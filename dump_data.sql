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

--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, name, description, rolename) FROM stdin;
1	SYSTEM ADMIN	Add, Modify, View all information	sysadmin
2	REQUESTER	Add, Modify and Delete their own entries for a traveller	requester
3	TRAVELLER	Add, Modify and Delete their own entries or entries in their name	traveller
4	SUPERVISOR	Approved, Reject update a status for travellers requests	supervisor
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (room_id, capacity, facility, room_name, description, available, image_url) FROM stdin;
1	20	Projector, Wi-Fi, Dispenser	Conference Room	Conference Room Description	t	room-image/conference-room.jpg
2	10	Wi-fi, etc	Room A	This is Room A	t	room-image-demo/room1.png
4	15	Updated Facilities	Room B	meeting room	t	room-image-demo/room2.jpg
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, username, role_id, password, email, enable_status) FROM stdin;
1	System Administrator	sysadmin	1	$2b$12$mN52A6BLH/Ne6Kd4uk6kyer6GvyBSCt9MtgRQAYbNsfz2HkxeboGa	sysadm@example.co.id	t
2	Adam	useradam	2	$2b$12$6EH/fHhjcd5TvH4T5orSP.jw0z8C3q2iwSi3k0wbWit52tsjb6zO2	adam@example.org	t
3	Brendan	userbrendan	3	$2b$12$HfZpCs8U7FcWTjHJ5Qja/.LGq.xIXhDLx8zHcGM4i0H2sXterINzm	brendan@example.org	t
4	John	userjohn	4	$2b$12$O0rFcnxKQJ8xWsRrHRfEGez1rdNnus4/AvHx.onzZ000nm7.6bwey	john@example.org	t
\.


--
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking (booking_id, brief_desc, "desc", user_id, start_date, end_date, created_at, modified_at, repeatable, room_id, status, booking_type) FROM stdin;
\.


--
-- Data for Name: booking_owner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_owner (booking_owner_id, user_id, booking_id) FROM stdin;
\.


--
-- Data for Name: logactivity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logactivity (log_id, user_id, activity, date) FROM stdin;
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schedules (schedule_id, booking_id, start_date, end_date, date) FROM stdin;
\.


--
-- Name: booking_owner_booking_owner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.booking_owner_booking_owner_id_seq', 1, false);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 4, true);


--
-- Name: room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.room_id_seq', 4, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 4, true);


--
-- PostgreSQL database dump complete
--

