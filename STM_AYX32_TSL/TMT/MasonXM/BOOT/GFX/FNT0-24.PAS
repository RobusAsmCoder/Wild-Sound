USES CRT,DOS,STRINGS;
VAR  N,M,I,O,P,L,X,XX,Y,YY:LONGINT;
     TRULKA:BOOLEAN;
     S:STRING;
     F:FILE;
     MAS:ARRAY[0..65535] OF BYTE;
     MASX,MASXX:ARRAY[0..65535] OF WORD;
     M_ALIGN:DWORD;
     M_MAX:DWORD;



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
        R:BYTE;
        G:BYTE;
        B:BYTE;
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




BEGIN

        M_ALIGN:=3;
        M_MAX:=24;
        S:='fnt1-24';
        IF ParamSTR(1)<>'' THEN S:=GetNameX(ParamSTR(1));
        IF ParamSTR(2)<>'' THEN M_ALIGN:=StrToInt(ParamSTR(2));
        IF ParamSTR(3)<>'' THEN M_MAX:=StrToInt(ParamSTR(3));
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

        FillChar(MAS,SizeOf(MAS),0);
        FillChar(MASX,SizeOf(MASX),0);
        FillChar(MASXX,SizeOf(MASXX),0);
        P:=0;
        L:=0;


{
        I:=0;
        FOR P:=0 TO 36 DO BEGIN
         FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
          FOR X:=0 TO 15 DO BEGIN
           N:=Point(X+P*16,Y);
           M:=I+(X SHR 3);
           IF N>127 THEN MAS[M]:=MAS[M] OR (1 SHL (7-(X AND 7)));
          END;
          INC (I,2);
         END;
        END;
}
        WRITELN (BMP.Info.Width);

        X:=0;
        WHILE X < BMP.Info.Width DO BEGIN
         X:=((X-1) OR 7)+1;
//          WRITELN('===X:',X,' L:',L);
         IF NOT TestX_Pix(X,8) THEN BEGIN
          BREAK;
         END;
         IF X >= BMP.Info.Width THEN BREAK;

         XX:=X;
         MASX[L]:=P;
         REPEAT
          FOR N:=0 TO 7 DO BEGIN
           FOR Y:=0 TO BMP.Info.Height-1 DO BEGIN
            IF Point(X,Y)>127 THEN MAS[P+Y]:=MAS[P+Y] OR (128 SHR N);
//            MAS[P+Y]:=Y;
           END;
           INC(X);
          END;
          INC(P,BMP.Info.Height);
          IF (NOT TestX_Pix(X-1,1)) OR (NOT TestX_Pix(X,1)) THEN BREAK;
         UNTIL FALSE;
         IF (P-MASX[L])>M_MAX THEN MASXX[L]:=$8000;
//         WRITE (X-XX,',');
         INC (L);
        END;

        WriteLn('-->',L);
        L:=((L-1) OR M_ALIGN)+1;
        WriteLn('-->',L);
        FOR N:=0 TO L-1 DO BEGIN
         INC(MASX[N],L*2);
         MASX[N]:=MASX[N] OR MASXX[N];
        END;

        WriteLn('');
        WriteLn('');
        WriteLn(L);
        WriteLn(P);

        ASSIGN (F,S+'.bin');
        REWRITE (F);
        BlockWrite(F,MASX,L*2);
        BlockWrite(F,MAS,P);
        CLOSE (F);

//        FOR N:=0 TO L-1-1 DO BEGIN
//         WriteLn(MASX[N+1]-MASX[N]);
//        END;

END.


