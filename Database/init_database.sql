-- ============================================
-- Initial Database Setup for Sports Borrow DB
-- Run this FIRST before any other SQL files
-- ============================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------
-- Table: users
-- -------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('admin','user') NOT NULL DEFAULT 'user',
  `student_id` VARCHAR(20) NULL,
  `first_name` VARCHAR(100) NULL,
  `last_name` VARCHAR(100) NULL,
  `profile_image` VARCHAR(255) NULL DEFAULT 'default.jpg',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  INDEX `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------
-- Table: categories
-- -------------------------------------------
CREATE TABLE IF NOT EXISTS `categories` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------
-- Table: equipment
-- -------------------------------------------
CREATE TABLE IF NOT EXISTS `equipment` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `quantity` INT(11) NOT NULL DEFAULT 0,
  `category_id` INT(11) NOT NULL,
  `image` VARCHAR(255) DEFAULT 'default.jpg',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_category_id` (`category_id`),
  INDEX `idx_equipment_name` (`name`),
  INDEX `idx_quantity` (`quantity`),
  CONSTRAINT `fk_equipment_category` FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------
-- Table: borrowings
-- -------------------------------------------
CREATE TABLE IF NOT EXISTS `borrowings` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `equipment_id` INT(11) NOT NULL,
  `quantity` INT(11) NOT NULL DEFAULT 1,
  `borrow_date` DATE NOT NULL,
  `return_date` DATE NULL,
  `status` ENUM('borrowed','returned') NOT NULL DEFAULT 'borrowed',
  `approval_status` ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `approved_by` INT(11) NULL,
  `approved_at` TIMESTAMP NULL,
  `rejection_reason` TEXT NULL,
  `pickup_confirmed` TINYINT(1) NOT NULL DEFAULT 0,
  `pickup_time` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_approval_status` (`approval_status`),
  INDEX `idx_pickup_confirmed` (`pickup_confirmed`),
  INDEX `idx_approved_by` (`approved_by`),
  INDEX `idx_borrow_date` (`borrow_date`),
  INDEX `idx_user_approval` (`user_id`, `approval_status`, `pickup_confirmed`),
  CONSTRAINT `fk_borrowings_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_borrowings_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_borrowings_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------
-- Table: deleted_borrowings
-- -------------------------------------------
CREATE TABLE IF NOT EXISTS `deleted_borrowings` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `original_id` INT(11) NOT NULL,
  `equipment_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `borrow_date` DATETIME NOT NULL,
  `return_date` DATETIME NULL,
  `status` ENUM('borrowed','returned') NOT NULL,
  `approval_status` ENUM('pending','approved','rejected') NOT NULL,
  `pickup_confirmed` TINYINT(1) DEFAULT 0,
  `pickup_time` DATETIME NULL,
  `approved_by` INT(11) NULL,
  `approved_at` DATETIME NULL,
  `deleted_at` DATETIME NOT NULL,
  `deleted_by` INT(11) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_original_id` (`original_id`),
  INDEX `idx_equipment_id` (`equipment_id`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_deleted_at` (`deleted_at`),
  INDEX `idx_deleted_by` (`deleted_by`),
  CONSTRAINT `fk_deleted_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_deleted_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_deleted_by` FOREIGN KEY (`deleted_by`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------
-- Seed Data: Admin user (password: admin)
-- -------------------------------------------
INSERT INTO `users` (`username`, `password`, `role`, `first_name`, `last_name`) VALUES
('admin', '$2y$10$Hef/4PPNRZ52uKywQY4hrOVKeB6ie2JZHMUqiKNPNI7yXdzZ9cHAO', 'admin', 'Admin', 'System');

-- -------------------------------------------
-- Seed Data: Sample categories
-- -------------------------------------------
INSERT INTO `categories` (`name`, `description`) VALUES
('คอมพิวเตอร์', 'อุปกรณ์คอมพิวเตอร์และไอที'),
('อุปกรณ์สำนักงาน', 'อุปกรณ์สำหรับสำนักงานและการเรียน'),
('อุปกรณ์กีฬา', 'อุปกรณ์สำหรับกิจกรรมกีฬา'),
('อุปกรณ์ทั่วไป', 'อุปกรณ์ทั่วไปอื่นๆ');

-- -------------------------------------------
-- Seed Data: Sample equipment
-- -------------------------------------------
INSERT INTO `equipment` (`name`, `description`, `quantity`, `category_id`, `image`) VALUES
('Laptop Dell XPS 15', 'แล็ปท็อปสำหรับงานนักศึกษา', 5, 1, 'default.jpg'),
('Projector Epson EB-X41', 'โปรเจกเตอร์สำหรับการนำเสนอ', 3, 2, 'default.jpg'),
('Camera Canon EOS 80D', 'กล้องถ่ายภาพ DSLR', 2, 1, 'default.jpg'),
('Tablet iPad Air', 'แท็บเล็ตสำหรับเรียน', 4, 1, 'default.jpg'),
('ลูกฟุตบอล Adidas', 'ลูกฟุตบอลมาตรฐาน', 10, 3, 'default.jpg'),
('ไม้แบดมินตัน Yonex', 'ไม้แบดมินตันพร้อมลูก', 8, 3, 'default.jpg');
