USES CRT,DOS,STRINGS;
VAR  N,M,I,O,P,L,X,XX,Y,YY:LONGINT;
     TRULKA:BOOLEAN;
     S:STRING;
     F:FILE;
     MAS:ARRAY[0..65535] OF BYTE;
     MASX,MASXX:ARRAY[0..65535] OF WORD;



TYPE   BMP_Header=RECORD

        BM:ARRAY [0..1] OF CHAR;         //тип файла (для битового образа - BM)
        Size:DWORD;                         //размер файла в dword
        Reserved1:WORD;                     //не используется
        Reserved2:WORD;                     //не используется
        Offbits:DWORD;                      //смещение данных битового образа от
                                            //заголовка в байтах
       END;

       BMP_Info_Header=RECORD
        Size:dword;            //число байт, занимаемых структурой
                               //BITMAPINFOHEADER
        Width:DWORD;           //ширина битового образа в пикселах
        Height:DWORD;          //высота битового образа в пикселах
        Planes:WORD;           //число битовых плоскостей устройства
        BitCount:WORD;         //число битов на пиксель
        Compression:DWORD;     //тип сжатия
        SizeImage:DWORD;       //размер картинки в байтах
        XPelsPerMeter:DWORD;   //горизонтальное разрешение устройства,
                               //пиксел/м
        YPelsPerMeter:DWORD;   //вертикальное разрешение устройства,
                               //пиксел/м
        ClrUsed:DWORD;         //число используемых цветов
        ClrImportant:DWORD;    //число "важных" цветов
       END;

       BMP_RGB=RECORD
        B:BYTE;
        G:BYTE;
        R:BYTE;
        L:BYTE;
       END;



VAR BMPYSTEP:DWORD;
    BMP:RECORD
     Header:BMP_Header;
     Info:BMP_Info_Header;
     RGB:ARRAY [0..255] OF BMP_RGB;
     DATA:ARRAY [0..1024*1024*16] OF BYTE;
    END;


FUNCTION Point(X,Y:LONGINT):DWORD;
VAR N,M,I,O:LONGINT;
BEGIN
        N:=BMPYSTEP*(BMP.Info.Height-Y-1)+X;
        N:=BMP.DATA[N];
        RESULT:=ROUND((BMP.RGB[N].R+BMP.RGB[N].G+BMP.RGB[N].B)/3);
END;


VAR PoLast:RECORD
     R:BYTE;
     G:BYTE;
     B:BYTE;
    END;

FUNCTION PointRGB(X,Y:LONGINT):DWORD;
VAR N,M,I,O:LONGINT;
BEGIN
        N:=BMPYSTEP*(BMP.Info.Height-Y-1)+X;
        N:=BMP.DATA[N];
        PoLast.R:=BMP.RGB[N].R;
        PoLast.G:=BMP.RGB[N].G;
        PoLast.B:=BMP.RGB[N].B;
        RESULT:=(PoLast.R SHL 00) OR
                (PoLast.G SHL 08) OR
                (PoLast.B SHL 16);
END;

FUNCTION GetZXCOL(COL,SHIFT,BRIGHT:DWORD):DWORD;
BEGIN
        //000..095 = 0
        //096..191 = 1
        //192..255 = 1+BRIGHT
        RESULT:=0;
        CASE COL OF
          96..191:RESULT:=RESULT OR (1 SHL SHIFT);
         192..255:RESULT:=RESULT OR (1 SHL SHIFT) OR (1 SHL BRIGHT);
        END;

END;

FUNCTION PointZXCOL(X,Y:LONGINT):DWORD;
VAR N,M,I,O:LONGINT;
BEGIN
        N:=BMPYSTEP*(BMP.Info.Height-Y-1)+X;
        N:=BMP.DATA[N];
        PoLast.R:=BMP.RGB[N].R;
        PoLast.G:=BMP.RGB[N].G;
        PoLast.B:=BMP.RGB[N].B;
        RESULT:=GetZXCOL(PoLast.B,0,0) OR
                GetZXCOL(PoLast.R,1,1) OR
                GetZXCOL(PoLast.G,2,2);
END;


FUNCTION TestX_Pix(X,XX:DWORD):BOOLEAN;
VAR N,M,I,O,Y:LONGINT;
BEGIN

        RESULT:=TRUE;
        FOR M:=0 TO XX-1 DO BEGIN
         FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
          I:=X+M;
          IF Point(I,Y) > 127 THEN EXIT;
         END;
        END;
        RESULT:=FALSE;

END;



FUNCTION GetNameX (S:STRING):STRING; CODE; ASM

        MOV ESI,[S]
        MOV EDI,@Result
        MOV EAX,[ESI]
        AND EAX,00FFFFFFH
        CMP EAX,002E2E02H
        JZ @M0
        AND EAX,0000FFFFH
        CMP EAX,00002E01H
        JZ @M0

        MOVZX ECX,AL
        JECXZ @M0

        MOV EBX,ECX
