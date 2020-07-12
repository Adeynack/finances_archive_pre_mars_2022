SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: user_access_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_access_level AS ENUM (
    'Admin',
    'Write',
    'Read'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: book_rights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_rights (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    book_id uuid,
    user_id uuid NOT NULL,
    access public.user_access_level NOT NULL
);


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL,
    owner_id uuid NOT NULL,
    default_currency_id uuid NOT NULL
);


--
-- Name: currencies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.currencies (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    iso_code character varying,
    name character varying NOT NULL,
    symbol character varying,
    symbol_first boolean NOT NULL,
    subunit character varying,
    subunit_to_unit integer NOT NULL
);


--
-- Name: COLUMN currencies.iso_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.currencies.iso_code IS 'ISO-4217 Code (https://en.wikipedia.org/wiki/ISO_4217)';


--
-- Name: COLUMN currencies.symbol; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.currencies.symbol IS 'Text or symbol to prefix or suffix when displaying an amount in this currency.';


--
-- Name: COLUMN currencies.symbol_first; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.currencies.symbol_first IS 'Indicates if the symbol prefixes (true) or suffixes (false) the amount.';


--
-- Name: COLUMN currencies.subunit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.currencies.subunit IS 'Name of sub-unit of the currency (if any).';


--
-- Name: COLUMN currencies.subunit_to_unit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.currencies.subunit_to_unit IS 'How many sub-units does it take to make one unit (ex: 100 cents for 1 dollar, 5 Khoums for 1 Mauritanian Ouguiya)';


--
-- Name: registers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    book_id uuid NOT NULL,
    parent_id uuid,
    name character varying NOT NULL,
    type character varying NOT NULL,
    info jsonb,
    notes character varying,
    currency_id uuid NOT NULL,
    initial_balance integer NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: COLUMN registers.info; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registers.info IS 'A JSON structure containing details about the register. Different register type have different fields.';


--
-- Name: COLUMN registers.currency_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registers.currency_id IS 'Currency in which this register operates.';


--
-- Name: COLUMN registers.initial_balance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registers.initial_balance IS 'Balance when this register is entered in the system.';


--
-- Name: COLUMN registers.active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registers.active IS 'Inactive registers stay in the system for historical purposes but are not displayed to the user by default.';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    email character varying NOT NULL,
    display_name character varying NOT NULL,
    password_digest character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: book_rights book_rights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_rights
    ADD CONSTRAINT book_rights_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: currencies currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (id);


--
-- Name: registers registers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registers
    ADD CONSTRAINT registers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_book_rights_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_rights_on_book_id ON public.book_rights USING btree (book_id);


--
-- Name: index_book_rights_on_book_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_book_rights_on_book_id_and_user_id ON public.book_rights USING btree (book_id, user_id);


--
-- Name: index_book_rights_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_book_rights_on_user_id ON public.book_rights USING btree (user_id);


--
-- Name: index_books_on_default_currency_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_default_currency_id ON public.books USING btree (default_currency_id);


--
-- Name: index_books_on_name_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_books_on_name_and_owner_id ON public.books USING btree (name, owner_id);


--
-- Name: index_books_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_owner_id ON public.books USING btree (owner_id);


--
-- Name: index_currencies_on_iso_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_currencies_on_iso_code ON public.currencies USING btree (iso_code);


--
-- Name: index_registers_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registers_on_active ON public.registers USING btree (active);


--
-- Name: index_registers_on_book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registers_on_book_id ON public.registers USING btree (book_id);


--
-- Name: index_registers_on_book_id_and_parent_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_registers_on_book_id_and_parent_id_and_name ON public.registers USING btree (book_id, parent_id, name);


--
-- Name: index_registers_on_currency_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registers_on_currency_id ON public.registers USING btree (currency_id);


--
-- Name: index_registers_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registers_on_parent_id ON public.registers USING btree (parent_id);


--
-- Name: index_registers_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registers_on_type ON public.registers USING btree (type);


--
-- Name: index_users_on_display_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_display_name ON public.users USING btree (display_name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: books fk_rails_1b1e135573; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_rails_1b1e135573 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: registers fk_rails_478010d6cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registers
    ADD CONSTRAINT fk_rails_478010d6cf FOREIGN KEY (currency_id) REFERENCES public.currencies(id);


--
-- Name: books fk_rails_6fc465ae85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT fk_rails_6fc465ae85 FOREIGN KEY (default_currency_id) REFERENCES public.currencies(id);


--
-- Name: registers fk_rails_8568b4a0d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registers
    ADD CONSTRAINT fk_rails_8568b4a0d0 FOREIGN KEY (parent_id) REFERENCES public.registers(id);


--
-- Name: book_rights fk_rails_ccb18bc7e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_rights
    ADD CONSTRAINT fk_rails_ccb18bc7e5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: registers fk_rails_dcf3a7135d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registers
    ADD CONSTRAINT fk_rails_dcf3a7135d FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: book_rights fk_rails_ebdd5fe059; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_rights
    ADD CONSTRAINT fk_rails_ebdd5fe059 FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('2020071200000001'),
('2020071200000002'),
('2020071200000003'),
('2020071200000004'),
('2020071200000005'),
('2020071200000006'),
('2020071200000007'),
('2020071200000008');


