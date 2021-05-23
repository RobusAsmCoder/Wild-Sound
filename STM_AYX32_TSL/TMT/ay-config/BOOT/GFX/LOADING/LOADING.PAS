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


PROCEDURE LoadBMP(S:STRING);
BEGIN
        WriteLn ('Converting: ',S+'.bmp');


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

        N:=BMP.Info.Height*(BMP.Info.Width SHR 3);
        ASSIGN (F,FNAM+'.scr');
        REWRITE (F);
        BlockWrite (F,MAS,N);
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


PROCEDURE FindTwoMAX(VAR MAS; VAR NMA_A,NMAxA,NMA_B,NMAxB,NMA_C,NMAxC:DWORD; SIZ:WORD);
VAR N,M,I:LONGINT;
    MASREP:ARRAY[0..65535] OF WORD;
//    MASREX:ARRAY[0..65535] OF WORD;
BEGIN
        FillChar(MASREP,SizeOf(MASREP),0);
        I:=0;
        NMA_A:=0;
        NMA_B:=0;
        NMAxA:=0;
        NMAxB:=0;
        WHILE I<SIZ DO BEGIN
//         N:=PBYTE(DWORD(@MAS)+I)^;
//         INC(I);
//         N:=N OR (PBYTE(DWORD(@MAS)+I)^ SHL 8);
//         INC(I);
         N:=PWord(DWORD(@MAS)+I)^;
         INC(I,2);
         INC(MASREP[N]);
        END;

{
        FOR N:=0 TO 65535 DO MASREX[N]:=N;
        FOR N:=0 TO 65535 DO BEGIN
         FOR M:=N TO 65535 DO BEGIN
          IF MASREP[M]>MASREP[N] THEN BEGIN
           NMA_A:=MASREP[N];
           MASREP[N]:=MASREP[M];
           MASREP[M]:=NMA_A;
           NMA_A:=MASREX[N];
           MASREX[N]:=MASREX[M];
           MASREX[M]:=NMA_A;
          END;
         END;
        END;
        NMA_A:=MASREP[0];
        NMA_B:=MASREP[1];
        NMAxA:=MASREX[0];
        NMAxB:=MASREX[1];
}
        NMA_A:=0;
        NMA_B:=0;
        NMA_C:=0;
        NMAxA:=$FFFFFFFF;
        NMAxB:=$FFFFFFFF;
        NMAxC:=$FFFFFFFF;
        FOR N:=0 TO 65535 DO BEGIN
         IF NMA_A<MASREP[N] THEN BEGIN
          IF NMA_B<NMA_A THEN BEGIN
           IF NMA_C<NMA_B THEN BEGIN
            NMA_C:=NMA_B;
            NMAxC:=NMAxB;
           END;
           NMA_B:=NMA_A;
           NMAxB:=NMAxA;
          END;
          NMA_A:=MASREP[N];
          NMAxA:=N;
         END ELSE BEGIN
          IF NMA_B<MASREP[N] THEN BEGIN
           IF NMA_C<NMA_B THEN BEGIN
            NMA_C:=NMA_B;
            NMAxC:=NMAxB;
           END;
           NMA_B:=MASREP[N];
           NMAxB:=N;
          END ELSE BEGIN
           IF NMA_C<MASREP[N] THEN BEGIN
            NMA_C:=MASREP[N];
            NMAxC:=N;
           END;
          END;
         END;
        END;

END;



PROCEDURE Crunch_128x192(FNAM:STRING;PEREPOL:DWORD);
VAR N,M,I,II,O,P,X,XS,XSS,Y,YY,ISA,TIK,TIKMA:LONGINT;
    NMA_A,NMAxA:DWORD;
    NMA_B,NMAxB:DWORD;
    NMA_C,NMAxC:DWORD;
    NMAHL:DWORD;
    MASC:ARRAY[0..65535] OF BYTE;

BEGIN

        ASSIGN(F,FNAM+'.bin');
        RESET(F);
        BlockRead(F,MAS,FileSize(F));
        CLOSE(F);



        FOR N:=0 TO 3071 DO MAS[3072+N]:=MAS[3072+N] OR 64;

//        FindTwoMAX(MAS[3072], NMA_A, NMAxA, NMA_B, NMAxB, 3072);
//        WriteLn(HEX(NMAxA),' - ',NMA_A);
//        WriteLn(HEX(NMAxB),' - ',NMA_B);

        FillChar(MASC,SizeOf(MASC),0);
        I:=192*2;

        FindTwoMAX(MAS[3072], NMA_A, NMAxA, NMA_B, NMAxB, NMA_C, NMAxC, 3072);
