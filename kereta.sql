-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 24 Jul 2024 pada 17.05
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kereta`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`` PROCEDURE `cek_penumpang_berdasarkan_kereta_jadwal` (IN `kereta_id_param` VARCHAR(20), IN `jadwal_id_param` VARCHAR(20))   BEGIN
    DECLARE hitung_penumpang INT;

    -- Menghitung jumlah penumpang berdasarkan jadwal dan kereta
    SELECT COUNT(*) INTO hitung_penumpang
    FROM pembayaran
    WHERE kereta_id = kereta_id_param AND jadwal_id = jadwal_id_param;

    -- Menggunakan CASE untuk menghasilkan pesan berdasarkan jumlah penumpang
    IF hitung_penumpang > 50 THEN
        SELECT 'lebih dari 50 penumpang' AS pesan;
    ELSEIF hitung_penumpang BETWEEN 20 AND 50 THEN
        SELECT 'antara 20 dan 50 penumpang' AS pesan;
    ELSE
        SELECT 'kurang dari 20 penumpang' AS pesan;
    END IF;
END$$

CREATE DEFINER=`` PROCEDURE `cek_total_penumpang` ()   BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM penumpang;

    IF total > 100 THEN
        SELECT 'Total penumpang lebih dari 100' AS pesan;
    ELSE
        SELECT 'Total penumpang kurang dari 100' AS pesan;
    END IF;
END$$

--
-- Fungsi
--
CREATE DEFINER=`` FUNCTION `dapatkanTotalHarga` (`penumpang_id_param` VARCHAR(20), `jadwal_id_param` VARCHAR(20)) RETURNS DECIMAL(10,2)  BEGIN
    DECLARE total_price DECIMAL(10, 2);

    -- Menghitung total harga pembayaran
    SELECT SUM(harga) INTO total_price
    FROM pembayaran
    WHERE penumpang_id = penumpang_id_param
      AND jadwal_id = jadwal_id_param;

    RETURN total_price;
END$$

CREATE DEFINER=`` FUNCTION `total_penumpang` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM penumpang;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `horizontalview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `horizontalview` (
`kereta_id` varchar(20)
,`nama_kereta` varchar(100)
,`kelas` varchar(20)
,`kapasitas` int(11)
,`tersedia` tinyint(1)
,`keberangkatan_stasiun` varchar(100)
,`kedatangan_stasiun` varchar(100)
,`keberangkatan_date` date
,`kedatangan_date` date
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `inspectedkeretajadwalview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `inspectedkeretajadwalview` (
`kereta_id` varchar(20)
,`nama_kereta` varchar(100)
,`jadwal_id` varchar(20)
,`keberangkatan_stasiun` varchar(100)
,`kedatangan_stasiun` varchar(100)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jadwal`
--

CREATE TABLE `jadwal` (
  `jadwal_id` varchar(20) NOT NULL,
  `kereta_id` varchar(20) DEFAULT NULL,
  `nama_kereta` varchar(100) DEFAULT NULL,
  `keberangkatan_stasiun` varchar(100) DEFAULT NULL,
  `kedatangan_stasiun` varchar(100) DEFAULT NULL,
  `keberangkatan_date` date DEFAULT NULL,
  `keberangkatan_time` time DEFAULT NULL,
  `kedatangan_date` date DEFAULT NULL,
  `kedatangan_time` time DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jadwal`
--

INSERT INTO `jadwal` (`jadwal_id`, `kereta_id`, `nama_kereta`, `keberangkatan_stasiun`, `kedatangan_stasiun`, `keberangkatan_date`, `keberangkatan_time`, `kedatangan_date`, `kedatangan_time`, `status`) VALUES
('J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', '2024-08-01', '08:00:00', '2024-08-01', '10:30:00', 'On time'),
('J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', '2024-08-02', '09:00:00', '2024-08-02', '13:00:00', 'Delayed'),
('J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', '2024-08-03', '11:30:00', '2024-08-03', '14:30:00', 'On time'),
('J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', '2024-08-04', '15:00:00', '2024-08-04', '07:00:00', 'On time'),
('J005', 'KA005', 'Matarmaja', 'Semarang Tawang', 'Surabaya Pasar Turi', '2024-08-05', '07:30:00', '2024-08-05', '13:30:00', 'Delayed'),
('J006', 'KA006', 'Merak Jaya', 'Yogyakarta Tugu', 'Jakarta Gambir', '2024-08-06', '14:00:00', '2024-08-06', '18:30:00', 'On time'),
('J007', 'KA007', 'Jayabaya', 'Surabaya Pasar Turi', 'Malang', '2024-08-07', '08:45:00', '2024-08-07', '11:00:00', 'On time'),
('J008', 'KA008', 'Gumarang', 'Yogyakarta Tugu', 'Solo Balapan', '2024-08-08', '10:15:00', '2024-08-08', '12:00:00', 'Delayed'),
('J009', 'KA009', 'Progo', 'Purwokerto', 'Jember', '2024-08-09', '13:30:00', '2024-08-09', '23:30:00', 'On time'),
('J010', 'KA010', 'Arjuna', 'Solo Balapan', 'Yogyakarta Tugu', '2024-08-10', '17:00:00', '2024-08-10', '18:15:00', 'On time'),
('J021', 'KA011', 'Jayakarta', 'Gambir', 'Bandung', '2024-08-01', '10:00:00', '2024-08-01', '13:00:00', 'On Time');

-- --------------------------------------------------------

--
-- Struktur dari tabel `keretaapi`
--

CREATE TABLE `keretaapi` (
  `kereta_id` varchar(20) NOT NULL,
  `nama_kereta` varchar(100) NOT NULL,
  `kelas` varchar(20) NOT NULL,
  `kapasitas` int(11) DEFAULT NULL,
  `tersedia` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `keretaapi`
--

INSERT INTO `keretaapi` (`kereta_id`, `nama_kereta`, `kelas`, `kapasitas`, `tersedia`) VALUES
('KA001', 'Argo Parahyangan', 'Eksekutif', 60, 1),
('KA002', 'Gajayana', 'Ekonomi', 180, 1),
('KA003', 'Malioboro Express', 'Bisnis', 150, 1),
('KA004', 'Bima', 'Eksekutif', 100, 1),
('KA005', 'Matarmaja', 'Ekonomi', 200, 1),
('KA006', 'Merak Jaya', 'Bisnis', 160, 1),
('KA007', 'Jayabaya', 'Eksekutif', 130, 1),
('KA008', 'Gumarang', 'Ekonomi', 190, 1),
('KA009', 'Progo', 'Bisnis', 170, 1),
('KA010', 'Arjuna', 'Eksekutif', 110, 1),
('KA011', 'Jayakarta', 'Eksekutif', 50, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `keretachecks`
--

CREATE TABLE `keretachecks` (
  `check_id` varchar(20) NOT NULL,
  `kereta_id` varchar(20) DEFAULT NULL,
  `check_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `keretachecks`
--

INSERT INTO `keretachecks` (`check_id`, `kereta_id`, `check_date`, `status`, `notes`) VALUES
('CHK001', 'KA001', '2024-08-01', 'Passed', 'Regular safety check completed.'),
('CHK002', 'KA001', '2024-09-05', 'Passed', 'Annual inspection cleared.'),
('CHK003', 'KA002', '2024-08-10', 'Passed', 'All systems functional.'),
('CHK004', 'KA002', '2024-09-15', 'Passed', 'Brake tests successful.'),
('CHK005', 'KA003', '2024-08-20', 'Passed', 'No issues found in internal systems.'),
('CHK006', 'KA003', '2024-09-25', 'Passed', 'Exterior condition satisfactory.'),
('CHK007', 'KA004', '2024-08-05', 'Passed', 'Alignment and suspension checked.'),
('CHK008', 'KA004', '2024-09-10', 'Passed', 'Engine diagnostics completed.'),
('CHK009', 'KA005', '2024-08-15', 'Passed', 'Air conditioning functioning well.'),
('CHK010', 'KA005', '2024-09-20', 'Passed', 'Transmission in good condition.'),
('CHK011', 'KA006', '2024-08-25', 'Passed', 'Seats and upholstery inspected.'),
('CHK012', 'KA006', '2024-09-30', 'Passed', 'Windows and doors operational.'),
('CHK013', 'KA007', '2024-08-02', 'Passed', 'Regular safety check completed.'),
('CHK014', 'KA007', '2024-09-06', 'Passed', 'Annual inspection cleared.'),
('CHK015', 'KA008', '2024-08-11', 'Passed', 'All systems functional.'),
('CHK016', 'KA008', '2024-09-16', 'Passed', 'Brake tests successful.'),
('CHK017', 'KA009', '2024-08-21', 'Passed', 'No issues found in internal systems.'),
('CHK018', 'KA009', '2024-09-26', 'Passed', 'Exterior condition satisfactory.'),
('CHK019', 'KA010', '2024-08-06', 'Passed', 'Alignment and suspension checked.'),
('CHK020', 'KA010', '2024-09-11', 'Passed', 'Engine diagnostics completed.');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `keretajadwalview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `keretajadwalview` (
`kereta_id` varchar(20)
,`nama_kereta` varchar(100)
,`jadwal_id` varchar(20)
,`keberangkatan_stasiun` varchar(100)
,`kedatangan_stasiun` varchar(100)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_penumpang`
--

CREATE TABLE `log_penumpang` (
  `log_id` int(11) NOT NULL,
  `penumpang_id` varchar(20) DEFAULT NULL,
  `action_type` varchar(20) DEFAULT NULL,
  `old_nama` varchar(100) DEFAULT NULL,
  `new_nama` varchar(100) DEFAULT NULL,
  `old_no_hp` varchar(15) DEFAULT NULL,
  `new_no_hp` varchar(15) DEFAULT NULL,
  `old_email` varchar(100) DEFAULT NULL,
  `new_email` varchar(100) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_penumpang`
--

INSERT INTO `log_penumpang` (`log_id`, `penumpang_id`, `action_type`, `old_nama`, `new_nama`, `old_no_hp`, `new_no_hp`, `old_email`, `new_email`, `changed_at`) VALUES
(1, 'P115', 'BEFORE INSERT', NULL, 'Bagus Kurniawan', NULL, '08123456789', NULL, 'bagus@gmail.com', '2024-07-24 11:50:27'),
(2, 'P115', 'AFTER INSERT', NULL, 'Bagus Kurniawan', NULL, '08123456789', NULL, 'bagus@gmail.com', '2024-07-24 11:50:27'),
(3, 'P115', 'BEFORE UPDATE', 'Bagus Kurniawan', 'Bagus Kurniawan', '08123456789', '08198765432', 'bagus@gmail.com', 'aguslaparbu@gmail.com', '2024-07-24 11:59:51'),
(4, 'P115', 'AFTER UPDATE', 'Bagus Kurniawan', 'Bagus Kurniawan', '08123456789', '08198765432', 'bagus@gmail.com', 'aguslaparbu@gmail.com', '2024-07-24 11:59:51'),
(5, 'P115', 'BEFORE DELETE', 'Bagus Kurniawan', NULL, '08198765432', NULL, 'aguslaparbu@gmail.com', NULL, '2024-07-24 12:03:04'),
(6, 'P115', 'AFTER DELETE', 'Bagus Kurniawan', NULL, '08198765432', NULL, 'aguslaparbu@gmail.com', NULL, '2024-07-24 12:03:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `maintenance`
--

CREATE TABLE `maintenance` (
  `maintenance_id` varchar(20) NOT NULL,
  `kereta_id` varchar(20) DEFAULT NULL,
  `maintenance_date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `maintenance`
--

INSERT INTO `maintenance` (`maintenance_id`, `kereta_id`, `maintenance_date`, `description`, `harga`) VALUES
('MNT001', 'KA001', '2024-08-01', 'Routine maintenance checkup', 1500.00),
('MNT002', 'KA001', '2024-09-05', 'Oil change and lubrication', 1800.00),
('MNT003', 'KA002', '2024-08-10', 'Electrical system inspection', 1200.00),
('MNT004', 'KA002', '2024-09-15', 'Brake system overhaul', 2200.00),
('MNT005', 'KA003', '2024-08-20', 'Interior cleaning and sanitization', 900.00),
('MNT006', 'KA003', '2024-09-25', 'Exterior repainting', 2500.00),
('MNT007', 'KA004', '2024-08-05', 'Wheel alignment and balancing', 1300.00),
('MNT008', 'KA004', '2024-09-10', 'Engine performance tuning', 1900.00),
('MNT009', 'KA005', '2024-08-15', 'Air conditioning system check', 1100.00),
('MNT010', 'KA005', '2024-09-20', 'Transmission fluid change', 1700.00),
('MNT011', 'KA006', '2024-08-25', 'Seat upholstery repair', 1000.00),
('MNT012', 'KA006', '2024-09-30', 'Window glass replacement', 2000.00),
('MNT013', 'KA007', '2024-08-02', 'Routine maintenance checkup', 1500.00),
('MNT014', 'KA007', '2024-09-06', 'Oil change and lubrication', 1800.00),
('MNT015', 'KA008', '2024-08-11', 'Electrical system inspection', 1200.00),
('MNT016', 'KA008', '2024-09-16', 'Brake system overhaul', 2200.00),
('MNT017', 'KA009', '2024-08-21', 'Interior cleaning and sanitization', 900.00),
('MNT018', 'KA009', '2024-09-26', 'Exterior repainting', 2500.00),
('MNT019', 'KA010', '2024-08-06', 'Wheel alignment and balancing', 1300.00),
('MNT020', 'KA010', '2024-09-11', 'Engine performance tuning', 1900.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembayaran`
--

CREATE TABLE `pembayaran` (
  `payment_id` varchar(20) NOT NULL,
  `penumpang_id` varchar(20) DEFAULT NULL,
  `jadwal_id` varchar(20) DEFAULT NULL,
  `kereta_id` varchar(20) DEFAULT NULL,
  `kereta_nama` varchar(100) DEFAULT NULL,
  `keberangkatan_stasiun` varchar(100) DEFAULT NULL,
  `kedatangan_stasiun` varchar(100) DEFAULT NULL,
  `kelas` varchar(20) DEFAULT NULL,
  `seat_number` varchar(10) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `pembayaran_date` date DEFAULT NULL,
  `pembayaran_method` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pembayaran`
--

INSERT INTO `pembayaran` (`payment_id`, `penumpang_id`, `jadwal_id`, `kereta_id`, `kereta_nama`, `keberangkatan_stasiun`, `kedatangan_stasiun`, `kelas`, `seat_number`, `harga`, `pembayaran_date`, `pembayaran_method`) VALUES
('PY001', 'P001', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A001', 250000.00, '2024-07-16', 'Credit Card'),
('PY002', 'P002', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A002', 250000.00, '2024-07-16', 'Bank Transfer'),
('PY003', 'P003', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A003', 250000.00, '2024-07-16', 'Debit Card'),
('PY004', 'P004', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A004', 250000.00, '2024-07-16', 'Cash'),
('PY005', 'P005', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A005', 250000.00, '2024-07-16', 'Credit Card'),
('PY006', 'P006', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A006', 250000.00, '2024-07-16', 'Bank Transfer'),
('PY007', 'P007', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A007', 250000.00, '2024-07-16', 'Debit Card'),
('PY008', 'P008', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A008', 250000.00, '2024-07-16', 'Cash'),
('PY009', 'P009', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A009', 250000.00, '2024-07-16', 'Credit Card'),
('PY010', 'P010', 'J001', 'KA001', 'Argo Parahyangan', 'Jakarta Gambir', 'Bandung', 'Eksekutif', 'A010', 250000.00, '2024-07-16', 'Bank Transfer'),
('PY011', 'P011', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B001', 150000.00, '2024-07-16', 'Debit Card'),
('PY012', 'P012', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B002', 150000.00, '2024-07-16', 'Cash'),
('PY013', 'P013', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B003', 150000.00, '2024-07-16', 'Credit Card'),
('PY014', 'P014', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B004', 150000.00, '2024-07-16', 'Bank Transfer'),
('PY015', 'P015', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B005', 150000.00, '2024-07-16', 'Debit Card'),
('PY016', 'P016', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B006', 150000.00, '2024-07-16', 'Cash'),
('PY017', 'P017', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B007', 150000.00, '2024-07-16', 'Credit Card'),
('PY018', 'P018', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B008', 150000.00, '2024-07-16', 'Bank Transfer'),
('PY019', 'P019', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B009', 150000.00, '2024-07-16', 'Debit Card'),
('PY020', 'P020', 'J002', 'KA002', 'Gajayana', 'Surabaya Pasar Turi', 'Yogyakarta Tugu', 'Ekonomi', 'B010', 150000.00, '2024-07-16', 'Cash'),
('PY021', 'P021', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C001', 180000.00, '2024-07-16', 'Credit Card'),
('PY022', 'P022', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C002', 180000.00, '2024-07-16', 'Bank Transfer'),
('PY023', 'P023', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C003', 180000.00, '2024-07-16', 'Debit Card'),
('PY024', 'P024', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C004', 180000.00, '2024-07-16', 'Cash'),
('PY025', 'P025', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C005', 180000.00, '2024-07-16', 'Credit Card'),
('PY026', 'P026', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C006', 180000.00, '2024-07-16', 'Bank Transfer'),
('PY027', 'P027', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C007', 180000.00, '2024-07-16', 'Debit Card'),
('PY028', 'P028', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C008', 180000.00, '2024-07-16', 'Cash'),
('PY029', 'P029', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C009', 180000.00, '2024-07-16', 'Credit Card'),
('PY030', 'P030', 'J003', 'KA003', 'Malioboro Express', 'Surabaya Gubeng', 'Malang', 'Bisnis', 'C010', 180000.00, '2024-07-16', 'Bank Transfer'),
('PY031', 'P031', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A001', 280000.00, '2024-07-16', 'Cash'),
('PY032', 'P032', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A002', 280000.00, '2024-07-16', 'Credit Card'),
('PY033', 'P033', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A003', 280000.00, '2024-07-16', 'Debit Card'),
('PY034', 'P034', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A004', 280000.00, '2024-07-16', 'Bank Transfer'),
('PY035', 'P035', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A005', 280000.00, '2024-07-16', 'Cash'),
('PY036', 'P036', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A006', 280000.00, '2024-07-16', 'Credit Card'),
('PY037', 'P037', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A007', 280000.00, '2024-07-16', 'Debit Card'),
('PY038', 'P038', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A008', 280000.00, '2024-07-16', 'Bank Transfer'),
('PY039', 'P039', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A009', 280000.00, '2024-07-16', 'Cash'),
('PY040', 'P040', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A010', 280000.00, '2024-07-16', 'Credit Card'),
('PY041', 'P041', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A011', 280000.00, '2024-07-16', 'Debit Card'),
('PY042', 'P042', 'J004', 'KA004', 'Bima', 'Jakarta Pasar Senen', 'Surabaya Gubeng', 'Eksekutif', 'A012', 280000.00, '2024-07-16', 'Bank Transfer'),
('PY043', 'P043', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B001', 120000.00, '2024-07-16', 'Cash'),
('PY044', 'P044', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B002', 120000.00, '2024-07-16', 'Credit Card'),
('PY045', 'P045', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B003', 120000.00, '2024-07-16', 'Debit Card'),
('PY046', 'P046', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B004', 120000.00, '2024-07-16', 'Bank Transfer'),
('PY047', 'P047', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B005', 120000.00, '2024-07-16', 'Cash'),
('PY048', 'P048', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B006', 120000.00, '2024-07-16', 'Credit Card'),
('PY049', 'P049', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B007', 120000.00, '2024-07-16', 'Debit Card'),
('PY050', 'P050', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B008', 120000.00, '2024-07-16', 'Bank Transfer'),
('PY051', 'P051', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B009', 120000.00, '2024-07-16', 'Cash'),
('PY052', 'P052', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B010', 120000.00, '2024-07-16', 'Credit Card'),
('PY053', 'P053', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B011', 120000.00, '2024-07-16', 'Debit Card'),
('PY054', 'P054', 'J005', 'KA005', 'Listrik', 'Yogyakarta Tugu', 'Bandung', 'Ekonomi', 'B012', 120000.00, '2024-07-16', 'Bank Transfer'),
('PY055', 'P055', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C001', 270000.00, '2024-07-16', 'Credit Card'),
('PY056', 'P056', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C002', 270000.00, '2024-07-16', 'Bank Transfer'),
('PY057', 'P057', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C003', 270000.00, '2024-07-16', 'Debit Card'),
('PY058', 'P058', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C004', 270000.00, '2024-07-16', 'Cash'),
('PY059', 'P059', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C005', 270000.00, '2024-07-16', 'Credit Card'),
('PY060', 'P060', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C006', 270000.00, '2024-07-16', 'Bank Transfer'),
('PY061', 'P061', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C007', 270000.00, '2024-07-16', 'Debit Card'),
('PY062', 'P062', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C008', 270000.00, '2024-07-16', 'Cash'),
('PY063', 'P063', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C009', 270000.00, '2024-07-16', 'Credit Card'),
('PY064', 'P064', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C010', 270000.00, '2024-07-16', 'Bank Transfer'),
('PY065', 'P065', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C011', 270000.00, '2024-07-16', 'Debit Card'),
('PY066', 'P066', 'J006', 'KA006', 'Gajah Mada', 'Jakarta Gambir', 'Semarang Tawang', 'Eksekutif', 'C012', 270000.00, '2024-07-16', 'Cash'),
('PY067', 'P067', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D001', 200000.00, '2024-07-16', 'Credit Card'),
('PY068', 'P068', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D002', 200000.00, '2024-07-16', 'Bank Transfer'),
('PY069', 'P069', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D003', 200000.00, '2024-07-16', 'Debit Card'),
('PY070', 'P070', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D004', 200000.00, '2024-07-16', 'Cash'),
('PY071', 'P071', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D005', 200000.00, '2024-07-16', 'Credit Card'),
('PY072', 'P072', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D006', 200000.00, '2024-07-16', 'Bank Transfer'),
('PY073', 'P073', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D007', 200000.00, '2024-07-16', 'Debit Card'),
('PY074', 'P074', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D008', 200000.00, '2024-07-16', 'Cash'),
('PY075', 'P075', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D009', 200000.00, '2024-07-16', 'Credit Card'),
('PY076', 'P076', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D010', 200000.00, '2024-07-16', 'Bank Transfer'),
('PY077', 'P077', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D011', 200000.00, '2024-07-16', 'Debit Card'),
('PY078', 'P078', 'J007', 'KA007', 'Cendrawasih', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'D012', 200000.00, '2024-07-16', 'Cash'),
('PY079', 'P079', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E001', 140000.00, '2024-07-16', 'Debit Card'),
('PY080', 'P080', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E002', 140000.00, '2024-07-16', 'Cash'),
('PY081', 'P081', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E003', 140000.00, '2024-07-16', 'Credit Card'),
('PY082', 'P082', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E004', 140000.00, '2024-07-16', 'Bank Transfer'),
('PY083', 'P083', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E005', 140000.00, '2024-07-16', 'Debit Card'),
('PY084', 'P084', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E006', 140000.00, '2024-07-16', 'Cash'),
('PY085', 'P085', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E007', 140000.00, '2024-07-16', 'Credit Card'),
('PY086', 'P086', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E008', 140000.00, '2024-07-16', 'Bank Transfer'),
('PY087', 'P087', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E009', 140000.00, '2024-07-16', 'Debit Card'),
('PY088', 'P088', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E010', 140000.00, '2024-07-16', 'Cash'),
('PY089', 'P089', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E011', 140000.00, '2024-07-16', 'Credit Card'),
('PY090', 'P090', 'J008', 'KA008', 'Panggon', 'Semarang Tawang', 'Yogyakarta Tugu', 'Ekonomi', 'E012', 140000.00, '2024-07-16', 'Bank Transfer'),
('PY091', 'P091', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F001', 190000.00, '2024-07-16', 'Bank Transfer'),
('PY092', 'P092', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F002', 190000.00, '2024-07-16', 'Debit Card'),
('PY093', 'P093', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F003', 190000.00, '2024-07-16', 'Cash'),
('PY094', 'P094', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F004', 190000.00, '2024-07-16', 'Credit Card'),
('PY095', 'P095', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F005', 190000.00, '2024-07-16', 'Bank Transfer'),
('PY096', 'P096', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F006', 190000.00, '2024-07-16', 'Debit Card'),
('PY097', 'P097', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F007', 190000.00, '2024-07-16', 'Cash'),
('PY098', 'P098', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F008', 190000.00, '2024-07-16', 'Credit Card'),
('PY099', 'P099', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F009', 190000.00, '2024-07-16', 'Bank Transfer'),
('PY100', 'P100', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F010', 190000.00, '2024-07-16', 'Debit Card'),
('PY101', 'P101', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F011', 190000.00, '2024-07-16', 'Cash'),
('PY102', 'P102', 'J009', 'KA009', 'Sumber', 'Bandung', 'Jakarta Gambir', 'Bisnis', 'F012', 190000.00, '2024-07-16', 'Credit Card'),
('PY103', 'P103', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G001', 130000.00, '2024-07-16', 'Bank Transfer'),
('PY104', 'P104', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G002', 130000.00, '2024-07-16', 'Debit Card'),
('PY105', 'P105', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G003', 130000.00, '2024-07-16', 'Cash'),
('PY106', 'P106', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G004', 130000.00, '2024-07-16', 'Credit Card'),
('PY107', 'P107', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G005', 130000.00, '2024-07-16', 'Bank Transfer'),
('PY108', 'P108', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G006', 130000.00, '2024-07-16', 'Debit Card'),
('PY109', 'P109', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G007', 130000.00, '2024-07-16', 'Cash'),
('PY110', 'P110', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G008', 130000.00, '2024-07-16', 'Credit Card'),
('PY111', 'P111', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G009', 130000.00, '2024-07-16', 'Bank Transfer'),
('PY112', 'P112', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G010', 130000.00, '2024-07-16', 'Debit Card'),
('PY113', 'P113', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G011', 130000.00, '2024-07-16', 'Cash'),
('PY114', 'P114', 'J010', 'KA010', 'Kencana', 'Jakarta Gambir', 'Surabaya Gubeng', 'Ekonomi', 'G012', 130000.00, '2024-07-16', 'Credit Card');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pemberhentian`
--

CREATE TABLE `pemberhentian` (
  `pemberhentian_id` varchar(20) NOT NULL,
  `jadwal_id` varchar(20) DEFAULT NULL,
  `stasiun_nama` varchar(100) DEFAULT NULL,
  `waktu_berhenti` time DEFAULT NULL,
  `berapa_kali_berhenti` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pemberhentian`
--

INSERT INTO `pemberhentian` (`pemberhentian_id`, `jadwal_id`, `stasiun_nama`, `waktu_berhenti`, `berapa_kali_berhenti`) VALUES
('PBH001', 'J001', 'Bekasi', '08:15:00', 1),
('PBH002', 'J001', 'Cikarang', '08:30:00', 2),
('PBH003', 'J002', 'Madiun', '10:30:00', 1),
('PBH004', 'J002', 'Solo Balapan', '11:15:00', 2),
('PBH005', 'J003', 'Jombang', '12:00:00', 1),
('PBH006', 'J003', 'Kertosono', '12:30:00', 2),
('PBH007', 'J004', 'Cirebon', '18:00:00', 1),
('PBH008', 'J004', 'Tegal', '19:00:00', 2),
('PBH009', 'J005', 'Semarang Poncol', '10:00:00', 1),
('PBH010', 'J005', 'Pekalongan', '10:45:00', 2),
('PBH011', 'J006', 'Purwokerto', '17:00:00', 1),
('PBH012', 'J006', 'Kroya', '17:45:00', 2),
('PBH013', 'J007', 'Sidoarjo', '10:00:00', 1),
('PBH014', 'J007', 'Porong', '10:30:00', 2),
('PBH015', 'J008', 'Solo Jebres', '14:15:00', 1),
('PBH016', 'J008', 'Nganjuk', '15:00:00', 2),
('PBH017', 'J009', 'Bojonegoro', '20:00:00', 1),
('PBH018', 'J009', 'Madiun', '21:00:00', 2),
('PBH019', 'J010', 'Maguwo', '19:00:00', 1),
('PBH020', 'J010', 'Klaten', '19:45:00', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `penumpang`
--

CREATE TABLE `penumpang` (
  `penumpang_id` varchar(20) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `no_hp` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penumpang`
--

INSERT INTO `penumpang` (`penumpang_id`, `nama`, `no_hp`, `email`) VALUES
('', 'Budi Santoso', '081234567890', 'budi.santoso@example.com'),
('P001', 'Budi Santoso', '08123456789', 'budi.santoso@example.com'),
('P002', 'Ani Susanti', '08234567890', 'ani.susanti@example.com'),
('P003', 'Joko Raharjo', '08345678901', 'joko.raharjo@example.com'),
('P004', 'Siti Nurhikmah', '08111222333', 'siti.nurhikmah@example.com'),
('P005', 'Ahmad Yani', '08765432100', 'ahmad.yani@example.com'),
('P006', 'Dewi Lestari', '08987654321', 'dewi.lestari@example.com'),
('P007', 'Firman Hadi', '08123456789', 'firman.hadi@example.com'),
('P008', 'Linda Wijaya', '08234567890', 'linda.wijaya@example.com'),
('P009', 'Rudi Gunawan', '08345678901', 'rudi.gunawan@example.com'),
('P010', 'Siska Rachmawati', '08111222333', 'siska.rachmawati@example.com'),
('P011', 'Agus Salim', '08765432100', 'agus.salim@example.com'),
('P012', 'Diana Putri', '08987654321', 'diana.putri@example.com'),
('P013', 'Hendro Wijaya', '08123456789', 'hendro.wijaya@example.com'),
('P014', 'Ratna Sari', '08234567890', 'ratna.sari@example.com'),
('P015', 'Fahmi Setiawan', '08345678901', 'fahmi.setiawan@example.com'),
('P016', 'Siti Aisyah', '08111222333', 'siti.aisyah@example.com'),
('P017', 'Bambang Surya', '08765432100', 'bambang.surya@example.com'),
('P018', 'Nadia Pratiwi', '08987654321', 'nadia.pratiwi@example.com'),
('P019', 'Gatot Koco', '08123456789', 'gatot.koco@example.com'),
('P020', 'Wulan Anggraini', '08234567890', 'wulan.anggraini@example.com'),
('P021', 'Indra Gunawan', '08345678901', 'indra.gunawan@example.com'),
('P022', 'Rina Melati', '08111222333', 'rina.melati@example.com'),
('P023', 'Surya Bakti', '08765432100', 'surya.bakti@example.com'),
('P024', 'Anita Dewi', '08987654321', 'anita.dewi@example.com'),
('P025', 'Hadi Pranoto', '08123456789', 'hadi.pranoto@example.com'),
('P026', 'Novi Susanto', '08234567890', 'novi.susanto@example.com'),
('P027', 'Eko Wibowo', '08345678901', 'eko.wibowo@example.com'),
('P028', 'Dewi Lestari', '08111222333', 'dewi.lestari@example.com'),
('P029', 'Rendra Surya', '08765432100', 'rendra.surya@example.com'),
('P030', 'Kartika Sari', '08987654321', 'kartika.sari@example.com'),
('P031', 'Budi Gunawan', '08123456789', 'budi.gunawan@example.com'),
('P032', 'Ani Yuliani', '08234567890', 'ani.yuliani@example.com'),
('P033', 'Joko Subroto', '08345678901', 'joko.subroto@example.com'),
('P034', 'Siti Mariam', '08111222333', 'siti.mariam@example.com'),
('P035', 'Ahmad Fajar', '08765432100', 'ahmad.fajar@example.com'),
('P036', 'Dewi Agustin', '08987654321', 'dewi.agustin@example.com'),
('P037', 'Firman Prasetyo', '08123456789', 'firman.prasetyo@example.com'),
('P038', 'Linda Kusuma', '08234567890', 'linda.kusuma@example.com'),
('P039', 'Rudi Hartono', '08345678901', 'rudi.hartono@example.com'),
('P040', 'Siska Hartati', '08111222333', 'siska.hartati@example.com'),
('P041', 'Agus Wijaya', '08765432100', 'agus.wijaya@example.com'),
('P042', 'Diana Kusuma', '08987654321', 'diana.kusuma@example.com'),
('P043', 'Hendro Saputra', '08123456789', 'hendro.saputra@example.com'),
('P044', 'Ratna Dewi', '08234567890', 'ratna.dewi@example.com'),
('P045', 'Fahmi Nugroho', '08345678901', 'fahmi.nugroho@example.com'),
('P046', 'Siti Rahmawati', '08111222333', 'siti.rahmawati@example.com'),
('P047', 'Bambang Hariyanto', '08765432100', 'bambang.hariyanto@example.com'),
('P048', 'Nadia Puspita', '08987654321', 'nadia.puspita@example.com'),
('P049', 'Gatot Prasetyo', '08123456789', 'gatot.prasetyo@example.com'),
('P050', 'Wulan Sukmawati', '08234567890', 'wulan.sukmawati@example.com'),
('P051', 'Indra Yulianto', '08345678901', 'indra.yulianto@example.com'),
('P052', 'Rina Dewi', '08111222333', 'rina.dewi@example.com'),
('P053', 'Surya Agung', '08765432100', 'surya.agung@example.com'),
('P054', 'Anita Kurnia', '08987654321', 'anita.kurnia@example.com'),
('P055', 'Hadi Susanto', '08123456789', 'hadi.susanto@example.com'),
('P056', 'Novi Kusuma', '08234567890', 'novi.kusuma@example.com'),
('P057', 'Eko Pranoto', '08345678901', 'eko.pranoto@example.com'),
('P058', 'Dewi Cahyani', '08111222333', 'dewi.cahyani@example.com'),
('P059', 'Rendra Priyanto', '08765432100', 'rendra.priyanto@example.com'),
('P060', 'Kartika Putri', '08987654321', 'kartika.putri@example.com'),
('P061', 'Budi Priyono', '08123456789', 'budi.priyono@example.com'),
('P062', 'Ani Suryani', '08234567890', 'ani.suryani@example.com'),
('P063', 'Joko Sutrisno', '08345678901', 'joko.sutrisno@example.com'),
('P064', 'Siti Amalia', '08111222333', 'siti.amalia@example.com'),
('P065', 'Ahmad Nur', '08765432100', 'ahmad.nur@example.com'),
('P066', 'Dewi Ayu', '08987654321', 'dewi.ayu@example.com'),
('P067', 'Firman Sukma', '08123456789', 'firman.sukma@example.com'),
('P068', 'Linda Astuti', '08234567890', 'linda.astuti@example.com'),
('P069', 'Rudi Hartawan', '08345678901', 'rudi.hartawan@example.com'),
('P070', 'Siska Kusumawati', '08111222333', 'siska.kusumawati@example.com'),
('P071', 'Agus Kurniawan', '08765432100', 'agus.kurniawan@example.com'),
('P072', 'Diana Anggraini', '08987654321', 'diana.anggraini@example.com'),
('P073', 'Hendro Yulianto', '08123456789', 'hendro.yulianto@example.com'),
('P074', 'Ratna Sulastri', '08234567890', 'ratna.sulastri@example.com'),
('P075', 'Fahmi Prasetyo', '08345678901', 'fahmi.prasetyo@example.com'),
('P076', 'Siti Wahyuni', '08111222333', 'siti.wahyuni@example.com'),
('P077', 'Bambang Priyono', '08765432100', 'bambang.priyono@example.com'),
('P078', 'Nadia Ramadhani', '08987654321', 'nadia.ramadhani@example.com'),
('P079', 'Gatot Wibowo', '08123456789', 'gatot.wibowo@example.com'),
('P080', 'Wulan Sari', '08234567890', 'wulan.sari@example.com'),
('P081', 'Indra Wijaya', '08345678901', 'indra.wijaya@example.com'),
('P082', 'Rina Kusuma', '08111222333', 'rina.kusuma@example.com'),
('P083', 'Surya Dharma', '08765432100', 'surya.dharma@example.com'),
('P084', 'Anita Pratiwi', '08987654321', 'anita.pratiwi@example.com'),
('P085', 'Hadi Yulianto', '08123456789', 'hadi.yulianto@example.com'),
('P086', 'Novi Widodo', '08234567890', 'novi.widodo@example.com'),
('P087', 'Eko Susanto', '08345678901', 'eko.susanto@example.com'),
('P088', 'Dewi Supriyanto', '08111222333', 'dewi.supriyanto@example.com'),
('P089', 'Rendra Nugraha', '08765432100', 'rendra.nugraha@example.com'),
('P090', 'Kartika Dewi', '08987654321', 'kartika.dewi@example.com'),
('P091', 'Budi Setiawan', '08123456789', 'budi.setiawan@example.com'),
('P092', 'Ani Pratiwi', '08234567890', 'ani.pratiwi@example.com'),
('P093', 'Joko Suyono', '08345678901', 'joko.suyono@example.com'),
('P094', 'Siti Rosyidah', '08111222333', 'siti.rosyidah@example.com'),
('P095', 'Ahmad Setiawan', '08765432100', 'ahmad.setiawan@example.com'),
('P096', 'Dewi Pratiwi', '08987654321', 'dewi.pratiwi@example.com'),
('P097', 'Firman Setiawan', '08123456789', 'firman.setiawan@example.com'),
('P098', 'Linda Rosita', '08234567890', 'linda.rosita@example.com'),
('P099', 'Rudi Setiawan', '08345678901', 'rudi.setiawan@example.com'),
('P100', 'Siska Pratiwi', '08111222333', 'siska.pratiwi@example.com'),
('P101', 'Agus Rosita', '08765432100', 'agus.rosita@example.com'),
('P102', 'Diana Setiawan', '08987654321', 'diana.setiawan@example.com'),
('P103', 'Hendro Pratama', '08123456789', 'hendro.pratama@example.com'),
('P104', 'Ratna Pratama', '08234567890', 'ratna.pratama@example.com'),
('P105', 'Fahmi Pratama', '08345678901', 'fahmi.pratama@example.com'),
('P106', 'Siti Pratama', '08111222333', 'siti.pratama@example.com'),
('P107', 'Bambang Pratama', '08765432100', 'bambang.pratama@example.com'),
('P108', 'Nadia Pratama', '08987654321', 'nadia.pratama@example.com'),
('P109', 'Gatot Pratama', '08123456789', 'gatot.pratama@example.com'),
('P110', 'Wulan Pratama', '08234567890', 'wulan.pratama@example.com'),
('P111', 'Indra Pratama', '08345678901', 'indra.pratama@example.com'),
('P112', 'Rina Pratama', '08111222333', 'rina.pratama@example.com'),
('P113', 'Surya Pratama', '08765432100', 'surya.pratama@example.com'),
('P114', 'Anita Pratama', '08987654321', 'anita.pratama@example.com');

--
-- Trigger `penumpang`
--
DELIMITER $$
CREATE TRIGGER `after_delete_penumpang` AFTER DELETE ON `penumpang` FOR EACH ROW BEGIN
    INSERT INTO log_penumpang (penumpang_id, action_type, old_nama, old_no_hp, old_email)
    VALUES (OLD.penumpang_id, 'AFTER DELETE', OLD.nama, OLD.no_hp, OLD.email);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_penumpang` AFTER INSERT ON `penumpang` FOR EACH ROW BEGIN
    INSERT INTO log_penumpang (penumpang_id, action_type, new_nama, new_no_hp, new_email)
    VALUES (NEW.penumpang_id, 'AFTER INSERT', NEW.nama, NEW.no_hp, NEW.email);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_penumpang` AFTER UPDATE ON `penumpang` FOR EACH ROW BEGIN
    INSERT INTO log_penumpang (penumpang_id, action_type, old_nama, new_nama, old_no_hp, new_no_hp, old_email, new_email)
    VALUES (OLD.penumpang_id, 'AFTER UPDATE', OLD.nama, NEW.nama, OLD.no_hp, NEW.no_hp, OLD.email, NEW.email);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_penumpang` BEFORE DELETE ON `penumpang` FOR EACH ROW BEGIN
    INSERT INTO log_penumpang (penumpang_id, action_type, old_nama, old_no_hp, old_email)
    VALUES (OLD.penumpang_id, 'BEFORE DELETE', OLD.nama, OLD.no_hp, OLD.email);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_penumpang` BEFORE INSERT ON `penumpang` FOR EACH ROW BEGIN
    INSERT INTO log_penumpang (penumpang_id, action_type, new_nama, new_no_hp, new_email)
    VALUES (NEW.penumpang_id, 'BEFORE INSERT', NEW.nama, NEW.no_hp, NEW.email);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_penumpang` BEFORE UPDATE ON `penumpang` FOR EACH ROW BEGIN
    INSERT INTO log_penumpang (penumpang_id, action_type, old_nama, new_nama, old_no_hp, new_no_hp, old_email, new_email)
    VALUES (OLD.penumpang_id, 'BEFORE UPDATE', OLD.nama, NEW.nama, OLD.no_hp, NEW.no_hp, OLD.email, NEW.email);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `reservasi`
--

CREATE TABLE `reservasi` (
  `reservasi_id` varchar(20) NOT NULL,
  `penumpang_id` varchar(20) DEFAULT NULL,
  `jadwal_id` varchar(20) DEFAULT NULL,
  `nomor_kursi` varchar(10) DEFAULT NULL,
  `tanggal_reservasi` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `verticalview`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `verticalview` (
`kereta_id` varchar(20)
,`nama_kereta` varchar(100)
,`kelas` varchar(20)
,`kapasitas` varchar(100)
,`tersedia` tinyint(4)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `horizontalview`
--
DROP TABLE IF EXISTS `horizontalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `horizontalview`  AS SELECT `keretaapi`.`kereta_id` AS `kereta_id`, `keretaapi`.`nama_kereta` AS `nama_kereta`, `keretaapi`.`kelas` AS `kelas`, `keretaapi`.`kapasitas` AS `kapasitas`, `keretaapi`.`tersedia` AS `tersedia`, `jadwal`.`keberangkatan_stasiun` AS `keberangkatan_stasiun`, `jadwal`.`kedatangan_stasiun` AS `kedatangan_stasiun`, `jadwal`.`keberangkatan_date` AS `keberangkatan_date`, `jadwal`.`kedatangan_date` AS `kedatangan_date` FROM (`keretaapi` join `jadwal` on(`keretaapi`.`kereta_id` = `jadwal`.`kereta_id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `inspectedkeretajadwalview`
--
DROP TABLE IF EXISTS `inspectedkeretajadwalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `inspectedkeretajadwalview`  AS SELECT `keretajadwalview`.`kereta_id` AS `kereta_id`, `keretajadwalview`.`nama_kereta` AS `nama_kereta`, `keretajadwalview`.`jadwal_id` AS `jadwal_id`, `keretajadwalview`.`keberangkatan_stasiun` AS `keberangkatan_stasiun`, `keretajadwalview`.`kedatangan_stasiun` AS `kedatangan_stasiun` FROM `keretajadwalview` WHERE `keretajadwalview`.`keberangkatan_stasiun` = 'Surabaya Gubeng'WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `keretajadwalview`
--
DROP TABLE IF EXISTS `keretajadwalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `keretajadwalview`  AS SELECT `keretaapi`.`kereta_id` AS `kereta_id`, `keretaapi`.`nama_kereta` AS `nama_kereta`, `jadwal`.`jadwal_id` AS `jadwal_id`, `jadwal`.`keberangkatan_stasiun` AS `keberangkatan_stasiun`, `jadwal`.`kedatangan_stasiun` AS `kedatangan_stasiun` FROM (`keretaapi` join `jadwal` on(`keretaapi`.`kereta_id` = `jadwal`.`kereta_id`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `verticalview`
--
DROP TABLE IF EXISTS `verticalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`` SQL SECURITY DEFINER VIEW `verticalview`  AS SELECT `keretaapi`.`kereta_id` AS `kereta_id`, `keretaapi`.`nama_kereta` AS `nama_kereta`, `keretaapi`.`kelas` AS `kelas`, `keretaapi`.`kapasitas` AS `kapasitas`, `keretaapi`.`tersedia` AS `tersedia` FROM `keretaapi`union all select `penumpang`.`penumpang_id` AS `penumpang_id`,`penumpang`.`nama` AS `nama`,`penumpang`.`no_hp` AS `no_hp`,`penumpang`.`email` AS `email`,NULL AS `NULL` from `penumpang`  ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`jadwal_id`),
  ADD KEY `kereta_id` (`kereta_id`);

--
-- Indeks untuk tabel `keretaapi`
--
ALTER TABLE `keretaapi`
  ADD PRIMARY KEY (`kereta_id`);

--
-- Indeks untuk tabel `keretachecks`
--
ALTER TABLE `keretachecks`
  ADD PRIMARY KEY (`check_id`),
  ADD KEY `idx_kereta_check_date` (`kereta_id`,`check_date`);

--
-- Indeks untuk tabel `log_penumpang`
--
ALTER TABLE `log_penumpang`
  ADD PRIMARY KEY (`log_id`);

--
-- Indeks untuk tabel `maintenance`
--
ALTER TABLE `maintenance`
  ADD PRIMARY KEY (`maintenance_id`),
  ADD KEY `kereta_id` (`kereta_id`);

--
-- Indeks untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `penumpang_id` (`penumpang_id`),
  ADD KEY `jadwal_id` (`jadwal_id`),
  ADD KEY `kereta_id` (`kereta_id`);

--
-- Indeks untuk tabel `pemberhentian`
--
ALTER TABLE `pemberhentian`
  ADD PRIMARY KEY (`pemberhentian_id`),
  ADD KEY `idx_jadwal_stasiun` (`jadwal_id`,`stasiun_nama`);

--
-- Indeks untuk tabel `penumpang`
--
ALTER TABLE `penumpang`
  ADD PRIMARY KEY (`penumpang_id`);

--
-- Indeks untuk tabel `reservasi`
--
ALTER TABLE `reservasi`
  ADD PRIMARY KEY (`reservasi_id`),
  ADD KEY `jadwal_id` (`jadwal_id`),
  ADD KEY `idx_penumpang_jadwal` (`penumpang_id`,`jadwal_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `log_penumpang`
--
ALTER TABLE `log_penumpang`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `jadwal`
--
ALTER TABLE `jadwal`
  ADD CONSTRAINT `jadwal_ibfk_1` FOREIGN KEY (`kereta_id`) REFERENCES `keretaapi` (`kereta_id`);

--
-- Ketidakleluasaan untuk tabel `keretachecks`
--
ALTER TABLE `keretachecks`
  ADD CONSTRAINT `keretachecks_ibfk_1` FOREIGN KEY (`kereta_id`) REFERENCES `keretaapi` (`kereta_id`);

--
-- Ketidakleluasaan untuk tabel `maintenance`
--
ALTER TABLE `maintenance`
  ADD CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`kereta_id`) REFERENCES `keretaapi` (`kereta_id`);

--
-- Ketidakleluasaan untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`penumpang_id`) REFERENCES `penumpang` (`penumpang_id`),
  ADD CONSTRAINT `pembayaran_ibfk_2` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal` (`jadwal_id`),
  ADD CONSTRAINT `pembayaran_ibfk_3` FOREIGN KEY (`kereta_id`) REFERENCES `keretaapi` (`kereta_id`);

--
-- Ketidakleluasaan untuk tabel `pemberhentian`
--
ALTER TABLE `pemberhentian`
  ADD CONSTRAINT `pemberhentian_ibfk_1` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal` (`jadwal_id`);

--
-- Ketidakleluasaan untuk tabel `reservasi`
--
ALTER TABLE `reservasi`
  ADD CONSTRAINT `reservasi_ibfk_1` FOREIGN KEY (`penumpang_id`) REFERENCES `penumpang` (`penumpang_id`),
  ADD CONSTRAINT `reservasi_ibfk_2` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal` (`jadwal_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
