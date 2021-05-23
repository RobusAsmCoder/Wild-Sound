(****************************************************************)
(*                                                              *)
(*       TMT Pascal 4 Runtime Library                           *)
(*       Windows 32bit API Library Functions                    *)
(*       Based on wininet.h                                     *)
(*       Targets: WIN32 only                                    *)
(*                                                              *)
(*       Copyright (c) 1995-98 TMT Development Corporation      *)
(*       Portions Copyright (c) by Microsoft Corporation        *)
(*       Author: Vadim Bodrov                                   *)
(*                                                              *)
(****************************************************************)

{$i-,r-,a+,oa+,p+,t-,x+,b-,cc+,q-,v+,s-}

unit WinINet;

(*++

Copyright 1995 - 1998 Microsoft Corporation

Module Name:

    wininet.h

Abstract:

    Contains manifests, macros, types and prototypes for Microsoft Windows
    Internet Extensions

--*)

interface

uses Windows;

const
  WinINetDLL       = 'wininet.dll';

  INTERNET_INVALID_PORT_NUMBER = 0;        // use the protocol-specific default

  INTERNET_DEFAULT_FTP_PORT    = 21;       // default for FTP servers
  INTERNET_DEFAULT_GOPHER_PORT = 70;       //    "     "  gopher "
  INTERNET_DEFAULT_HTTP_PORT   = 80;       //    "     "  HTTP   "
  INTERNET_DEFAULT_HTTPS_PORT  = 443;      //    "     "  HTTPS  "
  INTERNET_DEFAULT_SOCKS_PORT  = 1080;     // default for SOCKS firewall servers.

  MAX_CACHE_ENTRY_INFO_SIZE    = 4096;


// maximum field lengths (arbitrary)

  INTERNET_MAX_HOST_NAME_LENGTH   = 256;
  INTERNET_MAX_USER_NAME_LENGTH   = 128;
  INTERNET_MAX_PASSWORD_LENGTH    = 128;
  INTERNET_MAX_PORT_NUMBER_LENGTH = 5;             // INTERNET_PORT is unsigned short
  INTERNET_MAX_PORT_NUMBER_VALUE  = 65535;         // maximum unsigned short value
  INTERNET_MAX_PATH_LENGTH        = 2048;
  INTERNET_MAX_SCHEME_LENGTH      = 32;            // longest protocol name length
  INTERNET_MAX_PROTOCOL_NAME      = 'gopher';      // longest protocol name
  INTERNET_MAX_URL_LENGTH = ((SizeOf(INTERNET_MAX_PROTOCOL_NAME) - 1)
                            + SizeOf('://')
                            + INTERNET_MAX_PATH_LENGTH);


// values returned by InternetQueryOption with INTERNET_OPTION_KEEP_CONNECTION:

  INTERNET_KEEP_ALIVE_UNKNOWN = -1;
  INTERNET_KEEP_ALIVE_ENABLED = 1;
  INTERNET_KEEP_ALIVE_DISABLED = 0;

// flags returned by InternetQueryOption with INTERNET_OPTION_REQUEST_FLAGS

  INTERNET_REQFLAG_FROM_CACHE   = $00000001;
  INTERNET_REQFLAG_ASYNC        = $00000002;
  INTERNET_REQFLAG_VIA_PROXY    = $00000004;          // request was made via a proxy
  INTERNET_REQFLAG_NO_HEADERS   = $00000008;          // orginal response contained no headers
  INTERNET_REQFLAG_PASSIVE      = $00000010;          // FTP: passive-mode connection
  INTERNET_REQFLAG_CACHE_WRITE_DISABLED = $00000040;  // HTTPS: this request not cacheable

// flags common to open functions (not InternetOpen):

  INTERNET_FLAG_RELOAD = $80000000;                 // retrieve the original item

// flags for InternetOpenUrl:

  INTERNET_FLAG_RAW_DATA = $40000000;               // receive the item as raw data
  INTERNET_FLAG_EXISTING_CONNECT = $20000000;       // do not create new connection object

// flags for InternetOpen:

  INTERNET_FLAG_ASYNC = $10000000;                  // this request is asynchronous (where supported)

// protocol-specific flags:

  INTERNET_FLAG_PASSIVE = $08000000;                // used for FTP connections

// additional cache flags

  INTERNET_FLAG_NO_CACHE_WRITE        = $04000000;  // don't write this item to the cache
  INTERNET_FLAG_DONT_CACHE            = INTERNET_FLAG_NO_CACHE_WRITE;
  INTERNET_FLAG_MAKE_PERSISTENT       = $02000000;  // make this item persistent in cache
  INTERNET_FLAG_FROM_CACHE            = $01000000;  // use offline semantics
  INTERNET_FLAG_OFFLINE               = $01000000;  // use offline semantics

// additional flags

  INTERNET_FLAG_SECURE                = $00800000;  // use PCT/SSL if applicable (HTTP)
  INTERNET_FLAG_KEEP_CONNECTION       = $00400000;  // use keep-alive semantics
  INTERNET_FLAG_NO_AUTO_REDIRECT      = $00200000;  // don't handle redirections automatically
  INTERNET_FLAG_READ_PREFETCH         = $00100000;  // do background read prefetch
  INTERNET_FLAG_NO_COOKIES            = $00080000;  // no automatic cookie handling
  INTERNET_FLAG_NO_AUTH               = $00040000;  // no automatic authentication handling
  INTERNET_FLAG_CACHE_IF_NET_FAIL     = $00010000;  // return cache file if net request fails

// Security Ignore Flags, Allow HttpOpenRequest to overide
// Secure Channel (SSL/PCT) failures of the following types.

  INTERNET_FLAG_IGNORE_CERT_CN_INVALID        = $00001000; // bad common name in X509 Cert.
  INTERNET_FLAG_IGNORE_CERT_DATE_INVALID      = $00002000; // expired X509 Cert.
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS      = $00004000; // ex: http:// to https://
  INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP       = $00008000; // ex: https:// to http://

//
// more caching flags
//
  INTERNET_FLAG_RESYNCHRONIZE     = $00000800;  // asking wininet to update an item if it is newer
  INTERNET_FLAG_HYPERLINK         = $00000400;  // asking wininet to do hyperlinking semantic which works right for scripts
  INTERNET_FLAG_NO_UI             = $00000200;  // no cookie popup
  INTERNET_FLAG_PRAGMA_NOCACHE    = $00000100;  // asking wininet to add "pragma: no-cache"
  INTERNET_FLAG_CACHE_ASYNC       = $00000080;  // ok to perform lazy cache-write
  INTERNET_FLAG_FORMS_SUBMIT      = $00000040;  // this is a forms submit
  INTERNET_FLAG_NEED_FILE         = $00000010;  // need a file for this request

//
// flags for FTP
//
  FTP_TRANSFER_TYPE_UNKNOWN   = 00000000;
  FTP_TRANSFER_TYPE_ASCII     = 00000001;
  FTP_TRANSFER_TYPE_BINARY    = 00000002;

  FTP_TRANSFER_TYPE_MASK      = FTP_TRANSFER_TYPE_ASCII or
                                FTP_TRANSFER_TYPE_BINARY;


  INTERNET_FLAG_TRANSFER_ASCII        = FTP_TRANSFER_TYPE_ASCII;
  INTERNET_FLAG_TRANSFER_BINARY       = FTP_TRANSFER_TYPE_BINARY;

// flags field masks

  SECURITY_INTERNET_MASK      = INTERNET_FLAG_IGNORE_CERT_CN_INVALID or
                                INTERNET_FLAG_IGNORE_CERT_DATE_INVALID or
                                INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS or
                                INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;

  SECURITY_SET_MASK           = SECURITY_INTERNET_MASK;

  INTERNET_FLAGS_MASK         = INTERNET_FLAG_RELOAD              or
                                INTERNET_FLAG_RAW_DATA            or
                                INTERNET_FLAG_EXISTING_CONNECT    or
                                INTERNET_FLAG_ASYNC               or
                                INTERNET_FLAG_PASSIVE             or
                                INTERNET_FLAG_NO_CACHE_WRITE      or
                                INTERNET_FLAG_MAKE_PERSISTENT     or
                                INTERNET_FLAG_FROM_CACHE          or
                                INTERNET_FLAG_SECURE              or
                                INTERNET_FLAG_KEEP_CONNECTION     or
                                INTERNET_FLAG_NO_AUTO_REDIRECT    or
                                INTERNET_FLAG_READ_PREFETCH       or
                                INTERNET_FLAG_NO_COOKIES          or
                                INTERNET_FLAG_NO_AUTH             or
                                INTERNET_FLAG_CACHE_IF_NET_FAIL   or
                                SECURITY_INTERNET_MASK            or
                                INTERNET_FLAG_RESYNCHRONIZE       or
                                INTERNET_FLAG_HYPERLINK           or
                                INTERNET_FLAG_NO_UI               or
                                INTERNET_FLAG_PRAGMA_NOCACHE      or
                                INTERNET_FLAG_CACHE_ASYNC         or
                                INTERNET_FLAG_FORMS_SUBMIT        or
                                INTERNET_FLAG_NEED_FILE           or
                                INTERNET_FLAG_TRANSFER_BINARY     or
                                INTERNET_FLAG_TRANSFER_ASCII;

  INTERNET_ERROR_MASK_INSERT_CDROM = $1;

  INTERNET_OPTIONS_MASK       =  not INTERNET_FLAGS_MASK;

//
// common per-API flags (new APIs)
//

  WININET_API_FLAG_ASYNC          = $00000001;  // force async operation
  WININET_API_FLAG_SYNC           = $00000004;  // force sync operation
  WININET_API_FLAG_USE_CONTEXT    = $00000008;  // use value supplied in dwContext (even if 0)

// INTERNET_NO_CALLBACK - if this value is presented as the dwContext parameter
// then no call-backs will be made for that API

  INTERNET_NO_CALLBACK = 0;

  INTERNET_SCHEME_PARTIAL = -2;
  INTERNET_SCHEME_UNKNOWN = -1;
  INTERNET_SCHEME_DEFAULT = 0;
  INTERNET_SCHEME_FTP     = 1;
  INTERNET_SCHEME_GOPHER  = 2;
  INTERNET_SCHEME_HTTP    = 3;
  INTERNET_SCHEME_HTTPS   = 4;
  INTERNET_SCHEME_FILE    = 5;
  INTERNET_SCHEME_NEWS    = 6;
  INTERNET_SCHEME_MAILTO  = 7;
  INTERNET_SCHEME_FIRST   = INTERNET_SCHEME_FTP;
  INTERNET_SCHEME_LAST    = INTERNET_SCHEME_MAILTO;

  INTERNET_PREFETCH_PROGRESS      = 0;
  INTERNET_PREFETCH_COMPLETE      = 1;
  INTERNET_PREFETCH_ABORTED       = 2;

//
// ISO_FORCE_DISCONNECTED - if set when putting Wininet into disconnected mode,
// all outstanding requests will be aborted with a cancelled error
//
  ISO_FORCE_DISCONNECTED  = $00000001;

//
// constants for InternetTimeFromSystemTime
//
  INTERNET_RFC1123_FORMAT         = 0;
  INTERNET_RFC1123_BUFSIZE        = 30;

//
// flags for InternetCrackUrl() and InternetCreateUrl()
//
  ICU_ESCAPE          = $80000000;  // (un)escape URL characters
  ICU_USERNAME        = $40000000;  // use internal username & password

//
// flags for InternetCanonicalizeUrl() and InternetCombineUrl()
//
  ICU_NO_ENCODE          = $20000000;  // Don't convert unsafe characters to escape sequence
  ICU_DECODE             = $10000000;  // Convert escape sequences to characters
  ICU_NO_META            = $08000000;  // Don't convert .. etc. meta path sequences
  ICU_ENCODE_SPACES_ONLY = $04000000;  // Encode spaces only
  ICU_BROWSER_MODE       = $02000000;  // Special encode/decode rules for browser

//
// access types for InternetOpen()
//
  INTERNET_OPEN_TYPE_PRECONFIG                    = 0;  // use registry configuration
  INTERNET_OPEN_TYPE_DIRECT                       = 1;  // direct to net
  INTERNET_OPEN_TYPE_PROXY                        = 3;  // via named proxy
  INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  = 4;  // prevent using java/script/INS

//
// old names for access types
//
  PRE_CONFIG_INTERNET_ACCESS      = INTERNET_OPEN_TYPE_PRECONFIG;
  LOCAL_INTERNET_ACCESS           = INTERNET_OPEN_TYPE_DIRECT;
  CERN_PROXY_INTERNET_ACCESS      = INTERNET_OPEN_TYPE_PROXY;

  GATEWAY_INTERNET_ACCESS         = 2;  // Internet via gateway

//
// service types for InternetConnect
//
  INTERNET_SERVICE_URL = 0;
  INTERNET_SERVICE_FTP = 1;
  INTERNET_SERVICE_GOPHER = 2;
  INTERNET_SERVICE_HTTP = 3;

//
// flags for InternetReadFileEx()
//
  IRF_ASYNC       = WININET_API_FLAG_ASYNC;
  IRF_SYNC        = WININET_API_FLAG_SYNC;
  IRF_USE_CONTEXT = WININET_API_FLAG_USE_CONTEXT;
  IRF_NO_WAIT     = $00000008;

//
// flags for InternetSetOptionEx()
//
  ISO_GLOBAL      = $00000001;  // modify option globally
  ISO_REGISTRY    = $00000002;  // write option to registry (where applicable)
  ISO_VALID_FLAGS = ISO_GLOBAL or ISO_REGISTRY;

