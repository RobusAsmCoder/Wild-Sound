UNIT PER;

INTERFACE
//USES Windows, SysUtils;
  FUNCTION  DeFuzz (x:Real):Real;
  FUNCTION Pwr (x,y:  Real):Real;        {Pwr = x^y}


IMPLEMENTATION

VAR N,M,I,O,P:LONGINT;
    R:REAL;

    Note:Integer;
    FineTune:ShortInt;
    Period,Frequency:REAL;



  FUNCTION  DeFuzz (x:Real):Real;
  BEGIN
    IF   ABS(x) < (1.0E-12)
    THEN Defuzz := 0
    ELSE Defuzz := x
  END;


  FUNCTION Pwr (x,y:  Real):Real;        {Pwr = x^y}
  BEGIN
    IF   DeFuzz(x) = 0.0
    THEN
      IF   DeFuzz(y) = 0.0
      THEN Pwr := 1.0    {0^0 = 1 (i.e., lim x^x = 1 as x -> 0)}
      ELSE Pwr := 0.0
    ELSE Pwr := EXP( LN(x)*y )
  END;



CONST   PeriodTab:Array[0..12*8-1] of Word = (
      907,900,894,887,881,875,868,862,856,850,844,838,832,826,820,814,
      808,802,796,791,785,779,774,768,762,757,752,746,741,736,730,725,
      720,715,709,704,699,694,689,684,678,675,670,665,660,655,651,646,
      640,636,632,628,623,619,614,610,604,601,597,592,588,584,580,575,
      570,567,563,559,555,551,547,543,538,535,532,528,524,520,516,513,
      508,505,502,498,494,491,487,484,480,477,474,470,467,463,460,457);


BEGIN


   Note:=2*12-12+12;
   FineTune:=0;

   //WriteLn ('Note = ',Note);
   //WriteLn ('FineTune = ',FineTune);
   //WriteLn ('');
   //WriteLn ('... Linear:');



   FOR N:=0 TO 12 DO BEGIN
    Note:=N+1;
    Period := 10*12*16*4 - Note*16*4;
    Frequency := 8363*Pwr ( 2,((6*12*16*4 - Period) / (12*16*4)) );
    //Write ('N = ',Note:5,' P = ',Period:10:3,' F = ',Frequency:10:5);

   Period := (PeriodTab[Round((Note MOD 12)*8)]*2)*
             16/Pwr ( 2,(Note DIV 12));
   Frequency := 8363*1712/Period;
    //WriteLn (' P = ',Period:10:3,' F = ',Frequency:10:5);

   END;

    //WriteLn ('');



   Period := (PeriodTab[Round((Note MOD 12)*8 + FineTune/16)]*(1-Frac(FineTune/16)) +
             PeriodTab[Round((Note MOD 12)*8 + FineTune/16)]*(Frac(FineTune/16)))
            *16/Pwr ( 2,(Note DIV 12));


   Frequency := 8363*1712/Period/1.8880;

   //WriteLn ('... Amiga:');
   //WriteLn ('Period = ',Period:10:3);
   //WriteLn ('Frequency = ',Frequency:10:10);


END.