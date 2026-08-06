import { readFile } from "fs/promises";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";
import log from "./logger.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const DATA_DIR = resolve(__dirname, "../../assets/data");

export async function readJSON(filename) {
  log.success(`Reading ${filename}...`);
  const filePath = resolve(DATA_DIR, filename);
  const raw = await readFile(filePath, "utf-8");
  const data = JSON.parse(raw);
  log.success(`${data.length} records found in ${filename}`);
  return data;
}
