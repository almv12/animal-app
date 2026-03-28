// Устаревший файл — используй api.js
// ZooJoy — Supabase API client
// Замени YOUR_SUPABASE_URL и YOUR_SUPABASE_ANON_KEY на свои данные

const SUPABASE_URL = 'https://taxxncqrjdzojmgdtujl.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRheHhuY3FyamR6b2ptZ2R0dWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ1OTU3MDQsImV4cCI6MjA5MDE3MTcwNH0.lbL4TZZ39_KPKSb011rcmyhlORqnotWw3ae9CSz95Vc';

async function sbFetch(table, params = '') {
  const url = `${SUPABASE_URL}/rest/v1/${table}?${params}`;
  const resp = await fetch(url, {
    headers: {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
    }
  });
  if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
  return resp.json();
}
