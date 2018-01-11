{
 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.        *
 *                                                                         *
 ***************************************************************************
}

unit uLanguages;

{$mode objfpc}{$H+}

interface

uses
  LResources;

resourcestring

  MIFileCaption = 'File';
  ANewLRSCaption = 'New LRS';
  ANewLRSHint = 'New LRS';
  AOpenLRSCaption = 'Open LRS';
  AOpenLRSHint = 'Open LRS-file';
  ASaveLRSCaption = 'Save LRS';
  ASaveLRSHint = 'Save LRS-file';
  ASaveAsCaption = 'Save as';
  ASaveAsHint = 'Save LRS as...';
  AExitCaption = 'Exit';

  MIResourcesCaption = 'Resources';
  ARenameResourceCaption = 'Rename resource';
  ARenameResourceHint = 'Change name of selected resource';
  AAddFileCaption = 'Add File';
  AAddFileHint = 'Add file to LRS';
  ADelFileCaption = 'Delete File';
  ADelFileHint = 'Delete resource from LRS';
  AExtractResourceCaption = 'Extract Resource';
  AExtractResourceHint = 'Extract resource to binary file';
  AExtractAllResCaption = 'Extract All Res';
  AExtractAllResHint = 'Extract all resources to binary files';
  ASaveResourceCaption = 'Save Resource';
  ASaveResourceHint = 'Save resource to file';
  ASaveAllResCaption = 'Save All Res';
  ASaveAllResHint = 'Save all resources to folder';

  MILanguageCaption = 'Language';

  AViewModeTextCaption = 'Viewer Mode: Text';
  AViewModeTextHint = 'Change mode of viewer to Resource Text mode';
  AViewModeBinCaption = 'Viewer Mode: Bin';
  AViewModeBinHint = 'Change mode of viewer to Binary mode';

  OpenDialogLRSTitle = 'Open LRS File';
  OpenDialogFileTitle = 'Open File';
  SaveDialogResourceTitle = 'Save current resource of lrs';
  SaveDialogLRSTitle = 'Save current LRS file';

  GBoxResourcesListCaption = 'Resources List';
  GBoxResourceViewerCaption = 'Resource Viewer';

  BitBtnApplyCaption = 'Apply';
  BitBtnApplyHint = 'Apply changes to resource';

  Appli_Message0 = 'Unable to convert Delphi form to text: %s!';
  msgError = 'Error';
  msgErrorChange = 'Change error!';
  Appli_Message2 = 'Your lrs file %s was changed! Do you want to save it?';
  msgAttention = 'Attention';
  Appli_Message4 = 'Unable to create file ''';
  Appli_Message5 = 'No resource name';
  Appli_Message6 = 'Unable to read file: %s';
  Appli_Message7 = 'Unable to create temporary file ';
  Appli_Message8 = 'Are you sure you want to delete the resource(s):'#13#10' %s?';
  msgManyParams = 'Too many parameters!';
  msgResourceChanged = 'Resource "%s" was changed. Save it?';

  InputBoxRenameCaption = 'Rename resource';
  InputBoxRenamePrompt = 'Enter a new name for resource "%s"...';

procedure SetLangDir(const LDir: string);
function GetLanguageName(const poFileName: string; var LangName: string): boolean;
procedure LoadLngFilesList;
function LangFile(const sLangName: string): string;
function GetLangNames: string;
function LoadLngFromFile(const sFileName: string): string;

implementation

uses
  Classes, SysUtils, FileUtil, Translations, Gettext, LCLProc;

var
  SListFileName, SListLangNames: TStringList;
  LangDir: string;

procedure SetLangDir(const LDir: string);
begin
  LangDir := LDir;
end;

function GetLanguageName(const poFileName: string; var LangName: string): boolean;
var
  iPos1, iPos2: integer;
  sLine: string;
  f: TextFile;
begin
  Result := False;
  if not FileExists(poFileName) then
    exit;

  Assign(f, poFileName);
  Reset(f);

  // search of 'X-Poedit-Language:' in head section of PO-file
  repeat
    ReadLn(f, sLine);
    iPos1 := Pos('X-Poedit-Language:', sLine);
    if iPos1 <> 0 then
    begin
      iPos1 := Pos(':', sLine) + 1;
      iPos2 := Pos('\n', sLine) - 1;
      LangName := Copy(sLine, iPos1, iPos2 - iPos1 + 1);
      Result := True;
      break;
    end;
  until sLine = '';

  Close(f);
end;

procedure LoadLngFilesList;
var
  fr: TSearchRec;
  sLangName: string;
begin
  SListFileName.Clear;
  SListLangNames.Clear;
  if FindFirst(LangDir + '*.po', faAnyFile, fr) = 0 then
    repeat
      if GetLanguageName(LangDir + fr.Name, sLangName) then
      begin
        SListFileName.Add(fr.Name);
        SListLangNames.Add(sLangName);
      end;
    until FindNext(fr) <> 0;

  FindClose(fr);
end;

function LoadLngFromFile(const sFileName: string): string;
var
  poFileName, sLang, sFallbackLang: string;
begin
  { Localization }
  Result := '';
  poFileName := sFileName;

  if sFileName = '' then
  begin
    poFileName := LangDir + 'LRS_Explorer.%s.po';
    GetLanguageIDs(sLang, sFallbackLang); // Get system language
    Translations.TranslateUnitResourceStrings('uLanguages', poFileName,
      sLang, sFallbacklang);
    if sFallbackLang <> '' then
      Result := Format(poFileName, [sFallbackLang]);
    //if sLang <> '' then Result := Format(poFileName, [sLang]);
  end
  else
  begin
    if not FileExists(LangDir + poFileName) then
    begin
      poFileName := 'LRS_Explorer.%s.po';
      GetLanguageIDs(sLang, sFallbackLang);
      poFileName := Format(poFileName, [sFallbackLang]);
    end;

    if not FileExists(LangDir + poFileName) then
    begin
      poFileName := Format(poFileName, [sLang]);
    end;

    if FileExists(LangDir + poFileName) then
    begin
      //  DebugLn('Loading lng file: ', LangDir+poFileName);
      //      TranslateLCL(poFileName);
      Translations.TranslateUnitResourceStrings('uLanguages', LangDir + poFileName);
      Result := LangDir + poFileName;
    end;
  end;
end;

function LangFile(const sLangName: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to SListLangNames.Count - 1 do
    if SameText(SListLangNames[i], sLangName) then
    begin
      Result := SListFileName[i];
      break;
    end;
end;

function GetLangNames: string;
begin
  Result := SListLangNames.Text;
end;

initialization
  SListFileName := TStringList.Create;
  SListLangNames := TStringList.Create;

finalization
  SListFileName.Free;
  SListLangNames.Free;

end.
