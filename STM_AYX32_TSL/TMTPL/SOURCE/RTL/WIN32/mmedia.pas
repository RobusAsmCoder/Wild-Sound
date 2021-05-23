(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Multimedia Object Unit v.1.0                           *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995,1999 TMT Development Corporation    *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

unit MMedia;

interface

uses Strings, Windows, MMSystem;

const
  MCI_AutoSelect   = 0;
  MCI_AVIVideo     = 1;
  MCI_CDAudio      = 2;
  MCI_DAT          = 3;
  MCI_DigitalVideo = 4;
  MCI_MMMovie      = 5;
  MCI_Other        = 6;
  MCI_Overlay      = 7;
  MCI_Scanner      = 8;
  MCI_Sequencer    = 9;
  MCI_VCR          = 10;
  MCI_VideoDisc    = 11;
  MCI_WaveAudio    = 12;

// Constants inherited from MMSYSTEM.PAS
  MCI_CDA_TRACK_AUDIO    = MCI_CD_OFFSET;
  MCI_CDA_TRACK_OTHER    = MCI_CD_OFFSET + 1;

  MCI_MODE_NOT_READY     = MCI_STRING_OFFSET + 12;
  MCI_MODE_STOP          = MCI_STRING_OFFSET + 13;
  MCI_MODE_PLAY          = MCI_STRING_OFFSET + 14;
  MCI_MODE_RECORD        = MCI_STRING_OFFSET + 15;
  MCI_MODE_SEEK          = MCI_STRING_OFFSET + 16;
  MCI_MODE_PAUSE         = MCI_STRING_OFFSET + 17;
  MCI_MODE_OPEN          = MCI_STRING_OFFSET + 18;

  MCI_FORMAT_MILLISECONDS         = 0;
  MCI_FORMAT_HMS                  = 1;
  MCI_FORMAT_MSF                  = 2;
  MCI_FORMAT_FRAMES               = 3;
  MCI_FORMAT_SMPTE_24             = 4;
  MCI_FORMAT_SMPTE_25             = 5;
  MCI_FORMAT_SMPTE_30             = 6;
  MCI_FORMAT_SMPTE_30DROP         = 7;
  MCI_FORMAT_BYTES                = 8;
  MCI_FORMAT_SAMPLES              = 9;
  MCI_FORMAT_TMSF                 = 10;

  MMSYSERR_NOERROR                = 01;
  MMSYSERR_ERROR                  = MMSYSERR_BASE + 01;
  MMSYSERR_BADDEVICEID            = MMSYSERR_BASE + 02;
  MMSYSERR_NOTENABLED             = MMSYSERR_BASE + 03;
  MMSYSERR_ALLOCATED              = MMSYSERR_BASE + 04;
  MMSYSERR_INVALHANDLE            = MMSYSERR_BASE + 05;
  MMSYSERR_NODRIVER               = MMSYSERR_BASE + 06;
  MMSYSERR_NOMEM                  = MMSYSERR_BASE + 07;
  MMSYSERR_NOTSUPPORTED           = MMSYSERR_BASE + 08;
  MMSYSERR_BADERRNUM              = MMSYSERR_BASE + 09;
  MMSYSERR_INVALFLAG              = MMSYSERR_BASE + 10;
  MMSYSERR_INVALPARAM             = MMSYSERR_BASE + 11;
  MMSYSERR_HANDLEBUSY             = MMSYSERR_BASE + 12;
  MMSYSERR_INVALIDALIAS           = MMSYSERR_BASE + 13;
  MMSYSERR_BADDB                  = MMSYSERR_BASE + 14;
  MMSYSERR_KEYNOTFOUND            = MMSYSERR_BASE + 15;
  MMSYSERR_READERROR              = MMSYSERR_BASE + 16;
  MMSYSERR_WRITEERROR             = MMSYSERR_BASE + 17;
  MMSYSERR_DELETEERROR            = MMSYSERR_BASE + 18;
  MMSYSERR_VALNOTFOUND            = MMSYSERR_BASE + 19;
  MMSYSERR_NODRIVERCB             = MMSYSERR_BASE + 20;
  MMSYSERR_LASTERROR              = MMSYSERR_BASE + 20;

type
  TMCIDeviceCaps = record
    CanPlay:             Boolean;
    CanRecord:           Boolean;
    CanEject:            Boolean;
    CanSave:             Boolean;
    CanChangePos:        Boolean;
    HasVideo:            Boolean;
    HasAudio:            Boolean;
    ActiveRect:          TRect;
    ActiveRectWidth:     Longint;
    ActiveRectHeight:    Longint;
  end;

  TMMedia = Object
  private
    MCIDeviceOpened:     Boolean;
    MCIFlags:            UINT;
    MCIShareable:        Boolean;
    MCIUseStartPos:      Boolean;
    MCIUseEndPos:        Boolean;
    MCIDisplayWndHandle: THandle;
    MCIDeviceID:         Word;
    MCIDevice:           DWORD;
    MCIStartPos:         DWORD;
    MCIEndPos:           DWORD;
    MCIError:            UINT;
    Handle:              THandle;
    procedure   MCIDeviceIsNotOpen;
    procedure   PrepareMCI(CheckForOpen: Boolean);
  public
    PlayFullScreen:      Boolean;
    PlayRepeat:          Boolean;
    Wait:                Boolean;
    StopAtClose:         Boolean;
    Notify:              Boolean;
    AutoRewind:          Boolean;
    MCIErrorProc: procedure(ErrorCode: UINT);
    function    GetLength: DWORD;
    procedure   Rewind;
    constructor Create(OwnerHandle: THandle);
    procedure   Open(FileName: String);
    procedure   Play;
    function    GetPos: Longint;
    procedure   SetPos(Position: Longint);
    function    GetStatus: DWORD;
    function    GetTimeFormat: DWORD;
    procedure   SetTimeFormat(TimeFormat: DWORD);
    function    GetTracksCount: Longint;
    function    GetTrackPos(TrackNum: UINT): Longint;
    function    GetTrackLength(TrackNum: DWORD): DWORD;
    procedure   SetStartPos(StartPos: Longint);
    procedure   SetEndPos(EndPos: Longint);
    procedure   ResetStartPos;
    procedure   ResetEndPos;
    procedure   Next;
    procedure   Previous;
    procedure   SetDisplayWindow(WndHandle: THandle);
    destructor  Close;
    procedure   Step(Frames: Longint);
    procedure   Resume;
    procedure   Rec;
    procedure   Stop;
    procedure   Pause;
    procedure   SetDoorOpen;
    procedure   SetDoorClosed;
    function    CDMediaIsPresent: Boolean;
    function    GetTrackFormat(TrackNo: DWORD): DWORD;
    function    GetFirstAudioTrack: DWORD;
    function    GotoFirstAudioTrack: Boolean;
    procedure   Save(FileName: String);
    procedure   SetDisplayRect(DisplayRect: TRect);
    function    ErrorCode: UINT;
    procedure   GetDeviceCaps(var DeviceCaps: TMCIDeviceCaps);
    procedure   SetDevice(Device: DWORD);
    function    GetDevice: DWORD;
    function    GetDeviceID: DWORD;
  end;

implementation

procedure DefaultMCIErrorProc(ErrorCode: UINT);
var
  Temp: array [0..MAX_PATH] of char;
begin
  if isConsole then
    Writeln('MCI device fault. Error code #' + IntToStr(ErrorCode))
  else
    MessageBox(0, StrPCopy(Temp, 'MCI device fault. Error code #' + IntToStr(ErrorCode)), 'Error', MB_ICONERROR);
end;

procedure TMMedia.PrepareMCI(CheckForOpen: Boolean);
begin
  if CheckForOpen and (not MCIDeviceOpened) then
    MCIDeviceIsNotOpen
  else
    MCIError := 0;
  MCIFlags := 0;
  if Notify then MCIFlags := MCIFlags or mci_Notify;
  if Wait then MCIFlags := MCIFlags or mci_Wait;
end;

procedure TMMedia.MCIDeviceIsNotOpen;
begin
  if DWORD(@MCIErrorProc) <> 0
  then
    MCIErrorProc(MCIError)
  else begin
    if isConsole then
      Writeln('MCI device is not open.')
    else
      MessageBox(Handle, 'MCI device is not open.', 'Error', MB_ICONERROR);
  end;
end;

constructor TMMedia.Create(OwnerHandle: THandle);
begin
  Handle := OwnerHandle;
  FillChar(Self, SizeOf(Self), 0);
  MCIErrorProc := DefaultMCIErrorProc;
  StopAtClose := TRUE;
end;

function TMMedia.GetLength: DWORD;
var
  StatusParm: TMCI_Status_Parms;
begin
  if not MCIDeviceOpened then MCIDeviceIsNotOpen;
  MCIFlags := mci_Wait or mci_Status_Item;
  StatusParm.dwItem := mci_Status_Length;
  MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, Longint(@StatusParm));
  Result := StatusParm.dwReturn;
