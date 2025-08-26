Program Lab6;
{
  By date: day, month, year determine the date and the previous day 
}

// Compiler directive, sets the application type as console
{$APPTYPE CONSOLE}

// Connecting the system library
uses
  SysUtils;

// Custom Type Declaration Block
Type
  TDW = (Mon = 1,Tue,Wed,Thu,Fri,Sat,Sun);
  TMonth = (Jan = 1,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec);
{
 TDW - the type containing days of the week;
 TMonth - type containing months
}

// Constant declaration block
Const
  BasicY = 2022;
  BasicM = 12;
  BasicDM = 25;
  BasicDW = 7 ;
  T_BasicDW = Sun;
  Delta1 = 1;
  Delta2 = 2;
{
 BasicY - the year of a specific date from which the days of the week are counted;
 BasicM - the month of a specific date from which the days of the week are counted; 
 BasicDM - the day of a specific date from which the days of the week are counted;
 BasicDW - the day of the week of a specific date from which the days of the week are counted;
 T_BasicDW - the variable BasicDW in TDW type;
 Delta1 - the value for determining the day of the week of a predefined day in the desired year when it earlier than predefined;
 Delta2 - the value for determining the day of the week of a predefined day in the desired day when it later than predefined;
}

// Variable declaration block
Var
  Day, Year, LeapNum, ShiftNum, Month, Diff, Check, DWNum, n: Integer;
  Dir: SmallInt;
  NewDW, MCount, Term, Excess, Incr, i: Byte;
  ThisDW, InpStr: String[9];
  Flag: Boolean;
  T_NewDW,T_DW: TDW;
  T_Month: TMonth;
{
 Day - the day (number) that the user enters, then for which the day of the week is determined;
 Month - the month that the user enters, then the end date month;
 Year - the year that the user enters, then the end date year;
 LeapNum - the number of leap years, located beetween predefined and end date years;
 ShiftNum - the shift in calculation of the day of the week for predefined date in the end date year;
 DW - the day of the week of desired date;
 Diff - the differense between the day of the desired number and the predetermined;
 DWNum - the number of the day of the week in relation to the predefined;
 n - the cycle variable for calculating the required day of the week;
 Check - the variable to calculate tne number of years that are multiples of 100 but not multiples of 400;
 Dir - the variable for calculating the number of days in a month: 30 or 31;
 NewDW - the day of the week for predefined date in the end date year;
 MCount - the number of days between the desired date and a predefined date in the end date year;
 Term - the number of days in month in question;
 Excess - the number of years located beetween predefined and end date years, which value is multiples of 100 but not multiples of 400;
 Incr - increment variable check;
 i - the variable for integer checking characters of entered values;
 ThisDW - the string containing the day of the week of the date the user is looking for;
 InpStr - the string containing values entered by the user;
 Flag - the Boolean variable for input checking loop entry or exit;
 T_NewDW - the variable NewDW in TDW type;
 T_DW - the variable DW in TDW type;
 T_Month - the variable Month in TDW type
}

 Begin

  // Checking the entered days input
  // Assigning a false value to a boolean variable in order to enter the cycle of checking the entered date
  Flag := False;
  While not Flag do
  Begin

    // Checking the entered days input
    While not Flag do
    Begin

      // Assigning a true value to a boolean variable in order to get out of the cycle of checking the entered month
      Flag := True;
      Writeln('Enter the day (number) of the date of interest: ');

      // Assignment of the entered value to the line for further verification of it for an integer
      Readln(InpStr);

      // Each character must be a number in the ASCII encoding table
      For i := 1 to Length(InpStr) do
      Begin
        If (Ord(InpStr[i]) < 48) or (Ord(InpStr[i]) > 57) then

          // Assigning a false value to a boolean variable in order to repeat the input of the day number
          Flag := False;
      End;
      If not Flag then
      Begin
        Writeln('Incorrect input!');
        Writeln('The day value entered must be an integer');
      End;
      // The block of checking the entered value of the day for reality
      If Flag then
      Begin
        
        // Converting a value from a string to an integer type
        Day := StrToInt(InpStr);
        
        // Converting a number to a standard form
        Day := Ord(Day);
        
        // The number must be non-zero and a maximum of two digits
        If (Day = 0) or (Length(InpStr) > 2) then
        Begin
          Writeln('Incorrect input!');
          Writeln('Day of the month must be positive single or double digit integer');
          Flag := False;
        End;
      End;
    End;

    // Checking the entered month input
    // Assigning a false value to a boolean variable in order to enter the cycle of checking the entered date
    Flag := False;
    While not Flag do
    Begin

      // Assigning a true value to a boolean variable in order to get out of the cycle of checking the entered month
      Flag := True;
      Writeln('Enter the month of the date of interest: ');

      // Assignment of the entered value to the line for further verification of it for an integer
      Readln(InpStr);
      Month := 0;
      
      // Checking the entered characters for belonging to digits in the ASCII encoding table
      If (Ord(InpStr[1]) >= 48) and (Ord(InpStr[1]) <= 57) then
      Begin

          // Each character must be a number in the ASCII encoding table
          For i := 2 to Length(InpStr) do
          Begin
            If (Ord(InpStr[i]) < 48) or (Ord(InpStr[i]) > 57) then

              // Assigning a false value to a boolean variable in order to repeat the input of the month number
              Flag := False;
          End;
          If not Flag then
          Begin
              Writeln('Incorrect input!');
              Writeln('The month value entered must be an integer');
          End;
          If Flag then
          Begin

            // Converting a value from a string to an integer type
            Month := StrToInt(InpStr);

            // Converting a number to a standard form
            Month := Ord(Month);

            // The number of the month must be non-zero and not greater than 12
            If (Month = 0) or (Month > 12) then
            Begin
              Writeln('Incorrect input!');
              Writeln('The month value must be positive and integer not exceed 12');
              Flag := False;
            End;
          End;
      End
      Else
      Begin

        // Convert all lowercase letters to uppercase letters to determine the month
        For i := 1 to Length(InpStr) do
          InpStr[i] := UpCase(InpStr[i]);
      End;

      // The month definition block that the user entered
      If ((Month = 1) or (InpStr = 'JANUARY')) and Flag then
      Begin
        T_Month := Jan;
        Flag := False;
      End;
      If ((Month = 2) or (InpStr = 'FEBRUARY')) and Flag then
      Begin
        T_Month := Feb;
        Flag := False;
      End;
      If ((Month = 3) or (InpStr = 'MARCH')) and Flag then
      Begin
        T_Month := Mar;
        Flag := False;
      End;
      If ((Month = 4) or (InpStr = 'APRIL')) and Flag then
      Begin
        T_Month := Apr;
        Flag := False;
      End;
      If ((Month = 5) or (InpStr = 'MAY')) and Flag then
      Begin
        T_Month := May;
        Flag := False;
      End;
      If ((Month = 6) or (InpStr = 'JUNE')) and Flag then
      Begin
        T_Month := Jun;
        Flag := False;
      End;
      If ((Month = 7) or (InpStr = 'JULY')) and Flag then
      Begin
        T_Month := Jul;
        Flag := False;
      End;
      If ((Month = 8) or (InpStr = 'AUGUST')) and Flag then
      Begin
        T_Month := Aug;
        Flag := False;
      End;
      If ((Month = 9) or (InpStr = 'SEPTEMBER')) and Flag then
      Begin
        T_Month := Sep;
        Flag := False;
      End;
      If ((Month = 10) or (InpStr = 'OCTOBER')) and Flag then
      Begin
        T_Month := Oct;
        Flag := False;
      End;
      If ((Month = 11) or (InpStr = 'NOVEMBER')) and Flag then
      Begin
        T_Month := Nov;
        Flag := False;
      End;
      If ((Month = 12) or (InpStr = 'DECEMBER')) and Flag then
      Begin
        T_Month := Dec;
        Flag := False;
      End;
      If Flag then
      Begin
        Writeln('Incorrect input!');
        Writeln('Åhe value of the month must be a number or its name in English');
        Flag := False;
      End
      Else
        Flag := True;
    End;

    // Checking the entered years input
    // Assigning a false value to a boolean variable in order to enter the cycle of checking the entered date
    Flag := False;
    While not Flag do
    Begin

      // Assigning a true value to a boolean variable in order to get out of the cycle of checking the entered year
      Flag := True;
      Writeln('Enter the year of the date you are interested in: ');

      // Assignment of the entered value to the line for further verification of it for an integer
      Readln(InpStr);

      // Each character must be a number in the ASCII encoding table
      For i := 1 to Length(InpStr) do
      Begin
        If (Ord(InpStr[i]) < 48) or (Ord(InpStr[i]) > 57) then

          // Assigning a false value to a boolean variable in order to get out of the cycle of checking the entered year
          Flag := False;
        If not Flag then
        Begin
          Writeln('Incorrect input!');
          Writeln('The year value entered must be an integer');
        End;
      End;
      If Flag then
      Begin
        
        // Converting a value from a string to an integer type
        Year := StrToInt(InpStr);
        
        // The year should not be earlier than our era and not exceed the range of values of the Integer type
        If (Year = 0) or (Length(InpStr) > 8) then
        Begin
          Writeln('Incorrect input!');
          Writeln('The value of the year must be positive and of integer type');
          Flag := False;
        End;
      End;
    End;

    // Determining the maximum number of days in each month
    Case T_Month of
      Jan,Mar,May,Jul,Aug,Oct,Dec:
        Term := 31;
      Apr,Jun,Sep,Nov:
        Term := 30;
      Feb:

        // The number of days in February should depend on the leap year
        Begin
          If (Year mod 4 = 0) and (Year mod 100 <> 0) or (Year mod 400 = 0) then
            Term := 29
          Else
            Term := 28;
        End;
    End;

    // The number of days entered can't exceed the maximum number of days in a month
    If Day > Term then
    Begin

      // Assigning a false value to a boolean variable in order to enter the cycle of checking the entered date because of incorrect input
      Flag := False;
      Writeln('Incorrect input!');
      Writeln('You entered an invalid date');
    End;
  End;

  // Block for calculating the date previous to the entered
  // If the entered day is greater than one, then the month and year will remain the same
  If Day > 1 then
    Day := Pred(Day)

  // If the entered number is the first, then the month and, possibly, the year will change in the received date
  Else
  Begin

    // Calculating the number of days in each month
    Case T_Month of
      May,Jul,Oct,Dec:
        Day := 30;
      Feb,Apr,Jun,Aug,Sep,Nov:
        Day := 31;
      Jan:
      Begin
        Day := 31;
        Year := Year-1;
      End
      Else

      // Calculating the number of days in February
      Begin

        // A leap year is one that is multiple of 4 but not a multiple of 100 or a multiple of 400
        If (Year mod 4 = 0) and (Year mod 100 <> 0) or (Year mod 400 = 0) then
          Day := 29
        Else
          Day := 28;
      End;
    End;
    
    // Jan is the first value of the custom type of months, so the previous month needs to be searched separately
    If T_Month = Jan then
    Begin
      T_Month := Dec;
    End
    
    // For the remaining months, the previous ones are a built-in function
    Else
    Begin
      T_Month := Pred(T_Month);
    End;
  End;

  // Block for calculating the day of the week of a predefined date
  If Year >= BasicY then
  Begin
    Excess := 0;
    Check := BasicY;
    Incr := 1;

    // Loop to calculate the number of exceptions years that are a multiple of 100 but not a multiple of 400
    While Check <= Year do
    Begin
      If (Check mod 100 = 0) and (Check mod 400 <> 0) then
      Begin
        Excess := Excess+1;

        // After the first found value, it is enough that the increment is equal to 100
        Incr := 100;
      End;
      Check := Check+Incr;
    End;

    // The number of leap years in this span will be equal to the number of multiples of 4 without the number of exceptions
    LeapNum := (Year-(BasicY-Delta2)) div 4-Excess;
    ShiftNum :=(Year-BasicY)+LeapNum;
    
    // The days of the week are counted from a predetermined day
    T_DW := T_BasicDW;
    DWNum := BasicDW+ShiftNum;
    
    // The cycle of finding the day of the week for a predefined number, but the desired year
    For n := BasicDW+1 to DWNum do
    Begin
      
      // Sun is the last value of the custom type of days of the week, so the next day for it needs to be searched separately
      If T_Dw <> Sun then
      Begin
        T_DW := Succ(T_DW);
      End
      Else
        
      // For the remaining days of the week, the following ones are a built-in function
      Begin
        T_DW := Mon;
      End;
    End;
  End
  Else
  Begin
    Excess := 0;
    Check := Year;
    Incr := 1;
    While Check <= BasicY do
    Begin
      
      // A leap year is one that is multiple of 4 but not a multiple of 100 or a multiple of 400
      If ((Check+1) mod 100 = 0) and ((Check+1) mod 400 <> 0) then
      Begin
        Excess := Excess+1;

        // After the first found value, it is enough that the increment is equal to 100
        Incr := 100;
      End;
      Check := Check+Incr;
    End;

    // The number of leap years in this span will be equal to the number of multiples of 4 without the number of exceptions
    LeapNum := (BasicY+Delta1-Year) div 4-Excess;
    ShiftNum := (BasicY-Year)+LeapNum;
    DWNum := BasicDW-ShiftNum;
    
    // The days of the week are counted from a predetermined day
    T_DW := T_BasicDW;
    For n := BasicDW-1 downto DWNum do
    Begin
      
      // Mon is the first value of the custom days of the week type, so you need to search for the previous day separately
      If T_Dw <> Mon then
      Begin
        
        // For the other days of the week, the previous ones are a built-in function
        T_DW := Pred(T_DW);
      End
      Else
      Begin
        T_DW := Sun;
      End;
    End;
  End;
  
  //  Day of the week for predefined date in the end date year
  T_NewDW := T_DW;
  
  // Block for calculating the desired day of the week
  // Calculating for dates greater than predefined
  If (Day >= BasicDM) and (BasicM = Ord(T_Month)) then
  Begin

    // Finding the difference in the number of days
    ShiftNum := Day-BasicDM;

    // A difference of 7 days returns the same value as the predefined date
    DWNum := Ord(T_DW)+ShiftNum;
    For n := Ord(T_NewDW)+1 to DWNum do
    Begin
      
      // Sun is the last value of the custom type of days of the week, so the next day for it needs to be searched separately
      If T_DW <> Sun then
        T_DW := Succ(T_DW)
      
      // For the remaining days of the week, the following ones are a built-in function
      Else
        T_DW := Mon;
    End;
  End

  // Calculating for dates less than predefined
  Else
  Begin
    MCount := 1;
    ShiftNum := 0;
    Dir := 1;

    // Calculating of the number of days between a predefined and a desired date
    While MCount <= (BasicM-Ord(T_Month)) do
    Begin

      // Calculate the number of days in each month
      Case MCount of
        1:
        Begin

          // Should be taken part of December before a predetermined data
          ShiftNum := ShiftNum+25;
          Term := 30;
        End;
        2..4,7..9:
        Begin
          ShiftNum := ShiftNum+Term;

          // There is an alternation of 30 and 31 number of days
          Term := Term+Dir;
          Dir := Dir*(-1);
        End;

        // August and July violate tne alternation
        5:
          ShiftNum := ShiftNum+Term;
        6:
        Begin
          ShiftNum := ShiftNum+Term;

          // There is an alternation of 30 and 31 number of days
          Term := Term+Dir;
          Dir := Dir*(-1);
        End;
        10:
        Begin

          // The number of days in February should depend on the leap year
          ShiftNum := ShiftNum+Term;
          If (Year mod 4 = 0) and (Year mod 100 <> 0) or (Year mod 400 = 0) then
            Term := 29
          Else
            Term := 28;
        End;
        11:
        Begin

          // Bacause there is December before January
          ShiftNum := ShiftNum+Term;
          Term := 31;
        End;
      End;
      MCount := MCount+1;
    End;

    // The case of the coincidence of the month of the desired and predetermined dates
    If Ord(T_Month) = BasicM then
      ShiftNum := BasicDM-Day
    Else

      // In case of difference month, the day of the week is searched backwards
      ShiftNum := ShiftNum+(Term-Day);

      // Calculating the day of week of a given date
      For n := NewDW-1 downto NewDW-ShiftNum do
      Begin
       
        // Mon is the first value of the custom days of the week type, so you need to search for the previous day separately
        If T_DW <> Mon then
          
          // For the other days of the week, the previous ones are a built-in function
          T_DW := Pred(T_DW)
        Else
         T_DW := Sun;
      End;
  End;
  
  // Determining the value of the desired month
  Case T_Month of
      Jan:
        Month := 1;
      Feb:
        Month := 2;
      Mar:
        Month := 3;
      Apr:
        Month := 4;
      May:
        Month := 5;
      Jun:
        Month := 6;
      Jul:
        Month := 7;
      Aug:
        Month := 8;
      Sep:
        Month := 9;
      Oct:
        Month := 10;
      Nov:
        Month := 11;
      Dec:
        Month := 12;
  End;
  
  // Determining the desired day of the week
  Case T_DW of
      Mon:
        ThisDW := 'Monday';
      Tue:
        ThisDW := 'Tuesday';
      Wed:
        ThisDW := 'Wednesday';
      Thu:
        ThisDW := 'Thursday';
      Fri:
        ThisDW := 'Friday';
      Sat:
        ThisDW := 'Saturday';
      Sun:
        ThisDW := 'Sunday';
  End;

  // Output of the required data and its day of the week
  Writeln(ThisDW, ' ', Day, '.', Month, '.', Year);
  Readln
End.


