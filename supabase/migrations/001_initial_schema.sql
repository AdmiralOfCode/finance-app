-- ============================================================
-- Finance App — Initial Schema
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- ── Extensions ──────────────────────────────────────────────
create extension if not exists "uuid-ossp";

-- ── profiles ────────────────────────────────────────────────
-- Automatically populated by the trigger below on signup.
create table public.profiles (
  id          uuid references auth.users(id) on delete cascade primary key,
  full_name   text,
  avatar_url  text,
  currency    text not null default 'USD',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ── categories ──────────────────────────────────────────────
create table public.categories (
  id          uuid default uuid_generate_v4() primary key,
  user_id     uuid references auth.users(id) on delete cascade not null,
  name        text not null,
  icon        text not null default 'category',
  color       text not null default '#2DD4BF',
  type        text not null check (type in ('income', 'expense', 'both')),
  is_default  boolean not null default false,
  created_at  timestamptz not null default now()
);

-- ── transactions ─────────────────────────────────────────────
create table public.transactions (
  id           uuid default uuid_generate_v4() primary key,
  user_id      uuid references auth.users(id) on delete cascade not null,
  category_id  uuid references public.categories(id) on delete set null,
  amount       numeric(12, 2) not null check (amount > 0),
  type         text not null check (type in ('income', 'expense')),
  description  text,
  date         date not null default current_date,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ── budgets ──────────────────────────────────────────────────
create table public.budgets (
  id           uuid default uuid_generate_v4() primary key,
  user_id      uuid references auth.users(id) on delete cascade not null,
  category_id  uuid references public.categories(id) on delete cascade not null,
  amount       numeric(12, 2) not null check (amount > 0),
  period       text not null check (period in ('monthly', 'yearly')),
  created_at   timestamptz not null default now(),
  unique (user_id, category_id, period)
);

-- ── Row Level Security ───────────────────────────────────────
alter table public.profiles     enable row level security;
alter table public.categories   enable row level security;
alter table public.transactions enable row level security;
alter table public.budgets      enable row level security;

-- profiles
create policy "Own profile: select"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Own profile: update"
  on public.profiles for update
  using (auth.uid() = id);

-- categories
create policy "Own categories: all"
  on public.categories for all
  using (auth.uid() = user_id);

-- transactions
create policy "Own transactions: all"
  on public.transactions for all
  using (auth.uid() = user_id);

-- budgets
create policy "Own budgets: all"
  on public.budgets for all
  using (auth.uid() = user_id);

-- ── Auto-create profile on signup ────────────────────────────
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data ->> 'full_name',
    new.raw_user_meta_data ->> 'avatar_url'
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── Seed default categories for new users ────────────────────
create or replace function public.create_default_categories(p_user_id uuid)
returns void language plpgsql security definer as $$
begin
  insert into public.categories (user_id, name, icon, color, type, is_default) values
    (p_user_id, 'Salary',        'work',           '#2DD4BF', 'income',  true),
    (p_user_id, 'Freelance',     'laptop',         '#10B981', 'income',  true),
    (p_user_id, 'Food',          'restaurant',     '#F87171', 'expense', true),
    (p_user_id, 'Transport',     'directions_car', '#FBBF24', 'expense', true),
    (p_user_id, 'Housing',       'home',           '#818CF8', 'expense', true),
    (p_user_id, 'Healthcare',    'local_hospital', '#FB7185', 'expense', true),
    (p_user_id, 'Entertainment', 'movie',          '#60A5FA', 'expense', true),
    (p_user_id, 'Shopping',      'shopping_cart',  '#F472B6', 'expense', true);
end;
$$;

-- ── Call default categories after profile creation ───────────
create or replace function public.handle_new_user_categories()
returns trigger language plpgsql security definer as $$
begin
  perform public.create_default_categories(new.id);
  return new;
end;
$$;

create trigger on_profile_created_seed_categories
  after insert on public.profiles
  for each row execute procedure public.handle_new_user_categories();

-- ── Useful view: monthly summary per user ────────────────────
create or replace view public.monthly_summary as
select
  user_id,
  date_trunc('month', date)    as month,
  type,
  sum(amount)                  as total
from public.transactions
group by user_id, date_trunc('month', date), type;
