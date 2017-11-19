create table mailbox (
    id int,
    name text,
    domainid int,
    password text
);

create table domain (
    id int,
    name text
);

create table alias (
    id int,
    name text,
    domainid int
);