//
// options manifests for Internet(Query or Set)Option
//
  INTERNET_OPTION_CALLBACK                    = 1;
  INTERNET_OPTION_CONNECT_TIMEOUT             = 2;
  INTERNET_OPTION_CONNECT_RETRIES             = 3;
  INTERNET_OPTION_CONNECT_BACKOFF             = 4;
  INTERNET_OPTION_SEND_TIMEOUT                = 5;
  INTERNET_OPTION_CONTROL_SEND_TIMEOUT        = INTERNET_OPTION_SEND_TIMEOUT;
  INTERNET_OPTION_RECEIVE_TIMEOUT             = 6;
  INTERNET_OPTION_CONTROL_RECEIVE_TIMEOUT     = INTERNET_OPTION_RECEIVE_TIMEOUT;
  INTERNET_OPTION_DATA_SEND_TIMEOUT           = 7;
  INTERNET_OPTION_DATA_RECEIVE_TIMEOUT        = 8;
  INTERNET_OPTION_HANDLE_TYPE                 = 9;

  INTERNET_OPTION_READ_BUFFER_SIZE            = 12;
  INTERNET_OPTION_WRITE_BUFFER_SIZE           = 13;

  INTERNET_OPTION_ASYNC_ID                    = 15;
  INTERNET_OPTION_ASYNC_PRIORITY              = 16;

  INTERNET_OPTION_PARENT_HANDLE               = 21;
  INTERNET_OPTION_KEEP_CONNECTION             = 22;
  INTERNET_OPTION_REQUEST_FLAGS               = 23;
  INTERNET_OPTION_EXTENDED_ERROR              = 24;

  INTERNET_OPTION_OFFLINE_MODE                = 26;
  INTERNET_OPTION_CACHE_STREAM_HANDLE         = 27;
  INTERNET_OPTION_USERNAME                    = 28;
  INTERNET_OPTION_PASSWORD                    = 29;
  INTERNET_OPTION_ASYNC                       = 30;
  INTERNET_OPTION_SECURITY_FLAGS              = 31;
  INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT = 32;
  INTERNET_OPTION_DATAFILE_NAME               = 33;
  INTERNET_OPTION_URL                         = 34;
  INTERNET_OPTION_SECURITY_CERTIFICATE        = 35;
  INTERNET_OPTION_SECURITY_KEY_BITNESS        = 36;
  INTERNET_OPTION_REFRESH                     = 37;
  INTERNET_OPTION_PROXY                       = 38;
  INTERNET_OPTION_SETTINGS_CHANGED            = 39;
  INTERNET_OPTION_VERSION                     = 40;
  INTERNET_OPTION_USER_AGENT                  = 41;
  INTERNET_OPTION_END_BROWSER_SESSION         = 42;
  INTERNET_OPTION_PROXY_USERNAME              = 43;
  INTERNET_OPTION_PROXY_PASSWORD              = 44;
  INTERNET_OPTION_CONTEXT_VALUE               = 45;
  INTERNET_OPTION_CONNECT_LIMIT               = 46;
  INTERNET_OPTION_SECURITY_SELECT_CLIENT_CERT = 47;
  INTERNET_OPTION_POLICY                      = 48;
  INTERNET_OPTION_DISCONNECTED_TIMEOUT        = 49;
  INTERNET_OPTION_CONNECTED_STATE             = 50;
  INTERNET_OPTION_IDLE_STATE                  = 51;
  INTERNET_OPTION_OFFLINE_SEMANTICS           = 52;
  INTERNET_OPTION_SECONDARY_CACHE_KEY         = 53;
  INTERNET_OPTION_CALLBACK_FILTER             = 54;
  INTERNET_OPTION_CONNECT_TIME                = 55;
  INTERNET_OPTION_SEND_THROUGHPUT             = 56;
  INTERNET_OPTION_RECEIVE_THROUGHPUT          = 57;
  INTERNET_OPTION_REQUEST_PRIORITY            = 58;
  INTERNET_OPTION_HTTP_VERSION                = 59;
  INTERNET_OPTION_RESET_URLCACHE_SESSION      = 60;
  INTERNET_OPTION_ERROR_MASK                  = 62;

  INTERNET_FIRST_OPTION                      = INTERNET_OPTION_CALLBACK;
  INTERNET_LAST_OPTION                       = INTERNET_OPTION_PROXY;

//
// values for INTERNET_OPTION_PRIORITY
//
  INTERNET_PRIORITY_FOREGROUND = 1000;

//
// handle types
//
  INTERNET_HANDLE_TYPE_INTERNET         = 1;
  INTERNET_HANDLE_TYPE_CONNECT_FTP      = 2;
  INTERNET_HANDLE_TYPE_CONNECT_GOPHER   = 3;
  INTERNET_HANDLE_TYPE_CONNECT_HTTP     = 4;
  INTERNET_HANDLE_TYPE_FTP_FIND         = 5;
  INTERNET_HANDLE_TYPE_FTP_FIND_HTML    = 6;
  INTERNET_HANDLE_TYPE_FTP_FILE         = 7;
  INTERNET_HANDLE_TYPE_FTP_FILE_HTML    = 8;
  INTERNET_HANDLE_TYPE_GOPHER_FIND      = 9;
  INTERNET_HANDLE_TYPE_GOPHER_FIND_HTML = 10;
  INTERNET_HANDLE_TYPE_GOPHER_FILE      = 11;
  INTERNET_HANDLE_TYPE_GOPHER_FILE_HTML = 12;
  INTERNET_HANDLE_TYPE_HTTP_REQUEST     = 13;

//
// values for INTERNET_OPTION_SECURITY_FLAGS
//
  SECURITY_FLAG_SECURE                        = $00000001; // can query only
  SECURITY_FLAG_SSL                           = $00000002;
  SECURITY_FLAG_SSL3                          = $00000004;
  SECURITY_FLAG_PCT                           = $00000008;
  SECURITY_FLAG_PCT4                          = $00000010;
  SECURITY_FLAG_IETFSSL4                      = $00000020;

  SECURITY_FLAG_STRENGTH_WEAK                 = $10000000;
  SECURITY_FLAG_STRENGTH_MEDIUM               = $40000000;
  SECURITY_FLAG_STRENGTH_STRONG               = $20000000;

  SECURITY_FLAG_40BIT                         = SECURITY_FLAG_STRENGTH_WEAK;
  SECURITY_FLAG_128BIT                        = SECURITY_FLAG_STRENGTH_STRONG;
  SECURITY_FLAG_56BIT                         = SECURITY_FLAG_STRENGTH_MEDIUM;
  SECURITY_FLAG_UNKNOWNBIT                    = $80000000;
  SECURITY_FLAG_NORMALBITNESS                 = SECURITY_FLAG_40BIT;

  SECURITY_FLAG_IGNORE_REVOCATION             = 00000080;
  SECURITY_FLAG_IGNORE_UNKNOWN_CA             = 00000100;
  SECURITY_FLAG_IGNORE_WRONG_USAGE            = 00000200;

  SECURITY_FLAG_IGNORE_CERT_CN_INVALID        = INTERNET_FLAG_IGNORE_CERT_CN_INVALID;
  SECURITY_FLAG_IGNORE_CERT_DATE_INVALID      = INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;

  SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTPS      = INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS;
  SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTP       = INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP;

//
// status manifests for Internet status callback
//
  INTERNET_STATUS_RESOLVING_NAME              = 10;
  INTERNET_STATUS_NAME_RESOLVED               = 11;
  INTERNET_STATUS_CONNECTING_TO_SERVER        = 20;
  INTERNET_STATUS_CONNECTED_TO_SERVER         = 21;
  INTERNET_STATUS_SENDING_REQUEST             = 30;
  INTERNET_STATUS_REQUEST_SENT                = 31;
  INTERNET_STATUS_RECEIVING_RESPONSE          = 40;
  INTERNET_STATUS_RESPONSE_RECEIVED           = 41;
  INTERNET_STATUS_CTL_RESPONSE_RECEIVED       = 42;
  INTERNET_STATUS_PREFETCH                    = 43;
  INTERNET_STATUS_CLOSING_CONNECTION          = 50;
  INTERNET_STATUS_CONNECTION_CLOSED           = 51;
  INTERNET_STATUS_HANDLE_CREATED              = 60;
  INTERNET_STATUS_HANDLE_CLOSING              = 70;
  INTERNET_STATUS_REQUEST_COMPLETE            = 100;
  INTERNET_STATUS_REDIRECT                    = 110;
  INTERNET_STATUS_INTERMEDIATE_RESPONSE       = 120;
  INTERNET_STATUS_STATE_CHANGE                = 200;

//
// the following can be indicated in a state change notification:
//
  INTERNET_STATE_CONNECTED                    = 00000001;  // connected state (mutually exclusive with disconnected)
  INTERNET_STATE_DISCONNECTED                 = 00000002;  // disconnected from network
  INTERNET_STATE_DISCONNECTED_BY_USER         = 00000010;  // disconnected by user request
  INTERNET_STATE_IDLE                         = 00000100;  // no network requests being made (by Wininet)
  INTERNET_STATE_BUSY                         = 00000200;  // network requests being made (by Wininet)

//
// if the following value is returned by InternetSetStatusCallback, then
// probably an invalid (non-code) address was supplied for the callback
//
  INTERNET_INVALID_STATUS_CALLBACK = (-1);

//
// string field lengths (in characters, not bytes)
//
  MAX_GOPHER_DISPLAY_TEXT   = 128;
  MAX_GOPHER_SELECTOR_TEXT  = 256;
  MAX_GOPHER_HOST_NAME      = INTERNET_MAX_HOST_NAME_LENGTH;
  MAX_GOPHER_LOCATOR_LENGTH = 1
                              + MAX_GOPHER_DISPLAY_TEXT
                              + 1
                              + MAX_GOPHER_SELECTOR_TEXT
                              + 1
                              + MAX_GOPHER_HOST_NAME
                              + 1
                              + INTERNET_MAX_PORT_NUMBER_LENGTH
                              + 1
                              + 1
                              + 2;

//
// manifests for GopherType
//
  GOPHER_TYPE_TEXT_FILE         = $00000001;
  GOPHER_TYPE_DIRECTORY         = $00000002;
  GOPHER_TYPE_CSO               = $00000004;
  GOPHER_TYPE_ERROR             = $00000008;
  GOPHER_TYPE_MAC_BINHEX        = $00000010;
  GOPHER_TYPE_DOS_ARCHIVE       = $00000020;
  GOPHER_TYPE_UNIX_UUENCODED    = $00000040;
  GOPHER_TYPE_INDEX_SERVER      = $00000080;
  GOPHER_TYPE_TELNET            = $00000100;
  GOPHER_TYPE_BINARY            = $00000200;
  GOPHER_TYPE_REDUNDANT         = $00000400;
  GOPHER_TYPE_TN3270            = $00000800;
  GOPHER_TYPE_GIF               = $00001000;
  GOPHER_TYPE_IMAGE             = $00002000;
  GOPHER_TYPE_BITMAP            = $00004000;
  GOPHER_TYPE_MOVIE             = $00008000;
  GOPHER_TYPE_SOUND             = $00010000;
  GOPHER_TYPE_HTML              = $00020000;
  GOPHER_TYPE_PDF               = $00040000;
  GOPHER_TYPE_CALENDAR          = $00080000;
  GOPHER_TYPE_INLINE            = $00100000;
  GOPHER_TYPE_UNKNOWN           = $20000000;
  GOPHER_TYPE_ASK               = $40000000;
  GOPHER_TYPE_GOPHER_PLUS       = $80000000;

//
// GOPHER_TYPE_FILE_MASK - use this to determine if a locator identifies a
// (known) file type
//
  GOPHER_TYPE_FILE_MASK = GOPHER_TYPE_TEXT_FILE
                          or GOPHER_TYPE_MAC_BINHEX
                          or GOPHER_TYPE_DOS_ARCHIVE
                          or GOPHER_TYPE_UNIX_UUENCODED
                          or GOPHER_TYPE_BINARY
                          or GOPHER_TYPE_GIF
                          or GOPHER_TYPE_IMAGE
                          or GOPHER_TYPE_BITMAP
                          or GOPHER_TYPE_MOVIE
                          or GOPHER_TYPE_SOUND
                          or GOPHER_TYPE_HTML
                          or GOPHER_TYPE_PDF
                          or GOPHER_TYPE_CALENDAR
                          or GOPHER_TYPE_INLINE;

  MAX_GOPHER_CATEGORY_NAME    = 128;        // arbitrary
  MAX_GOPHER_ATTRIBUTE_NAME   = 128;        //     "
  MIN_GOPHER_ATTRIBUTE_LENGTH = 256;        //     "

//
// known gopher attribute categories. See below for ordinals
//
  GOPHER_INFO_CATEGORY           = '+INFO';
  GOPHER_ADMIN_CATEGORY          = '+ADMIN';
  GOPHER_VIEWS_CATEGORY          = '+VIEWS';
  GOPHER_ABSTRACT_CATEGORY       = '+ABSTRACT';
  GOPHER_VERONICA_CATEGORY       = '+VERONICA';

//
// known gopher attributes. These are the attribute names as defined in the
// gopher+ protocol document
//
  GOPHER_ADMIN_ATTRIBUTE         = 'Admin';
  GOPHER_MOD_DATE_ATTRIBUTE      = 'Mod-Date';
  GOPHER_TTL_ATTRIBUTE           = 'TTL';
  GOPHER_SCORE_ATTRIBUTE         = 'Score';
  GOPHER_RANGE_ATTRIBUTE         = 'Score-range';
  GOPHER_SITE_ATTRIBUTE          = 'Site';
  GOPHER_ORG_ATTRIBUTE           = 'Org';
  GOPHER_LOCATION_ATTRIBUTE      = 'Loc';
  GOPHER_GEOG_ATTRIBUTE          = 'Geog';
  GOPHER_TIMEZONE_ATTRIBUTE      = 'TZ';
  GOPHER_PROVIDER_ATTRIBUTE      = 'Provider';
  GOPHER_VERSION_ATTRIBUTE       = 'Version';
  GOPHER_ABSTRACT_ATTRIBUTE      = 'Abstract';
  GOPHER_VIEW_ATTRIBUTE          = 'View';
  GOPHER_TREEWALK_ATTRIBUTE      = 'treewalk';

