-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2024 at 04:51 AM
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
  `STATUS` enum('Pending','Confirmed','Completed','Cancelled') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`APPOINTMENT_ID`, `DONOR_ID`, `HOSPITAL_ID`, `DATE`, `TIME`, `STATUS`) VALUES
(8, 14, 3, '2024-11-25', '12:45:00', 'Confirmed'),
(9, 14, 3, '2024-11-25', '13:01:00', 'Confirmed'),
(10, 7, 1, '2024-11-26', '02:06:00', 'Confirmed'),
(11, 5, 1, '2024-11-19', '11:10:00', 'Confirmed'),
(12, 6, 1, '2024-11-19', '11:55:00', 'Confirmed'),
(13, 5, 1, '2024-11-29', '11:33:00', 'Confirmed'),
(14, 16, 1, '2024-11-28', '19:28:00', 'Confirmed'),
(15, 2, 1, '2024-11-25', '18:32:00', 'Confirmed'),
(16, 2, 1, '2024-11-18', '18:42:00', 'Confirmed'),
(17, 2, 1, '2024-11-28', '14:46:00', 'Confirmed'),
(18, 2, 1, '2024-11-28', '14:46:00', 'Confirmed'),
(19, 5, 1, '2024-11-28', '19:46:00', 'Confirmed'),
(20, 9, 1, '2024-11-28', '18:50:00', 'Confirmed'),
(21, 16, 1, '2024-11-18', '18:52:00', 'Pending'),
(22, 5, 1, '2024-11-29', '21:56:00', 'Pending'),
(23, 5, 1, '2024-11-17', '21:58:00', 'Pending'),
(24, 5, 1, '2024-11-28', '12:15:00', 'Pending');

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
  `STATUS` enum('Open','Fulfilled','Closed') DEFAULT 'Open'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_requests`
--

INSERT INTO `blood_requests` (`REQUEST_ID`, `HOSPITAL_ID`, `BLOOD_TYPE`, `QUANTITY`, `REQUESTED_DATE`, `STATUS`) VALUES
(20, 1, 'A+', 23, '2024-11-27', 'Fulfilled'),
(21, 1, 'A+', 123, '2024-11-27', 'Fulfilled'),
(22, 1, 'O+', 12, '2024-11-27', 'Fulfilled'),
(23, 1, 'B+', 21, '2024-11-27', 'Fulfilled'),
(24, 1, 'A-', 12, '2024-11-27', 'Open'),
(25, 1, 'A+', 22, '2024-11-27', 'Open'),
(26, 3, 'A+', 12, '2024-11-27', 'Open'),
(27, 1, 'A+', 23, '2024-11-27', 'Open'),
(28, 1, 'A+', 453, '2024-11-27', 'Open'),
(29, 1, 'A+', 123, '2024-11-27', 'Open');

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
  `BLOOD_TYPE` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donors`
--

