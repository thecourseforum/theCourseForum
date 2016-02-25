ALTER TABLE books
ADD created_at datetime,
ADD updated_at datetime;

CREATE INDEX index_books_on_updated_at ON books(updated_at) USING BTREE;