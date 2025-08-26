program Lab10;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Var
  F,FCopy: text;
  i: Integer;
  a: Char;
  Str: String;

Procedure CopyFile(Var sourceF,destF: text);
  Var
    Str: String[255];
  Begin
    Reset(sourceF);
    Rewrite(destF);
    While not EoF(sourceF) do
    Begin
      Read(sourceF,Str);
      Write(destF,Str);
      If EoLn(sourceF) then
        Readln(sourceF);
    End;
    Close(sourceF);
    Close(destF);
  End;

Procedure ConvertCopy(Var sourceF,destF: text);
  Var
    sourceStr: String[255];
    destStr: String[60];
    i,j,Delta: Integer;

  Begin
    Reset(sourceF);
    Rewrite(destF);
    Delta := 0;
    While not Eof(sourceF) do
    Begin
      Read(sourceF,sourceStr);
      Writeln(sourceStr);
      j := 0;
      While j < length(sourceStr) do
      Begin
        i := 0;
        Repeat
          inc(i);
          inc(j);
        Until (sourceStr[j] = '.') or (i+Delta=60) or (j=length(sourceStr));
        destStr := Copy(sourceStr,j-i+1,i);
        Write(destF,destStr);
        If Delta <> 0 then
          Delta := 0;
        If j <> 255 then
          Writeln(destF)
        Else
          Delta := i;
      End;
    End;
    Close(destF);
    Close(sourceF);
  End;

begin
  AssignFile(F,'F.txt');
  AssignFile(FCopy,'FCopy.txt');
  CopyFile(F,FCopy);
  ConvertCopy(FCopy,F);
  Readln;
end.       
