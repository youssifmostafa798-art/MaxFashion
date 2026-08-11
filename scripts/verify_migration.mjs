import { createClient } from "@supabase/supabase-js";
import { config } from "dotenv";
import { readFileSync } from "fs";
config();

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function postMigrationVerification() {
  console.log("========================================");
  console.log("POST-MIGRATION VERIFICATION");
  console.log("========================================\n");

  // 1. Read all product_images rows
  const { data: rows, error: fetchError } = await supabase
    .from("product_images")
    .select("id, product_id, image_url, sort_order")
    .order("id");

  if (fetchError) {
    console.error("ERROR fetching product_images:", fetchError.message);
    process.exit(1);
  }

  console.log(`1. Total rows: ${rows.length}`);

  // 2. Legacy path check
  const legacyRows = rows.filter(r => r.image_url.startsWith("assets/products_supa/"));
  console.log(`2. Legacy paths remaining: ${legacyRows.length}`);
  if (legacyRows.length > 0) {
    console.log("   LEGACY PATHS FOUND:");
    legacyRows.forEach(r => console.log(`     id=${r.id}: ${r.image_url}`));
  }

  // 3. Storage path coverage
  async function listAll(prefix) {
    const { data, error } = await supabase.storage
      .from("product-images")
      .list(prefix, { limit: 1000 });
    if (error) return [];
    let results = [];
    for (const item of data) {
      if (item.id === null) {
        const subItems = await listAll(`${prefix}/${item.name}`);
        results = results.concat(subItems);
      } else {
        results.push(`${prefix}/${item.name}`);
      }
    }
    return results;
  }

  const storagePaths = [...await listAll("men"), ...await listAll("women")];
  const dbPaths = rows.map(r => r.image_url);

  const missingInStorage = dbPaths.filter(p => !storagePaths.includes(p));
  const unexpectedInStorage = storagePaths.filter(p => !dbPaths.includes(p));

  console.log(`3. Storage path coverage: ${dbPaths.length - missingInStorage.length}/${dbPaths.length}`);
  console.log(`   Missing in Storage: ${missingInStorage.length}`);
  if (missingInStorage.length > 0) {
    missingInStorage.forEach(p => console.log(`     MISSING: ${p}`));
  }

  // 4. Duplicate check
  const pathCounts = {};
  dbPaths.forEach(p => { pathCounts[p] = (pathCounts[p] || 0) + 1; });
  const duplicates = Object.entries(pathCounts).filter(([_, count]) => count > 1);
  console.log(`4. Duplicate image_url: ${duplicates.length}`);
  if (duplicates.length > 0) {
    duplicates.forEach(([path, count]) => console.log(`     DUPLICATE: ${path} (${count}x)`));
  }

  // 5. Product mapping integrity
  const { data: products, error: prodError } = await supabase
    .from("products")
    .select("id");

  if (prodError) {
    console.error("ERROR fetching products:", prodError.message);
  } else {
    const productIds = products.map(p => p.id);
    const orphanedRows = rows.filter(r => !productIds.includes(r.product_id));
    console.log(`5. Product mapping integrity: ${orphanedRows.length} orphaned rows`);
    if (orphanedRows.length > 0) {
      orphanedRows.forEach(r => console.log(`     ORPHAN: id=${r.id} product_id=${r.product_id}`));
    }
  }

  // 6. Product IDs unchanged
  let originalRaw = readFileSync("../assets/data/product_images.json", "utf-8");
  if (originalRaw.charCodeAt(0) === 0xFEFF) originalRaw = originalRaw.slice(1);
  const originalData = JSON.parse(originalRaw);
  const originalProductIds = originalData.map(r => r.product_id);
  const currentProductIds = rows.map(r => r.product_id);
  const productIdMismatch = originalProductIds.filter((id, i) => currentProductIds[i] !== id);
  console.log(`6. Product IDs unchanged: ${productIdMismatch.length === 0 ? "YES" : "NO"}`);

  // 7. Sort order unchanged
  const originalSortOrders = originalData.map(r => r.sort_order);
  const currentSortOrders = rows.map(r => r.sort_order);
  const sortOrderMismatch = originalSortOrders.filter((so, i) => currentSortOrders[i] !== so);
  console.log(`7. Sort order unchanged: ${sortOrderMismatch.length === 0 ? "YES" : "NO"}`);

  // 8. Sample rows
  console.log("\n--- Sample rows (first 10) ---");
  console.log("id | product_id | image_url | sort_order");
  console.log("--- | --- | --- | ---");
  rows.slice(0, 10).forEach(r => {
    console.log(`${r.id} | ${r.product_id} | ${r.image_url} | ${r.sort_order}`);
  });

  console.log("\n--- Sample rows (last 5) ---");
  rows.slice(-5).forEach(r => {
    console.log(`${r.id} | ${r.product_id} | ${r.image_url} | ${r.sort_order}`);
  });

  // Summary
  console.log("\n========================================");
  console.log("VERIFICATION SUMMARY");
  console.log("========================================");
  console.log(`Total rows: ${rows.length}`);
  console.log(`Legacy paths: ${legacyRows.length}`);
  console.log(`Missing in Storage: ${missingInStorage.length}`);
  console.log(`Unexpected in Storage: ${unexpectedInStorage.length}`);
  console.log(`Duplicate URLs: ${duplicates.length}`);
  console.log(`Product IDs unchanged: ${productIdMismatch.length === 0 ? "YES" : "NO"}`);
  console.log(`Sort order unchanged: ${sortOrderMismatch.length === 0 ? "YES" : "NO"}`);

  if (legacyRows.length === 0 && missingInStorage.length === 0 && duplicates.length === 0) {
    console.log("\nALL CHECKS PASSED");
  } else {
    console.log("\nSOME CHECKS FAILED - SEE ABOVE");
  }
}

postMigrationVerification().catch(err => {
  console.error("FATAL ERROR:", err);
  process.exit(1);
});
