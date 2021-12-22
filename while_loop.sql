declare @loopthrough as table (
       Id int,
       Col varchar(63),
       Processed int default(0)
);
 
insert into @loopthrough(Id, Col) values(1, 'ColA')
insert into @loopthrough(Id, Col) values(2, 'ColB')
insert into @loopthrough(Id, Col) values(3, 'ColC')
insert into @loopthrough(Id, Col) values(4, 'ColD')
 
-- Loop through records in table
while (select count(*) from @loopthrough where Processed = 0) > 0
begin
       declare
              @id int,
              @col varchar(63)
 
       -- Select top row
       select top 1 @id = Id, @col = Col from @loopthrough where Processed = 0
 
       -- Do something
       select @id, @col
 
       -- Set current record as Processed for while loop control flow purposes
       update @loopthrough set Processed = 1 where Id  = @id;
end;
