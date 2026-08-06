const success = (msg) => console.log(`✔ ${msg}`);
const error = (msg) => console.error(`✖ ${msg}`);
const info = (msg) => console.log(`ℹ ${msg}`);
const warn = (msg) => console.warn(`⚠ ${msg}`);

export default { success, error, info, warn };
