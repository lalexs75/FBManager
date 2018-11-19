{ Free DB Manager

  Copyright (C) 2005-2018 Lagunov Aleksey  alexs75 at yandex.ru

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}

unit fbmFileProviderUnit;

{$I fbmanager_define.inc}

interface

uses
  Classes, SysUtils, IpHtml, IpMsg, Graphics;

type

  { TFileDataProvider }

  TFileDataProvider = class(TIpAbstractHtmlDataProvider)
  protected
    function DoGetHtmlStream(const URL: string;
      PostData: TIpFormDataEntity) : TStream; override;
    {-provider assumes ownership of returned TStream and will free it when
      done using it.}
    function DoCheckURL(const URL: string;
      var ContentType: string): Boolean; override;
    procedure DoLeave(Html: TIpHtml); override;
    procedure DoReference(const URL: string); override;
    procedure DoGetImage(Sender: TIpHtmlNode; const URL: string;
      var Picture: TPicture); override;
    function CanHandle(const URL: string): Boolean; override;
    // renamed New,Old for IP_LAZARUS to NewURL, OldURL
    function BuildURL(const OldURL, NewURL: string): string; override;
  end;

implementation

{ TFileDataProvider }

function TFileDataProvider.DoGetHtmlStream(const URL: string;
  PostData: TIpFormDataEntity): TStream;
begin
  Result:=nil;
  if FileExists(URL) then
    Result:=TFileStream.Create(URL, fmOpenRead);
end;

function TFileDataProvider.DoCheckURL(const URL: string; var ContentType: string
  ): Boolean;
begin
  Result:=(Pos('www',Url) = 0) and (Pos('@',Url) = 0) and FileExists(URL);
  if Result then
    ContentType := 'text/html';
end;

procedure TFileDataProvider.DoLeave(Html: TIpHtml);
begin

end;

procedure TFileDataProvider.DoReference(const URL: string);
begin

end;

procedure TFileDataProvider.DoGetImage(Sender: TIpHtmlNode; const URL: string;
  var Picture: TPicture);
begin
  //inherited DoGetImage(Sender, URL, Picture);
end;

function TFileDataProvider.CanHandle(const URL: string): Boolean;
begin
  Result:=true;//(Pos('www',Url) = 0) and (Pos('@',Url) = 0);
end;

function TFileDataProvider.BuildURL(const OldURL, NewURL: string): string;
begin
  if (Pos(':', NewUrl) = 0) and (Pos('www',NewUrl) = 0) and (Pos('@',NewUrl) = 0) then
    Result := {ProgramDirectory+'docs\'+}NewUrl
  else
    Result := NewUrl;
end;

end.

