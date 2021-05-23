USES rbBase64,rb_crc16,
     CRT,DOS,STRINGS;

VAR FNAMEORIGINAL:STRING;
    FPATH,FNAME:STRING;

CONST BLOCK_TYPES_BOOT_STATIC = 0;
      BLOCK_TYPES_BOOT_FLASH = 1;
      BLOCK_TYPES_DATA_FLASH = 2;



function FileExists(FileName : String) : Boolean;

{ Функция возвращает True, если файл существует, иначе
  возвращает False. Закрывает файл, если он существует. }

var
  F : File;
begin
 {$I-}
  Assign(F, FileName);
 Reset(F);
 Close(F);
 {$I+}
 FileExists := (IOResult = 0) and (FileName <> '');
end;  { FileExists }



PROCEDURE FileErase(FileName : String);
VAR F:FILE;
BEGIN
      IF (FileExists(FileName)) THEN BEGIN
       ASSIGN(F,FileName);
       ERASE(F);
      END;

END;

FUNCTION GetNameX (S:STRING):STRING;
VAR N,M,I:LONGINT;
BEGIN
        RESULT:=S;
        N:=Length(S);
        WHILE N<>0 DO BEGIN
         IF S[N]='.' THEN BEGIN
          RESULT:=COPY(S,1,N-1);
          EXIT;
         END;
         DEC(N);
        END;
END;





FUNCTION GetPath(FPA:STRING):STRING; CODE; ASM


        MOV ESI,FPA
        MOV EDI,@Result
        MOV EBX,EDI
        LODSB
        STOSB
        MOVZX ECX,AL
        JECXZ @M1
        PUSH ECX
        REP MOVSB
        POP ECX
@M2:
        DEC EDI
        MOV AL,[EDI]
        CMP AL,'\'
        JZ @M1
        DEC BYTE PTR [EBX]
        LOOP @M2
@M1:
        RET
END;

FUNCTION GetName(FPA:STRING):STRING; CODE; ASM

        MOV ESI,FPA
        MOV EDI,@Result
        MOV EBX,EDI

        LODSB
        STOSB
        OR AL,AL
        JZ @M0

        MOV AH,AL
        MOVZX ECX,AL
        PUSH ECX
        REP MOVSB
        POP ECX
@M1:
        DEC EDI
        CMP EDI,EBX
        JZ @M0
        MOV AL,[EDI]
        CMP AL,'\'
        JNZ @M1
        INC EDI

        MOV ESI,EDI
        MOV EDI,EBX
        MOVZX ECX,AH
        MOV EAX,ESI
        INC EBX
        SUB EAX,EBX
        SUB ECX,EAX
        MOV AL,CL
        STOSB
        JECXZ @M0
        REP MOVSB
@M0:
        RET
END;




FUNCTION Mid (S:STRING;OfseD,SizeD:DWORD):STRING; CODE; ASM

        MOV ESI,S
        MOV EDI,@Result

        LODSB

        MOV BYTE PTR [EDI],0

        MOVZX EBX,AL
        MOV EDX,OfseD
        DEC EDX
        ADD ESI,EDX
        SUB EBX,EDX
        JC @M1
        JZ @M1

        MOV AL,BL

        MOV ECX,SizeD
        SUB EBX,ECX
        JNC @M2
        MOVZX ECX,AL
@M2:
        JECXZ @M1
        MOV AL,CL
        STOSB
        REP MOVSB
        RET
@M1:
        XOR AL,AL
        STOSB

        RET

END;





FUNCTION Right(S:STRING;Co:DWORD):STRING; BEGIN
        IF Length(S)>Co THEN Delete (S,1,Length(S)-Co);
        RESULT:=S;
END;




FUNCTION GetEle (S,SF:STRING;ElN:DWORD):STRING; ASSEMBLER; ASM

         MOV ESI,S
         LODSB
         MOVZX EDX,AL
         INC DL
         MOV BYTE PTR [ESI+EDX],' '