@M1:    MOV AL,[ESI+EBX]
        CMP AL,'.'
        JZ @M2
        DEC EBX
        JNZ @M1

        INC ECX
        REP MOVSB
        RET

@M2:    DEC EBX
        MOV ECX,EBX
        MOV EAX,EBX
        STOSB
        INC ESI
        REP MOVSB
        RET

@M0:    MOV [EDI],EAX
        RET

END;

VAR DefBMPNAME:STRING='';
PROCEDURE LoadBMP(S:STRING);
BEGIN
        WriteLn ('Converting: ',S+'.bmp');

        DefBMPNAME:=S;
        ASSIGN (F,S+'.bmp');
        RESET (F);
        BlockRead (F,BMP.Header,SizeOf(BMP.Header));
        BlockRead (F,BMP.Info,SizeOf(BMP.Info));

        FOR N:=0 TO 255 DO BEGIN
         BMP.RGB[N].R:=0;
         BMP.RGB[N].G:=0;
         BMP.RGB[N].B:=0;
         BMP.RGB[N].L:=0;
        END;
        BlockRead (F,BMP.RGB,BMP.Header.Offbits-SizeOf(BMP.Header)-SizeOf(BMP.Info));
        FOR N:=0 TO 255 DO BMP.RGB[N].L:=ROUND((BMP.RGB[N].R+BMP.RGB[N].G+BMP.RGB[N].B)/3);
        I:=FileSize(F)-FilePos(F);
        BlockRead (F,BMP.DATA,I);
        CLOSE (F);

{        BMPYSTEP:=ROUND(I/BMP.Info.Height);}

        BMPYSTEP:=BMP.Info.Width;
        ASM
@M2:     TEST BMPYSTEP,00000011B
         JZ @M1
         INC BMPYSTEP
         JMP @M2
@M1:
        END;

END;






CONST C_0=7;
      C_1=191;
      C_2=255;

FUNCTION GetColB(N:BYTE):BYTE;
BEGIN
      CASE N OF
       C_0+1..C_1:RESULT:=63+00;
       C_1+1..C_2:RESULT:=63+64;
       ELSE RESULT:=0;
      END;
END;

FUNCTION GetColor(N:DWORD):DWORD;
BEGIN
        RESULT:=0;
        RESULT:=RESULT OR (GetColB((N SHR 00) AND 255) AND (64+1));
        RESULT:=RESULT OR (GetColB((N SHR 08) AND 255) AND (64+2));
        RESULT:=RESULT OR (GetColB((N SHR 16) AND 255) AND (64+4));
END;




CONST ZX_SCR:ARRAY [0..23] OF DWORD=(
       2048*0+32*0,
       2048*0+32*1,
       2048*0+32*2,
       2048*0+32*3,
       2048*0+32*4,
       2048*0+32*5,
       2048*0+32*6,
       2048*0+32*7,
       2048*1+32*0,
       2048*1+32*1,
       2048*1+32*2,
       2048*1+32*3,
       2048*1+32*4,
       2048*1+32*5,
       2048*1+32*6,
       2048*1+32*7,
       2048*2+32*0,
       2048*2+32*1,
       2048*2+32*2,
       2048*2+32*3,
       2048*2+32*4,
       2048*2+32*5,
       2048*2+32*6,
       2048*2+32*7);


VAR CoFP:LONGINT=-1;
    CoFI:LONGINT=-1;
    CoIN:BYTE=0;

PROCEDURE CovertToSCR(FNAM:STRING);
VAR N,M,I,O,C_INK,C_PAP,C_DAT,C_IC,C_PC,A,B,C,P,X,Y:LONGINT;
    F:FILE;

BEGIN

        I:=0;
        FOR Y:=0 TO 23 DO BEGIN
         FOR X:=0 TO 31 DO BEGIN
          C_DAT:=0;
