(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       CALC.INC for Math Unit                                 *)
(*       Targets: MS-DOS, OS/2, WIN32                           *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Authors: Victor Petrov, Dmitriy Nevozhai               *)
(*                                                              *)
(****************************************************************)

const
   CalcError: Boolean = False;

type
   PData=^TData;
   TData=record
      Next:PData;
      Data:String;
   end;

   PConnection=^TConnection;
   TConnection=object
      Pred,Next:Pointer;
   end;

   PReal=^TReal;
   TReal=object(TConnection)
      Data:Extended;
      constructor Init(NewData:Extended);
      destructor Done;
   end;

procedure NewElem(const Elem,Head:Pointer);
begin
   PConnection(PConnection(Head)^.Pred)^.Next:=Elem;
   PConnection(Elem)^.Next:=Head;
   PConnection(Elem)^.Pred:=PConnection(Head)^.Pred;
   PConnection(Head)^.Pred:=Elem;
end;

function FromDec(Number:LongInt;Base:Byte):String;
var
   Answer,S:String;
   N:LongInt;
begin
   Answer:='';
   if Number>=0 then begin
      repeat
         N:=Number Mod Base;
         if N>9 then Answer:=Chr(55+N)+Answer else begin
            System.Str(N,S);
            Answer:=S+Answer;
         end;
         Number:=Number Div Base;
      until Number<Base;
      if Number>9 then Answer:=Chr(55+Number)+Answer else begin
         System.Str(Number,S);
         Answer:=S+Answer;
      end;
      FromDec:=Answer;
   end else FromDec:=FromDec(Abs(Number Shr 15),Base)+
                     FromDec(Word(Number) and $7FFF,Base);
end;

function InDec(Number:String;Base:Word):LongInt;
var
   Answer:LongInt;
   N,R:LongInt;
   I,J:Byte;
begin
   Answer:=0;
   for I:=0 to Pred(Length(Number)) do begin
      if Number[Length(Number)-I]='.' then Exit;
      if Number[Length(Number)-I] In ['0'..'9'] then
         N:=Ord(Number[Length(Number)-I])-48 else
         if UpCase(Number[Length(Number)-I]) In ['A'..'Z'] then
            N:=Ord(UpCase(Number[Length(Number)-I]))-55 else Exit;
      R:=1;
      J:=I;
      while J>0 do begin
         R:=R*LongInt(Base);
         Dec(J);
      end;
      Answer:=Answer+LongInt(N)*R;
   end;
   InDec:=Answer;
end;

constructor TReal.Init;
begin
   Data:=NewData;
end;

destructor TReal.Done;
begin
   PConnection(Pred)^.Next:=Next;
   PConnection(Next)^.Pred:=Pred;
end;

function Fact(Number:Extended):Extended;
var
   F:Extended;
begin
   if Number=0 then Result:=1 else begin
      Result:=1;
      F:=1;
      repeat
         Result:=Result*F;
         F:=F+1;
      until F>Number;
   end;
end;

function Prec(Ch:String):Byte;
begin
   if Length(Ch)=1 then Case Ch[1] Of
      '^':Prec:=6;
      '/','*','&','%','!':Prec:=5;
      '-','+','|','\':Prec:=4;
      '>','<','=':Prec:=3;
      '(':Prec:=1;
      else Prec:=0;
   end else
       if (Ch='>>') or (Ch='<<') then Prec:=5 else
       if (Ch='>=') or (Ch='<=') or (Ch='=>') or (Ch='=<') or (Ch='==') or (Ch='<>') then Prec:=3 else
       if (Ch='&&') or (Ch='||') or (Ch='^^') then Prec:=2 else Prec:=0;
end;

procedure Push(var P:PData;Data:String);
var
   T:PData;
begin
   New(T);
   T^.Data:=Data;
   T^.Next:=P;
   P:=T;
end;

function Pop(var P:PData):String;
var
   T:PData;
