(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit Library Uint for Print APIs              *)
(*       Based on winspool.h                                    *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit WinSpool;

interface

uses Windows;

const
  winspldrv = 'winspool.drv';

  PRINTER_CONTROL_PAUSE = $01;
  PRINTER_CONTROL_RESUME = $02;
  PRINTER_CONTROL_PURGE = $03;
  PRINTER_CONTROL_SET_STATUS = $04;

  PRINTER_STATUS_PAUSED = $00000001;
  PRINTER_STATUS_ERROR = $00000002;
  PRINTER_STATUS_PENDING_DELETION = $00000004;
  PRINTER_STATUS_PAPER_JAM = $00000008;
  PRINTER_STATUS_PAPER_OUT = $00000010;
  PRINTER_STATUS_MANUAL_FEED = $00000020;
  PRINTER_STATUS_PAPER_PROBLEM = $00000040;
  PRINTER_STATUS_OFFLINE = $00000080;
  PRINTER_STATUS_IO_ACTIVE = $00000100;
  PRINTER_STATUS_BUSY = $00000200;
  PRINTER_STATUS_PRINTING = $00000400;
  PRINTER_STATUS_OUTPUT_BIN_FULL = $00000800;
  PRINTER_STATUS_NOT_AVAILABLE = $00001000;
  PRINTER_STATUS_WAITING = $00002000;
  PRINTER_STATUS_PROCESSING = $00004000;
  PRINTER_STATUS_INITIALIZING = $00008000;
  PRINTER_STATUS_WARMING_UP = $00010000;
  PRINTER_STATUS_TONER_LOW = $00020000;
  PRINTER_STATUS_NO_TONER = $00040000;
  PRINTER_STATUS_PAGE_PUNT = $00080000;
  PRINTER_STATUS_USER_INTERVENTION = $00100000;
  PRINTER_STATUS_OUT_OF_MEMORY = $00200000;
  PRINTER_STATUS_DOOR_OPEN = $00400000;
  PRINTER_STATUS_SERVER_UNKNOWN = $00800000;
  PRINTER_STATUS_POWER_SAVE = $01000000;

  PRINTER_ATTRIBUTE_QUEUED = $00000001;
  PRINTER_ATTRIBUTE_DIRECT = $00000002;
  PRINTER_ATTRIBUTE_DEFAULT = $00000004;
  PRINTER_ATTRIBUTE_SHARED = $00000008;
  PRINTER_ATTRIBUTE_NETWORK = $00000010;
  PRINTER_ATTRIBUTE_HIDDEN = $00000020;
  PRINTER_ATTRIBUTE_LOCAL = $00000040;

  PRINTER_ATTRIBUTE_ENABLE_DEVQ = $00000080;
  PRINTER_ATTRIBUTE_KEEPPRINTEDJOBS = $00000100;
  PRINTER_ATTRIBUTE_DO_COMPLETE_FIRST = $00000200;

  PRINTER_ATTRIBUTE_WORK_OFFLINE = $00000400;
  PRINTER_ATTRIBUTE_ENABLE_BIDI = $00000800;

  NO_PRIORITY = 0;
  MAX_PRIORITY = $63;
  MIN_PRIORITY = $01;
  DEF_PRIORITY = $01;

  JOB_CONTROL_PAUSE = $01;
  JOB_CONTROL_RESUME = $02;
  JOB_CONTROL_CANCEL = $03;
  JOB_CONTROL_RESTART = $04;
  JOB_CONTROL_DELETE = $05;

  JOB_STATUS_PAUSED = $00000001;
  JOB_STATUS_ERROR = $00000002;
  JOB_STATUS_DELETING = $00000004;
  JOB_STATUS_SPOOLING = $00000008;
  JOB_STATUS_PRINTING = $00000010;
  JOB_STATUS_OFFLINE = $00000020;
  JOB_STATUS_PAPEROUT = $00000040;
  JOB_STATUS_PRINTED = $00000080;
  JOB_STATUS_DELETED = $00000100;
  JOB_STATUS_BLOCKED_DEVQ = $00000200;
  JOB_STATUS_USER_INTERVENTION = $00000400;

  JOB_POSITION_UNSPECIFIED = 0;

  DI_CHANNEL = $01;
  DI_CHANNEL_WRITE = $02;
  DI_READ_SPOOL_JOB = $03;

  FORM_BUILTIN = $00000001;

  PORT_TYPE_WRITE = $0001;
  PORT_TYPE_READ = $0002;
  PORT_TYPE_REDIRECTED = $0004;
  PORT_TYPE_NET_ATTACHED = $0008;

  PRINTER_ENUM_DEFAULT = $00000001;
  PRINTER_ENUM_LOCAL = $00000002;
  PRINTER_ENUM_CONNECTIONS = $00000004;
  PRINTER_ENUM_FAVORITE = $00000004;
  PRINTER_ENUM_NAME = $00000008;
  PRINTER_ENUM_REMOTE = $00000010;
  PRINTER_ENUM_SHARED = $00000020;
  PRINTER_ENUM_NETWORK = $00000040;

  PRINTER_ENUM_EXPAND = $00004000;
  PRINTER_ENUM_CONTAINER = $00008000;

  PRINTER_ENUM_ICONMASK = $00FF0000;
  PRINTER_ENUM_ICON1 = $00010000;
  PRINTER_ENUM_ICON2 = $00020000;
  PRINTER_ENUM_ICON3 = $00040000;
  PRINTER_ENUM_ICON4 = $00080000;
  PRINTER_ENUM_ICON5 = $00100000;
  PRINTER_ENUM_ICON6 = $00200000;
  PRINTER_ENUM_ICON7 = $00400000;
  PRINTER_ENUM_ICON8 = $00800000;

  PRINTER_NOTIFY_TYPE = $00;
  JOB_NOTIFY_TYPE = $01;

  PRINTER_NOTIFY_FIELD_SERVER_NAME = $00;
  PRINTER_NOTIFY_FIELD_PRINTER_NAME = $01;
  PRINTER_NOTIFY_FIELD_SHARE_NAME = $02;
  PRINTER_NOTIFY_FIELD_PORT_NAME = $03;
  PRINTER_NOTIFY_FIELD_DRIVER_NAME = $04;
  PRINTER_NOTIFY_FIELD_COMMENT = $05;
  PRINTER_NOTIFY_FIELD_LOCATION = $06;
  PRINTER_NOTIFY_FIELD_DEVMODE = $07;
  PRINTER_NOTIFY_FIELD_SEPFILE = $08;
  PRINTER_NOTIFY_FIELD_PRINT_PROCESSOR = $09;
  PRINTER_NOTIFY_FIELD_PARAMETERS = $0A;
  PRINTER_NOTIFY_FIELD_DATATYPE = $0B;
  PRINTER_NOTIFY_FIELD_SECURITY_DESCRIPTOR = $0C;
  PRINTER_NOTIFY_FIELD_ATTRIBUTES = $0D;
  PRINTER_NOTIFY_FIELD_PRIORITY = $0E;
  PRINTER_NOTIFY_FIELD_DEFAULT_PRIORITY = $0F;
  PRINTER_NOTIFY_FIELD_START_TIME = $10;
  PRINTER_NOTIFY_FIELD_UNTIL_TIME = $11;
  PRINTER_NOTIFY_FIELD_STATUS = $12;
  PRINTER_NOTIFY_FIELD_STATUS_STRING = $13;
  PRINTER_NOTIFY_FIELD_CJOBS = $14;
  PRINTER_NOTIFY_FIELD_AVERAGE_PPM = $15;
  PRINTER_NOTIFY_FIELD_TOTAL_PAGES = $16;
  PRINTER_NOTIFY_FIELD_PAGES_PRINTED = $17;
  PRINTER_NOTIFY_FIELD_TOTAL_BYTES = $18;
  PRINTER_NOTIFY_FIELD_BYTES_PRINTED = $19;

  JOB_NOTIFY_FIELD_PRINTER_NAME = $00;
  JOB_NOTIFY_FIELD_MACHINE_NAME = $01;
  JOB_NOTIFY_FIELD_PORT_NAME = $02;
  JOB_NOTIFY_FIELD_USER_NAME = $03;
  JOB_NOTIFY_FIELD_NOTIFY_NAME = $04;
  JOB_NOTIFY_FIELD_DATATYPE = $05;
  JOB_NOTIFY_FIELD_PRINT_PROCESSOR = $06;
  JOB_NOTIFY_FIELD_PARAMETERS = $07;
  JOB_NOTIFY_FIELD_DRIVER_NAME = $08;
  JOB_NOTIFY_FIELD_DEVMODE = $09;
  JOB_NOTIFY_FIELD_STATUS = $0A;
  JOB_NOTIFY_FIELD_STATUS_STRING = $0B;
  JOB_NOTIFY_FIELD_SECURITY_DESCRIPTOR = $0C;
  JOB_NOTIFY_FIELD_DOCUMENT = $0D;
  JOB_NOTIFY_FIELD_PRIORITY = $0E;
  JOB_NOTIFY_FIELD_POSITION = $0F;
  JOB_NOTIFY_FIELD_SUBMITTED = $10;
  JOB_NOTIFY_FIELD_START_TIME = $11;
  JOB_NOTIFY_FIELD_UNTIL_TIME = $12;
  JOB_NOTIFY_FIELD_TIME = $13;
  JOB_NOTIFY_FIELD_TOTAL_PAGES = $14;
  JOB_NOTIFY_FIELD_PAGES_PRINTED = $15;
  JOB_NOTIFY_FIELD_TOTAL_BYTES = $16;
  JOB_NOTIFY_FIELD_BYTES_PRINTED = $17;

  PRINTER_NOTIFY_OPTIONS_REFRESH = $01;
  PRINTER_NOTIFY_INFO_DISCARDED = $01;

  PRINTER_CHANGE_ADD_PRINTER = $00000001;
  PRINTER_CHANGE_SET_PRINTER = $00000002;
  PRINTER_CHANGE_DELETE_PRINTER = $00000004;
  PRINTER_CHANGE_FAILED_CONNECTION_PRINTER = $00000008;
  PRINTER_CHANGE_PRINTER = $000000FF;
  PRINTER_CHANGE_ADD_JOB = $00000100;
  PRINTER_CHANGE_SET_JOB = $00000200;
  PRINTER_CHANGE_DELETE_JOB = $00000400;
  PRINTER_CHANGE_WRITE_JOB = $00000800;
  PRINTER_CHANGE_JOB = $0000FF00;
  PRINTER_CHANGE_ADD_FORM = $00010000;
  PRINTER_CHANGE_SET_FORM = $00020000;
  PRINTER_CHANGE_DELETE_FORM = $00040000;
  PRINTER_CHANGE_FORM = $00070000;
  PRINTER_CHANGE_ADD_PORT = $00100000;
  PRINTER_CHANGE_CONFIGURE_PORT = $00200000;
  PRINTER_CHANGE_DELETE_PORT = $00400000;
  PRINTER_CHANGE_PORT = $00700000;
  PRINTER_CHANGE_ADD_PRINT_PROCESSOR = $01000000;
  PRINTER_CHANGE_DELETE_PRINT_PROCESSOR = $04000000;
  PRINTER_CHANGE_PRINT_PROCESSOR = $07000000;
  PRINTER_CHANGE_ADD_PRINTER_DRIVER = $10000000;
  PRINTER_CHANGE_SET_PRINTER_DRIVER = $20000000;
  PRINTER_CHANGE_DELETE_PRINTER_DRIVER = $40000000;
  PRINTER_CHANGE_PRINTER_DRIVER = $70000000;
  PRINTER_CHANGE_TIMEOUT = $80000000;
  PRINTER_CHANGE_ALL = $7777FFFF;

  PRINTER_ERROR_INFORMATION = $80000000;
  PRINTER_ERROR_WARNING = $40000000;
  PRINTER_ERROR_SEVERE = $20000000;

  PRINTER_ERROR_OUTOFPAPER = $00000001;
  PRINTER_ERROR_JAM = $00000002;
  PRINTER_ERROR_OUTOFTONER = $00000004;

  SERVER_ACCESS_ADMINISTER = $00000001;

  SERVER_ACCESS_ENUMERATE = $00000002;
  PRINTER_ACCESS_ADMINISTER = $00000004;
  PRINTER_ACCESS_USE = $00000008;
  JOB_ACCESS_ADMINISTER = $00000010;

 /*
  * SetPrinterData and GetPrinterData Server Handle Key values
  */
  SPLREG_DEFAULT_SPOOL_DIRECTORY = 'DefaultSpoolDirectory';
  SPLREG_PORT_THREAD_PRIORITY_DEFAULT = 'PortThreadPriorityDefault';
  SPLREG_PORT_THREAD_PRIORITY = 'PortThreadPriority';
  SPLREG_SCHEDULER_THREAD_PRIORITY_DEFAULT = 'SchedulerThreadPriorityDefault';
  SPLREG_SCHEDULER_THREAD_PRIORITY = 'SchedulerThreadPriority';
  SPLREG_BEEP_ENABLED = 'BeepEnabled';
  SPLREG_NET_POPUP = 'NetPopup';
  SPLREG_EVENT_LOG = 'EventLog';
  SPLREG_MAJOR_VERSION = 'MajorVersion';
  SPLREG_MINOR_VERSION = 'MinorVersion';
  SPLREG_ARCHITECTURE = 'Architecture';

 /*
  * Access rights for print servers
  */
  SERVER_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SERVER_ACCESS_ADMINISTER or SERVER_ACCESS_ENUMERATE);
  SERVER_READ = (STANDARD_RIGHTS_READ or SERVER_ACCESS_ENUMERATE);
  SERVER_WRITE = (STANDARD_RIGHTS_WRITE or SERVER_ACCESS_ADMINISTER or SERVER_ACCESS_ENUMERATE);
  SERVER_EXECUTE = (STANDARD_RIGHTS_EXECUTE or SERVER_ACCESS_ENUMERATE);

 /*
  * Access rights for printers
  */
  PRINTER_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or PRINTER_ACCESS_ADMINISTER or PRINTER_ACCESS_USE);
  PRINTER_READ = (STANDARD_RIGHTS_READ or PRINTER_ACCESS_USE);
  PRINTER_WRITE = (STANDARD_RIGHTS_WRITE or PRINTER_ACCESS_USE);
  PRINTER_EXECUTE = (STANDARD_RIGHTS_EXECUTE or PRINTER_ACCESS_USE);

 /*
  * Access rights for jobs
  */
  JOB_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or JOB_ACCESS_ADMINISTER);
  JOB_READ = (STANDARD_RIGHTS_READ or JOB_ACCESS_ADMINISTER);
  JOB_WRITE = (STANDARD_RIGHTS_WRITE or JOB_ACCESS_ADMINISTER);
  JOB_EXECUTE = (STANDARD_RIGHTS_EXECUTE or JOB_ACCESS_ADMINISTER);

