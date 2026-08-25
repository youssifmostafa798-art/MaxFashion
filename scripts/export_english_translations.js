import supabase from "./lib/supabase.js";
import { writeFileSync } from "fs";
import log from "./lib/logger.js";

async function main() {
  log.success("=== Exporting English Product Translations ===");

  const { data, error } = await supabase
    .from("product_translations")
    .select("product_id, locale, name, description")
    .eq("locale", "en")
    .order("product_id", { ascending: true });

  if (error) {
    log.error(`Export failed: ${error.message}`);
    process.exit(1);
  }

  log.success(`Exported ${data.length} English translations`);

  writeFileSync(
    "./data/english_translations.json",
    JSON.stringify(data, null, 2),
    "utf-8"
  );

  log.success("Saved to ./data/english_translations.json");
}

main().catch((err) => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});
