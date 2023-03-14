unit MainUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TMainForm = class(TForm)
    StateSwitch: TSwitch;
    Label2: TLabel;
    MainLayout: TLayout;
    MainRectangle: TRectangle;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure StateSwitchSwitch(Sender: TObject);
    procedure StateSwitchClick(Sender: TObject);
  private
    { Private declarations }
    function GetState: Boolean;
    procedure SetState(AState: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  Winapi.ShellAPI, Winapi.ShlObj, System.Win.Registry;

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Label2.StyledSettings := [TStyledSetting.Family, TStyledSetting.Size, TStyledSetting.Style];
  StateSwitch.IsChecked := GetState;
end;

function TMainForm.GetState: Boolean;
begin
  Result := False;
  with TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY) do
  try
    if KeyExists('Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32') then
      Result := True;
  finally
    CloseKey;
    Free;
  end;
end;

procedure TMainForm.SetState(AState: Boolean);
var
  LItem: PITEMIDLIST;
  LDir: array[0..1023] of Char;
begin
  with TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY) do
  try
    RootKey := HKEY_CURRENT_USER;
    if AState then
    begin
      if KeyExists('Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32') then
        Exit
      else
      begin
        if not OpenKey('Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32', True) then
          Exit;
        WriteString('', '');
        SHGetSpecialFolderLocation(0, CSIDL_WINDOWS, LItem);
        SHGetPathFromIDList(LItem, LDir);
        Shellexecute(0, nil, 'cmd.exe', '/c taskkill /f /im explorer.exe & start explorer.exe', LDir, SW_HIDE);
      end;
    end
    else
    begin
      if KeyExists('Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32') then
        DeleteKey('Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}')
    end;
  finally
    CloseKey;
    Free;
  end;
end;

procedure TMainForm.StateSwitchClick(Sender: TObject);
begin
SetState(StateSwitch.IsChecked);
end;

procedure TMainForm.StateSwitchSwitch(Sender: TObject);
begin
  if StateSwitch.IsChecked then
  begin
    Label2.FontColor := TAlphaColors.White;
    Label2.Text := '经典菜单';
  end
  else
  begin
    Label2.FontColor := TAlphaColors.Black;
    Label2.Text := '新版菜单';
  end;
end;

end.

