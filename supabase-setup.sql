-- Clinic Token System — Supabase setup (run ONCE in the SQL Editor)
-- Creates the single table the app uses for live cross-device sync:
-- one row per clinic (clinic_code -> the whole queue state as JSON).
-- Safe to re-run: it only creates what is missing and re-sets the policies.

create table if not exists public.clinic_state (
  clinic_code text primary key,
  state       jsonb not null,
  updated_at  timestamptz not null default now()
);

alter table public.clinic_state enable row level security;

-- Demo-grade policies: the app's anon key may read/write rows.
-- (The sellable version will add per-clinic logins on top of this.)
drop policy if exists "clinic_state anon read"   on public.clinic_state;
drop policy if exists "clinic_state anon insert" on public.clinic_state;
drop policy if exists "clinic_state anon update" on public.clinic_state;

create policy "clinic_state anon read"
  on public.clinic_state for select
  using (true);

create policy "clinic_state anon insert"
  on public.clinic_state for insert
  with check (true);

create policy "clinic_state anon update"
  on public.clinic_state for update
  using (true)
  with check (true);
