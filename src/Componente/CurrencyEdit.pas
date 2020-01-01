unit CurrencyEdit;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls;

const
	PB_SETTINGCHANGE = WM_USER + 147;

type
	TNumberFormat = (Standard, Thousands, Scientific, Engineering);
	TCurrencyEdit = class(TCustomEdit)
	private
		FAlignment: TAlignment;
		FDecimals: ShortInt;
    FNegativo: Boolean;
		FEnter, FParentColor : Boolean;
		FInvalidEntry: TNotifyEvent;
		FMaxValue: Extended;
		FMinValue: Extended;
		FNumberFormat : TNumberFormat;
		FVersion: String;
		FDisabledColor, FEnabledColor : TColor;
		OldDecimalSep, OldThousandSep : Char;
		FOnClear : TNotifyEvent;
		function FormatText(Value: Extended): string;
		function GetAsCurrency: Currency;
		function GetAsFloat: Extended;
		function GetAsInteger: Integer;
		function GetValue: Extended;
		function HookMainProc(var Message: TMessage) : Boolean;
		function Remove1000(Num : string): string;
		function ReplaceSeparators(Num : string) : string;
		procedure DeleteKey(Key: Word);
		procedure DeleteSelection;
		procedure SetAlignment(Value: TAlignment);
		procedure SetAsCurrency(Value: Currency);
		procedure SetAsFloat(Value: Extended);
		procedure SetAsInteger(Value: Integer);
		procedure SetColor(Value : TColor);
		procedure SetDisabledColor(Value : TColor);
		procedure SetDecimals(Value: ShortInt);
    procedure SetNegativo(Value: Boolean);
		procedure SetMaxValue(Value: Extended);
		procedure SetMinValue(Value: Extended);
		procedure SetNumberFormat(Value: TNumberFormat);
		procedure SetParentColor(Value : Boolean);
		procedure SetValue(Value: Extended);
		procedure SetVersion(Value: String);
		procedure WMClear(var Msg : TMessage); message WM_CLEAR;
		procedure WMCut(var Message: TMessage); message WM_CUT;
		procedure WMCopy(var Message: TMessage); message WM_COPY;
		procedure WMGetDlgCode(var Msg : TWMGetDlgCode); message WM_GETDLGCODE;
		procedure WMPaste(var Message: TMessage); message WM_PASTE;
		procedure WMSettingchange(var Message: TMessage); message PB_SETTINGCHANGE;
		procedure CMPARENTCOLORCHANGED(var M:TMessage); message CM_PARENTCOLORCHANGED;
    procedure UnFormatText;
	protected
		procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
		procedure DoEnter; override;
		procedure DoExit; override;
		procedure InvalidEntry;
		procedure KeyDown(var Key: Word; Shift: TShiftState); override;
		procedure KeyPress(var Key: Char); override;
		procedure Keyup(var Key: Word; Shift: TShiftState); override;
		procedure SetEnabled(Value : Boolean); override;
		procedure Loaded; override;
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		procedure CreateParams(var Params: TCreateParams); override;
		property AsCurrency: Currency read GetAsCurrency write SetAsCurrency;
		property AsFloat: Extended read GetAsFloat write SetAsFloat;
		property AsInteger: Integer read GetAsInteger write SetAsInteger;
	published
		property Alignment: TAlignment read FAlignment write SetAlignment;
{$IFNDEF VER100} property Anchors; {$ENDIF}
		property AutoSelect;
		property AutoSize;
		property BorderStyle;
		property Color : TColor read FEnabledColor write SetColor default clWindow;
		property DisabledColor : TColor read FDisabledColor
			write SetDisabledColor default clBtnFace;
		property Enabled : Boolean read GetEnabled
			write SetEnabled default True;
		property Ctl3D;
		property Decimals: ShortInt read FDecimals write SetDecimals;
    property NumeroNegativo: Boolean read FNegativo write SetNegativo;
		property DragCursor;
		property DragMode;
		property Font;
		property HideSelection;
    property MaxLength;
		property MaxValue: Extended read FMaxValue write SetMaxValue;
		property MinValue: Extended read FMinValue write SetMinValue;
		property NumberFormat: TNumberFormat read FNumberFormat write SetNumberFormat;
		property OnChange;
		property OnClear : TNotifyEvent read FOnClear write FOnClear;
		property OnClick;
		property OnDblClick;
		property OnDragDrop;
		property OnDragOver;
		property OnEndDrag;
		property OnEnter;
		property OnExit;
		property OnInvalidEntry: TNotifyEvent read FInvalidEntry write FInvalidEntry;
		property OnKeyDown;
		property OnKeyPress;
		property OnKeyUp;
		property OnMouseDown;
		property OnMouseMove;
		property OnMouseUp;
		property OnStartDrag;
		property ParentColor : Boolean read FParentColor
			write SetParentColor default False;
		property ParentCtl3D;
		property ParentFont;
		property ParentShowHint;
		property PopupMenu;
		property ReadOnly;
		property ShowHint;
		property TabOrder;
		property TabStop;
		property Value: Extended read GetValue write SetValue;
{Read only}
		property Version: String read FVersion write SetVersion stored False;
		property Visible;
	end;

