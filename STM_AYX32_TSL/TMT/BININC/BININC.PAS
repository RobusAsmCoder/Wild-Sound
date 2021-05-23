USES CRT,DOS,STRINGS;


VAR FNAMEORIGINAL,FNAMESAVE:STRING;
    FPATH,FNAME:STRING;

    MASBIN:ARRAY[0..1024*1024] OF BYTE;
    MASSIZE:DWORD;
    SA,SB,SZ:STRING;
    MAXSZ:DWORD;


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


FUNCTION LoadBinFile(FNM:STRING):DWORD;
VAR N,M,I:LONGINT;
    F:FILE;
BEGIN
        FPATH:=GetPath(FNM);
        FNAME:=GetName(FNM);
        FNM:=FPATH+GetNameX(FNAME);

        ASSIGN(F,FPATH+FNAME);
        RESET(F);
        MASSIZE := FileSize(F);
        BlockRead(F,MASBIN,MASSIZE);
        CLOSE(F);

        RESULT:=MASSIZE;

END;


PROCEDURE SaveIncBinFile(FILENAME:STRING; VAR BUF; SIZE:LONGINT; S1:STRING; S2:STRING; MAXSZ:DWORD);
VAR M,I:LONGINT;
    P,SZZ:LONGINT;
    T:TEXT;
    S:STRING;
BEGIN
           P := DWORD(POINTER(@BUF));
           ASSIGN(T,FILENAME);
           REWRITE(T);
           //P:=HEXR.BUF.BLK[N].POS;

           IF SA<>'' THEN WriteLn(T,SA);
           SZZ:=SIZE;
           IF SZZ>MAXSZ THEN SZZ:=MAXSZ;
           M:=0;
           FOR I:=0 TO SZZ-1 DO BEGIN  //HEXR.BUF.BLK[N].SIZE
            IF I<>0 THEN BEGIN
             Write(T,',');
            END;
            IF M=15 THEN BEGIN
             M:=0;
             WriteLn(T,'');
            END;
            S:='0x'+COPY(HEX(MEM[P]),7,2);
            Write(T,S);
            INC(M);
            INC(P);
           END;
           IF SB<>'' THEN BEGIN
            WriteLn(T,' };');
            //WriteLn(T,SB);//,  'sizeof('++');');
            WriteLn(T,SB, SIZE, ';');
           END ELSE BEGIN;
            WriteLn(T,'');
           END;
           CLOSE(T);

END;



BEGIN

        FNAMEORIGINAL:='boot.bin';
        FNAMESAVE := 'boot.inc';

        IF ParamSTR(1)<>'' THEN FNAMEORIGINAL:=ParamSTR(1);
        IF ParamSTR(2)<>'' THEN FNAMESAVE:=ParamSTR(2);

        TextColor(7);
        Write('BIN Converter ... ');
        TextColor(14);
        Write(FNAMEORIGINAL);
        TextColor(7);
        WriteLn('');

        SA:='';
        SB:='';
        SZ:=ParamSTR(3);
        MAXSZ:=1024*1024;
        IF SZ[1]='!' THEN BEGIN
         DELETE(SZ,1,1);
        END;
        IF SZ<>'' THEN BEGIN
         SA:='unsigned char '+SZ+'[] = {';
         //SB:='unsigned int '+SZ+'_len = sizeof('+ParamSTR(3)+');';
         SB:='unsigned int '+SZ+'_len = ';
         MAXSZ:=32;
        END;

        LoadBinFile(FNAMEORIGINAL);
        SaveIncBinFile(FNAMESAVE, MASBIN, MASSIZE, SA,SB, MAXSZ);

{
        fHEX_Reset();

         HEXR.BLOCKTYPE := BLOCK_TYPES_BOOT_STATIC;
         ConvertLustHEX('..\..\BootFlasherMemoryStatic\OBJ\STM_BootFlasherMemoryStatic.hex');
         SaveIncBinFileBLK(FPATH+GetNameX(FNAME)+'.inc', HEXR.BUF.BLKNUM-1);

         HEXR.BLOCKTYPE := BLOCK_TYPES_BOOT_FLASH;
         ConvertLustHEX('..\..\BootFlasherMemoryFlash\OBJ\STM_BootFlasherMemoryFlash.hex');
         SaveIncBinFileBLK(FPATH+GetNameX(FNAME)+'.inc', HEXR.BUF.BLKNUM-1);

         HEXR.BLOCKTYPE := BLOCK_TYPES_BOOT_FLASH;
         ConvertLustHEX('..\..\STM_AYX32_TSL_WILDFIRMWARE\OBJ\STM_AYX32_TSL_WILDFIRMWARE.hex');
         SaveIncBinFileBLK(FPATH+GetNameX(FNAME)+'.inc', HEXR.BUF.BLKNUM-1);


        IF FNAMEORIGINAL<>'' THEN BEGIN
         HEXR.BLOCKTYPE := BLOCK_TYPES_DATA_FLASH;
         ConvertLustHEX(FNAMEORIGINAL);
        END ELSE BEGIN
         HEXR.BLOCKTYPE := BLOCK_TYPES_DATA_FLASH;
         ConvertLustHEX('..\..\STM_AYX32_TSL_WILDSOUND\OBJ\STM_AYX32_TSL_WILDSOUND.hex');
         SaveIncBinFileBLK(FPATH+GetNameX(FNAME)+'.inc', HEXR.BUF.BLKNUM-1);
        END;

        CompleteBLOCK(TRUE);
}
        TextColor(7);
        Write('Well Done ...');


END.
