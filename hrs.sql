-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 24, 2025 at 08:09 AM
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
-- Database: `hrs`
--

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` int(11) NOT NULL,
  `strategy_id` int(11) NOT NULL,
  `activity` text NOT NULL,
  `kpi` varchar(255) DEFAULT NULL,
  `target` varchar(255) DEFAULT NULL,
  `Y1` decimal(10,2) DEFAULT NULL,
  `Y2` decimal(10,2) DEFAULT NULL,
  `Y3` decimal(10,2) DEFAULT NULL,
  `Y4` decimal(10,2) DEFAULT NULL,
  `Y5` decimal(10,2) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `strategy_id`, `activity`, `kpi`, `target`, `Y1`, `Y2`, `Y3`, `Y4`, `Y5`, `comment`, `created_at`, `updated_at`) VALUES
(1, 3, '\"Conduct customer \r\nsatisfaction survey \r\nImplementation of \r\ncustomer satisfaction \r\nsurveys \r\nrecommendations   \"', '\"Number  of  customer  surveys \"', '\"85%\"', 0.00, 0.00, 0.00, 0.00, 0.00, '', '2025-09-08 12:11:24', '2025-09-12 06:03:45'),
(2, 3, 'Implement MultiChannel Support (e.g., phone, chat, email, social media) ', 'Function  ing call  centre ', '2', 0.50, 0.00, 0.00, 0.00, 0.00, '', '2025-09-08 12:14:34', '2025-10-13 13:27:56');

-- --------------------------------------------------------

--
-- Table structure for table `allowance_types`
--

CREATE TABLE `allowance_types` (
  `allowance_type_id` int(11) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `allowance_types`
--

INSERT INTO `allowance_types` (`allowance_type_id`, `type_name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'House Allowance', 'Allowance for housing expenses', 1, '2025-08-29 09:21:33', '2025-08-29 09:21:33'),
(2, 'Commuter Allowance', 'Allowance for transportation costs', 1, '2025-08-29 09:21:33', '2025-08-29 09:21:33'),
(5, 'Leave Allowance', 'Allocated to employees on annual leave', 1, '2025-09-01 13:01:08', '2025-09-01 13:01:41'),
(6, 'Dirty Allowance', 'Allocated to employees whose designation involves a dirty environment', 1, '2025-09-01 13:02:27', '2025-09-01 13:02:27');

-- --------------------------------------------------------

--
-- Table structure for table `appraisal_cycles`
--

CREATE TABLE `appraisal_cycles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','inactive','completed') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appraisal_cycles`
--

INSERT INTO `appraisal_cycles` (`id`, `name`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Q4 2025/2026 Performance Review', '2026-04-01', '2026-06-30', 'active', '2025-08-11 11:29:14', '2025-08-11 13:55:02'),
(2, 'Q1 2025/2026 Performance Review', '2025-07-01', '2025-09-30', 'active', '2025-08-11 11:29:14', '2025-08-11 13:53:26'),
(3, 'Q2 2025/2026 Performance Review', '2025-10-01', '2025-12-31', 'active', '2025-08-11 11:29:14', '2025-08-11 13:53:36'),
(4, 'Annual Review 2025', '2025-01-01', '2025-12-31', 'active', '2025-08-11 11:29:14', '2025-08-11 11:29:14'),
(5, 'Q3 2025/2026 Performance Review', '2026-01-01', '2026-03-31', 'active', '2025-08-11 13:52:29', '2025-08-11 13:52:29'),
(6, 'Q1 2024/2025 Performance Review', '2024-07-01', '2024-09-30', 'active', '2024-08-01 07:00:00', '2025-09-04 06:54:13'),
(7, 'Q2 2024/2025 Performance Review', '2024-10-01', '2024-12-31', 'completed', '2024-11-01 07:00:00', '2025-08-15 07:47:04'),
(8, 'Mid-Year Review 2025', '2025-01-01', '2025-06-30', 'active', '2025-02-01 07:00:00', '2025-08-15 07:47:04');

-- --------------------------------------------------------

--
-- Table structure for table `appraisal_scores`
--

CREATE TABLE `appraisal_scores` (
  `id` int(11) NOT NULL,
  `employee_appraisal_id` int(11) NOT NULL,
  `performance_indicator_id` int(11) NOT NULL,
  `score` decimal(3,2) DEFAULT NULL,
  `appraiser_comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appraisal_scores`
--

INSERT INTO `appraisal_scores` (`id`, `employee_appraisal_id`, `performance_indicator_id`, `score`, `appraiser_comment`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 1.00, '', '2025-08-11 13:39:38', '2025-08-15 07:47:04'),
(2, 2, 2, 1.00, '', '2025-08-11 13:39:38', '2025-08-15 07:47:04'),
(3, 2, 3, 1.00, '', '2025-08-11 13:39:38', '2025-08-15 07:47:04'),
(4, 2, 4, 1.00, '', '2025-08-11 13:39:38', '2025-08-15 07:47:04'),
(5, 2, 5, 1.00, '', '2025-08-11 13:39:39', '2025-08-15 07:47:04'),
(6, 2, 6, 1.00, '', '2025-08-11 13:39:39', '2025-08-15 07:47:04'),
(7, 2, 7, 1.00, '', '2025-08-11 13:39:39', '2025-08-15 07:47:04'),
(8, 8, 1, 5.00, '', '2025-08-13 05:03:58', '2025-08-15 07:47:04'),
(9, 8, 2, 0.00, '', '2025-08-13 05:03:59', '2025-08-15 07:47:04'),
(10, 8, 3, 0.00, '', '2025-08-13 05:03:59', '2025-08-15 07:47:04'),
(11, 8, 4, 0.00, '', '2025-08-13 05:03:59', '2025-08-15 07:47:04'),
(12, 8, 5, 0.00, '', '2025-08-13 05:03:59', '2025-08-15 07:47:04'),
(13, 8, 6, 0.00, '', '2025-08-13 05:03:59', '2025-08-15 07:47:04'),
(14, 8, 7, 0.00, '', '2025-08-13 05:03:59', '2025-08-15 07:47:04'),
(15, 3, 1, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(16, 3, 2, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(18, 3, 3, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(19, 3, 4, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(20, 3, 5, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(21, 3, 6, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(22, 3, 7, 1.00, '', '2025-08-13 07:32:01', '2025-08-15 07:47:04'),
(135, 5, 1, 4.30, '', '2025-08-13 07:51:10', '2025-08-15 07:47:04'),
(136, 5, 2, 9.99, '', '2025-08-13 07:51:10', '2025-08-15 07:47:04'),
(138, 5, 3, 0.00, '', '2025-08-13 07:51:11', '2025-08-15 07:47:04'),
(139, 5, 4, 0.00, '', '2025-08-13 07:51:11', '2025-08-15 07:47:04'),
(140, 5, 5, 0.00, '', '2025-08-13 07:51:11', '2025-08-15 07:47:04'),
(141, 5, 6, 0.00, '', '2025-08-13 07:51:11', '2025-08-15 07:47:04'),
(142, 5, 7, 0.00, '', '2025-08-13 07:51:11', '2025-08-15 07:47:04'),
(199, 7, 1, 3.00, '', '2025-08-14 05:58:06', '2025-08-15 07:47:04'),
(200, 7, 2, 2.10, '', '2025-08-14 05:58:08', '2025-08-15 07:47:04'),
(201, 7, 3, 3.00, '', '2025-08-14 05:58:09', '2025-08-15 07:47:04'),
(202, 7, 4, 3.00, '', '2025-08-14 05:58:09', '2025-08-15 07:47:04'),
(203, 7, 5, 3.00, '', '2025-08-14 05:58:10', '2025-08-15 07:47:04'),
(204, 7, 6, 3.00, '', '2025-08-14 05:58:10', '2025-08-15 07:47:04'),
(205, 7, 7, 3.00, '', '2025-08-14 05:58:10', '2025-08-15 07:47:04'),
(311, 1, 1, 2.00, '', '2025-08-14 06:24:45', '2025-08-15 07:47:04'),
(312, 1, 2, 2.00, '', '2025-08-14 06:24:46', '2025-08-15 07:47:04'),
(313, 1, 3, 2.00, '', '2025-08-14 06:24:46', '2025-08-15 07:47:04'),
(314, 1, 4, 2.00, '', '2025-08-14 06:24:46', '2025-08-15 07:47:04'),
(315, 1, 5, 2.00, '', '2025-08-14 06:24:47', '2025-08-15 07:47:04'),
(316, 1, 6, 2.00, '', '2025-08-14 06:24:47', '2025-08-15 07:47:04'),
(317, 1, 7, 2.00, '', '2025-08-14 06:24:48', '2025-08-15 07:47:04'),
(381, 24, 1, 4.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(382, 24, 2, 3.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(383, 24, 3, 2.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(384, 24, 4, 3.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(385, 24, 5, 2.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(386, 24, 6, 2.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(387, 24, 7, 1.00, '', '2025-08-14 08:29:57', '2025-08-15 07:47:04'),
(451, 25, 1, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(452, 25, 2, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(453, 25, 3, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(454, 25, 4, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(455, 25, 5, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(456, 25, 6, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(457, 25, 7, 0.00, '', '2025-08-14 08:37:40', '2025-08-15 07:47:04'),
(458, 26, 1, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(459, 26, 2, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(460, 26, 3, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(461, 26, 4, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(462, 26, 5, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(463, 26, 6, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(464, 26, 7, 0.00, '', '2025-08-14 08:57:21', '2025-08-15 07:47:04'),
(465, 10, 1, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(466, 10, 2, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(467, 10, 3, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(468, 10, 4, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(469, 10, 5, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(470, 10, 6, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(471, 10, 7, 0.00, '', '2025-08-14 08:57:41', '2025-08-15 07:47:04'),
(472, 6, 1, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(473, 6, 2, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(474, 6, 3, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(475, 6, 4, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(476, 6, 5, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(477, 6, 6, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(478, 6, 7, 0.00, '', '2025-08-14 08:58:22', '2025-08-15 07:47:04'),
(486, 19, 1, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(487, 19, 2, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(488, 19, 3, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(489, 19, 4, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(490, 19, 5, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(491, 19, 6, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(492, 19, 7, 4.00, '', '2025-08-14 09:49:43', '2025-08-15 07:47:04'),
(528, 1, 9, 4.32, 'Good performance in Customer Service Excellence. Shows consistent effort and results.', '2025-08-11 12:08:07', '2025-08-15 07:47:04'),
(529, 3, 9, 3.79, 'Good performance in Customer Service Excellence. Shows consistent effort and results.', '2025-08-12 08:41:45', '2025-08-15 07:47:04'),
(530, 24, 9, 3.01, 'Good performance in Customer Service Excellence. Shows consistent effort and results.', '2025-08-14 08:29:44', '2025-08-15 07:47:04'),
(531, 1, 10, 4.68, 'Good performance in Technical Competency. Shows consistent effort and results.', '2025-08-11 12:08:07', '2025-08-15 07:47:04'),
(532, 3, 10, 3.38, 'Good performance in Technical Competency. Shows consistent effort and results.', '2025-08-12 08:41:45', '2025-08-15 07:47:04'),
(533, 24, 10, 3.83, 'Good performance in Technical Competency. Shows consistent effort and results.', '2025-08-14 08:29:44', '2025-08-15 07:47:04'),
(534, 1, 11, 4.03, 'Good performance in Leadership Potential. Shows consistent effort and results.', '2025-08-11 12:08:07', '2025-08-15 07:47:04'),
(535, 3, 11, 3.65, 'Good performance in Leadership Potential. Shows consistent effort and results.', '2025-08-12 08:41:45', '2025-08-15 07:47:04'),
(536, 24, 11, 3.16, 'Good performance in Leadership Potential. Shows consistent effort and results.', '2025-08-14 08:29:44', '2025-08-15 07:47:04'),
(537, 1, 12, 3.85, 'Good performance in Adaptability. Shows consistent effort and results.', '2025-08-11 12:08:07', '2025-08-15 07:47:04'),
(538, 3, 12, 4.77, 'Good performance in Adaptability. Shows consistent effort and results.', '2025-08-12 08:41:45', '2025-08-15 07:47:04'),
(539, 24, 12, 3.28, 'Good performance in Adaptability. Shows consistent effort and results.', '2025-08-14 08:29:44', '2025-08-15 07:47:04'),
(543, 33, 1, 5.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(544, 33, 2, 3.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(545, 33, 10, 3.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(546, 33, 3, 1.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(547, 33, 9, 1.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(548, 33, 4, 2.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(549, 33, 12, 1.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(550, 33, 5, 2.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(551, 33, 11, 2.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(552, 33, 6, 1.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(553, 33, 7, 2.00, '', '2025-08-15 12:00:51', '2025-08-15 12:01:07'),
(664, 4, 1, 3.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(665, 4, 2, 4.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(666, 4, 10, 4.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(667, 4, 3, 2.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(668, 4, 9, 3.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(669, 4, 4, 3.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(670, 4, 12, 3.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(671, 4, 5, 3.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(672, 4, 11, 3.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(673, 4, 6, 4.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(674, 4, 7, 2.00, '', '2025-08-15 12:33:23', '2025-08-15 12:33:44'),
(796, 28, 1, 3.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(797, 28, 2, 2.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(798, 28, 10, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(799, 28, 3, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(800, 28, 9, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(801, 28, 4, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(802, 28, 12, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(803, 28, 5, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(804, 28, 11, 4.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(805, 28, 6, 3.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(806, 28, 7, 3.00, '', '2025-08-15 12:34:05', '2025-08-15 12:34:26'),
(906, 37, 1, 3.00, '', '2025-08-15 12:34:56', '2025-08-15 12:35:10'),
(907, 37, 2, 2.00, '', '2025-08-15 12:34:56', '2025-08-15 12:35:10'),
(908, 37, 10, 3.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(909, 37, 3, 3.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(910, 37, 9, 3.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(911, 37, 4, 2.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(912, 37, 12, 2.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(913, 37, 5, 2.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(914, 37, 11, 2.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(915, 37, 6, 2.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(916, 37, 7, 2.00, '', '2025-08-15 12:34:57', '2025-08-15 12:35:10'),
(1027, 18, 1, 2.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:51'),
(1028, 18, 2, 2.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:51'),
(1029, 18, 10, 3.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:51'),
(1030, 18, 3, 3.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:51'),
(1031, 18, 9, 3.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:51'),
(1032, 18, 4, 3.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:52'),
(1033, 18, 12, 3.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:52'),
(1034, 18, 5, 2.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:52'),
(1035, 18, 11, 3.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:52'),
(1036, 18, 6, 4.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:52'),
(1037, 18, 7, 4.00, '', '2025-08-15 12:35:28', '2025-08-15 12:35:52'),
(1103, 38, 1, 1.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1104, 38, 2, 1.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1105, 38, 10, 1.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1106, 38, 3, 1.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1107, 38, 9, 1.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1108, 38, 4, 1.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1109, 38, 12, 2.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1110, 38, 5, 2.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1111, 38, 11, 2.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1112, 38, 6, 2.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1113, 38, 7, 2.00, '', '2025-08-15 12:36:12', '2025-08-15 12:36:27'),
(1224, 20, 1, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1225, 20, 2, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1226, 20, 10, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1227, 20, 3, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1228, 20, 9, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1229, 20, 4, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1230, 20, 12, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1231, 20, 5, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1232, 20, 11, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1233, 20, 6, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1234, 20, 7, 0.00, '', '2025-08-18 07:38:37', '2025-08-18 07:38:37'),
(1235, 39, 19, 2.00, 'good', '2025-08-22 12:11:00', '2025-08-22 12:12:14'),
(1236, 39, 20, 5.00, 'better', '2025-08-22 12:11:00', '2025-08-22 12:12:14'),
(1237, 39, 31, 4.00, 'extaordinary', '2025-08-22 12:11:00', '2025-08-22 12:12:14'),
(1238, 39, 30, 3.00, 'excellent', '2025-08-22 12:11:00', '2025-08-22 12:12:14'),
(1239, 39, 32, 2.00, 'good', '2025-08-22 12:11:00', '2025-08-22 12:12:14'),
(1240, 39, 33, 3.00, 'excellent', '2025-08-22 12:11:00', '2025-08-22 12:12:15'),
(1241, 39, 34, 2.00, 'better', '2025-08-22 12:11:00', '2025-08-22 12:12:15'),
(1333, 46, 19, 1.00, 'good', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1334, 46, 20, 2.00, 'excellent', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1335, 46, 31, 3.00, 'good', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1336, 46, 30, 2.00, 'good', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1337, 46, 32, 2.00, 'beter', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1338, 46, 33, 2.00, 'good improvement', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1339, 46, 34, 2.00, 'good improvement', '2025-08-22 12:12:29', '2025-08-22 12:13:16'),
(1431, 47, 19, 1.00, 'poor performance on team  performnce', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1432, 47, 20, 2.00, 'good', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1433, 47, 31, 2.00, 'better', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1434, 47, 30, 3.00, 'better', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1435, 47, 32, 2.00, 'good', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1436, 47, 33, 3.00, 'good', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1437, 47, 34, 2.00, 'poor', '2025-08-22 12:13:42', '2025-08-22 12:15:26'),
(1536, 31, 13, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1537, 31, 17, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1538, 31, 25, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1539, 31, 18, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1540, 31, 27, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1541, 31, 26, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1542, 31, 28, 5.00, '', '2025-08-24 12:59:26', '2025-08-24 12:59:33'),
(1543, 31, 29, 5.00, '', '2025-08-24 12:59:27', '2025-08-24 12:59:33'),
(1600, 56, 32, 4.00, '', '2025-08-25 11:21:08', '2025-08-25 11:21:30'),
(1601, 56, 33, 3.00, '', '2025-08-25 11:21:08', '2025-08-25 11:21:31'),
(1602, 56, 34, 2.00, '', '2025-08-25 11:21:08', '2025-08-25 11:21:31'),
(1603, 56, 20, 3.00, '', '2025-08-25 11:21:09', '2025-08-25 11:21:31'),
(1604, 56, 31, 2.00, '', '2025-08-25 11:21:09', '2025-08-25 11:21:31'),
(1605, 56, 30, 3.00, '', '2025-08-25 11:21:09', '2025-08-25 11:21:31'),
(1606, 56, 19, 2.00, '', '2025-08-25 11:21:09', '2025-08-25 11:21:31'),
(1649, 57, 32, 1.00, '', '2025-08-25 11:22:06', '2025-08-25 11:22:19'),
(1650, 57, 33, 2.00, '', '2025-08-25 11:22:06', '2025-08-25 11:22:19'),
(1651, 57, 34, 3.00, '', '2025-08-25 11:22:06', '2025-08-25 11:22:19'),
(1652, 57, 20, 3.00, '', '2025-08-25 11:22:06', '2025-08-25 11:22:19'),
(1653, 57, 31, 3.00, '', '2025-08-25 11:22:07', '2025-08-25 11:22:19'),
(1654, 57, 30, 4.00, '', '2025-08-25 11:22:07', '2025-08-25 11:22:19'),
(1655, 57, 19, 5.00, '', '2025-08-25 11:22:07', '2025-08-25 11:22:19'),
(1705, 58, 18, 2.00, '', '2025-09-03 08:11:07', '2025-09-03 08:11:23'),
(1706, 58, 27, 2.00, '', '2025-09-03 08:11:08', '2025-09-03 08:11:23'),
(1707, 58, 26, 2.00, '', '2025-09-03 08:11:08', '2025-09-03 08:11:23'),
(1708, 58, 17, 2.00, '', '2025-09-03 08:11:08', '2025-09-03 08:11:23'),
(1709, 58, 28, 2.00, '', '2025-09-03 08:11:08', '2025-09-03 08:11:23'),
(1710, 58, 29, 2.00, '', '2025-09-03 08:11:08', '2025-09-03 08:11:23'),
(1711, 58, 25, 2.00, '', '2025-09-03 08:11:09', '2025-09-03 08:11:24'),
(1712, 58, 13, 2.00, '', '2025-09-03 08:11:09', '2025-09-03 08:11:24'),
(1777, 49, 18, 0.00, '', '2025-09-03 13:06:08', '2025-09-03 13:06:08'),
(1778, 49, 27, 0.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1779, 49, 26, 0.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1780, 49, 17, 0.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1781, 49, 28, 0.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1782, 49, 29, 1.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1783, 49, 25, 0.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1784, 49, 13, 0.00, '', '2025-09-03 13:06:09', '2025-09-03 13:06:09'),
(1785, 59, 18, 2.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:06'),
(1786, 59, 27, 3.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:06'),
(1787, 59, 26, 3.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:07'),
(1788, 59, 17, 4.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:07'),
(1789, 59, 28, 5.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:07'),
(1790, 59, 29, 4.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:07'),
(1791, 59, 25, 3.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:07'),
(1792, 59, 13, 3.00, '', '2025-09-04 07:05:10', '2025-09-04 07:06:07'),
(1897, 68, 18, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1898, 68, 27, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1899, 68, 26, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1900, 68, 17, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1901, 68, 28, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1902, 68, 29, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1903, 68, 25, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1904, 68, 13, 2.00, '', '2025-09-10 09:12:37', '2025-09-10 09:13:03'),
(1969, 23, 18, 1.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1970, 23, 27, 3.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1971, 23, 26, 3.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1972, 23, 17, 4.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1973, 23, 28, 4.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1974, 23, 29, 5.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1975, 23, 25, 5.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(1976, 23, 13, 4.00, '', '2025-09-11 08:55:01', '2025-09-11 08:55:24'),
(2033, 69, 18, 1.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2034, 69, 27, 2.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2035, 69, 26, 3.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2036, 69, 17, 4.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2037, 69, 28, 3.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2038, 69, 29, 3.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2039, 69, 25, 4.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2040, 69, 13, 4.00, '', '2025-09-11 09:44:18', '2025-09-11 09:44:33'),
(2097, 67, 18, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2098, 67, 27, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2099, 67, 26, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2100, 67, 17, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2101, 67, 28, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2102, 67, 29, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2103, 67, 25, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2104, 67, 13, 0.00, '', '2025-09-11 09:52:33', '2025-09-11 09:52:33'),
(2105, 64, 18, 1.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2106, 64, 27, 2.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2107, 64, 26, 2.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2108, 64, 17, 3.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2109, 64, 28, 3.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2110, 64, 29, 4.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2111, 64, 25, 5.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32'),
(2112, 64, 13, 3.00, '', '2025-09-11 11:32:18', '2025-09-11 11:32:32');

-- --------------------------------------------------------

--
-- Table structure for table `appraisal_summary_cache`
--

CREATE TABLE `appraisal_summary_cache` (
  `id` int(11) NOT NULL,
  `appraisal_cycle_id` int(11) NOT NULL,
  `quarter` varchar(10) NOT NULL,
  `total_completed` int(11) DEFAULT 0,
  `average_score` decimal(5,2) DEFAULT 0.00,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appraisal_summary_cache`
--

INSERT INTO `appraisal_summary_cache` (`id`, `appraisal_cycle_id`, `quarter`, `total_completed`, `average_score`, `last_updated`) VALUES
(1, 1, 'Q2', 1, 41.07, '2025-08-15 07:47:04'),
(2, 3, 'Q4', 1, 56.15, '2025-08-15 07:47:04'),
(3, 5, 'Q1', 1, 55.05, '2025-08-15 07:47:04');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `user_role` varchar(50) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `old_values` text DEFAULT NULL,
  `new_values` text DEFAULT NULL,
  `description` text NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text NOT NULL,
  `url` text NOT NULL,
  `method` varchar(10) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `session_id` varchar(255) DEFAULT NULL,
  `execution_time` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `username`, `user_role`, `action_type`, `table_name`, `record_id`, `old_values`, `new_values`, `description`, `ip_address`, `user_agent`, `url`, `method`, `timestamp`, `session_id`, `execution_time`) VALUES
(1, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: login.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/login.php', 'POST', '2025-10-23 16:51:20', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(2, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/dashboard.php', 'GET', '2025-10-23 16:51:20', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(3, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:51:23', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(4, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: personal_profile.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/personal_profile.php', 'GET', '2025-10-23 16:51:28', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(5, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:51:28', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(6, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: leave_management.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/leave_management.php', 'GET', '2025-10-23 16:51:31', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(7, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:51:32', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(8, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: get_employee_leave_types.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/get_employee_leave_types.php?employee_id=367', 'GET', '2025-10-23 16:51:33', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(9, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: strategic_plan.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/strategic_plan.php?tab=goals', 'GET', '2025-10-23 16:51:34', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(10, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:51:35', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(11, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:51:41', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(12, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:51:55', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(13, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php', 'GET', '2025-10-23 16:51:55', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(14, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php', 'GET', '2025-10-23 16:53:55', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(15, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php?user_id=&action_type=PAGE_VIEW&table_name=&start_date=&end_date=', 'GET', '2025-10-23 16:54:30', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(16, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php', 'GET', '2025-10-23 16:58:07', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(17, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: strategic_plan.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/strategic_plan.php?tab=goals', 'GET', '2025-10-23 16:58:11', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(18, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:58:11', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(19, 300, 'Hezron Njoroge', 'dept_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: logout.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/logout.php', 'GET', '2025-10-23 16:58:14', 'lrgrkauf5094n1vgj7tdh4dc06', NULL),
(20, 0, 'system', 'guest', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: login.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/login.php?message=You+have+been+successfully+logged+out.', 'GET', '2025-10-23 16:58:14', '0sitf45kikud51ifnorp4duoop', NULL),
(21, 0, 'system', 'guest', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: login.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/login.php', 'POST', '2025-10-23 16:58:23', 'bs1gsj3r1g9391p13se4nj2uoa', NULL),
(22, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: login.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/login.php', 'POST', '2025-10-23 16:59:35', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(23, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/dashboard.php', 'GET', '2025-10-23 16:59:35', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(24, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:59:35', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(25, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: personal_profile.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/personal_profile.php', 'GET', '2025-10-23 16:59:38', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(26, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:59:41', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(27, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: leave_management.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/leave_management.php', 'GET', '2025-10-23 16:59:42', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(28, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:59:44', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(29, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: get_employee_leave_types.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/get_employee_leave_types.php?employee_id=388', 'GET', '2025-10-23 16:59:45', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(30, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php', 'GET', '2025-10-23 16:59:52', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(31, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: auth_check.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/auth_check.php', 'GET', '2025-10-23 16:59:52', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(32, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php?user_id=0&action_type=&table_name=&start_date=&end_date=', 'GET', '2025-10-23 17:00:29', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(33, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php?user_id=300&action_type=&table_name=&start_date=&end_date=', 'GET', '2025-10-23 17:00:33', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(34, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php?user_id=284&action_type=&table_name=&start_date=&end_date=', 'GET', '2025-10-23 17:00:41', 'ukeib9krt4rskdcntfmia9a9tf', NULL),
(35, 284, 'kangara Josephine', 'section_head', 'PAGE_VIEW', NULL, NULL, NULL, NULL, 'Viewed page: audit_dashboard.php', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'http://localhost/HRS/HRS/audit_dashboard.php?user_id=284&action_type=&table_name=&start_date=&end_date=', 'GET', '2025-10-24 08:50:44', 'ukeib9krt4rskdcntfmia9a9tf', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `banks`
--

CREATE TABLE `banks` (
  `bank_id` int(11) NOT NULL,
  `bank_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banks`
--

INSERT INTO `banks` (`bank_id`, `bank_name`) VALUES
(1, 'Equity'),
(2, 'Cooperative Bank'),
(3, 'KCB bank'),
(4, 'FAMILY BANK'),
(5, 'NCBA BANK');

-- --------------------------------------------------------

--
-- Stand-in structure for view `completed_appraisals_view`
-- (See below for the actual view)
--
CREATE TABLE `completed_appraisals_view` (
`id` int(11)
,`employee_id` int(11)
,`appraiser_id` int(11)
,`appraisal_cycle_id` int(11)
,`employee_comment` text
,`employee_comment_date` timestamp
,`submitted_at` timestamp
,`status` enum('draft','awaiting_employee','submitted','completed','awaiting_submission')
,`created_at` timestamp
,`updated_at` timestamp
,`cycle_name` varchar(100)
,`start_date` date
,`end_date` date
,`first_name` varchar(100)
,`last_name` varchar(100)
,`emp_id` varchar(50)
,`designation` varchar(50)
,`department_name` varchar(100)
,`section_name` varchar(100)
,`appraiser_first_name` varchar(100)
,`appraiser_last_name` varchar(100)
,`quarter` varchar(7)
,`average_score_percentage` decimal(14,10)
);

-- --------------------------------------------------------

--
-- Table structure for table `deduction_audit_log`
--

CREATE TABLE `deduction_audit_log` (
  `id` int(11) NOT NULL,
  `deduction_id` int(11) NOT NULL,
  `action` enum('created','updated','deleted') NOT NULL,
  `performed_by` int(11) NOT NULL,
  `action_date` datetime DEFAULT current_timestamp(),
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deduction_audit_log`
--

INSERT INTO `deduction_audit_log` (`id`, `deduction_id`, `action`, `performed_by`, `action_date`, `details`) VALUES
(1, 2, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(2, 3, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(3, 4, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(4, 5, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(5, 6, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(6, 7, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(7, 8, 'created', 135, '2025-10-02 14:11:45', 'Deduction created via enhanced form'),
(8, 9, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(9, 10, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(10, 11, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(11, 12, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(12, 13, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(13, 14, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(14, 15, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(15, 16, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(16, 17, 'created', 135, '2025-10-02 14:11:46', 'Deduction created via enhanced form'),
(17, 18, 'created', 135, '2025-10-02 14:11:47', 'Deduction created via enhanced form'),
(18, 19, 'created', 135, '2025-10-02 14:11:47', 'Deduction created via enhanced form'),
(19, 20, 'created', 135, '2025-10-02 14:11:48', 'Deduction created via enhanced form'),
(20, 21, 'created', 135, '2025-10-02 14:13:18', 'Deduction created via enhanced form'),
(21, 22, 'created', 135, '2025-10-02 14:13:18', 'Deduction created via enhanced form'),
(22, 23, 'created', 135, '2025-10-02 14:13:18', 'Deduction created via enhanced form'),
(23, 24, 'created', 135, '2025-10-02 14:13:18', 'Deduction created via enhanced form'),
(24, 25, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(25, 26, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(26, 27, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(27, 28, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(28, 29, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(29, 30, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(30, 31, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(31, 32, 'created', 135, '2025-10-02 14:13:19', 'Deduction created via enhanced form'),
(32, 33, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(33, 34, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(34, 35, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(35, 36, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(36, 37, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(37, 38, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(38, 39, 'created', 135, '2025-10-02 14:13:20', 'Deduction created via enhanced form'),
(39, 40, 'created', 135, '2025-10-02 14:15:16', 'Deduction created via enhanced form'),
(40, 41, 'created', 135, '2025-10-02 14:20:35', 'Deduction created via enhanced form'),
(41, 42, 'created', 135, '2025-10-02 14:20:36', 'Deduction created via enhanced form'),
(42, 43, 'created', 135, '2025-10-02 14:20:36', 'Deduction created via enhanced form'),
(43, 44, 'created', 135, '2025-10-02 14:20:36', 'Deduction created via enhanced form'),
(44, 45, 'created', 135, '2025-10-02 14:20:36', 'Deduction created via enhanced form'),
(45, 46, 'created', 135, '2025-10-02 14:20:36', 'Deduction created via enhanced form'),
(46, 47, 'created', 135, '2025-10-02 14:20:36', 'Deduction created via enhanced form'),
(47, 48, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(48, 49, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(49, 50, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(50, 51, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(51, 52, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(52, 53, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(53, 54, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(54, 55, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(55, 56, 'created', 135, '2025-10-02 14:20:37', 'Deduction created via enhanced form'),
(56, 57, 'created', 135, '2025-10-02 14:20:38', 'Deduction created via enhanced form'),
(57, 58, 'created', 135, '2025-10-02 14:20:38', 'Deduction created via enhanced form'),
(58, 59, 'created', 135, '2025-10-02 14:20:38', 'Deduction created via enhanced form'),
(59, 60, 'created', 135, '2025-10-02 14:36:05', 'Deduction created via enhanced form'),
(60, 61, 'created', 135, '2025-10-02 14:36:06', 'Deduction created via enhanced form'),
(61, 62, 'created', 135, '2025-10-02 14:36:06', 'Deduction created via enhanced form'),
(62, 63, 'created', 135, '2025-10-02 14:36:06', 'Deduction created via enhanced form'),
(63, 64, 'created', 135, '2025-10-02 14:36:06', 'Deduction created via enhanced form'),
(64, 65, 'created', 135, '2025-10-02 14:36:06', 'Deduction created via enhanced form'),
(65, 66, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(66, 67, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(67, 68, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(68, 69, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(69, 70, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(70, 71, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(71, 72, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(72, 73, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(73, 74, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(74, 75, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(75, 76, 'created', 135, '2025-10-02 14:36:07', 'Deduction created via enhanced form'),
(76, 77, 'created', 135, '2025-10-02 14:36:08', 'Deduction created via enhanced form'),
(77, 78, 'created', 135, '2025-10-02 14:36:08', 'Deduction created via enhanced form'),
(78, 79, 'created', 135, '2025-10-02 14:39:53', 'Deduction created via enhanced form'),
(79, 80, 'created', 135, '2025-10-02 15:26:20', 'Deduction created via enhanced form'),
(80, 81, 'created', 135, '2025-10-02 15:26:20', 'Deduction created via enhanced form'),
(81, 82, 'created', 135, '2025-10-02 15:26:20', 'Deduction created via enhanced form'),
(82, 83, 'created', 135, '2025-10-02 15:26:20', 'Deduction created via enhanced form'),
(83, 84, 'created', 135, '2025-10-02 15:26:20', 'Deduction created via enhanced form'),
(84, 85, 'created', 135, '2025-10-02 15:26:21', 'Deduction created via enhanced form'),
(85, 86, 'created', 135, '2025-10-02 15:26:21', 'Deduction created via enhanced form'),
(86, 87, 'created', 135, '2025-10-02 15:26:21', 'Deduction created via enhanced form'),
(87, 88, 'created', 135, '2025-10-02 15:26:21', 'Deduction created via enhanced form'),
(88, 89, 'created', 135, '2025-10-02 15:26:21', 'Deduction created via enhanced form'),
(89, 90, 'created', 135, '2025-10-02 15:26:21', 'Deduction created via enhanced form'),
(90, 91, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(91, 92, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(92, 93, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(93, 94, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(94, 95, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(95, 96, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(96, 97, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form'),
(97, 98, 'created', 135, '2025-10-02 15:26:22', 'Deduction created via enhanced form');

-- --------------------------------------------------------

--
-- Table structure for table `deduction_formulas`
--

CREATE TABLE `deduction_formulas` (
  `formula_id` int(11) NOT NULL,
  `deduction_type_id` int(11) NOT NULL,
  `formula_name` varchar(255) NOT NULL,
  `formula_expression` text NOT NULL,
  `applicable_from` date NOT NULL,
  `applicable_to` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deduction_templates`
--

CREATE TABLE `deduction_templates` (
  `id` int(11) NOT NULL,
  `template_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `calculation_type` enum('fixed','percentage','formula') NOT NULL,
  `calculation_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`calculation_details`)),
  `created_by` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deduction_templates`
--

INSERT INTO `deduction_templates` (`id`, `template_name`, `description`, `calculation_type`, `calculation_details`, `created_by`, `created_at`) VALUES
(1, 'sha', 'medical deduction', 'formula', '{\"type\":\"formula\",\"formula\":\"basic_salary-gross_salary\"}', 135, '2025-10-02 14:02:52'),
(2, 'chama', 'compulsary company deduction', 'fixed', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 14:36:08'),
(3, 'Mentor Sacco', 'Mentor sacco deduction', 'formula', '{\"type\":\"formula\",\"formula\":\"(basic_salary*17)\"}', 135, '2025-10-02 14:39:53'),
(4, 'Unaitas Loan', 'Unaitas', 'fixed', '{\"type\":\"fixed\",\"amount\":10000}', 135, '2025-10-03 11:44:15');

-- --------------------------------------------------------

--
-- Table structure for table `deduction_types`
--

CREATE TABLE `deduction_types` (
  `deduction_type_id` int(11) NOT NULL,
  `type_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `calculation_method` enum('percentage','fixed','formula') DEFAULT 'fixed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `calculation_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`calculation_details`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `deduction_types`
--

INSERT INTO `deduction_types` (`deduction_type_id`, `type_name`, `description`, `is_active`, `calculation_method`, `created_at`, `updated_at`, `calculation_details`) VALUES
(1, 'PAYE', 'Pay As You Earn Tax', 1, 'formula', '2025-09-01 17:43:09', '2025-09-01 17:43:09', NULL),
(2, 'NSSF', 'National Social Security Fund', 1, 'percentage', '2025-09-01 17:43:09', '2025-09-01 17:43:09', NULL),
(3, 'Equity Bank Loan', 'Monthly loan repayment', 1, 'fixed', '2025-09-01 17:43:09', '2025-09-01 17:43:09', NULL),
(4, 'Health Insurance', 'Monthly health insurance premium', 1, 'fixed', '2025-09-01 17:43:09', '2025-09-01 17:43:09', NULL),
(5, 'Pension', 'Retirement contribution', 1, 'percentage', '2025-09-01 17:43:09', '2025-09-01 17:43:09', NULL),
(7, 'sha', 'medical deduction', 1, 'formula', '2025-10-02 11:02:52', '2025-10-02 11:02:52', NULL),
(8, 'chama', 'Company Full deduction', 1, 'percentage', '2025-10-02 11:04:42', '2025-10-02 11:04:42', NULL),
(9, 'Mentor Sacco', 'Mentor sacco deduction', 1, 'formula', '2025-10-02 11:39:52', '2025-10-02 11:39:52', NULL),
(10, 'Unaitas Loan', 'Unaitas', 1, 'fixed', '2025-10-03 08:44:15', '2025-10-03 08:44:15', '{\"type\":\"fixed\",\"amount\":10000}'),
(13, 'KBC', 'LOAN', 1, 'formula', '2025-10-03 09:21:51', '2025-10-03 09:37:19', '{\"type\":\"formula\",\"formula\":\"(basic_salary*10\\/100)-loan_balance\"}');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'Manages employee relations and company policies', '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(2, 'Commercial', 'Handles sales, marketing, and customer relations', '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(3, 'Technical', 'Manages technical operations and development', '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(4, 'Corporate Affairs', 'Handles legal, compliance, and corporate governance', '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(5, 'Fort-Aqua', 'Water management and supply operations', '2025-07-19 06:04:13', '2025-07-19 06:04:13');

-- --------------------------------------------------------

--
-- Table structure for table `dependencies`
--

CREATE TABLE `dependencies` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `relationship` varchar(100) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `id_no` varchar(50) DEFAULT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dependencies`
--

INSERT INTO `dependencies` (`id`, `employee_id`, `name`, `relationship`, `date_of_birth`, `gender`, `id_no`, `contact`, `created_at`) VALUES
(1, 135, 'Smith Andrew', 'Mother', '1987-03-11', 'female', '', '', '2025-09-09 13:36:21'),
(2, 150, 'Smith Andrew', 'Father', '1908-03-18', 'male', '', '', '2025-09-11 12:57:00');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `profile_token` char(64) DEFAULT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `gender` varchar(10) NOT NULL,
  `national_id` int(10) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `employment_type` varchar(20) NOT NULL,
  `employee_type` varchar(20) NOT NULL,
  `profile_image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `employee_status` enum('active','inactive','resigned','fired','retired') NOT NULL DEFAULT 'active',
  `scale_id` varchar(10) DEFAULT NULL,
  `next_of_kin` varchar(50) NOT NULL,
  `subsection_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `profile_token`, `employee_id`, `first_name`, `last_name`, `surname`, `gender`, `national_id`, `email`, `designation`, `phone`, `date_of_birth`, `address`, `department_id`, `section_id`, `position`, `salary`, `hire_date`, `employment_type`, `employee_type`, `profile_image_url`, `created_at`, `updated_at`, `employee_status`, `scale_id`, `next_of_kin`, `subsection_id`) VALUES
(336, 'ea6c981fbe95e892ae9345e7ebbe144681c05e53d540a624cc4d8d0692583bfb', '74', 'Hannah', 'Wangari', 'Kamau', '', 27500132, 'annwangari275@gmail.com', 'Technician', '0711366089', '1989-10-09', 'Murang`a', 3, 10, NULL, NULL, '2025-10-09', 'permanent', 'officer', NULL, '2025-10-09 12:54:31', '2025-10-21 08:42:45', 'active', '5', '', NULL),
(337, '1d3ec41cc5b1e579232af520a944a37485b4d57fc79adcf498d0965dde9a4190', '98', 'NYAGUTHII', 'SOLOMON', 'NJOROGE', '', 27862698, 'njorogesolomon2@gmail.com', 'Region Officer', '0717331399', '1990-10-09', 'Murang`a', 3, 5, NULL, NULL, '2025-10-10', 'permanent', 'officer', NULL, '2025-10-09 12:54:32', '2025-10-21 08:42:56', 'active', '5', '', NULL),
(338, 'f21032f0abbdce5a623de1a2d1fc04b0e052f4a1803d6a572d4258570e3e0fa1', '100', 'Halima', 'Issah', '', '', 28460830, 'mimaissah@gmail.com', 'Water Production Officer', '0717210705', '1990-08-08', 'Murang`a', 3, 6, NULL, NULL, '2025-10-11', 'permanent', 'officer', NULL, '2025-10-09 12:54:32', '2025-10-21 08:42:58', 'active', '5', '', NULL),
(339, '152fe0e12d16bab2396be8e6243741bb9a35c99f883cd290e421e9811ac9245b', '101', 'EPHANTUS', 'NDEGWA', 'KAIYEGO', '', 28590573, 'ephantusndegwa3@gmail.com', 'Water Production Operator', '0706 9387 75', '1991-06-10', 'Murang`a', 3, 18, NULL, NULL, '2025-10-12', 'permanent', 'officer', NULL, '2025-10-09 12:54:32', '2025-10-21 08:42:59', 'active', '5', '', NULL),
(340, 'c0fea81a9d6ba7c338a8f906f1b98ac7ea9920542899926b5c98b3bc6fe44f21', '102', 'Gerald', 'Nduati', 'Kaaru', '', 22889104, 'nduatigerald763@gmail.com', 'Sewerage Artisan', '0719570676', '1981-06-22', 'Murang`a', 3, 15, NULL, NULL, '2025-10-13', 'permanent', 'officer', NULL, '2025-10-09 12:54:32', '2025-10-21 08:43:00', 'active', '5', '', NULL),
(341, 'ad4a6aecc7c5b2e290a93857b3535b88e214ddee46c6d865e9bfa5c1683b2750', '103', 'Gladys', 'Waigwe', 'Nyambura', '', 20667990, 'gladyswaigwenyambura@gmail.com', 'Meter Reader', '0723136825', '1978-10-09', 'Murang`a', 2, 14, NULL, NULL, '2025-10-14', 'permanent', 'officer', NULL, '2025-10-09 12:54:32', '2025-10-21 08:43:00', 'active', '5', '', NULL),
(342, 'e0cd6b53f5a88a9b0cbb34aa1b3c2bfcc00d5a1fe4bc107df1c44b1f5e6bc5f2', '104', 'Mercy', 'Thiong\'o', '', '', 26207104, 'mercythiongo62@gmail.com', 'Water Production Operator', '0701516689', '1988-09-27', 'Murang`a', 3, 18, NULL, NULL, '2025-10-15', 'permanent', 'officer', NULL, '2025-10-09 12:54:32', '2025-10-21 08:43:01', 'active', '5', '', NULL),
(343, '498c2810aac72e05be099ba352cdeaf9313745cda9c043943bf4a09352cec612', '105', 'Nahashon', 'Muchai', 'Karina', '', 22005533, 'muchainash@gmail.com', 'Waste Water Officer', '0726605101', '1979-11-20', 'Murang`a', 3, 15, NULL, NULL, '2025-10-16', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:01', 'active', '5', '', NULL),
(344, 'bc2ea0dbf5aaf74e15c1f0d17114da08db0f3290b7571fa472c8304ed5c7f257', '106', 'Patrick', 'Wanjohi', 'Mwai', '', 10192889, 'partmwai70@gmail.com', 'Transport Officer', '0715198136', '1968-10-09', 'Murang`a', 1, 13, NULL, NULL, '2025-10-17', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:01', 'active', '5', '', NULL),
(345, '262403065c7e2eead8eb2bb755b77429bf7b43581022df7475be4b6906bf0ce7', '107', 'SIMON', 'KINYUA', 'MWANGI', '', 1388422, 'eng.skinyua@gmail.com', 'Water Inspector', '0729368082', '1976-10-09', 'Murang`a', 1, 19, NULL, NULL, '2025-10-18', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:01', 'active', '5', '', NULL),
(346, 'cea33eea75ce2fad1c8996f28573255d1f24fc9e42747df87ec8f8abbd913608', '108', 'Peter', 'Kairu', '', '', 22536155, 'peterkairu2023@gmail.com', 'Technician', '0723405355', '1978-07-27', 'Murang`a', 3, 12, NULL, NULL, '2025-10-19', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:02', 'active', '5', '', NULL),
(347, '8ba3b8e9e471add7a5022af0cb5be11943acdde093e325446abdafd4bf5aa4b4', '109', 'NELIUS', 'WARUGURU', 'MACHARIA', '', 26291321, 'neliusmacharia60@gmail.com', 'Technician', '0712732130', '1989-01-04', 'Murang`a', 2, 14, NULL, NULL, '2025-10-20', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:02', 'active', '5', '', NULL),
(348, '2a2334693d4ec0942e3cadf3a06d2bb36766bfcb0f423afa48f1598571c12e6a', '110', 'Peter', 'nganga', 'wangui', '', 32652831, 'cumahngash@gmail.com', 'Construction', '0722937749', '1993-03-12', 'Murang`a', 3, 12, NULL, NULL, '2025-10-21', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:02', 'active', '5', '', NULL),
(349, '224e6f3ab3e5d10c3207687fefd22320f8e96546c1373cc38b3136fc2601617b', '111', 'Patrick', 'waweru', 'kimani', '', 29197433, 'patrickwaweru43@gmail.com', 'Snr Water Production Officer', '0716729050', '1992-07-21', 'Murang`a', 3, 5, NULL, NULL, '2025-10-22', 'permanent', 'officer', NULL, '2025-10-09 12:54:33', '2025-10-21 08:43:03', 'active', '5', '', NULL),
(350, '65b39ce2037bea8b71caa15a94ae25f6e722a485c7f64a209c6484c2ebacdddd', '112', 'ANNA', 'Ng\'ang\'a', '', '', 25901851, 'wanjirunganga7@gmail.com', 'Debt Controller', '0721286220', '1986-12-09', 'Murang`a', 2, 14, NULL, NULL, '2025-10-23', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:03', 'active', '5', '', NULL),
(351, 'b1a806964437f0b9b64e7b6b0bfb07f8bb97a8e7c28778bd4b7310019c69c26c', '113', 'Stephen', 'Ngumi', '', '', 27720940, 'stevenngumi2017@gmail.com', 'Technician', '0725544028', '1988-08-19', 'Murang`a', 3, 10, NULL, NULL, '2025-10-24', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:04', 'active', '5', '', NULL),
(352, '7c351ff96cd06fe0c86c9baad087fc90bbcf29727deb7069c585e30f3dedfd2a', '114', 'James', 'Kamande', 'Ngugi', '', 26520042, 'jameskamande1988@gmail.com', 'Technician', '0725082047', '1988-03-03', 'Murang`a', 3, 5, NULL, NULL, '2025-10-25', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:04', 'active', '5', '', NULL),
(353, 'a6cb9dbe2239e909de381ea3dd1bc8ca7fbb4ca83b85603100a56ce2565c2887', '115', 'Monicah', 'nyambura', 'njuguna', '', 21524791, 'nyamburamonicahn@gmail.com', 'Debt Controller', '0725510718', '1979-10-09', 'Murang`a', 2, 14, NULL, NULL, '2025-10-26', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:04', 'active', '5', '', NULL),
(354, '200d93dc3ec5f9356a69fa9887f88392d25177cca6d94e51aa0c86c803545d4c', '118', 'Nancy', 'Wanjiru', 'Muriithi', '', 25784014, 'nancymuriithi2014@gmail.com', 'Asst. Customer Relations Officer', '0710637796', '1987-12-19', 'Murang`a', 4, 5, NULL, NULL, '2025-10-27', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:05', 'active', '5', '', NULL),
(355, '169dc26eb2de4ad486b9b57c8ea3cc37c0e0083739b7af3d6b4ea9594d01324b', '119', 'Lucy', 'Mbuthia', '', '', 30667121, 'Lucymbuthia11@gmail.com', 'Human Resource Officer', '0720421352', '1993-01-29', 'Murang`a', 1, 1, NULL, NULL, '2025-10-28', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:06', 'active', '5', '', NULL),
(356, '187cbd0050fabfceee0f8603e6f812060a3f4b2f30f7146177b0b89975a3d8a3', '120', 'Monica', 'Wanjiru', 'mwaura', '', 27685980, 'monicawanjirumwaura@gmail.com', 'Water Production Operator', '0707740307', '1989-08-10', 'Murang`a', 3, 18, NULL, NULL, '2025-10-29', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:07', 'active', '5', '', NULL),
(357, 'a74517c7ae5895a24fa529fec0b54ef7e73c50ac07a6b9eb432ff966c71e508f', '121', 'Tabitha', 'W', 'Mwirigi', '', 23129694, 'tabithamwirigi@gmail.com', 'Pro Poor Officer', '0726700604', '1983-11-08', 'Murang`a', 4, 5, NULL, NULL, '2025-10-30', 'permanent', 'officer', NULL, '2025-10-09 12:54:34', '2025-10-21 08:43:07', 'active', '5', '', NULL),
(358, '0409e4acb7035cf8edbd687a86aa623d483d9a5f1fd310046ba42f045a7b33ea', '124', 'Emma', 'Wachui', '', '', 26238345, 'emmawacui@gmail.com', 'Office Assistant', '0728315533', '1983-06-22', 'Murang`a', 1, 13, NULL, NULL, '2025-10-31', 'permanent', 'officer', NULL, '2025-10-09 12:54:35', '2025-10-21 08:43:08', 'active', '5', '', NULL),
(359, '07bd0e22fe57822bf88379a3d355f5b897d1065ed0bfb76cee52c9025d4ca87a', '128', 'Christopher', 'Gichuru', 'Theuri', '', 21400348, 'gichuruchristopher@yahoo.com', 'Technician', '0724619079', '1978-10-09', 'Murang`a', 2, 14, NULL, NULL, '2025-11-01', 'permanent', 'officer', NULL, '2025-10-09 12:54:35', '2025-10-21 08:43:08', 'active', '5', '', NULL),
(360, 'b03ba601d36b8d7a00ccff433099c5e0461c7ff697453241d231093570378016', '130', 'MONICAH', 'MUGECHI', 'GITHINJI.', '', 22061425, 'monicahgithinji680@gmail.com', 'Office Assistant', '0723677670', '1981-05-05', 'Murang`a', 1, 13, NULL, NULL, '2025-11-02', 'permanent', 'officer', NULL, '2025-10-09 12:54:35', '2025-10-21 08:43:08', 'active', '5', '', NULL),
(361, 'e17a6eec2fcfc198cecd242beb19827d0b90bd6c97af140a372f2c7dd7daca07', '131', 'Joseph', 'njoroge', 'mathias', '', 29959581, 'njorogemathia21@gmail.com', 'Water Production Operator', '0708076186', '1993-08-16', 'Murang`a', 3, 18, NULL, NULL, '2025-11-03', 'permanent', 'officer', NULL, '2025-10-09 12:54:35', '2025-10-21 08:43:09', 'active', '5', '', NULL),
(362, '85d05d865a0e7efa6f96e7e0ac69d1e9fc41234652dbda719fbf1bc63c4e200a', '133', 'Rose', 'Gichimu', '', '', 33540252, 'gichimurose61@gmail.com', 'Procurement Officer', '0719277611', '1997-02-28', 'Murang`a', 1, 16, NULL, NULL, '2025-11-04', 'permanent', 'officer', NULL, '2025-10-09 12:54:35', '2025-10-21 08:43:09', 'active', '5', '', NULL),
(363, '585347820a5ef1c402f4f4fb592342fee9537afdf95d8a2831ddd055e641ef03', '135', 'Wangai', 'Mary', 'Njeri', '', 27084163, 'njeriwangai6@gmail.com', 'Customer Service Assistant', '07284 63040', '1989-08-23', 'Murang`a', 4, 5, NULL, NULL, '2025-11-05', 'permanent', 'officer', NULL, '2025-10-09 12:54:35', '2025-10-21 08:43:09', 'active', '5', '', NULL),
(364, '4c3b463d71f8241b85ecf77045b2f44375c01ab8474aa5e7ca933982424f50c7', '136', 'Margaret', 'wairimu', 'mwangi', '', 24364920, 'margaretwairimumm@gmail.com', 'Office Assistant', '0713114087', '1985-04-27', 'Murang`a', 1, 1, NULL, NULL, '2025-11-06', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:09', 'active', '5', '', NULL),
(365, 'b44cbe10cf2f83d1200448b3704f7ddb93b2fcf0039f71ec1e7ce3ee92281e3c', '140', 'Stephen', 'kamau', 'maina', '', 29460116, 'stekapannuelss5@gmail.com', 'Water Quality Officer', '0700863332', '1991-04-15', 'Murang`a', 3, 18, NULL, NULL, '2025-11-07', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:10', 'active', '5', '', NULL),
(366, 'dd17ccee48614a0433cf6a395d7f77f0cb47d7031987a6984cc367da38609ec8', '143', 'Michael', 'Shimega', 'Iyema', '', 21106799, 'michaeliyema01@gmail.com', 'Driver', '0727728906', '1977-02-01', 'Murang`a', 1, 17, NULL, NULL, '2025-11-08', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:10', 'active', '5', '', NULL),
(367, '5be4676efbad457289a0b1e25e6ba16e3ef7de8585ae3e17dfb685cfa8b81ae9', '144', 'ANN', 'NYAMBURA', 'WAINAINA', '', 31454031, 'anwainaina249@gmail.com', 'Accountant', '0713623097', '1993-09-24', 'Murang`a', 2, 2, NULL, NULL, '2025-11-09', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:10', 'active', '5', '', NULL),
(368, '58d924f364b2cdef8b035440b13759812b385671affffcab6590049ece027c0a', '145', 'Peter', 'kimani', 'wanjiru', '', 22467362, 'peterkim0048@gmail.com', 'Meter Reader', '0713470048', '1979-10-30', 'Murang`a', 2, 14, NULL, NULL, '2025-11-10', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:10', 'active', '5', '', NULL),
(369, '0a6323efde07f947c491411c9297bd919f973d58f28bfa6e317b0a8b31c6bb70', '146', 'Jeniffer', 'njoki', 'maina', '', 28463984, 'jeniffernjoki389@gmail.com', 'Technician', '0707866140', '1991-11-16', 'Murang`a', 5, 6, NULL, NULL, '2025-11-11', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:10', 'active', '5', '', NULL),
(370, '6d2d96b959a9c17bf515c2333aa7f3360cad8c9c1d79e68605131414d4aa2f3e', '147', 'ALICE', 'MUTHONI', 'GACHINGA', '', 11273950, 'alicemuthoni252@gmail.com', 'Office Assistant', '0720838464', '1969-05-15', 'Murang`a', 1, 1, NULL, NULL, '2025-11-12', 'permanent', 'officer', NULL, '2025-10-09 12:54:36', '2025-10-21 08:43:10', 'active', '5', '', NULL),
(371, '7c36e4c1dea756638a55d84e188a6df3bb0d947b21a5dec61b2245d61516b3f8', '148', 'Jacob', 'Gachua', 'Mbuthia', '', 21983038, 'jacobgachua@gmail.com', 'Office Assistant', '0727939595', '1979-10-09', 'Murang`a', 1, 1, NULL, NULL, '2025-11-13', 'permanent', 'officer', NULL, '2025-10-09 12:54:37', '2025-10-21 08:43:11', 'active', '5', '', NULL),
(372, '95e34bd0a2c07e25207e74d88fb32988633c2ae1cab0a6349150933e5867c448', '150', 'Priscilla', 'Nancy', 'Nyambura', '', 14626726, 'priscillanjoroge111@gmail.com', 'Office Assistant', '0728463069', '1976-12-07', 'Murang`a', 2, 14, NULL, NULL, '2025-11-14', 'permanent', 'officer', NULL, '2025-10-09 12:54:37', '2025-10-21 08:43:11', 'active', '5', '', NULL),
(373, '32113c42ba58f48255a4aa0ab330fcf18cec0ee8bc65625f28ef3f40bd1b0ba3', '154', 'Cliffson', 'munene', 'kinuthia', '', 29701652, 'cliffsonmunene40@gmail.com', 'Technician', '0726771449', '1992-03-06', 'Murang`a', 2, 14, NULL, NULL, '2025-11-15', 'permanent', 'officer', NULL, '2025-10-09 12:54:37', '2025-10-21 08:43:11', 'active', '5', '', NULL),
(374, 'b6eeeb68ba374eb5ecf3fa1761256725c742ebc55bba3d086585abd161c0bdb8', '157', 'Dennis', 'Thiongo', 'Mwangi', '', 27652087, 'thiongo.dennis53@gmail.com', 'Water Inspector', '0728086149', '1988-11-05', 'Murang`a', 1, 19, NULL, NULL, '2025-11-16', 'permanent', 'officer', NULL, '2025-10-09 12:54:37', '2025-10-21 08:43:11', 'active', '5', '', NULL),
(375, '8e06d18708b0e47aa7d789f16bae69d90851f7361785d550f5356d275568f2c9', '158', 'Elizabeth', 'Wariara', '', '', 24546700, 'elizawariara870@gmail.com', 'Water Quality Officer', '0725633731', '1985-02-28', 'Murang`a', 3, 18, NULL, NULL, '2025-11-17', 'permanent', 'officer', NULL, '2025-10-09 12:54:37', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(376, '05366145995162e486563ae624335366de4b35ccdb04c76f660bc85f19628999', '159', 'Rebecca', 'Wanjiku', 'Kaguai', '', 34285764, 'kaguairebeccaw@gmail.com', 'Technician', '0110932834', '1996-03-11', 'Murang`a', 2, 14, NULL, NULL, '2025-11-18', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(377, '6617c801f36b1a300e6281cc52a70b67627b8151a7fb9bbdb0c3e114dfcfdc4e', '160', 'PETER', 'CHEGE', 'WANJIKU', '', 34205920, 'peterchek852@gmail.com', 'Driver', '0743800935', '1996-05-25', 'Murang`a', 3, 15, NULL, NULL, '2025-11-19', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(378, '8e8d3c155cbfb0064d66ad02cc671d253483f5ad927e19bb7b62143a5aa58416', '161', 'Raphael', 'Koigi', 'Kamwaga', '', 22488405, 'raphaelkoigi@gmail.com', 'Human Resource Asst.', '0721585113', '1981-12-06', 'Murang`a', 1, 1, NULL, NULL, '2025-11-20', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(379, '170e1ca0eca8f485bae4284e68fe11f9be2b6e03e0c23439a667ce64e7ad8474', '162', 'MWANGI', 'DAVID', 'KIBUGI', '', 28292196, 'mwangikibugi@gmail.com', 'Sales & Marketing', '0727925196', '1989-10-14', 'Murang`a', 5, NULL, NULL, NULL, '2025-11-21', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(380, '67b4693a58e810d67abdcbbd05916f2fe5a47ffcb96a860e02463fa1fa7f0eb1', '164', 'JOHN', 'KINYANJUI', 'NGUGI', '', 28570194, 'ngugijohn316@gmail.com', 'Technician', '0700666471', '1992-01-02', 'Murang`a', 3, 5, NULL, NULL, '2025-11-22', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(381, '0b02326dfa51738d240495dac6b615f4105f19321c461d7b6adf651b11778867', '167', 'David', 'Silas', 'Marwa', '', 33209775, 'davidmarwa95@gmail.com', 'Development Officer', '0708746190', '1995-10-11', 'Murang`a', 3, 8, NULL, NULL, '2025-11-23', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(382, 'f35999c9ba94af8a3d52e9130f831500e40e4db833a66a22305476e842a9e526', '168', 'Kibaiyu', 'Mary', 'Wambui', '', 34031174, 'kibaiyu17@gmail.com', 'Procurement Officer', '0701971835', '1996-03-27', 'Murang`a', 1, 16, NULL, NULL, '2025-11-24', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:12', 'active', '5', '', NULL),
(383, '8c094fb9b77da3dd1a693ddd02e645bbbf61d8dbee55ebb25be48faa8f935a4b', '169', 'MICHAEL', 'CHEGE', 'NGANGA', '', 11660055, 'ngangamichael704@gmail.com', 'Mechanic', '0794800524', '1973-10-09', 'Murang`a', 1, 17, NULL, NULL, '2025-11-25', 'permanent', 'officer', NULL, '2025-10-09 12:54:38', '2025-10-21 08:43:13', 'active', '5', '', NULL),
(384, '18e958149d55bc169c15beb61cd645b2a750d56166bacd4e0cf57cfad71621da', '170', 'DAVID', 'IRUNGU', 'KIBUNJA', '', 26282847, 'irungud715@gmail.com', 'Office Assistant', '0797629688', '1988-08-05', 'Murang`a', 1, 1, NULL, NULL, '2025-11-26', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:13', 'active', '5', '', NULL),
(385, '3a5616cccd87ba7145b6c67c4002e86a0002e63a7fdf7db22146e34a503fe3f2', '171', 'Gathere', 'julius', 'mukundi', '', 38191108, 'juliusgathere58@gmail.com', 'Technician', '0768517106', '1999-06-20', 'Murang`a', 3, 7, NULL, NULL, '2025-11-27', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:13', 'active', '5', '', NULL),
(386, '5bf28f2bbbe59ff788ac106b6a0a2093ccf416c6de4db8cf2af7ca34958942ed', '172', 'Gatambia', 'Charles', 'Irungu', '', 34183309, 'charlesirungugatambia@gmail.com', 'Water Production Operator', '0797156237', '1997-04-21', 'Murang`a', 3, 18, NULL, NULL, '2025-11-28', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:13', 'active', '5', '', NULL),
(387, 'b95b2dd05202fd994072e7068c6bfda661b3a03eb32d68f79c7110a4807a0536', '173', 'Stanley', 'njuguna', 'ngige', '', 33672086, 'Stanleynjuguna403@gmail.com', 'Technician', '0711264480', '1996-05-18', 'Murang`a', 3, 10, NULL, NULL, '2025-11-29', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:13', 'active', '5', '', NULL),
(388, '1eb1fa5efd3de9bec25170fec893e1a9b8937356908e3893472dc7b1b638a5e9', '174', 'IRENE', 'WAMBUI', 'MUTHONI', '', 24819953, 'Irenewambui07@gmail.com', 'Asst. Sales & Marketing Officer', '0713415338', '1979-09-24', 'Murang`a', 5, 4, NULL, NULL, '2025-11-30', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:13', 'active', '5', '', NULL),
(389, '876a93e6e6a771e798542f25abc7d47609f67b947b0bf38e023b142a3fe1c42d', '175', 'Jilden', 'Stanely', 'Mbugua', '', 39083479, 'kingjilden@gmail.com', 'Meter Reader', '0702372604', '2001-05-24', 'Murang`a', 2, 14, NULL, NULL, '2025-12-02', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:14', 'active', '5', '', NULL),
(390, 'a6f7c8e53e8577f2d377f3d9b350bc7d33de14a242b94dc9deac856340728efe', '176', 'Peter', 'Mwangi', 'Kariuki', '', 27474191, 'petermwangikariuki78929@gmail.com', 'Technician', '0700172390', '1990-08-17', 'Murang`a', 3, 7, NULL, NULL, '2025-12-03', 'permanent', 'officer', NULL, '2025-10-09 12:54:39', '2025-10-21 08:43:14', 'active', '5', '', NULL),
(391, '76fe0cbb07e61e41b0c5d5058d401f556875243b4b8c87ebfd6f211e985de691', '177', 'Sarah', 'kathunguto', 'kiio', 'female', 27750736, 'sarahkathunguto@gmail.com', '0', '0721491105', '1988-06-06', 'Murang`a', 1, 1, NULL, NULL, '2025-12-04', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:14', 'active', '5', '[]', NULL),
(392, '5183cdd2e5847cf2a9d1e2f006359819171ad3e37333c7b344733cbd6b589273', '178', 'Stephen', 'Mwangi', 'Kabii', 'male', 36469141, 'mwangikabii@gmail.com', 'ict', '0707699054', '1999-03-27', 'Murang`a', 2, 4, NULL, NULL, '2025-12-05', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:14', 'active', '5', '[]', NULL),
(393, 'dfff1ce6685f56934ab4bfa336bd0293dd6fd3368a04dae2297d41a94fbea7d8', '179', 'Jackline', 'wanjiru', 'wambui', '', 26103678, 'wjackline15@yahoo.com', 'Secretary', '0724897142', '1985-01-01', 'Murang`a', 1, 1, NULL, NULL, '2025-12-06', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:14', 'active', '5', '', NULL),
(394, '866cd9a034b135ee954366a335403e46872b08dd986dfbf8c209086f87c7fddd', '180', 'DUNCAN', 'WAWERU', '', '', 21738860, 'wawerud201@gmail.com', 'Sewerage Artisan', '0715169302', '1978-02-11', 'Murang`a', 3, 15, NULL, NULL, '2025-12-07', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:15', 'active', '5', '', NULL),
(395, '87f32632610ddc573232af1a0549c781c03a3fc5e436c61a60e157b0441d0e54', '182', 'Hellen', 'wanjiru', 'michire', '', 26407043, 'shiromichire94@gmail.com', 'Meter Reader', '0725828637', '1987-08-22', 'Murang`a', 2, 14, NULL, NULL, '2025-12-08', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:15', 'active', '5', '', NULL),
(396, '18c56be7c6930c20b0e6ec1c028973e7ea9c6afb16694214826cc6e3ea2b7afe', '183', 'Susan', 'Wanjiru', 'Mucheru', '', 29869822, 'suuwa36@gmail.com', 'Meter Reader', '0727930908', '1987-10-22', 'Murang`a', 2, 14, NULL, NULL, '2025-12-09', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:15', 'active', '5', '', NULL),
(397, 'ca10a6eb23e0ef3004870eec90554feed5092bf485bc512b72d26bffe9eeee68', '184', 'JOE', 'CALEB', '', '', 36890082, 'caleb.lacherry@gmail.com', 'Asst. Customer Relations Officer', '0708880269', '1999-02-07', 'Murang`a', 4, 5, NULL, NULL, '2025-12-10', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:16', 'active', '5', '', NULL),
(398, 'be03a7d09e26ca5f9580cd8f8e2ad330af81e8646c1f9ecd8c1d5731f858de11', '185', 'IBRAHIM', 'MBOTE', 'MWANGI', '', 26646151, 'mboteibrahim@gmail.com', 'Technician', '0704615003', '1988-05-13', 'Murang`a', 3, 8, NULL, NULL, '2025-12-11', 'permanent', 'officer', NULL, '2025-10-09 12:54:40', '2025-10-21 08:43:16', 'active', '5', '', NULL),
(399, 'b4d20f66bff79d22a525470203578fe1eb760769defa10e48b7a1977d454a7dd', '186', 'Joan', 'Waiyego', 'Thuo', '', 37178695, 'joannewaiyegothuo@gmail.com', 'Water Production Operator', '0741720469', '2000-02-12', 'Murang`a', 3, 18, NULL, NULL, '2025-12-12', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:16', 'active', '5', '', NULL),
(400, '12af42e931dc58452dcf125c61fed3703ba4f85c542d9512adeadf60f7bb5fd7', '187', 'Nancy', 'muthoga', '', 'female', 31103923, 'nancymuthoga1@gmail.com', 'Meter Reader', '0714318975', '1992-12-12', 'Murang`a', 2, 12, NULL, NULL, '2025-12-13', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:16', 'active', '5', '[]', 1),
(401, 'caed43e499582902022f02b0edbc7945252780273d42b05f70f367a93c22ae20', '188', 'AGNES', 'NJOKI', 'MAINA', '', 24447512, 'aggynorbert.an@gmail.com', 'Debt Controller', '0720629363', '1984-01-01', 'Murang`a', 4, 5, NULL, NULL, '2025-12-14', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:17', 'active', '5', '', NULL),
(402, '92d63c5e137805f2d5e8c2d8026a747af8fab3912e29bfc671bbe86fdff9751b', '189', 'Susan', 'Wairimu', 'Njuguna', '', 39107617, 'nimohnjuguna8@gmail.com', 'Accountant', '0743207684', '2001-01-03', 'Murang`a', 2, 2, NULL, NULL, '2025-12-15', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:17', 'active', '5', '', NULL),
(403, 'c2a896634e0a7955bb29a8c67694fa1f7ce1d6243318bdbaa8d766242de1d21e', '191', 'Pleasant', 'Wanjiru', '', '', 38088379, 'pleasantkangethe@gmail.com', 'Customer Service Assistant', '0724566942', '2001-02-04', 'Murang`a', 4, 5, NULL, NULL, '2025-12-16', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:17', 'active', '5', '', NULL),
(404, 'e24aadac6cb4d1723f9f597ea96dd4c190b62dd574e6d6bfb10bd4605e09ff72', '192', 'Stanley', 'mwangi', 'ngigi', '', 28597769, 'Stanleyngigi44@gmail.com', 'Technician', '0748835395', '1990-04-27', 'Murang`a', 2, 14, NULL, NULL, '2025-12-17', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:17', 'active', '5', '', NULL),
(405, 'ab50e001227dfa146ad43ca41926bd4b6ffc50bdfb0ed9243c8e6edb7a12702a', '193', 'EUNICE', 'NJOKI', 'NGICIRI', '', 28114623, 'njoki6077@gmail.com', 'Office Assistant', '0706902656', '1979-02-20', 'Murang`a', 1, 1, NULL, NULL, '2025-12-18', 'permanent', 'officer', NULL, '2025-10-09 12:54:41', '2025-10-21 08:43:17', 'active', '5', '', NULL),
(406, '2b605803ab6069f1610723f19aea8a2d373b21a6513856c5059d2e390b1be3e2', '195', 'MERCY', 'Muthoni', 'Mutuota', 'female', 32895196, 'muthonimercy264@gmail.com', 'Customer Service Assistant', '0745439003', '1996-02-02', 'Murang`a', 5, NULL, NULL, NULL, '2025-12-19', 'permanent', 'officer', NULL, '2025-10-09 12:54:42', '2025-10-23 09:06:23', 'active', '5', '[]', NULL),
(407, '96df6929b1551a8522938fa2ee121260b78e20c594cfecaf751387f539de831f', '196', 'John', 'Mwaniki', 'Shimega', '', 37319374, 'johnmwank440@gmail.com', 'Technician', '0705427918', '2000-02-05', 'Murang`a', 3, 7, NULL, NULL, '2025-12-20', 'permanent', 'officer', NULL, '2025-10-09 12:54:42', '2025-10-21 08:43:18', 'active', '5', '', NULL),
(408, 'f882a01ca444e0e068169f056725eadfbd9fcd3e664302d403a2bdfbee372801', '197', 'Antony', 'Kangethe', 'Ngechu', '', 36466545, 'antogoshen@gmail.com', 'Technician', '0705446430', '1998-12-01', 'Murang`a', 3, 7, NULL, NULL, '2025-12-21', 'permanent', 'officer', NULL, '2025-10-09 12:54:42', '2025-10-21 08:43:26', 'active', '5', '', NULL),
(409, 'afa4d7cd7cbeafc51d2d223f59922e5ec2882a6abee73086dcae98ef805fe7e3', '198', 'Godwin', 'mukhwana', 'okumu', '', 36401453, 'godwinokumu2020@gmail.com', 'Office Assistant', '0715843762', '1997-05-15', 'Murang`a', 1, 19, NULL, NULL, '2025-12-22', 'permanent', 'officer', NULL, '2025-10-09 12:54:42', '2025-10-21 08:43:26', 'active', '5', '', NULL),
(410, 'a49e9973292f0a1c274dd4b58e73003e3f6fc5a76982b78169439a1ebcf5a30f', '199', 'Peter', 'Maina', 'Mwangi', 'male', 36528788, 'mainapetermwangi2017@gmail.com', 'ICT Officer', '0707454717', '1999-04-20', 'Murang`a', 2, 5, NULL, NULL, '2025-12-23', 'permanent', 'officer', NULL, '2025-10-09 12:54:42', '2025-10-21 13:03:39', 'active', '5', '[]', NULL),
(411, 'a1ca1a1b6fc49af33868a038665b3ea737bc33d00c03f1637039132b65f623e1', '200', 'Stephen', 'ritho', 'wanjama', '', 39959520, 'stephenritho493@gmail.com', 'Technician', '0759717848', '2000-07-06', 'Murang`a', 3, 7, NULL, NULL, '2025-12-24', 'permanent', 'officer', NULL, '2025-10-09 12:54:42', '2025-10-21 08:43:27', 'active', '5', '', NULL),
(412, 'e09fe09aff9eb412afcf7d5b9512d25ee4d206128c63e05fa035a607c8412a0d', '201', 'Stephen', 'kamau', 'wanjiku', '', 38331359, 'stevekamau721@gmail.com', 'Technician', '0111378711', '2001-05-20', 'Murang`a', 3, 7, NULL, NULL, '2025-12-25', 'permanent', 'officer', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:27', 'active', '5', '', NULL),
(413, 'bbcf799218b0f5041447c0b618a6b268e5daa31552e4e464eb1397d5abd17138', '202', 'LILLY', 'WAIRIMU', '', '', 32795484, 'lillymuthoni13@gmail.com', 'Meter Reader', '0716012540', '1996-04-07', 'Murang`a', 2, 14, NULL, NULL, '2025-12-26', 'permanent', 'officer', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:27', 'active', '5', '', NULL),
(414, 'c46849c9146be06086a2c1fec803563717e78da47cbb81b3dc13a7ec92172b25', '203', 'Edwin', 'Waithaka', 'Kimani', '', 35437434, 'kimaniedwin499@gmail.com', 'Technician', '0708725276', '1998-09-16', 'Murang`a', 3, 7, NULL, NULL, '2025-12-27', 'permanent', 'officer', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:27', 'active', '5', '', NULL),
(415, '560822bb50402b2f7f3251436d4c3db59c626a05887931b93a31db9b0ab361c2', '204', 'Michael', 'Justus', 'Muhiu', '', 30106765, 'muhiumichael@gmail.com', 'NRW Officer', '0704205872', '1992-12-26', 'Murang`a', 3, 10, NULL, NULL, '2025-12-28', 'permanent', 'officer', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:34', 'active', '5', '', NULL),
(416, 'ad35c12d0867c7baaf1c5fca59270946323769383b8d5921823b714e042deee8', '205', 'Emily', 'Wangui', '', '', 34594804, 'emilywanguiwahinya@gmail.com', 'Asst. Pro poor Officer', '0796723421', '1997-12-07', 'Murang`a', 4, 5, NULL, NULL, '2025-12-29', 'permanent', 'officer', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:34', 'active', '5', '', NULL),
(417, '3c013e67fdc8eed58c4526d255aabccdda844dc1f6d0ee945ed4838da1eb157f', '206', 'KELVIN', 'KIHIA', 'WANDERI', '', 29912388, 'wanderikelvin@gmail.com', 'Water Production Officer', '0741781567', '1993-08-04', 'Murang`a', 3, 18, NULL, NULL, '2025-12-30', 'permanent', 'officer', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:35', 'active', '5', '', NULL),
(418, '45042fb8dbd3f45247657223d309d9dd2dc85c1155bafa699ace9d7f53382d1d', '207', 'kangara', 'Josephine', 'Kabura', 'female', 36466531, 'kangarajosephine@gmail.com', '0', '0746984430', '1999-04-21', 'Murang`a', 2, 4, NULL, NULL, '2025-12-31', 'permanent', 'section_head', NULL, '2025-10-09 12:54:43', '2025-10-21 08:43:36', 'active', '5', '[]', NULL),
(419, 'bedf5cfbb37ed65a721e740535a19ab45c60aebd15d367ef6271a06294faad57', '208', 'Moses', 'Kamau', 'Waweru', '', 33608182, 'moseswawerukamau@gmail.com', 'Technician', '0741932039', '1994-09-06', 'Murang`a', 3, 7, NULL, NULL, '2026-01-01', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:36', 'active', '5', '', NULL),
(420, 'a65f7e7451eaa2bd858243111ed196b1a202696c4615c697464437ed3c13490d', '209', 'Florence', 'Mugechi', 'Kimari', '', 33366972, 'mugechikimari@gmail.com', 'Environment Officer', '0716117261', '1996-07-10', 'Murang`a', 2, 14, NULL, NULL, '2026-01-02', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:36', 'active', '5', '', NULL),
(421, '4b674443a12c0d637f30755560e9d8e14a3eedad44a7ab3439598f69869ad789', '210', 'Gatama', 'Raymond', 'Muiruri', '', 35119275, 'raymondmuiruri8@gmail.com', 'Environment Officer', '0758836259', '1997-05-14', 'Murang`a', 2, 14, NULL, NULL, '2026-01-03', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:37', 'active', '5', '', NULL),
(422, '939793e1cdedd4075d59d73fe0de38b40a74a8e1d2c25531682608c920d0f9eb', '211', 'Samuel', 'Mungai', 'Murigi', '', 28408367, 'smurigivins@gmail.com', 'Internal Auditor', '0720122639', '1990-01-02', 'Murang`a', 1, 19, NULL, NULL, '2026-01-04', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:37', 'active', '5', '', NULL),
(423, 'd250203869856e9c7c90b449ad75675410996f6989e0a972b918e0ecfcb11d77', '212', 'MOUREEN', 'WANJIKU', 'NJOROGE', '', 32520729, 'moureenwanjikunjoroge@gmail.com', 'Enforcement Officer', '0702831791', '1995-05-26', 'Murang`a', 2, 14, NULL, NULL, '2026-01-05', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:37', 'active', '5', '', NULL),
(424, 'a56656dd341440568e4e890bd2f51be88e1783b401a25e6cac2790304f2a1ffb', '213', 'William', 'Waweru', 'Njeri', '', 29734194, 'williamwawerunjeri@gmail.com', 'Revenue Officer', '0702310554', '1993-04-21', 'Murang`a', 2, 14, NULL, NULL, '2026-01-06', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:37', 'active', '5', '', NULL),
(425, '0f0e4ad6265f00621332928c4d697fa45e3212469c21b719b7af7be3e85f10c7', '214', 'BEATRICE', 'WANJIKU', '', '', 28838713, 'murigibeatrice091@gmail.com', 'Office Assistant', '0701138593', '1990-04-23', 'Murang`a', 3, 7, NULL, NULL, '2026-01-07', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:37', 'active', '5', '', NULL),
(426, '7293abc6d7e1fee6676aafec4c75a623bcc08002bda2594cfbf57c8a742dfe84', '215', 'Salome', 'Wanjiku', 'Wachui', '', 38633075, 'salokiesheeqow@gmail.com', 'Office Assistant', '0759338378', '2000-05-24', 'Murang`a', 5, 6, NULL, NULL, '2026-01-08', 'permanent', 'officer', NULL, '2025-10-09 12:54:44', '2025-10-21 08:43:37', 'active', '5', '', NULL),
(427, 'df7c901daebaaf2399693d09dea53a8152a51f2eeef6f41f1c6b78f10c70cb8d', '216', 'Shelmith', 'mugure', '', '', 33190478, 'shelmithmugure21@gmail.com', 'Human Resource Officer', '0700472246', '1996-04-29', 'Murang`a', 1, 19, NULL, NULL, '2026-01-09', 'permanent', 'officer', NULL, '2025-10-09 12:54:45', '2025-10-21 08:43:38', 'active', '5', '', NULL),
(428, '9fae7451d014a101c5592256d7838f0b999445c3f7cd979c97ec82e05b038cfa', '217', 'Dorcas', 'Mukami', 'Wakina', 'male', 35903017, 'mukamigichere@gmail.com', 'Administration Officer', '0727497706', '1998-11-04', 'Murang`a', 1, 1, NULL, NULL, '2026-01-10', 'permanent', 'hr_manager', NULL, '2025-10-09 12:54:45', '2025-10-21 08:43:38', 'active', '5', '[]', NULL),
(429, 'cb7f040d84c6d7d025a4897ec71fe5f9cfb501a83e9bc0d8c30bddf3d5cf0404', '219', 'Moses', 'Kamande', 'Kamau', '', 39350518, 'moseskamandekamau@gmail.com', 'Meter Reader', '0748094260', '2001-08-04', 'Murang`a', 2, 14, NULL, NULL, '2026-01-11', 'permanent', 'officer', NULL, '2025-10-09 12:54:45', '2025-10-21 08:43:38', 'active', '5', '', NULL),
(430, '83fb1b0f1a3ed9c6cdfc242adb1b15a5dc0330d44927facf5388d9a0875dc029', '221', 'Gerald', 'Nganga', 'mwangi', '', 34330734, 'mwangigerald216@gmail.com', 'Office Assistant', '0701070882', '1995-09-09', 'Murang`a', 3, 18, NULL, NULL, '2026-01-12', 'permanent', 'officer', NULL, '2025-10-09 12:54:45', '2025-10-21 08:43:38', 'active', '5', '', NULL),
(431, 'a0e0100bd073cb48a3321eaf34f4b9db3214f5eeb8af67e7cc8c97b1f67ce2d4', '222', 'Peter', 'Kimani', 'Thomi', '', 22815071, 'Peterthomipeter9@gmail.com', 'Technician', '0711968470', '1980-10-09', 'Murang`a', 3, 7, NULL, NULL, '2026-01-13', 'permanent', 'officer', NULL, '2025-10-09 12:54:45', '2025-10-21 08:43:38', 'active', '5', '', NULL),
(432, 'b02eff006047b8b09c9d1c16583a157ff3978e9a76b55fbfca8527cbda344e1d', '223', 'Njuguna', 'Morgan', 'Mwangi', '', 34424165, 'mwangimorgan369@gmail.com', 'Technician', '0748763664', '1997-11-30', 'Murang`a', 3, 7, NULL, NULL, '2026-01-14', 'permanent', 'officer', NULL, '2025-10-09 12:54:46', '2025-10-21 08:43:38', 'active', '5', '', NULL),
(433, '4c6f9a2885cc233d9e4553bd897427576453b0611b396d174a97c2d4f0694d7f', '224', 'Susan', 'Wairimu', 'Karanja', '', 39196082, 'ksuwairimu424@gmail.com', 'Revenue Officer', '0791557495', '2001-12-24', 'Murang`a', 2, 2, NULL, NULL, '2026-01-15', 'permanent', 'officer', NULL, '2025-10-09 12:54:46', '2025-10-21 08:43:38', 'active', '5', '', NULL),
(434, 'c426c329d92c618bb2fc6af4b134dd8555aabd0d38f4d8c23577d3f8284ca093', '225', 'Hezron', 'Njoroge', 'Mutharu', 'male', 30442579, 'hezmutharu@gmail.com', 'Asst. ICT Officer', '0713606709', '1994-05-01', 'Murang`a', 2, NULL, NULL, NULL, '2026-01-16', 'permanent', 'dept_head', NULL, '2025-10-09 12:54:46', '2025-10-21 08:43:39', 'active', '5', '[]', NULL),
(435, '52c0477fec360780ac086faa44de97bd1bfb13c99bd040d41a13c2638cda7a8e', '226', 'CONNIE', 'WANJIKU', 'KIHARA', '', 34401651, 'wanjikuconny@gmail.com', 'Procurement Officer', '0710251734', '1998-01-23', 'Murang`a', 2, 16, NULL, NULL, '2026-01-17', 'permanent', 'officer', NULL, '2025-10-09 12:54:46', '2025-10-21 08:43:39', 'active', '5', '', NULL),
(436, '867ba9bfc7893d7a93cabcfcf9d7cd01c026d151e7a7596a9fe10a67fa94df85', '227', 'Faith', 'Nunga', 'Wamburu', '', 37887347, 'wamburufaith@gmail.com', 'Meter Reader', '0111276150', '2000-10-17', 'Murang`a', 4, 5, NULL, NULL, '2026-01-18', 'permanent', 'officer', NULL, '2025-10-09 12:54:46', '2025-10-21 08:43:39', 'active', '5', '', NULL),
(437, 'c46fb022830f3bd15a5ab83b51090ea5528c8bb5f68fafb4017bafc715b3b1fa', '228', 'Caroline', 'wanjira', 'wanyoike', '', 28597786, 'ben796756@gmail.com', 'Meter Reader', '0720651524', '1990-01-01', 'Murang`a', 5, 6, NULL, NULL, '2026-01-19', 'permanent', 'officer', NULL, '2025-10-09 12:54:46', '2025-10-21 08:43:39', 'active', '5', '', NULL),
(438, '890baab0b264158354c822d7880c02fff8ebed5f82fcd21c83a873b8d497f044', '229', 'Kelvin', 'kariuki', 'chege', '', 34464723, 'kelvinandrewkariuki@gmail.com', 'Technician', '0745016519', '1997-03-19', 'Murang`a', 3, 7, NULL, NULL, '2026-01-20', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:39', 'active', '5', '', NULL),
(439, 'f040bbbd502ef470fe57f300f7322e3426fd20fa3bc4d3350ec8410e59d060e8', '231', 'Patrick', 'Mwaniki', 'Wambugu', '', 25879831, 'wambugupatrick88@gmail.com', 'Driver', '0711226687', '1987-09-08', 'Murang`a', 1, 17, NULL, NULL, '2026-01-21', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:39', 'active', '5', '', NULL),
(440, 'ca6ebafdc657c86d9a99e95855dd34a600fab7b3c8b5a20055cdccb309e8875a', '232', 'Mary', 'Nyambura', 'Kahara', '', 22405757, 'marykahara@gmail.com', 'Asst. Procurement Officer', '0721880882', '1980-01-01', 'Murang`a', 1, 16, NULL, NULL, '2026-01-22', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:40', 'active', '5', '', NULL),
(441, '684007b166057e79a26ebbc1b76f4db084715ca1a0012d664d086e805fe0f206', '233', 'MAINA', 'ALEX', 'KAMAU', 'male', 29064617, 'alphalamyna@gmail.com', '0', '0720593975', '1989-01-10', 'Murang`a', 1, NULL, NULL, NULL, '2026-01-23', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:40', 'active', '5', '[]', NULL),
(442, '30955729f099b8834153c35b315b99f0c791d6ba1ae193befca074c61a5036df', '234', 'Winrose', 'Muthoni', 'Njai', '', 26455280, 'winrosemuthoninjai@gmail.com', 'Office Assistant', '0701304940', '1985-06-04', 'Murang`a', 5, 6, NULL, NULL, '2026-01-24', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:40', 'active', '5', '', NULL),
(443, '95883ecc1bb91c034532d52bfce0e660f53572f5594d1efcaedc6fa33160e72b', '235', 'Manase', 'Kimari', '', '', 35676974, 'manasekimari254@gmail.com', 'Asst. Accountant', '0791064285', '1998-12-01', 'Murang`a', 2, 2, NULL, NULL, '2026-01-25', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:40', 'active', '5', '', NULL),
(444, 'aa9fa7af8788d3c6eed6812f35157ff4dffc12d2f3b5beeb68fbc137e6fd1808', '237', 'Joan', 'Njeri', 'munyaka', '', 31677952, 'munyakajoanne@gmail.com', 'Office Assistant', '0726246236', '1995-01-14', 'Murang`a', 5, 6, NULL, NULL, '2026-01-26', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:40', 'active', '5', '', NULL),
(445, 'c31e31fbbe0b681e57f13af1cedc1d50e3211a7081249e50c3c627af4ea83dca', '86044155', 'Virginia', 'wanjiku', 'wangai', '', 8652642, 'virginiawangai579@gmail.com', 'Driver', '0721638937', '1967-10-09', 'Murang`a', 1, 17, NULL, NULL, '2026-01-27', 'permanent', 'officer', NULL, '2025-10-09 12:54:47', '2025-10-21 08:43:40', 'active', '5', '', NULL),
(446, '470a5f9216db9fd6e234ceee0555f76aadea8124bc35e47d9efbefa3aab8fb81', '1991001489', 'PHILOMENA', 'WANJIRU', 'MWANGI', 'female', 9811790, 'philoo208@gmail.com', 'Human Resource Manager', '0720823265', '1968-12-25', 'Murang`a', 1, 1, NULL, NULL, '2026-01-28', 'permanent', 'hr_manager', 'uploads/profile_images/68ee1439b0027.jpg', '2025-10-09 12:54:48', '2025-10-21 08:43:41', 'active', '5', '[]', NULL),
(447, '394186ca62f2ac133f7f3c12d3a26ff77e2f2f45b8d661482972ec885322f24f', '000', 'KEITH', 'NJUGUNA', 'KIMANI', '', 38161855, 'keithnjuguna01@gmail.com', 'Office Assistant', '0795096315', '2000-04-10', 'Murang`a', 5, 4, NULL, NULL, '2026-01-29', 'permanent', 'officer', NULL, '2025-10-09 12:54:48', '2025-10-21 08:43:41', 'active', '5', '', NULL),
(448, '3269a79dc8940878fbf7286ac0d54134b20fd98c9ca530e2df0ac570d8ff8fc0', '001', 'Siphira', 'wairimu', 'kamau', '', 24577702, 'siphirahwairimu@yahoo.com', 'Asst. Commercial Manager (Finance)', '0727316130', '1984-04-13', 'Murang`a', 2, 2, NULL, NULL, '2026-01-30', 'permanent', 'officer', NULL, '2025-10-09 12:54:48', '2025-10-21 08:43:41', 'active', '5', '', NULL),
(449, '05e8e957277bbe9db12d7ec8c7877ee568f12e4ec2a3aeaf1a96af1a0a2bcddf', '008', 'CAROLINE', 'WAITHIRA', 'KAMANDE', '', 22426392, 'kamandecarol@gmail.com', 'Customer Relations Officer', '0724776490', '1980-11-01', 'Murang`a', 4, 5, NULL, NULL, '2026-01-31', 'permanent', 'officer', NULL, '2025-10-09 12:54:48', '2025-10-21 08:43:41', 'active', '5', '', NULL),
(450, 'c1890b375f8cc5976064b61b643691e166b0afa114eb1c3b20d4a3e631db3f09', '018', 'Josephine', 'Wambui', 'Kinuthia', '', 23480038, 'jwambuikinuthia@yahoo.com', 'Asst. Commercial Manager (Revenue)', '0726230995', '1983-03-16', 'Murang`a', 2, 14, NULL, NULL, '2026-02-01', 'permanent', 'officer', NULL, '2025-10-09 12:54:48', '2025-10-21 08:43:41', 'active', '5', '', NULL),
(451, '9a321474ecdd518a4a1f7580df8ac9cb5d948a7ca79c4522ee4c4bc087b5a76c', '019', 'Joyce', 'Wainaina', '', 'female', 24610405, 'joymwihaki@gmail.com', 'Snr. ICT Officer', '0725355372', '1986-11-07', 'Murang`a', 2, 3, NULL, NULL, '2026-02-02', 'permanent', 'section_head', NULL, '2025-10-09 12:54:48', '2025-10-21 08:43:42', 'active', '5', '[]', NULL),
(452, '2189c7446657f2931ca9fcca73db0eb312c6b777c1e93dc02fb58989ba877f9a', '020', 'Elias', 'Ekutu', 'Gichuhi', '', 24039016, 'gichuhielias@gmail.com', 'Water Production Operator', '0725348008', '1983-10-09', 'Murang`a', 3, 18, NULL, NULL, '2026-02-03', 'permanent', 'officer', NULL, '2025-10-09 12:54:48', '2025-10-21 08:43:42', 'active', '5', '', NULL),
(453, '48c4523f25b7d2e6452daea06165623fcde500a5c43ee5303ff1cd90691d0098', '021', 'Joram', 'Chege', 'Karuga', '', 25228612, 'kajorchy@gmail.com', 'Technician', '0722864174', '1984-10-13', 'Murang`a', 3, 18, NULL, NULL, '2026-02-04', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:42', 'active', '5', '', NULL),
(454, '70d1fc4cddcb5a8c524665ccb8f42826c1b0b88ed7dff23fdf1128f4002850d7', '022', 'Mwangi', 'Julius', 'Antony', '', 22973062, 'githiakajulius@gmail.com', 'Technician', '0716038790', '1982-09-19', 'Murang`a', 5, 6, NULL, NULL, '2026-02-05', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:42', 'active', '5', '', NULL),
(455, 'c3bcf271437b07d49a8ee3486a3df02b85a0400e197c921f6a3ba92822a0ac13', '023', 'Julia', 'Waithira', 'Munene', '', 21698611, 'juliatony2030@gmail.com', 'Quality Assurance Officer', '0721401068', '1979-07-23', 'Murang`a', 3, 18, NULL, NULL, '2026-02-06', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:42', 'active', '5', '', NULL),
(456, '87e101bab818f8c9bf44531549b3cf3e32d4d7d7a8916a58386e41e142b0f764', '026', 'Patrick', 'Munga', 'Njeru', '', 20769554, 'pruje@yahoo.com', 'Internal Audit Manager', '0724458019', '1978-08-21', 'Murang`a', 1, 19, NULL, NULL, '2026-02-07', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:43', 'active', '5', '', NULL),
(457, '20e14f458163a87275d7d174519ac114c707b10d403da44be400d972c2858dc3', '028', 'Beatrice', 'Wanja', 'Wagura', '', 25132402, 'bettywanja24@yahoo.com', 'Revenue Officer', '0726656222', '1986-12-10', 'Murang`a', 2, 14, NULL, NULL, '2026-02-08', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:43', 'active', '5', '', NULL),
(458, '3bf8afb07cc11236f92cd67f0ec7e3edaf0a6fc698f974e3567bc8cfab955a17', '029', 'Pauline', 'Wairimu', '', '', 24849684, 'paulinewairimuwanjiru13@gmail.com', 'Meter Reader', '0725861554', '1975-08-25', 'Murang`a', 2, 14, NULL, NULL, '2026-02-09', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:46', 'active', '5', '', NULL),
(459, 'd33b2034162d5b1ee2c04b45a5b926e2dd59f11031797171b3579c6a190bff8f', '030', 'John', 'Kiai', '', '', 21776473, 'johnkiai79@gmail.com', 'Technician', '0725518986', '1979-12-05', 'Murang`a', 3, 7, NULL, NULL, '2026-02-10', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:48', 'active', '5', '', NULL),
(460, '46e0e56937d3570f3f7e9b518551ac667b7c108592aad4a7cdd31ac0b9025060', '032', 'Gerald', 'Kamau', 'Kimani', '', 24137641, 'gearkim06@gmail.com', 'Accountant', '0725903893', '1985-06-18', 'Murang`a', 2, 2, NULL, NULL, '2026-02-11', 'permanent', 'officer', NULL, '2025-10-09 12:54:49', '2025-10-21 08:43:50', 'active', '5', '', NULL),
(461, '4fe5f1b78159c9c8ed7045cf941a3f89f0501fcad4889fea02f11b3d98b31f4c', '034', 'Cecilia', 'Njoki', 'Gachanja', 'female', 27941411, 'njokicecilia@gmail.com', 'Revenue Officer', '0717463504', '1989-05-29', 'Murang`a', 2, 12, NULL, NULL, '2026-02-13', 'permanent', 'sub_section_head', 'uploads/profile_images/68ee2d805d187.jpeg', '2025-10-09 12:54:50', '2025-10-21 13:29:13', 'active', '5', '[]', 1),
(462, '15bda22e4bc0b088a88c6f9436e2d0442fa4c5422f3b201522a09c2bc0c7cfe5', '035', 'CHRISTINE', 'WANJIKU', NULL, 'female', 28671709, 'christinenjogu87@gmail.com', '0', '0725951329', '1987-10-31', 'Murang`a', 1, 1, NULL, NULL, '2026-02-14', 'permanent', 'officer', NULL, '2025-10-09 12:54:50', '2025-10-21 08:43:52', 'active', '5', '[]', NULL),
(463, '28f414341301a6c2ba4a0d572787e1f0b64cab175686207a2bcd5a683899d696', '036', 'Rose', 'Muthoni', 'Kahara', '', 21754968, 'rosekahara5@gmail.com', 'Revenue Officer', '0708683017', '1977-12-05', 'Murang`a', 2, 14, NULL, NULL, '2026-02-15', 'permanent', 'officer', NULL, '2025-10-09 12:54:50', '2025-10-21 08:43:52', 'active', '5', '', NULL),
(464, '68f4edfc407498a80e7a646b90b189011e16a58b9b5f4ccad743b8f71d2eb057', '040', 'Lilian', 'Wanjiru', 'Maina', 'female', 22644383, 'lillianmaina51@gmail.com', 'Monitoring & Evaluation Manager', '0722165154', '1983-12-31', 'Murang`a', 1, 13, NULL, NULL, '2026-02-16', 'permanent', 'manager', NULL, '2025-10-09 12:54:50', '2025-10-21 08:43:53', 'active', '5', '[]', NULL),
(465, '56df0c23ae18699a2c8636cca0eef25abc129d12cdb172929f2234de9efc63f3', '041', 'Pithon', 'wanderi', 'thuku', '', 25701138, 'wanderi.pithon@gmail.com', 'Debt Controller', '0720627123', '1987-04-26', 'Murang`a', 3, 7, NULL, NULL, '2026-02-17', 'permanent', 'officer', NULL, '2025-10-09 12:54:50', '2025-10-21 08:43:54', 'active', '5', '', NULL),
(466, '5351ca141a7f70c89b7eaa7bb1a7babd49ed75eed2fa52ee00a14a3fb48fa731', '042', 'John', 'Kaiganira', 'Mwangi', '', 25701526, 'kaiganirajohn@yahoo.com', 'Assistant Auditor', '0724481550', '1988-04-21', 'Murang`a', 5, 2, NULL, NULL, '2026-02-18', 'permanent', 'officer', NULL, '2025-10-09 12:54:50', '2025-10-21 08:43:54', 'active', '5', '', NULL),
(467, '8342b55663aaa741fc4ccfee3d3855a04a9647f63cfcd7bf77e92ae849f7ca44', '043', 'Peter', 'Ng\'ang\'a', 'Ngige', '', 26468677, 'ngangapeter827@gmail.com', 'Water Production Operator', '0716346948', '1989-04-26', 'Murang`a', 3, 18, NULL, NULL, '2026-02-19', 'permanent', 'officer', NULL, '2025-10-09 12:54:51', '2025-10-21 08:43:54', 'active', '5', '', NULL),
(468, '1e8dae1350f9f0dc2e868185b2d6a631cbdebc0f648b8461e6608adf2113abc2', '046', 'Francis', 'I.', 'Macharia', '', 25808624, 'mirungufrancis@gmail.com', 'Asst. Technical Manager', '0728071619 or 0112 0', '1986-02-27', 'Murang`a', 3, 7, NULL, NULL, '2026-02-20', 'permanent', 'officer', NULL, '2025-10-09 12:54:51', '2025-10-21 08:43:55', 'active', '5', '', NULL),
(469, '32be4981c3a1db30100049cf9bb989435fe5b0a450001d5e39af58ffede082a8', '050', 'Nancy', 'kabura', 'Karanja', '', 27829053, 'nicyk254@gmail.com', 'Accountant', '0726082287', '1989-04-26', 'Murang`a', 1, 19, NULL, NULL, '2026-02-21', 'permanent', 'officer', NULL, '2025-10-09 12:54:51', '2025-10-21 08:43:55', 'active', '5', '', NULL),
(470, 'c1d6034c4a2ddb423fa8b9a5a04218993b654d4202b9748c4380db006fb3beb9', '051', 'ANTONY', 'KARANI', '', '', 27734504, 'karaniantony@gmail.com', 'Region Officer', '0718816853', '1988-08-27', 'Murang`a', 3, 7, NULL, NULL, '2026-02-22', 'permanent', 'officer', NULL, '2025-10-09 12:54:51', '2025-10-21 08:43:56', 'active', '5', '', NULL),
(471, '94919233ef8534ee8728c1056b622f9eab071667260f9709612ba77c3bd6374b', '053', 'Joseph', 'karanja', 'Mwangi', '', 29299160, 'joskaranja50@gmail.com', 'Technician', '0711405587', '1990-01-01', 'Murang`a', 3, 7, NULL, NULL, '2026-02-23', 'permanent', 'officer', NULL, '2025-10-09 12:54:51', '2025-10-21 08:43:56', 'active', '5', '', NULL),
(472, '307054550f1a81ff36852caaecb814894a603b2d481b6b0dc1be052a91e33889', '054', 'John', 'Chege', '', '', 14544241, 'johnchegemacharia75@gmail.com', 'Technician', '0721915093', '1975-04-21', 'Murang`a', 3, 15, NULL, NULL, '2026-02-24', 'permanent', 'officer', NULL, '2025-10-09 12:54:51', '2025-10-21 08:43:56', 'active', '5', '', NULL),
(473, 'af9ff8b5993e7db08e0fe24ffbbc5df9e1d7bea8b155ef5c53d60f7e00661292', '055', 'JAMES', 'MAINA', 'NJUGUNA', '', 26421690, 'jimmybrown.jm@gmail.com', 'Region Officer', '0725994507', '1987-02-06', 'Murang`a', 3, 7, NULL, NULL, '2026-02-25', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:57', 'active', '5', '', NULL),
(474, '0eb2cf8a6c02ccb1e2cb826f009e0d93b3ddc5edbbde157b6e4eaa7f255ae74e', '056', 'DAVID', 'IRUNGU', 'THUGU', 'male', 28478961, 'davidthugu@gmail.com', 'Asst. Commercial Manager ( Revenue)', '0711870625', '1991-08-10', 'Murang`a', 2, 12, NULL, NULL, '2026-02-26', 'permanent', 'section_head', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:57', 'active', '5', '[]', NULL),
(475, 'abd7e6f5142f49154bd8d618ab4bc469ec8e55eb4fb71e3119af12f4f98da05b', '057', 'Esther', 'wanjiru', 'Mburu', '', 21046174, 'estherwanjiru482@gmail.com', 'Driver', '0721377931', '1976-04-16', 'Murang`a', 1, 17, NULL, NULL, '2026-02-27', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:57', 'active', '5', '', NULL),
(476, '3388e5adf2a61fb4e10274ec76c41f747b4934b871b8f6933140c72547c7f6e6', '058', 'Jacob', 'Mbuthia', 'Wambui', '', 27651238, 'jacobmbuthia@yahoo.com', 'Corporate Affairs Manager', '0715038398', '1989-10-29', 'Murang`a', 4, 5, NULL, NULL, '2026-02-28', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:57', 'active', '5', '', NULL),
(477, '0228ef49dd3d5dbb738cde75e40962617ba4ca65029fdf0ced0869f646080202', '059', 'Grace', 'wainaina', '', '', 25229706, 'gwanjirii@gmail.com', 'Technician', '0725559431', '1986-08-08', 'Murang`a', 2, 14, NULL, NULL, '2026-03-01', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:58', 'active', '5', '', NULL),
(478, 'd4cd0dc25acf90b15f008c81bb7017edbafd68dffb3ff90f31c56722464d7c6f', '062', 'Christopher', 'Mwangi', '', '', 29237893, 'wanguichristopher32@gmail.com', 'NRW Manager', '0764 446781', '1991-11-01', 'Murang`a', 3, 10, NULL, NULL, '2026-03-02', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:58', 'active', '5', '', NULL);
INSERT INTO `employees` (`id`, `profile_token`, `employee_id`, `first_name`, `last_name`, `surname`, `gender`, `national_id`, `email`, `designation`, `phone`, `date_of_birth`, `address`, `department_id`, `section_id`, `position`, `salary`, `hire_date`, `employment_type`, `employee_type`, `profile_image_url`, `created_at`, `updated_at`, `employee_status`, `scale_id`, `next_of_kin`, `subsection_id`) VALUES
(479, 'ddbfcc83fa3ff8ab74e16dc9a38c9cf052b27382f057943182bd8e9815f6b96b', '063', 'Gidraph', 'Ngumba', 'Irungu', '', 28128265, 'gidraphngumba@gmail.com', 'Technician', '0712647026', '1990-10-09', 'Murang`a', 3, 15, NULL, NULL, '2026-03-03', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:43:59', 'active', '5', '', NULL),
(480, 'c014ca2785da6fde2b0e71e0bd9c62e459c4549f56f36cdc3b6b0ec71c2044a0', '064', 'Francis', 'Ndung\'u', 'Mwangi', '', 21211297, 'francismwangi261@gmail.com', 'Sewerage Artisan', '0720118840', '1978-09-28', 'Murang`a', 3, 15, NULL, NULL, '2026-03-04', 'permanent', 'officer', NULL, '2025-10-09 12:54:52', '2025-10-21 08:44:00', 'active', '5', '', NULL),
(481, 'bcbc2c0abd6b7074afb71d4bb4f9a270a9a022d07f54da40600a37d1eff7627d', '065', 'JANE', 'WANJIKU', 'NDUGURE', '', 21939297, 'janendugire2015@gmail.com', 'Customer Service Assistant', '0712058650', '1979-10-10', 'Murang`a', 4, 5, NULL, NULL, '2026-03-05', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:02', 'active', '5', '', NULL),
(482, 'cd426379cc07f9876dbf5843692dcc2ba250faf53eeb1bb6ff8b4d14d0b5e053', '068', 'RAHAB', 'MURINGI', 'MAINA', '', 20919548, 'mevinmaina@gmail.com', 'Technician', '0710433367', '1978-06-24', 'Murang`a', 2, 14, NULL, NULL, '2026-03-06', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:05', 'active', '5', '', NULL),
(483, 'aa4c0901a7ac9f1d1b440aaa76152179303400539eb1c30201864e6808cd6bf4', '072', 'Aaron', 'Maina', 'Muchina', '', 27084325, 'amuchina88@gmail.com', 'GIS Officer', '0728110465', '1989-05-24', 'Murang`a', 3, 8, NULL, NULL, '2026-03-07', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:06', 'active', '5', '', NULL),
(484, '037040acb732edae93fa9ca9d5ef6e6c14e018fc6452c54217c50cd63d0204b1', '073', 'Evans', 'Gitari', 'Kinyua', '', 24541491, 'evansonkinyua@yahoo.com', 'Asst. Accountant', '0726390559', '1983-08-01', 'Murang`a', 2, 2, NULL, NULL, '2026-03-08', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:06', 'active', '5', '', NULL),
(485, '25801060a372ffa486b74ca71fc088a1be3ed130e540b5d7e45e91004bfdc8e6', '077', 'Saweria', 'muthoni', 'elias', '', 13253944, 'saweriamelia@gmail.com', 'Water Production Operator', '0725456988', '1973-10-09', 'Murang`a', 3, 18, NULL, NULL, '2026-03-09', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:06', 'active', '5', '', NULL),
(486, '6c62b357159965888b628c7ee133fd511a2c333317dfb53f00f3637f684d5054', '078', 'JOSEPH', 'KINYUA', '', '', 27830985, 'josetycoon@gmail.com', 'ICT Officer', '0715562816', '1990-05-29', 'Murang`a', 2, 3, NULL, NULL, '2026-03-10', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:07', 'active', '5', '', NULL),
(487, '86afa3e229cded58bd931451fd5750607490b1b7c30bc76fa31aedf89130a7ac', '079', 'Florence', 'waithera', 'mutahi', '', 27281235, 'vicjas009@gmail.com', 'Meter Reader', '0727537600', '1988-03-03', 'Murang`a', 2, 14, NULL, NULL, '2026-03-11', 'permanent', 'officer', NULL, '2025-10-09 12:54:53', '2025-10-21 08:44:08', 'active', '5', '', NULL),
(488, '071fc9c7c2dfe1dcaa9ff90b67c5d6ab0289f0f7affbba28de75b76f7707e041', '081', 'Bernard', 'Kihara', 'Kamau', '', 24953335, 'bernardkiharakamau@gmail.com', 'Region Officer', '0726224387', '1986-06-28', 'Murang`a', 3, 7, NULL, NULL, '2026-03-12', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:08', 'active', '5', '', NULL),
(489, '021ad872edbc2950f8326a4a4df8bbc9cdd602ff8e413bb6666e1e06b4c74be0', '083', 'DAVID', 'KIMANI', 'IRUNGU', '', 29313135, 'kdavepaul42@gmail.com', 'Technician', '0702579481', '1990-08-17', 'Murang`a', 3, 7, NULL, NULL, '2026-03-13', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:09', 'active', '5', '', NULL),
(490, 'be9fbcecd8ab2bb2102e958863caba8d583910b071aa5e5b2dacb00840a9c982', '084', 'Nephat', 'Mûchoki', 'Maina', '', 27828216, 'nephatmaina20@gmail.com', 'Technician', '0725619878', '1990-05-01', 'Murang`a', 3, 7, NULL, NULL, '2026-03-14', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:10', 'active', '5', '', NULL),
(491, 'cefa02207fe5df2171834ce06f15d864d3914576773589dd1f9ac9003e475ad8', '085', 'PETER', 'KARIUKI', 'MWANGI', '', 26644346, 'mwangipeter155@gmail.com', 'Technician', '0720398637', '1986-02-16', 'Murang`a', 3, 7, NULL, NULL, '2026-03-15', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:10', 'active', '5', '', NULL),
(492, 'f1ed03839ffa741f383eff3d428c8685b95cf522321c927117bb676321885e83', '086', 'Kenneth', 'Githumbi', 'Macharia', '', 25825289, 'machariaken86@gmail.com', 'Technician', '0728260908', '1986-12-01', 'Murang`a', 3, 7, NULL, NULL, '2026-03-16', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:11', 'active', '5', '', NULL),
(493, '4dfb029023972b19a4812eb063a2577ba54048c3e1a727cad3739f52779f454a', '087', 'Edwin', 'Wari', 'kimani', '', 29217292, 'wariedwin20@gmail.com', 'Technician', '0708534511', '1992-08-20', 'Murang`a', 3, 7, NULL, NULL, '2026-03-17', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:12', 'active', '5', '', NULL),
(494, 'e3c9e5d5d908f167a439a9a2fb3f2bdf820e2c750cf9efa7bad4539da57f648a', '090', 'Charles', 'Waweru', 'Gichuki', '', 10643030, 'gichukic70@gmail.com', 'Sewerage Artisan', '0795931676', '1970-10-09', 'Murang`a', 3, 15, NULL, NULL, '2026-03-18', 'permanent', 'officer', NULL, '2025-10-09 12:54:54', '2025-10-21 08:44:13', 'active', '5', '', NULL),
(495, '4bdc7ad09e56586e9c55367634eb8701b2746be515f430f182e6761017f301e3', '091', 'Mary', 'Ndirangu', '', '', 30061434, 'maryndirangu132@gmail.com', 'Water Production Officer', '0717524190', '1992-04-03', 'Murang`a', 3, 18, NULL, NULL, '2026-03-19', 'permanent', 'officer', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:14', 'active', '5', '', NULL),
(496, '6bc93c5e2aecc90b09207c47007dbda1fd7ce7d2e59fbc4263d1883ea2dd3d43', '094', 'Didmus', 'Mwangi', 'Mwaniki', '', 14565915, 'didmusmwangi@gmail.com', 'Chemical Attendant', '0727146946', '1977-02-03', 'Murang`a', 3, 18, NULL, NULL, '2026-03-20', 'permanent', 'officer', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:14', 'active', '5', '', NULL),
(497, '08c0ec0096e1664edfb1e51f154b9458de41ccea561c496a479493050fa9cb29', '096', 'James', 'Mwangi', 'kanda', '', 10168916, 'jmkanda2016@gmail.com', 'Water Inspector', '0723052124', '1970-10-09', 'Murang`a', 1, 19, NULL, NULL, '2026-03-21', 'permanent', 'officer', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:14', 'active', '5', '', NULL),
(498, '594644135f9ae4564553f7a8a17e9192792cba62ac961aa1306791338098d84f', '097', 'Antony', 'Gitau', '', '', 11066503, 'gitau67@gmail.com', 'Intake Attendant', '0720220935', '1970-07-12', 'Murang`a', 3, 18, NULL, NULL, '2026-03-22', 'permanent', 'officer', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:15', 'active', '5', '', NULL),
(499, '18e0410a5d90f71e4fc15f8c0b30509ef401f1d19415f4366b70198816cd6538', '099', 'Beatrice', 'wanjiru', 'Mbugua', '', 27445768, 'btshish@gmail.com', 'Customer Service Assistant', '0708686083', '1988-10-06', 'Murang`a', 4, 5, NULL, NULL, '2026-03-23', 'permanent', 'officer', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:15', 'active', '5', '', NULL),
(500, '55be4805cde941f1312715f35b886c04a6cf6bf7da1a76c4ebd9fd0a961dd0a4', '20 001', 'NG\'ANG\'A', 'Daniel', '', 'male', 21747601, 'Kimahmahh@gmail.com', 'Managing Director', '0721626795', '1978-01-01', 'Murang`a', NULL, NULL, NULL, NULL, '2026-03-24', 'permanent', 'managing_director', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:15', 'active', '5', '[]', NULL),
(501, '589d766d475741fa2bb243dfd825d176b60535fa6f55257b9c66b079a07ea5b5', '200003', 'Peter', 'Mwangi', 'Karenju', '', 21711173, 'pmkarenju@gmail.com', 'Technical Services Manager', '0722664121', '1979-09-24', 'Murang`a', 3, 20, NULL, NULL, '2026-03-25', 'permanent', 'officer', NULL, '2025-10-09 12:54:55', '2025-10-21 08:44:16', 'active', '5', '', NULL),
(502, 'dbec2d9b89078c7e578eefc5d64d8d549f80e0857ec726ee372776c4f65f0ad9', '20002', 'Joseph', 'Maina', 'Mukundi', 'male', 10446122, 'bcmutai88@yahoo.com', 'Commercial Manager', '0721107436', '1967-05-05', 'Murang`a', 2, NULL, NULL, NULL, '2026-03-26', 'permanent', 'dept_head', NULL, '2025-10-09 12:54:56', '2025-10-21 08:44:17', 'active', '5', '[]', NULL),
(503, '8ee5b01729e7dd82dd0ce8a05fbb5fd5083cae3bce1ff9d49ded3e402df6a481', 'Mow 05', 'Julius', 'chomba', 'Ngugi', '', 9153049, 'jvngugi66@mail.com', 'Water Production Operator', '0727495927', '1966-10-09', 'Murang`a', 3, 18, NULL, NULL, '2026-03-27', 'permanent', 'officer', NULL, '2025-10-09 12:54:56', '2025-10-21 08:44:17', 'active', '5', '', NULL),
(504, '2712c687eee471a78f3c1abdf5a919a6d36f0df0e63eaa042781400df1dff9a5', 'MOW07', 'Stephen', 'k', 'mbugua', '', 9270065, 's.k.mbugua58@gmail.com', 'Technician', '0729693470', '1966-10-09', 'Murang`a', 3, 7, NULL, NULL, '2026-03-28', 'permanent', 'officer', NULL, '2025-10-09 12:54:56', '2025-10-21 08:44:17', 'active', '5', '', NULL),
(505, '052301bc934cf0ff66356dc5e1c93f0afcd0077e0af304badcea32c5c8d9ce7b', 'Mow08', 'Samuel', 'kamau', 'muriathi', '', 9291811, 'smuriathi@gmail.com', 'Driver', '0721974813', '1968-03-05', 'Murang`a', 1, 17, NULL, NULL, '2026-03-29', 'permanent', 'officer', NULL, '2025-10-09 12:54:56', '2025-10-21 08:44:17', 'active', '5', '', NULL),
(506, 'b45ef992dabbb70e8c45772a201197c2e0fa93ce355c439f2e891cfba44fb861', 'MOW12', 'Stephen', 'kariuki', 'Kiiru', '', 8988049, 'Stephenkiiru394@gmail.com', 'Technician', '0720437122', '1966-10-09', 'Murang`a', 3, 7, NULL, NULL, '2026-03-30', 'permanent', 'officer', NULL, '2025-10-09 12:54:56', '2025-10-21 08:44:18', 'active', '5', '', NULL),
(507, 'd25826f0ebd98e7c9a56a11dcc4a814f81411c72cfd592e7b751656fa97ca4e6', '194', 'Simon', 'Gitau', '', '', 20235632, 'simongitaujohn@gmail.com', 'Office Assistant', '746757028', '1976-03-01', 'Murang`a', 3, 18, NULL, NULL, '2026-03-31', 'permanent', 'officer', NULL, '2025-10-09 12:54:56', '2025-10-21 08:44:18', 'active', '5', '', NULL),
(508, '92b1b90d950d06bc9d9488a6962e49c7f8e84d2f84b87926af092f3b13a754d0', '190', 'Kelvin', 'Kariuki', 'Muturi', '', 37775922, 'kelvinmuturi2019@gmail.com', '', '708836689', '0000-00-00', 'Murang`a', 2, 2, NULL, NULL, '2026-04-01', 'permanent', 'officer', NULL, '2025-10-09 12:54:57', '2025-10-21 08:44:18', 'active', '5', '', NULL),
(509, 'b323c106716f0b20354fb541255c5c71d0c238406e9984b2df10590376cfe58c', '236', 'SAMUEL', 'MUKURIA', 'NJOKI', '', 342108789, 'mukuriasamuel478@gmail.com', 'Technician', '704857189', '1995-02-05', 'Murang`a', 3, 7, NULL, NULL, '2026-04-02', 'permanent', 'officer', 'uploads/profile_images/68e7b23eac3fd.jpg', '2025-10-09 12:54:57', '2025-10-21 08:44:18', 'active', '5', '', NULL),
(510, 'c90bc46ebbd52ee2ba60ba6df522bb8b98d32b339ef113e80318fbdddd030d34', '44', 'Stephen', 'Kibue', 'Gichogo', '', 10875188, 'skibue546@gmail.com', 'Meter Reader', '754152140', '1970-02-08', 'Murang`a', 2, 14, NULL, NULL, '2026-04-06', 'permanent', 'officer', NULL, '2025-10-09 12:54:57', '2025-10-21 08:44:18', 'active', '5', '', NULL),
(511, 'c06df57e34b2485b98ddd81f23f80bed31d18374c89298af67d5c125f8004100', '116', 'Simon', 'Karanja', 'Mwaura', 'male', 23000306, 'skaranja700@gmail.com', 'Technician', '723142964', '1982-12-03', 'Murang`a', NULL, NULL, NULL, NULL, '2026-04-07', 'permanent', 'bod_chairman', NULL, '2025-10-09 12:54:58', '2025-10-21 08:44:19', 'active', '5', '[]', NULL),
(512, 'd10bc780fab6f2ff4a0289378ba3b7d0e3efa20598aaab4f5d3f502cabf21937', '52', 'Peter', 'Mburu', 'Njogu', 'male', 27, 'mburupeter1000@gmail.com', 'Plumber', '704919059', '1987-05-04', 'Murang`a', 3, 7, NULL, NULL, '2026-04-08', 'permanent', 'officer', 'uploads/profile_images/68f749c106772.jpg', '2025-10-09 12:54:58', '2025-10-21 08:52:17', 'active', '5', '[]', NULL);

--
-- Triggers `employees`
--
DELIMITER $$
CREATE TRIGGER `trg_unique_roles` BEFORE INSERT ON `employees` FOR EACH ROW BEGIN
    -- Only one Managing Director
    IF NEW.employee_type = 'managing_director' THEN
        IF (SELECT COUNT(*) FROM employees WHERE employee_type = 'managing_director') > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only one Managing Director is allowed.';
        END IF;
    END IF;

    -- Only one Department Head per department
    IF NEW.employee_type = 'dept_head' THEN
        IF (SELECT COUNT(*) FROM employees WHERE employee_type = 'dept_head' AND department_id = NEW.department_id) > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Each department can only have one Department Head.';
        END IF;
    END IF;

    -- Only one Section Head per section
    IF NEW.employee_type = 'section_head' THEN
        IF (SELECT COUNT(*) FROM employees WHERE employee_type = 'section_head' AND section_id = NEW.section_id) > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Each section can only have one Section Head.';
        END IF;
    END IF;

    -- Only one Subsection Head per subsection
    IF NEW.employee_type = 'sub_section_head' THEN
        IF (SELECT COUNT(*) FROM employees WHERE employee_type = 'sub_section_head' AND subsection_id = NEW.subsection_id) > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Each subsection can only have one Subsection Head.';
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_allowances`
--

CREATE TABLE `employee_allowances` (
  `allowance_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `allowance_type_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_allowances`
--

INSERT INTO `employee_allowances` (`allowance_id`, `period_id`, `emp_id`, `allowance_type_id`, `amount`, `effective_date`, `end_date`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(8, 1, 148, 1, 13552.00, '2025-09-01', '2025-09-02', 'active', 135, '2025-09-01 12:32:52', '2025-09-01 12:32:52'),
(9, 1, 147, 1, 13552.00, '2025-09-02', '2025-09-03', 'active', 135, '2025-09-01 12:42:34', '2025-09-01 12:42:34'),
(10, 1, 121, 1, 27104.00, '2025-09-02', '2025-09-02', 'active', 135, '2025-09-01 12:50:48', '2025-09-01 12:50:48'),
(11, 1, 5, 1, 13552.00, '2025-09-02', '2025-09-02', 'active', 135, '2025-09-01 12:57:39', '2025-09-01 12:57:39'),
(12, 1, 148, 3, 0.00, '2025-09-01', '2025-09-02', 'active', 135, '2025-09-01 17:06:23', '2025-09-01 17:06:23'),
(13, 1, 146, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(14, 1, 143, 1, 58080.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(15, 1, 104, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(16, 1, 134, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(17, 1, 112, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(18, 1, 135, 1, 32912.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(19, 1, 113, 1, 58080.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(20, 1, 111, 1, 32912.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(21, 1, 114, 1, 27104.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(22, 1, 118, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(23, 1, 136, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(24, 1, 145, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(25, 1, 122, 1, 13552.00, '2025-07-01', '2025-07-31', 'active', 135, '2025-09-10 09:34:01', '2025-09-10 09:34:01'),
(26, 2, 148, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:46', '2025-10-02 12:23:46'),
(27, 2, 147, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:46', '2025-10-02 12:23:46'),
(28, 2, 146, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:46', '2025-10-02 12:23:46'),
(29, 2, 143, 2, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:46', '2025-10-02 12:23:46'),
(30, 2, 104, 2, 6500.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:46', '2025-10-02 12:23:46'),
(31, 2, 134, 2, 6500.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(32, 2, 121, 2, 8000.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(33, 2, 112, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(34, 2, 135, 2, 11000.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(35, 2, 113, 2, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(36, 2, 111, 2, 11000.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(37, 2, 5, 2, 6500.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(38, 2, 114, 2, 8000.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(39, 2, 118, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(40, 2, 136, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(41, 2, 145, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(42, 2, 122, 2, 5200.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:23:47', '2025-10-02 12:23:47'),
(43, 2, 148, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:29', '2025-10-02 12:24:29'),
(44, 2, 147, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:29', '2025-10-02 12:24:29'),
(45, 2, 146, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:29', '2025-10-02 12:24:29'),
(46, 2, 143, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:29', '2025-10-02 12:24:29'),
(47, 2, 104, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:29', '2025-10-02 12:24:29'),
(48, 2, 134, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:29', '2025-10-02 12:24:29'),
(49, 2, 121, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(50, 2, 112, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(51, 2, 135, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(52, 2, 113, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(53, 2, 111, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(54, 2, 5, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(55, 2, 114, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(56, 2, 118, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:30', '2025-10-02 12:24:30'),
(57, 2, 136, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:31', '2025-10-02 12:24:31'),
(58, 2, 145, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:31', '2025-10-02 12:24:31'),
(59, 2, 122, 6, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:24:31', '2025-10-02 12:24:31'),
(60, 2, 148, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:12', '2025-10-02 12:25:12'),
(61, 2, 147, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(62, 2, 146, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(63, 2, 143, 1, 58080.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(64, 2, 104, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(65, 2, 134, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(66, 2, 121, 1, 27104.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(67, 2, 112, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(68, 2, 135, 1, 32912.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(69, 2, 113, 1, 58080.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(70, 2, 111, 1, 32912.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(71, 2, 5, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(72, 2, 114, 1, 27104.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(73, 2, 118, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:13', '2025-10-02 12:25:13'),
(74, 2, 136, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:14', '2025-10-02 12:25:14'),
(75, 2, 145, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:14', '2025-10-02 12:25:14'),
(76, 2, 122, 1, 13552.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:25:14', '2025-10-02 12:25:14'),
(77, 2, 151, 6, 2000.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 12:52:34', '2025-10-02 12:52:34'),
(78, 2, 151, 2, 6500.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 13:14:44', '2025-10-02 13:14:44'),
(79, 2, 149, 2, 0.00, '2025-09-01', '2025-09-30', 'active', 135, '2025-10-02 13:14:44', '2025-10-02 13:14:44'),
(80, 3, 148, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:03', '2025-10-02 13:27:03'),
(81, 3, 147, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(82, 3, 146, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(83, 3, 143, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(84, 3, 151, 6, 2000.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(85, 3, 104, 6, 2000.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(86, 3, 134, 6, 2000.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(87, 3, 121, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:04', '2025-10-02 13:27:04'),
(88, 3, 112, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(89, 3, 135, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(90, 3, 113, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(91, 3, 111, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(92, 3, 5, 6, 2000.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(93, 3, 114, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(94, 3, 118, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(95, 3, 136, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(96, 3, 145, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(97, 3, 149, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(98, 3, 122, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:27:05', '2025-10-02 13:27:05'),
(99, 3, 153, 2, 6500.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:35:50', '2025-10-02 13:35:50'),
(100, 3, 153, 6, 0.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:36:09', '2025-10-02 13:36:09'),
(101, 3, 153, 1, 19360.00, '2025-10-01', '2025-10-31', 'active', 135, '2025-10-02 13:36:47', '2025-10-02 13:36:47'),
(102, 4, 153, 1, 19360.00, '2025-11-01', '2025-11-30', 'active', 135, '2025-10-02 13:43:44', '2025-10-02 13:43:44'),
(103, 7, 148, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(104, 7, 147, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(105, 7, 146, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(106, 7, 143, 2, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(107, 7, 151, 2, 6500.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(108, 7, 104, 2, 6500.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(109, 7, 134, 2, 6500.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:22', '2025-10-07 07:42:22'),
(110, 7, 121, 2, 8000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(111, 7, 112, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(112, 7, 153, 2, 6500.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(113, 7, 135, 2, 11000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(114, 7, 113, 2, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(115, 7, 111, 2, 11000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(116, 7, 5, 2, 6500.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(117, 7, 114, 2, 8000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(118, 7, 118, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(119, 7, 136, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(120, 7, 145, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(121, 7, 149, 2, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(122, 7, 122, 2, 5200.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:23', '2025-10-07 07:42:23'),
(123, 7, 148, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(124, 7, 147, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(125, 7, 146, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(126, 7, 143, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(127, 7, 151, 6, 2000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(128, 7, 104, 6, 2000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(129, 7, 134, 6, 2000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(130, 7, 121, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(131, 7, 112, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(132, 7, 153, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(133, 7, 135, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(134, 7, 113, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(135, 7, 111, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(136, 7, 5, 6, 2000.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:52', '2025-10-07 07:42:52'),
(137, 7, 114, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:53', '2025-10-07 07:42:53'),
(138, 7, 118, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:53', '2025-10-07 07:42:53'),
(139, 7, 136, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:53', '2025-10-07 07:42:53'),
(140, 7, 145, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:53', '2025-10-07 07:42:53'),
(141, 7, 149, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:53', '2025-10-07 07:42:53'),
(142, 7, 122, 6, 0.00, '2026-02-01', '2026-02-28', 'active', 135, '2025-10-07 07:42:53', '2025-10-07 07:42:53');

-- --------------------------------------------------------

--
-- Table structure for table `employee_appraisals`
--

CREATE TABLE `employee_appraisals` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `appraiser_id` int(11) NOT NULL,
  `appraisal_cycle_id` int(11) NOT NULL,
  `employee_comment` text DEFAULT NULL,
  `employee_satisfied` int(11) NOT NULL,
  `employee_comment_date` timestamp NULL DEFAULT NULL,
  `supervisors_comment` text NOT NULL,
  `supervisors_comment_date` datetime NOT NULL DEFAULT current_timestamp(),
  `submitted_at` timestamp NULL DEFAULT NULL,
  `status` enum('draft','awaiting_employee','submitted','completed','awaiting_submission') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_appraisals`
--

INSERT INTO `employee_appraisals` (`id`, `employee_id`, `appraiser_id`, `appraisal_cycle_id`, `employee_comment`, `employee_satisfied`, `employee_comment_date`, `supervisors_comment`, `supervisors_comment_date`, `submitted_at`, `status`, `created_at`, `updated_at`) VALUES
(1, 118, 5, 3, 'I am satisfied with this appraisal. The feedback provided is constructive and will help me improve my performance in the coming period. I appreciate the recognition of my efforts in teamwork and quality of work.', 0, '2025-08-14 06:26:15', '', '2025-08-22 15:54:21', '2025-08-18 12:08:07', 'submitted', '2025-08-11 12:08:07', '2025-08-15 07:47:04'),
(2, 136, 5, 3, 'NO THANK YOU', 0, '2025-08-14 08:32:40', '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-11 12:54:09', '2025-08-14 09:37:52'),
(3, 118, 5, 1, 'Thank you for the comprehensive evaluation. I agree with most of the assessments and will work on the areas identified for improvement, particularly in initiative and innovation. The appraisal process was fair and transparent.', 0, '2025-08-13 07:33:08', '', '2025-08-22 15:54:21', '2025-08-13 07:37:01', 'submitted', '2025-08-12 08:41:45', '2025-08-15 07:47:04'),
(4, 136, 5, 1, 'SATISFIED', 1, '2025-09-11 09:46:41', '', '2025-08-22 15:54:21', NULL, 'awaiting_submission', '2025-08-12 16:59:40', '2025-09-11 09:46:41'),
(5, 143, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-12 17:57:25', '2025-08-13 08:14:53'),
(6, 104, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-12 17:57:37', '2025-08-14 08:58:22'),
(7, 134, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-12 17:57:44', '2025-08-14 08:19:30'),
(8, 121, 135, 1, 'Good job', 0, '2025-08-15 11:31:38', '', '2025-08-22 15:54:21', NULL, 'awaiting_submission', '2025-08-12 17:57:53', '2025-08-22 12:46:13'),
(10, 112, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-12 18:14:29', '2025-08-14 08:57:41'),
(11, 113, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-12 18:14:30', '2025-08-12 18:14:30'),
(12, 111, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-12 18:29:42', '2025-08-12 18:29:42'),
(13, 5, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-12 18:29:43', '2025-08-12 18:29:43'),
(14, 114, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-12 18:29:43', '2025-08-12 18:29:43'),
(17, 122, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-12 18:36:02', '2025-08-12 18:36:02'),
(18, 118, 5, 2, 'please my comment is wrong', 0, '2025-08-15 12:37:39', 'done', '2025-08-24 16:27:23', '2025-08-24 13:27:23', 'submitted', '2025-08-13 07:40:36', '2025-08-24 13:27:23'),
(19, 136, 5, 2, 'TOMORROW', 1, '2025-09-11 09:47:20', '', '2025-08-22 15:54:21', NULL, 'awaiting_submission', '2025-08-13 07:40:36', '2025-09-11 09:47:20'),
(20, 104, 135, 5, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-13 18:25:43', '2025-08-18 07:38:37'),
(21, 104, 135, 3, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-13 18:25:50', '2025-08-13 18:25:50'),
(22, 104, 135, 2, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-13 18:25:52', '2025-08-13 18:25:52'),
(23, 118, 135, 5, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-13 18:26:09', '2025-09-11 08:55:24'),
(24, 136, 5, 5, 'NOOOOO', 0, '2025-08-14 08:31:37', '', '2025-08-22 15:54:21', '2025-08-14 10:02:30', 'submitted', '2025-08-14 08:29:44', '2025-08-14 10:02:30'),
(25, 121, 135, 5, 'good job', 0, '2025-08-15 11:31:49', '', '2025-08-22 15:54:21', NULL, 'awaiting_submission', '2025-08-14 08:37:34', '2025-08-22 12:45:58'),
(26, 134, 135, 5, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-14 08:42:52', '2025-08-14 08:57:21'),
(27, 135, 135, 1, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-14 08:58:09', '2025-08-14 08:58:09'),
(28, 136, 5, 4, 'THE DAY BEFORE YESTERDAY', 1, '2025-09-11 09:47:44', '', '2025-08-22 15:54:21', NULL, 'awaiting_submission', '2025-08-14 09:37:09', '2025-09-11 09:47:44'),
(30, 136, 135, 8, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-15 10:03:22', '2025-08-15 10:03:22'),
(31, 112, 121, 5, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'awaiting_employee', '2025-08-15 11:32:43', '2025-08-24 12:59:33'),
(32, 112, 121, 3, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-15 11:32:58', '2025-08-15 11:32:58'),
(33, 5, 121, 3, 'halllo,', 0, '2025-08-15 12:52:39', '', '2025-08-22 15:54:21', '2025-08-15 12:54:08', 'submitted', '2025-08-15 12:00:30', '2025-08-15 12:54:08'),
(35, 121, 135, 3, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-15 12:30:31', '2025-08-15 12:30:31'),
(36, 121, 135, 2, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-15 12:31:45', '2025-08-15 12:31:45'),
(37, 118, 5, 4, 'halooo', 0, '2025-08-15 12:38:22', '', '2025-08-22 15:54:21', NULL, 'awaiting_submission', '2025-08-15 12:34:48', '2025-08-22 12:45:43'),
(38, 118, 5, 8, 'halooo', 0, '2025-08-15 12:38:08', 'donee', '2025-08-24 16:29:03', '2025-08-24 13:29:03', 'submitted', '2025-08-15 12:36:05', '2025-08-24 13:29:03'),
(39, 5, 121, 5, 'perfect', 0, '2025-08-22 12:17:02', 'PERFECTO', '2025-08-24 16:37:27', '2025-08-24 13:37:27', 'submitted', '2025-08-15 12:53:53', '2025-08-24 13:37:27'),
(40, 143, 135, 3, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-18 07:19:41', '2025-08-18 07:19:41'),
(41, 143, 135, 5, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-18 20:21:17', '2025-08-18 20:21:17'),
(42, 121, 135, 4, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-21 12:38:15', '2025-08-21 12:38:15'),
(43, 121, 135, 8, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-21 12:38:22', '2025-08-21 12:38:22'),
(44, 113, 135, 3, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-22 12:08:38', '2025-08-22 12:08:38'),
(45, 5, 135, 4, NULL, 0, NULL, '', '2025-08-22 15:54:21', NULL, 'draft', '2025-08-22 12:09:22', '2025-08-22 12:09:22'),
(46, 5, 121, 8, 'yeah', 0, '2025-08-22 12:17:36', 'Good performance', '2025-08-25 15:10:27', '2025-08-25 12:10:27', 'submitted', '2025-08-22 12:12:22', '2025-08-25 12:10:27'),
(47, 5, 121, 2, 'am contented', 0, '2025-08-22 12:17:23', 'ok', '2025-08-25 09:38:29', '2025-08-25 06:38:30', 'submitted', '2025-08-22 12:13:31', '2025-08-25 06:38:30'),
(48, 112, 121, 8, NULL, 0, NULL, '', '2025-08-22 16:18:43', NULL, 'draft', '2025-08-22 13:18:43', '2025-08-22 13:18:43'),
(49, 112, 121, 2, NULL, 0, NULL, '', '2025-08-24 15:59:53', NULL, 'awaiting_employee', '2025-08-24 12:59:53', '2025-09-03 13:06:09'),
(50, 111, 135, 8, NULL, 0, NULL, '', '2025-08-25 12:41:14', NULL, 'draft', '2025-08-25 09:41:14', '2025-08-25 09:41:14'),
(51, 111, 135, 4, NULL, 0, NULL, '', '2025-08-25 12:41:18', NULL, 'draft', '2025-08-25 09:41:18', '2025-08-25 09:41:18'),
(52, 111, 135, 5, NULL, 0, NULL, '', '2025-08-25 12:41:24', NULL, 'draft', '2025-08-25 09:41:24', '2025-08-25 09:41:24'),
(53, 111, 135, 3, NULL, 0, NULL, '', '2025-08-25 12:41:27', NULL, 'draft', '2025-08-25 09:41:27', '2025-08-25 09:41:27'),
(54, 111, 135, 2, NULL, 0, NULL, '', '2025-08-25 12:41:31', NULL, 'draft', '2025-08-25 09:41:31', '2025-08-25 09:41:31'),
(55, 114, 121, 5, NULL, 0, NULL, '', '2025-08-25 13:52:00', NULL, 'draft', '2025-08-25 10:52:00', '2025-08-25 10:52:00'),
(56, 134, 121, 2, NULL, 0, NULL, '', '2025-08-25 14:20:50', NULL, 'awaiting_employee', '2025-08-25 11:20:50', '2025-08-25 11:21:31'),
(57, 134, 121, 8, NULL, 0, NULL, '', '2025-08-25 14:21:54', NULL, 'awaiting_employee', '2025-08-25 11:21:54', '2025-08-25 11:22:19'),
(58, 148, 135, 1, 'SATISFIED', 0, '2025-09-03 08:12:34', 'thank you for your comment', '2025-09-04 09:53:42', '2025-09-04 06:53:42', 'submitted', '2025-09-03 08:10:55', '2025-09-04 06:53:42'),
(59, 146, 121, 1, 'I AM SATISFIED WITH THE RESULTS', 1, '2025-09-11 11:33:47', '', '2025-09-03 16:05:53', NULL, 'awaiting_submission', '2025-09-03 13:05:53', '2025-09-11 11:33:47'),
(60, 148, 135, 5, NULL, 0, NULL, '', '2025-09-04 09:53:42', NULL, 'draft', '2025-09-04 06:53:42', '2025-09-04 06:53:42'),
(61, 148, 135, 3, NULL, 0, NULL, '', '2025-09-04 09:53:50', NULL, 'draft', '2025-09-04 06:53:50', '2025-09-04 06:53:50'),
(62, 148, 135, 4, NULL, 0, NULL, '', '2025-09-04 09:53:56', NULL, 'draft', '2025-09-04 06:53:56', '2025-09-04 06:53:56'),
(63, 146, 121, 4, NULL, 0, NULL, '', '2025-09-04 10:06:15', NULL, 'draft', '2025-09-04 07:06:15', '2025-09-04 07:06:15'),
(64, 146, 135, 3, 'I AM SATISFIED WITH THE RESULTS', 1, '2025-09-11 11:34:08', 'EMPLOYEE IMPRESSIION IS VERY GOOD', '2025-09-11 14:35:47', '2025-09-11 11:35:47', 'submitted', '2025-09-05 06:43:22', '2025-09-11 11:35:47'),
(65, 121, 135, 6, NULL, 0, NULL, '', '2025-09-05 09:43:53', NULL, 'draft', '2025-09-05 06:43:53', '2025-09-05 06:43:53'),
(66, 146, 135, 5, NULL, 0, NULL, '', '2025-09-05 09:54:10', NULL, 'draft', '2025-09-05 06:54:10', '2025-09-05 06:54:10'),
(67, 147, 135, 1, NULL, 0, NULL, '', '2025-09-08 16:49:07', NULL, 'awaiting_employee', '2025-09-08 13:49:07', '2025-09-11 09:52:33'),
(68, 118, 135, 6, NULL, 0, NULL, '', '2025-09-10 10:38:51', NULL, 'awaiting_employee', '2025-09-10 07:38:51', '2025-09-10 09:13:03'),
(69, 136, 135, 6, 'TODAY', 1, '2025-09-11 09:46:55', '', '2025-09-11 12:43:53', NULL, 'awaiting_submission', '2025-09-11 09:43:53', '2025-09-11 09:46:55'),
(70, 146, 135, 2, NULL, 0, NULL, '', '2025-09-12 09:04:34', NULL, 'draft', '2025-09-12 06:04:34', '2025-09-12 06:04:34'),
(71, 147, 135, 2, NULL, 0, NULL, '', '2025-10-08 09:43:23', NULL, 'draft', '2025-10-08 06:43:23', '2025-10-08 06:43:23'),
(72, 151, 135, 2, NULL, 0, NULL, '', '2025-10-08 09:43:28', NULL, 'draft', '2025-10-08 06:43:28', '2025-10-08 06:43:28'),
(73, 147, 135, 3, NULL, 0, NULL, '', '2025-10-08 09:57:09', NULL, 'draft', '2025-10-08 06:57:09', '2025-10-08 06:57:09'),
(74, 484, 446, 1, NULL, 0, NULL, '', '2025-10-13 09:28:08', NULL, 'draft', '2025-10-13 06:28:08', '2025-10-13 06:28:08'),
(75, 484, 446, 5, NULL, 0, NULL, '', '2025-10-13 09:28:10', NULL, 'draft', '2025-10-13 06:28:10', '2025-10-13 06:28:10'),
(76, 474, 446, 5, NULL, 0, NULL, '', '2025-10-13 09:28:32', NULL, 'draft', '2025-10-13 06:28:32', '2025-10-13 06:28:32'),
(77, 408, 446, 5, NULL, 0, NULL, '', '2025-10-13 09:29:07', NULL, 'draft', '2025-10-13 06:29:07', '2025-10-13 06:29:07'),
(78, 370, 446, 5, NULL, 0, NULL, '', '2025-10-13 09:29:17', NULL, 'draft', '2025-10-13 06:29:17', '2025-10-13 06:29:17'),
(79, 370, 446, 3, NULL, 0, NULL, '', '2025-10-13 09:29:27', NULL, 'draft', '2025-10-13 06:29:27', '2025-10-13 06:29:27'),
(80, 428, 446, 1, NULL, 0, NULL, '', '2025-10-14 10:14:08', NULL, 'draft', '2025-10-14 07:14:08', '2025-10-14 07:14:08'),
(81, 446, 500, 1, NULL, 0, NULL, '', '2025-10-14 10:17:25', NULL, 'draft', '2025-10-14 07:17:25', '2025-10-14 07:17:25'),
(82, 446, 500, 5, NULL, 0, NULL, '', '2025-10-14 10:17:40', NULL, 'draft', '2025-10-14 07:17:40', '2025-10-14 07:17:40'),
(83, 446, 500, 3, NULL, 0, NULL, '', '2025-10-14 10:17:45', NULL, 'draft', '2025-10-14 07:17:45', '2025-10-14 07:17:45'),
(84, 401, 446, 1, NULL, 0, NULL, '', '2025-10-14 13:55:11', NULL, 'draft', '2025-10-14 10:55:11', '2025-10-14 10:55:11'),
(85, 393, 446, 1, NULL, 0, NULL, '', '2025-10-21 14:59:49', NULL, 'draft', '2025-10-21 11:59:49', '2025-10-21 11:59:49'),
(86, 400, 461, 1, NULL, 0, NULL, '', '2025-10-21 16:30:42', NULL, 'draft', '2025-10-21 13:30:42', '2025-10-21 13:30:42'),
(87, 400, 461, 2, NULL, 0, NULL, '', '2025-10-21 16:36:17', NULL, 'draft', '2025-10-21 13:36:17', '2025-10-21 13:36:17'),
(88, 399, 461, 2, NULL, 0, NULL, '', '2025-10-21 16:36:38', NULL, 'draft', '2025-10-21 13:36:38', '2025-10-21 13:36:38'),
(89, 350, 446, 1, NULL, 0, NULL, '', '2025-10-21 16:56:34', NULL, 'draft', '2025-10-21 13:56:34', '2025-10-21 13:56:34'),
(90, 457, 446, 1, NULL, 0, NULL, '', '2025-10-21 16:56:50', NULL, 'draft', '2025-10-21 13:56:50', '2025-10-21 13:56:50'),
(91, 392, 446, 1, NULL, 0, NULL, '', '2025-10-21 16:57:18', NULL, 'draft', '2025-10-21 13:57:18', '2025-10-21 13:57:18');

-- --------------------------------------------------------

--
-- Table structure for table `employee_deductions`
--

CREATE TABLE `employee_deductions` (
  `deduction_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `deduction_type_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','inactive','pending') DEFAULT 'active',
  `calculation_details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`calculation_details`)),
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deduction_method` enum('fixed','percentage','formula') NOT NULL,
  `max_limit_percent` float NOT NULL,
  `fixed_amount` decimal(10,2) DEFAULT NULL,
  `percentage_value` decimal(5,2) DEFAULT NULL,
  `salary_component` varchar(50) DEFAULT NULL,
  `formula_expression` text DEFAULT NULL,
  `period_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `employee_deductions`
--

INSERT INTO `employee_deductions` (`deduction_id`, `emp_id`, `deduction_type_id`, `amount`, `effective_date`, `end_date`, `status`, `calculation_details`, `created_by`, `created_at`, `updated_at`, `deduction_method`, `max_limit_percent`, `fixed_amount`, `percentage_value`, `salary_component`, `formula_expression`, `period_id`) VALUES
(1, 5, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:09:50', '2025-10-02 11:09:50', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(2, 5, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(3, 104, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(4, 111, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(5, 112, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(6, 113, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(7, 114, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(8, 118, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(9, 121, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:45', '2025-10-02 11:11:45', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(10, 122, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(11, 134, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(12, 135, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(13, 136, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(14, 143, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(15, 145, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(16, 146, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(17, 147, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(18, 148, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:46', '2025-10-02 11:11:46', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(19, 149, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:47', '2025-10-02 11:11:47', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(20, 150, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:11:47', '2025-10-02 11:11:47', 'fixed', 15, NULL, NULL, NULL, NULL, NULL),
(21, 5, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:17', '2025-10-02 11:13:17', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(22, 104, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:18', '2025-10-02 11:13:18', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(23, 111, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:18', '2025-10-02 11:13:18', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(24, 112, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:18', '2025-10-02 11:13:18', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(25, 113, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(26, 114, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(27, 118, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(28, 121, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(29, 122, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(30, 134, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(31, 135, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(32, 136, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:19', '2025-10-02 11:13:19', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(33, 143, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(34, 145, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(35, 146, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(36, 147, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(37, 148, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(38, 149, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(39, 150, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:13:20', '2025-10-02 11:13:20', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(40, 118, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"gross_salary\"}', 135, '2025-10-02 11:15:15', '2025-10-02 11:15:15', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(41, 5, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:35', '2025-10-02 11:20:35', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(42, 104, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:35', '2025-10-02 11:20:35', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(43, 111, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:36', '2025-10-02 11:20:36', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(44, 112, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:36', '2025-10-02 11:20:36', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(45, 113, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:36', '2025-10-02 11:20:36', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(46, 114, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:36', '2025-10-02 11:20:36', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(47, 118, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:36', '2025-10-02 11:20:36', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(48, 121, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(49, 122, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(50, 134, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(51, 135, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(52, 136, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(53, 143, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(54, 145, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(55, 146, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(56, 147, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(57, 148, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:37', '2025-10-02 11:20:37', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(58, 149, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:38', '2025-10-02 11:20:38', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(59, 150, 8, 0.00, '2025-10-17', '2026-04-02', 'active', '{\"type\":\"fixed\",\"amount\":1000}', 135, '2025-10-02 11:20:38', '2025-10-02 11:20:38', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(60, 5, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:05', '2025-10-02 11:36:05', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(61, 104, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:05', '2025-10-02 11:36:05', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(62, 111, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:06', '2025-10-02 11:36:06', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(63, 112, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:06', '2025-10-02 11:36:06', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(64, 113, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:06', '2025-10-02 11:36:06', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(65, 114, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:06', '2025-10-02 11:36:06', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(66, 118, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:06', '2025-10-02 11:36:06', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(67, 121, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(68, 122, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(69, 134, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(70, 135, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(71, 136, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(72, 143, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(73, 145, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(74, 146, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(75, 147, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(76, 148, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:07', '2025-10-02 11:36:07', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(77, 149, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:08', '2025-10-02 11:36:08', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(78, 150, 8, 0.00, '2025-01-01', '2025-12-31', 'active', '{\"type\":\"fixed\",\"amount\":2000}', 135, '2025-10-02 11:36:08', '2025-10-02 11:36:08', 'fixed', 100, NULL, NULL, NULL, NULL, NULL),
(79, 145, 9, 0.00, '2025-10-01', '2025-11-08', 'active', '{\"type\":\"formula\",\"formula\":\"(basic_salary*17)\"}', 135, '2025-10-02 11:39:53', '2025-10-02 11:39:53', 'fixed', 40, NULL, NULL, NULL, NULL, NULL),
(80, 5, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:19', '2025-10-02 12:26:19', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(81, 104, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:20', '2025-10-02 12:26:20', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(82, 111, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:20', '2025-10-02 12:26:20', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(83, 112, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:20', '2025-10-02 12:26:20', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(84, 113, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:20', '2025-10-02 12:26:20', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(85, 114, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:20', '2025-10-02 12:26:20', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(86, 118, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:21', '2025-10-02 12:26:21', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(87, 121, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:21', '2025-10-02 12:26:21', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(88, 122, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:21', '2025-10-02 12:26:21', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(89, 134, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:21', '2025-10-02 12:26:21', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(90, 135, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:21', '2025-10-02 12:26:21', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(91, 136, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(92, 143, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(93, 145, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(94, 146, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(95, 147, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(96, 148, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(97, 149, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(98, 150, 9, 0.00, '2025-09-01', '2026-01-10', 'active', '{\"type\":\"percentage\",\"percentage\":15,\"component\":\"basic_salary\"}', 135, '2025-10-02 12:26:22', '2025-10-02 12:26:22', 'fixed', 5, NULL, NULL, NULL, NULL, NULL),
(99, 148, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(100, 147, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(101, 146, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(102, 143, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(103, 151, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(104, 104, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(105, 134, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(106, 121, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:29', '2025-10-03 08:49:29', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(107, 112, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(108, 153, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(109, 135, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(110, 113, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(111, 111, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(112, 5, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(113, 150, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(114, 114, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(115, 118, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(116, 136, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(117, 145, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(118, 149, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(119, 122, 10, 10000.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"fixed\",\"amount\":\"10000\"}', 135, '2025-10-03 08:49:30', '2025-10-03 08:49:30', 'fixed', 0, NULL, NULL, NULL, NULL, 4),
(120, 145, 13, 6500.00, '2025-10-01', '2025-10-31', 'active', '{\"type\":\"percentage\",\"percentage\":10,\"component\":\"basic_salary\"}', 135, '2025-10-03 09:29:56', '2025-10-03 09:29:56', 'percentage', 0, NULL, NULL, NULL, NULL, 4);

-- --------------------------------------------------------

--
-- Table structure for table `employee_documents`
--

CREATE TABLE `employee_documents` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `document_name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_documents`
--

INSERT INTO `employee_documents` (`id`, `employee_id`, `document_name`, `file_name`, `uploaded_at`) VALUES
(1, 149, 'CURRICULUM VITAE', '68ba8e3b1d85e.pdf', '2025-09-05 07:16:11'),
(2, 135, 'KCSE CERTIFICATE', '68c12d85b3d09.pdf', '2025-09-10 07:49:25'),
(3, 135, 'KCSE CERTFICATE', '68de719391707.pdf', '2025-10-02 12:35:31');

-- --------------------------------------------------------

--
-- Table structure for table `employee_leave_balances`
--

CREATE TABLE `employee_leave_balances` (
  `id` int(11) NOT NULL,
  `employee_id` varchar(50) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `financial_year_id` int(11) NOT NULL,
  `allocated_days` decimal(5,2) NOT NULL DEFAULT 0.00,
  `used_days` decimal(5,2) NOT NULL DEFAULT 0.00,
  `remaining_days` decimal(5,2) NOT NULL DEFAULT 0.00,
  `total_days` int(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_leave_balances`
--

INSERT INTO `employee_leave_balances` (`id`, `employee_id`, `leave_type_id`, `financial_year_id`, `allocated_days`, `used_days`, `remaining_days`, `total_days`, `created_at`, `updated_at`) VALUES
(2775, '406', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2776, '406', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2777, '406', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2778, '407', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2779, '407', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2780, '407', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2781, '407', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2782, '407', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2783, '407', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2784, '407', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2785, '408', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2786, '408', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2787, '408', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2788, '408', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2789, '408', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2790, '408', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2791, '408', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2792, '409', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2793, '409', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2794, '409', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2795, '409', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2796, '409', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2797, '409', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2798, '409', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2799, '410', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2800, '410', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2801, '410', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2802, '410', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2803, '410', 4, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2804, '410', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2805, '410', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2806, '410', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2807, '411', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2808, '411', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2809, '411', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2810, '411', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2811, '411', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2812, '411', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2813, '411', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2814, '412', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2815, '412', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2816, '412', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2817, '412', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2818, '412', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2819, '412', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2820, '412', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2821, '413', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2822, '413', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2823, '413', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2824, '413', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2825, '413', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2826, '413', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2827, '413', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2828, '414', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2829, '414', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2830, '414', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2831, '414', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2832, '414', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2833, '414', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2834, '414', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2835, '415', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2836, '415', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2837, '415', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2838, '415', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2839, '415', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2840, '415', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2841, '415', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2842, '416', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2843, '416', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2844, '416', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2845, '416', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2846, '416', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2847, '416', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2848, '416', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2849, '417', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2850, '417', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2851, '417', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2852, '417', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2853, '417', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2854, '417', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2855, '417', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2856, '418', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2857, '418', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2858, '418', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2859, '418', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2860, '418', 3, 28, 120.00, 0.00, 120.00, 120, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2861, '418', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2862, '418', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2863, '418', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2864, '419', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2865, '419', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2866, '419', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2867, '419', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2868, '419', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2869, '419', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2870, '419', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2871, '420', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2872, '420', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2873, '420', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2874, '420', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2875, '420', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2876, '420', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2877, '420', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2878, '421', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2879, '421', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2880, '421', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2881, '421', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2882, '421', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2883, '421', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2884, '421', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2885, '422', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2886, '422', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2887, '422', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2888, '422', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2889, '422', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2890, '422', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2891, '422', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2892, '423', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2893, '423', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2894, '423', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2895, '423', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2896, '423', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2897, '423', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2898, '423', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2899, '424', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2900, '424', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2901, '424', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2902, '424', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2903, '424', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2904, '424', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2905, '424', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2906, '425', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2907, '425', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2908, '425', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2909, '425', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2910, '425', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2911, '425', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2912, '425', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2913, '426', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2914, '426', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2915, '426', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2916, '426', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2917, '426', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2918, '426', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2919, '426', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2920, '427', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2921, '427', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2922, '427', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2923, '427', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2924, '427', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2925, '427', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2926, '427', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2927, '428', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2928, '428', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2929, '428', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2930, '428', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2931, '428', 4, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2932, '428', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2933, '428', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2934, '428', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2935, '429', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2936, '429', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2937, '429', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2938, '429', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2939, '429', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2940, '429', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2941, '429', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2942, '430', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2943, '430', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2944, '430', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2945, '430', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2946, '430', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2947, '430', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2948, '430', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2949, '431', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2950, '431', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2951, '431', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2952, '431', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2953, '431', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2954, '431', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2955, '431', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2956, '432', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2957, '432', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2958, '432', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2959, '432', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2960, '432', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2961, '432', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2962, '432', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2963, '433', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2964, '433', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2965, '433', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2966, '433', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2967, '433', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2968, '433', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2969, '433', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2970, '434', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2971, '434', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2972, '434', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2973, '434', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2974, '434', 4, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2975, '434', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2976, '434', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2977, '434', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2978, '435', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2979, '435', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2980, '435', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2981, '435', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2982, '435', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2983, '435', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2984, '435', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2985, '436', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2986, '436', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2987, '436', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2988, '436', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2989, '436', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2990, '436', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2991, '436', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2992, '437', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2993, '437', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2994, '437', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2995, '437', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2996, '437', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2997, '437', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2998, '437', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(2999, '438', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3000, '438', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3001, '438', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3002, '438', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3003, '438', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3004, '438', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3005, '438', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3006, '439', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3007, '439', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3008, '439', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3009, '439', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3010, '439', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3011, '439', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3012, '439', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3013, '440', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3014, '440', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3015, '440', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3016, '440', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3017, '440', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3018, '440', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3019, '440', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3020, '441', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3021, '441', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3022, '441', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3023, '441', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3024, '441', 4, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3025, '441', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3026, '441', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3027, '441', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3028, '442', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3029, '442', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3030, '442', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3031, '442', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3032, '442', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3033, '442', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3034, '442', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3035, '443', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3036, '443', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3037, '443', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3038, '443', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3039, '443', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3040, '443', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3041, '443', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3042, '444', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3043, '444', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3044, '444', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3045, '444', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3046, '444', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3047, '444', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3048, '444', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3049, '445', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3050, '445', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3051, '445', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3052, '445', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3053, '445', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3054, '445', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3055, '445', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3056, '446', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3057, '446', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3058, '446', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3059, '446', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3060, '446', 3, 28, 120.00, 0.00, 120.00, 120, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3061, '446', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3062, '446', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3063, '446', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3064, '447', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3065, '447', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3066, '447', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3067, '447', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3068, '447', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3069, '447', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3070, '447', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3071, '448', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3072, '448', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3073, '448', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3074, '448', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3075, '448', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3076, '448', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3077, '448', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3078, '449', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3079, '449', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3080, '449', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3081, '449', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3082, '449', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3083, '449', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3084, '449', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3085, '450', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3086, '450', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3087, '450', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3088, '450', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3089, '450', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3090, '450', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3091, '450', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3092, '451', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3093, '451', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3094, '451', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3095, '451', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3096, '451', 3, 28, 120.00, 0.00, 120.00, 120, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3097, '451', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3098, '451', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3099, '451', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3100, '452', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3101, '452', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3102, '452', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3103, '452', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3104, '452', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3105, '452', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3106, '452', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3107, '453', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3108, '453', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3109, '453', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3110, '453', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3111, '453', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3112, '453', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3113, '453', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3114, '454', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3115, '454', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3116, '454', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3117, '454', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3118, '454', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3119, '454', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3120, '454', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3121, '455', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3122, '455', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3123, '455', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3124, '455', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3125, '455', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3126, '455', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3127, '455', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3128, '456', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3129, '456', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3130, '456', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3131, '456', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3132, '456', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3133, '456', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3134, '456', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3135, '457', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3136, '457', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3137, '457', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3138, '457', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3139, '457', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3140, '457', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3141, '457', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3142, '458', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3143, '458', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3144, '458', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3145, '458', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3146, '458', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3147, '458', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3148, '458', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3149, '459', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3150, '459', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3151, '459', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3152, '459', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3153, '459', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3154, '459', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3155, '459', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3156, '460', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3157, '460', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3158, '460', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3159, '460', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3160, '460', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3161, '460', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3162, '460', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3163, '461', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3164, '461', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3165, '461', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3166, '461', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3167, '461', 3, 28, 120.00, 0.00, 120.00, 120, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3168, '461', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3169, '461', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3170, '461', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3171, '462', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3172, '462', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3173, '462', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3174, '462', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3175, '462', 3, 28, 120.00, 0.00, 120.00, 120, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3176, '462', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3177, '462', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3178, '462', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3179, '463', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3180, '463', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3181, '463', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3182, '463', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3183, '463', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3184, '463', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3185, '463', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3186, '464', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3187, '464', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3188, '464', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3189, '464', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3190, '464', 3, 28, 120.00, 0.00, 120.00, 120, '2024-07-23 05:31:25', '2024-07-23 05:31:25'),
(3191, '464', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3192, '464', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3193, '464', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3194, '465', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3195, '465', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3196, '465', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3197, '465', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3198, '465', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3199, '465', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3200, '465', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3201, '466', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3202, '466', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3203, '466', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3204, '466', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3205, '466', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3206, '466', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3207, '466', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3208, '467', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3209, '467', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3210, '467', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3211, '467', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3212, '467', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3213, '467', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3214, '467', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3215, '468', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3216, '468', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3217, '468', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3218, '468', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3219, '468', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3220, '468', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3221, '468', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3222, '469', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3223, '469', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3224, '469', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3225, '469', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3226, '469', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3227, '469', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3228, '469', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3229, '470', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3230, '470', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3231, '470', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3232, '470', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3233, '470', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3234, '470', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3235, '470', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3236, '471', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3237, '471', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3238, '471', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3239, '471', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3240, '471', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3241, '471', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3242, '471', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3243, '472', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3244, '472', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3245, '472', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3246, '472', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3247, '472', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3248, '472', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3249, '472', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3250, '473', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3251, '473', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3252, '473', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3253, '473', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3254, '473', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3255, '473', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3256, '473', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3257, '474', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3258, '474', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3259, '474', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3260, '474', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3261, '474', 4, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3262, '474', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3263, '474', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3264, '474', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3265, '475', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3266, '475', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3267, '475', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3268, '475', 2, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3269, '475', 7, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3270, '475', 9, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3271, '475', 8, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3272, '476', 1, 28, 30.00, 0.00, 30.00, 30, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3273, '476', 6, 28, 0.00, 0.00, 0.00, 0, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(3274, '476', 5, 28, 10.00, 0.00, 10.00, 10, '2024-07-23 05:31:26', '2024-07-23 05:31:26'),
(4793, '336', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4794, '336', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4795, '336', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4796, '336', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4797, '336', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4798, '336', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4799, '336', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4800, '337', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4801, '337', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4802, '337', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4803, '337', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4804, '337', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4805, '337', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4806, '337', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4807, '338', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4808, '338', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4809, '338', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4810, '338', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4811, '338', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4812, '338', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4813, '338', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4814, '339', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4815, '339', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4816, '339', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4817, '339', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4818, '339', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4819, '339', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4820, '339', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4821, '340', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4822, '340', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4823, '340', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4824, '340', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4825, '340', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4826, '340', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4827, '340', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4828, '341', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4829, '341', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4830, '341', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4831, '341', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4832, '341', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4833, '341', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4834, '341', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4835, '342', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4836, '342', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4837, '342', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4838, '342', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4839, '342', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4840, '342', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4841, '342', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4842, '343', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4843, '343', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4844, '343', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4845, '343', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4846, '343', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4847, '343', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4848, '343', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4849, '344', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4850, '344', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4851, '344', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4852, '344', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4853, '344', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35');
INSERT INTO `employee_leave_balances` (`id`, `employee_id`, `leave_type_id`, `financial_year_id`, `allocated_days`, `used_days`, `remaining_days`, `total_days`, `created_at`, `updated_at`) VALUES
(4854, '344', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4855, '344', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4856, '345', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4857, '345', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4858, '345', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4859, '345', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4860, '345', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4861, '345', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4862, '345', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4863, '346', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4864, '346', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4865, '346', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4866, '346', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4867, '346', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4868, '346', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4869, '346', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4870, '347', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4871, '347', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4872, '347', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4873, '347', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4874, '347', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4875, '347', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4876, '347', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4877, '348', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4878, '348', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4879, '348', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4880, '348', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4881, '348', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4882, '348', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4883, '348', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4884, '349', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4885, '349', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4886, '349', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4887, '349', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4888, '349', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4889, '349', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4890, '349', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4891, '350', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4892, '350', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4893, '350', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4894, '350', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4895, '350', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4896, '350', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4897, '350', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4898, '351', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4899, '351', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4900, '351', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4901, '351', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4902, '351', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4903, '351', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4904, '351', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4905, '352', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4906, '352', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4907, '352', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4908, '352', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4909, '352', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4910, '352', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4911, '352', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4912, '353', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4913, '353', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4914, '353', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4915, '353', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4916, '353', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4917, '353', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4918, '353', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4919, '354', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4920, '354', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4921, '354', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4922, '354', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4923, '354', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4924, '354', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4925, '354', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4926, '355', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4927, '355', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4928, '355', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4929, '355', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4930, '355', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4931, '355', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4932, '355', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4933, '356', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4934, '356', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4935, '356', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4936, '356', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4937, '356', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4938, '356', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4939, '356', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4940, '357', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4941, '357', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4942, '357', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4943, '357', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4944, '357', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4945, '357', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4946, '357', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4947, '358', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4948, '358', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4949, '358', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4950, '358', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4951, '358', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4952, '358', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4953, '358', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4954, '359', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4955, '359', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4956, '359', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4957, '359', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4958, '359', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4959, '359', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4960, '359', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4961, '360', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4962, '360', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4963, '360', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4964, '360', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4965, '360', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4966, '360', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4967, '360', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4968, '361', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4969, '361', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4970, '361', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4971, '361', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4972, '361', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4973, '361', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4974, '361', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4975, '362', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4976, '362', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4977, '362', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4978, '362', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4979, '362', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4980, '362', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4981, '362', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4982, '363', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4983, '363', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4984, '363', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4985, '363', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4986, '363', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4987, '363', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4988, '363', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4989, '364', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4990, '364', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4991, '364', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4992, '364', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4993, '364', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4994, '364', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4995, '364', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4996, '365', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4997, '365', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4998, '365', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(4999, '365', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5000, '365', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5001, '365', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5002, '365', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5003, '366', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5004, '366', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5005, '366', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5006, '366', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5007, '366', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5008, '366', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5009, '366', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5010, '367', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5011, '367', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5012, '367', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5013, '367', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5014, '367', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5015, '367', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5016, '367', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5017, '368', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5018, '368', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5019, '368', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5020, '368', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5021, '368', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5022, '368', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5023, '368', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5024, '369', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5025, '369', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5026, '369', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5027, '369', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5028, '369', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5029, '369', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5030, '369', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5031, '370', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5032, '370', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5033, '370', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5034, '370', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5035, '370', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5036, '370', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5037, '370', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5038, '371', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5039, '371', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5040, '371', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5041, '371', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5042, '371', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5043, '371', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5044, '371', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5045, '372', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5046, '372', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5047, '372', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5048, '372', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5049, '372', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5050, '372', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5051, '372', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5052, '373', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5053, '373', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5054, '373', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5055, '373', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5056, '373', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5057, '373', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5058, '373', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5059, '374', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5060, '374', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5061, '374', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5062, '374', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5063, '374', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5064, '374', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5065, '374', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5066, '375', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5067, '375', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5068, '375', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5069, '375', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5070, '375', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5071, '375', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5072, '375', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5073, '376', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5074, '376', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5075, '376', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5076, '376', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5077, '376', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5078, '376', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5079, '376', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5080, '377', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5081, '377', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5082, '377', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5083, '377', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5084, '377', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5085, '377', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5086, '377', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5087, '378', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5088, '378', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5089, '378', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5090, '378', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5091, '378', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5092, '378', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5093, '378', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5094, '379', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5095, '379', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5096, '379', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5097, '379', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5098, '379', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5099, '379', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5100, '379', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5101, '380', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5102, '380', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5103, '380', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5104, '380', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5105, '380', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5106, '380', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5107, '380', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5108, '381', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5109, '381', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5110, '381', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5111, '381', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5112, '381', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5113, '381', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5114, '381', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5115, '382', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5116, '382', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5117, '382', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5118, '382', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5119, '382', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5120, '382', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5121, '382', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5122, '383', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5123, '383', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5124, '383', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5125, '383', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5126, '383', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5127, '383', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5128, '383', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5129, '384', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5130, '384', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5131, '384', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5132, '384', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5133, '384', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5134, '384', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5135, '384', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5136, '385', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5137, '385', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5138, '385', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5139, '385', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5140, '385', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5141, '385', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5142, '385', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5143, '386', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5144, '386', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5145, '386', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5146, '386', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5147, '386', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5148, '386', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5149, '386', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5150, '387', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5151, '387', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5152, '387', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5153, '387', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5154, '387', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5155, '387', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5156, '387', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5157, '388', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5158, '388', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5159, '388', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5160, '388', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5161, '388', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5162, '388', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5163, '388', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5164, '389', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5165, '389', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5166, '389', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5167, '389', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5168, '389', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5169, '389', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5170, '389', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5171, '390', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5172, '390', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5173, '390', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5174, '390', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5175, '390', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5176, '390', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5177, '390', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5178, '391', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5179, '391', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5180, '391', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5181, '391', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5182, '391', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5183, '391', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5184, '391', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5185, '391', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5186, '392', 1, 30, 34.00, 37.00, 30.00, 27, '2025-07-23 07:23:35', '2025-10-23 12:02:08'),
(5187, '392', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5188, '392', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5189, '392', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5190, '392', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5191, '392', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5192, '392', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5193, '392', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5194, '393', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5195, '393', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5196, '393', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5197, '393', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5198, '393', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5199, '393', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5200, '393', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5201, '394', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5202, '394', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5203, '394', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5204, '394', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5205, '394', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5206, '394', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5207, '394', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5208, '395', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5209, '395', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5210, '395', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5211, '395', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5212, '395', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5213, '395', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5214, '395', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5215, '396', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5216, '396', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5217, '396', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5218, '396', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5219, '396', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5220, '396', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5221, '396', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5222, '397', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5223, '397', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5224, '397', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5225, '397', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5226, '397', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5227, '397', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5228, '397', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5229, '398', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5230, '398', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5231, '398', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5232, '398', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5233, '398', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5234, '398', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5235, '398', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5236, '399', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5237, '399', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5238, '399', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5239, '399', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5240, '399', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5241, '399', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5242, '399', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5243, '400', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5244, '400', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5245, '400', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5246, '400', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5247, '400', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5248, '400', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5249, '400', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5250, '400', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5251, '401', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5252, '401', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5253, '401', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5254, '401', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5255, '401', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5256, '401', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5257, '401', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5258, '402', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5259, '402', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5260, '402', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5261, '402', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5262, '402', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5263, '402', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5264, '402', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5265, '403', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5266, '403', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5267, '403', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5268, '403', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5269, '403', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5270, '403', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5271, '403', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5272, '404', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5273, '404', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5274, '404', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5275, '404', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5276, '404', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5277, '404', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5278, '404', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5279, '405', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5280, '405', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5281, '405', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5282, '405', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5283, '405', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5284, '405', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5285, '405', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5286, '406', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5287, '406', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5288, '406', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5289, '406', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5290, '406', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5291, '406', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5292, '406', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5293, '407', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5294, '407', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5295, '407', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5296, '407', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5297, '407', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5298, '407', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5299, '407', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5300, '408', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5301, '408', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5302, '408', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5303, '408', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5304, '408', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5305, '408', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5306, '408', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5307, '409', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5308, '409', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5309, '409', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5310, '409', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5311, '409', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5312, '409', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5313, '409', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5314, '410', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5315, '410', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5316, '410', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5317, '410', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5318, '410', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5319, '410', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5320, '410', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5321, '410', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5322, '411', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5323, '411', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5324, '411', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5325, '411', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5326, '411', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5327, '411', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5328, '411', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5329, '412', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5330, '412', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5331, '412', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5332, '412', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5333, '412', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5334, '412', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5335, '412', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5336, '413', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5337, '413', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5338, '413', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5339, '413', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5340, '413', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5341, '413', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5342, '413', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5343, '414', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5344, '414', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5345, '414', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5346, '414', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5347, '414', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5348, '414', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5349, '414', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5350, '415', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5351, '415', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5352, '415', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5353, '415', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5354, '415', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5355, '415', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5356, '415', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5357, '416', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5358, '416', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5359, '416', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5360, '416', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5361, '416', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5362, '416', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5363, '416', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5364, '417', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5365, '417', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5366, '417', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5367, '417', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5368, '417', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5369, '417', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5370, '417', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5371, '418', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5372, '418', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5373, '418', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5374, '418', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5375, '418', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5376, '418', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5377, '418', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5378, '418', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5379, '419', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5380, '419', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5381, '419', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5382, '419', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5383, '419', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5384, '419', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5385, '419', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5386, '420', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5387, '420', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5388, '420', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5389, '420', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5390, '420', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5391, '420', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5392, '420', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5393, '421', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5394, '421', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5395, '421', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5396, '421', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5397, '421', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5398, '421', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5399, '421', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5400, '422', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5401, '422', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5402, '422', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5403, '422', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5404, '422', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5405, '422', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5406, '422', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5407, '423', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5408, '423', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5409, '423', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5410, '423', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5411, '423', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5412, '423', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5413, '423', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5414, '424', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35');
INSERT INTO `employee_leave_balances` (`id`, `employee_id`, `leave_type_id`, `financial_year_id`, `allocated_days`, `used_days`, `remaining_days`, `total_days`, `created_at`, `updated_at`) VALUES
(5415, '424', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5416, '424', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5417, '424', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5418, '424', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5419, '424', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5420, '424', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5421, '425', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5422, '425', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:35', '2025-07-23 07:23:35'),
(5423, '425', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5424, '425', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5425, '425', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5426, '425', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5427, '425', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5428, '426', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5429, '426', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5430, '426', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5431, '426', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5432, '426', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5433, '426', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5434, '426', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5435, '427', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5436, '427', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5437, '427', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5438, '427', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5439, '427', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5440, '427', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5441, '427', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5442, '428', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5443, '428', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5444, '428', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5445, '428', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5446, '428', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5447, '428', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5448, '428', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5449, '428', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5450, '429', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5451, '429', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5452, '429', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5453, '429', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5454, '429', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5455, '429', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5456, '429', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5457, '430', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5458, '430', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5459, '430', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5460, '430', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5461, '430', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5462, '430', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5463, '430', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5464, '431', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5465, '431', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5466, '431', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5467, '431', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5468, '431', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5469, '431', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5470, '431', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5471, '432', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5472, '432', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5473, '432', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5474, '432', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5475, '432', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5476, '432', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5477, '432', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5478, '433', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5479, '433', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5480, '433', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5481, '433', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5482, '433', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5483, '433', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5484, '433', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5485, '434', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5486, '434', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5487, '434', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5488, '434', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5489, '434', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5490, '434', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5491, '434', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5492, '434', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5493, '435', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5494, '435', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5495, '435', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5496, '435', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5497, '435', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5498, '435', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5499, '435', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5500, '436', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5501, '436', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5502, '436', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5503, '436', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5504, '436', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5505, '436', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5506, '436', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5507, '437', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5508, '437', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5509, '437', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5510, '437', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5511, '437', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5512, '437', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5513, '437', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5514, '438', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5515, '438', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5516, '438', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5517, '438', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5518, '438', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5519, '438', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5520, '438', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5521, '439', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5522, '439', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5523, '439', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5524, '439', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5525, '439', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5526, '439', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5527, '439', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5528, '440', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5529, '440', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5530, '440', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5531, '440', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5532, '440', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5533, '440', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5534, '440', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5535, '441', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5536, '441', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5537, '441', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5538, '441', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5539, '441', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5540, '441', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5541, '441', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5542, '441', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5543, '442', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5544, '442', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5545, '442', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5546, '442', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5547, '442', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5548, '442', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5549, '442', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5550, '443', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5551, '443', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5552, '443', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5553, '443', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5554, '443', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5555, '443', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5556, '443', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5557, '444', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5558, '444', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5559, '444', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5560, '444', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5561, '444', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5562, '444', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5563, '444', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5564, '445', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5565, '445', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5566, '445', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5567, '445', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5568, '445', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5569, '445', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5570, '445', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5571, '446', 1, 30, 30.00, 21.00, 9.00, 30, '2025-07-23 07:23:36', '2025-10-23 07:24:58'),
(5572, '446', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5573, '446', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5574, '446', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5575, '446', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5576, '446', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5577, '446', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5578, '446', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5579, '447', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5580, '447', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5581, '447', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5582, '447', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5583, '447', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5584, '447', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5585, '447', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5586, '448', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5587, '448', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5588, '448', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5589, '448', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5590, '448', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5591, '448', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5592, '448', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5593, '449', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5594, '449', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5595, '449', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5596, '449', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5597, '449', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5598, '449', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5599, '449', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5600, '450', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5601, '450', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5602, '450', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5603, '450', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5604, '450', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5605, '450', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5606, '450', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5607, '451', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5608, '451', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5609, '451', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5610, '451', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5611, '451', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5612, '451', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5613, '451', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5614, '451', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5615, '452', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5616, '452', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5617, '452', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5618, '452', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5619, '452', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5620, '452', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5621, '452', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5622, '453', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5623, '453', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5624, '453', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5625, '453', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5626, '453', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5627, '453', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5628, '453', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5629, '454', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5630, '454', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5631, '454', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5632, '454', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5633, '454', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5634, '454', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5635, '454', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5636, '455', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5637, '455', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5638, '455', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5639, '455', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5640, '455', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5641, '455', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5642, '455', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5643, '456', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5644, '456', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5645, '456', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5646, '456', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5647, '456', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5648, '456', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5649, '456', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5650, '457', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5651, '457', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5652, '457', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5653, '457', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5654, '457', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5655, '457', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5656, '457', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5657, '458', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5658, '458', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5659, '458', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5660, '458', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5661, '458', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5662, '458', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5663, '458', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5664, '459', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5665, '459', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5666, '459', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5667, '459', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5668, '459', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5669, '459', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5670, '459', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5671, '460', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5672, '460', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5673, '460', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5674, '460', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5675, '460', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5676, '460', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5677, '460', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5678, '461', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5679, '461', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5680, '461', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5681, '461', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5682, '461', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5683, '461', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5684, '461', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5685, '461', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5686, '462', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5687, '462', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5688, '462', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5689, '462', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5690, '462', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5691, '462', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5692, '462', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5693, '462', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5694, '463', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5695, '463', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5696, '463', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5697, '463', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5698, '463', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5699, '463', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5700, '463', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5701, '464', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5702, '464', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5703, '464', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5704, '464', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5705, '464', 3, 30, 120.00, 0.00, 120.00, 120, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5706, '464', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5707, '464', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5708, '464', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5709, '465', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5710, '465', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5711, '465', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5712, '465', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5713, '465', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5714, '465', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5715, '465', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5716, '466', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5717, '466', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5718, '466', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5719, '466', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5720, '466', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5721, '466', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5722, '466', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5723, '467', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5724, '467', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5725, '467', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5726, '467', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5727, '467', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5728, '467', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5729, '467', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5730, '468', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5731, '468', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5732, '468', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5733, '468', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5734, '468', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5735, '468', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5736, '468', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5737, '469', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5738, '469', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5739, '469', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5740, '469', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5741, '469', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5742, '469', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5743, '469', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5744, '470', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5745, '470', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5746, '470', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5747, '470', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5748, '470', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5749, '470', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5750, '470', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5751, '471', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5752, '471', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5753, '471', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5754, '471', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5755, '471', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5756, '471', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5757, '471', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5758, '472', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5759, '472', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5760, '472', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5761, '472', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5762, '472', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5763, '472', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5764, '472', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5765, '473', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5766, '473', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5767, '473', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5768, '473', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5769, '473', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5770, '473', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5771, '473', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5772, '474', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5773, '474', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5774, '474', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5775, '474', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5776, '474', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5777, '474', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5778, '474', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5779, '474', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5780, '475', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5781, '475', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5782, '475', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5783, '475', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5784, '475', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5785, '475', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5786, '475', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5787, '476', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5788, '476', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5789, '476', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5790, '476', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5791, '476', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5792, '476', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5793, '476', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5794, '477', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5795, '477', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5796, '477', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5797, '477', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5798, '477', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5799, '477', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5800, '477', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5801, '478', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5802, '478', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5803, '478', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5804, '478', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5805, '478', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5806, '478', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5807, '478', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5808, '479', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5809, '479', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5810, '479', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5811, '479', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5812, '479', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5813, '479', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5814, '479', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5815, '480', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5816, '480', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5817, '480', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5818, '480', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5819, '480', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5820, '480', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5821, '480', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5822, '481', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5823, '481', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5824, '481', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5825, '481', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5826, '481', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5827, '481', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5828, '481', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5829, '482', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5830, '482', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5831, '482', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5832, '482', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5833, '482', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5834, '482', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5835, '482', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5836, '483', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5837, '483', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5838, '483', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5839, '483', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5840, '483', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5841, '483', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5842, '483', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5843, '484', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5844, '484', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5845, '484', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5846, '484', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5847, '484', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5848, '484', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5849, '484', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5850, '485', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5851, '485', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5852, '485', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5853, '485', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5854, '485', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5855, '485', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5856, '485', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5857, '486', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5858, '486', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5859, '486', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5860, '486', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5861, '486', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5862, '486', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5863, '486', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5864, '487', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5865, '487', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5866, '487', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5867, '487', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5868, '487', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5869, '487', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5870, '487', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5871, '488', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5872, '488', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5873, '488', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5874, '488', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5875, '488', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5876, '488', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5877, '488', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5878, '489', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5879, '489', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5880, '489', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5881, '489', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5882, '489', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5883, '489', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5884, '489', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5885, '490', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5886, '490', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5887, '490', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5888, '490', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5889, '490', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5890, '490', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5891, '490', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5892, '491', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5893, '491', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5894, '491', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5895, '491', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5896, '491', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5897, '491', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5898, '491', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5899, '492', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5900, '492', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5901, '492', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5902, '492', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5903, '492', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5904, '492', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5905, '492', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5906, '493', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5907, '493', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5908, '493', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5909, '493', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5910, '493', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5911, '493', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5912, '493', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5913, '494', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5914, '494', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5915, '494', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5916, '494', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5917, '494', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5918, '494', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5919, '494', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5920, '495', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5921, '495', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5922, '495', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5923, '495', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5924, '495', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5925, '495', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5926, '495', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5927, '496', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5928, '496', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5929, '496', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5930, '496', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5931, '496', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5932, '496', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5933, '496', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5934, '497', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5935, '497', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5936, '497', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5937, '497', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5938, '497', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5939, '497', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5940, '497', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5941, '498', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5942, '498', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5943, '498', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5944, '498', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5945, '498', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5946, '498', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5947, '498', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5948, '499', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5949, '499', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5950, '499', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5951, '499', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5952, '499', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5953, '499', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5954, '499', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5955, '500', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5956, '500', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5957, '500', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5958, '500', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5959, '500', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5960, '500', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5961, '500', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5962, '500', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5963, '501', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5964, '501', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5965, '501', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5966, '501', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5967, '501', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5968, '501', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5969, '501', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5970, '502', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5971, '502', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5972, '502', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5973, '502', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5974, '502', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5975, '502', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36');
INSERT INTO `employee_leave_balances` (`id`, `employee_id`, `leave_type_id`, `financial_year_id`, `allocated_days`, `used_days`, `remaining_days`, `total_days`, `created_at`, `updated_at`) VALUES
(5976, '502', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5977, '502', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5978, '503', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5979, '503', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5980, '503', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5981, '503', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5982, '503', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5983, '503', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5984, '503', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5985, '504', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5986, '504', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5987, '504', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5988, '504', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5989, '504', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5990, '504', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5991, '504', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5992, '505', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5993, '505', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5994, '505', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5995, '505', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5996, '505', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5997, '505', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5998, '505', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(5999, '506', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6000, '506', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6001, '506', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6002, '506', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6003, '506', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6004, '506', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6005, '506', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6006, '507', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6007, '507', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6008, '507', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6009, '507', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6010, '507', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6011, '507', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6012, '507', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6013, '508', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6014, '508', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6015, '508', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6016, '508', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6017, '508', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6018, '508', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6019, '508', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6020, '509', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6021, '509', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6022, '509', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6023, '509', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6024, '509', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6025, '509', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6026, '509', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6027, '510', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6028, '510', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6029, '510', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6030, '510', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6031, '510', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6032, '510', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6033, '510', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6034, '511', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6035, '511', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6036, '511', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6037, '511', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6038, '511', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6039, '511', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6040, '511', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6041, '511', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6042, '512', 1, 30, 30.00, 0.00, 30.00, 30, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6043, '512', 6, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6044, '512', 5, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6045, '512', 2, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6046, '512', 4, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6047, '512', 7, 30, 10.00, 0.00, 10.00, 10, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6048, '512', 9, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6049, '512', 8, 30, 0.00, 0.00, 0.00, 0, '2025-07-23 07:23:36', '2025-07-23 07:23:36'),
(6052, '406', 3, 30, 120.00, 0.00, 120.00, 120, '2025-10-23 09:06:40', '2025-10-23 09:06:40');

-- --------------------------------------------------------

--
-- Table structure for table `employee_loans`
--

CREATE TABLE `employee_loans` (
  `loan_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `loan_type` varchar(100) NOT NULL,
  `principal_amount` decimal(10,2) NOT NULL,
  `interest_rate` decimal(5,2) DEFAULT 0.00,
  `remaining_balance` decimal(10,2) NOT NULL,
  `loan_duration` int(11) NOT NULL,
  `months_remaining` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `last_payment_date` date DEFAULT NULL,
  `calculation_type` enum('fixed','percentage','reducing_balance') NOT NULL DEFAULT 'fixed',
  `calculation_details` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('active','completed','cancelled','defaulted') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_loans`
--

INSERT INTO `employee_loans` (`loan_id`, `emp_id`, `loan_type`, `principal_amount`, `interest_rate`, `remaining_balance`, `loan_duration`, `months_remaining`, `start_date`, `last_payment_date`, `calculation_type`, `calculation_details`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 146, 'reducing Balance', 1000.00, 12.00, 1000.00, 8, 8, '2025-11-01', NULL, 'percentage', '{\"calculation_type\":\"percentage\",\"monthly_amount\":\"\",\"percentage_rate\":\"10\",\"interest_rate\":\"12\"}', 'Equity Loans', 'active', '2025-10-06 07:52:46', '2025-10-06 07:52:46'),
(2, 145, 'reducing Balance', 10000.00, 15.00, 0.00, 12, 11, '2025-10-01', '2025-12-31', 'fixed', '{\"calculation_type\":\"fixed\",\"monthly_amount\":\"30000\",\"percentage_rate\":\"\",\"interest_rate\":\"15\"}', 'loan', 'completed', '2025-10-06 11:08:19', '2025-10-06 11:08:30'),
(3, 145, 'Fixed', 120000.00, 17.00, 103100.00, 10, 0, '2025-10-01', '2025-10-07', 'percentage', '{\"calculation_type\":\"percentage\",\"monthly_amount\":\"\",\"percentage_rate\":\"2\",\"interest_rate\":\"17\"}', 'Hello', 'active', '2025-10-06 11:09:35', '2025-10-07 07:18:49'),
(4, 150, 'reducing Balance', 10000.00, 10.00, 0.00, 12, 10, '2025-11-01', '2025-10-07', 'fixed', '{\"calculation_type\":\"fixed\",\"monthly_amount\":\"50000\",\"percentage_rate\":\"\",\"interest_rate\":\"10\"}', '', 'completed', '2025-10-07 07:13:28', '2025-10-07 07:13:43'),
(5, 150, 'error', 100000.00, 12.00, 0.00, 10, 6, '2026-01-01', '2025-10-07', 'percentage', '{\"calculation_type\":\"percentage\",\"monthly_amount\":\"\",\"percentage_rate\":\"10\",\"interest_rate\":\"12\"}', '', 'completed', '2025-10-07 07:15:36', '2025-10-07 07:18:50'),
(6, 118, 'Equity Loan', 120000.00, 13.00, 120000.00, 10, 10, '2025-11-01', NULL, 'percentage', '{\"calculation_type\":\"percentage\",\"monthly_amount\":\"\",\"percentage_rate\":\"5\",\"interest_rate\":\"13\"}', 'DESCRIBE', 'active', '2025-10-08 07:43:47', '2025-10-08 07:43:47');

-- --------------------------------------------------------

--
-- Table structure for table `financial_years`
--

CREATE TABLE `financial_years` (
  `id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `year_name` varchar(100) NOT NULL,
  `total_days` int(11) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `financial_years`
--

INSERT INTO `financial_years` (`id`, `start_date`, `end_date`, `year_name`, `total_days`, `is_active`, `created_at`, `updated_at`) VALUES
(30, '2025-07-01', '2026-06-30', '2025/26', 365, 1, '2025-07-23 07:23:35', '2025-07-23 07:23:35');

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `description` text DEFAULT NULL,
  `is_recurring` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `holidays`
--

INSERT INTO `holidays` (`id`, `name`, `date`, `description`, `is_recurring`, `created_at`) VALUES
(1, 'Jamhuri day', '2025-12-12', 'To become a republic', 1, '2025-07-22 06:41:38');

-- --------------------------------------------------------

--
-- Table structure for table `leave_applications`
--

CREATE TABLE `leave_applications` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `days_requested` int(11) NOT NULL,
  `reason` text NOT NULL,
  `deduction_details` text DEFAULT NULL COMMENT 'JSON storage of deduction plan',
  `primary_days` int(11) DEFAULT 0 COMMENT 'Days deducted from primary leave type',
  `annual_days` int(11) DEFAULT 0 COMMENT 'Days deducted from annual leave',
  `unpaid_days` int(11) DEFAULT 0 COMMENT 'Days that are unpaid',
  `status` enum('pending','pending_section_head','pending_dept_head','pending_managing_director','pending_hr_manager','approved','rejected','pending_bod_chair','pending_subsection_head') NOT NULL DEFAULT 'pending',
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `section_head_approval` enum('pending','approved','rejected') DEFAULT 'pending',
  `section_head_approved_by` varchar(50) DEFAULT NULL,
  `section_head_approved_at` timestamp NULL DEFAULT NULL,
  `dept_head_approval` enum('pending','approved','rejected') DEFAULT 'pending',
  `dept_head_approved_by` varchar(50) DEFAULT NULL,
  `dept_head_approved_at` timestamp NULL DEFAULT NULL,
  `hr_processed_by` varchar(50) DEFAULT NULL,
  `hr_processed_at` timestamp NULL DEFAULT NULL,
  `hr_comments` text DEFAULT NULL,
  `approver_id` int(11) DEFAULT NULL,
  `section_head_emp_id` int(11) DEFAULT NULL,
  `dept_head_emp_id` int(11) DEFAULT NULL,
  `days_deducted` int(11) DEFAULT 0,
  `days_from_annual` int(11) DEFAULT 0,
  `managing_director_approved_by` int(11) DEFAULT NULL,
  `hr_approved_by` int(11) DEFAULT NULL,
  `hr_approved_at` datetime DEFAULT NULL,
  `managing_director_approved_at` datetime DEFAULT NULL,
  `md_emp_id` int(11) DEFAULT NULL,
  `subsection_head_emp_id` int(11) DEFAULT NULL,
  `subsection_head_approval` enum('pending','approved','rejected') DEFAULT 'pending',
  `subsection_head_approved_by` int(11) DEFAULT NULL,
  `subsection_head_approved_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_applications`
--

INSERT INTO `leave_applications` (`id`, `employee_id`, `leave_type_id`, `start_date`, `end_date`, `days_requested`, `reason`, `deduction_details`, `primary_days`, `annual_days`, `unpaid_days`, `status`, `applied_at`, `section_head_approval`, `section_head_approved_by`, `section_head_approved_at`, `dept_head_approval`, `dept_head_approved_by`, `dept_head_approved_at`, `hr_processed_by`, `hr_processed_at`, `hr_comments`, `approver_id`, `section_head_emp_id`, `dept_head_emp_id`, `days_deducted`, `days_from_annual`, `managing_director_approved_by`, `hr_approved_by`, `hr_approved_at`, `managing_director_approved_at`, `md_emp_id`, `subsection_head_emp_id`, `subsection_head_approval`, `subsection_head_approved_by`, `subsection_head_approved_at`) VALUES
(201, 446, 1, '2025-10-24', '2025-11-22', 21, 'annual', NULL, 21, 0, 0, 'approved', '2025-10-23 07:24:58', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 'pending', NULL, NULL),
(202, 392, 6, '2025-12-06', '2025-12-09', 2, 'apply', NULL, 0, 0, 0, 'approved', '2025-10-23 07:31:43', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 10:32:16', NULL, NULL, NULL, 'pending', NULL, NULL),
(203, 392, 7, '2025-10-24', '2025-11-03', 7, 'compassionate', NULL, 7, 0, 0, 'approved', '2025-10-23 07:33:42', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 10:34:07', NULL, NULL, NULL, 'pending', NULL, NULL),
(204, 392, 1, '2025-10-23', '2025-11-20', 21, 'apply', NULL, 21, 0, 0, 'approved', '2025-10-23 07:34:57', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 10:35:26', NULL, NULL, NULL, 'pending', NULL, NULL),
(205, 392, 1, '2025-10-24', '2025-11-13', 15, 'annual', NULL, 15, 0, 0, 'approved', '2025-10-23 08:17:04', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 11:20:35', NULL, NULL, NULL, 'pending', NULL, NULL),
(206, 392, 1, '2025-10-24', '2025-11-13', 15, 'annual', NULL, 15, 0, 0, 'approved', '2025-10-23 08:17:11', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 11:20:28', NULL, NULL, NULL, 'pending', NULL, NULL),
(207, 392, 1, '2025-10-24', '2025-11-15', 16, 'annual', NULL, 16, 0, 0, 'approved', '2025-10-23 08:57:43', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 11:57:59', NULL, NULL, NULL, 'pending', NULL, NULL),
(208, 418, 1, '2025-10-24', '2025-11-15', 16, 'annual', NULL, 16, 0, 0, 'approved', '2025-10-23 08:58:55', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 11:59:09', NULL, NULL, NULL, 'pending', NULL, NULL),
(209, 392, 1, '2025-10-23', '2025-11-15', 17, 'apply', NULL, 17, 0, 0, 'approved', '2025-10-23 09:17:23', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 12:18:50', NULL, NULL, NULL, 'pending', NULL, NULL),
(210, 483, 1, '2025-10-23', '2025-11-12', 15, 'apply', NULL, 15, 0, 0, '', '2025-10-23 09:45:07', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 'pending', NULL, NULL),
(211, 392, 1, '2025-10-23', '2025-11-12', 15, 'apply', NULL, 15, 0, 0, 'approved', '2025-10-23 09:50:08', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 12:50:29', NULL, NULL, NULL, 'pending', NULL, NULL),
(212, 392, 1, '2025-10-23', '2025-11-12', 15, 'apply', NULL, 15, 0, 0, 'approved', '2025-10-23 09:56:16', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 12:56:35', NULL, NULL, NULL, 'pending', NULL, NULL),
(213, 392, 1, '2025-10-23', '2025-11-12', 15, 'apply', NULL, 15, 0, 0, 'approved', '2025-10-23 10:03:18', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 13:03:30', NULL, NULL, NULL, 'pending', NULL, NULL),
(214, 392, 1, '2025-10-24', '2025-11-13', 15, 'apply', NULL, 15, 0, 0, 'approved', '2025-10-23 11:06:48', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 14:07:09', NULL, NULL, NULL, 'pending', NULL, NULL),
(215, 392, 9, '2025-10-24', '2025-10-29', 4, 'clain a day', NULL, 0, 0, 0, 'approved', '2025-10-23 11:18:06', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 14:18:23', NULL, NULL, NULL, 'pending', NULL, NULL),
(216, 392, 1, '2025-10-24', '2025-11-20', 20, 'annual', NULL, 20, 0, 0, 'approved', '2025-10-23 11:39:05', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 14:52:17', NULL, NULL, NULL, 'pending', NULL, NULL),
(217, 392, 6, '2025-10-24', '2025-10-27', 2, 'apply', NULL, 0, 0, 0, 'approved', '2025-10-23 12:00:51', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, 446, '2025-10-23 15:02:08', NULL, NULL, NULL, 'pending', NULL, NULL),
(218, 483, 1, '2025-10-24', '2025-11-15', 16, '', NULL, 16, 0, 0, '', '2025-10-23 13:20:27', 'pending', NULL, NULL, 'pending', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 'pending', NULL, NULL),
(219, 418, 1, '2025-10-24', '2025-11-18', 18, '', NULL, 18, 0, 0, 'rejected', '2025-10-23 13:21:19', 'pending', NULL, NULL, 'pending', '434', '2025-10-23 13:21:49', NULL, NULL, NULL, NULL, 418, 434, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 'pending', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `leave_history`
--

CREATE TABLE `leave_history` (
  `id` int(11) NOT NULL,
  `leave_application_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `performed_by` int(11) NOT NULL,
  `comments` text DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_history`
--

INSERT INTO `leave_history` (`id`, `leave_application_id`, `action`, `performed_by`, `comments`, `performed_at`) VALUES
(1, 22, 'applied', 9, 'Leave application submitted for 4 days', '2025-07-29 03:44:04'),
(2, 23, 'applied', 4, 'Leave application submitted for 3 days', '2025-07-29 06:03:59'),
(3, 24, 'applied', 5, 'Leave application submitted for 6 days', '2025-07-29 06:42:22'),
(4, 25, 'applied', 5, 'Leave application submitted for 4 days', '2025-07-29 09:04:27'),
(5, 25, 'dept_head_approved', 6, 'Approved by department head', '2025-07-29 09:07:44'),
(6, 26, 'applied', 5, 'Leave application submitted for 6 days', '2025-07-29 09:14:31'),
(7, 26, 'dept_head_approved', 6, 'Approved by department head', '2025-07-29 09:15:24'),
(8, 27, 'applied', 6, 'Leave application submitted for 5 days', '2025-07-29 09:22:27'),
(9, 28, 'applied', 4, 'Leave application submitted for 2 days', '2025-08-07 13:01:49'),
(10, 28, 'section_head_approved', 5, 'Approved by section head', '2025-08-07 13:02:36'),
(11, 28, 'dept_head_approved', 6, 'Approved by department head', '2025-08-07 13:03:12'),
(12, 29, 'applied', 4, 'Leave application submitted for 10 days', '2025-08-08 07:46:07'),
(13, 30, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-08 09:35:07'),
(14, 31, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-08 09:37:30'),
(15, 32, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-08 09:44:50'),
(16, 33, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-08 09:48:09'),
(17, 34, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-08 10:01:51'),
(18, 35, 'applied', 9, 'Leave application submitted for 2 days', '2025-08-08 11:14:20'),
(19, 36, 'applied', 9, 'Leave application submitted for 7 days', '2025-08-10 14:58:29'),
(20, 37, 'applied', 9, 'Leave application submitted for 4 days', '2025-08-10 17:06:42'),
(21, 38, 'applied', 4, 'Leave application submitted for 1 days', '2025-08-10 17:10:25'),
(22, 39, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 17:33:18'),
(23, 40, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 17:36:06'),
(24, 41, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 17:36:19'),
(25, 42, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 17:36:32'),
(26, 43, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 17:36:56'),
(27, 44, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 17:38:32'),
(28, 45, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 18:01:21'),
(29, 46, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 18:01:30'),
(30, 47, 'applied', 9, 'Leave application submitted for 11 days', '2025-08-10 18:03:17'),
(31, 48, 'applied', 9, 'Leave application submitted for 11 days', '2025-08-10 19:23:29'),
(32, 49, 'applied', 9, 'Leave application submitted for 2 days', '2025-08-10 20:17:31'),
(33, 50, 'applied', 9, 'Leave application submitted for 2 days', '2025-08-10 20:31:16'),
(34, 51, 'applied', 9, 'Leave application submitted for 2 days', '2025-08-10 20:31:50'),
(35, 52, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 20:36:33'),
(36, 53, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 20:46:24'),
(37, 54, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 20:47:31'),
(38, 55, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 20:48:53'),
(39, 56, 'applied', 9, 'Leave application submitted for 3 days', '2025-08-10 21:12:40'),
(40, 57, 'applied', 9, 'Leave application submitted for 2 days', '2025-08-10 21:13:15'),
(41, 58, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 21:15:57'),
(42, 59, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 21:17:39'),
(43, 60, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 21:19:16'),
(44, 61, 'applied', 9, 'Leave application submitted for 1 days', '2025-08-10 21:26:03'),
(45, 62, 'applied', 9, 'Leave application submitted for 2 days', '2025-08-10 21:27:00'),
(46, 63, 'applied', 5, 'Leave application submitted for 2 days', '2025-08-10 21:28:39'),
(47, 64, 'applied', 6, 'Leave application submitted for 5 days', '2025-08-10 21:29:57'),
(48, 65, 'applied', 4, 'Leave application submitted for 1 days', '2025-08-11 09:01:55'),
(49, 66, 'applied', 6, 'Leave application submitted for 9 days', '2025-08-25 12:53:41'),
(50, 67, 'applied', 6, 'Leave application submitted for 9 days', '2025-08-25 13:32:56'),
(51, 68, 'applied', 9, 'Leave application submitted for 66 days', '2025-08-25 19:03:55'),
(52, 69, 'applied', 9, 'Leave application submitted for 66 days', '2025-08-25 19:16:48'),
(53, 70, 'applied', 9, 'Leave application submitted for 66 days', '2025-08-25 19:46:36'),
(54, 71, 'applied', 9, 'Leave application submitted for 12 days', '2025-09-03 08:18:44'),
(55, 72, 'applied', 9, 'Leave application submitted for 4 days', '2025-09-03 08:26:00'),
(56, 73, 'applied', 4, 'Leave application submitted for 4 days', '2025-09-03 08:36:02'),
(57, 74, 'applied', 4, 'Leave application submitted for 17 days', '2025-09-03 08:41:15'),
(58, 75, 'applied', 9, 'Leave application submitted for 6 days', '2025-09-03 08:46:51'),
(59, 76, 'applied', 9, 'Leave application submitted for 14 days', '2025-09-03 08:52:14'),
(60, 77, 'applied', 9, 'Leave application submitted for 6 days', '2025-09-03 08:53:56'),
(61, 78, 'applied', 9, 'Leave application submitted for 6 days', '2025-09-03 08:56:31'),
(62, 79, 'applied', 9, 'Leave application submitted for 42 days', '2025-09-03 08:56:58'),
(63, 80, 'applied', 9, 'Leave application submitted for 5 days', '2025-09-03 11:33:43'),
(64, 81, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-03 11:39:16'),
(65, 82, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-03 13:00:47'),
(66, 83, 'applied', 6, 'Leave application submitted for 3 days', '2025-09-03 13:37:52'),
(67, 84, 'applied', 6, 'Leave application submitted for 3 days', '2025-09-03 13:38:52'),
(68, 85, 'applied', 6, 'Leave application submitted for 6 days', '2025-09-03 13:40:09'),
(69, 86, 'applied', 6, 'Leave application submitted for 2 days', '2025-09-03 14:00:58'),
(70, 87, 'applied', 9, 'Leave application submitted for 4 days', '2025-09-03 14:03:22'),
(71, 88, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-03 14:04:20'),
(72, 89, 'applied', 9, 'Leave application submitted for 3 days', '2025-09-04 06:25:33'),
(73, 90, 'applied', 9, 'Leave application submitted for 3 days', '2025-09-04 07:33:48'),
(74, 91, 'applied', 9, 'Leave application submitted for 3 days', '2025-09-04 07:37:01'),
(75, 92, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-04 07:38:34'),
(76, 93, 'applied', 5, 'Leave application submitted for 2 days', '2025-09-04 07:41:28'),
(77, 94, 'applied', 9, 'Leave application submitted for 16 days', '2025-09-04 07:55:46'),
(78, 95, 'applied', 9, 'Leave application submitted for 17 days', '2025-09-04 07:56:28'),
(79, 96, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 07:59:32'),
(80, 97, 'applied', 9, 'Leave application submitted for 4 days', '2025-09-04 08:03:56'),
(81, 98, 'applied', 9, 'Leave application submitted for 4 days', '2025-09-04 08:05:00'),
(82, 99, 'applied', 9, 'Leave application submitted for 6 days', '2025-09-04 08:05:34'),
(83, 100, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 08:06:37'),
(84, 101, 'applied', 9, 'Leave application submitted for 25 days', '2025-09-04 09:07:05'),
(85, 102, 'applied', 9, 'Leave application submitted for 25 days', '2025-09-04 09:07:45'),
(86, 103, 'applied', 9, 'Leave application submitted for 24 days', '2025-09-04 09:08:21'),
(87, 104, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 09:17:03'),
(88, 105, 'applied', 9, 'Leave application submitted for 5 days', '2025-09-04 09:18:13'),
(89, 106, 'applied', 9, 'Leave application submitted for 17 days', '2025-09-04 09:23:45'),
(90, 107, 'applied', 5, 'Leave application submitted for 2 days', '2025-09-04 09:26:33'),
(91, 108, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-04 09:40:02'),
(92, 109, 'applied', 5, 'Leave application submitted for 4 days', '2025-09-04 09:42:13'),
(93, 110, 'applied', 6, 'Leave application submitted for 1 days', '2025-09-04 09:55:07'),
(94, 111, 'applied', 6, 'Leave application submitted for 1 days', '2025-09-04 09:56:12'),
(95, 112, 'applied', 5, 'Leave application submitted for 2 days', '2025-09-04 09:56:56'),
(96, 113, 'applied', 5, 'Leave application submitted for 1 days', '2025-09-04 09:57:58'),
(97, 114, 'applied', 5, 'Leave application submitted for 1 days', '2025-09-04 09:58:52'),
(98, 115, 'applied', 6, 'Leave application submitted for 1 days', '2025-09-04 10:00:56'),
(99, 116, 'applied', 6, 'Leave application submitted for 1 days', '2025-09-04 10:01:35'),
(100, 117, 'applied', 6, 'Leave application submitted for 1 days', '2025-09-04 10:02:31'),
(101, 118, 'applied', 6, 'Leave application submitted for 1 days', '2025-09-04 10:05:36'),
(102, 119, 'applied', 6, 'Leave application submitted for 17 days', '2025-09-04 11:21:04'),
(103, 120, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 11:24:29'),
(104, 121, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 11:25:44'),
(105, 122, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 11:26:17'),
(106, 123, 'applied', 9, 'Leave application submitted for 22 days', '2025-09-04 11:27:32'),
(107, 124, 'applied', 9, 'Leave application submitted for 22 days', '2025-09-04 11:27:35'),
(108, 125, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 11:29:33'),
(109, 126, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 11:47:54'),
(110, 127, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 11:49:00'),
(111, 128, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 11:51:18'),
(112, 129, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 12:09:01'),
(113, 130, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 12:17:11'),
(114, 131, 'applied', 9, 'Leave application submitted for 23 days', '2025-09-04 12:18:28'),
(115, 132, 'applied', 9, 'Leave application submitted for 23 days', '2025-09-04 12:26:09'),
(116, 133, 'applied', 9, 'Leave application submitted for 23 days', '2025-09-04 12:26:20'),
(117, 134, 'applied', 9, 'Leave application submitted for 23 days', '2025-09-04 12:30:31'),
(118, 135, 'applied', 9, 'Leave application submitted for 23 days', '2025-09-04 12:46:53'),
(119, 136, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 12:47:42'),
(120, 137, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 12:48:21'),
(121, 138, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 12:51:22'),
(122, 139, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 13:23:45'),
(123, 140, 'applied', 9, 'Leave application submitted for 1 days', '2025-09-04 13:25:35'),
(124, 141, 'applied', 9, 'Leave application submitted for 18 days', '2025-09-04 13:28:20'),
(125, 142, 'applied', 9, 'Leave application submitted for 4 days', '2025-09-04 13:32:08'),
(126, 143, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-04 13:32:54'),
(127, 144, 'applied', 5, 'Leave application submitted for 24 days', '2025-09-04 13:34:12'),
(128, 145, 'applied', 5, 'Leave application submitted for 19 days with status: approved', '2025-09-04 13:55:14'),
(129, 146, 'applied', 9, 'Leave application submitted for 17 days', '2025-09-05 06:45:16'),
(130, 147, 'applied', 9, 'Leave application submitted for 2 days', '2025-09-05 07:23:41'),
(131, 148, 'applied', 9, 'Leave application submitted for 3 days', '2025-09-05 07:31:48'),
(132, 149, 'applied', 9, 'Leave application submitted for 22 days', '2025-10-07 11:23:55'),
(133, 150, 'applied', 9, 'Leave application submitted for 9 days', '2025-10-07 11:26:04'),
(135, 152, 'applied', 312, 'Leave application submitted for 18 days', '2025-10-15 06:11:01'),
(136, 153, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 06:18:50'),
(137, 156, 'auto-approved', 312, 'Leave application auto-approved (HR Manager self-approval) for 2 days', '2025-10-15 07:16:58'),
(138, 157, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 07:18:54'),
(139, 158, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 07:20:13'),
(140, 159, 'applied', 312, 'Leave application submitted for 12 days', '2025-10-15 07:21:54'),
(141, 160, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 07:25:10'),
(142, 161, 'applied', 312, 'Leave application submitted for 18 days', '2025-10-15 07:49:10'),
(143, 162, 'applied', 312, 'Leave application submitted for 18 days', '2025-10-15 07:51:13'),
(144, 163, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 08:08:24'),
(145, 164, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-15 08:09:39'),
(146, 165, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 08:11:40'),
(147, 166, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 08:16:52'),
(148, 167, 'applied', 312, 'Leave application submitted for 3 days', '2025-10-15 08:20:52'),
(149, 168, 'applied', 312, 'Leave application submitted for 5 days', '2025-10-15 08:23:26'),
(150, 169, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 08:31:56'),
(151, 170, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 08:32:46'),
(152, 171, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-15 08:35:29'),
(153, 172, 'applied', 312, 'Leave application submitted for 6 days', '2025-10-15 09:11:59'),
(154, 173, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 09:13:49'),
(155, 174, 'applied', 312, 'Leave application submitted for 1 days', '2025-10-15 09:15:08'),
(156, 175, 'applied', 312, 'Leave application submitted for 3 days', '2025-10-15 09:17:05'),
(157, 176, 'applied', 312, 'Leave application submitted for 9 days', '2025-10-15 09:26:25'),
(158, 177, 'applied', 366, 'Leave application submitted for 17 days', '2025-10-15 09:51:29'),
(159, 178, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 09:58:01'),
(160, 179, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 09:58:57'),
(161, 180, 'applied', 312, 'Leave application submitted for 1 days', '2025-10-15 10:00:24'),
(162, 181, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 10:01:45'),
(163, 182, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 10:03:46'),
(164, 183, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 10:06:06'),
(165, 184, 'applied', 312, 'Leave application submitted for 3 days', '2025-10-15 11:24:20'),
(166, 185, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 11:26:22'),
(167, 186, 'applied', 312, 'Leave application submitted for 2 days', '2025-10-15 11:34:38'),
(168, 187, 'applied', 312, 'Leave application submitted for 1 days', '2025-10-15 11:48:48'),
(169, 188, 'applied', 266, 'Leave application submitted for 2 days', '2025-10-15 11:51:16'),
(170, 189, 'applied', 312, 'Leave application submitted for 8 days', '2025-10-15 12:07:38'),
(171, 190, 'applied', 312, 'Leave application submitted for 1 days', '2025-10-16 07:55:03'),
(172, 191, 'applied', 368, 'Leave application submitted for 16 days', '2025-10-16 12:59:32'),
(173, 192, 'applied', 312, 'Leave application submitted for 18 days', '2025-10-21 08:04:58'),
(174, 193, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-22 07:23:15'),
(175, 194, 'applied', 312, 'Leave application submitted for 4 days', '2025-10-22 07:28:06'),
(176, 195, 'applied', 312, 'Leave application submitted for 7 days', '2025-10-22 08:20:46'),
(177, 196, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-22 08:57:45'),
(178, 197, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-22 09:09:01'),
(179, 198, 'applied', 300, 'Leave application submitted for 17 days', '2025-10-22 11:18:01'),
(180, 199, 'applied', 312, 'Leave application submitted for 30 days', '2025-10-22 12:46:25'),
(181, 200, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-23 05:39:52'),
(182, 201, 'auto-approved', 312, 'Leave application auto-approved (HR Manager self-approval) for 21 days', '2025-10-23 07:24:58'),
(183, 202, 'applied', 258, 'Leave application submitted for 2 days', '2025-10-23 07:31:43'),
(184, 203, 'applied', 258, 'Leave application submitted for 7 days', '2025-10-23 07:33:42'),
(185, 204, 'applied', 258, 'Leave application submitted for 21 days', '2025-10-23 07:34:57'),
(186, 205, 'applied', 258, 'Leave application submitted for 15 days', '2025-10-23 08:17:04'),
(187, 206, 'applied', 258, 'Leave application submitted for 15 days', '2025-10-23 08:17:11'),
(188, 207, 'applied', 312, 'Leave application submitted for 16 days', '2025-10-23 08:57:43'),
(189, 208, 'applied', 312, 'Leave application submitted for 16 days', '2025-10-23 08:58:55'),
(190, 209, 'applied', 312, 'Leave application submitted for 17 days', '2025-10-23 09:17:23'),
(191, 210, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-23 09:45:07'),
(192, 211, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-23 09:50:08'),
(193, 212, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-23 09:56:16'),
(194, 213, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-23 10:03:18'),
(195, 214, 'applied', 312, 'Leave application submitted for 15 days', '2025-10-23 11:06:48'),
(196, 215, 'applied', 312, 'Leave application submitted for 4 days', '2025-10-23 11:18:06'),
(197, 216, 'applied', 312, 'Leave application submitted for 20 days', '2025-10-23 11:39:06'),
(198, 217, 'applied', 258, 'Leave application submitted for 2 days', '2025-10-23 12:00:51'),
(199, 218, 'applied', 312, 'Leave application submitted for 16 days', '2025-10-23 13:20:27'),
(200, 219, 'applied', 312, 'Leave application submitted for 18 days', '2025-10-23 13:21:19');

-- --------------------------------------------------------

--
-- Table structure for table `leave_transactions`
--

CREATE TABLE `leave_transactions` (
  `id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `transaction_date` datetime NOT NULL,
  `transaction_type` enum('deduction','restoration','adjustment') NOT NULL,
  `details` text DEFAULT NULL COMMENT 'JSON storage of transaction details',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Audit trail for all leave transactions';

--
-- Dumping data for table `leave_transactions`
--

INSERT INTO `leave_transactions` (`id`, `application_id`, `employee_id`, `transaction_date`, `transaction_type`, `details`, `created_at`) VALUES
(8, 22, 135, '2025-07-29 09:44:04', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":4,\"warnings\":\"No available balance. All 4 days will be unpaid.\"}', '2025-07-29 03:44:04'),
(9, 23, 118, '2025-07-29 12:03:59', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":3,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 3 days from Annual Leave.\"}', '2025-07-29 06:03:59'),
(11, 25, 5, '2025-07-29 15:04:27', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":4,\"warnings\":\"No available balance. All 4 days will be unpaid.\"}', '2025-07-29 09:04:27'),
(12, 26, 5, '2025-07-29 15:14:31', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":6,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-07-29 09:14:31'),
(13, 27, 121, '2025-07-29 15:22:27', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":5,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-07-29 09:22:27'),
(14, 28, 118, '2025-08-07 16:01:49', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":2,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-07 13:01:49'),
(15, 29, 118, '2025-08-08 10:46:07', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":10,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-08 07:46:07'),
(16, 30, 112, '2025-08-08 12:35:07', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 3 days will be unpaid.\"}', '2025-08-08 09:35:07'),
(17, 31, 135, '2025-08-08 12:37:30', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 3 days will be unpaid.\"}', '2025-08-08 09:37:30'),
(18, 32, 118, '2025-08-08 12:44:49', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":3,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-08 09:44:49'),
(19, 33, 118, '2025-08-08 12:48:09', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-08 09:48:09'),
(20, 34, 135, '2025-08-08 13:01:51', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 3 days will be unpaid.\"}', '2025-08-08 10:01:51'),
(21, 35, 118, '2025-08-08 14:14:20', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":2,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-08 11:14:20'),
(22, 36, 136, '2025-08-10 17:58:29', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":7,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 7 days will be unpaid.\"}', '2025-08-10 14:58:29'),
(23, 37, 118, '2025-08-10 20:06:42', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":4,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 17:06:42'),
(24, 38, 118, '2025-08-10 20:10:25', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 17:10:25'),
(25, 39, 104, '2025-08-10 20:33:18', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"No available balance. All 3 days will be unpaid.\"}', '2025-08-10 17:33:18'),
(26, 40, 104, '2025-08-10 20:36:06', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"No available balance. All 3 days will be unpaid.\"}', '2025-08-10 17:36:06'),
(27, 41, 104, '2025-08-10 20:36:19', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"No available balance. All 3 days will be unpaid.\"}', '2025-08-10 17:36:19'),
(28, 42, 104, '2025-08-10 20:36:32', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"No available balance. All 3 days will be unpaid.\"}', '2025-08-10 17:36:32'),
(29, 43, 118, '2025-08-10 20:36:56', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 17:36:56'),
(30, 44, 118, '2025-08-10 20:38:32', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 17:38:32'),
(31, 45, 118, '2025-08-10 21:01:21', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 18:01:21'),
(32, 46, 118, '2025-08-10 21:01:30', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 18:01:30'),
(33, 47, 118, '2025-08-10 21:03:17', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":11,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 18:03:17'),
(34, 48, 118, '2025-08-10 22:23:29', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":11,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 19:23:29'),
(35, 54, 135, '2025-08-10 23:47:31', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":3,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Maternity Leave balance.\"}', '2025-08-10 20:47:31'),
(36, 55, 135, '2025-08-10 23:48:53', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":3,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Maternity Leave balance.\"}', '2025-08-10 20:48:53'),
(37, 56, 135, '2025-08-11 00:12:40', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":3,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Maternity Leave balance.\"}', '2025-08-10 21:12:40'),
(38, 57, 118, '2025-08-11 00:13:15', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":2,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 21:13:15'),
(39, 58, 135, '2025-08-11 00:15:57', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Compassionate Leave balance.\"}', '2025-08-10 21:15:57'),
(40, 59, 118, '2025-08-11 00:17:39', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Compassionate Leave balance.\"}', '2025-08-10 21:17:39'),
(41, 60, 118, '2025-08-11 00:19:16', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Compassionate Leave balance.\"}', '2025-08-10 21:19:16'),
(42, 61, 118, '2025-08-11 00:26:03', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Compassionate Leave balance.\"}', '2025-08-10 21:26:03'),
(43, 62, 118, '2025-08-11 00:27:00', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"No available balance. All 2 days will be unpaid.\"}', '2025-08-10 21:27:00'),
(44, 63, 118, '2025-08-11 00:28:39', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":2,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-08-10 21:28:39'),
(45, 64, 118, '2025-08-11 00:29:57', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":5,\"warnings\":\"No available balance. All 5 days will be unpaid.\"}', '2025-08-10 21:29:57'),
(46, 65, 118, '2025-08-11 12:01:55', 'deduction', '{\"primary_leave_type\":5,\"primary_days\":1,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Study Leave balance.\"}', '2025-08-11 09:01:55'),
(47, 66, 114, '2025-08-25 15:53:41', 'deduction', '{\"primary_leave_type\":5,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":9,\"warnings\":\"Insufficient leave balance. 0 days from Study Leave, 0 days from Annual Leave, 9 days will be unpaid.\"}', '2025-08-25 12:53:41'),
(48, 67, 114, '2025-08-25 16:32:56', 'deduction', '{\"primary_leave_type\":5,\"primary_days\":9,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Study Leave balance.\"}', '2025-08-25 13:32:56'),
(49, 68, 135, '2025-08-25 22:03:55', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":66,\"warnings\":\"No available balance. All 66 days will be unpaid.\"}', '2025-08-25 19:03:55'),
(50, 69, 135, '2025-08-25 22:16:48', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":66,\"warnings\":\"No available balance. All 66 days will be unpaid.\"}', '2025-08-25 19:16:48'),
(51, 70, 135, '2025-08-25 22:46:36', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":66,\"warnings\":\"No available balance. All 66 days will be unpaid.\"}', '2025-08-25 19:46:36'),
(52, 71, 121, '2025-09-03 11:18:44', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":12,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-03 08:18:44'),
(53, 72, 118, '2025-09-03 11:26:00', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":4,\"warnings\":\"No available balance. All 4 days will be unpaid.\"}', '2025-09-03 08:26:00'),
(54, 73, 118, '2025-09-03 11:36:02', 'deduction', '{\"primary_leave_type\":5,\"primary_days\":4,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Study Leave balance.\"}', '2025-09-03 08:36:02'),
(55, 74, 118, '2025-09-03 11:41:15', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":17,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-03 08:41:15'),
(56, 75, 5, '2025-09-03 11:46:51', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":6,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-03 08:46:51'),
(57, 76, 118, '2025-09-03 11:52:14', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":14,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-03 08:52:14'),
(58, 77, 122, '2025-09-03 11:53:56', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":6,\"warnings\":\"No available balance. All 6 days will be unpaid.\"}', '2025-09-03 08:53:56'),
(59, 78, 122, '2025-09-03 11:56:31', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":6,\"warnings\":\"No available balance. All 6 days will be unpaid.\"}', '2025-09-03 08:56:31'),
(60, 79, 114, '2025-09-03 11:56:58', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":42,\"warnings\":\"Requested days (42) exceed maximum allowed per year (30).; Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 42 days will be unpaid.\"}', '2025-09-03 08:56:58'),
(61, 80, 118, '2025-09-03 14:33:43', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":5,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-03 11:33:43'),
(62, 81, 118, '2025-09-03 14:39:16', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":2,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Compassionate Leave balance.\"}', '2025-09-03 11:39:16'),
(63, 82, 121, '2025-09-03 16:00:47', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 2 days to your annual leave upon approval.\"}', '2025-09-03 13:00:47'),
(64, 83, 146, '2025-09-03 16:37:52', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 3 days to your annual leave upon approval.\"}', '2025-09-03 13:37:52'),
(65, 84, 146, '2025-09-03 16:38:52', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 3 days to your annual leave upon approval.\"}', '2025-09-03 13:38:52'),
(66, 85, 121, '2025-09-03 16:40:09', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":null,\"annual_days\":6,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Annual Leave, 6 days from Annual Leave.\"}', '2025-09-03 13:40:09'),
(67, 86, 146, '2025-09-03 17:00:58', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 2 days to your annual leave upon approval.\"}', '2025-09-03 14:00:58'),
(68, 87, 113, '2025-09-03 17:03:22', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":4,\"warnings\":\"Insufficient leave balance.  days from Short Leave, 0 days from Annual Leave, 4 days will be unpaid.\"}', '2025-09-03 14:03:22'),
(69, 88, 5, '2025-09-03 17:04:20', 'deduction', '{\"primary_leave_type\":8,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"\\u2139\\ufe0f You will be absent for 2 days.\"}', '2025-09-03 14:04:20'),
(70, 89, 5, '2025-09-04 09:25:33', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 3 days to your annual leave upon approval.\"}', '2025-09-04 06:25:33'),
(71, 90, 121, '2025-09-04 10:33:48', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 3 days to your annual leave upon approval.\"}', '2025-09-04 07:33:48'),
(72, 91, 5, '2025-09-04 10:37:01', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":3,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Short Leave, 3 days from Annual Leave.\"}', '2025-09-04 07:37:01'),
(73, 92, 5, '2025-09-04 10:38:34', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":2,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Short Leave, 2 days from Annual Leave.\"}', '2025-09-04 07:38:34'),
(74, 93, 5, '2025-09-04 10:41:28', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":2,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Short Leave, 2 days from Annual Leave.\"}', '2025-09-04 07:41:28'),
(75, 94, 121, '2025-09-04 10:55:46', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":null,\"annual_days\":16,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Annual Leave, 16 days from Annual Leave.\"}', '2025-09-04 07:55:46'),
(76, 95, 5, '2025-09-04 10:56:28', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":null,\"annual_days\":17,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Annual Leave, 17 days from Annual Leave.\"}', '2025-09-04 07:56:28'),
(77, 96, 121, '2025-09-04 10:59:32', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":null,\"annual_days\":18,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Annual Leave, 18 days from Annual Leave.\"}', '2025-09-04 07:59:32'),
(78, 97, 5, '2025-09-04 11:03:56', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":4,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Short Leave, 4 days from Annual Leave.\"}', '2025-09-04 08:03:56'),
(79, 98, 121, '2025-09-04 11:05:00', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":4,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Short Leave, 4 days from Annual Leave.\"}', '2025-09-04 08:05:00'),
(80, 99, 5, '2025-09-04 11:05:34', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 6 days to your annual leave upon approval.\"}', '2025-09-04 08:05:34'),
(81, 100, 121, '2025-09-04 11:06:37', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":null,\"annual_days\":18,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient.  days from Annual Leave, 18 days from Annual Leave.\"}', '2025-09-04 08:06:37'),
(82, 101, 113, '2025-09-04 12:07:05', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":25,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 25 days will be unpaid.\"}', '2025-09-04 09:07:05'),
(83, 102, 5, '2025-09-04 12:07:45', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":24,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 24 days from Annual Leave, 1 days from Annual Leave.\"}', '2025-09-04 09:07:45'),
(84, 103, 121, '2025-09-04 12:08:21', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":24,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 09:08:21'),
(85, 104, 121, '2025-09-04 12:17:03', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":18,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 09:17:03'),
(86, 105, 5, '2025-09-04 12:18:13', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":5,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 5 days from Annual Leave.\"}', '2025-09-04 09:18:13'),
(87, 106, 121, '2025-09-04 12:23:45', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":17,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 09:23:45'),
(88, 107, 5, '2025-09-04 12:26:33', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":2,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 2 days from Annual Leave.\"}', '2025-09-04 09:26:33'),
(89, 108, 5, '2025-09-04 12:40:02', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":2,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 2 days from Annual Leave.\"}', '2025-09-04 09:40:02'),
(90, 109, 5, '2025-09-04 12:42:13', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":4,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 4 days from Annual Leave.\"}', '2025-09-04 09:42:13'),
(91, 110, 5, '2025-09-04 12:55:07', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 09:55:07'),
(92, 111, 121, '2025-09-04 12:56:12', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 09:56:12'),
(93, 112, 5, '2025-09-04 12:56:56', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":2,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 2 days from Annual Leave.\"}', '2025-09-04 09:56:56'),
(94, 113, 5, '2025-09-04 12:57:58', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 09:57:58'),
(95, 114, 118, '2025-09-04 12:58:52', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 09:58:52'),
(96, 115, 121, '2025-09-04 13:00:56', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 10:00:56'),
(97, 116, 5, '2025-09-04 13:01:35', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 10:01:35'),
(98, 117, 118, '2025-09-04 13:02:31', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 10:02:31'),
(99, 118, 5, '2025-09-04 13:05:36', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":1,\"unpaid_days\":0,\"warnings\":\"Primary balance insufficient. 0 days from Short Leave, 1 days from Annual Leave.\"}', '2025-09-04 10:05:36'),
(100, 119, 5, '2025-09-04 14:21:04', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":17,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 11:21:04'),
(101, 120, 135, '2025-09-04 14:24:29', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 18 days will be unpaid.\"}', '2025-09-04 11:24:29'),
(102, 121, 112, '2025-09-04 14:25:44', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 18 days will be unpaid.\"}', '2025-09-04 11:25:44'),
(103, 122, 5, '2025-09-04 14:26:17', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":18,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 11:26:17'),
(104, 123, 121, '2025-09-04 14:27:32', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":22,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 11:27:32'),
(105, 124, 121, '2025-09-04 14:27:35', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":22,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 11:27:35'),
(106, 125, 118, '2025-09-04 14:29:33', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":18,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 11:29:33'),
(107, 126, 135, '2025-09-04 14:47:54', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"Insufficient leave balance. 0 days from Short Leave, 0 days from Annual Leave, 1 days will be unpaid.\"}', '2025-09-04 11:47:54'),
(108, 127, 135, '2025-09-04 14:49:00', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"Insufficient leave balance.  days from Short Leave, 0 days from Annual Leave, 1 days will be unpaid.\"}', '2025-09-04 11:49:00'),
(109, 128, 135, '2025-09-04 14:51:18', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"Insufficient leave balance.  days from Short Leave, 0 days from Annual Leave, 1 days will be unpaid.\"}', '2025-09-04 11:51:18'),
(110, 129, 135, '2025-09-04 15:09:01', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 1 days to your annual leave upon approval.\"}', '2025-09-04 12:09:01'),
(111, 130, 135, '2025-09-04 15:17:11', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"Insufficient leave balance.  days from Annual Leave, 0 days from Annual Leave, 18 days will be unpaid.\"}', '2025-09-04 12:17:11'),
(112, 131, 135, '2025-09-04 15:18:28', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":23,\"warnings\":\"No available balance. All 23 days will be unpaid.\"}', '2025-09-04 12:18:28'),
(113, 132, 135, '2025-09-04 15:26:09', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":23,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Maternity Leave balance.\"}', '2025-09-04 12:26:09'),
(114, 133, 135, '2025-09-04 15:26:20', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":23,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Maternity Leave balance.\"}', '2025-09-04 12:26:20'),
(115, 134, 135, '2025-09-04 15:30:31', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":23,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Maternity Leave balance.\"}', '2025-09-04 12:30:31'),
(116, 135, 135, '2025-09-04 15:46:53', 'deduction', '{\"primary_leave_type\":3,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":23,\"warnings\":\"No available balance. All 23 days will be unpaid.\"}', '2025-09-04 12:46:53'),
(117, 136, 135, '2025-09-04 15:47:42', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 1 days to your annual leave upon approval.\"}', '2025-09-04 12:47:42'),
(118, 137, 135, '2025-09-04 15:48:21', 'deduction', '{\"primary_leave_type\":8,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"\\u2139\\ufe0f You will be absent for 1 days.\"}', '2025-09-04 12:48:21'),
(119, 138, 135, '2025-09-04 15:51:22', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"Insufficient leave balance.  days from Short Leave, 0 days from Annual Leave, 1 days will be unpaid.\"}', '2025-09-04 12:51:22'),
(120, 139, 135, '2025-09-04 16:23:45', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":null,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"Insufficient leave balance.  days from Short Leave, 0 days from Annual Leave, 1 days will be unpaid.\"}', '2025-09-04 13:23:45'),
(121, 140, 135, '2025-09-04 16:25:35', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"Insufficient leave balance. 0 days from Short Leave, 0 days from Annual Leave, 1 days will be unpaid.\"}', '2025-09-04 13:25:35'),
(122, 141, 135, '2025-09-04 16:28:20', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"Insufficient leave balance. 0 days from Annual Leave, 0 days from Annual Leave, 18 days will be unpaid.\"}', '2025-09-04 13:28:20'),
(123, 142, 135, '2025-09-04 16:32:08', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":4,\"warnings\":\"Insufficient leave balance. 0 days from Short Leave, 0 days from Annual Leave, 4 days will be unpaid.\"}', '2025-09-04 13:32:08'),
(124, 143, 5, '2025-09-04 16:32:54', 'deduction', '{\"primary_leave_type\":8,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"\\u2139\\ufe0f You will be absent for 2 days.\"}', '2025-09-04 13:32:54'),
(125, 144, 5, '2025-09-04 16:34:12', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":24,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 13:34:12'),
(126, 145, 5, '2025-09-04 16:55:14', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":19,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-09-04 13:55:14'),
(127, 146, 135, '2025-09-05 09:45:16', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":17,\"annual_days\":17,\"unpaid_days\":0,\"warnings\":\"17 days from Short Leave (balance may go negative).; Primary balance insufficient. 17 days from Short Leave.\"}', '2025-09-05 06:45:16'),
(128, 147, 135, '2025-09-05 10:23:41', 'deduction', '{\"primary_leave_type\":8,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"\\u2139\\ufe0f You will be absent for 2 days.\"}', '2025-09-05 07:23:41'),
(129, 148, 135, '2025-09-05 10:31:48', 'deduction', '{\"primary_leave_type\":2,\"primary_days\":3,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"3 days from Sick Leave (balance may go negative).\"}', '2025-09-05 07:31:48'),
(130, 149, 118, '2025-10-07 14:23:55', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 22 days to your annual leave upon approval.\"}', '2025-10-07 11:23:55'),
(131, 150, 153, '2025-10-07 14:26:04', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":9,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"9 days from Compassionate Leave (balance may go negative).\"}', '2025-10-07 11:26:04'),
(133, 152, 446, '2025-10-15 09:11:01', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"18 days will be unpaid.\"}', '2025-10-15 06:11:01'),
(134, 153, 392, '2025-10-15 09:18:50', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 06:18:50'),
(137, 156, 446, '2025-10-15 10:16:58', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 07:16:58'),
(138, 157, 392, '2025-10-15 10:18:54', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 07:18:54'),
(139, 158, 400, '2025-10-15 10:20:13', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 07:20:13'),
(140, 159, 502, '2025-10-15 10:21:54', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":12,\"warnings\":\"12 days will be unpaid.\"}', '2025-10-15 07:21:54'),
(141, 160, 451, '2025-10-15 10:25:10', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 07:25:10'),
(142, 161, 392, '2025-10-15 10:49:10', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"18 days will be unpaid.\"}', '2025-10-15 07:49:10'),
(143, 162, 418, '2025-10-15 10:51:13', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"18 days will be unpaid.\"}', '2025-10-15 07:51:13'),
(144, 163, 410, '2025-10-15 11:08:24', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 08:08:24'),
(145, 164, 464, '2025-10-15 11:09:39', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":15,\"warnings\":\"15 days will be unpaid.\"}', '2025-10-15 08:09:39'),
(146, 165, 500, '2025-10-15 11:11:40', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 08:11:40'),
(147, 166, 500, '2025-10-15 11:16:52', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 08:16:52'),
(148, 167, 500, '2025-10-15 11:20:52', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"3 days will be unpaid.\"}', '2025-10-15 08:20:52'),
(149, 168, 428, '2025-10-15 11:23:26', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":5,\"warnings\":\"5 days will be unpaid.\"}', '2025-10-15 08:23:26'),
(150, 169, 446, '2025-10-15 11:31:56', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 08:31:56'),
(151, 170, 428, '2025-10-15 11:32:46', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 08:32:46'),
(152, 171, 410, '2025-10-15 11:35:29', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 08:35:29'),
(153, 172, 410, '2025-10-15 12:11:59', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":6,\"warnings\":\"6 days will be unpaid.\"}', '2025-10-15 09:11:59'),
(154, 173, 410, '2025-10-15 12:13:49', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 09:13:49'),
(155, 174, 410, '2025-10-15 12:15:08', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"1 days will be unpaid.\"}', '2025-10-15 09:15:08'),
(156, 175, 500, '2025-10-15 12:17:05', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"3 days will be unpaid.\"}', '2025-10-15 09:17:05'),
(157, 176, 410, '2025-10-15 12:26:25', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":9,\"warnings\":\"9 days will be unpaid.\"}', '2025-10-15 09:26:25'),
(158, 177, 500, '2025-10-15 12:51:29', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-15 09:51:29'),
(159, 178, 410, '2025-10-15 12:58:01', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 09:58:01'),
(160, 179, 392, '2025-10-15 12:58:57', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 09:58:57'),
(161, 180, 418, '2025-10-15 13:00:24', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"1 days will be unpaid.\"}', '2025-10-15 10:00:24'),
(162, 181, 502, '2025-10-15 13:01:45', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 10:01:45'),
(163, 182, 428, '2025-10-15 13:03:46', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 10:03:46'),
(164, 183, 428, '2025-10-15 13:06:06', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 10:06:06'),
(165, 184, 500, '2025-10-15 14:24:20', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":3,\"warnings\":\"3 days will be unpaid.\"}', '2025-10-15 11:24:20'),
(166, 185, 500, '2025-10-15 14:26:22', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 11:26:22'),
(167, 186, 400, '2025-10-15 14:34:38', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 11:34:38'),
(168, 187, 400, '2025-10-15 14:48:48', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"1 days will be unpaid.\"}', '2025-10-15 11:48:48'),
(169, 188, 400, '2025-10-15 14:51:16', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":2,\"warnings\":\"2 days will be unpaid.\"}', '2025-10-15 11:51:16'),
(170, 189, 400, '2025-10-15 15:07:38', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":8,\"warnings\":\"8 days will be unpaid.\"}', '2025-10-15 12:07:38'),
(171, 190, 400, '2025-10-16 10:55:03', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":1,\"warnings\":\"1 days will be unpaid.\"}', '2025-10-16 07:55:03'),
(172, 191, 400, '2025-10-16 15:59:31', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":16,\"warnings\":\"16 days will be unpaid.\"}', '2025-10-16 12:59:31'),
(173, 192, 446, '2025-10-21 11:04:57', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":18,\"warnings\":\"18 days will be unpaid.\"}', '2025-10-21 08:04:57'),
(174, 193, 446, '2025-10-22 10:23:15', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":15,\"warnings\":\"15 days will be unpaid.\"}', '2025-10-22 07:23:15'),
(175, 194, 392, '2025-10-22 10:28:06', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 4 days to your annual leave upon approval.\"}', '2025-10-22 07:28:06'),
(176, 195, 392, '2025-10-22 11:20:46', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":7,\"warnings\":\"7 days will be unpaid.\"}', '2025-10-22 08:20:46'),
(177, 196, 418, '2025-10-22 11:57:44', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-22 08:57:44'),
(178, 197, 418, '2025-10-22 12:09:01', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-22 09:09:01'),
(179, 198, 434, '2025-10-22 14:18:01', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":17,\"warnings\":\"17 days will be unpaid.\"}', '2025-10-22 11:18:01'),
(180, 199, 446, '2025-10-22 15:46:25', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":30,\"warnings\":\"30 days will be unpaid.\"}', '2025-10-22 12:46:25'),
(181, 200, 392, '2025-10-23 08:39:52', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 05:39:52'),
(182, 201, 446, '2025-10-23 10:24:58', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":21,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 07:24:58'),
(183, 202, 392, '2025-10-23 10:31:43', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Unlimited leave type\\u2014no balance deduction required.\"}', '2025-10-23 07:31:43'),
(184, 203, 392, '2025-10-23 10:33:42', 'deduction', '{\"primary_leave_type\":7,\"primary_days\":7,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Compassionate Leave balance.\"}', '2025-10-23 07:33:42'),
(185, 204, 392, '2025-10-23 10:34:57', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":21,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 07:34:57'),
(186, 205, 392, '2025-10-23 11:17:04', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 08:17:04'),
(187, 206, 392, '2025-10-23 11:17:11', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 08:17:11'),
(188, 207, 392, '2025-10-23 11:57:43', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":16,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 08:57:43'),
(189, 208, 418, '2025-10-23 11:58:55', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":16,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 08:58:55'),
(190, 209, 392, '2025-10-23 12:17:23', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":17,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 09:17:23'),
(191, 210, 483, '2025-10-23 12:45:07', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 09:45:07'),
(192, 211, 392, '2025-10-23 12:50:08', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 09:50:08'),
(193, 212, 392, '2025-10-23 12:56:16', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 09:56:16'),
(194, 213, 392, '2025-10-23 13:03:18', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 10:03:18'),
(195, 214, 392, '2025-10-23 14:06:48', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":15,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 11:06:48'),
(196, 215, 392, '2025-10-23 14:18:06', 'deduction', '{\"primary_leave_type\":9,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"\\u2705 This will add 4 days to your annual leave upon approval.\"}', '2025-10-23 11:18:06'),
(197, 216, 392, '2025-10-23 14:39:05', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":20,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 11:39:05'),
(198, 217, 392, '2025-10-23 15:00:51', 'deduction', '{\"primary_leave_type\":6,\"primary_days\":0,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Unlimited leave type\\u2014no balance deduction required.\"}', '2025-10-23 12:00:51'),
(199, 218, 483, '2025-10-23 16:20:27', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":16,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 13:20:27'),
(200, 219, 418, '2025-10-23 16:21:19', 'deduction', '{\"primary_leave_type\":1,\"primary_days\":18,\"annual_days\":0,\"unpaid_days\":0,\"warnings\":\"Will be deducted from Annual Leave balance.\"}', '2025-10-23 13:21:19');

-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `leave_types` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `counts_weekends` tinyint(1) DEFAULT 0,
  `deducted_from_annual` tinyint(1) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_types`
--

INSERT INTO `leave_types` (`id`, `name`, `description`, `counts_weekends`, `deducted_from_annual`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Annual Leave', 'Regular annual vacation leave', 0, 1, 1, '2025-07-21 07:55:35', '2025-07-21 07:55:35'),
(2, 'Sick Leave', 'Medical leave for illness', 0, 0, 1, '2025-07-21 07:55:35', '2025-07-21 07:55:35'),
(3, 'Maternity Leave', 'Maternity leave for female employees', 1, 0, 1, '2025-07-21 07:55:35', '2025-07-28 04:32:29'),
(4, 'Paternity Leave', 'Paternity leave for male employees', 0, 0, 1, '2025-07-21 07:55:35', '2025-07-21 07:55:35'),
(5, 'Study Leave', 'Educational or training leave', 0, 1, 1, '2025-07-21 07:55:35', '2025-07-28 04:32:29'),
(6, 'Short Leave', 'Short duration leave (half day, few hours)', 0, 1, 1, '2025-07-21 07:55:35', '2025-07-21 07:55:35'),
(7, 'Compassionate Leave', 'Emergency or bereavement leave', 0, 0, 1, '2025-07-21 07:55:35', '2025-07-28 04:32:29'),
(8, 'leave of absence', 'selected to perform official duties', 0, 0, 1, '2025-09-03 09:30:20', '2025-09-03 09:30:20'),
(9, 'claim a day', 'Claim unused days', 0, 1, 1, '2025-09-03 09:31:48', '2026-06-03 11:56:33');

-- --------------------------------------------------------

--
-- Table structure for table `loan_payments`
--

CREATE TABLE `loan_payments` (
  `payment_id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `payment_amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `balance_after_payment` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT 'payroll_deduction',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `loan_payments`
--

INSERT INTO `loan_payments` (`payment_id`, `loan_id`, `payment_amount`, `payment_date`, `balance_after_payment`, `payment_method`, `notes`, `created_at`) VALUES
(1, 2, 10000.00, '2025-12-31', 0.00, 'payroll_deduction', NULL, '2025-10-06 11:08:30'),
(2, 3, 1300.00, '2025-12-31', 118700.00, 'payroll_deduction', NULL, '2025-10-06 11:09:58'),
(3, 3, 1300.00, '2025-12-31', 117400.00, 'payroll_deduction', NULL, '2025-10-06 12:00:49'),
(4, 3, 1300.00, '2025-12-31', 116100.00, 'payroll_deduction', NULL, '2025-10-06 12:44:10'),
(5, 3, 1300.00, '2025-12-31', 114800.00, 'payroll_deduction', NULL, '2025-10-07 06:25:03'),
(6, 3, 1300.00, '2025-12-31', 113500.00, 'payroll_deduction', NULL, '2025-10-07 06:27:29'),
(7, 3, 1300.00, '2025-12-31', 112200.00, 'payroll_deduction', NULL, '2025-10-07 07:11:45'),
(8, 3, 1300.00, '2025-10-07', 110900.00, 'payroll_deduction', NULL, '2025-10-07 07:11:45'),
(9, 3, 1300.00, '2025-12-31', 109600.00, 'payroll_deduction', NULL, '2025-10-07 07:13:42'),
(10, 3, 1300.00, '2025-10-07', 108300.00, 'payroll_deduction', NULL, '2025-10-07 07:13:42'),
(11, 4, 10000.00, '2025-12-31', 0.00, 'payroll_deduction', NULL, '2025-10-07 07:13:43'),
(12, 4, 10000.00, '2025-10-07', 0.00, 'payroll_deduction', NULL, '2025-10-07 07:13:43'),
(13, 3, 1300.00, '2025-12-31', 107000.00, 'payroll_deduction', NULL, '2025-10-07 07:15:50'),
(14, 3, 1300.00, '2025-10-07', 105700.00, 'payroll_deduction', NULL, '2025-10-07 07:15:50'),
(15, 5, 30000.00, '2025-12-31', 70000.00, 'payroll_deduction', NULL, '2025-10-07 07:15:51'),
(16, 5, 30000.00, '2025-10-07', 40000.00, 'payroll_deduction', NULL, '2025-10-07 07:15:51'),
(17, 3, 1300.00, '2026-01-31', 104400.00, 'payroll_deduction', NULL, '2025-10-07 07:18:49'),
(18, 3, 1300.00, '2025-10-07', 103100.00, 'payroll_deduction', NULL, '2025-10-07 07:18:49'),
(19, 5, 30000.00, '2026-01-31', 10000.00, 'payroll_deduction', NULL, '2025-10-07 07:18:50'),
(20, 5, 30000.00, '2025-10-07', 0.00, 'payroll_deduction', NULL, '2025-10-07 07:18:50');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` enum('info','success','warning','error') DEFAULT 'info',
  `is_read` tinyint(1) DEFAULT 0,
  `related_type` varchar(50) DEFAULT NULL,
  `related_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `objectives`
--

CREATE TABLE `objectives` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `strategic_plan_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `objectives`
--

INSERT INTO `objectives` (`id`, `strategic_plan_id`, `name`, `start_date`, `end_date`, `created_at`, `updated_at`) VALUES
(1, 3, 'Customer satisfaction ', '2025-07-01', '2026-06-30', '2025-09-05 11:18:12', '2025-09-08 09:29:10'),
(2, 2, 'improve  Communicati  on and  Transparency', '2025-06-01', '2025-12-31', '2025-09-08 11:18:01', '2025-09-08 11:18:01'),
(3, 2, 'Review the  company’s corporate  communicati  ons policy', '2025-09-01', '2025-12-31', '2025-09-08 11:19:24', '2025-09-08 11:19:24');

-- --------------------------------------------------------

--
-- Table structure for table `payroll`
--

CREATE TABLE `payroll` (
  `payroll_id` int(11) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `employment_type` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `salary` decimal(12,2) DEFAULT NULL,
  `bank_account` varchar(50) DEFAULT NULL,
  `bank_id` int(11) DEFAULT NULL,
  `SHA_number` varchar(50) DEFAULT NULL,
  `KRA_pin` varchar(20) DEFAULT NULL,
  `NSSF` varchar(50) DEFAULT NULL,
  `Gross_pay` decimal(10,2) DEFAULT NULL,
  `net_pay` decimal(10,2) DEFAULT NULL,
  `job_group` varchar(10) DEFAULT NULL,
  `total_allowances` float NOT NULL,
  `total_deductions` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payroll`
--

INSERT INTO `payroll` (`payroll_id`, `emp_id`, `employment_type`, `status`, `salary`, `bank_account`, `bank_id`, `SHA_number`, `KRA_pin`, `NSSF`, `Gross_pay`, `net_pay`, `job_group`, `total_allowances`, `total_deductions`) VALUES
(192, 336, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(193, 337, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(194, 338, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(195, 339, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(196, 340, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(197, 341, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(198, 342, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(199, 343, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(200, 344, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(201, 345, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(202, 346, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(203, 347, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(204, 348, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(205, 349, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(206, 350, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(207, 351, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(208, 352, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(209, 353, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(210, 354, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(211, 355, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(212, 356, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(213, 357, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(214, 358, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(215, 359, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(216, 360, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(217, 361, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(218, 362, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(219, 363, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(220, 364, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(221, 365, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(222, 366, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(223, 367, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(224, 368, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(225, 369, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(226, 370, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(227, 371, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(228, 372, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(229, 373, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(230, 374, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(231, 375, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(232, 376, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(233, 377, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(234, 378, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(235, 379, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(236, 380, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(237, 381, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(238, 382, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(239, 383, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(240, 384, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(241, 385, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(242, 386, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(243, 387, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(244, 388, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(245, 389, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(246, 390, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(247, 391, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(248, 392, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(249, 393, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(250, 394, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(251, 395, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(252, 396, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(253, 397, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(254, 398, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(255, 399, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(256, 400, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(257, 401, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(258, 402, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(259, 403, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(260, 404, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(261, 405, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(262, 406, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(263, 407, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(264, 408, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(265, 409, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(266, 410, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(267, 411, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(268, 412, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(269, 413, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(270, 414, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(271, 415, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(272, 416, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(273, 417, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(274, 418, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(275, 419, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(276, 420, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(277, 421, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(278, 422, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(279, 423, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(280, 424, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(281, 425, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(282, 426, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(283, 427, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(284, 428, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(285, 429, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(286, 430, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(287, 431, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(288, 432, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(289, 433, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(290, 434, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(291, 435, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(292, 436, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(293, 437, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(294, 438, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(295, 439, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(296, 440, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(297, 441, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(298, 442, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(299, 443, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(300, 444, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(301, 445, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(302, 446, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(303, 447, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(304, 448, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(305, 449, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(306, 450, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(307, 451, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(308, 452, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(309, 453, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(310, 454, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(311, 455, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(312, 456, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(313, 457, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(314, 458, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(315, 459, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(316, 460, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(317, 461, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(318, 462, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(319, 463, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(320, 464, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(321, 465, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(322, 466, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(323, 467, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(324, 468, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(325, 469, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(326, 470, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(327, 471, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(328, 472, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(329, 473, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(330, 474, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(331, 475, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(332, 476, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(333, 477, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(334, 478, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(335, 479, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(336, 480, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(337, 481, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(338, 482, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(339, 483, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(340, 484, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(341, 485, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(342, 486, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(343, 487, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(344, 488, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(345, 489, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(346, 490, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(347, 491, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(348, 492, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(349, 493, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(350, 494, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(351, 495, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(352, 496, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(353, 497, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(354, 498, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(355, 499, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(356, 500, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(357, 501, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(358, 502, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(359, 503, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(360, 504, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(361, 505, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(362, 506, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(363, 507, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(364, 508, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(365, 509, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(366, 510, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(367, 511, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0),
(368, 512, 'permanent', 'active', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '5', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `payroll_periods`
--

CREATE TABLE `payroll_periods` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `period_name` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `pay_date` date NOT NULL,
  `frequency` varchar(20) DEFAULT 'Monthly',
  `status` varchar(20) DEFAULT 'Draft',
  `is_locked` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payroll_periods`
--

INSERT INTO `payroll_periods` (`id`, `period_name`, `start_date`, `end_date`, `pay_date`, `frequency`, `status`, `is_locked`, `created_at`, `updated_at`) VALUES
(1, 'JULY2025', '2025-07-01', '2025-07-31', '2025-07-31', 'Monthly', 'Draft', 1, '2025-08-26 12:33:52', '2025-08-26 13:02:48'),
(2, 'SEPTEMBER2025', '2025-09-01', '2025-10-31', '2025-10-31', 'Monthly', 'Draft', 1, '2025-10-02 12:23:04', '2025-10-07 07:17:46'),
(3, 'OCTOBER ', '2025-10-01', '2025-10-31', '2025-10-31', 'Bi-weekly', 'Draft', 1, '2025-10-02 13:22:26', '2025-10-02 13:23:25'),
(4, 'NOVEMBER 2025', '2025-11-01', '2025-10-31', '2025-11-30', 'Monthly', 'Draft', 1, '2025-10-02 13:42:59', '2025-10-03 12:21:26'),
(5, 'DECEMBER 2025', '2025-12-01', '2025-12-31', '2025-12-31', 'Monthly', 'Draft', 1, '2025-10-06 08:18:50', '2025-10-07 07:17:40'),
(6, 'JANUARY 2026', '2026-01-01', '2026-01-31', '2026-01-31', 'Monthly', 'Draft', 0, '2025-10-07 07:17:35', '2025-10-07 07:17:35'),
(7, 'FEBRUARY 2026', '2026-02-01', '2026-02-28', '2026-02-28', 'Monthly', 'Draft', 0, '2025-10-07 07:19:49', '2025-10-07 07:19:49');

-- --------------------------------------------------------

--
-- Table structure for table `payroll_records`
--

CREATE TABLE `payroll_records` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `pay_period_id` bigint(20) UNSIGNED NOT NULL,
  `base_salary` decimal(10,2) NOT NULL,
  `gross_pay` decimal(10,2) NOT NULL,
  `total_allowances` decimal(10,2) DEFAULT 0.00,
  `total_deductions` decimal(10,2) DEFAULT 0.00,
  `net_pay` decimal(10,2) NOT NULL,
  `allowances_breakdown` text DEFAULT NULL,
  `deductions_breakdown` text DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `performance_indicators`
--

CREATE TABLE `performance_indicators` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `max_score` int(11) NOT NULL DEFAULT 5,
  `role` varchar(50) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `section_id` int(11) DEFAULT NULL,
  `subsection_id` int(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `performance_indicators`
--

INSERT INTO `performance_indicators` (`id`, `name`, `description`, `max_score`, `role`, `department_id`, `is_active`, `created_at`, `updated_at`, `section_id`, `subsection_id`) VALUES
(1, 'Quality of Work', 'Accuracy, thoroughness, and attention to detail in work output', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-08-12 19:49:48', NULL, 0),
(2, 'Productivity', 'Efficiency in completing tasks and meeting deadlines', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-08-11 11:29:14', NULL, 0),
(3, 'Communication Skills', 'Effectiveness in verbal and written communication', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-08-15 08:38:43', NULL, 0),
(4, 'Teamwork & Collaboration', 'Ability to work effectively with colleagues and contribute to team goals', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-08-11 11:29:14', NULL, 0),
(5, 'Initiative & Innovation', 'Proactive approach and creative problem-solving abilities', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-08-11 11:29:14', NULL, 0),
(6, 'Professional Development', 'Commitment to learning and skill improvement', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-08-11 11:29:14', NULL, 0),
(7, 'Attendance & Punctuality', 'Reliability in attendance and meeting scheduled commitments', 5, NULL, NULL, 1, '2025-08-11 11:29:14', '2025-10-14 10:55:01', NULL, 0),
(9, 'Customer Service Excellence', 'Quality of customer interaction and problem resolution', 5, NULL, NULL, 1, '2025-08-15 07:47:04', '2025-08-15 07:47:04', NULL, 0),
(10, 'Technical Competency', 'Mastery of job-related technical skills and knowledge', 5, NULL, NULL, 1, '2025-08-15 07:47:04', '2025-08-15 07:47:04', NULL, 0),
(11, 'Leadership Potential', 'Demonstration of leadership qualities and mentoring abilities', 5, NULL, NULL, 1, '2025-08-15 07:47:04', '2025-08-15 07:47:04', NULL, 0),
(12, 'Adaptability', 'Flexibility in handling change and new challenges', 5, NULL, NULL, 1, '2025-08-15 07:47:04', '2025-08-15 07:47:04', NULL, 0),
(13, 'Workplan', 'Ensure departmnta goals are aligned with the organizational goals', 5, 'officer', 2, 1, '2025-08-15 08:25:00', '2025-08-21 12:06:42', 4, 0),
(14, 'compliance', 'Regulatory:Ensure 10% compliance with local and legistlative bodies', 5, 'hr_manager', 2, 1, '2025-08-15 08:25:56', '2025-08-18 20:42:31', 4, 0),
(15, 'strategies formulated', 'Enhanced employer branding:Formulate strategies on enhancing employers brand', 5, NULL, NULL, 1, '2025-08-15 08:28:27', '2025-08-15 08:28:27', 1, 0),
(16, 'Workplans', 'Ensure departmentalk goals are aligned with the organizatinal goals', 5, 'dept_head', 2, 1, '2025-08-15 09:41:22', '2025-08-15 09:41:22', NULL, 0),
(17, 'Field Reports Timeliness', 'Submit reports within set deadlines', 5, 'officer', 2, 1, '2025-08-22 12:04:31', '2025-08-22 12:04:31', 4, 0),
(18, 'Client Satisfaction', 'Handle client feedback and ensure satisfaction', 5, 'officer', 2, 1, '2025-08-22 12:04:31', '2025-08-22 12:04:31', 4, 0),
(19, 'Team Oversight', 'Manage and oversee team performance', 5, 'section_head', 2, 1, '2025-08-22 12:05:01', '2025-08-22 12:05:01', 4, 0),
(20, 'Section Planning', 'Develop and review sectional workplans', 5, 'section_head', 2, 1, '2025-08-22 12:05:01', '2025-08-22 12:05:01', 4, 0),
(21, 'Department Performance Review', 'Monitor department KPIs', 5, 'dept_head', 2, 1, '2025-08-22 12:05:21', '2025-08-22 12:05:21', NULL, 0),
(22, 'Strategic Planning', 'Lead the creation of strategic goals', 5, 'dept_head', 2, 1, '2025-08-22 12:05:21', '2025-08-22 12:05:21', NULL, 0),
(23, 'Recruitment Efficiency', 'Complete hiring processes timely', 5, 'hr_manager', 2, 1, '2025-08-22 12:05:45', '2025-08-22 12:05:45', NULL, 0),
(24, 'Training Programs', 'Implement employee development programs', 5, 'hr_manager', 2, 1, '2025-08-22 12:05:45', '2025-08-22 12:05:45', NULL, 0),
(25, 'Task Completion', 'Complete assigned tasks within deadlines', 5, 'officer', 2, 1, '2025-08-22 12:06:28', '2025-08-22 12:06:28', 4, 0),
(26, 'Field Accuracy', 'Ensure accuracy in field data collection', 5, 'officer', 2, 1, '2025-08-22 12:06:28', '2025-08-22 12:06:28', 4, 0),
(27, 'Community Engagement', 'Maintain positive relations with local communities', 5, 'officer', 2, 1, '2025-08-22 12:06:28', '2025-08-22 12:06:28', 4, 0),
(28, 'Incident Reporting', 'Timely reporting of issues and incidents', 5, 'officer', 2, 1, '2025-08-22 12:06:28', '2025-08-22 12:06:28', 4, 0),
(29, 'Resource Management', 'Efficient use of resources during field operations', 5, 'officer', 2, 1, '2025-08-22 12:06:28', '2025-08-22 12:06:28', 4, 0),
(30, 'Staff Supervision', 'Ensure proper supervision of team members', 5, 'section_head', 2, 1, '2025-08-22 12:06:47', '2025-08-22 12:06:47', 4, 0),
(31, 'Section Planning', 'Create and manage sectional plans effectively', 5, 'section_head', 2, 1, '2025-08-22 12:06:47', '2025-08-22 12:06:47', 4, 0),
(32, 'Budget Oversight', 'Track and manage section budgets', 5, 'section_head', 2, 1, '2025-08-22 12:06:47', '2025-08-22 12:06:47', 4, 0),
(33, 'Compliance Checks', 'Ensure policies and procedures are followed', 5, 'section_head', 2, 1, '2025-08-22 12:06:47', '2025-08-22 12:06:47', 4, 0),
(34, 'Quarterly Reports', 'Submit accurate and timely section reports', 5, 'section_head', 2, 1, '2025-08-22 12:06:47', '2025-08-22 12:06:47', 4, 0),
(35, 'Department Planning', 'Develop annual and quarterly department plans', 5, 'dept_head', 2, 1, '2025-08-22 12:07:08', '2025-08-22 12:07:08', NULL, 0),
(36, 'Policy Implementation', 'Ensure department policies are followed', 5, 'dept_head', 2, 1, '2025-08-22 12:07:08', '2025-08-22 12:07:08', NULL, 0),
(37, 'Performance Reviews', 'Oversee performance evaluation across department', 5, 'dept_head', 2, 1, '2025-08-22 12:07:08', '2025-08-22 12:07:08', NULL, 0),
(38, 'Cross-Team Coordination', 'Coordinate efforts across different teams', 5, 'dept_head', 2, 1, '2025-08-22 12:07:08', '2025-08-22 12:07:08', NULL, 0),
(39, 'Budget Planning', 'Prepare and review department budgets', 5, 'dept_head', 2, 1, '2025-08-22 12:07:08', '2025-08-22 12:07:08', NULL, 0),
(40, 'Staff Onboarding', 'Manage effective onboarding processes', 5, 'hr_manager', 2, 1, '2025-08-22 12:07:32', '2025-08-22 12:07:32', NULL, 0),
(41, 'Performance Metrics', 'Define KPIs for different roles', 5, 'hr_manager', 2, 1, '2025-08-22 12:07:32', '2025-08-22 12:07:32', NULL, 0),
(42, 'Training & Development', 'Organize staff training sessions', 5, 'hr_manager', 2, 1, '2025-08-22 12:07:32', '2025-08-22 12:07:32', NULL, 0),
(43, 'Employee Satisfaction', 'Measure and improve staff satisfaction', 5, 'hr_manager', 2, 1, '2025-08-22 12:07:32', '2025-08-22 12:07:32', NULL, 0),
(44, 'Leave Management', 'Track leave applications and approvals', 5, 'hr_manager', 2, 1, '2025-08-22 12:07:32', '2025-08-22 12:07:32', NULL, 0),
(45, 'Geri Ineegi', 'subsection_id gfffggihihougdtduyuu', 5, 'officer', 2, 1, '2025-10-21 12:07:24', '2025-10-21 12:07:24', 12, 1),
(46, 'Geri', 'inegi', 5, 'officer', 2, 1, '2025-10-21 14:00:51', '2025-10-21 14:00:51', 4, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `salary_bands`
--

CREATE TABLE `salary_bands` (
  `scale_id` varchar(10) NOT NULL,
  `min_salary` decimal(10,2) DEFAULT NULL,
  `max_salary` decimal(10,2) DEFAULT NULL,
  `house_allowance` decimal(10,2) DEFAULT NULL,
  `commuter_allowance` decimal(10,2) DEFAULT NULL,
  `leave_allowance` decimal(10,2) DEFAULT NULL,
  `Dirty_allowance` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `salary_bands`
--

INSERT INTO `salary_bands` (`scale_id`, `min_salary`, `max_salary`, `house_allowance`, `commuter_allowance`, `leave_allowance`, `Dirty_allowance`) VALUES
('1', 17895.00, 35608.00, 8518.00, 4050.00, NULL, NULL),
('10', 307718.00, 637867.00, 58080.00, 0.00, NULL, NULL),
('2', 20844.00, 39673.00, 10261.00, 4050.00, NULL, NULL),
('3', 21787.00, 41468.00, 10842.00, 5200.00, NULL, NULL),
('3A', 22987.00, 43752.00, 10842.00, 5200.00, NULL, NULL),
('3B', 24187.00, 48128.00, 10842.00, 5200.00, NULL, NULL),
('3C', 27412.00, 58174.00, 10842.00, 5200.00, NULL, NULL),
('4', 27509.00, 62119.00, 13552.00, 5200.00, NULL, NULL),
('5', 31387.00, 64664.00, 13552.00, 6500.00, NULL, 2000.00),
('6', 38182.00, 74132.00, 19360.00, 6500.00, NULL, NULL),
('7', 58097.00, 103819.00, 27104.00, 8000.00, NULL, NULL),
('8', 80413.00, 160009.00, 32912.00, 11000.00, NULL, NULL),
('9', 118178.00, 397383.00, 38720.00, 20000.00, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`id`, `name`, `description`, `department_id`, `created_at`, `updated_at`) VALUES
(1, 'Human Resources', 'Employee management and policies', 1, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(2, 'Finance', 'Financial planning and accounting', 1, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(3, 'Sales', 'Direct sales operations', 2, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(4, 'Marketing', 'Brand promotion and advertising', 2, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(5, 'Customer Service', 'Customer support and relations', 2, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(6, 'Software Development', 'Application and system development', 3, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(7, 'IT Support', 'Technical support and maintenance', 3, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(8, 'Network Operations', 'Network infrastructure management', 3, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(9, 'Legal Affairs', 'Legal compliance and contracts', 4, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(10, 'Public Relations', 'Media and public communications', 4, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(11, 'Water Supply', 'Water distribution and supply management', 5, '2025-07-19 06:04:13', '2025-07-19 06:04:13'),
(12, 'Revenue', 'revenue and billing', 2, '2025-10-14 09:28:48', '2025-10-14 09:28:48'),
(13, 'M and E', 'Monitoring and evaluation', 1, '2025-10-14 09:54:54', '2025-10-14 09:55:13');

-- --------------------------------------------------------

--
-- Table structure for table `security_logs`
--

CREATE TABLE `security_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `event_type` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `security_logs`
--

INSERT INTO `security_logs` (`id`, `user_id`, `event_type`, `ip_address`, `user_agent`, `timestamp`, `details`) VALUES
(1, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 12:51:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(2, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 13:43:40', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo2008@gmail.com\"}'),
(3, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 13:43:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(4, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 13:45:55', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(5, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 13:46:02', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(6, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 13:46:04', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(7, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 13:46:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(8, 258, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 13:47:10', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?action=view&id=512\",\"email\":\"\"}'),
(9, NULL, 'login_failed', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 13:47:35', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philo2008@gmail.com\"}'),
(10, NULL, 'login_failed', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 13:47:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philo2008@gmail.com\"}'),
(11, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 13:48:09', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(12, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 13:48:40', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(13, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:27:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(14, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:28:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(15, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:29:18', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(16, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:29:21', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(17, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:29:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(18, 312, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:29:59', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(19, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:30:11', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(20, 312, 'session_token_mismatch', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:30:14', '{\"script\":\"\\/HRS\\/HRS\\/dashboard.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/departments.php\"}'),
(21, 312, 'session_token_mismatch', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:30:43', '{\"script\":\"\\/HRS\\/HRS\\/dashboard.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\"}'),
(22, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 14:31:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(23, NULL, 'login_failed', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:39:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(24, NULL, 'csrf_validation_failed', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:40:04', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(25, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:40:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(26, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 14:56:09', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?action=view&id=512\",\"email\":\"\"}'),
(27, 312, 'session_token_mismatch', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-13 14:56:17', '{\"script\":\"\\/HRS\\/HRS\\/dashboard.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\"}'),
(28, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 14:57:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(29, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 15:01:13', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(30, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:07:31', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(31, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:07:46', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(32, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:09:11', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(33, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 15:20:23', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(34, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:24:41', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(35, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:24:46', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(36, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:24:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(37, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 15:25:59', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(38, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:37:55', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(39, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:38:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(40, 312, 'session_token_mismatch', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 15:38:33', '{\"script\":\"\\/HRS\\/HRS\\/dashboard.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\"}'),
(41, 312, 'session_token_mismatch', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:38:46', '{\"script\":\"\\/HRS\\/HRS\\/dashboard.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\"}'),
(42, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:41:35', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(43, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:44:22', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(44, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:44:26', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(45, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 15:53:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(46, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 16:28:14', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/strategic_plan.php?tab=goals\",\"email\":\"\"}'),
(47, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 16:45:05', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(48, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 16:45:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(49, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 16:47:51', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(50, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-13 16:48:00', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(51, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:49:52', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(52, 312, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:49:52', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(53, 312, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:50:39', '{\"consent_id\": 1, \"full_name\": \"PHILOMENA WANJIRU\", \"consent_date\": \"2025-10-13 16:50:39\"}'),
(54, 312, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:50:39', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"PHILOMENA WANJIRU\",\"national_id_hash\":\"e2c9d34842499b05e6d0589e0be15047b1f70e03ad06c748128aebeb1b9a609c\"}'),
(55, 312, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:50:39', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(56, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:50:43', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(57, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:50:53', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(58, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:50:53', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(59, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:05', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(60, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:18', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(61, 258, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:18', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(62, 258, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:53', '{\"consent_id\": 2, \"full_name\": \"Stephen Mwangi\", \"consent_date\": \"2025-10-13 16:51:53\"}'),
(63, 258, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:53', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Stephen Mwangi\",\"national_id_hash\":\"a50803e3b3712e2785df7e8a6ec8670521f5d245b62509559d58f59bb60c04c0\"}'),
(64, 258, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:53', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(65, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:51:56', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(66, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:52:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(67, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:52:04', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(68, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 16:52:14', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(69, NULL, 'csrf_validation_failed', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:10:51', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(70, 312, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:10:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(71, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:10:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(72, 312, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:15:49', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=&department=&type=managing_director&status=\",\"email\":\"\"}'),
(73, NULL, 'login_failed', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:15:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"Kimahmah@gmail.com\"}'),
(74, 366, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:16:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"Kimahmah@gmail.com\"}'),
(75, 366, 'consent_required_redirect', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:16:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"Kimahmah@gmail.com\"}'),
(76, 366, 'consent_record_created', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:16:48', '{\"consent_id\": 3, \"full_name\": \"NG\'ANG\'A Daniel\", \"consent_date\": \"2025-10-14 10:16:48\"}'),
(77, 366, 'consent_provided', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:16:49', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"NG\'ANG\'A Daniel\",\"national_id_hash\":\"0ed8a96a5cca02fb26a01d86676c4b168c763a072fcb0acd928ae1fa5aabdd6b\"}'),
(78, 366, 'login_success_after_consent', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:16:49', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(79, 312, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:33:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo2008@gmail.com\"}'),
(80, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 10:33:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo2008@gmail.com\"}'),
(81, 312, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 11:38:09', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/departments.php\",\"email\":\"\"}'),
(82, 258, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 11:38:41', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(83, 258, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 11:38:41', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(84, 258, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:05:39', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/personal_profile.php\",\"email\":\"\"}'),
(85, 312, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:05:43', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(86, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:05:43', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(87, 312, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:07:18', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/personal_profile.php\",\"email\":\"\"}'),
(88, 258, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:07:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(89, 258, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:07:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(90, 258, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:08:01', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/completed_appraisals.php\",\"email\":\"\"}'),
(91, 312, 'login_credentials_validated', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:09:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(92, 312, 'login_success', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 12:09:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(93, 312, 'logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 13:56:23', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/personal_profile.php?view_employee=509\",\"email\":\"\"}'),
(94, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:58:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(95, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:58:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(96, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:58:28', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(97, 375, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:58:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mukuriasamuel478@gmail.com\"}'),
(98, 375, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:58:40', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mukuriasamuel478@gmail.com\"}'),
(99, 375, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:59:24', '{\"consent_id\": 4, \"full_name\": \"SAMUEL MUKURIA\", \"consent_date\": \"2025-10-14 13:59:24\"}'),
(100, 375, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:59:24', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"SAMUEL MUKURIA\",\"national_id_hash\":\"066ff65e1bc315c66ccfb50430024ff18fd15dd42bdb0eb19205266ba2da414c\"}'),
(101, 375, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 13:59:24', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(102, 375, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:00:36', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(103, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:00:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(104, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:00:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(105, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:01:40', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/personal_profile.php?view_employee=461\",\"email\":\"\"}'),
(106, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:02:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(107, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:02:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(108, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:02:10', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(109, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:03:12', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(110, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:03:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(111, 327, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:03:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(112, 327, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:03:41', '{\"consent_id\": 5, \"full_name\": \"Cecilia Njoki\", \"consent_date\": \"2025-10-14 14:03:41\"}'),
(113, 327, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:03:41', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Cecilia Njoki\",\"national_id_hash\":\"066ff65e1bc315c66ccfb50430024ff18fd15dd42bdb0eb19205266ba2da414c\"}'),
(114, 327, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:03:41', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(115, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:17:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(116, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:17:11', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(117, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:17:11', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(118, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:26:35', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?action=edit&id=512\",\"email\":\"\"}'),
(119, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:27:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(120, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:27:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(121, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:28:18', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=kabii&department=&type=&status=\",\"email\":\"\"}'),
(122, 258, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:28:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(123, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:28:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(124, 258, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:28:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mwangikabii@gmail.com\"}'),
(125, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:28:45', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mwangikabii@gmail.com\"}'),
(126, 312, 'login_blocked_employee_status', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:28:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(127, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:04', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(128, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:04', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(129, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:45', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php\",\"email\":\"\"}'),
(130, 327, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:52', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(131, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:53', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(132, 327, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(133, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:29:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(134, 327, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(135, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(136, 327, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(137, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(138, 327, 'login_attempt_inactive_employee', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(139, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(140, NULL, 'rate_limit_exceeded', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"njokicecilia@gmail.com\"}'),
(141, 312, 'login_blocked_employee_status', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(142, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(143, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 14:30:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(144, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 15:17:43', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(145, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 15:17:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(146, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-14 15:40:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}');
INSERT INTO `security_logs` (`id`, `user_id`, `event_type`, `ip_address`, `user_agent`, `timestamp`, `details`) VALUES
(147, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 15:41:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(148, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 15:41:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(149, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:28:15', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/profile.php\",\"email\":\"\"}'),
(150, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:28:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(151, 327, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:28:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(152, 327, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:44:50', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(153, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:44:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(154, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:44:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(155, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:58:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo2008@gmail.com\"}'),
(156, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 16:58:10', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo2008@gmail.com\"}'),
(157, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 17:02:21', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo2008@gmail.com\"}'),
(158, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 17:02:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(159, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 17:02:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(160, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 08:59:01', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(161, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 08:59:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(162, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:13:45', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(163, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:15:54', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(164, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:15:54', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(165, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:17:39', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(166, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:18:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(167, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:18:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(168, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:20:33', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(169, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:21:26', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(170, 327, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:21:26', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(171, 327, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:22:05', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(172, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:22:21', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(173, 284, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:22:21', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(174, 284, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:22:33', '{\"consent_id\": 6, \"full_name\": \"kangara Josephine\", \"consent_date\": \"2025-10-15 09:22:33\"}'),
(175, 284, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:22:33', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"kangara Josephine\",\"national_id_hash\":\"972dcafa6fb4c2c88bce752fca4ab18c6bd88599330a4ad9813915b05bfbe76d\"}'),
(176, 284, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:22:33', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(177, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:23:10', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(178, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:24:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(179, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 09:24:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(180, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:17:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(181, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:17:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(182, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:17:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(183, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:18:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(184, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:18:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(185, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:49:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(186, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:49:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(187, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:50:00', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(188, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:50:00', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(189, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:50:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(190, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 10:50:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(191, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:18:18', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php\",\"email\":\"\"}'),
(192, 377, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:18:26', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(193, 377, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:18:26', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(194, 377, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:18:50', '{\"consent_id\": 7, \"full_name\": \"Simon Karanja\", \"consent_date\": \"2025-10-15 11:18:50\"}'),
(195, 377, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:18:50', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Simon Karanja\",\"national_id_hash\":\"55912f950a3c65e22dd2151080371069860f6f90fb757d2d7a69e45543d59c5c\"}'),
(196, 377, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:18:50', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(197, 377, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:20:13', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(198, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:20:20', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(199, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:20:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(200, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:20:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(201, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:39:19', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(202, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:39:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(203, 276, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:39:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(204, 276, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:39:37', '{\"consent_id\": 8, \"full_name\": \"Peter Maina\", \"consent_date\": \"2025-10-15 11:39:37\"}'),
(205, 276, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:39:37', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Peter Maina\",\"national_id_hash\":\"021bbb499511b2dd93ef70cb0e24b772a1680a9337d3709f884ea44590c56f88\"}'),
(206, 276, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:39:37', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(207, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:40:27', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(208, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:40:37', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(209, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:40:38', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(210, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:12:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo2008@gmail.com\"}'),
(211, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:12:19', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(212, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:12:20', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(213, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:27:05', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(214, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:27:10', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(215, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:27:10', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(216, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:27:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(217, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:27:38', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(218, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:27:38', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(219, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:48:27', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(220, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:48:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(221, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:48:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(222, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:02', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=simo&department=&type=&status=\",\"email\":\"\"}'),
(223, 377, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:15', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(224, 377, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:15', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(225, 377, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:38', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(226, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(227, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(228, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:49:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(229, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:50:07', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=daniel&department=&type=&status=\",\"email\":\"\"}'),
(230, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:50:20', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(231, 366, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:50:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"Kimahmahh@gmail.com\"}'),
(232, 366, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:50:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"Kimahmahh@gmail.com\"}'),
(233, 366, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:51:51', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/profile.php\",\"email\":\"\"}'),
(234, 377, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:52:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(235, 377, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:52:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(236, 377, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:57:34', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(237, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:57:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(238, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:57:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(239, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:58:19', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(240, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:58:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(241, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:58:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(242, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:59:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(243, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:59:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(244, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:49:15', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(245, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:49:15', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(246, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:50:34', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=nancy&department=&type=&status=\",\"email\":\"\"}'),
(247, 266, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:50:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"nancymuthoga1@gmail.com\"}'),
(248, 266, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:50:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"nancymuthoga1@gmail.com\"}'),
(249, 266, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:50:51', '{\"consent_id\": 9, \"full_name\": \"Nancy muthoga\", \"consent_date\": \"2025-10-15 14:50:51\"}'),
(250, 266, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:50:52', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Nancy muthoga\",\"national_id_hash\":\"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92\"}'),
(251, 266, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 14:50:52', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(252, 266, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:07:00', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(253, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:07:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(254, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:07:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(255, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:07:55', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(256, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:07:55', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(257, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:10:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(258, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:10:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(259, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:10:51', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(260, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:10:51', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(261, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:12:06', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(262, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:12:22', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(263, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:12:22', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(264, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:13:17', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(265, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:13:17', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(266, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:14:15', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(267, 300, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:14:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(268, 300, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:14:22', '{\"consent_id\": 10, \"full_name\": \"Hezron Njoroge\", \"consent_date\": \"2025-10-15 15:14:22\"}'),
(269, 300, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:14:22', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Hezron Njoroge\",\"national_id_hash\":\"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92\"}'),
(270, 300, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:14:22', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(271, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:25:22', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(272, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:25:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(273, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:51:30', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(274, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:51:30', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(275, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:52:18', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(276, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:52:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(277, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 15:52:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(278, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:19', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 180\"}'),
(279, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:20', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 180, error: Failed to update leave balance. No matching record found.\"}'),
(280, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:29', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: reject_leave, leave_id: 188\"}'),
(281, 312, 'leave_rejected', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:29', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 188\"}'),
(282, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:41', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 179\"}'),
(283, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:42', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 179, error: Failed to update leave balance. No matching record found.\"}'),
(284, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:11:53', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(285, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:12:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(286, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:12:10', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(287, 284, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:12:20', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: section_head_approve, leave_id: 157\"}'),
(288, 284, 'leave_approved_section_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:12:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 157\"}'),
(289, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:33:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(290, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:33:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}');
INSERT INTO `security_logs` (`id`, `user_id`, `event_type`, `ip_address`, `user_agent`, `timestamp`, `details`) VALUES
(291, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:33:55', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(292, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:33:55', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your+session+was+terminated+because+you+logged+in+from+another+device+or+tab.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(293, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:34:19', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/personal_profile.php\",\"email\":\"\"}'),
(294, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:34:28', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(295, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:34:28', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(296, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:34:48', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(297, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:35:00', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(298, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:35:00', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(299, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:53:24', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(300, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:53:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(301, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:53:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(302, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:54:33', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(303, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:54:46', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"petermaina19@gmail.com\"}'),
(304, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:54:51', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"petermaina19@gmail.com\"}'),
(305, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:55:13', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(306, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 16:55:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(307, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:09:13', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(308, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:09:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(309, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:24:10', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(310, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:24:41', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(311, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:24:43', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(312, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:29:26', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php\",\"email\":\"\"}'),
(313, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:29:47', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(314, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:29:49', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(315, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:29:49', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(316, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:30:02', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(317, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:30:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(318, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:31:48', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php\",\"email\":\"\"}'),
(319, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:32:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo208@gmail.com\"}'),
(320, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:32:30', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Session+expired.+Please+log+in+again.\",\"email\":\"philoo208@gmail.com\"}'),
(321, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:32:47', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php\",\"email\":\"\"}'),
(322, 377, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:33:05', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(323, 377, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:33:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"skaranja700@gmail.com\"}'),
(324, 377, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 09:52:55', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/departments.php\",\"email\":\"\"}'),
(325, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:13:30', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(326, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:13:34', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(327, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:19:43', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(328, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:28:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(329, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:28:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(330, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:28:58', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(331, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:30:06', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(332, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:30:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(333, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:31:37', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(334, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:31:59', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(335, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:32:00', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(336, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:33:11', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(337, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:39:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(338, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:39:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(339, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:41:59', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(340, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:47:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(341, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:47:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(342, 312, 'logout', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-16 10:48:13', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(343, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-16 10:48:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(344, NULL, 'csrf_validation_failed', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-16 10:48:30', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(345, 312, 'login_success', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-16 10:48:30', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(346, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-16 10:48:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(347, 312, 'login_success', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-16 10:48:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(348, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:51:03', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 189\"}'),
(349, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:51:08', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 189, error: Failed to update leave balance. No matching record found.\"}'),
(350, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:51:48', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(351, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:52:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(352, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:52:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(353, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:53:32', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(354, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:53:35', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(355, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:53:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(356, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:55:15', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(357, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:55:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(358, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:55:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(359, 276, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 10:55:46', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: subsection_head_approve, leave_id: 190\"}'),
(360, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:16:44', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php?action=subsection_head_approve&id=190&csrf_token=628a60418dde76ed3f8aae235ff765149680622aad91caf1e723042576b6b675\",\"email\":\"\"}'),
(361, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:16:49', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(362, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:16:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(363, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:31:42', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(364, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:31:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(365, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:32:05', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mwangikabii@gmail.com\"}'),
(366, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:32:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mwangikabii@gmail.com\"}'),
(367, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:32:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(368, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:32:44', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(369, 276, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:32:56', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: subsection_head_approve, leave_id: 190\"}'),
(370, 276, 'leave_approved_subsection_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:32:57', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 190\"}'),
(371, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:33:01', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(372, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:33:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"josephine@gmail.com\"}'),
(373, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:33:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(374, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:33:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"kangarajosephine@gmail.com\"}'),
(375, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:34:13', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/personal_profile.php\",\"email\":\"\"}'),
(376, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:34:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(377, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:34:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(378, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:35:44', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=davi&department=&type=&status=\",\"email\":\"\"}'),
(379, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:35:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"davidthugu@gmail.com\"}'),
(380, 340, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"davidthugu@gmail.com\"}'),
(381, 340, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"davidthugu@gmail.com\"}'),
(382, 340, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:20', '{\"consent_id\": 11, \"full_name\": \"DAVID IRUNGU\", \"consent_date\": \"2025-10-16 11:36:20\"}'),
(383, 340, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:21', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"DAVID IRUNGU\",\"national_id_hash\":\"37253bdf914c75373134e8ec887f3ae9b72d9963646c4dad7ad4f92019075d29\"}'),
(384, 340, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:21', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(385, 340, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:48', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: section_head_approve, leave_id: 190\"}'),
(386, 340, 'leave_approved_section_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:36:56', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 190\"}'),
(387, 340, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:02', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: section_head_approve, leave_id: 178\"}'),
(388, 340, 'leave_approved_section_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:05', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 178\"}'),
(389, 340, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:11', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: section_head_approve, leave_id: 174\"}'),
(390, 340, 'leave_approved_section_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:15', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 174\"}'),
(391, 340, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:23', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(392, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(393, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(394, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:37:50', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=maina&department=&type=&status=\",\"email\":\"\"}'),
(395, 368, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:02', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(396, 368, 'consent_required_redirect', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:02', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(397, 368, 'consent_record_created', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:19', '{\"consent_id\": 12, \"full_name\": \"Joseph Maina\", \"consent_date\": \"2025-10-16 11:38:19\"}'),
(398, 368, 'consent_provided', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:19', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\",\"full_name\":\"Joseph Maina\",\"national_id_hash\":\"c4603c4ee09900f1d6fcc3cbb802a04c57c3ab48f5450abc84eb15d8844c687c\"}'),
(399, 368, 'login_success_after_consent', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:20', '{\"script\":\"\\/HRS\\/HRS\\/consent.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/consent.php\"}'),
(400, 368, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:37', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_id: 190\"}'),
(401, 368, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 11:38:38', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 190, error: Failed to update leave balance. No matching record found.\"}'),
(402, 368, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:17:22', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_id: 178\"}'),
(403, 368, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:18:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_id: 178\"}'),
(404, 368, 'leave_approval_unauthorized', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:18:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 178\"}'),
(405, 368, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:18:40', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(406, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:18:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(407, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:18:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(408, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:19:26', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 187\"}'),
(409, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:19:56', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 187\"}'),
(410, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:20:23', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 187\"}'),
(411, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:25:53', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 187\"}'),
(412, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:26:24', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 187\"}'),
(413, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:26:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 187, error: Failed to update leave balance. No matching record found or insufficient balance.\"}'),
(414, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:27:37', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: reject_leave, leave_type_id: 186\"}'),
(415, 312, 'leave_rejected', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:27:37', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 186\"}'),
(416, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:27:46', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 183\"}'),
(417, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:27:48', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 183, error: Failed to update leave balance. No matching record found or insufficient balance.\"}'),
(418, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:31:16', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 184\"}'),
(419, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:31:16', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 184, error: Failed to update leave balance. No matching record found or insufficient balance.\"}'),
(420, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:37:38', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 185\"}'),
(421, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:37:38', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 185, error: Failed to update leave balance. No matching record found or insufficient balance.\"}'),
(422, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:42:49', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 181\"}'),
(423, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:42:49', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 181, error: No active financial year found.\"}'),
(424, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:45:33', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 176\"}'),
(425, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:45:33', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 176, error: No leave balance record found for this employee, leave type, and financial year.\"}'),
(426, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:45:44', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 174\"}'),
(427, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:45:44', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 174, error: No leave balance record found for this employee, leave type, and financial year.\"}'),
(428, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:55:50', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 175\"}'),
(429, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:55:50', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 175, error: No leave balance record found for this employee and leave type.\"}'),
(430, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:56:02', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 170\"}'),
(431, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:56:02', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 170, error: No leave balance record found for this employee and leave type.\"}'),
(432, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:56:12', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 163\"}');
INSERT INTO `security_logs` (`id`, `user_id`, `event_type`, `ip_address`, `user_agent`, `timestamp`, `details`) VALUES
(433, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 12:56:12', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 163, error: No leave balance record found for this employee and leave type.\"}'),
(434, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:41:06', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?error=You+have+been+logged+out+due+to+inactivity.\",\"email\":\"philoo208@gmail.com\"}'),
(435, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:41:09', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?error=You+have+been+logged+out+due+to+inactivity.\",\"email\":\"philoo208@gmail.com\"}'),
(436, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:49:12', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 173\"}'),
(437, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:49:13', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 173, error: No leave balance record found for this employee and leave type.\"}'),
(438, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2025-10-16 15:53:28', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 172\"}'),
(439, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2025-10-16 15:53:29', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 172, error: Insufficient leave balance. Available: 0.00, Requested: 6\"}'),
(440, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:54:24', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 171\"}'),
(441, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:54:26', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 171, error: Insufficient leave balance. Available: 0.00, Requested: 17\"}'),
(442, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:56:05', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 169\"}'),
(443, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:56:06', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 169, error: Insufficient leave balance. Available: 0.00, Requested: 17\"}'),
(444, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:57:30', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 158\"}'),
(445, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:57:35', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 158, error: Insufficient leave balance. Available: 0.00, Requested: 17\"}'),
(446, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:58:00', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"email\":\"\"}'),
(447, 368, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:58:11', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(448, 368, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 15:58:26', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(449, 368, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:00:59', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"email\":\"\"}'),
(450, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:01:08', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(451, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:01:09', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(452, 276, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:01:55', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: subsection_head_approve, leave_type_id: 191\"}'),
(453, 276, 'leave_approved_subsection_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:01:59', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 191\"}'),
(454, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:02:17', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"email\":\"\"}'),
(455, 368, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:02:26', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(456, 368, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:02:27', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(457, 368, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:02:37', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(458, 340, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:02:46', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"davidthugu@gmail.com\"}'),
(459, 340, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:02:47', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"davidthugu@gmail.com\"}'),
(460, 340, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:03:00', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: section_head_approve, leave_type_id: 191\"}'),
(461, 340, 'leave_approved_section_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:03:05', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 191\"}'),
(462, 340, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:03:41', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"email\":\"\"}'),
(463, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:01', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(464, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:18', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(465, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:31', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(466, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:32', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(467, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:47', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/employees.php?search=hezron&department=&type=&status=\",\"email\":\"\"}'),
(468, 368, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:55', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(469, 368, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:04:57', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"bcmutai88@yahoo.com\"}'),
(470, 368, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:05:42', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"email\":\"\"}'),
(471, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:05:58', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(472, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:06:08', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(473, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:06:17', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(474, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:06:22', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(475, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:06:24', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(476, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:07:43', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(477, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:07:45', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(478, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:07:54', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(479, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:07:59', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(480, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:07:59', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(481, 300, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:08:12', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_type_id: 191\"}'),
(482, 300, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:08:14', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 191, error: Insufficient leave balance. Available: 0.00, Requested: 16\"}'),
(483, 300, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:25:29', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_type_id: 162\"}'),
(484, 300, 'leave_approved_dept_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:25:39', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 162\"}'),
(485, 300, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:26:12', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_type_id: 159\"}'),
(486, 300, 'leave_approved_dept_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:26:18', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 159\"}'),
(487, 300, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:40:33', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_type_id: 157\"}'),
(488, 300, 'leave_approved_dept_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 16:40:40', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 157\"}'),
(489, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 09:46:49', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(490, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 09:47:23', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php\",\"email\":\"philoo2008@gmail.com\"}'),
(491, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:48:43', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(492, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:48:56', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(493, 300, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:50:56', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(494, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:51:07', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(495, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:51:12', '{\"script\":\"\\/hrs\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(496, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:52:33', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 166\"}'),
(497, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 09:52:35', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 166\"}'),
(498, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:15:52', '{\"script\":\"\\/hrs\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/history.php\",\"email\":\"\"}'),
(499, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:28:17', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(500, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:28:18', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(501, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:43:01', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 165\"}'),
(502, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:43:02', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 165\"}'),
(503, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:43:15', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 160\"}'),
(504, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:43:15', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 160\"}'),
(505, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:45:43', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 153\"}'),
(506, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 10:45:44', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 153\"}'),
(507, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 11:24:27', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 192\"}'),
(508, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 11:24:28', '{\"script\":\"\\/hrs\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/hrs\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 192\"}'),
(509, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:53:29', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(510, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 13:53:35', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=Your%20session%20was%20terminated%20because%20you%20logged%20in%20from%20another%20device%20or%20tab.\",\"email\":\"philoo208@gmail.com\"}'),
(511, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 14:59:07', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 164\"}'),
(512, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 14:59:08', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 164\"}'),
(513, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:17:17', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=nancy&department=&type=&status=\",\"email\":\"\"}'),
(514, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:17:26', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(515, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:17:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(516, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:17:33', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(517, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:17:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(518, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:17:43', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(519, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:44:25', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php\",\"email\":\"\"}'),
(520, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:44:34', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(521, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:44:34', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(522, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:44:52', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=cecil&department=&type=&status=\",\"email\":\"\"}'),
(523, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:45:02', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(524, 327, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:45:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(525, 327, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:55:50', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/strategic_plan.php?tab=goals\",\"email\":\"\"}'),
(526, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:56:01', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(527, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 15:56:01', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(528, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:04:05', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=cecilia&department=&type=&status=\",\"email\":\"\"}'),
(529, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:04:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(530, 327, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:04:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(531, 327, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:23:56', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(532, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:24:05', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(533, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:24:20', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(534, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:24:21', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(535, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:29:56', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=cecilia&department=&type=&status=\",\"email\":\"\"}'),
(536, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:30:10', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(537, 327, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:30:11', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(538, 327, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:56:08', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/performance_appraisal.php?cycle_id=2&employee_id=400\",\"email\":\"\"}'),
(539, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:56:14', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo2008@gmail.com\"}'),
(540, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:56:21', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(541, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-21 16:56:21', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(542, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 09:29:24', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=You+have+been+logged+out+due+to+inactivity.\",\"email\":\"philoo208@gmail.com\"}'),
(543, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 09:29:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=You+have+been+logged+out+due+to+inactivity.\",\"email\":\"philoo208@gmail.com\"}'),
(544, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 10:23:34', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 193\"}'),
(545, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 10:23:35', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 193\"}'),
(546, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 10:28:18', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 194\"}'),
(547, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 10:28:18', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 194\"}'),
(548, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:21:03', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 195\"}'),
(549, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:24:41', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 195\"}'),
(550, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:24:44', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 195, error: Balance update failed: No leave balance record found for the employee and leave type.\"}'),
(551, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:25:08', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 195\"}'),
(552, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:25:08', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 195, error: Balance update failed: No leave balance record found for the employee and leave type.\"}'),
(553, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:29:48', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 195\"}'),
(554, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:41:38', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 195\"}'),
(555, 178, 'leave_balance_initialized', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:41:40', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type: 7, fy: 27\"}'),
(556, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:41:41', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 195\"}'),
(557, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:58:03', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 196\"}'),
(558, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 11:58:04', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 196\"}'),
(559, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:09:38', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=kangara&department=&type=&status=\",\"email\":\"\"}'),
(560, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:09:47', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezronnjoro@gmail.com\"}'),
(561, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:09:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezronnjoro@gmail.com\"}'),
(562, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:28', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(563, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:28', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(564, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:44', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=hez&department=&type=&status=\",\"email\":\"\"}'),
(565, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:45', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=hez&department=&type=&status=\",\"email\":\"\"}'),
(566, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:45', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/employees.php?search=hez&department=&type=&status=\",\"email\":\"\"}'),
(567, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:57', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(568, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:10:57', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(569, 300, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:11:11', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: dept_head_approve, leave_id: 197\"}'),
(570, 300, 'leave_approved_dept_head', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 12:11:14', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 197\"}'),
(571, 300, 'session_timeout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:16:54', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"\"}'),
(572, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:16:58', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=You+have+been+logged+out+due+to+inactivity.\",\"email\":\"hezmutharu@gmail.com\"}'),
(573, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:16:59', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?error=You+have+been+logged+out+due+to+inactivity.\",\"email\":\"hezmutharu@gmail.com\"}'),
(574, 300, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:17:20', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(575, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:17:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}');
INSERT INTO `security_logs` (`id`, `user_id`, `event_type`, `ip_address`, `user_agent`, `timestamp`, `details`) VALUES
(576, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:17:27', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"hezmutharu@gmail.com\"}'),
(577, 300, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:18:17', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(578, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:18:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(579, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:18:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(580, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:19:06', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 198\"}'),
(581, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:19:06', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 198, error: Insufficient leave balance. Approval denied.\"}'),
(582, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:19:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 198\"}'),
(583, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:19:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 198, error: Insufficient leave balance. Approval denied.\"}'),
(584, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:35:36', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 198\"}'),
(585, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:35:36', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 198, error: Insufficient leave balance. Approval denied.\"}'),
(586, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:36:34', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 198\"}'),
(587, 225, 'leave_balance_initialized', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:36:34', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type: 1, fy: 27\"}'),
(588, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 14:36:34', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 198\"}'),
(589, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 15:46:51', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 199\"}'),
(590, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 15:46:51', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 199, error: Insufficient leave balance. Approval denied.\"}'),
(591, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:32:14', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 199\"}'),
(592, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:32:57', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_id: 199\"}'),
(593, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:32:57', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_id: 199, error: Insufficient leave balance. Approval denied.\"}'),
(594, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:42:34', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 199\"}'),
(595, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:43:01', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 199\"}'),
(596, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:44:45', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 199\"}'),
(597, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-22 16:44:46', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 199\"}'),
(598, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 08:03:11', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(599, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 08:03:13', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"philoo208@gmail.com\"}'),
(600, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2024-07-23 08:31:50', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(601, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2024-07-23 08:33:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(602, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2024-07-23 08:33:03', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(603, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 08:40:47', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 200\"}'),
(604, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 08:40:47', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 200\"}'),
(605, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:30:05', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(606, NULL, 'login_failed', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:30:12', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(607, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:30:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mwangikabii@gmail.com\"}'),
(608, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:30:25', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php\",\"email\":\"mwangikabii@gmail.com\"}'),
(609, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:30:57', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(610, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:31:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(611, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:31:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(612, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:31:56', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(613, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:04', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(614, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:04', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(615, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:16', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 202\"}'),
(616, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:17', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 202\"}'),
(617, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:26', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(618, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:33', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(619, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:32:34', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(620, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:33:52', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(621, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:33:59', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(622, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:33:59', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(623, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:34:07', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 203\"}'),
(624, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:34:07', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 203\"}'),
(625, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:34:09', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(626, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:34:17', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(627, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:34:17', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(628, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:05', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(629, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(630, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(631, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:25', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 204\"}'),
(632, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:26', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 204\"}'),
(633, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:30', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(634, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(635, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:39', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(636, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:35:56', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(637, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:36:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(638, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 10:36:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(639, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:14:59', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(640, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:16:22', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(641, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:16:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(642, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:10', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(643, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(644, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(645, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:28', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 206\"}'),
(646, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:28', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 206\"}'),
(647, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:35', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 205\"}'),
(648, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:36', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 205\"}'),
(649, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:40', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(650, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:49', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(651, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:20:49', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(652, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:25:01', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(653, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:25:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(654, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:25:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(655, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:55:30', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(656, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:55:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(657, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:55:37', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(658, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:57:59', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 207\"}'),
(659, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:57:59', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 207, error: No leave balance record found for employee ID 178 and leave type ID 1.\"}'),
(660, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:59:09', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 208\"}'),
(661, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 11:59:09', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 208, error: No leave balance record found for employee ID 207 and leave type ID 1.\"}'),
(662, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:02:34', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(663, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:02:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(664, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:02:36', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(665, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:02:38', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/dashboard.php\",\"email\":\"\"}'),
(666, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:02:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(667, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:02:42', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(668, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:08', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(669, 276, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:13', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(670, 276, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:13', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mainapetermwangi2017@gmail.com\"}'),
(671, 276, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:21', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(672, 327, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(673, 327, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:32', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"njokicecilia@gmail.com\"}'),
(674, 327, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:45', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(675, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(676, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:03:50', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(677, 284, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:05:06', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(678, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:05:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(679, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:05:16', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(680, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:18:50', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 209\"}'),
(681, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:18:50', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 209, error: No leave balance record found for employee ID 178 and leave type ID 1.\"}'),
(682, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:50:29', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 211\"}'),
(683, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:50:29', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 211, error: No leave balance record found for employee ID 178 and leave type ID 1.\"}'),
(684, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:56:35', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 212\"}'),
(685, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 12:56:35', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 212, error: No leave balance record found for employee ID 178 and leave type ID 1.\"}'),
(686, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 13:03:29', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 213\"}'),
(687, 312, 'leave_approval_error', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 13:03:30', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 213, error: Failed to update leave balance.\"}'),
(688, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:07:09', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 214\"}'),
(689, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:07:12', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 214\"}'),
(690, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:18:23', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 215\"}'),
(691, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:18:27', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 215\"}'),
(692, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:52:17', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 216\"}'),
(693, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:52:21', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 216\"}'),
(694, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:52:59', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(695, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:53:07', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(696, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 14:53:08', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(697, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:01:31', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(698, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:01:37', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(699, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:01:38', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(700, 312, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:02:08', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: hr_approve, leave_type_id: 217\"}'),
(701, 312, 'leave_approved_hr', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:02:11', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 217\"}'),
(702, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:02:25', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(703, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:02:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(704, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:02:31', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(705, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:18:00', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/profile.php\",\"email\":\"\"}'),
(706, 258, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:18:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(707, 258, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:18:09', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"mwangikabii@gmail.com\"}'),
(708, 258, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:18:15', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(709, 312, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:18:20', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(710, 312, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 15:18:20', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"philoo208@gmail.com\"}'),
(711, 312, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:21:34', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"email\":\"\"}'),
(712, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:21:40', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(713, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:21:40', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(714, 300, 'leave_management_action', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:21:49', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"action: reject_leave, leave_type_id: 219\"}'),
(715, 300, 'leave_rejected', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:21:52', '{\"script\":\"\\/HRS\\/HRS\\/manage.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/manage.php\",\"additional_info\":\"leave_type_id: 219\"}'),
(716, 300, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:45:15', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/leave_management.php\",\"email\":\"\"}'),
(717, 300, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:47:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}'),
(718, 300, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:47:48', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"hezmutharu@gmail.com\"}');
INSERT INTO `security_logs` (`id`, `user_id`, `event_type`, `ip_address`, `user_agent`, `timestamp`, `details`) VALUES
(719, 300, 'logout', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:58:14', '{\"script\":\"\\/HRS\\/HRS\\/logout.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/strategic_plan.php?tab=goals\",\"email\":\"\"}'),
(720, 284, 'login_credentials_validated', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:58:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}'),
(721, 284, 'login_success', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-23 16:58:23', '{\"script\":\"\\/HRS\\/HRS\\/login.php\",\"referrer\":\"http:\\/\\/localhost\\/HRS\\/HRS\\/login.php?message=You+have+been+successfully+logged+out.\",\"email\":\"kangarajosephine@gmail.com\"}');

-- --------------------------------------------------------

--
-- Table structure for table `strategic_plan`
--

CREATE TABLE `strategic_plan` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `strategic_plan`
--

INSERT INTO `strategic_plan` (`id`, `name`, `start_date`, `end_date`, `created_at`, `updated_at`, `image`) VALUES
(2, 'strategic plan 2025-2030', '2025-01-01', '2031-03-12', '2025-09-05 12:19:43', '2025-09-08 07:55:49', 'uploads/strategic_plan_images/2025/2.png'),
(3, '2026-2031', '2026-01-01', '2031-12-31', '2025-09-08 08:15:44', '2025-09-08 08:22:16', 'Uploads/2026-2031/3.png');

-- --------------------------------------------------------

--
-- Table structure for table `strategies`
--

CREATE TABLE `strategies` (
  `id` int(11) NOT NULL,
  `strategic_plan_id` int(11) NOT NULL,
  `objective_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `activity` text NOT NULL,
  `kpi` text NOT NULL,
  `target` text NOT NULL,
  `Y1` int(11) NOT NULL,
  `Y2` int(11) NOT NULL,
  `Y3` int(11) NOT NULL,
  `Y4` int(11) NOT NULL,
  `Y5` int(11) NOT NULL,
  `Comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `strategies`
--

INSERT INTO `strategies` (`id`, `strategic_plan_id`, `objective_id`, `name`, `start_date`, `end_date`, `activity`, `kpi`, `target`, `Y1`, `Y2`, `Y3`, `Y4`, `Y5`, `Comment`, `created_at`, `updated_at`) VALUES
(2, 2, 1, 'To enforce  the Public  Health Act  on sewer  connections', '2025-10-01', '2025-10-31', 'Asingning new meter readers', '', '', 1, 2, 0, 0, 0, '', '2025-09-08 09:14:51', '2025-09-08 11:16:25'),
(3, 2, 3, 'Improve  customer  satisfaction  index from  60% to 85%  by the year  2030 ', '2025-06-01', '2025-12-01', '', '', '', 0, 0, 0, 0, 0, '', '2025-09-08 11:20:22', '2025-09-08 11:20:22'),
(4, 2, 1, 'To increase  customer  sewer  connections  from 6500 to  10,000 by the  year 2030 ', '2025-09-01', '2025-09-24', '', '', '', 0, 0, 0, 0, 0, '', '2025-09-08 11:22:07', '2025-09-08 11:22:07');

-- --------------------------------------------------------

--
-- Table structure for table `subsections`
--

CREATE TABLE `subsections` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `department_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subsections`
--

INSERT INTO `subsections` (`id`, `name`, `description`, `department_id`, `section_id`, `created_at`, `updated_at`) VALUES
(1, 'Nothern Region', 'commercial nothern region', 2, 12, '2025-10-14 09:29:47', '2025-10-14 09:29:47');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(50) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `surname` varchar(50) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('bod_chairman','super_admin','hr_manager','dept_head','section_head','manager','officer','managing_director','sub_section_head') DEFAULT 'officer',
  `designation` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `profile_image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `employee_id` varchar(11) DEFAULT NULL,
  `session_token` varchar(255) DEFAULT NULL,
  `login_identifier` varchar(64) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `last_activity` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `first_name`, `last_name`, `surname`, `gender`, `password`, `role`, `designation`, `phone`, `address`, `profile_image_url`, `created_at`, `updated_at`, `employee_id`, `session_token`, `login_identifier`, `is_active`, `last_activity`) VALUES
(202, 'annwangari275@gmail.com', 'Hannah', 'Wangari', '', '', '$2y$10$g.XijIQ7XLO/U8bR3KPIiOLBJZwGPa5Xqnk4Gj3whwqGkWH2x.q9W', '', 'Technician', '0711366089', 'Murang`a', NULL, '2025-10-09 12:54:31', '2025-10-09 12:54:31', '74', NULL, NULL, 1, NULL),
(203, 'njorogesolomon2@gmail.com', 'NYAGUTHII', 'SOLOMON', '', '', '$2y$10$M4sLk/WvzBD71frfM3QFnuiUtumGVkptfDDGgrrhPQJI7L2O/wsH2', '', 'Region Officer', '0717331399', 'Murang`a', NULL, '2025-10-09 12:54:32', '2025-10-09 12:54:32', '98', NULL, NULL, 1, NULL),
(204, 'mimaissah@gmail.com', 'Halima', 'Issah', '', '', '$2y$10$wS9hr7VoNt19xZk1ra9ZhOJ3npRGi1QDN5G2VBsRGmWnX6KWAMcbe', '', 'Water Production Officer', '0717210705', 'Murang`a', NULL, '2025-10-09 12:54:32', '2025-10-09 12:54:32', '100', NULL, NULL, 1, NULL),
(205, 'ephantusndegwa3@gmail.com', 'EPHANTUS', 'NDEGWA', '', '', '$2y$10$SMM8FDFpCo00H1aTjAodLO3BvpM9NitlNyEbS/iWtmzfJUjZp0EXa', '', 'Water Production Operator', '0706 9387 75', 'Murang`a', NULL, '2025-10-09 12:54:32', '2025-10-09 12:54:32', '101', NULL, NULL, 1, NULL),
(206, 'nduatigerald763@gmail.com', 'Gerald', 'Nduati', '', '', '$2y$10$tVxALmU5BZ34D3sdQ1SUAOfd.9.hSYoTeAVeuyJewrWHeE2ZP8F.2', '', 'Sewerage Artisan', '0719570676', 'Murang`a', NULL, '2025-10-09 12:54:32', '2025-10-09 12:54:32', '102', NULL, NULL, 1, NULL),
(207, 'gladyswaigwenyambura@gmail.com', 'Gladys', 'Waigwe', '', '', '$2y$10$FIOxXZD4mal8nT3CP.r8t.Q1dfks5mcKjz4sGbG3eBEheAXJMC3.W', '', 'Meter Reader', '0723136825', 'Murang`a', NULL, '2025-10-09 12:54:32', '2025-10-09 12:54:32', '103', NULL, NULL, 1, NULL),
(208, 'mercythiongo62@gmail.com', 'Mercy', 'Thiong\'o', '', '', '$2y$10$QLucY5i47vgv8VQ08dikMO15122bE6EQpYooxsDj9ZK6MtQ0TbiuG', '', 'Water Production Operator', '0701516689', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '104', NULL, NULL, 1, NULL),
(209, 'muchainash@gmail.com', 'Nahashon', 'Muchai', '', '', '$2y$10$sX0pmYB7aY33HE2zb0VzN.H/2e28nmI858ISTr1orEeNb16SWs91m', '', 'Waste Water Officer', '0726605101', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '105', NULL, NULL, 1, NULL),
(210, 'partmwai70@gmail.com', 'Patrick', 'Wanjohi', '', '', '$2y$10$ktq202kEOLJ.lyFN0i3kp.nMl7SfjAlCoRue510bRuBfXvJnbAqou', '', 'Transport Officer', '0715198136', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '106', NULL, NULL, 1, NULL),
(211, 'eng.skinyua@gmail.com', 'SIMON', 'KINYUA', '', '', '$2y$10$3nVlE2EGUGAJzh6PAjjM8OXDe8TClqUMpASWn0V44t1ZRnFRoi8GO', '', 'Water Inspector', '0729368082', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '107', NULL, NULL, 1, NULL),
(212, 'peterkairu2023@gmail.com', 'Peter', 'Kairu', '', '', '$2y$10$HD8boA1aIfVSFBFaMbCBi.2aIwyuMV5WuRlJbL0RyMLgZzF.d3fu6', '', 'Technician', '0723405355', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '108', NULL, NULL, 1, NULL),
(213, 'neliusmacharia60@gmail.com', 'NELIUS', 'WARUGURU', '', '', '$2y$10$mQqC8PyPkEnYNPDKwiGLN.lZe.3NcVFKbCdZ5AB2DYgeOTXsRpvz6', '', 'Technician', '0712732130', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '109', NULL, NULL, 1, NULL),
(214, 'cumahngash@gmail.com', 'Peter', 'nganga', '', '', '$2y$10$KSYJs7ZwLaFMp/Kp1kQNf.Uwcx4K0nUOcEA/kunsSXBrwMjfevC5C', '', 'Construction', '0722937749', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '110', NULL, NULL, 1, NULL),
(215, 'patrickwaweru43@gmail.com', 'Patrick', 'waweru', '', '', '$2y$10$5aAjQXisSZcx4mrNXoCMXObI1NIhHfYnmRMsc9yf1Hx5xCqFtw8gi', '', 'Snr Water Production Officer', '0716729050', 'Murang`a', NULL, '2025-10-09 12:54:33', '2025-10-09 12:54:33', '111', NULL, NULL, 1, NULL),
(216, 'wanjirunganga7@gmail.com', 'ANNA', 'Ng\'ang\'a', '', '', '$2y$10$hNxLB6SaQSJLrrU/95g7uOA4i/dtTKrrE0UdM5d3.wjJ33FlrCaQS', '', 'Debt Controller', '0721286220', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '112', NULL, NULL, 1, NULL),
(217, 'stevenngumi2017@gmail.com', 'Stephen', 'Ngumi', '', '', '$2y$10$yYc1Fzta69fMKaAPNakN4enwTdGbFcGGa3TyITxp0gHNf/cwid5Uq', '', 'Technician', '0725544028', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '113', NULL, NULL, 1, NULL),
(218, 'jameskamande1988@gmail.com', 'James', 'Kamande', '', '', '$2y$10$wTPjyIa/s53EHVsyZXprzugsb/ZsuZ3o2kCebIY1em.azRsJXHlju', '', 'Technician', '0725082047', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '114', NULL, NULL, 1, NULL),
(219, 'nyamburamonicahn@gmail.com', 'Monicah', 'nyambura', '', '', '$2y$10$RJk1udqVzavYFG9w83TQjulUiGZlAK1v.vfv5ZijL7RXK5E13Tyya', '', 'Debt Controller', '0725510718', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '115', NULL, NULL, 1, NULL),
(220, 'nancymuriithi2014@gmail.com', 'Nancy', 'Wanjiru', '', '', '$2y$10$JMSeUT8XmhjKEF1VywFjmOvMpYFd3nDyjwSvgvxp25i2DpUFT2ox2', '', 'Asst. Customer Relations Officer', '0710637796', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '118', NULL, NULL, 1, NULL),
(221, 'Lucymbuthia11@gmail.com', 'Lucy', 'Mbuthia', '', '', '$2y$10$ppjvCX2uHyKWMebZ8eo9q.MyZ0APCoubf37lmq82DzzA37s/GBR2i', '', 'Human Resource Officer', '0720421352', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '119', NULL, NULL, 1, NULL),
(222, 'monicawanjirumwaura@gmail.com', 'Monica', 'Wanjiru', '', '', '$2y$10$EBkLxOPoZmv2.pE4o0GnO.4Q16VJsZSttFD7K1.0J.i05BhzVh9.i', '', 'Water Production Operator', '0707740307', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '120', NULL, NULL, 1, NULL),
(223, 'tabithamwirigi@gmail.com', 'Tabitha', 'W', '', '', '$2y$10$cpDtRaHr45S7elhRDqXqH.UqiVsaq5A0HxpE0filORsUmI6RrRzLq', '', 'Pro Poor Officer', '0726700604', 'Murang`a', NULL, '2025-10-09 12:54:34', '2025-10-09 12:54:34', '121', NULL, NULL, 1, NULL),
(224, 'emmawacui@gmail.com', 'Emma', 'Wachui', '', '', '$2y$10$7kIUYIA0XB1j9JnM2gIwsuD1qciGO2omeSg5i7FCVO4C32MdN3g4C', '', 'Office Assistant', '0728315533', 'Murang`a', NULL, '2025-10-09 12:54:35', '2025-10-09 12:54:35', '124', NULL, NULL, 1, NULL),
(225, 'gichuruchristopher@yahoo.com', 'Christopher', 'Gichuru', '', '', '$2y$10$js/DiV4bvF6S48Bmllj99.zIEAz.9ufsTvXbbWOCF0/cZzfgw9e/.', '', 'Technician', '0724619079', 'Murang`a', NULL, '2025-10-09 12:54:35', '2025-10-09 12:54:35', '128', NULL, NULL, 1, NULL),
(226, 'monicahgithinji680@gmail.com', 'MONICAH', 'MUGECHI', '', '', '$2y$10$OWO3YhBHaD7x5.nRn4aXleCSFkeq/SotNEw09vF3MMpEdXKdyK3g2', '', 'Office Assistant', '0723677670', 'Murang`a', NULL, '2025-10-09 12:54:35', '2025-10-09 12:54:35', '130', NULL, NULL, 1, NULL),
(227, 'njorogemathia21@gmail.com', 'Joseph', 'njoroge', '', '', '$2y$10$/C8k0zC6nrt9A438gFXUZ.vmAMUE/ccqoDoPj7GuSngrhYMJz7D4e', '', 'Water Production Operator', '0708076186', 'Murang`a', NULL, '2025-10-09 12:54:35', '2025-10-09 12:54:35', '131', NULL, NULL, 1, NULL),
(228, 'gichimurose61@gmail.com', 'Rose', 'Gichimu', '', '', '$2y$10$G/0hjLdpOSJz8BIUResc6O27SVdaAswv1fIqASiLAPUWEeketxyh2', '', 'Procurement Officer', '0719277611', 'Murang`a', NULL, '2025-10-09 12:54:35', '2025-10-09 12:54:35', '133', NULL, NULL, 1, NULL),
(229, 'njeriwangai6@gmail.com', 'Wangai', 'Mary', '', '', '$2y$10$ukLpG2J49XC34h/4K5ytgOpbxOSwYtLN7COHpvHA.0HlV1xTznX12', '', 'Customer Service Assistant', '07284 63040', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '135', NULL, NULL, 1, NULL),
(230, 'margaretwairimumm@gmail.com', 'Margaret', 'wairimu', '', '', '$2y$10$gSvXJ/dwlvGdSdj2hLxpWuznr/o6nw.i.aLnHm8xkQDF5sP/aM6cy', '', 'Office Assistant', '0713114087', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '136', NULL, NULL, 1, NULL),
(231, 'stekapannuelss5@gmail.com', 'Stephen', 'kamau', '', '', '$2y$10$ox7FSspl3i/IwonPsYsv8udKb0VkW42cLxzZtDkjLxTULPM69vEEW', '', 'Water Quality Officer', '0700863332', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '140', NULL, NULL, 1, NULL),
(232, 'michaeliyema01@gmail.com', 'Michael', 'Shimega', '', '', '$2y$10$e0.ZyUtK4g7i2wTZ/YF7UeGLkw7W/l4tzyZzKvxh4DkgB5y3bLwlO', '', 'Driver', '0727728906', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '143', NULL, NULL, 1, NULL),
(233, 'anwainaina249@gmail.com', 'ANN', 'NYAMBURA', '', '', '$2y$10$cmmJc9rwqYrtbvqSm/4kYuNfcO9HkIVaKCOMWNHH1si7E0WyQWZES', '', 'Accountant', '0713623097', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '144', NULL, NULL, 1, NULL),
(234, 'peterkim0048@gmail.com', 'Peter', 'kimani', '', '', '$2y$10$bZAKX.a7GgIO7763IVAPfuu0kdmgnit3DgcKtgHwJ7IFX2qt/b.My', '', 'Meter Reader', '0713470048', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '145', NULL, NULL, 1, NULL),
(235, 'jeniffernjoki389@gmail.com', 'Jeniffer', 'njoki', '', '', '$2y$10$dT1KTr2GJgtS40KGLUpR0.j2NjUNQ9vbsDacL3LVhxhRoaWd4gbGe', '', 'Technician', '0707866140', 'Murang`a', NULL, '2025-10-09 12:54:36', '2025-10-09 12:54:36', '146', NULL, NULL, 1, NULL),
(236, 'alicemuthoni252@gmail.com', 'ALICE', 'MUTHONI', '', '', '$2y$10$ifgfl.MWLEiXUmlP7JDdwOQlpwb48h.WQzC.XnW/faj5ihxdq2EDO', '', 'Office Assistant', '0720838464', 'Murang`a', NULL, '2025-10-09 12:54:37', '2025-10-09 12:54:37', '147', NULL, NULL, 1, NULL),
(237, 'jacobgachua@gmail.com', 'Jacob', 'Gachua', '', '', '$2y$10$zxf7U/NEIYnJxY/rHl3q1.EUu3KCxj2HO8yhF5tgrMrtYmG1yVh8a', '', 'Office Assistant', '0727939595', 'Murang`a', NULL, '2025-10-09 12:54:37', '2025-10-09 12:54:37', '148', NULL, NULL, 1, NULL),
(238, 'priscillanjoroge111@gmail.com', 'Priscilla', 'Nancy', '', '', '$2y$10$gjcy1Cb/1XAKV.Dl/Mt8zu8/MTBkUbjSBfOqJfq1Rlf0ZyQ92K1l6', '', 'Office Assistant', '0728463069', 'Murang`a', NULL, '2025-10-09 12:54:37', '2025-10-09 12:54:37', '150', NULL, NULL, 1, NULL),
(239, 'cliffsonmunene40@gmail.com', 'Cliffson', 'munene', '', '', '$2y$10$eN4aem9qsrP/uB6SS1h3QelsufTneVoWEyHyKwYhB0AFbmWXf7UP6', '', 'Technician', '0726771449', 'Murang`a', NULL, '2025-10-09 12:54:37', '2025-10-09 12:54:37', '154', NULL, NULL, 1, NULL),
(240, 'thiongo.dennis53@gmail.com', 'Dennis', 'Thiongo', '', '', '$2y$10$B41X4aiUlUuOvMUOYbM/0O6hqbFW0nSHnPXEafDOCBSpP148WKTC2', '', 'Water Inspector', '0728086149', 'Murang`a', NULL, '2025-10-09 12:54:37', '2025-10-09 12:54:37', '157', NULL, NULL, 1, NULL),
(241, 'elizawariara870@gmail.com', 'Elizabeth', 'Wariara', '', '', '$2y$10$uaQfvSAoX03JNbK5aNvmGu0xxmTKwU9uTKm1WkmremOgbLg0ViEae', '', 'Water Quality Officer', '0725633731', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '158', NULL, NULL, 1, NULL),
(242, 'kaguairebeccaw@gmail.com', 'Rebecca', 'Wanjiku', '', '', '$2y$10$HR9anshVLmXR21Wdv9PrquRu3xwnZ3WKDMhY8HxJKt5Q2Ox3/lZYu', '', 'Technician', '0110932834', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '159', NULL, NULL, 1, NULL),
(243, 'peterchek852@gmail.com', 'PETER', 'CHEGE', '', '', '$2y$10$w/3GjNcEnaRYYgqqQzYJsuiYvGSIpIm2lw3z.qQge46.wKmG502Da', '', 'Driver', '0743800935', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '160', NULL, NULL, 1, NULL),
(244, 'raphaelkoigi@gmail.com', 'Raphael', 'Koigi', '', '', '$2y$10$WOpHQxY0XTlopk9RVoBo9O5BFJe1j1EXVC8rRQfwYvC.ZvK4lsFUe', '', 'Human Resource Asst.', '0721585113', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '161', NULL, NULL, 1, NULL),
(245, 'mwangikibugi@gmail.com', 'MWANGI', 'DAVID', '', '', '$2y$10$AfHoEpGS6Qhk6eqPNCkGzOK6/MosvRyk5KMN68y7NZpFvigXCkcge', '', 'Sales & Marketing', '0727925196', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '162', NULL, NULL, 1, NULL),
(246, 'ngugijohn316@gmail.com', 'JOHN', 'KINYANJUI', '', '', '$2y$10$TVxXDvtGntH3MI1noompLObi0UXIWPlLPq.tERNeg3qHYw/sIS4nS', '', 'Technician', '0700666471', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '164', NULL, NULL, 1, NULL),
(247, 'davidmarwa95@gmail.com', 'David', 'Silas', '', '', '$2y$10$09OyZULWV.q5R6zLEvVBku4ZH/oXocJWIOTPlYQi9Q6KVy.710ZRK', '', 'Development Officer', '0708746190', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '167', NULL, NULL, 1, NULL),
(248, 'kibaiyu17@gmail.com', 'Kibaiyu', 'Mary', '', '', '$2y$10$rhP0PqYiBhjz.1M6GB7/3uKBsnCu64FG0SllGuNZcXiC2gHjVHqFq', '', 'Procurement Officer', '0701971835', 'Murang`a', NULL, '2025-10-09 12:54:38', '2025-10-09 12:54:38', '168', NULL, NULL, 1, NULL),
(249, 'ngangamichael704@gmail.com', 'MICHAEL', 'CHEGE', '', '', '$2y$10$MuHzKy0/cDPw1QeojGHDE.W3q.APkr5FX3Z4yMXuFLYHqKutqohVK', '', 'Mechanic', '0794800524', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '169', NULL, NULL, 1, NULL),
(250, 'irungud715@gmail.com', 'DAVID', 'IRUNGU', '', '', '$2y$10$a1Z73zIHZjQUdEbtK4.JJeGDfrCVS3YBbB73JCRRDklJTzmGeLO5e', '', 'Office Assistant', '0797629688', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '170', NULL, NULL, 1, NULL),
(251, 'juliusgathere58@gmail.com', 'Gathere', 'julius', '', '', '$2y$10$3zzJJZIhhc1jRxRKPiRMp.8h6AZwWwqZzYav1JzVpF7Y0BXzJYnhK', '', 'Technician', '0768517106', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '171', NULL, NULL, 1, NULL),
(252, 'charlesirungugatambia@gmail.com', 'Gatambia', 'Charles', '', '', '$2y$10$XeuizKo8OVHfHL0aGajQcOCRDBucjEFT7kW/gYc0pMirJyPkRyFIO', '', 'Water Production Operator', '0797156237', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '172', NULL, NULL, 1, NULL),
(253, 'Stanleynjuguna403@gmail.com', 'Stanley', 'njuguna', '', '', '$2y$10$wikPvTM4ZL4R7vS6pYAh8.8G7J1UTMJCL/r0ZVs2cydqzHETN98B2', '', 'Technician', '0711264480', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '173', NULL, NULL, 1, NULL),
(254, 'Irenewambui07@gmail.com', 'IRENE', 'WAMBUI', '', '', '$2y$10$.f55B1q8StRL19vFNB6ClOcxc3E5deTshgrnxyBOg6NBorPmr6tsK', '', 'Asst. Sales & Marketing Officer', '0713415338', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '174', NULL, NULL, 1, NULL),
(255, 'kingjilden@gmail.com', 'Jilden', 'Stanely', '', '', '$2y$10$/TfWac57/cHLea53NQwUY.MyVxBlKRE24Dw1Fi7c9oxAJFu/RXzS6', '', 'Meter Reader', '0702372604', 'Murang`a', NULL, '2025-10-09 12:54:39', '2025-10-09 12:54:39', '175', NULL, NULL, 1, NULL),
(256, 'petermwangikariuki78929@gmail.com', 'Peter', 'Mwangi', '', '', '$2y$10$Xkte6iqOCK7uPGnojCY2qut1nl6a5ASgt8kVQgGLL6CTMS3MHkU.m', '', 'Technician', '0700172390', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '176', NULL, NULL, 1, NULL),
(257, 'sarahkathunguto@gmail.com', 'Sarah', 'kathunguto', '', 'female', '$2y$10$2Lsl/n2ZC8uLLy9LjvlKGe6G5v7XGUhPb5j1ggW1avYK/nls5vnR2', 'officer', 'Office Assistant', '0721491105', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 13:17:37', '177', NULL, NULL, 1, NULL),
(258, 'mwangikabii@gmail.com', 'Stephen', 'Mwangi', '', 'male', '$2y$10$xjTq75QtEwElMFrq6YXpQebCu/HUcEMOnam/Mm42KnsxT8oqsscNW', '', 'Asst. ICT', '0707699054', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-23 12:18:15', '178', NULL, NULL, 1, '2025-10-23 12:18:12'),
(259, 'wjackline15@yahoo.com', 'Jackline', 'wanjiru', '', '', '$2y$10$S3hlyvPKE.P/2wZPOf3HIejm57AF78W4JSvlCgZh9z5d4spjN/qLW', '', 'Secretary', '0724897142', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '179', NULL, NULL, 1, NULL),
(260, 'wawerud201@gmail.com', 'DUNCAN', 'WAWERU', '', '', '$2y$10$Bg8fiuNb.GLGBE.tVS2OU.rni9wcKhS8xRQtFNuO/WUGLlpd8YMM.', '', 'Sewerage Artisan', '0715169302', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '180', NULL, NULL, 1, NULL),
(261, 'shiromichire94@gmail.com', 'Hellen', 'wanjiru', '', '', '$2y$10$EcP/3mPzoMpP7fXqaHJF1ucSEltDI4QapcywFzpp6Ga8z7hPQqQ8O', '', 'Meter Reader', '0725828637', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '182', NULL, NULL, 1, NULL),
(262, 'suuwa36@gmail.com', 'Susan', 'Wanjiru', '', '', '$2y$10$bA0WbuG1F9itJ0rhuiyB5es5J8m3xzVNq17RKiVxpphui4AVf.Gyi', '', 'Meter Reader', '0727930908', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '183', NULL, NULL, 1, NULL),
(263, 'caleb.lacherry@gmail.com', 'JOE', 'CALEB', '', '', '$2y$10$7Nmov0HIHcMvb5./3PZXJeARj8JyQkL9rWj9hCQ5.KJf.nFqhnN9y', '', 'Asst. Customer Relations Officer', '0708880269', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '184', NULL, NULL, 1, NULL),
(264, 'mboteibrahim@gmail.com', 'IBRAHIM', 'MBOTE', '', '', '$2y$10$17sgzITb0VMls7J/7AzeWueYpr30kTgZlpGiGFEVSgb6/Y9eLZxBi', '', 'Technician', '0704615003', 'Murang`a', NULL, '2025-10-09 12:54:40', '2025-10-09 12:54:40', '185', NULL, NULL, 1, NULL),
(265, 'joannewaiyegothuo@gmail.com', 'Joan', 'Waiyego', '', '', '$2y$10$guLVWA7q1XR679hOKs9dUeh0qU1qBi1tdy7zqfHVZhXaSoXvw88wK', '', 'Water Production Operator', '0741720469', 'Murang`a', NULL, '2025-10-09 12:54:41', '2025-10-09 12:54:41', '186', NULL, NULL, 1, NULL),
(266, 'nancymuthoga1@gmail.com', 'Nancy', 'muthoga', '', 'female', '$2y$10$YIJGyklEJSK9mU0Xi2tudu9jrOXpfFEJtwTvPUT.w94K9Dy7evZ56', '', 'Meter Reader', '0714318975', 'Murang`a', NULL, '2025-10-09 12:54:41', '2025-10-15 12:07:00', '187', NULL, NULL, 1, '2025-10-15 12:06:46'),
(267, 'aggynorbert.an@gmail.com', 'AGNES', 'NJOKI', '', '', '$2y$10$Z4O1uqQnzZOMIjS.MmfGEeSIHErbfBTRG7TW9rETa51J3YwcbbC62', '', 'Debt Controller', '0720629363', 'Murang`a', NULL, '2025-10-09 12:54:41', '2025-10-09 12:54:41', '188', NULL, NULL, 1, NULL),
(268, 'nimohnjuguna8@gmail.com', 'Susan', 'Wairimu', '', '', '$2y$10$Piz1me90xXRcjW56CUiFLOrYBi3etqYxBLtBRio.3FZfHVfC6RRAi', '', 'Accountant', '0743207684', 'Murang`a', NULL, '2025-10-09 12:54:41', '2025-10-09 12:54:41', '189', NULL, NULL, 1, NULL),
(269, 'pleasantkangethe@gmail.com', 'Pleasant', 'Wanjiru', '', '', '$2y$10$eAxAEKwClDrEdjdx1EyCreHPZtMgMtZnkDh6EDPx88KFXPZnOBlWq', '', 'Customer Service Assistant', '0724566942', 'Murang`a', NULL, '2025-10-09 12:54:41', '2025-10-09 12:54:41', '191', NULL, NULL, 1, NULL),
(270, 'Stanleyngigi44@gmail.com', 'Stanley', 'mwangi', '', '', '$2y$10$N2LotVjwBA3ecHWj8cBi.OOx8DdlvYX05EI3o.zDlO.INzn6sPUQy', '', 'Technician', '0748835395', 'Murang`a', NULL, '2025-10-09 12:54:41', '2025-10-09 12:54:41', '192', NULL, NULL, 1, NULL),
(271, 'njoki6077@gmail.com', 'EUNICE', 'NJOKI', '', '', '$2y$10$WM3wAXsPWsrbUlYXdMD93efLiA1svIGgKplJg/Wh2a4EVTVS5B39W', '', 'Office Assistant', '0706902656', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-09 12:54:42', '193', NULL, NULL, 1, NULL),
(272, 'muthonimercy264@gmail.com', 'MERCY', 'Muthoni', '', 'female', '$2y$10$wopzrH4AeTxLEIuU7uK5cO9gjrk/U5tBzqkXXVHcTailuDeGAK39y', '', 'Customer Service Assistant', '0745439003', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-23 09:06:25', '195', NULL, NULL, 1, NULL),
(273, 'johnmwank440@gmail.com', 'John', 'Mwaniki', '', '', '$2y$10$HIFxTQfIcJq8YXI83pAiNOrFMWxJD.FXT1zIxfRvazZckjqHDR.Bi', '', 'Technician', '0705427918', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-09 12:54:42', '196', NULL, NULL, 1, NULL),
(274, 'antogoshen@gmail.com', 'Antony', 'Kangethe', '', '', '$2y$10$HjRBbvZ15Mm71E7PIZdd1OC1goIaUbsKNYZKKYZSnKvHzSe1M9lSq', '', 'Technician', '0705446430', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-09 12:54:42', '197', NULL, NULL, 1, NULL),
(275, 'godwinokumu2020@gmail.com', 'Godwin', 'mukhwana', '', '', '$2y$10$7/S1ZJbxgrC2PCZ/UPcVqOkh9NaoQUzjIqsTMohO2jdyislrsPvSO', '', 'Office Assistant', '0715843762', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-09 12:54:42', '198', NULL, NULL, 1, NULL),
(276, 'mainapetermwangi2017@gmail.com', 'Peter', 'Maina', '', 'male', '$2y$10$A39nrLErGWa8tJVziNLs0ezZyOWzhtAG/eB9/MqLGCbrDMzDFUGXi', '', 'ICT Officer', '0707454717', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-23 09:03:21', '199', NULL, NULL, 1, '2025-10-23 09:03:16'),
(277, 'stephenritho493@gmail.com', 'Stephen', 'ritho', '', '', '$2y$10$WlFqdVlcWJ9Lk6N6TpAfSe9AKC3JAoEeumcf6k3cazGxHFgQr4Bpm', '', 'Technician', '0759717848', 'Murang`a', NULL, '2025-10-09 12:54:42', '2025-10-09 12:54:42', '200', NULL, NULL, 1, NULL),
(278, 'stevekamau721@gmail.com', 'Stephen', 'kamau', '', '', '$2y$10$rqMHpksQgncR8AAlQKHSJeJmO.fDMvS6a4ulrGU0hTonTa6M90X2K', '', 'Technician', '0111378711', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-09 12:54:43', '201', NULL, NULL, 1, NULL),
(279, 'lillymuthoni13@gmail.com', 'LILLY', 'WAIRIMU', '', '', '$2y$10$aCKUVf0atRVUDG.K7egJ7eeqEcP1ygW4r9NUJbOPaMQzr07x6P/be', '', 'Meter Reader', '0716012540', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-09 12:54:43', '202', NULL, NULL, 1, NULL),
(280, 'kimaniedwin499@gmail.com', 'Edwin', 'Waithaka', '', '', '$2y$10$QIdVq/RcuTwpWtVZMaE/seUYcANwXXeliyEsXl8o.sko4MG8Aya8C', '', 'Technician', '0708725276', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-09 12:54:43', '203', NULL, NULL, 1, NULL),
(281, 'muhiumichael@gmail.com', 'Michael', 'Justus', '', '', '$2y$10$6e38LXdnoXtnlhOWiAi5Ee8TtaL.VgoY8PNA6ibCyuPa3Wc20Wh3O', '', 'NRW Officer', '0704205872', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-09 12:54:43', '204', NULL, NULL, 1, NULL),
(282, 'emilywanguiwahinya@gmail.com', 'Emily', 'Wangui', '', '', '$2y$10$THRCbsSUBkkbfqmwW7/2I.BWDvSFEFfAv.YrWzqUaphyqV2O5ZB0u', '', 'Asst. Pro poor Officer', '0796723421', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-09 12:54:43', '205', NULL, NULL, 1, NULL),
(283, 'wanderikelvin@gmail.com', 'KELVIN', 'KIHIA', '', '', '$2y$10$h7MhUZKH0RMsBuZmtVceB.dI5XpXA7ZA6xZmyrPQXSF2YNgrghd2i', '', 'Water Production Officer', '0741781567', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-09 12:54:43', '206', NULL, NULL, 1, NULL),
(284, 'kangarajosephine@gmail.com', 'kangara', 'Josephine', '', 'female', '$2y$10$pmphaGdHegJhTvUSfwbJVuIaxaUL0zQ9rtYtgIMVMapsArpsJgeuC', 'section_head', 'Asst. Monitoring & Evaluation Officer', '0746984430', 'Murang`a', NULL, '2025-10-09 12:54:43', '2025-10-23 13:59:52', '207', 'f6f81047a355bf82f1fa957caea6a27e1d06110b3a19c06a40c0b8b9601519a0', 'f9362ac3788ce9190095d1e80e642c26f418abaf4ba30383f0541178888d54b9', 1, '2025-10-23 13:59:52'),
(285, 'moseswawerukamau@gmail.com', 'Moses', 'Kamau', '', '', '$2y$10$NBUfHqBNHNPF3tSn.CfCP.5QXxweuzP1crZjTzDbUearfyl.4UtT6', '', 'Technician', '0741932039', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '208', NULL, NULL, 1, NULL),
(286, 'mugechikimari@gmail.com', 'Florence', 'Mugechi', '', '', '$2y$10$ME6drzlfIFtJfhRdJ3fOcupz3jKtzYNeIgL56ppeQRkMRhwH7izrm', '', 'Environment Officer', '0716117261', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '209', NULL, NULL, 1, NULL),
(287, 'raymondmuiruri8@gmail.com', 'Gatama', 'Raymond', '', '', '$2y$10$Hz.acROcFToR5MgvuPPwHe1VliEU55QUK/mo6P669DKejqarj6z3q', '', 'Environment Officer', '0758836259', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '210', NULL, NULL, 1, NULL),
(288, 'smurigivins@gmail.com', 'Samuel', 'Mungai', '', '', '$2y$10$tbdYuEwW.2NEJmz71NQIguz/VDRByWA.RcLg6MIJxOe/Boe0i0uqq', '', 'Internal Auditor', '0720122639', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '211', NULL, NULL, 1, NULL),
(289, 'moureenwanjikunjoroge@gmail.com', 'MOUREEN', 'WANJIKU', '', '', '$2y$10$ryh/RD1H5BFcY65gFPj3e.7WtOFTxR3Oz1a7uNrUY8RkdoN4EfvOu', '', 'Enforcement Officer', '0702831791', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '212', NULL, NULL, 1, NULL),
(290, 'williamwawerunjeri@gmail.com', 'William', 'Waweru', '', '', '$2y$10$CuT7.Kyw/utMgX664HyjJ.jrIHaoFoMNgL0sxzxeItxPW9MbofuvG', '', 'Revenue Officer', '0702310554', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '213', NULL, NULL, 1, NULL),
(291, 'murigibeatrice091@gmail.com', 'BEATRICE', 'WANJIKU', '', '', '$2y$10$NWHbFo.U4NDm9D8hC7qppuTJkAQ8wPSdcdFYfD2f48e1M8VuXFUBG', '', 'Office Assistant', '0701138593', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '214', NULL, NULL, 1, NULL),
(292, 'salokiesheeqow@gmail.com', 'Salome', 'Wanjiku', '', '', '$2y$10$wrc2WB5gAZGu.Gf1Bksza.xMXolC/ZIjHboJAyXauWEi7KGxM5A0O', '', 'Office Assistant', '0759338378', 'Murang`a', NULL, '2025-10-09 12:54:44', '2025-10-09 12:54:44', '215', NULL, NULL, 1, NULL),
(293, 'shelmithmugure21@gmail.com', 'Shelmith', 'mugure', '', '', '$2y$10$4fuZpMnfQBGa4XJjN.7Dv.NLId7dOSLqHjhTXdlXMsTDshy4fTMCq', '', 'Human Resource Officer', '0700472246', 'Murang`a', NULL, '2025-10-09 12:54:45', '2025-10-09 12:54:45', '216', NULL, NULL, 1, NULL),
(294, 'mukamigichere@gmail.com', 'Dorcas', 'Mukami', '', 'male', '$2y$10$tBfk9Oyu2V3pCQFNKjUMM.d38s6nBPM1swc7bce4N6CeqP36DJete', 'hr_manager', 'Administration Officer', '0727497706', 'Murang`a', NULL, '2025-10-09 12:54:45', '2025-10-15 08:22:57', '217', NULL, NULL, 1, NULL),
(295, 'moseskamandekamau@gmail.com', 'Moses', 'Kamande', '', '', '$2y$10$a7D5/smImTh8.gpOztG3Z.PP88sGD51rrof3fpIKq2j.CkDJlIiVK', '', 'Meter Reader', '0748094260', 'Murang`a', NULL, '2025-10-09 12:54:45', '2025-10-09 12:54:45', '219', NULL, NULL, 1, NULL),
(296, 'mwangigerald216@gmail.com', 'Gerald', 'Nganga', '', '', '$2y$10$laRz23i4qjG5F1fyCICD5eZuvpJ0k1ruXS1XZbeeCjfW.iq.ienNu', '', 'Office Assistant', '0701070882', 'Murang`a', NULL, '2025-10-09 12:54:45', '2025-10-09 12:54:45', '221', NULL, NULL, 1, NULL),
(297, 'Peterthomipeter9@gmail.com', 'Peter', 'Kimani', '', '', '$2y$10$D3VnQ3ClSw6ZKW7O13krbuoJj2FlawmX7kG4ROGUwQ5E5cQol0nHa', '', 'Technician', '0711968470', 'Murang`a', NULL, '2025-10-09 12:54:45', '2025-10-09 12:54:45', '222', NULL, NULL, 1, NULL),
(298, 'mwangimorgan369@gmail.com', 'Njuguna', 'Morgan', '', '', '$2y$10$lO6Vq4YcsYoBUSNQUO2wr.cwLCIevT.In4xcmbgW3gupCpBpf/o9u', '', 'Technician', '0748763664', 'Murang`a', NULL, '2025-10-09 12:54:46', '2025-10-09 12:54:46', '223', NULL, NULL, 1, NULL),
(299, 'ksuwairimu424@gmail.com', 'Susan', 'Wairimu', '', '', '$2y$10$8l.k/7MD1c2KUfReFcLDXeM5rvH8N0aVPXHn1tCAZKZfQkbMHfY0W', '', 'Revenue Officer', '0791557495', 'Murang`a', NULL, '2025-10-09 12:54:46', '2025-10-09 12:54:46', '224', NULL, NULL, 1, NULL),
(300, 'hezmutharu@gmail.com', 'Hezron', 'Njoroge', '', 'male', '$2y$10$jtH069DOFTzy9r/0TF8VtOD8zg92o2rp0QE4kqXu7O0SNrmKotNT.', 'dept_head', 'Asst. ICT Officer', '0713606709', 'Murang`a', NULL, '2025-10-09 12:54:46', '2025-10-23 13:58:14', '225', NULL, NULL, 1, '2025-10-23 13:58:12'),
(301, 'wanjikuconny@gmail.com', 'CONNIE', 'WANJIKU', '', '', '$2y$10$ggt3SX79DitiMbYjk0.//OlD4UmeO7Kvv6DL3220bCHxHl9uu1z/K', '', 'Procurement Officer', '0710251734', 'Murang`a', NULL, '2025-10-09 12:54:46', '2025-10-09 12:54:46', '226', NULL, NULL, 1, NULL),
(302, 'wamburufaith@gmail.com', 'Faith', 'Nunga', '', '', '$2y$10$lz0UgwHHtRKYOeCCo91GSu460Vb8DgYhT6groM/5B72M54wwBtFEW', '', 'Meter Reader', '0111276150', 'Murang`a', NULL, '2025-10-09 12:54:46', '2025-10-09 12:54:46', '227', NULL, NULL, 1, NULL),
(303, 'ben796756@gmail.com', 'Caroline', 'wanjira', '', '', '$2y$10$3VTMKNHrhjlP0IeS3Et16u94OuwPe4WhEoOHrZU7lQputIl9JmQUi', '', 'Meter Reader', '0720651524', 'Murang`a', NULL, '2025-10-09 12:54:46', '2025-10-09 12:54:46', '228', NULL, NULL, 1, NULL),
(304, 'kelvinandrewkariuki@gmail.com', 'Kelvin', 'kariuki', '', '', '$2y$10$qEcQ4B17qmMQ5oloYeXfCecWlxxBdeUy4DcrqwWfyne0jL1AM5P/K', '', 'Technician', '0745016519', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 12:54:47', '229', NULL, NULL, 1, NULL),
(305, 'wambugupatrick88@gmail.com', 'Patrick', 'Mwaniki', '', '', '$2y$10$H368qgt4evcWDIbQ1fUMvOqGbVb1vaiqhq9mi0YFpN6IPrFJSPa9i', '', 'Driver', '0711226687', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 12:54:47', '231', NULL, NULL, 1, NULL),
(306, 'marykahara@gmail.com', 'Mary', 'Nyambura', '', '', '$2y$10$D7xe4/pnvFxbnkYFZoQzAuwkTQ.qwwrLa6C/LpI.u1jH4P4gTsU0C', '', 'Asst. Procurement Officer', '0721880882', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 12:54:47', '232', NULL, NULL, 1, NULL),
(307, 'alphalamyna@gmail.com', 'MAINA', 'ALEX', '', 'male', '$2y$10$x2o2qB30YBkJTbRc3iNxzOUgf1GPjbk7ckcIQPP/osAeeAXVTjc8S', 'officer', 'Water Inspector', '0720593975', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 13:23:25', '233', NULL, NULL, 1, NULL),
(308, 'winrosemuthoninjai@gmail.com', 'Winrose', 'Muthoni', '', '', '$2y$10$OHK2YIoxt2SHQ2JZM7enyulP7HjEgbZAebEDaeSl/QFHaWRNnRMr2', '', 'Office Assistant', '0701304940', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 12:54:47', '234', NULL, NULL, 1, NULL),
(309, 'manasekimari254@gmail.com', 'Manase', 'Kimari', '', '', '$2y$10$ueSuLY5DA89hWmvHGtRqM.BloPiDgXnqsPCLCw8H/CpPH4flxekr.', '', 'Asst. Accountant', '0791064285', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 12:54:47', '235', NULL, NULL, 1, NULL),
(310, 'munyakajoanne@gmail.com', 'Joan', 'Njeri', '', '', '$2y$10$SpWMeq2FbXuGRINqLv4BGuHWWZqXMVpABvbX/zVLI7d0/GFau9Rj2', '', 'Office Assistant', '0726246236', 'Murang`a', NULL, '2025-10-09 12:54:47', '2025-10-09 12:54:47', '237', NULL, NULL, 1, NULL),
(311, 'virginiawangai579@gmail.com', 'Virginia', 'wanjiku', '', '', '$2y$10$t7fS7czgmIHLHPBkG6TJVeeYAPi6oMuOvi7M9xC1iMUVSsSPbgnx2', '', 'Driver', '0721638937', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-09 12:54:48', '86044155', NULL, NULL, 1, NULL),
(312, 'philoo208@gmail.com', 'PHILOMENA', 'WANJIRU', '', 'female', '$2y$10$WrSp8a0L/4rlMD6KcrPy0eVdXdyY/JO3Mp38FS.w2Q0XubAZnCaWC', 'hr_manager', 'Asst. Human Resource Manager', '0720823265', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-23 13:21:34', '1991001489', NULL, NULL, 1, '2025-10-23 13:21:31'),
(313, 'keithnjuguna01@gmail.com', 'KEITH', 'NJUGUNA', '', '', '$2y$10$m86k5v0PC01525piccC3o.x5EfORSPlSJgIF/cJ2lEYuAiSEkVsiC', '', 'Office Assistant', '0795096315', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-09 12:54:48', '000', NULL, NULL, 1, NULL),
(314, 'siphirahwairimu@yahoo.com', 'Siphira', 'wairimu', '', '', '$2y$10$MNYmVTRF1XzQxvH0uTYgROjsT4YYJZZ3ncxCJupak8Fr9obRpveAy', '', 'Asst. Commercial Manager (Finance)', '0727316130', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-09 12:54:48', '001', NULL, NULL, 1, NULL),
(315, 'kamandecarol@gmail.com', 'CAROLINE', 'WAITHIRA', '', '', '$2y$10$QKAYohzKIFHyNWRspI027OlqmPbMEVnEPR.5.Mjd9YwbipW4TRgTS', '', 'Customer Relations Officer', '0724776490', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-09 12:54:48', '008', NULL, NULL, 1, NULL),
(316, 'jwambuikinuthia@yahoo.com', 'Josephine', 'Wambui', '', '', '$2y$10$WJlqizUb1UEB8RLGCssgIO.AqsmIxIqBCTEib3GLVZg00zZw5QpHS', '', 'Asst. Commercial Manager (Revenue)', '0726230995', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-09 12:54:48', '018', NULL, NULL, 1, NULL),
(317, 'joymwihaki@gmail.com', 'Joyce', 'Wainaina', '', 'female', '$2y$10$Bcj3Ir0ImI4SrvCftJZ6x.ZlZc0zb07INCnel3F/tXB5k7pdqUnjG', 'section_head', 'Snr. ICT Officer', '0725355372', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-15 07:23:51', '019', NULL, NULL, 1, NULL),
(318, 'gichuhielias@gmail.com', 'Elias', 'Ekutu', '', '', '$2y$10$ioNT9QfTHijCBpdCYWJOHuoKZLdZzmrNxzfrRO0QVSzTG9YJVtGyq', '', 'Water Production Operator', '0725348008', 'Murang`a', NULL, '2025-10-09 12:54:48', '2025-10-09 12:54:48', '020', NULL, NULL, 1, NULL),
(319, 'kajorchy@gmail.com', 'Joram', 'Chege', '', '', '$2y$10$Gy0E9gBwcZgZ6xU3JDAQ3esRbVq0c9UidglLfe.rldBJSJtJE8G7C', '', 'Technician', '0722864174', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '021', NULL, NULL, 1, NULL),
(320, 'githiakajulius@gmail.com', 'Mwangi', 'Julius', '', '', '$2y$10$QfGWbMtBGK1DHJbRMxZlK.dpxANk6BFFMAZ259WfVxvCZJcy1D1de', '', 'Technician', '0716038790', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '022', NULL, NULL, 1, NULL),
(321, 'juliatony2030@gmail.com', 'Julia', 'Waithira', '', '', '$2y$10$QweM.CfAZV2m4FqfOlOrrOT5/RUFvLsfJAHlnCdUomKOxrXhGCZQu', '', 'Quality Assurance Officer', '0721401068', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '023', NULL, NULL, 1, NULL),
(322, 'pruje@yahoo.com', 'Patrick', 'Munga', '', '', '$2y$10$bv.6lK6c8c4wvCiLC6VpWOfiu/b19fukiQkIKa48qqgvylkRif/vW', '', 'Internal Audit Manager', '0724458019', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '026', NULL, NULL, 1, NULL),
(323, 'bettywanja24@yahoo.com', 'Beatrice', 'Wanja', '', '', '$2y$10$cTvCKmh7YeFy1mthu8Uy/eojNxjnPvCyG0.BaXrmrJAhm6hi4e0M2', '', 'Revenue Officer', '0726656222', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '028', NULL, NULL, 1, NULL),
(324, 'paulinewairimuwanjiru13@gmail.com', 'Pauline', 'Wairimu', '', '', '$2y$10$V3dCeN9/b7IYrMmNx6Mv3ejv.FQ9oemjDyCo6UrU.YVyBTg50tXcS', '', 'Meter Reader', '0725861554', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '029', NULL, NULL, 1, NULL),
(325, 'johnkiai79@gmail.com', 'John', 'Kiai', '', '', '$2y$10$Zym1iXZ280vNxZ9IoAR0G.uQWi4LMfOHD1794uJ/3gZP5.HXbUzdm', '', 'Technician', '0725518986', 'Murang`a', NULL, '2025-10-09 12:54:49', '2025-10-09 12:54:49', '030', NULL, NULL, 1, NULL),
(326, 'gearkim06@gmail.com', 'Gerald', 'Kamau', '', '', '$2y$10$XCcBues06xCMKPbW7PMohOTJrUrpPmZg4cO1hbUWCH3OZQmFDK7M2', '', 'Accountant', '0725903893', 'Murang`a', NULL, '2025-10-09 12:54:50', '2025-10-09 12:54:50', '032', NULL, NULL, 1, NULL),
(327, 'njokicecilia@gmail.com', 'Cecilia', 'Njoki', '', 'female', '$2y$10$iSzUbIx851UbcXgrPyLowOPrZXd2L..FsmvoDcd3BOn5qyAdWRpl.', 'sub_section_head', 'Revenue Officer', '0717463504', 'Murang`a', NULL, '2025-10-09 12:54:50', '2025-10-23 09:03:45', '034', NULL, NULL, 1, '2025-10-23 09:03:42'),
(328, 'christinenjogu87@gmail.com', 'CHRISTINE', 'WANJIKU', '', 'female', '$2y$10$G1zbPJSc5zkOn7180nNpaer0waRj0iH..ktN0TRAs7Vxo3X3B6mv.', 'officer', 'Customer Service Assistant', '0725951329', 'Murang`a', NULL, '2025-10-09 12:54:50', '2025-10-09 13:42:24', '035', NULL, NULL, 1, NULL),
(329, 'rosekahara5@gmail.com', 'Rose', 'Muthoni', '', '', '$2y$10$EHo55AcLRbbwDeFLcTh5ee8m9EbJpiEyD8BkwY3jEbVFSjFIXRvu6', '', 'Revenue Officer', '0708683017', 'Murang`a', NULL, '2025-10-09 12:54:50', '2025-10-09 12:54:50', '036', NULL, NULL, 1, NULL),
(330, 'lillianmaina51@gmail.com', 'Lilian', 'Wanjiru', '', 'female', '$2y$10$oge3oZpK1bqyF.Uo4PYSwOQZX212wrmQKtDhkSZPZKsyNedHu8btK', 'manager', 'Monitoring & Evaluation Manager', '0722165154', 'Murang`a', NULL, '2025-10-09 12:54:50', '2025-10-15 07:48:12', '040', NULL, NULL, 1, NULL),
(331, 'wanderi.pithon@gmail.com', 'Pithon', 'wanderi', '', '', '$2y$10$VkzCviV3FdQU8J/I2gWuyO8e1afM8hsnz7RgZ/dgdNagYnF2MPn7q', '', 'Debt Controller', '0720627123', 'Murang`a', NULL, '2025-10-09 12:54:50', '2025-10-09 12:54:50', '041', NULL, NULL, 1, NULL),
(332, 'kaiganirajohn@yahoo.com', 'John', 'Kaiganira', '', '', '$2y$10$jveHgmMDmy9fPcSXCrFy8epGl4dEO4HbQsCeWqGCVO5J6TtotMOpW', '', 'Assistant Auditor', '0724481550', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '042', NULL, NULL, 1, NULL),
(333, 'ngangapeter827@gmail.com', 'Peter', 'Ng\'ang\'a', '', '', '$2y$10$XV3VypLpy2dMn44RIe7jm.RJMfgdOx8ntpeRuYr6I7wOaU4WveEM.', '', 'Water Production Operator', '0716346948', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '043', NULL, NULL, 1, NULL),
(334, 'mirungufrancis@gmail.com', 'Francis', 'I.', '', '', '$2y$10$9Z1xlGOCA97qZFBUIoRR4.peFFXjQ5BTh6i1u/wVrsVkdV9/kPS76', '', 'Asst. Technical Manager', '0728071619 or 0112 0', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '046', NULL, NULL, 1, NULL),
(335, 'nicyk254@gmail.com', 'Nancy', 'kabura', '', '', '$2y$10$KtuhGAiUq2WIB28TwLopNOTkuKiIwg2w.1Q7MVQs0TdhR9G59o0Bq', '', 'Accountant', '0726082287', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '050', NULL, NULL, 1, NULL),
(336, 'karaniantony@gmail.com', 'ANTONY', 'KARANI', '', '', '$2y$10$F.4cfW9WirVB1Ek1wfT2zek0rJpAV9yceGBD.jaUBVJhTg3XmYnES', '', 'Region Officer', '0718816853', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '051', NULL, NULL, 1, NULL),
(337, 'joskaranja50@gmail.com', 'Joseph', 'karanja', '', '', '$2y$10$rxkAWM0ZVV6mzWzTcHTNPOvbILc0GMz1ij6.GWfdlSJkQ6Xm5/PIe', '', 'Technician', '0711405587', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '053', NULL, NULL, 1, NULL),
(338, 'johnchegemacharia75@gmail.com', 'John', 'Chege', '', '', '$2y$10$omC3O0wQie7l8Dz7vJZDxOfycT3bOxWY8Y.Bxap.xOwm1AL6MmjmS', '', 'Technician', '0721915093', 'Murang`a', NULL, '2025-10-09 12:54:51', '2025-10-09 12:54:51', '054', NULL, NULL, 1, NULL),
(339, 'jimmybrown.jm@gmail.com', 'JAMES', 'MAINA', '', '', '$2y$10$JP7GpEWBX6F.naJx7ivG1Oivo5tSOErcFa.4JikiyD2glrpMha.2a', '', 'Region Officer', '0725994507', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-09 12:54:52', '055', NULL, NULL, 1, NULL),
(340, 'davidthugu@gmail.com', 'DAVID', 'IRUNGU', '', 'male', '$2y$10$liRU64G5svOOFHItbKcwMewocTV3Z71IgrRk2L.8oquNlY7swczKu', 'section_head', 'Asst. Commercial Manager ( Revenue)', '0711870625', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-16 13:03:41', '056', NULL, NULL, 1, '2025-10-16 13:03:37'),
(341, 'estherwanjiru482@gmail.com', 'Esther', 'wanjiru', '', '', '$2y$10$Aa./Khww6y1d/qq9UwnRqOzudXsuy/RPUb..ETcKRrbOlMV0bcGNG', '', 'Driver', '0721377931', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-09 12:54:52', '057', NULL, NULL, 1, NULL),
(342, 'jacobmbuthia@yahoo.com', 'Jacob', 'Mbuthia', '', '', '$2y$10$Wgxby9tv/gdgbVcmqOFOdeObHQ7DV4OLhc.u9JtAPDWgclC0AJVN.', '', 'Corporate Affairs Manager', '0715038398', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-09 12:54:52', '058', NULL, NULL, 1, NULL),
(343, 'gwanjirii@gmail.com', 'Grace', 'wainaina', '', '', '$2y$10$BuXauhhotQ8OLXBS8Bw3M.mqu3OUKVDbKCnXsFdJsKKDEzeCesote', '', 'Technician', '0725559431', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-09 12:54:52', '059', NULL, NULL, 1, NULL),
(344, 'wanguichristopher32@gmail.com', 'Christopher', 'Mwangi', '', '', '$2y$10$eZkMzlqYcp6kNnfu3IPL5ugdUHYB0vVO5DIaI72hK6V0gIeaF8/TS', '', 'NRW Manager', '0764 446781', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-09 12:54:52', '062', NULL, NULL, 1, NULL),
(345, 'gidraphngumba@gmail.com', 'Gidraph', 'Ngumba', '', '', '$2y$10$roIAjOdJZJY9mmmyEaSxu.KJeybWYFHnrACR7lI7ky4MxQm7cunj6', '', 'Technician', '0712647026', 'Murang`a', NULL, '2025-10-09 12:54:52', '2025-10-09 12:54:52', '063', NULL, NULL, 1, NULL),
(346, 'francismwangi261@gmail.com', 'Francis', 'Ndung\'u', '', '', '$2y$10$o1H6l4z9OmRhkVNpTFKCw.JAlBSBJw.c7agU67B3BdDrxne1AhySq', '', 'Sewerage Artisan', '0720118840', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '064', NULL, NULL, 1, NULL),
(347, 'janendugire2015@gmail.com', 'JANE', 'WANJIKU', '', '', '$2y$10$fa/rzEau/vOD4yKnnLuv9uooeMbJm6f9ZKyf777Ly3qzGhjhMsml.', '', 'Customer Service Assistant', '0712058650', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '065', NULL, NULL, 1, NULL),
(348, 'mevinmaina@gmail.com', 'RAHAB', 'MURINGI', '', '', '$2y$10$zTST7GfTKJda5jvdNXZwEevb1iDD3GyZW9gGfT0y6lnMXWYUgK5B.', '', 'Technician', '0710433367', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '068', NULL, NULL, 1, NULL),
(349, 'amuchina88@gmail.com', 'Aaron', 'Maina', '', '', '$2y$10$iTzkbGGaCuQ.JwvOcIKbr..xFsxaf7x3ce0e1IcHyk6HjystDkyN6', '', 'GIS Officer', '0728110465', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '072', NULL, NULL, 1, NULL),
(350, 'evansonkinyua@yahoo.com', 'Evans', 'Gitari', '', '', '$2y$10$ZPVOn5nwp.jbLxcSPwcSpu/amfo8vyz2ivVmYiQ9UnyBT72c/sDcy', '', 'Asst. Accountant', '0726390559', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '073', NULL, NULL, 1, NULL),
(351, 'saweriamelia@gmail.com', 'Saweria', 'muthoni', '', '', '$2y$10$aGFOG1N8ANATJDA5yIVWiOwxHWD19lFZhkUaVorSGWymRRC2bqc16', '', 'Water Production Operator', '0725456988', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '077', NULL, NULL, 1, NULL),
(352, 'josetycoon@gmail.com', 'JOSEPH', 'KINYUA', '', '', '$2y$10$qN2TpfpcYo5IcukbYY/mmOTaQFee7cGKCMVWwb0c9JShjqXDesgJe', '', 'ICT Officer', '0715562816', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '078', NULL, NULL, 1, NULL),
(353, 'vicjas009@gmail.com', 'Florence', 'waithera', '', '', '$2y$10$UKbWKcI06p3QkvsKJByaAOQmWuwR3.A.zwc18AO7yjT8mdjmWtw6C', '', 'Meter Reader', '0727537600', 'Murang`a', NULL, '2025-10-09 12:54:53', '2025-10-09 12:54:53', '079', NULL, NULL, 1, NULL),
(354, 'bernardkiharakamau@gmail.com', 'Bernard', 'Kihara', '', '', '$2y$10$q86psb8VDPXs97v8WxcXYeu20WgZst4obBjaDTYe82Q3MTiHXBQEm', '', 'Region Officer', '0726224387', 'Murang`a', NULL, '2025-10-09 12:54:54', '2025-10-09 12:54:54', '081', NULL, NULL, 1, NULL),
(355, 'kdavepaul42@gmail.com', 'DAVID', 'KIMANI', '', '', '$2y$10$SJcTcKccMpkYMnG9RTqIQOZy8xYEteQsPYGqhZKDWdu9SVzqzC.ay', '', 'Technician', '0702579481', 'Murang`a', NULL, '2025-10-09 12:54:54', '2025-10-09 12:54:54', '083', NULL, NULL, 1, NULL),
(356, 'nephatmaina20@gmail.com', 'Nephat', 'Mûchoki', '', '', '$2y$10$6UKvJZclqVSdR0a0H9Tzv.9/rV9df7jJp3kfA62ycq2VpCrDOejDy', '', 'Technician', '0725619878', 'Murang`a', NULL, '2025-10-09 12:54:54', '2025-10-09 12:54:54', '084', NULL, NULL, 1, NULL),
(357, 'mwangipeter155@gmail.com', 'PETER', 'KARIUKI', '', '', '$2y$10$u.IbRSZ9vrkxWKW.WO96ZuGZOSGsroghYW6ricywm6TAfnzovgbga', '', 'Technician', '0720398637', 'Murang`a', NULL, '2025-10-09 12:54:54', '2025-10-09 12:54:54', '085', NULL, NULL, 1, NULL),
(358, 'machariaken86@gmail.com', 'Kenneth', 'Githumbi', '', '', '$2y$10$LfvGaeaA3pWPf1TendjjaepUf9pnCs4W9SVYW4tgwUuHEhZLCmEK2', '', 'Technician', '0728260908', 'Murang`a', NULL, '2025-10-09 12:54:54', '2025-10-09 12:54:54', '086', NULL, NULL, 1, NULL),
(359, 'wariedwin20@gmail.com', 'Edwin', 'Wari', '', '', '$2y$10$7TfibobE1eay7wemuz98sO3mQEB4fwYk0Cu3hcuxPTTnmEJqr4mw6', '', 'Technician', '0708534511', 'Murang`a', NULL, '2025-10-09 12:54:54', '2025-10-09 12:54:54', '087', NULL, NULL, 1, NULL),
(360, 'gichukic70@gmail.com', 'Charles', 'Waweru', '', '', '$2y$10$cjlCOOLU1UDHRlPQMlC.MOeC0Oc/Mq2XhlYlJky0IA8bGQ0.M8OGC', '', 'Sewerage Artisan', '0795931676', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-09 12:54:55', '090', NULL, NULL, 1, NULL),
(361, 'maryndirangu132@gmail.com', 'Mary', 'Ndirangu', '', '', '$2y$10$p0qJWw7g92QW8omiFRxJ9eMgFkrC8DlJWiwDA6NQNn0xUTxMhY.XG', '', 'Water Production Officer', '0717524190', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-09 12:54:55', '091', NULL, NULL, 1, NULL),
(362, 'didmusmwangi@gmail.com', 'Didmus', 'Mwangi', '', '', '$2y$10$AO9KR.jblijSb1Tu0ASYnuJ.r5R/Em8k2gc48vYgdpkhpt4RpYP6a', '', 'Chemical Attendant', '0727146946', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-09 12:54:55', '094', NULL, NULL, 1, NULL),
(363, 'jmkanda2016@gmail.com', 'James', 'Mwangi', '', '', '$2y$10$5jiGai80ds9wfqxlk2g72ue88fEO4djRHS5VBPXrzVIbINBc9CfIu', '', 'Water Inspector', '0723052124', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-09 12:54:55', '096', NULL, NULL, 1, NULL),
(364, 'gitau67@gmail.com', 'Antony', 'Gitau', '', '', '$2y$10$3EJDxSFNaS.oy2k1APDVdeX0XlFW4BhiN7KUwsePl0.Me/Cwqj9CS', '', 'Intake Attendant', '0720220935', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-09 12:54:55', '097', NULL, NULL, 1, NULL),
(365, 'btshish@gmail.com', 'Beatrice', 'wanjiru', '', '', '$2y$10$0z9WcUaaQQ5DogleIvPRteHDGlwnyIlxCPocLJqWdDMgto3zxzJSm', '', 'Customer Service Assistant', '0708686083', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-09 12:54:55', '099', NULL, NULL, 1, NULL),
(366, 'Kimahmahh@gmail.com', 'NG\'ANG\'A', 'Daniel', '', 'male', '$2y$10$q9Zh9QG1tbFgmhjE1SuVtOmOp5HRte2e2EyNh6BNLerUuSXqiYY3q', 'managing_director', 'Managing Director', '0721626795', 'Murang`a', NULL, '2025-10-09 12:54:55', '2025-10-15 11:20:19', '20 001', NULL, NULL, 1, '2025-10-15 09:51:38'),
(367, 'pmkarenju@gmail.com', 'Peter', 'Mwangi', '', '', '$2y$10$rfSbgALi3CxM1GHAWb8D7OOxSVFm5tH1J40rt7lQBzxiAnlQ3AZMi', '', 'Technical Services Manager', '0722664121', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-09 12:54:56', '200003', NULL, NULL, 1, NULL),
(368, 'bcmutai88@yahoo.com', 'Joseph', 'Maina', '', 'male', '$2y$10$LyhqHqtP56y5tL.Wjx7KROS0.GnXJmpoQ5DWJaT3ZVgcTJOP3/ory', 'dept_head', 'Commercial Manager', '0721107436', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-16 13:05:43', '20002', NULL, NULL, 1, '2025-10-16 13:05:17'),
(369, 'jvngugi66@mail.com', 'Julius', 'chomba', '', '', '$2y$10$QhQriB2aJq.pGofoURORzO/GGnHLrQE4L9HEfJ7/7MKULb63ZbeUu', '', 'Water Production Operator', '0727495927', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-09 12:54:56', 'Mow 05', NULL, NULL, 1, NULL),
(370, 's.k.mbugua58@gmail.com', 'Stephen', 'k', '', '', '$2y$10$pRfZloOSXq0hbhzrzGOazOwxtB558t1ZOyg2Qe0G7Ni/gImiQ3kI2', '', 'Technician', '0729693470', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-09 12:54:56', 'MOW07', NULL, NULL, 1, NULL),
(371, 'smuriathi@gmail.com', 'Samuel', 'kamau', '', '', '$2y$10$dNmlRQ0pXsMjFEua7cmH8uJ.6UYioJOwG/21qQtsWYm67yTq0YhrK', '', 'Driver', '0721974813', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-09 12:54:56', 'Mow08', NULL, NULL, 1, NULL),
(372, 'Stephenkiiru394@gmail.com', 'Stephen', 'kariuki', '', '', '$2y$10$FxturyXLCbcZ3TzaETW9RullMCk4yB8ftzoRySGsFi7F.Ibh1/3Pm', '', 'Technician', '0720437122', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-09 12:54:56', 'MOW12', NULL, NULL, 1, NULL),
(373, 'simongitaujohn@gmail.com', 'Simon', 'Gitau', '', '', '$2y$10$memVT7o5lvIgeSsukYIT6eyxrW0Jb9xqmEmzKM/2/cnX259K/6uni', '', 'Office Assistant', '746757028', 'Murang`a', NULL, '2025-10-09 12:54:56', '2025-10-09 12:54:56', '194', NULL, NULL, 1, NULL),
(374, 'kelvinmuturi2019@gmail.com', 'Kelvin', 'Kariuki', '', '', '$2y$10$ifosNyyJ3ellIIvWUt1D7e0UYnfyzjmLZAd45Ri3dwAVunJVM5zn2', '', '', '708836689', 'Murang`a', NULL, '2025-10-09 12:54:57', '2025-10-09 12:54:57', '190', NULL, NULL, 1, NULL),
(375, 'mukuriasamuel478@gmail.com', 'SAMUEL', 'MUKURIA', '', '', '$2y$10$t0ChtFiiYPQkSfJrdOk21utWU7/j2Oq0iNw3du/hwPlBESuvEw7c6', '', 'Technician', '704857189', 'Murang`a', NULL, '2025-10-09 12:54:57', '2025-10-14 11:00:36', '236', NULL, NULL, 1, '2025-10-14 11:00:32'),
(376, 'skibue546@gmail.com', 'Stephen', 'Kibue', '', '', '$2y$10$vZSp9ndjHgaggikD1bXgUuhxpaD9.T8slh14.fD0w7Nqnbgwvz4wO', '', 'Meter Reader', '754152140', 'Murang`a', NULL, '2025-10-09 12:54:57', '2025-10-09 12:54:57', '44', NULL, NULL, 1, NULL),
(377, 'skaranja700@gmail.com', 'Simon', 'Karanja', '', 'male', '$2y$10$GW8g36DMCjdJLH2QT5LRpeSfB/dUxbzRYguATadyLRXXjrjfT7tAG', 'super_admin', 'Technician', '723142964', 'Murang`a', NULL, '2025-10-09 12:54:58', '2025-10-16 06:52:56', '116', NULL, NULL, 1, '2025-10-16 06:52:46'),
(378, 'mburupeter1000@gmail.com', 'Peter', 'Mburu', '', 'male', '$2y$10$onrZguIiRFR5NDqkHa6.Qe8pAc8VgFh2REecLTvbfGMpqIooSgfaS', '', 'Technician', '704919059', 'Murang`a', NULL, '2025-10-09 12:54:58', '2025-10-09 13:55:29', '52', NULL, NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_consents`
--

CREATE TABLE `user_consents` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `national_id` varchar(100) NOT NULL,
  `consent_given` tinyint(1) DEFAULT 1,
  `consent_date` datetime NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores employee data protection consent records';

--
-- Dumping data for table `user_consents`
--

INSERT INTO `user_consents` (`id`, `user_id`, `full_name`, `national_id`, `consent_given`, `consent_date`, `ip_address`, `user_agent`, `created_at`, `updated_at`) VALUES
(1, 312, 'PHILOMENA WANJIRU', '35903017', 1, '2025-10-13 16:50:39', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 13:50:39', '2025-10-13 13:50:39'),
(2, 258, 'Stephen Mwangi', '36363636', 1, '2025-10-13 16:51:53', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-13 13:51:53', '2025-10-13 13:51:53'),
(3, 366, 'NG\'ANG\'A Daniel', '674489395', 1, '2025-10-14 10:16:48', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:143.0) Gecko/20100101 Firefox/143.0', '2025-10-14 07:16:48', '2025-10-14 07:16:48'),
(4, 375, 'SAMUEL MUKURIA', '6875674456', 1, '2025-10-14 13:59:24', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 10:59:24', '2025-10-14 10:59:24'),
(5, 327, 'Cecilia Njoki', '6875674456', 1, '2025-10-14 14:03:41', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-14 11:03:41', '2025-10-14 11:03:41'),
(6, 284, 'kangara Josephine', '2147483647', 1, '2025-10-15 09:22:33', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 06:22:33', '2025-10-15 06:22:33'),
(7, 377, 'Simon Karanja', '5779896', 1, '2025-10-15 11:18:50', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 08:18:50', '2025-10-15 08:18:50'),
(8, 276, 'Peter Maina', '658585654', 1, '2025-10-15 11:39:37', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 08:39:37', '2025-10-15 08:39:37'),
(9, 266, 'Nancy muthoga', '123456', 1, '2025-10-15 14:50:51', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 11:50:51', '2025-10-15 11:50:51'),
(10, 300, 'Hezron Njoroge', '123456', 1, '2025-10-15 15:14:22', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-15 12:14:22', '2025-10-15 12:14:22'),
(11, 340, 'DAVID IRUNGU', '34866059', 1, '2025-10-16 11:36:20', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 08:36:20', '2025-10-16 08:36:20'),
(12, 368, 'Joseph Maina', '34389983', 1, '2025-10-16 11:38:19', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '2025-10-16 08:38:19', '2025-10-16 08:38:19');

--
-- Triggers `user_consents`
--
DELIMITER $$
CREATE TRIGGER `user_consents_audit_insert` AFTER INSERT ON `user_consents` FOR EACH ROW BEGIN
    INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details)
    VALUES (
        NEW.user_id,
        'consent_record_created',
        NEW.ip_address,
        NEW.user_agent,
        JSON_OBJECT(
            'consent_id', NEW.id,
            'full_name', NEW.full_name,
            'consent_date', NEW.consent_date
        )
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `user_consents_audit_update` AFTER UPDATE ON `user_consents` FOR EACH ROW BEGIN
    INSERT INTO security_logs (user_id, event_type, ip_address, user_agent, details)
    VALUES (
        NEW.user_id,
        'consent_record_updated',
        NEW.ip_address,
        NEW.user_agent,
        JSON_OBJECT(
            'consent_id', NEW.id,
            'old_consent_given', OLD.consent_given,
            'new_consent_given', NEW.consent_given,
            'update_date', NOW()
        )
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `completed_appraisals_view`
--
DROP TABLE IF EXISTS `completed_appraisals_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `completed_appraisals_view`  AS SELECT `ea`.`id` AS `id`, `ea`.`employee_id` AS `employee_id`, `ea`.`appraiser_id` AS `appraiser_id`, `ea`.`appraisal_cycle_id` AS `appraisal_cycle_id`, `ea`.`employee_comment` AS `employee_comment`, `ea`.`employee_comment_date` AS `employee_comment_date`, `ea`.`submitted_at` AS `submitted_at`, `ea`.`status` AS `status`, `ea`.`created_at` AS `created_at`, `ea`.`updated_at` AS `updated_at`, `ac`.`name` AS `cycle_name`, `ac`.`start_date` AS `start_date`, `ac`.`end_date` AS `end_date`, `e`.`first_name` AS `first_name`, `e`.`last_name` AS `last_name`, `e`.`employee_id` AS `emp_id`, `e`.`designation` AS `designation`, `d`.`name` AS `department_name`, `s`.`name` AS `section_name`, `e_appraiser`.`first_name` AS `appraiser_first_name`, `e_appraiser`.`last_name` AS `appraiser_last_name`, CASE WHEN month(`ac`.`start_date`) in (1,2,3) THEN 'Q1' WHEN month(`ac`.`start_date`) in (4,5,6) THEN 'Q2' WHEN month(`ac`.`start_date`) in (7,8,9) THEN 'Q3' WHEN month(`ac`.`start_date`) in (10,11,12) THEN 'Q4' ELSE 'Unknown' END AS `quarter`, (select avg(`as_`.`score` / `pi`.`max_score` * 100) from (`appraisal_scores` `as_` join `performance_indicators` `pi` on(`as_`.`performance_indicator_id` = `pi`.`id`)) where `as_`.`employee_appraisal_id` = `ea`.`id`) AS `average_score_percentage` FROM (((((`employee_appraisals` `ea` join `employees` `e` on(`ea`.`employee_id` = `e`.`id`)) left join `departments` `d` on(`e`.`department_id` = `d`.`id`)) left join `sections` `s` on(`e`.`section_id` = `s`.`id`)) join `appraisal_cycles` `ac` on(`ea`.`appraisal_cycle_id` = `ac`.`id`)) join `employees` `e_appraiser` on(`ea`.`appraiser_id` = `e_appraiser`.`id`)) WHERE `ea`.`status` = 'submitted' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `strategy_id` (`strategy_id`);

--
-- Indexes for table `allowance_types`
--
ALTER TABLE `allowance_types`
  ADD PRIMARY KEY (`allowance_type_id`);

--
-- Indexes for table `appraisal_cycles`
--
ALTER TABLE `appraisal_cycles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_appraisal_cycles_dates` (`start_date`,`end_date`);

--
-- Indexes for table `appraisal_scores`
--
ALTER TABLE `appraisal_scores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_appraisal_indicator` (`employee_appraisal_id`,`performance_indicator_id`),
  ADD KEY `employee_appraisal_id` (`employee_appraisal_id`),
  ADD KEY `performance_indicator_id` (`performance_indicator_id`);

--
-- Indexes for table `appraisal_summary_cache`
--
ALTER TABLE `appraisal_summary_cache`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_cycle_quarter` (`appraisal_cycle_id`,`quarter`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_timestamp` (`timestamp`),
  ADD KEY `idx_action_type` (`action_type`),
  ADD KEY `idx_table_record` (`table_name`,`record_id`);

--
-- Indexes for table `banks`
--
ALTER TABLE `banks`
  ADD PRIMARY KEY (`bank_id`);

--
-- Indexes for table `deduction_audit_log`
--
ALTER TABLE `deduction_audit_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deduction_formulas`
--
ALTER TABLE `deduction_formulas`
  ADD PRIMARY KEY (`formula_id`),
  ADD KEY `deduction_type_id` (`deduction_type_id`);

--
-- Indexes for table `deduction_templates`
--
ALTER TABLE `deduction_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deduction_types`
--
ALTER TABLE `deduction_types`
  ADD PRIMARY KEY (`deduction_type_id`),
  ADD UNIQUE KEY `unique_type_name` (`type_name`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dependencies`
--
ALTER TABLE `dependencies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `employee_id` (`employee_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `profile_token` (`profile_token`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `section_id` (`section_id`),
  ADD KEY `idx_employees_dept_section` (`department_id`,`section_id`),
  ADD KEY `subsection_id` (`subsection_id`);

--
-- Indexes for table `employee_allowances`
--
ALTER TABLE `employee_allowances`
  ADD PRIMARY KEY (`allowance_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `allowance_type_id` (`allowance_type_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `period_id` (`period_id`);

--
-- Indexes for table `employee_appraisals`
--
ALTER TABLE `employee_appraisals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_employee_cycle` (`employee_id`,`appraisal_cycle_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `appraiser_id` (`appraiser_id`),
  ADD KEY `appraisal_cycle_id` (`appraisal_cycle_id`),
  ADD KEY `idx_employee_appraisals_status` (`status`),
  ADD KEY `idx_employee_appraisals_submitted_at` (`submitted_at`);

--
-- Indexes for table `employee_deductions`
--
ALTER TABLE `employee_deductions`
  ADD PRIMARY KEY (`deduction_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `deduction_type_id` (`deduction_type_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `employee_documents`
--
ALTER TABLE `employee_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Indexes for table `employee_leave_balances`
--
ALTER TABLE `employee_leave_balances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_employee_leave_year` (`employee_id`,`leave_type_id`,`financial_year_id`),
  ADD KEY `financial_year_id` (`financial_year_id`),
  ADD KEY `employee_leave_balances_ibfk_1` (`leave_type_id`);

--
-- Indexes for table `employee_loans`
--
ALTER TABLE `employee_loans`
  ADD PRIMARY KEY (`loan_id`);

--
-- Indexes for table `financial_years`
--
ALTER TABLE `financial_years`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_year` (`start_date`,`end_date`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leave_applications`
--
ALTER TABLE `leave_applications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `leave_type_id` (`leave_type_id`);

--
-- Indexes for table `leave_history`
--
ALTER TABLE `leave_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leave_transactions`
--
ALTER TABLE `leave_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_application_id` (`application_id`),
  ADD KEY `idx_employee_id` (`employee_id`),
  ADD KEY `idx_transaction_date` (`transaction_date`);

--
-- Indexes for table `leave_types`
--
ALTER TABLE `leave_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_payments`
--
ALTER TABLE `loan_payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `loan_id` (`loan_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`user_id`) USING BTREE;

--
-- Indexes for table `objectives`
--
ALTER TABLE `objectives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `strategic_plan_id` (`strategic_plan_id`);

--
-- Indexes for table `payroll`
--
ALTER TABLE `payroll`
  ADD PRIMARY KEY (`payroll_id`),
  ADD KEY `emp_id` (`emp_id`),
  ADD KEY `fk_bank_id` (`bank_id`);

--
-- Indexes for table `payroll_periods`
--
ALTER TABLE `payroll_periods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payroll_records`
--
ALTER TABLE `payroll_records`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_emp_period` (`employee_id`,`pay_period_id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `pay_period_id` (`pay_period_id`);

--
-- Indexes for table `performance_indicators`
--
ALTER TABLE `performance_indicators`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `salary_bands`
--
ALTER TABLE `salary_bands`
  ADD PRIMARY KEY (`scale_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `security_logs`
--
ALTER TABLE `security_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Indexes for table `strategic_plan`
--
ALTER TABLE `strategic_plan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `strategies`
--
ALTER TABLE `strategies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `strategic_plan_id` (`strategic_plan_id`),
  ADD KEY `objective_id` (`objective_id`);

--
-- Indexes for table `subsections`
--
ALTER TABLE `subsections`
  ADD PRIMARY KEY (`id`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_consents`
--
ALTER TABLE `user_consents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_consent` (`user_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_consent_date` (`consent_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `allowance_types`
--
ALTER TABLE `allowance_types`
  MODIFY `allowance_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `appraisal_cycles`
--
ALTER TABLE `appraisal_cycles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `appraisal_scores`
--
ALTER TABLE `appraisal_scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2169;

--
-- AUTO_INCREMENT for table `appraisal_summary_cache`
--
ALTER TABLE `appraisal_summary_cache`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `banks`
--
ALTER TABLE `banks`
  MODIFY `bank_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `deduction_audit_log`
--
ALTER TABLE `deduction_audit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `deduction_formulas`
--
ALTER TABLE `deduction_formulas`
  MODIFY `formula_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deduction_templates`
--
ALTER TABLE `deduction_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `deduction_types`
--
ALTER TABLE `deduction_types`
  MODIFY `deduction_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `dependencies`
--
ALTER TABLE `dependencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=513;

--
-- AUTO_INCREMENT for table `employee_allowances`
--
ALTER TABLE `employee_allowances`
  MODIFY `allowance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=143;

--
-- AUTO_INCREMENT for table `employee_appraisals`
--
ALTER TABLE `employee_appraisals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `employee_deductions`
--
ALTER TABLE `employee_deductions`
  MODIFY `deduction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `employee_documents`
--
ALTER TABLE `employee_documents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employee_leave_balances`
--
ALTER TABLE `employee_leave_balances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6053;

--
-- AUTO_INCREMENT for table `employee_loans`
--
ALTER TABLE `employee_loans`
  MODIFY `loan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `financial_years`
--
ALTER TABLE `financial_years`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `leave_applications`
--
ALTER TABLE `leave_applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=220;

--
-- AUTO_INCREMENT for table `leave_history`
--
ALTER TABLE `leave_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `leave_transactions`
--
ALTER TABLE `leave_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT for table `leave_types`
--
ALTER TABLE `leave_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `loan_payments`
--
ALTER TABLE `loan_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `objectives`
--
ALTER TABLE `objectives`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payroll`
--
ALTER TABLE `payroll`
  MODIFY `payroll_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=369;

--
-- AUTO_INCREMENT for table `payroll_periods`
--
ALTER TABLE `payroll_periods`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `payroll_records`
--
ALTER TABLE `payroll_records`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `performance_indicators`
--
ALTER TABLE `performance_indicators`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `security_logs`
--
ALTER TABLE `security_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=722;

--
-- AUTO_INCREMENT for table `strategic_plan`
--
ALTER TABLE `strategic_plan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `strategies`
--
ALTER TABLE `strategies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `subsections`
--
ALTER TABLE `subsections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=379;

--
-- AUTO_INCREMENT for table `user_consents`
--
ALTER TABLE `user_consents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`strategy_id`) REFERENCES `strategies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `appraisal_scores`
--
ALTER TABLE `appraisal_scores`
  ADD CONSTRAINT `appraisal_scores_ibfk_1` FOREIGN KEY (`employee_appraisal_id`) REFERENCES `employee_appraisals` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appraisal_scores_ibfk_2` FOREIGN KEY (`performance_indicator_id`) REFERENCES `performance_indicators` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `appraisal_summary_cache`
--
ALTER TABLE `appraisal_summary_cache`
  ADD CONSTRAINT `appraisal_summary_cache_ibfk_1` FOREIGN KEY (`appraisal_cycle_id`) REFERENCES `appraisal_cycles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `deduction_formulas`
--
ALTER TABLE `deduction_formulas`
  ADD CONSTRAINT `deduction_formulas_ibfk_1` FOREIGN KEY (`deduction_type_id`) REFERENCES `deduction_types` (`deduction_type_id`);

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`subsection_id`) REFERENCES `subsections` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `loan_payments`
--
ALTER TABLE `loan_payments`
  ADD CONSTRAINT `fk_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `employee_loans` (`loan_id`) ON DELETE CASCADE;

--
-- Constraints for table `payroll_records`
--
ALTER TABLE `payroll_records`
  ADD CONSTRAINT `payroll_records_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payroll_records_ibfk_2` FOREIGN KEY (`pay_period_id`) REFERENCES `payroll_periods` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subsections`
--
ALTER TABLE `subsections`
  ADD CONSTRAINT `subsections_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subsections_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_consents`
--
ALTER TABLE `user_consents`
  ADD CONSTRAINT `user_consents_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
