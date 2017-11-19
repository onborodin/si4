
drop table domain;
drop table user;
drop table alias;

create table domain (
    id int unique,
    name text unique
);

insert into domain values(1,'unix7.pro');
insert into domain values(2,'unix7.org');

create table user (
    id int unique,
    name text,
    domainid int,
    password text
);

insert into user values(2,'abc1',2,'12345');
insert into user values(3,'abc3',1,'12345');
insert into user values(4,'abc5',2,'12345');

create table alias (
    id int unique,
    name text,
    domainid int,
    goto text
);
insert into alias values(1,'ccc1', 2,'a@b.c');
insert into alias values(2,'ccc2', 1,'a@b.c');


