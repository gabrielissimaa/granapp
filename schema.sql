-- Rode este script no Supabase: Project > SQL Editor > New query > cole e clique em "Run"

create table if not exists public.app_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_data enable row level security;

-- Cada pessoa só pode ler e escrever a própria linha (identificada pelo login)
create policy "select own data" on public.app_data
  for select using (auth.uid() = user_id);

create policy "insert own data" on public.app_data
  for insert with check (auth.uid() = user_id);

create policy "update own data" on public.app_data
  for update using (auth.uid() = user_id);
