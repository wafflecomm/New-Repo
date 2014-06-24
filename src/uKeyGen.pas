unit uKeyGen ;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, clipbrd, ExtCtrls ;

  Function GenerateKey( const pProductKey : Char ; pUserName: String ) : String ;

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
//  ex) K2RJ-TB9b-LFF1-3QHD
//       3 0  0 2   0   1 0
//  -------------------------
//  0 : User Name Key
//  1 : Product Key - UpperCase
//  2 : Product Key - LowCase
//  3 : Product Key - Numeric
////////////////////////////////////////////////////////////////////////////////
Function GenerateKey( const pProductKey : Char ; pUserName: String ) : String ;
var
  i, j : Integer ;

  sTotalRegKey, sRegKeySec : String ;

  sRegKey : Array[0..3, 0..3] of Char ;
  sProducKey : Array[0..2] of Char ;

begin


  sProducKey[0] := Char( (Ord(pProductKey) Mod 24) + 65 ) ; // UpperCase
  sProducKey[1] := Char( (Ord(pProductKey) Mod 10) + 48 ) ; // Numeric
  sProducKey[2] := Char( (Ord(pProductKey) Mod 24) + 97 ) ; // LowCase


  FillChar( sRegKey, SizeOf(sRegKey), 0 ) ;

  Randomize;

//  Key Section 1;

  for j := 0 to 3 do
  begin
    Case j of
        0  : sRegKey[0,j] := Char (Random(24) + 65 ) ; // UpperCase
        1  : sRegKey[0,j] := sProducKey[1] ; // Char (Random(10) + 48) ; // Numeric
        2  : sRegKey[0,j] := Char (Random(24) + 65) ; // UpperCase
        3  : sRegKey[0,j] := Char( ((Ord(pUserName[1]) + Ord(sRegKey[0,2])) Mod 24) + 65 ) ;
    End ;
  end ;

//  Key Section 2;

  for j := 0 to 3 do
  begin
    Case j of
        0  : sRegKey[1,j] := Char (Random(24) + 65 ) ; // UpperCase
        1  : sRegKey[1,j] := Char( ((Ord(pUserName[2]) + Ord(sRegKey[1,0])) Mod 24) + 65 ) ;
        2  : sRegKey[1,j] := Char (Random(10) + 48) ; // Numeric
        3  : sRegKey[1,j] := sProducKey[2] ; // sRegKey[1,j] := Char (Random(24) + 65) ; // UpperCase
    End ;
  end ;


//  Key Section 3;

  for j := 0 to 3 do
  begin
    Case j of
        0  : sRegKey[2,j] := Char (Random(10) + 48) ; // Numeric
        1  : sRegKey[2,j] := Char (Random(24) + 65) ; // UpperCase
        2  : sRegKey[2,j] := Char( ((Ord(pUserName[3]) + Ord(sRegKey[2,1])) Mod 24) + 65 ) ;
        3  : sRegKey[2,j] := Char (Random(24) + 65 ) ; // UpperCase
    End ;
  end ;


//  Key Section 4;

  for j := 0 to 2 do
  begin
    Case j of
        0  : sRegKey[3,j] := Char( ((Ord(pUserName[4]) + Ord(sRegKey[2,3])) Mod 24) + 65 ) ; // Char (Random(10) + 48) ; // Numeric
        1  : sRegKey[3,j] := sProducKey[0] ; // sRegKey[3,j] := Char (Random(24) + 65 ) ; // UpperCase
        2  : sRegKey[3,j] := Char (Random(24) + 65) ; // UpperCase
     //   3  : sRegKey[3,j] := '0' CheckSum Digit ;
    End ;
  end ;

  // CheckSum
  sRegKey[3,3] := Char( ((CalcStrChecksum ( sRegKey[0] + sRegKey[1] + sRegKey[2] + sRegKey[3] )) Mod 10) + 48);


  sTotalRegKey := '' ;
  for i := 0 to 3 do
  begin
    {
    sRegKeySec := '' ;
    for j := 0 to 3 do
    begin
      sRegKeySec := sRegKeySec + sRegKey[i,j] ;
    end;
    sTotalRegKey := sTotalRegKey + sRegKeySec + '-' ;
    }
    sTotalRegKey := sTotalRegKey + sRegKey[i] + '-' ;
  end ;

  Result := Copy( sTotalRegKey, 1, Length(sTotalRegKey)-1 )  ;

end ;

end.
 