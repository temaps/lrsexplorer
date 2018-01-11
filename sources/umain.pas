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

unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, LCLProc, Forms, Controls, Graphics,
  Dialogs, Menus, ComCtrls, StdCtrls, ExtCtrls, LCLType, ActnList,
  StrUtils, LCLIntf, Buttons;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    AAddFile: TAction;
    ARenameResource: TAction;
    AViewModeBin: TAction;
    AViewModeText: TAction;
    AExtractAllRes: TAction;
    AExtractResource: TAction;
    ASaveAllRes: TAction;
    ASaveLRSAs: TAction;
    ASaveResource: TAction;
    ADelFile: TAction;
    ANewLRS: TAction;
    ASaveLRS: TAction;
    AOpenLRS: TAction;
    AExit: TAction;
    ActionList1: TActionList;
    BitBtnApply: TBitBtn;
    GBoxResourcesList: TGroupBox;
    GBoxResourceViewer: TGroupBox;
    ImageRes: TImage;
    ImageListCommon: TImageList;
    ImageListResType: TImageList;
    MainMenu1: TMainMenu;
    MemoResText: TMemo;
    MIRenameRes2: TMenuItem;
    MIRenameRes: TMenuItem;
    MIBreak5: TMenuItem;
    MIExtract2: TMenuItem;
    MIExtractAll2: TMenuItem;
    MLExtractAll: TMenuItem;
    MLExtract: TMenuItem;
    MIBreak4: TMenuItem;
    MIExtractAllRes: TMenuItem;
    MIExtractResource: TMenuItem;
    MIBreak3: TMenuItem;
    MISaveAllRes: TMenuItem;
    MISaveRes: TMenuItem;
    MIBreak2: TMenuItem;
    MIDelete: TMenuItem;
    MIAdd: TMenuItem;
    MIResources: TMenuItem;
    MISaveAs: TMenuItem;
    MIFile: TMenuItem;
    MISaveRes2: TMenuItem;
    MINew: TMenuItem;
    MIBreak: TMenuItem;
    MIExit: TMenuItem;
    MILanguage: TMenuItem;
    MLDelete: TMenuItem;
    MLAdd: TMenuItem;
    MISave: TMenuItem;
    MIOpen: TMenuItem;
    OpenDialogFile: TOpenDialog;
    OpenDialogLRS: TOpenDialog;
    PMResource: TPopupMenu;
    PMTreeViewRes: TPopupMenu;
    SaveDialogRes: TSaveDialog;
    SaveDialogLRS: TSaveDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    ToolBarMain: TToolBar;
    ToolBarResource: TToolBar;
    ToolBarResList: TToolBar;
    TBExtract: TToolButton;
    TBExtractAll: TToolButton;
    TBSeparator1: TToolButton;
    TBAddFile: TToolButton;
    TBDelFile: TToolButton;
    TBSeparator2: TToolButton;
    TBViewerText: TToolButton;
    TBViewerBin: TToolButton;
    TBSeparator3: TToolButton;
    ToolNewFile: TToolButton;
    TBSave: TToolButton;
    TBOpen: TToolButton;
    TreeViewRes: TTreeView;
    procedure AAddFileExecute(Sender: TObject);
    procedure ADelFileExecute(Sender: TObject);
    procedure AExitExecute(Sender: TObject);
    procedure AExtractAllResExecute(Sender: TObject);
    procedure AExtractResourceExecute(Sender: TObject);
    procedure ANewLRSExecute(Sender: TObject);
    procedure AOpenLRSExecute(Sender: TObject);
    procedure ARenameResourceExecute(Sender: TObject);
    procedure ASaveAllResExecute(Sender: TObject);
    procedure ASaveLRSAsExecute(Sender: TObject);
    procedure ASaveLRSExecute(Sender: TObject);
    procedure ASaveResourceExecute(Sender: TObject);
    procedure AViewModeBinExecute(Sender: TObject);
    procedure AViewModeTextExecute(Sender: TObject);
    procedure BitBtnApplyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoResTextChange(Sender: TObject);
    procedure TreeViewResSelectionChanged(Sender: TObject);
  private
    { Private declarations }
    FOpenedFile: UTF8string;
    FLanguage: string;
    FViewerMode: integer;
    function IndexExt(const Filter: string; const FilterIndex: integer): string;
    procedure SetFormCaption;
    procedure OpenLRSfile(const sFileName: string);
    procedure SaveResourceToFile(const ResName: string; const sFileName: UTF8string);
    function GetResTypeStr(TreeNode: TTreeNode): string;
    function GetResType(TreeNode: TTreeNode): integer;
    function GetResNameStr(TreeNode: TTreeNode): string;
    procedure ChangeLanguage(Sender: TObject);
    procedure CreateLanguageMenuItems;
    procedure ReloadFormControlsCaptions;
    function GetLanguage: string;
    procedure SetLanguage(const AValue: string);
    procedure CheckLangMenuItem(const LangName: string);
    procedure ExtractResourceToFile(const ResName: string; const sFileName: UTF8string);
    procedure SetViewerMode(const AValue: integer);
    procedure ViewResource(const ResName, ResType: string; const Res_ID: integer);
    procedure ViewAsText(const ResName, ResType: string);
    procedure ViewAsPicture(const ResName, Extension: string);
    procedure ViewAsResourceText(const ResName: string);
    procedure ApplyResourceChanges(const ResName, ResType: string);
    procedure ShowHintMessage(Sender: TObject);
  public
    { Public declarations }
    Saving: boolean; // The file is saving ?
    InTextLRS: TStringList;
    ResourceChange: boolean; // Resource was changed?
    FileChange: boolean;     // File was changed?
    //FileChangesCount: Integer; // Count of file changes
    // Info about selected resource
    SelResName, SelResType: string;
    SelRes_ID: integer;

    procedure LoadLRS;
    procedure DisableView;
    property Language: string read GetLanguage write SetLanguage;
    property ViewerMode: integer read FViewerMode write SetViewerMode;
  end;