begin
   if P<>nil then begin
      Pop:=P^.Data;
      T:=P;
      P:=P^.Next;
      Dispose(T);
   end else Pop:='';
end;

function PopData(var P:PData):String;
begin
   if P<>nil then begin
      if P^.Next=nil then PopData:=Pop(P) else PopData:=PopData(P^.Next)
   end else PopData:='';
end;

function Calculate(Func:String):Extended;

function Check:Boolean;
var
   C,I: Longint;
begin
   for I:=1 to Length(Func)do Func[I]:=UpCase(Func[I]);
   repeat
      I:=Pos(' DIV ',Func);
      if I=0 then Break;
      Delete(Func,I,4);
      Func[I] := '!';
   until False;
   repeat
      I:=Pos(' MOD ',Func);
      if I=0 then Break;
      Delete(Func,I,4);
      Func[I] := '%';
   until False;
   repeat
      I:=Pos(' SHL ',Func);
      if I=0 then Break;
      Delete(Func,I,3);
      Func[I] := '<';Func[I+1] := '<';
   until False;
   repeat
      I:=Pos(' SHR ',Func);
      if I=0 then Break;
      Delete(Func,I,3);
      Func[I] := '>';Func[I+1] := '>';
   until False;
   repeat
      I:=Pos(' AND ',Func);
      if I=0 then Break;
      Delete(Func,I,3);
      Func[I] := '&';Func[I+1] := '&';
   until False;
   repeat
      I:=Pos(' XOR ',Func);
      if I=0 then Break;
      Delete(Func,I,3);
      Func[I] := '^';Func[I+1] := '^';
   until False;
   repeat
      I:=Pos(' OR ',Func);
      if I=0 then Break;
      Delete(Func,I,2);
      Func[I] := '|';Func[I+1] := '|';
   until False;
   I:=1;
   while I<=Byte(Func[0]) do
      if Func[I]=' ' then Delete(Func,I,1) else Inc(I);
   repeat
      I:=Pos('0X',Func);
      if I=0 then Break;
      Delete(Func,I,1);
      Func[I] := '$';
   until False;
   C:=0;
   for I:=1 to Length(Func) do begin
      Case Func[I] Of
         '(':Inc(C);
         ')':begin
                Dec(C);
                if (C<0) or (I=1) or (Func[I-1]='(') then begin
                   Check:=False;
                   Exit;
                end;
             end;
      end;
   end;
   Check:=(C=0) and (Length(Func)>0);
end;

var
   Hex,Inv:Boolean;
   Ch,K:Char;
   Main:PConnection;
   Done:Boolean;
   S:String;
   X,Y:PData;
   I,J,Last:Word;
   R,P:Extended;

function CheckFunc(F:String):Boolean;
begin
   if (Copy(Func,I,Length(F))=F) and (Func[I+Length(F)]='(') then begin
      Inc(I,Length(F));
      Push(Y,'(');
      Push(Y,F);
      Result:=True;
   end else Result:=False;
end;

