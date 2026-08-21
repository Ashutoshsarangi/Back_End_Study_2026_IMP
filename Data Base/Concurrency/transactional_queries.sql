select * from account;

update account set balance = balance + 2000 where name = 'Alice Johnson';


BEGIN TRANSACTION;
update account set balance = balance + 1000 where id = 1;
update account set balance = balance - 1000 where id = 3;
COMMIT;

-- RollBack
BEGIN TRANSACTION;
update account set balance = balance + 1000 where id = 1;
update account set balance = balance - 1000 where id = 3; -- If some error happen
ROLLBACK;

advantages:-

-- race condition

