USES CRT,DOS,STRINGS,
     RobXM;





//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

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


VAR STMP:STRING='tmp89748258';

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

PROCEDURE EraseFileExist(S8:STRING);
VAR F:FILE;
BEGIN
               IF CheckFileExistWithRules(S8,TRUE) THEN BEGIN
                ASSIGN (F,S8);
                Erase (F);
               END;
END;



//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

PROCEDURE XM_SaveMasonDigitalTRD(PATHLINK:STRING);
VAR N,M,I,III:LONGINT;
    S,S1,S2:STRING;
    T:TEXT;
    FLINK:STRING;
    FNAME:STRING;
BEGIN
        //WriteLn(XM.FNAM);

        FNAME:=XM.FNAM;//GetName(XM.FNAM);
        FLINK:=FNAME;//PATHLINK+FNAME;
//        WRITELN(FLINK);


        ASSIGN(T,FLINK+'.cmd');
        REWRITE(T);



WriteLn(T,'        ReDef   :"L","BOOT\loados.inc"CMD.L');
WriteLn(T,'        ReDef   :"U","BOOT\loados.inc"CMD.U');
WriteLn(T,'        ReDef   :"X","BOOT\loados.inc"CMD.X');
WriteLn(T,'        ReDef   :"x","BOOT\loados.inc"CMD.XX');
WriteLn(T,'        ReDef   :"E","BOOT\loados.inc"CMD.E');
WriteLn(T,'        ReDef   :"P","BOOT\loados.inc"CMD.P');
WriteLn(T,'        ReDef   :"G","BOOT\loados.inc"CMD.G');
WriteLn(T,'        ReDef   :"g","BOOT\loados.inc"CMD.GG');
WriteLn(T,'        ReDef   :"I","BOOT\loados.inc"CMD.I');
WriteLn(T,'        ReDef   :"i","BOOT\loados.inc"CMD.II');
WriteLn(T,'        ReDef   :"T","BOOT\loados.inc"CMD.T');
WriteLn(T,'        ReDef   :1,"BOOT\loados.inc"CMD.COM1');
WriteLn(T,'        ReDef   :2,"BOOT\loados.inc"CMD.COM2');
WriteLn(T,'        ReDef   :3,"BOOT\loados.inc"CMD.COM3');
WriteLn(T,'        ReDef   :4,"BOOT\loados.inc"CMD.COM4');
WriteLn(T,'        ReDef   :5,"BOOT\loados.inc"CMD.COM5');
WriteLn(T,'        ReDef   :6,"BOOT\loados.inc"CMD.COM6');
WriteLn(T,'        ReDef   :"K","BOOT\loados.inc"CMD.K');
WriteLn(T,'        OpenTRD :"BOOT\BOOT.trd",256');
WriteLn(T,'        OpenFile:"boot.B"');
WriteLn(T,'        PackMode:DoPack');
WriteLn(T,'');
WriteLn(T,'        Page    :16');
WriteLn(T,'        Pack    :"BOOT\XMPLOAD\xmpload.bin","BOOT\XMPLOAD\xmpload.txt"START');

        FOR III:=0 TO 3 DO BEGIN
         CASE III OF
          0,2:BEGIN
           S:=XM.FNAM+'PatPack';
          END;
          1,3:BEGIN
           S:=XM.FNAM+'InsPack';
          END;
         END;
         IF ( CheckFileExistWithRules(S,TRUE) ) THEN BEGIN
//          WriteLn('>>>',S);
          IF III<2 THEN BEGIN
          END ELSE BEGIN
           EraseFileExist(S);
          END;
          FOR N:=0 TO 15 DO BEGIN
           StrSpaceRob:='0';
           S1:=S+IntToStrRob(N,2);
           IF ( CheckFileExistWithRules(S1,TRUE) ) THEN BEGIN
//            WriteLn('>>>',S1);
            IF III<2 THEN BEGIN
