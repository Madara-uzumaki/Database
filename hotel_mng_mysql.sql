# customers table

create table customers(
id int primary key auto_increment,
phonenum int,
email varchar(50) unique,
name varchar(50)
);

#rooms table

create table rooms(
id int primary key auto_increment,
room_num int unique,
room_type varchar(10),
price int,
room_status varchar(10) 
);
insert into rooms(room_num,room_type,price,room_status) values
(101,'single',200,'unbooked'),
(102,'double',300,'unbooked'),
(103,'vip',500,'unbooked'),
(104,'single',200,'unbooked'),
(105,'double',300,'unbooked'),
(106,'vip',500,'unbooked');
#bookings table

create table bookings(
id int primary key auto_increment,
customer_id int,
room_id int ,
foreign key(customer_id) references customers(id),
foreign key(room_id) references rooms(id) 
);




# payments table


create table payments(
id int primary key auto_increment,
booking_id int,
amount int,
payment_date date,
payment_method varchar(20),
foreign key(booking_id) references bookings(id)
);


delimiter $$
create procedure book
(in name varchar(50),
in phonenum int,
in email varchar(50),
in payment_method varchar(20),
in roomnumber int,
in roomtype varchar(10))
begin

insert into customers(name,phonenum,email) values(name,phonenum,email);

insert into bookings(customer_id) values((select id from customers where id=last_insert_id()));
set @bookid=last_insert_id();

insert into payments(booking_id,amount,payment_date,payment_method) 
values(
(select id from bookings where id=last_insert_id()),
(select price from rooms where room_type=roomtype and room_num=roomnumber),
current_date(),
payment_method);

update rooms set room_status = 'booked'
where room_type = roomtype and room_status='unbooked' and room_num=roomnumber;

set @roomid =last_insert_id();
update bookings set room_id=@roomid where id=@bookid;


end $$
delimiter ;


delimiter $$
create procedure unbook(roomnum int)
begin
update rooms set room_status='unbooked' where room_num=roomnum and room_status='booked';
end$$
delimiter ;


delimiter $$
create procedure show_available_rooms()
begin
select *from rooms where room_status='unbooked' ;
end$$
delimiter ; 

delimiter $$
create procedure total_amount_of(name varchar(50))
begin
select sum(a.amount) from payments as a inner join customers as b on b.id=a.id where b.name=name group by payment_date with rollup;
end$$
delimiter ;

 


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 