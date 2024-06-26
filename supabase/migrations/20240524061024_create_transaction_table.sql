create table if not exists public."Transaction" (
    id uuid not null default gen_random_uuid(),
    account_id uuid not null,
    category_id uuid not null,

    title text not null,
    description text null,

    value double precision not null default '0'::double precision,
    date timestamp with time zone not null default now(),
    is_income boolean not null default false,
    is_transfer boolean not null default false,

    constraint Transaction_pkey primary key (id),

    constraint Transaction_account_id_fkey foreign key (account_id)
    references "Account" (id) on update cascade on delete cascade,

    constraint Transaction_category_id_fkey foreign key (category_id)
    references "Category" (id) on update cascade on delete cascade
) tablespace pg_default;

create policy "Users can view transactions if they have at least one account"
on public."Transaction" for select to public
using ((
    select exists (
        select id from public."Account" where (select auth.uid()) = user_id
    )
));

alter table public."Transaction" enable row level security;
