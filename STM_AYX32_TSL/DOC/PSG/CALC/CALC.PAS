USES CRT,DOS,STRINGS;

VAR FM:DWORD = 1750000;
    FMx:DWORD;




FUNCTION CALST_OR(TP:DWORD; EP:DWORD):DWORD;
BEGIN




END;

PROCEDURE Cacl_AY;
VAR N,M,I,O,P:LONGINT;

    TP:DWORD;
    EP:DWORD;

    TPF,EPF:DWORD;
    TPFX,EPFX:DWORD;


BEGIN

        TP:=1;
        EP:=1;

        WriteLn('FM .......... ',FM);
        WriteLn('TP .......... ',TP);
        WriteLn('EP .......... ',EP);

        TPF := TP;
        IF TPF=0 THEN TPF:=1;
        EPF := EP;
        IF EPF=0 THEN EPF:=1;
        TPF := ROUND( FM/( 16*(TPF)) );
        EPF := ROUND( FM/(256*(EPF)) );


        WriteLn('---ORIGINAL---');
        WriteLn('TPF ......... ',TPF);
        WriteLn('EPF ......... ',EPF);
        WriteLn('TPF/E[F ..... ',ROUND(TPF/EPF*100));

        FMX := ROUND(FM*3);
        TPFX := ROUND( (FMX)/( 16*((TP+1)*2-0)) );
        EPFX := ROUND( (FMX)/(256*((EP+1)*2-0)) );

        WriteLn('---FREQ/(16*(TP*2+1))');
        WriteLn('TPFx ........ ',TPFX);
        WriteLn('EPFx ........ ',EPFX);
        WriteLn('TPFx/EPFx ... ',ROUND(TPFX/EPFX*100));


END;


PROCEDURE Cacl_VOL;
VAR N,M,I:LONGINT;
    R,R1:REAL;
BEGIN

        WriteLn('---Volume Log');
        FOR N:=0 TO 15 DO BEGIN
         R1:=N/15;
         R:=1-COS(PI/2*R1);
         R:=R*R1;
         WriteLn(R:3:4);
        END;



END;



BEGIN



        Cacl_AY();
        Cacl_VOL();


END.






