
-- timesheet_two edited database 
-- this database is an improved version of timesheet database

create database timesheet_two;

show tables in timesheet_two;

use timesheet_two;


-- bloody timesheet thing 

create table projects(
	project_id smallint(3) not null primary key auto_increment,
	project_name varchar(50) not null unique
);

create table tasks(
	task_id smallint(3) not null primary key auto_increment,
	task_type varchar(50) not null unique
);

create table users(
	user_id smallint(3) not null primary key auto_increment,
	first_name varchar(50) not null,
	surname varchar(50) not null,
    dob date not null,
    manager_id smallint(3), 
    pword varchar(50) check (pword > 6),
    FOREIGN KEY (manager_id) REFERENCES users(user_id)
);

create table timesheet_entries(
	timesheet_entry_id smallint(3) not null primary key auto_increment,
	project_id smallint(3) ,
    user_id smallint(3),
    task_id smallint(3), 
    entry_date datetime check (entry_date >= getdate()),
    dt_submitted datetime,
    duration varchar(10),
    is_approved boolean,
	FOREIGN KEY (project_id) REFERENCES projects(project_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (task_id) REFERENCES tasks(task_id)
);

-- describe

describe projects;

describe timesheet_entries;

describe users;

select * from timesheet_entries;

insert into users(first_name, surname, dob, manager_id, pword) values 
('josh', 'berry', '1998-12-31', 1, 'password'),
('mary', 'berry', '1993-11-19', 1, 'password'),
('callum', 'burn', '1980-03-11', 2, 'password'),
('john', 'berny', '1998-02-02', 2, 'password'),
('cameron', 'ryan', '1990-10-10', 1, 'password');

insert into projects(project_name) values 
('Project 1 > Scrum'),
('Project 2 > Gaming'),
('Project 3 > Mobile App'),
('Project 4 > Main site');

insert into tasks(task_type) values 
('Agile, Scrum'),
('Software Dev'),
('Framework setup'),
('Test');

insert into timesheet_entries(project_id, user_id, task_id, entry_date, dt_submitted, duration, is_approved) values 
(1, 1, 1, '2016-12-31', '2016-12-31', '1', true),
(2, 3, 2, '2016-12-31', '2016-12-31', '2', true),
(3, 2, 2, '2016-12-31', '2016-12-31', '1', true),
(2, 3, 2, '2016-12-31', '2016-12-31', '3', false),
(4, 2, 2, '2016-12-31', '2016-12-31', '1', false);


-- selects that could be executed 
select * from timesheet_entries where entry_date >= '2016-12-31';

-- two joins (joining 2 tables)
select te.entry_date as "Entry Date", 
	   te.dt_submitted as "Date/Time Submitted",
       te.duration as Duration, 
       te.is_approved as "Approved?", 
       u.first_name as "First Name",
	   u.surname as "Last Name",
       u.dob as "Birth Date",
       u.manager_id as "Manager ID",
       p.project_name as "Project Name"
from timesheet_entries as te
inner join users as u
on te.user_id=u.user_id
inner join projects as p
on te.project_id=p.project_id
order by p.project_name asc;


-- hours spend on a project

select sum(te.duration) as "Hours Spend", 
       p.project_name as "Project Name"
from timesheet_entries as te
inner join projects as p
on te.project_id=p.project_id
group by p.project_name asc;


-- hours spend on a task

select sum(te.duration) as "Hours Spend", 
       t.task_type as "Task Type"
from timesheet_entries as te
inner join tasks as t
on te.task_id=t.task_id
group by t.task_type asc;