end;

procedure TMMedia.GetDeviceCaps(var DeviceCaps: TMCIDeviceCaps);
var
  MCIDevCapsParms: TMCI_GetDevCaps_Parms;
  MCIAnimRectParms: TMCI_Anim_Rect_Parms;
begin
  MCIFlags := mci_Wait or mci_GetDevCaps_Item;

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Has_Video;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  DeviceCaps.HasVideo := Boolean(MCIDevCapsParms.dwReturn);

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Has_Audio;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  DeviceCaps.HasAudio := Boolean(MCIDevCapsParms.dwReturn);

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Can_Play;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  DeviceCaps.CanPlay := Boolean(MCIDevCapsParms.dwReturn);

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Can_Record;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  DeviceCaps.CanRecord := Boolean(MCIDevCapsParms.dwReturn);

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Can_Save;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  DeviceCaps.CanSave := Boolean(MCIDevCapsParms.dwReturn);

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Can_Eject;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  DeviceCaps.CanEject := Boolean(MCIDevCapsParms.dwReturn);

  MCIFlags := mci_Anim_Where_Source;
  MCIError := mciSendCommand(MCIDeviceID, mci_Where, MCIFlags, DWORD(@MCIAnimRectParms));
  DeviceCaps.ActiveRect := MCIAnimRectParms.rc;
  DeviceCaps.ActiveRectWidth := MCIAnimRectParms.rc.Right - MCIAnimRectParms.rc.Left + 1;
  DeviceCaps.ActiveRectHeight := MCIAnimRectParms.rc.Bottom - MCIAnimRectParms.rc.Top + 1;

  MCIDevCapsParms.dwItem := mci_GetDevCaps_Device_Type;
  mciSendCommand(MCIDeviceID, mci_GetDevCaps, MCIFlags, DWORD(@MCIDevCapsParms));
  if (MCIDevCapsParms.dwReturn = mci_DevType_Digital_Video) or (MCIDevCapsParms.dwReturn = mci_DevType_Animation) or
     (MCIDevCapsParms.dwReturn = mci_DevType_Overlay) or (MCIDevCapsParms.dwReturn = mci_DevType_VCR)
  then
    DeviceCaps.CanChangePos := TRUE
  else
    DeviceCaps.CanChangePos := FALSE;