@M3:
         CALL @FinSpace
         CMP ElN,0
         JZ @M1
         CALL @IsDelimiter
         JNC @M1
         CALL @FinSpace
         MOV EDI,ESI
         MOV DH,DL
         CALL @IsDelimiter
         MOV AL,DL
         MOV DL,DH
         MOV ESI,EDI
         CMP AL,DL
         JNZ @M2
         DEC DL
         LODSB
@M2:
         DEC ElN
         JMP @M3
@M1:
         MOV DH,DL
         MOV EDI,ESI

         CALL @IsDelimiter
         CALL @FinSpace

         MOV EAX,ESI
         SUB EAX,EDI

         MOV ESI,EDI
         MOV EDI,@Result
         PUSH EDI
         STOSB
         MOV ECX,EAX
         JECXZ @M4
         REP MOVSB
@M4:
         POP EBX
@M6:
         CMP BYTE PTR [EBX],0
         JZ @M7
         DEC EDI
         CMP BYTE PTR [EDI],' '
         JNZ @M5
         DEC BYTE PTR [EBX]
         JMP @M6
@M7:
         DEC DH
         JNZ @M5
         MOV AX,0FF01H
         MOV [EBX],AX
@M5:

         JMP @EXIT



@FinSpace:
         DEC DL
         JZ @FiSp1
         LODSB
         CMP AL,' '
         JZ @FinSpace
         DEC ESI
@FiSp1:
         INC DL
         RET 0



@IsDelimiter:
         DEC DL
         JZ @IsDe0
         LODSB

         MOV EBX,[SF]
         MOVZX ECX,BYTE PTR [EBX]
         JECXZ @IsDe3
@IsDe1:
         INC EBX
         CMP AL,[EBX]
         JZ @IsDe2
         LOOP @IsDe1
@IsDe3:
         JMP @IsDelimiter
@IsDe0:
         INC DL
         CLC
         RET 0
@IsDe2:
         DEC ESI
         INC DL
         STC
         RET 0
@EXIT:


END;





FUNCTION DetBin(S:STRING):BOOLEAN;
VAR N,M,I,O:DWORD;
    S1:STRING;
