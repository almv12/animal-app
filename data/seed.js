#!/usr/bin/env node
/**
 * ZooJoy Supabase Seed Script
 * 
 * СПОСОБ 1 (рекомендуется):
 *   1. Открой: https://supabase.com/dashboard/project/yhfacbsiitblfqchmekv/sql/new
 *   2. Вставь содержимое data/schema.sql и нажми Run
 *   3. Запусти: node data/seed.js
 * 
 * СПОСОБ 2 (автоматически, нужен PAT):
 *   SUPABASE_PAT=sbp_xxxx node data/seed.js --create-tables
 * 
 * В обоих случаях данные зальются через REST API с service_role key.
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

const SUPABASE_URL = 'https://yhfacbsiitblfqchmekv.supabase.co';
const PROJECT_REF = 'yhfacbsiitblfqchmekv';
const SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InloZmFjYnNpaXRibGZxY2htZWt2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDY5NzI1NywiZXhwIjoyMDkwMjczMjU3fQ.WNIYKfJQEro-kH1jUEnzTI7uNmq4jhEdwPKE2EBvu3A';
const PAT = process.env.SUPABASE_PAT; // sbp_xxxx

const CREATE_TABLES = process.argv.includes('--create-tables');

// ── HTTP helpers ────────────────────────────────────────────────────────────

function request(opts, body) {
  return new Promise((resolve, reject) => {
    const data = body ? JSON.stringify(body) : '';
    const headers = { 'Content-Type': 'application/json', ...opts.headers };
    if (data) headers['Content-Length'] = Buffer.byteLength(data);

    const req = https.request({ ...opts, headers }, res => {
      let b = '';
      res.on('data', c => b += c);
      res.on('end', () => resolve({ status: res.statusCode, body: b }));
    });
    req.on('error', reject);
    if (data) req.write(data);
    req.end();
  });
}

async function runSQL(sql) {
  // Requires PAT (Personal Access Token from supabase.com account)
  if (!PAT) throw new Error('SUPABASE_PAT env var required for DDL. Get it from: https://supabase.com/dashboard/account/tokens');
  const { status, body } = await request({
    hostname: 'api.supabase.com',
    path: `/v1/projects/${PROJECT_REF}/database/query`,
    method: 'POST',
    headers: { 'Authorization': `Bearer ${PAT}` }
  }, { query: sql });
  if (status >= 200 && status < 300) return JSON.parse(body);
  throw new Error(`SQL failed (${status}): ${body}`);
}

async function upsert(table, records) {
  const { status, body } = await request({
    hostname: new URL(SUPABASE_URL).hostname,
    path: `/rest/v1/${table}`,
    method: 'POST',
    headers: {
      'apikey': SERVICE_KEY,
      'Authorization': `Bearer ${SERVICE_KEY}`,
      'Prefer': 'resolution=merge-duplicates,return=minimal',
    }
  }, records);
  if (status >= 200 && status < 300) return records.length;
  const err = JSON.parse(body);
  if (err.code === 'PGRST205') {
    throw new Error(`Table '${table}' not found. Run schema.sql first: https://supabase.com/dashboard/project/${PROJECT_REF}/sql/new`);
  }
  throw new Error(`Upsert '${table}' failed (${status}): ${body}`);
}

// ── Schema ───────────────────────────────────────────────────────────────────

async function createTables() {
  console.log('🏗  Creating tables via Management API...');
  const schema = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');
  // Split on -- SEED: to only run DDL part
  const ddl = schema.split('-- ================================================================\n-- SEED:')[0];
  // Run as a single query
  await runSQL(ddl);
  console.log('✅ Tables created');
}

// ── Data ─────────────────────────────────────────────────────────────────────

function flattenCoords(r) {
  const o = { ...r };
  if (o.coordinates) { o.lat = o.coordinates.lat; o.lng = o.coordinates.lng; delete o.coordinates; }
  return o;
}

async function seedTable(tableName, file) {
  const data = JSON.parse(fs.readFileSync(path.join(__dirname, file))).map(flattenCoords);
  process.stdout.write(`📥 ${tableName} (${data.length} records)... `);
  const n = await upsert(tableName, data);
  console.log(`✅ ${n} upserted`);
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  console.log('🚀 ZooJoy Supabase Seed');
  console.log('URL:', SUPABASE_URL);
  console.log('');

  if (CREATE_TABLES) {
    await createTables();
    console.log('');
  }

  try {
    await seedTable('vets', 'vets.json');
    await seedTable('places', 'places.json');
    await seedTable('organizations', 'organizations.json');
    await seedTable('shelters', 'shelters.json');
    console.log('\n✨ All done! ZooJoy data is live in Supabase.');
  } catch (e) {
    console.error('\n❌', e.message);
    if (e.message.includes('not found')) {
      console.error('\n💡 Quick fix:');
      console.error(`   1. Open: https://supabase.com/dashboard/project/${PROJECT_REF}/sql/new`);
      console.error('   2. Paste contents of data/schema.sql');
      console.error('   3. Click Run');
      console.error('   4. Then run: node data/seed.js');
    }
    process.exit(1);
  }
}

main();
