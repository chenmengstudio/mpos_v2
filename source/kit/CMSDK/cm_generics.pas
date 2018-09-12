{
    This file is part of the CM SDK.
    Copyright (c) 2013-2018 by the ChenMeng studio

    cm_generics

    This is not a complete unit, for testing

 **********************************************************************}

unit cm_generics;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Contnrs;

type

  { TCMHashObjectList }

  TCMHashObjectList<T: class> = class
  private
    FObjectList: TFPHashObjectList;
    function GetCapacity: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): T;
    procedure SetCapacity(AValue: Integer);
    procedure SetCount(AValue: Integer);
    procedure SetItem(Index: Integer; AValue: T);
  private
    function GetOwnsObjects: Boolean;
    procedure SetOwnsObjects(AValue: Boolean);
  public
    constructor Create(FreeObjects: Boolean=True);
    destructor Destroy; override;
    procedure Clear;
    function Add(const AName: ShortString; AObject: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    function NameOfIndex(Index: Integer): ShortString; {$ifdef CCLASSESINLINE}inline;{$endif}
    function HashOfIndex(Index: Integer): LongWord; {$ifdef CCLASSESINLINE}inline;{$endif}
    procedure Delete(Index: Integer);
    function Remove(AObject: T): Integer; inline;
    function IndexOf(AObject: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    function Find(const s: shortstring): T; {$ifdef CCLASSESINLINE}inline;{$endif}
    function FindIndexOf(const s: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    function FindWithHash(const AName: shortstring; AHash:LongWord): T;
    function Rename(const AOldName, ANewName: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property OwnsObjects: Boolean read GetOwnsObjects write SetOwnsObjects;
    property Items[Index: Integer]: T read GetItem write SetItem; default;
  end;

  { TInterfaceItem }

  TInterfaceItem<T: IUnknown> = class
  private
    FInft: T;
  public
    constructor Create(AInft: T);
    destructor Destroy; override;
    property Inft: T read FInft;
  end;

  { TCMHashInterfaceList
        因考虑到接口自动生命周期与其实现难度的问题，用 TInterfaceItem<T: IUnknown> 对接口进行托管处理，
    如此则存放量大时诸如：Remove(AInft: T)、IndexOf(AObject: T) 效率将下降。
  }

  TCMHashInterfaceList<T: IUnknown> = class
  private
    FObjectList: TFPHashObjectList;
    function GetCapacity: Integer;
    function GetCount: Integer;
    function GetItem(Index: Integer): T;
    procedure SetCapacity(AValue: Integer);
    procedure SetCount(AValue: Integer);
    procedure SetItem(Index: Integer; AValue: T);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const AName: ShortString; AInft: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    function NameOfIndex(Index: Integer): ShortString; {$ifdef CCLASSESINLINE}inline;{$endif}
    function HashOfIndex(Index: Integer): LongWord; {$ifdef CCLASSESINLINE}inline;{$endif}
    procedure Delete(Index: Integer);
    function Remove(AInft: T): Integer; inline;
    function IndexOf(AInft: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    function Find(const s: shortstring): T; {$ifdef CCLASSESINLINE}inline;{$endif}
    function FindIndexOf(const s: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    function FindWithHash(const AName: shortstring; AHash:LongWord): T;
    function Rename(const AOldName, ANewName: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: T read GetItem write SetItem; default;
  end;

implementation

{ TCMHashObjectList }

function TCMHashObjectList<T>.GetCapacity: Integer;
begin
  Result := FObjectList.Capacity;
end;

function TCMHashObjectList<T>.GetCount: Integer;
begin
  Result := FObjectList.Count;
end;

function TCMHashObjectList<T>.GetItem(Index: Integer): T;
begin
  Result := T(FObjectList[Index]);
end;

procedure TCMHashObjectList<T>.SetCapacity(AValue: Integer);
begin
  FObjectList.Capacity := AValue;
end;

procedure TCMHashObjectList<T>.SetCount(AValue: Integer);
begin
  FObjectList.Count := AValue;
end;

procedure TCMHashObjectList<T>.SetItem(Index: Integer; AValue: T);
begin
  FObjectList[Index] := AValue;
end;

function TCMHashObjectList<T>.GetOwnsObjects: Boolean;
begin
  Result := FObjectList.OwnsObjects;
end;

procedure TCMHashObjectList<T>.SetOwnsObjects(AValue: Boolean);
begin
  FObjectList.OwnsObjects := AValue;
end;

constructor TCMHashObjectList<T>.Create(FreeObjects: Boolean);
begin
  FObjectList := TFPHashObjectList.Create(FreeObjects);
end;

destructor TCMHashObjectList<T>.Destroy;
begin
  FObjectList.Free;
  inherited Destroy;
end;

procedure TCMHashObjectList<T>.Clear;
begin
  FObjectList.Clear;
end;

function TCMHashObjectList<T>.Add(const AName: ShortString; AObject: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.Add(AName, AObject);
end;

function TCMHashObjectList<T>.NameOfIndex(Index: Integer): ShortString; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.NameOfIndex(Index);
end;

function TCMHashObjectList<T>.HashOfIndex(Index: Integer): LongWord; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.HashOfIndex(Index);
end;

procedure TCMHashObjectList<T>.Delete(Index: Integer);
begin
  FObjectList.Delete(Index);
end;

function TCMHashObjectList<T>.Remove(AObject: T): Integer;
begin
  Result := FObjectList.Remove(AObject);
end;

function TCMHashObjectList<T>.IndexOf(AObject: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.IndexOf(AObject);
end;

function TCMHashObjectList<T>.Find(const s: shortstring): T; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := T(FObjectList.Find(s));
end;

function TCMHashObjectList<T>.FindIndexOf(const s: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.FindIndexOf(s);
end;

function TCMHashObjectList<T>.FindWithHash(const AName: shortstring; AHash: LongWord): T;
begin
  Result := T(FObjectList.FindWithHash(AName, AHash));
end;

function TCMHashObjectList<T>.Rename(const AOldName, ANewName: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.Rename(AOldName, ANewName);
end;

{ TInterfaceItem }

constructor TInterfaceItem<T>.Create(AInft: T);
begin
  FInft := AInft;
end;

destructor TInterfaceItem<T>.Destroy;
begin
  IUnknown(FInft) := nil;
  inherited Destroy;
end;

{ TCMHashInterfaceList }

function TCMHashInterfaceList<T>.GetCapacity: Integer;
begin
  Result := FObjectList.Capacity;
end;

function TCMHashInterfaceList<T>.GetCount: Integer;
begin
  Result := FObjectList.Count;
end;

function TCMHashInterfaceList<T>.GetItem(Index: Integer): T;
begin
  Result := TInterfaceItem<T>(FObjectList[Index]).Inft;
end;

procedure TCMHashInterfaceList<T>.SetCapacity(AValue: Integer);
begin
  FObjectList.Capacity := AValue;
end;

procedure TCMHashInterfaceList<T>.SetCount(AValue: Integer);
begin
  FObjectList.Count := AValue;
end;

procedure TCMHashInterfaceList<T>.SetItem(Index: Integer; AValue: T);
begin
  TInterfaceItem<T>(FObjectList[Index]).FInft := AValue;
end;

constructor TCMHashInterfaceList<T>.Create;
begin
  FObjectList := TFPHashObjectList.Create(True);
end;

destructor TCMHashInterfaceList<T>.Destroy;
begin
  FObjectList.Free;
  inherited Destroy;
end;

procedure TCMHashInterfaceList<T>.Clear;
begin
  FObjectList.Clear;
end;

function TCMHashInterfaceList<T>.Add(const AName: ShortString; AInft: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.Add(AName, TInterfaceItem<T>.Create(AInft));
end;

function TCMHashInterfaceList<T>.NameOfIndex(Index: Integer): ShortString; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.NameOfIndex(Index);
end;

function TCMHashInterfaceList<T>.HashOfIndex(Index: Integer): LongWord; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.HashOfIndex(Index);
end;

procedure TCMHashInterfaceList<T>.Delete(Index: Integer);
begin
  FObjectList.Delete(Index);
end;

function TCMHashInterfaceList<T>.Remove(AInft: T): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := Self.IndexOf(AInft);
  if i >= 0 then
    begin
      FObjectList.Delete(i);
      Result := i;
    end;
end;

function TCMHashInterfaceList<T>.IndexOf(AInft: T): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
var
  i: Integer;
begin
  Result := -1;
  for i:=0 to FObjectList.Count-1 do
    begin
      if TInterfaceItem<T>(FObjectList[i]).Inft = AInft then
        begin
          Result := i;
          Exit;
        end;
    end;
end;

function TCMHashInterfaceList<T>.Find(const s: shortstring): T; {$ifdef CCLASSESINLINE}inline;{$endif}
var
  item: TInterfaceItem<T>;
begin
  Result := T(nil);
  item := TInterfaceItem<T>(FObjectList.Find(s));
  if Assigned(item) then
    Result := item.Inft;
end;

function TCMHashInterfaceList<T>.FindIndexOf(const s: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.FindIndexOf(s);
end;

function TCMHashInterfaceList<T>.FindWithHash(const AName: shortstring; AHash: LongWord): T;
var
  item: TInterfaceItem<T>;
begin
  Result := T(nil);
  item := TInterfaceItem<T>(FObjectList.FindWithHash(AName, AHash));
  if Assigned(item) then
    Result := item.Inft;
end;

function TCMHashInterfaceList<T>.Rename(const AOldName, ANewName: shortstring): Integer; {$ifdef CCLASSESINLINE}inline;{$endif}
begin
  Result := FObjectList.Rename(AOldName, ANewName);
end;



end.

