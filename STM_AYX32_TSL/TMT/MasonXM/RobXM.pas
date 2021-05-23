UNIT RobXM;

INTERFACE
USES STRINGS,PER;

TYPE


      ShortString = STRING;


      InsHeader=PACKED RECORD
       HeaderSize:DWORD;
       Name:ARRAY [0..21] OF CHAR;
       ID:Byte;
       NumSamples:WORD;
       SampleHeaderSize:DWORD;
       SampleUseNote:ARRAY [0..95] OF BYTE;
       PointsVolume:ARRAY [0..11] OF PACKED RECORD
        Volume:WORD;
        X:WORD;
       END;
       PointsPanning:ARRAY [0..11] OF PACKED RECORD
        Panning:WORD;
        X:WORD;
       END;
       NumVolumePoints:BYTE;
       NumPanningPoints:BYTE;
       VolumeSustain:BYTE;
       VolumeLoopStart:BYTE;
       VolumeLoopEnd:BYTE;
       PanningSustain:BYTE;
       PanningLoopStart:BYTE;
       PanningLoopEnd:BYTE;
       VolumeType:BYTE;
       PanningType:BYTE;
       VibratoType:BYTE;
       VibratoSweep:BYTE;
       VibratoDepth:BYTE;
       VolumeFadeout:WORD;
       Free:WORD;
      END;

      SmpType=PACKED RECORD    { 48 !!! }
       Length:DWORD;
       Loop:DWORD;
       LoopEnd:DWORD;
       Volume:BYTE;
       FineTune:ShortInt;
       SType:BYTE;
       Panning:BYTE;
       RelativeNote:ShortInt;
       Free:BYTE;
       Name:ARRAY [0..21] OF CHAR;
       SmpPtr:POINTER;
       FreeX:DWORD;
      END;

      InsSample=ARRAY [0..15] OF SmpType;

      InsType=PACKED RECORD
       Header:InsHeader;
       Sample:InsSample;
       Free:ARRAY [0..1023-SizeOf(InsHeader)-SizeOf(InsSample)] OF BYTE;
      END;

      XmPattern=PACKED RECORD
       HeaderSize:DWORD;
       PackType:BYTE;
       Rows:WORD;
       PackSize:WORD;
      END;


TYPE TPatData=PACKED RECORD
      Note        :BYTE;
      Ins         :BYTE;
      VolEFF      :BYTE;
      EFF         :BYTE;
      EFV         :BYTE;
      //_VOL        :BYTE;
      //FREE0       :BYTE;
      //FREE1       :BYTE;
     END;

TYPE TPatLast=PACKED RECORD
      Note         :BYTE;
      RelativeTone :BYTE;
      Ins          :BYTE;
      InsA         :BYTE;
      Vol          :LONGINT;
      EnvelopeVol  :BYTE;
      FinalVol     :BYTE;
      FinalVol_L   :BYTE;
      FinalVol_R   :BYTE;
      FinalVol_LR  :WORD;
      FinalPan     :BYTE;
      EFF          :BYTE;
      EFV          :BYTE;
      FineTune     :Shortint;
      Period       :REAL;
      Frequency    :REAL;
     END;

VAR XMCUR:RECORD
     Period     :REAL;
     Frequency  :REAL;
     LINE       :DWORD;
     LINE_LOOP  :DWORD;
     LINE_LOOPC :DWORD;
     CLINE      :DWORD;
     POS        :DWORD;
     POSC       :DWORD;
     PAT        :DWORD;
     BPM        :DWORD;
     TMP        :DWORD;
     TIK        :LONGINT;
     TIKI       :LONGINT;
     SongEND    :BOOLEAN;
     PAT_PLAYED :ARRAY[0..255] OF BYTE;
     GlobalVol  :BYTE;
     PatLPREV   :ARRAY[0..63] OF TPatLast;
     PatDPREV   :ARRAY[0..63] OF TPatData;
//     PatLAST    :ARRAY[0..63] OF TPatLast;
//     PatDATA    :ARRAY[0..63] OF TPatData;
     LineCUR    :ARRAY[0..63] OF RECORD
      Note          :BYTE;
      NoteArpeggio  :LONGINT;
      NoteO         :BYTE;
      NoteOO        :BYTE;
      PeriodO       :EXTENDED;
      FrequencyO    :EXTENDED;
      Vol           :LONGINT;
      Ins           :BYTE;
      InsA          :BYTE;
      EnvelopeVol   :BYTE;
      EFF           :BYTE;
      EFV           :BYTE;
      Period        :EXTENDED;
      Frequency     :EXTENDED;
      PeriodR       :EXTENDED;
      FrequencyR    :EXTENDED;
      RelativeTone  :LONGINT;
      PeriodPortamento  :LONGINT;
      PeriodPortamentoO :LONGINT;
      FineTune      :LONGINT;
      RelativeToneO :LONGINT;
      FineTuneO     :LONGINT;
      RelativeToneOO:LONGINT;
      FineTuneOO    :LONGINT;
      RelativePRES  :LONGINT;
      FinalVol      :BYTE;
      FinalVol_L    :BYTE;
      FinalVol_R    :BYTE;
      FinalVol_LR   :WORD;
      SmpOfs        :DWORD;
     END;
     LineDATA   :ARRAY[0..63] OF TPatData;
    END;


TYPE  TPatternRec=PACKED RECORD
       OFS    :DWORD;    //Offset To Data
       SIZE   :DWORD;    //Packed Size
       Rows   :WORD;
      END;

      TPatternsPacked=PACKED RECORD
       Size          :DWORD;  //Whole Size Of Packed Data
       TrackName     :ARRAY [0..19] OF CHAR;
       Channels      :WORD;
       TMP           :WORD;
       BPM           :WORD;
       FreqTable     :WORD;
       PatLen        :WORD;
       PatRes        :WORD;
       PatOrder      :ARRAY[0..255] OF BYTE;
       PatREC        :ARRAY[0..255] OF TPatternRec;
       PatDATA       :ARRAY[0..1024*1024*4] OF BYTE;
      END;
      PTPatternsPacked=^TPatternsPacked;


      TInstrumentRec=PACKED RECORD
       OFS           :DWORD;
       Length        :DWORD;
       Loop          :DWORD;
       LoopEnd       :DWORD;
       Volume        :BYTE;
       FineTune      :ShortInt;
       SType         :BYTE;
       Panning       :BYTE;
       RelativeNote  :ShortInt;
      END;
      TInstrumentsPacked=PACKED RECORD
       Ins           :ARRAY[0..63] OF TInstrumentRec;
       Data          :ARRAY[0..1024*1024*4] OF BYTE;
      END;
      PTInstrumentsPacked=^TInstrumentsPacked;

VAR PatternsPacked:TPatternsPacked;
VAR InstrumentsPacked:TInstrumentsPacked;



VAR ShutSample:ARRAY [0..256*4+512+256+32+256+1024+256-1] OF BYTE;

VAR Sample:ARRAY [0..1023] OF PACKED RECORD
     Ptr:Pointer;
     Size:DWORD;
    END;



    XM:PACKED RECORD

     Info:PACKED RECORD
      ID:ARRAY [0..16] OF CHAR;
      Name:ARRAY [0..19] OF CHAR;
      ID1:BYTE;
      TrackerName:ARRAY [0..19] OF CHAR;
      VerLow:BYTE;
      VerHi:BYTE;
     END;

     Header:PACKED RECORD
      HeaderSize:DWORD;
      SongLen:WORD;
      Restart:WORD;
      NumChannels:WORD;
      NumPatterns:WORD;
      NumInstruments:WORD;
      FreqTable:WORD;
      TMP:WORD;
      BPM:WORD;
      PatternOrder:ARRAY [0..255] OF BYTE;
     END;


     Pattern:ARRAY [0..255] OF XmPattern;

     Instrument:ARRAY [0..127] OF InsType;


     FNAM:ShortString;
    END;

    PatternER:ARRAY [0..256] OF PACKED RECORD
     FileOffset:DWORD;
     MemPtr:POINTER;
     MemSize:DWORD;
     Free:ARRAY [0..15-4-4-4] OF BYTE;
    END;




CONST XmPatternSize = SizeOf (XmPattern);





PROCEDURE SavePatternsPack(FName:STRING; BLKSIZE:DWORD);
FUNCTION SaveInstrumentsPack(FName:STRING; SIZM:DWORD):DWORD;
FUNCTION XM_Load(FNAM:ShortString):DWORD;
PROCEDURE XM_Save_XMTXT(FNAM:ShortString);
FUNCTION GetEle (S,SF:STRING;ElN:DWORD):ShortString;
FUNCTION XM_CopySmp(VAR PTRR;N,M:DWORD):DWORD;

PROCEDURE XM_Player_INIT;
FUNCTION XM_ChekSongEND:BOOLEAN;
FUNCTION XM_Player_STEP(DEV_FREQ:REAL):BOOLEAN;
FUNCTION XM_GetPack(VAR P:ARRAY OF BYTE):DWORD; STDCALL;



