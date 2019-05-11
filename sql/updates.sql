alter table account add column phone_extension character varying(255);
alter table account add column cell_phone character varying(255);
alter table account add column fax character varying(255);
alter table account add column website character varying(255);
alter table account add column company character varying(255);
alter table account add column title character varying(255);
alter table account add column deleted boolean;
alter table account add column verified boolean;

alter table account add column territory_id bigint;
alter table account add column size_id bigint;
alter table account add column status_id bigint;


update account set deleted = false;
update account set verified = false;