//          C_PAP:=-1;
//          C_INK:=-1;
           C_PAP:=CoFP;
           C_INK:=CoFI;
          C_IC:=0;
          C_PC:=0;
          FOR M:=0 TO 7 DO BEGIN
           FOR N:=0 TO 7 DO BEGIN
            P:=Point(X*8+N,Y*8+M);
            A:=GetColor(P);
            IF A=C_INK THEN BEGIN
             B:=1;
            END ELSE IF A=C_PAP THEN BEGIN
             B:=0;
            END ELSE BEGIN
             IF C_INK=-1 THEN BEGIN
              C_INK:=A;
              B:=1;
             END ELSE IF C_PAP=-1 THEN BEGIN
              C_PAP:=A;
              B:=0;
             END ELSE B:=0;
            END;
            IF B=0 THEN INC(C_PC) ELSE INC(C_IC);
            C_DAT:=(C_DAT SHL 1) OR B;
           END;

           MAS[ZX_SCR[Y]+X+M*256]:=C_DAT;
          END;

          IF C_INK=-1 THEN C_INK:=C_PAP;
          IF C_PAP=-1 THEN C_PAP:=C_INK;
          IF C_INK=-1 THEN C_INK:=C_PAP;

          IF CoFP<>-1 THEN BEGIN
           C_PAP:=CoFP;
           C_INK:=CoFI;

          END ELSE BEGIN
           IF C_IC>C_PC THEN BEGIN
            FOR M:=0 TO 7 DO MAS[ZX_SCR[Y]+X+M*256]:=NOT MAS[ZX_SCR[Y]+X+M*256];
            C_DAT:=C_INK;
            C_INK:=C_PAP;
            C_PAP:=C_DAT;
           END;
          END;

          FOR M:=0 TO 7 DO MAS[ZX_SCR[Y]+X+M*256]:=CoIN XOR MAS[ZX_SCR[Y]+X+M*256];


          MAS[6144+Y*32+X]:=(C_PAP AND 64) OR ((C_PAP AND 7) SHL 3) OR C_INK;
         END;
        END;


        ASSIGN (F,FNAM+'.scr');
        REWRITE (F);
        BlockWrite (F,MAS,6912);
        CLOSE (F);


END;










PROCEDURE CovertToMonoSCR(FNAM:STRING;INV:BYTE);
VAR N,M,I,O,A,B,C,P,X,Y:LONGINT;
BEGIN


        FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
         FOR X:=0 TO BMP.Info.Width-1 DO BEGIN
          P:=Point(X,Y);
//          P:=(P AND 255)+((P SHR 8) AND 255)+((P SHR 16) AND 255);
//          P:=ROUND(INT(P/3));
          IF P<240 THEN P:=0 ELSE P:=1;
          N:=(N SHL 1) OR P;

          IF ((X+1) AND 7)=0 THEN BEGIN
           I:=ZX_SCR[Y SHR 3] OR ((Y AND 7) SHL 8) OR (X SHR 3);
           MAS[I]:=N XOR INV;
          END;

         END;
        END;

        ASSIGN (F,FNAM+'.scr');
        REWRITE (F);
        BlockWrite (F,MAS,6144);
        CLOSE (F);

END;


PROCEDURE CovertToMonoBIN(FNAM:STRING;INV:BYTE);
VAR N,M,I,O,A,B,C,P,X,Y:LONGINT;
BEGIN

        I:=0;
        FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
         FOR X:=0 TO BMP.Info.Width-1 DO BEGIN
          P:=Point(X,Y);
//          P:=(P AND 255)+((P SHR 8) AND 255)+((P SHR 16) AND 255);
//          P:=ROUND(INT(P/3));
          IF P<128 THEN P:=0 ELSE P:=1;
          N:=(N SHL 1) OR P;

          IF ((X+1) AND 7)=0 THEN BEGIN
//           I:=ZX_SCR[Y SHR 3] OR ((Y AND 7) SHL 8) OR (X SHR 3);
           MAS[I]:=N XOR INV;
           INC (I);
          END;

         END;
        END;

        ASSIGN (F,FNAM+'.bin');
        REWRITE (F);
//        BlockWrite (F,BMP.Info.Height,1);
        BlockWrite (F,MAS,I);
        CLOSE (F);

END;

CONST COL_PRI:ARRAY[0..7] OF BYTE=(0,0,0,0,0,1,1,1);

PROCEDURE SetColPRI_STR(S:STRING);
VAR N:LONGINT;
BEGIN
      FOR N:=0 TO 7 DO BEGIN
       COL_PRI[N]:=BYTE(S[N+1]) AND 7;
      END;
END;


PROCEDURE CovertToColorBIN(FNAM:STRING;PAPSIZE_M:DWORD);
VAR N,M,MA,MI,MP,I,O,A,B,C,CM,D,P,XO,X,Y:LONGINT;
    COLT:ARRAY[0..255] OF RECORD
     COL:ARRAY[0..1] OF BYTE;
     USED:ARRAY[0..1] OF BOOLEAN;
    END;
