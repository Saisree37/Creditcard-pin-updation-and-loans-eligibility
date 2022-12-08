set serveroutput on;
create table credit_card_loan(phone_number number, credit_card_number number,loan_eligibility char(1),loan_amount number);
insert into credit_card_loan values(9876543120,1234123412346666,'N',100000);
commit;
/
create or replace procedure loan_eligibilty_proc(p_phone number,
                                                   p_cc_last number,
                                                   p_msg out varchar2) 
as
	l_loan_amt number;
	l_count number;
	l_loan_eligibility char(1);
	no_record_exception exception;
begin
	select count(*) into l_count from credit_card_loan where phone_number=p_phone and substr(credit_card_number,-4)=p_cc_last;
		if l_count=0 then
			raise no_record_exception;
		end if;
	select loan_amount into l_loan_amt from credit_card_loan where phone_number=p_phone and substr(credit_card_number,-4)=p_cc_last  and loan_eligibility ='Y';
	p_msg:= 'Approved Loan amount is:'||TO_CHAR(l_loan_Amt,'9,99,999');
	exception 
		when no_record_exception then
			p_msg :='Entered details are incorrect.Please check';
		when no_data_found then
			p_msg:='sorry,no offers available.Please try after sometime';
end loan_eligibilty_proc;

/
declare
	result varchar2(100);
begin
	loan_eligibility_proc(p_phone =>9876543120,p_cc_last_4 =>6666,p_msg => result);
dbms_output.put_line(result);
end;
/