var
  frmMain: TfrmMain;

const
  ID_FormData = 0;
  ID_Binary = 1;
  ID_Image = 2;

  VWM_ResourceText = 0;
  VWM_Binary = 1;

const
  AppVersion = '1.0.0.2';

implementation

uses
  FileUtil, uResourceWorks, uLanguages;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SetLangDir(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) +
    'languages'));
  LoadLngFilesList;
  CreateLanguageMenuItems;

  // Set system language as default for application
  Language := '';

  ResourceChange := False;
  FileChange := False;

  ViewerMode := VWM_Binary;

  SetFormCaption;
  InTextLRS := TStringList.Create;
  ImageRes.Align := alClient;
  MemoResText.Align := alClient;

  case ParamCount of
    0: ;
    1: OpenLRSfile(ParamStr(1));
    else
      ShowMessage(msgManyParams);
      exit;
  end;

  Application.OnHint := @ShowHintMessage;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  i_mb: integer;
begin
  if FileChange then
  begin
    i_mb := Application.MessageBox(PChar(Format(Appli_Message2, [FOpenedFile])),
      PChar(msgAttention), MB_YESNOCANCEL);
    case i_mb of
      idYes: ASaveLRSExecute(nil);
      idCancel:
      begin
        CanClose := False;
        exit;
      end;
    end;

    CanClose := True;
  end;
end;

procedure TfrmMain.AExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.AExtractResourceExecute(Sender: TObject);
// Extract Resource to binary file
var
  tree: TTreeNode;
  ResName, ResType, sTemp, sFileName, sDialogExt: string;
  ImageId: integer;
