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

unit uoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

procedure LoadOptions;
procedure SaveOptions;

implementation

uses
  FileUtil, uMain;

procedure LoadOptions;
var
  Ini: Tinifile;
begin
  if not FileExists(ChangeFileExt(ParamStr(0), '.ini')) then
    Ini := TIniFile.Create('')
  else
    Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));

  try
    with frmMain do
    begin
      Top := Ini.ReadInteger(Name, 'Top', 10);
      Left := Ini.ReadInteger(Name, 'Left', 10);
      Width := Ini.ReadInteger(Name, 'Width', 986);
      Height := Ini.ReadInteger(Name, 'Height', 782);
      Language := Ini.ReadString(Name, 'Language', '');
    end;

  finally
    Ini.Free;
  end;
end;

procedure SaveOptions;
var
  Ini: Tinifile;
begin
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    with frmMain do
    begin
      Ini.WriteInteger(Name, 'Top', Top);
      Ini.WriteInteger(Name, 'Left', Left);
      Ini.WriteInteger(Name, 'Width', Width);
      Ini.WriteInteger(Name, 'Height', Height);
      Ini.WriteString(Name, 'Language', Language);
    end;

  finally
    Ini.Free;
  end;
end;

end.

