# Author: Lawrence Hook

# SQL changes from master to beta

# populate books, book_requirements, stats

CREATE TABLE stats AS 
  (SELECT sections.course_id, 
          section_professors.professor_id 
   FROM   sections 
          JOIN section_professors 
            ON section_professors.section_id = sections.id 
   GROUP  BY course_id, 
             professor_id);

ALTER TABLE stats ADD id int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE stats ADD COLUMN rating double;
ALTER TABLE stats ADD COLUMN difficulty double;
ALTER TABLE stats ADD COLUMN gpa double;

CREATE TABLE `book_requirements` (
  `section_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  UNIQUE KEY `index_book_requirements_on_book_id_and_section_id` (`book_id`,`section_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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


CREATE TABLE `bugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `description` text,
  `email` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `calendar_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `courses_users` (
  `course_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_courses_users_on_user_id_and_course_id` (`user_id`,`course_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `professor_salary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_type` text,
  `assignment_organization` text,
  `annual_salary` int(11) DEFAULT NULL,
  `normal_hours` int(11) DEFAULT NULL,
  `working_title` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE professors
ADD COLUMN `classification` text,
ADD COLUMN `department` text,
ADD COLUMN `department_code` text,
ADD COLUMN `primary_email` text,
ADD COLUMN `office_phone` text,
ADD COLUMN `office_address` text,
ADD COLUMN `registered_email` text,
ADD COLUMN `fax_phone` text,
ADD COLUMN `title` text,
ADD COLUMN `home_phone` text,
ADD COLUMN `home_page` text,
ADD COLUMN `mobile_phone` text,
ADD COLUMN `professor_salary_id` int(11) DEFAULT NULL;

CREATE TABLE `schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `flagged` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `schedules_sections` (
  `schedule_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  UNIQUE KEY `index_schedules_sections_on_schedule_id_and_section_id` (`schedule_id`,`section_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE `section_users`;

ALTER TABLE courses 
ADD COLUMN description text AFTER title;