begin
  tree := TreeViewRes.Selected;
  if tree <> nil then
  begin
    ResName := GetResNameStr(tree);
    ResType := GetResTypeStr(tree);

    ImageId := GetResType(tree);
    case ImageId of
      ID_FormData: sTemp := 'Form Data (*.%s)|*.%s';
      ID_Image: sTemp := 'Image (*.%s)|*.%s';
      else
        sTemp := 'Unknown (*.%s)|*.%s';
    end;

    SaveDialogRes.Filter :=
      Format(sTemp, [ResType, ResType]) + '|All Files (*.*)|*.*';

    SaveDialogRes.FileName := ResName;
    SaveDialogRes.FilterIndex := 1;
    if SaveDialogRes.Execute then
    begin
      sFileName := SaveDialogRes.FileName;
      sDialogExt := IndexExt(SaveDialogRes.Filter, SaveDialogRes.FilterIndex);
      if sDialogExt <> '' then
        sFileName := ChangeFileExt(sFileName, sDialogExt);

      ExtractResourceToFile(ResName, sFileName);
    end;
  end;
end;

procedure TfrmMain.AExtractAllResExecute(Sender: TObject);
// Extract All Resources to binary form to folder
var
  i: integer;
  ResName, ResType, sFileName: string;
begin
  if TreeViewRes.Items.Count > 0 then
  begin
    SelectDirectoryDialog1.InitialDir := ExtractFileDir(FOpenedFile);
    if SelectDirectoryDialog1.Execute then
      for i := 0 to TreeViewRes.Items.Count - 1 do
      begin
        ResName := GetResNameStr(TreeViewRes.Items[i]);
        ResType := GetResTypeStr(TreeViewRes.Items[i]);
        //Res_ID  := GetResType(TreeViewRes.Items[i]);

        SFileName := IncludeTrailingPathDelimiter(SelectDirectoryDialog1.FileName) +
          ResName + '.' + ResType;

        ExtractResourceToFile(ResName, sFileName);
      end;
  end;
end;

procedure TfrmMain.AAddFileExecute(Sender: TObject);
begin
  if OpenDialogFile.Execute then
  begin
    AddFilesToLRS(OpenDialogFile.Files, InTextLRS);
    DisableView;
    LoadLRS;
    FileChange := True;
  end;
end;

procedure TfrmMain.ADelFileExecute(Sender: TObject);
var
  tree: TTreeNode;
  ResourceName: string;
  SList: TStringList;
begin
  //important! Don't use "TreeViewRes.Selected;" below with tree.GetNextMultiSelected;
  tree := TreeViewRes.GetFirstMultiSelected;

  if tree <> nil then
  begin
    SList := TStringList.Create;

    // completing list of res. names to deleting
    while tree <> nil do
    begin
      ResourceName := GetResNameStr(tree);
      SList.Add(ResourceName);
      tree := tree.GetNextMultiSelected;
    end;

    if Application.MessageBox(PChar(Format(Appli_Message8, [TrimRight(SList.Text)])),
      PChar(msgAttention), MB_YESNO) = idYes then
    begin
      DeleteResources(SList, InTextLRS);

      DisableView;
      LoadLRS;
      FileChange := True;
    end;

    SList.Free;
  end;
end;

procedure TfrmMain.ANewLRSExecute(Sender: TObject);
var
  i_mb: integer;
begin
  if FileChange then
  begin
    i_mb := Application.MessageBox(PChar(Format(Appli_Message2, [FOpenedFile])),
      PChar(msgAttention), MB_YESNOCANCEL);
    case i_mb of
      idYes: ASaveLRSExecute(nil);
      idCancel: exit;
    end;
  end;

  InTextLRS.Clear;
  TreeViewRes.Items.Clear;
  DisableView;
  FileChange := False;
  FOpenedFile := '';
  SetFormCaption;
end;

procedure TfrmMain.AOpenLRSExecute(Sender: TObject);
var
  i_mb: integer;