//
// identifiers for attribute strings
//
  GOPHER_ATTRIBUTE_ID_BASE      = $abcccc00;
  GOPHER_CATEGORY_ID_ALL        = GOPHER_ATTRIBUTE_ID_BASE + 1;
  GOPHER_CATEGORY_ID_INFO       = GOPHER_ATTRIBUTE_ID_BASE + 2;
  GOPHER_CATEGORY_ID_ADMIN      = GOPHER_ATTRIBUTE_ID_BASE + 3;
  GOPHER_CATEGORY_ID_VIEWS      = GOPHER_ATTRIBUTE_ID_BASE + 4;
  GOPHER_CATEGORY_ID_ABSTRACT   = GOPHER_ATTRIBUTE_ID_BASE + 5;
  GOPHER_CATEGORY_ID_VERONICA   = GOPHER_ATTRIBUTE_ID_BASE + 6;
  GOPHER_CATEGORY_ID_ASK        = GOPHER_ATTRIBUTE_ID_BASE + 7;
  GOPHER_CATEGORY_ID_UNKNOWN    = GOPHER_ATTRIBUTE_ID_BASE + 8;
  GOPHER_ATTRIBUTE_ID_ALL       = GOPHER_ATTRIBUTE_ID_BASE + 9;
  GOPHER_ATTRIBUTE_ID_ADMIN     = GOPHER_ATTRIBUTE_ID_BASE + 10;
  GOPHER_ATTRIBUTE_ID_MOD_DATE  = GOPHER_ATTRIBUTE_ID_BASE + 11;
  GOPHER_ATTRIBUTE_ID_TTL       = GOPHER_ATTRIBUTE_ID_BASE + 12;
  GOPHER_ATTRIBUTE_ID_SCORE     = GOPHER_ATTRIBUTE_ID_BASE + 13;
  GOPHER_ATTRIBUTE_ID_RANGE     = GOPHER_ATTRIBUTE_ID_BASE + 14;
  GOPHER_ATTRIBUTE_ID_SITE      = GOPHER_ATTRIBUTE_ID_BASE + 15;
  GOPHER_ATTRIBUTE_ID_ORG       = GOPHER_ATTRIBUTE_ID_BASE + 16;
  GOPHER_ATTRIBUTE_ID_LOCATION  = GOPHER_ATTRIBUTE_ID_BASE + 17;
  GOPHER_ATTRIBUTE_ID_GEOG      = GOPHER_ATTRIBUTE_ID_BASE + 18;
  GOPHER_ATTRIBUTE_ID_TIMEZONE  = GOPHER_ATTRIBUTE_ID_BASE + 19;
  GOPHER_ATTRIBUTE_ID_PROVIDER  = GOPHER_ATTRIBUTE_ID_BASE + 20;
  GOPHER_ATTRIBUTE_ID_VERSION   = GOPHER_ATTRIBUTE_ID_BASE + 21;
  GOPHER_ATTRIBUTE_ID_ABSTRACT  = GOPHER_ATTRIBUTE_ID_BASE + 22;
  GOPHER_ATTRIBUTE_ID_VIEW      = GOPHER_ATTRIBUTE_ID_BASE + 23;
  GOPHER_ATTRIBUTE_ID_TREEWALK  = GOPHER_ATTRIBUTE_ID_BASE + 24;
  GOPHER_ATTRIBUTE_ID_UNKNOWN   = GOPHER_ATTRIBUTE_ID_BASE + 25;

//
// the default major/minor HTTP version numbers
//
  HTTP_MAJOR_VERSION = 1;
  HTTP_MINOR_VERSION = 0;
  HTTP_VERSION       = 'HTTP/1.0';

//
// HttpQueryInfo info levels. Generally, there is one info level
// for each potential RFC822/HTTP/MIME header that an HTTP server
// may send as part of a request response.
//
// The HTTP_QUERY_RAW_HEADERS info level is provided for clients
// that choose to perform their own header parsing.
//
  HTTP_QUERY_MIME_VERSION                     = 0;
  HTTP_QUERY_CONTENT_TYPE                     = 1;
  HTTP_QUERY_CONTENT_TRANSFER_ENCODING        = 2;
  HTTP_QUERY_CONTENT_ID                       = 3;
  HTTP_QUERY_CONTENT_DESCRIPTION              = 4;
  HTTP_QUERY_CONTENT_LENGTH                   = 5;
  HTTP_QUERY_CONTENT_LANGUAGE                 = 6;
  HTTP_QUERY_ALLOW                            = 7;
  HTTP_QUERY_PUBLIC                           = 8;
  HTTP_QUERY_DATE                             = 9;
  HTTP_QUERY_EXPIRES                          = 10;
  HTTP_QUERY_LAST_MODIFIED                    = 11;
  HTTP_QUERY_MESSAGE_ID                       = 12;
  HTTP_QUERY_URI                              = 13;
  HTTP_QUERY_DERIVED_FROM                     = 14;
  HTTP_QUERY_COST                             = 15;
  HTTP_QUERY_LINK                             = 16;
  HTTP_QUERY_PRAGMA                           = 17;
  HTTP_QUERY_VERSION                          = 18; // special: part of status line
  HTTP_QUERY_STATUS_CODE                      = 19; // special: part of status line
  HTTP_QUERY_STATUS_TEXT                      = 20; // special: part of status line
  HTTP_QUERY_RAW_HEADERS                      = 21; // special: all headers as ASCIIZ
  HTTP_QUERY_RAW_HEADERS_CRLF                 = 22; // special: all headers
  HTTP_QUERY_CONNECTION                       = 23;
  HTTP_QUERY_ACCEPT                           = 24;
  HTTP_QUERY_ACCEPT_CHARSET                   = 25;
  HTTP_QUERY_ACCEPT_ENCODING                  = 26;
  HTTP_QUERY_ACCEPT_LANGUAGE                  = 27;
  HTTP_QUERY_AUTHORIZATION                    = 28;
  HTTP_QUERY_CONTENT_ENCODING                 = 29;
  HTTP_QUERY_FORWARDED                        = 30;
  HTTP_QUERY_FROM                             = 31;
  HTTP_QUERY_IF_MODIFIED_SINCE                = 32;
  HTTP_QUERY_LOCATION                         = 33;
  HTTP_QUERY_ORIG_URI                         = 34;
  HTTP_QUERY_REFERER                          = 35;
  HTTP_QUERY_RETRY_AFTER                      = 36;
  HTTP_QUERY_SERVER                           = 37;
  HTTP_QUERY_TITLE                            = 38;
  HTTP_QUERY_USER_AGENT                       = 39;
  HTTP_QUERY_WWW_AUTHENTICATE                 = 40;
  HTTP_QUERY_PROXY_AUTHENTICATE               = 41;
  HTTP_QUERY_ACCEPT_RANGES                    = 42;
  HTTP_QUERY_SET_COOKIE                       = 43;
  HTTP_QUERY_COOKIE                           = 44;
  HTTP_QUERY_REQUEST_METHOD                   = 45;  // special: GET/POST etc.
  HTTP_QUERY_REFRESH                          = 46;
  HTTP_QUERY_CONTENT_DISPOSITION              = 47;

//
// HTTP 1.1 defined headers
//
  HTTP_QUERY_AGE                              = 48;
  HTTP_QUERY_CACHE_CONTROL                    = 49;
  HTTP_QUERY_CONTENT_BASE                     = 50;
  HTTP_QUERY_CONTENT_LOCATION                 = 51;
  HTTP_QUERY_CONTENT_MD5                      = 52;
  HTTP_QUERY_CONTENT_RANGE                    = 53;
  HTTP_QUERY_ETAG                             = 54;
  HTTP_QUERY_HOST                             = 55;
  HTTP_QUERY_IF_MATCH                         = 56;
  HTTP_QUERY_IF_NONE_MATCH                    = 57;
  HTTP_QUERY_IF_RANGE                         = 58;
  HTTP_QUERY_IF_UNMODIFIED_SINCE              = 59;
  HTTP_QUERY_MAX_FORWARDS                     = 60;
  HTTP_QUERY_PROXY_AUTHORIZATION              = 61;
  HTTP_QUERY_RANGE                            = 62;
  HTTP_QUERY_TRANSFER_ENCODING                = 63;
  HTTP_QUERY_UPGRADE                          = 64;
  HTTP_QUERY_VARY                             = 65;
  HTTP_QUERY_VIA                              = 66;
  HTTP_QUERY_WARNING                          = 67;

  HTTP_QUERY_MAX                              = 67;

//
// HTTP_QUERY_CUSTOM - if this special value is supplied as the dwInfoLevel
// parameter of HttpQueryInfo then the lpBuffer parameter contains the name
// of the header we are to query
//
  HTTP_QUERY_CUSTOM                           = 65535;

//
// HTTP_QUERY_FLAG_REQUEST_HEADERS - if this bit is set in the dwInfoLevel
// parameter of HttpQueryInfo then the request headers will be queried for the
// request information
//
  HTTP_QUERY_FLAG_REQUEST_HEADERS             = $80000000;

//
// HTTP_QUERY_FLAG_SYSTEMTIME - if this bit is set in the dwInfoLevel parameter
// of HttpQueryInfo AND the header being queried contains date information,
// e.g. the "Expires:" header then lpBuffer will contain a SYSTEMTIME structure
// containing the date and time information converted from the header string
//
  HTTP_QUERY_FLAG_SYSTEMTIME                  = $40000000;

//
// HTTP_QUERY_FLAG_NUMBER - if this bit is set in the dwInfoLevel parameter of
// HttpQueryInfo, then the value of the header will be converted to a number
// before being returned to the caller, if applicable
//
  HTTP_QUERY_FLAG_NUMBER                      = $20000000;

//
// HTTP_QUERY_FLAG_COALESCE - combine the values from several headers of the
// same name into the output buffer
//
  HTTP_QUERY_FLAG_COALESCE                    = $10000000;

  HTTP_QUERY_MODIFIER_FLAGS_MASK              = HTTP_QUERY_FLAG_REQUEST_HEADERS or
                                                HTTP_QUERY_FLAG_SYSTEMTIME or
                                                HTTP_QUERY_FLAG_NUMBER or
                                                HTTP_QUERY_FLAG_COALESCE;

  HTTP_QUERY_HEADER_MASK                      = not HTTP_QUERY_MODIFIER_FLAGS_MASK;

//
//  HTTP Response Status Codes:
//
  HTTP_STATUS_CONTINUE            = 100;    // OK to continue with request
  HTTP_STATUS_SWITCH_PROTOCOLS    = 101;    // server has switched protocols in upgrade header

  HTTP_STATUS_OK                  = 200;    // request completed
  HTTP_STATUS_CREATED             = 201;    // object created, reason = new URI
  HTTP_STATUS_ACCEPTED            = 202;    // async completion (TBS)
  HTTP_STATUS_PARTIAL             = 203;    // partial completion
  HTTP_STATUS_NO_CONTENT          = 204;    // no info to return
  HTTP_STATUS_RESET_CONTENT       = 205;    // request completed, but clear form
  HTTP_STATUS_PARTIAL_CONTENT     = 206;    // partial GET furfilled

  HTTP_STATUS_AMBIGUOUS           = 300;    // server couldn't decide what to return
  HTTP_STATUS_MOVED               = 301;    // object permanently moved
  HTTP_STATUS_REDIRECT            = 302;    // object temporarily moved
  HTTP_STATUS_REDIRECT_METHOD     = 303;    // redirection w/ new access method
  HTTP_STATUS_NOT_MODIFIED        = 304;    // if-modified-since was not modified
  HTTP_STATUS_USE_PROXY           = 305;    // redirection to proxy, location header specifies proxy to use
  HTTP_STATUS_REDIRECT_KEEP_VERB  = 307;    // HTTP/1.1: keep same verb

  HTTP_STATUS_BAD_REQUEST         = 400;    // invalid syntax
  HTTP_STATUS_DENIED              = 401;    // access denied
  HTTP_STATUS_PAYMENT_REQ         = 402;    // payment required
  HTTP_STATUS_FORBIDDEN           = 403;    // request forbidden
  HTTP_STATUS_NOT_FOUND           = 404;    // object not found
  HTTP_STATUS_BAD_METHOD          = 405;    // method is not allowed
  HTTP_STATUS_NONE_ACCEPTABLE     = 406;    // no response acceptable to client found
  HTTP_STATUS_PROXY_AUTH_REQ      = 407;    // proxy authentication required
  HTTP_STATUS_REQUEST_TIMEOUT     = 408;    // server timed out waiting for request
  HTTP_STATUS_CONFLICT            = 409;    // user should resubmit with more info
  HTTP_STATUS_GONE                = 410;    // the resource is no longer available
  HTTP_STATUS_AUTH_REFUSED        = 411;    // couldn't authorize client
  HTTP_STATUS_PRECOND_FAILED      = 412;    // precondition given in request failed
  HTTP_STATUS_REQUEST_TOO_LARGE   = 413;    // request entity was too large
  HTTP_STATUS_URI_TOO_LONG        = 414;    // request URI too long
  HTTP_STATUS_UNSUPPORTED_MEDIA   = 415;    // unsupported media type

  HTTP_STATUS_SERVER_ERROR        = 500;    // internal server error
  HTTP_STATUS_NOT_SUPPORTED       = 501;    // required not supported
  HTTP_STATUS_BAD_GATEWAY         = 502;    // error response received from gateway
  HTTP_STATUS_SERVICE_UNAVAIL     = 503;    // temporarily overloaded
  HTTP_STATUS_GATEWAY_TIMEOUT     = 504;    // timed out waiting for gateway
  HTTP_STATUS_VERSION_NOT_SUP     = 505;    // HTTP version not supported

  HTTP_STATUS_FIRST               = HTTP_STATUS_CONTINUE;
  HTTP_STATUS_LAST                = HTTP_STATUS_VERSION_NOT_SUP;

//
// values for dwModifiers parameter of HttpAddRequestHeaders
//
  HTTP_ADDREQ_INDEX_MASK          = $0000FFFF;
  HTTP_ADDREQ_FLAGS_MASK          = $FFFF0000;

//
// HTTP_ADDREQ_FLAG_ADD_IF_NEW - the header will only be added if it doesn't
// already exist
//
  HTTP_ADDREQ_FLAG_ADD_IF_NEW     = $10000000;

//
// HTTP_ADDREQ_FLAG_ADD - if HTTP_ADDREQ_FLAG_REPLACE is set but the header is
// not found then if this flag is set, the header is added anyway, so long as
// there is a valid header-value
//
  HTTP_ADDREQ_FLAG_ADD            = $20000000;

