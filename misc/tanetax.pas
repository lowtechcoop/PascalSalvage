program TaneTax;
uses crt;
{
This program will calculate a rough approximation of tax , rebates, and
any refund due for the 1998-99 tax year
}

var
{----Input Variables----}
YearIncome,
PAYEdeduction,
GrossInterest,
RWT,
OtherIncome,
Expenses,
Donations,
Childcare : Word;
WeeksWorked:byte;
{----Calculated Variables----}
TotalIncome,
TotalTaxableIncome :word;
TotalTaxPaid, TotalTaxDue,ResidualTax:real;
Rebate1,Rebate2,Rebate3,Rebate4,TotalRebate:real;
{----Temporary Variables----}
TempA:real;

Procedure InputData;
{----Collect Data from User----}
begin
   Writeln('What was your income from Wages/Salary for the year April 1998 to March 1999?');
   readln(YearIncome);

   Writeln('What was the total PAYE deduction from your Wages/Salary?');
   readln(PAYEdeduction);

   Writeln('How much gross interest was paid to you on savings?');
   readln(GrossInterest);

   Writeln('How much Resident Withholding Tax (RWT) was deducted from the interest?');
   readln(RWT);

   Writeln('What was the amount of any other Income you earned (untaxed at source) ?');
   readln(OtherIncome);

   Writeln('What expenses were incurred when preparing the tax return or investing money?');
   readln(Expenses);

   Writeln('How many weeks during the year did you work 20 or more hours?');
   readln(WeeksWorked);

   Writeln('What was the total amount of donations to charitable organisations?');
   readln(donations);

   writeln('What was the payment to a housekeeper, or childcare?');
   readln(childcare);

end;

procedure Calculations;
begin;
   TotalIncome:=yearincome+otherincome+grossinterest;
   TotalTaxPaid:=PAYEdeduction+RWT;
   TotalTaxableIncome:=TotalIncome-Expenses;
{----Rebate 1 calculation----}
case TotalTaxableIncome of
     0..6240: Rebate1:=14*WeeksWorked;
     6241..9880: Rebate1:=(((9880-TotalTaxableIncome)*(0.2*WeeksWorked))/52);
  else
    Rebate1:=0;
end;
{----Rebate 2 Calculation----}
case TotalTaxableIncome of
     0..9499:Rebate2:=(TotalTaxableIncome-GrossInterest)*0.65;
     9500..34199: begin
          TempA:=TotalTaxableIncome-GrossInterest;
          if TempA > 9500 then TempA:=9500;
          Rebate2:=TempA*0.065;
          Rebate2:=Rebate2-((TotalTaxableIncome-9500)*0.025);
          if Rebate2<0 then Rebate2:=0;
     end;
     else
       Rebate2:=0;
end;
{----Rebate 3 Calculation----}
If Donations < 1500 then Rebate3:=Donations/3 else Rebate3:=500;

{----Rebate 4 Calculation----}
If Childcare<940 then Rebate4:=Childcare*0.33 else Rebate4:=310;

{----Total Rebate Calculation----}
TotalRebate:=Rebate1+Rebate2+Rebate3+Rebate4;

{----Tax Due Calculation----}
If TotalTaxableIncome<=34200
then TotalTaxDue:=TotalTaxableIncome*0.215 else TotalTaxDue:=((7353+(TotalTaxableIncome-34200))*0.33);

TotalTaxDue:=TotalTaxDue-TotalRebate;
If TotalTaxDue<0 then TotalTaxDue:=0;
ResidualTax:=TotalTaxDue-TotalTaxPaid;

end;

Procedure Output;
{----Outputs all processed data----}
begin
ClrScr;
Writeln('Processing Complete. Here are the results.');
Writeln;
Writeln('Total Income = $',TotalIncome);
Writeln('Taxable Income = $',TotalTaxableIncome);
Writeln('Rebate1 = $',round(Rebate1));
Writeln('Rebate2 = $',round(Rebate2));
Writeln('Rebate3 = $',round(Rebate3));
Writeln('Rebate4 = $',round(Rebate4));
Writeln('Total Rebate = $',round(TotalRebate));

Writeln('Tax Due = $',round(TotalTaxDue));
Writeln('Residual tax to pay =');
if ResidualTax>0 then writeln('Tax Due = $',round(ResidualTax));
if ResidualTax<0 then Writeln('Refund Due =$',round(ResidualTax*(-1)));
Writeln;
Writeln('Tax Calculator v0.0');
end;

begin;
clrscr;
inputdata;
calculations;
output;
end.


