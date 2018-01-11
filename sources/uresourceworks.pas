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

unit uResourceWorks;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Dialogs, FileUtil, LCLProc;

function FindResourceInLRS(const ResourceName: string; const List: TStrings): integer;
function FindEndResourceInLRS(const Start: integer; const List: TStrings): integer;
function ExtractResource(HeaderIndex: integer; LRS: TStrings): TMemoryStream;
function StreamIsFormInTextFormat(Stream: TMemoryStream): boolean;
function StreamIsFormInFCLFormat(Stream: TMemoryStream): boolean;
procedure ConvertFormToText(Stream: TMemoryStream);
procedure AddFilesToLRS(Files: TStrings; var InTextLRS: TStringList);
procedure DeleteResource(const ResName: string; var InTextLRS: TStringList);
procedure CorrectXPM(BinStream: TStream);
procedure DeleteResources(ResNames: TStringList; var InTextLRS: TStringList);
procedure RenameResource(const OldName, NewName: string; var InTextLRS: TStringList);
procedure ReplaceResource(const ResName: string; const NewResList: TStrings;
  var InTextLRS: TStringList);

implementation

uses
  uLanguages, StrUtils;

function FindResourceInLRS(const ResourceName: string; const List: TStrings): integer;
{Return the string number of begining resource "ResourceName" in List.
If resource "ResourceName" not found then return -1.}
const
  PatternBeginRes = 'LazarusResources.Add(''';
var
  s: string;
  i: integer;