//
// HTTP_ADDREQ_FLAG_COALESCE - coalesce headers with same name. e.g.
// "Accept: text/*" and "Accept: audio/*" with this flag results in a single
// header: "Accept: text/*, audio/*"
//
  HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA           = $40000000;
  HTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON       = $01000000;
  HTTP_ADDREQ_FLAG_COALESCE                      = HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA;

//
// HTTP_ADDREQ_FLAG_REPLACE - replaces the specified header. Only one header can
// be supplied in the buffer. If the header to be replaced is not the first
// in a list of headers with the same name, then the relative index should be
// supplied in the low 8 bits of the dwModifiers parameter. If the header-value
// part is missing, then the header is removed
//
  HTTP_ADDREQ_FLAG_REPLACE        = $80000000;

//
// flags for HttpSendRequestEx(), HttpEndRequest()
//
  HSR_ASYNC       = WININET_API_FLAG_ASYNC;          // force async
  HSR_SYNC        = WININET_API_FLAG_SYNC;           // force sync
  HSR_USE_CONTEXT = WININET_API_FLAG_USE_CONTEXT;    // use dwContext value
  HSR_INITIATE    = $00000008;                       // iterative operation (completed by HttpEndRequest)
  HSR_DOWNLOAD    = $00000010;                       // download to file
  HSR_CHUNKED     = $00000020;                       // operation is send of chunked data

//
// InternetErrorDlg - Provides UI for certain Errors.
//
  FLAGS_ERROR_UI_FILTER_FOR_ERRORS            = $01;
  FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS         = $02;
  FLAGS_ERROR_UI_FLAGS_GENERATE_DATA          = $04;
  FLAGS_ERROR_UI_FLAGS_NO_UI                  = $08;
  FLAGS_ERROR_UI_SERIALIZE_DIALOGS            = $10;

//
// Internet API error returns
//
  INTERNET_ERROR_BASE                         = 12000;

  ERROR_INTERNET_OUT_OF_HANDLES               = INTERNET_ERROR_BASE + 1;
  ERROR_INTERNET_TIMEOUT                      = INTERNET_ERROR_BASE + 2;
  ERROR_INTERNET_EXTENDED_ERROR               = INTERNET_ERROR_BASE + 3;
  ERROR_INTERNET_INTERNAL_ERROR               = INTERNET_ERROR_BASE + 4;
  ERROR_INTERNET_INVALID_URL                  = INTERNET_ERROR_BASE + 5;
  ERROR_INTERNET_UNRECOGNIZED_SCHEME          = INTERNET_ERROR_BASE + 6;
  ERROR_INTERNET_NAME_NOT_RESOLVED            = INTERNET_ERROR_BASE + 7;
  ERROR_INTERNET_PROTOCOL_NOT_FOUND           = INTERNET_ERROR_BASE + 8;
  ERROR_INTERNET_INVALID_OPTION               = INTERNET_ERROR_BASE + 9;
  ERROR_INTERNET_BAD_OPTION_LENGTH            = INTERNET_ERROR_BASE + 10;
  ERROR_INTERNET_OPTION_NOT_SETTABLE          = INTERNET_ERROR_BASE + 11;
  ERROR_INTERNET_SHUTDOWN                     = INTERNET_ERROR_BASE + 12;
  ERROR_INTERNET_INCORRECT_USER_NAME          = INTERNET_ERROR_BASE + 13;
  ERROR_INTERNET_INCORRECT_PASSWORD           = INTERNET_ERROR_BASE + 14;
  ERROR_INTERNET_LOGIN_FAILURE                = INTERNET_ERROR_BASE + 15;
  ERROR_INTERNET_INVALID_OPERATION            = INTERNET_ERROR_BASE + 16;
  ERROR_INTERNET_OPERATION_CANCELLED          = INTERNET_ERROR_BASE + 17;
  ERROR_INTERNET_INCORRECT_HANDLE_TYPE        = INTERNET_ERROR_BASE + 18;
  ERROR_INTERNET_INCORRECT_HANDLE_STATE       = INTERNET_ERROR_BASE + 19;
  ERROR_INTERNET_NOT_PROXY_REQUEST            = INTERNET_ERROR_BASE + 20;
  ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND     = INTERNET_ERROR_BASE + 21;
  ERROR_INTERNET_BAD_REGISTRY_PARAMETER       = INTERNET_ERROR_BASE + 22;
  ERROR_INTERNET_NO_DIRECT_ACCESS             = INTERNET_ERROR_BASE + 23;
  ERROR_INTERNET_NO_CONTEXT                   = INTERNET_ERROR_BASE + 24;
  ERROR_INTERNET_NO_CALLBACK                  = INTERNET_ERROR_BASE + 25;
  ERROR_INTERNET_REQUEST_PENDING              = INTERNET_ERROR_BASE + 26;
  ERROR_INTERNET_INCORRECT_FORMAT             = INTERNET_ERROR_BASE + 27;
  ERROR_INTERNET_ITEM_NOT_FOUND               = INTERNET_ERROR_BASE + 28;
  ERROR_INTERNET_CANNOT_CONNECT               = INTERNET_ERROR_BASE + 29;
  ERROR_INTERNET_CONNECTION_ABORTED           = INTERNET_ERROR_BASE + 30;
  ERROR_INTERNET_CONNECTION_RESET             = INTERNET_ERROR_BASE + 31;
  ERROR_INTERNET_FORCE_RETRY                  = INTERNET_ERROR_BASE + 32;
  ERROR_INTERNET_INVALID_PROXY_REQUEST        = INTERNET_ERROR_BASE + 33;

  ERROR_INTERNET_HANDLE_EXISTS                = INTERNET_ERROR_BASE + 36;
  ERROR_INTERNET_SEC_CERT_DATE_INVALID        = INTERNET_ERROR_BASE + 37;
  ERROR_INTERNET_SEC_CERT_CN_INVALID          = INTERNET_ERROR_BASE + 38;
  ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR       = INTERNET_ERROR_BASE + 39;
  ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR       = INTERNET_ERROR_BASE + 40;
  ERROR_INTERNET_MIXED_SECURITY               = INTERNET_ERROR_BASE + 41;
  ERROR_INTERNET_CHG_POST_IS_NON_SECURE       = INTERNET_ERROR_BASE + 42;
  ERROR_INTERNET_POST_IS_NON_SECURE           = INTERNET_ERROR_BASE + 43;
  ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED      = INTERNET_ERROR_BASE + 44;
  ERROR_INTERNET_INVALID_CA                   = INTERNET_ERROR_BASE + 45;
  ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP        = INTERNET_ERROR_BASE + 46;
  ERROR_INTERNET_ASYNC_THREAD_FAILED          = INTERNET_ERROR_BASE + 47;
  ERROR_INTERNET_REDIRECT_SCHEME_CHANGE       = INTERNET_ERROR_BASE + 48;
  ERROR_INTERNET_DIALOG_PENDING               = INTERNET_ERROR_BASE + 49;
  ERROR_INTERNET_RETRY_DIALOG                 = INTERNET_ERROR_BASE + 50;
  ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR      = INTERNET_ERROR_BASE + 52;
  ERROR_INTERNET_INSERT_CDROM                 = INTERNET_ERROR_BASE + 53;

//
// FTP API errors
//
  ERROR_FTP_TRANSFER_IN_PROGRESS              = INTERNET_ERROR_BASE + 110;
  ERROR_FTP_DROPPED                           = INTERNET_ERROR_BASE + 111;
  ERROR_FTP_NO_PASSIVE_MODE                   = INTERNET_ERROR_BASE + 112;

//
// gopher API errors
//
  ERROR_GOPHER_PROTOCOL_ERROR                 = INTERNET_ERROR_BASE + 130;
  ERROR_GOPHER_NOT_FILE                       = INTERNET_ERROR_BASE + 131;
  ERROR_GOPHER_DATA_ERROR                     = INTERNET_ERROR_BASE + 132;
  ERROR_GOPHER_END_OF_DATA                    = INTERNET_ERROR_BASE + 133;
  ERROR_GOPHER_INVALID_LOCATOR                = INTERNET_ERROR_BASE + 134;
  ERROR_GOPHER_INCORRECT_LOCATOR_TYPE         = INTERNET_ERROR_BASE + 135;
  ERROR_GOPHER_NOT_GOPHER_PLUS                = INTERNET_ERROR_BASE + 136;
  ERROR_GOPHER_ATTRIBUTE_NOT_FOUND            = INTERNET_ERROR_BASE + 137;
  ERROR_GOPHER_UNKNOWN_LOCATOR                = INTERNET_ERROR_BASE + 138;

//
// HTTP API errors
//
  ERROR_HTTP_HEADER_NOT_FOUND                 = INTERNET_ERROR_BASE + 150;
  ERROR_HTTP_DOWNLEVEL_SERVER                 = INTERNET_ERROR_BASE + 151;
  ERROR_HTTP_INVALID_SERVER_RESPONSE          = INTERNET_ERROR_BASE + 152;
  ERROR_HTTP_INVALID_HEADER                   = INTERNET_ERROR_BASE + 153;
  ERROR_HTTP_INVALID_QUERY_REQUEST            = INTERNET_ERROR_BASE + 154;
  ERROR_HTTP_HEADER_ALREADY_EXISTS            = INTERNET_ERROR_BASE + 155;
  ERROR_HTTP_REDIRECT_FAILED                  = INTERNET_ERROR_BASE + 156;
  ERROR_HTTP_NOT_REDIRECTED                   = INTERNET_ERROR_BASE + 160;
  ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION        = INTERNET_ERROR_BASE + 161;
  ERROR_HTTP_COOKIE_DECLINED                  = INTERNET_ERROR_BASE + 162;
  ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION      = INTERNET_ERROR_BASE + 168;

//
// additional Internet API error codes
//
  ERROR_INTERNET_SECURITY_CHANNEL_ERROR       = INTERNET_ERROR_BASE + 157;
  ERROR_INTERNET_UNABLE_TO_CACHE_FILE         = INTERNET_ERROR_BASE + 158;
  ERROR_INTERNET_TCPIP_NOT_INSTALLED          = INTERNET_ERROR_BASE + 159;
  ERROR_INTERNET_DISCONNECTED                 = INTERNET_ERROR_BASE + 163;
  ERROR_INTERNET_SERVER_UNREACHABLE           = INTERNET_ERROR_BASE + 164;
  ERROR_INTERNET_PROXY_SERVER_UNREACHABLE     = INTERNET_ERROR_BASE + 165;

  ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT        = INTERNET_ERROR_BASE + 166;
  ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT    = INTERNET_ERROR_BASE + 167;
  ERROR_INTERNET_SEC_INVALID_CERT             = INTERNET_ERROR_BASE + 169;
  ERROR_INTERNET_SEC_CERT_REVOKED             = INTERNET_ERROR_BASE + 170;

//
// InternetAutodial specific errors
//
  ERROR_INTERNET_FAILED_DUETOSECURITYCHECK    = INTERNET_ERROR_BASE + 171;

  INTERNET_ERROR_LAST                         = ERROR_INTERNET_FAILED_DUETOSECURITYCHECK;

//
// datatype definitions.
//

//
// cache entry type flags.
//
  NORMAL_CACHE_ENTRY          = $00000001;
  STABLE_CACHE_ENTRY          = $00000002;
  STICKY_CACHE_ENTRY          = $00000004;
  COOKIE_CACHE_ENTRY          = $00100000;
  URLHISTORY_CACHE_ENTRY      = $00200000;
  TRACK_OFFLINE_CACHE_ENTRY   = $00000010;
  TRACK_ONLINE_CACHE_ENTRY    = $00000020;

  SPARSE_CACHE_ENTRY          = $00010000;
  OCX_CACHE_ENTRY             = $00020000;

  URLCACHE_FIND_DEFAULT_FILTER = NORMAL_CACHE_ENTRY or
                                 COOKIE_CACHE_ENTRY or
                                 URLHISTORY_CACHE_ENTRY or
                                 TRACK_OFFLINE_CACHE_ENTRY or
                                 TRACK_ONLINE_CACHE_ENTRY or
                                 STICKY_CACHE_ENTRY;

  CACHE_ENTRY_ATTRIBUTE_FC        = $00000004;
  CACHE_ENTRY_HITRATE_FC          = $00000010;
  CACHE_ENTRY_MODTIME_FC          = $00000040;
  CACHE_ENTRY_EXPTIME_FC          = $00000080;
  CACHE_ENTRY_ACCTIME_FC          = $00000100;
  CACHE_ENTRY_SYNCTIME_FC         = $00000200;
  CACHE_ENTRY_HEADERINFO_FC       = $00000400;
  CACHE_ENTRY_EXEMPT_DELTA_FC     = $00000800;

  INTERNET_CACHE_GROUP_ADD      = 0;
  INTERNET_CACHE_GROUP_REMOVE   = 1;

//
// Flags for InternetDial - must not conflict with InternetAutodial flags
//                          as they are valid here also.
//
  INTERNET_DIAL_UNATTENDED       = $8000;

  INTERENT_GOONLINE_REFRESH      = $00000001;
  INTERENT_GOONLINE_MASK         = $00000001;

//
// Flags for InternetAutodial
//
  INTERNET_AUTODIAL_FORCE_ONLINE          = 1;
  INTERNET_AUTODIAL_FORCE_UNATTENDED      = 2;
  INTERNET_AUTODIAL_FAILIFSECURITYCHECK   = 4;
  INTERNET_AUTODIAL_FLAGS_MASK            = INTERNET_AUTODIAL_FORCE_ONLINE or
                                            INTERNET_AUTODIAL_FORCE_UNATTENDED or
                                            INTERNET_AUTODIAL_FAILIFSECURITYCHECK;

//
// Flags for InternetGetConnectedState
//
  INTERNET_CONNECTION_MODEM           = 1;
  INTERNET_CONNECTION_LAN             = 2;
  INTERNET_CONNECTION_PROXY           = 4;
  INTERNET_CONNECTION_MODEM_BUSY      = 8;

//
// Flags for custom dial handler
//
  INTERNET_CUSTOMDIAL_CONNECT         = 0;
  INTERNET_CUSTOMDIAL_UNATTENDED      = 1;
  INTERNET_CUSTOMDIAL_DISCONNECT      = 2;
  INTERNET_CUSTOMDIAL_SHOWOFFLINE     = 4;