BEGIN
        DetBin:=FALSE;
        S1:=GetEle (S,'.',1);
        S:=GetEle (S,'.',0);
        IF IsDelimiter('Bb',S,Length(S)) AND IsDelimiter('01',S[1],1) THEN IF IsDelimiter('0123456789'+#255,S1,1) THEN BEGIN
         DetBin:=TRUE;
         FOR N:=1 TO Length(S)-1 DO IF NOT IsDelimiter('01',S[N],1) THEN DetBin:=FALSE;
        END;
END;

FUNCTION DetHex(S:STRING):BOOLEAN;
VAR N,M,I,O:DWORD;
    S1:STRING;
BEGIN
        DetHex:=FALSE;
        S1:=GetEle (S,'.',1);
        S:=GetEle (S,'.',0);
        IF IsDelimiter('Hh',S,Length(S)) AND IsDelimiter('0123456789',S[1],1) THEN IF IsDelimiter('0123456789'+#255,S1,1) THEN BEGIN
         DetHex:=TRUE;
         FOR N:=1 TO Length(S)-1 DO IF NOT IsDelimiter('0123456789ABCDEF',UpperCase(S[N]),1) THEN DetHex:=FALSE;
        END;
END;

FUNCTION DetVal(S:STRING):BOOLEAN;
VAR N,M,I,O:DWORD;
    S1:STRING;
BEGIN
        DetVal:=Length(S)<>0;
        FOR N:=1 TO Length(S) DO IF NOT IsDelimiter('0123456789',S[N],1) THEN DetVal:=FALSE;
        IF S='$' THEN DetVal:=TRUE;
END;

FUNCTION DetValS(S:STRING):BOOLEAN;
VAR N,M,I,O:DWORD;
BEGIN
        DetValS:=Length(S)<>0;
        FOR N:=1 TO Length(S) DO IF NOT IsDelimiter('0123456789.',S[N],1) THEN DetValS:=FALSE;
        IF S[1]='.' THEN DetValS:=FALSE;
        IF S='$' THEN DetValS:=TRUE;
END;




FUNCTION DetVar(S:STRING):BOOLEAN; BEGIN
        DetVar:=DetBin(S) OR DetHex(S) OR DetVal(S);
END;


FUNCTION DetVarS(S:STRING):BOOLEAN; BEGIN
        DetVarS:=DetBin(S) OR DetHex(S) OR DetValS(S);
END;



FUNCTION GetVar(S:STRING):LONGINT;
VAR N,M,I,O:DWORD;
BEGIN
      I:=0;
      S:=GetEle (S,'.',0);
      IF DetBin (S) THEN FOR N:=1 TO Length(S)-1 DO I:=I SHL 1 OR (BYTE(S[N])-48);
      IF DetHex (S) THEN I:=DWord(HexVal(Mid(S,1,Length(S)-1)));
      IF DetVal (S) THEN Val(S,I,N);
      GetVar:=I;
END;



FUNCTION GetVarS(S:STRING):SINGLE;
VAR N,M,I,O:DWORD;
    II:SINGLE;
    S1:STRING;
BEGIN
      I:=0;
      II:=0;
      S1:=GetEle (S,'.',1);
      S:=GetEle (S,'.',0);
      IF S1=#255 THEN S1:='0';
      IF DetBin (S) THEN FOR N:=1 TO Length(S)-1 DO I:=I SHL 1 OR (BYTE(S[N])-48);
      IF DetHex (S) THEN I:=DWord(HexVal(Mid(S,1,Length(S)-1)));
      Val('0.'+S1,II,N);
      II:=II+ROUND(I);
      IF DetValS (S) THEN IF S='$' THEN Val(S+'.'+S1,II,N);
      GetVarS:=II;
END;


FUNCTION GetVarSS(S:STRING):REAL;
VAR N,M,I,O:DWORD;
    P:LONGINT;
    II:REAL;
    S1:STRING;
BEGIN
      IF S[1]='-' THEN BEGIN
       DELETE (S,1,1);
       P:=-1;
      END ELSE P:=1;
      I:=0;
      II:=0;
      S1:=GetEle (S,'.',1);
      S:=GetEle (S,'.',0);
      IF S1=#255 THEN S1:='0';
      IF DetBin (S) THEN FOR N:=1 TO Length(S)-1 DO I:=I SHL 1 OR (BYTE(S[N])-48);
      IF DetHex (S) THEN I:=DWord(HexVal(Mid(S,1,Length(S)-1)));
      Val('0.'+S1,II,N);
      II:=II+ROUND(I);
      IF DetValS (S) THEN IF S='$' THEN Val(S+'.'+S1,II,N);
      GetVarSS:=II*P;
END;



FUNCTION GetHEX(S:STRING):DWORD;
BEGIN
      RESULT:=GetVar('0'+S+'H');
END;


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

FUNCTION FindDir(S:STRING):BOOLEAN;
VAR DirSeRe:SearchRec;
BEGIN
        FindFirst(GetPath(S)+'*.*',AnyFile,DirSeRe);
        RESULT:=DosError=0;
END;

FUNCTION FindFile(S:STRING):BOOLEAN;
VAR DirSeRe:SearchRec;
BEGIN
        FindFirst(S,AnyFile,DirSeRe);
        RESULT:=DosError=0;
END;



FUNCTION CheckFileExistWithRules(VAR ST:STRING; isFile:BOOLEAN):BOOLEAN;
VAR N,M,I,P,OI:LONGINT;
    S:STRING;
BEGIN

         RESULT:=FALSE;
         S:=ST;
         M:=0;
         N:=7;
         IF COPY(S,1,2)='?\' THEN BEGIN
          DELETE(S,1,2);
          M:=N;
         END ELSE IF COPY(S,1,3)='??\' THEN BEGIN
          isFile:=FALSE;   //FIND ONLY CATALOG
          DELETE(S,1,3);
          M:=N;
         END ELSE IF COPY(S,1,4)='???\' THEN BEGIN
          isFile:=TRUE;    //FIND ONLY FILE
          DELETE(S,1,4);
          M:=N;
         END;
         //WriteLn('FIND:',S,'...',GetPath(S));

         FOR N:=0 TO M DO BEGIN
          IF isFile THEN BEGIN
           RESULT:=FindFile(S);
          END ELSE BEGIN
           RESULT:=FindDir(GetPath(S));
          END;
          IF RESULT THEN BEGIN
           BREAK;
          END ELSE BEGIN
           S:='..\'+S;
          END;
         END;

         IF RESULT THEN BEGIN
          ST:=S;
         END;

END;


FUNCTION CheckFileExistWithRulesCOMPLEX(VAR ST:STRING; isFile:BOOLEAN):DWORD;
VAR N,M,I,O:LONGINT;
    S,S1:STRING;
BEGIN
        S:='';
        S1:='';
        I:=0;
        O:=0;
        WHILE TRUE DO BEGIN
         S1:=GetEle(ST,' ',I);
         IF (S1=#255) THEN BREAK;
         IF CheckFileExistWithRules(S1, isFile) THEN BEGIN
          INC(O);
         END;
         IF I=0 THEN BEGIN
          S:=S+S1;
         END ELSE BEGIN
          S:=S+' '+S1;
         END;
         INC(I);
        END;
        ST:=S;
        RESULT:=O;
END;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

CONST HEXBUFSIZE=1024*1024;
CONST HEXBLOCKS=256;

VAR HEXR:PACKED RECORD
     GlobalAddres:DWORD;
     GlobalAddresUpdated:BOOLEAN;
     HREC:PACKED RECORD
      SIZE:DWORD;
      ADDR:DWORD;
      TYP:BYTE;
      DATA:ARRAY[0..255] OF BYTE;
      CRC:DWORD;
     END;
     BUF:PACKED RECORD
      BLK:ARRAY[0..HEXBLOCKS-1] OF PACKED RECORD
       ADDR:DWORD;
       SIZE:DWORD;
       TYP:WORD;
       POS:DWORD;
       FREE:WORD;
      END;
      BLOCK:ARRAY[0..HEXBLOCKS-1] OF PACKED RECORD
       ADDR:DWORD;
       SIZE:DWORD;
       TYP:WORD;
      END;
      BLKNUM:DWORD;
      DATA:ARRAY[0..HEXBUFSIZE-1] OF BYTE;
      POS:DWORD;
     END;
     BLOCKTYPE:DWORD;
    END;


PROCEDURE fHEX_BUF_FINISH;
BEGIN
      IF (HEXR.BUF.BLK[HEXR.BUF.BLKNUM].SIZE<>0) THEN BEGIN

       HEXR.BUF.BLOCK[HEXR.BUF.BLKNUM].ADDR := HEXR.BUF.BLK[HEXR.BUF.BLKNUM].ADDR;
       HEXR.BUF.BLOCK[HEXR.BUF.BLKNUM].SIZE := HEXR.BUF.BLK[HEXR.BUF.BLKNUM].SIZE;
       HEXR.BUF.BLOCK[HEXR.BUF.BLKNUM].TYP := HEXR.BUF.BLK[HEXR.BUF.BLKNUM].TYP;

       INC(HEXR.BUF.BLKNUM);
       HEXR.BUF.BLK[HEXR.BUF.BLKNUM].SIZE := 0;
      END;
END;


PROCEDURE fHEX_BUF_ADD(VAR BUF; ADDR:DWORD; SIZE:DWORD);
BEGIN
        IF (SIZE<>0) THEN BEGIN
         IF ( ADDR <> (HEXR.BUF.BLK[HEXR.BUF.BLKNUM].ADDR + HEXR.BUF.BLK[HEXR.BUF.BLKNUM].SIZE) ) THEN BEGIN
          fHEX_BUF_FINISH();
         END;

         IF (HEXR.BUF.BLK[HEXR.BUF.BLKNUM].SIZE=0) THEN BEGIN
          HEXR.BUF.BLK[HEXR.BUF.BLKNUM].ADDR := ADDR;
          HEXR.BUF.BLK[HEXR.BUF.BLKNUM].POS := HEXR.BUF.POS;
          HEXR.BUF.BLK[HEXR.BUF.BLKNUM].TYP := HEXR.BLOCKTYPE;
         END;

         MOVE(BUF, HEXR.BUF.DATA[HEXR.BUF.POS], SIZE);
         INC(HEXR.BUF.POS, SIZE);
         INC(HEXR.BUF.BLK[HEXR.BUF.BLKNUM].SIZE, SIZE);
        END;
END;

FUNCTION fHEX_Cut_Str(VAR S:STRING; SIZE:BYTE):DWORD;
BEGIN
      IF SIZE>4 THEN SIZE:=4;
      RESULT:=GetHEX( COPY(S,1,SIZE) );
      DELETE(S,1,SIZE);
END;

PROCEDURE fHEX_Reset;
BEGIN
//      HEXR.GlobalAddres:=0;
      FillChar(HEXR, SizeOf(HEXR), 0);
END;


PROCEDURE SaveIncBaseFile(FILENAME:STRING; P:LONGINT; SIZE:LONGINT);
VAR M,I:LONGINT;
    B:BYTE;
    T:TEXT;
    S:STRING;
BEGIN

           ASSIGN(T,FILENAME);
           REWRITE(T);
           S:=CHAR(SIZE) + CHAR(SIZE SHR 8) + CHAR(SIZE SHR 16) + CHAR(SIZE SHR 24);
           S:=BASE64_EnCode(S);
           Write(T,'*',S);
           Write(T,#$0D);
           S:='';
           FOR I:=0 TO SIZE-1 DO BEGIN
            B:=HEXR.BUF.DATA[P];
            S:=S+CHAR(B);
            IF LENGTH(S)=48-16 THEN BEGIN
             S:=BASE64_EnCode(S);
             Write(T,'+',S);
             Write(T,#$0D);
             S:='';
            END;
            INC(P);
           END;
           IF LENGTH(S)<>0 THEN BEGIN
            S:=BASE64_EnCode(S);
            Write(T,'+',S);
            Write(T,#$0D);
            S:='';
           END;
           Write(T,'$FINISH');
           Write(T,#$0D);
           CLOSE(T);

END;

PROCEDURE SaveIncBinFile(FILENAME:STRING; P:LONGINT; SIZE:LONGINT);
VAR M,I:LONGINT;
//    P:LONGINT;
    T:TEXT;
    S:STRING;
BEGIN

           ASSIGN(T,FILENAME);
           REWRITE(T);
           //P:=HEXR.BUF.BLK[N].POS;
           M:=0;
           FOR I:=0 TO SIZE-1 DO BEGIN  //HEXR.BUF.BLK[N].SIZE
            IF I<>0 THEN BEGIN
             Write(T,',');
            END;
            IF M=15 THEN BEGIN
             M:=0;
             WriteLn(T,'');
            END;
            S:='0x'+COPY(HEX(HEXR.BUF.DATA[P]),7,2);
            Write(T,S);
            INC(M);
            INC(P);
           END;
           WriteLn(T,'');
           CLOSE(T);

END;


PROCEDURE SaveIncBinFileBLK(FILENAME:STRING; N:LONGINT);
BEGIN
        SaveIncBinFile(FILENAME, HEXR.BUF.BLK[N].POS, HEXR.BUF.BLK[N].SIZE);
END;


PROCEDURE SaveBootBinFile(FILENAME:STRING; P:LONGINT; SIZE:LONGINT);
VAR M,I:LONGINT;
    B:BYTE;
    F:FILE;
    S,FNBOOT:STRING;

    MASB:ARRAY[0..32767] OF BYTE;
BEGIN

           FNBOOT := '?\TMT\BININC\boot.bin';


           IF CheckFileExistWithRules(FNBOOT, TRUE) THEN BEGIN
            TextColor(7);
            Write('Save BinBoot: ');
            TextColor(14);
            WriteLn(FNBOOT);
            TextColor(7);

            TextColor(7);
            Write('Save BinFW: ');
            TextColor(14);
            WriteLn(FILENAME);
            TextColor(7);


            FillChar(MASB, SizeOf(MASB), $FF);
            ASSIGN(F,FNBOOT);
            RESET(F);
            BlockRead(F,MASB,FileSize(F));
            CLOSE(F);

            ASSIGN(F,FILENAME);
            REWRITE(F);
            BlockWrite(F, MASB, SizeOf(MASB));
            BlockWrite(F, HEXR.BUF.DATA[P], SIZE);
            I:=FileSize(F);
            CLOSE(F);

            TextColor(7);
            Write('FirmAll Size: ');
            TextColor(14);
            WriteLn(I);
            TextColor(7);

            TextColor(7);
            Write('FirmWare Size: ');
            TextColor(14);
            WriteLn(SIZE);
            TextColor(7);

           END ELSE BEGIN
            TextColor(7);
            Write('Not Found BinBoot: ');
            TextColor(12);
            WriteLn(FNBOOT);
            TextColor(7);
           END;

END;

PROCEDURE SaveBootBinFileBLK(FILENAME:STRING; N:LONGINT);
BEGIN
        //SaveIncBinFile(FILENAME, HEXR.BUF.BLK[N].POS, HEXR.BUF.BLK[N].SIZE);
        SaveBootBinFile(FILENAME, HEXR.BUF.BLK[N].POS, HEXR.BUF.BLK[N].SIZE);
END;



//RETURN TRUE IF END OF FILE
FUNCTION fHEX_CompileLine(S:STRING):BOOLEAN;
VAR N,M,I:LONGINT;
    AD:DWORD;
    B:BYTE;
BEGIN

        HEXR.HREC.SIZE:=0;
        HEXR.GlobalAddresUpdated:=FALSE;
        RESULT:=FALSE;
        IF ( LENGTH(S)>=9 ) THEN BEGIN
         IF (S[1]=':') THEN BEGIN
          DELETE(S,1,1);
          HEXR.HREC.SIZE:=fHEX_Cut_Str(S,2);
          HEXR.HREC.ADDR:=fHEX_Cut_Str(S,4);
          HEXR.HREC.TYP:=fHEX_Cut_Str(S,2);

          IF LENGTH(S)=(HEXR.HREC.SIZE*2+2) THEN BEGIN
           HEXR.HREC.CRC:=GetHEX( RIGHT(S,2) );
           DELETE(S,LENGTH(S)-1,2);
           //WriteLn('SI=',HEXR.HREC.SIZE,' = ',S);
           //WriteLn('AD=',HEXR.HREC.ADDR);
           //WriteLn('CR=',HEX(HEXR.HREC.CRC),' = ',S);
           CASE HEXR.HREC.TYP OF
            0:BEGIN //DATA
             AD:=HEXR.GlobalAddres+HEXR.HREC.ADDR;
             //TextColor(15);
             //Write('AD:');
             //TextColor(14);
             //Write(HEX(AD));
             //TextColor(6);
             //Write( COPY(HEX(HEXR.HREC.SIZE),7,2) );
             //TextColor(7);
             //WriteLn(S);
             FOR N:=0 TO HEXR.HREC.SIZE-1 DO BEGIN
              HEXR.HREC.DATA[N]:=fHEX_Cut_Str(S,2);
             END;
             fHEX_BUF_ADD(HEXR.HREC.DATA, AD, HEXR.HREC.SIZE);
            END;
            1:BEGIN //END OF FILE
             RESULT:=TRUE;
            END;
            2:BEGIN //EXTENDED SEGMENT ADDRESS
             HEXR.GlobalAddres:=(HEXR.HREC.ADDR) + (fHEX_Cut_Str(S,4) SHL 4);
             HEXR.GlobalAddresUpdated:=TRUE;
            END;
            4:BEGIN //EXTENDED LINEAR ADDRESS
             HEXR.GlobalAddres:=(HEXR.HREC.ADDR) OR (fHEX_Cut_Str(S,4) SHL 16);
             HEXR.GlobalAddresUpdated:=TRUE;
            END;
            5:BEGIN //START LINEAR ADDRESS
             TextColor(10);
             Write('EX:');
             TextColor(14);
             WriteLn(S);
             TextColor(7);
            END;
           END;

           IF HEXR.GlobalAddresUpdated THEN BEGIN
            TextColor(11);
            Write('PA:');
            TextColor(14);
            WriteLn(HEX(HEXR.GlobalAddres));
            TextColor(7);
           END;


          END;


         END;
        END;




END;



//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////





FUNCTION ConvertLustHEX(FNM:STRING):BOOLEAN;
VAR N,M,I,O,P:LONGINT;
    S:STRING;
    T:TEXT;
BEGIN
        RESULT:=TRUE;
        IF CheckFileExistWithRules(FNM, TRUE) THEN BEGIN
         FPATH:=GetPath(FNM);
         FNAME:=GetName(FNM);
         //FNM:=FPATH+GetNameX(FNAME);

         TextColor(7);
         Write('File Path: ');
         TextColor(14);
         WriteLn(FPATH);
         TextColor(7);
         Write('File Name: ');
         TextColor(14);
         WriteLn(FNAME);
         TextColor(7);
         Write('File Full: ');
         TextColor(14);
         WriteLn(FNM);
         TextColor(7);

         ASSIGN(T,FNM);
         RESET(T);

         WHILE NOT EOF(T) DO BEGIN
          ReadLn(T,S);
 //         WriteLn(S);
          IF fHEX_CompileLine(S) THEN BREAK;
         END;

         CLOSE(T);

         fHEX_BUF_FINISH();

        END ELSE BEGIN
         TextColor(7);
         Write('File: ');
         TextColor(14);
         Write(FNM);
         TextColor(12);
         Write(' Not Found !!!');
         TextColor(7);
         WriteLn('');
         RESULT:=FALSE;
        END;


END;






PROCEDURE CompleteBLOCK(DoSaveBlocks:BOOLEAN);
VAR N,M,I,P:LONGINT;
    PAT,FNM:STRING;
    F:FILE;
    T:TEXT;
    S:STRING;

    BLKS:ARRAY[0..HEXBLOCKS-1] OF DWORD;

BEGIN


        FOR N:=0 TO HEXBLOCKS-1 DO BEGIN
         IF N<HEXR.BUF.BLKNUM THEN BEGIN
          TextColor(7);
          Write('BLK:');
          TextColor(14);
          Write(HEX(HEXR.BUF.BLK[N].ADDR));
          TextColor(7);
          Write(',');
          TextColor(14);
          Write(HEXR.BUF.BLK[N].SIZE);
          WriteLn('');
         END;

         IF (DoSaveBlocks) THEN BEGIN
          PAT:=GetPath(ParamSTR(0));
          FNM:=COPY(HEX(N),5,4);
          IF N<HEXR.BUF.BLKNUM THEN BEGIN
           ASSIGN(T,PAT+FNM+'.INF');
           REWRITE(T);
           CASE (HEXR.BUF.BLOCK[N].TYP) OF
            BLOCK_TYPES_BOOT_STATIC:  WriteLn(T,'File Name: Boot Static');
            BLOCK_TYPES_BOOT_FLASH :  WriteLn(T,'File Name: Boot Flash');
            BLOCK_TYPES_DATA_FLASH :  WriteLn(T,'File Name: Data Flash (',FPATH,FNAME,')');
           END;
           WriteLn(T,' BLK ADDR: ',HEX(HEXR.BUF.BLOCK[N].ADDR));
           WriteLn(T,'     SIZE: ',HEX(HEXR.BUF.BLOCK[N].SIZE));
           WriteLn(T,'     TYPE: ',    HEXR.BUF.BLOCK[N].TYP);
           M:=0;
           P:=HEXR.BUF.BLK[N].POS;
           FOR I:=0 TO HEXR.BUF.BLK[N].SIZE-1 DO BEGIN
            IF M=0 THEN BEGIN
             IF I=0 THEN BEGIN
              Write  (T,' DATA: ');
             END ELSE BEGIN
              Write  (T,'       ');
             END;
            END ELSE BEGIN
             Write(T,' ');
            END;
            S:=COPY(HEX(HEXR.BUF.DATA[P]),7,2);
            Write(T,S);
            INC(P);
            INC(M);
            IF M=22 THEN BEGIN
             M:=0;
             WriteLn(T,'');
            END;
           END;
           CLOSE(T);

           SaveIncBinFileBLK(PAT+FNM+'.INC', N);

           ASSIGN(F,PAT+FNM+'.BLK');
           REWRITE(F);
           I:=SizeOf(HEXR.BUF.BLOCK[N]);
           BlockWrite(F, I, 4);
           BlockWrite(F, HEXR.BUF.BLOCK[N], I);
           I:=HEXR.BUF.BLOCK[N].SIZE;
           BlockWrite(F, I, 4);
           BlockWrite(F, HEXR.BUF.DATA[HEXR.BUF.BLK[N].POS], I);
           CLOSE(F);

          END ELSE BEGIN
           FileErase(PAT+FNM+'.BLK');
           FileErase(PAT+FNM+'.INC');
           FileErase(PAT+FNM+'.INF');
          END;

         END;


        END;


        IF (DoSaveBlocks) THEN BEGIN


//        crc16_blk_CCITT

         INC(HEXR.BUF.POS,2);

         P:=HEXR.BUF.POS;

         FOR N:=0 TO HEXR.BUF.BLKNUM-1 DO BEGIN
          I:=SizeOf(HEXR.BUF.BLOCK[N]);
//          M:=I+HEXR.BUF.BLOCK[N].SIZE;
//          BlockWrite(F, M, 4);

          BLKS[N]:=P;
          MOVE( I, HEXR.BUF.DATA[P], 4 );
          INC(P,4);
          MOVE( HEXR.BUF.BLOCK[N], HEXR.BUF.DATA[P], I );
          INC(P,I);
          I:=HEXR.BUF.BLOCK[N].SIZE;
          MOVE( I, HEXR.BUF.DATA[P], 4 );
          INC(P,4);
          MOVE( HEXR.BUF.DATA[HEXR.BUF.BLK[N].POS], HEXR.BUF.DATA[P], I );
          INC(P,I);
         END;


         M:=$FFFFFFFF;
         MOVE( M, HEXR.BUF.DATA[P], 4 );
         INC(P,4);
         FOR N:=0 TO HEXR.BUF.BLKNUM-1 DO BEGIN
          M:=P-BLKS[N];
          MOVE( M, HEXR.BUF.DATA[P], 4 );
          INC(P,4);
         END;

         ASSIGN(F,PAT+'ALL.BLK');
         REWRITE(F);
         I:=P-HEXR.BUF.POS;
         DEC(HEXR.BUF.POS,2);

         PWORD( @HEXR.BUF.DATA[HEXR.BUF.POS] )^ := crc16_blk_CCITT( HEXR.BUF.DATA[HEXR.BUF.POS+2], I );



         INC(I,2);

         BlockWrite(F, HEXR.BUF.DATA[HEXR.BUF.POS], I);
         CLOSE(F);

         SaveIncBinFile(PAT+'ALL.INC', HEXR.BUF.POS, I);
         SaveIncBaseFile(PAT+'ALL.TXT', HEXR.BUF.POS, I);

        END;

//        BASE64_EnCode(

END;



BEGIN

        FNAMEORIGINAL:='';

        IF ParamSTR(1)<>'' THEN FNAMEORIGINAL:=ParamSTR(1);

        WriteLn('HEX Converter ...');
        fHEX_Reset();

        IF FNAMEORIGINAL<>'' THEN BEGIN
         HEXR.BLOCKTYPE := BLOCK_TYPES_DATA_FLASH;
         ConvertLustHEX(FNAMEORIGINAL);
        END ELSE BEGIN
         HEXR.BLOCKTYPE := BLOCK_TYPES_DATA_FLASH;
         IF ConvertLustHEX('?\STM_AYX32_TSL_WILDFIRMWARE\OBJ\STM_AYX32_TSL_WILDFIRMWARE.hex') THEN BEGIN
          //SaveIncBinFileBLK(FPATH+GetNameX(FNAME)+'.inc', HEXR.BUF.BLKNUM-1);
          SaveBootBinFileBLK(FPATH+GetNameX(FNAME)+'.bin', HEXR.BUF.BLKNUM-1);
         END;
        END;

//        CompleteBLOCK(TRUE);

        TextColor(7);
        Write('Well Done ...');


END.
