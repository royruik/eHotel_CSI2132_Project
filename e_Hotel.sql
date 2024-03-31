--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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
-- Name: HotelChain; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "HotelChain";


ALTER SCHEMA "HotelChain" OWNER TO postgres;

--
-- Name: HotelDepartments; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "HotelDepartments";


ALTER SCHEMA "HotelDepartments" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: HotelChain; Type: TABLE; Schema: HotelChain; Owner: postgres
--

CREATE TABLE "HotelChain"."HotelChain" (
);


ALTER TABLE "HotelChain"."HotelChain" OWNER TO postgres;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: HotelChain; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA "HotelChain" GRANT ALL ON TABLES TO postgres;


--
-- PostgreSQL database dump complete
--

