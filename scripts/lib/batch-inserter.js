import supabase from "./supabase.js";
import log from "./logger.js";

const BATCH_SIZE = 100;

export async function batchInsert(tableName, data) {
  log.success(`Validating...`);

  const total = data.length;
  const batches = [];
  for (let i = 0; i < total; i += BATCH_SIZE) {
    batches.push(data.slice(i, i + BATCH_SIZE));
  }

  let insertedCount = 0;

  for (let i = 0; i < batches.length; i++) {
    const batch = batches[i];
    const batchNum = i + 1;
    const totalBatches = batches.length;

    log.success(
      `Uploading batch ${batchNum}/${totalBatches} (${batch.length} records)...`
    );

    const { data: inserted, error } = await supabase
      .from(tableName)
      .insert(batch)
      .select();

    if (error) {
      log.error(`Batch ${batchNum} failed:`);
      log.error(`  Supabase error: ${error.message}`);
      if (error.details) log.error(`  Details: ${error.details}`);
      if (error.hint) log.error(`  Hint: ${error.hint}`);
      log.error(`  Failing rows: ${JSON.stringify(batch.slice(0, 5), null, 2)}`);
      process.exit(1);
    }

    insertedCount += inserted ? inserted.length : batch.length;
  }

  log.success(`Import completed successfully: ${insertedCount} rows inserted into ${tableName}`);
  return insertedCount;
}
