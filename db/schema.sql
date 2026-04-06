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
  (5, 'HOUSE 5'),
  (6, 'สำรอง');

INSERT IGNORE INTO members (house_id, name, order_index) VALUES
  (1, 'Kay Tumgundailong',   0),
  (1, 'Jacop Runtukverb',    1),
  (1, 'Nin Star',            2),
  (1, 'Damon Mega',          3),
  (1, 'Thale Agi',           4),
  (1, 'Red Onefourk',          5),

  (2, 'Sugus Klayphetw',     0),
  (2, 'Daisy Onefourk',      1),
  (2, 'Snowball Jubjub',     2),
  (2, 'Hendrix Onefourk',    3),
  (2, 'Uan Phansailan',      4),
  (2, 'Cake Onefourk',       5),
  (2, 'Whipcream Brown',     6),

  (3, 'Jadd Puay',           0),
  (3, 'Bxbe Roulette',       1),
  (3, 'Woody Watdaimod',     2),
  (3, 'Jasper Runtukverb',   3),
  (3, 'Mars Thebuzz',       4),
  (3, 'Mara Onefourk',       5),

  (4, 'Ryu Nomoney',         0),
  (4, 'Somruay Onefourk',    1),
  (4, 'Boar Popsmoke',       2),
  (4, 'Verse Nonstop',       3),
  (4, 'Jod Howdy',           4),
  (4, 'Perst Leal',          5),

  (5, 'Carlos Lee',          0),
  (5, 'Smile Zeiss',         1),
  (5, 'Pong Darksecret',     2),
  (5, 'Nongstefan Onefourk', 3),
  (5, 'Champ Kinsaep',       4),

  (6, 'Jin',             0),
  (6, 'JustX',           1),
  (6, 'Boss Onefourk',   2),
  (6, 'Moon',            3);