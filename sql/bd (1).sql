-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 06, 2024 at 02:43 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bd`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `APPOINTMENT_ID` int(11) NOT NULL,
  `DONOR_ID` int(11) NOT NULL,
  `HOSPITAL_ID` int(11) NOT NULL,
  `DATE` date NOT NULL,
  `TIME` time NOT NULL,
  `STATUS` enum('Pending','Confirmed','Completed','Cancelled') DEFAULT 'Pending',
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`APPOINTMENT_ID`, `DONOR_ID`, `HOSPITAL_ID`, `DATE`, `TIME`, `STATUS`, `active`) VALUES
(44, 20, 1, '2024-12-18', '14:53:00', 'Cancelled', 0),
(45, 20, 1, '2024-12-09', '13:54:00', 'Confirmed', 0),
(46, 20, 1, '2024-12-23', '15:59:00', 'Cancelled', 1),
(47, 20, 1, '2024-12-16', '03:00:00', 'Confirmed', 1),
(48, 2, 1, '2024-12-12', '05:57:00', 'Cancelled', 1),
(49, 2, 1, '2024-12-25', '01:00:00', 'Confirmed', 1),
(50, 21, 6, '2024-12-10', '01:00:00', 'Confirmed', 1),
(51, 21, 6, '2024-12-16', '01:01:00', 'Cancelled', 1),
(52, 23, 1, '2024-12-08', '16:55:00', 'Cancelled', 1),
(53, 2, 1, '2024-12-09', '10:41:00', 'Confirmed', 1),
(54, 5, 1, '2024-12-25', '11:20:00', 'Pending', 1),
(55, 25, 1, '2024-12-09', '01:02:00', 'Confirmed', 1),
(56, 27, 1, '2024-12-08', '00:38:00', 'Confirmed', 1);

-- --------------------------------------------------------

--
-- Table structure for table `blood_requests`
--

CREATE TABLE `blood_requests` (
  `REQUEST_ID` int(11) NOT NULL,
  `HOSPITAL_ID` int(11) NOT NULL,
  `BLOOD_TYPE` varchar(3) NOT NULL,
  `QUANTITY` int(11) NOT NULL,
  `REQUESTED_DATE` date DEFAULT curdate(),
  `STATUS` enum('Open','Fulfilled','Closed') DEFAULT 'Open',
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_requests`
--

INSERT INTO `blood_requests` (`REQUEST_ID`, `HOSPITAL_ID`, `BLOOD_TYPE`, `QUANTITY`, `REQUESTED_DATE`, `STATUS`, `active`) VALUES
(46, 1, 'A+', 34, '2024-12-04', 'Fulfilled', 0),
(47, 1, 'A+', 12, '2024-12-04', 'Fulfilled', 0),
(48, 1, 'B-', 12, '2024-12-04', 'Fulfilled', 0),
(49, 1, 'B-', 12, '2024-12-04', 'Fulfilled', 0),
(50, 1, 'A+', 12, '2024-12-05', 'Fulfilled', 1),
(51, 6, 'O+', 12, '2024-12-05', 'Fulfilled', 1),
(52, 6, 'A+', 23, '2024-12-05', 'Open', 1),
(53, 6, 'B-', 34, '2024-12-05', 'Open', 1),
(54, 6, 'O+', 23, '2024-12-05', 'Open', 1),
(55, 1, 'B+', 12, '2024-12-05', 'Open', 1),
(56, 1, 'A+', 12, '2024-12-05', 'Fulfilled', 1),
(58, 1, 'B+', 45, '2024-12-06', 'Open', 1),
(59, 1, 'O+', 12, '2024-12-06', 'Open', 1),
(60, 1, 'A+', 12, '2024-12-06', 'Fulfilled', 1),
(61, 1, 'A+', 12, '2024-12-06', 'Fulfilled', 1);

-- --------------------------------------------------------

--
-- Table structure for table `blood_types`
--