INSERT INTO `donors` (`donor_id`, `USER_ID`, `NAME`, `CONTACT_INFO`, `MEDICAL_HISTORY`, `LOCATION_ID`, `BLOOD_TYPE`) VALUES
(2, 2, 'Wasey', '123', NULL, 1, 'A+'),
(4, 4, 'Salik Ahmed', '21211', NULL, 2, 'A+'),
(5, 5, 'Muhammad Hamza', '1232', NULL, 2, 'O+'),
(6, 6, 'Omer Khan', '12211', NULL, 1, 'B+'),
(7, 7, 'Muhib', '21211', NULL, 3, 'A+'),
(9, 9, 'Travis SHARIF', '0222123', NULL, 5, 'B+'),
(12, 14, 'Sabeer', '0313121', NULL, 9, 'A+'),
(14, 17, 'Talha Duration', '0303033', NULL, 11, 'A+'),
(15, 19, 'Abdullah masood', '12323123', NULL, 12, 'B-'),
(16, 20, 'Asghar Ali', '01312312', NULL, 8, 'B+'),
(18, 22, 'Saad Arshad', '123123', NULL, 8, 'A-');

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
  `PARENT_HOSPITAL` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospitals`
--

INSERT INTO `hospitals` (`HOSPITAL_ID`, `USER_ID`, `NAME`, `LOCATION_ID`, `CONTACT_INFO`, `PARENT_HOSPITAL`) VALUES
(1, 10, 'DUHS', 6, '', NULL),
(2, 13, 'Jinnah', 8, '', NULL),
(3, 18, 'NEHALS', 10, '12321', NULL),
(4, 23, 'Hajmola dawakhana', 8, '', NULL),
(5, 24, 'Liaqat National', 8, '', NULL);

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
(13, NULL, 'Hyderabad', 'Sindh', '742223');

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
  `CREATED_AT` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`USER_ID`, `USERNAME`, `PASSWORD`, `ROLE`, `EMAIL`, `CREATED_AT`) VALUES
(2, 'wasey', 'scrypt:32768:8:1$OswK8iEpFUhQb8v4$2b1374f456af861094262ed69476365032d6500a9459182d4c58c3065c90edb16b8e7514647b4a780680809f3a96977d38ea3bd232c2c10bcc3c33544d281600', 'Donor', 'wasey@bd', '2024-11-23 13:34:19'),
(4, 'salik', 'scrypt:32768:8:1$xXuNPt5Zhi6ITVdq$537a3c6302ef9b860d9287ff48fbf6d2ccb6c2cb7be4c194f3a59faf4efdae5088da4deaad3eadc6c8442215a6633ae3ed2328d5aee3771f96229068ce631cdb', 'Donor', 'salik@bd', '2024-11-23 13:37:06'),
(5, 'hamza', 'scrypt:32768:8:1$iRG6QDJwDPc79HMg$e8be6096057e9617342592ad0917d87f1f3d52366f01c2ba54ff07c8d57625dbdf29496edaf024ac1697082fa330d8ff501f20e31814bc42c0ad827a43f2afc8', 'Donor', 'hamza@bdd', '2024-11-23 13:38:37'),
(6, 'omer', 'scrypt:32768:8:1$54jv4YSiJVLX6KRw$6a1d5dd5c930434ea5b6355a38eda3f01d177c7d6d1c5d192cc868cf3f33d37d228c2c0bc1f7ab3fb573bb026d2cb91756f33b3e76172a58ce9385ba429a816e', 'Donor', 'omer@bloodbank', '2024-11-23 13:39:37'),
(7, 'mani', 'scrypt:32768:8:1$HPcUDFCaOlJp5wjb$e54a760477af709c9a638354b2c4a5beafdd6bdeb2c1631d761bdd85a1c8163121c368783bf261d7cf99d10c676e74044eab46e9d09b21f8b5d1704e6b1a7435', 'Donor', 'mani@muhib', '2024-11-23 13:40:35'),
(9, 'taha', 'scrypt:32768:8:1$Y57riKGTJFqhPBzW$2ccadd048453c468d89a1f10f6523b38e8d4948389c513c57b9cea94932763aa681007dc33ccec390e07b9f5d4ae8078f676a3e1b01ad54712485058d23d7c0f', 'Donor', 'taha@bd', '2024-11-23 14:39:57'),
(10, 'dow', 'scrypt:32768:8:1$4kBygbnAkbee2dMK$366ecbdbc11f92d03312fcb3bdf06d3f0c768f6cf5dd8dd5ada2354aac9cb99d6115ac28716a4a490790c19e51908e955c7f53154ade9f22c1bb4c9f68aa7600', 'Hospital', 'dow@ojha', '2024-11-23 14:42:13'),
(13, 'jinnah', 'scrypt:32768:8:1$cR3fZxfpXwT2uund$a0e6a9f54b9bcce1e35ee09beda9695a98c87c854d467611346fc359dfac8d075f37d0fccdf5f4ebc94edcf0ada5637058b2b2c82727a34de1f4e17935a3ba98', 'Hospital', 'jinnah@bd', '2024-11-24 13:22:17'),
(14, 'sabeer', 'scrypt:32768:8:1$Kc2XpQ3r4r8zv2nV$1d6cfb96e187a816413230d33cd0716c5cb592763d1828ed0e49b741cb05e9ddc7bf06301499d3b9630cf94d89379fa4ef2c1aaec33f9453164cbaac9fc3920d', 'Donor', 'sabeer@bd', '2024-11-24 16:00:05'),
(17, 'td', 'scrypt:32768:8:1$djhTwmiA1kdJEKDc$788963b44a7c7ee869addcd9b9776f1dace9c21b9eb37ca2637bd1c3f6ab58b79510cdedb7b6098fc5cbfe96afe92c74a73845b58b19427e275a618fc85dfcb3', 'Donor', 'td@bd', '2024-11-24 16:37:06'),
(18, 'nehal', 'scrypt:32768:8:1$ZSKfk5eJWuFCp2VB$70c77ffe3a312ce995e7ba386e08ba9fa285e6195c01500f8e7c3f91e1be8016ba476b953f77e1134d9a51cfa6d97ef3e7893b58361f9608a4f550be075c91d4', 'Hospital', 'nehal@bd', '2024-11-24 16:41:01'),
(19, 'abm', 'scrypt:32768:8:1$vhTDIdJ5Az6FIj4R$53a18167df1035bba5e04b1d2d5e11960f5e90f54fc27eae0314bf90878ed1e9398f9a59fc33f0571004ab614da873bc2e2a1be15c041ca19621fc6a83185011', 'Donor', 'abmarmy@bd', '2024-11-25 04:13:54'),
(20, 'asghar', 'scrypt:32768:8:1$xUf0Ys0iLsPs8Vk3$cbb34156ffa26acd2930ec82f184d7c6e3d9cda59ff853753dccaa4bde62b8e4d19c2f0854d7ef830686c2a82b2e8a297b0c67b252f96b80dce0df13d411ccde', 'Donor', 'asghar@bd', '2024-11-27 09:26:22'),
(22, 'saad', 'scrypt:32768:8:1$tQuNtqjJQVPxBG4K$3da71c52b667a5df15387609fbc2f4a39f98693cf9dff5ed18eaf94add8ad056b1236aaee6b5a72cc35ae5eecab17b465cdef9967c2824155e60cdeb2410b0f0', 'Donor', 'saad@bd', '2024-11-27 18:14:33'),
(23, 'hm', 'scrypt:32768:8:1$d8uIQDDKspYNNE1r$0714096802b165f8b605e5947f4195ef6b3e44c7d69106e6b030feea7962012ecc5930def1743f284e4cf1e8e32b6144b1b6c6817fca0e8e5f749080e2e47f98', 'Hospital', 'hm@bd', '2024-11-27 18:17:37'),
(24, 'ln', 'scrypt:32768:8:1$L9FVhVlMor2Ix0Vw$a63963f32a966225a291b5037fb8ac76c0ac17a47cda753e11dddcb6df83f82b72ffc2af9c4d51ce2e072eade5d253a256e55a2ae6e0d3382b085d4d6ea19467', 'Hospital', 'ln@db', '2024-11-27 18:25:48');

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
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`USER_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `APPOINTMENT_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `blood_requests`
--
ALTER TABLE `blood_requests`
  MODIFY `REQUEST_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `donors`
--
ALTER TABLE `donors`
  MODIFY `donor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `HOSPITAL_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `LOCATION_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `USER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
