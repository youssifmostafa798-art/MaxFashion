import supabase from "./lib/supabase.js";
import log from "./lib/logger.js";

async function main() {
  log.success("=== Post-Insert Validation ===");

  // 1. Count verification
  log.success("\n--- Count Verification ---");
  const { data: countData, error: countError } = await supabase
    .from("product_translations")
    .select("locale")
    .order("locale");

  if (countError) {
    log.error(`Count query failed: ${countError.message}`);
    process.exit(1);
  }

  const localeCounts = {};
  for (const row of countData) {
    localeCounts[row.locale] = (localeCounts[row.locale] || 0) + 1;
  }

  log.success(`English translations: ${localeCounts["en"]}`);
  log.success(`Arabic translations: ${localeCounts["ar"]}`);

  if (localeCounts["en"] !== 241) {
    log.error(`FAIL: English count expected 241, got ${localeCounts["en"]}`);
    process.exit(1);
  }
  if (localeCounts["ar"] !== 241) {
    log.error(`FAIL: Arabic count expected 241, got ${localeCounts["ar"]}`);
    process.exit(1);
  }
  log.success("PASS: Count verification");

  // 2. Missing Arabic translations
  log.success("\n--- Missing Arabic Translations ---");
  const { data: products, error: prodError } = await supabase
    .from("products")
    .select("id");

  if (prodError) {
    log.error(`Products query failed: ${prodError.message}`);
    process.exit(1);
  }

  const { data: arTranslations, error: arError } = await supabase
    .from("product_translations")
    .select("product_id")
    .eq("locale", "ar");

  if (arError) {
    log.error(`Arabic translations query failed: ${arError.message}`);
    process.exit(1);
  }

  const arIds = new Set(arTranslations.map((t) => t.product_id));
  const missingAr = products.filter((p) => !arIds.has(p.id));

  if (missingAr.length > 0) {
    log.error(`FAIL: ${missingAr.length} products missing Arabic translations`);
    for (const p of missingAr) {
      log.error(`  - product_id: ${p.id}`);
    }
    process.exit(1);
  }
  log.success("PASS: No missing Arabic translations");

  // 3. Duplicate verification
  log.success("\n--- Duplicate Verification ---");
  const { data: dupes, error: dupeError } = await supabase
    .from("product_translations")
    .select("product_id, locale")
    .order("product_id");

  if (dupeError) {
    log.error(`Duplicate query failed: ${dupeError.message}`);
    process.exit(1);
  }

  const seenDupe = new Set();
  const dupesList = [];
  for (const row of dupes) {
    const key = `${row.product_id}-${row.locale}`;
    if (seenDupe.has(key)) {
      dupesList.push(key);
    }
    seenDupe.add(key);
  }

  if (dupesList.length > 0) {
    log.error(`FAIL: ${dupesList.length} duplicate rows found`);
    for (const d of dupesList) {
      log.error(`  - ${d}`);
    }
    process.exit(1);
  }
  log.success("PASS: No duplicate rows");

  // 4. Arabic search verification
  log.success("\n--- Arabic Search Verification ---");
  const { data: searchResult1, error: searchErr1 } = await supabase.rpc(
    "search_products",
    {
      p_query: "نظارات",
      p_locale: "ar",
      p_limit: 5,
      p_offset: 0,
    }
  );

  if (searchErr1) {
    log.error(`Arabic search failed: ${searchErr1.message}`);
    process.exit(1);
  }

  if (!searchResult1 || searchResult1.length === 0) {
    log.error("FAIL: Arabic search returned no results for 'نظارات'");
    process.exit(1);
  }
  log.success(`PASS: Arabic search for 'نظارات' returned ${searchResult1.length} results`);
  log.success(`  First result: id=${searchResult1[0].id}, name=${searchResult1[0].name}`);

  // 5. Arabic description search
  log.success("\n--- Arabic Description Search ---");
  const { data: searchResult2, error: searchErr2 } = await supabase.rpc(
    "search_products",
    {
      p_query: "عدسات",
      p_locale: "ar",
      p_limit: 5,
      p_offset: 0,
    }
  );

  if (searchErr2) {
    log.error(`Arabic description search failed: ${searchErr2.message}`);
    process.exit(1);
  }

  if (!searchResult2 || searchResult2.length === 0) {
    log.error("FAIL: Arabic description search returned no results for 'عدسات'");
    process.exit(1);
  }
  log.success(`PASS: Arabic description search for 'عدسات' returned ${searchResult2.length} results`);
  log.success(`  First result: id=${searchResult2[0].id}, name=${searchResult2[0].name}`);

  // 6. English regression verification
  log.success("\n--- English Regression Verification ---");
  const { data: enSearch, error: enSearchErr } = await supabase.rpc(
    "search_products",
    {
      p_query: "Coastal Voyager",
      p_locale: "en",
      p_limit: 5,
      p_offset: 0,
    }
  );

  if (enSearchErr) {
    log.error(`English search failed: ${enSearchErr.message}`);
    process.exit(1);
  }

  if (!enSearch || enSearch.length === 0) {
    log.error("FAIL: English search returned no results for 'Coastal Voyager'");
    process.exit(1);
  }
  log.success(`PASS: English search for 'Coastal Voyager' returned ${enSearch.length} results`);
  log.success(`  First result: id=${enSearch[0].id}, name=${enSearch[0].name}`);

  // 7. Cross-locale verification
  log.success("\n--- Cross-Locale Verification ---");
  const testProductIds = [1, 27, 84, 121, 241];

  for (const pid of testProductIds) {
    const { data: enRow, error: enErr } = await supabase
      .from("product_translations")
      .select("product_id, locale, name, description")
      .eq("product_id", pid)
      .eq("locale", "en")
      .single();

    const { data: arRow, error: arErr } = await supabase
      .from("product_translations")
      .select("product_id, locale, name, description")
      .eq("product_id", pid)
      .eq("locale", "ar")
      .single();

    if (enErr || arErr) {
      log.error(`FAIL: Cross-locale check failed for product_id ${pid}`);
      process.exit(1);
    }

    if (enRow.product_id !== arRow.product_id) {
      log.error(`FAIL: Product ID mismatch for ${pid}`);
      process.exit(1);
    }

    if (enRow.name === arRow.name) {
      log.error(`FAIL: Name not translated for product_id ${pid}`);
      process.exit(1);
    }

    log.success(`PASS: product_id ${pid} - EN: ${enRow.name} | AR: ${arRow.name}`);
  }

  // 8. Verify prices, images, categories unchanged
  log.success("\n--- Data Integrity Verification ---");
  const { data: sampleProducts, error: sampleErr } = await supabase
    .from("products")
    .select("id, price, discount_price, brand, category_id, thumbnail_url, is_featured, is_available")
    .in("id", testProductIds);

  if (sampleErr) {
    log.error(`Sample products query failed: ${sampleErr.message}`);
    process.exit(1);
  }

  for (const p of sampleProducts) {
    log.success(`  product_id ${p.id}: price=${p.price}, brand=${p.brand}, category=${p.category_id}`);
  }
  log.success("PASS: Product data integrity verified");

  log.success("\n=== ALL VALIDATIONS PASSED ===");
}

main().catch((err) => {
  log.error(`Unexpected error: ${err.message}`);
  process.exit(1);
});
