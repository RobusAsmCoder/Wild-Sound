(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit Image Help Routines                      *)
(*       Based on imagehlp.h                                    *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-99 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit Imagehlp;

(*++ BUILD Version: 0001     Increment this if a change has global effects

Copyright 1993 - 1998 Microsoft Corporation

Module Name:

    imagehlp.h

Abstract:

    This module defines the prptotypes and constants required for the image
    help routines.

Revision History:

--*)

interface

uses Windows;

const
  imagehlplibdll = 'IMAGEHLP.DLL';

const
  CHECKSUM_SUCCESS                = 0;
  CHECKSUM_OPEN_FAILURE           = 1;
  CHECKSUM_MAP_FAILURE            = 2;
  CHECKSUM_MAPVIEW_FAILURE        = 3;
  CHECKSUM_UNICODE_FAILURE        = 4;
//
// Define Splitsym flags.
//
  SPLITSYM_REMOVE_PRIVATE         = $00000001;      // Remove CV types/symbols and Fixup debug
  SPLITSYM_EXTRACT_ALL            = $00000002;      // Extract all debug info from image.

type
  _IMAGEHLP_STATUS_REASON = (
    BindOutOfMemory,
    BindRvaToVaFailed,
    BindNoRoomInImage,
    BindImportModuleFailed,
    BindImportProcedureFailed,
    BindImportModule,
    BindImportProcedure,
    BindForwarder,
    BindForwarderNOT,
    BindImageModified,
    BindExpandFileHeaders,
    BindImageComplete,
    BindMismatchedSymbols,
    BindSymbolsNotUpdated
  );
  IMAGEHLP_STATUS_REASON = _IMAGEHLP_STATUS_REASON;
  TImagehlpStatusReason = _IMAGEHLP_STATUS_REASON;

type
  PIMAGEHLP_STATUS_ROUTINE = function conv arg_stdcall (Reason: TImagehlpStatusReason;
    ImageName, DllName: LPSTR; Va, Parameter: ULONG): Boolean;
  TImagehlpStatusRoutine = PIMAGEHLP_STATUS_ROUTINE;

const
  BIND_NO_BOUND_IMPORTS     = $00000001;
  BIND_NO_UPDATE            = $00000002;
  BIND_ALL_IMAGES           = $00000004;

const
  IMAGE_SEPARATION     = 64 * 1024;

type
  PloadedImage = ^LoadedImage;
  _LOADED_IMAGE = record
    ModuleName: LPSTR;
    hFile: THandle;
    MappedAddress: PChar;
    FileHeader: PImageNtHeaders;
    LastRvaSection: PImageSectionHeader;
    NumberOfSections: ULONG;
    Sections: PImageSectionHeader;
    Characteristics: ULONG;
    fSystemImage: ByteBool;
    fDOSImage: ByteBool;
    Links: TListEntry;
    SizeOfImage: ULONG;
  end;
  LOADED_IMAGE = _LOADED_IMAGE;
  LoadedImage = _LOADED_IMAGE;

type
  PimageDebugInformation = ^TImageDebugInformation;
  _IMAGE_DEBUG_INFORMATION = packed record
    List: TListEntry;
    Size: DWORD;
    MappedBase: Pointer;
    Machine: Word;
    Characteristics: Word;
    CheckSum: DWORD;
    ImageBase: DWORD;
    SizeOfImage: DWORD;
    NumberOfSections: DWORD;
    Sections: PImageSectionHeader;
    ExportedNamesSize: DWORD;
    ExportedNames: LPSTR;
    NumberOfFunctionTableEntries: DWORD;
    FunctionTableEntries: PImageFunctionEntry;
    LowestFunctionStartingAddress: DWORD;
    HighestFunctionEndingAddress: DWORD;
    NumberOfFpoTableEntries: DWORD;
    FpoTableEntries: PFpoData;
    SizeOfCoffSymbols: DWORD;
    CoffSymbols: PImageCOFFSymbolsHeader;
    SizeOfCodeViewSymbols: DWORD;
    CodeViewSymbols: Pointer;
    ImageFilePath: LPSTR;
    ImageFileName: LPSTR;
    DebugFilePath: LPSTR;
    TimeDateStamp: DWORD;
    RomImage: Bool;
    DebugDirectory: PImageDebugDirectory;
    NumberOfDebugDirectories: DWORD;
    Reserved: array[0..2] of DWORD;
  end;
  IMAGE_DEBUG_INFORMATION = _IMAGE_DEBUG_INFORMATION;
  TImageDebugInformation = _IMAGE_DEBUG_INFORMATION;

//
// UnDecorateSymbolName Flags
//
const
  UNDNAME_COMPLETE                     = $0000;    // Enable full undecoration
  UNDNAME_NO_LEADING_UNDERSCORES       = $0001;    // Remove leading underscores from MS extended keywords
  UNDNAME_NO_MS_KEYWORDS               = $0002;    // Disable expansion of MS extended keywords
  UNDNAME_NO_FUNCTION_RETURNS          = $0004;    // Disable expansion of return type for primary declaration
  UNDNAME_NO_ALLOCATION_MODEL          = $0008;    // Disable expansion of the declaration model
  UNDNAME_NO_ALLOCATION_LANGUAGE       = $0010;    // Disable expansion of the declaration language specifier
  UNDNAME_NO_MS_THISTYPE               = $0020;    // NYI Disable expansion of MS keywords on the 'this' type for primary declaration
  UNDNAME_NO_CV_THISTYPE               = $0040;    // NYI Disable expansion of CV modifiers on the 'this' type for primary declaration
  UNDNAME_NO_THISTYPE                  = $0060;    // Disable all modifiers on the 'this' type
  UNDNAME_NO_ACCESS_SPECIFIERS         = $0080;    // Disable expansion of access specifiers for members
  UNDNAME_NO_THROW_SIGNATURES          = $0100;    // Disable expansion of 'throw-signatures' for functions and pointers to functions
  UNDNAME_NO_MEMBER_TYPE               = $0200;    // Disable expansion of 'static' or 'virtual'ness of members
  UNDNAME_NO_RETURN_UDT_MODEL          = $0400;    // Disable expansion of MS model for UDT returns
  UNDNAME_32_BIT_DECODE                = $0800;    // Undecorate 32-bit decorated names
  UNDNAME_NAME_ONLY                    = $1000;    // Crack only the name for primary declaration;
  UNDNAME_NO_ARGUMENTS                 = $2000;    // Don't undecorate arguments to function
  UNDNAME_NO_SPECIAL_SYMS              = $4000;    // Don't undecorate special names (v-table, vcall, vector xxx, metatype, etc)

//
// StackWalking API
//
type
  ADDRESS_MODE = (
    AddrMode1616,
    AddrMode1632,
    AddrModeReal,
    AddrModeFlat
  );
  TAddressMode = ADDRESS_MODE;

  PAddress = ^TAddress;
  _tagADDRESS = record
    Offset: DWORD;
    Segment: Word;
    Mode: TAddressMode;
  end;
  ADDRESS = _tagADDRESS;
  TAddress = _tagADDRESS;

//
// This structure is included in the STACKFRAME structure,
// and is used to trace through usermode callbacks in a thread's
// kernel stack.  The values must be copied by the kernel debugger
// from the DBGKD_GET_VERSION and WAIT_STATE_CHANGE packets.
//
  PKdHelp = ^TKdHelp;
  _KDHELP = packed record
    //
    // address of kernel thread object, as provided in the
    // WAIT_STATE_CHANGE packet.
    //
    Thread: DWORD;
    //
    // offset in thread object to pointer to the current callback frame
    // in kernel stack.
    //
    ThCallbackStack: DWORD;
    //
    // offsets to values in frame:
    //
    // address of next callback frame
    NextCallback: DWORD;
    // address of saved frame pointer (if applicable)
    FramePointer: DWORD;
    //
    // Address of the kernel function that calls out to user mode
    //
    KiCallUserMode: DWORD;
    //
    // Address of the user mode dispatcher function
    //
    KeUserCallbackDispatcher: DWORD;
  end;
  KDHELP = _KDHELP;
  TKdHelp = _KDHELP;

  PStackFrame = ^TStackFrame;
  _tagSTACKFRAME = packed record
    AddrPC: TAddress;               // program counter
    AddrReturn: TAddress;           // return address
    AddrFrame: TAddress;            // frame pointer
    AddrStack: TAddress;            // stack pointer
    FuncTableEntry: Pointer;        // pointer to pdata/fpo or NULL
    Params: array[0..3] of DWORD;   // possible arguments to the function
    _Far: Bool;                     // WOW far call
    _Virtual: Bool;                 // is this a virtual frame?
    Reserved: array[0..2] of DWORD; // used internally by StackWalk api
    KdHelp: TKdHelp;
  end;
  STACKFRAME = _tagSTACKFRAME;
  TStackFrame = _tagSTACKFRAME;

type
  PREAD_PROCESS_MEMORY_ROUTINE = function conv arg_stdcall (hProcess: THandle;
    lpBaseAddress, lpBuffer: Pointer; nSize: DWORD; var lpNumberOfBytesRead: DWORD): Boolean;
  TReadProcessMemoryRoutine = PREAD_PROCESS_MEMORY_ROUTINE;

  PFUNCTION_TABLE_ACCESS_ROUTINE = function conv arg_stdcall (hProcess: THandle;
    AddrBase: DWORD): Pointer; TFunctionTableAccessRoutine = PFUNCTION_TABLE_ACCESS_ROUTINE;

  PGET_MODULE_BASE_ROUTINE = function conv arg_stdcall (hProcess: THandle;
    ReturnAddress: DWORD): DWORD; TGetModuleBaseRoutine = PGET_MODULE_BASE_ROUTINE;

  PTRANSLATE_ADDRESS_ROUTINE = function conv arg_stdcall (hProcess, hThread: THandle;
    lpaddr: PAddress): DWORD; TTranslateAddressRoutine = PTRANSLATE_ADDRESS_ROUTINE;

const
  API_VERSION_NUMBER     = 5;

type
  PApiVersion = ^TApiVersion;
  API_VERSION = packed record
    MajorVersion: Word;
    MinorVersion: Word;
    Revision: Word;
    Reserved: Word;
  end;
  TApiVersion = API_VERSION;

//
// typedefs for function pointers
//
type
  PSYM_ENUMMODULES_CALLBACK = function conv arg_stdcall (ModuleName: LPSTR; BaseOfDll: ULONG;
    UserContext: Pointer): Boolean; TSymEnummodulesCallback = PSYM_ENUMMODULES_CALLBACK;

  PSYM_ENUMSYMBOLS_CALLBACK = function conv arg_stdcall (SymbolName: LPSTR; SymbolAddress,
    SymbolSize: ULONG; UserContext: Pointer): Boolean; TSymEnumsymbolsCallback = PSYM_ENUMSYMBOLS_CALLBACK;

  PENUMLOADED_MODULES_CALLBACK = function conv arg_stdcall (ModuleName: LPSTR; ModuleBase,
    ModuleSize: ULONG; UserContext: Pointer): Boolean; TEnumloadedModulesCallback = PENUMLOADED_MODULES_CALLBACK;

  PSYMBOL_REGISTERED_CALLBACK = function conv arg_stdcall (hProcess: THandle; ActionCode: ULONG;
    CallbackData, UserContext: Pointer): Boolean; TSymbolRegisteredCallback = PSYMBOL_REGISTERED_CALLBACK;

//
// symbol flags
//
const
  SYMF_OMAP_GENERATED       = $00000001;
  SYMF_OMAP_MODIFIED        = $00000002;

type
  SYM_TYPE = (
    SymNone,
    SymCoff,
    SymCv,
    SymPdb,
    SymExport,
    SymDeferred,
    SymSym                  // .sym file
  );
  TSymType = SYM_TYPE;

//
// symbol data structure
//
  PImagehlpSymbol = ^TImagehlpSymbol;
  _IMAGEHLP_SYMBOL = packed record
    SizeOfStruct: DWORD;        // set to sizeof(IMAGEHLP_SYMBOL)
    Address: DWORD;             // virtual address including dll base address
    Size: DWORD;                // estimated size of symbol, can be zero
    Flags: DWORD;               // info about the symbols, see the SYMF defines
    MaxNameLength: DWORD;       // maximum size of symbol name in 'Name'
    Name: array[0..0] of Char;  // symbol name (null terminated string)
  end;
  IMAGEHLP_SYMBOL = _IMAGEHLP_SYMBOL;
  TImagehlpSymbol = _IMAGEHLP_SYMBOL;

//
// module data structure
//
  PImagehlpModule = ^TImagehlpModule;
  _IMAGEHLP_MODULE = record
    SizeOfStruct: DWORD;                    // set to sizeof(IMAGEHLP_MODULE)
    BaseOfImage: DWORD;                     // base load address of module
    ImageSize: DWORD;                       // virtual size of the loaded module
    TimeDateStamp: DWORD;                   // date/time stamp from pe header
    CheckSum: DWORD;                        // checksum from the pe header
    NumSyms: DWORD;                         // number of symbols in the symbol table
    SymType: TSymType;                      // type of symbols loaded
    ModuleName: array[0..31] of Char;       // module name
    ImageName: array[0..255] of Char;       // image name
    LoadedImageName: array[0..255] of Char; // symbol file name
  end;
  IMAGEHLP_MODULE = _IMAGEHLP_MODULE;
  TImagehlpModule = _IMAGEHLP_MODULE;

//
// data structures used for registered symbol callbacks
//
const
  CBA_DEFERRED_SYMBOL_LOAD_START              = $00000001;
  CBA_DEFERRED_SYMBOL_LOAD_COMPLETE           = $00000002;
  CBA_DEFERRED_SYMBOL_LOAD_FAILURE            = $00000003;
  CBA_SYMBOLS_UNLOADED                        = $00000004;
  CBA_DUPLICATE_SYMBOL                        = $00000005;

type
  PImagehlpDeferredSymbolLoad = ^TImagehlpDeferredSymbolLoad;
  _IMAGEHLP_DEFERRED_SYMBOL_LOAD = packed record
    SizeOfStruct: DWORD;                    // set to sizeof(IMAGEHLP_DEFERRED_SYMBOL_LOAD)
    BaseOfImage: DWORD;                     // base load address of module
    CheckSum: DWORD;                        // checksum from the pe header
    TimeDateStamp: DWORD;                   // date/time stamp from pe header
    FileName: array[0..MAX_PATH-1] of Char; // symbols file or image name
  end;
  IMAGEHLP_DEFERRED_SYMBOL_LOAD = _IMAGEHLP_DEFERRED_SYMBOL_LOAD;
  TImagehlpDeferredSymbolLoad = _IMAGEHLP_DEFERRED_SYMBOL_LOAD;

  PImagehlpDuplicateSymbol = ^TImagehlpDuplicateSymbol;
  _IMAGEHLP_DUPLICATE_SYMBOL = packed record
    SizeOfStruct: DWORD;        // set to sizeof(IMAGEHLP_DUPLICATE_SYMBOL)
    NumberOfDups: DWORD;        // number of duplicates in the Symbol array
    Symbol: PImagehlpSymbol;    // array of duplicate symbols
    SelectedSymbol: ULONG;      // symbol selected (-1 to start)
  end;
  IMAGEHLP_DUPLICATE_SYMBOL = _IMAGEHLP_DUPLICATE_SYMBOL;
  TImagehlpDuplicateSymbol = _IMAGEHLP_DUPLICATE_SYMBOL;

const
  SYMOPT_CASE_INSENSITIVE      = $00000001;
  SYMOPT_UNDNAME               = $00000002;
  SYMOPT_DEFERRED_LOADS        = $00000004;
  SYMOPT_NO_CPP                = $00000008;

const
  CERT_PE_IMAGE_DIGEST_DEBUG_INFO             = $01;
  CERT_PE_IMAGE_DIGEST_RESOURCES              = $02;
  CERT_PE_IMAGE_DIGEST_ALL_IMPORT_INFO        = $04;

  CERT_SECTION_TYPE_ANY                       = $FF;      // Any Certificate type

type
  DIGEST_HANDLE = Pointer;
  TDigestHandle = DIGEST_HANDLE;

type
  DIGEST_FUNCTION = function conv arg_stdcall (refdata: TDigestHandle; pData: PByte;
    dwLength: DWORD): Boolean;
  TDigestFunction = DIGEST_FUNCTION;

function BindImage conv arg_stdcall (ImageName, DllPath, SymbolPath: LPSTR): Boolean;
  external imagehlplibdll name 'BindImage';

function BindImageEx conv arg_stdcall (Flags: DWORD; ImageName, DllPath, SymbolPath: LPSTR;
  var StatusRoutine: TImagehlpStatusReason): Boolean;
  external imagehlplibdll name 'BindImageEx';

function CheckSumMappedFile conv arg_stdcall (BaseAddress: Pointer; FileLength: DWORD;
  HeaderSum: PDWORD; CheckSum: PDWORD): PImageNtHeaders;
  external imagehlplibdll name 'CheckSumMappedFile';

function EnumerateLoadedModules conv arg_stdcall (hProcess: THandle;
  EnumLoadedModulesCallback: TEnumLoadedModulesCallback; UserContext: Pointer): Boolean;
  external imagehlplibdll name 'EnumerateLoadedModules';

function FindDebugInfoFile conv arg_stdcall (FileName, SymbolPath, DebugFilePath: LPSTR): THandle;
  external imagehlplibdll name 'FindDebugInfoFile';

function FindExecutableImage conv arg_stdcall (FileName, SymbolPath, ImageFilePath: LPSTR): THandle;
  external imagehlplibdll name 'FindExecutableImage';

function GetImageConfigInformation conv arg_stdcall (LoadedImage: PLoadedImage;
  var ImageConfigInformation: TImageLoadConfigDirectory): Boolean;
  external imagehlplibdll name 'GetImageConfigInformation';

function GetImageUnusedHeaderBytes conv arg_stdcall (LoadedImage: PLoadedImage;
  var SizeUnusedHeaderBytes: DWORD): DWORD;
  external imagehlplibdll name 'GetImageUnusedHeaderBytes';

function GetTimestampForLoadedLibrary conv arg_stdcall (Module: HMODULE): DWORD;
  external imagehlplibdll name 'GetTimestampForLoadedLibrary';

function ImageAddCertificate conv arg_stdcall (FileHandle: THandle;
  var Certificate: PWinCertificate; var Index: DWORD): Boolean;
  external imagehlplibdll name 'ImageAddCertificate';

function ImageDirectoryEntryToData conv arg_stdcall (Base: Pointer; MappedAsImage: ByteBool;
  DirectoryEntry: Word; var Size: ULONG): Pointer;
  external imagehlplibdll name 'ImageDirectoryEntryToData';

function ImageEnumerateCertificates conv arg_stdcall (FileHandle: THandle; TypeFilter: Word;
  CertificateCount, Indices, IndexCount: PDWORD): Boolean;
  external imagehlplibdll name 'ImageEnumerateCertificates';

function ImageGetCertificateData conv arg_stdcall (FileHandle: THandle; CertificateIndex: DWORD;
  Certificate: PWinCertificate; var RequiredLength: DWORD): Boolean;
  external imagehlplibdll name 'ImageGetCertificateData';

function ImageGetCertificateHeader conv arg_stdcall (FileHandle: THandle; CertificateIndex: DWORD;
  var Certificateheader: PWinCertificate): Boolean;
  external imagehlplibdll name 'ImageGetCertificateHeader';

function ImageGetDigestStream conv arg_stdcall (FileHandle: THandle; DigestLevel: DWORD;
  DigestFunction: TDigestFunction; DigestHandle: TDigestHandle): Boolean;
  external imagehlplibdll name 'ImageGetDigestStream';

function ImagehlpApiVersion: PApiVersion;
  external imagehlplibdll name 'ImagehlpApiVersion';

function ImagehlpApiVersionEx conv arg_stdcall (var AppVersion: TApiVersion): PApiVersion;
  external imagehlplibdll name 'ImagehlpApiVersionEx';

function ImageLoad conv arg_stdcall (DllName, DllPath: LPSTR): PLoadedImage;
  external imagehlplibdll name 'ImageLoad';

function ImageNtHeader conv arg_stdcall (Base: Pointer): PImageNtHeaders;
  external imagehlplibdll name 'ImageNtHeader';

function ImageRemoveCertificate conv arg_stdcall (FileHandle: THandle; Index: DWORD): Boolean;
  external imagehlplibdll name 'ImageRemoveCertificate';

function ImageRvaToSection conv arg_stdcall (NtHeaders: PImageNtHeaders; Base: Pointer;
  Rva: ULONG): PImageSectionHeader;
  external imagehlplibdll name 'ImageRvaToSection';

function ImageRvaToVa conv arg_stdcall (NtHeaders: PImageNtHeaders; Base: Pointer;
  Rva: ULONG; var LastRvaSection: PImageSectionHeader): Pointer;
  external imagehlplibdll name 'ImageRvaToVa';

function ImageUnload conv arg_stdcall (LoadedImage: PLoadedImage): Boolean;
  external imagehlplibdll name 'ImageUnload';

function MakeSureDirectoryPathExists conv arg_stdcall (DirPath: LPCSTR): Boolean;
  external imagehlplibdll name 'MakeSureDirectoryPathExists';

function MapAndLoad conv arg_stdcall (ImageName, DllPath: LPSTR; LoadedImage: PLoadedImage;
  DotDll, ReadOnly: Bool): Boolean;
  external imagehlplibdll name 'MapAndLoad';

function MapDebugInformation conv arg_stdcall (FileHandle: THandle; FileName, SymbolPath: LPSTR;
  ImageBase: DWORD): PImageDebugInformation;
  external imagehlplibdll name 'MapDebugInformation';

function MapFileAndCheckSumA conv arg_stdcall (Filename: PAnsiChar; var HeaderSum, CheckSum: DWORD): DWORD;
  external imagehlplibdll name 'MapFileAndCheckSumA';

function MapFileAndCheckSumW conv arg_stdcall (Filename: PWideChar; var HeaderSum, CheckSum: DWORD): DWORD;
  external imagehlplibdll name 'MapFileAndCheckSumW';

function MapFileAndCheckSum conv arg_stdcall (Filename: PChar; var HeaderSum, CheckSum: DWORD): DWORD;
  external imagehlplibdll name 'MapFileAndCheckSumA';

function ReBaseImage conv arg_stdcall (CurrentImageName, SymbolPath: LPSTR; fReBase,
  fRebaseSysfileOk, fGoingDown: Bool; CheckImageSize: ULONG;
  var OldImageSize, OldImageBase, NewImageSize, NewImageBase: ULONG;
  TimeStamp: ULONG): Boolean;
  external imagehlplibdll name 'ReBaseImage';

function RemovePrivateCvSymbolic conv arg_stdcall (DebugData: PChar; var NewDebugData: PChar;
  var NewDebugSize: ULONG): Boolean;
  external imagehlplibdll name 'RemovePrivateCvSymbolic';

procedure RemoveRelocations conv arg_stdcall (ImageName: PChar);
  external imagehlplibdll name 'RemoveRelocations';

function SearchTreeForFile conv arg_stdcall (RootPath, InputPathName, OutputPathBuffer: LPSTR): Boolean;
  external imagehlplibdll name 'SearchTreeForFile';

function SetImageConfigInformation conv arg_stdcall (LoadedImage: PLoadedImage;
  const ImageConfigInformation: TImageLoadConfigDirectory): Boolean;
  external imagehlplibdll name 'SetImageConfigInformation';

function SplitSymbols conv arg_stdcall (ImageName, SymbolsPath, SymbolFilePath: LPSTR; Flags: DWORD): Boolean;
  external imagehlplibdll name 'SplitSymbols';

function StackWalk conv arg_stdcall (MachineType: DWORD; hProcess, hThread: THandle;
  StackFrame: PStackFrame; ContextRecord: Pointer;
  ReadMemoryRoutine: TReadProcessMemoryRoutine;
  FunctionTableAccessRoutine: TFunctionTableAccessRoutine;
  GetModuleBaseRoutine: TGetModuleBaseRoutine;
  TranslateAddress: TTranslateAddressRoutine): Boolean;
  external imagehlplibdll name 'StackWalk';

function SymCleanup conv arg_stdcall (hProcess: THandle): Boolean;
  external imagehlplibdll name 'SymCleanup';

function SymEnumerateModules conv arg_stdcall (hProcess: THandle;
  EnumModulesCallback: TSymEnumModulesCallback; UserContext: Pointer): Boolean;
  external imagehlplibdll name 'SymEnumerateModules';

function SymEnumerateSymbols conv arg_stdcall (hProcess: THandle; BaseOfDll: DWORD;
  EnumSymbolsCallback: TSymEnumSymbolsCallback; UserContext: Pointer): Boolean;
  external imagehlplibdll name 'SymEnumerateSymbols';

function SymFunctionTableAccess conv arg_stdcall (hProcess: THandle; AddrBase: DWORD): Pointer;
  external imagehlplibdll name 'SymFunctionTableAccess';

function SymGetModuleBase conv arg_stdcall (hProcess: THandle; dwAddr: DWORD): DWORD;
  external imagehlplibdll name 'SymGetModuleBase';

function SymGetModuleInfo conv arg_stdcall (hProcess: THandle; dwAddr: DWORD;
  var ModuleInfo: TImagehlpModule): Boolean;
  external imagehlplibdll name 'SymGetModuleInfo';

function SymGetOptions: DWORD;
  external imagehlplibdll name 'SymGetOptions';

function SymGetSearchPath conv arg_stdcall (hProcess: THandle; SearchPath: LPSTR;
  SearchPathLength: DWORD): Boolean;
  external imagehlplibdll name 'SymGetSearchPath';

function SymGetSymFromAddr conv arg_stdcall (hProcess: THandle; dwAddr: DWORD;
  pdwDisplacement: PDWORD; var Symbol: TImagehlpSymbol): Boolean;
  external imagehlplibdll name 'SymGetSymFromAddr';

function SymGetSymFromName conv arg_stdcall (hProcess: THandle; Name: LPSTR; var Symbol: TImagehlpSymbol): Boolean;
  external imagehlplibdll name 'SymGetSymFromName';

function SymGetSymNext conv arg_stdcall (hProcess: THandle; var Symbol: TImagehlpSymbol): Boolean;
  external imagehlplibdll name 'SymGetSymNext';

function SymGetSymPrev conv arg_stdcall (hProcess: THandle; var Symbol: TImagehlpSymbol): Boolean;
  external imagehlplibdll name 'SymGetSymPrev';

function SymInitialize conv arg_stdcall (hProcess: THandle; UserSearchPath: LPSTR; fInvadeProcess: Bool): Boolean;
  external imagehlplibdll name 'SymInitialize';

function SymLoadModule conv arg_stdcall (hProcess: THandle; hFile: THandle; ImageName,
  ModuleName: LPSTR; BaseOfDll, SizeOfDll: DWORD): Boolean;
  external imagehlplibdll name 'SymLoadModule';

function SymRegisterCallback conv arg_stdcall (hProcess: THandle;
  CallbackFunction: TSymbolRegisteredCallback; UserContext: Pointer): Boolean;
  external imagehlplibdll name 'SymRegisterCallback';

function SymSetOptions conv arg_stdcall (SymOptions: DWORD): DWORD;
  external imagehlplibdll name 'SymSetOptions';

function SymSetSearchPath conv arg_stdcall (hProcess: THandle; SearchPath: LPSTR): Boolean;
  external imagehlplibdll name 'SymSetSearchPath';

function SymUnDName conv arg_stdcall (sym: PImagehlpSymbol; UnDecName: LPSTR; UnDecNameLength: DWORD): Boolean;
  external imagehlplibdll name 'SymUnDName';

function SymUnloadModule conv arg_stdcall (hProcess: THandle; BaseOfDll: DWORD): Boolean;
  external imagehlplibdll name 'SymUnloadModule';

function TouchFileTimes conv arg_stdcall (FileHandle: THandle; const lpSystemTime: TSystemTime): Boolean;
  external imagehlplibdll name 'TouchFileTimes';

function UnDecorateSymbolName conv arg_stdcall (DecoratedName, UnDecoratedName: LPSTR; UndecoratedLength, Flags: DWORD): DWORD;
  external imagehlplibdll name 'UnDecorateSymbolName';

function UnMapAndLoad conv arg_stdcall (LoadedImage: PLoadedImage): Boolean;
  external imagehlplibdll name 'UnMapAndLoad';

function UnmapDebugInformation conv arg_stdcall (DebugInfo: PImageDebugInformation): Boolean;
  external imagehlplibdll name 'UnmapDebugInformation';

function UpdateDebugInfoFile conv arg_stdcall (ImageFileName, SymbolPath, DebugFilePath: LPSTR;
  NtHeaders: PImageNtHeaders): Boolean;
  external imagehlplibdll name 'UpdateDebugInfoFile';

function UpdateDebugInfoFileEx conv arg_stdcall (ImageFileName, SymbolPath, DebugFilePath: LPSTR;
  NtHeaders: PImageNtHeaders; OldChecksum: DWORD): Boolean;
  external imagehlplibdll name 'UpdateDebugInfoFileEx';

implementation

(* nothing to implement *)

end.
