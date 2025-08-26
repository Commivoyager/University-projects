program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

Type
  Pntr = ^Element;
  Element = record
    Coef,Degree: Integer;
    Next: Pntr;
  End;

Var
  P1, P2, Res: Pntr;
  x: Integer;

Procedure Make(Var First: Pntr);
  Var
    P: Pntr;
    n, i, CoefInp: Integer;
    Flag: Boolean;

  Begin
    Flag := False;
    While not Flag do
    Begin
      Write('Enter degree of polynomial: ');
      Readln(n);
      If n >= 0 then
        Flag := True
      Else
        Writeln('Incorrect input. Degree must be positive');
    End;
    New(P);
    First := P;
    For i := n downto 0 do
    Begin
      If i > 1 then
        Write('Enter coefficient of x^', i, ': ')
      Else
        If i = 1 then
          Write('Enter coefficient of x: ')
        Else
          Write('Enter the value of the free member: '); 
      Readln(CoefInp);
      If CoefInp <> 0 then
      Begin
        New(P^.Next);
        P := P^.Next;
        P^.Coef := CoefInp;
        P^.Degree := i;
      End;
    End;
    P^.Next := nil;
    Writeln
  End;

Procedure Outp1(Var First: Pntr);
  Var
    P: Pntr;

  Begin
    P := First^.Next;
    Write('Polynomial: ');
    While P <> nil do
    Begin
      If (P^.Coef < 0) or (P = First^.Next) then
      Begin
        If P^.Coef <> 1 then
          Write(P^.Coef)
      End
      Else
      Begin
        Write('+');
        If (P^.Coef <> 1) or (P^.Degree = 0) then
          Write(P^.Coef)
      End;
      If P^.Degree > 1 then
       Write('x^', P^.Degree)
      Else
        If P^.Degree = 1 then
          Write('x');
      P := P^.Next;
    End;
    Writeln;
    Writeln
  End;

Procedure Outp2(Var First: Pntr);
  Var
    P: Pntr;

  Begin
    P := First^.Next;
    Write('Polynomial: ');
    While P.Next <> nil do
    Begin
      If (P^.Coef < 0) or (P = First^.Next) then
      Begin
        If P^.Coef <> 1 then
          Write(P^.Coef)
      End
      Else
      Begin
        Write('+');
        If (P^.Coef <> 1) or (P^.Degree = 0) then
          Write(P^.Coef)
      End;
      If P^.Degree > 1 then
       Write('x^', P^.Degree)
      Else
        If P^.Degree = 1 then
          Write('x');
      P := P^.Next;
    End;
    Writeln;
    Writeln
  End;

Procedure Equality(Var F1,F2: Pntr);
  Var
    P1, P2: Pntr;
    Flag: Boolean;
  Begin
    P1 := F1^.Next;
    P2 := F2^.Next;
    Flag := False;
    While not Flag and (P1 <> nil) do
    Begin
      If P1^.Degree = P2^.Degree then
      Begin
        If P1^.Coef <> P2^.Coef then
          Flag := True;
      End
      Else
        Flag := True;
      P1 := P1^.Next;
      P2 := P2^.Next;
    End;
    If Flag then
      Writeln('Not equal')
    Else
      Writeln('Equal');
    Writeln
  End;

Function Meaning(Var F: Pntr; Var x: Integer): Integer;
  Var
    P: Pntr;
    cx,i: Integer;
  Begin
    P := F.Next;
    Result := 0;
    While P <> nil do
    Begin
      cx := P.Coef;
      For i := 1 to P.Degree do
        cx := cx*x;
      Result := Result+cx;
      P := P.Next;
    End;
    Writeln
  End;

Procedure Add(Var res,F1,F2: Pntr);
  Var
    Pr,P1,P2,P: Pntr;

  Begin
    P1 := F1.Next;
    P2 := F2.Next;
    New(res);
    New(res.Next);
    Pr := res.Next;
    While (P1 <> nil) and (P2 <> nil) do
    Begin
      If P1.Degree = P2.Degree then
      Begin
        Pr.Degree := P1.Degree;
        Pr.Coef := P1.Coef+P2.Coef;
        P1 := P1.Next;
        P2 := P2.Next;
      End
      Else
      Begin
        If P1.Degree > P2.Degree then
        Begin
          Pr.Degree := P1.Degree;
          Pr.Coef := P1.Coef;
          P1 := P1.Next;
        End
        Else
        Begin
          Pr.Degree := P2.Degree;
          Pr.Coef := P2.Coef;
          P2 := P2.Next;
        End;
      End;
      New(Pr.Next);
      Pr := Pr.Next;
    End;
    If (P1 = nil) and (P2 = nil) then

    Else
    Begin
      If P1 = nil then
        P := P2
      Else
        P := P1;
    //End;
    While P <> nil do
    Begin
      Pr.Coef := P.Coef;
      Pr.Degree := P.Degree;
      P := P.Next;
      New(Pr.Next);
      Pr := Pr.Next;
    End;
    End;
    Pr := nil
  End;

Procedure No0(Var P: Pntr);
  Var
    F,G: Pntr;

  Begin
    F := P.Next;
    G := P;
    While F <> nil do
    Begin
      If F.Coef = 0 then
        G.Next := F.Next;
      F := F.Next;
      G := G.Next;
    End;

  End;

begin
  Make(P1);
  Outp1(P1);
  Make(P2);
  Outp1(P2);
  Equality(P1,P2);
  Write('Enter x: ');
  Readln(x);
  Writeln('The value of the first polynomial at x = ', x,': ', Meaning(P1,x));
  Write('Enter x: ');
  Readln(x);
  Writeln('The value of the second polynomial at x = ', x,': ', Meaning(P2,x));
  Writeln;
  Add(Res,P1,P2);
  No0(Res);
  Outp2(Res);
  Readln
end.