//
// Custom dial handler supported functionality flags
//
  INTERNET_CUSTOMDIAL_SAFE_FOR_UNATTENDED = 1;
  INTERNET_CUSTOMDIAL_WILL_SUPPLY_STATE   = 2;
  INTERNET_CUSTOMDIAL_CAN_HANGUP          = 4;

type
  HINTERNET      = Pointer;
  PHINTERNET     = ^HINTERNET;

  INTERNET_PORT  = Word;
  PINTERNET_PORT = ^INTERNET_PORT;

  PInternetScheme = ^TInternetScheme;
  TInternetScheme = Longint;

//
// TInternetAsyncResult - this structure is returned to the application via
// the callback with INTERNET_STATUS_REQUEST_COMPLETE. It is not sufficient to
// just return the result of the async operation. If the API failed then the
// app cannot call GetLastError because the thread context will be incorrect.
// Both the value returned by the async API and any resultant error code are
// made available. The app need not check dwError if dwResult indicates that
// the API succeeded (in this case dwError will be ERROR_SUCCESS)
//
  PInternetAsyncResult = ^TInternetAsyncResult;
  TInternetAsyncResult = record
    dwResult: DWORD;  // the HINTERNET, DWORD or BOOL return code from an async API
    dwError:  DWORD;  // dwError - the error code if the API failed
  end;

  PInternetPrefetchStatus = ^TInternetPrefetchStatus;
  TInternetPrefetchStatus = record
    dwStatus: DWORD;  // dwStatus - status of download. See INTERNET_PREFETCH_ flags
    dwSize:   DWORD;  // dwSize - size of file downloaded so far
  end;

  PInternetProxyInfo = ^TInternetProxyInfo;
  TInternetProxyInfo = record
    dwAccessType:    DWORD;
    lpszProxy:       LPCSTR;
    lpszProxyBypass: LPCSTR;
  end;

//
// INTERNET_VERSION_INFO - version information returned via
// InternetQueryOption(..., INTERNET_OPTION_VERSION, ...)
//
  PInternetVersionInfo = ^TInternetVersionInfo;
  TInternetVersionInfo = record
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
  end;

//
// HTTP_VERSION_INFO - query or set global HTTP version (1.0 or 1.1)
//
  PHttpVersionInfo = ^THttpVersionInfo;
  THttpVersionInfo = record
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
  end;

//
// INTERNET_CONNECTED_INFO - information used to set the global connected state
//
  PInternetConnectedInfo = ^TInternetConnectedInfo;
  TInternetConnectedInfo = record
    //
    // dwConnectedState - new connected/disconnected state.
    // See INTERNET_STATE_CONNECTED, etc.
    //
      dwConnectedState: DWORD;
    //
    // dwFlags - flags controlling connected->disconnected (or disconnected->
    // connected) transition. See below
    //
      dwFlags: DWORD;
  end;

//
// URL_COMPONENTS - the constituent parts of an URL. Used in InternetCrackUrl
// and InternetCreateUrl
//
// For InternetCrackUrl, if a Pointer field and its corresponding length field
// are both 0 then that component is not returned; If the Pointer field is NULL
// but the length field is not zero, then both the Pointer and length fields are
// returned; if both Pointer and corresponding length fields are non-zero then
// the Pointer field points to a buffer where the component is copied. The
// component may be un-escaped, depending on dwFlags
//
// For InternetCreateUrl, the Pointer fields should be nil if the component
// is not required. If the corresponding length field is zero then the Pointer
// field is the address of a zero-terminated string. If the length field is not
// zero then it is the string length of the corresponding Pointer field
//
type
  PURLComponents = ^TURLComponents;
  TURLComponents = record
    dwStructSize: DWORD;        // size of this structure. Used in version check
    lpszScheme: LPSTR;          // Pointer to scheme name
    dwSchemeLength: DWORD;      // length of scheme name
    nScheme: TInternetScheme;   // enumerated scheme type (if known)
    lpszHostName: LPSTR;        // Pointer to host name
    dwHostNameLength: DWORD;    // length of host name
    nPort: INTERNET_PORT;       // converted port number
    lpszUserName: LPSTR;        // Pointer to user name
    dwUserNameLength: DWORD;    // length of user name
    lpszPassword: LPSTR;        // Pointer to password
    dwPasswordLength: DWORD;    // length of password
    lpszUrlPath: LPSTR;         // Pointer to URL-path
    dwUrlPathLength: DWORD;     // length of URL-path
    lpszExtraInfo: LPSTR;       // Pointer to extra information (e.g. ?foo or #foo)
    dwExtraInfoLength: DWORD;   // length of extra information
  end;

//
// TInternetCertificateInfo lpBuffer - contains the certificate returned from
// the server
//
  PInternetCertificateInfo = ^TInternetCertificateInfo;
  TInternetCertificateInfo = record
    //
    // ftExpiry - date the certificate expires.
    //
    ftExpiry: TFileTime;
    //
    // ftStart - date the certificate becomes valid.
    //
    ftStart: TFileTime;
    //
    // lpszSubjectInfo - the name of organization, site, and server
    //   the cert. was issued for.
    //
    lpszSubjectInfo: LPSTR;
    //
    // lpszIssuerInfo - the name of orgainzation, site, and server
    //   the cert was issues by.
    //
    lpszIssuerInfo: LPSTR;
    //
    // lpszProtocolName - the name of the protocol used to provide the secure
    //   connection.
    //
    lpszProtocolName: LPSTR;
    //
    // lpszSignatureAlgName - the name of the algorithm used for signing
    //  the certificate.
    //
    lpszSignatureAlgName: LPSTR;
    //
    // lpszEncryptionAlgName - the name of the algorithm used for
    //  doing encryption over the secure channel (SSL/PCT) connection.
    //
    lpszEncryptionAlgName: LPSTR;
    //
    // dwKeySize - size of the key.
    //
    dwKeySize: DWORD;
  end;

//
// INTERNET_BUFFERS - combines headers and data. May be chained for e.g. file
// upload or scatter/gather operations. For chunked read/write, lpcszHeader
// contains the chunked-ext
//
  PInternetBuffers = ^TInternetBuffers;
  TInternetBuffers = record
    dwStructSize: DWORD;      // used for API versioning. Set to sizeof(INTERNET_BUFFERS)
    Next: PInternetBuffers;   // chain of buffers
    lpcszHeader: LPSTR;       // Pointer to headers (may be NULL)
    dwHeadersLength: DWORD;   // length of headers if not NULL
    dwHeadersTotal: DWORD;    // size of headers if not enough buffer
    lpvBuffer: Pointer;       // Pointer to data buffer (may be NULL)
    dwBufferLength: DWORD;    // length of data buffer if not NULL
    dwBufferTotal: DWORD;     // total size of chunk, or content-length if not chunked
    dwOffsetLow: DWORD;       // used for read-ranges (only used in HttpSendRequest2)
    dwOffsetHigh: DWORD;
  end;

//
// callback function for InternetSetStatusCallback
//
  TFNInternetStatusCallback = TFarProc;
  PFNInternetStatusCallback = ^TFNInternetStatusCallback;

//
// GOPHER_FIND_DATA - returns the results of a GopherFindFirstFile/
// InternetFindNextFile request
//
  PGopherFindDataA = ^TGopherFindDataA;
  PGopherFindDataW = ^TGopherFindDataW;
  PGopherFindData = PGopherFindDataA;

  TGopherFindDataA = record
    DisplayString: array [0..MAX_GOPHER_DISPLAY_TEXT-1] of AnsiChar;
    GopherType: DWORD;  // GopherType - if known
    SizeLow: DWORD;
    SizeHigh: DWORD;
    LastModificationTime: TFileTime;
    Locator: array [0..MAX_GOPHER_LOCATOR_LENGTH - 1] of AnsiChar;
  end;
  TGopherFindDataW = record
    DisplayString: array [0..MAX_GOPHER_DISPLAY_TEXT - 1] of WideChar;
    GopherType: DWORD;  // GopherType - if known
    SizeLow: DWORD;
    SizeHigh: DWORD;
    LastModificationTime: TFileTime;
    Locator: array [0..MAX_GOPHER_LOCATOR_LENGTH - 1] of WideChar;
  end;
  TGopherFindData = TGopherFindDataA;

//
// structured gopher attributes (as defined in gopher+ protocol document)
//
  PGopherAdminAttributeType = ^TGopherAdminAttributeType;
  TGopherAdminAttributeType = record
    Comment: LPCSTR;
    EmailAddress: LPCSTR;
  end;

  PGopherModDateAttributeType = ^TGopherModDateAttributeType;
  TGopherModDateAttributeType = record
    DateAndTime: TFileTime;
  end;

  PGopherTtlAttributeType = ^TGopherTtlAttributeType;
  TGopherTtlAttributeType = record
    Ttl: DWORD;
  end;

  PGopherScoreAttributeType = ^TGopherScoreAttributeType;
  TGopherScoreAttributeType = record
    Score: Longint;
  end;

  PGopherScoreRangeAttributeType = ^TGopherScoreRangeAttributeType;
  TGopherScoreRangeAttributeType = record
    LowerBound: Longint;
    UpperBound: Longint;
  end;

  PGopherSiteAttributeType = ^TGopherSiteAttributeType;
  TGopherSiteAttributeType = record
    Site: LPCSTR;
  end;

  PGopherOrganizationAttributeType = ^TGopherOrganizationAttributeType;
  TGopherOrganizationAttributeType = record
    Organization: LPCSTR;
  end;

  PGopherLocationAttributeType = ^TGopherLocationAttributeType;
  TGopherLocationAttributeType = record
    Location: LPCSTR;
  end;

  PGopherGeographicalLocationAttributeType = ^TGopherGeographicalLocationAttributeType;
  TGopherGeographicalLocationAttributeType = record
    DegreesNorth: Longint;
    MinutesNorth: Longint;
    SecondsNorth: Longint;
    DegreesEast: Longint;
    MinutesEast: Longint;
    SecondsEast: Longint;
  end;

  PGopherTimezoneAttributeType = ^TGopherTimezoneAttributeType;
  TGopherTimezoneAttributeType = record
    Zone: Longint;
  end;

  PGopherProviderAttributeType = ^TGopherProviderAttributeType;
  TGopherProviderAttributeType = record
    Provider: LPCSTR;
  end;

  PGopherVersionAttributeType = ^TGopherVersionAttributeType;
  TGopherVersionAttributeType = record
    Version: LPCSTR;
  end;

  PGopherAbstractAttributeType = ^TGopherAbstractAttributeType;
  TGopherAbstractAttributeType = record
    ShortAbstract: LPCSTR;
    AbstractFile: LPCSTR;
  end;

  PGopherViewAttributeType = ^TGopherViewAttributeType;
  TGopherViewAttributeType = record
    ContentType: LPCSTR;
    Language: LPCSTR;
    Size: DWORD;
  end;

  PGopherVeronicaAttributeType = ^TGopherVeronicaAttributeType;
  TGopherVeronicaAttributeType = record
    TreeWalk: BOOL;
  end;

  PGopherAskAttributeType = ^TGopherAskAttributeType;
  TGopherAskAttributeType = record
    QuestionType: LPCSTR;
    QuestionText: LPCSTR;
  end;

//
// GOPHER_UNKNOWN_ATTRIBUTE_TYPE - this is returned if we retrieve an attribute
// that is not specified in the current gopher/gopher+ documentation. It is up
// to the application to parse the information
//
  PGopherUnknownAttributeType = ^TGopherUnknownAttributeType;
  TGopherUnknownAttributeType = record
    Text: LPCSTR;
  end;

//
// GOPHER_ATTRIBUTE_TYPE - returned in the user's buffer when an enumerated
// GopherGetAttribute call is made
//
  PGopherAttributeType = ^TGopherAttributeType;
  TGopherAttributeType = record
    CategoryId: DWORD;  // e.g. GOPHER_CATEGORY_ID_ADMIN
    AttributeId: DWORD; // e.g. GOPHER_ATTRIBUTE_ID_ADMIN
    case Longint of
      0: (Admin: TGopherAdminAttributeType);
      1: (ModDate: TGopherModDateAttributeType);
      2: (Ttl: TGopherTtlAttributeType);
      3: (Score: TGopherScoreAttributeType);
      4: (ScoreRange: TGopherScoreRangeAttributeType);
      5: (Site: TGopherSiteAttributeType);
      6: (Organization: TGopherOrganizationAttributeType);
      7: (Location: TGopherLocationAttributeType);
      8: (GeographicalLocation: TGopherGeographicalLocationAttributeType);
      9: (TimeZone: TGopherTimezoneAttributeType);
      10: (Provider: TGopherProviderAttributeType);
      11: (Version: TGopherVersionAttributeType);
      12: (AbstractType: TGopherAbstractAttributeType);
      13: (View: TGopherViewAttributeType);
      14: (Veronica: TGopherVeronicaAttributeType);
      15: (Ask: TGopherAskAttributeType);
      16: (Unknown: TGopherUnknownAttributeType);
    end;

  TFNGopherAttributeEnumerator = TFarProc;
  PFNGopherAttributeEnumerator = ^TFNGopherAttributeEnumerator;

  PFN_AUTH_NOTIFY = function conv arg_stdcall (dwContext:DWORD; dwReturn:DWORD; lpReserved:Pointer): DWORD;

  PInternetCacheEntryInfoA = ^TInternetCacheEntryInfoA;
  PInternetCacheEntryInfoW = ^TInternetCacheEntryInfoW;
  PInternetCacheEntryInfo = PInternetCacheEntryInfoA;
  TInternetCacheEntryInfoA = record
    dwStructSize: DWORD;             // version of cache system. ?? do we need this for all entries?
    lpszSourceUrlName: PAnsiChar;    // embedded Pointer to the URL name string.
    lpszLocalFileName: PAnsiChar;    // embedded Pointer to the local file name.
    CacheEntryType: DWORD;           // cache type bit mask.
    dwUseCount: DWORD;               // current users count of the cache entry.
    dwHitRate: DWORD;                // num of times the cache entry was retrieved.
    dwSizeLow: DWORD;                // low DWORD of the file size.
    dwSizeHigh: DWORD;               // high DWORD of the file size.
    LastModifiedTime: TFileTime;     // last modified time of the file in GMT format.
    ExpireTime: TFileTime;           // expire time of the file in GMT format
    LastAccessTime: TFileTime;       // last accessed time in GMT format
    LastSyncTime: TFileTime;         // last time the URL was synchronized
                                     // with the source
    lpHeaderInfo: PBYTE;             // embedded Pointer to the header info.
    dwHeaderInfoSize: DWORD;         // size of the above header.
    lpszFileExtension: PAnsiChar;    // File extension used to retrive the urldata as a file.
    dwReserved: DWORD;               // reserved for future use.
  end;
  TInternetCacheEntryInfoW = record
    dwStructSize: DWORD;             // version of cache system. ?? do we need this for all entries?
    lpszSourceUrlName: PAnsiChar;    // embedded Pointer to the URL name string.
    lpszLocalFileName: PWideChar;    // embedded Pointer to the local file name.
    CacheEntryType: DWORD;           // cache type bit mask.
    dwUseCount: DWORD;               // current users count of the cache entry.
    dwHitRate: DWORD;                // num of times the cache entry was retrieved.
    dwSizeLow: DWORD;                // low DWORD of the file size.
    dwSizeHigh: DWORD;               // high DWORD of the file size.
    LastModifiedTime: TFileTime;     // last modified time of the file in GMT format.
    ExpireTime: TFileTime;           // expire time of the file in GMT format
    LastAccessTime: TFileTime;       // last accessed time in GMT format
    LastSyncTime: TFileTime;         // last time the URL was synchronized
                                     // with the source
    lpHeaderInfo: PBYTE;             // embedded Pointer to the header info.
    dwHeaderInfoSize: DWORD;         // size of the above header.
    lpszFileExtension: PWideChar;    // File extension used to retrive the urldata as a file.
    dwReserved: DWORD;               // reserved for future use.
  end;
  TInternetCacheEntryInfo = TInternetCacheEntryInfoA;

  GROUPID = TLargeInteger;