end;

procedure TMMedia.Rewind;
var
  MCISeekParms: TMCI_Seek_Parms;
  TempFlags: Longint;
begin
  PrepareMCI(TRUE);
  TempFlags := mci_Wait or mci_Seek_To_Start;
  mciSendCommand(MCIDeviceID, mci_Seek, TempFlags, DWORD(@MCISeekParms));
end;

procedure TMMedia.Open(FileName: String);
const
  MCIDeviceName: array[0..12] of PChar = ('', 'AVIVideo', 'CDAudio', 'DAT', 'DigitalVideo',
    'MMMovie', 'Other', 'Overlay', 'Scanner', 'Sequencer','VCR', 'Videodisc', 'WaveAudio');
var
  Temp: array [0..MAX_PATH] of Char;
  MCIOpenParm: TMCI_Open_Parms;
  TrackNo: DWORD;
  MCIDeviceCaps: TMCIDeviceCaps;
  StrRes: Longint;
begin
  if MCIDeviceOpened then Close;

  with MCIOpenParm do
  begin
    PrepareMCI(FALSE);
    dwCallback := 0;
    if FileName <> '' then
    begin
      if (MCIDevice = MCI_CDAudio) or (MCIDevice = MCI_VideoDisc) then
        Val(FileName, TrackNo, StrRes)
      else
      begin
        lpstrElementName := StrPCopy(Temp, FileName);
        MCIFlags := MCIFlags or mci_Open_Element;
      end;
    end;
    if MCIDevice <> MCI_AutoSelect then
    begin
      lpstrDeviceType := MCIDeviceName[MCIDevice];
      MCIFlags := MCIFlags or mci_Open_Type;
    end;
    if MCIShareable then MCIFlags := MCIFlags or mci_Open_Shareable;
    dwCallback := Handle;

    MCIError := mciSendCommand(0, mci_Open, MCIFlags, Longint(@MCIOpenParm));

    if MCIError = NO_ERROR then
    begin
      MCIDeviceOpened := TRUE;
      MCIDeviceID := wDeviceID;
      GetDeviceCaps(MCIDeviceCaps);
      if (MCIDevice = MCI_CDAudio) or (MCIDevice = MCI_VideoDisc) then
      begin
        SetTimeFormat(MCI_FORMAT_TMSF);
        SetStartPos(GetTrackPos(TrackNo));
      end;
    end else
      if DWORD(@MCIErrorProc) <> 0 then MCIErrorProc(MCIError);
  end;
