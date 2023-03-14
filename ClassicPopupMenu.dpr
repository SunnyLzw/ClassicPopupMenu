program ClassicPopupMenu;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'Src\MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
