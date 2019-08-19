PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

-- Seeding for Users Table
INSERT INTO
    users
    (fname, lname)
VALUES
    ("Josh", "Kim"),
    ("Marvin", "Ma");

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- Seeding for Questions table
INSERT INTO
    questions
    (title, body, author_id)
VALUES
    ("Josh's Question", "????", 1),
    ("Marvin's Question", "?????", 2);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);
--Seeding for Question Followers
INSERT INTO
    question_follows
    (user_id, question_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);
--Seeding for Replies Table
INSERT INTO
    replies
    (question_id, parent_reply_id, user_id, body)
VALUES
    (1, NULL, 2, "Question 1 Reply"),
    (1, 1, 1, "Question 1.1 Reply");

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

--Seeding for Question Likes
INSERT INTO
    question_likes
    (user_id, question_id)
VALUES
    (2, 1),
    (1, 2);


