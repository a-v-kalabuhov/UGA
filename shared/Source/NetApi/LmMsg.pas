{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ LanManager share functions for Windows NT interface unit         }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: lmmsg.h, released 14 Nov 1998.             }
{ The original Pascal code is: LmMsg.pas, released 11 Jan 2000.    }
{ The initial developer of the Pascal code is Petr Vones           }
{ (petr.v@mujmail.cz).                                             }
{                                                                  }
{ Portions created by Petr Vones are                               }
{ Copyright (C) 2000 Petr Vones                                    }
{                                                                  }
{ Obtained through:                                                }
{                                                                  }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html                          }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}

unit LmMsg;

{$I LANMAN.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows, LmCons;

(*$HPPEMIT '#include <netcons.h>'*)
(*$HPPEMIT '#include <lmmsg.h>'*)


{$EXTERNALSYM NetMessageNameAdd}
function NetMessageNameAdd(servername, msgname: LPCWSTR): NET_API_STATUS; stdcall;

{$EXTERNALSYM NetMessageNameEnum}
function NetMessageNameEnum(servername: LPCWSTR; level: DWORD; bufptr: Pointer;
  prefmaxlen: DWORD; var entriesread: DWORD; var totalentries: DWORD;
  resume_handle: PDWORD): NET_API_STATUS; stdcall;

{$EXTERNALSYM NetMessageNameGetInfo}
function NetMessageNameGetInfo(servername: LPCWSTR; msgname: LPCWSTR;
  level: DWORD; var bufptr: Pointer): NET_API_STATUS; stdcall;

{$EXTERNALSYM NetMessageNameDel}
function NetMessageNameDel(servername, msgname: LPCWSTR): NET_API_STATUS; stdcall;

{$EXTERNALSYM NetMessageBufferSend}
function NetMessageBufferSend(servername: LPCWSTR; msgname: LPCWSTR;
  fromname: LPCWSTR; buf: Pointer; buflen: DWORD): NET_API_STATUS; stdcall;

type
  PMsgInfo0 = ^TMsgInfo0;
  {$EXTERNALSYM _MSG_INFO_0}
  _MSG_INFO_0 = record
    msgi0_name: LPWSTR;
  end;
  TMsgInfo0 = _MSG_INFO_0;
  {$EXTERNALSYM MSG_INFO_0}
  MSG_INFO_0 = _MSG_INFO_0;

  PMsgInfo1 = ^TMsgInfo1;
  {$EXTERNALSYM _MSG_INFO_1}
  _MSG_INFO_1 = record
    msgi1_name: LPWSTR;
    msgi1_forward_flag: DWORD;
    msgi1_forward: LPWSTR;
  end;
  TMsgInfo1 = _MSG_INFO_1;
  {$EXTERNALSYM MSG_INFO_1}
  MSG_INFO_1 = _MSG_INFO_1;


// Values for msgi1_forward_flag.

const
  {$EXTERNALSYM MSGNAME_NOT_FORWARDED}
  MSGNAME_NOT_FORWARDED   = $00;    // Name not forwarded
  {$EXTERNALSYM MSGNAME_FORWARDED_TO}
  MSGNAME_FORWARDED_TO    = $04;    // Name forward to remote station
  {$EXTERNALSYM MSGNAME_FORWARDED_FROM}
  MSGNAME_FORWARDED_FROM  = $10;    // Name forwarded from remote station

implementation

function NetMessageNameAdd; external netapi32lib name 'NetMessageNameAdd';
function NetMessageNameEnum; external netapi32lib name 'NetMessageNameEnum';
function NetMessageNameGetInfo; external netapi32lib name 'NetMessageNameGetInfo';
function NetMessageNameDel; external netapi32lib name 'NetMessageNameDel';
function NetMessageBufferSend; external netapi32lib name 'NetMessageBufferSend';

end.
