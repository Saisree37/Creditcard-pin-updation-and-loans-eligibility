set serveroutput on;
create table cc_pin (credit_card_number number,phone_number number,pin number,modified_date date,modified_by varchar2(100));
insert into cc_pin values(TO_CHAR(4123123434564567),9630258741,1111,sysdate,'sai');
commit;
select * from cc_pin;
/
create or replace procedure cc_pin_updation(p_cc_num number,p_pin number,p_msg number)
as
	l_count number;
 	l_cc varchar2(100);
	cc_length_exception exception;
	cc_invalid exception;
begin
	select count(*) into l_count from cc_pin where credit_card_number=p_cc_num;
	if length(p_pin)=4 and l_count=1 then
		l_cc :=substr(p_cc_num,1,4)||' XXXX XXXX '||substr(p_cc_num,-4);
		update cc_pin set pin=p_pin,modified_date=sysdate,modified_by user where credit_card_number=p_cc_num;
		commit;
		p_msg :='Your pin for credit card '||l_cc||' has been updated successfully';
	elsif length(p_pin)<>4 then 
		raise cc_length_exception;
	elsif l_count=0 then
		raise cc_invalid;
	end if;
	exception 	
		when cc_length_exception then
			p_msg :='length of the pin should be 4 digit only';	
		when cc_invalid then
			p_msg :=p_cc_num||' credit card number is not valid';
end cc_pin_updation;
end;
/
declare
	msg varchar2(100);
begin
	cc_pin_updation(1234123412341234,9999,msg);
	dbms_output.put_line(msg);
end;