BEGIN

        I:=0;
        O:=0;
        FillChar(MAS,SizeOf(MAS),0);
        FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
         IF (Y AND PAPSIZE_M)=0 THEN BEGIN
          FillChar(COLT,SizeOf(COLT),0);
         END;
         FOR X:=0 TO BMP.Info.Width-1 DO BEGIN
          C:=PointZXCOL(X,Y);
          XO:=X SHR 3;
          B:=49152+O+XO;
          MA:=128 SHR (X AND 7);
          P:=COL_PRI[C];

          IF COLT[XO].USED[P] AND (COLT[XO].COL[P]=C) THEN BEGIN
          END ELSE BEGIN
           IF COLT[XO].USED[P XOR 1] AND (COLT[XO].COL[P XOR 1]=C) THEN BEGIN
            P:=P XOR 1;
           END;
          END;

          IF COLT[XO].USED[P] AND (COLT[XO].COL[P]=C) THEN BEGIN
          END ELSE BEGIN
           IF COLT[XO].USED[P] THEN BEGIN
            P:=P XOR 1;
           END;
           IF COLT[XO].USED[P] THEN BEGIN
            P:=P XOR 1;
            WriteLn('!!! ERROR !!! TO MANI COLORS(',X:3,',',Y:3,')  !!! ERROR !!!');
           END;
          END;

          COLT[XO].USED[P]:=TRUE;
          COLT[XO].COL[P]:=C;
          N:=N AND (MA XOR 255);
          IF P=0 THEN N:=N OR MA;

          IF ((X+1) AND 7)=0 THEN BEGIN
           MAS[I+XO]:=N;
          END;

         END;
         X:=BMP.Info.Width SHR 3;
         INC (I,X);
         IF (((Y+1) AND PAPSIZE_M)=0) {OR ((Y+1)=BMP.Info.Height)} THEN BEGIN
          FOR XO:=0 TO (BMP.Info.Width SHR 3)-1 DO BEGIN;
           MAS[49152+O]:=COLT[XO].COL[0] OR (COLT[XO].COL[1] SHL 3);
           INC (O);
          END;
         END;
        END;

        ASSIGN (F,FNAM+'.bin');
        REWRITE (F);
//        BlockWrite (F,BMP.Info.Height,1);
        BlockWrite (F,MAS,I);
        BlockWrite (F,MAS[49152],O);
        CLOSE (F);

END;


VAR MASI,MASO:ARRAY[0..65535] OF BYTE;

PROCEDURE Xorik(FNAM:STRING);
VAR N,M,I,O,P:LONGINT;
    F:FILE;
    MAS:ARRAY[0..65535] OF BYTE;
BEGIN
        ASSIGN(F,FNAM);
        RESET(F);
        P:=FileSize(F);
        BlockRead(F,MAS,P);
        CLOSE(F);

        FOR N:=0 TO P-1 DO BEGIN
         MAS[N]:=MASI[N] XOR MAS[N];
        END;

        ASSIGN(F,FNAM);
        REWRITE(F);
        BlockWrite(F,MAS,P);
        CLOSE(F);

END;



PROCEDURE CrunchPero;
VAR N,M,I,O,P:LONGINT;
    F:FILE;
    MAS_G,MAS_M:ARRAY[0..65535] OF BYTE;

BEGIN

        ASSIGN(F,'pero-g.bin');
        RESET(F);
        BlockRead(F,MAS_G,FileSize(F));
        CLOSE(F);

        ASSIGN(F,'pero-m.bin');
        RESET(F);
        BlockRead(F,MAS_M,FileSize(F));
        CLOSE(F);


END;



//R,G,B = 0..7
FUNCTION IzLastColor(R,G,B:BYTE):BOOLEAN;
CONST RF:REAL=36.4285714285714286;
BEGIN
       RESULT:=TRUE;

       IF ROUND(PoLast.R/RF)<>R THEN RESULT:=FALSE;
       IF ROUND(PoLast.G/RF)<>G THEN RESULT:=FALSE;
       IF ROUND(PoLast.B/RF)<>B THEN RESULT:=FALSE;


END;

FUNCTION GetXAND7(X:DWORD):DWORD;
BEGIN
      RESULT:=((((X-0) OR 7)+0) SHR 3);
END;


FUNCTION ByteShiftCHK(AD,AS,BD,BS:DWORD):BOOLEAN;
VAR N,M,I:LONGINT;
BEGIN

        CASE AS OF
         0:AD:=(AD AND $00FF0000) OR ((AD SHR 0) AND $000000FF);
         1:AD:=(AD AND $00FF0000) OR ((AD SHR 8) AND $000000FF);
        END;

        CASE BS OF
         0:BD:=(BD AND $00FF0000) OR ((BD SHR 0) AND $000000FF);
         1:BD:=(BD AND $00FF0000) OR ((BD SHR 8) AND $000000FF);
        END;

        RESULT:=AD=BD;


END;