end;

procedure TMMedia.Play;
var
  PlayParm: TMCI_Play_Parms;
begin
  if AutoRewind and (GetPos = GetLength) then
    if not (MCIUseStartPos or MCIUseEndPos) then Rewind;

  FillChar(PlayParm, SizeOf(PlayParm), 0);
  MCIFlags := 0;

  PrepareMCI(FALSE);

  if MCIUseStartPos then
  begin
    MCIFlags := MCIFlags or mci_From;
    PlayParm.dwFrom := MCIStartPos;
    MCIUseStartPos := FALSE;
  end;

  if MCIUseEndPos then
  begin
    MCIFlags := MCIFlags or mci_To;
    PlayParm.dwTo := MCIEndPos;
    MCIUseEndPos := FALSE;
  end;

  PlayParm.dwCallback := Handle;
  if PlayFullScreen then
    MCIFlags := MCIFlags or MCI_MCIAVI_PLAY_FULLSCREEN;
  if PlayRepeat then
    MCIFlags := MCIFlags or MCI_DGV_PLAY_REPEAT;
  MCIError := mciSendCommand(MCIDeviceID, mci_Play, MCIFlags, DWORD(@PlayParm));
end;

function TMMedia.GetPos: Longint;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  MCIFlags := mci_Wait or mci_Status_Item;
  MCIStatusParms.dwItem := mci_Status_Position;
  MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
  Result := MCIStatusParms.dwReturn;
end;

procedure TMMedia.SetPos(Position: Longint);
var
  MCISeekParms: TMCI_Seek_Parms;
begin
  PrepareMCI(TRUE);
  MCIFlags := MCIFlags or mci_To;
  MCISeekParms.dwCallback := Handle;
  MCISeekParms.dwTo := Position;
  MCIError := mciSendCommand(MCIDeviceID, mci_Seek, MCIFlags, DWORD(@MCISeekParms));
end;

function TMMedia.GetTimeFormat: DWORD;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  if not MCIDeviceOpened then MCIDeviceIsNotOpen;

  MCIFlags := mci_Wait or mci_Status_Item;
  MCIStatusParms.dwItem := mci_Status_Time_Format;
  MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
  Result := MCIStatusParms.dwReturn;
end;

function TMMedia.GetStatus: DWORD;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  MCIFlags := mci_Wait or mci_Status_Item;
  MCIStatusParms.dwItem := mci_Status_Mode;
  MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
  Result := MCIStatusParms.dwReturn;
end;

function TMMedia.GetTracksCount: Longint;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  if not MCIDeviceOpened then MCIDeviceIsNotOpen;

  MCIFlags := mci_Wait or mci_Status_Item;
  MCIStatusParms.dwItem := mci_Status_Number_Of_Tracks;
  MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
  Result := MCIStatusParms.dwReturn;
end;

function TMMedia.GetTrackPos(TrackNum: UINT): Longint;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  PrepareMCI(TRUE);
  MCIFlags := mci_Wait or mci_Status_Item or mci_Track;
  MCIStatusParms.dwItem := mci_Status_Position;
  MCIStatusParms.dwTrack := TrackNum;
  mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
  Result := MCIStatusParms.dwReturn;
end;

function TMMedia.GetTrackLength(TrackNum: DWORD): DWORD;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  PrepareMCI(TRUE);
  MCIFlags := mci_Wait or mci_Status_Item or mci_Track;
  MCIStatusParms.dwItem := mci_Status_Length;
  MCIStatusParms.dwTrack := TrackNum;
  mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
  Result := MCIStatusParms.dwReturn;
end;

procedure TMMedia.SetTimeFormat(TimeFormat: DWORD);
var
  SetParm: TMCI_Set_Parms;