begin
  if FileChange then
  begin
    i_mb := Application.MessageBox(PChar(Appli_Message2), PChar(msgAttention),
      MB_YESNOCANCEL);
    case i_mb of
      idYes: ASaveLRSExecute(nil);
      idCancel: exit;
    end;
  end;

  if OpenDialogLRS.Execute then
    OpenLRSfile(OpenDialogLRS.FileName);
end;

procedure TfrmMain.ARenameResourceExecute(Sender: TObject);
var
  tree: TTreeNode;
  OldName, NewName: string;
  bInpQry: boolean;
begin
  // Rename 1 selected resource
  tree := TreeViewRes.Selected;
  if tree <> nil then
  begin
    OldName := GetResNameStr(tree);
    NewName := OldName;
    bInpQry := InputQuery(InputBoxRenameCaption,
      Format(InputBoxRenamePrompt, [OldName]), NewName);
    if bInpQry and (NewName <> '') and (NewName <> OldName) then
    begin
      RenameResource(OldName, NewName, InTextLRS);
      LoadLRS;
      tree.Selected := True;
      FileChange := True;
    end;
  end;
end;

procedure TfrmMain.ASaveLRSAsExecute(Sender: TObject);
var
  sFileName, sDialogExt: string;
begin
  // Save as (Main Menu)
  if SaveDialogLRS.Execute then
  begin
    sFileName := SaveDialogLRS.FileName;
    sDialogExt := IndexExt(SaveDialogLRS.Filter, SaveDialogLRS.FilterIndex);
    if sDialogExt <> '' then
      sFileName := ChangeFileExt(sFileName, sDialogExt);

    InTextLRS.SaveToFile(sFileName);
    FileChange := False;
    FOpenedFile := sFileName;
    SetFormCaption;
  end;
end;

procedure TfrmMain.ASaveLRSExecute(Sender: TObject);
begin
  if FileExists(FOpenedFile) then
  begin
    InTextLRS.SaveToFile(FOpenedFile);
    FileChange := False;
  end
  else
  begin
    ASaveLRSAsExecute(Sender);
  end;
end;

procedure TfrmMain.ASaveResourceExecute(Sender: TObject);
// Save selected resource into separate file
var
  tree: TTreeNode;
  ResName, ResType, sTemp, sFileName, sDialogExt: string;
begin
  tree := TreeViewRes.Selected;
  if tree <> nil then
  begin
    ResName := GetResNameStr(tree);
    ResType := 'LRS';

    sTemp := Format('Lazarus Resource (*.%s)|*.%s', [ResType, ResType]);

    SaveDialogRes.Filter := sTemp + '|All Files (*.*)|*.*';

    SaveDialogRes.FileName := ResName;
    SaveDialogRes.FilterIndex := 1;
    if SaveDialogRes.Execute then
    begin
      sFileName := SaveDialogRes.FileName;
      sDialogExt := IndexExt(SaveDialogRes.Filter, SaveDialogRes.FilterIndex);
      ;

      if sDialogExt <> '' then
        sFileName := ChangeFileExt(sFileName, sDialogExt);

      SaveResourceToFile(ResName, sFileName);
    end;
  end;
end;

procedure TfrmMain.AViewModeBinExecute(Sender: TObject);
begin
  ViewerMode := VWM_Binary;
end;

procedure TfrmMain.AViewModeTextExecute(Sender: TObject);
begin
  ViewerMode := VWM_ResourceText;
end;

procedure TfrmMain.BitBtnApplyClick(Sender: TObject);
var
  MemStr: TMemoryStream;
  hind: integer;
  tempLRS: TStringList;
begin
  tempLRS := TStringList.Create;
  MemStr := TMemoryStream.Create;
  try
    tempLRS.Text := InTextLRS.Text;
    ReplaceResource(SelResName, MemoResText.Lines, tempLRS);
    hind := FindResourceInLRS(SelResName, tempLRS);
    MemStr := ExtractResource(hind, tempLRS);
    if MemStr.Size > 0 then
    begin
      // Apply changes to selected resource
      ApplyResourceChanges(SelResName, SelResType);
      // Return focus to TreeViewRes
      TreeViewRes.SetFocus;
    end
    else
      ShowMessage(msgErrorChange);
  finally
    tempLRS.Free;
    MemStr.Free;
  end;
