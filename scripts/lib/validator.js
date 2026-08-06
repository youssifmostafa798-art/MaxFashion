import log from "./logger.js";

export function validateArray(data, filename) {
  if (!Array.isArray(data)) {
    log.error(`${filename} must be a JSON array`);
    return false;
  }
  if (data.length === 0) {
    log.warn(`${filename} is empty, nothing to import`);
    return false;
  }
  return true;
}

export function validateRequiredFields(data, requiredFields, filename) {
  const errors = [];
  data.forEach((row, index) => {
    for (const field of requiredFields) {
      if (row[field] === undefined || row[field] === null) {
        errors.push(`Row ${index + 1}: missing required field "${field}"`);
      }
    }
  });
  if (errors.length > 0) {
    log.error(`Validation failed for ${filename}:`);
    errors.forEach((e) => log.error(`  ${e}`));
    return false;
  }
  return true;
}

export function validateNoDuplicateIds(data, idField, filename) {
  const seen = new Set();
  const duplicates = [];
  data.forEach((row, index) => {
    const id = row[idField];
    if (id !== undefined) {
      if (seen.has(id)) {
        duplicates.push({ index: index + 1, id });
      }
      seen.add(id);
    }
  });
  if (duplicates.length > 0) {
    log.error(`Duplicate IDs in ${filename}:`);
    duplicates.forEach((d) =>
      log.error(`  Row ${d.index}: ${idField}=${d.id}`)
    );
    return false;
  }
  return true;
}

export function validateForeignKeys(data, fkField, targetIds, filename) {
  const errors = [];
  data.forEach((row, index) => {
    if (row[fkField] !== undefined && !targetIds.has(row[fkField])) {
      errors.push(
        `Row ${index + 1}: ${fkField}=${row[fkField]} not found in target`
      );
    }
  });
  if (errors.length > 0) {
    log.error(`Foreign key validation failed for ${filename}:`);
    errors.forEach((e) => log.error(`  ${e}`));
    return false;
  }
  return true;
}
