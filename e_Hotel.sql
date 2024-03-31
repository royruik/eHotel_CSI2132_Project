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
-- Name: Booking; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Booking";


ALTER SCHEMA "Booking" OWNER TO postgres;

--
-- Name: Customer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Customer";


ALTER SCHEMA "Customer" OWNER TO postgres;

--
-- Name: Employee; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Employee";


ALTER SCHEMA "Employee" OWNER TO postgres;

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

--
-- Name: archive_deleted_booking(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.archive_deleted_booking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "Booking".archive (
        original_action_id,
        action_type,
        customer_id,
        room_id,
        employee_id,
        start_date,
        end_date,
        number_of_guests,
        problem_reported,
        special_notes,
        archive_date
    ) VALUES (
        OLD.booking_id,
        'Booking',
        OLD.customer_id,
        OLD.room_id,
        OLD.employee_id,
        OLD.booking_start_date,
        OLD.booking_end_date,
        OLD.number_of_guests,
        NULL,  -- Assuming you have fields for reporting problems and special notes
        NULL,
        CURRENT_DATE
    );

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.archive_deleted_booking() OWNER TO postgres;

--
-- Name: prevent_booking_overlap(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.prevent_booking_overlap() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    room_already_booked BOOLEAN;
BEGIN
    -- Check if there are any bookings that overlap the date range for the same room
    SELECT EXISTS (
        SELECT 1 FROM "Booking".booking
        WHERE room_id = NEW.room_id
        AND booking_start_date < NEW.booking_end_date
        AND booking_end_date > NEW.booking_start_date
    ) INTO room_already_booked;

    IF room_already_booked THEN
        RAISE EXCEPTION 'Room is already booked for the given dates';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.prevent_booking_overlap() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: archive; Type: TABLE; Schema: Booking; Owner: postgres
--

CREATE TABLE "Booking".archive (
    archive_id integer NOT NULL,
    original_action_id integer,
    action_type character varying(50),
    customer_id integer,
    room_id integer,
    employee_id integer,
    start_date date,
    end_date date,
    number_of_guests integer,
    problem_reported character varying(255),
    special_notes character varying(255),
    archive_date date,
    dp_id integer NOT NULL
);


ALTER TABLE "Booking".archive OWNER TO postgres;

--
-- Name: archive_archive_id_seq; Type: SEQUENCE; Schema: Booking; Owner: postgres
--

CREATE SEQUENCE "Booking".archive_archive_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Booking".archive_archive_id_seq OWNER TO postgres;

--
-- Name: archive_archive_id_seq; Type: SEQUENCE OWNED BY; Schema: Booking; Owner: postgres
--

ALTER SEQUENCE "Booking".archive_archive_id_seq OWNED BY "Booking".archive.archive_id;


--
-- Name: booking; Type: TABLE; Schema: Booking; Owner: postgres
--

CREATE TABLE "Booking".booking (
    booking_id integer NOT NULL,
    customer_id integer,
    room_id integer,
    employee_id integer,
    number_of_guests integer,
    booking_start_date date,
    booking_end_date date,
    dp_id integer NOT NULL
);


ALTER TABLE "Booking".booking OWNER TO postgres;

--
-- Name: booking_booking_id_seq; Type: SEQUENCE; Schema: Booking; Owner: postgres
--

CREATE SEQUENCE "Booking".booking_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Booking".booking_booking_id_seq OWNER TO postgres;

--
-- Name: booking_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: Booking; Owner: postgres
--

ALTER SEQUENCE "Booking".booking_booking_id_seq OWNED BY "Booking".booking.booking_id;


--
-- Name: renting; Type: TABLE; Schema: Booking; Owner: postgres
--

CREATE TABLE "Booking".renting (
    renting_id integer NOT NULL,
    customer_id integer,
    room_id integer,
    employee_id integer,
    check_in_date date,
    check_out_date date,
    number_of_guests integer,
    payment_status character varying(100),
    dp_id integer NOT NULL
);


ALTER TABLE "Booking".renting OWNER TO postgres;

--
-- Name: renting_renting_id_seq; Type: SEQUENCE; Schema: Booking; Owner: postgres
--

CREATE SEQUENCE "Booking".renting_renting_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Booking".renting_renting_id_seq OWNER TO postgres;

--
-- Name: renting_renting_id_seq; Type: SEQUENCE OWNED BY; Schema: Booking; Owner: postgres
--

ALTER SEQUENCE "Booking".renting_renting_id_seq OWNED BY "Booking".renting.renting_id;


--
-- Name: customer; Type: TABLE; Schema: Customer; Owner: postgres
--

CREATE TABLE "Customer".customer (
    customer_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    address character varying(255),
    id_proof_type character varying(50),
    id_proof_no character varying(50),
    regis_date date
);


ALTER TABLE "Customer".customer OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE; Schema: Customer; Owner: postgres
--

CREATE SEQUENCE "Customer".customer_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Customer".customer_customer_id_seq OWNER TO postgres;

--
-- Name: customer_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: Customer; Owner: postgres
--

ALTER SEQUENCE "Customer".customer_customer_id_seq OWNED BY "Customer".customer.customer_id;


--
-- Name: employeerole; Type: TABLE; Schema: Employee; Owner: postgres
--

CREATE TABLE "Employee".employeerole (
    employee_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE "Employee".employeerole OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: Employee; Owner: postgres
--

CREATE TABLE "Employee".employees (
    employee_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    address character varying(255),
    ssn_sin character varying(20),
    role_id integer,
    dp_id integer NOT NULL
);


ALTER TABLE "Employee".employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: Employee; Owner: postgres
--

CREATE SEQUENCE "Employee".employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Employee".employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: Employee; Owner: postgres
--

ALTER SEQUENCE "Employee".employees_employee_id_seq OWNED BY "Employee".employees.employee_id;


--
-- Name: role; Type: TABLE; Schema: Employee; Owner: postgres
--

CREATE TABLE "Employee".role (
    role_id integer NOT NULL,
    role_name character varying(255)
);


ALTER TABLE "Employee".role OWNER TO postgres;

--
-- Name: role_role_id_seq; Type: SEQUENCE; Schema: Employee; Owner: postgres
--

CREATE SEQUENCE "Employee".role_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Employee".role_role_id_seq OWNER TO postgres;

--
-- Name: role_role_id_seq; Type: SEQUENCE OWNED BY; Schema: Employee; Owner: postgres
--

ALTER SEQUENCE "Employee".role_role_id_seq OWNED BY "Employee".role.role_id;


--
-- Name: hotelchain; Type: TABLE; Schema: HotelChain; Owner: postgres
--

CREATE TABLE "HotelChain".hotelchain (
    brand_id integer NOT NULL,
    brand_name character varying(255) NOT NULL,
    office_address character varying(255),
    contact_email character varying(255),
    phone_no character varying(20),
    hotel_counts integer
);


ALTER TABLE "HotelChain".hotelchain OWNER TO postgres;

--
-- Name: hotelchain_brand_id_seq; Type: SEQUENCE; Schema: HotelChain; Owner: postgres
--

CREATE SEQUENCE "HotelChain".hotelchain_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "HotelChain".hotelchain_brand_id_seq OWNER TO postgres;

--
-- Name: hotelchain_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: HotelChain; Owner: postgres
--

ALTER SEQUENCE "HotelChain".hotelchain_brand_id_seq OWNED BY "HotelChain".hotelchain.brand_id;


--
-- Name: hotel; Type: TABLE; Schema: HotelDepartments; Owner: postgres
--

CREATE TABLE "HotelDepartments".hotel (
    dp_id integer NOT NULL,
    brand_id integer,
    star_level integer,
    dp_phone character varying(20),
    dp_address character varying(255),
    dp_email character varying(255),
    manager_id integer,
    room_counts integer
);


ALTER TABLE "HotelDepartments".hotel OWNER TO postgres;

--
-- Name: hotel_dp_id_seq; Type: SEQUENCE; Schema: HotelDepartments; Owner: postgres
--

CREATE SEQUENCE "HotelDepartments".hotel_dp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "HotelDepartments".hotel_dp_id_seq OWNER TO postgres;

--
-- Name: hotel_dp_id_seq; Type: SEQUENCE OWNED BY; Schema: HotelDepartments; Owner: postgres
--

ALTER SEQUENCE "HotelDepartments".hotel_dp_id_seq OWNED BY "HotelDepartments".hotel.dp_id;


--
-- Name: rooms; Type: TABLE; Schema: HotelDepartments; Owner: postgres
--

CREATE TABLE "HotelDepartments".rooms (
    room_no integer NOT NULL,
    dp_id integer NOT NULL,
    price numeric(10,2),
    capacity integer,
    has_sea_view boolean,
    has_mountain_view boolean,
    can_extend_bed boolean,
    problems_description text,
    has_tv boolean DEFAULT false NOT NULL,
    has_air_conditioning boolean DEFAULT false NOT NULL,
    has_fridge boolean DEFAULT false NOT NULL
);


ALTER TABLE "HotelDepartments".rooms OWNER TO postgres;

--
-- Name: rooms_room_no_seq; Type: SEQUENCE; Schema: HotelDepartments; Owner: postgres
--

CREATE SEQUENCE "HotelDepartments".rooms_room_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "HotelDepartments".rooms_room_no_seq OWNER TO postgres;

--
-- Name: rooms_room_no_seq; Type: SEQUENCE OWNED BY; Schema: HotelDepartments; Owner: postgres
--

ALTER SEQUENCE "HotelDepartments".rooms_room_no_seq OWNED BY "HotelDepartments".rooms.room_no;


--
-- Name: available_rooms_per_area; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.available_rooms_per_area AS
 SELECT hd.dp_id AS department_id,
    hd.dp_address AS department_address,
    count(r.room_no) AS available_rooms_count
   FROM (("HotelDepartments".hotel hd
     LEFT JOIN "HotelDepartments".rooms r ON ((hd.dp_id = r.dp_id)))
     LEFT JOIN "Booking".booking b ON (((r.room_no = b.room_id) AND (hd.dp_id = b.dp_id) AND (b.booking_end_date >= CURRENT_DATE))))
  WHERE ((b.booking_id IS NULL) OR (b.booking_end_date < CURRENT_DATE))
  GROUP BY hd.dp_id, hd.dp_address
  ORDER BY hd.dp_id;


ALTER VIEW public.available_rooms_per_area OWNER TO postgres;

--
-- Name: totalcapacityperhotel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.totalcapacityperhotel AS
 SELECT hd.dp_id,
    hd.dp_address AS hoteladdress,
    sum(r.capacity) AS totalcapacity
   FROM ("HotelDepartments".hotel hd
     JOIN "HotelDepartments".rooms r ON ((hd.dp_id = r.dp_id)))
  GROUP BY hd.dp_id, hd.dp_address
  ORDER BY hd.dp_id;


ALTER VIEW public.totalcapacityperhotel OWNER TO postgres;

--
-- Name: archive archive_id; Type: DEFAULT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".archive ALTER COLUMN archive_id SET DEFAULT nextval('"Booking".archive_archive_id_seq'::regclass);


--
-- Name: booking booking_id; Type: DEFAULT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".booking ALTER COLUMN booking_id SET DEFAULT nextval('"Booking".booking_booking_id_seq'::regclass);


--
-- Name: renting renting_id; Type: DEFAULT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".renting ALTER COLUMN renting_id SET DEFAULT nextval('"Booking".renting_renting_id_seq'::regclass);


--
-- Name: customer customer_id; Type: DEFAULT; Schema: Customer; Owner: postgres
--

ALTER TABLE ONLY "Customer".customer ALTER COLUMN customer_id SET DEFAULT nextval('"Customer".customer_customer_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".employees ALTER COLUMN employee_id SET DEFAULT nextval('"Employee".employees_employee_id_seq'::regclass);


--
-- Name: role role_id; Type: DEFAULT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".role ALTER COLUMN role_id SET DEFAULT nextval('"Employee".role_role_id_seq'::regclass);


--
-- Name: hotelchain brand_id; Type: DEFAULT; Schema: HotelChain; Owner: postgres
--

ALTER TABLE ONLY "HotelChain".hotelchain ALTER COLUMN brand_id SET DEFAULT nextval('"HotelChain".hotelchain_brand_id_seq'::regclass);


--
-- Name: hotel dp_id; Type: DEFAULT; Schema: HotelDepartments; Owner: postgres
--

ALTER TABLE ONLY "HotelDepartments".hotel ALTER COLUMN dp_id SET DEFAULT nextval('"HotelDepartments".hotel_dp_id_seq'::regclass);


--
-- Name: rooms room_no; Type: DEFAULT; Schema: HotelDepartments; Owner: postgres
--

ALTER TABLE ONLY "HotelDepartments".rooms ALTER COLUMN room_no SET DEFAULT nextval('"HotelDepartments".rooms_room_no_seq'::regclass);


--
-- Name: archive archive_pkey; Type: CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".archive
    ADD CONSTRAINT archive_pkey PRIMARY KEY (archive_id);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (booking_id);


--
-- Name: renting renting_pkey; Type: CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".renting
    ADD CONSTRAINT renting_pkey PRIMARY KEY (renting_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: Customer; Owner: postgres
--

ALTER TABLE ONLY "Customer".customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: employeerole employeerole_pkey; Type: CONSTRAINT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".employeerole
    ADD CONSTRAINT employeerole_pkey PRIMARY KEY (employee_id, role_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);


--
-- Name: hotelchain hotelchain_pkey; Type: CONSTRAINT; Schema: HotelChain; Owner: postgres
--

ALTER TABLE ONLY "HotelChain".hotelchain
    ADD CONSTRAINT hotelchain_pkey PRIMARY KEY (brand_id);


--
-- Name: hotel hotel_pkey; Type: CONSTRAINT; Schema: HotelDepartments; Owner: postgres
--

ALTER TABLE ONLY "HotelDepartments".hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (dp_id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: HotelDepartments; Owner: postgres
--

ALTER TABLE ONLY "HotelDepartments".rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_no, dp_id);


--
-- Name: idx_booking_dates; Type: INDEX; Schema: Booking; Owner: postgres
--

CREATE INDEX idx_booking_dates ON "Booking".booking USING btree (booking_start_date, booking_end_date);


--
-- Name: idx_customer_regis_date; Type: INDEX; Schema: Customer; Owner: postgres
--

CREATE INDEX idx_customer_regis_date ON "Customer".customer USING btree (regis_date);


--
-- Name: idx_room_price; Type: INDEX; Schema: HotelDepartments; Owner: postgres
--

CREATE INDEX idx_room_price ON "HotelDepartments".rooms USING btree (price);


--
-- Name: booking prevent_booking_overlap; Type: TRIGGER; Schema: Booking; Owner: postgres
--

CREATE TRIGGER prevent_booking_overlap BEFORE INSERT ON "Booking".booking FOR EACH ROW EXECUTE FUNCTION public.prevent_booking_overlap();


--
-- Name: archive archive_customer_id_fkey; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".archive
    ADD CONSTRAINT archive_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES "Customer".customer(customer_id);


--
-- Name: archive archive_employee_id_fkey; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".archive
    ADD CONSTRAINT archive_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES "Employee".employees(employee_id);


--
-- Name: archive archive_room_fk; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".archive
    ADD CONSTRAINT archive_room_fk FOREIGN KEY (room_id, dp_id) REFERENCES "HotelDepartments".rooms(room_no, dp_id);


--
-- Name: booking booking_customer_id_fkey; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".booking
    ADD CONSTRAINT booking_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES "Customer".customer(customer_id);


--
-- Name: booking booking_employee_id_fkey; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".booking
    ADD CONSTRAINT booking_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES "Employee".employees(employee_id);


--
-- Name: booking booking_room_fk; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".booking
    ADD CONSTRAINT booking_room_fk FOREIGN KEY (room_id, dp_id) REFERENCES "HotelDepartments".rooms(room_no, dp_id);


--
-- Name: renting renting_customer_id_fkey; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".renting
    ADD CONSTRAINT renting_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES "Customer".customer(customer_id);


--
-- Name: renting renting_employee_id_fkey; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".renting
    ADD CONSTRAINT renting_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES "Employee".employees(employee_id);


--
-- Name: renting renting_room_fk; Type: FK CONSTRAINT; Schema: Booking; Owner: postgres
--

ALTER TABLE ONLY "Booking".renting
    ADD CONSTRAINT renting_room_fk FOREIGN KEY (room_id, dp_id) REFERENCES "HotelDepartments".rooms(room_no, dp_id);


--
-- Name: employeerole employeerole_employee_id_fkey; Type: FK CONSTRAINT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".employeerole
    ADD CONSTRAINT employeerole_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES "Employee".employees(employee_id);


--
-- Name: employees fk_employee_dp_id; Type: FK CONSTRAINT; Schema: Employee; Owner: postgres
--

ALTER TABLE ONLY "Employee".employees
    ADD CONSTRAINT fk_employee_dp_id FOREIGN KEY (dp_id) REFERENCES "HotelDepartments".hotel(dp_id);


--
-- Name: hotel hotel_brand_id_fkey; Type: FK CONSTRAINT; Schema: HotelDepartments; Owner: postgres
--

ALTER TABLE ONLY "HotelDepartments".hotel
    ADD CONSTRAINT hotel_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES "HotelChain".hotelchain(brand_id);


--
-- Name: rooms rooms_dp_id_fkey; Type: FK CONSTRAINT; Schema: HotelDepartments; Owner: postgres
--

ALTER TABLE ONLY "HotelDepartments".rooms
    ADD CONSTRAINT rooms_dp_id_fkey FOREIGN KEY (dp_id) REFERENCES "HotelDepartments".hotel(dp_id);


--
-- PostgreSQL database dump complete
--