type
  PPrinterInfo1A = ^TPrinterInfo1A;
  PPrinterInfo1W = ^TPrinterInfo1W;
  PPrinterInfo1 = PPrinterInfo1A;
  TPrinterInfo1A = record
    Flags: DWORD;
    pDescription: PAnsiChar;
    pName: PAnsiChar;
    pComment: PAnsiChar;
  end;
  TPrinterInfo1W = record
    Flags: DWORD;
    pDescription: PWideChar;
    pName: PWideChar;
    pComment: PWideChar;
  end;
  TPrinterInfo1 = TPrinterInfo1A;

  PPrinterInfo2A = ^TPrinterInfo2A;
  PPrinterInfo2W = ^TPrinterInfo2W;
  PPrinterInfo2 = PPrinterInfo2A;
  TPrinterInfo2A = record
    pServerName: PAnsiChar;
    pPrinterName: PAnsiChar;
    pShareName: PAnsiChar;
    pPortName: PAnsiChar;
    pDriverName: PAnsiChar;
    pComment: PAnsiChar;
    pLocation: PAnsiChar;
    pDevMode: PDeviceModeA;
    pSepFile: PAnsiChar;
    pPrintProcessor: PAnsiChar;
    pDatatype: PAnsiChar;
    pParameters: PAnsiChar;
    pSecurityDescriptor: PSecurityDescriptor;
    Attributes: DWORD;
    Priority: DWORD;
    DefaultPriority: DWORD;
    StartTime: DWORD;
    UntilTime: DWORD;
    Status: DWORD;
    cJobs: DWORD;
    AveragePPM: DWORD;
  end;
  TPrinterInfo2W = record
    pServerName: PWideChar;
    pPrinterName: PWideChar;
    pShareName: PWideChar;
    pPortName: PWideChar;
    pDriverName: PWideChar;
    pComment: PWideChar;
    pLocation: PWideChar;
    pDevMode: PDeviceModeW;
    pSepFile: PWideChar;
    pPrintProcessor: PWideChar;
    pDatatype: PWideChar;
    pParameters: PWideChar;
    pSecurityDescriptor: PSecurityDescriptor;
    Attributes: DWORD;
    Priority: DWORD;
    DefaultPriority: DWORD;
    StartTime: DWORD;
    UntilTime: DWORD;
    Status: DWORD;
    cJobs: DWORD;
    AveragePPM: DWORD;
  end;
  TPrinterInfo2 = TPrinterInfo2A;

  PPrinterInfo3A = ^TPrinterInfo3A;
  PPrinterInfo3W = ^TPrinterInfo3W;
  PPrinterInfo3 = PPrinterInfo3A;
  TPrinterInfo3A = record
    pSecurityDescriptor: PSecurityDescriptor;
  end;
  TPrinterInfo3W = record
    pSecurityDescriptor: PSecurityDescriptor;
  end;
  TPrinterInfo3 = TPrinterInfo3A;

  PPrinterInfo4A = ^TPrinterInfo4A;
  PPrinterInfo4W = ^TPrinterInfo4W;
  PPrinterInfo4 = PPrinterInfo4A;
  TPrinterInfo4A = record
    pPrinterName: PAnsiChar;
    pServerName: PAnsiChar;
    Attributes: DWORD;
  end;
  TPrinterInfo4W = record
    pPrinterName: PWideChar;
    pServerName: PWideChar;
    Attributes: DWORD;
  end;
  TPrinterInfo4 = TPrinterInfo4A;

  PPrinterInfo5A = ^TPrinterInfo5A;
  PPrinterInfo5W = ^TPrinterInfo5W;
  PPrinterInfo5 = PPrinterInfo5A;
  TPrinterInfo5A = record
    pPrinterName: PAnsiChar;
    pPortName: PAnsiChar;
    Attributes: DWORD;
    DeviceNotSelectedTimeout: DWORD;
    TransmissionRetryTimeout: DWORD;
  end;
  TPrinterInfo5W = record
    pPrinterName: PWideChar;
    pPortName: PWideChar;
    Attributes: DWORD;
    DeviceNotSelectedTimeout: DWORD;
    TransmissionRetryTimeout: DWORD;
  end;
  TPrinterInfo5 = TPrinterInfo5A;

  PJobInfo1A = ^TJobInfo1A;
  PJobInfo1W = ^TJobInfo1W;
  PJobInfo1 = PJobInfo1A;
  TJobInfo1A = record
   JobId: DWORD;
   pPrinterName: PAnsiChar;
   pMachineName: PAnsiChar;
   pUserName: PAnsiChar;
   pDocument: PAnsiChar;
   pDatatype: PAnsiChar;
   pStatus: PAnsiChar;
   Status: DWORD;
   Priority: DWORD;
   Position: DWORD;
   TotalPages: DWORD;
   PagesPrinted: DWORD;
   Submitted: TSystemTime;
  end;
  TJobInfo1W = record
   JobId: DWORD;
   pPrinterName: PWideChar;
   pMachineName: PWideChar;
   pUserName: PWideChar;
   pDocument: PWideChar;
   pDatatype: PWideChar;
   pStatus: PWideChar;
   Status: DWORD;
   Priority: DWORD;
   Position: DWORD;
   TotalPages: DWORD;
   PagesPrinted: DWORD;
   Submitted: TSystemTime;
  end;
  TJobInfo1 = TJobInfo1A;

  PJobInfo2A = ^TJobInfo2A;
  PJobInfo2W = ^TJobInfo2W;
  PJobInfo2 = PJobInfo2A;
  TJobInfo2A = record
   JobId: DWORD;
   pPrinterName: PAnsiChar;
   pMachineName: PAnsiChar;
   pUserName: PAnsiChar;
   pDocument: PAnsiChar;
   pNotifyName: PAnsiChar;
   pDatatype: PAnsiChar;
   pPrintProcessor: PAnsiChar;
   pParameters: PAnsiChar;
   pDriverName: PAnsiChar;
   pDevMode: PDeviceModeA;
   pStatus: PAnsiChar;
   pSecurityDescriptor: PSECURITY_DESCRIPTOR;
   Status: DWORD;
   Priority: DWORD;
   Position: DWORD;
   StartTime: DWORD;
   UntilTime: DWORD;
   TotalPages: DWORD;
   Size: DWORD;
   Submitted: TSystemTime;
   Time: DWORD;
   PagesPrinted: DWORD;
  end;
  TJobInfo2W = record
   JobId: DWORD;
   pPrinterName: PWideChar;
   pMachineName: PWideChar;
   pUserName: PWideChar;
   pDocument: PWideChar;
   pNotifyName: PWideChar;
   pDatatype: PWideChar;
   pPrintProcessor: PWideChar;
   pParameters: PWideChar;
   pDriverName: PWideChar;
   pDevMode: PDeviceModeW;
   pStatus: PWideChar;
   pSecurityDescriptor: PSECURITY_DESCRIPTOR;
   Status: DWORD;
   Priority: DWORD;
   Position: DWORD;
   StartTime: DWORD;
   UntilTime: DWORD;
   TotalPages: DWORD;
   Size: DWORD;
   Submitted: TSystemTime;
   Time: DWORD;
   PagesPrinted: DWORD;
  end;
  TJobInfo2 = TJobInfo2A;

  PAddJobInfo1A = ^TAddJobInfo1A;
  PAddJobInfo1W = ^TAddJobInfo1W;
  PAddJobInfo1 = PAddJobInfo1A;
  TAddJobInfo1A = record
    Path: PAnsiChar;
    JobId: DWORD;
  end;
  TAddJobInfo1W = record
    Path: PWideChar;
    JobId: DWORD;
  end;
  TAddJobInfo1 = TAddJobInfo1A;

  PDriverInfo1A = ^TDriverInfo1A;
  PDriverInfo1W = ^TDriverInfo1W;
  PDriverInfo1 = PDriverInfo1A;
  TDriverInfo1A = record
    pName: PAnsiChar;
  end;
  TDriverInfo1W = record
    pName: PWideChar;
  end;
  TDriverInfo1 = TDriverInfo1A;

  PDriverInfo2A = ^TDriverInfo2A;
  PDriverInfo2W = ^TDriverInfo2W;
  PDriverInfo2 = PDriverInfo2A;
  TDriverInfo2A = record
    cVersion: DWORD;
    pName: PAnsiChar;
    pEnvironment: PAnsiChar;
    pDriverPath: PAnsiChar;
    pDataFile: PAnsiChar;
    pConfigFile: PAnsiChar;
  end;
  TDriverInfo2W = record
    cVersion: DWORD;
    pName: PWideChar;
    pEnvironment: PWideChar;
    pDriverPath: PWideChar;
    pDataFile: PWideChar;
    pConfigFile: PWideChar;
  end;
  TDriverInfo2 = TDriverInfo2A;

  PDriverInfo3A = ^TDriverInfo3A;
  PDriverInfo3W = ^TDriverInfo3W;
  PDriverInfo3 = PDriverInfo3A;
  TDriverInfo3A = record
    cVersion: DWORD;
    pName: PAnsiChar;
    pEnvironment: PAnsiChar;
  pDriverPath: PAnsiChar;
    pDataFile: PAnsiChar;
    pConfigFile: PAnsiChar;
    pHelpFile: PAnsiChar;
    pDependentFiles: PAnsiChar;
    pMonitorName: PAnsiChar;
    pDefaultDataType: PAnsiChar;
  end;
  TDriverInfo3W = record
    cVersion: DWORD;
    pName: PWideChar;
    pEnvironment: PWideChar;
    pDriverPath: PWideChar;
    pDataFile: PWideChar;
    pConfigFile: PWideChar;
    pHelpFile: PWideChar;
    pDependentFiles: PWideChar;
    pMonitorName: PWideChar;
    pDefaultDataType: PWideChar;
  end;
  TDriverInfo3 = TDriverInfo3A;

  PDocInfo1A = ^TDocInfo1A;
  PDocInfo1W = ^TDocInfo1W;
  PDocInfo1 = PDocInfo1A;
  TDocInfo1A = record
    pDocName: PAnsiChar;
    pOutputFile: PAnsiChar;
    pDatatype: PAnsiChar;
  end;
  TDocInfo1W = record
    pDocName: PWideChar;
    pOutputFile: PWideChar;
    pDatatype: PWideChar;
  end;
  TDocInfo1 = TDocInfo1A;

  PFormInfo1A = ^TFormInfo1A;
  PFormInfo1W = ^TFormInfo1W;
  PFormInfo1 = PFormInfo1A;
  TFormInfo1A = record
    Flags: DWORD;
    pName: PAnsiChar;
    Size: TSize;
    ImageableArea: TRect;
  end;
  TFormInfo1W = record
    Flags: DWORD;
    pName: PWideChar;
    Size: TSize;
    ImageableArea: TRect;
  end;
  TFormInfo1 = TFormInfo1A;

  PDocInfo2A = ^TDocInfo2A;
  PDocInfo2W = ^TDocInfo2W;
  PDocInfo2 = PDocInfo2A;
  TDocInfo2A = record
    pDocName: PAnsiChar;
    pOutputFile: PAnsiChar;
    pDatatype: PAnsiChar;
    dwMode: DWORD;
    JobId: DWORD;
  end;
  TDocInfo2W = record
    pDocName: PWideChar;
    pOutputFile: PWideChar;
    pDatatype: PWideChar;
    dwMode: DWORD;
    JobId: DWORD;
  end;
  TDocInfo2 = TDocInfo2A;

  PPrintProcessorInfo1A = ^TPrintProcessorInfo1A;
  PPrintProcessorInfo1W = ^TPrintProcessorInfo1W;
  PPrintProcessorInfo1 = PPrintProcessorInfo1A;
  TPrintProcessorInfo1A = record
    pName: PAnsiChar;
  end;
  TPrintProcessorInfo1W = record
    pName: PWideChar;
  end;
  TPrintProcessorInfo1 = TPrintProcessorInfo1A;

  PPortInfo1A = ^TPortInfo1A;
  PPortInfo1W = ^TPortInfo1W;
  PPortInfo1 = PPortInfo1A;
  TPortInfo1A = record
    pName: PAnsiChar;
  end;
  TPortInfo1W = record
    pName: PWideChar;
  end;
  TPortInfo1 = TPortInfo1A;

  PPortInfo2A = ^TPortInfo2A;
  PPortInfo2W = ^TPortInfo2W;
  PPortInfo2 = PPortInfo2A;
  TPortInfo2A = record
    pPortName: PAnsiChar;
    pMonitorName: PAnsiChar;
    pDescription: PAnsiChar;
    fPortType: DWORD;
    Reserved: DWORD;
  end;
  TPortInfo2W = record
    pPortName: PWideChar;
    pMonitorName: PWideChar;
    pDescription: PWideChar;
    fPortType: DWORD;
    Reserved: DWORD;
  end;
  TPortInfo2 = TPortInfo2A;

  PMonitorInfo1A = ^TMonitorInfo1A;
  PMonitorInfo1W = ^TMonitorInfo1W;
  PMonitorInfo1 = PMonitorInfo1A;
  TMonitorInfo1A = record
    pName: PAnsiChar;
  end;
  TMonitorInfo1W = record
    pName: PWideChar;
  end;
  TMonitorInfo1 = TMonitorInfo1A;

  PMonitorInfo2A = ^TMonitorInfo2A;
  PMonitorInfo2W = ^TMonitorInfo2W;
  PMonitorInfo2 = PMonitorInfo2A;
  TMonitorInfo2A = record
    pName: PAnsiChar;
    pEnvironment: PAnsiChar;
    pDLLName: PAnsiChar;
  end;
  TMonitorInfo2W = record
    pName: PWideChar;
    pEnvironment: PWideChar;
    pDLLName: PWideChar;
  end;
  TMonitorInfo2 = TMonitorInfo2A;

  PDatatypesInfo1A = ^TDatatypesInfo1A;
  PDatatypesInfo1W = ^TDatatypesInfo1W;
  PDatatypesInfo1 = PDatatypesInfo1A;
  TDatatypesInfo1A = record
    pName: PAnsiChar;
  end;
  TDatatypesInfo1W = record
    pName: PWideChar;
  end;
  TDatatypesInfo1 = TDatatypesInfo1A;

  PPrinterDefaultsA = ^TPrinterDefaultsA;
  PPrinterDefaultsW = ^TPrinterDefaultsW;
  PPrinterDefaults = PPrinterDefaultsA;
  TPrinterDefaultsA = record
    pDatatype: PAnsiChar;
    pDevMode: PDeviceModeA;
    DesiredAccess: ACCESS_MASK;
  end;
  TPrinterDefaultsW = record
    pDatatype: PWideChar;
    pDevMode: PDeviceModeW;
    DesiredAccess: ACCESS_MASK;
  end;
  TPrinterDefaults = TPrinterDefaultsA;

  PPrinterNotifyOptionsType = ^TPrinterNotifyOptionsType;
  TPrinterNotifyOptionsType = record
    wType: Word;
    Reserved0: Word;
    Reserved1: DWORD;
    Reserved2: DWORD;
    Count: DWORD;
    pFields: PWord;
  end;

  PPrinterNotifyOptions = ^TPrinterNotifyOptions;
  TPrinterNotifyOptions = record
    Version: DWORD;
    Flags: DWORD;
    Count: DWORD;
    pTypes: PPrinterNotifyOptionsType;
  end;

  PPrinterNotifyInfoData = ^TPrinterNotifyInfoData;
  TPrinterNotifyInfoData = record
    wType: Word;
    Field: Word;
    Reserved: DWORD;
    Id: DWORD;
    NotifyData: record
      case Longint of
        0: (adwData: array[0..1] of DWORD);
        1: (Data: record
              cbBuf: DWORD;
              pBuf: Pointer;
            end);
    end;
  end;

  PPrinterNotifyInfo = ^TPrinterNotifyInfo;
  TPrinterNotifyInfo = record
    Version: DWORD;
    Flags: DWORD;
    Count: DWORD;
    aData: array[0..0] of TPrinterNotifyInfoData;
  end;

  PProvidorInfo1A = ^TProvidorInfo1A;
  PProvidorInfo1W = ^TProvidorInfo1W;
  PProvidorInfo1 = PProvidorInfo1A;
  TProvidorInfo1A = record
    pName: PAnsiChar;
    pEnvironment: PAnsiChar;
    pDLLName: PAnsiChar;
  end;
  TProvidorInfo1W = record
    pName: PWideChar;
    pEnvironment: PWideChar;
    pDLLName: PWideChar;
  end;
  TProvidorInfo1 = TProvidorInfo1A;

