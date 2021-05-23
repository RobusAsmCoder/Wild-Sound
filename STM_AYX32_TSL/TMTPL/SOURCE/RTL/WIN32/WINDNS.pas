(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit DNS API interface unit                   *)
(*       Based on windns.h                                      *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995, 2001 TMT Development Corporation   *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

unit WinDNS;

interface

uses
  Windows;

type
  DNS_STATUS = Longint;

type
  IP4_ADDRESS = DWORD;
  PIP4_ADDRESS = ^IP4_ADDRESS;
  TIP4Address = IP4_ADDRESS;
  PIP4Address = PIP4_ADDRESS;

const
  SIZEOF_IP4_ADDRESS         = 4;
  IP4_ADDRESS_STRING_LENGTH  = 15;

type
  _IP4_ARRAY =  record
    AddrCount: DWORD;
    AddrArray: array [0..0] of IP4_ADDRESS;
  end;
  IP4_ARRAY = _IP4_ARRAY;
  PIP4_ARRAY = ^IP4_ARRAY;
  TIP4Array = IP4_ARRAY;
  PIP4Array = PIP4_ARRAY;

  DNS_IP6_ADDRESS =  record
    IP6Word: array [0..7] of WORD;
  end;
  PDNS_IP6_ADDRESS = ^DNS_IP6_ADDRESS;
  TDnsIP6Address = DNS_IP6_ADDRESS;
  PDnsIP6Address = PDNS_IP6_ADDRESS;

const
  IPV6_ADDRESS_STRING_LENGTH = 39;

procedure INLINE_WORD_FLIP(var Out_: WORD; In_: WORD);
procedure INLINE_HTONS(var Out_: WORD; In_: WORD);
procedure INLINE_NTOHS(var Out_: WORD; In_: WORD);
procedure INLINE_DWORD_FLIP(var Out_: DWORD; In_: DWORD);
procedure INLINE_NTOHL(var Out_: DWORD; In_: DWORD);
procedure INLINE_HTONL(var Out_: DWORD; In_: DWORD);
procedure INLINE_WRITE_FLIPPED_WORD(pout: PWORD; In_: WORD);
procedure INLINE_WRITE_FLIPPED_DWORD(pout: PDWORD; In_: DWORD);

const
  DNS_PORT_HOST_ORDER = $0035;    // port 53
  DNS_PORT_NET_ORDER  = $3500;

  DNS_RFC_MAX_UDP_PACKET_LENGTH = 512;
  DNS_MAX_NAME_LENGTH            = 255;
  DNS_MAX_LABEL_LENGTH           = 63;
  DNS_MAX_NAME_BUFFER_LENGTH     = 256;
  DNS_MAX_LABEL_BUFFER_LENGTH    = 64;

//
//  Reverse lookup domain names
//

  DNS_REVERSE_DOMAIN_STRING = 'in-addr.arpa.';

  //DNS_MAX_REVERSE_NAME_LENGTH = IP_ADDRESS_STRING_LENGTH + 1 + Length(DNS_REVERSE_DOMAIN_STRING) + 1;

  //DNS_MAX_REVERSE_NAME_BUFFER_LENGTH = DNS_MAX_REVERSE_NAME_LENGTH + 1;

//
//  DNS Text string limited by size representable
//      in a single byte length field

  DNS_MAX_TEXT_STRING_LENGTH = 255;

//
//  DNS Message Header
//

type
  _DNS_HEADER = packed record
    Xid: WORD;
    Flags: Byte;
    Flags2: Byte;
    QuestionCount: WORD;
    AnswerCount: WORD;
    NameServerCount: WORD;
    AdditionalCount: WORD;
  end;
  DNS_HEADER = _DNS_HEADER;
  PDNS_HEADER = ^DNS_HEADER;
  TDnsHeader = DNS_HEADER;
  PDnsHeader = PDNS_HEADER;

//
//  Flags as WORD
//

function DNS_HEADER_FLAGS(pHead: PDNS_HEADER): WORD;

//
//  Byte flip DNS header to\from host order.
//
//  Note that this does NOT flip flags, as definition above defines
//  flags as individual bytes for direct access to net byte order.
//

procedure DNS_BYTE_FLIP_HEADER_COUNTS(var pHeader: PDNS_HEADER);

//
//  Question name follows header
//

const
  DNS_OFFSET_TO_QUESTION_NAME = SizeOf(DNS_HEADER);

//
//  Question immediately follows header so compressed question name
//      0xC000 | sizeof(DNS_HEADER)

  DNS_COMPRESSED_QUESTION_NAME = $C00C;

//
//  DNS Question
//

type
  _DNS_WIRE_QUESTION = packed record
    //  Preceded by question name
    QuestionType: WORD;
    QuestionClass: WORD;
  end;
  DNS_WIRE_QUESTION = _DNS_WIRE_QUESTION;
  PDNS_WIRE_QUESTION = ^DNS_WIRE_QUESTION;
  TDnsWireQuestion = DNS_WIRE_QUESTION;
  PDnsWireQuestion = PDNS_WIRE_QUESTION;

//
//  DNS Resource Record
//

  _DNS_WIRE_RECORD = packed record
    //  Preceded by record owner name
    RecordType: WORD;
    RecordClass: WORD;
    TimeToLive: DWORD;
    DataLength: WORD;
    //  Followed by record data
  end;
  DNS_WIRE_RECORD = _DNS_WIRE_RECORD;
  PDNS_WIRE_RECORD = ^DNS_WIRE_RECORD;
  TDnsWireRecord = DNS_WIRE_RECORD;
  PDnsWireRecord = PDNS_WIRE_RECORD;

//
//  DNS Query Types
//

const
  DNS_OPCODE_QUERY         = 0; // Query
  DNS_OPCODE_IQUERY        = 1; // Obsolete: IP to name
  DNS_OPCODE_SERVER_STATUS = 2; // Obsolete: DNS ping
  DNS_OPCODE_UNKNOWN       = 3; // Unknown
  DNS_OPCODE_NOTIFY        = 4; // Notify
  DNS_OPCODE_UPDATE        = 5; // Dynamic Update

//
//  DNS response codes.
//
//  Sent in the "ResponseCode" field of a DNS_HEADER.
//

  DNS_RCODE_NOERROR  = 0;
  DNS_RCODE_FORMERR  = 1; // Format error
  DNS_RCODE_SERVFAIL = 2; // Server failure
  DNS_RCODE_NXDOMAIN = 3; // Name error
  DNS_RCODE_NOTIMPL  = 4; // Not implemented
  DNS_RCODE_REFUSED  = 5; // Refused
  DNS_RCODE_YXDOMAIN = 6; // Domain name should not exist
  DNS_RCODE_YXRRSET  = 7; // RR set should not exist
  DNS_RCODE_NXRRSET  = 8; // RR set does not exist
  DNS_RCODE_NOTAUTH  = 9; // Not authoritative for zone
  DNS_RCODE_NOTZONE  = 10; // Name is not zone
  DNS_RCODE_MAX      = 15;

//
//  Extended RCODEs
//

  DNS_RCODE_BADSIG  = 16; // Bad signature
  DNS_RCODE_BADKEY  = 17; // Bad key
  DNS_RCODE_BADTIME = 18; // Bad timestamp

//
//  Mappings to friendly names
//

  DNS_RCODE_NO_ERROR        = DNS_RCODE_NOERROR;
  DNS_RCODE_FORMAT_ERROR    = DNS_RCODE_FORMERR;
  DNS_RCODE_SERVER_FAILURE  = DNS_RCODE_SERVFAIL;
  DNS_RCODE_NAME_ERROR      = DNS_RCODE_NXDOMAIN;
  DNS_RCODE_NOT_IMPLEMENTED = DNS_RCODE_NOTIMPL;

//
//  DNS Classes
//
//  Classes are on the wire as WORDs.
//
//  _CLASS_ defines in host order.
//  _RCLASS_ defines in net byte order.
//
//  Generally we'll avoid byte flip and test class in net byte order.
//

  DNS_CLASS_INTERNET = $0001; // 1
  DNS_CLASS_CSNET    = $0002; // 2
  DNS_CLASS_CHAOS    = $0003; // 3
  DNS_CLASS_HESIOD   = $0004; // 4
  DNS_CLASS_NONE     = $00fe; // 254
  DNS_CLASS_ALL      = $00ff; // 255
  DNS_CLASS_ANY      = $00ff; // 255

  DNS_RCLASS_INTERNET = $0100; // 1
  DNS_RCLASS_CSNET    = $0200; // 2
  DNS_RCLASS_CHAOS    = $0300; // 3
  DNS_RCLASS_HESIOD   = $0400; // 4
  DNS_RCLASS_NONE     = $fe00; // 254
  DNS_RCLASS_ALL      = $ff00; // 255
  DNS_RCLASS_ANY      = $ff00; // 255

//
//  DNS Record Types
//
//  _TYPE_ defines are in host byte order.
//  _RTYPE_ defines are in net byte order.
//
//  Generally always deal with types in host byte order as we index
//  resource record functions by type.
//

  DNS_TYPE_ZERO = $0000;

//  RFC 1034/1035

  DNS_TYPE_A     = $0001; // 1
  DNS_TYPE_NS    = $0002; // 2
  DNS_TYPE_MD    = $0003; // 3
  DNS_TYPE_MF    = $0004; // 4
  DNS_TYPE_CNAME = $0005; // 5
  DNS_TYPE_SOA   = $0006; // 6
  DNS_TYPE_MB    = $0007; // 7
  DNS_TYPE_MG    = $0008; // 8
  DNS_TYPE_MR    = $0009; // 9
  DNS_TYPE_NULL  = $000a; // 10
  DNS_TYPE_WKS   = $000b; // 11
  DNS_TYPE_PTR   = $000c; // 12
  DNS_TYPE_HINFO = $000d; // 13
  DNS_TYPE_MINFO = $000e; // 14
  DNS_TYPE_MX    = $000f; // 15
  DNS_TYPE_TEXT  = $0010; // 16

//  RFC 1183

  DNS_TYPE_RP    = $0011; // 17
  DNS_TYPE_AFSDB = $0012; // 18
  DNS_TYPE_X25   = $0013; // 19
  DNS_TYPE_ISDN  = $0014; // 20
  DNS_TYPE_RT    = $0015; // 21

//  RFC 1348

  DNS_TYPE_NSAP    = $0016; // 22
  DNS_TYPE_NSAPPTR = $0017; // 23

//  RFC 2065    (DNS security)

  DNS_TYPE_SIG = $0018; // 24
  DNS_TYPE_KEY = $0019; // 25

//  RFC 1664    (X.400 mail)

  DNS_TYPE_PX = $001a; // 26

//  RFC 1712    (Geographic position)

  DNS_TYPE_GPOS = $001b; // 27

//  RFC 1886    (IPv6 Address)

  DNS_TYPE_AAAA = $001c; // 28

//  RFC 1876    (Geographic location)

  DNS_TYPE_LOC = $001d; // 29

//  RFC 2065    (Secure negative response)

  DNS_TYPE_NXT = $001e; // 30

//  RFC 2052    (Service location)

  DNS_TYPE_SRV = $0021; // 33

//  ATM Standard something-or-another

  DNS_TYPE_ATMA = $0022; // 34

//
//  Query only types (1035, 1995)
//

  DNS_TYPE_TKEY  = $00f9; // 249
  DNS_TYPE_TSIG  = $00fa; // 250
  DNS_TYPE_IXFR  = $00fb; // 251
  DNS_TYPE_AXFR  = $00fc; // 252
  DNS_TYPE_MAILB = $00fd; // 253
  DNS_TYPE_MAILA = $00fe; // 254
  DNS_TYPE_ALL   = $00ff; // 255
  DNS_TYPE_ANY   = $00ff; // 255

//
//  Temp Microsoft types -- use until get IANA approval for real type
//

  DNS_TYPE_WINS   = $ff01; // 64K - 255
  DNS_TYPE_WINSR  = $ff02; // 64K - 254
  DNS_TYPE_NBSTAT = (DNS_TYPE_WINSR);


//
//  DNS Record Types -- Net Byte Order
//

  DNS_RTYPE_A     = $0100; // 1
  DNS_RTYPE_NS    = $0200; // 2
  DNS_RTYPE_MD    = $0300; // 3
  DNS_RTYPE_MF    = $0400; // 4
  DNS_RTYPE_CNAME = $0500; // 5
  DNS_RTYPE_SOA   = $0600; // 6
  DNS_RTYPE_MB    = $0700; // 7
  DNS_RTYPE_MG    = $0800; // 8
  DNS_RTYPE_MR    = $0900; // 9
  DNS_RTYPE_NULL  = $0a00; // 10
  DNS_RTYPE_WKS   = $0b00; // 11
  DNS_RTYPE_PTR   = $0c00; // 12
  DNS_RTYPE_HINFO = $0d00; // 13
  DNS_RTYPE_MINFO = $0e00; // 14
  DNS_RTYPE_MX    = $0f00; // 15
  DNS_RTYPE_TEXT  = $1000; // 16

//  RFC 1183

  DNS_RTYPE_RP    = $1100; // 17
  DNS_RTYPE_AFSDB = $1200; // 18
  DNS_RTYPE_X25   = $1300; // 19
  DNS_RTYPE_ISDN  = $1400; // 20
  DNS_RTYPE_RT    = $1500; // 21

//  RFC 1348

  DNS_RTYPE_NSAP    = $1600; // 22
  DNS_RTYPE_NSAPPTR = $1700; // 23

//  RFC 2065    (DNS security)

  DNS_RTYPE_SIG = $1800; // 24
  DNS_RTYPE_KEY = $1900; // 25

//  RFC 1664    (X.400 mail)

  DNS_RTYPE_PX = $1a00; // 26

//  RFC 1712    (Geographic position)

  DNS_RTYPE_GPOS = $1b00; // 27

//  RFC 1886    (IPv6 Address)

  DNS_RTYPE_AAAA = $1c00; // 28

//  RFC 1876    (Geographic location)

  DNS_RTYPE_LOC = $1d00; // 29

//  RFC 2065    (Secure negative response)

  DNS_RTYPE_NXT = $1e00; // 30

//  RFC 2052    (Service location)

  DNS_RTYPE_SRV = $2100; // 33

//  ATM Standard something-or-another

  DNS_RTYPE_ATMA = $2200; // 34

//
//  Query only types (1035, 1995)
//

  DNS_RTYPE_TKEY  = $f900; // 249
  DNS_RTYPE_TSIG  = $fa00; // 250
  DNS_RTYPE_IXFR  = $fb00; // 251
  DNS_RTYPE_AXFR  = $fc00; // 252
  DNS_RTYPE_MAILB = $fd00; // 253
  DNS_RTYPE_MAILA = $fe00; // 254
  DNS_RTYPE_ALL   = $ff00; // 255
  DNS_RTYPE_ANY   = $ff00; // 255

//
//  Temp Microsoft types -- use until get IANA approval for real type
//

  DNS_RTYPE_WINS  = $01ff; // 64K - 255
  DNS_RTYPE_WINSR = $02ff; // 64K - 254

//
//  Record type specific definitions
//

//
//  ATMA (ATM address type) formats
//
//  Define these directly for any environment (ex NT4)
//  without winsock2 ATM support (ws2atm.h)
//

{$IFNDEF ATMA_E164}
  DNS_ATMA_FORMAT_E164     = 1;
  DNS_ATMA_FORMAT_AESA     = 2;
  DNS_ATMA_MAX_ADDR_LENGTH = (20);
{$ELSE}
  DNS_ATMA_FORMAT_E164     = ATM_E164;
  DNS_ATMA_FORMAT_AESA     = ATM_AESA;
  DNS_ATMA_MAX_ADDR_LENGTH = ATM_ADDR_SIZE;
{$ENDIF}

  DNS_ATMA_AESA_ADDR_LENGTH  = (20);
  DNS_ATMA_MAX_RECORD_LENGTH = (DNS_ATMA_MAX_ADDR_LENGTH+1);

//
//  DNSSEC defs
//

//  DNSSEC algorithms

  DNSSEC_ALGORITHM_RSAMD5  = 1;
  DNSSEC_ALGORITHM_NULL    = 253;
  DNSSEC_ALGORITHM_PRIVATE = 254;

//  DNSSEC KEY protocol table

  DNSSEC_PROTOCOL_NONE   = 0;
  DNSSEC_PROTOCOL_TLS    = 1;
  DNSSEC_PROTOCOL_EMAIL  = 2;
  DNSSEC_PROTOCOL_DNSSEC = 3;
  DNSSEC_PROTOCOL_IPSEC  = 4;

//  DNSSEC KEY flag field

  DNSSEC_KEY_FLAG_NOAUTH = $0001;
  DNSSEC_KEY_FLAG_NOCONF = $0002;
  DNSSEC_KEY_FLAG_FLAG2  = $0004;
  DNSSEC_KEY_FLAG_EXTEND = $0008;
  DNSSEC_KEY_FLAG_FLAG4 = $0010;
  DNSSEC_KEY_FLAG_FLAG5 = $0020;

// bits 6,7 are name type

  DNSSEC_KEY_FLAG_USER  = $0000;
  DNSSEC_KEY_FLAG_ZONE  = $0040;
  DNSSEC_KEY_FLAG_HOST  = $0080;
  DNSSEC_KEY_FLAG_NTPE3 = $00c0;

// bits 8-11 are reserved for future use

  DNSSEC_KEY_FLAG_FLAG8  = $0100;
  DNSSEC_KEY_FLAG_FLAG9  = $0200;
  DNSSEC_KEY_FLAG_FLAG10 = $0400;
  DNSSEC_KEY_FLAG_FLAG11 = $0800;

// bits 12-15 are sig field

  DNSSEC_KEY_FLAG_SIG0  = $0000;
  DNSSEC_KEY_FLAG_SIG1  = $1000;
  DNSSEC_KEY_FLAG_SIG2  = $2000;
  DNSSEC_KEY_FLAG_SIG3  = $3000;
  DNSSEC_KEY_FLAG_SIG4  = $4000;
  DNSSEC_KEY_FLAG_SIG5  = $5000;
  DNSSEC_KEY_FLAG_SIG6  = $6000;
  DNSSEC_KEY_FLAG_SIG7  = $7000;
  DNSSEC_KEY_FLAG_SIG8  = $8000;
  DNSSEC_KEY_FLAG_SIG9  = $9000;
  DNSSEC_KEY_FLAG_SIG10 = $a000;
  DNSSEC_KEY_FLAG_SIG11 = $b000;
  DNSSEC_KEY_FLAG_SIG12 = $c000;
  DNSSEC_KEY_FLAG_SIG13 = $d000;
  DNSSEC_KEY_FLAG_SIG14 = $e000;
  DNSSEC_KEY_FLAG_SIG15 = $f000;

//
//  TKEY modes
//

  DNS_TKEY_MODE_SERVER_ASSIGN   = 1;
  DNS_TKEY_MODE_DIFFIE_HELLMAN  = 2;
  DNS_TKEY_MODE_GSS             = 3;
  DNS_TKEY_MODE_RESOLVER_ASSIGN = 4;

//
//  WINS + NBSTAT flag field
//

  DNS_WINS_FLAG_SCOPE = DWORD($80000000);
  DNS_WINS_FLAG_LOCAL = ($00010000);

//
//  Helpful checks
//

function IS_DWORD_ALIGNED(P: Pointer): BOOL;

function IS_QWORD_ALIGNED(P: Pointer): BOOL;

//
//  DNS config API
//

//
//  Types of DNS configuration info
//

type
  DNS_CONFIG_TYPE = (
    DnsConfigPrimaryDomainName_W,
    DnsConfigPrimaryDomainName_A,
    DnsConfigPrimaryDomainName_UTF8,
    DnsConfigAdapterDomainName_W,
    DnsConfigAdapterDomainName_A,
    DnsConfigAdapterDomainName_UTF8,
    DnsConfigDnsServerList,
    DnsConfigSearchList,
    DnsConfigAdapterInfo,
    DnsConfigPrimaryHostNameRegistrationEnabled,
    DnsConfigAdapterHostNameRegistrationEnabled,
    DnsConfigAddressRegistrationMaxCount);
  TDnsConfigType = DNS_CONFIG_TYPE;

//
//  Config API flags
//

//
//  Causes config info to be allocated with LocalAlloc()
//

const
  DNS_CONFIG_FLAG_ALLOC = $00000001;

function DnsQueryConfig(Config: DNS_CONFIG_TYPE; Flag: DWORD; pwsAdapterName: PWSTR;
  pReserved, pBuffer: Pointer; var pBufferLength: DWORD): DNS_STATUS; stdcall;

//
//  DNS resource record structure
//

//
//  Record data for specific types
//

type
  DNS_A_DATA = record
    IpAddress: IP4_ADDRESS;
  end;
  PDNS_A_DATA = ^DNS_A_DATA;
  TDnsAData = DNS_A_DATA;
  PDnsAData = PDNS_A_DATA;

  DNS_PTR_DATA = record
    pNameHost: LPTSTR;
  end;
  PDNS_PTR_DATA = ^DNS_PTR_DATA;
  TDnsPtrData = DNS_PTR_DATA;
  PDnsPtrData = PDNS_PTR_DATA;

  DNS_SOA_DATA = record
    pNamePrimaryServer: LPTSTR;
    pNameAdministrator: LPTSTR;
    dwSerialNo: DWORD;
    dwRefresh: DWORD;
    dwRetry: DWORD;
    dwExpire: DWORD;
    dwDefaultTtl: DWORD;
  end;
  PDNS_SOA_DATA = ^DNS_SOA_DATA;
  TDnsSoaData = DNS_SOA_DATA;
  PDnsSoaData = PDNS_SOA_DATA;

  DNS_MINFO_DATA = record
    pNameMailbox: LPTSTR;
    pNameErrorsMailbox: LPTSTR;
  end;
  PDNS_MINFO_DATA = ^DNS_MINFO_DATA;
  TDnsMInfoData = DNS_MINFO_DATA;
  PDnsMInfoData = PDNS_MINFO_DATA;

  DNS_MX_DATA = record
    pNameExchange: LPTSTR;
    wPreference: WORD;
    Pad: WORD;        // keep ptrs DWORD aligned
  end;
  PDNS_MX_DATA = ^DNS_MX_DATA;
  TDnsMxData = DNS_MX_DATA;
  PDnsMxData = PDNS_MX_DATA;

  DNS_TXT_DATA = record
    dwStringCount: DWORD;
    pStringArray: array [0..0] of LPTSTR;
  end;
  PDNS_TXT_DATA = ^DNS_TXT_DATA;
  TDnsTxtData = DNS_TXT_DATA;
  PDnsTxtData = PDNS_TXT_DATA;

  DNS_NULL_DATA = record
    dwByteCount: DWORD;
    Data: array [0..0] of Byte;
  end;
  PDNS_NULL_DATA = ^DNS_NULL_DATA;
  TDnsNullData = DNS_NULL_DATA;
  PDnsNullData = PDNS_NULL_DATA;

  DNS_WKS_DATA = record
    IpAddress: IP4_ADDRESS;
    chProtocol: UCHAR;
    BitMask: array [0..0] of Byte;
  end;
  PDNS_WKS_DATA = ^DNS_WKS_DATA;
  TDnsWksData = DNS_WKS_DATA;
  PDnsWksData = PDNS_WKS_DATA;

  DNS_AAAA_DATA = record
    Ip6Address: DNS_IP6_ADDRESS;
  end;
  PDNS_AAAA_DATA = ^DNS_AAAA_DATA;
  TDnsAAAAData = DNS_AAAA_DATA;
  PDnsAAAAData = PDNS_AAAA_DATA;

  DNS_SIG_DATA = record
    pNameSigner: LPTSTR;
    wTypeCovered: Word;
    chAlgorithm: Byte;
    chLabelCount: Byte;
    dwOriginalTtl: DWORD;
    dwExpiration: DWORD;
    dwTimeSigned: DWORD;
    wKeyTag: Word;
    Pad: Word;            // keep byte field aligned
    Signature: array [0..0] of Byte;
  end;
  PDNS_SIG_DATA = ^DNS_SIG_DATA;

  DNS_KEY_DATA = record
    wFlags: WORD;
    chProtocol: Byte;
    chAlgorithm: Byte;
    Key: array [0..0] of Byte;
  end;
  PDNS_KEY_DATA = ^DNS_KEY_DATA;

  DNS_LOC_DATA = record
    wVersion: WORD;
    wSize: WORD;
    wHorPrec: WORD;
    wVerPrec: WORD;
    dwLatitude: DWORD;
    dwLongitude: DWORD;
    dwAltitude: DWORD;
  end;
  PDNS_LOC_DATA = ^DNS_LOC_DATA;
  TDnsLocData = DNS_LOC_DATA;
  PDnsLocData = PDNS_LOC_DATA;

  DNS_NXT_DATA = record
    pNameNext: LPTSTR;
    bTypeBitMap: array [0..0] of Byte;
  end;
  PDNS_NXT_DATA = ^DNS_NXT_DATA;
  TDnsNxtData = DNS_NXT_DATA;
  PDnsNxtData = PDNS_NXT_DATA;

  DNS_SRV_DATA = record
    pNameTarget: LPTSTR;
    wPriority: WORD;
    wWeight: WORD;
    wPort: WORD;
    Pad: WORD;            // keep ptrs DWORD aligned
  end;
  PDNS_SRV_DATA = ^DNS_SRV_DATA;
  TDnsSrvData = DNS_SRV_DATA;
  PDnsSrvData = PDNS_SRV_DATA;

  DNS_ATMA_DATA = record
    AddressType: Byte;
    Address: array [0..DNS_ATMA_MAX_ADDR_LENGTH - 1] of Byte;

    //  E164 -- Null terminated string of less than
    //      DNS_ATMA_MAX_ADDR_LENGTH
    //
    //  For NSAP (AESA) BCD encoding of exactly
    //      DNS_ATMA_AESA_ADDR_LENGTH
  end;
  PDNS_ATMA_DATA = ^DNS_ATMA_DATA;
  TDnsAtmaData = DNS_ATMA_DATA;
  PDnsAtmaData = PDNS_ATMA_DATA;

  DNS_TKEY_DATA = record
    pNameAlgorithm: LPTSTR;
    pAlgorithmPacket: PByte;
    pKey: PByte;
    pOtherData: PByte;
    dwCreateTime: DWORD;
    dwExpireTime: DWORD;
    wMode: WORD;
    wError: WORD;
    wKeyLength: WORD;
    wOtherLength: WORD;
    cAlgNameLength: UCHAR;
    bPacketPointers: BOOL;
  end;
  PDNS_TKEY_DATA = ^DNS_TKEY_DATA;
  TDnsTKeyData = DNS_TKEY_DATA;
  PDnsTKeyData = PDNS_TKEY_DATA;

  DNS_TSIG_DATA = record
    pNameAlgorithm: LPTSTR;
    pAlgorithmPacket: PByte;
    pSignature: PByte;
    pOtherData: PByte;
    i64CreateTime: LONGLONG;
    wFudgeTime: WORD;
    wOriginalXid: WORD;
    wError: WORD;
    wSigLength: WORD;
    wOtherLength: WORD;
    cAlgNameLength: UCHAR;
    bPacketPointers: BOOL;
  end;
  PDNS_TSIG_DATA = ^DNS_TSIG_DATA;
  TDnsTSigData = DNS_TSIG_DATA;
  PDnsTSigData = PDNS_TSIG_DATA;

//
//  MS only types -- only hit the wire in MS-MS zone transfer
//

  DNS_WINS_DATA = record
    dwMappingFlag: DWORD;
    dwLookupTimeout: DWORD;
    dwCacheTimeout: DWORD;
    cWinsServerCount: DWORD;
    WinsServers: array [0..0] of IP4_ADDRESS;
  end;
  PDNS_WINS_DATA = ^DNS_WINS_DATA;
  TDnsWinsData = DNS_WINS_DATA;
  PDnsWinsData = PDNS_WINS_DATA;

  DNS_WINSR_DATA = record
    dwMappingFlag: DWORD;
    dwLookupTimeout: DWORD;
    dwCacheTimeout: DWORD;
    pNameResultDomain: LPTSTR;
  end;
  PDNS_WINSR_DATA = ^DNS_WINSR_DATA;
  TDnsWinsrData = DNS_WINSR_DATA;
  PDnsWinsrData = PDNS_WINSR_DATA;

//
//  Length of non-fixed-length data types
//

function DNS_TEXT_RECORD_LENGTH(StringCount: Longint): Longint;

function DNS_NULL_RECORD_LENGTH(ByteCount: Longint): Longint;

function DNS_WKS_RECORD_LENGTH(ByteCount: Longint): Longint;

//function DNS_WINS_RECORD_LENGTH(IpCount: Longint): Longint;

//
//  Record flags
//

type
  _DnsRecordFlags = record
    Flags: DWORD;
  end;
  DNS_RECORD_FLAGS = _DnsRecordFlags;
  TDnsRecordFlags = DNS_RECORD_FLAGS;

//
//  Record flags as bit flags
//  These may be or'd together to set the fields
//

//  RR Section in packet

const
  DNSREC_SECTION = ($00000003);

  DNSREC_QUESTION   = ($00000000);
  DNSREC_ANSWER     = ($00000001);
  DNSREC_AUTHORITY  = ($00000002);
  DNSREC_ADDITIONAL = ($00000003);

//  RR Section in packet (update)

  DNSREC_ZONE   = ($00000000);
  DNSREC_PREREQ = ($00000001);
  DNSREC_UPDATE = ($00000002);

//  Delete RR (update) or No-exist (prerequisite)

  DNSREC_DELETE  = ($00000004);
  DNSREC_NOEXIST = ($00000004);

//
//  Record \ RR set structure
//
//  Note:  The dwReserved flag serves to insure that the substructures
//  start on 64-bit boundaries.  Do NOT pack this structure, as the
//  substructures may contain pointers or int64 values which are
//  properly aligned unpacked.
//

type
  PDNS_RECORD = ^DNS_RECORD;
  _DnsRecord = record
    pNext: PDNS_RECORD;
    pName: LPTSTR;
    wType: WORD;
    wDataLength: WORD; // Not referenced for DNS record types defined above.
    Flags: record
    case Longint of
      0: (DW: DWORD);             // flags as DWORD
      1: (S: DNS_RECORD_FLAGS);   // flags as structure
    end;
    dwTtl: DWORD;
    dwReserved: DWORD;

    //  Record Data

    Data: record
    case Longint of
       0: (A: DNS_A_DATA);
       1: (SOA, Soa_: DNS_SOA_DATA);
       2: (PTR, Ptr_,
           NS, Ns_,
           CNAME, Cname_,
           MB, Mb_,
           MD, Md_,
           MF, Mf_,
           MG, Mg_,
           MR, Mr_: DNS_PTR_DATA);
       3: (MINFO, Minfo_,
           RP, Rp_: DNS_MINFO_DATA);
       4: (MX, Mx_,
           AFSDB, Afsdb_,
           RT, Rt_: DNS_MX_DATA);
       5: (HINFO, Hinfo_,
           ISDN, Isdn_,
           TXT, Txt_,
           X25: DNS_TXT_DATA);
       6: (Null: DNS_NULL_DATA);
       7: (WKS, Wks_: DNS_WKS_DATA);
       8: (AAAA: DNS_AAAA_DATA);
       9: (SRV, Srv_: DNS_SRV_DATA);
      10: (ATMA, Atma_: DNS_ATMA_DATA);
      11: (TKEY, Tkey_: DNS_TKEY_DATA);
      12: (TSIG, Tsig_: DNS_TSIG_DATA);
      13: (WINS, Wins_: DNS_WINS_DATA);
      14: (WINSR, WinsR_, NBSTAT, Nbstat_: DNS_WINSR_DATA);
    end;
  end;
  DNS_RECORD = _DnsRecord;
  PPDNS_RECORD = ^PDNS_RECORD;
  TDnsRecord = DNS_RECORD;
  PDnsRecord = PDNS_RECORD;

//
//  Header or fixed size of DNS_RECORD
//

const
  DNS_RECORD_FIXED_SIZE = 24;                // FIELD_OFFSET( DNS_RECORD, Data )
  SIZEOF_DNS_RECORD_HEADER = DNS_RECORD_FIXED_SIZE;

//
//  Resource record set building
//
//  pFirst points to first record in list.
//  pLast points to last record in list.
//

type
  _DnsRRSet = record
    pFirstRR: PDNS_RECORD;
    pLastRR: PDNS_RECORD;
  end;
  DNS_RRSET = _DnsRRSet;
  PDNS_RRSET = ^DNS_RRSET;
  TDnsRRSet = DNS_RRSET;
  PDnsRRSet = PDNS_RRSET;

//
//  To init pFirst is NULL.
//  But pLast points at the location of the pFirst pointer -- essentially
//  treating the pFirst ptr as a DNS_RECORD.  (It is a DNS_RECORD with
//  only a pNext field, but that's the only part we use.)
//
//  Then when the first record is added to the list, the pNext field of
//  this dummy record (which corresponds to pFirst's value) is set to
//  point at the first record.  So pFirst then properly points at the
//  first record.
//
//  (This works only because pNext is the first field in a
//  DNS_RECORD structure and hence casting a PDNS_RECORD ptr to
//  PDNS_RECORD* and dereferencing yields its pNext field)
//
//  Use TERMINATE when have built RR set by grabbing records out of
//  existing set.   This makes sure that at the end, the last RR is
//  properly NULL terminated.
//

procedure DNS_RRSET_INIT(rrset: PDNS_RRSET);

//procedure DNS_RRSET_ADD(rrset, pnewRR: PDNS_RRSET);

procedure DNS_RRSET_TERMINATE(rrset: PDNS_RRSET);

//
//  Record set manipulation
//

//
//  Record Copy
//  Record copy functions also do conversion between character sets.
//
//  Note, it might be advisable to directly expose non-Ex copy
//  functions _W, _A for record and set, to avoid exposing the
//  conversion enum.
//

type
  _DNS_CHARSET = (DnsCharSetUnknown, DnsCharSetUnicode, DnsCharSetUtf8, DnsCharSetAnsi);
  DNS_CHARSET = _DNS_CHARSET;
  TDnsCharSet = DNS_CHARSET;

function DnsRecordCopyEx(pRecord: PDNS_RECORD; CharSetIn, CharSetOut: DNS_CHARSET): PDNS_RECORD; stdcall;
function DnsRecordSetCopyEx(pRecordSet: PDNS_RECORD; CharSetIn, CharSetOut: DNS_CHARSET): PDNS_RECORD; stdcall;
function DnsRecordCopy(pRR: PDNS_RECORD): PDNS_RECORD;
function DnsRecordSetCopy(pRR: PDNS_RECORD): PDNS_RECORD;


//
//  Record Compare
//
//  Note:  these routines only compare records of the SAME character set.
//  (ANSI, unicode or UTF8).  Furthermore the routines assume the character
//  set is indicated within the record.  If compare of user created, rather
//  than DNS API created record lists is desired, then caller should use
//  DnsRecordCopy API and compare copies.
//

function DnsRecordCompare(pRecord1, pRecord2: PDNS_RECORD): BOOL; stdcall;

function DnsRecordSetCompare(pRR1, pRR2: PDNS_RECORD; var ppDiff1, ppDiff2: PDNS_RECORD): BOOL; stdcall;

//
//  Detach next record set from record list
//

function DnsRecordSetDetach(pRecordList: PDNS_RECORD): PDNS_RECORD; stdcall;

//
//  Free record list
//
//  Only supported free is deep free of entire record list with LocalFree().
//  This correctly frees record list returned by DnsQuery() or DnsRecordSetCopy()
//

type
  DNS_FREE_TYPE = (DnsFreeNoOp, DnsFreeRecordListDeep);
 TDnsFreeType = DNS_FREE_TYPE;

procedure DnsRecordListFree(pRecordList: PDNS_RECORD; FreeType: DNS_FREE_TYPE); stdcall;

//
//  DNS Query API
//

//
//  Options for DnsQuery
//

const
  DNS_QUERY_STANDARD                  = $00000000;
  DNS_QUERY_ACCEPT_TRUNCATED_RESPONSE = $00000001;
  DNS_QUERY_USE_TCP_ONLY              = $00000002;
  DNS_QUERY_NO_RECURSION              = $00000004;
  DNS_QUERY_BYPASS_CACHE              = $00000008;
  DNS_QUERY_CACHE_ONLY                = $00000010;
  DNS_QUERY_SOCKET_KEEPALIVE          = $00000100;
  DNS_QUERY_TREAT_AS_FQDN             = $00001000;
  DNS_QUERY_ALLOW_EMPTY_AUTH_RESP     = $00010000;
  DNS_QUERY_DONT_RESET_TTL_VALUES     = $00100000;
  DNS_QUERY_RESERVED                  = DWORD($ff000000);

function DnsQuery_A(pszName: LPSTR; wType: WORD; Options: DWORD; aipServers: PIP4_ARRAY;
  ppQueryResults: PPDNS_RECORD; pReserved: PPVOID): DNS_STATUS; stdcall;

function DnsQuery_UTF8(pszName: LPSTR; wType: WORD; Options: DWORD; aipServers: PIP4_ARRAY;
  ppQueryResults: PPDNS_RECORD; pReserved: PPVOID): DNS_STATUS; stdcall;

function DnsQuery_W(pszName: LPWSTR; wType: WORD; Options: DWORD; aipServers: PIP4_ARRAY;
  ppQueryResults: PPDNS_RECORD; pReserved: PPVOID): DNS_STATUS; stdcall;

function DnsQuery(pszName: LPSTR; wType: WORD; Options: DWORD; aipServers: PIP4_ARRAY;
  ppQueryResults: PPDNS_RECORD; pReserved: PPVOID): DNS_STATUS; stdcall;

//
//  DNS Update API
//
//      DnsAcquireContextHandle
//      DnsReleaseContextHandle
//      DnsModifyRecordsInSet
//      DnsReplaceRecordSet
//

//
//  Update flags
//

const
  DNS_UPDATE_SECURITY_USE_DEFAULT    = $00000000;
  DNS_UPDATE_SECURITY_OFF            = $00000010;
  DNS_UPDATE_SECURITY_ON             = $00000020;
  DNS_UPDATE_SECURITY_ONLY           = $00000100;
  DNS_UPDATE_CACHE_SECURITY_CONTEXT  = $00000200;
  DNS_UPDATE_TEST_USE_LOCAL_SYS_ACCT = $00000400;
  DNS_UPDATE_FORCE_SECURITY_NEGO     = $00000800;
  DNS_UPDATE_TRY_ALL_MASTER_SERVERS  = $00001000;
  DNS_UPDATE_RESERVED                = DWORD($ffff0000);

//
//  Note:  pCredentials paramater is currently respectively
//  PSEC_WINNT_AUTH_IDENTITY_W or PSEC_WINNT_AUTH_IDENTITY_A.
//  Using Pointer to obviate the need for including rpcdce.h
//  in order to include this file and to leave open the
//  possibility of alternative credential specifications in
//  the future.
//

function DnsAcquireContextHandle_W(CredentialFlags: DWORD; pCredentials: Pointer;
  var pContextHandle: THandle): DNS_STATUS; stdcall;

function DnsAcquireContextHandle_A(CredentialFlags: DWORD; pCredentials: Pointer;
  var pContextHandle: THandle): DNS_STATUS; stdcall;

function DnsAcquireContextHandle(CredentialFlags: DWORD; pCredentials: Pointer;
  var pContextHandle: THandle): DNS_STATUS; stdcall;

procedure DnsReleaseContextHandle(hContext: THandle); stdcall;

//
//  Dynamic Update API
//

function DnsModifyRecordsInSet_W(pAddRecords, pDeleteRecords: PDNS_RECORD;
  Options: DWORD; hContext: THandle; pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsModifyRecordsInSet_A(pAddRecords, pDeleteRecords: PDNS_RECORD;
  Options: DWORD; hContext: THandle; pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsModifyRecordsInSet_UTF8(pAddRecords, pDeleteRecords: PDNS_RECORD;
  Options: DWORD; hContext: THandle; pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsModifyRecordsInSet(pAddRecords, pDeleteRecords: PDNS_RECORD;
  Options: DWORD; hContext: THandle; pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsReplaceRecordSetW(pNewSet: PDNS_RECORD; Options: DWORD; hContext: THandle;
  pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsReplaceRecordSetA(pNewSet: PDNS_RECORD; Options: DWORD; hContext: THandle;
  pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsReplaceRecordSetUTF8(pNewSet: PDNS_RECORD; Options: DWORD; hContext: THandle;
  pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

function DnsReplaceRecordSet(pNewSet: PDNS_RECORD; Options: DWORD; hContext: THandle;
  pServerList: PIP4_ARRAY; pReserved: Pointer): DNS_STATUS; stdcall;

//
//  DNS name validation
//

type
  _DNS_NAME_FORMAT = (
    DnsNameDomain,
    DnsNameDomainLabel,
    DnsNameHostnameFull,
    DnsNameHostnameLabel,
    DnsNameWildcard,
    DnsNameSrvRecord);
  DNS_NAME_FORMAT = _DNS_NAME_FORMAT;
  TDnsNameFormat = DNS_NAME_FORMAT;


function DnsValidateName_UTF8(pszName: LPCSTR; Format: DNS_NAME_FORMAT): DNS_STATUS; stdcall;
function DnsValidateName_W(pszName: LPCWSTR; Format: DNS_NAME_FORMAT): DNS_STATUS; stdcall;
function DnsValidateName_A(pszName: LPCSTR; Format: DNS_NAME_FORMAT): DNS_STATUS; stdcall;
function DnsValidateName(pszName: LPCSTR; Format: DNS_NAME_FORMAT): DNS_STATUS;

//
//  DNS name comparison
//

function DnsNameCompare_A(pName1, pName2: LPSTR): BOOL; stdcall;
function DnsNameCompare_W(pName1, pName2: LPWSTR): BOOL; stdcall;
function DnsNameCompare(pName1, pName2: LPSTR): BOOL; stdcall;

//
//  DNS message "roll-your-own" routines
//

type
  _DNS_MESSAGE_BUFFER = record
    MessageHead: DNS_HEADER;
    MessageBody: array [0..0] of Char;
  end;
  DNS_MESSAGE_BUFFER = _DNS_MESSAGE_BUFFER;
  PDNS_MESSAGE_BUFFER = ^DNS_MESSAGE_BUFFER;
  TDnsMessageBuffer = DNS_MESSAGE_BUFFER;
  PDnsMessageBuffer = PDNS_MESSAGE_BUFFER;

function DnsWriteQuestionToBuffer_W(pDnsBuffer: PDNS_MESSAGE_BUFFER;
  pdwBufferSize: LPDWORD; pszName: LPWSTR; wType, Xid: WORD;
  fRecursionDesired: BOOL): BOOL; stdcall;

function DnsWriteQuestionToBuffer_UTF8(pDnsBuffer: PDNS_MESSAGE_BUFFER;
  pdwBufferSize: LPDWORD; pszName: LPWSTR; wType, Xid: WORD;
  fRecursionDesired: BOOL): BOOL; stdcall;

function DnsExtractRecordsFromMessage_W(pDnsBuffer: PDNS_MESSAGE_BUFFER;
  wMessageLength: WORD; var ppRecord: PDNS_RECORD): DNS_STATUS; stdcall;

function DnsExtractRecordsFromMessage_UTF8(pDnsBuffer: PDNS_MESSAGE_BUFFER;
  wMessageLength: WORD; var ppRecord: PDNS_RECORD): DNS_STATUS; stdcall;

implementation

const
  dnsapidll = 'dnsapidll.dll';

function  DnsQueryConfig; external dnsapidll name 'DnsQueryConfig';
function  DnsRecordCopyEx; external dnsapidll name 'DnsRecordCopyEx';
function  DnsRecordSetCopyEx; external dnsapidll name 'DnsRecordSetCopyEx';
function  DnsRecordCompare; external dnsapidll name 'DnsRecordCompare';
function  DnsRecordSetCompare; external dnsapidll name 'DnsRecordSetCompare';
function  DnsRecordSetDetach; external dnsapidll name 'DnsRecordSetDetach';
procedure DnsRecordListFree; external dnsapidll name 'DnsRecordListFree';
function  DnsQuery_A; external dnsapidll name 'DnsQuery_A';
function  DnsQuery_UTF8; external dnsapidll name 'DnsQuery_UTF8';
function  DnsQuery_W; external dnsapidll name 'DnsQuery_W';
function  DnsQuery; external dnsapidll name 'DnsQuery_A';
function  DnsAcquireContextHandle_W; external dnsapidll name 'DnsAcquireContextHandle_W';
function  DnsAcquireContextHandle_A; external dnsapidll name 'DnsAcquireContextHandle_A';
function  DnsAcquireContextHandle; external dnsapidll name 'DnsAcquireContextHandle_A';
procedure DnsReleaseContextHandle; external dnsapidll name 'DnsReleaseContextHandle';
function  DnsModifyRecordsInSet_W; external dnsapidll name 'DnsModifyRecordsInSet_W';
function  DnsModifyRecordsInSet_A; external dnsapidll name 'DnsModifyRecordsInSet_A';
function  DnsModifyRecordsInSet_UTF8; external dnsapidll name 'DnsModifyRecordsInSet_UTF8';
function  DnsModifyRecordsInSet; external dnsapidll name 'DnsModifyRecordsInSet_A';
function  DnsReplaceRecordSetW; external dnsapidll name 'DnsReplaceRecordSetW';
function  DnsReplaceRecordSetA; external dnsapidll name 'DnsReplaceRecordSetA';
function  DnsReplaceRecordSetUTF8; external dnsapidll name 'DnsReplaceRecordSetUTF8';
function  DnsReplaceRecordSet; external dnsapidll name 'DnsReplaceRecordSetA';
function  DnsValidateName_UTF8; external dnsapidll name 'DnsValidateName_UTF8';
function  DnsValidateName_W; external dnsapidll name 'DnsValidateName_W';
function  DnsValidateName_A; external dnsapidll name 'DnsValidateName_A';
function  DnsNameCompare_A; external dnsapidll name 'DnsNameCompare_A';
function  DnsNameCompare_W; external dnsapidll name 'DnsNameCompare_W';
function  DnsNameCompare; external dnsapidll name 'DnsNameCompare_A';
function  DnsWriteQuestionToBuffer_W; external dnsapidll name 'DnsWriteQuestionToBuffer_W';
function  DnsWriteQuestionToBuffer_UTF8; external dnsapidll name 'DnsWriteQuestionToBuffer_UTF8';
function  DnsExtractRecordsFromMessage_W; external dnsapidll name 'DnsExtractRecordsFromMessage_W';
function  DnsExtractRecordsFromMessage_UTF8; external dnsapidll name 'DnsExtractRecordsFromMessage_UTF8';

function DnsValidateName(pszName: LPCSTR; Format: DNS_NAME_FORMAT): DNS_STATUS;
begin
  Result := DnsValidateName_A(pszName, Format);
end;

function DNS_TEXT_RECORD_LENGTH(StringCount: Longint): Longint;
begin
  Result := SizeOf(DWORD) + ((StringCount) * SizeOf(PChar));
end;

function DNS_NULL_RECORD_LENGTH(ByteCount: Longint): Longint;
begin
  Result := SizeOf(DWORD) + (ByteCount);
end;

function DNS_WKS_RECORD_LENGTH(ByteCount: Longint): Longint;
begin
  Result := SizeOf(DNS_WKS_DATA) + (ByteCount - 1);
end;

procedure DNS_RRSET_INIT(rrset: PDNS_RRSET);
begin
  rrset^.pFirstRR := nil;
  rrset^.pLastRR := (@rrset^.pFirstRR);
end;

procedure DNS_RRSET_TERMINATE(rrset: PDNS_RRSET);
begin
  rrset^.pLastRR^.pNext := nil;
end;

function DnsRecordCopy(pRR: PDNS_RECORD): PDNS_RECORD;
begin
  Result := DnsRecordCopyEx(pRR, DnsCharSetAnsi, DnsCharSetAnsi);
end;

function DnsRecordSetCopy(pRR: PDNS_RECORD): PDNS_RECORD;
begin
  Result := DnsRecordSetCopyEx(pRR, DnsCharSetAnsi, DnsCharSetAnsi);
end;

procedure INLINE_WORD_FLIP(var Out_: WORD; In_: WORD);
begin
  Out_ := (In_ shl 8) or (In_ shr 8);
end;

procedure INLINE_HTONS(var Out_: WORD; In_: WORD);
begin
  INLINE_WORD_FLIP(Out_, In_);
end;

procedure INLINE_NTOHS(var Out_: WORD; In_: WORD);
begin
  INLINE_WORD_FLIP(Out_, In_);
end;

procedure INLINE_DWORD_FLIP(var Out_: DWORD; In_: DWORD);
begin
  Out_ := ((In_ shl 8) and $00ff0000) or (In_ shl 24) or
    ((In_ shr 8) and $0000ff00) or (In_ shr 24);
end;

procedure INLINE_NTOHL(var Out_: DWORD; In_: DWORD);
begin
  INLINE_DWORD_FLIP(Out_, In_);
end;

procedure INLINE_HTONL(var Out_: DWORD; In_: DWORD);
begin
  INLINE_DWORD_FLIP(Out_, In_);
end;

procedure INLINE_WRITE_FLIPPED_WORD(pout: PWORD; In_: WORD);
begin
  INLINE_WORD_FLIP(pout^, In_);
end;

procedure INLINE_WRITE_FLIPPED_DWORD(pout: PDWORD; In_: DWORD);
begin
  INLINE_DWORD_FLIP(pout^, In_);
end;

function DNS_HEADER_FLAGS(pHead: PDNS_HEADER): WORD;
begin
  Result := PWORD(Longint(pHead) + SizeOf(WORD))^;
end;

procedure DNS_BYTE_FLIP_HEADER_COUNTS(var pHeader: PDNS_HEADER);
var
  _head: PDNS_HEADER;
begin
  _head := pHeader;
  INLINE_HTONS(_head^.Xid, _head^.Xid);
  INLINE_HTONS(_head^.QuestionCount, _head^.QuestionCount);
  INLINE_HTONS(_head^.AnswerCount, _head^.AnswerCount);
  INLINE_HTONS(_head^.NameServerCount, _head^.NameServerCount);
  INLINE_HTONS(_head^.AdditionalCount, _head^.AdditionalCount);
end;

function IS_DWORD_ALIGNED(P: Pointer): BOOL;
begin
  Result := (Longint(P) and 3) = 0;
end;

function IS_QWORD_ALIGNED(P: Pointer): BOOL;
begin
  Result := (Longint(P) and 7) = 0;
end;

end.
