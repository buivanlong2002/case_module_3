
CREATE
DATABASE IF NOT EXISTS `CASE_MODULE_3` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;


USE
`CASE_MODULE_3`;

CREATE TABLE `users`
(
    `user_id`  INT          NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50)  NOT NULL,
    `email`    VARCHAR(100) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `phone`    VARCHAR(20)  DEFAULT NULL,
    `address`  VARCHAR(255) DEFAULT NULL,
    `birthday` DATE         DEFAULT NULL,
    `image`    VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `username` (`username`),
    UNIQUE KEY `email` (`email`)
)

-- Tạo bảng user_sessions
CREATE TABLE `user_sessions`
(
    `session_id` VARCHAR(36)  NOT NULL,
    `user_id`    INT          NOT NULL,
    `login_time` DATETIME     NOT NULL,
    `ip_address` VARCHAR(45)  NOT NULL,
    `user_agent` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`session_id`),
    KEY          `user_id` (`user_id`),
    CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
)

-- Tạo bảng faceid
CREATE TABLE `faceid`
(
    `id`         INT          NOT NULL AUTO_INCREMENT,
    `user_id`    INT          NOT NULL,
    `face_token` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `faceid_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
)
