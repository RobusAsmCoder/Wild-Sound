(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API WinSock Interface Unit               *)
(*       Based on winsock.h                                     *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit WinSock;

(* WINSOCK.PAS--definitions to be used with the WINSOCK.DLL
 * Copyright (c) 1993-1996, Microsoft Corp. All rights reserved.
 *
 * This header file corresponds to version 1.1 of the Windows Sockets
 * specification.
 *
 * This file includes parts which are Copyright (c) 1982-1986 Regents
 * of the University of California.  All rights reserved.  The
 * Berkeley Software License Agreement specifies the terms and
 * conditions for redistribution.
 *)

interface

uses Windows;

type
  u_char = Char;
  u_short = Word;
  u_int = Longint;
  u_long = Longint;
  TSocket = u_int;

const
  wsock32dll = 'wsock32.dll';

  FD_SETSIZE   = $40;
  IOCPARM_MASK = $7F;
  IOC_VOID     = $20000000;
  IOC_OUT      = $40000000;
  IOC_IN       = $80000000;
  IOC_INOUT    = (IOC_IN or IOC_OUT);

  FIONREAD     = IOC_OUT or ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 127;
  FIONBIO      = IOC_IN or  ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 126;
  FIOASYNC     = IOC_IN or ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 125;

//Protocols

  IPPROTO_IP     =   0;             // dummy for IP
  IPPROTO_ICMP   =   1;             // control message protocol
  IPPROTO_IGMP   =   2;             // group management protocol
  IPPROTO_GGP    =   3;             // gateway^2 (deprecated)
  IPPROTO_TCP    =   6;             // tcp
  IPPROTO_PUP    =  12;             // pup
  IPPROTO_UDP    =  17;             // user datagram protocol
  IPPROTO_IDP    =  22;             // xns idp
  IPPROTO_ND     =  77;             // UNOFFICIAL net disk proto

  IPPROTO_RAW    =  255;            // raw IP packet
  IPPROTO_MAX    =  256;

// Port/socket numbers: network standard functions

  IPPORT_ECHO    =   7;
  IPPORT_DISCARD =   9;
  IPPORT_SYSTAT  =   11;
  IPPORT_DAYTIME =   13;
  IPPORT_NETSTAT =   15;
  IPPORT_FTP     =   21;
  IPPORT_TELNET  =   23;
  IPPORT_SMTP    =   25;
  IPPORT_TIMESERVER  =  37;
  IPPORT_NAMESERVER  =  42;
  IPPORT_WHOIS       =  43;
  IPPORT_MTP         =  57;

// Port/socket numbers: host specific functions

  IPPORT_TFTP        =  69;
  IPPORT_RJE         =  77;
  IPPORT_FINGER      =  79;
  IPPORT_TTYLINK     =  87;
  IPPORT_SUPDUP      =  95;

// UNIX TCP sockets

  IPPORT_EXECSERVER  =  512;
  IPPORT_LOGINSERVER =  513;
  IPPORT_CMDSERVER   =  514;
  IPPORT_EFSSERVER   =  520;

// UNIX UDP sockets

  IPPORT_BIFFUDP     =  512;
  IPPORT_WHOSERVER   =  513;
  IPPORT_ROUTESERVER =  520;

// Ports < IPPORT_RESERVED are reserved for privileged processes (e.g. root).

  IPPORT_RESERVED    =  1024;

// Link numbers

  IMPLINK_IP         =  155;
  IMPLINK_LOWEXPER   =  156;
  IMPLINK_HIGHEXPER  =  158;

  INADDR_ANY       = $00000000;
  INADDR_LOOPBACK  = $7F000001;
  INADDR_BROADCAST = $FFFFFFFF;
  INADDR_NONE      = $FFFFFFFF;

  WSADESCRIPTION_LEN     =   256;
  WSASYS_STATUS_LEN      =   128;

  TF_DISCONNECT           = $01;
  TF_REUSE_SOCKET         = $02;
  TF_WRITE_BEHIND         = $04;

// Options for use with [gs]etsockopt at the IP level.

  IP_OPTIONS          = 1;
  IP_MULTICAST_IF     = 2;           // set/get IP multicast interface
  IP_MULTICAST_TTL    = 3;           // set/get IP multicast timetolive
  IP_MULTICAST_LOOP   = 4;           // set/get IP multicast loopback
  IP_ADD_MEMBERSHIP   = 5;           // add  an IP group membership
  IP_DROP_MEMBERSHIP  = 6;           // drop an IP group membership
  IP_TTL              = 7;           // set/get IP Time To Live
  IP_TOS              = 8;           // set/get IP Type Of Service
  IP_DONTFRAGMENT     = 9;           // set/get IP Don't Fragment flag


  IP_DEFAULT_MULTICAST_TTL   = 1;    // normally limit m'casts to 1 hop
  IP_DEFAULT_MULTICAST_LOOP  = 1;    // normally hear sends if a member
  IP_MAX_MEMBERSHIPS         = 20;   // per socket; must fit in one mbuf

// This is used instead of -1, since the  TSocket type is unsigned.

  INVALID_SOCKET                = TSocket(NOT(0));
  SOCKET_ERROR                  = -1;

// Types

  SOCK_STREAM     = 1;               // stream socket
  SOCK_DGRAM      = 2;               // datagram socket
  SOCK_RAW        = 3;               // raw-protocol interface
  SOCK_RDM        = 4;               // reliably-delivered message
  SOCK_SEQPACKET  = 5;               // sequenced packet stream

// Option flags per-socket.

  SO_DEBUG        = $0001;          // turn on debugging info recording
  SO_ACCEPTCONN   = $0002;          // socket has had listen()
  SO_REUSEADDR    = $0004;          // allow local address reuse
  SO_KEEPALIVE    = $0008;          // keep connections alive
  SO_DONTROUTE    = $0010;          // just use interface addresses
  SO_BROADCAST    = $0020;          // permit sending of broadcast msgs
  SO_USELOOPBACK  = $0040;          // bypass hardware when possible
  SO_LINGER       = $0080;          // linger on close if data present
  SO_OOBINLINE    = $0100;          // leave received OOB data in line

  SO_DONTLINGER  =   $ff7f;

// Additional options.

  SO_SNDBUF       = $1001;          // send buffer size
  SO_RCVBUF       = $1002;          // receive buffer size
  SO_SNDLOWAT     = $1003;          // send low-water mark
  SO_RCVLOWAT     = $1004;          // receive low-water mark
  SO_SNDTIMEO     = $1005;          // send timeout
  SO_RCVTIMEO     = $1006;          // receive timeout
  SO_ERROR        = $1007;          // get error status and clear
  SO_TYPE         = $1008;          // get socket type

// Options for connect and disconnect data and options.  Used only by
// non-TCP/IP transports such as DECNet, OSI TP4, etc.

  SO_CONNDATA     = $7000;
  SO_CONNOPT      = $7001;
  SO_DISCDATA     = $7002;
  SO_DISCOPT      = $7003;
  SO_CONNDATALEN  = $7004;
  SO_CONNOPTLEN   = $7005;
  SO_DISCDATALEN  = $7006;
  SO_DISCOPTLEN   = $7007;

// Option for opening sockets for synchronous access.

  SO_OPENTYPE     = $7008;

  SO_SYNCHRONOUS_ALERT    = $10;
  SO_SYNCHRONOUS_NONALERT = $20;

// Other NT-specific options.

  SO_MAXDG                     = $7009;
  SO_MAXPATHDG                 = $700A;
  SO_UPDATE_ACCEPT_CONTEXT     = $700B;
  SO_CONNECT_TIME              = $700C;

// TCP options.

  TCP_NODELAY     = $0001;
  TCP_BSDURGENT   = $7000;

// Address families.

  AF_UNSPEC       = 0;               // unspecified
  AF_UNIX         = 1;               // local to host (pipes, portals)
  AF_INET         = 2;               // internetwork: UDP, TCP, etc.
  AF_IMPLINK      = 3;               // arpanet imp addresses
  AF_PUP          = 4;               // pup protocols: e.g. BSP
  AF_CHAOS        = 5;               // mit CHAOS protocols
  AF_IPX          = 6;               // IPX and SPX
  AF_NS           = 6;               // XEROX NS protocols
  AF_ISO          = 7;               // ISO protocols
  AF_OSI          = AF_ISO;          // OSI is ISO
  AF_ECMA         = 8;               // european computer manufacturers
  AF_DATAKIT      = 9;               // datakit protocols
  AF_CCITT        = 10;              // CCITT protocols, X.25 etc
  AF_SNA          = 11;              // IBM SNA
  AF_DECnet       = 12;              // DECnet
  AF_DLI          = 13;              // Direct data link interface
  AF_LAT          = 14;              // LAT
  AF_HYLINK       = 15;              // NSC Hyperchannel
  AF_APPLETALK    = 16;              // AppleTalk
  AF_NETBIOS      = 17;              // NetBios-style addresses
  AF_VOICEVIEW    = 18;              // VoiceView
  AF_FIREFOX      = 19;              // FireFox
  AF_UNKNOWN1     = 20;              // Somebody is using this!
  AF_BAN          = 21;              // Banyan

  AF_MAX          = 22;

// Protocol families, same as address families for now.

  PF_UNSPEC       = AF_UNSPEC;
  PF_UNIX         = AF_UNIX;
  PF_INET         = AF_INET;
  PF_IMPLINK      = AF_IMPLINK;
  PF_PUP          = AF_PUP;
  PF_CHAOS        = AF_CHAOS;
  PF_NS           = AF_NS;
  PF_IPX          = AF_IPX;
  PF_ISO          = AF_ISO;
  PF_OSI          = AF_OSI;
  PF_ECMA         = AF_ECMA;
  PF_DATAKIT      = AF_DATAKIT;
  PF_CCITT        = AF_CCITT;
  PF_SNA          = AF_SNA;
  PF_DECnet       = AF_DECnet;
  PF_DLI          = AF_DLI;
  PF_LAT          = AF_LAT;
  PF_HYLINK       = AF_HYLINK;
  PF_APPLETALK    = AF_APPLETALK;
  PF_VOICEVIEW    = AF_VOICEVIEW;
  PF_FIREFOX      = AF_FIREFOX;
  PF_UNKNOWN1     = AF_UNKNOWN1;
  PF_BAN          = AF_BAN;

  PF_MAX          = AF_MAX;

// Level number for (get/set)sockopt() to apply to socket itself.

  SOL_SOCKET      = $FFFF;

// Maximum queue length specifiable by listen.

  SOMAXCONN       = 5;

  MSG_OOB         = $01;            //process out-of-band data
  MSG_PEEK        = $02;            //peek at incoming message
  MSG_DONTROUTE   = $04;            //send without using routing tables

  MSG_MAXIOVLEN   = $10;

  MSG_PARTIAL     = $8000;          //partial send or recv for message xport

// Define constant based on rfc883, used by gethostbyxxxx() calls.

  MAXGETHOSTSTRUCT        = $400;

// Define flags to be used with the WSAAsyncSelect() call.

  FD_READ         = $01;
  FD_WRITE        = $02;
  FD_OOB          = $04;
  FD_ACCEPT       = $08;
  FD_CONNECT      = $10;
  FD_CLOSE        = $20;

// All Windows Sockets error constants are biased by WSABASEERR from the "normal"

  WSABASEERR              = 10000;

// Windows Sockets definitions of regular Microsoft C error constants

  WSAEINTR                = (WSABASEERR+4);
  WSAEBADF                = (WSABASEERR+9);
  WSAEACCES               = (WSABASEERR+13);
  WSAEFAULT               = (WSABASEERR+14);
  WSAEINVAL               = (WSABASEERR+22);
  WSAEMFILE               = (WSABASEERR+24);

// Windows Sockets definitions of regular Berkeley error constants

  WSAEWOULDBLOCK          = (WSABASEERR+35);
  WSAEINPROGRESS          = (WSABASEERR+36);
  WSAEALREADY             = (WSABASEERR+37);
  WSAENOTSOCK             = (WSABASEERR+38);
  WSAEDESTADDRREQ         = (WSABASEERR+39);
  WSAEMSGSIZE             = (WSABASEERR+40);
  WSAEPROTOTYPE           = (WSABASEERR+41);
  WSAENOPROTOOPT          = (WSABASEERR+42);
  WSAEPROTONOSUPPORT      = (WSABASEERR+43);
  WSAESOCKTNOSUPPORT      = (WSABASEERR+44);
  WSAEOPNOTSUPP           = (WSABASEERR+45);
  WSAEPFNOSUPPORT         = (WSABASEERR+46);
  WSAEAFNOSUPPORT         = (WSABASEERR+47);
  WSAEADDRINUSE           = (WSABASEERR+48);
  WSAEADDRNOTAVAIL        = (WSABASEERR+49);
  WSAENETDOWN             = (WSABASEERR+50);
  WSAENETUNREACH          = (WSABASEERR+51);
  WSAENETRESET            = (WSABASEERR+52);
  WSAECONNABORTED         = (WSABASEERR+53);
  WSAECONNRESET           = (WSABASEERR+54);
  WSAENOBUFS              = (WSABASEERR+55);
  WSAEISCONN              = (WSABASEERR+56);
  WSAENOTCONN             = (WSABASEERR+57);
  WSAESHUTDOWN            = (WSABASEERR+58);
  WSAETOOMANYREFS         = (WSABASEERR+59);
  WSAETIMEDOUT            = (WSABASEERR+60);
  WSAECONNREFUSED         = (WSABASEERR+61);
  WSAELOOP                = (WSABASEERR+62);
  WSAENAMETOOLONG         = (WSABASEERR+63);
  WSAEHOSTDOWN            = (WSABASEERR+64);
  WSAEHOSTUNREACH         = (WSABASEERR+65);
  WSAENOTEMPTY            = (WSABASEERR+66);
  WSAEPROCLIM             = (WSABASEERR+67);
  WSAEUSERS               = (WSABASEERR+68);
  WSAEDQUOT               = (WSABASEERR+69);
  WSAESTALE               = (WSABASEERR+70);
  WSAEREMOTE              = (WSABASEERR+71);

  WSAEDISCON              = (WSABASEERR+101);

// Extended Windows Sockets error constant definitions

  WSASYSNOTREADY          = (WSABASEERR+91);
  WSAVERNOTSUPPORTED      = (WSABASEERR+92);
  WSANOTINITIALISED       = (WSABASEERR+93);

// Error return codes from gethostbyname() and gethostbyaddr()
//  (when using the resolver). Note that these errors are
//  retrieved via WSAGetLastError() and must therefore follow
//  the rules for avoiding clashes with error numbers from
//  specific implementations or language run-time systems.
//  For this reason the codes are based at WSABASEERR+1001.
//  Note also that [WSA]NO_ADDRESS is defined only for
//  compatibility purposes.

// Authoritative Answer: Host not found

  WSAHOST_NOT_FOUND       = (WSABASEERR+1001);
  HOST_NOT_FOUND          = WSAHOST_NOT_FOUND;

// Non-Authoritative: Host not found, or SERVERFAIL

  WSATRY_AGAIN            = (WSABASEERR+1002);
  TRY_AGAIN               = WSATRY_AGAIN;

// Non recoverable errors, FORMERR, REFUSED, NOTIMP

  WSANO_RECOVERY          = (WSABASEERR+1003);
  NO_RECOVERY             = WSANO_RECOVERY;

// Valid name, no data record of requested type

  WSANO_DATA              = (WSABASEERR+1004);
  NO_DATA                 = WSANO_DATA;

// no address, look for MX record

  WSANO_ADDRESS           = WSANO_DATA;
  NO_ADDRESS              = WSANO_ADDRESS;

// Windows Sockets errors redefined as regular Berkeley error constants.
// These are commented out in Windows NT to avoid conflicts with errno.h.
// Use the WSA constants instead.

  EWOULDBLOCK        =  WSAEWOULDBLOCK;
  EINPROGRESS        =  WSAEINPROGRESS;
  EALREADY           =  WSAEALREADY;
  ENOTSOCK           =  WSAENOTSOCK;
  EDESTADDRREQ       =  WSAEDESTADDRREQ;
  EMSGSIZE           =  WSAEMSGSIZE;
  EPROTOTYPE         =  WSAEPROTOTYPE;
  ENOPROTOOPT        =  WSAENOPROTOOPT;
  EPROTONOSUPPORT    =  WSAEPROTONOSUPPORT;
  ESOCKTNOSUPPORT    =  WSAESOCKTNOSUPPORT;
  EOPNOTSUPP         =  WSAEOPNOTSUPP;
  EPFNOSUPPORT       =  WSAEPFNOSUPPORT;
  EAFNOSUPPORT       =  WSAEAFNOSUPPORT;
  EADDRINUSE         =  WSAEADDRINUSE;
  EADDRNOTAVAIL      =  WSAEADDRNOTAVAIL;
  ENETDOWN           =  WSAENETDOWN;
  ENETUNREACH        =  WSAENETUNREACH;
  ENETRESET          =  WSAENETRESET;
  ECONNABORTED       =  WSAECONNABORTED;
  ECONNRESET         =  WSAECONNRESET;
  ENOBUFS            =  WSAENOBUFS;
  EISCONN            =  WSAEISCONN;
  ENOTCONN           =  WSAENOTCONN;
  ESHUTDOWN          =  WSAESHUTDOWN;
  ETOOMANYREFS       =  WSAETOOMANYREFS;
  ETIMEDOUT          =  WSAETIMEDOUT;
  ECONNREFUSED       =  WSAECONNREFUSED;
  ELOOP              =  WSAELOOP;
  ENAMETOOLONG       =  WSAENAMETOOLONG;
  EHOSTDOWN          =  WSAEHOSTDOWN;
  EHOSTUNREACH       =  WSAEHOSTUNREACH;
  ENOTEMPTY          =  WSAENOTEMPTY;
  EPROCLIM           =  WSAEPROCLIM;
  EUSERS             =  WSAEUSERS;
  EDQUOT             =  WSAEDQUOT;
  ESTALE             =  WSAESTALE;
  EREMOTE            =  WSAEREMOTE;

type
  PFDSet = ^TFDSet;
  TFDSet = packed record
    fd_count: u_int;
    fd_array: array[0..FD_SETSIZE-1] of TSocket;
  end;

  PTimeVal = ^TTimeVal;
  TTimeVal = packed record
    tv_sec: Longint;
    tv_usec: Longint;
  end;

  PHostEnt = ^THostEnt;
  THostEnt = packed record
    h_name: PChar;
    h_aliases: ^PChar;
    h_addrtype: Smallint;
    h_length: Smallint;
    case Byte of
      0: (h_addr_list: ^PChar);
      1: (h_addr: ^PChar)
  end;

  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;

  SunW = packed record
    s_w1, s_w2: u_short;
  end;

  PInAddr = ^TInAddr;
  TInAddr = packed record
    case Longint of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;

  PSockAddrIn = ^TSockAddrIn;
  TSockAddrIn = packed record
    case Longint of
      0: (sin_family: u_short;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: array[0..7] of Char);
      1: (sa_family: u_short;
          sa_data: array[0..13] of Char)
  end;

  PWSAData = ^TWSAData;
  TWSAData = packed record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array[0..WSADESCRIPTION_LEN] of Char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
  end;

  PTransmitFileBuffers = ^TTransmitFileBuffers;
  TTransmitFileBuffers = packed record
    Head: Pointer;
    HeadLength: DWORD;
    Tail: Pointer;
    TailLength: DWORD;
  end;

// Structure used by kernel to store most addresses.

  PSockAddr = ^TSockAddr;
  TSockAddr = TSockAddrIn;

// Structure used by kernel to pass protocol information in raw sockets.
  PSockProto = ^TSockProto;
  TSockProto = packed record
    sp_family: u_short;
    sp_protocol: u_short;
  end;

// Structure used for manipulating linger option.
  PLinger = ^TLinger;
  TLinger = packed record
    l_onoff: u_short;
    l_linger: u_short;
  end;

  PNetEnt = ^TNetEnt;
  TNetEnt = packed record
    n_name: PChar;
    n_aliases: ^PChar;
    n_addrtype: Smallint;
    n_net: u_long;
  end;

  PServEnt = ^TServEnt;
  TServEnt = packed record
    s_name: PChar;
    s_aliases: ^PChar;
    s_port: Smallint;
    s_proto: PChar;
  end;

  PProtoEnt = ^TProtoEnt;
  TProtoEnt = packed record
    p_name: PChar;
    p_aliases: ^Pchar;
    p_proto: Smallint;
  end;


////////////////////////////////////////////////////////////////////////////
function accept conv arg_stdcall (s: TSocket; addr: PSockAddr; addrlen: PLongint): TSocket;
  external wsock32dll name 'accept';

function bind conv arg_stdcall (s: TSocket; var addr: TSockAddr; namelen: Longint): Longint;
  external wsock32dll name 'bind';

function closesocket conv arg_stdcall (s: TSocket): Longint;
  external wsock32dll name 'closesocket';

function connect conv arg_stdcall (s: TSocket; var name: TSockAddr; namelen: Longint): Longint;
  external wsock32dll name 'connect';

function getpeername conv arg_stdcall (s: TSocket; var name: TSockAddr; var namelen: Longint): Longint;
  external wsock32dll name 'getpeername';

function getsockname conv arg_stdcall (s: TSocket; var name: TSockAddr; var namelen: Longint): Longint;
  external wsock32dll name 'getsockname';

function getsockopt conv arg_stdcall (s: TSocket; level, optname: Longint; optval: PChar; var optlen: Longint): Longint;
  external wsock32dll name 'getsockopt';

function htonl conv arg_stdcall (hostlong: u_long): u_long;
  external wsock32dll name 'htonl';

function htons conv arg_stdcall (hostshort: u_short): u_short;
  external wsock32dll name 'htons';

function inet_addr conv arg_stdcall (cp: PChar): u_long;
  external wsock32dll name 'inet_addr';

function inet_ntoa conv arg_stdcall (inaddr: TInAddr): PChar;
  external wsock32dll name 'inet_ntoa';

function ioctlsocket conv arg_stdcall (s: TSocket; cmd: Longint; var arg: u_long): Longint;
  external wsock32dll name 'ioctlsocket';

function listen conv arg_stdcall (s: TSocket; backlog: Longint): Longint;
  external wsock32dll name 'listen';

function ntohl conv arg_stdcall (netlong: u_long): u_long;
  external wsock32dll name 'ntohl';

function ntohs conv arg_stdcall (netshort: u_short): u_short;
  external wsock32dll name 'ntohs';

function recv conv arg_stdcall (s: TSocket; var Buf; len, flags: Longint): Longint;
  external wsock32dll name 'recv';

function recvfrom conv arg_stdcall (s: TSocket; var Buf; len, flags: Longint;
  var from: TSockAddr; var fromlen: Longint): Longint;
  external wsock32dll name 'recvfrom';

function select conv arg_stdcall (nfds: Longint; readfds, writefds, exceptfds: PFDSet; timeout: PTimeVal): Longint;
  external wsock32dll name 'select';

function send conv arg_stdcall (s: TSocket; var Buf; len, flags: Longint): Longint;
  external wsock32dll name 'send';

function sendto conv arg_stdcall (s: TSocket; var Buf; len, flags: Longint; var addrto: TSockAddr; tolen: Longint): Longint;
  external wsock32dll name 'sendto';

function setsockopt conv arg_stdcall (s: TSocket; level, optname: Longint; optval: PChar; optlen: Longint): Longint;
  external wsock32dll name 'setsockopt';

function shutdown conv arg_stdcall (s: TSocket; how: Longint): Longint;
  external wsock32dll name 'shutdown';

function socket conv arg_stdcall (af, struct, protocol: Longint): TSocket;
  external wsock32dll name 'socket';

function gethostbyaddr conv arg_stdcall (addr: Pointer; len, addrtype: Longint): PHostEnt;
  external wsock32dll name 'gethostbyaddr';

function gethostbyname conv arg_stdcall (name: PChar): PHostEnt;
  external wsock32dll name 'gethostbyname';

function getprotobyname conv arg_stdcall (name: PChar): PProtoEnt;
  external wsock32dll name 'getprotobyname';

function getprotobynumber conv arg_stdcall (proto: Longint): PProtoEnt;
  external wsock32dll name 'getprotobynumber';

function getservbyname conv arg_stdcall (name, proto: PChar): PServEnt;
  external wsock32dll name 'getservbyname';

function getservbyport conv arg_stdcall (port: Longint; proto: PChar): PServEnt;
  external wsock32dll name 'getservbyport';

function gethostname conv arg_stdcall (name: PChar; len: Longint): Longint;
  external wsock32dll name 'gethostname';

function WSAAsyncSelect conv arg_stdcall (s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Longint;
  external wsock32dll name 'WSAAsyncSelect';

function WSARecvEx conv arg_stdcall (s: TSocket; var buf; len: Longint; var flags: Longint): Longint;
  external wsock32dll name 'WSARecvEx';

function WSAAsyncGetHostByAddr conv arg_stdcall (HWindow: HWND; wMsg: u_int; addr: PChar; len, struct: Longint; buf: PChar; buflen: Longint): THandle;
  external wsock32dll name 'WSAAsyncGetHostByAddr';

function WSAAsyncGetHostByName conv arg_stdcall (HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Longint): THandle;
  external wsock32dll name 'WSAAsyncGetHostByName';

function WSAAsyncGetProtoByNumber conv arg_stdcall (HWindow: HWND; wMsg: u_int; number: Longint; buf: PChar; buflen: Longint): THandle;
  external wsock32dll name 'WSAAsyncGetProtoByNumber';

function WSAAsyncGetProtoByName conv arg_stdcall (HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Longint): THandle;
  external wsock32dll name 'WSAAsyncGetProtoByName';

function WSAAsyncGetServByPort conv arg_stdcall ( HWindow: HWND; wMsg, port: u_int; proto, buf: PChar; buflen: Longint): THandle;
  external wsock32dll name 'WSAAsyncGetServByPort';

function WSAAsyncGetServByName conv arg_stdcall (HWindow: HWND; wMsg: u_int; name, proto, buf: PChar; buflen: Longint): THandle;
  external wsock32dll name 'WSAAsyncGetServByName';

function WSACancelAsyncRequest conv arg_stdcall (hAsyncTaskHandle: THandle): Longint;
  external wsock32dll name 'WSACancelAsyncRequest';

function WSASetBlockingHook conv arg_stdcall (lpBlockFunc: TFarProc): TFarProc;
  external wsock32dll name 'WSASetBlockingHook';

function WSAUnhookBlockingHook: Longint; stdcall;
  external wsock32dll name 'WSAUnhookBlockingHook';

function WSAGetLastError: Longint; stdcall;
  external wsock32dll name 'WSAGetLastError';

procedure WSASetLastError conv arg_stdcall (iError: Longint);
  external wsock32dll name 'WSASetLastError';

function WSACancelBlockingCall: Longint; stdcall;
  external wsock32dll name 'WSACancelBlockingCall';

function WSAIsBlocking: BOOL; stdcall;
  external wsock32dll name 'WSAIsBlocking';

function WSAStartup conv arg_stdcall (wVersionRequired: word; var WSData: TWSAData): Longint;
  external wsock32dll name 'WSAStartup';

function WSACleanup: Longint;
  external wsock32dll name 'WSACleanup';

function __WSAFDIsSet conv arg_stdcall (s: TSOcket; var FDSet: TFDSet): Bool;
  external wsock32dll name '__WSAFDIsSet';

function TransmitFile conv arg_stdcall (hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD;
  nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped;
  lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL;
  external wsock32dll name 'TransmitFile';

function AcceptEx conv arg_stdcall (sListenSocket, sAcceptSocket: TSocket;
  lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength,
  dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD;
  lpOverlapped: POverlapped): BOOL;
  external  wsock32dll name 'AcceptEx';

procedure GetAcceptExSockaddrs conv arg_stdcall (lpOutputBuffer: Pointer;
  dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD;
  var LocalSockaddr: TSockAddr; var LocalSockaddrLength: Longint;
  var RemoteSockaddr: TSockAddr; var RemoteSockaddrLength: Longint);
  external wsock32dll name 'GetAcceptExSockaddrs';

function  WSAMakeSyncReply(Buflen, Error: Word): Longint;
function  WSAMakeSelectReply(Event, Error: Word): Longint;
function  WSAGetAsyncBuflen(Param: Longint): Word;
function  WSAGetAsyncError(Param: Longint): Word;
function  WSAGetSelectEvent(Param: Longint): Word;
function  WSAGetSelectError(Param: Longint): Word;
procedure FD_CLR(Socket: TSocket; var FDSet: TFDSet);
function  FD_ISSET(Socket: TSocket; var FDSet: TFDSet): Boolean;
procedure FD_SET(Socket: TSocket; var FDSet: TFDSet);
procedure FD_ZERO(var FDSet: TFDSet);

implementation

function WSAMakeSyncReply;
begin
  WSAMakeSyncReply := Buflen or Error shl 16;
end;

function WSAMakeSelectReply;
begin
  WSAMakeSelectReply:= Event or Error shl 16;
end;

function WSAGetAsyncBuflen;
begin
  WSAGetAsyncBuflen := Word(Param);
end;

function WSAGetAsyncError;
begin
  WSAGetAsyncError := Word(Param shr 16);
end;

function WSAGetSelectEvent;
begin
  WSAGetSelectEvent := Word(Param);
end;

function WSAGetSelectError;
begin
  WSAGetSelectError:= Word(Param shr 16);
end;

procedure FD_CLR(Socket: TSocket; var FDSet: TFDSet);
var
  i: Longint := 0;
begin
  while i < FDSet.fd_count do
  begin
    if FDSet.fd_array[i] = Socket then
    begin
      while i < FDSet.fd_count - 1 do
      begin
        FDSet.fd_array[i] := FDSet.fd_array[i + 1];
        i +:= 1;
      end;
      Dec(FDSet.fd_count);
      Break;
    end;
    i +:= 1;
  end;
end;

function FD_ISSET(Socket: TSocket; var FDSet: TFDSet): Boolean;
begin
  Result := __WSAFDIsSet(Socket, FDSet);
end;

procedure FD_SET(Socket: TSocket; var FDSet: TFDSet);
begin
  if FDSet.fd_count < FD_SETSIZE then begin
    FDSet.fd_array[FDSet.fd_count] := Socket;
    FDSet.fd_count +:= 1;
  end;
end;

procedure FD_ZERO(var FDSet: TFDSet);
begin
  FDSet.fd_count := 0;
end;

end.
