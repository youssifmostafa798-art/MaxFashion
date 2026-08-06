import log from "./lib/logger.js";

const importers = [
  { name: "categories", script: "./import_categories.js" },
  { name: "products", script: "./import_products.js" },
  { name: "product_images", script: "./import_product_images.js" },
  { name: "product_sizes", script: "./import_product_sizes.js" },
];

async function runImporter(importer) {
  log.success(`--- Importing ${importer.name} ---`);
  const mod = await import(importer.script);
}

async function main() {
  const startTime = Date.now();
  log.success("=== Starting Full Import ===");
  log.success("Order: categories -> products -> product_images -> product_sizes");

  for (const importer of importers) {
    await runImporter(importer);
  }

  const elapsed = ((Date.now() - startTime) / 1000).toFixed(2);
  log.success(`=== All imports completed in ${elapsed}s ===`);
}

main().catch((err) => {
  log.error(`Fatal error: ${err.message}`);
  process.exit(1);
});
