unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, clipbrd, ExtCtrls, dxGDIPlusClasses;

type
  TfrmMain = class(TForm)
    lbKey: TLabel;
    txtRegKey: TEdit;
    bnCopyClip: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    cmbProduct: TComboBox;
    lbName: TLabel;
    txtUsrName: TEdit;
    bnKeyGen: TButton;
    Image1: TImage;
    Label3: TLabel;
    Bevel1: TBevel;
    btnCheckKey: TButton;
    procedure bnKeyGenClick(Sender: TObject);
    procedure bnCopyClipClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCheckKeyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Function  CheckInvalidName : Boolean ;
  end;

var
  frmMain: TfrmMain;



implementation

uses
  uKeyGen, uKeyCheck ;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
procedure TfrmMain.bnKeyGenClick(Sender: TObject);
var
  sProducKey : Char ;
begin
   If Not( CheckInvalidName ) then Exit ;

   Case cmbProduct.ItemIndex of
     0 : sProducKey := 'w' ;
     1 : sProducKey := 'C' ;
     else
         sProducKey := '0' ;
   end ;

   txtRegKey.Text := uKeyGen.GenerateKey( sProducKey, Trim(txtUsrName.Text) ) ;


end;

////////////////////////////////////////////////////////////////////////////////
Function TfrmMain.CheckInvalidName : Boolean ;
begin
  if( Length(Trim(txtUsrName.Text)) < 5 ) then begin
     MessageDlg('Name must be extra 6 character. !', mtInformation, [mbOk], 0);
     Result := FALSE ;
  end
  else
     Result := TRUE ;
end ;

////////////////////////////////////////////////////////////////////////////////
procedure TfrmMain.bnCopyClipClick(Sender: TObject);
begin
  Clipboard.SetTextBuf( PChar(txtRegKey.Text)); 
end;
////////////////////////////////////////////////////////////////////////////////
procedure TfrmMain.FormShow(Sender: TObject);
begin

  Caption := Application.Title ;

  txtUsrName.Text := 'Waffle Communication' ;
  txtRegKey.Text := '' ;

end;
////////////////////////////////////////////////////////////////////////////////
procedure TfrmMain.btnCheckKeyClick(Sender: TObject);
var
  iRet : Integer ;
  cProducKey : Char ;
begin
   If (Trim(txtRegKey.Text) = '')  then Exit ;

   Case cmbProduct.ItemIndex of
     0 : cProducKey := 'w' ;
     1 : cProducKey := 'C' ;
     else
         cProducKey := '0' ;
   end ;

   iRet := uKeyCheck.CheckKeyValidation( cProducKey, txtUsrName.Text, txtRegKey.Text ) ;
   if( iRet > 0 ) then
   begin
//     ShowMessage( 'Success Check Registration Key Validation.' ) ;
     MessageDlg( 'Success Check Registration Key Validation.', mtInformation, [mbOK], 0 ) ;
   end
   else
   begin
//     ShowMessage( 'Failure Check Registration Key Validation. ' + IntToStr(iRet) ) ;
     MessageDlg( 'Failure Check Registration Key Validation. (' + IntToStr(iRet) + ')', mtWarning, [mbOK], 0 ) ;
   end ;

end;

end.