WriteLn(T,'        Pack    :"'+S1+'","BOOT\XMPLOAD\xmpload.txt"LOAD_DATA');
S2:='        EXEC    :"BOOT\XMPLOAD\xmpload.txt"';
             IF III=0 THEN BEGIN
              S2:=S2+'UpLoadAY_TRKN';
             END ELSE BEGIN
              IF N=0 THEN BEGIN
               S2:=S2+'UpLoadAY_INSHDR';
              END ELSE BEGIN
               S2:=S2+'UpLoadAY_INS';
              END;
             END;
WriteLn(T,S2);
            END ELSE BEGIN
             EraseFileExist(S1);
            END;
           END ELSE BEGIN
             IF III=1 THEN BEGIN
WriteLn(T,'        EXEC    :"BOOT\XMPLOAD\xmpload.txt"UpPlayer');
WriteLn(T,'');
WriteLn(T,'        CloseTRD:"'+FNAME+'.trd"');
WriteLn(T,'        RenameFile:,"boot.B","AAAA.B"');
WriteLn(T,'        RenameFile:,"boot.B","boot.L"');
WriteLn(T,'        RenameFile:,"boot.B","boot.I"');
WriteLn(T,'        RenameFile:,"boot.B","boot.N"');
WriteLn(T,'        RenameFile:,"boot.B","boot.K"');
WriteLn(T,'        RenameFile:,"boot.B","boot.E"');
WriteLn(T,'        RenameFile:,"boot.B","boot.R"');
WriteLn(T,'        RenameFile:,"boot.B","boot.O"');
WriteLn(T,'        RenameFile:,"boot.B","boot.S"');
WriteLn(T,'        RenameFile:,"boot.B","boot.T"');
WriteLn(T,'        RenameFile:,"AAAA.B","boot.B"');
        CLOSE(T);
              EXEC ('BOOT\LINKER\LINK.exe',FLINK+'.cmd');
              EraseFileExist('LINK.TMP');
              EraseFileExist(FLINK+'.cmd');
             END;
            BREAK;
           END;
          END;
         END;

        END;




END;

PROCEDURE XM_ModuleConvert(FNAM:STRING; SNGNAME:STRING);
VAR N,M,I:LONGINT;
BEGIN
        XM_Load(FNAM);
        IF (SNGNAME<>'') THEN BEGIN
         FillChar(PatternsPacked.TrackName, SizeOf(PatternsPacked.TrackName), 0);
         I:=Length(SNGNAME);
         IF (I>SizeOf(PatternsPacked.TrackName)) THEN BEGIN
          I:=SizeOf(PatternsPacked.TrackName);
         END;
         MOVE(SNGNAME[1], PatternsPacked.TrackName, I); //XM.Info.Name := SNGNAME;
        END;
        SavePatternsPack(XM.FNAM+'PatPack',32768);
        SaveInstrumentsPack(XM.FNAM+'InsPack',32768);


        XM_SaveMasonDigitalTRD('BOOT\LINKER\');


END;




BEGIN
        IF ParamStr(1)<>'' THEN BEGIN
         XM_ModuleConvert(ParamStr(1), ParamStr(2));
        END ELSE BEGIN
         WriteLn('PLEASE MasonXM.EXE file.xm');
        END;

//        XM_ModuleConvert('Music\Prosiak.xm', 'Prosiak');
//        XM_ModuleConvert('Music\Prosiak0.xm', '');
//        XM_ModuleConvert('Music\checkno1.xm', 'Checkno');
//        XM_ModuleConvert('Music\Consul.xm', '');
        //XM_ModuleConvert('Music\DISCHARZ.xm', '');
//        XM_ModuleConvert('Music\BALLADAL.xm', '');

//        XM_ModuleConvert('Music\TREXZ.xm', '');
        //XM_ModuleConvert('Music\TREXZ.xm', '');
//        XM_ModuleConvert('Music\FASTER-2.xm', '');




END.