begin
   CalcError:=False;
   if Func='' then begin
      Calculate:=0;
      Exit;
   end;
   if Not Check then begin
      CalcError:=True;
      Exit;
   end;
   X:=nil;
   Y:=nil;
   I:=0;
   Last:=0;
   Func:=Func+#0#0#0#0#0#0#0#0#0#0;
   repeat
      Inc(I);
      while Copy(Func,I,2)='~~' do Delete(Func,I,2);
      Ch:=Func[I];
      if (Ch In ['-','+']) and ((I=1) or (Func[I-1] In ['(',',','=','>','<'])) and (I<>Last) then begin
         Func:=Copy(Func,1,I-1)+'('+Ch+'1)*'+Copy(Func,I+1,Length(Func)-I);
         Last:=I+1;
         Ch:='(';
      end;
      S:=Ch;
      if (Ch='>') and (Func[I+1] In ['>','=']) or
         (Ch='<') and (Func[I+1] In ['<','>','=']) or
         (Ch='=') and (Func[I+1] In ['=','>','<']) or
         (Ch='&') and (Func[I+1]='&') or
         (Ch='|') and (Func[I+1]='|') or
         (Ch='^') and (Func[I+1]='^') then begin
         Inc(I);
         S:=S+Func[I];
      end;
      if (Ch='P') and (Func[I+1]='I') then begin
         Push(X,'PI');
         Inc(I);
         Continue;
      end;
      if CheckFunc('~') then Continue;
      if (Ch In ['~','$','0'..'9','.']) or ((Ch In ['+','-']) and ((I=1) or (Func[I-1] In ['(',',','=','>','<']))) then begin
         S:='';
         Hex:=False;Inv:=False;
         while (Ch In ['0'..'9','.','A'..'F']) or ((S='') or (S='+') or (S='-')) and Not Hex or
               (I<>1) and (Func[I-1]='E') and (Ch<>#0) and Not Hex or
               (Ch In ['O','H']) and Not Hex do begin
            if Ch In ['(',')'] then Break;
            Inc(I);
            if (Ch='$') and (S='') then Hex:=True else
            if (Ch='~') and ((S='') or (S='+') or (S='-'))
               then Inv:=Not Inv else S:=S+Ch;
            if Ch In ['O','H'] then Break;
            Ch:=Func[I];
         end;
         if (S='') or (Func[I] In ['0'..'9','.','A'..'F','O','H','$','~']) then begin
            while Y<>nil do PopData(Y);
            while X<>nil do PopData(X);
            CalcError:=True;
            Exit;
         end;
         K:=S[Length(S)];
         if Not Hex and (K In ['B','H','O']) then Delete(S,Length(S),1);
         if (Hex or (K In ['B','O','H'])) and (S[1] In ['+','-']) then begin
            Ch:=S[1];
            Delete(S,1,1);
         end else Ch:=#0;
         if Not Hex and (K In ['O','B']) then begin
            Val(S,R,J);
            if (J<>0) or (Pos('E',S)<>0) then begin
               while Y<>nil do PopData(Y);
               while X<>nil do PopData(X);
               CalcError:=True;
               Exit;
            end;
            for J:=1 to Length(S) do
               if (K='O') and Not (S[J] In ['0'..'7']) or
                  (K='B') and Not (S[J] In ['0','1']) then begin
                  while Y<>nil do PopData(Y);
                  while X<>nil do PopData(X);
                  CalcError:=True;
                  Exit;
               end;
         end;
         if Not Hex then Case K Of
            'B':begin R:=InDec(S,2);System.Str(R,S);end;
            'O':begin R:=InDec(S,8);System.Str(R,S);end;
            'H':begin R:=InDec(S,16);System.Str(R,S);end;
         end;
         Dec(I);
         if Hex then begin
            R:=InDec(S,16);
            System.Str(R,S);
         end;
         if Inv then begin
            Val(S,R,J);
            if J<>0 then begin
               while Y<>nil do PopData(Y);
               while X<>nil do PopData(X);
               CalcError:=True;
               Exit;
            end;
            if Abs(R)>MaxLongInt then R:=0 else R:=Not Trunc(R);
            System.Str(R,S);
         end;
         if Ch='-' then S:='-'+S;
         Push(X,S);
         Continue;
      end;
      if CheckFunc('SIN') then Continue;
      if CheckFunc('COS') then Continue;
      if CheckFunc('EXP') then Continue;
      if CheckFunc('LN') then Continue;
      if CheckFunc('TG') then Continue;
      if CheckFunc('TAN') then Continue;
      if CheckFunc('TN') then Continue;
      if CheckFunc('CTG') then Continue;
      if CheckFunc('COTAN') then Continue;
      if CheckFunc('CTAN') then Continue;
      if CheckFunc('CTN') then Continue;
      if CheckFunc('ACTG') then Continue;
      if CheckFunc('ACOTAN') then Continue;
      if CheckFunc('ACTAN') then Continue;
      if CheckFunc('ACTN') then Continue;
      if CheckFunc('ARCCTG') then Continue;
      if CheckFunc('ARCCOTAN') then Continue;
      if CheckFunc('ARCCTAN') then Continue;
      if CheckFunc('ARCCTN') then Continue;
      if CheckFunc('INT') then Continue;
      if CheckFunc('FRAC') then Continue;
      if CheckFunc('RADTOGRAD') then Continue;
      if CheckFunc('GRADTORAD') then Continue;
      if CheckFunc('RAD') then Continue;
      if CheckFunc('GRAD') then Continue;
      if CheckFunc('ATN') then Continue;
      if CheckFunc('ATG') then Continue;
      if CheckFunc('ATAN') then Continue;
      if CheckFunc('ARCTN') then Continue;
      if CheckFunc('ARCTG') then Continue;
      if CheckFunc('ARCTAN') then Continue;
      if CheckFunc('SIGN') then Continue;
      if CheckFunc('LG') then Continue;
      if CheckFunc('LOG2') then Continue;
      if CheckFunc('LOG10') then Continue;
      if CheckFunc('SQR') then Continue;
      if CheckFunc('SQRT') then Continue;
      if CheckFunc('ASIN') then Continue;
      if CheckFunc('ARCSIN') then Continue;
      if CheckFunc('ACOS') then Continue;
      if CheckFunc('ARCCOS') then Continue;
      if CheckFunc('FACT') then Continue;
      if CheckFunc('ABS') then Continue;
      if CheckFunc('ROUND') then Continue;
      if CheckFunc('NOT') then Continue;
      if CheckFunc('SEC') then Continue;
      if CheckFunc('COSEC') then Continue;
      if CheckFunc('CSEC') then Continue;
      if CheckFunc('CSC') then Continue;
      if CheckFunc('LOG') then Continue;
      if CheckFunc('MIN') then Continue;
      if CheckFunc('MAX') then Continue;
      if CheckFunc('HYPOT') then Continue;
      if CheckFunc('HYP') then Continue;
      if S='(' then Push(Y,S) else
      if S=')' then begin
         while Y^.Data<>'(' do Push(X,Pop(Y));
         Pop(Y);
      end else
      if S[1]=',' then begin
         while (Y<>nil) and (Y^.Next<>nil) and (Y^.Next^.Data<>'(') do Push(X,Pop(Y));
         if (Y=nil) or (Y^.Next=nil) then begin
            while Y<>nil do PopData(Y);
            while X<>nil do PopData(X);
            CalcError:=True;
            Exit;
         end;
      end else
      if S[1] In ['+','-','*','/','!','>','<','^','=','&','|','\','%',#0] then begin
         repeat
            Done:=True;
            if (Y<>nil) and (Prec(S)<=Prec(Y^.Data)) then begin
               Push(X,Pop(Y));
               Done:=False;
            end;
         until Done;
         if S[1]<>#0 then Push(Y,S);
      end else begin
         while Y<>nil do PopData(Y);
         while X<>nil do PopData(X);
         CalcError:=True;
         Exit;
      end;
   until S[1]=#0;
   if X=nil then begin
      CalcError:=True;
      Exit;
   end;
   if Y<>nil then begin
      while Y<>nil do PopData(Y);
      CalcError:=True;
      Exit;
   end;
   New(Main);
   Main^.Next:=Main;
   Main^.Pred:=Main;
   while X<>nil do begin
      S:=PopData(X);
      if ((Length(S)=1) and (S[1] In ['~','+','-','*','/','>','<','=','^','&','\','|','%','!'])) or
         (Length(S)=2) and ((S='<<') or (S='>>') or (S='&&') or (S='||') or
         (S='^^') or (S='==') or (S='<>') or (S='<=') or (S='>=') or (S='=<') or (S='=>')) or
         (S='SIN') or (S='COS') or (S='EXP') or (S='LN') or (S='TG') or (S='TN') or
         (S='TAN') or (S='RAD') or (S='GRAD') or (S='INT') or (S='FRAC') or
         (S='COTAN') or (S='CTG') or (S='CTAN') or (S='CTN') or (S='SIGN') or
         (S='ATAN') or (S='ATN') or (S='ARCTAN') or (S='ARCTG') or (S='ATG') or
         (S='ARCTN') or (S='LG') or (S='SQR') or (S='SQRT') or (S='ASIN') or
         (S='ARCSIN') or (S='ACOS') or (S='ARCCOS') or (S='LOG2') or (S='LOG10') or
         (S='ACOTAN') or (S='ACTG') or (S='ACTAN') or (S='ACTN') or (S='FACT') or
         (S='ARCCOTAN') or (S='ARCCTG') or (S='ARCCTAN') or (S='ARCCTN') or
         (S='ROUND') or (S='ABS') or (S='NOT') or (S='SEC') or (S='COSEC') or
         (S='CSEC') or (S='CSC') or (S='LOG') or (S='MIN') or (S='MAX') or
         (S='RADTOGRAD') or (S='GRADTORAD') or (S='HYP') or (S='HYPOT') then begin
         if Main^.Pred=Main then begin
            CalcError:=True;
            while X<>nil do PopData(X);
            Dispose(Main);
            Exit;
         end;
         R:=PReal(Main^.Pred)^.Data;
         if (S[1] In ['+','-','*','/','>','<','=','^','&','\','|','%','!']) or
            (S='LOG') or (S='MIN') or (S='MAX') or (S='HYP') or (S='HYPOT')
            then Dispose(PReal(Main^.Pred),Done);
         if Main^.Pred=Main then begin
            CalcError:=True;
            while X<>nil do PopData(X);
            while Main^.Next<>Main do Dispose(PReal(Main^.Next),Done);
            Dispose(Main);
            Exit;
         end;
         if ((S[1] In ['&','|','%','~','\']) or (S='<<') or (S='>>')) and
            ((Abs(R)>MaxLongInt) or (Abs(PReal(Main^.Pred)^.Data)>MaxLongInt))
            then begin
            CalcError:=True;
            while X<>nil do PopData(X);
            while Main^.Next<>Main do Dispose(PReal(Main^.Next),Done);
            Dispose(Main);
            Exit;
         end;
         if Length(S)=1 then Case S[1] Of
            '+':PReal(Main^.Pred)^.Data:=PReal(Main^.Pred)^.Data+R;
            '-':PReal(Main^.Pred)^.Data:=PReal(Main^.Pred)^.Data-R;
            '>':PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data>R);
            '<':PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data<R);
            '=':PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data=R);
            '*':if (Abs(R)>1) then
                   if 1e38/Abs(R)<Abs(PReal(Main^.Pred)^.Data)
                      then CalcError:=True else PReal(Main^.Pred)^.Data:=PReal(Main^.Pred)^.Data*R
                      else if (Abs(PReal(Main^.Pred)^.Data)>1) and (1e38/Abs(PReal(Main^.Pred)^.Data)<Abs(R))
                      then CalcError:=True else PReal(Main^.Pred)^.Data:=PReal(Main^.Pred)^.Data*R;
            '&':PReal(Main^.Pred)^.Data:=Trunc(PReal(Main^.Pred)^.Data) and Trunc(R);
            '|':PReal(Main^.Pred)^.Data:=Trunc(PReal(Main^.Pred)^.Data) or Trunc(R);
            '\':PReal(Main^.Pred)^.Data:=Trunc(PReal(Main^.Pred)^.Data) Xor Trunc(R);
            '%':if Trunc(R)=0 then CalcError:=True else PReal(Main^.Pred)^.Data:=Trunc(PReal(Main^.Pred)^.Data) Mod Trunc(R);
            '~':PReal(Main^.Pred)^.Data:=Not Trunc(R);
            '/':if Abs(R)<1e-18 then CalcError:=True else PReal(Main^.Pred)^.Data:=PReal(Main^.Pred)^.Data/R;
            '!':if Abs(R)<1e-18 then CalcError:=True else PReal(Main^.Pred)^.Data:=Int(PReal(Main^.Pred)^.Data/R);
            '^':begin
                   P:=PReal(Main^.Pred)^.Data;
                   if (P=0) and (R<0) or (R>1e9) or
                      (P<>0) and (R<>0) and (Abs(P)<>1) and (Abs(R)<>1) and
                      ((Abs(P)>1) and (Ln(Abs(P))>=(70/Abs(R))) or
                      (Abs(P)<1) and (-Ln(Abs(P))>=(691/Abs(R))))
                      then CalcError:=True
                      else PReal(Main^.Pred)^.Data:=Power(P,R);
                end;
         end else
         if S='>>' then PReal(Main^.Pred)^.Data:=Trunc(PReal(Main^.Pred)^.Data) Shr Trunc(R) else
         if S='<<' then PReal(Main^.Pred)^.Data:=Trunc(PReal(Main^.Pred)^.Data) shl Trunc(R) else
         if (S='>=') or (S='=>') then PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data>=R) else
         if (S='<=') or (S='=<') then PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data<=R) else
         if S='==' then PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data=R) else
         if S='<>' then PReal(Main^.Pred)^.Data:=Ord(PReal(Main^.Pred)^.Data<>R) else
         if S='&&' then PReal(Main^.Pred)^.Data:=Ord((PReal(Main^.Pred)^.Data<>0) and (R<>0)) else
         if S='||' then PReal(Main^.Pred)^.Data:=Ord((PReal(Main^.Pred)^.Data<>0) or (R<>0)) else
         if S='^^' then PReal(Main^.Pred)^.Data:=Ord((PReal(Main^.Pred)^.Data<>0) Xor (R<>0)) else
         if S='NOT' then PReal(Main^.Pred)^.Data:=Ord(Not(R<>0)) else
         if S='LOG' then begin
            if (R<1e-18) or (PReal(Main^.Pred)^.Data<1e-18) or (Ln(PReal(Main^.Pred)^.Data)<1e-18) then CalcError:=True
               else PReal(Main^.Pred)^.Data:=Ln(R)/Ln(PReal(Main^.Pred)^.Data);
         end else
         if S='SEC' then begin
            if (Abs(R)>1e18) or (Abs(Sin(R))<1e-18) then CalcError:=True else PReal(Main^.Pred)^.Data:=1/Sin(R);
         end else
         if (S='COSEC') or (S='CSEC') or (S='CSC') then begin
            if (Abs(R)>1e18) or (Abs(Cos(R))<1e-18) then CalcError:=True else PReal(Main^.Pred)^.Data:=1/Cos(R);
         end else
         if S='SIN' then begin
            if Abs(R)>1e18 then CalcError:=True else PReal(Main^.Pred)^.Data:=Sin(R);
         end else
         if S='COS' then begin
            if Abs(R)>1e18 then CalcError:=True else PReal(Main^.Pred)^.Data:=Cos(R);
         end else
         if (S='TG') or (S='TAN') or (S='TN') then begin
            if (Abs(R)>1e18) or (Abs(Cos(R))<1e-18)
               then CalcError:=True
               else PReal(Main^.Pred)^.Data:=Sin(R)/Cos(R);
         end else
         if (S='COTAN') or (S='CTG') or (S='CTAN') or (S='CTN') then begin
            if (Abs(R)>1e18) or (Abs(Sin(R))<1e-18)
               then CalcError:=True
               else PReal(Main^.Pred)^.Data:=Cos(R)/Sin(R);
         end else
         if (S='ACOTAN') or (S='ACTG') or (S='ACTAN') or (S='ACTN') or
            (S='ARCCOTAN') or (S='ARCCTG') or (S='ARCCTAN') or (S='ARCCTN')
            then PReal(Main^.Pred)^.Data:=-ArcTan(R)+Pi/2.0 else
         if S='EXP' then begin
            if R>82 then CalcError:=True else PReal(Main^.Pred)^.Data:=Exp(R);
         end else
         if S='LN' then begin
            if R<1e-18 then CalcError:=True else PReal(Main^.Pred)^.Data:=Ln(R);
         end else
         if (S='LG') or (S='LOG10') then begin
            if R<1e-18 then CalcError:=True else PReal(Main^.Pred)^.Data:=Ln(R)/Ln(10);
         end else
         if S='LOG2' then begin
            if R<1e-18 then CalcError:=True else PReal(Main^.Pred)^.Data:=Ln(R)/Ln(2);
         end else
         if S='SQRT' then begin
            if R<0 then CalcError:=True else PReal(Main^.Pred)^.Data:=Sqrt(R);
         end else
         if S='SQR' then begin
            if (Abs(R)>1) then
               if 1e38/Abs(R)<Abs(R)
                  then CalcError:=True else PReal(Main^.Pred)^.Data:=Sqr(R)
                  else if (Abs(R)>1) and (1e38/Abs(R)<Abs(R))
                  then CalcError:=True else PReal(Main^.Pred)^.Data:=Sqr(R);
         end else
         if (S='ASIN') or (S='ARCSIN') then begin
            if Abs(R)>1 then CalcError:=True else PReal(Main^.Pred)^.Data:=ArcSin(R);
         end else
         if (S='ACOS') or (S='ARCCOS') then begin
            if Abs(R)>1 then CalcError:=True else PReal(Main^.Pred)^.Data:=ArcCos(R);
         end else
         if S='FACT' then begin
            if (R<0) or (R>160) then CalcError:=True else PReal(Main^.Pred)^.Data:=Fact(R);
         end else
         if S='MIN' then begin
            if R<PReal(Main^.Pred)^.Data then PReal(Main^.Pred)^.Data:=R;
         end else
         if S='MAX' then begin
            if R>PReal(Main^.Pred)^.Data then PReal(Main^.Pred)^.Data:=R;
         end else
         if (S='HYP') or (S='HYPOT') then PReal(Main^.Pred)^.Data:=Hypot(PReal(Main^.Pred)^.Data,R) else
         if S='ABS' then PReal(Main^.Pred)^.Data:=Abs(R) else
         if S='ROUND' then PReal(Main^.Pred)^.Data:=Round(R) else
         if (S='GRAD') or (S='RADTOGRAD') then PReal(Main^.Pred)^.Data:=R*180/Pi else
         if (S='RAD') or (S='GRADTORAD') then PReal(Main^.Pred)^.Data:=R*Pi/180 else
         if S='INT' then PReal(Main^.Pred)^.Data:=Int(R) else
         if S='FRAC' then PReal(Main^.Pred)^.Data:=Frac(R) else
         if (S='ATAN') or (S='ATN') or (S='ARCTAN') or (S='ARCTG') or (S='ATG') or
            (S='ARCTN') then PReal(Main^.Pred)^.Data:=ArcTan(R) else
         if S='SIGN' then if R=0 then PReal(Main^.Pred)^.Data:=0 else
                             if R<0 then PReal(Main^.Pred)^.Data:=-1
                                    else PReal(Main^.Pred)^.Data:=1;
         if Not CalcError then Continue;
      end;
      if Not CalcError then begin
         if S='PI' then R:=Pi else begin
            Val(S,R,I);
            if (I<>0) or (Abs(R)>10e+300) then CalcError:=True;
         end;
      end;
      if CalcError then begin
         while X<>nil do PopData(X);
         while Main^.Next<>Main do Dispose(PReal(Main^.Next),Done);
         Dispose(Main);
         Exit;
      end;
      NewElem(New(PReal,Init(R)),Main);
   end;
   if Main^.Next=Main then begin
      CalcError:=True;
      Dispose(Main);
      Exit;
   end;
   Calculate:=PReal(Main^.Next)^.Data;
   CalcError:=Main^.Next<>Main^.Pred;
   while Main^.Next<>Main do Dispose(PReal(Main^.Next),Done);
   Dispose(Main);
end;

