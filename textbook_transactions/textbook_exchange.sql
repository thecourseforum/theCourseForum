# Author Lawrence Hook

CREATE TABLE `textbook_transactions` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`seller_id` int(11) NOT NULL,
	`buyer_id` int(11) DEFAULT NULL,
	`book_id` int(11) NOT NULL,
	`price` int(11) NOT NULL,
	`condition` varchar(255) NOT NULL,
	`notes` text DEFAULT NULL,
	`created_at` datetime NOT NUll,
	`updated_at` datetime NOT NUll,
	`sold_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `index_textbook_transactions_on_seller_id_and_buyer_id` (`seller_id`, `buyer_id`) USING BTREE,
	KEY `index_textbook_transactions_on_seller_id` (`seller_id`) USING BTREE,
	KEY `index_textbook_transactions_on_buyer_id` (`buyer_id`) USING BTREE,
	KEY `index_textbook_transactions_on_book_id` (`book_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `books_users` (
	`book_id` int(11) NOT NULL,
	`user_id` int(11) NOT NULL,
	UNIQUE KEY `index_books_users_on_book_id_and_user_id` (`book_id`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE users
ADD COLUMN cellphone varchar(255) DEFAULT NULL AFTER email;
