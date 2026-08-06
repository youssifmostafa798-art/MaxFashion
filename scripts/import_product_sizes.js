import { readJSON } from "./lib/json-reader.js";
import { validateArray, validateRequiredFields } from "./lib/validator.js";
import { batchInsert } from "./lib/batch-inserter.js";
import log from "./lib/logger.js";

const REQUIRED_FIELDS = ["product_id", "size", "stock"];

async function main() {
  log.success("=== Importing Product Sizes ===");

  const data = await readJSON("product_sizes.json");

  if (!validateArray(data, "product_sizes.json")) process.exit(1);
  if (!validateRequiredFields(data, REQUIRED_FIELDS, "product_sizes.json"))
    process.exit(1);

  await batchInsert("product_sizes", data, "product_id,size");
}

main().catch((err) => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});