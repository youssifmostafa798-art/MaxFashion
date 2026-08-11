import { createClient } from "@supabase/supabase-js";
import { config } from "dotenv";
import { readFileSync, existsSync } from "fs";
import { resolve, relative } from "path";

config();

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

const BUCKET = "product-images";
const ASSETS_ROOT = resolve(import.meta.dirname, "..", "assets", "products_supa");
const IMAGES_JSON = resolve(import.meta.dirname, "..", "assets", "data", "product_images.json");

function getContentType(filePath) {
  const ext = filePath.split(".").pop().toLowerCase();
  const types = {
    jpg: "image/jpeg",
    jpeg: "image/jpeg",
    png: "image/png",
    webp: "image/webp",
  };
  return types[ext] || "application/octet-stream";
}

async function main() {
  console.log("========================================");
  console.log("PRODUCT IMAGES UPLOAD SCRIPT");
  console.log("========================================");
  console.log(`Bucket: ${BUCKET}`);
  console.log(`Assets root: ${ASSETS_ROOT}`);
  console.log(`Images JSON: ${IMAGES_JSON}`);

  // Read product_images.json (strip BOM if present)
  let rawJson = readFileSync(IMAGES_JSON, "utf-8");
  if (rawJson.charCodeAt(0) === 0xFEFF) {
    rawJson = rawJson.slice(1);
  }
  const imageData = JSON.parse(rawJson);
  console.log(`\nTotal records in product_images.json: ${imageData.length}`);

  // Check bucket is empty
  const { data: existing, error: listError } = await supabase.storage
    .from(BUCKET)
    .list("", { limit: 1000 });

  if (listError) {
    console.error("ERROR: Failed to list bucket:", listError.message);
    process.exit(1);
  }

  if (existing && existing.length > 0) {
    console.error(`ERROR: Bucket is not empty (${existing.length} objects). Aborting.`);
    process.exit(1);
  }

  console.log("Bucket verified empty. Starting upload...\n");

  const results = {
    success: [],
    failed: [],
    skipped: [],
  };

  let processed = 0;
  const total = imageData.length;

  for (const record of imageData) {
    processed++;
    const localAssetPath = record.image_url;

    // Strip "assets/products_supa/" prefix to get storage path
    const storagePath = localAssetPath.replace(/^assets\/products_supa\//, "");

    // Build full local path
    const localPath = resolve(import.meta.dirname, "..", localAssetPath);

    // Check file exists
    if (!existsSync(localPath)) {
      console.error(`[${processed}/${total}] MISSING: ${storagePath}`);
      results.failed.push({ storagePath, error: "File not found" });
      continue;
    }

    // Read file
    const fileBuffer = readFileSync(localPath);

    // Check file size (5MB limit)
    if (fileBuffer.length > 5 * 1024 * 1024) {
      console.error(`[${processed}/${total}] OVERSIZED: ${storagePath} (${(fileBuffer.length / 1024 / 1024).toFixed(2)} MB)`);
      results.failed.push({ storagePath, error: "File exceeds 5MB limit" });
      continue;
    }

    // Upload
    try {
      const { data, error } = await supabase.storage
        .from(BUCKET)
        .upload(storagePath, fileBuffer, {
          contentType: getContentType(localPath),
          upsert: false,
        });

      if (error) {
        console.error(`[${processed}/${total}] FAILED: ${storagePath} - ${error.message}`);
        results.failed.push({ storagePath, error: error.message });
      } else {
        results.success.push(storagePath);
        if (processed % 50 === 0 || processed === total) {
          console.log(`[${processed}/${total}] Uploaded: ${storagePath}`);
        }
      }
    } catch (err) {
      console.error(`[${processed}/${total}] ERROR: ${storagePath} - ${err.message}`);
      results.failed.push({ storagePath, error: err.message });
    }
  }

  // Summary
  console.log("\n========================================");
  console.log("UPLOAD SUMMARY");
  console.log("========================================");
  console.log(`Total records: ${total}`);
  console.log(`Successful: ${results.success.length}`);
  console.log(`Failed: ${results.failed.length}`);
  console.log(`Skipped: ${results.skipped.length}`);

  if (results.failed.length > 0) {
    console.log("\nFAILED UPLOADS:");
    results.failed.forEach((f) => {
      console.log(`  ${f.storagePath}: ${f.error}`);
    });
  }

  console.log("\n========================================");
  if (results.failed.length === 0) {
    console.log("ALL 247 IMAGES UPLOADED SUCCESSFULLY");
  } else {
    console.log(`UPLOAD INCOMPLETE: ${results.failed.length} failures`);
  }
  console.log("========================================");
}

main().catch((err) => {
  console.error("FATAL ERROR:", err);
  process.exit(1);
});