//        NMAxC:=$FFFF0000;
        WriteLN(HEX(NMAxA),' - ',NMA_A,' ... ');
        WriteLN(HEX(NMAxB),' - ',NMA_B,' ... ');
        WriteLN(HEX(NMAxC),' - ',NMA_C,' ... ');

        PWord(@MASC[I])^:=NMAxA;
        INC(I,2);
        PWord(@MASC[I])^:=NMAxB;
        INC(I,2);
        PWord(@MASC[I])^:=NMAxC;
        INC(I,2);

        TIKMA:=0;
        FOR Y:=0 TO 191 DO BEGIN
         TIK:=0;
         PWord(@MASC[Y*2])^:=I;

         MASC[I]:=49;           //LD SP,nn
         INC(I);
         PWord(@MASC[I])^:=(22528-64*256) OR ((Y SHR 3)*32+16+8);
         INC(I,2);

         INC(TIK,10);
         NMAHL:=$FFFF0000;
         X:=14;
         WHILE X>=0 DO BEGIN
          N:=PWord(@MAS[3072+Y*16+X])^;
          IF N=NMAxA THEN BEGIN
           MASC[I]:=$C5;        //PUSH BC
           INC(I);
           INC(TIK,11);
          END ELSE BEGIN
           IF N=NMAxB THEN BEGIN
            MASC[I]:=$D5;       //PUSH DE
            INC(I);
            INC(TIK,11);
           END ELSE BEGIN
            IF N=NMAxC THEN BEGIN
             MASC[I]:=$F5;      //PUSH AF
             INC(I);
             INC(TIK,11);
            END ELSE BEGIN
             IF NMAHL<>N THEN BEGIN
              MASC[I]:=33;       //LD HL,nn
              INC(I);
              MASC[I]:=N;
              INC(I);
              MASC[I]:=N SHR 8;
              INC(I);
              INC(TIK,10);
              NMAHL:=N;
             END;
             MASC[I]:=$E5;      //PUSH HL
             INC(I);
             INC(TIK,11);
            END;
           END;
          END;
          DEC(X,2);
         END;

//         I:=((I-1) OR 31)+1;
         IF TIKMA<TIK THEN TIKMA:=TIK;

         WHILE TIK<PEREPOL DO BEGIN
          N:=PEREPOL-TIK;
          {IF N>=(19*2+6) THEN BEGIN
           MASC[I]:=$E3;         //EX (SP),HL
           INC(I);
           MASC[I]:=$E3;         //EX (SP),HL
           INC(I);
           INC(TIK,19*2);
          END ELSE }BEGIN
           CASE TIK AND 3 OF
            0:BEGIN
             IF N>=12 THEN BEGIN
              MASC[I]:=$18;         //JR s
              INC(I);
              MASC[I]:=$00;         //
              INC(I);
              INC(TIK,12);
             END ELSE BEGIN
              MASC[I]:=$00;       //INC HL
              INC(I);
              INC(TIK,4);
             END;
            END;
            1,3:BEGIN
             MASC[I]:=$2E;       //LD L,n
             INC(I,2);
             INC(TIK,7);
            END;
            2:BEGIN
             MASC[I]:=$23;       //INC HL
             INC(I);
             INC(TIK,6);
            END;
           END;
          END;
         END;

         IF TIK<>PEREPOL THEN BEGIN
          WriteLn(TIK);
          WriteLn('!!! ERROR !!!');
          HALT;
         END;

        END;
        WriteLn('TIK MAX: ',TIKMA);
        WriteLn('TIK FRE: ',224-TIKMA);







        ASSIGN(F,FNAM+'.biG');
        REWRITE(F);
        BlockWrite(F,MAS,3072);
        CLOSE(F);

        ASSIGN(F,FNAM+'.biC');
        REWRITE(F);
        BlockWrite(F,MASC,I);
        CLOSE(F);


END;

//
//  LD SP,IX    ;10
//  POP HL      ;10
//  INC IX      ;10
//  INC IX      ;10
//  LD SP,HL    ;6
//
//  DEC SP      ;6
//  DEC SP      ;6
//  POP HL      ;10
//  LD SP,HL    ;6
//
//
//
//
//




PROCEDURE Covert_BMP_ToMonoBIN(FNAM:STRING;INV:BYTE);
BEGIN

        LoadBMP(FNAM);
        CovertToMonoBIN(FNAM,INV);

END;

PROCEDURE Covert_BMP_ToMonoSCR(FNAM:STRING;INV:BYTE);
BEGIN
        LoadBMP(FNAM);
        CovertToMonoSCR(FNAM,INV);
END;



BEGIN


//        S:='spitu';
//        IF ParamSTR(1)<>'' THEN S:=GetNameX(ParamSTR(1));

        Covert_BMP_ToMonoSCR('LOADING',255); //Covert_BMP_ToMonoBIN('LOADING',255);


END.


