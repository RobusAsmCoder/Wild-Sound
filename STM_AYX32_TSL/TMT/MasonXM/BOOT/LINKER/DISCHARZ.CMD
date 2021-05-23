;O-OPEN TRD                   "PATH\file"
;o-OPEN BOOT.B                "NAME.B"
;C-CLOSE TRD                  "PATH\file"
;L-LOAD                       "PATH\file",Start,Size
;U-LOAD/UNPACK                "PATH\file",Start,Size
;P-PAGE                       Page
;E-FLUSH & EXEC               Start
;R-REDEFINE CMD               "CMD",Value
;G-GoTo                       Label
;g-GoSub                      Label
;I-GoToIF                     A,<=>,B,Label
;i-GoSubIF                    A,<=>,B,Label
;T-RET
;l-Label
;K-Start Coding OUT DATA      CodingString
;k-End Coding OUT DATA

        ReDef   :"L","..\loados.inc"CMD.L
        ReDef   :"U","..\loados.inc"CMD.U
        ReDef   :"X","..\loados.inc"CMD.X
        ReDef   :"x","..\loados.inc"CMD.XX
        ReDef   :"E","..\loados.inc"CMD.E
        ReDef   :"P","..\loados.inc"CMD.P
        ReDef   :"G","..\loados.inc"CMD.G
        ReDef   :"g","..\loados.inc"CMD.GG
        ReDef   :"I","..\loados.inc"CMD.I
        ReDef   :"i","..\loados.inc"CMD.II
        ReDef   :"T","..\loados.inc"CMD.T
        ReDef   :1,"..\loados.inc"CMD.COM1
        ReDef   :2,"..\loados.inc"CMD.COM2
        ReDef   :3,"..\loados.inc"CMD.COM3
        ReDef   :4,"..\loados.inc"CMD.COM4
        ReDef   :5,"..\loados.inc"CMD.COM5
        ReDef   :6,"..\loados.inc"CMD.COM6
        ReDef   :"K","..\loados.inc"CMD.K

        OpenTRD :"..\BOOT.trd",256
        OpenFile:"boot.B"

        PackMode:DoLoad
        PackMode:DoPack

;        Page    :16
;        Pack    :"..\LZSATEST\lzsatest.bin","..\LZSATEST\lzsatest.txt"START
;        Exec    :"..\LZSATEST\lzsatest.txt"START
;        Pack    :"..\LZSATEST\pictest.bin","..\LZSATEST\pictest.txt"START
;        Exec    :"..\LZSATEST\pictest.txt"START


        GoTo    :LoadingPENT








;=============================================================================
; LOAD PENTAGON
;=============================================================================
l:LoadingPENT

        Page    :16

        Pack    :"..\XMPLOAD\xmpload.bin","..\XMPLOAD\xmpload.txt"START

        Pack    :"..\..\MUSIC\DISCHARZ.xmPatPack00","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_TRKN
        Pack    :"..\..\MUSIC\DISCHARZ.xmPatPack01","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_TRKN
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack00","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INSHDR
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack01","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack02","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack03","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack04","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack05","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack06","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack07","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack08","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack09","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS
        Pack    :"..\..\MUSIC\DISCHARZ.xmInsPack10","..\XMPLOAD\xmpload.txt"LOAD_DATA
        EXEC    :"..\XMPLOAD\xmpload.txt"UpLoadAY_INS

        EXEC    :"..\XMPLOAD\xmpload.txt"UpPlayer




;=============================================================================
; Linking Result
;=============================================================================

        CloseTRD:"DISCHARZ.trd"

        RenameFile:,"boot.B","AAAA.B"
        RenameFile:,"boot.B","boot.L"
        RenameFile:,"boot.B","boot.I"
        RenameFile:,"boot.B","boot.N"
        RenameFile:,"boot.B","boot.K"
        RenameFile:,"boot.B","boot.E"
        RenameFile:,"boot.B","boot.R"
        RenameFile:,"boot.B","boot.O"
        RenameFile:,"boot.B","boot.S"
        RenameFile:,"boot.B","boot.T"
        RenameFile:,"AAAA.B","boot.B"