begin
  Result := -1;
  if ResourceName <> '' then
  begin
    s := PatternBeginRes + ResourceName + ''',';
    for i := 0 to List.Count - 1 do
      if Pos(s, List[i]) = 1 then
      begin
        Result := i;
        break;
      end;
  end;
end;

function FindEndResourceInLRS(const Start: integer; const List: TStrings): integer;
{Return the string number of ending resource in List.
Start - string number of begining resource in List.
If end of resource "ResourceName" not found then return -1.}
const
  PatternEndRes = ']);';
var
  i: integer;
begin
  Result := -1;
  if (Start >= 0) and (Start <= List.Count - 1) then
    for i := Start + 1 to List.Count - 1 do
      if List[i] = PatternEndRes then
      begin
        Result := i;
        break;
      end;
end;

function ExtractResource(HeaderIndex: integer; LRS: TStrings): TMemoryStream;
{Copying resource with HeaderIndex from LRS liststring to
a memory stream.}
var
  i, StartPos: longint;
  p, CharID: integer;
  Line: string;
  c: char;
begin
  Result := TMemoryStream.Create;
  i := HeaderIndex + 1;
  while i < LRS.Count do
  begin
    Line := LRS[i];
    if (Line <> '') and (Line[1] = ']') then
      exit;// found the end of this resource
    p := 1;
    while p <= length(Line) do
    begin
      case Line[p] of
        '''':
          // string constant
        begin
          Inc(p);
          while p <= length(Line) do
          begin
            if Line[p] <> '''' then
            begin
              // read normal characters
              StartPos := p;
              while (p <= length(Line)) and (Line[p] <> '''') do
                Inc(p);
              Result.Write(Line[StartPos], p - StartPos);
            end
            else if (p < length(Line)) and (Line[p + 1] = '''') then
            begin
              // read '
              Result.Write(Line[p], 1);
              Inc(p, 2);
            end
            else
            begin
              // end of string constant found
              Inc(p);
              break;
            end;
          end;
        end;
        '#':
          // special character
        begin
          Inc(p);
          CharID := 0;
          while (p <= length(Line)) and (Line[p] in ['0'..'9']) do
          begin
            CharID := CharID * 10 + Ord(Line[p]) - Ord('0');
            Inc(p);
          end;
          c := chr(CharID);
          Result.Write(c, 1);
        end;
        else
          Inc(p);
      end;
    end;
    Inc(i);
  end;
end;

function StreamIsFormInTextFormat(Stream: TMemoryStream): boolean;
const
  FormTextStart = 'object ';
var
  s: string;
  OldPos: integer;
begin
  SetLength(s, length(FormTextStart));
  OldPos := Stream.Position;
  Stream.Read(s[1], length(s));
  Result := AnsiCompareText(s, FormTextStart) = 0;
  Stream.Position := OldPos;
end;

function StreamIsFormInFCLFormat(Stream: TMemoryStream): boolean;
const
  FormFCLStart = 'TPF0';
var
  s: string;
  OldPos: integer;
begin
  SetLength(s, length(FormFCLStart));
  OldPos := Stream.Position;
  Stream.Read(s[1], length(s));
  Result := (s = FormFCLStart);
  Stream.Position := OldPos;
end;

procedure ConvertFormToText(Stream: TMemoryStream);
var
  TextStream: TMemoryStream;
begin
  try
    TextStream := TMemoryStream.Create;
    FormDataToText(Stream, TextStream);
    TextStream.Position := 0;
    Stream.Clear;
    Stream.CopyFrom(TextStream, TextStream.Size);
    Stream.Position := 0;
  except
    on E: Exception do
    begin
      //Application.MessageBox(PChar(Appli_Message0+E.Message), PChar(Appli_Message1),0);
      ShowMessage(Format(Appli_Message0, [E.Message]));
    end;
  end;
end;

procedure AddFilesToLRS(Files: TStrings; var InTextLRS: TStringList);
var
  FileTemp: TStringList;
  BinFilename, BinExt, ResourceName, ResourceType: string;
  a: integer;
  BinFileStream: TFileStream;
  ResMemStream, BinMemStream: TMemoryStream;
begin
  ResMemStream := TMemoryStream.Create;
  try
    for a := 0 to Files.Count - 1 do
    begin
      BinFilename := Files.Strings[a];
      try
        BinFilename := BinFilename;
        BinFileStream := TFileStream.Create(BinFilename, fmOpenRead);
        BinMemStream := TMemoryStream.Create;
        try
          BinMemStream.CopyFrom(BinFileStream, BinFileStream.Size);
          BinMemStream.Position := 0;
          BinExt := UpCase(ExtractFileExt(BinFilename));
          if (BinExt = '.LFM') or (BinExt = '.DFM') or (BinExt = '.XFM') then
          begin
            ResourceType := 'FORMDATA';
            ConvertFormToText(BinMemStream);
            ResourceName := FindLFMClassName(BinMemStream);
            if ResourceName = '' then
            begin
              ShowMessage(Appli_Message5);
              exit;
            end;
            LFMtoLRSstream(BinMemStream, ResMemStream);
          end
          else
          begin
            ResourceType := Copy(BinExt, 2, length(BinExt) - 1);
            ResourceName := ExtractFileName(BinFilename);
            ResourceName := Copy(ResourceName, 1, length(ResourceName) - length(BinExt));
            if ResourceName = '' then
            begin
              ShowMessage(Appli_Message5);
              exit;
            end;
            // correct, just for XPM's pictures
            if BinExt = '.XPM' then
              CorrectXPM(BinMemStream);

            BinaryToLazarusResourceCode(BinMemStream, ResMemStream,
              ResourceName, ResourceType);
          end;
        finally
          BinFileStream.Free;
          BinMemStream.Free;
        end;
      except
        ShowMessage(Format(Appli_Message6, [BinFilename]));
        exit;
      end;
    end;

    ResMemStream.Position := 0;
    try
      FileTemp := TStringList.Create;
      try
        FileTemp.LoadFromStream(ResMemStream);
        for a := 0 to FileTemp.Count - 1 do
          InTextLRS.Add(FileTemp.Strings[a]);

      finally
        FileTemp.Free;
      end;
    except
      ShowMessage(Appli_Message7);
    end;

  finally
    ResMemStream.Free;
  end;
end;

procedure DeleteResource(const ResName: string; var InTextLRS: TStringList);
var
  i, iStart, iEnd: integer;
begin
  iStart := FindResourceInLRS(ResName, InTextLRS);
  iEnd := FindEndResourceInLRS(iStart, InTextLRS);
  if iEnd <> -1 then
    for i := iEnd downto iStart do
      InTextLRS.Delete(i)
  else
  begin
    // Error - resource "ResName" not found!
  end;
end;

procedure CorrectXPM(BinStream: TStream);
var
  SList: TStringList;
  i, j: integer;
begin
  SList := TStringList.Create;

  SList.LoadFromStream(BinStream);

  for i := 0 to SList.Count - 1 do
  begin
    j := Pos('static char', SList.Strings[i]);
    if j <> 0 then
    begin
      // correct file description to this form
      SList.Strings[i] := 'static char *graphic[] = {';
      break;
    end;
  end;

  BinStream.Position := 0;
  BinStream.Size := 0; // I used it like .Clear method
  BinStream.Write(SList.Text[1], length(SList.Text));
  SList.Free;

  BinStream.Position := 0;
end;

procedure DeleteResources(ResNames: TStringList; var InTextLRS: TStringList);
var
  i: integer;
begin
  if ResNames.Count > 0 then
    for i := 0 to ResNames.Count - 1 do
      DeleteResource(ResNames[i], InTextLRS);
end;

procedure RenameResource(const OldName, NewName: string; var InTextLRS: TStringList);
const
  Pattern = 'LazarusResources.Add(''';
var
  hind, iPos: integer;
  s: string;
begin
  // Rename resource in InTextLRS stringlist
  hind := FindResourceInLRS(OldName, InTextLRS);
  if hind <> -1 then
  begin
    iPos := length(Pattern);
    iPos := PosEx(OldName, InTextLRS[hind], iPos + 1);
    if iPos <> 0 then
    begin
      s := InTextLRS[hind];
      Delete(s, iPos, length(OldName));
      Insert(NewName, s, iPos);
      InTextLRS[hind] := s;
    end;
  end
  else
  begin
    // Error - Resource OldName not found!
  end;
end;

procedure ReplaceResource(const ResName: string; const NewResList: TStrings;
  var InTextLRS: TStringList);
var
  i, iStartRes, iEndRes: integer;
begin
  iStartRes := FindResourceInLRS(ResName, InTextLRS);
  iEndRes := FindEndResourceInLRS(iStartRes, InTextLRS);
  if iEndRes <> -1 then
  begin
    // Delete resource ResName
    for i := iEndRes downto iStartRes do
      InTextLRS.Delete(i);

    // Insert resource to start position of ResName
    for i := 0 to NewResList.Count - 1 do
      InTextLRS.Insert(iStartRes + i, NewResList[i]);
  end
  else
  begin
    // Error - resource "ResName" not found!
  end;
end;

end.
