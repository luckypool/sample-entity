DROP DATABASE if EXISTS practice;
CREATE DATABASE practice;
USE practice;

DROP TABLE if EXISTS machine;
CREATE TABLE machine (
    id INT unsigned NOT NULL AUTO_INCREMENT,
    owner INT unsigned NOT NULL,
    os VARCHAR(32) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE if EXISTS developer;
CREATE TABLE developer (
    id INT unsigned NOT NULL AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL,
    company INT unsigned NOT NULL,
    email VARCHAR(64) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE if EXISTS company;
CREATE TABLE company (
    id INT unsigned NOT NULL AUTO_INCREMENT,
    name VARCHAR(32) NOT NULL,
    url VARCHAR(128) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