PROCEDURE CrunchWo_M(FNAM:STRING;XORING:DWORD);
CONST x_KAD=8;
VAR N,M,I,II,O,P,X,XS,XSS,Y,YY,ISA:LONGINT;
    A,B,C,D:DWORD;
    MAS_A:ARRAY[0..65535] OF BYTE;
    MAS_X:ARRAY[0..x_KAD*(8*9*8)] OF BYTE;
    MAS_R:ARRAY[0..255] OF DWORD;
    MAS_D:ARRAY[0..3] OF BYTE;
    T:TEXT;
BEGIN
        WriteLn('XSize: ',BMP.Info.Width);
        WriteLn('YSize: ',BMP.Info.Height);


        P:=0;
        I:=0;
//        XS:=GetXAND7(BMP.Info.Width);
//        XSS:=(((ROUND(BMP.Info.Width/8)-1) OR 7)+1);
        WriteLn(XS);
        FillChar(MAS_A, SizeOf(MAS_A), 0);
        FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
         FOR X:=0 TO BMP.Info.Width-1 DO BEGIN
          N:=Point(X,Y);
          IF N<128 THEN BEGIN
           N:=0 XOR XORING;
          END ELSE BEGIN
           N:=255 XOR XORING;
          END;
          MAS_A[I]:=MAS_A[I] OR (N AND (128 SHR (X AND 7)));
          IF (X AND 7)=7 THEN INC(I);
         END;
        END;


        WriteLn(I);


        ISA:=XS*BMP.Info.Height;

        ASSIGN(F,FNAM+'.bin');
        REWRITE(F);
        BlockWrite(F,MAS_A,I);
        CLOSE(F);


        I:=0;
        N:=0;
        FillChar(MAS_X, SizeOf(MAS_X), 0);
        FOR M:=0 TO x_KAD-1 DO BEGIN
         FOR Y:=0 TO 7 DO BEGIN
          MAS_X[N+0]:=MAS_A[I+0];
          MAS_X[N+1]:=MAS_A[I+1];
          MAS_X[N+2]:=MAS_A[I+2];
          MAS_X[N+3]:=MAS_A[I+3];
          MAS_X[N+4]:=MAS_A[I+0];
          MAS_X[N+5]:=MAS_A[I+1];
          MAS_X[N+6]:=MAS_A[I+2];
          MAS_X[N+7]:=MAS_A[I+3];
          MAS_X[N+8]:=0;
          INC(N,9);
          INC(I,4);
         END;
         INC(N,7*9*8);
        END;

        A:=0;
        B:=9*8;
        FOR M:=0 TO x_KAD-1 DO BEGIN
         C:=0;
         FOR Y:=0 TO 8*7-1 DO BEGIN
          FOR X:=0 TO 8 DO BEGIN
           MAS_X[B]:=(MAS_X[A] SHR 1) OR C;
           C:=MAS_X[A] SHL 7;
           INC(A);
           INC(B);
          END;
         END;
         INC(A,9*8);
         INC(B,9*8);
        END;

        FillChar(MAS_R, SizeOf(MAS_R), 0);
        FOR N:=0 TO A-1 DO BEGIN
         INC(MAS_R[MAS_X[N]]);
        END;

        FOR Y:=0 TO 3 DO BEGIN
         B:=1;
         FOR N:=1 TO 255 DO BEGIN
          IF MAS_R[B]<MAS_R[N] THEN BEGIN
           B:=N;
          END;
         END;
         MAS_D[Y]:=B;
         WriteLn (B:3,' ',MAS_R[B]);
         MAS_R[B]:=0;
        END;

        ASSIGN(F,FNAM+'.bio');
        REWRITE(F);
        BlockWrite(F,MAS_D,4);
        BlockWrite(F,MAS_X,A);
        CLOSE(F);

        ASSIGN(T,FNAM+'.az8');
        REWRITE(T);
        WriteLn(T,'rCO_0      EQU ',MAS_D[0]);
        WriteLn(T,'rCO_1      EQU ',MAS_D[1]);
        WriteLn(T,'rCO_2      EQU ',MAS_D[2]);
        WriteLn(T,'rCO_3      EQU ',MAS_D[3]);
        CLOSE(T);


END;

FUNCTION GetNameHEX(D,L:DWORD):STRING;
BEGIN
        RESULT:=COPY(HEX(D),9-L,L);

END;

PROCEDURE DecrunchBIN_LOGR(FNAM:STRING;XORING,LINS:DWORD);
VAR N,M,I,II,O,P,X,XS,XSS,Y,YY,ISA,L:LONGINT;
    MASO:ARRAY[0..65535] OF BYTE;
    F:FILE;