procedure Register;

implementation

uses Clipbrd;

constructor TCurrencyEdit.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	Width := 100;
	FAlignment := taRightJustify;
	FDecimals := -1;
	FEnter := False;
	FMaxValue := 0;
	FMinValue := 0;
	FNumberFormat := Standard;
	FVersion := '8.50.00.00';
	OldDecimalSep := FormatSettings.DecimalSeparator;
	OldThousandSep := FormatSettings.ThousandSeparator;
	Value := 0;
	Text := FormatText(Value);
	inherited Enabled := True;
	inherited Color := clWindow;
	FEnabledColor := clWindow;
	FDisabledColor := clBtnFace;
	Application.HookMainWindow(HookMainProc);
end;

procedure TCurrencyEdit.Loaded;
begin
	inherited;
	if Enabled then inherited Color := FEnabledColor
	else inherited Color := FDisabledColor;
end;

procedure TCurrencyEdit.CreateParams(var Params: TCreateParams);
const
	Alignments: array[TAlignment] of Word = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
	inherited CreateParams(Params);
	Params.Style := Params.Style or ES_MULTILINE or Alignments[FAlignment];
end;

destructor TCurrencyEdit.Destroy;
begin
	Application.UnHookMainWindow(HookMainProc);
	inherited;
end;

procedure TCurrencyEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	if (Button = mbLeft) or (ssLeft in Shift) then
	begin
		if FEnter = True then
		begin
			FEnter := False;
			if AutoSelect then SelectAll;
		end;
	end;
	inherited MouseDown(Button, Shift, X, Y);
end;

procedure TCurrencyEdit.DoEnter;
begin
	inherited DoEnter;
	if csLButtonDown in ControlState then FEnter := True;
	if AutoSelect then SelectAll;
end;

procedure TCurrencyEdit.DoExit;
begin
	Text := FormatText(Value);
	if ((FMinValue <> 0) or (FMaxValue <> 0))
		and ((Value < FMinValue) or (Value > FMaxValue)) then InvalidEntry
	else inherited DoExit;
end;

procedure TCurrencyEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
	inherited KeyDown(Key, Shift);
	FEnter := False;
	if not ReadOnly then
	begin
		if Key in [VK_DELETE, VK_BACK] then
		begin
			if SelLength > 0 then DeleteSelection
			else DeleteKey(Key);
			Key := 0;
		end;
	end;
end;

procedure TCurrencyEdit.UnFormatText;
var
  TmpText : String;
  Tmp     : Byte;

  IsNeg   : Boolean;
begin
  IsNeg := (Pos('-',Text) > 0) or (Pos('(',Text) > 0);
  TmpText := '';
  For Tmp := 1 to Length(Text) do
    if Text[Tmp] in ['0'..'9',FormatSettings.DecimalSeparator] then
      TmpText := TmpText + Text[Tmp];
  try
    If TmpText='' Then TmpText := '0.00';
    Text := TmpText;
  except
    MessageBeep(mb_IconAsterisk);
  end;
