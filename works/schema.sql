
drop table domain;
create table domain (
    id int unique,
    name text unique
);

drop table user;
create table user (
    id int unique,
    name text,
    domainid int,
    password text
);

drop table alias;
create table alias (
    id int unique,
    name text,
    domainid int
    goto text
);


insert into domain values (1, 'unix7.pro');
insert into domain values (2, 'unix7.org');
 

