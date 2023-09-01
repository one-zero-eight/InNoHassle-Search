-- +goose Up
-- +goose StatementBegin
CREATE TABLE thing (
    id   int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    type varchar(255) NOT NULL,

    CHECK (type IN (
                    'CONTACT',
                    'COURSE',
                    'TEACHER',
                    'SCHEDULE',
                    'UNIVERSITY_ROOM',
                    'DORMITORY',
                    'INTERNET_RESOURCE'
        ))
);

CREATE TABLE tag (
    id            int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    parent_tag_id int REFERENCES tag (id),
    name          varchar(100) UNIQUE
);

CREATE TABLE rel_thing_tag (
    thing_id int NOT NULL REFERENCES thing (id),
    tag_id   int NOT NULL REFERENCES tag (id),

    PRIMARY KEY (thing_id, tag_id)
);

CREATE TABLE full_name_translation (
    id          int GENERATED ALWAYS AS IDENTITY,
    thing_id    int          NOT NULL REFERENCES thing (id),
    language    varchar(2)   NOT NULL,
    first_name  varchar(100) NOT NULL,
    last_name   varchar(100) NOT NULL,
    middle_name varchar(100),

    UNIQUE (thing_id, language),
    CHECK ( language IN ('EN', 'RU') )
);

CREATE TABLE title_translation (
    id       int PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    thing_id int          NOT NULL REFERENCES thing (id),
    title    varchar(255) NOT NULL,
    language varchar(2)   NOT NULL,

    UNIQUE (thing_id, language),
    CHECK ( language IN ('EN', 'RU') )
);

CREATE TABLE contact (
    id                int PRIMARY KEY REFERENCES thing (id),
    full_name_id      int NOT NULL REFERENCES full_name_translation (id),
    telegram_id       int UNIQUE,
    telegram_username varchar(32) UNIQUE,
    phone             varchar(20) UNIQUE,
    email             varchar(255) UNIQUE,

    CHECK (phone ~* '^\+\d+$')
);

CREATE TABLE schedule (
    id       int PRIMARY KEY REFERENCES thing (id),
    title_id int NOT NULL REFERENCES title_translation (id)
);

CREATE TABLE university_room (
    id   int PRIMARY KEY REFERENCES thing (id),
    room varchar(8) NOT NULL UNIQUE
);

CREATE TABLE course (
    id       int PRIMARY KEY REFERENCES thing (id),
    code     varchar(8) NOT NULL UNIQUE,
    title_id int        NOT NULL REFERENCES title_translation (id),
    year     smallint   NOT NULL,
    semester varchar(6) NOT NULL,

    CHECK (semester IN ('FALL', 'SPRING', 'SUMMER'))
);

CREATE TABLE teacher (
    id             int PRIMARY KEY REFERENCES thing (id),
    contact_id     int NOT NULL REFERENCES contact (id),
    office_room_id int REFERENCES university_room (id)
);

CREATE TABLE rel_course_teacher (
    course_id  int NOT NULL REFERENCES course (id),
    teacher_id int NOT NULL REFERENCES teacher (id),

    PRIMARY KEY (course_id, teacher_id)
);

CREATE TABLE dormitory (
    id                       int PRIMARY KEY REFERENCES thing (id),
    number                   smallint UNIQUE,
    cleaning_schedule_id     int NOT NULL REFERENCES schedule (id),
    linen_change_schedule_id int NOT NULL REFERENCES schedule (id),

    CHECK ( number IN (1, 2, 3, 4, 5, 6, 7) )
);

CREATE TABLE internet_resource (
    id       int PRIMARY KEY REFERENCES thing (id),
    title_id int           NOT NULL REFERENCES title_translation (id),
    url      varchar(2048) NOT NULL
);
-- +goose StatementEnd


-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS internet_resource;
DROP TABLE IF EXISTS dormitory;
DROP TABLE IF EXISTS rel_course_teacher;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS university_room;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS contact;
DROP TABLE IF EXISTS title_translation;
DROP TABLE IF EXISTS full_name_translation;
DROP TABLE IF EXISTS rel_thing_tag;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS thing;
-- +goose StatementEnd
