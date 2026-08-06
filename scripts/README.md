# MaxFashion JSON Seeder

Production-quality Node.js scripts to import JSON data into Supabase.

## Prerequisites

- Node.js 18+
- npm
- Supabase project with tables created

## Installation

```bash
cd scripts
npm install
```

## Environment Variables

Create a `.env` file in the `scripts/` directory:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## Usage

### Import all tables

```bash
node scripts/import_all.js
```

### Import individual tables

```bash
node scripts/import_categories.js
node scripts/import_products.js
node scripts/import_product_images.js
node scripts/import_product_sizes.js
```

## Import Order

Tables are imported in this order to respect foreign key dependencies:

1. `categories`
2. `products`
3. `product_images`
4. `product_sizes`

## Project Structure

```
scripts/
├── package.json
├── README.md
├── import_categories.js
├── import_products.js
├── import_product_images.js
├── import_product_sizes.js
├── import_all.js
└── lib/
    ├── supabase.js        # Reusable Supabase client
    ├── logger.js           # Consistent console logging
    ├── json-reader.js      # JSON file reader
    ├── validator.js        # Data validation
    └── batch-inserter.js   # Batch insert with progress
```

## Features

- Batch inserts (100 records per batch)
- Data validation (required fields, duplicate IDs, foreign keys)
- Progress logging
- Error handling with batch details
- Proper exit codes

## Troubleshooting

### "Missing SUPABASE_URL or SUPABASE_ANON_KEY"

Ensure your `.env` file exists in `scripts/` with both variables set.

### "Duplicate primary key"

Data contains duplicate IDs. Check the JSON file and remove duplicates.

### "Foreign key violation"

A `product_images` or `product_sizes` row references a `product_id` that does not exist in the `products` table. Import products first.

### Batch fails mid-import

The script stops immediately on failure. Fix the issue and re-run. Already-inserted rows will cause duplicate key errors on re-run; clear the table first if needed.

## JSON File Locations

```
assets/data/
├── categories.json
├── products.json
├── product_images.json
└── product_sizes.json
```