begin
  begin
    MCIFlags := mci_Notify or mci_Set_Time_Format;
    SetParm.dwTimeFormat := TimeFormat;
    MCIError := mciSendCommand(MCIDeviceID, mci_Set, MCIFlags, DWORD(@SetParm));
  end;
end;

procedure TMMedia.SetStartPos(StartPos: Longint);
begin
  MCIStartPos := StartPos;
  MCIUseStartPos := TRUE;
end;

procedure TMMedia.SetEndPos(EndPos: Longint);
begin
  MCIEndPos := EndPos;
  MCIUseEndPos := TRUE;
end;

procedure TMMedia.ResetStartPos;
begin
  MCIStartPos := 0;
  MCIUseStartPos := FALSE;
end;

procedure TMMedia.ResetEndPos;
begin
  MCIEndPos := 0;
  MCIUseEndPos := FALSE;
end;

procedure TMMedia.Next;
var
  MCISeekParms: TMCI_Seek_Parms;
  StoreFlags: DWORD;
begin
  FillChar(MCISeekParms, SizeOf(MCISeekParms), 0);

  PrepareMCI(TRUE);
  StoreFlags := MCIFlags;

  if GetTimeFormat = MCI_FORMAT_TMSF then
  begin
    if GetStatus = MCI_MODE_PLAY then
    begin
      if mci_TMSF_Track(GetPos) = GetTracksCount then
         SetStartPos(GetTrackPos(mci_TMSF_Track(GetPos)))
      else
         SetStartPos(GetTrackPos(1 + mci_TMSF_Track(GetPos)));
      Play;
      exit;
    end
    else
    begin
      if mci_TMSF_Track(GetPos) = GetTracksCount then
         MCISeekParms.dwTo := GetTrackPos(mci_TMSF_Track(GetPos))
      else
         MCISeekParms.dwTo := GetTrackPos(1 + mci_TMSF_Track(GetPos));
      MCIFlags := StoreFlags or mci_To;
    end;
  end
  else
    MCIFlags := StoreFlags or mci_Seek_To_End;

  MCISeekParms.dwCallback := Handle;
  MCIError := mciSendCommand(MCIDeviceID, mci_Seek, MCIFlags, DWORD(@MCISeekParms));
end;

procedure TMMedia.Previous;
var
  MCISeekParms: TMCI_Seek_Parms;
  StoreFlags: DWORD;
begin
  FillChar(MCISeekParms, SizeOf(MCISeekParms), 0);

  PrepareMCI(TRUE);
  StoreFlags := MCIFlags;

  if GetTimeFormat = MCI_FORMAT_TMSF then
  begin
    if GetStatus = MCI_MODE_PLAY then
    begin
      if mci_TMSF_Track(GetPos) <> 1 then
         SetStartPos(GetTrackPos(mci_TMSF_Track(GetPos) - 1))
      else
         SetStartPos(GetTrackPos(mci_TMSF_Track(GetPos)));
      Play;
      exit;
    end
    else
    begin
      if mci_TMSF_Track(GetPos) <> 1 then
         MCISeekParms.dwTo := GetTrackPos(mci_TMSF_Track(GetPos) - 1)
      else
         MCISeekParms.dwTo := GetTrackPos(mci_TMSF_Track(GetPos));
      MCIFlags := StoreFlags or mci_To;
    end;
  end
  else
    MCIFlags := StoreFlags or mci_Seek_To_Start;

  MCISeekParms.dwCallback := Handle;
  MCIError := mciSendCommand(MCIDeviceID, mci_Seek, MCIFlags, DWORD(@MCISeekParms));
end;

procedure TMMedia.SetDisplayWindow(WndHandle: THandle);
var
  MCIAnimWindowParm: TMCI_Anim_Window_Parms;
  MCIDeviceCaps: TMCIDeviceCaps;
begin
  GetDeviceCaps(MCIDeviceCaps);
  if (WndHandle <> 0) and MCIDeviceOpened and MCIDeviceCaps.HasVideo then
  begin
    MCIFlags := mci_Wait or mci_Anim_Window_hWnd;
    MCIAnimWindowParm.Wnd := WndHandle;
    MCIError := mciSendCommand(MCIDeviceID, mci_Window, MCIFlags, DWORD(@MCIAnimWindowParm));
    if MCIError <> 0 then
      MCIDisplayWndHandle  := 0
    else
      MCIDisplayWndHandle := WndHandle;
  end;
