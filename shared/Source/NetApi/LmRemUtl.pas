{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ LanManager share functions for Windows NT interface unit         }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: lmremutl.h, released 14 Nov 1998.          }
{ The original Pascal code is: LmRemUtl.pas, released 13 Jan 2000. }
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

unit LmRemUtl;

{$I LANMAN.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows, LmCons;

(*$HPPEMIT '#include <lmremutl.h>'*)

function NetRemoteTOD(UncServerName: LPCWSTR; BufferPtr: Pointer): NET_API_STATUS; stdcall;
{$EXTERNALSYM NetRemoteTOD}

function NetRemoteComputerSupports(UncServerName: LPCWSTR; OptionsWanted: DWORD;
  var OptionsSupported: DWORD): NET_API_STATUS; stdcall;
{$EXTERNALSYM NetRemoteComputerSupports}

type
  PTimeOfDayInfo = ^TTimeOfDayInfo;
  _TIME_OF_DAY_INFO = record
    tod_elapsedt: DWORD;
    tod_msecs: DWORD;
    tod_hours: DWORD;
    tod_mins: DWORD;
    tod_secs: DWORD;
    tod_hunds: DWORD;
    tod_timezone: LongInt;
    tod_tinterval: DWORD;
    tod_day: DWORD;
    tod_month: DWORD;
    tod_year: DWORD;
    tod_weekday: DWORD;
  end;
  {$EXTERNALSYM _TIME_OF_DAY_INFO}
  TTimeOfDayInfo = _TIME_OF_DAY_INFO;
  TIME_OF_DAY_INFO = _TIME_OF_DAY_INFO;
  {$EXTERNALSYM TIME_OF_DAY_INFO}

// Mask bits for use with NetRemoteComputerSupports:

const
  SUPPORTS_REMOTE_ADMIN_PROTOCOL  = $00000002;
  {EXTERNALSYM SUPPORTS_REMOTE_ADMIN_PROTOCOL}
  SUPPORTS_RPC                    = $00000004;
  {EXTERNALSYM SUPPORTS_RPC}
  SUPPORTS_SAM_PROTOCOL           = $00000008;
  {EXTERNALSYM SUPPORTS_SAM_PROTOCOL}
  SUPPORTS_UNICODE                = $00000010;
  {EXTERNALSYM SUPPORTS_UNICODE}
  SUPPORTS_LOCAL                  = $00000020;
  {EXTERNALSYM SUPPORTS_LOCAL}
  SUPPORTS_ANY                    = $FFFFFFFF;
  {EXTERNALSYM SUPPORTS_ANY}

// Flag bits for RxRemoteApi:

  NO_PERMISSION_REQUIRED  = $00000001;      // set if use NULL session;
  {EXTERNALSYM NO_PERMISSION_REQUIRED}
  ALLOCATE_RESPONSE       = $00000002;      // set if RxRemoteApi allocates response buffer;
  {EXTERNALSYM ALLOCATE_RESPONSE}
  USE_SPECIFIC_TRANSPORT  = $80000000;
  {EXTERNALSYM USE_SPECIFIC_TRANSPORT}

implementation

function NetRemoteTOD; external netapi32lib name 'NetRemoteTOD';
function NetRemoteComputerSupports; external netapi32lib name 'NetRemoteComputerSupports';

end.
