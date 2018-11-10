{
    This file is part of the CM SDK.
    Copyright (c) 2013-2018 by the ChenMeng studio

    cm_theme

    This is not a complete unit, for testing

    Abstract Window Toolkit
    依赖于具体解决方案，否则抛出异常。
    不建议不分次建议中操作同一对象，你可能遇到类型操作失误的状况。
    建议在使用时捕获相应的异常。

    这一部分都是线程不安全的。

 **********************************************************************}

unit cm_AWT;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  cm_interfaces,
  cm_AWTBase, cm_AWTEvent;

type

  // 前置声明
  TAFont = class;
  TACustomBitmap = class;
  TABrush = class;
  TACanvas = class;
  TAControlBorderSpacing = class;
  TAControl = class;
  TAWinControl = class;
  IAToolkit = interface;

  { EAWTException }

  EAWTException = class(Exception);

  {$I awt_graphicspeer.inc}

  { TAObject }

  TAObject = class abstract(TCMBasePersistent)
  protected
    FPeer: IAPeer;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  { TAFont }

  TAFont = class(TAObject)
  private
    function GetColor: TAColor;
    function GetHeight: Integer;
    function GetName: string;
    function GetSize: Integer;
    procedure SetColor(AValue: TAColor);
    procedure SetHeight(AValue: Integer);
    procedure SetName(AValue: string);
    procedure SetSize(AValue: Integer);
  public
    constructor Create;
    constructor Create(APeer: IAFontPeer); overload;
    function GetPeer: IAFontPeer;
  public
    property Color: TAColor read GetColor write SetColor;
    property Height: Integer read GetHeight write SetHeight;
    property Name: string read GetName write SetName;
    property Size: Integer read GetSize write SetSize;
  end;

  { TAGraphic }

  TAGraphic = class abstract(TAObject)
  private
    function GetEmpty: Boolean;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(AValue: Integer);
    procedure SetWidth(AValue: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function GetPeer: IAGraphicPeer;
  public
    procedure Clear;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToFile(const AFileName: string);
    procedure SaveToStream(AStream: TStream);
    property Empty: Boolean read GetEmpty;
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
  end;

  { TARasterImage }

  TARasterImage = class abstract(TAGraphic)
  private
    function GetCanvas: TACanvas;
  public
    function GetPeer: IARasterImagePeer;
  public
    procedure FreeImage;
    property Canvas: TACanvas read GetCanvas;
  end;

  { TACustomBitmap }

  TACustomBitmap = class(TARasterImage)
  private
    function GetMonochrome: Boolean;
    procedure SetMonochrome(AValue: Boolean);
  public
    // 这里映射的是一个抽象类，这个构造方法仅用于取出映射对象多态属性。
    constructor Create(APeer: IACustomBitmapPeer);
    function GetPeer: IACustomBitmapPeer;
  public
    procedure SetSize(AWidth, AHeight: Integer);
    property Monochrome: Boolean read GetMonochrome write SetMonochrome;
  end;

  { TABitmap }

  TABitmap = class(TACustomBitmap)
  public
    constructor Create;
  end;

  { TAJPEGImage }

  TAJPEGImage = class(TACustomBitmap)
  public
    constructor Create;
  end;

  { TAGIFImage }

  TAGIFImage = class(TACustomBitmap)
  public
    constructor Create;
  end;

  { TAPortableNetworkGraphic }

  TAPortableNetworkGraphic = class(TACustomBitmap)
  public
    constructor Create;
  end;

  { TABrush }

  TABrush = class(TAObject)
  private
    function GetBitmap: TACustomBitmap;
    function GetColor: TAColor;
    procedure SetBitmap(AValue: TACustomBitmap);
    procedure SetColor(AValue: TAColor);
  public
    constructor Create(APeer: IABrushPeer);
    function GetPeer: IABrushPeer;
  public
    property Bitmap: TACustomBitmap read GetBitmap write SetBitmap;
    property Color: TAColor read GetColor write SetColor;
  end;

  { TACanvas }

  TACanvas = class(TAObject)
  private
    function GetBrush: TABrush;
    function GetFont: TAFont;
    procedure SetBrush(AValue: TABrush);
    procedure SetFont(AValue: TAFont);
  public
    constructor Create;
    constructor Create(APeer: IACanvasPeer); overload;
    function GetPeer: IACanvasPeer;
  public
    procedure FillRect(X1,Y1,X2,Y2: Integer);
    procedure TextOut(X,Y: Integer; const Text: string);
    property Brush: TABrush read GetBrush write SetBrush;
    property Font: TAFont read GetFont write SetFont;
  end;

  {$i awt_controlpeer.inc}

  { TAControlBorderSpacing }

  TAControlBorderSpacing = class(TAObject)
  private
    function GetAround: Integer;
    function GetBottom: Integer;
    function GetLeft: Integer;
    function GetRight: Integer;
    function GetTop: Integer;
    procedure SetAround(AValue: Integer);
    procedure SetBottom(AValue: Integer);
    procedure SetLeft(AValue: Integer);
    procedure SetRight(AValue: Integer);
    procedure SetTop(AValue: Integer);
  public
    constructor Create(OwnerControl: TAControl);
    constructor Create(APeer: IAControlBorderSpacingPeer); overload;
    function GetPeer: IAControlBorderSpacingPeer;
  public
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Right: Integer read GetRight write SetRight;
    property Bottom: Integer read GetBottom write SetBottom;
    property Around: Integer read GetAround write SetAround;
  end;

  { TAComponent }

  TAComponent = class abstract(TAObject)
  private
    FOwner: TAComponent;
    FComponents: TFPList;
    function GetComponent(AIndex: Integer): TAComponent;
    function GetComponentCount: Integer;
  public
    constructor Create(AOwner: TAComponent); virtual;
    destructor Destroy; override;
    procedure DestroyComponents;
    procedure InsertComponent(AComponent: TAComponent);
    procedure RemoveComponent(AComponent: TAComponent);
    property Components[AIndex: Integer]: TAComponent read GetComponent;
    property ComponentCount: Integer read GetComponentCount;
    property Owner: TAComponent read FOwner;
    function GetPeer: IAComponentPeer;
  private
    function GetName: TComponentName;
    procedure SetName(AValue: TComponentName);
    function GetTag: PtrInt;
    procedure SetTag(AValue: PtrInt);
  public
    property Name: TComponentName read GetName write SetName;
    property Tag: PtrInt read GetTag write SetTag;
  end;

  { TAControl }

  TAControl = class abstract(TAComponent)
  public
    function GetPeer: IAControlPeer;
  private
    function GetParent: TAWinControl;
    procedure SetParent(AValue: TAWinControl);
  private
    function GetAlign: TAAlign;
    function GetBorderSpacing: TAControlBorderSpacing;
    function GetBoundsRect: TRect;
    function GetColor: TAColor;
    function GetEnabled: Boolean;
    function GetFont: TAFont;
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetText: TACaption;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetAlign(AValue: TAAlign);
    procedure SetBorderSpacing(AValue: TAControlBorderSpacing);
    procedure SetBoundsRect(AValue: TRect);
    procedure SetColor(AValue: TAColor);
    procedure SetEnabled(AValue: Boolean);
    procedure SetFont(AValue: TAFont);
    procedure SetHeight(AValue: Integer);
    procedure SetLeft(AValue: Integer);
    procedure SetText(AValue: TACaption);
    procedure SetTop(AValue: Integer);
    procedure SetWidth(AValue: Integer);
  public
    property Align: TAAlign read GetAlign write SetAlign;
    property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;
    property BorderSpacing: TAControlBorderSpacing read GetBorderSpacing write SetBorderSpacing;
    property Caption: TACaption read GetText write SetText;
    property Color: TAColor read GetColor write SetColor;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Font: TAFont read GetFont write SetFont;
  public
    property Left: Integer read GetLeft write SetLeft;
    property Height: Integer read GetHeight write SetHeight;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
    property Parent: TAWinControl read GetParent write SetParent;
  end;

  TAGraphicControl = class abstract(TAControl)
  end;

  { TAWinControl }

  TAWinControl = class abstract(TAControl)
  private
    function GetControl(AIndex: Integer): TAControl;
    function GetControlCount: Integer;
  public
    function GetPeer: IAWinControlPeer;
  public
    procedure InsertControl(AControl: TAControl);
    procedure RemoveControl(AControl: TAControl);
    property ControlCount: Integer read GetControlCount;
    property Controls[AIndex: Integer]: TAControl read GetControl;
  public
    function CanFocus: Boolean;
    function CanSetFocus: Boolean;
    procedure SetFocus;
    procedure AddKeyListener(l: IKeyListener); //添加指定的按键侦听器，以接收发自此 WinControl 的按键事件。
  end;

  { TACustomControl }

  TACustomControl = class abstract(TAWinControl)
  private
    function GetBorderStyle: TABorderStyle;
    function GetCanvas: TACanvas;
    procedure SetBorderStyle(AValue: TABorderStyle);
    procedure SetCanvas(AValue: TACanvas);
  public
    function GetPeer: IACustomControlPeer;
  public
    property BorderStyle: TABorderStyle read GetBorderStyle write SetBorderStyle; //start at TWinControl
    property Canvas: TACanvas read GetCanvas write SetCanvas;
  end;

  { TALabel }

  TALabel = class(TAGraphicControl)
  public
    constructor Create(AOwner: TAComponent); override;
    function GetPeer: IALabelPeer;
  public

  end;

  { TAPanel }

  TAPanel = class(TACustomControl)
  public
    constructor Create(AOwner: TAComponent); override;
    function GetPeer: IAPanelPeer;
  public

  end;

  { TAEdit }

  TAEdit = class(TAWinControl)
  public
    constructor Create(AOwner: TAComponent); override;
    function GetPeer: IAEditPeer;
  public
    procedure Clear;
    procedure SelectAll;
    property Text: TACaption read GetText write SetText;
  end;

  { TAForm }

  TAForm = class(TAWinControl)
  private
    function GetFormBorderStyle: TAFormBorderStyle;
    procedure SetFormBorderStyle(AValue: TAFormBorderStyle);
  public
    constructor Create(AOwner: TAComponent); override;
    function GetPeer: IAFormPeer;
  public
    property BorderStyle: TAFormBorderStyle read GetFormBorderStyle write SetFormBorderStyle;
    function ShowModal: Integer;
  end;

  {$I awt_toolkit.inc}

implementation

{ TAObject }

constructor TAObject.Create;
begin
  if not Assigned(TAWTManager.DefaultToolkit) then
    raise EAWTException.Create(NoToolKitError);
  FPeer := nil;
end;

destructor TAObject.Destroy;
begin
  FPeer := nil;
  inherited Destroy;
end;

{ TAFont }

function TAFont.GetColor: TAColor;
begin
  Result := GetPeer.GetColor;
end;

function TAFont.GetHeight: Integer;
begin
  Result := GetPeer.GetHeight;
end;

function TAFont.GetName: string;
begin
  Result := GetPeer.GetName;
end;

function TAFont.GetSize: Integer;
begin
  Result := GetPeer.GetSize;
end;

procedure TAFont.SetColor(AValue: TAColor);
begin
  GetPeer.SetColor(AValue);
end;

procedure TAFont.SetHeight(AValue: Integer);
begin
  GetPeer.SetHeight(AValue);
end;

procedure TAFont.SetName(AValue: string);
begin
  GetPeer.SetName(AValue);
end;

procedure TAFont.SetSize(AValue: Integer);
begin
  GetPeer.SetSize(AValue);
end;

constructor TAFont.Create;
begin
  inherited Create;
  FPeer := TAWTManager.DefaultToolkit.CreateFont(Self);
end;

constructor TAFont.Create(APeer: IAFontPeer);
begin
  inherited Create;
  FPeer := APeer;
end;

function TAFont.GetPeer: IAFontPeer;
begin
  FPeer.QueryInterface(IAFontPeer, Result);
end;

{ TAGraphic }

function TAGraphic.GetEmpty: Boolean;
begin
  Result := GetPeer.GetEmpty;
end;

function TAGraphic.GetHeight: Integer;
begin
  Result := GetPeer.GetHeight;
end;

function TAGraphic.GetWidth: Integer;
begin
  Result := GetPeer.GetWidth;
end;

procedure TAGraphic.SetHeight(AValue: Integer);
begin
  GetPeer.SetHeight(AValue);
end;

procedure TAGraphic.SetWidth(AValue: Integer);
begin
  GetPeer.SetWidth(AValue);
end;

constructor TAGraphic.Create;
begin
  FPeer := nil;
end;

destructor TAGraphic.Destroy;
begin
  FPeer := nil;
  inherited Destroy;
end;

function TAGraphic.GetPeer: IAGraphicPeer;
begin
  FPeer.QueryInterface(IAGraphicPeer, Result);
end;

procedure TAGraphic.Clear;
begin
  GetPeer.Clear;
end;

procedure TAGraphic.LoadFromFile(const AFilename: string);
begin
  GetPeer.LoadFromFile(AFilename);
end;

procedure TAGraphic.LoadFromStream(AStream: TStream);
begin
  GetPeer.LoadFromStream(AStream);
end;

procedure TAGraphic.SaveToFile(const AFilename: string);
begin
  GetPeer.SaveToFile(AFilename);
end;

procedure TAGraphic.SaveToStream(AStream: TStream);
begin
  GetPeer.SaveToStream(AStream);
end;

{ TARasterImage }

function TARasterImage.GetCanvas: TACanvas;
begin
  Result := GetPeer.GetCanvas;
end;

function TARasterImage.GetPeer: IARasterImagePeer;
begin
  FPeer.QueryInterface(IARasterImagePeer, Result);
end;

procedure TARasterImage.FreeImage;
begin
  GetPeer.FreeImage;
end;

{ TACustomBitmap }

function TACustomBitmap.GetMonochrome: Boolean;
begin
  Result := GetPeer.GetMonochrome;
end;

procedure TACustomBitmap.SetMonochrome(AValue: Boolean);
begin
  GetPeer.SetMonochrome(AValue);
end;

constructor TACustomBitmap.Create(APeer: IACustomBitmapPeer);
begin
  inherited Create;
  FPeer := APeer;
end;

function TACustomBitmap.GetPeer: IACustomBitmapPeer;
begin
  FPeer.QueryInterface(IACustomBitmapPeer, Result);
end;

procedure TACustomBitmap.SetSize(AWidth, AHeight: Integer);
begin
  GetPeer.SetSize(AWidth, AHeight);
end;

{ TABitmap }

constructor TABitmap.Create;
begin
  inherited Create(TAWTManager.DefaultToolkit.CreateCustomBitmap(Self));
end;

{ TAJPEGImage }

constructor TAJPEGImage.Create;
begin
  inherited Create(TAWTManager.DefaultToolkit.CreateCustomBitmap(Self));
end;

{ TAGIFImage }

constructor TAGIFImage.Create;
begin
  inherited Create(TAWTManager.DefaultToolkit.CreateCustomBitmap(Self));
end;

{ TAPortableNetworkGraphic }

constructor TAPortableNetworkGraphic.Create;
begin
  inherited Create(TAWTManager.DefaultToolkit.CreateCustomBitmap(Self));
end;

{ TABrush }

function TABrush.GetBitmap: TACustomBitmap;
begin
  Result := GetPeer.GetBitmap;
end;

function TABrush.GetColor: TAColor;
begin
  Result := GetPeer.GetColor;
end;

procedure TABrush.SetBitmap(AValue: TACustomBitmap);
begin
  GetPeer.SetBitmap(AValue);
end;

procedure TABrush.SetColor(AValue: TAColor);
begin
  GetPeer.SetColor(AValue);
end;

constructor TABrush.Create(APeer: IABrushPeer);
begin
  inherited Create;
  FPeer := APeer;
end;

function TABrush.GetPeer: IABrushPeer;
begin
  FPeer.QueryInterface(IABrushPeer, Result);
end;

{ TACanvas }

function TACanvas.GetBrush: TABrush;
begin
  Result := GetPeer.GetBrush;
end;

function TACanvas.GetFont: TAFont;
begin
  Result := GetPeer.GetFont;
end;

procedure TACanvas.SetBrush(AValue: TABrush);
begin
  GetPeer.SetBrush(AValue);
end;

procedure TACanvas.SetFont(AValue: TAFont);
begin
  GetPeer.SetFont(AValue);
end;

constructor TACanvas.Create;
begin
  inherited Create;
  FPeer := TAWTManager.DefaultToolkit.CreateCanvas(Self);
end;

constructor TACanvas.Create(APeer: IACanvasPeer);
begin
  inherited Create;
  FPeer := APeer;
end;

function TACanvas.GetPeer: IACanvasPeer;
begin
  Result := IACanvasPeer(FPeer);
end;

procedure TACanvas.FillRect(X1, Y1, X2, Y2: Integer);
begin
  GetPeer.FillRect(X1, Y1, X2, Y2);
end;

procedure TACanvas.TextOut(X, Y: Integer; const Text: string);
begin
  GetPeer.TextOut(X, Y, Text);
end;

{ TAComponent }

function TAComponent.GetComponent(AIndex: Integer): TAComponent;
begin
  if not Assigned(FComponents) then
    Result := nil
  else
    Result := TAComponent(FComponents.Items[AIndex]);
end;

function TAComponent.GetComponentCount: Integer;
begin
  if not Assigned(FComponents) then
    Result := 0
  else
    Result := FComponents.Count;
end;

constructor TAComponent.Create(AOwner: TAComponent);
begin
  inherited Create;
  FOwner := nil;
  FComponents := nil;
  if Assigned(AOwner) then
    AOwner.InsertComponent(Self);
end;

destructor TAComponent.Destroy;
begin
  DestroyComponents;
  if FOwner <> nil then
    FOwner.RemoveComponent(Self);
  FPeer := nil;
  inherited Destroy;
end;

procedure TAComponent.DestroyComponents;
var
  acomponent: TAComponent;
begin
  while Assigned(FComponents) do
    begin
      aComponent := TAComponent(FComponents.Last);
      RemoveComponent(aComponent);
      aComponent.Destroy;
    end;
end;

procedure TAComponent.InsertComponent(AComponent: TAComponent);
begin
  if not Assigned(FComponents) then
    FComponents := TFPList.Create;
  FComponents.Add(AComponent);
  AComponent.FOwner := Self;
end;

procedure TAComponent.RemoveComponent(AComponent: TAComponent);
begin
  AComponent.FOwner := nil;
  if Assigned(FComponents) then
    begin
      FComponents.Remove(AComponent);
      if FComponents.Count = 0 then
        begin
          FComponents.Free;
          FComponents := nil;
        end;
    end;
end;

function TAComponent.GetPeer: IAComponentPeer;
begin
  Result := IAComponentPeer(FPeer);
end;

function TAComponent.GetName: TComponentName;
begin
  Result := GetPeer.GetName;
end;

procedure TAComponent.SetName(AValue: TComponentName);
begin
  GetPeer.SetName(AValue);
end;

function TAComponent.GetTag: PtrInt;
begin
  Result := GetPeer.GetTag;
end;

procedure TAComponent.SetTag(AValue: PtrInt);
begin
  GetPeer.SetTag(AValue);
end;

{ TAControl }

function TAControl.GetPeer: IAControlPeer;
begin
  FPeer.QueryInterface(IAControlPeer, Result);
end;

function TAControl.GetParent: TAWinControl;
begin
  Result := GetPeer.GetParent;
end;

procedure TAControl.SetParent(AValue: TAWinControl);
begin
  GetPeer.SetParent(AValue);
end;

function TAControl.GetWidth: Integer;
begin
  Result := GetPeer.GetWidth;
end;

procedure TAControl.SetWidth(AValue: Integer);
begin
  GetPeer.SetWidth(AValue);
end;

function TAControl.GetBoundsRect: TRect;
begin
  Result := GetPeer.GetBoundsRect;
end;

function TAControl.GetAlign: TAAlign;
begin
  Result := GetPeer.GetAlign;
end;

function TAControl.GetBorderSpacing: TAControlBorderSpacing;
begin
  Result := GetPeer.GetBorderSpacing;
end;

function TAControl.GetColor: TAColor;
begin
  Result := GetPeer.GetColor;
end;

function TAControl.GetEnabled: Boolean;
begin
  Result := GetPeer.GetEnabled;
end;

function TAControl.GetFont: TAFont;
begin
  Result := GetPeer.GetFont;
end;

function TAControl.GetHeight: Integer;
begin
  Result := GetPeer.GetHeight;
end;

function TAControl.GetLeft: Integer;
begin
  Result := GetPeer.GetLeft;
end;

function TAControl.GetText: TACaption;
begin
  Result := GetPeer.GetText;
end;

function TAControl.GetTop: Integer;
begin
  Result := GetPeer.GetTop;
end;

procedure TAControl.SetAlign(AValue: TAAlign);
begin
  GetPeer.SetAlign(AValue);
end;

procedure TAControl.SetBorderSpacing(AValue: TAControlBorderSpacing);
begin
  GetPeer.SetBorderSpacing(AValue);
end;

procedure TAControl.SetColor(AValue: TAColor);
begin
  GetPeer.SetColor(AValue);
end;

procedure TAControl.SetEnabled(AValue: Boolean);
begin
  GetPeer.SetEnabled(AValue);
end;

procedure TAControl.SetFont(AValue: TAFont);
begin
  GetPeer.SetFont(AValue);
end;

procedure TAControl.SetHeight(AValue: Integer);
begin
  GetPeer.SetHeight(AValue);
end;

procedure TAControl.SetLeft(AValue: Integer);
begin
  GetPeer.SetLeft(AValue);
end;

procedure TAControl.SetText(AValue: TACaption);
begin
  GetPeer.SetText(AValue);
end;

procedure TAControl.SetTop(AValue: Integer);
begin
  GetPeer.SetTop(AValue);
end;

procedure TAControl.SetBoundsRect(AValue: TRect);
begin
  GetPeer.SetBoundsRect(AValue);
end;

{ TAWinControl }

function TAWinControl.GetControl(AIndex: Integer): TAControl;
begin
  Result := GetPeer.GetControl(AIndex);
end;

function TAWinControl.GetControlCount: Integer;
begin
  Result := GetPeer.GetControlCount;
end;

function TAWinControl.GetPeer: IAWinControlPeer;
begin
  FPeer.QueryInterface(IAWinControlPeer, Result);
end;

procedure TAWinControl.InsertControl(AControl: TAControl);
begin
  GetPeer.InsertControl(AControl);
end;

procedure TAWinControl.RemoveControl(AControl: TAControl);
begin
  GetPeer.RemoveControl(AControl);
end;

function TAWinControl.CanFocus: Boolean;
begin
  Result := GetPeer.CanFocus;
end;

function TAWinControl.CanSetFocus: Boolean;
begin
  Result := GetPeer.CanSetFocus;
end;

procedure TAWinControl.SetFocus;
begin
  GetPeer.SetFocus;
end;

procedure TAWinControl.AddKeyListener(l: IKeyListener);
begin
  GetPeer.AddKeyListener(l);
end;

{ TACustomControl }

function TACustomControl.GetBorderStyle: TABorderStyle;
begin
  Result := GetPeer.GetBorderStyle;
end;

function TACustomControl.GetCanvas: TACanvas;
begin
  Result := GetPeer.GetCanvas;
end;

procedure TACustomControl.SetBorderStyle(AValue: TABorderStyle);
begin
  GetPeer.SetBorderStyle(AValue);
end;

procedure TACustomControl.SetCanvas(AValue: TACanvas);
begin
  GetPeer.SetCanvas(AValue);
end;

function TACustomControl.GetPeer: IACustomControlPeer;
begin
  FPeer.QueryInterface(IACustomControlPeer, Result);
end;

{ TALabel }

constructor TALabel.Create(AOwner: TAComponent);
begin
  inherited Create(AOwner);
  FPeer := TAWTManager.DefaultToolkit.CreateLabel(Self);
end;

function TALabel.GetPeer: IALabelPeer;
begin
  FPeer.QueryInterface(IALabelPeer, Result);
end;

{ TAPanel }

constructor TAPanel.Create(AOwner: TAComponent);
begin
  inherited Create(AOwner);
  FPeer := TAWTManager.DefaultToolkit.CreatePanel(Self);
end;

function TAPanel.GetPeer: IAPanelPeer;
begin
  FPeer.QueryInterface(IAPanelPeer, Result);
end;

{ TAEdit }

constructor TAEdit.Create(AOwner: TAComponent);
begin
  inherited Create(AOwner);
  FPeer := TAWTManager.DefaultToolkit.CreateEdit(Self);
end;

function TAEdit.GetPeer: IAEditPeer;
begin
  FPeer.QueryInterface(IAEditPeer, Result);
end;

procedure TAEdit.Clear;
begin
  GetPeer.Clear;
end;

procedure TAEdit.SelectAll;
begin
  GetPeer.SelectAll;
end;

{ TAForm }

function TAForm.GetFormBorderStyle: TAFormBorderStyle;
begin
  Result := GetPeer.GetFormBorderStyle;
end;

procedure TAForm.SetFormBorderStyle(AValue: TAFormBorderStyle);
begin
  GetPeer.SetFormBorderStyle(AValue);
end;

constructor TAForm.Create(AOwner: TAComponent);
begin
  inherited Create(AOwner);
  FPeer := TAWTManager.DefaultToolkit.CreateForm(Self);
end;

function TAForm.GetPeer: IAFormPeer;
begin
  FPeer.QueryInterface(IAFormPeer, Result);
end;

function TAForm.ShowModal: Integer;
begin
  Result := IAFormPeer(FPeer).ShowModal;
end;

{ TAControlBorderSpacing }

function TAControlBorderSpacing.GetAround: Integer;
begin
  Result := GetPeer.GetAround;
end;

function TAControlBorderSpacing.GetBottom: Integer;
begin
  Result := GetPeer.GetBottom;
end;

function TAControlBorderSpacing.GetLeft: Integer;
begin
  Result := GetPeer.GetLeft;
end;

function TAControlBorderSpacing.GetRight: Integer;
begin
  Result := GetPeer.GetRight;
end;

function TAControlBorderSpacing.GetTop: Integer;
begin
  Result := GetPeer.GetTop;
end;

procedure TAControlBorderSpacing.SetAround(AValue: Integer);
begin
  GetPeer.SetAround(AValue);
end;

procedure TAControlBorderSpacing.SetBottom(AValue: Integer);
begin
  GetPeer.SetBottom(AValue);
end;

procedure TAControlBorderSpacing.SetLeft(AValue: Integer);
begin
  GetPeer.SetLeft(AValue);
end;

procedure TAControlBorderSpacing.SetRight(AValue: Integer);
begin
  GetPeer.SetRight(AValue);
end;

procedure TAControlBorderSpacing.SetTop(AValue: Integer);
begin
  GetPeer.SetTop(AValue);
end;

constructor TAControlBorderSpacing.Create(OwnerControl: TAControl);
begin
  inherited Create;
  FPeer := TAWTManager.DefaultToolkit.CreateBorderSpacing(Self, OwnerControl);
end;

constructor TAControlBorderSpacing.Create(APeer: IAControlBorderSpacingPeer);
begin
  inherited Create;
  FPeer := APeer;
end;

function TAControlBorderSpacing.GetPeer: IAControlBorderSpacingPeer;
begin
  Result := IAControlBorderSpacingPeer(FPeer);
end;

initialization
  TAWTManager.DefaultToolkit := nil;



end.

