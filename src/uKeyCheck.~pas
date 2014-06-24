unit uKeyCheck ;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, clipbrd, ExtCtrls ;

  Function CheckKeyValidation( const pProductKey : Char ; pUserName, pRegKey: String ) : Integer ;

implementation


////////////////////////////////////////////////////////////////////////////////
{
Example of calculating a simple checksum.
Beispiel, wie eine einfache Checksumme berechnet werden kann.
}
////////////////////////////////////////////////////////////////////////////////
function CalcStrChecksum( sStr: String; Const bZeroBased: Boolean = TRUE ): Longint ;
var
  i : integer ;
  iLen : integer ;
begin
  Result := 0 ;
  iLen := Length(sStr);
  if iLen > 0 then
  begin
  for i := 1 to iLen do
    if bZeroBased then
       Inc( Result, Ord(sStr[i]) - 65 )
    else
       Inc( Result, Ord(sStr[i]) );
  end;
end ;


////////////////////////////////////////////////////////////////////////////////
//      1234567890123456
//  ex) K2RJTB9bLFF1DQH3
//       3 0 0 2  0 01 C
//  -------------------------
//  0 : User Name Key
//  1 : Product Key - UpperCase
//  2 : Product Key - LowCase
//  3 : Product Key - Numeric
//  C : Checksum
////////////////////////////////////////////////////////////////////////////////
Function CheckKeyValidation( const pProductKey : Char ; pUserName, pRegKey: String ) : Integer ;
var
  sRegKey : String ;

  sProducKey : Array[0..2] of Char ;
  sUserKey : Array[0..3] of Char ;

  iCheckSum : Integer ;

begin
  Result := 0 ;

  FillChar( sProducKey, Length(sProducKey), 0 ) ;
  FillChar( sUserKey, Length(sUserKey), 0 ) ;

  sRegKey := StringReplace( pRegKey, '-', '', [rfReplaceAll] ) ;

  if( sRegKey = '' ) then Exit ;


  sProducKey[0] := Char( (Ord(pProductKey) Mod 24) + 65 ) ; // UpperCase
  sProducKey[1] := Char( (Ord(pProductKey) Mod 10) + 48 ) ; // Numeric
  sProducKey[2] := Char( (Ord(pProductKey) Mod 24) + 97 ) ; // LowCase

  sUserKey[0] := Char( ((Ord(pUserName[1]) + Ord(sRegKey[3])) Mod 24) + 65 ) ;
  sUserKey[1] := Char( ((Ord(pUserName[2]) + Ord(sRegKey[5])) Mod 24) + 65 ) ;
  sUserKey[2] := Char( ((Ord(pUserName[3]) + Ord(sRegKey[10])) Mod 24) + 65 ) ;
  sUserKey[3] := Char( ((Ord(pUserName[4]) + Ord(sRegKey[12])) Mod 24) + 65 ) ;


{
  Char( ((Ord(pUserName[1]) + Ord(sRegKey[3])) Mod 24) + 65 ) ;
  Char( ((Ord(pUserName[2]) + Ord(sRegKey[4])) Mod 24) + 65 ) ;
  Char( ((Ord(pUserName[3]) + Ord(sRegKey[9])) Mod 24) + 65 ) ;
  Char( ((Ord(pUserName[4]) + Ord(sRegKey[11])) Mod 24) + 65 ) ;
}

  Result := -1 ;
  // 1.Check Checksum Digit
  // Char( ((CalcStrChecksum ( sRegKey[0] + sRegKey[1] + sRegKey[2] + sRegKey[3] )) Mod 10) + 48);
  iCheckSum := CalcStrChecksum( Copy(sRegKey, 1, Length(sRegKey)-1) ) ;
  iCheckSum := (iCheckSum Mod 10) + 48 ;
  if( Ord(sRegKey[16]) <> iCheckSum ) then Exit ;


  Result := -2 ;
  // 2.Check Product Key Validation
  if( sRegKey[2]  <> sProducKey[1] ) then Exit ;
  if( sRegKey[8]  <> sProducKey[2] ) then Exit ;
  if( sRegKey[14] <> sProducKey[0] ) then Exit ;


   Result := -3 ;
  // 3.Check User Name Key Validation
  if( sRegKey[4]  <> sUserKey[0] ) then Exit ;
  if( sRegKey[6]  <> sUserKey[1] ) then Exit ;
  if( sRegKey[11] <> sUserKey[2] ) then Exit ;
  if( sRegKey[13] <> sUserKey[3] ) then Exit ;


  Result := 1 ;

end ;

end.

 