end;

procedure TfrmMain.ASaveAllResExecute(Sender: TObject);
var
  i: integer;
  ResName, ResType, sFileName: string;
begin
  // Save all resources to folder
  if TreeViewRes.Items.Count > 0 then
  begin
    SelectDirectoryDialog1.InitialDir := ExtractFileDir(FOpenedFile);
    if SelectDirectoryDialog1.Execute then
      for i := 0 to TreeViewRes.Items.Count - 1 do
      begin
        ResName := GetResNameStr(TreeViewRes.Items[i]);
        ResType := GetResTypeStr(TreeViewRes.Items[i]);
        //Res_ID  := GetResType(TreeViewRes.Items[i]);

        sFileName := IncludeTrailingPathDelimiter(SelectDirectoryDialog1.FileName) +
          ResName + '.' + ResType;
        SaveResourceToFile(ResName, sFileName);
      end;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  InTextLRS.Free;
end;

procedure TfrmMain.MemoResTextChange(Sender: TObject);
begin
  ResourceChange := True;
  BitBtnApply.Enabled := ResourceChange;
end;

procedure TfrmMain.ApplyResourceChanges(const ResName, ResType: string);
var
  ResMemStream, BinMemStream: TMemoryStream;
  SList: TStringList;
begin
  case ViewerMode of
    VWM_ResourceText:
    begin
      ReplaceResource(ResName, MemoResText.Lines, InTextLRS);
    end;

    VWM_Binary:
    begin
      BinMemStream := TMemoryStream.Create;
      ResMemStream := TMemoryStream.Create;

      MemoResText.Lines.SaveToStream(BinMemStream);
      BinMemStream.Position := 0;

      BinaryToLazarusResourceCode(BinMemStream, ResMemStream, ResName, ResType);
      BinMemStream.Free;

      SList := TStringList.Create;
      ResMemStream.Position := 0;
      SList.LoadFromStream(ResMemStream);
      ResMemStream.Free;

      ReplaceResource(ResName, SList, InTextLRS);

      SList.Free;
    end;
  end;

  ResourceChange := False;
  BitBtnApply.Enabled := ResourceChange;
  FileChange := True;
end;