IMPLEMENTATION




VAR StrSpaceRob:CHAR:=' ';


FUNCTION IntToStrRob(Num,SIZ:LONGINT):STRING; CODE; ASM


        MOV EDI,@Result
        INC EDI

        MOV EBX,[Num]
        MOV ESI,[SIZ]
        PUSH EBP

        MOV EBP,EBX
        AND EBP,80000000H
        JZ @M9
        NEG EBX
        OR ESI,ESI
        JZ @M9
        DEC ESI
@M9:
        XOR ECX,ECX
        OR ESI,ESI
        JZ @M6
        MOV CL,10
        SUB ECX,ESI
        JNC @M6
        NEG ECX
        MOV AH,CL
        MOV AL,[StrSpaceRob]
        XOR ECX,ECX
@M8:    CALL @STOSB
        DEC AH
        JNZ @M8

//        MOV CH,AH
@M6:    XOR EAX,EAX

        MOV EDX,1000000000
        CALL @M1
        MOV EDX,100000000
        CALL @M1
        MOV EDX,10000000
        CALL @M1
        MOV EDX,1000000
        CALL @M1
        MOV EDX,100000
        CALL @M1
        MOV EDX,10000
        CALL @M1
        MOV  DX,1000
        CALL @M1
        MOV  DX,100
        CALL @M1
        MOV  DL,10
        CALL @M1
        MOV AL,BL
        CALL @M4
        POP EBP
        MOV EDI,@Result
        MOV [EDI],CH
        RET

@M1:
        XOR AL,AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
        JC @M2
        INC AL
        SUB EBX,EDX
@M2:    ADD EBX,EDX
        OR AH,AL
        JZ @M3
        OR CL,CL
        JNZ @M5
@M4:    ADD AL,'0'
        CALL @STOSB
//        INC CH
        RET 0
@M5:    DEC CL
        RET 0
@M3:    OR CL,CL
        JNZ @M5
        OR ESI,ESI
        JZ @M7
        MOV AL,[StrSpaceRob]
        CALL @STOSB
//        INC CH
@M7:    RET 0

@STOSB: OR EBP,EBP
        JNZ @STOSB1
        STOSB
        INC CH
        RET 0
@STOSB1:PUSH AX
        MOV AH,AL
        MOV AL,'-'
        STOSW
        POP AX
        INC CH
        INC CH
        XOR EBP,EBP
        RET 0



END;


FUNCTION Mid(S:ShortString; OFS,SIZ:LONGINT):ShortString;
BEGIN
      RESULT:=COPY(S,OFS,SIZ);
END;

