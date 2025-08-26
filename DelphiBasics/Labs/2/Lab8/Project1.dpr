{Determine whether the entered text corresponds to the concept of "Parameter list"}
program Project1;

// Determining the Console Program Type
{$APPTYPE CONSOLE}

// A subroutine that scans and determines the correctness of the entered string
{
  The string entered by the user is character-by-character read and an analysis is performed of whether the character being read can occupy the position at which it is located
}
Function Scan(scanName, scanIndicator, scanBracket: Boolean): Boolean;

  // Variable declaration section
  Var
    Symb: Char;
    {
     Symb - variable storing the character being read
    }

  Begin
    If scanName then

    // The part that checks whether the entered character is a letter and whether it is in the correct position
    Begin
      Read(Symb);

      // Checking whether the entered character is a letter
      If (Symb >= 'A') and (Symb <= 'Z') or (Symb >= 'a') and (Symb <= 'z') then
      Begin

        // Changing the value of a Boolean variable, since there may be other characters after the letter
        scanIndicator := True;
        Result := Scan(scanName,scanIndicator,scanBracket);
      End
      Else
      Begin
        If scanIndicator then
        Begin
          If Symb = '=' then
          Begin

            //After the "=" symbol there should be either a number or a list of parameters
            scanName := False;
            Result := Scan(scanName,scanIndicator,scanBracket);
          End
          Else
          Begin
            Result := False;
          End;
        End
        Else
          Result := False;
      End;
    End

      // The part that checks whether the character set corresponds to the necessary concept
    Else
    Begin
      Read(Symb);
      If Symb = '(' then
      Begin

        //After the parenthesis there should be a parameter
        scanIndicator := False;
        scanName := True;
        Result := Scan(scanName,scanIndicator,True);
        If Result then
          Read(Symb);
      End
      Else
      Begin

        //If there are no brackets, then there should be numbers there
        scanIndicator := False;
        While (Symb >= '0') and (Symb <= '9') do
        Begin

          // Changing the value of a Boolean variable, since there may be other characters after the number
          scanIndicator := True;
          Read(Symb);
        End;
        If not scanIndicator then
        Begin
          Result := False;
        End
        Else
          Result := True;
      End;
      If Result then
      Begin

        // There should be another parameter after the comma
        If Symb = ',' then
        Begin
          scanName := True;
          scanIndicator := False;
          Result := Scan(scanName,scanIndicator,scanBracket);
        End
        Else
        Begin

          // Checking whether a section of the string is the end
          If (Symb <> ')') and (Ord(Symb) <> 13) then
          Begin
            Result := False;
          End
          Else
          Begin
            If Symb = ')' then
            Begin
              If not scanBracket then
                Result := False;
            End
            Else
              If scanBracket then
                Result := False;
          End;
        End;
      End;
    End;
  End;

Begin
  Writeln('Enter string: ');
  If Scan(True,False,False) then
    Writeln('Correct')
  Else
    Writeln('Incorrect');
  Readln;
  Readln;
End.



