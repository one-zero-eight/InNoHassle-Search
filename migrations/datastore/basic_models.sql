create table contact (
    id bigint primary key,
    name varchar not null,
    telegram_id bigint unique,
    telegram_alias varchar unique,
    phone varchar(11) unique,
    email varchar unique,
    extra varchar,
    constraint contact_phone_number_format check (phone ~ '^\+?[0-9]{1,3}-?[0-9]{3}-?[0-9]{3}-?[0-9]{4}$')
);

comment on table contact is 'Контакт';
comment on column contact.name is 'Имя контакта';
comment on column contact.telegram_alias is 'Alias пользователя';
comment on column contact.telegram_id is 'Id телеграм аккаунта контакта в телеграме';
comment on column contact.phone is 'Номер мобильного телефона контакта';
comment on column contact.email is 'E-mail адрес контакта';
comment on column contact.extra is 'Дополнительная информация';

create table university_room (
    room_number varchar primary key
);

comment on table university_room is 'Помещение в иннополисе';
comment on column university_room.room_number is 'Номер помещения';

create table schedule (
    id bigint primary key,
    name varchar not null,
    cron varchar not null,
    start_time timestamp not null,
    stop_time timestamp not null,
    exceptions bigint[] not null default array[]::bigint[]
);

comment on table schedule is 'Расписание события';

create table tag (
    name varchar primary key
);

comment on table tag is 'Теги';

create table internet_resource (
    id bigint primary key,
    link varchar not null unique,
    name varchar not null,
    preview bytea,
    description varchar
);

comment on table internet_resource is 'Сайты или чаты в телеграме';

create table club (
    name varchar primary key,
    logo bytea,
    description varchar,
    schedule_id bigint references schedule
);

create table club_contact (
    club_name varchar not null references club,
    contact_id bigint not null references contact,
    primary key (club_name, contact_id)

);

comment on table club is 'Описание клуба';

create table name (
    id bigint primary key,
    first_name varchar not null,
    second_name varchar not null,
    middle_name varchar
);

create table teacher (
    id bigint primary key,
    name_id bigint not null references name,
    contact_id bigint references contact,
    office varchar references university_room
);

comment on table teacher is 'Описание преподавателя (TA/Prof)';

create table grading (
    id bigint primary key
);

create table grades_threshold (
    grading_id bigint not null references grading,
    grade varchar(1) not null,
    threshold smallint not null,
    primary key (grading_id, grade),
    constraint grades_activity_threshold_range check (threshold between 0 and 100)
);

create table grades_activity (
    grading_id bigint not null references grading,
    activity_type varchar not null,
    percentage smallint not null,
    primary key (grading_id, activity_type),
    constraint grades_activity_percentage_range check (percentage between 0 and 100)
);

create table course (
    code varchar primary key,
    name varchar not null,
    year smallint not null,
    type varchar(2) not null,
    grading_id bigint not null references grading,
    semester varchar(6) not null,
    syllabus varchar,
    schedule_id bigint references schedule,
    constraint course_id_type_enum check (type in ('BS', 'MS', 'E')),
    constraint course_id_semester_enum check (semester in ('Fall', 'Spring', 'Summer')),

);

comment on table course is 'Описание проводимого/проведённого курса';

create table office_hours (
    course_code varchar not null references course,
    teacher_id bigint not null references teacher,
    schedule_id bigint references schedule,
    room_name varchar references university_room,
    primary key (course_code, teacher_id)
);

comment on table office_hours is 'Описание определённого office-hours';

create table teacher_course (
    teacher_id bigint not null references teacher,
    course_code bigint not null references course,
    primary key (teacher_id, course_code)
);

create table events (
    id bigint primary key,
    name varchar not null,
    preview bytea,
    event_start timestamp not null,
    description varchar
);

comment on table events is 'Опубоикованные меропрития';

create table dorm (
    number smallint primary key,
    cleaning_schedule_id bigint not null references schedule,
    linen_change_schedule bigint not null references schedule
    constraint dorm_number_range check (number between 1 and 7)
);

comment on table dorm is 'Описание общаги';

create table location (
    id bigint primary key,
    latitude double precision not null,
    longitude double precision not null
);

create table organization (
    id bigint primary key,
    name varchar not null,
    location_id bigint references location,
    schedule_id bigint references schedule,
    description varchar
);

-- further add many-to-many relations for tags