BEGIN

        CovertToMonoBIN(FNAM,XORING);


        FillChar(MAS,SizeOf(MAS),XORING);


        ASSIGN(F,FNAM+'.bin');
        RESET(F);
        ISA:=FileSize(F);
        BlockRead(F,MAS,ISA);
        CLOSE(F);

        L:=0;
        P:=0;
        I:=0;
        Y:=BMP.Info.Height-8;
        XS:=BMP.Info.Width SHR 3;
        WHILE Y>=0 DO BEGIN

         FOR X:=0 TO XS-1 DO BEGIN
          FOR N:=0 TO 7 DO BEGIN
           MASO[I]:=MAS[(Y+N)*XS+X];
           INC(I);
          END;
         END;

         INC(L);
         IF L=LINS THEN BEGIN
          L:=0;
          ASSIGN(F,FNAM+'.b'+GetNameHEX(P,2));
          REWRITE(F);
          BlockWrite(F,MASO,I);
          CLOSE(F);
          I:=0;
          INC(P);
         END;

         DEC(Y,8);
        END;

        IF I<>0 THEN BEGIN
         ASSIGN(F,FNAM+'.b'+GetNameHEX(P,2));
         REWRITE(F);
         BlockWrite(F,MASO,I);
         CLOSE(F);
        END;



END;


PROCEDURE CovertToMonoBIN_MASK(FNAM:STRING;INV:BYTE);
VAR N,NN,M,I,O,A,B,C,P,PP,X,Y:LONGINT;
BEGIN

        FillChar(MAS,SizeOf(MAS),0);
        I:=0;
        FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
         FOR X:=0 TO BMP.Info.Width-1 DO BEGIN
          PP:=PointRGB(X,Y);
          IF ((PP SHR 8) AND $FF) <> (PP AND $FF) THEN BEGIN
           P:=INV;
           PP:=1;
          END ELSE BEGIN
           P:=Point(X,Y);
           PP:=0;
          END;

          IF P<128 THEN P:=0 ELSE P:=1;

          N:=(N SHL 1) OR P;

//          IF PP<128 THEN PP:=0 ELSE PP:=1;
          NN:=(NN SHL 1) OR PP;

          IF ((X+1) AND 7)=0 THEN BEGIN
           MAS[I]:=NN;
           INC (I);
           MAS[I]:=(N XOR INV) AND (NOT NN);
           INC (I);
          END;

         END;
        END;

        ASSIGN (F,FNAM+'.bin');
        REWRITE (F);
//        BlockWrite (F,BMP.Info.Height,1);
        BlockWrite (F,MAS,I);
        CLOSE (F);

END;
VAR CFG:RECORD
     FNT_CHAR_I:ARRAY[0..255] OF WORD;  // IN NUMERATE CHARS IN BMP
     FNT_FILL:BYTE;                     //OUT DEFAULT FILL BYTE FOR FONT DATA
     FNT_RGB_BAK:DWORD;                 // IN COLOR TRANSPARENT PIXELS
     FNT_RGB_PIX:DWORD;                 // IN COLOR FOR PIXELS
     FNT_FORMAT:DWORD;                  // 0-FNT BIN LINEAR
                                        // 1-FON BIN +256 STEP
                                        // 2-FNN BIN +256 STEP, +SIZE OF CHAR
                                        // 3-FNP BIN PACKED MODE
                                        // 4-FNC COLOR PACKED MODE
     FNT_CHAR_XS:BYTE;                  // CHAR X BTYE SIZE
     FNT_CHAR_YS:BYTE;                  // CHAR Y LINE SIZE
    END;


PROCEDURE SetUseChar(RdC,WrC:CHAR);
BEGIN
        CFG.FNT_CHAR_I[BYTE(RdC)]:=BYTE(WrC) OR $8000;
END;


PROCEDURE CFG_Def_DOS_DOS;
VAR N,M,I:LONGINT;
BEGIN
      FillChar(CFG.FNT_CHAR_I,SizeOf(CFG.FNT_CHAR_I),0);
      FOR N:=0 TO 255 DO BEGIN
       SetUseChar(CHAR(N),CHAR(N));
      END;
END;

PROCEDURE CFG_Def_STR(S:STRING);
VAR N,M,I:LONGINT;
BEGIN

        FillChar(CFG.FNT_CHAR_I,SizeOf(CFG.FNT_CHAR_I),0);
        FOR N:=0 TO Length(S)-1 DO BEGIN
         SetUseChar(CHAR(N),S[N+1]);
        END;

END;

PROCEDURE CFG_Reset(CO_PI,CO_BA,MODE:DWORD);
BEGIN
      FillChar(CFG,SizeOf(CFG),0);

      CASE MODE OF
          0:CFG_Def_DOS_DOS();
       ELSE CFG_Def_DOS_DOS();
      END;
      CFG.FNT_RGB_BAK:=CO_BA;
      CFG.FNT_RGB_PIX:=CO_PI;

END;

FUNCTION MemComp(VAR A;VAR B;SIZ:DWORD):BOOLEAN;
VAR N,M,I:LONGINT;
    AB,BB:BYTE;
