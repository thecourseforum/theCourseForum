# Author Lawrence Hook

CREATE TABLE `textbook_transactions` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`seller_id` int(11) DEFAULT NULL,
	`buyer_id` int(11) DEFAULT NULL,
	`book_id` int(11) NOT NULL,
	`price` int(11) NOT NULL,
	`condition` varchar(255) NOT NULL,
	`created_at` datetime NOT NUll,
	`updated_at` datetime NOT NUll,
	`sold_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE users
ADD COLUMN cellphone int(11) DEFAULT NULL AFTER email;