CREATE TABLE `blood_types` (
  `BLOOD_TYPE` varchar(3) NOT NULL,
  `DESCRIPTION` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_types`
--

INSERT INTO `blood_types` (`BLOOD_TYPE`, `DESCRIPTION`) VALUES
('A+', 'A positive blood type'),
('A-', 'A negative blood type'),
('AB+', 'AB positive blood type'),
('AB-', 'AB negative blood type'),
('B+', 'B positive blood type'),
('B-', 'B negative blood type'),
('O+', 'O positive blood type'),
('O-', 'O negative blood type');

-- --------------------------------------------------------

--
-- Table structure for table `donors`
--

CREATE TABLE `donors` (
  `donor_id` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `CONTACT_INFO` varchar(100) DEFAULT NULL,
  `MEDICAL_HISTORY` text DEFAULT NULL,
  `LOCATION_ID` int(11) DEFAULT NULL,
  `BLOOD_TYPE` varchar(3) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donors`
--

INSERT INTO `donors` (`donor_id`, `USER_ID`, `NAME`, `CONTACT_INFO`, `MEDICAL_HISTORY`, `LOCATION_ID`, `BLOOD_TYPE`, `active`) VALUES
(2, 2, 'A WaseyyY', '123', NULL, 1, 'A+', 1),
(4, 4, 'Salik Ahmed', '21211', NULL, 2, 'A+', 1),
(5, 5, 'Muhammad Hamza', '1232', NULL, 2, 'O+', 1),
(6, 6, 'Omer Khan', '12211', NULL, 1, 'B+', 1),
(7, 7, 'Muhib', '21211', NULL, 3, 'A+', 1),
(9, 9, 'Travis SHARIF', '0222123', NULL, 5, 'B+', 1),
(12, 14, 'Sabeer', '0313121', NULL, 9, 'A+', 1),
(14, 17, 'Talha Duration', '0303033', NULL, 11, 'A+', 1),
(15, 19, 'Abdullah masood', '12323123', NULL, 12, 'B-', 1),
(16, 20, 'Asghar Ali', '01312312', NULL, 8, 'B+', 1),
(18, 22, 'Saad Arshad', '123123', NULL, 8, 'A-', 1),
(19, 25, 'ASAD Ali Baloch', '12312', NULL, 8, 'O-', 1),
(20, 26, 'Usman khan M', '032131323', NULL, 2, 'B-', 1),
(21, 27, 'C. Ronaldo', '0213232232', NULL, 14, 'O+', 1),
(23, 30, 'Shahzaib', '12312312', NULL, 2, 'A+', 1),
(24, 32, 'Ayan', '123123', NULL, 2, 'AB+', 1),
(25, 33, 'Taha Imtiaz', '0303033', NULL, 2, 'O+', 1),
(26, 34, 'Abdul Rafay', '1231312', NULL, 2, 'O+', 1),
(27, 35, 'Fatima Gado', '123123', NULL, 2, 'O+', 1),
(28, 37, 'new user', '1312', NULL, 2, 'A+', 1);

-- --------------------------------------------------------

--
-- Table structure for table `hospitals`
--

CREATE TABLE `hospitals` (
  `HOSPITAL_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `LOCATION_ID` int(11) DEFAULT NULL,
  `CONTACT_INFO` varchar(100) DEFAULT NULL,
  `PARENT_HOSPITAL` varchar(100) DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospitals`
--

INSERT INTO `hospitals` (`HOSPITAL_ID`, `USER_ID`, `NAME`, `LOCATION_ID`, `CONTACT_INFO`, `PARENT_HOSPITAL`, `active`) VALUES
(1, 10, 'DOW HOSPITAL', 6, '', NULL, 1),
(2, 13, 'Jinnah', 8, '', NULL, 1),
(3, 18, 'NEHALS', 10, '12321', NULL, 1),
(4, 23, 'Hajmola dawakhana', 8, '', NULL, 1),
(5, 24, 'Liaqat National', 8, '', NULL, 1),
(6, 28, 'Hospital Angeles', 14, '', NULL, 1),
(7, 36, 'Hospita', 2, '132123', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `LOCATION_ID` int(11) NOT NULL,
  `LOCATION_NAME` varchar(100) DEFAULT NULL,
  `CITY` varchar(50) NOT NULL,
  `STATE` varchar(50) NOT NULL,
  `ZIP_CODE` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`LOCATION_ID`, `LOCATION_NAME`, `CITY`, `STATE`, `ZIP_CODE`) VALUES
(1, NULL, 'Karachi', 'Sindh', '14005'),
(2, NULL, 'karachi', 'Sindh', '75300'),
(3, NULL, 'Karachi', 'Sindh', '44332'),
(4, NULL, 'Aberdeen', 'UK', '33220'),
(5, NULL, 'New York', 'California', '756332'),
(6, NULL, 'Karachi', 'Sindh', '332212'),
(7, NULL, 'Karachi', 'Sindh', '21312'),
(8, NULL, 'Karachi', 'Sindh', '75330'),
(9, NULL, 'Karachi', 'Sindh', '211222'),
(10, NULL, 'Hyderabad', 'UK', '434322'),
(11, NULL, 'Aberdeen', 'UK', '123123'),
(12, NULL, 'Riyadh', 'Riyadh', '123221'),
(13, NULL, 'Hyderabad', 'Sindh', '742223'),
(14, NULL, 'Mexico', 'Spain', '14005');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `event_type` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`log_id`, `user_id`, `event_type`, `description`, `timestamp`) VALUES
(5, 22, 'Login', 'Successful login by user: saad', '2024-12-05 13:45:27'),
(6, 9, 'Login', 'Successful login by user: taha', '2024-12-05 13:47:15'),
(7, 5, 'Login', 'Successful login by user: hamza', '2024-12-05 13:47:53'),
(8, 10, 'Login', 'Successful login by user: dow', '2024-12-05 13:52:58'),
(9, 4, 'Login', 'Successful login by user: salik', '2024-12-05 14:10:40'),
(10, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-05 14:54:29'),
(11, 10, 'Login', 'Successful login by user: dow', '2024-12-05 14:54:59'),
(12, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-05 14:55:25'),
(13, 10, 'Login', 'Successful login by user: dow', '2024-12-05 14:55:45'),
(14, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-05 14:56:07'),
(15, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 07:34:50'),
(16, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 07:44:42'),
(17, 10, 'Login', 'Successful login by user: dow', '2024-12-06 07:47:32'),
(18, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 08:02:31'),
(19, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 08:09:45'),
(20, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 08:11:33'),
(21, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 08:28:14'),
(22, 10, 'Login', 'Successful login by user: dow', '2024-12-06 08:29:41'),
(23, 10, 'Login', 'Successful login by user: dow', '2024-12-06 08:46:58'),
(24, 10, 'Login', 'Successful login by user: dow', '2024-12-06 09:06:19'),
(25, 10, 'Login', 'Successful login by user: dow', '2024-12-06 09:07:25'),
(26, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 09:08:18'),
(27, 10, 'Login', 'Successful login by user: dow', '2024-12-06 09:09:33'),
(28, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 09:09:51'),
(29, 10, 'Login', 'Successful login by user: dow', '2024-12-06 09:17:14'),
(30, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 09:18:28'),
(31, 10, 'Login', 'Successful login by user: dow', '2024-12-06 09:21:03'),
(32, NULL, 'Login', 'Failed login attempt for username: rafay.', '2024-12-06 10:47:45'),
(33, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 10:47:50'),
(34, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 10:50:14'),
(35, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 10:50:29'),
(36, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 10:51:59'),
(37, NULL, 'Login', 'Failed login attempt for username: adsa.', '2024-12-06 10:52:19'),
(38, NULL, 'Login', 'Failed login attempt for username: rafay.', '2024-12-06 10:52:25'),
(39, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 10:52:30'),
(40, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:00:57'),
(41, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:01:19'),
(42, 10, 'Login', 'Successful login by user: dow', '2024-12-06 11:02:08'),
(43, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:02:41'),
(44, 10, 'Login', 'Successful login by user: dow', '2024-12-06 11:03:06'),
(45, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:03:23'),
(46, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:03:56'),
(47, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:04:54'),
(48, 33, 'Login', 'Successful login by user: taha123', '2024-12-06 11:05:00'),
(49, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 11:05:19'),
(50, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 11:08:09'),
(51, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 11:10:18'),
(52, 35, 'Login', 'Successful login by user: fatima', '2024-12-06 11:36:17'),
(53, 35, 'Login', 'Successful login by user: fatima', '2024-12-06 11:37:46'),
(54, 10, 'Login', 'Successful login by user: dow', '2024-12-06 11:38:22'),
(55, 35, 'Login', 'Successful login by user: fatima', '2024-12-06 11:38:37'),
(56, NULL, 'Login', 'Failed login attempt for username: dow.', '2024-12-06 11:39:15'),
(57, 10, 'Login', 'Successful login by user: dow', '2024-12-06 11:39:20'),
(58, 35, 'Login', 'Successful login by user: fatima', '2024-12-06 11:40:00'),
(59, 35, 'Login', 'Successful login by user: fatima', '2024-12-06 11:40:23'),
(61, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 12:25:00'),
(62, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 12:25:03'),
(63, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 12:25:17'),
(64, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 12:25:55'),
(65, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-06 12:31:59'),
(66, NULL, 'Login', 'Failed login attempt for username: asd.', '2024-12-06 12:35:40'),
(67, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 12:37:37'),
(68, NULL, 'Login', 'Failed login attempt for username: adas.', '2024-12-06 12:38:03'),
(69, NULL, 'Login', 'Failed login attempt for username: rafay.', '2024-12-06 12:38:18'),
(70, NULL, 'Login', 'Failed login attempt for username: sda.', '2024-12-06 12:50:32'),
(71, 37, 'Login', 'Successful login by user: new', '2024-12-06 13:10:53'),
(72, 36, 'Login', 'Successful login by user: hos', '2024-12-06 13:11:02'),
(73, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 13:11:17'),
(74, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 13:14:09'),
(80, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 13:18:56'),
(81, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 13:20:29'),
(82, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 13:23:34'),
(83, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 13:23:53'),
(84, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 14:58:13'),
(85, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 14:58:57'),
(86, 5, 'Update', 'User last_login timestamp updated.', '2024-12-06 14:58:57'),
(87, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-06 18:14:04'),
(88, 34, 'Login', 'Successful login by user: rafay', '2024-12-06 18:14:10'),
(89, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-06 18:19:32'),
(90, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-06 18:19:37'),
(91, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-06 18:19:40'),
(92, 30, 'Login', 'Successful login by user: shahzaib', '2024-12-06 18:19:43'),
(93, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 18:25:55'),
(94, 2, 'Update', 'User last_login timestamp updated.', '2024-12-06 18:25:55'),
(95, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 18:42:06'),
(96, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 18:42:13'),
(97, 2, 'Login', 'Successful login by user: wasey', '2024-12-06 18:42:26'),
(98, 5, 'Login', 'Successful login by user: hamza', '2024-12-06 18:42:31');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `donor_id` int(11) NOT NULL,
  `sender_role` enum('Donor','Admin') NOT NULL,
  `content` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `hospital_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `donor_id`, `sender_role`, `content`, `timestamp`, `hospital_id`, `is_read`) VALUES
(1, 20, 'Donor', 'Hello Admin', '2024-12-04 20:04:32', NULL, 0),
(2, 20, 'Donor', 'reply\r\n', '2024-12-04 20:25:42', NULL, 0),
(3, 2, 'Donor', 'hello admin', '2024-12-04 20:57:17', NULL, 0),
(4, 7, 'Donor', 'Hello admin', '2024-12-05 03:04:01', NULL, 0),
(5, 2, 'Admin', 'HI', '2024-12-05 03:19:11', NULL, 0),
(6, 9, 'Donor', 'hi admin', '2024-12-05 03:20:27', NULL, 0),
(7, 9, 'Admin', 'hi', '2024-12-05 03:20:47', NULL, 0),
(8, 9, 'Admin', 'hello', '2024-12-05 03:30:54', NULL, 0),
(11, 21, 'Donor', 'hello admin', '2024-12-05 05:02:47', NULL, 0),
(12, 21, 'Admin', 'hello', '2024-12-05 05:03:22', NULL, 0),
(15, 4, 'Donor', 'hi\r\n', '2024-12-05 09:11:32', NULL, 0),
(16, 4, 'Admin', 'klvjbk', '2024-12-05 09:12:00', NULL, 0),
(17, 23, 'Donor', 'hi', '2024-12-05 09:56:19', NULL, 0),
(18, 23, 'Admin', 'hi', '2024-12-05 09:56:58', NULL, 0),
(19, 2, 'Admin', 'hi\r\n', '2024-12-06 04:09:19', NULL, 0),
(20, 25, 'Donor', 'hi admin', '2024-12-06 06:01:36', NULL, 0),
(21, 25, 'Admin', 'hi', '2024-12-06 06:01:54', NULL, 0),
(22, 27, 'Donor', 'hi', '2024-12-06 06:38:06', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `donor_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `donor_id`, `message`, `created_at`) VALUES
(1, 19, 'Your appointment with hospital DOW HOSPITAL has been confirmed.', '2024-12-02 22:36:07'),
(2, 19, 'Your appointment with hospital DOW HOSPITAL has been rejected.', '2024-12-02 22:37:16'),
(3, 2, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-04 11:39:20'),
(4, 19, 'Your appointment with hospital DOW HOSPITAL has been rejected, please select different time and date.', '2024-12-04 14:47:49'),
(5, 19, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-04 14:48:16'),
(6, 20, 'Your appointment with hospital DOW HOSPITAL has been rejected, please select different time and date.', '2024-12-04 23:54:10'),
(7, 20, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-04 23:54:44'),
(8, 20, 'Your appointment with hospital DOW HOSPITAL has been rejected, please select different time and date.', '2024-12-04 23:59:58'),
(9, 20, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-05 00:00:35'),
(10, 2, 'Your appointment with hospital DOW HOSPITAL has been rejected, please select different time and date.', '2024-12-05 01:55:56'),
(11, 2, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-05 01:56:43'),
(12, 21, 'Your appointment with hospital Hospital Angeles has been confirmed, You can visit the Hospital.', '2024-12-05 10:00:57'),
(13, 21, 'Your appointment with hospital Hospital Angeles has been rejected, please select different time and date.', '2024-12-05 10:02:09'),
(14, 23, 'Your appointment with hospital DOW HOSPITAL has been rejected, please select different time and date.', '2024-12-05 14:55:55'),
(15, 2, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-06 09:09:37'),
(16, 25, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-06 11:03:14'),
(17, 27, 'Your appointment with hospital DOW HOSPITAL has been confirmed, You can visit the Hospital.', '2024-12-06 11:39:48');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `USER_ID` int(11) NOT NULL,
  `USERNAME` varchar(50) NOT NULL,
  `PASSWORD` varchar(255) NOT NULL,
  `ROLE` enum('Donor','Hospital','Admin') NOT NULL,
  `EMAIL` varchar(100) NOT NULL,
  `CREATED_AT` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`USER_ID`, `USERNAME`, `PASSWORD`, `ROLE`, `EMAIL`, `CREATED_AT`, `last_login`, `active`) VALUES
(2, 'wasey', 'scrypt:32768:8:1$OswK8iEpFUhQb8v4$2b1374f456af861094262ed69476365032d6500a9459182d4c58c3065c90edb16b8e7514647b4a780680809f3a96977d38ea3bd232c2c10bcc3c33544d281600', 'Donor', 'wasey@bd', '2024-11-23 13:34:19', '2024-12-06 18:25:55', 1),
(4, 'salik', 'scrypt:32768:8:1$xXuNPt5Zhi6ITVdq$537a3c6302ef9b860d9287ff48fbf6d2ccb6c2cb7be4c194f3a59faf4efdae5088da4deaad3eadc6c8442215a6633ae3ed2328d5aee3771f96229068ce631cdb', 'Donor', 'salik@bd', '2024-11-23 13:37:06', '2024-12-05 14:10:40', 1),
(5, 'hamza', 'scrypt:32768:8:1$iRG6QDJwDPc79HMg$e8be6096057e9617342592ad0917d87f1f3d52366f01c2ba54ff07c8d57625dbdf29496edaf024ac1697082fa330d8ff501f20e31814bc42c0ad827a43f2afc8', 'Donor', 'hamza@bdd', '2024-11-23 13:38:37', '2024-12-06 14:58:57', 1),
(6, 'omer', 'scrypt:32768:8:1$54jv4YSiJVLX6KRw$6a1d5dd5c930434ea5b6355a38eda3f01d177c7d6d1c5d192cc868cf3f33d37d228c2c0bc1f7ab3fb573bb026d2cb91756f33b3e76172a58ce9385ba429a816e', 'Donor', 'omer@bloodbank', '2024-11-23 13:39:37', NULL, 1),
(7, 'mani', 'scrypt:32768:8:1$HPcUDFCaOlJp5wjb$e54a760477af709c9a638354b2c4a5beafdd6bdeb2c1631d761bdd85a1c8163121c368783bf261d7cf99d10c676e74044eab46e9d09b21f8b5d1704e6b1a7435', 'Donor', 'mani@muhib', '2024-11-23 13:40:35', NULL, 1),
(9, 'taha', 'scrypt:32768:8:1$Y57riKGTJFqhPBzW$2ccadd048453c468d89a1f10f6523b38e8d4948389c513c57b9cea94932763aa681007dc33ccec390e07b9f5d4ae8078f676a3e1b01ad54712485058d23d7c0f', 'Donor', 'taha@bd', '2024-11-23 14:39:57', '2024-12-05 13:47:15', 1),
(10, 'dow', 'scrypt:32768:8:1$4kBygbnAkbee2dMK$366ecbdbc11f92d03312fcb3bdf06d3f0c768f6cf5dd8dd5ada2354aac9cb99d6115ac28716a4a490790c19e51908e955c7f53154ade9f22c1bb4c9f68aa7600', 'Hospital', 'dow@ojha.com', '2024-11-23 14:42:13', '2024-12-06 11:39:20', 1),
(13, 'jinnah', 'scrypt:32768:8:1$cR3fZxfpXwT2uund$a0e6a9f54b9bcce1e35ee09beda9695a98c87c854d467611346fc359dfac8d075f37d0fccdf5f4ebc94edcf0ada5637058b2b2c82727a34de1f4e17935a3ba98', 'Hospital', 'jinnah@bd', '2024-11-24 13:22:17', NULL, 1),
(14, 'sabeer', 'scrypt:32768:8:1$Kc2XpQ3r4r8zv2nV$1d6cfb96e187a816413230d33cd0716c5cb592763d1828ed0e49b741cb05e9ddc7bf06301499d3b9630cf94d89379fa4ef2c1aaec33f9453164cbaac9fc3920d', 'Donor', 'sabeer@bd', '2024-11-24 16:00:05', NULL, 1),
(17, 'td', 'scrypt:32768:8:1$djhTwmiA1kdJEKDc$788963b44a7c7ee869addcd9b9776f1dace9c21b9eb37ca2637bd1c3f6ab58b79510cdedb7b6098fc5cbfe96afe92c74a73845b58b19427e275a618fc85dfcb3', 'Donor', 'td@bd', '2024-11-24 16:37:06', NULL, 1),
(18, 'nehal', 'scrypt:32768:8:1$ZSKfk5eJWuFCp2VB$70c77ffe3a312ce995e7ba386e08ba9fa285e6195c01500f8e7c3f91e1be8016ba476b953f77e1134d9a51cfa6d97ef3e7893b58361f9608a4f550be075c91d4', 'Hospital', 'nehal@bd', '2024-11-24 16:41:01', NULL, 1),
(19, 'abm', 'scrypt:32768:8:1$vhTDIdJ5Az6FIj4R$53a18167df1035bba5e04b1d2d5e11960f5e90f54fc27eae0314bf90878ed1e9398f9a59fc33f0571004ab614da873bc2e2a1be15c041ca19621fc6a83185011', 'Donor', 'abmarmy@bd', '2024-11-25 04:13:54', NULL, 1),
(20, 'asghar', 'scrypt:32768:8:1$xUf0Ys0iLsPs8Vk3$cbb34156ffa26acd2930ec82f184d7c6e3d9cda59ff853753dccaa4bde62b8e4d19c2f0854d7ef830686c2a82b2e8a297b0c67b252f96b80dce0df13d411ccde', 'Donor', 'asghar@bd', '2024-11-27 09:26:22', NULL, 1),
(22, 'saad', 'scrypt:32768:8:1$tQuNtqjJQVPxBG4K$3da71c52b667a5df15387609fbc2f4a39f98693cf9dff5ed18eaf94add8ad056b1236aaee6b5a72cc35ae5eecab17b465cdef9967c2824155e60cdeb2410b0f0', 'Donor', 'saad@bd', '2024-11-27 18:14:33', '2024-12-05 13:45:27', 1),
(23, 'hm', 'scrypt:32768:8:1$d8uIQDDKspYNNE1r$0714096802b165f8b605e5947f4195ef6b3e44c7d69106e6b030feea7962012ecc5930def1743f284e4cf1e8e32b6144b1b6c6817fca0e8e5f749080e2e47f98', 'Hospital', 'hm@bd', '2024-11-27 18:17:37', NULL, 1),
(24, 'ln', 'scrypt:32768:8:1$L9FVhVlMor2Ix0Vw$a63963f32a966225a291b5037fb8ac76c0ac17a47cda753e11dddcb6df83f82b72ffc2af9c4d51ce2e072eade5d253a256e55a2ae6e0d3382b085d4d6ea19467', 'Hospital', 'ln@db', '2024-11-27 18:25:48', NULL, 1),
(25, 'asad', 'scrypt:32768:8:1$HikNYvCeDt9rmiVM$e579f558be3578b6aa66027fe3689f4c94a4d4d91732d47bac3ade71fbf598d144429654e5829dfd565bea575c286f832a198cf7f21339976fb57c480189e457', 'Donor', 'asad@bd', '2024-11-29 11:20:11', NULL, 1),
(26, 'usman', 'scrypt:32768:8:1$37ARsz1kb2OD0yGD$84182a9cdbc7a73694c46028dec3473bc33cda14cdfa01d43fc3144111014a54ba6628f6e50c061bcf150e9e32215054a30b1fb4c70d9e912d466741ba373e1e', 'Donor', 'usman@bd', '2024-12-04 18:41:26', NULL, 1),
(27, 'ronaldo', 'scrypt:32768:8:1$DRChaaWeIMZANm5E$1809fc03cf219900be230927bb4479f64033b5d5bb669d40ecfb0002cf28c0e9356c7d706938a0ef18ea0d77d5424f5e845492dd359910221599fb78c8fedf03', 'Donor', 'ronaldo@bd', '2024-12-05 03:46:51', NULL, 1),
(28, 'angeles', 'scrypt:32768:8:1$OaVZOK0PofK5aJFk$7a381488f44a309843d472b79e315f64b3e61099b0dc4dd26de28e4bca806c76d0e17e1fd164f378f6e22bb45e6c0ecc181b46d46b32feeb64695e430f810764', 'Hospital', 'angeles@bd', '2024-12-05 03:48:49', NULL, 1),
(30, 'shahzaib', 'scrypt:32768:8:1$IU2sg7FQ8GSFJtPK$19e37fcff73411d88e10089fbf13ae0dee3dd90fc9aa10daf37f8cc5ff9289a670c68b5649ca10ff929a2a8af478631b8a9c6b7ecbe38840c05b38b72ba9e72b', 'Donor', 'sha@bd', '2024-12-05 09:54:22', '2024-12-05 14:56:07', 1),
(32, 'ayan', 'scrypt:32768:8:1$GhznAJWvny7JKBkV$b3e638fcfc0be99ccc6ac51d256225cbe6d31a5dbcb902381d822b090f2133a01eee286d6eafeacfaa757ad6f642f01686b95af8619690f5a1d2adf3773dd478', 'Donor', 'ayan@bd', '2024-12-06 05:37:35', NULL, 1),
(33, 'taha123', 'scrypt:32768:8:1$OBrJey2Qy3MX5PRP$5cb175d13196db4a02bd196744fd664f0898995633ed644c408829b46043ef60fef3782c5e9a1fb8d820d0f8dc279d89383d9c0805bdf3ab1c791e2dfc97229d', 'Donor', 'tahaimtiaz@bd', '2024-12-06 05:41:45', '2024-12-06 11:03:23', 1),
(34, 'rafay', 'scrypt:32768:8:1$PYkHI8Nk39SzIhyh$cfe713467620a81cd5566db0adc82dacb7273589fa14e8b3502de05f752355512a7456f98fa09df2079f3fa0a30d09ccb76527ee4094c5558ca93b6c9cc999df', 'Donor', 'rafay@bd', '2024-12-06 05:47:29', '2024-12-06 10:52:30', 1),
(35, 'fatima', 'scrypt:32768:8:1$YD8DqmBRHvngol1W$c9b60e7990e01920a85c2e893a1a4181c44b800fb7712db862e9b7d378fee35e1c9149d61701e837ece949c370071b04a7ed03165c0aa4921748274455324c78', 'Donor', 'fatima@bd', '2024-12-06 06:36:07', '2024-12-06 11:40:00', 1),
(36, 'hos', 'scrypt:32768:8:1$BXCQqCsSvofZ1jad$f4973c1854b8386d12354916e68e6043e2a28e222b4f40a2dfe691107668a886b0b084e1deb8b5a004c0eac68411f0d73dad52fd25bb127744bbdaf45c3c0f9f', 'Hospital', 'hospital@bd', '2024-12-06 08:07:05', '2024-12-06 13:11:02', 1),
(37, 'new', 'scrypt:32768:8:1$jAN3InZv6YlJTPQi$71dae5df507c9eec6591033feef3617f5025abe0a71d438f8ed776d42f612b1fe7054fee5efd5ab51255e982ab472a9f0e900dbe4d98f5ee0769affed48ff180', 'Donor', 'new@bd', '2024-12-06 08:10:40', '2024-12-06 13:10:53', 1);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `after_user_login` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    IF NEW.last_login IS NOT NULL THEN
        INSERT INTO Logs (user_id, event_type, description)
        VALUES (NEW.user_id, 'Login', CONCAT('Successful login by user: ', NEW.username));
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_users_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    IF OLD.last_login != NEW.last_login THEN
        INSERT INTO Logs (user_id, event_type, description)
        VALUES (NEW.user_id, 'Update', 'User last_login timestamp updated.');
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`APPOINTMENT_ID`),
  ADD KEY `DONOR_ID` (`DONOR_ID`),
  ADD KEY `HOSPITAL_ID` (`HOSPITAL_ID`);

--
-- Indexes for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD PRIMARY KEY (`REQUEST_ID`),
  ADD KEY `HOSPITAL_ID` (`HOSPITAL_ID`),
  ADD KEY `BLOOD_TYPE` (`BLOOD_TYPE`);

--
-- Indexes for table `blood_types`
--
ALTER TABLE `blood_types`
  ADD PRIMARY KEY (`BLOOD_TYPE`);

--
-- Indexes for table `donors`
--
ALTER TABLE `donors`
  ADD PRIMARY KEY (`donor_id`),
  ADD UNIQUE KEY `USER_ID` (`USER_ID`),
  ADD KEY `LOCATION_ID` (`LOCATION_ID`);

--
-- Indexes for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD PRIMARY KEY (`HOSPITAL_ID`),
  ADD UNIQUE KEY `USER_ID` (`USER_ID`),
  ADD KEY `LOCATION_ID` (`LOCATION_ID`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`LOCATION_ID`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `donor_id` (`donor_id`),
  ADD KEY `messages_hospital_fk` (`hospital_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `donor_id` (`donor_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`USER_ID`),
  ADD UNIQUE KEY `USERNAME` (`USERNAME`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `APPOINTMENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `blood_requests`
--
ALTER TABLE `blood_requests`
  MODIFY `REQUEST_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `donors`
--
ALTER TABLE `donors`
  MODIFY `donor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `HOSPITAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `LOCATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`DONOR_ID`) REFERENCES `donors` (`DONOR_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`HOSPITAL_ID`) REFERENCES `hospitals` (`HOSPITAL_ID`) ON DELETE CASCADE;

--
-- Constraints for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD CONSTRAINT `blood_requests_ibfk_1` FOREIGN KEY (`HOSPITAL_ID`) REFERENCES `hospitals` (`HOSPITAL_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `blood_requests_ibfk_2` FOREIGN KEY (`BLOOD_TYPE`) REFERENCES `blood_types` (`BLOOD_TYPE`) ON DELETE CASCADE;

--
-- Constraints for table `donors`
--
ALTER TABLE `donors`
  ADD CONSTRAINT `donors_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `users` (`USER_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `donors_ibfk_2` FOREIGN KEY (`LOCATION_ID`) REFERENCES `locations` (`LOCATION_ID`) ON DELETE SET NULL;

--
-- Constraints for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD CONSTRAINT `hospitals_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `users` (`USER_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `hospitals_ibfk_2` FOREIGN KEY (`LOCATION_ID`) REFERENCES `locations` (`LOCATION_ID`) ON DELETE SET NULL;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`USER_ID`) ON DELETE SET NULL;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_hospital_fk` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`HOSPITAL_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`donor_id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`donor_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