BEGIN
        RESULT:=FALSE;
        IF SIZ=0 THEN EXIT;
        FOR N:=0 TO SIZ-1 DO BEGIN
         AB:=PByte(DWORD(@A)+N)^;
         BB:=PByte(DWORD(@B)+N)^;
         IF AB<>BB THEN EXIT;
        END;
        RESULT:=TRUE;
END;



PROCEDURE ConvertFONT(FNAM:STRING; FORMATMODE:DWORD);
VAR N,M,MM,I,O,P,PP,P0,P1,X,Y,PPMAX,PMA:LONGINT;
    FORMA:BYTE;
    XST,CHARSI:LONGINT;
    C,D:DWORD;
    SEXT:STRING;
    RGBC:DWORD;
    T:TEXT;
BEGIN
        IF FNAM='' THEN FNAM:=DefBMPNAME;
        IF FNAM='' THEN BEGIN
         WriteLn('!!! ERROR FILE NAME IS EMPTY !!!');
        END;
        FillChar(MAS,SizeOf(MAS),CFG.FNT_FILL);

        IF CFG.FNT_CHAR_XS=0 THEN CFG.FNT_CHAR_XS:=1;//BMP.Info.Height;
        IF CFG.FNT_CHAR_YS=0 THEN CFG.FNT_CHAR_YS:=BMP.Info.Height;
        CFG.FNT_FORMAT:=FORMATMODE AND $0000FFFF;
        FORMA:=CFG.FNT_FORMAT;

        XST:=CFG.FNT_CHAR_XS*8;
        WriteLn('BMP XS = ',BMP.Info.Width);
        WriteLn('BMP YS = ',BMP.Info.Height);
        WriteLn('FNT XS = ',CFG.FNT_CHAR_XS,'x8 = ',XST);
        WriteLn('FNT YS = ',CFG.FNT_CHAR_YS);
        WriteLn('FNT MOD= ',HEX(CFG.FNT_FORMAT));

        CHARSI:=CFG.FNT_CHAR_YS*CFG.FNT_CHAR_XS;
        SEXT:='';
        P:=0;     //POS IN MAS
        PPMAX:=0; //SAVE MAX !!!
        CASE FORMA OF
         0,3,5:BEGIN //FNT & FNP
           IF FORMA=0 THEN BEGIN
            I:=0;
            Write('Create FNT ...');
           END ELSE BEGIN
            I:=512+16;
            Write('Create FNP ...');
           END;
           FOR X:=0 TO (BMP.Info.Width DIV XST)-1 DO BEGIN
            M:=CFG.FNT_FORMAT SHR 8;
            MM:=0;
            FOR Y:=0 TO CFG.FNT_CHAR_YS-1 DO BEGIN
             FOR N:=0 TO XST-1 DO BEGIN
              RGBC:=PointRGB(X*XST+N,Y);
              C:=CFG.FNT_CHAR_I[X];
              IF C>255 THEN BEGIN
               C:=C AND 255;
               IF RGBC=CFG.FNT_RGB_PIX THEN BEGIN
                IF M<(N+1) THEN M:=N+1;
                IF N=0 THEN MM:=128;
                PMA:=C*CFG.FNT_CHAR_YS+I;
                PP:=DWORD(@MAS[PMA]+(N SHR 3));
                INC(PP,Y*CFG.FNT_CHAR_XS);
                MEM[PP]:=MEM[PP] OR (128 SHR (N AND 7));
                IF PPMAX<PMA THEN PPMAX:=PMA;
               END;
              END;
             END;
            END;
            C:=CFG.FNT_CHAR_I[X];
//            IF (C>255) AND (FORMA=3) THEN BEGIN
            IF (C>255) AND ((FORMA=3) OR (FORMA=5)) THEN BEGIN
             C:=X;
             PP:=DWORD(@MAS[C AND 255])+256+16;
             MEM[PP]:=M OR MM;
            END;
           END;
           IF FORMA=0 THEN BEGIN
            SEXT:='FNT';
            CASE (FORMATMODE SHR 20) OF
             0: P:=CFG.FNT_CHAR_XS*CFG.FNT_CHAR_YS*256;
             1: P:=PPMAX+CFG.FNT_CHAR_YS;
            END;
           END ELSE BEGIN
            SEXT:='FNP';
            //PACK
            MAS[0]:=CFG.FNT_CHAR_XS;
            MAS[1]:=CFG.FNT_CHAR_YS;
            MAS[2]:=CHARSI;
            MAS[3]:=0;      //USED CHARS
            PWord(DWORD(@MAS[4]))^:=I;
            PWord(DWORD(@MAS[6]))^:=I-256;
            P:=I;
            FOR N:=0 TO 255 DO BEGIN
             PP:=0;
             FOR M:=0 TO N-1 DO BEGIN
              IF MemComp(MAS[N*CHARSI+I],MAS[M*CHARSI+I],CHARSI) THEN BEGIN
               MAS[16+N]:=M;
               PP:=1;
               BREAK;
              END;
             END;
             IF (FORMA=5) THEN BEGIN
              M:=MAS[3];
              MAS[16+M+256]:=MAS[16+N+256];
             END;
             IF PP=0 THEN BEGIN
              MAS[16+N]:=MAS[3];
              FOR M:=0 TO CHARSI-1 DO BEGIN
               MAS[P]:=MAS[N*CHARSI+I+M];
               INC(P);
              END;
              INC(MAS[3]);
             END;
            END;
            FOR N:=MAS[3] TO 255 DO BEGIN
             MAS[16+N+256]:=0;
            END;

