unit uMStClassesProjectsIntf;

interface

uses
  Classes,
  uMStClassesProjects,
  uMStKernelTypes;

type
  ImstProjects = interface
    ['{3E45B575-FBBA-43A0-A7D0-F202D2B8EB63}']
    function GetProject(PrjId: Integer; LoadIsNotExtsts: Boolean): TmstProject;
    procedure LoadProjects(const aLeft, aTop, aRight, aBottom: Double; CallBack: TProgressEvent2);
    procedure LoadProjectsByField(const FieldName, Text: String; OnPrjLoaded: TNotifyEvent);
  end;

implementation

end.