end;

destructor TMMedia.Close;
var
  MCIGenericParms: TMCI_Generic_Parms;
begin
  if MCIDeviceID <> 0 then
  begin
    PrepareMCI(FALSE);
    MCIGenericParms.dwCallback := Handle;
    if StopAtClose then Stop;
    MCIError := mciSendCommand(MCIDeviceID, mci_Close, MCIFlags, DWORD(@MCIGenericParms));
    if MCIError = 0 then
    begin
      MCIDeviceOpened := FALSE;
      MCIDeviceID := 0;
    end;
  end;
end;

procedure TMMedia.Step(Frames: Longint);
var
  MCIAnimStepParms: TMCI_Anim_Step_Parms;
  MCIDeviceCaps: TMCIDeviceCaps;
begin
  GetDeviceCaps(MCIDeviceCaps);
  if MCIDeviceCaps.HasVideo then
  begin
    if AutoRewind and (GetPos = GetLength) then Rewind;

    PrepareMCI(FALSE);
    MCIFlags := MCIFlags or mci_Anim_Step_Frames;
    if Frames < 0 then
      MCIFlags := MCIFlags or mci_Anim_Step_Reverse;
    MCIAnimStepParms.dwFrames := Abs(Frames);
    MCIAnimStepParms.dwCallback := Handle;
    MCIError := mciSendCommand(MCIDeviceID, mci_Step, MCIFlags, DWORD(@MCIAnimStepParms));
  end;
end;

procedure TMMedia.Resume;
var
  MCIGenericParms: TMCI_Generic_Parms;
begin
  PrepareMCI(TRUE);
  MCIGenericParms.dwCallback := Handle;
  MCIError := mciSendCommand(MCIDeviceID, mci_Resume, MCIFlags, DWORD(@MCIGenericParms));
  if MCIError <> 0 then Play
end;

procedure TMMedia.Rec;
var
  MCIRecordParms: TMCI_Record_Parms;
begin
  PrepareMCI(TRUE);
  if MCIUseStartPos then
  begin
    MCIFlags := MCIFlags or mci_From;
    MCIRecordParms.dwFrom := MCIStartPos;
    MCIUseStartPos := FALSE;
  end;
  if MCIUseEndPos then
  begin
    MCIFlags := MCIFlags or mci_To;
    MCIRecordParms.dwTo := MCIEndPos;
    MCIUseEndPos := FALSE;
  end;
  MCIRecordParms.dwCallback := Handle;
  MCIError := mciSendCommand(MCIDeviceID, mci_Record, MCIFlags, DWORD(@MCIRecordParms));
end;

procedure TMMedia.Stop;
var
  MCIGenericParms: TMCI_Generic_Parms;
begin
  PrepareMCI(TRUE);
  MCIGenericParms.dwCallback := Handle;
  MCIError := mciSendCommand(MCIDeviceID, mci_Stop, MCIFlags, DWORD(@MCIGenericParms));
end;

procedure TMMedia.Pause;
var
  MCIGenericParms: TMCI_Generic_Parms;
begin
  PrepareMCI(TRUE);
  MCIGenericParms.dwCallback := Handle;
  MCIError := mciSendCommand(MCIDeviceID, mci_Pause, MCIFlags, DWORD(@MCIGenericParms));
end;

procedure TMMedia.SetDoorOpen;
var
  MCISetParms: TMCI_Set_Parms;
  MCIDeviceCaps: TMCIDeviceCaps;
begin
  GetDeviceCaps(MCIDeviceCaps);
  if MCIDeviceCaps.CanEject then
  begin
    PrepareMCI(TRUE);
    MCIFlags := MCIFlags or mci_Set_Door_Open;
    MCISetParms.dwCallback := Handle;
    MCIError := mciSendCommand(MCIDeviceID, mci_Set, MCIFlags, DWORD(@MCISetParms));
  end;
end;

procedure TMMedia.SetDoorClosed;
var
  MCISetParms: TMCI_Set_Parms;
  MCIDeviceCaps: TMCIDeviceCaps;
begin
  GetDeviceCaps(MCIDeviceCaps);
  if MCIDeviceCaps.CanEject then
  begin
    PrepareMCI(TRUE);
    MCIFlags := MCIFlags or mci_Set_Door_Closed;
    MCISetParms.dwCallback := Handle;
    MCIError := mciSendCommand(MCIDeviceID, mci_Set, MCIFlags, DWORD(@MCISetParms));
  end;
