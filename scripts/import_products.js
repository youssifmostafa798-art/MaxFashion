import { readJSON } from "./lib/json-reader.js";
import {
  validateArray,
  validateRequiredFields,
  validateNoDuplicateIds,
} from "./lib/validator.js";
import { batchInsert } from "./lib/batch-inserter.js";
import log from "./lib/logger.js";

const REQUIRED_FIELDS = [
  "id",
  "category_id",
  "name",
  "description",
  "price",
  "brand",
  "thumbnail_url",
];

async function main() {
  log.success("=== Importing Products ===");

  const data = await readJSON("products.json");

  if (!validateArray(data, "products.json")) process.exit(1);
  if (!validateRequiredFields(data, REQUIRED_FIELDS, "products.json"))
    process.exit(1);
  if (!validateNoDuplicateIds(data, "id", "products.json")) process.exit(1);

  await batchInsert("products", data);
}

main().catch((err) => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});
