import { readJSON } from "./lib/json-reader.js";
import { validateArray, validateRequiredFields, validateNoDuplicateIds } from "./lib/validator.js";
import { batchInsert } from "./lib/batch-inserter.js";
import log from "./lib/logger.js";

const REQUIRED_FIELDS = ["id", "name", "slug", "image_url"];

async function main() {
  log.success("=== Importing Categories ===");

  const data = await readJSON("categories.json");

  if (!validateArray(data, "categories.json")) process.exit(1);
  if (!validateRequiredFields(data, REQUIRED_FIELDS, "categories.json"))
    process.exit(1);
  if (!validateNoDuplicateIds(data, "id", "categories.json")) process.exit(1);

  await batchInsert("categories", data);
}

main().catch((err) => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});