end;

procedure TCurrencyEdit.KeyPress(var Key: Char);
Var
  S : String;
  frmParent : TForm;
  btnDefault : TButton;
  i : integer;

  wID : Word;
  LParam : LongRec;
begin
  if Not (Key in ['0'..'9','.','-', #8, #13]) Then Key := #0;
  case Key of
    #13 : begin
            frmParent := TForm(GetParentForm(Self));
            UnformatText;
            btnDefault := nil;
            for i := 0 to frmParent.ControlCount -1 do
              if frmParent.Controls[i] is TButton then
                if (frmParent.Controls[i] as TButton).Default then

                  btnDefault := (frmParent.Controls[i] as TButton);
            if btnDefault <> nil then
              begin
                wID := GetWindowWord(btnDefault.Handle, wID);
                LParam.Lo := btnDefault.Handle;
                LParam.Hi := BN_CLICKED;
                SendMessage(frmParent.Handle, WM_COMMAND, wID, longint(LParam) );
              end;
            Key := #0;
          end;

    '.' : if ( Pos('.',Text) >0 ) then Key := #0;
    '-' : if ( Pos('-',Text) >0 ) or ( SelStart > 0 ) then Key := #0;
  else
    if ( Pos('-',Text) >0 ) and ( SelStart = 0 ) and (SelLength=0) then Key := #0;
  end;


  if Key <> Char(vk_Back) then begin
    S := Copy(Text,1,SelStart)+Key+Copy(Text,SelStart+SelLength+1,Length(Text));
    if ((Pos(FormatSettings.DecimalSeparator, S) > 0) and
       (Length(S) - Pos(FormatSettings.DecimalSeparator, S) > Decimals))
         or ((Key = '-') and (Pos('-', Text) <> 0))
         or (Pos('-', S) > 1)
    then Key := #0;

  end;

  if not FNegativo then begin
    if (key = '-') then Key := #0;
  end;

  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TCurrencyEdit.Keyup(var Key: Word; Shift: TShiftState);
var
	Numsep, NumSep0, SelStart0, X, D, N, N0 : integer;
	Text0 : string;
begin
	inherited KeyUp(Key, Shift);
	if (SelLength > 0) then exit;
	if NumberFormat <> Thousands then exit;
	D := pos(FormatSettings.DecimalSeparator, Text);
	SelStart0 := SelStart;
	NumSep := 0;
	NumSep0 := 0;
	Text0 := FormatText(AsFloat);
	for X := 1 to length(Text0) do
		if Text0[X] = FormatSettings.ThousandSeparator then inc(NumSep0);
	for X := 1 to length(Text) do
		if Text[X] = FormatSettings.ThousandSeparator then inc(NumSep);
	N := pos(FormatSettings.ThousandSeparator, Text);
	N0 := pos(FormatSettings.ThousandSeparator, Text0);
	if (NumSep <> NumSep0) or (N <> N0) or (Key in [32, 13]) then
	begin
		Text := Text0;
		Selstart := SelStart0 + NumSep0 - NumSep;
		if (pos(FormatSettings.DecimalSeparator, Text) <> 0) and (D = 0) then Selstart := Selstart + 1
		else if (D <> 0) and (pos(FormatSettings.DecimalSeparator, Text) = 0) then Selstart := Selstart - 1;
		if Copy(Text, Selstart + 1, 1) = FormatSettings.ThousandSeparator then Selstart := Selstart + 1;
	end;
end;

function TCurrencyEdit.GetAsCurrency: Currency;
begin
	Result := StrToCurr(Remove1000(Text));
end;

function TCurrencyEdit.GetAsFloat: Extended;
begin
	Result := StrToFloat(Remove1000(Text));
end;

function TCurrencyEdit.GetAsInteger: Integer;
begin
	Result := Trunc(StrToFloat(Remove1000(Text)));
end;

function TCurrencyEdit.GetValue: Extended;
begin
	Result := StrToFloat(Remove1000(Text));
end;

procedure TCurrencyEdit.SetAsCurrency(Value: Currency);
begin
	if Text <> FormatText(Value) then Text := FormatText(Value);
end;

procedure TCurrencyEdit.SetAsFloat(Value: Extended);
begin
	if Text <> FormatText(Value) then Text := FormatText(Value);
end;

procedure TCurrencyEdit.SetAsInteger(Value: Integer);
begin
	if Text <> FormatText(Value) then Text := FormatText(Value);
end;

procedure TCurrencyEdit.SetAlignment(Value: TAlignment);
var
	SelSt, SelLe : integer;
begin
	if FAlignment <> Value then
	begin
		SelSt := SelStart;
		SelLe := SelLength;
		FAlignment := Value;
		RecreateWnd;
		SelStart := SelSt;
		SelLength := SelLe;
	end;
end;

procedure TCurrencyEdit.SetColor(Value : TColor);
begin
	if FEnabledColor <> Value then
	begin
		FEnabledColor := Value;
		if Enabled then inherited Color := Value;
		if (Parent <> nil) and (FEnabledColor <> Parent.Brush.Color)
			then FParentColor := False;
	end;
end;

procedure TCurrencyEdit.SetDisabledColor(Value : TColor);
begin
	if FDisabledColor <> Value then
	begin
		FDisabledColor := Value;
		if (not Enabled) then inherited Color := Value;
	end;
end;

procedure TCurrencyEdit.SetEnabled(Value : Boolean);
begin
	inherited;
	if Enabled then inherited Color := FEnabledColor
	else inherited Color := FDisabledColor;
end;

procedure TCurrencyEdit.SetNegativo(Value: Boolean);
begin
  FNegativo := Value;
end;

procedure TCurrencyEdit.SetDecimals(Value: ShortInt);
var Value0 : ShortInt;
begin
	Value0 := Value;
	if FDecimals <> Value0 then
	begin
		if Value0 < 0 then Value0 := -1
		else if Value0 > 14 then Value0 := 14;
		if (Value0 > MaxLength - 2) and (MaxLength > 0) then Value0 := maxlength - 2;
		FDecimals := Value0;
		Text := FormatText(AsFloat);
	end;
end;

procedure TCurrencyEdit.SetMaxValue(Value: Extended);
begin
	if (FMaxValue <> Value) and (Value >= FminValue) then
	begin
		FMaxValue := Value;
	end;
end;

procedure TCurrencyEdit.SetMinValue(Value: Extended);
begin
	if (FMinValue <> Value) and (Value <= FmaxValue) then
	begin
		FMinValue := Value;
	end;
end;

procedure TCurrencyEdit.SetParentColor(Value : Boolean);
begin
	if FParentColor <> Value then
	begin
		FParentColor := Value;
		if FParentColor and (Parent <> nil) then FEnabledColor := Parent.Brush.Color;
		SetEnabled(Enabled);
	end;
end;

procedure TCurrencyEdit.SetValue(Value: Extended);
begin
	if csDesigning in ComponentState then
	begin
		if (Value > FMaxValue) and ((FMaxValue <> 0) or (FMinValue <> 0)) then InvalidEntry;
		if (Value < FMinValue) and ((FMaxValue <> 0) or (FMinValue <> 0)) then InvalidEntry;
	end;
	if Text <> FormatText(Value) then Text := FormatText(Value);
end;

procedure TCurrencyEdit.DeleteKey(Key: Word);
var
	P, D, E: Integer;
	N: Boolean;
	str0 : string;
begin
	D := pos(FormatSettings.DecimalSeparator, Text);
	E := pos('E', Text);
	if E = 0 then E := length(Text) + 1;
	if Key = VK_DELETE then
	begin
		P := SelStart + 1;
		if P > Length(Text) then Exit;
		if Text[P] in [FormatSettings.ThousandSeparator, FormatSettings.DecimalSeparator, 'E'] then inc(P);
	end
	else
	begin
		P := SelStart;
		if P = 0 then Exit;
		if Text[P] in [FormatSettings.ThousandSeparator, FormatSettings.DecimalSeparator, 'E'] then dec(P);
	end;
	N := (Pos('-', Text) > 0);
	if (P = 0) or (P > Length(Text)) then exit;
	str0 := '';
	if (P > D) and (D <> 0) and ((P < E) or (E = 0)) then
	begin
		if FDecimals > 0 then str0 := '0';
		Text := Copy(Text, 1, P - 1) + Copy(Text, P + 1,E - P - 1)
			+ str0 + Copy(Text, E, length(Text) - E + 1);
		SelStart := P - 1;
	end
	else if (P = 1) and N then
	begin
		Text := Copy(Text, 2, Length(Text) - 1);
		if Text = '' then Text := '0';
	end
	else if (P = 1) and ((P = D - 1) or (P = E - 1) or (P = length(Text))) then
	begin
		Text := '0' + Copy(Text, 2, Length(Text) - 1);
		SelStart := 1;
		if N then Text := '-' + Text;
	end
	else if P > 0 then
	begin
		Text := Copy(Text, 1, P - 1) + Copy(Text, P + 1, Length(Text) - P);
		SelStart := P - 1;
		if ((FNumberFormat = Scientific) or (FNumberFormat = Engineering))
			and (Text[length(Text)] = 'E') then Text := Text + '0';
	end;
end;

procedure TCurrencyEdit.DeleteSelection;
var
	X, Y, Z: Integer;
begin
	if SelLength = 0 then exit;
	if SelText = Text then
	begin
		Text := FormatText(0);
		exit;
	end;
	Y := Length(Remove1000(SelText));
	if pos(FormatSettings.DecimalSeparator, SelText) <> 0 then dec(Y);
	Z := Length(SelText);
	SelStart := SelStart + Z;
	for X:= 1 to Y do
	begin
		DeleteKey(VK_BACK);
	end;
end;

procedure TCurrencyEdit.InvalidEntry;
begin
	if not (csLoading in ComponentState) then
	begin
		if Assigned(FInvalidEntry) then FInvalidEntry(Self)
		else
		begin
			if Value < FMinValue then Value := FMinValue
			else if Value > FMaxValue then Value := FMaxValue;
			MessageBeep(0);
			if CanFocus and (not (csDesigning in ComponentState)) then SetFocus;
		end;
	end;
end;

procedure TCurrencyEdit.SetVersion(Value: String);
begin
	{ Read only! }
end;

procedure TCurrencyEdit.WMCopy(var Message: TMessage);
begin
	ClipBoard.AsText := Remove1000(Seltext);
end;

procedure TCurrencyEdit.WMCut(var Message: TMessage);
begin
	ClipBoard.AsText := Remove1000(Seltext);
	DeleteSelection;
end;

procedure TCurrencyEdit.WMPaste(var Message: TMessage);
var
	X: integer;
	S: String;
	W: Word;
begin
	DeleteSelection;
	S := Clipboard.AsText;
	for X := 1 to Length(S) do
	begin
		W := Ord(S[X]);
		Perform(WM_CHAR, W, 0);
	end;
end;

procedure TCurrencyEdit.SetNumberFormat(Value: TNumberFormat);
begin
	if FNumberFormat <> Value then FNumberFormat := Value;
	Text := FormatText(AsFloat);
end;

function TCurrencyEdit.ReplaceSeparators(Num : string) : string;
var
	t : integer;
begin
	Result := Num;
	for t := 1 to Length(Result) do
	begin
		if Result[t] = OldDecimalSep then Result[t] := FormatSettings.DecimalSeparator
		else if Result[t] = OldThousandSep then Result[t] := FormatSettings.ThousandSeparator;
	end;
	OldDecimalSep := FormatSettings.DecimalSeparator;
	OldThousandSep := FormatSettings.ThousandSeparator;
end;

function TCurrencyEdit.Remove1000(Num : string): string;
var
	t : integer;
begin
	if (OldDecimalSep <> FormatSettings.DecimalSeparator)
		or (OldThousandSep <> FormatSettings.ThousandSeparator)
		then Num := ReplaceSeparators(Num);
	Result := '';
	for t :=1 to length(Num) do
	begin
		if Num[t] <> FormatSettings.ThousandSeparator then Result := Result + Num[t];
	end;
	if Result = '' then Result := '0';
	if Result = '-' then Result := '-0';
end;

function TCurrencyEdit.FormatText(Value: Extended) : string;
var
	e0, E, D, NN, t, FD : integer;
	a : extended;
	Formatmask : string;
begin
	if (FNumberFormat = Engineering) and (Value <> 0) then
	begin
		e0 := trunc(ln(abs(Value)) / ln(10) / 3) * 3;
		Result := 'E' + inttostr(e0);
		a := Value / StrToFloat('1' + Result);
		FD := 14;
		if a > 9 then dec(FD);
		if a > 99 then dec(FD);
		if (FD > FDecimals) and (FDecimals <> -1) then FD := FDecimals;
		if FDecimals < 0 then Result := formatfloat('0.' + StringOfChar('#',FD), a) + Result
		else if FDecimals = 0 then Result := formatfloat('0', a) + Result
		else Result := formatfloat('0.' + StringOfChar('0',FD), a) + Result;
	end
	else
	begin
		FormatMask := '0';
		if FNumberFormat = Thousands then FormatMask := ',' + FormatMask;
		if FDecimals > 0 then FormatMask := FormatMask + '.' + StringOfChar('0', FDecimals)
		else if FDecimals < 0 then FormatMask := FormatMask + '.' + StringOfChar('#', 14);
		if FNumberFormat > Thousands then FormatMask := FormatMask + 'E-';
		Result := FormatFloat(FormatMask, Value);
		E := pos('E',Result);
		if E = 0 then
		begin
			D := pos(FormatSettings.DecimalSeparator, Result);
			if (D <> 0) then
			begin
				NN := 0;
				for t := 1 to D do if (Result[t] in ['0'..'9'] = True) then inc(NN);
				if (FDecimals = -1) then
				begin
					if FNumberFormat = Thousands then Result := FormatFloat(',0.' + StringOfChar('#',15 - NN),Value)
					else if FDecimals <> -1 then Result := FormatFloat('0.' + StringOfChar('#',15 - NN),Value);
				end
				else if (FDecimals > 15 - NN) then
				begin
					if FNumberFormat = Thousands then Result := FormatFloat(',0.' + StringOfChar('0',15 - NN),Value)
					else if FDecimals <> -1 then Result := FormatFloat('0.' + StringOfChar('0',15 - NN),Value);
					Result := Result + StringOfChar('0', Fdecimals -15 + NN);
				end;
			end;
		end;
	end;
end;

function TCurrencyEdit.HookMainProc(var Message: TMessage) : Boolean;
begin
	Result := False;
	if Message.Msg = WM_SETTINGCHANGE
		then PostMessage(Self.Handle, PB_SETTINGCHANGE, 0, 0);
end;

procedure TCurrencyEdit.WMSettingchange(var Message: TMessage);
begin
	Text := ReplaceSeparators(Text);
end;

procedure TCurrencyEdit.CMPARENTCOLORCHANGED(var M:TMessage);
begin
	if FParentColor and (Parent <> nil) then FEnabledColor := Parent.Brush.Color;
	if Parent <> nil then Invalidate;
	SetEnabled(Enabled);
end;

procedure TCurrencyEdit.WMClear(var Msg : TMessage);
begin
	if Assigned(FOnClear) then FOnClear(Self)
	else DeleteSelection;
end;

procedure TCurrencyEdit.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
	Msg.Result := DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure Register;
begin
	RegisterComponents('CurrEdit', [TCurrencyEdit]);
end;

end.