//
// Custom dial handler prototype
//
  PFN_DIAL_HANDLER = function conv arg_stdcall (A:HWND; B:LPCSTR; C:DWORD; D:LPDWORD): DWORD;

function CommitUrlCacheEntryA conv arg_stdcall (lpszUrlName, lpszLocalFileName: PAnsiChar;
  ExpireTime, LastModifiedTime: TFileTime;  CacheEntryType: DWORD;
  lpHeaderInfo: PBYTE; dwHeaderSize: DWORD; lpszFileExtension: PAnsiChar;
  dwReserved: DWORD): BOOL;
  external WinINetDLL name 'CommitUrlCacheEntryA';

function CommitUrlCacheEntryW conv arg_stdcall (lpszUrlName, lpszLocalFileName: PAnsiChar;
  ExpireTime, LastModifiedTime: TFileTime;  CacheEntryType: DWORD;
  lpHeaderInfo: PBYTE; dwHeaderSize: DWORD; lpszFileExtension: PWideChar;
  dwReserved: DWORD): BOOL;
  external WinINetDLL name 'CommitUrlCacheEntryW';

function CommitUrlCacheEntry conv arg_stdcall (lpszUrlName, lpszLocalFileName: PAnsiChar;
  ExpireTime, LastModifiedTime: TFileTime;  CacheEntryType: DWORD;
  lpHeaderInfo: PBYTE; dwHeaderSize: DWORD; lpszFileExtension: PChar;
  dwReserved: DWORD): BOOL;
  external WinINetDLL name 'CommitUrlCacheEntryA';

