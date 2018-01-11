program LRS_Explorer;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  { you can add units after this }
  uMain,
  uoptions;

{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

{$R *.res}

begin
  Application.Title := 'LRS Explorer';
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.