procedure TfrmMain.ShowHintMessage(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := Application.Hint;
end;

procedure TfrmMain.TreeViewResSelectionChanged(Sender: TObject);
var
  tree: TTreeNode;
begin
  tree := TreeViewRes.Selected;
  if tree <> nil then
  begin
    if ResourceChange then
    begin
      if Application.MessageBox(PChar(Format(msgResourceChanged, [SelResName])),
        PChar(msgAttention), MB_YESNO) = idYes then
      begin
        ApplyResourceChanges(SelResName, SelResType);
      end
      else
      begin
        ResourceChange := False;
        BitBtnApply.Enabled := ResourceChange;
      end;
    end;

    SelResName := GetResNameStr(tree);
    SelResType := GetResTypeStr(tree);
    SelRes_ID := GetResType(tree);

    ViewResource(SelResName, SelResType, SelRes_ID);
  end;
end;

function TfrmMain.IndexExt(const Filter: string; const FilterIndex: integer): string;
  // Get Extension from Filter using FilterIndex
const
  Sep = '|';//Separator character
var
  i, SepCount, iStart: integer;
  sMask: string;
begin
  Result := '';
  SepCount := 0;
  iStart := 0;
  sMask := '';
  for i := 1 to length(Filter) do
    if (Filter[i] = Sep) or (i = length(Filter)) then
    begin
      SepCount := SepCount + 1;
      if iStart = 0 then
      begin
        if SepCount = 2 * FilterIndex - 1 then
          iStart := i;
      end
      else
      begin
        sMask := Copy(Filter, iStart + 1, i - iStart - 1 + Ord(i = length(Filter)));
        break;
      end;
    end;

  if sMask <> '' then
    for i := length(sMask) downto 1 do
      if sMask[i] = '.' then
      begin
        Result := Copy(sMask, i, length(sMask));
        if Result = '.*' then
          Result := '';
        break;
      end;
end;

procedure TfrmMain.LoadLRS;
const
  Pattern = 'LazarusResources.Add(''';
var
  i, j, k: integer;
  texte, NameResource, TypeResource: string;
  tree: TTreeNode;
begin
  TreeViewRes.Items.Clear;
  for i := 0 to InTextLRS.Count - 1 do
  begin
    texte := InTextLRS.Strings[i];
    j := PosEx(Pattern, texte); // default offset = 1
    if j > 0 then
    begin
      j := PosEx('''', texte, length(Pattern) + 1);
      NameResource := Copy(texte, length(Pattern) + 1, j - length(Pattern) - 1);

      j := PosEx('''', texte, j + 1);
      k := PosEx('''', texte, j + 1);
      TypeResource := Copy(texte, j + 1, k - j - 1);

      tree := TreeViewRes.Items.Add(nil, NameResource + '(' + TypeResource + ')');
      texte := UpCase(TypeResource);
      if (texte = 'XPM') or (texte = 'BMP') or (texte = 'JPG') or
        (texte = 'JPEG') or (texte = 'PNG') or (texte = 'ICO') or (texte = 'ICON') then
      begin
        tree.ImageIndex := ID_Image;
        tree.SelectedIndex := tree.ImageIndex;
      end
      else
      if texte = 'FORMDATA' then
      begin
        tree.ImageIndex := ID_FormData;
        tree.SelectedIndex := tree.ImageIndex;
      end
      else
      begin
        tree.ImageIndex := ID_Binary;
        tree.SelectedIndex := tree.ImageIndex;
      end;
    end;
  end;
end;

procedure TfrmMain.DisableView;
begin
  MemoResText.Visible := False;
  ImageRes.Visible := False;
end;

procedure TfrmMain.SetFormCaption;
var
  sOpenedFile: string;
begin
  sOpenedFile := ExtractFileName(FOpenedFile);
  Caption := Application.Title + ' ' + AppVersion;
  if sOpenedFile <> '' then
    Caption := Caption + ' - ' + sOpenedFile;
end;

function TfrmMain.GetLanguage: string;
begin
  Result := FLanguage;
end;

procedure TfrmMain.OpenLRSfile(const sFileName: string);
begin
  DisableView;
  InTextLRS.LoadFromFile(sFileName);
  LoadLRS;
  FileChange := False;
  FOpenedFile := sFileName;// Type of sFileName = UTF8String
  SetFormCaption;
  OpenDialogLRS.FileName := FOpenedFile;

  if TreeViewRes.Items.Count > 0 then
    TreeViewRes.Items[0].Selected := True;
end;

procedure TfrmMain.SaveResourceToFile(const ResName: string;
  const sFileName: UTF8string);
// Save 1 resource in separate file sFileName
var
  SList: TStringList;
  hind, endRes, i: integer;
begin
  SList := TStringList.Create;

  hind := FindResourceInLRS(ResName, InTextLRS);
  endRes := FindEndResourceInLRS(hind, InTextLRS);

  for i := hind to endRes do
    SList.Add(InTextLRS[i]);

  SList.SaveToFile(sFileName);

  SList.Free;
end;

function TfrmMain.GetResTypeStr(TreeNode: TTreeNode): string;
var
  i, j: integer;
begin
  i := PosEx('(', TreeNode.Text);
  j := PosEx(')', TreeNode.Text, i + 1);

  Result := Copy(TreeNode.Text, i + 1, j - i - 1);
end;

function TfrmMain.GetResType(TreeNode: TTreeNode): integer;
begin
  Result := TreeNode.ImageIndex;
end;

function TfrmMain.GetResNameStr(TreeNode: TTreeNode): string;
begin
  Result := Copy(TreeNode.Text, 1, PosEx('(', TreeNode.Text) - 1);
end;

procedure TfrmMain.ChangeLanguage(Sender: TObject);
begin
  //  debugln('TfrmMain.ChangeLanguage ', (Sender as TMenuItem).Caption);

  Language := (Sender as TMenuItem).Caption;
end;

procedure TfrmMain.CreateLanguageMenuItems;

  procedure AddMI(const strMenu: string);
  var
    MI: TMenuItem;
  begin
    MI := TMenuItem.Create(MILanguage);

    MI.Caption := strMenu;
    MI.OnClick := @ChangeLanguage;

    MILanguage.Add(MI);
    //    MI.Free;
  end;

var
  SList: TStringList;
  i: integer;
begin
  MILanguage.Clear;

  SList := TStringList.Create;
  SList.Text := GetLangNames;

  for i := 0 to SList.Count - 1 do
    AddMI(SList[i]);

  SList.Free;
end;

procedure TfrmMain.ReloadFormControlsCaptions;
begin
  MIFile.Caption := MIFileCaption;
  ANewLRS.Caption := ANewLRSCaption;
  ANewLRS.Hint := ANewLRSHint;
  AOpenLRS.Caption := AOpenLRSCaption;
  AOpenLRS.Hint := AOpenLRSHint;
  ASaveLRS.Caption := ASaveLRSCaption;
  ASaveLRS.Hint := ASaveLRSHint;
  ASaveLRSAs.Caption := ASaveAsCaption;
  ASaveLRSAs.Hint := ASaveAsHint;
  AExit.Caption := AExitCaption;

  MIResources.Caption := MIResourcesCaption;
  ARenameResource.Caption := ARenameResourceCaption;
  ARenameResource.Hint := ARenameResourceHint;
  AAddFile.Caption := AAddFileCaption;
  AAddFile.Hint := AAddFileHint;
  ADelFile.Caption := ADelFileCaption;
  ADelFile.Hint := ADelFileHint;
  AExtractResource.Caption := AExtractResourceCaption;
  AExtractResource.Hint := AExtractResourceHint;
  AExtractAllRes.Caption := AExtractAllResCaption;
  AExtractAllRes.Hint := AExtractAllResHint;
  ASaveResource.Caption := ASaveResourceCaption;
  ASaveResource.Hint := ASaveResourceHint;
  ASaveAllRes.Caption := ASaveAllResCaption;
  ASaveAllRes.Hint := ASaveAllResHint;

  MILanguage.Caption := MILanguageCaption;

  AViewModeText.Caption := AViewModeTextCaption;
  AViewModeText.Hint := AViewModeTextHint;
  AViewModeBin.Caption := AViewModeBinCaption;
  AViewModeBin.Hint := AViewModeBinHint;

  OpenDialogLRS.Title := OpenDialogLRSTitle;
  OpenDialogFile.Title := OpenDialogFileTitle;
  SaveDialogRes.Title := SaveDialogResourceTitle;
  SaveDialogLRS.Title := SaveDialogLRSTitle;

  GBoxResourcesList.Caption := GBoxResourcesListCaption;
  GBoxResourceViewer.Caption := GBoxResourceViewerCaption;

  BitBtnApply.Caption := BitBtnApplyCaption;
  BitBtnApply.Hint := BitBtnApplyHint;
end;

procedure TfrmMain.SetLanguage(const AValue: string);
var
  LFile: string;
begin
  LFile := LangFile(AValue);
  if (LFile <> '') or (AValue = '') then
  begin
    LFile := LoadLngFromFile(LFile);

    if GetLanguageName(LFile, FLanguage) then
    begin
      CheckLangMenuItem(FLanguage);
      ReloadFormControlsCaptions;
    end
    else
    begin //If There is no lang file for some language - use default
      FLanguage := ' English'; // default
      CheckLangMenuItem(FLanguage);
    end;
  end
  else
  begin
    // Error - language file "%s" not found!
  end;
end;

procedure TfrmMain.CheckLangMenuItem(const LangName: string);
var
  i: integer;
begin
  for i := 0 to MILanguage.Count - 1 do
    if MILanguage.Items[i].Caption = LangName then
      MILanguage.Items[i].Checked := True
    else
      MILanguage.Items[i].Checked := False;
end;

procedure TfrmMain.ExtractResourceToFile(const ResName: string;
  const sFileName: UTF8string);
var
  MemStr: TMemoryStream;
  hind: integer;
begin
  MemStr := TMemoryStream.Create;
  try
    hind := FindResourceInLRS(ResName, InTextLRS);
    MemStr := ExtractResource(hind, InTextLRS);

    MemStr.SaveToFile(sFileName);
  finally
    MemStr.Free;
  end;
end;

procedure TfrmMain.SetViewerMode(const AValue: integer);
begin
  if (AValue in [VWM_ResourceText, VWM_Binary]) and (FViewerMode <> AValue) then
  begin
    FViewerMode := AValue;
    case FViewerMode of
      VWM_ResourceText:
        TBViewerText.Down := True;

      VWM_Binary:
        TBViewerBin.Down := True;
    end;//}

    TreeViewResSelectionChanged(nil);
  end;
end;

procedure TfrmMain.ViewAsPicture(const ResName, Extension: string);
var
  HeaderIndex: integer;
  Memory: TMemoryStream;
begin
  DisableView;
  HeaderIndex := FindResourceInLRS(ResName, InTextLRS);
  try
    Memory := TMemoryStream.Create;
    Memory := ExtractResource(HeaderIndex, InTextLRS);
    try
      ImageRes.Visible := True;
      Memory.Position := 0;
      ImageRes.Picture.LoadFromStreamWithFileExt(Memory, Extension);
    except
      ImageRes.Visible := False;
      // error - can't open resource as picture
    end;
  finally
    ResourceChange := False;
    Memory.Free;
  end;
end;

procedure TfrmMain.ViewAsResourceText(const ResName: string);
var
  SList: TStringList;
  hind, endRes, i: integer;
begin
  DisableView;
  MemoResText.Clear;

  SList := TStringList.Create;

  hind := FindResourceInLRS(ResName, InTextLRS);
  endRes := FindEndResourceInLRS(hind, InTextLRS);

  for i := hind to endRes do
    SList.Add(InTextLRS[i]);

  MemoResText.Lines := SList;

  if MemoResText.Lines.Count > 0 then
    MemoResText.Visible := True;
  ResourceChange := False;

  SList.Free;
end;

procedure TfrmMain.ViewAsText(const ResName, ResType: string);
var
  MemStr: TMemoryStream;
  hind: integer;
  s: string;
begin
  DisableView;
  MemStr := TMemoryStream.Create;
  try
    hind := FindResourceInLRS(ResName, InTextLRS);
    MemStr := ExtractResource(hind, InTextLRS);

    MemStr.Position := 0;

    Setlength(s, MemStr.Size);
    MemStr.Read(s[1], MemStr.Size);

    MemoResText.Lines.Text := s;

    if MemoResText.Lines.Count > 0 then
      MemoResText.Visible := True;

    ResourceChange := False;
  finally
    MemStr.Free;
  end;
end;

procedure TfrmMain.ViewResource(const ResName, ResType: string; const Res_ID: integer);
begin
  case ViewerMode of
    VWM_ResourceText: ViewAsResourceText(ResName);

    VWM_Binary:
      case Res_ID of
        ID_Image: ViewAsPicture(ResName, ResType);
        else
          ViewAsText(ResName, ResType);
      end;
  end;
end;

initialization
  {$I umain.lrs}

end.

