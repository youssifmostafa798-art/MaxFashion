import { readJSON } from "./lib/json-reader.js";
import {
  validateArray,
  validateRequiredFields,
  validateNoDuplicateIds,
} from "./lib/validator.js";
import { batchInsert } from "./lib/batch-inserter.js";
import log from "./lib/logger.js";

const REQUIRED_FIELDS = ["id", "product_id", "image_url", "sort_order"];

async function main() {
  log.success("=== Importing Product Images ===");

  const data = await readJSON("product_images.json");

  if (!validateArray(data, "product_images.json")) process.exit(1);
  if (!validateRequiredFields(data, REQUIRED_FIELDS, "product_images.json"))
    process.exit(1);
  if (!validateNoDuplicateIds(data, "id", "product_images.json"))
    process.exit(1);

  await batchInsert("product_images", data);
}

main().catch((err) => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});
