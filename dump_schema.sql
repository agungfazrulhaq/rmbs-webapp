--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4 (Debian 15.4-2.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Debian 15.4-2.pgdg120+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: booking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking (
    booking_id bigint NOT NULL,
    brief_desc character varying(255) NOT NULL,
    "desc" text,
    user_id bigint NOT NULL,
    start_date time(0) without time zone NOT NULL,
    end_date time(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    modified_at timestamp(0) without time zone,
    repeatable boolean NOT NULL,
    room_id bigint NOT NULL,
    status character varying(255) NOT NULL,
    booking_type character varying(255) NOT NULL
);


ALTER TABLE public.booking OWNER TO postgres;

--
-- Name: booking_owner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_owner (
    booking_owner_id bigint NOT NULL,
    user_id bigint NOT NULL,
    booking_id bigint NOT NULL
);


ALTER TABLE public.booking_owner OWNER TO postgres;

--
-- Name: booking_owner_booking_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.booking_owner_booking_owner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.booking_owner_booking_owner_id_seq OWNER TO postgres;

--
-- Name: booking_owner_booking_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.booking_owner_booking_owner_id_seq OWNED BY public.booking_owner.booking_owner_id;


--
-- Name: logactivity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logactivity (
    log_id bigint NOT NULL,
    user_id bigint NOT NULL,
    activity text NOT NULL,
    date timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.logactivity OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id smallint DEFAULT nextval('public.role_id_seq'::regclass) NOT NULL,
    name character varying(255),
    description text NOT NULL,
    rolename character varying NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.room_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.room_id_seq OWNER TO postgres;

--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_id bigint DEFAULT nextval('public.room_id_seq'::regclass) NOT NULL,
    capacity bigint NOT NULL,
    facility text NOT NULL,
    room_name character varying(255) NOT NULL,
    description text NOT NULL,
    available boolean NOT NULL,
    image_url text
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedules (
    schedule_id bigint NOT NULL,
    booking_id bigint NOT NULL,
    start_date time(0) without time zone NOT NULL,
    end_date time(0) without time zone NOT NULL,
    date date NOT NULL
);


ALTER TABLE public.schedules OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint DEFAULT nextval('public.user_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    role_id smallint NOT NULL,
    password character varying(255) NOT NULL,
    email character varying NOT NULL,
    enable_status boolean
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: booking_owner booking_owner_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_owner ALTER COLUMN booking_owner_id SET DEFAULT nextval('public.booking_owner_booking_owner_id_seq'::regclass);


--
-- Name: booking_owner booking_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_owner
    ADD CONSTRAINT booking_owner_pkey PRIMARY KEY (booking_owner_id);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (booking_id);


--
-- Name: logactivity logactivity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logactivity
    ADD CONSTRAINT logactivity_pkey PRIMARY KEY (log_id);


--
-- Name: roles role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: booking_owner booking_owner_booking_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_owner
    ADD CONSTRAINT booking_owner_booking_id_foreign FOREIGN KEY (booking_id) REFERENCES public.booking(booking_id);


--
-- Name: booking booking_room_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_room_id_foreign FOREIGN KEY (room_id) REFERENCES public.rooms(room_id);


--
-- Name: booking booking_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: logactivity logactivity_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logactivity
    ADD CONSTRAINT logactivity_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: schedules schedules_booking_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_booking_id_foreign FOREIGN KEY (booking_id) REFERENCES public.booking(booking_id);


--
-- Name: users users_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: booking_owner users_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_owner
    ADD CONSTRAINT users_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

