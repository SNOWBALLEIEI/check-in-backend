-- ============================================================
-- Airdrop Check-in Database Schema
-- Import this file via phpMyAdmin: Import > choose file
-- ============================================================

CREATE DATABASE IF NOT EXISTS airdrop_checkin
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE airdrop_checkin;

-- ─── HOUSES ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS houses (
  id   INT          NOT NULL AUTO_INCREMENT,
  name VARCHAR(50)  NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── MEMBERS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS members (
  id          INT          NOT NULL AUTO_INCREMENT,
  house_id    INT          NOT NULL,
  name        VARCHAR(100) NOT NULL,
  order_index INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  FOREIGN KEY (house_id) REFERENCES houses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── ATTENDANCE RECORDS ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS attendance_records (
  id            VARCHAR(60)  NOT NULL,
  house_id      INT          NOT NULL,
  house_name    VARCHAR(50)  NOT NULL,
  airdrop_type  VARCHAR(60)  NOT NULL,
  present_count INT          NOT NULL DEFAULT 0,
  leave_count   INT          NOT NULL DEFAULT 0,
  absent_count  INT          NOT NULL DEFAULT 0,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (house_id) REFERENCES houses(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── ATTENDANCE DETAILS ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS attendance_details (
  id          INT          NOT NULL AUTO_INCREMENT,
  record_id   VARCHAR(60)  NOT NULL,
  member_name VARCHAR(100) NOT NULL,
  status      ENUM('present','leave','absent') DEFAULT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (record_id) REFERENCES attendance_records(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─── SEED DATA ────────────────────────────────────────────────
INSERT IGNORE INTO houses (id, name) VALUES
  (1, 'HOUSE 1'),
  (2, 'HOUSE 2'),
  (3, 'HOUSE 3'),
  (4, 'HOUSE 4'),
  (5, 'HOUSE 5');

INSERT IGNORE INTO members (house_id, name, order_index) VALUES
  (1, 'สมชาย ใจดี',       0),
  (1, 'สมหญิง รักดี',     1),
  (1, 'กนกพร สดใส',       2),
  (1, 'วิชัย มั่นคง',     3),
  (1, 'นภาพร งามพร้อม',   4),

  (2, 'ประสิทธิ์ เก่งดี', 0),
  (2, 'มณีรัตน์ แสงทอง',  1),
  (2, 'สุรชัย พร้อมสุข',  2),
  (2, 'พิมพ์ใจ อ่อนโยน',  3),
  (2, 'อานนท์ ยิ้มสู้',   4),

  (3, 'เกียรติศักดิ์ ดีเด่น', 0),
  (3, 'รัตนา มีสุข',          1),
  (3, 'ธนวัฒน์ รุ่งเรือง',    2),
  (3, 'สุภาพร เปรมใจ',        3),
  (3, 'วรรณี สว่างจิต',       4),

  (4, 'ชัยวัฒน์ ก้าวหน้า', 0),
  (4, 'นิตยา บริสุทธิ์',   1),
  (4, 'สมศักดิ์ เข้มแข็ง', 2),
  (4, 'พรทิพย์ สดชื่น',    3),
  (4, 'ธีรยุทธ กล้าหาญ',   4),

  (5, 'ปิยะ ทรงคุณ',    0),
  (5, 'วาสนา เจริญดี',  1),
  (5, 'สุเทพ ยิ่งใหญ่', 2),
  (5, 'กัญญา งามสง่า',  3),
  (5, 'ศักดิ์ชัย บึกบึน', 4);
