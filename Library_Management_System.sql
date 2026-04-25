-- Library Management System
drop table if exists branch;
create table branch(
	branch_id varchar(10) primary key,
	manager_id varchar(10),
	branch_address varchar(55),
	contact_no varchar(10));
alter table branch 
alter column contact_no type varchar(20);

drop table if exists employees;
create table employees
(
	emp_id varchar(10) primary key,
	emp_name varchar(25),
	position varchar(15),
	salary int,
	branch_id varchar(10) --foreign key
);

drop table if exists books;
create table books
(
	isbn varchar(10) primary key,	
	book_title varchar(75),	
	category varchar(20),	
	rental_price float,	
	status varchar(15),	
	author varchar(35),	
	publisher varchar(55)

);
alter table books
alter column author type varchar(55);

alter table books
alter column isbn type varchar(30);


drop table if exists members;
create table members
( 	member_id varchar(10) primary key,
	member_name varchar(35),	
	member_address varchar(75),	
	reg_date date
);

drop table if exists issued_status;
create table issued_status
(	issued_id varchar(15) primary key,	
	issued_member_id varchar(15),	-- foreign key
	issued_book_name varchar(75),	
	issued_date date,	
	issued_book_isbn varchar(25),	--foreign key
	issued_emp_id varchar(10)		--foregin key


);

drop table if exists return_status;
create table return_status
(	return_id varchar(10) primary key,	
	issued_id varchar(10),	
	return_book_name varchar(75),	
	return_date date,	
	return_book_isbn varchar(20)



);

--Foreign Key constraints
alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);

alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

alter table return_status
add constraint fk_issued_id
foreign key (issued_id)
references issue_status(issued_id);

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

--Task 2: Update an Existing Member's Address
update members
set member_address = '779 Oakwood Avenue'
where member_id = 'C103';
select * from members;

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id = 'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select issued_book_name from issued_status
where issued_emp_id = 'E101';

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id,count(*)
from issued_status
group by issued_emp_id
having count(*)>1;

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_issue_cnt as
select b.isbn,b.book_title,count(ist.issued_id) as issue_count
from issued_status as ist
join books as b
on ist.issued_book_isbn = b.isbn
group by 1,2;
select * from book_issue_cnt;

-- Task 7: Retrieve All Books in a Specific Category:
select book_title from books where category = 'Classic';

--Task 8:  Find Total Rental Income by Category:
select b.category,sum(b.rental_price) as total_rental_price,count(*)
from books as b 
join issued_status as ist
on b.isbn = ist.issued_book_isbn
group by 1

--Task 9: List Members Who Registered in the Last 180 Days:
select * from members
where reg_date >= Current_Date - Interval '180 days';
--Task 10: List Employees with Their Branch Manager's Name and their branch details:
select 
e1.emp_id,e1.emp_name,e1.position,e2.emp_name as manager,b.*
from employees as e1
join 
branch as b
on b.branch_id = e1.branch_id
join employees as e2
on b.manager_id = e2.emp_id;
--Task 11: Create a Table of Books with Rental Price Above a Certain Threshold:
create table overprice_book 
as select * from books where rental_price>5;
select * from overprice_book;
--Task 12: Retrieve the List of Books Not Yet Returned
select *
from issued_status as istat
left join return_status as rs
on rs.issued_id = istat.issued_id
where rs.issued_id is null;

