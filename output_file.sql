--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

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

ALTER TABLE ONLY public.booking_owner DROP CONSTRAINT users_user_id_foreign;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_role_id_foreign;
ALTER TABLE ONLY public.schedules DROP CONSTRAINT schedules_booking_id_foreign;
ALTER TABLE ONLY public.logactivity DROP CONSTRAINT logactivity_user_id_foreign;
ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_user_id_foreign;
ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_room_id_foreign;
ALTER TABLE ONLY public.booking_owner DROP CONSTRAINT booking_owner_booking_id_foreign;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.schedules DROP CONSTRAINT schedules_pkey;
ALTER TABLE ONLY public.rooms DROP CONSTRAINT rooms_pkey;
ALTER TABLE ONLY public.roles DROP CONSTRAINT role_pkey;
ALTER TABLE ONLY public.logactivity DROP CONSTRAINT logactivity_pkey;
ALTER TABLE ONLY public.booking DROP CONSTRAINT booking_pkey;
ALTER TABLE ONLY public.booking_owner DROP CONSTRAINT booking_owner_pkey;
ALTER TABLE public.booking_owner ALTER COLUMN booking_owner_id DROP DEFAULT;
DROP TABLE public.users;
DROP SEQUENCE public.user_id_seq;
DROP TABLE public.schedules;
DROP TABLE public.rooms;
DROP TABLE public.roles;
DROP SEQUENCE public.role_id_seq;
DROP TABLE public.logactivity;
DROP SEQUENCE public.booking_owner_booking_owner_id_seq;
DROP TABLE public.booking_owner;
DROP TABLE public.booking;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: booking; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: booking_owner; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.booking_owner (
    booking_owner_id bigint NOT NULL,
    user_id bigint NOT NULL,
    booking_id bigint NOT NULL
);


--
-- Name: booking_owner_booking_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.booking_owner_booking_owner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: booking_owner_booking_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.booking_owner_booking_owner_id_seq OWNED BY public.booking_owner.booking_owner_id;


--
-- Name: logactivity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logactivity (
    log_id bigint NOT NULL,
    user_id bigint NOT NULL,
    activity text NOT NULL,
    date timestamp(0) without time zone NOT NULL
);


--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    role_id smallint DEFAULT nextval('public.role_id_seq'::regclass) NOT NULL,
    name character varying(255),
    description text NOT NULL,
    rolename character varying NOT NULL
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    room_id bigint NOT NULL,
    capacity bigint NOT NULL,
    facility text NOT NULL,
    room_name character varying(255) NOT NULL,
    description text NOT NULL,
    available boolean NOT NULL
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    schedule_id bigint NOT NULL,
    booking_id bigint NOT NULL,
    start_date time(0) without time zone NOT NULL,
    end_date time(0) without time zone NOT NULL,
    date date NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- Name: booking_owner booking_owner_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_owner ALTER COLUMN booking_owner_id SET DEFAULT nextval('public.booking_owner_booking_owner_id_seq'::regclass);


--
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: booking_owner; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: logactivity; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.roles (role_id, name, description, rolename) VALUES (1, 'SYSTEM ADMIN', 'Add, Modify, View all information', 'sysadmin');
INSERT INTO public.roles (role_id, name, description, rolename) VALUES (2, 'REQUESTER', 'Add, Modify and Delete their own entries for a traveller', 'requester');
INSERT INTO public.roles (role_id, name, description, rolename) VALUES (3, 'TRAVELLER', 'Add, Modify and Delete their own entries or entries in their name', 'traveller');
INSERT INTO public.roles (role_id, name, description, rolename) VALUES (4, 'SUPERVISOR', 'Approved, Reject update a status for travellers requests', 'supervisor');


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users (user_id, name, username, role_id, password, email, enable_status) VALUES (1, 'System Administrator', 'sysadmin', 1, '$2b$12$mN52A6BLH/Ne6Kd4uk6kyer6GvyBSCt9MtgRQAYbNsfz2HkxeboGa', 'sysadm@example.co.id', true);
INSERT INTO public.users (user_id, name, username, role_id, password, email, enable_status) VALUES (2, 'Adam', 'useradam', 2, '$2b$12$6EH/fHhjcd5TvH4T5orSP.jw0z8C3q2iwSi3k0wbWit52tsjb6zO2', 'adam@example.org', true);
INSERT INTO public.users (user_id, name, username, role_id, password, email, enable_status) VALUES (3, 'Brendan', 'userbrendan', 3, '$2b$12$HfZpCs8U7FcWTjHJ5Qja/.LGq.xIXhDLx8zHcGM4i0H2sXterINzm', 'brendan@example.org', true);
INSERT INTO public.users (user_id, name, username, role_id, password, email, enable_status) VALUES (4, 'John', 'userjohn', 4, '$2b$12$O0rFcnxKQJ8xWsRrHRfEGez1rdNnus4/AvHx.onzZ000nm7.6bwey', 'john@example.org', true);


--
-- Name: booking_owner_booking_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.booking_owner_booking_owner_id_seq', 1, false);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.role_id_seq', 4, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_id_seq', 4, true);


--
-- Name: booking_owner booking_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_owner
    ADD CONSTRAINT booking_owner_pkey PRIMARY KEY (booking_owner_id);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (booking_id);


--
-- Name: logactivity logactivity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logactivity
    ADD CONSTRAINT logactivity_pkey PRIMARY KEY (log_id);


--
-- Name: roles role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (role_id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: booking_owner booking_owner_booking_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_owner
    ADD CONSTRAINT booking_owner_booking_id_foreign FOREIGN KEY (booking_id) REFERENCES public.booking(booking_id);


--
-- Name: booking booking_room_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_room_id_foreign FOREIGN KEY (room_id) REFERENCES public.rooms(room_id);


--
-- Name: booking booking_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: logactivity logactivity_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logactivity
    ADD CONSTRAINT logactivity_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: schedules schedules_booking_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_booking_id_foreign FOREIGN KEY (booking_id) REFERENCES public.booking(booking_id);


--
-- Name: users users_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: booking_owner users_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.booking_owner
    ADD CONSTRAINT users_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

