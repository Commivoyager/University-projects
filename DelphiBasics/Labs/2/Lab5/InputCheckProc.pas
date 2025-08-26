// A subroutine for entering the boundaries of a segment on which arbitrary numbers will be calculated to fill an arbitrary array to be sorted
{
  The user enters the boundaries, the entered data is processed as a string TInpStr. In case of incorrect input, the subroutine will display a message about the need to repeat, otherwise this value will be assigned to the Input variable
}
Procedure InputCheck(Var Str; Var Input: Integer);

  // Type declaration block
  Type
    TInpStr = String[50];
  {
  TInpStr - the type of string passed to the input procedure to output information to the user;
  }

  // Ñonstant declaration section
  Const
    IntPart = MaxInt mod 2000000000;
  {
    IntPart - a value to check whether a number is of type integer
  }

  // Variable declaration section
  Var
    i, Shift: Integer;
    InpStr: String[12];
    IntCheck: String[9];
    CorrectInp: Boolean;
  {
    i - position in the string of the character in question;
    Shift - shift by character indexes when checking whether the entered number corresponds to the Integer type;
    InpStr - a string entered by the user;
    IntCheck - a string whose value is converted to an integer and compared with IntPart to determine whether the number entered by the user does not exceed the limits of the Integer type;
    CorrectInp - a boolean variable that determines whether the input is correct
  }

  Begin

    // The string is reset to zero so that values can be added to it in the future, the boolean value is set to False to enter the verification cycle
    IntCheck := '000000000';
    CorrectInp := False;

    // A loop for checking the input for correctness
    While not CorrectInp do
    Begin

      // If the input is incorrect, the value will be reassigned to False in order to enter the input loop again
      CorrectInp := True;
      Write(TInpStr(Str));
      Readln(InpStr);
      i := 1;

      // If a number takes more than 11 characters, then it is definitely not in the range of Integer values
      If Length(InpStr) > 11 then
        CorrectInp := False;

      // Character-by-character check whether they are digits
      While (i <= Length(InpStr)) and CorrectInp do
      Begin
        If (Ord(InpStr[i]) < 48) or (Ord(InpStr[i]) > 57) then
        Begin
          CorrectInp := False;

          // The first element can be a minus sign
          If (i = 1) and (Length(InpStr) > 1) then
            If (Ord(InpStr[i]) = 45) then
              CorrectInp := True
        End
        Else

          // The entered number can be 11 characters long only if the first character is a minus sign
          If (i = 1) and (Length(InpStr) = 11) then
            CorrectInp := False;
        Inc(i)
      End;

      // If the entered number is 10 or 11 characters long, then it must be modulo less than the maximum number from the range of Integer values
      If CorrectInp and (Length(InpStr) >= 10) then
      Begin
         If Length(InpStr) = 11 then
           Shift := 2
         Else
           Shift := 1;

         // The first character of a number of this length should not be greater than 2
         If Ord(InpStr[Shift]) <> 45 then
         Begin
           If Ord(InpStr[Shift]) > 50 then
             CorrectInp := False
           Else
           Begin

             // Checking whether the entered number is in the range of Integer values
             For i := 1 to 9 do
               IntCheck[i] := InpStr[i+Shift];
             If StrToInt(IntCheck) > IntPart then
               CorrectInp := False;
           End;
         End;
      End;
      If CorrectInp then
        Input := StrToInt(InpStr)
      Else
        Writeln('Invalid input: it must be an integer type number. Repeat');
    End;
  End;