FUNCTION GetEle (S,SF:STRING;ElN:DWORD):ShortString;
VAR N,M,I,O:DWORD;
BEGIN

        N:=1;
        IF IsDelimiter(' ',SF,1) AND NOT IsDelimiter(#9,SF,1) THEN SF:=SF+#9;
        WHILE IsDelimiter(' '+#9,S,N) DO INC (N);
        WHILE ElN<>0 DO BEGIN
         WHILE NOT IsDelimiter(SF,S,N) AND (N<=Length(S)) DO INC (N);
         WHILE IsDelimiter(' '+#9,S,N) DO INC (N);
         IF IsDelimiter(SF,S,N) THEN INC (N);
         WHILE IsDelimiter(' '+#9,S,N) DO INC (N);
         DEC (ElN);
        END;

        M:=N;
        WHILE NOT IsDelimiter(SF,S,N) AND (N<=Length(S)) DO INC (N);
        WHILE IsDelimiter(' '+#9,S,N) DO INC (N);

        O:=N-Length(S)-1;
        S:=Mid (S,M,N-M);
        WHILE IsDelimiter(' '+#9,S,Length(S)) AND (Length(S)<>0) DO DELETE(S,Length(S),1);

        IF (LENGTH(S)=0) AND (O=0) THEN S:=#255;
        GetEle:=S;

END;


FUNCTION HexB(N:DWORD):ShortString;
BEGIN
      RESULT:=IntToHex(N,2);
END;

FUNCTION Hex(N:DWORD):ShortString;
BEGIN
      RESULT:=IntToHex(N,8);
END;

FUNCTION HexW(N:DWORD):ShortString;
BEGIN
      RESULT:=IntToHex(N,4);
END;




VAR NoteFRQ:ARRAY[0..65535] OF WORD;
    FRQNote:ARRAY[0..65535] OF WORD;


PROCEDURE SetNoteFRQ;
VAR R,R1:REAL;
    N,M,I,O,P:DWORD;
    F:FILE;
BEGIN


     FOR N:=0 TO 65535 DO FRQNote[N]:=0;
     M:=0;
     FOR N:=0 TO 65535 DO BEGIN
      R1 := 10*12*16*4 - (N/256-12*2-1)*16*4;
      R1 := 8363*Pwr ( 2,((6*12*16*4 - R1) / (12*16*4)) );
      IF R1>65535 THEN R1:=65535;
      I:=Round(R1);
      NoteFRQ[N]:=I;
{
      FOR P:=M TO M+Round((I-M)/2) DO FRQNote[P]:=FRQNote[M];
      FOR P:=P TO I DO FRQNote[P]:=N;
}
      FOR P:=M TO I DO FRQNote[P]:=FRQNote[M];
      P:=N;
      IF N>32767 THEN P:=32767;
      FRQNote[I]:=P;

      M:=I;
     END;





     FOR N:=$00000 TO $000FF DO NoteFRQ[N]:=0;
     FOR N:=$0FF00 TO $0FFFF DO NoteFRQ[N]:=$0FFFF;

         Assign (F,'NoteFRQ.FRQ');
         Rewrite (F,1);
         BlockWrite (F,NoteFRQ,SizeOf (NoteFRQ) );
         Close (F);

         Assign (F,'FRQNote.FRQ');
         Rewrite (F,1);
         BlockWrite (F,FRQNote,SizeOf (FRQNote) );
         Close (F);


END;




VAR SaveSMP:DWORD=0;

PROCEDURE ConvertSmp(SPtr:POINTER); STDCALL; ASSEMBLER;
ASM
        PUSHAD
        MOV ESI,SPtr

        MOV EDI,ESI
        ADD EDI,1024
        MOV ECX,256
@M1:
        MOV EBX,[ESI]
        CALL @FindStart
        INC AH

        MOV [ESI],EBX
        STOSW
        ADD ESI,4

        LOOP @M1


        ADD EDI,256
        MOV ESI,EDI
        XOR EDX,EDX
@M2:
        MOV EBX,[ESI+16+8]
        CALL @FindStart
        MOV [ESI+6],EBX
        MOV [ESI+12],AX

        MOV EBX,[ESI+16+12]
        CALL @FindStart
        MOV [ESI+2],EBX
        MOV [ESI+10],AX

        MOV BL,[ESI+16+7]
        MOV [ESI+14],BL

        MOVZX EAX,WORD PTR [ESI+16]
        MOV [ESI+16+00],EDX
        MOV [ESI+16+04],EDX
        MOV [ESI+16+08],EDX
        MOV [ESI+16+12],EDX
        MOV [ESI],AX
        ADD EAX,32+256+256
        ADD ESI,EAX

        TEST BL,00001000B
        JZ @M2

        JMP @EXIT


@FindStart:
        PUSH DX
        XOR DL,DL
        XOR AX,AX
@FiS1:
        INC AX
        DEC EBX
        CMP [EBX],DL
        JNZ @FiS1
        DEC AX
        INC EBX
        POP DX
        DEC BH
        RET 0
@EXIT:
        POPAD

END;








PROCEDURE ClearSmp;
VAR N,M:DWORD;
BEGIN
        N:=SizeOf(ShutSample);
        ASM
         PUSHAD
         MOV EDI,OFFSET ShutSample
         XOR AL,AL
         MOV ECX,N
         REP STOSB

         MOV EDI,OFFSET ShutSample
         MOV EAX,EDI
         ADD EAX,1024+512+256+32+256
         MOV ECX,256
         REP STOSD

         ADD EDI,512+256
         PUSH AX

         MOV AX,1024
         MOV ECX,16
         REP STOSB

         STOSW

         STOSB
         STOSB
         STOSB
         STOSB
         STOSB

         MOV AL,00001100B
         STOSB
         POP AX
         PUSH EAX
         ADD EAX,1023
         STOSD
         POP EAX
         STOSD

         ADD EDI,256
         MOV EAX,80808080H
         MOV ECX,1024/4
         REP STOSD

         PUSH OFFSET ShutSample
         CALL ConvertSmp
         POPAD
        END;


{
        Assign (F,HEX(SaveSMP)+'.   ');
        Re//Write (F);
        Block//Write (F,ShutSample,N);
        Close (F);
        INC (SaveSMP);
}


END;










FUNCTION LoadSampleData(SName:STRING; VAR _SSeek,_SSize,_SLoop,_SEnd:DWORD; VAR _SType:BYTE; SCONV:BYTE):POINTER;
VAR F:FILE;
    P,P1:POINTER;
    N,M,I,O:DWORD;
    GM,DecrunchSize:DWORD;
    SSeek,SSize,SLoop,SEnd:DWORD;
    SType:BYTE;
CONST SmpBlockSize=65536-256*4;
BEGIN
       SSeek   := _SSeek;
       SSize   := _SSize;
       SLoop   := _SLoop;
       SEnd    := _SEnd;
       SType   := _SType;

       IF SSize>0 THEN BEGIN

        Assign (F,SName);
        Reset (F,1);
        Seek (F,SSeek);
         O:=ROUND (INT (SSize/SmpBlockSize));
         GM:=SSize*2;
         GetMem (P,GM);
         P1:=POINTER(DWORD(P)+SSize);

         BlockRead (F,P1^,SSize);
        Close (F);
        INC(SSeek,SSize);

        //Convert From XI format
        IF (SCONV AND 1)<>0 THEN ASM
          PUSHAD
          MOV EBX,P1
          MOV EDI,P1
          XOR AL,AL
          MOV ECX,SSize
@M1:      ADD AL,[EBX]
          INC EBX
          STOSB
          LOOP @M1
          POPAD
         END;




        //16-BIT SAMPLE TO 8 BIT
        IF (SType AND 16)<>0 THEN ASM
         PUSHAD
         MOV ESI,P1
         MOV EDI,ESI
         SHR SSize,1
         MOV ECX,SSize
@M1:     LODSW
         MOV AL,AH
         STOSB
         LOOP @M1
         SHR SLoop,1
         SHR SEnd,1
         POPAD
        END;


        //Sign Polarity
        IF (SCONV AND 2)<>0 THEN ASM
          PUSHAD
          MOV EBX,P1
          MOV ECX,SSize
@M1:      XOR BYTE PTR [EBX],128
          INC EBX
          LOOP @M1
          POPAD
        END;

        ASM
          PUSHAD
          MOV ESI,P1
          MOV EDI,ESI
          MOV ECX,SSize
@M1:      LODSB
          OR AL,AL
          JNZ @M2
          INC AL
@M2:      STOSB
          LOOP @M1
          POPAD
        END;

        CASE SType AND 3 OF
         //No loop
         0,3:BEGIN
          SLoop:=SSize;
          SEnd :=0;
         END;
         //Forward loop
         1:BEGIN
         END;
         //Ping-pong loop
         2:ASM
          PUSHAD
          MOV ESI,P1
          MOV EDI,P
          MOV ECX,SLoop
          ADD ECX,SEnd

          MOV EDX,SSize
          SUB EDX,ECX

          REP MOVSB


          MOV EBX,EDI
          MOV ECX,SEnd
          JECXZ @M1
          DEC ECX
          JECXZ @M1
          INC SLoop
          ADD SSize,ECX
          DEC EBX
@M2:      DEC EBX
          MOV AL,[EBX]
          STOSB
          LOOP @M2

//          MOV ECX,EDX
//          JECXZ @M3
//          REP MOVSB
//@M3:

@M1:      MOV EAX,P
          SUB EDI,EAX
          MOV SSize,EDI
          MOV EAX,P
          MOV P1,EAX
          POPAD
         END;

        END;



{
        Assign (F,HEX(SaveSMP)+'.smp');
        Re//Write (F);
        Block//Write (F,P1^,SSize);
        Close (F);
}
{
       ASM
        PUSHAD
        MOV ESI,P1
        MOV EDI,ESI
        MOV ECX,SSize
@M1:
        LODSB
        OR AL,AL
        JNZ @M2
        INC AL
@M2:
        STOSB
        LOOP @M1


        MOV EAX,SSize
        CMP EAX,SLoop
        JNZ @M2x1
        INC EAX
        MOV SLoop,EAX
@M2x1:
        CMP SEnd,0
        JNZ @M2x2
        INC SEnd
@M2x2:

        MOV EAX,SLoop
        ADD SEnd,EAX


        MOV DecrunchSize,0
        MOV EDI,P
        MOV ECX,256+256/4+512/4
        XOR EAX,EAX
        REP STOSD

        MOV ESI,P1
        XOR EBX,EBX
        XOR EDX,EDX
        JMP @M8
@M5:

        CMP N,SmpBlockSize
        JZ @M3x1
        CMP EBX,SSize
        JZ @M3x1
        CMP EBX,SLoop
        JZ @M3x1
        CMP EBX,SEnd
        JNZ @M3
@M3x1:
        XOR EAX,EAX
        MOV ECX,256/4
        REP STOSD
@M8:
        MOV N,0
        MOV EAX,EDI
        ADD EAX,256+32
        OR EBX,EBX
        JZ @M7
        CMP EBX,SEnd
        JNZ @M7x1

        MOV AL,SType
        SHR AL,2
        AND AL,00000011B
        CMP AL,2
        JNZ @M7x3
        MOV EAX,EDI
        SUB EAX,257
        OR BYTE PTR [EDX-256-8-1],00000001B
        JMP @M7x2
@M7x3:
        PUSH EDX
        MOV EDX,DecrunchSize
        MOV EAX,EDI
        SUB EAX,257
        MOV [EDX-256-8],EAX
        POP EDX
        MOV EAX,DecrunchSize
        JMP @M7x2
@M7x1:
        CMP EBX,SSize
        JNZ @M7x2
        MOV EAX,EDI
        SUB EAX,257
@M7x2:
        MOV [EDX-256-4],EAX
        MOV EAX,EDI
        SUB EAX,EDX
        DEC AH
        MOV [EDX-256-16],AX
@M7:
        CMP EBX,SSize
        JZ @M3

        XOR EAX,EAX
        STOSD
        STOSD
        STOSD
        STOSD

        XOR EAX,EAX
        STOSD
        TEST EBX,-1
        JNZ @M7xxxx1
        MOV EAX,00000100B SHL 24
@M7xxxx1:
        STOSD

        MOV AL,SType
        SHR AL,2
        AND AL,00000011B
        CMP AL,2
        PUSHFD
        MOV EAX,EDI
        SUB EAX,256+9+16
        POPFD
        JNZ @M7x1x2
        CMP EBX,SLoop
        JNZ @M7x1x2
        OR BYTE PTR [EDI-1],00000010B
        JMP @M7x1x3
@M7x1x2:
        OR EBX,EBX
        JNZ @M7x1x1
@M7x1x3:
        MOV EAX,EDI
        ADD EAX,256+8
@M7x1x1:

        STOSD
        XOR EAX,EAX
        STOSD


        MOV ECX,256/4
        XOR EAX,EAX
        REP STOSD
        MOV EDX,EDI
@M3:

        TEST EBX,0FFFF0000H
        JNZ @M4
        OR BL,BL
        JNZ @M4
        PUSH EBX
        MOVZX EAX,BH
        MOV EBX,P
        MOV [EBX+EAX*4],EDI
        POP EBX
@M4:
        CMP EBX,SLoop
        JNZ @M9
        MOV DecrunchSize,EDI
@M9:
        CMP EBX,SSize
        JZ @M6
        MOVSB

        INC EBX
        INC N

        JMP @M5
@M6:
        OR BYTE PTR [EDX-256-8-1],00001000B

        MOV EBX,P
        MOV EAX,EDI
        SUB EAX,257
        MOV ECX,256
@M10:
        CMP DWORD PTR [EBX],0
        JNZ @M10x1
        MOV [EBX],EAX
@M10x1:
        ADD EBX,4
        LOOP @M10


        MOV EAX,GM
        MOV [EBX+512],EAX

        SUB EDI,P
        MOV DecrunchSize,EDI

        PUSH P
        CALL ConvertSmp
        POPAD

       END;
       RESULT:=P;
}
       RESULT:=P1;

{
       TextColor (15);
       //WriteLn ('');
       //WriteLn ('Size ........ ',HEX (SSize));
       //WriteLn ('Loop ........ ',HEX (SLoop));
       //WriteLn ('End ......... ',HEX (SEnd));
       //WriteLn ('DecrunchSize  ',DecrunchSize,' OF ',GM);
       TextColor (7);
}



{
        Assign (F,HEX(SaveSMP)+'.   ');
        Re//Write (F);
        Block//Write (F,P^,DecrunchSize);
        Close (F);

        INC (SaveSMP);
}

        IF (SLoop+SEnd)>SSize THEN BEGIN
         SEnd:=SSize-SLoop;
        END;
        SEnd:=SLoop+SEnd;
       END;// ELSE RESULT:=@ShutSample;;


       _SSeek   := SSeek;
       _SSize   := SSize;
       _SLoop   := SLoop;
       _SEnd    := SEnd;
       _SType   := SType;

END;












FUNCTION GetPatternsMemorySize:DWORD;
VAR N,M,I,O,P:DWORD;
BEGIN

        I:=0;
        FOR N:=$0 TO 255 DO BEGIN
         P:=0;
         M:=1;
         While (M<=XM.Header.SongLen) DO BEGIN
          IF XM.Header.PatternOrder[M-1]=N THEN P:=XM.Pattern[N].Rows;
          INC (M);
         END;
         IF P>0 THEN INC (I,P*XM.Header.NumChannels*SizeOF(TPatData)+512*0);
        END;
        GetPatternsMemorySize:=I;

END;




//////////////////////////////////////////////////////////////////////////////


FUNCTION SaveInstrumentsPack(FName:STRING; SIZM:DWORD):DWORD;
VAR N,M,I,O,OO,P,SI,BLCNT:LONGINT;
    S:STRING;
    F:FILE;
BEGIN
         BLCNT:=0;
         Assign(F,FName);
         Rewrite(F,1);
         O:=0;
         FillChar(InstrumentsPacked, SizeOf(InstrumentsPacked), 0);
         I:=XM.Header.NumInstruments;
         OO:=DWORD(@PTInstrumentsPacked(0)^.Ins[I]);
         FOR N:=0 TO I-1 DO BEGIN
          IF (XM.Instrument[N].Header.NumSamples<>0) THEN BEGIN
           M:=0;
           SI:=XM_CopySmp(InstrumentsPacked.Data[O], N, M);
           InstrumentsPacked.Ins[N].OFS          := O+OO;
           InstrumentsPacked.Ins[N].Length       := XM.Instrument[N].Sample[M].Length;
           InstrumentsPacked.Ins[N].Loop         := XM.Instrument[N].Sample[M].Loop;
           InstrumentsPacked.Ins[N].LoopEnd      := XM.Instrument[N].Sample[M].LoopEnd;
           InstrumentsPacked.Ins[N].Volume       := XM.Instrument[N].Sample[M].Volume;
           InstrumentsPacked.Ins[N].FineTune     := XM.Instrument[N].Sample[M].FineTune;
           InstrumentsPacked.Ins[N].SType        := XM.Instrument[N].Sample[M].SType;
           InstrumentsPacked.Ins[N].Panning      := XM.Instrument[N].Sample[M].Panning;
           InstrumentsPacked.Ins[N].RelativeNote := XM.Instrument[N].Sample[M].RelativeNote;
           INC(O,SI);
          END;
         END;

         BlockWrite(F, InstrumentsPacked.Ins, OO);
         BlockWrite(F, InstrumentsPacked.Data, O);

         Close(F);

         Assign(F,FName+'00');
         Rewrite(F,1);
         BlockWrite(F, InstrumentsPacked.Ins, OO);
         Close(F);
         INC(BLCNT);
         N:=O;
         M:=0;
         WHILE (N<>0) DO BEGIN
          SI:=SIZM;
          IF SI>N THEN SI:=N;

          StrSpaceRob:='0';
          S:=FName+IntToStrRob(BLCNT,2);

          //WriteLn(S);
          Assign(F,S);
          Rewrite(F,1);
          BlockWrite(F, InstrumentsPacked.Data[M], SI);
          Close(F);

          INC(M,SI);
          DEC(N,SI);
          INC(BLCNT);
         END;



         RESULT:=BLCNT;

END;
//////////////////////////////////////////////////////////////////////////////

FUNCTION PatternsPackChangeOFS(O:LONGINT):DWORD;
VAR N,M,I:LONGINT;
BEGIN
         I:=0;
         FOR N:=0 TO 255 DO BEGIN
          IF (PatternsPacked.PatREC[N].SIZE<>0) THEN BEGIN
           I:=N+1;
           INC(PatternsPacked.PatREC[N].OFS,O);
          END;
         END;
         RESULT:=I;
END;

TYPE TSaveAutoBlock=PACKED RECORD
      F         :FILE;
      FName     :STRING;
      BLKSIZE   :DWORD;
      BLKPOS    :DWORD;
      BLKCNT    :DWORD;
      MODE      :DWORD;
      ACCUMSIZE :DWORD;
     END;

VAR SAOTSTR:TSaveAutoBlock;



PROCEDURE SaveAutoStart(FName:STRING; BLKSIZE:DWORD; MODE:DWORD);
BEGIN
      SAOTSTR.FName := FName;
      SAOTSTR.BLKSIZE := BLKSIZE;
      SAOTSTR.BLKPOS := 0;
      SAOTSTR.BLKCNT := 0;
      SAOTSTR.ACCUMSIZE := 0;
      SAOTSTR.MODE := MODE;
END;

PROCEDURE SaveAutoFlush;
BEGIN
         IF SAOTSTR.BLKPOS<>0 THEN BEGIN
          CLOSE(SAOTSTR.F);
          SAOTSTR.BLKPOS:=0;
          INC(SAOTSTR.BLKCNT);
         END;
END;

PROCEDURE SaveAutoFinish;
VAR S:STRING;
BEGIN
         SaveAutoFlush();
          StrSpaceRob:='0';
          S:=SAOTSTR.FName+IntToStrRob(0,2);
          Assign(SAOTSTR.F,S);
          Append(SAOTSTR.F);
          Seek(SAOTSTR.F,0);
          BlockWrite(SAOTSTR.F, SAOTSTR.ACCUMSIZE, 4);
          CLOSE(SAOTSTR.F);
END;

PROCEDURE SaveAutoBlock(VAR F:FILE; VAR BUF; BSIZE:DWORD);
VAR N,M,I,O,P:LONGINT;
    SIZ,MSIZE:DWORD;
    S:STRING;
BEGIN
        IF @F<>NIL THEN BEGIN
         BlockWrite(F, BUF, BSIZE);
        END;

        P:=0;
        WHILE BSIZE<>0 DO BEGIN
         IF SAOTSTR.BLKPOS=0 THEN BEGIN
          StrSpaceRob:='0';
          S:=SAOTSTR.FName+IntToStrRob(SAOTSTR.BLKCNT,2);
          Assign(SAOTSTR.F,S);
          Rewrite(SAOTSTR.F,1);
          IF (SAOTSTR.BLKCNT=0) AND (SAOTSTR.MODE=1) THEN BEGIN
           BlockWrite(SAOTSTR.F, P, 4);
           INC(SAOTSTR.BLKPOS,4);
          END;
         END;

         SIZ:=BSIZE;
         MSIZE:=SAOTSTR.BLKSIZE-SAOTSTR.BLKPOS;
         IF SIZ>MSIZE THEN SIZ:=MSIZE;
         //WriteLn(SIZ,' C:',SAOTSTR.BLKCNT);

         BlockWrite(SAOTSTR.F, PBYTE(DWORD(@BUF)+P)^, SIZ);

         IF SAOTSTR.BLKPOS>=SAOTSTR.BLKSIZE THEN BEGIN
          SaveAutoFlush();
         END;

         DEC(BSIZE, SIZ);
         INC(P, SIZ);
         INC(SAOTSTR.BLKPOS, SIZ);
         INC(SAOTSTR.ACCUMSIZE, SIZ);
        END;



END;


PROCEDURE SavePatternsPack(FName:STRING; BLKSIZE:DWORD);
VAR N,M,I,O,P:LONGINT;
    F,FB:FILE;
BEGIN
         SaveAutoStart(FName, BLKSIZE, 1);
         //FB:=NIL;
         Assign(F,FName);
         Rewrite(F,1);
         I:=PatternsPackChangeOFS(0);
         O:=DWORD(@PTPatternsPacked(0)^.PatREC[I]);
         PatternsPackChangeOFS( O);
         SaveAutoBlock(F,PatternsPacked, O);
         PatternsPackChangeOFS(-O);
         //WriteLn(DWORD(@PTPatternsPacked(0)^.PatREC));
         SaveAutoBlock(F,PatternsPacked.PatDATA,PatternsPacked.SIZE);
         Close(F);

         SaveAutoFinish();

END;


//////////////////////////////////////////////////////////////////////////////

PROCEDURE LoadPatterns(FName:STRING);
VAR N,NN,M,I,O,P,PX:DWORD;
    B,BB:BYTE;
    PatP:DWORD;
    PLP,PLPx:POINTER;
    F:FILE;
//    FF:FILE;
    //BUFR:ARRAY[0..65535] OF BYTE;
BEGIN

//        WriteLn('All Pattern Size: ',GetPatternsMemorySize());

        FillChar(PatternsPacked, SizeOf(PatternsPacked), 0);

        PatternsPacked.TrackName := XM.Info.Name;
        PatternsPacked.Channels  := XM.Header.NumChannels;
        PatternsPacked.TMP       := XM.Header.TMP;
        PatternsPacked.BPM       := XM.Header.BPM;
        PatternsPacked.PatOrder  := XM.Header.PatternOrder;
        PatternsPacked.PatLen    := XM.Header.SongLen;
        PatternsPacked.PatRes    := XM.Header.Restart;
        PatternsPacked.FreqTable := XM.Header.FreqTable;


        IF GetPatternsMemorySize()>0 THEN BEGIN
         GetMem(PatternER[256].MemPtr,GetPatternsMemorySize());
         PatP:=0;

         Assign (F,FName);
         Reset (F,1);
         FOR N:=0 TO 255 DO BEGIN
          P:=0;
          M:=1;
          WHILE (M<=XM.Header.SongLen) DO BEGIN
           IF XM.Header.PatternOrder[M-1]=N THEN P:=XM.Pattern[N].Rows;
           INC (M);
          END;

          IF P>0 THEN BEGIN
           SEEK (F,PatternER[N].FileOffset);

           O:=P*XM.Header.NumChannels*SizeOF(TPatData)+512*0;    //P = ROWS
           PX:=P*XM.Header.NumChannels;
           PatternER[N].MemPtr:=POINTER(DWORD(PatternER[256].MemPtr)+PatP);
           PatternER[N].MemSize:=O;
           I:=XM.Pattern[N].PackSize;           // PACKED SIZE = I
           PLPx:=PatternER[N].MemPtr;           // UNPACK TO
           PLP:=POINTER(@PatternsPacked.PatDATA[PatternsPacked.SIZE]);//POINTER(@BUFR);//POINTER(DWORD(PLPx)+O-I);       // PACKED DATA
           PatternsPacked.PatREC[N].Rows := XM.Pattern[N].Rows;
           PatternsPacked.PatREC[N].OFS := PatternsPacked.SIZE;
           PatternsPacked.PatREC[N].SIZE := I;

           BlockRead (F,PLP^, I);  //XM.Pattern[N].PackSize);

           FillChar(PLPx^, O, 0);

           FOR M:=0 TO PX-1 DO BEGIN
            B:=PByte(PLP)^;
            INC(PLP);
            IF (B AND 128)=0 THEN BEGIN
             PByte(PLPx+0)^:=B;
             PDword(PLPx+1)^:=PDword(PLP)^;
             INC(PLP,4);
            END ELSE BEGIN
             FOR NN:=0 TO 4 DO BEGIN
              IF (B AND 1)<>0 THEN BEGIN
               PByte(PLPx+NN)^:=PByte(PLP)^;
               INC(PLP);
              END;
              B:=B SHR 1;
             END;
            END;
            INC(PLPx,SizeOF(TPatData));
           END;


           INC(PatternsPacked.SIZE, I);
           INC(PatP,O);
          END;

         END;

         Close (F);


         //Assign (F,'Pattern.pak');
         //Rewrite (F,1);
         //BlockWrite (F,PatternsPacked.PatDATA,PatternsPacked.SIZE);
         //Close (F);

         //Assign (F,'Pattern.dat');
         //Rewrite (F,1);
         //BlockWrite (F,PatternER[256].MemPtr^,PatP);
         //Close (F);

         //Assign (F,'Pattern.pat');
         //Rewrite (F,1);
         //BlockWrite (F,PatternER,SizeOf(PatternER));
         //Close (F);

         //WriteLn(XM.FNAM);

        END;
END;






FUNCTION XM_Load(FNAM:ShortString):DWORD;
VAR N,M,I,O,P:LONGINT;
    PtrRD:DWORD;
    F:FILE;
BEGIN
        ClearSmp();
        XM.FNAM:=FNAM;
        Assign (F,FNAM);
         Reset (F,1);
         //WriteLn ('File Size ................ ',FileSize(F));

         BlockRead (F,XM.Info,SizeOf (XM.Info));

//         WriteLn ('XM.ID .................... ',XM.Info.ID);
         WriteLn ('XM.ModuleName ............ ',XM.Info.Name);
//         WriteLn ('XM.TrackerName ........... ',XM.Info.TrackerName);
//         WriteLn ('XM.ID1 ................... ',HexB (XM.Info.ID1));
//         WriteLn ('XM.Ver ................... ',XM.Info.VerHi,'.',XM.Info.VerLow);

         //WriteLn ('');
         PtrRD:=FilePos(F);
         //WriteLn ('.',Hex(PtrRD));
         BlockRead (F,XM.Header,SizeOf (XM.Header));
         //WriteLn ('');

//         WriteLn ('XM.HeaderSize ............ ',XM.Header.HeaderSize,' OF ',SizeOf (XM.Header));
         WriteLn ('XM.SongLen ............... ',XM.Header.SongLen);
         WriteLn ('XM.Restart ............... ',XM.Header.Restart);
         WriteLn ('XM.NumChannels ........... ',XM.Header.NumChannels);
         WriteLn ('XM.NumPatterns ........... ',XM.Header.NumPatterns);
         WriteLn ('XM.NumInstruments ........ ',XM.Header.NumInstruments);
//         WriteLn ('XM.FreqTable ............. ',XM.Header.FreqTable);
         WriteLn ('XM.TMP ................... ',XM.Header.TMP);
         WriteLn ('XM.BPM ................... ',XM.Header.BPM);

//         WriteLn ('');
         Write ('PatternOrder .. ');
         FOR N:=1 TO XM.Header.SongLen DO BEGIN
          IF N<>1 THEN Write (',');
          Write ('0',HexB(XM.Header.PatternOrder[N-1]));
         END;
         WriteLn ('');

         INC (PtrRD,XM.Header.HeaderSize);
         Seek (F,PtrRD);

         //WriteLn ('');
         //WriteLn ('.',Hex(PtrRD));
         //WriteLn ('');






         N:=0;
         While N<XM.Header.NumPatterns DO BEGIN

          BlockRead (F,XM.Pattern[N],SizeOf (XM.Pattern[0]));

          IF N<>0 THEN //Write (' ');
          //Write (HexB(N));
          //Write (':');

          M:=1;
          While (M<=XM.Header.SongLen) DO BEGIN
//           IF XM.Header.PatternOrder[M-1]=N THEN TextColor (14);
           INC (M);
          END;
          //Write (HexW(XM.Pattern[N].PackSize));

          IF XM.Pattern[N].PackSize<>0 THEN PatternER[N].FileOffset:=PtrRD+XM.Pattern[N].HeaderSize;
          INC (PtrRD,XM.Pattern[N].HeaderSize+XM.Pattern[N].PackSize);
          Seek (F,PtrRD);

          INC (N);
         END;


         LoadPatterns(FNAM);


         //WriteLn ('');

         //WriteLn ('');
         //WriteLn ('.',Hex(PtrRD));
         //WriteLn ('');







         //WriteLn ('Loading Samples:');
         N:=0;
         While N<XM.Header.NumInstruments DO BEGIN

          BlockRead (F,XM.Instrument[N].Header,SizeOf(XM.Instrument[0].Header));
          INC (PtrRD,XM.Instrument[N].Header.HeaderSize);
          Seek (F,PtrRD);
{
          IF XM.Instrument[N].Header.NumSamples=0 THEN TextColor (7) ELSE TextColor (15);
          //Write (HexB(N));
          TextColor (7);
          //Write (' <');
          IF XM.Instrument[N].Header.NumSamples=0 THEN TextColor (3) ELSE TextColor (11);
          //Write (HexB(XM.Instrument[N].Header.NumSamples));
          TextColor (7);
          //Write ('> ');
          TextColor (14);
          //Write (XM.Instrument[N].Header.Name);
          //WriteLn ('');
}

          //Write (N/(XM.Header.NumInstruments-0.9)*100:3:0,'%');

          M:=0;
          While M<XM.Instrument[N].Header.NumSamples DO BEGIN
           BlockRead (F,XM.Instrument[N].Sample[M],XM.Instrument[N].Header.SampleHeaderSize);
           INC (M);
          END;

          INC (PtrRD,XM.Instrument[N].Header.NumSamples*XM.Instrument[N].Header.SampleHeaderSize);
          M:=0;
          While M<XM.Instrument[N].Header.NumSamples DO BEGIN
           XM.Instrument[N].Sample[M].SmpPtr:=LoadSampleData(FNAM,PtrRD,
                          XM.Instrument[N].Sample[M].Length,
                          XM.Instrument[N].Sample[M].Loop,
                          XM.Instrument[N].Sample[M].LoopEnd,
//                          3 OR (XM.Instrument[N].Sample[M].SType SHL 2));
                          XM.Instrument[N].Sample[M].SType, 3);

{           //WriteLn (' ..... ',DWord (P) );}
//           INC (PtrRD,XM.Instrument[N].Sample[M].Length);
           INC (M);
          END;
          Seek (F,PtrRD);



          INC (N);
         END;

         //WriteLn ('');
         //WriteLn ('');
         //WriteLn ('.',Hex(PtrRD));
         //WriteLn ('');



        Close (F);



END;




FUNCTION GetFName(S:STRING):STRING;
VAR N,M,I,O:LONGINT;
BEGIN
      N:=Length(S);
      RESULT:=S;
      WHILE N>0 DO BEGIN
       IF S[N]='.' THEN BEGIN
        DELETE(RESULT,N,Length(S)-N+1);
        EXIT;
       END;
       DEC(N);
      END;
END;

FUNCTION GetFNameX(S:STRING):STRING;
VAR N,M,I,O:LONGINT;
BEGIN
      RESULT:=GetFName(S);

      FOR N:=LENGTH(RESULT) DOWNTO 1 DO IF (S[N]='\') OR (S[N]='/') THEN BEGIN
       DELETE (RESULT,1,N);
       BREAK;
      END;


END;

FUNCTION GetFExt(S:STRING):STRING;
VAR N,M,I,O:LONGINT;
BEGIN
      N:=Length(S);
      WHILE N>0 DO BEGIN
       IF S[N]='.' THEN BEGIN
        RESULT:=S;
        DELETE(RESULT,1,N);
        EXIT;
       END;
       DEC(N);
      END;
      RESULT:='';
END;

FUNCTION GetDirELE(S:STRING;NU:LONGINT):STRING;
VAR N,M,I,O:LONGINT;
BEGIN

    RESULT:='';
    N:=1;
    WHILE (NU>0) AND (N<=LENGTH(S)) DO BEGIN
     CASE S[N] OF
       '/','\':DEC(NU);
     END;
     INC(N);
    END;
    WHILE N<=LENGTH(S) DO BEGIN
     RESULT:=RESULT+S[N];
     CASE S[N] OF
       '/','\':BREAK;
     END;
     INC(N);
    END;


END;



FUNCTION XM_CopySmp(VAR PTRR;N,M:DWORD):DWORD;
BEGIN
      RESULT:=XM.Instrument[N].Sample[M].Length;
      MOVE (XM.Instrument[N].Sample[M].SmpPtr^, PTRR, RESULT );
END;


PROCEDURE XM_Save_XMTXT(FNAM:ShortString);
VAR N,M,I,O,A,B,C:LONGINT;
    S,S1,S2:ShortString;
    F:FILE;
    T:TEXT;
    P:POINTER;
    PP:POINTER;
BEGIN


     IF XM.FNAM<>'' THEN BEGIN
      Assign(T,FNAM);
      ReWrite(T);

//         LogAdd(IntToStr(XM.Header.NumInstruments));
         N:=0;
         While N<XM.Header.NumInstruments DO BEGIN
          M:=0;
          While M<XM.Instrument[N].Header.NumSamples DO BEGIN
//           XM.Instrument[N].Sample[M].SmpPtr:=LoadSampleData(FNAM,PtrRD,
            S:=XM.FNAM+'S'+IntToHex(N+1,2)+IntToHex(M,2);

            WriteLn(T,'S['+IntToHex(N+1,2)+','+IntToHex(M,2)+'] "',GetFNameX(S)+'.'+GetFExt(S),'"');
            WriteLn(T,' S.Length ......... ',IntToHex(XM.Instrument[N].Sample[M].Length,8) );
            WriteLn(T,' S.Loop ........... ',IntToHex(XM.Instrument[N].Sample[M].Loop,8) );
            WriteLn(T,' S.LoopEnd ........ ',IntToHex(XM.Instrument[N].Sample[M].LoopEnd,8) );
            WriteLn(T,' S.Volume ......... ',IntToHex(XM.Instrument[N].Sample[M].Volume,2) );
            WriteLn(T,' S.FineTune ....... ',IntToHex(XM.Instrument[N].Sample[M].FineTune,2) );
            WriteLn(T,' S.SType .......... ',IntToHex(XM.Instrument[N].Sample[M].SType,2) );
            WriteLn(T,' S.Panning ........ ',IntToHex(XM.Instrument[N].Sample[M].Panning,2) );
            WriteLn(T,' S.RelativeNote ... ',IntToHex(XM.Instrument[N].Sample[M].RelativeNote,2) );
            WriteLn(T,' S.Name ........... ',XM.Instrument[N].Sample[M].Name );
//       Name:ARRAY [0..21] OF CHAR;
//       SmpPtr:POINTER;
//       FreeX:DWORD;

            A:=0;
            B:=XM.Instrument[N].Sample[M].Length;
            P:=XM.Instrument[N].Sample[M].SmpPtr;
            WHILE A<B DO BEGIN
             Write(T,' S.Data['+IntToHex(A,6)+'] ... ' );
             S1:='';
             FOR O:=0 TO 31 DO BEGIN
              IF A<B THEN BEGIN
               C:=PByte(DWORD(P)+A)^;
               S1:=S1+IntToHex(C,2);
               INC(A);
              END;
             END;
             WriteLn(T,S1 );
            END;

//            LogAdd(S);
           Assign(F,S);
           ReWrite(F,1);
           P:=XM.Instrument[N].Sample[M].SmpPtr;
           PP:=POINTER(PDword(@P));
           BlockWrite(F,P^, XM.Instrument[N].Sample[M].Length);
           Close(F);
           WriteLn(T);
           INC(M);
          END;
          INC(N);
         END;
      Close(T);
     END;

END;




FUNCTION PerFrCalc(PatternNote:BYTE; RelativeTone, FineTune, PeriodPortamento:LONGINT ):REAL;
VAR Note:DWORD;
CONST PeriodTab : Array[0..12*8-1] of Word = (
      907,900,894,887,881,875,868,862,856,850,844,838,832,826,820,814,
      808,802,796,791,785,779,774,768,762,757,752,746,741,736,730,725,
      720,715,709,704,699,694,689,684,678,675,670,665,660,655,651,646,
      640,636,632,628,623,619,614,610,604,601,597,592,588,584,580,575,
      570,567,563,559,555,551,547,543,538,535,532,528,524,520,516,513,
      508,505,502,498,494,491,487,484,480,477,474,470,467,463,460,457);
VAR   A,B,C,D:EXTENDED;
      Fract:EXTENDED;
BEGIN


//   ********************************
//   *   Periods and frequencies:   *
//   ********************************
//   PatternNote = 0..95 (0 = C-0, 95 = B-7)
//   FineTune = -128..+127 (-128 = -1 halftone, +127 = +127/128 halftones)
//   RelativeTone = -96..95 (0 => C-4 = C-4)
//   RealNote = PatternNote + RelativeTone; (0..118, 0 = C-0, 118 = A#9)
     Note := PatternNote + RelativeTone;
      IF XM.Header.FreqTable=1 THEN BEGIN
//      Linear frequence table:
//      -----------------------

       INC(Note,11);
       XMCUR.Period := 10*12*16*4 - Note*16*4 - FineTune/2 - PeriodPortamento*4;
       IF XMCUR.Period <1 THEN XMCUR.Period:=1;
       IF XMCUR.Period >65535 THEN XMCUR.Period:=65535;
       A := ((6*12*16*4 - XMCUR.Period) / (12*16*4));
       B := Pwr ( 2,A );
       XMCUR.Frequency := 8363*B;//*($92cb / $4db3);
      END ELSE BEGIN
//      Amiga frequence table:
//      ----------------------
       Fract := Frac(FineTune/16);
       XMCUR.Period := (PeriodTab[ROUND((Note MOD 12)*8 + FineTune/16)]*(1-Fract) +
                        PeriodTab[ROUND((Note MOD 12)*8 + FineTune/16)]*(Fract))
                        *16/Pwr ( 2,(Note DIV 12) );
//      (The period is interpolated for finer finetune values)
       XMCUR.Period := XMCUR.Period - PeriodPortamento*2;
       IF XMCUR.Period <1 THEN XMCUR.Period:=1;
       IF XMCUR.Period >65535 THEN XMCUR.Period:=65535;
       XMCUR.Frequency := 8363*1712/XMCUR.Period;
      END;
//       XMCUR.Frequency := 8363*1712/XMCUR.Period;
//      XMCUR.Frequency := XMCUR.Frequency + $70000;
END;



PROCEDURE XM_Player_INIT;
VAR N,M,I:LONGINT;
BEGIN
      FillChar(XMCUR,SizeOf(XMCUR),0);
      XMCUR.BPM := XM.Header.BPM;
      XMCUR.TMP := XM.Header.TMP;
      XMCUR.PAT := XM.Header.PatternOrder[XMCUR.POS];
      FOR N:=0 TO XM.Header.NumChannels-1 DO BEGIN
       XMCUR.LineCUR[N].Vol:=64;
       XMCUR.LineCUR[N].EnvelopeVol:=64;
       XMCUR.LineCUR[N].Note:=12*4;
      END;
      XMCUR.PAT_PLAYED[XMCUR.POSC]:=1;
      XMCUR.GlobalVol:=64;
      XMCUR.TIKI:=-1;
END;


FUNCTION XM_ChekSongEND:BOOLEAN;
VAR N,M,I,A,B,C:LONGINT;
BEGIN
       M:=XM.Header.SongLen-1;
       FOR N:=0 TO XM.Header.SongLen-1 DO BEGIN
        IF XMCUR.PAT_PLAYED[N]<>0 THEN DEC(M);
       END;
       IF M=0 THEN XMCUR.SongEND:=TRUE;
       RESULT:=XMCUR.SongEND;
END;

//TYPE ARTPatData = ARRAY [0..63] OF TPatData;

FUNCTION XM_Player_STEP(DEV_FREQ:REAL):BOOLEAN;
VAR N,M,I,A,B,C:LONGINT;
VAR //JPatData: ^TPatData;   //ARRAY OF TPatData;
    JPatData: ^ARRAY[0..65535] OF TPatData;
    EFF:DWORD;
    Vol:BYTE;
    FadeOutVol:DWORD;
    EnvelopeVol:BYTE;
    Scale:BYTE;
    Note:BYTE;
    Ins:BYTE;
BEGIN
//      XM.Header.PatternOrder[XMCUR.PATP];
      FadeOutVol:=65536;
      EnvelopeVol:=64;
      Scale:=255;

{
      FOR N:=0 TO XM.Header.NumChannels-1 DO BEGIN
       XMCUR.PatLAST[N].InsA := 0;
      END;
}
      INC(XMCUR.TIKI);
      DEC(XMCUR.TIK);
      IF XMCUR.TIK<1 THEN BEGIN
       //Get New Line
       IF XM.Pattern[XMCUR.PAT].Rows <= XMCUR.LINE THEN BEGIN
        XMCUR.POSC:=XMCUR.POS;
        XM_ChekSongEND();
        XMCUR.PAT_PLAYED[XMCUR.POSC]:=1;
        //Read Next PAT
        INC(XMCUR.POS);
        IF XMCUR.POS >= XM.Header.SongLen THEN BEGIN
         XMCUR.POS:=XM.Header.Restart;
        END;
        XMCUR.PAT := XM.Header.PatternOrder[XMCUR.POS];
        XMCUR.LINE:=0;
       END;
       JPatData:=PatternER[XMCUR.PAT].MemPtr;
       FOR N:=0 TO XM.Header.NumChannels-1 DO BEGIN
        XMCUR.LineDATA[N] := JPatData^[XMCUR.LINE * XM.Header.NumChannels + N];
        CASE XMCUR.LineDATA[N].EFF OF
         $0E :BEGIN
          XMCUR.LineDATA[N].EFF := (XMCUR.LineDATA[N].EFF SHL 4) OR (XMCUR.LineDATA[N].EFV SHR 4);
          XMCUR.LineDATA[N].EFV := XMCUR.LineDATA[N].EFV AND $0F;
         END;
         $0F:BEGIN
          IF XMCUR.LineDATA[N].EFV<$20 THEN BEGIN
           XMCUR.TMP:=XMCUR.LineDATA[N].EFV;
          END ELSE BEGIN
           XMCUR.BPM:=XMCUR.LineDATA[N].EFV;
          END;
         END;
         $17 :BEGIN
          CASE XMCUR.LineDATA[N].EFV AND $F0 OF
           $00:BEGIN
           END;
           $10:BEGIN
            INC (XMCUR.LineDATA[N].EFF);
           END;
           ELSE BEGIN
            XMCUR.LineDATA[N].EFF:=0;
           END;
          END;
          XMCUR.LineDATA[N].EFV := XMCUR.LineDATA[N].EFV AND $0F;
         END;
        END;

        XMCUR.LineCUR[N].RelativePRES:=1;
        IF XMCUR.LineDATA[N].EFF = $ED THEN BEGIN // Note Delay
         XMCUR.LineCUR[N].RelativePRES:=(XMCUR.LineDATA[N].EFV AND 15);
         IF XMCUR.LineCUR[N].RelativePRES<>0 THEN INC(XMCUR.LineCUR[N].RelativePRES);
        END;
       END;
       XMCUR.TIK := XMCUR.TMP;
       XMCUR.TIKI := 0;
       XMCUR.CLINE := XMCUR.LINE;
       INC(XMCUR.LINE);
      END;

      //Do EFFECTS
      FOR N:=0 TO XM.Header.NumChannels-1 DO BEGIN
       XMCUR.LineCUR[N].InsA := 0;
       DEC(XMCUR.LineCUR[N].RelativePRES);
       XMCUR.LineCUR[N].SmpOfs:=0;
       IF XMCUR.LineCUR[N].RelativePRES=0 THEN BEGIN

//        XMCUR.LineCUR[N].NoteO:=XMCUR.LineCUR[N].Note;
//        XMCUR.LineCUR[N].RelativeToneO:=XMCUR.LineCUR[N].RelativeTone;
//        XMCUR.LineCUR[N].FineTuneO:=XMCUR.LineCUR[N].FineTune;

        IF XMCUR.LineDATA[N].Ins<>0 THEN BEGIN
         XMCUR.LineCUR[N].Vol := XM.Instrument[XMCUR.LineDATA[N].Ins-1].Sample[0].Volume;
         CASE XMCUR.LineDATA[N].EFF OF
          $03:BEGIN
          END;
          ELSE BEGIN
           IF XMCUR.LineDATA[N].Note<>0 THEN BEGIN
            XMCUR.LineCUR[N].PeriodPortamento:=0;
            XMCUR.LineCUR[N].FineTune     := XM.Instrument[XMCUR.LineDATA[N].Ins-1].Sample[0].FineTune;
            XMCUR.LineCUR[N].RelativeTone := XM.Instrument[XMCUR.LineDATA[N].Ins-1].Sample[0].RelativeNote;
            XMCUR.LineCUR[N].Ins          := XMCUR.LineDATA[N].Ins;
            XMCUR.LineCUR[N].InsA         := XMCUR.LineDATA[N].Ins;
           END ELSE BEGIN
           END
          END;
         END;
        END ELSE BEGIN
         IF XMCUR.LineDATA[N].Note<>0 THEN BEGIN
          XMCUR.LineCUR[N].PeriodPortamento:=0;
          XMCUR.LineCUR[N].InsA         := XMCUR.LineCUR[N].Ins;
         END;
        END;

        IF XMCUR.LineDATA[N].Note<>0 THEN BEGIN
         CASE XMCUR.LineDATA[N].EFF OF
          $03:BEGIN
           XMCUR.LineCUR[N].PeriodPortamentoO := 0; // !!!!!!!!!!!!!
           XMCUR.LineCUR[N].NoteO         := XMCUR.LineDATA[N].Note;
           XMCUR.LineCUR[N].FineTuneO     := XM.Instrument[XMCUR.LineCUR[N].Ins-1].Sample[0].FineTune;
           XMCUR.LineCUR[N].RelativeToneO := XM.Instrument[XMCUR.LineCUR[N].Ins-1].Sample[0].RelativeNote;
          END;
          ELSE BEGIN
           XMCUR.LineCUR[N].Note:=XMCUR.LineDATA[N].Note;
          END;
         END;
        END;

        CASE XMCUR.LineDATA[N].VolEFF OF
         $10..$50:XMCUR.LineCUR[N].Vol:=XMCUR.LineDATA[N].VolEFF-$10;
        END;
       END;

       XMCUR.LineCUR[N].NoteArpeggio := 0;
       //DO EFFECT
       CASE XMCUR.LineDATA[N].EFF OF
        //1      Arpeggio
        $00:BEGIN
         CASE XMCUR.TIKI MOD 3 OF
          0:XMCUR.LineCUR[N].NoteArpeggio := 0;
          1:XMCUR.LineCUR[N].NoteArpeggio := XMCUR.LineDATA[N].EFV SHR 4;
          2:XMCUR.LineCUR[N].NoteArpeggio := XMCUR.LineDATA[N].EFV AND 15;
         END;
        END;

        //1  (*) Porta up
        $01:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES<>0 THEN INC(XMCUR.LineCUR[N].PeriodPortamento, XMCUR.LineDATA[N].EFV);
        END;
        //2  (*) Porta down
        $02:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES<>0 THEN DEC(XMCUR.LineCUR[N].PeriodPortamento, XMCUR.LineDATA[N].EFV);
        END;

        //3  (*) Slide
        $03:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES<>0 THEN BEGIN
           IF XMCUR.CLINE=8 THEN BEGIN
            I:=0;
           END;
           I:=0;
           PerFrCalc(XMCUR.LineCUR[N].NoteO, XMCUR.LineCUR[N].RelativeToneO, XMCUR.LineCUR[N].FineTuneO, XMCUR.LineCUR[N].PeriodPortamentoO);
           XMCUR.LineCUR[N].PeriodO := XMCUR.Period;
           XMCUR.LineCUR[N].FrequencyO := XMCUR.Frequency;
           IF XMCUR.LineCUR[N].FrequencyR < XMCUR.LineCUR[N].FrequencyO THEN BEGIN
            INC(XMCUR.LineCUR[N].PeriodPortamento, XMCUR.LineDATA[N].EFV);
            PerFrCalc(XMCUR.LineCUR[N].Note, XMCUR.LineCUR[N].RelativeTone, XMCUR.LineCUR[N].FineTune, XMCUR.LineCUR[N].PeriodPortamento);
            IF XMCUR.Frequency > XMCUR.LineCUR[N].FrequencyO THEN I:=1;
           END ELSE BEGIN
            DEC(XMCUR.LineCUR[N].PeriodPortamento, XMCUR.LineDATA[N].EFV);
            PerFrCalc(XMCUR.LineCUR[N].Note, XMCUR.LineCUR[N].RelativeTone, XMCUR.LineCUR[N].FineTune, XMCUR.LineCUR[N].PeriodPortamento);
            IF XMCUR.Frequency < XMCUR.LineCUR[N].FrequencyO THEN I:=1;
           END;
           IF I=1 THEN BEGIN
            XMCUR.LineCUR[N].Note           := XMCUR.LineCUR[N].NoteO;
            XMCUR.LineCUR[N].RelativeTone   := XMCUR.LineCUR[N].RelativeToneO;
            XMCUR.LineCUR[N].FineTune       := XMCUR.LineCUR[N].FineTuneO;
            XMCUR.LineCUR[N].PeriodPortamento:=XMCUR.LineCUR[N].PeriodPortamentoO;
           END;
         END;
        END;

        //9      Samplr Offset
        $09:BEGIN
         IF XMCUR.LineDATA[N].Note<>0 THEN BEGIN
          XMCUR.LineCUR[N].SmpOfs:=XMCUR.LineDATA[N].EFV;
         END;
        END;
        //C      Set volume
        $0C:BEGIN
         XMCUR.LineCUR[N].Vol:=XMCUR.LineDATA[N].EFV;
        END;

        //      A  (*) Volume slide
        $0A:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES<>0 THEN BEGIN
          IF (XMCUR.LineDATA[N].EFV AND $F0) <> 0 THEN BEGIN
           INC(XMCUR.LineCUR[N].Vol, XMCUR.LineDATA[N].EFV SHR 4);
          END ELSE BEGIN
           DEC(XMCUR.LineCUR[N].Vol, XMCUR.LineDATA[N].EFV);
          END;
         END;
        END;

        //      B  (*) Pos Jump
        $0B:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN BEGIN
          XMCUR.LINE:=$08000000;
          XMCUR.POS:=XMCUR.LineDATA[N].EFV;
          IF XMCUR.POS >= XM.Header.SongLen THEN BEGIN
           XMCUR.POS:=XM.Header.Restart;
          END;
         END;
        END;

        //      D  (*) PATTERN BREAK
        $0D:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN BEGIN
          XMCUR.LINE:=(XMCUR.LineDATA[N].EFV AND 15) OR ((XMCUR.LineDATA[N].EFV SHR 4)*10);
          XMCUR.LINE:=XMCUR.LINE OR $08000000;
          XMCUR.POS:=XMCUR.POSC+1;
          IF XMCUR.POS >= XM.Header.SongLen THEN BEGIN
           XMCUR.POS:=XM.Header.Restart;
          END;
         END;
        END;

        //E1 (*) Fine porta up
        $E1:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN INC(XMCUR.LineCUR[N].PeriodPortamento, XMCUR.LineDATA[N].EFV);
        END;
        //E2 (*) Fine porta down
        $E2:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN DEC(XMCUR.LineCUR[N].PeriodPortamento, XMCUR.LineDATA[N].EFV);
        END;

        $E6:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN BEGIN
          IF XMCUR.LineDATA[N].EFV=0 THEN BEGIN
           XMCUR.LINE_LOOP:=XMCUR.CLINE;
          END ELSE BEGIN
           IF XMCUR.LINE_LOOPC < XMCUR.LineDATA[N].EFV THEN BEGIN
            XMCUR.LINE:=XMCUR.LINE_LOOP;
            INC (XMCUR.LINE_LOOPC);
//            XMCUR.POS:=XMCUR.POSC;
           END ELSE BEGIN
            XMCUR.LINE_LOOPC:=0;
           END;
          END;
         END;
        END;

        //EA (*) Fine volume slide up
        $EA:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN INC(XMCUR.LineCUR[N].Vol, XMCUR.LineDATA[N].EFV);
        END;
        //EB (*) Fine volume slide down
        $EB:BEGIN
         IF XMCUR.LineCUR[N].RelativePRES=0 THEN DEC(XMCUR.LineCUR[N].Vol, XMCUR.LineDATA[N].EFV);
        END;

       END;



       IF XMCUR.LineCUR[N].Vol>64 THEN XMCUR.LineCUR[N].Vol:=64;
       IF XMCUR.LineCUR[N].Vol<0 THEN XMCUR.LineCUR[N].Vol:=0;

       PerFrCalc(XMCUR.LineCUR[N].Note+XMCUR.LineCUR[N].NoteArpeggio, XMCUR.LineCUR[N].RelativeTone, XMCUR.LineCUR[N].FineTune, XMCUR.LineCUR[N].PeriodPortamento);
       XMCUR.LineCUR[N].PeriodR := XMCUR.Period;
       XMCUR.LineCUR[N].FrequencyR := XMCUR.Frequency;
       XMCUR.LineCUR[N].Period := XMCUR.Period;
       XMCUR.LineCUR[N].Frequency := XMCUR.Frequency * (DEV_FREQ/45000);
       //(FadeOutVol/65536)*(EnvelopeVol/64)*(GlobalVol/64)*(Vol/64)*Scale;
       Vol:= XMCUR.LineCUR[N].Vol;
       EnvelopeVol:=XMCUR.LineCUR[N].EnvelopeVol;
       XMCUR.LineCUR[N].FinalVol := ROUND( (FadeOutVol/65536)*(EnvelopeVol/64)*(XMCUR.GlobalVol/64)*(Vol/64)*Scale );

       XMCUR.LineCUR[N].FinalVol_L := XMCUR.LineCUR[N].FinalVol;
       XMCUR.LineCUR[N].FinalVol_R := XMCUR.LineCUR[N].FinalVol;
       IF XM.Header.FreqTable<>1 THEN BEGIN
        //Amiga
        CASE N OF
         0:BEGIN //L
          XMCUR.LineCUR[N].FinalVol_L := ROUND(XMCUR.LineCUR[N].FinalVol*1.0);
          XMCUR.LineCUR[N].FinalVol_R := ROUND(XMCUR.LineCUR[N].FinalVol*0.4);
         END;
         1:BEGIN //L
          XMCUR.LineCUR[N].FinalVol_L := ROUND(XMCUR.LineCUR[N].FinalVol*1.0);
          XMCUR.LineCUR[N].FinalVol_R := ROUND(XMCUR.LineCUR[N].FinalVol*0.9);
         END;
         2:BEGIN //R
          XMCUR.LineCUR[N].FinalVol_L := ROUND(XMCUR.LineCUR[N].FinalVol*0.9);
          XMCUR.LineCUR[N].FinalVol_R := ROUND(XMCUR.LineCUR[N].FinalVol*1.0);
         END;
         3:BEGIN //R
          XMCUR.LineCUR[N].FinalVol_L := ROUND(XMCUR.LineCUR[N].FinalVol*0.4);
          XMCUR.LineCUR[N].FinalVol_R := ROUND(XMCUR.LineCUR[N].FinalVol*1.0);
         END;
        END;
       END;
       XMCUR.LineCUR[N].FinalVol_LR := XMCUR.LineCUR[N].FinalVol_L OR (XMCUR.LineCUR[N].FinalVol_R SHL 8)


      END;

      RESULT:=XMCUR.SongEND;
END;


FUNCTION XM_GetPack(VAR P:ARRAY OF BYTE):DWORD; STDCALL;
VAR N,M,MM,I,O:LONGINT;

BEGIN
//      P:=@OUTDATA;

      M:=0;
      FOR N:=0 TO XM.Header.NumChannels-1 DO BEGIN
       MM:=M;
       INC(M);
       O:=0;
       IF XMCUR.PatLPREV[N].FinalVol_LR <> XMCUR.LineCUR[N].FinalVol_LR THEN BEGIN
        O:=O OR (1 SHL 2);
        P[M]:=XMCUR.LineCUR[N].FinalVol_L;
        INC(M);
        P[M]:=XMCUR.LineCUR[N].FinalVol_R;
        INC(M);
        XMCUR.PatLPREV[N].FinalVol_LR := XMCUR.LineCUR[N].FinalVol_LR;
       END;
       IF XMCUR.PatLPREV[N].Frequency <> XMCUR.LineCUR[N].Frequency THEN BEGIN
        O:=O OR (1 SHL 1);
        O:=O OR (1 SHL 0);
        I:=ROUND(XMCUR.LineCUR[N].Frequency);
        P[M]:=I SHR 8;
        INC(M);
        P[M]:=I;
        INC(M);
        XMCUR.PatLPREV[N].Frequency := XMCUR.LineCUR[N].Frequency;
       END;

       IF (XMCUR.LineCUR[N].InsA<>0) OR (XMCUR.LineCUR[N].SmpOfs<>0) THEN BEGIN
        IF (XMCUR.LineCUR[N].SmpOfs<>0) THEN BEGIN
         O:=O OR (1 SHL 6);
         I:=XMCUR.LineCUR[N].SmpOfs;
         P[M]:=I;
         INC(M);
        END;
        O:=O OR (1 SHL 7);
        I:=XMCUR.LineCUR[N].Ins;
        P[M]:=I;
        INC(M);
       END;
       IF N=(XM.Header.NumChannels-1) THEN O:=O OR (1 SHL 5);
       P[MM]:=O;
      END;
      RESULT:=M;


END;









BEGIN
      XM.FNAM:='';

END.