end;

function TMMedia.CDMediaIsPresent: Boolean;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  if MCIDevice = MCI_CDAudio then
  begin
    MCIFlags := mci_Wait or mci_Status_Item;
    MCIStatusParms.dwItem := MCI_STATUS_MEDIA_PRESENT;
    MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
    Result := Boolean(MCIStatusParms.dwReturn);
  end else
    Result := FALSE;
end;

function TMMedia.GetTrackFormat(TrackNo: DWORD): DWORD;
var
  MCIStatusParms: TMCI_Status_Parms;
begin
  if MCIDevice = MCI_CDAudio then
  begin
    MCIFlags := mci_Wait or mci_Status_Item or MCI_TRACK;
    MCIStatusParms.dwItem := MCI_CDA_STATUS_TYPE_TRACK;
    MCIStatusParms. dwTrack := TrackNo;
    MCIError := mciSendCommand(MCIDeviceID, mci_Status, MCIFlags, DWORD(@MCIStatusParms));
    Result := MCIStatusParms.dwReturn;
  end;
end;

function TMMedia.GetFirstAudioTrack: DWORD;
var
  i, TracksCnt: DWord;
begin
  if MCIDevice = MCI_CDAudio then
  begin
    i := 1;
    TracksCnt := GetTracksCount;
    while (GetTrackFormat(i) <> MCI_CDA_TRACK_AUDIO) and (i <= TracksCnt) do i +:= 1;
    if i < TracksCnt then
    begin
      Result := i;
      exit;
    end;
  end;
  Result := 0;
end;

function TMMedia.GotoFirstAudioTrack: Boolean;
var
  FirstAudioTrack: DWORD;
begin
  if (GetDevice = MCI_CDAudio) and (CDMediaIsPresent) then
  begin
    FirstAudioTrack := GetFirstAudioTrack;
    if FirstAudioTrack <> 0 then
    begin
      if FirstAudioTrack > mci_TMSF_Track(GetPos) then SetPos(GetTrackPos(FirstAudioTrack));
      Result := TRUE;
      exit;
    end;
  end;
  Result := FALSE;
end;

procedure TMMedia.Save(FileName: String);
var
  MCISaveParms: TMCI_SaveParms;
  Temp: array [0..MAX_PATH] of Char;
begin
  if FileName <> '' then
  begin
    MCISaveParms.lpfilename := StrPCopy(Temp, FileName);
    PrepareMCI(TRUE);
    MCISaveParms.dwCallback := Handle;
    MCIFlags := MCIFlags or mci_Save_File;
    MCIError := mciSendCommand(MCIDeviceID, mci_Save, MCIFlags, DWORD(@MCISaveParms));
  end;
end;

procedure TMMedia.SetDisplayRect(DisplayRect: TRect);
var
  MCIAnimRectParms: TMCI_Anim_Rect_Parms;
  MCIDeviceCaps: TMCIDeviceCaps;
  WorkR: TRect;
begin
  GetDeviceCaps(MCIDeviceCaps);
  if MCIDeviceOpened and MCIDeviceCaps.HasVideo then
  begin
    if (DisplayRect.Bottom = 0) and (DisplayRect.Right = 0) then
    begin
      WorkR.Left   := DisplayRect.Left;
      WorkR.Top    := DisplayRect.Top;
      WorkR.Right  := MCIDeviceCaps.ActiveRectWidth  - 1;
      WorkR.Bottom := MCIDeviceCaps.ActiveRectHeight - 1;
    end else
      WorkR := DisplayRect;
    MCIFlags := mci_Anim_RECT or mci_Anim_Put_Destination;
    MCIAnimRectParms.rc := WorkR;
    MCIError := mciSendCommand(MCIDeviceID, mci_Put, MCIFlags, DWORD(@MCIAnimRectParms));
  end;
end;

function TMMedia.ErrorCode: UINT;
begin
  Result := MCIError;
end;

procedure TMMedia.SetDevice(Device: DWORD);
begin
  if MCIDevice in [MCI_AutoSelect..MCI_WaveAudio] then MCIDevice := Device;
end;

function TMMedia.GetDevice: DWORD;
begin
  Result := MCIDevice;
end;

function TMMedia.GetDeviceID: DWORD;
begin
  Result := MCIDeviceID;
end;

end.
