{*******************************************************}
{                                                       }
{       "ИС МП УГА"                                     }
{       Класс-фабрика менеджеров                        }
{                                                       }
{       Copyright (c) 2004-2005, МП УГА                 }
{                                                       }
{       Автор: Сирота Е.А.                              }
{                                                       }
{*******************************************************}

{ Описание:
  Имя модуля: Class Factory
  Версия: 1.01
  Дата последнего изменения: 22.04.05
  Цель: содержит класс - фабрику менеджеров
  Используется:
  Использует:
  Исключения:   }

{
  1.01          22.04.05
    - добавлен менеджер TKisLicensedOrgs
}

unit uKisFactory;

interface

{$I KisFlags.pas}

uses
  // Project
  uKisClasses;

type
  TKisMngrFactory = class
 public
   function CreateMngr(Ident: TKisMngrs): TkisMngr;
 end;

implementation

uses
   // Project
  uKisAppModule, uKisContragents, uKisBanks, uKisContragentAddresses,
  uKisContragentDocuments, uKisLetters, uKisOrders, uKisContragentCertificates,
  uKisOffices, uKisOrgs, uKisPeople, uKisFirms, uKisOfficeDocs, uKisMapTracings,
  uKisOutcomingLetters, uKisStreets, uKisGeoPunkts, uKisDecreeProjects,
  uKisArchivalDocsMngr, uKisLicensedOrgs, uKisAccounts, uKisMap500,
  uKisMapScans, uKisScanOrders, uKisMapScanViewGiveOuts,
  uKisProjectsJournal;

function TKisMngrFactory.CreateMngr(Ident: TKisMngrs): TkisMngr;
begin
  case Ident of
    kmBanks: Result := TKisBankMngr.Create(AppModule);
    kmContragents: Result := TKisContragentMngr.Create(AppModule);
    kmContrAddresses: Result := TKisContragentAddressMngr.Create(AppModule);
    kmContrDocs: Result := TKisContragentDocumentMngr.Create(AppModule);
    kmContrCertificates: Result := TKisContragentCertificateMngr.Create(AppModule);
    kmOrders: Result := TKisOrderMngr.Create(AppModule);
    kmLetters: Result := TKisLetterMngr.Create(AppModule);
    kmOffices: Result := TKisOfficeMngr.Create(AppModule);
    kmOrgs: Result := TKisOrgMngr.Create(AppModule);
    kmPeople: Result := TKisPeopleMngr.Create(AppModule);
    kmFirms: Result := TKisFirmMngr.Create(AppModule);
    kmOfficeDocs: Result := TKisOfficeDocMngr.Create(AppModule);
    kmOutcomingLetters: Result := TkisOutcomingLetterMngr.Create(AppModule);
    kmStreets : Result := TKisStreetMngr.Create(AppModule);
    kmGeoPunkts : Result := TKisGeoPunktsMngr.Create(AppModule);
    kmDecreeProjects : Result := TKisDecreeProjectMngr.Create(AppModule);
    kmArchivalDocs : Result := TKisArchivalDocsMngr.Create(AppModule);
    kmLicensedOrgs : Result := TKisLicensedOrgMngr.Create(AppModule);
    kmMapCases500 : Result := TKisMap500Mngr.Create(AppModule);
    kmAccounts : Result := TKisAccountsMngr.Create(AppModule);
    kmMapTracings : Result := TKisMapTracingMngr.Create(AppModule);
    kmMapScans : Result := TKisMapScansMngr.Create(AppModule);
    kmScanOrders : Result := TKisScanOrdersMngr.Create(AppModule);
    kmMapScanViewGiveOuts : Result := TKisMapScanViewGiveOutMngr.Create(AppModule);
    kmProjectsJournal : Result := TKisProjectsJournalMngr.Create(AppModule);
  else
    Result := nil;
  end;
end;


end.