//            P:=CFG.FNT_CHAR_XS*CFG.FNT_CHAR_YS*256+I;

           END;
           WriteLn(' OK');
         END;

         1:BEGIN //FON
           Write('Create FON ...');
           FOR X:=0 TO (BMP.Info.Width DIV XST)-1 DO BEGIN
            FOR Y:=0 TO CFG.FNT_CHAR_YS-1 DO BEGIN
             FOR N:=0 TO 7 DO BEGIN
              RGBC:=PointRGB(X*XST+N,Y);
              C:=CFG.FNT_CHAR_I[X];
              IF C>255 THEN BEGIN
               C:=C AND 255;
               IF RGBC=CFG.FNT_RGB_PIX THEN BEGIN
                PP:=DWORD(@MAS[C]);
                INC(PP,Y*256);
                MEM[PP]:=MEM[PP] OR (128 SHR (N AND 7));
               END;
              END;
             END;
            END;
           END;
           SEXT:='FON';
           P:=CFG.FNT_CHAR_XS*CFG.FNT_CHAR_YS*256;
           WriteLn(' OK');
         END;

         2:BEGIN //FNN
           Write('Create FNN ...');
           FOR X:=0 TO (BMP.Info.Width DIV XST)-1 DO BEGIN
            M:=CFG.FNT_FORMAT SHR 8;
            I:=0;
            FOR Y:=0 TO CFG.FNT_CHAR_YS-1 DO BEGIN
             FOR N:=0 TO 7 DO BEGIN
              RGBC:=PointRGB(X*XST+N,Y);
              C:=CFG.FNT_CHAR_I[X];
              IF C>255 THEN BEGIN
               C:=C AND 255;
               IF RGBC=CFG.FNT_RGB_PIX THEN BEGIN
                IF M<(N+1) THEN M:=N+1;
                IF N=0 THEN I:=128;
                PP:=DWORD(@MAS[C])+512;
                INC(PP,Y*256);
                MEM[PP]:=MEM[PP] OR (128 SHR (N AND 7));
               END;
              END;
             END;
            END;
            C:=CFG.FNT_CHAR_I[X];
            IF C>255 THEN BEGIN
             PP:=DWORD(@MAS[C AND 255]);
             MEM[PP]:=M OR I;
            END;
           END;
           SEXT:='FNN';
           FOR N:=0 TO 255 DO BEGIN
            MAS[N+256]:=$0FFFFFF00 SHR (MAS[N] AND 15);
           END;
           P:=CFG.FNT_CHAR_XS*CFG.FNT_CHAR_YS*256+512;
           WriteLn(' OK');
         END;

        END;

        IF SEXT<>'' THEN BEGIN
         ASSIGN (F,FNAM+'.'+SEXT);
         REWRITE (F);
         BlockWrite (F,MAS,P);
         CLOSE (F);
         IF ((FORMATMODE SHR 16) AND 15)<>0 THEN BEGIN
          ASSIGN(T,FNAM+'.inc');
          REWRITE(T);
          FOR N:=0 TO P-1 DO BEGIN
           Write(T,'0x',COPY(HEX(MAS[N]),7,2));
           IF (N+1)<>P THEN Write(T,',');
           IF ((N+1) MOD 10)=0 THEN WriteLn(T,'');
          END;
          WriteLn(T,'');
          CLOSE(T);
         END;
        END;


END;


BEGIN



//        S:='spitu';
//        IF ParamSTR(1)<>'' THEN S:=GetNameX(ParamSTR(1));

        LoadBMP('fnt4-24');
        CFG_Reset($00FFFFFF,$00000000,0);
        CFG_Def_STR('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЖЗИЙКabcdefghijklmnopqrstuvwxyz#-█░▓_.ыб[\]^+,()@┌┬┐└┴┘├┤');
        ConvertFONT('',$000403);


END.