function CreateUrlCacheEntryA conv arg_stdcall (lpszUrlName: PAnsiChar; dwExpectedFileSize: DWORD; lpszFileExtension: PAnsiChar;
  lpszFileName: PAnsiChar; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'CreateUrlCacheEntryA';

function CreateUrlCacheEntryW conv arg_stdcall (lpszUrlName: PAnsiChar; dwExpectedFileSize: DWORD; lpszFileExtension: PAnsiChar;
  lpszFileName: PWideChar; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'CreateUrlCacheEntryW';

function CreateUrlCacheEntry conv arg_stdcall (lpszUrlName: PAnsiChar; dwExpectedFileSize: DWORD; lpszFileExtension: PAnsiChar;
  lpszFileName: PChar; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'CreateUrlCacheEntryA';

function DeleteUrlCacheEntry conv arg_stdcall (lpszUrlName: LPCSTR): BOOL;
  external WinINetDLL name 'DeleteUrlCacheEntry';

function FindCloseUrlCache conv arg_stdcall (hEnumHandle: THandle): BOOL;
  external WinINetDLL name 'FindCloseUrlCache';

function FindFirstUrlCacheEntryA conv arg_stdcall (lpszUrlSearchPattern: PAnsiChar;
  var lpFirstCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwFirstCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'FindFirstUrlCacheEntryA';

function FindFirstUrlCacheEntryW conv arg_stdcall (lpszUrlSearchPattern: PAnsiChar;
  var lpFirstCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwFirstCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'FindFirstUrlCacheEntryW';

function FindFirstUrlCacheEntry conv arg_stdcall (lpszUrlSearchPattern: PAnsiChar;
  var lpFirstCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwFirstCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'FindFirstUrlCacheEntryA';

function FindNextUrlCacheEntryA conv arg_stdcall (hEnumHandle: THandle; var lpNextCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwNextCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'FindNextUrlCacheEntryA';

function FindNextUrlCacheEntryW conv arg_stdcall (hEnumHandle: THandle; var lpNextCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwNextCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'FindNextUrlCacheEntryW';

function FindNextUrlCacheEntry conv arg_stdcall (hEnumHandle: THandle; var lpNextCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwNextCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'FindNextUrlCacheEntryA';

function FtpCommandA conv arg_stdcall (hConnect: HINTERNET; fExpectResponse: BOOL;
  dwFlags: DWORD; lpszCommand: PAnsiChar; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpCommandA';

function FtpCommandW conv arg_stdcall (hConnect: HINTERNET; fExpectResponse: BOOL;
  dwFlags: DWORD; lpszCommand: PWideChar; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpCommandW';

function FtpCommand conv arg_stdcall (hConnect: HINTERNET; fExpectResponse: BOOL;
  dwFlags: DWORD; lpszCommand: PChar; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpCommandA';

function FtpCreateDirectoryA conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PAnsiChar): BOOL;
  external WinINetDLL name 'FtpCreateDirectoryA';

function FtpCreateDirectoryW conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PWideChar): BOOL;
  external WinINetDLL name 'FtpCreateDirectoryW';

function FtpCreateDirectory conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PChar): BOOL;
  external WinINetDLL name 'FtpCreateDirectoryA';

function FtpDeleteFileA conv arg_stdcall (hConnect: HINTERNET; lpszFileName: PAnsiChar): BOOL;
  external WinINetDLL name 'FtpDeleteFileA';

function FtpDeleteFileW conv arg_stdcall (hConnect: HINTERNET; lpszFileName: PWideChar): BOOL;
  external WinINetDLL name 'FtpDeleteFileW';

function FtpDeleteFile conv arg_stdcall (hConnect: HINTERNET; lpszFileName: PChar): BOOL;
  external WinINetDLL name 'FtpDeleteFileA';

function FtpFindFirstFileA conv arg_stdcall (hConnect: HINTERNET; lpszSearchFile: PAnsiChar;
  var lpFindFileData: TWin32FindDataA; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'FtpFindFirstFileA';

function FtpFindFirstFileW conv arg_stdcall (hConnect: HINTERNET; lpszSearchFile: PWideChar;
  var lpFindFileData: TWin32FindDataW; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'FtpFindFirstFileW';

function FtpFindFirstFile conv arg_stdcall (hConnect: HINTERNET; lpszSearchFile: PChar;
  var lpFindFileData: TWin32FindData; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'FtpFindFirstFileA';

function FtpGetCurrentDirectoryA conv arg_stdcall (hConnect: HINTERNET; lpszCurrentDirectory: PAnsiChar; var lpdwCurrentDirectory: DWORD): BOOL;
  external WinINetDLL name 'FtpGetCurrentDirectoryA';

function FtpGetCurrentDirectoryW conv arg_stdcall (hConnect: HINTERNET; lpszCurrentDirectory: PWideChar; var lpdwCurrentDirectory: DWORD): BOOL;
  external WinINetDLL name 'FtpGetCurrentDirectoryW';

function FtpGetCurrentDirectory conv arg_stdcall (hConnect: HINTERNET; lpszCurrentDirectory: PChar; var lpdwCurrentDirectory: DWORD): BOOL;
  external WinINetDLL name 'FtpGetCurrentDirectoryA';

function FtpGetFileA conv arg_stdcall (hConnect: HINTERNET; lpszRemoteFile: PAnsiChar;
  lpszNewFile: PAnsiChar; fFailIfExists: BOOL; dwFlagsAndAttributes: DWORD;
  dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpGetFileA';

function FtpGetFileW conv arg_stdcall (hConnect: HINTERNET; lpszRemoteFile: PWideChar;
  lpszNewFile: PWideChar; fFailIfExists: BOOL; dwFlagsAndAttributes: DWORD;
  dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpGetFileW';

function FtpGetFile conv arg_stdcall (hConnect: HINTERNET; lpszRemoteFile: PChar;
  lpszNewFile: PChar; fFailIfExists: BOOL; dwFlagsAndAttributes: DWORD;
  dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpGetFileA';

function FtpOpenFileA conv arg_stdcall (hConnect: HINTERNET; lpszFileName: PAnsiChar;
  dwAccess: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'FtpOpenFileA';

function FtpOpenFileW conv arg_stdcall (hConnect: HINTERNET; lpszFileName: PWideChar;
  dwAccess: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'FtpOpenFileW';

function FtpOpenFile conv arg_stdcall (hConnect: HINTERNET; lpszFileName: PChar;
  dwAccess: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'FtpOpenFileA';

function FtpPutFileA conv arg_stdcall (hConnect: HINTERNET; lpszLocalFile: PAnsiChar;
  lpszNewRemoteFile: PAnsiChar; dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpPutFileA';

function FtpPutFileW conv arg_stdcall (hConnect: HINTERNET; lpszLocalFile: PWideChar;
  lpszNewRemoteFile: PWideChar; dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpPutFileW';

function FtpPutFile conv arg_stdcall (hConnect: HINTERNET; lpszLocalFile: PChar;
  lpszNewRemoteFile: PChar; dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'FtpPutFileA';

function FtpRemoveDirectoryA conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PAnsiChar): BOOL;
  external WinINetDLL name 'FtpRemoveDirectoryA';

function FtpRemoveDirectoryW conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PWideChar): BOOL;
  external WinINetDLL name 'FtpRemoveDirectoryW';

function FtpRemoveDirectory conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PChar): BOOL;
  external WinINetDLL name 'FtpRemoveDirectoryA';

function FtpRenameFileA conv arg_stdcall (hConnect: HINTERNET; lpszExisting: PAnsiChar; lpszNew: PAnsiChar): BOOL;
  external WinINetDLL name 'FtpRenameFileA';

function FtpRenameFileW conv arg_stdcall (hConnect: HINTERNET; lpszExisting: PWideChar; lpszNew: PWideChar): BOOL;
  external WinINetDLL name 'FtpRenameFileW';

function FtpRenameFile conv arg_stdcall (hConnect: HINTERNET; lpszExisting: PChar; lpszNew: PChar): BOOL;
  external WinINetDLL name 'FtpRenameFileA';

function FtpSetCurrentDirectoryA conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PAnsiChar): BOOL;
  external WinINetDLL name 'FtpSetCurrentDirectoryA';

function FtpSetCurrentDirectoryW conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PWideChar): BOOL;
  external WinINetDLL name 'FtpSetCurrentDirectoryW';

function FtpSetCurrentDirectory conv arg_stdcall (hConnect: HINTERNET; lpszDirectory: PChar): BOOL;
  external WinINetDLL name 'FtpSetCurrentDirectoryA';

function GetUrlCacheEntryInfoA conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'GetUrlCacheEntryInfoA';

function GetUrlCacheEntryInfoW conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'GetUrlCacheEntryInfoW';

function GetUrlCacheEntryInfo conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD): BOOL;
  external WinINetDLL name 'GetUrlCacheEntryInfoA';

function GopherCreateLocatorA conv arg_stdcall (lpszHost: PAnsiChar; nServerPort: INTERNET_PORT;
  lpszDisplayString: PAnsiChar; lpszSelectorString: PAnsiChar; dwGopherType: DWORD;
  lpszLocator: PAnsiChar; var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'GopherCreateLocatorA';

function GopherCreateLocatorW conv arg_stdcall (lpszHost: PWideChar; nServerPort: INTERNET_PORT;
  lpszDisplayString: PWideChar; lpszSelectorString: PWideChar; dwGopherType: DWORD;
  lpszLocator: PWideChar; var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'GopherCreateLocatorW';

function GopherCreateLocator conv arg_stdcall (lpszHost: PChar; nServerPort: INTERNET_PORT;
  lpszDisplayString: PChar; lpszSelectorString: PChar; dwGopherType: DWORD;
  lpszLocator: PChar; var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'GopherCreateLocatorA';

function GopherFindFirstFileA conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PAnsiChar;
  lpszSearchString: PAnsiChar; var lpFindData: TGopherFindDataA; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'GopherFindFirstFileA';

function GopherFindFirstFileW conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PWideChar;
  lpszSearchString: PWideChar; var lpFindData: TGopherFindDataW; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'GopherFindFirstFileW';

function GopherFindFirstFile conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PChar;
  lpszSearchString: PChar; var lpFindData: TGopherFindData; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'GopherFindFirstFileA';

function GopherGetAttributeA conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PAnsiChar;
  lpszAttributeName: PAnsiChar; lpBuffer: Pointer; dwBufferLength: DWORD;
  var lpdwCharactersReturned: DWORD; lpfnEnumerator: PFNGopherAttributeEnumerator;
  dwContext: DWORD): BOOL;
  external WinINetDLL name 'GopherGetAttributeA';

function GopherGetAttributeW conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PWideChar;
  lpszAttributeName: PWideChar; lpBuffer: Pointer; dwBufferLength: DWORD;
  var lpdwCharactersReturned: DWORD; lpfnEnumerator: PFNGopherAttributeEnumerator;
  dwContext: DWORD): BOOL;
  external WinINetDLL name 'GopherGetAttributeW';

function GopherGetAttribute conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PChar;
  lpszAttributeName: PChar; lpBuffer: Pointer; dwBufferLength: DWORD;
  var lpdwCharactersReturned: DWORD; lpfnEnumerator: PFNGopherAttributeEnumerator;
  dwContext: DWORD): BOOL;
  external WinINetDLL name 'GopherGetAttributeA';

function GopherGetLocatorTypeA conv arg_stdcall (lpszLocator: PAnsiChar; var lpdwGopherType: DWORD): BOOL;
  external WinINetDLL name 'GopherGetLocatorTypeA';

function GopherGetLocatorTypeW conv arg_stdcall (lpszLocator: PWideChar; var lpdwGopherType: DWORD): BOOL;
  external WinINetDLL name 'GopherGetLocatorTypeW';

function GopherGetLocatorType conv arg_stdcall (lpszLocator: PChar; var lpdwGopherType: DWORD): BOOL;
  external WinINetDLL name 'GopherGetLocatorTypeA';

function GopherOpenFileA conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PAnsiChar;
  lpszView: PAnsiChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'GopherOpenFileA';

function GopherOpenFileW conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PWideChar;
  lpszView: PWideChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'GopherOpenFileW';

function GopherOpenFile conv arg_stdcall (hConnect: HINTERNET; lpszLocator: PChar;
  lpszView: PChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'GopherOpenFileA';

function HttpAddRequestHeadersA conv arg_stdcall (hRequest: HINTERNET; lpszHeaders: PAnsiChar;
  dwHeadersLength: DWORD; dwModifiers: DWORD): BOOL;
  external WinINetDLL name 'HttpAddRequestHeadersA';

function HttpAddRequestHeadersW conv arg_stdcall (hRequest: HINTERNET; lpszHeaders: PWideChar;
  dwHeadersLength: DWORD; dwModifiers: DWORD): BOOL;
  external WinINetDLL name 'HttpAddRequestHeadersW';

function HttpAddRequestHeaders conv arg_stdcall (hRequest: HINTERNET; lpszHeaders: PChar;
  dwHeadersLength: DWORD; dwModifiers: DWORD): BOOL;
  external WinINetDLL name 'HttpAddRequestHeadersA';

function HttpOpenRequestA conv arg_stdcall (hConnect: HINTERNET; lpszVerb: PAnsiChar;
  lpszObjectName: PAnsiChar; lpszVersion: PAnsiChar; lpszReferrer: PAnsiChar;
  lplpszAcceptTypes: PAnsiChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'HttpOpenRequestA';

function HttpOpenRequestW conv arg_stdcall (hConnect: HINTERNET; lpszVerb: PWideChar;
  lpszObjectName: PWideChar; lpszVersion: PWideChar; lpszReferrer: PWideChar;
  lplpszAcceptTypes: PWideChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'HttpOpenRequestW';

function HttpOpenRequest conv arg_stdcall (hConnect: HINTERNET; lpszVerb: PChar;
  lpszObjectName: PChar; lpszVersion: PChar; lpszReferrer: PChar;
  lplpszAcceptTypes: PChar; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'HttpOpenRequestA';

function HttpQueryInfoA conv arg_stdcall (hRequest: HINTERNET; dwInfoLevel: DWORD;
  lpvBuffer: Pointer; var lpdwBufferLength: DWORD; var lpdwReserved: DWORD): BOOL;
  external WinINetDLL name 'HttpQueryInfoA';

function HttpQueryInfoW conv arg_stdcall (hRequest: HINTERNET; dwInfoLevel: DWORD;
  lpvBuffer: Pointer; var lpdwBufferLength: DWORD; var lpdwReserved: DWORD): BOOL;
  external WinINetDLL name 'HttpQueryInfoW';

function HttpQueryInfo conv arg_stdcall (hRequest: HINTERNET; dwInfoLevel: DWORD;
  lpvBuffer: Pointer; var lpdwBufferLength: DWORD; var lpdwReserved: DWORD): BOOL;
  external WinINetDLL name 'HttpQueryInfoA';

function HttpSendRequestA conv arg_stdcall (hRequest: HINTERNET; lpszHeaders: PAnsiChar;
  dwHeadersLength: DWORD; lpOptional: Pointer; dwOptionalLength: DWORD): BOOL;
  external WinINetDLL name 'HttpSendRequestA';

function HttpSendRequestW conv arg_stdcall (hRequest: HINTERNET; lpszHeaders: PWideChar;
  dwHeadersLength: DWORD; lpOptional: Pointer; dwOptionalLength: DWORD): BOOL;
  external WinINetDLL name 'HttpSendRequestW';

function HttpSendRequest conv arg_stdcall (hRequest: HINTERNET; lpszHeaders: PChar;
  dwHeadersLength: DWORD; lpOptional: Pointer; dwOptionalLength: DWORD): BOOL;
  external WinINetDLL name 'HttpSendRequestA';

function InternetCanonicalizeUrlA conv arg_stdcall (lpszUrl: PAnsiChar;
  lpszBuffer: PAnsiChar; var lpdwBufferLength: DWORD; dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetCanonicalizeUrlA';

function InternetCanonicalizeUrlW conv arg_stdcall (lpszUrl: PWideChar; lpszBuffer: PWideChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetCanonicalizeUrlW';

function InternetCanonicalizeUrl conv arg_stdcall (lpszUrl: PChar; lpszBuffer: PChar; var lpdwBufferLength: DWORD;
  dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetCanonicalizeUrlA';

function InternetCloseHandle conv arg_stdcall (hInet: HINTERNET): BOOL;
  external WinINetDLL name 'InternetCloseHandle';

function InternetCombineUrlA conv arg_stdcall (lpszBaseUrl, lpszRelativeUrl: PAnsiChar;
  lpszBuffer: PAnsiChar; var lpdwBufferLength: DWORD; dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetCombineUrlA';

function InternetCombineUrlW conv arg_stdcall (lpszBaseUrl, lpszRelativeUrl: PWideChar;
  lpszBuffer: PWideChar; var lpdwBufferLength: DWORD; dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetCombineUrlW';

function InternetCombineUrl conv arg_stdcall (lpszBaseUrl, lpszRelativeUrl: PChar;
  lpszBuffer: PChar; var lpdwBufferLength: DWORD; dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetCombineUrlA';

function InternetConfirmZoneCrossing conv arg_stdcall (hWnd: HWND; szUrlPrev, szUrlNew: LPSTR; bPost: BOOL): DWORD;
  external WinINetDLL name 'InternetConfirmZoneCrossing';

function InternetConnectA conv arg_stdcall (hInet: HINTERNET; lpszServerName: PAnsiChar;
  nServerPort: INTERNET_PORT; lpszUsername: PAnsiChar; lpszPassword: PAnsiChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'InternetConnectA';

function InternetConnectW conv arg_stdcall (hInet: HINTERNET; lpszServerName: PWideChar;
  nServerPort: INTERNET_PORT; lpszUsername: PWideChar; lpszPassword: PWideChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'InternetConnectW';

function InternetConnect conv arg_stdcall (hInet: HINTERNET; lpszServerName: PChar;
  nServerPort: INTERNET_PORT; lpszUsername: PChar; lpszPassword: PChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'InternetConnectA';

function InternetCrackUrlA conv arg_stdcall (lpszUrl: PAnsiChar; dwUrlLength, dwFlags: DWORD; var lpUrlComponents: TURLComponents): BOOL;
  external WinINetDLL name 'InternetCrackUrlA';

function InternetCrackUrlW conv arg_stdcall (lpszUrl: PWideChar; dwUrlLength, dwFlags: DWORD; var lpUrlComponents: TURLComponents): BOOL;
  external WinINetDLL name 'InternetCrackUrlW';

function InternetCrackUrl conv arg_stdcall (lpszUrl: PChar; dwUrlLength, dwFlags: DWORD; var lpUrlComponents: TURLComponents): BOOL;
  external WinINetDLL name 'InternetCrackUrlA';

function InternetCreateUrlA conv arg_stdcall (var lpUrlComponents: TURLComponents;
  dwFlags: DWORD; lpszUrl: PAnsiChar; var dwUrlLength: DWORD): BOOL;
  external WinINetDLL name 'InternetCreateUrlA';

function InternetCreateUrlW conv arg_stdcall (var lpUrlComponents: TURLComponents;
  dwFlags: DWORD; lpszUrl: PWideChar; var dwUrlLength: DWORD): BOOL;
  external WinINetDLL name 'InternetCreateUrlW';

function InternetCreateUrl conv arg_stdcall (var lpUrlComponents: TURLComponents;
  dwFlags: DWORD; lpszUrl: PChar; var dwUrlLength: DWORD): BOOL;
  external WinINetDLL name 'InternetCreateUrlA';

function InternetErrorDlg conv arg_stdcall (hWnd: HWND; hRequest: HINTERNET; dwError, dwFlags: DWORD; var lppvData: Pointer): DWORD;
  external WinINetDLL name 'InternetErrorDlg';

function InternetFindNextFileA conv arg_stdcall (hFind: HINTERNET; lpvFindData: Pointer): BOOL;
  external WinINetDLL name 'InternetFindNextFileA';

function InternetFindNextFileW conv arg_stdcall (hFind: HINTERNET; lpvFindData: Pointer): BOOL;
  external WinINetDLL name 'InternetFindNextFileW';

function InternetFindNextFile conv arg_stdcall (hFind: HINTERNET; lpvFindData: Pointer): BOOL;
  external WinINetDLL name 'InternetFindNextFileA';

function InternetGetCookieA conv arg_stdcall (lpszUrl, lpszCookieName, lpszCookieData: PAnsiChar; var lpdwSize: DWORD): BOOL;
  external WinINetDLL name 'InternetGetCookieA';

function InternetGetCookieW conv arg_stdcall (lpszUrl, lpszCookieName, lpszCookieData: PWideChar; var lpdwSize: DWORD): BOOL;
  external WinINetDLL name 'InternetGetCookieW';

function InternetGetCookie conv arg_stdcall (lpszUrl, lpszCookieName, lpszCookieData: PChar; var lpdwSize: DWORD): BOOL;
  external WinINetDLL name 'InternetGetCookieA';

function InternetGetLastResponseInfoA conv arg_stdcall (var lpdwError: DWORD; lpszBuffer: PAnsiChar;
  var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetGetLastResponseInfoA';

function InternetGetLastResponseInfoW conv arg_stdcall (var lpdwError: DWORD; lpszBuffer: PWideChar;
  var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetGetLastResponseInfoW';

function InternetGetLastResponseInfo conv arg_stdcall (var lpdwError: DWORD; lpszBuffer: PChar;
  var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetGetLastResponseInfoA';

function InternetOpenA conv arg_stdcall (lpszAgent: PAnsiChar; dwAccessType: DWORD; lpszProxy, lpszProxyBypass: PAnsiChar; dwFlags: DWORD): HINTERNET;
  external WinINetDLL name 'InternetOpenA';

function InternetOpenW conv arg_stdcall (lpszAgent: PWideChar; dwAccessType: DWORD; lpszProxy, lpszProxyBypass: PWideChar; dwFlags: DWORD): HINTERNET;
  external WinINetDLL name 'InternetOpenW';

function InternetOpen conv arg_stdcall (lpszAgent: PChar; dwAccessType: DWORD; lpszProxy, lpszProxyBypass: PChar; dwFlags: DWORD): HINTERNET;
  external WinINetDLL name 'InternetOpenA';

function InternetOpenUrlA conv arg_stdcall (hInet: HINTERNET; lpszUrl: PAnsiChar; lpszHeaders: PAnsiChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'InternetOpenUrlA';

function InternetOpenUrlW conv arg_stdcall (hInet: HINTERNET; lpszUrl: PWideChar; lpszHeaders: PWideChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'InternetOpenUrlW';

function InternetOpenUrl conv arg_stdcall (hInet: HINTERNET; lpszUrl: PChar; lpszHeaders: PChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): HINTERNET;
  external WinINetDLL name 'InternetOpenUrlA';

function InternetQueryDataAvailable conv arg_stdcall (hFile: HINTERNET; var lpdwNumberOfBytesAvailable: DWORD;
  dwFlags, dwContext: DWORD): BOOL;
  external WinINetDLL name 'InternetQueryDataAvailable';

function InternetQueryOptionA conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetQueryOptionA';

function InternetQueryOptionW conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetQueryOptionW';

function InternetQueryOption conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; var lpdwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetQueryOptionA';

function InternetReadFile conv arg_stdcall (hFile: HINTERNET; lpBuffer: Pointer;
  dwNumberOfBytesToRead: DWORD; var lpdwNumberOfBytesRead: DWORD): BOOL;
  external WinINetDLL name 'InternetReadFile';

function InternetSetCookieA conv arg_stdcall (lpszUrl, lpszCookieName, lpszCookieData: PAnsiChar): BOOL;
  external WinINetDLL name 'InternetSetCookieA';

function InternetSetCookieW conv arg_stdcall (lpszUrl, lpszCookieName, lpszCookieData: PWideChar): BOOL;
  external WinINetDLL name 'InternetSetCookieW';

function InternetSetCookie conv arg_stdcall (lpszUrl, lpszCookieName, lpszCookieData: PChar): BOOL;
  external WinINetDLL name 'InternetSetCookieA';

function InternetSetFilePointer conv arg_stdcall (hFile: HINTERNET; lDistanceToMove: Longint; pReserved: Pointer;
  dwMoveMethod, dwContext: DWORD): DWORD;
  external WinINetDLL name 'InternetSetFilePointer';

function InternetSetOptionA conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; dwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetSetOptionA';

function InternetSetOptionW conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; dwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetSetOptionW';

function InternetSetOption conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; dwBufferLength: DWORD): BOOL;
  external WinINetDLL name 'InternetSetOptionA';

function InternetSetOptionExA conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; dwBufferLength, dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetSetOptionExA';

function InternetSetOptionExW conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; dwBufferLength, dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetSetOptionExW';

function InternetSetOptionEx conv arg_stdcall (hInet: HINTERNET; dwOption: DWORD; lpBuffer: Pointer; dwBufferLength, dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetSetOptionExA';

function InternetSetStatusCallback conv arg_stdcall (hInet: HINTERNET; lpfnInternetCallback: PFNInternetStatusCallback): PFNInternetStatusCallback;
  external WinINetDLL name 'InternetSetStatusCallback';

function InternetTimeFromSystemTime(const pst: TSystemTime; dwRFC: DWORD; lpszTime: LPSTR; cbTime: DWORD): BOOL;
  external WinINetDLL name 'InternetTimeFromSystemTime';

function InternetWriteFile conv arg_stdcall (const pst: TSystemTime; dwRFC: DWORD; lpszTime: LPSTR; cbTime: DWORD): BOOL;
  external WinINetDLL name 'InternetWriteFile';

function ReadUrlCacheEntryStream conv arg_stdcall (hUrlCacheStream: THandle;
  dwLocation: DWORD; var lpBuffer: Pointer; var lpdwLen: DWORD; Reserved: DWORD): BOOL;
  external WinINetDLL name 'ReadUrlCacheEntryStream';

function RetrieveUrlCacheEntryFileA conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
   var lpdwCacheEntryInfoBufferSize: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'RetrieveUrlCacheEntryFileA';

function RetrieveUrlCacheEntryFileW conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'RetrieveUrlCacheEntryFileW';

function RetrieveUrlCacheEntryFile conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'RetrieveUrlCacheEntryFileA';

function RetrieveUrlCacheEntryStreamA conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
   var lpdwCacheEntryInfoBufferSize: DWORD; fRandomRead: BOOL; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'RetrieveUrlCacheEntryStreamA';

function RetrieveUrlCacheEntryStreamW conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; fRandomRead: BOOL; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'RetrieveUrlCacheEntryStreamW';

function RetrieveUrlCacheEntryStream conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  var lpdwCacheEntryInfoBufferSize: DWORD; fRandomRead: BOOL; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'RetrieveUrlCacheEntryStreamA';

function SetUrlCacheEntryInfoA conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  dwFieldControl: DWORD): BOOL;
  external WinINetDLL name 'SetUrlCacheEntryInfoA';

function SetUrlCacheEntryInfoW conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  dwFieldControl: DWORD): BOOL;
  external WinINetDLL name 'SetUrlCacheEntryInfoW';

function SetUrlCacheEntryInfo conv arg_stdcall (lpszUrlName: PAnsiChar; var lpCacheEntryInfo: TInternetCacheEntryInfo;
  dwFieldControl: DWORD): BOOL;
  external WinINetDLL name 'SetUrlCacheEntryInfoA';

function UnlockUrlCacheEntryFile conv arg_stdcall (lpszUrlName: LPCSTR; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'UnlockUrlCacheEntryFile';

function UnlockUrlCacheEntryStream conv arg_stdcall (hUrlCacheStream: THandle; Reserved: DWORD): BOOL;
  external WinINetDLL name 'UnlockUrlCacheEntryStream';

function CreateUrlCacheGroup conv arg_stdcall (dwFlags: DWORD; lpReserved: Pointer): GROUPID;
  external WinINetDLL name 'CreateUrlCacheGroup';

function DeleteUrlCacheGroup conv arg_stdcall (Group_Id: GROUPID; dwFlags: DWORD; lpReserved: Pointer): BOOL;
  external WinINetDLL name 'DeleteUrlCacheGroup';

function FindFirstUrlCacheEntryExA conv arg_stdcall (lpszUrlSearchPattern: PAnsiChar;
  dwFlags: DWORD; dwFilter: DWORD;  Group_Id: GROUPID; lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
  lpdwFirstCacheEntryInfoBufferSize: LPDWORD; lpGroupAttributes: Pointer;
  pcbGroupAttributes: LPDWORD; lpReserved: Pointer): THandle;
  external WinINetDLL name 'FindFirstUrlCacheEntryExA';

function FindFirstUrlCacheEntryExW conv arg_stdcall (lpszUrlSearchPattern: PAnsiChar;
  dwFlags: DWORD; dwFilter: DWORD;  Group_Id: GROUPID; lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
  lpdwFirstCacheEntryInfoBufferSize: LPDWORD; lpGroupAttributes: Pointer;
  pcbGroupAttributes: LPDWORD; lpReserved: Pointer): THandle;
  external WinINetDLL name 'FindFirstUrlCacheEntryExW';

function FindFirstUrlCacheEntryEx conv arg_stdcall (lpszUrlSearchPattern: PAnsiChar;
  dwFlags: DWORD; dwFilter: DWORD;  Group_Id: GROUPID; lpFirstCacheEntryInfo: PInternetCacheEntryInfo;
  lpdwFirstCacheEntryInfoBufferSize: LPDWORD; lpGroupAttributes: Pointer;
  pcbGroupAttributes: LPDWORD; lpReserved: Pointer): THandle;
  external WinINetDLL name 'FindFirstUrlCacheEntryExA';

function FindNextUrlCacheEntryExA conv arg_stdcall (hEnumHandle: THANDLE;
  lpFirstCacheEntryInfo: PInternetCacheEntryInfo; lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
  lpGroupAttributes: Pointer; pcbGroupAttributes: LPDWORD; lpReserved: Pointer): BOOL;
  external WinINetDLL name 'FindNextUrlCacheEntryExA';

function FindNextUrlCacheEntryExW conv arg_stdcall (hEnumHandle: THANDLE;
  lpFirstCacheEntryInfo: PInternetCacheEntryInfo; lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
  lpGroupAttributes: Pointer; pcbGroupAttributes: LPDWORD;
  lpReserved: Pointer): BOOL;
  external WinINetDLL name 'FindNextUrlCacheEntryExW';

function FindNextUrlCacheEntryEx conv arg_stdcall (hEnumHandle: THANDLE;
    lpFirstCacheEntryInfo: PInternetCacheEntryInfo;  lpdwFirstCacheEntryInfoBufferSize: LPDWORD;
    lpGroupAttributes: Pointer; pcbGroupAttributes: LPDWORD; lpReserved: Pointer): BOOL;
  external WinINetDLL name 'FindNextUrlCacheEntryExA';

function GetUrlCacheEntryInfoExA conv arg_stdcall (lpszUrl: PAnsiChar;
    lpCacheEntryInfo: PInternetCacheEntryInfo; lpdwCacheEntryInfoBufSize: LPDWORD;
    lpszReserved: PAnsiChar; lpdwReserved: LPDWORD; lpReserved: Pointer;
    dwFlags: DWORD): BOOL;
  external WinINetDLL name 'GetUrlCacheEntryInfoExA';

function GetUrlCacheEntryInfoExW conv arg_stdcall (lpszUrl: PAnsiChar;
  lpCacheEntryInfo: PInternetCacheEntryInfo; lpdwCacheEntryInfoBufSize: LPDWORD;
  lpszReserved: PAnsiChar; lpdwReserved: LPDWORD; lpReserved: Pointer;
  dwFlags: DWORD): BOOL;
  external WinINetDLL name 'GetUrlCacheEntryInfoExW';

function GetUrlCacheEntryInfoEx conv arg_stdcall (lpszUrl: PAnsiChar;
  lpCacheEntryInfo: PInternetCacheEntryInfo; lpdwCacheEntryInfoBufSize: LPDWORD;
  lpszReserved: PAnsiChar; lpdwReserved: LPDWORD; lpReserved: Pointer;
  dwFlags: DWORD): BOOL;
  external WinINetDLL name 'GetUrlCacheEntryInfoExA';

function HttpEndRequestA conv arg_stdcall (hRequest: HINTERNET; lpBuffersOut: PInternetBuffers; dwFlags: DWORD;
  dwContext: DWORD): BOOL;
  external WinINetDLL name 'HttpEndRequestA';

function HttpEndRequestW conv arg_stdcall (hRequest: HINTERNET; lpBuffersOut: PInternetBuffers; dwFlags: DWORD;
  dwContext: DWORD): BOOL;
  external WinINetDLL name 'HttpEndRequestW';

function HttpEndRequest conv arg_stdcall (hRequest: HINTERNET; lpBuffersOut: PInternetBuffers; dwFlags: DWORD;
  dwContext: DWORD): BOOL;
  external WinINetDLL name 'HttpEndRequestA';

function InternetAttemptConnect conv arg_stdcall (dwReserved: DWORD): DWORD;
  external WinINetDLL name 'InternetAttemptConnect';

function InternetAuthNotifyCallback conv arg_stdcall (dwContext: DWORD; dwReturn: DWORD; lpReserved: Pointer): DWORD;
  external WinINetDLL name 'InternetAuthNotifyCallback';

function InternetAutodial conv arg_stdcall (dwFlags: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetAutodial';

function InternetAutodialHangup conv arg_stdcall (dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetAutodialHangup';

function InternetCheckConnectionA conv arg_stdcall (lpszUrl: PAnsiChar; dwFlags: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetCheckConnectionA';

function InternetCheckConnectionW conv arg_stdcall (lpszUrl: PAnsiChar; dwFlags: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetCheckConnectionW';

function InternetCheckConnection conv arg_stdcall (lpszUrl: PAnsiChar; dwFlags: DWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetCheckConnectionA';

function InternetDial conv arg_stdcall (hwndParent: HWND; lpszConnectoid: LPTSTR; dwFlags: DWORD;
  lpdwConnection: LPDWORD; dwReserved: DWORD): DWORD;
  external WinINetDLL name 'InternetDial';

function InternetGetConnectedState conv arg_stdcall (lpdwFlags: LPDWORD; dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetGetConnectedState';

function InternetGoOnline conv arg_stdcall (lpszURL: LPTSTR; hwndParent: HWND; dwFlags: DWORD): BOOL;
  external WinINetDLL name 'InternetGoOnline';

function InternetHangUp conv arg_stdcall (dwConnection: DWORD; dwReserved: DWORD): DWORD;
  external WinINetDLL name 'InternetHangUp';

function InternetLockRequestFile conv arg_stdcall (hInternet: HINTERNET; lphLockRequestInfo: PHandle): BOOL;
  external WinINetDLL name 'InternetLockRequestFile';

function InternetReadFileExA conv arg_stdcall (hFile: HINTERNET;  lpBuffersOut: Pointer;
  dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'InternetReadFileExA';

function InternetReadFileExW conv arg_stdcall (hFile: HINTERNET;  lpBuffersOut: Pointer;
  dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'InternetReadFileExW';

function InternetReadFileEx conv arg_stdcall (hFile: HINTERNET;  lpBuffersOut: Pointer;
  dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'InternetReadFileExA';

function InternetSetDialState conv arg_stdcall (lpszConnectoid: LPCTSTR; dwState: DWORD;
  dwReserved: DWORD): BOOL;
  external WinINetDLL name 'InternetSetDialState';

function InternetUnlockRequestFile conv arg_stdcall (hLockRequestInfo: THANDLE): BOOL;
  external WinINetDLL name 'InternetUnlockRequestFile';

function SetUrlCacheEntryGroup conv arg_stdcall (lpszUrlName: LPCSTR; dwFlags: DWORD;
  Group_Id: GROUPID; pbGroupAttributes: PChar; cbGroupAttributes: DWORD;
  lpReserved: Pointer): BOOL;
  external WinINetDLL name 'SetUrlCacheEntryGroup';

function HttpSendRequestExA conv arg_stdcall (hRequest: HINTERNET; lpBuffersIn: PInternetBuffers;
  lpBuffersOut: PInternetBuffers; dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'HttpSendRequestExA';

function HttpSendRequestExW conv arg_stdcall (hRequest: HINTERNET; lpBuffersIn: PInternetBuffers;
    lpBuffersOut: PInternetBuffers; dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'HttpSendRequestExW';

function HttpSendRequestEx conv arg_stdcall (hRequest: HINTERNET; lpBuffersIn: PInternetBuffers;
    lpBuffersOut: PInternetBuffers; dwFlags: DWORD; dwContext: DWORD): BOOL;
  external WinINetDLL name 'HttpSendRequestExA';

//
// gopher type macros
//
function IS_GOPHER_FILE(GopherType: DWORD): BOOL;
function IS_GOPHER_DIRECTORY(GopherType: DWORD): BOOL;
function IS_GOPHER_PHONE_SERVER(GopherType: DWORD): BOOL;
function IS_GOPHER_ERROR(GopherType: DWORD): BOOL;
function IS_GOPHER_INDEX_SERVER(GopherType: DWORD): BOOL;
function IS_GOPHER_TELNET_SESSION(GopherType: DWORD): BOOL;
function IS_GOPHER_BACKUP_SERVER(GopherType: DWORD): BOOL;
function IS_GOPHER_TN3270_SESSION(GopherType: DWORD): BOOL;
function IS_GOPHER_ASK(GopherType: DWORD): BOOL;
function IS_GOPHER_PLUS(GopherType: DWORD): BOOL;
function IS_GOPHER_TYPE_KNOWN(GopherType: DWORD): BOOL;

implementation

function IS_GOPHER_FILE(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_FILE_MASK) = 0;
end;

function IS_GOPHER_DIRECTORY(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_DIRECTORY) = 0;
end;

function IS_GOPHER_PHONE_SERVER(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_CSO) = 0;
end;

function IS_GOPHER_ERROR(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_ERROR) = 0;
end;

function IS_GOPHER_INDEX_SERVER(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_INDEX_SERVER) = 0;
end;

function IS_GOPHER_TELNET_SESSION(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_TELNET) = 0;
end;

function IS_GOPHER_BACKUP_SERVER(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_REDUNDANT) = 0;
end;

function IS_GOPHER_TN3270_SESSION(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_TN3270) = 0;
end;

function IS_GOPHER_ASK(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_ASK) = 0;
end;

function IS_GOPHER_PLUS(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_GOPHER_PLUS) = 0;
end;

function IS_GOPHER_TYPE_KNOWN(GopherType: DWORD): BOOL;
begin
  Result := (GopherType and GOPHER_TYPE_UNKNOWN) = 0;
end;

end.
