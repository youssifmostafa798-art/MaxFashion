import { createClient } from "@supabase/supabase-js";
import { config } from "dotenv";
import { readFileSync } from "fs";
config();

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function migrateDatabase() {
  console.log("========================================");
  console.log("PHASE B: DATABASE MIGRATION");
  console.log("========================================\n");

  // 1. Read product_images.json
  let rawJson = readFileSync("../assets/data/product_images.json", "utf-8");
  if (rawJson.charCodeAt(0) === 0xFEFF) rawJson = rawJson.slice(1);
  const imageData = JSON.parse(rawJson);

  console.log(`Total records to migrate: ${imageData.length}\n`);

  // 2. Verify current state - read existing rows
  const { data: existingRows, error: fetchError } = await supabase
    .from("product_images")
    .select("id, product_id, image_url, sort_order")
    .order("id");

  if (fetchError) {
    console.error("ERROR fetching product_images:", fetchError.message);
    process.exit(1);
  }

  console.log(`Current rows in database: ${existingRows.length}`);

  // Verify all rows have legacy paths
  const legacyRows = existingRows.filter(r => r.image_url.startsWith("assets/products_supa/"));
  console.log(`Rows with legacy paths: ${legacyRows.length}`);

  if (legacyRows.length !== imageData.length) {
    console.error("ERROR: Row count mismatch");
    process.exit(1);
  }

  // 3. Update each row
  console.log("\nStarting migration...\n");

  let successCount = 0;
  let failCount = 0;
  const failures = [];

  for (const record of imageData) {
    const storagePath = record.image_url.replace(/^assets\/products_supa\//, "");

    const { data, error } = await supabase
      .from("product_images")
      .update({ image_url: storagePath })
      .eq("id", record.id)
      .select();

    if (error) {
      failCount++;
      failures.push({ id: record.id, error: error.message });
      console.error(`FAILED: id=${record.id} - ${error.message}`);
    } else if (data && data.length > 0) {
      successCount++;
      if (successCount % 50 === 0 || successCount === imageData.length) {
        console.log(`[${successCount}/${imageData.length}] Updated: id=${record.id}`);
      }
    } else {
      failCount++;
      failures.push({ id: record.id, error: "No rows updated" });
      console.error(`FAILED: id=${record.id} - No rows updated`);
    }
  }

  // 4. Summary
  console.log("\n========================================");
  console.log("MIGRATION SUMMARY");
  console.log("========================================");
  console.log(`Total records: ${imageData.length}`);
  console.log(`Successful: ${successCount}`);
  console.log(`Failed: ${failCount}`);

  if (failures.length > 0) {
    console.log("\nFAILURES:");
    failures.forEach(f => console.log(`  id=${f.id}: ${f.error}`));
  }

  console.log("\n========================================");
  if (failCount === 0) {
    console.log("MIGRATION COMPLETE - ALL ROWS UPDATED");
  } else {
    console.log(`MIGRATION INCOMPLETE - ${failCount} FAILURES`);
  }
  console.log("========================================");
}

migrateDatabase().catch(err => {
  console.error("FATAL ERROR:", err);
  process.exit(1);
});
