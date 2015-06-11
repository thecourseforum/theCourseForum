CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `edition` varchar(255) DEFAULT NULL,
  `binding` varchar(255) DEFAULT NULL,
  `isbn` varchar(255) DEFAULT NULL,
  `bookstore_new_price` float DEFAULT NULL,
  `bookstore_used_price` float DEFAULT NULL,
  `asin` text,
  `small_image_link` text,
  `medium_image_link` text,
  `large_image_link` text,
  `amazon_official_new_price` float DEFAULT NULL,
  `amazon_official_used_price` float DEFAULT NULL,
  `amazon_merchant_new_price` float DEFAULT NULL,
  `amazon_merchant_used_price` float DEFAULT NULL,
  `amazon_new_total` int(11) DEFAULT NULL,
  `amazon_used_total` int(11) DEFAULT NULL,
  `amazon_affiliate_link` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_books_on_isbn` (`isbn`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `book_requirements` (
  `section_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  UNIQUE KEY `index_book_requirements_on_book_id_and_section_id` (`book_id`,`section_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;