function AbortPrinter conv arg_stdcall (hPrinter: THandle): BOOL;
  external winspldrv name 'AbortPrinter';

function AddFormA conv arg_stdcall (hPrinter: THandle; Level: DWORD; pForm: Pointer): BOOL;
  external winspldrv name 'AddFormA';

function AddFormW conv arg_stdcall (hPrinter: THandle; Level: DWORD; pForm: Pointer): BOOL;
  external winspldrv name 'AddFormW';

function AddForm conv arg_stdcall (hPrinter: THandle; Level: DWORD; pForm: Pointer): BOOL;
  external winspldrv name 'AddFormA';

function AddJobA conv arg_stdcall (hPrinter: THandle; Level: DWORD; pData: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'AddJobA';

function AddJobW conv arg_stdcall (hPrinter: THandle; Level: DWORD; pData: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'AddJobW';

function AddJob conv arg_stdcall (hPrinter: THandle; Level: DWORD; pData: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'AddJobA';

function AddMonitorA conv arg_stdcall (pName: PAnsiChar; Level: DWORD; pMonitors: Pointer): BOOL;
  external winspldrv name 'AddMonitorA';

function AddMonitorW conv arg_stdcall (pName: PWideChar; Level: DWORD; pMonitors: Pointer): BOOL;
  external winspldrv name 'AddMonitorW';

function AddMonitor conv arg_stdcall (pName: PChar; Level: DWORD; pMonitors: Pointer): BOOL;
  external winspldrv name 'AddMonitorA';

function AddPortA conv arg_stdcall (pName: PAnsiChar; hWnd: HWND; pMonitorName: PAnsiChar): BOOL;
  external winspldrv name 'AddPortA';

function AddPortW conv arg_stdcall (pName: PWideChar; hWnd: HWND; pMonitorName: PWideChar): BOOL;
  external winspldrv name 'AddPortW';

function AddPort conv arg_stdcall (pName: PChar; hWnd: HWND; pMonitorName: PChar): BOOL;
  external winspldrv name 'AddPortA';

function AddPrinterA conv arg_stdcall (pName: PAnsiChar; Level: DWORD; pPrinter: Pointer): THandle;
  external winspldrv name 'AddPrinterA';

function AddPrinterW conv arg_stdcall (pName: PWideChar; Level: DWORD; pPrinter: Pointer): THandle;
  external winspldrv name 'AddPrinterW';

function AddPrinter conv arg_stdcall (pName: PChar; Level: DWORD; pPrinter: Pointer): THandle;
  external winspldrv name 'AddPrinterA';

function AddPrinterConnectionA conv arg_stdcall (pName: PAnsiChar): BOOL;
  external winspldrv name 'AddPrinterConnectionA';

function AddPrinterConnectionW conv arg_stdcall (pName: PWideChar): BOOL;
  external winspldrv name 'AddPrinterConnectionW';

function AddPrinterConnection conv arg_stdcall (pName: PChar): BOOL;
  external winspldrv name 'AddPrinterConnectionA';

function AddPrinterDriverA conv arg_stdcall (pName: PAnsiChar; Level: DWORD; pDriverInfo: Pointer): BOOL;
  external winspldrv name 'AddPrinterDriverA';

function AddPrinterDriverW conv arg_stdcall (pName: PWideChar; Level: DWORD; pDriverInfo: Pointer): BOOL;
  external winspldrv name 'AddPrinterDriverW';

function AddPrinterDriver conv arg_stdcall (pName: PChar; Level: DWORD; pDriverInfo: Pointer): BOOL;
  external winspldrv name 'AddPrinterDriverA';

function AddPrintProcessorA conv arg_stdcall (pName, pEnvironment, pPathName, pPrintProcessorName: PAnsiChar): BOOL;
  external winspldrv name 'AddPrintProcessorA';

function AddPrintProcessorW conv arg_stdcall (pName, pEnvironment, pPathName, pPrintProcessorName: PWideChar): BOOL;
  external winspldrv name 'AddPrintProcessorW';

function AddPrintProcessor conv arg_stdcall (pName, pEnvironment, pPathName, pPrintProcessorName: PChar): BOOL;
  external winspldrv name 'AddPrintProcessorA';

function AddPrintProvidorA conv arg_stdcall (pName: PAnsiChar; level: DWORD; pProvidorInfo: Pointer): BOOL;
  external winspldrv name 'AddPrintProvidorA';

function AddPrintProvidorW conv arg_stdcall (pName: PWideChar; level: DWORD; pProvidorInfo: Pointer): BOOL;
  external winspldrv name 'AddPrintProvidorW';

function AddPrintProvidor conv arg_stdcall (pName: PChar; level: DWORD; pProvidorInfo: Pointer): BOOL;
  external winspldrv name 'AddPrintProvidorA';

function AdvancedDocumentPropertiesA conv arg_stdcall (hWnd: HWND; hPrinter: THandle; pDeviceName: PAnsiChar;
  pDevModeOutput, pDevModeInput: PDeviceModeA): Longint;
  external winspldrv name 'AdvancedDocumentPropertiesA';

function AdvancedDocumentPropertiesW conv arg_stdcall (hWnd: HWND; hPrinter: THandle; pDeviceName: PWideChar;
  pDevModeOutput, pDevModeInput: PDeviceModeW): Longint;
  external winspldrv name 'AdvancedDocumentPropertiesW';

function AdvancedDocumentProperties conv arg_stdcall (hWnd: HWND; hPrinter: THandle; pDeviceName: PChar;
  pDevModeOutput, pDevModeInput: PDeviceMode): Longint;
  external winspldrv name 'AdvancedDocumentPropertiesA';

function ClosePrinter conv arg_stdcall (hPrinter: THandle): BOOL;
  external winspldrv name 'ClosePrinter';

function ConfigurePortA conv arg_stdcall (pName: PAnsiChar; hWnd: HWND; pPortName: PAnsiChar): BOOL;
  external winspldrv name 'ConfigurePortA';

function ConfigurePortW conv arg_stdcall (pName: PWideChar; hWnd: HWND; pPortName: PWideChar): BOOL;
  external winspldrv name 'ConfigurePortW';

function ConfigurePort conv arg_stdcall (pName: PChar; hWnd: HWND; pPortName: PChar): BOOL;
  external winspldrv name 'ConfigurePortA';

function ConnectToPrinterDlg conv arg_stdcall (hwnd: HWND; Flags: DWORD): THandle;
  external winspldrv name 'ConnectToPrinterDlg';

function DeleteFormA conv arg_stdcall (hPrinter: THandle; pFormName: PAnsiChar): BOOL;
  external winspldrv name 'DeleteFormA';

function DeleteFormW conv arg_stdcall (hPrinter: THandle; pFormName: PWideChar): BOOL;
  external winspldrv name 'DeleteFormW';

function DeleteForm conv arg_stdcall (hPrinter: THandle; pFormName: PChar): BOOL;
  external winspldrv name 'DeleteFormA';

function DeleteMonitorA conv arg_stdcall (pName, pEnvironment, pMonitorName: PAnsiChar): BOOL;
  external winspldrv name 'DeleteMonitorA';

function DeleteMonitorW conv arg_stdcall (pName, pEnvironment, pMonitorName: PWideChar): BOOL;
  external winspldrv name 'DeleteMonitorW';

function DeleteMonitor conv arg_stdcall (pName, pEnvironment, pMonitorName: PChar): BOOL;
  external winspldrv name 'DeleteMonitorA';

function DeletePortA conv arg_stdcall (pName: PAnsiChar; hWnd: HWND; pPortName: PAnsiChar): BOOL;
  external winspldrv name 'DeletePortA';

function DeletePortW conv arg_stdcall (pName: PWideChar; hWnd: HWND; pPortName: PWideChar): BOOL;
  external winspldrv name 'DeletePortW';

function DeletePort conv arg_stdcall (pName: PChar; hWnd: HWND; pPortName: PChar): BOOL; stdcall;
  external winspldrv name 'DeletePortA';

function DeletePrinter conv arg_stdcall (hPrinter: THandle): BOOL;
  external winspldrv name 'DeletePrinter';

function DeletePrinterConnectionA conv arg_stdcall (pName: PAnsiChar): BOOL;
  external winspldrv name 'DeletePrinterConnectionA';

function DeletePrinterConnectionW conv arg_stdcall (pName: PWideChar): BOOL;
  external winspldrv name 'DeletePrinterConnectionW';

function DeletePrinterConnection conv arg_stdcall (pName: PChar): BOOL;
  external winspldrv name 'DeletePrinterConnectionA';

function DeletePrinterDriverA conv arg_stdcall (pName, pEnvironment, pDriverName: PAnsiChar): BOOL;
  external winspldrv name 'DeletePrinterDriverA';

function DeletePrinterDriverW conv arg_stdcall (pName, pEnvironment, pDriverName: PWideChar): BOOL;
  external winspldrv name 'DeletePrinterDriverW';

function DeletePrinterDriver conv arg_stdcall (pName, pEnvironment, pDriverName: PChar): BOOL;
  external winspldrv name 'DeletePrinterDriverA';

function DeletePrintProcessorA conv arg_stdcall (pName, pEnvironment, pPrintProcessorName: PAnsiChar): BOOL;
  external winspldrv name 'DeletePrintProcessorA';

function DeletePrintProcessorW conv arg_stdcall (pName, pEnvironment, pPrintProcessorName: PWideChar): BOOL;
  external winspldrv name 'DeletePrintProcessorW';

function DeletePrintProcessor conv arg_stdcall (pName, pEnvironment, pPrintProcessorName: PChar): BOOL;
  external winspldrv name 'DeletePrintProcessorA';

function DeletePrintProvidorA conv arg_stdcall (pName, pEnvironment, pPrintProvidorName: PAnsiChar): BOOL;
  external winspldrv name 'DeletePrintProvidorA';

function DeletePrintProvidorW conv arg_stdcall (pName, pEnvironment, pPrintProvidorName: PWideChar): BOOL;
  external winspldrv name 'DeletePrintProvidorW';

function DeletePrintProvidor conv arg_stdcall (pName, pEnvironment, pPrintProvidorName: PChar): BOOL;
  external winspldrv name 'DeletePrintProvidorA';

function DocumentPropertiesA conv arg_stdcall (hWnd: HWND; hPrinter: THandle; pDeviceName: PAnsiChar;
  const pDevModeOutput: TDeviceModeA; var pDevModeInput: TDeviceModeA; fMode: DWORD): Longint;
  external winspldrv name 'DocumentPropertiesA';

function DocumentPropertiesW conv arg_stdcall (hWnd: HWND; hPrinter: THandle; pDeviceName: PWideChar;
  const pDevModeOutput: TDeviceModeW; var pDevModeInput: TDeviceModeW; fMode: DWORD): Longint;
  external winspldrv name 'DocumentPropertiesW';

function DocumentProperties conv arg_stdcall (hWnd: HWND; hPrinter: THandle; pDeviceName: PChar;
  const pDevModeOutput: TDeviceMode; var pDevModeInput: TDeviceMode; fMode: DWORD): Longint;
  external winspldrv name 'DocumentPropertiesA';

function EndDocPrinter conv arg_stdcall (hPrinter: THandle): BOOL;
 external winspldrv name 'EndDocPrinter';

function EndPagePrinter conv arg_stdcall (hPrinter: THandle): BOOL;
  external winspldrv name 'EndPagePrinter';

function EnumFormsA conv arg_stdcall (hPrinter: THandle; Level: DWORD; pForm: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumFormsA';

function EnumFormsW conv arg_stdcall (hPrinter: THandle; Level: DWORD; pForm: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumFormsW';

function EnumForms conv arg_stdcall (hPrinter: THandle; Level: DWORD; pForm: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumFormsA';

function EnumJobsA conv arg_stdcall (hPrinter: THandle; FirstJob, NoJobs, Level: DWORD; pJob: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumJobsA';

function EnumJobsW conv arg_stdcall (hPrinter: THandle; FirstJob, NoJobs, Level: DWORD; pJob: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumJobsW';

function EnumJobs conv arg_stdcall (hPrinter: THandle; FirstJob, NoJobs, Level: DWORD; pJob: Pointer; cbBuf: DWORD;
 var pcbNeeded, pcReturned: DWORD): BOOL;
 external winspldrv name 'EnumJobsA';

function EnumMonitorsA conv arg_stdcall (pName: PAnsiChar; Level: DWORD; pMonitors: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumMonitorsA';

function EnumMonitorsW conv arg_stdcall (pName: PWideChar; Level: DWORD; pMonitors: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumMonitorsW';

function EnumMonitors conv arg_stdcall (pName: PChar; Level: DWORD; pMonitors: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumMonitorsA';

function EnumPortsA conv arg_stdcall (pName: PAnsiChar; Level: DWORD; pPorts: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPortsA';

function EnumPortsW conv arg_stdcall (pName: PWideChar; Level: DWORD; pPorts: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPortsW';

function EnumPorts conv arg_stdcall (pName: PChar; Level: DWORD; pPorts: Pointer; cbBuf: DWORD;
  var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPortsA';

function EnumPrinterDriversA conv arg_stdcall (pName, pEnvironment: PAnsiChar; Level: DWORD;
  pDriverInfo: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrinterDriversA';

function EnumPrinterDriversW conv arg_stdcall (pName, pEnvironment: PWideChar; Level: DWORD;
  pDriverInfo: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrinterDriversW';

function EnumPrinterDrivers conv arg_stdcall (pName, pEnvironment: PChar; Level: DWORD;
  pDriverInfo: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrinterDriversA';

function EnumPrintersA conv arg_stdcall (Flags: DWORD; Name: PAnsiChar; Level: DWORD;
  pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintersA';

function EnumPrintersW conv arg_stdcall (Flags: DWORD; Name: PWideChar; Level: DWORD;
  pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintersW';

function EnumPrinters conv arg_stdcall (Flags: DWORD; Name: PChar; Level: DWORD;
  pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintersA';

function EnumPrintProcessorDatatypesA conv arg_stdcall (pName, pPrintProcessorName: PAnsiChar; Level: DWORD;
  pDatatypes: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintProcessorDatatypesA';

function EnumPrintProcessorDatatypesW conv arg_stdcall (pName, pPrintProcessorName: PWideChar; Level: DWORD;
  pDatatypes: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintProcessorDatatypesW';

function EnumPrintProcessorDatatypes conv arg_stdcall (pName, pPrintProcessorName: PChar; Level: DWORD;
  pDatatypes: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintProcessorDatatypesA';

function EnumPrintProcessorsA conv arg_stdcall (pName, pEnvironment: PAnsiChar; Level: DWORD; pPrintProcessorInfo: Pointer;
  cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintProcessorsA';

function EnumPrintProcessorsW conv arg_stdcall (pName, pEnvironment: PWideChar; Level: DWORD; pPrintProcessorInfo: Pointer;
  cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintProcessorsW';

function EnumPrintProcessors conv arg_stdcall (pName, pEnvironment: PChar; Level: DWORD; pPrintProcessorInfo: Pointer;
  cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL;
  external winspldrv name 'EnumPrintProcessorsA';

function FindClosePrinterChangeNotification conv arg_stdcall (hChange: THandle): BOOL;
  external winspldrv name 'FindClosePrinterChangeNotification';

function FindFirstPrinterChangeNotification conv arg_stdcall (hPrinter: THandle; fdwFlags: DWORD;
  fdwOptions: DWORD; pPrinterNotifyOptions: Pointer): THandle;
  external winspldrv name 'FindFirstPrinterChangeNotification';

function FindNextPrinterChangeNotification conv arg_stdcall (hChange: THandle; var pdwChange: DWORD;
  pvReserved: Pointer; var ppPrinterNotifyInfo: Pointer): BOOL;
  external winspldrv name 'FindNextPrinterChangeNotification';

function FreePrinterNotifyInfo conv arg_stdcall (pPrinterNotifyInfo: PPrinterNotifyInfo): BOOL;
  external winspldrv name 'FreePrinterNotifyInfo';

function GetFormA conv arg_stdcall (hPrinter: THandle; pFormName: PAnsiChar; Level: DWORD; pForm: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetFormA';

function GetFormW conv arg_stdcall (hPrinter: THandle; pFormName: PWideChar; Level: DWORD; pForm: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetFormW';

function GetForm conv arg_stdcall (hPrinter: THandle; pFormName: PChar; Level: DWORD; pForm: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetFormA';

function GetJobA conv arg_stdcall (hPrinter: THandle; JobId: DWORD; Level: DWORD; pJob: Pointer; cbBuf: DWORD; pcbNeeded: PDWORD): BOOL;
  external winspldrv name 'GetJobA';

function GetJobW conv arg_stdcall (hPrinter: THandle; JobId: DWORD; Level: DWORD; pJob: Pointer; cbBuf: DWORD; pcbNeeded: PDWORD): BOOL;
  external winspldrv name 'GetJobW';

function GetJob conv arg_stdcall (hPrinter: THandle; JobId: DWORD; Level: DWORD; pJob: Pointer; cbBuf: DWORD; pcbNeeded: PDWORD): BOOL;
  external winspldrv name 'GetJobA';

function GetPrinterA conv arg_stdcall (hPrinter: THandle; Level: DWORD; pPrinter: Pointer; cbBuf: DWORD; pcbNeeded: PDWORD): BOOL;
  external winspldrv name 'GetPrinterA';

function GetPrinterW conv arg_stdcall (hPrinter: THandle; Level: DWORD; pPrinter: Pointer; cbBuf: DWORD; pcbNeeded: PDWORD): BOOL;
  external winspldrv name 'GetPrinterW';

function GetPrinter conv arg_stdcall (hPrinter: THandle; Level: DWORD; pPrinter: Pointer; cbBuf: DWORD; pcbNeeded: PDWORD): BOOL;
  external winspldrv name 'GetPrinterA';

function GetPrinterDataA conv arg_stdcall (hPrinter: THandle; pValueName: PAnsiChar; pType: PDWORD; pData: Pointer;
  nSize: DWORD; var pcbNeeded: DWORD): DWORD;
  external winspldrv name 'GetPrinterDataA';

function GetPrinterDataW conv arg_stdcall (hPrinter: THandle; pValueName: PWideChar; pType: PDWORD; pData: Pointer;
  nSize: DWORD; var pcbNeeded: DWORD): DWORD;
  external winspldrv name 'GetPrinterDataW';

function GetPrinterData conv arg_stdcall (hPrinter: THandle; pValueName: PChar; pType: PDWORD; pData: Pointer;
  nSize: DWORD; var pcbNeeded: DWORD): DWORD;
  external winspldrv name 'GetPrinterDataA';

function GetPrinterDriverA conv arg_stdcall (hPrinter: THandle; pEnvironment: PAnsiChar; Level: DWORD;
  pDriverInfo: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrinterDriverA';

function GetPrinterDriverW conv arg_stdcall (hPrinter: THandle; pEnvironment: PWideChar; Level: DWORD;
  pDriverInfo: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrinterDriverW';

function GetPrinterDriver conv arg_stdcall (hPrinter: THandle; pEnvironment: PChar; Level: DWORD;
  pDriverInfo: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrinterDriverA';

function GetPrinterDriverDirectoryA conv arg_stdcall (pName, pEnvironment: PAnsiChar; Level: DWORD;
  pDriverDirectory: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrinterDriverDirectoryA';

function GetPrinterDriverDirectoryW conv arg_stdcall (pName, pEnvironment: PWideChar; Level: DWORD;
  pDriverDirectory: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrinterDriverDirectoryW';

function GetPrinterDriverDirectory conv arg_stdcall (pName, pEnvironment: PChar; Level: DWORD;
  pDriverDirectory: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrinterDriverDirectoryA';

function GetPrintProcessorDirectoryA conv arg_stdcall (pName, pEnvironment: PAnsiChar; Level: DWORD;
  pPrintProcessorInfo: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrintProcessorDirectoryA';

function GetPrintProcessorDirectoryW conv arg_stdcall (pName, pEnvironment: PWideChar; Level: DWORD;
  pPrintProcessorInfo: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrintProcessorDirectoryW';

function GetPrintProcessorDirectory conv arg_stdcall (pName, pEnvironment: PChar; Level: DWORD;
  pPrintProcessorInfo: Pointer; cbBuf: DWORD; var pcbNeeded: DWORD): BOOL;
  external winspldrv name 'GetPrintProcessorDirectoryA';

function OpenPrinterA conv arg_stdcall (pPrinterName: PAnsiChar; var phPrinter: THandle; pDefault: PPrinterDefaultsA): BOOL;
  external winspldrv name 'OpenPrinterA';

function OpenPrinterW conv arg_stdcall (pPrinterName: PWideChar; var phPrinter: THandle; pDefault: PPrinterDefaultsW): BOOL;
  external winspldrv name 'OpenPrinterW';

function OpenPrinter conv arg_stdcall (pPrinterName: PChar; var phPrinter: THandle; pDefault: PPrinterDefaults): BOOL;
  external winspldrv name 'OpenPrinterA';

function PrinterMessageBoxA conv arg_stdcall (hPrinter: THandle; Error: DWORD; hWnd: HWND; pText, pCaption: PAnsiChar; dwType: DWORD): DWORD;
  external winspldrv name 'PrinterMessageBoxA';

function PrinterMessageBoxW conv arg_stdcall (hPrinter: THandle; Error: DWORD; hWnd: HWND; pText, pCaption: PWideChar; dwType: DWORD): DWORD;
  external winspldrv name 'PrinterMessageBoxW';

function PrinterMessageBox conv arg_stdcall (hPrinter: THandle; Error: DWORD; hWnd: HWND; pText, pCaption: PChar; dwType: DWORD): DWORD;
  external winspldrv name 'PrinterMessageBoxA';

function PrinterProperties conv arg_stdcall (hWnd: HWND; hPrinter: THandle): BOOL;
  external winspldrv name 'PrinterProperties';

function ReadPrinter conv arg_stdcall (hPrinter: THandle; pBuf: Pointer; cbBuf: DWORD; var pNoBytesRead: DWORD): BOOL;
  external winspldrv name 'ReadPrinter';

function ResetPrinterA conv arg_stdcall (hPrinter: THandle; pDefault: PPrinterDefaultsA): BOOL;
  external winspldrv name 'ResetPrinterA';

function ResetPrinterW conv arg_stdcall (hPrinter: THandle; pDefault: PPrinterDefaultsW): BOOL;
  external winspldrv name 'ResetPrinterW';

function ResetPrinter conv arg_stdcall (hPrinter: THandle; pDefault: PPrinterDefaults): BOOL;
  external winspldrv name 'ResetPrinterA';

function ScheduleJob conv arg_stdcall (hPrinter: THandle; JobId: DWORD): BOOL;
  external winspldrv name 'ScheduleJob';

function SetFormA conv arg_stdcall (hPrinter: THandle; pFormName: PAnsiChar; Level: DWORD; pForm: Pointer): BOOL;
  external winspldrv name 'SetFormA';

function SetFormW conv arg_stdcall (hPrinter: THandle; pFormName: PWideChar; Level: DWORD; pForm: Pointer): BOOL;
  external winspldrv name 'SetFormW';

function SetForm conv arg_stdcall (hPrinter: THandle; pFormName: PChar; Level: DWORD; pForm: Pointer): BOOL;
  external winspldrv name 'SetFormA';

function SetJobA conv arg_stdcall (hPrinter: THandle; JobId: DWORD; Level: DWORD; pJob: Pointer; Command: DWORD): BOOL;
  external winspldrv name 'SetJobA';

function SetJobW conv arg_stdcall (hPrinter: THandle; JobId: DWORD; Level: DWORD; pJob: Pointer; Command: DWORD): BOOL;
  external winspldrv name 'SetJobW';

function SetJob conv arg_stdcall (hPrinter: THandle; JobId: DWORD; Level: DWORD; pJob: Pointer; Command: DWORD): BOOL;
  external winspldrv name 'SetJobA';

function SetPrinterA conv arg_stdcall (hPrinter: THandle; Level: DWORD; pPrinter: Pointer; Command: DWORD): BOOL;
  external winspldrv name 'SetPrinterA';

function SetPrinterW conv arg_stdcall (hPrinter: THandle; Level: DWORD; pPrinter: Pointer; Command: DWORD): BOOL;
  external winspldrv name 'SetPrinterW';

function SetPrinter conv arg_stdcall (hPrinter: THandle; Level: DWORD; pPrinter: Pointer; Command: DWORD): BOOL;
  external winspldrv name 'SetPrinterA';

function SetPrinterDataA conv arg_stdcall (hPrinter: THandle; pValueName: PAnsiChar; dwType: DWORD; pData: Pointer; cbData: DWORD): DWORD;
  external winspldrv name 'SetPrinterDataA';

function SetPrinterDataW conv arg_stdcall (hPrinter: THandle; pValueName: PWideChar; dwType: DWORD; pData: Pointer; cbData: DWORD): DWORD;
  external winspldrv name 'SetPrinterDataW';

function SetPrinterData conv arg_stdcall (hPrinter: THandle; pValueName: PChar; dwType: DWORD; pData: Pointer; cbData: DWORD): DWORD;
  external winspldrv name 'SetPrinterDataA';

function StartDocPrinterA conv arg_stdcall (hPrinter: THandle; Level: DWORD; pDocInfo: Pointer): DWORD;
  external winspldrv name 'StartDocPrinterA';

function StartDocPrinterW conv arg_stdcall (hPrinter: THandle; Level: DWORD; pDocInfo: Pointer): DWORD;
  external winspldrv name 'StartDocPrinterW';

function StartDocPrinter conv arg_stdcall (hPrinter: THandle; Level: DWORD; pDocInfo: Pointer): DWORD;
  external winspldrv name 'StartDocPrinterA';

function StartPagePrinter conv arg_stdcall (hPrinter: THandle): BOOL;
  external winspldrv name 'StartPagePrinter';

function WaitForPrinterChange conv arg_stdcall (hPrinter: THandle; Flags: DWORD): DWORD;
  external winspldrv name 'WaitForPrinterChange';

function WritePrinter conv arg_stdcall (hPrinter: THandle; pBuf: Pointer; cbBuf: DWORD; var pcWritten: DWORD): BOOL;
  external winspldrv name 'WritePrinter';

implementation

end.