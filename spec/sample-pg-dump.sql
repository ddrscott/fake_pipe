--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: hstore_add(hstore, hstore); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hstore_add(a hstore, b hstore) RETURNS hstore
LANGUAGE plpgsql IMMUTABLE
AS $$
BEGIN
	RETURN
	hstore(
		array_agg(key),
		array_agg(
			(
				COALESCE(r.value::integer, 0) +
				COALESCE(l.value::integer, 0)
			)::text
		)
	)
	FROM each(a) l
	FULL OUTER JOIN each(b) r
	USING (key);
END;
$$;

ALTER FUNCTION public.hstore_add(a hstore, b hstore) OWNER TO postgres;

--
-- Name: sum(hstore); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE sum(hstore) (
	SFUNC = hstore_add,
	STYPE = hstore,
	INITCOND = ''
);


ALTER AGGREGATE public.sum(hstore) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_users (
  id uuid DEFAULT uuid_generate_v4() NOT NULL,
  email character varying,
  crypted_password character varying,
  password_salt character varyin,
  persistence_token character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  active boolean DEFAULT true,
  first_name character varying,
  last_name character varying,
  agency_id uuid,
  phone character varying,
  perishable_token character varying,
  extension character varying,
  commissioned boolean DEFAULT false,
  region text,
  division text,
  location text,
  last_request_at timestamp without time zone
);


ALTER TABLE auth_users OWNER TO postgres;

--
-- Name: COLUMN auth_users.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.email IS 'anon: email';


--
-- Name: COLUMN auth_users.crypted_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.crypted_password IS 'anon: bcrypt_password';


--
-- Name: COLUMN auth_users.password_salt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.password_salt IS 'anon: bcrypt_salt';


--
-- Name: COLUMN auth_users.persistence_token; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.persistence_token IS 'anon: empty_string';


--
-- Name: COLUMN auth_users.first_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.first_name IS 'anon: first_name';


--
-- Name: COLUMN auth_users.last_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.last_name IS 'anon: last_name';


--
-- Name: COLUMN auth_users.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.phone IS 'anon: clean_phone_number';


--
-- Name: COLUMN auth_users.perishable_token; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN auth_users.perishable_token IS 'anon: empty_string';

--
-- Data for Name: auth_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_users (id, email, crypted_password, password_salt, persistence_token, created_at, updated_at, active, first_name, last_name, agency_id, phone, perishable_token, extension, commissioned, region, division, location, last_request_at) FROM stdin;
07750c56-fb37-46e1-b7b6-da530704c056	cj@example.com	400$8$4c$c11df6facaefc6bc$93a657fb3c6e4cd1fd3255d3bd1edd18ffc4a8092e2616b9e5ca7954b2c52504	v8BMktHnOeokEBTy6As	86a97ff982e87ed5af7d90ab2ce31d4e89a3af3e6a0490b067bb8213aea7a4ee0eeafae1d8fe3c6f990aead095092fcf852004b18e484ef22569aebf64c3747f	2016-06-03 18:23:06.25685	2016-06-03 18:23:06.25685	t	C.J.	Cregg	\N	1231231234	hw1rFSX7yJBz65lDVzYi	\N	f	\N	\N	\N	\N
d489bda7-3212-4026-aef9-879d3242ad0c	leo@example.com	400$8$50$5555852e67bf920f$161b41afd99159609151f22fbc4efdccb925244606a87fc635954a71e8f7606f	c5d6v3NS97D3wYkUltFQ	630aaf10f3edcb396181535476bccfd369e1ee9281cbc218d0861e6117b9839219cb403abed3b59468b2564c229d78b0cb610d0e16fa4a03dc4d93ed3d55deb3	2016-06-03 18:23:06.417694	2016-06-03 18:23:06.417694	t	Leo	McGarry	\N	1231231234	ojbfkdLiQOOHvqxuTsg	\N	f	\N	\N	\N	\N
ab344f75-d78a-47ba-a4f7-121275b3b241	donna@example.com	400$8$4a$fb1a833f95079502$8b6ddd327381860e18bce53ee1a3249d5237de4f4344c06ad940ba8cfc6a2259	2IcBeSh6IVVCJyZpqBt	06fa5d0f3a4d62ff60717ff3315301129a5bcd152f63f073b67d2e6a835b098524b1d097367283c97ca75db9154cf61d6a918248eb68eaf8cd83d1a87cdd92dc	2016-06-03 18:23:06.563866	2016-06-03 18:23:06.563866	t	Donna	Moss	\N	1231231234	p8MikeuBbbbFZ2i7V1gT	\N	f	\N	\N	\N	\N
f7bd4a7f-b63f-41c3-83bd-9683f33bb4b3	charlie@example.com	400$8$50$8368e20d878ef1b1$b271e3af024b424b7256592439a35d6eb224b4dc769ac9f2fa564b282efb8a47	QOqWQ24CMiRNuPUz8f5	02cbd8d1e9690c7786375f9f6ec4da6fa3c2ead70d41a7aa1d7fe631477b42635210f0e8fa7579f6f4b5afdb364d9465623a2861ecff75fa3a052c9b2a9fc2dd	2016-06-03 18:23:06.739671	2016-06-03 18:23:06.739671	t	Charlie	Young	\N	1231231234	rkU7yVplV5FMsoJFDkaM	\N	f	\N	\N	\N	\N
abe9fd39-f0b3-4ec6-9006-9783fbdade07	fun@example.com	400$8$50$ef1eb813f8d8b99d$2932a9dc75d10f13525e43c29726061d99b4ebdff2e9f9951eb6e2393f36d221	uMYA6c3A7uGoI0aEbJ8R	b09909b6e83938dd41ffb5e931eeb3d646b1856dfb74a81acb1697b6d8466468047fe92286e011a4634c71b8d8775c7d5a31e19ce111bd31d0a61a4faf93d6af	2016-06-03 18:23:05.797143	2016-06-07 21:53:45.149755	t	Fun	Buyer	5030cc27-e7a8-4768-b355-20cdcf9efc53	1112223333	8npwjv7m8NmCTT9eZdIK	\N	f	\N	\N	\N	2016-06-07 21:53:45.148823
\.


COMMENT ON COLUMN messages.message IS 'anon: lorem_paragraph';

COPY messages (id, message, recipient) FROM stdin;
20f654fe-b27d-4051-9fd4-da7eea1b9aa0	Hello -\nI'm writing in regards to the stuff I've been receiving. Double quotes are "awesome"!	support@example.com
\.
