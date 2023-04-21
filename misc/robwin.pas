{$A+,B-,E+,F-,G+,N+,Q-,R-,S-}

unit RobWin;

interface

const
      GetMaxX                 = 319;
      GetMaxY                 = 199;
      GetMaxcolor             = 255;
      Maxcolors               = 256;
      Int1fFont               = 0;
      Int43Font               = 1;
      StandardVGAFont         = 1;
      Font8x8                 = 1;
      Font8x14                = 2;
      Font8x8dd               = 3;
      Font8x8ddHigh           = 4;
      AlphaAlternateFont      = 5;
      FontAlpha               = 5;
      Font8x16                = 6;
      Font9x16                = 7;
      FontRomAlt              = 7;
      Ok                      = 1;
      Cancel                  = 0;

type
   PaletteType = record
      RedLevel:   Array[0..Maxcolors-1] of byte;
      GreenLevel: Array[0..Maxcolors-1] of byte;
      BlueLevel:  Array[0..Maxcolors-1] of byte;
   end;
   FontType = record
      FontSeg       : Word;
      FontOfs       : Word;
      FontWidth     : Byte;
      FontByteWidth : Byte;
      FontHeight    : Byte;
      FontChars     : Byte;
   end;

function  MouseInstalled:boolean;
function  MouseX:word;
function  MouseY:word;
function  LeftPressed:boolean;
function  RightPressed:boolean;
procedure MouseSensetivity(x,y:word);
procedure MouseWindow(l,t,r,b:word);
procedure InitVGAMode;
function  New64KBitmap: pointer;
procedure FreeBitmap(var BmapPtr: pointer);
procedure UseBitmap(BmapPtr: pointer);
function  GetUsedBitmapAddr: pointer;
procedure CopyBitmapTo (DstBMap: pointer);
procedure CopyAreaToBitmap ( x1:word; y1:byte; x2:word; y2:byte;
	  dstbmap: pointer; DestX:word; DestY:byte);
procedure ShowUsedBitmap;
procedure FillArea(x1:word;y1:byte;x2:word;y2:byte;thecolor:byte);
procedure Cls;
procedure CCls(Thecolor : byte);
procedure CopyBitmap( SrcBMapPtr,  DstBMapPtr : pointer);
procedure ShowAllBitmap( TheBMap: pointer);
procedure ShowAreaOfBitmap ( TheBMap: Pointer; x1:word; y1:byte;
                             x2:word; y2:byte;
                             DestX:word; DestY: byte);
procedure InitOffsets;
procedure ScrollUp(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
procedure ScrollDown(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
procedure ScrollLeft(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
procedure ScrollRight(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
procedure PutPixel(x, y : integer; colorValue : Byte);
function  GetPixel(X,Y: integer): integer;
procedure Line(X1, Y1, X2, Y2:integer);
procedure LineRel(DiffX,DiffY: integer);
procedure LineTo(EndX,Endy:integer);
procedure Rectangle(x1,y1,x2,y2:integer);
procedure MoveTo(NewCursX,NewCursY:integer);
function  GetX: integer;
function  GetY: integer;
procedure PrintAt(x,y:integer; txt:string);
procedure Print(txt:string);
procedure GetAShape(x1,y1,x2,y2:word;Var DataPtr);
procedure FreeShape(DataPtr:pointer);
procedure Blit(x,y:word; Var DataPtr);
procedure ClipBlit(x,y:integer; Var DataPtr);
procedure Block(x,y:word; Var DataPtr);
procedure ClipBlock(x,y:integer; Var DataPtr);
function  BlitColl(x,y :integer; Var dataptr) : boolean;
procedure ScaleShape(var DataPtr; x1:word;y1:byte;x2:word;y2:byte);
procedure XFlipShape(Var DataPtr);
procedure YFlipShape(Var DataPtr);
function  ShapeSize(x1,y1,x2,y2:word):word;
function  ExtShapeSize(ShapeWidth, ShapeHeight : byte): word;
function  ShapeWidth(Var DataPtr): byte;
function  ShapeHeight(Var DataPtr): byte;
procedure LoadShape(FileName:String; Var DataPtr:Pointer);
procedure SaveShape(FileName:string; DataPtr:Pointer);
procedure LoadPCX(FileName:string; Var ThePalette: PaletteType);
procedure LocatePCX(filename:string; Var ThePalette: PaletteType;
          x,y,widthtoshow,heighttoshow:word);
procedure SavePCX(filename:string;ThePalette: PaletteType);
procedure SaveAreaAsPCX(filename:string;ThePalette: PaletteType;
          x,y, PCXWidth,PCXHeight: word);
function  UseFont(FontNumber:byte): boolean;
function  GetFontCharOffset(CharNum:byte): word;
function  GetCurrentFontAddress: pointer;
procedure SetNewFontAddress(NewFontPtr: pointer);
procedure GetCurrentFontSize(Var CurrFontWidth, CurrFontHeight:byte);
procedure SetFontSize(NewFontWidth, NewFontHeight:byte);
procedure LoadFont(FontFileName:String; Var FontRec: FontType);
procedure UseLoadedFont(FontRec : FontType);
procedure SaveFont(FontFileName:String; FirstChar, Numchars:byte);
procedure Usecolor(Newcolor:byte);
function  Getcolor: byte;
procedure GetRGB(colorNumber : Byte; VAR RedValue, GreenValue,
          BlueValue : Byte);
procedure SetRGB(colorNumber, RedValue, GreenValue, BlueValue : Byte);
procedure LoadPalette(FileName: String; Var Palette : PaletteType);
procedure SavePalette(FileName: String; Palette : PaletteType);
procedure CopyScreenPaletteTo(Var Palette : PaletteType);
procedure UsePalette(Palette : PaletteType);
procedure Vwait(TimeOut:word);
procedure palette(c,r,g,b:byte);
procedure Box(x1,y1,x2,y2,c:integer);
procedure put(x, y : word; Image : pointer);
procedure get(x1, y1, x2, y2 : word; var MemoryAccessVar : pointer);
procedure Button(x1, y1, x2, y2 : word);
procedure WriteAt(x, y : integer; message : string; c : byte);
procedure GetBackGround;
procedure PutBackGround;
procedure MinimizeButton(x, y : integer);
procedure ScrollUpButton(x, y : integer);
procedure PressedButton(x1, y1, x2, y2 : word);
procedure ScrollDownButton(x, y : integer);
procedure ScrollLeftButton(x, y : integer);
procedure ScrollRightButton(x, y : integer);
procedure ExitButton(x, y : integer);
procedure OkButton(x, y : integer);
procedure YesButton(x, y : integer);
procedure NoButton(x, y : integer);
procedure MousePointer;
procedure InitMouse;
procedure ShowMouse;
procedure HideMouse;
function MsgBox(title, message,message2 : string):byte;
function InputBox(title, message : string; var output : string):byte;
procedure Window(x1, y1, x2, y2: integer; title: string);
procedure WallPaper(WlpFile: string);
function ErrorBox(message : string):byte;
procedure SunkenArea(x1, y1, x2, y2: word);
procedure SetDefaultWallpaper;
procedure PlayMov(filename : string);
procedure PlayFullScreen(filename : string);
procedure DragWin(var WinBitmap : pointer; MaxX, MaxY : integer; var BackGround : pointer; var MainWinX, MainWinY : integer);
procedure ScrollBarUp(x : word; y1, y2 : byte);
procedure ScrollBarAcross(x1, x2 : word; y : byte);

implementation
uses crt, dos;
type
   Pcxheader_rec = record
      manufacturer: 	byte;
      version: 		byte;
      encoding: 		byte;
      bits_per_pixel: 	byte;
      xmin, ymin: 	word;
      xmax, ymax: 	word;
      hres: 		word;
      vres: 		word;
      palette: 		array [0..47] of byte;
      reserved:		byte;
      color_planes: 	byte;
      bytes_per_line: 	word;
      palette_type: 	word;
      filler: 		array [1..58] of byte;
   end;

var
    ScanLineOffsets:            array[0..199] of word;
    CurrentBitmapSegment:       word;
    CurrentBitmapOffset:        word;
    CurrentFontSegment:         word;
    CurrentFontOffset:          word;
    CurrentFontWidth:           byte;
    CurrentFontByteWidth:       byte;
    CurrentFontHeight:          byte;
    CurrentFontBytesPerChar:    byte;
    Currentcolor:               byte;
    CursorX:                    integer;
    CursorY:                    integer;
    header:                     Pcxheader_rec;
    x, y, x2, y2, mX, mY, x3, y3, mX2, mY2, x4, y4, col : integer;
    BackGround : array [1..6, 1..8] of byte;
    ErrorCode : byte;
    HiddenScreen : pointer;
    Image : pointer;
    WindowBitmap : pointer;

function MouseInstalled:boolean; assembler;
asm
  xor ax,ax
  int 33h
  cmp ax,-1
  je @skip
  xor al,al
@skip:
end;

function MouseX:word; assembler;
asm
  mov ax,3
  int 33h
  mov ax,cx
end;

function MouseY:word; assembler;
asm
  mov ax,3
  int 33h
  mov ax,dx
end;

function LeftPressed:boolean; assembler;
asm
  mov ax,3
  int 33h
  and bx,1
  mov ax,bx
end;

function RightPressed:boolean; assembler;
asm
  mov ax,3
  int 33h
  and bx,2
  mov ax,bx
end;

procedure MouseSensetivity(x,y:word); assembler;
asm
  mov ax,1ah
  mov bx,x
  mov cx,y
  xor dx,dx
  int 33h
end;

procedure MouseWindow(l,t,r,b:word); assembler;
asm
  mov ax,7
  mov cx,l
  mov dx,r
  int 33h
  mov ax,8
  mov cx,t
  mov dx,b
  int 33h
end;

procedure calculateoffset; near; forward;

procedure GetPtrData(pt:pointer; VAR Segm, Offs:word); Assembler;
asm
   LES DI,PT
   MOV AX,ES
   MOV BX,DI
   LES DI,Segm
   MOV [ES:DI],AX
   LES DI,Offs
   MOV [ES:DI],BX
end;

procedure InitVGAMode; Assembler;
asm
   XOR AH,AH
   MOV AL,13h
   INT 10h
end;

function New64KBitmap: pointer;
var MemoryAccessVar: pointer;
begin
     GetMem(MemoryAccessVar,64000);
     New64KBitmap:=MemoryAccessVar;
end;

procedure FreeBitmap(Var BMapPtr: pointer);
begin
     FreeMem(BMapPtr,64000);
     BMapPtr:=Nil;
end;

procedure UseBitmap(BMapPtr : pointer); Assembler;
asm
   MOV AX,WORD PTR BMapPtr[0]
   MOV CurrentBitmapOffset,AX
   MOV AX,WORD PTR BMapPtr[2]
   MOV CurrentBitmapSegment,AX
end;

function GetUsedBitmapAddr: pointer; Assembler;
asm
   MOV DX,CurrentBitmapSegment
   MOV AX,CurrentBitmapOffset

end;

procedure PostIncMove; Assembler;
asm
   DB $66; SHL CX,16
   MOV CX,AX
   CLD
   SHR CX,2
   OR CX,CX
   JZ @NoLongs
   REPZ
   DB $66; MOVSW
   DB $66; SHR CX,16
@NoLongs:
   TEST AL,2
   JZ @NoWords
   MOVSW
@NoWords:
   TEST AL,1
   JZ @NoBytes
   MOVSB
@NoBytes:
end;

procedure PreIncMove; Assembler;
asm
   STD
   CMP CX,4
   JB @CouldBeWord
   SHR CX,2
   SUB SI,3
   SUB DI,3
@MoveLong:
   DB $66; MOVSW
   DEC CX
   JNZ @MoveLong
   ADD SI,3
   ADD DI,3
   MOV CX,AX
@CouldBeWord:
   TEST AL,2
   JZ @CouldBeByte
   DEC SI
   DEC DI
   MOVSW
   INC SI
   INC DI
@CouldBeByte:
   TEST AL,1
   JZ @NoBytes
   MOVSB
@NoBytes:
end;

procedure CopyAreaToBitmap ( x1:word;y1:byte;x2:word;y2:byte;
          dstbmap : pointer; DestX:word;DestY:byte); Assembler;
asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX
     MOV AX,DestX
     XOR BH,BH
     MOV BL,DestY
     CALL CalculateOffset
     ADD BX,WORD PTR DstBMap[0]
     MOV DI,BX
     PUSH DS
     MOV ES,WORD PTR Dstbmap[2]
     MOV DS,CurrentBitmapSegment
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     DB $66; SHL BP,16
     MOV BP,SI
     MOV BX,DI
@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX
     MOV AX,CX
     CALL PostIncMove
     MOV SI,BP
     MOV DI,BX
     DEC DL
     JNZ @Outer
     DB $66; SHR BP,16
     POP DS
end;

procedure FillArea(x1:word;y1:byte;x2:word;y2:byte;thecolor:byte);
assembler;
asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV DI,BX
     MOV ES,CurrentBitmapSegment
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     MOV AL,Thecolor
     MOV AH,AL
     MOV BX,AX
     DB $66; SHL AX,16
     MOV AX,BX
     MOV SI,BP
     MOV BP,DI
     CLD
@Outer:
     ADD BP,320
     MOV BX,CX
     SHR CX,2
     OR CX,CX
     JZ @NoLongs
     REPZ
     DB $66; STOSW
     MOV CL,BL
     AND CL,3
     JZ @NoMoreBytes
@NoLongs:
     STOSB
     DEC CL
     JNZ @NoLongs
@NoMoreBytes:
     MOV CX,BX
     MOV DI,BP
     DEC DL
     JNZ @Outer
     MOV BP,SI
end;

Procedure Cls; Assembler;
asm
     MOV ES,CurrentBitmapSegment
     MOV DI,CurrentBitmapOffset
     MOV CX,4000
     DB $66
     XOR AX,AX
@ClearLoop:
     DB $66; STOSW
     DB $66; STOSW
     DB $66; STOSW
     DB $66; STOSW
     DEC CX
     JNZ @ClearLoop
end;

procedure CCls(Thecolor : byte); Assembler;
asm
   MOV ES,CurrentBitmapSegment
   MOV DI,CurrentBitmapOffset
   MOV CX,4000
   MOV AH,Thecolor
   MOV AL,AH
   MOV BX,AX
   DB $66; SHL AX,16
   MOV AX,BX
@FillLoop:
   DB $66; STOSW
   DB $66; STOSW
   DB $66; STOSW
   DB $66; STOSW
   DEC CX
   JNZ @FillLoop
end;

procedure FastCopy; Assembler;
asm
     MOV CX,2000
     CLD
@Copy:
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DEC CX
     JNZ @Copy
     MOV DS,DX
End;

procedure CopyBitmapTo(DstBmap: pointer); Assembler;
asm
   MOV DX,DS
   MOV ES,WORD PTR DstBmap[2]
   MOV DI,WORD PTR DstBmap[0]
   MOV SI,CurrentBitmapOffset
   MOV DS,CurrentBitmapSegment
   CALL FastCopy
end;

Procedure CopyBitmap( SrcBMapPtr,DstBMapPtr : pointer);
assembler;
asm
   MOV DX,DS
   MOV AX,WORD PTR DstBMapPtr[2]
   OR  AX,AX
   JNZ @UseDestBMap
   MOV DI,CurrentBitmapOffset
   MOV ES,CurrentBitmapSegment
   JMP @NowCheckDest
@UseDestBMap:
   MOV DI,WORD PTR DstBMapPtr
   MOV ES,AX
@NowCheckDest:
   MOV AX,WORD PTR SrcBMapPtr[2]
   OR AX,AX
   JNZ @UseSrcBMap
   MOV SI,CurrentBitmapOffset
   MOV DS,CurrentBitmapSegment
   JMP @DoCopy
@UseSrcBMap:
   MOV SI,WORD PTR SrcBMapPtr
   MOV DS,AX
@DoCopy:
   MOV CX,64000
   CALL FastCopy
end;

procedure ShowUsedBitmap; Assembler;
asm
   MOV AX,$a000
   MOV ES,AX
   MOV DI,0
   MOV SI,CurrentBitmapOffset
   MOV DX,DS
   MOV DS,CurrentBitmapSegment
   CALL FastCopy
end;

procedure ShowAllBitmap(TheBmap:pointer); Assembler;
asm
   MOV DX,DS
   MOV AX,$a000
   MOV ES,AX
   XOR DI,DI
   MOV AX,WORD PTR TheBMap[2]
   OR AX,AX
   JZ @UseCurrent
   MOV SI,WORD PTR TheBMap
   MOV DS,AX
   CALL FastCopy
   JMP @EndNow
@UseCurrent:
   MOV SI,CurrentBitmapOffset
   MOV DS,CurrentBitmapSegment
   CALL FastCopy
@EndNow:
end;

procedure ShowAreaOfBitmap( TheBMap: pointer; x1:word; y1:byte;
                            x2:word; y2:byte; DestX:word; DestY: byte);
assembler;
asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX
     CALL CalculateOffset
     MOV SI,BX
     MOV AX,DestX
     XOR BH,BH
     MOV BL,DestY
     CALL CalculateOffset
     MOV DI,BX
     PUSH DS
     MOV AX,$a000
     MOV ES,AX
     MOV AX,WORD PTR TheBMap[2]
     OR AX,AX
     JNZ @UseOtherBMap
     ADD SI,CurrentBitmapOffset
     MOV DS,CurrentBitmapSegment
     JMP @ContinueCalcs
@UseOtherBMap:
     ADD SI,WORD PTR TheBMap
     MOV DS,WORD PTR TheBmap[2]
@ContinueCalcs:
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     DB $66; SHL BP,16
     MOV BP,SI
     MOV BX,DI
@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX
     MOV AX,CX
     CALL PostIncMove
     MOV SI,BP
     MOV DI,BX
     DEC DL
     JNZ @Outer
     DB $66; SHR BP,16
     POP DS
end;

procedure ScrollUp(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX
     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     SUB BX,CX
     CALL CalculateOffset
     MOV DI,BX
     PUSH DS
     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     DB $66; SHL BP,16
     MOV BP,SI
     MOV BX,DI
@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX
     MOV AX,CX
     CALL PostIncMove
     MOV SI,BP
     MOV DI,BX
     DEC DL
     JNZ @Outer
     DB $66; SHR BP,16
     POP DS
End;

procedure ScrollDown(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y2
     MOV DX,BX
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX
     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     ADD BX,CX
     CALL CalculateOffset
     MOV DI,BX
     PUSH DS
     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     DB $66; SHL BP,16
     MOV BP,SI
     MOV BX,DI
@Outer:
     MOV AX,320
     SUB BP,AX
     SUB BX,AX
     MOV AX,CX
     CALL PostIncMove
     MOV SI,BP
     MOV DI,BX
     DEC DL
     JNZ @Outer
     DB $66; SHR BP,16
     POP DS
end;

procedure ScrollLeft(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX
     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     SUB AX,CX
     CALL CalculateOffset
     MOV DI,BX
     PUSH DS
     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     DB $66; SHL BP,16
     MOV BP,SI
     MOV BX,DI
@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX
     MOV AX,CX
     CALL PostIncMove
     MOV SI,BP
     MOV DI,BX
     DEC DL
     JNZ @Outer
     DB $66; SHR BP,16
     POP DS
end;

procedure ScrollRight(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
asm
     MOV AX,X2
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX
     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     ADD AX,CX
     CALL CalculateOffset
     MOV DI,BX
     PUSH DS
     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX
     MOV CX,X2
     SUB CX,X1
     INC CX
     MOV DL,Y2
     SUB DL,Y1
     INC DL
     DB $66; SHL BP,16
     MOV BP,SI
     MOV BX,DI
@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX
     MOV AX,CX
     CALL PreIncMove
     MOV SI,BP
     MOV DI,BX
     DEC DL
     JNZ @Outer
     DB $66; SHR BP,16
     POP DS
end;

procedure InitOffsets; Assembler;
asm
     XOR AX,AX
     MOV BX,OFFSET ScanLineOffsets
     MOV CL,200
@WriteOffset:
     MOV [BX],AX
     INC BX
     INC BX
     ADD AX,320
     DEC CL
     JNZ @WriteOffset
end;

procedure CalculateOffset; assembler;
asm
   CMP AX,319
   JA @InvalidCoord
   CMP BX,199
   JA @InvalidCoord
   SHL BX,1
   ADD BX,OFFSET ScanLineOffsets
   MOV BX,[BX]
   ADD BX,AX
   RET
@InvalidCoord:
   MOV BX,-1
end;

function GetPixel(X,Y: integer): integer; Assembler;
asm
   MOV AX,X
   MOV BX,Y
   CALL CalculateOffset
   CMP BX,-1
   JZ @NoGet
   ADD BX,CurrentBitmapOffset
   DB $8E, $26
   DW OFFSET CurrentBitmapSegment
   XOR AH,AH
   DB $64
   MOV AL,[BX]
   JMP @Finished
@NoGet:
   MOV AX,BX
@Finished:
end;

procedure FPutPixel; Near; Assembler;
asm
   CALL CalculateOffset
   CMP BX,-1
   JZ @NoPlot
   ADD BX,CurrentBitmapOffset
   DB $8E,$26
   DW OFFSET CurrentBitmapSegment
   DB $64
   MOV [BX],DL
@NoPlot:
end;

procedure PutPixel(x, y : integer; colorValue : Byte); Assembler;
asm
   MOV AX,x
   MOV BX,y
   MOV DL,colorValue
   CALL FPutPixel
end;

procedure Line(X1, Y1, X2, Y2: Integer); Assembler;
var
  LgDelta,
  ShDelta,
  LgStep,
  ShStep,
  Cycle : word;
asm
  MOV BX,X2
  MOV SI,X1
  SUB BX,SI
  MOV LgDelta,BX
  MOV CX,Y2
  MOV DI,Y1
  SUB CX,DI
  MOV ShDelta,CX
  TEST BH,$80
  JZ @LgDeltaPos
  NEG BX
  MOV LgDelta,BX
  MOV LgStep,-1
  JMP @Cont1
@LgDeltaPos:
  MOV LgStep,1
@Cont1:
  CMP CH,$80
  JB @ShDeltaPos
  NEG CX
  MOV ShDelta,CX
  MOV ShStep,-1
  JMP @Cont2
@ShDeltaPos:
  MOV ShStep,1
@Cont2:
  CMP BX,CX
  JB @OtherWay
  SHR BX,1
  MOV Cycle,BX
  MOV CX,X2
@FirstLoop:
  CMP SI,CX
  JZ @GetTheShitOut
  MOV AX,SI
  MOV BX,DI
  MOV DL,Currentcolor
  CALL FPutPixel
  ADD SI,LgStep
  MOV AX,Cycle
  ADD AX,ShDelta
  MOV Cycle,AX
  MOV BX,LgDelta
  CMP AX,BX
  JB @FirstLoop
  ADD DI,ShStep
  SUB Cycle,BX
  JMP @FirstLoop
@OtherWay:
  MOV AX,CX
  SHR AX,1
  MOV Cycle,AX
  XCHG BX,CX
  MOV LgDelta, BX
  MOV ShDelta, CX
  MOV AX,LgStep
  MOV BX,ShStep
  MOV ShStep,AX
  MOV LgStep,BX
  MOV CX,Y2
@SecondLoop:
  CMP DI,CX
  JZ @GetTheShitOut
  MOV AX,SI
  MOV BX,DI
  MOV DL,Currentcolor
  CALL FPutPixel
  ADD DI,LgStep
  MOV AX,Cycle
  ADD AX,ShDelta
  MOV Cycle,AX
  MOV BX,LgDelta
  CMP AX,BX
  JB @SecondLoop
  ADD SI,ShStep
  SUB Cycle,BX
  JMP @SecondLoop
@GetTheShitOut:
  MOV AX,X2
  MOV BX,Y2
  MOV DL,Currentcolor
  CALL FPutPixel
end;

procedure LineRel(DiffX,DiffY: integer); Assembler;
asm
     MOV  AX,CursorX
     MOV  BX,AX
     ADD  AX,DiffX
     PUSH AX
     MOV  AX,CursorY
     MOV  CX,AX
     ADD  AX,DiffY
     PUSH AX
     PUSH BX
     PUSH CX
     CALL Line
end;

procedure LineTo(EndX,EndY:integer); Assembler;
asm
   PUSH EndX
   PUSH EndY
   PUSH CursorX
   PUSH CursorY
   CALL Line
   MOV AX,EndX
   MOV CursorX,AX
   MOV AX,EndY
   MOV CursorY,AX
end;

procedure Rectangle(x1,y1,x2,y2:integer);
begin
     Line(x1,y1,x2,y1);
     Line(x1,y2,x2,y2);
     Line(x1,y1+1,x1,y2-1);
     Line(x2,y1+1,x2,y2-1);
end;

procedure MoveTo(NewCursX,NewCursY:integer); Assembler;
asm
   MOV AX,NewCursX
   MOV CursorX,AX
   MOV AX,NewCursY
   MOV CursorY,AX
end;

function GetX: integer; Assembler;
asm
   MOV AX,CursorX
end;

function GetY: integer; Assembler;
asm
   MOV AX, CursorY
end;

function ShapeWidth(Var DataPtr): byte; assembler;
asm
   LES DI,DataPtr
   MOV AL,[ES:DI]
end;

function ShapeHeight(Var DataPtr): byte; assembler;
asm
   LES DI,DataPtr
   MOV AL,[ES:DI+1]
end;

function ExtShapeSize(ShapeWidth, ShapeHeight : byte): word; Assembler;
asm
   MOV AL, ShapeWidth
   MOV BL, ShapeHeight
   MUL BL
   INC AX
   INC AX
end;

function ShapeSize(x1,y1,x2,y2:word):word; Assembler;
asm
   MOV AX,x2
   SUB AX,x1
   INC AX
   AND AH,$7F
   OR AH,AH
   JNZ @TooBig
   MOV BX,y2
   SUB BX,y1
   INC BX
   AND BH,$7F
   CMP BX,201
   JB @ShapeFine
@TooBig:
   XOR AX,AX
   JMP @Finished
@ShapeFine:
   MUL BL
   INC AX
   INC AX
@Finished:
end;

procedure Blit(x,y:word; Var DataPtr); Assembler;
asm
   MOV AX,x
   MOV BX,y
   CALL CalculateOffset
   MOV ES,CurrentBitmapSegment
   MOV CX,DS
   LDS SI,DataPtr
   MOV DX,[SI]
   INC SI
   INC SI
   CLD
   MOV AH,DL
@Outer:
   MOV DL,AH
   MOV DI,BX
@Main:
   LODSB
   OR AL,AL
   JZ @NoBlit
   MOV [ES:DI],AL
@NoBlit:
   INC DI
   DEC DL
   JNZ @Main
@NextScanLine:
   ADD BX,320
   DEC DH
   JNZ @Outer
   MOV DS,CX
end;

procedure Block(x,y:word; Var DataPtr); Assembler;
asm
   MOV AX,x
   MOV BX,y
   CALL CalculateOffset
   CMP BX,-1
   JZ @StupidUser
   ADD BX,CurrentBitmapOffset
   MOV DX,DS
   MOV ES,CurrentBitmapSegment
   CLD
   LDS SI,DataPtr
   MOV CX,[SI]
   INC SI
   INC SI
@Outer:
   MOV DI,BX
   MOV AL,CL
   CMP AL,4
   JB @MoveRemaining
   SHR AL,2
@CopyLong:
   DB $66
   MOVSW
   DEC AL
   JNZ @CopyLong
   TEST CL,3
   JZ @NoBytesLeft
   MOV AL,CL
   AND AL,3
@MoveRemaining:
   MOVSB
   DEC AL
   JNZ @MoveRemaining
@NoBytesLeft:
   ADD BX,320
   DEC CH
   JNZ @Outer
   MOV DS,DX
@StupidUser:
end;

procedure ClipCalculations; Near; Assembler;
asm
   CMP BX,199
   JG @NoDraw
   CMP AX,319
   JG @NoDraw
   MOV SI,DI
   INC SI
   INC SI
   XOR CH,CH
   MOV CL,[ES:DI]
   CMP AH,$80
   JB @XNotNegative
   NEG AX
   CMP AX,CX
   JA @NoDraw
   SUB CX,AX
   ADD SI,AX
   XOR AX,AX
   JMP @NowDoY
@XNotNegative:
   MOV DX,CX
   ADD DX,AX
   CMP DX,320
   JB @NowDoY
   MOV CX,320
   SUB CX,AX
@NowDoY:
   XOR DH,DH
   MOV DL,[ES:DI+1]
   MOV CH,DL
   CMP BH,$80
   JB @YNotNegative
   NEG BX
   CMP BX,DX
   JA @NoDraw
   SUB DX,BX
   MOV CH,DL
   PUSH AX
   XOR AH,AH
   MOV AL,[ES:DI]
   MUL BX
   ADD SI,AX
   POP AX
   XOR BX,BX
   JMP @NowDoBlit
@YNotNegative:
   ADD DX,BX
   CMP DX,200
   JB @NowDoBlit
   MOV DX,200
   SUB DX,BX
   MOV CH,DL
@NowDoBlit:
   PUSH CX
   CALL CalculateOffset
   POP CX
   ADD BX,CurrentBitmapOffset
   XOR DH,DH
   MOV DL,[ES:DI]
   MOV DI,BX
   CLC
   JMP @End
@NoDraw:
   STC
@End:
end;

procedure ClipBlit(x,y:integer; Var DataPtr); Assembler;
asm
   MOV AX,X
   MOV BX,Y
   LES DI,DataPtr
   CALL ClipCalculations
   JC @NoDraw
   MOV AX,DS
   DB $66; SHL AX,16
   DB $66; SHL BP,16
   MOV AX,CurrentBitmapSegment
   MOV BX,ES
   MOV DS,BX
   MOV ES,AX
   MOV BX,SI
   MOV BP,DI
   MOV AH,CL
   CLD
@Outer:
   MOV CL,AH
   MOV SI,BX
   MOV DI,BP
@WriteByte:
   LODSB
   OR AL,AL
   JZ @NoBlit
   MOV [ES:DI],AL
@NoBlit:
   INC DI
   DEC CL
   JNZ @WriteByte
   ADD BX,DX
   ADD BP,320
   DEC CH
   JNZ @Outer
   DB $66; SHR BP,16
   DB $66; SHR AX,16
   MOV DS,AX
@NoDraw:
end;

procedure ClipBlock(x,y:integer; Var DataPtr); Assembler;
asm
   MOV AX,X
   MOV BX,Y
   LES DI,DataPtr
   CALL ClipCalculations
   JC @NoDraw
   PUSH DS
   PUSH BP
   MOV AX,CurrentBitmapSegment
   MOV BX,ES
   MOV DS,BX
   MOV ES,AX
   MOV BX,SI
   MOV BP,DI
   CLD
@Outer:
   MOV AL,CL
   MOV SI,BX
   MOV DI,BP
   CMP AL,4
   JB @MoveRemaining
   SHR AL,2
@CopyLong:
   DB $66
   MOVSW
   DEC AL
   JNZ @CopyLong
   TEST CL,3
   JZ @NoBytesLeft
   MOV AL,CL
   AND AL,3
@MoveRemaining:
   MOVSB
   DEC AL
   JNZ @MoveRemaining
@NoBytesLeft:
   ADD BX,DX
   ADD BP,320
   DEC CH
   JNZ @Outer
   POP BP
   POP DS
@NoDraw:
end;

procedure GetAShape(x1,y1,x2,y2:word;Var DataPtr); Assembler;
asm
   MOV AX,x1
   MOV BX,y1
   CALL CalculateOffset
   CMP BX,-1
   JZ @StupidUser
   ADD BX,CurrentBitmapOffset
   MOV AX,x2
   SUB AX,x1
   INC AX
   MOV CL,AL
   MOV AX,y2
   SUB AX,y1
   INC AX
   MOV CH,AL
   LES DI,DataPtr
   MOV [ES:DI],CX
   INC DI
   INC DI
   MOV DX,DS
   MOV DS,CurrentBitmapSegment
   CLD
@Outer:
   MOV SI,BX
   MOV AL,CL
   CMP AL,4
   JB @MoveRemaining
   SHR AL,2
@CopyLong:
   DB $66
   MOVSW
   DEC AL
   JNZ @CopyLong
   TEST CL,3
   JZ @NoBytesLeft
   MOV AL,CL
   AND AL,3
@MoveRemaining:
   MOVSB
   DEC AL
   JNZ @MoveRemaining
@NoBytesLeft:
   ADD BX,320
   DEC CH
   JNZ @Outer
   DB $66; SHR AX,16
   MOV DS,DX
@StupidUser:
end;

function BlitColl(x,y :integer; Var dataptr) : boolean; Assembler;
asm
   MOV AX,x
   MOV BX,y
   CALL CalculateOffset
   ADD BX,CurrentBitmapOffset
   MOV ES,CurrentBitmapSegment
   PUSH DS
   DB $66; SHL BP,16
   LDS SI,DataPtr
   MOV DX,[SI]
   INC SI
   INC SI
   CLD
   MOV CL,DL
@Outer:
   MOV DI,BX
   MOV DL,CL
   CMP DL,4
   JB @CantCheckLong
   SHR DL,2
@CheckLong:
   DB $66; LODSW
   DB $66; OR AX,AX
   JZ @NoCheckBackLong
   DB $66
   MOV BP,AX
   DB $66
   XOR AX,[ES:DI]
   DB $66
   CMP BP,AX
   JNZ @CollisionOccurred
@NoCheckBackLong:
   ADD DI,4
   DEC DL
   JNZ @CheckLong
   MOV DL,CL
   AND DL,3
@CantCheckLong:
   CMP DL,2
   JB @CantCheckWord
@CheckWord:
   LODSW
   OR AX,AX
   JZ @CantCheckWord
   MOV BP,AX
   XOR AX,[ES:DI]
   CMP BP,AX
   JNZ @CollisionOccurred
   ADD DI,2
@CantCheckWord:
   TEST CL,1
   JZ @AllChecksDone
   LODSB
   OR AL,AL
   JZ @AllChecksDone
   MOV CH,AL
   XOR AL,[ES:DI]
   CMP CH,AL
   JNZ @CollisionOccurred
@AllChecksDone:
   ADD BX,320
   DEC DH
   JNZ @Outer
   MOV AL,False
   JMP @Exit
@CollisionOccurred:
   MOV AL,True
@Exit:
   DB $66; SHR BP,16
   POP DS
end;

procedure ScaleShape(var DataPtr; x1:word;y1:byte;x2:word;y2:byte);
assembler;
type
  fixed = record
    case boolean of
      true  : (w : longint);
      false : (f, i : word);
    end;
var
  x,y        : word;
  s, w, h    : word;
  sx, sy, cy : fixed;
asm
     MOV SI, WORD PTR DataPtr
     MOV ES, WORD PTR DataPtr+2
     XOR AH,AH
     MOV AL,[ES:SI]
     MOV x,AX
     INC SI
     MOV AL,[ES:SI]
     MOV y,AX
     INC SI
     MOV AX,x1
     XOR BH,BH
     MOV BL,y1
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV DI,BX
     MOV BX,x2
     XCHG AX,BX
     SUB AX,BX
     INC AX
     MOV CX,AX
     MOV w,AX
     MOV AX,320
     SUB AX,CX
     MOV s,AX
     XOR DX,DX
     INC DL
     XOR AX,AX
     DIV CX
     MUL x
     MOV WORD [sx.w],AX
     MOV WORD [sx.w+2],DX
     XOR AH,AH
     MOV AL,y2
     SUB AL,y1
     INC AL
     MOV h,AX
     MOV BX,AX
     XOR DX,DX
     INC DL
     XOR AX,AX
     DIV BX
     MUL y
     MOV WORD [sy.w],AX
     MOV WORD [sy.w+2],DX
     DB $66; XOR AX,AX
     DB $66; MOV WORD PTR cy.w, AX
     PUSH DS
     MOV AX,ES
     MOV ES,CurrentBitmapSegment
     MOV DS,AX
    cld
@L2:
    MOV AX,SI
    DB $66; SHL SI,16
    MOV SI,AX
    MOV  AX, cy.i
    MUL  X
    ADD  SI,AX
    MOV  AX,CX
    DB $66; shl CX,16
    MOV  CX, AX
    XOR  BX, BX
    MOV  DX, sx.f
@L:
    MOV AL,[SI]
    STOSB
    ADD  BX, DX
    ADC  SI, sx.i
    DEC CX
    JNZ @L
    DB $66; SHR SI,16
    DB $66; SHR CX,16
    ADD  DI, s
    DB $66; MOV  AX, sy.f
    DB $66; ADD  cy.f, AX
    DEC  WORD PTR h
    JNZ  @L2
    POP  DS
end;

procedure XFlipShape(Var DataPtr); Assembler;
asm
     PUSH DS
     LDS SI,DataPtr
     XOR DH,DH
     MOV DL,[SI]
     MOV CL,DL
     INC SI
     MOV CH,[SI]
     INC SI
     MOV DI,SI
     ADD DI,DX
     CMP CL,4
     JB @SmallShape
     SUB DI,2
     SHR CL,2
@Outer:
     MOV AX,SI
     DB $66; SHL SI,16
     MOV SI,AX
     MOV AX,DI
     DB $66; SHL DI,16
     MOV DI,AX
@SwapBytes:
     MOV AX,[SI]
     XCHG AL,AH
     MOV BX,[DI]
     XCHG BL,BH
     MOV [SI],BX
     MOV [DI],AX
     INC SI
     INC SI
     DEC DI
     DEC DI
     DEC CL
     JNZ @SwapBytes
     CMP DI,SI
     JB @NoMiddleByte
     INC DI
     MOV AL,[SI]
     XCHG AL,[DI]
     MOV [SI],AL
@NoMiddleByte:
     DB $66; SHR SI,16
     DB $66; SHR DI,16
     MOV CL,DL
     SHR CL,2
     ADD SI,DX
     ADD DI,DX
     DEC CH
     JNZ @Outer
     JMP @ExitProg
@SmallShape:
     DEC DI
@Outer2:
     MOV AL,[SI]
     MOV AH,[DI]
     MOV [DI],AL
     MOV [SI],AH
     ADD SI,DX
     ADD DI,DX
     DEC CH
     JNZ @Outer2
@ExitProg:
     POP DS
end;

procedure YFlipShape(Var DataPtr); Assembler;
asm
   PUSH DS
   LDS SI,DataPtr
   DB $66; SHL BP,16
   MOV AX,[SI]
   INC SI
   INC SI
   XOR DH,DH
   MOV DL,AL
   MOV CH,AH
   SHR CH,1
   DEC AH
   MUL AH
   ADD AX,SI
   MOV DI,AX
@Outer:
   MOV BP,SI
   ADD BP,DX
   MOV BX,DI
   SUB BX,DX
   MOV CL,DL
   CMP CL,4
   JB @NoLongsToSwap
   SHR CL,2
@SwapLong:
   DB $66; MOV AX,[SI]
   DB $66; XCHG AX,[DI]
   DB $66; MOV [SI],AX
   ADD SI,4
   ADD DI,4
   DEC CL
   JNZ @SwapLong
   MOV CL,DL
   AND CL,3
   OR CL,CL
   JZ @NoMoreSwaps
@NoLongsToSwap:
   MOV AL,[SI]
   XCHG AL,[DI]
   MOV [SI],AL
   INC SI
   INC DI
   DEC CL
   JNZ @NoLongsToSwap
@NoMoreSwaps:
   MOV SI,BP
   MOV DI,BX
   DEC CH
   JNZ @Outer
   DB $66; SHR BP,16
   POP DS
end;

procedure FreeShape(DataPtr:pointer);
var ImWidth,
    ImHeight: byte;
begin
   asm
      LES DI,DataPtr
      MOV AX,[ES:DI]
      MOV ImWidth,AL
      MOV ImHeight,AH
   end;
   FreeMem(DataPtr,ExtShapeSize(ImWidth,ImHeight));
end;

procedure LoadShape(FileName:String; Var DataPtr: Pointer);
type ShapeHeader = record
        ShapeWidth  : byte;
        ShapeHeight : byte;
     end;
var F            : File;
    ShapeBuf     : ShapeHeader;
    DestSeg      : word;
    DestOffset   : word;
    ImgSize      : word;
begin
     Assign(F,FileName);
     {$i-}
     Reset(F,1);
     {$i+}
     if IoResult = 0 then
     begin
        BlockRead(F,shapebuf,sizeof(shapeheader));
        ImgSize:= ExtShapeSize( ShapeBuf.ShapeWidth,
                                ShapeBuf.ShapeHeight);
        if ImgSize < MaxAvail then
        begin
           GetMem(DataPtr,ImgSize);
	   GetPtrData(DataPtr,DestSeg,DestOffset);
           Reset(F,1);
           BlockRead(F,Mem[DestSeg:DestOffset], ImgSize);
           Close(F);
        end
        else
        begin
            Writeln('Error: Not enough memory to load shape ',FileName,'.');
	    Halt(1);
	end;
     end
     else
     begin
         Writeln('Error: Couldn''t find shape file ',FileName,'.');
         Halt(1);
     end;
end;

procedure SaveShape(FileName:string; DataPtr:Pointer);
var F: File;
    SourceSeg, SourceOffset: word;
begin
     Assign(F,FileName);
     Rewrite(F,1);
     GetPtrData(DataPtr,SourceSeg,SourceOffset);
     BlockWrite(F, Mem[SourceSeg:SourceOffset],
                   ExtShapeSize(mem[SourceSeg:SourceOffset],
                   mem[SourceSeg:SourceOffset+1]));
     Close(F);
end;

procedure LocatePCX(filename:string; Var ThePalette: PaletteType;
          x,y,widthtoshow,heighttoshow:word);
var
    PCXFile: file;
    ReadingFromMem : Boolean;
    MemRequired : longint;
    BytesRead : longint;
    PCXFileSize : longint;
    Count : integer;
    RedVal : byte;
    GreenVal : byte;
    BlueVal : byte;
    MemoryAccessVar : pointer;
    BufferSeg, BufferOffset : word;
    SrcBmapOffs : word;
    Width,Height, N,Bytes : word;
    RunLength, c : byte;
    PastHorizontalLimit : boolean;
begin
    assign(PCXFile,FileName);
    {$i-}
    reset (PCXFile,1);
    {$i+}
    if IOResult = 0 then
    begin
       blockread (PCXFile, header, sizeof (header));
       if (header.manufacturer=10) and (header.version=5) and
          (header.bits_per_pixel=8) and (header.color_planes=1) then
          begin
               seek (PCXFile, filesize (PCXFile)-769);
	       blockread (PCXFile, c, 1);
               if (c=12) then
               begin
                  for Count:=0 to 255 do
                  begin
                     BlockRead(PCXFile,RedVal,1);
                     BlockRead(PCXFile,GreenVal,1);
                     BlockRead(PCXFile,BlueVal,1);
                     ThePalette.RedLevel[Count]:=RedVal SHR 2;
                     ThePalette.GreenLevel[Count]:=GreenVal SHR 2;
                     ThePalette.BlueLevel[Count]:=BlueVal SHR 2;
                  end;
                  seek (PCXFile, 128);
                  MemRequired:=Filesize(PCXFile)-897;
                  PCXFileSize:=MemRequired;
                  BytesRead:=0;
                  if (MemRequired < 65528) And (MaxAvail > MemRequired) then
                  begin
                     getmem(MemoryAccessVar,MemRequired);
                     GetPtrData(MemoryAccessVar, BufferSeg, BufferOffset);
                     BlockRead(PCXFile,Mem[BufferSeg:BufferOffset],MemRequired);
		     ReadingFromMem:=True;
                  end
                  else
                  if (MaxAvail > 65527) then
                  begin
                     GetMem(MemoryAccessVar,65528);
                     GetPtrData(MemoryAccessVar, BufferSeg, BufferOffset);
                     BlockRead(PCXFile,Mem[BufferSeg:BufferOffset],65528);
                     BytesRead:=65528;
                     MemRequired:=65528;
		     ReadingFromMem:=True;
                  end
                  else
                  ReadingFromMem:=False;
                  with Header Do
                  begin
		     width:=(xmax - xmin)+1;
                     height:=(ymax - ymin)+1;
                     bytes:=bytes_per_line;
                  end;
		  if widthtoshow > width then widthtoshow:=width;
                  if (widthtoshow + x) > 320 then widthtoshow:=width-x;
                  if heighttoshow > height then heighttoshow:=height;
                  if (heighttoshow + y)> 200 then heighttoshow:=height-y;
                  for Count:=0 to (heighttoshow-1) do
		  begin
                      n:=0;
                      PastHorizontalLimit:=False;
                      SrcBmapOffs:= CurrentBitmapOffset+((Y+Count)* 320)+X;
                      while (n<bytes) do
                      begin
                           if N >= WidthToShow then PastHorizontalLimit:=True;
                           if ReadingFromMem then
                           begin
			       c:=Mem[BufferSeg:BufferOffset];
                               Inc(BufferOffset);
                               if BufferOffset = 65528 then
                                  begin
                                  if (PCXFileSize - BytesRead)> 65527 then
                                     begin
                                        BlockRead(PCXFile,Mem[BufferSeg:0],65528);
                                        Inc(BytesRead,65528);
				     end
                                  else
				  begin
                                     BlockRead(PCXFile,Mem[BufferSeg:0],
                                     (PCXFileSize - BytesRead));
                                  end;
                                  BufferOffset:=0;
                               end;
                           end
                           else BlockRead(PCXFile,c,1);
                           if ((c and 192)=192) then
                           begin
                               RunLength:=c and 63;
                               if ReadingFromMem then
                               begin
				  c:=Mem[BufferSeg:BufferOffset];
                                  Inc(BufferOffset);
                                  if BufferOffset = 65528 then
                                  begin
                                     if (PCXFileSize - BytesRead)> 65527 then
                                        begin
                                           BlockRead(PCXFile,Mem[BufferSeg:0],65528);
                                           Inc(BytesRead,65528);
                                        end
                                     else
                                     begin
                                        BlockRead(PCXFile,Mem[BufferSeg:0], (PCXFileSize - BytesRead));
                                     end;
                                     BufferOffset:=0;
                                  end;
                               end
                               else
                                   BlockRead(PCXFile,c,1);
                               if Not PastHorizontalLimit then
                               begin
                                  if n+RunLength > widthtoshow
                                  then fillchar(Mem[CurrentBitmapSegment:SrcBmapOffs],WidthToShow-n,c)
				  else fillchar(Mem[CurrentBitmapSegment:SrcBmapOffs],RunLength,c);
                                  inc(SrcBmapOffs,RunLength);
                               end;
                               inc(n,RunLength);
			       end
                            else
                                begin
                                if Not PastHorizontalLimit then
                                   begin
				   mem [CurrentBitmapSegment:SrcBmapOffs]:=c;
                                   inc (SrcBmapOffs);
                                end;
                                inc (n);
			    end;
                      end;
                  end;
                  if ReadingFromMem then freemem(MemoryAccessVar,MemRequired);
              end
          else
              begin
                 ErrorCode:=3;
              end;
          end
       else
           begin
           ErrorCode:=2;
       end;
       close (PCXFile);
       end
       else ErrorCode:=1;
end;

procedure LoadPCX(FileName:string; Var ThePalette: PaletteType);
begin
     LocatePCX(Filename,ThePalette,0,0,320,200);
end;

procedure SaveAreaAsPCX(filename:string;ThePalette: PaletteType;
          x,y, PCXWidth,PCXHeight: word);
var
    f: File;
    colorMapID: byte;
    colorCount: byte;
    RedValue: byte;
    GreenValue: byte;
    BlueValue: byte;
    LastOffset: word;
    SrcBmapOffs: word;
    VerticalCount: byte;
    LastByte : byte;
    NewByte: byte;
    RunLength : byte;
    ByteCount: word;
begin
     {$i-}
     Assign(f,filename);
     Rewrite(f,1);
     with header do
     begin
          Manufacturer := 10;
          Version := 5;
          Encoding :=0;
	  Bits_per_pixel:=8;
          XMin:=0;
          YMin:=0;
	  if (PCXwidth + x) > 320 then PCXwidth:=320-x;
          if (PCXheight+ y) > 200 then PCXheight:=200-y;
          XMax:=(PCXWidth-1);
          YMax:=(PCXHeight-1);
	  Hres:=320;
          VRes:=200;
          color_planes:=1;
          Bytes_per_line:=PCXWidth;
	  Palette_type:=12;
     end;
     BlockWrite(F,Header,SizeOf(Header));
     asm
        MOV AX,X
        MOV BX,Y
        CALL CalculateOffset
        MOV SrcBmapOffs,BX
     end;
     for VerticalCount:=0 to PCXHeight-1 do
     begin
          LastOffset:=SrcBmapOffs;
          ByteCount:=0;
          LastByte:=0;
          Repeat
                NewByte:=Mem[CurrentBitmapSegment:SrcBmapOffs];
                if NewByte = LastByte then
                   begin
                   RunLength:=0;
                   while (NewByte = LastByte) and (RunLength < 63)
                      and (ByteCount <> PCXWidth) do
                      begin
                      Inc(RunLength);
                      Inc(ByteCount);
                      Inc(SrcBmapOffs);
                      NewByte:=Mem[CurrentBitmapSegment:SrcBmapOffs];
                   end;
                   asm
                      OR Byte Ptr RunLength, 192
                   end;
                   BlockWrite(f,RunLength,1);
                   BlockWrite(f,LastByte,1);
                   LastByte:=NewByte;
                   end
                else
		   if (NewByte > 191) then
                       begin
                          Inc(ByteCount);
                          Inc(SrcBmapOffs);
		          RunLength:=193;
		          BlockWrite(f,RunLength,1);
		          BlockWrite(f,NewByte,1);
		          LastByte:=NewByte;
		       end
		   else
		       begin
                          Inc(ByteCount);
                          Inc(SrcBmapOffs);
                          BlockWrite(f,NewByte,1);
                          LastByte:=NewByte;
                       end;
          until ByteCount = PCXWidth;
          SrcBmapOffs:=LastOffset+320;
     end;
     colorMapID:=12;
     BlockWrite(f,colorMapID,1);
     for colorCount:=0 to 255 do
     begin
         RedValue:=ThePalette.   RedLevel[colorCount] SHL 2;
	 GreenValue:=ThePalette. GreenLevel[colorCount] SHL 2;
         BlueValue:=ThePalette.  BlueLevel[colorCount] SHL 2;
	 BlockWrite(F,RedValue,1);
         BlockWrite(F,GreenValue,1);
         BlockWrite(F,BlueValue,1);
     end;
     Close(F);
     {$i+}
     if IOresult<>0 then ErrorCode:= 1;
end;

procedure SavePCX(filename:string;ThePalette: PaletteType);
begin
     SaveAreaAsPCX(filename,ThePalette,0,0,320,200);
end;

function UseFont(FontNumber:byte): boolean; Assembler;
asm
     MOV AX,$1130
     MOV BH,FontNumber
     CMP BH,7
     JA @NoWriteSize
     PUSH BP
     PUSH BX
     INT $10
     MOV CurrentFontSegMent,ES
     MOV CurrentFontOffset,BP
     POP BX
     POP BP
     CMP BH,Int1fFont
     JZ @NoWriteSize
     CMP BH,StandardVGAFont
     JZ @Set8x8
     CMP BH,Font8x8dd
     JZ @Set8x8
     CMP BH,Font8x8ddHigh
     JZ @Set8x8
     CMP BH,AlphaAlternateFont
     JNZ @Check8x14Font
@Set8x8:
     MOV AL,8
     MOV AH,8
     JMP @DoWrite
@Check8x14Font:
     CMP BH,Font8x14
     JNZ @Check8x16Font
     MOV AL,8
     MOV AH,14
     JMP @DoWrite
@Check8x16Font:
     CMP BH,Font8x16
     JNZ @UseRomAlternateFont
     MOV AL,8
     MOV AH,16
     JMP @DoWrite
@UseRomAlternateFont:
     MOV AL,9
     MOV AH,16
@DoWrite:
     MOV CurrentFontWidth,AL
     MOV CurrentFontHeight,AH
     SHR AL,3
     MOV CurrentFontByteWidth,AL
     MUL AH
     MOV CurrentFontBytesPerChar,AL
     MOV AL,True
     JMP @NowExit
@NoWriteSize:
     MOV AL,False
@NowExit:
end;

function GetCurrentFontAddress: pointer; Assembler;
asm
   MOV DX,CurrentFontSegment
   MOV AX,CurrentFontOffset
end;

procedure SetNewFontAddress(NewFontPtr: pointer); Assembler;
asm
   MOV AX,WORD PTR NewFontPtr[2]
   MOV CurrentFontSegment,AX
   MOV AX,WORD PTR NewFontPtr
   MOV CurrentFontOffset,AX
end;

procedure GetCurrentFontSize(Var CurrFontWidth, CurrFontHeight:byte); Assembler;
asm
   MOV AL,CurrentFontWidth
   MOV AH,CurrentFontHeight
   LES DI,CurrFontWidth
   MOV [ES:DI],AL
   LES DI,CurrFontHeight
   MOV [ES:DI],AH
end;

procedure SetFontSize(NewFontWidth, NewFontHeight:byte); Assembler;
asm
     MOV AL,NewFontWidth
     MOV AH,NewFontHeight
     CMP AL,8
     JB @IllegalSize
     OR AH,AH
     JZ @IllegalSize
     MOV CurrentFontWidth,AL
     MOV CurrentFontHeight,AH
     SHR AL,3
     MOV CurrentFontByteWidth,AL
     MUL AH
     MOV CurrentFontBytesPerChar,AL
     JMP @ExitNow
@IllegalSize:
     XOR AL,AL
     MOV BYTE PTR CurrentFontWidth,0
     MOV BYTE PTR CurrentFontHeight,0
@ExitNow:
end;

function GetFontCharOffset(CharNum:byte): word; assembler;
asm
   MOV AL,CharNum
   MOV BH,CurrentFontByteWidth
   MOV BL,CurrentFontHeight
   MUL BL
   MOV BL,BH
   XOR BH,BH
   MUL BX
   ADD AX,CurrentFontOffset
end;

procedure LoadFont(FontFileName:String; Var FontRec: FontType);
var
    FontFile : File;
    BytesToReserve : word;
    FontPtr : Pointer;
begin
     Assign(FontFile,FontFileName);
     {$i-}
     Reset(FontFile,1);
     {$i+}
     if IoResult = 0  then
     begin
        BlockRead(FontFile,FontRec,SizeOf(FontRec));
        with FontRec do
        begin
             BytesToReserve:=FontChars * (FontByteWidth * FontHeight);
             GetMem(FontPtr,BytesToReserve);
             GetPtrData(FontPtr,FontSeg,FontOfs);
             BlockRead(FontFile,Mem[FontSeg:FontOfs],BytesToReserve);
        end;
	Close(FontFile);
     end
     else
     begin
         Writeln('Error: Couldn''t load font file ',FontFileName,'.');
         Halt(1);
     end;
end;

procedure SaveFont(FontFileName:String; FirstChar, Numchars:byte);
var
    TempFontRec     : FontType;
    FontFile        : File;
    BytesPerChar    : word;
    FirstCharOffset : word;
begin
     with TempFontRec do
     begin
          FontSeg:=0;
          FontOfs:=0;
          FontByteWidth:=CurrentFontByteWidth;
          FontWidth:=CurrentFontWidth;
          FontHeight:=CurrentFontHeight;
          FontChars:=NumChars;
     end;
     Assign(FontFile,FontFileName);
     Rewrite(FontFile,1);
     BlockWrite(FontFile,TempFontRec,SizeOf(TempFontRec));
     BytesPerChar:=CurrentFontByteWidth * CurrentFontHeight;
     FirstCharOffset:=CurrentFontOffset+(FirstChar * BytesPerChar);
     BlockWrite(FontFile, Mem[CurrentFontSegment:FirstCharOffset],
     NumChars * BytesPerChar);
     Close(FontFile);
end;

procedure UseLoadedFont(FontRec : FontType);
begin
     with FontRec do
     begin
	  CurrentFontSegment:=FontSeg;
	  CurrentFontOffset:=FontOfs;
	  SetFontSize(FontWidth,FontHeight);
     end;
end;

procedure PrintAt(x,y: integer; txt:string); Assembler;
var
    Chars   : byte;
    TextSeg : word;
    Currx   : word;
asm
   les si,txt
   mov textseg,es
   mov al,[es:si]
   mov chars,al
   inc si
@GetNextChar:
   mov es,textseg
   mov al, [es:si]
   inc si
   mul byte ptr currentfontbytesperchar
   mov di, currentfontoffset
   add di,ax
   mov es,currentfontsegment
   mov dl,currentcolor
   mov bx,y
   mov ch,currentfontheight
@downloop:
   mov cl,currentfontbytewidth
   mov ax,x
@acrossloop:
   mov dh,8
   push cx
   mov cl,[es:di]
@bitsloop:
   test cl,$80
   jz @noplot
   push bx
   call FPutPixel
   pop bx
@noplot:
   shl cl,1
   inc ax
   dec dh
   jnz @bitsloop
   inc di
   pop cx
   dec cl
   jnz @acrossloop
   inc bx
   dec ch
   jnz @downloop
   clc
   mov ax,x
   add al,currentfontwidth
   adc ah,0
   mov x,ax
   dec byte ptr chars
   jnz @getnextchar
end;

procedure Print(txt:string);
begin
     PrintAt(CursorX,CursorY,txt);
end;

procedure GetRGB(colorNumber : Byte; var RedValue, GreenValue, BlueValue : Byte); Assembler;
asm
   MOV DX,$3C7
   MOV AL,colorNumber
   SUB AL,1
   OUT DX,AL
   ADD DL,2
   IN AL,DX
   LES DI,RedValue
   MOV [ES:DI],AL
   IN AL,DX
   LES DI,GreenValue
   MOV [ES:DI],AL
   IN AL,DX
   LES DI,BlueValue
   MOV [ES:DI],AL
   IN AL,DX
   LES DI,RedValue
   MOV [ES:DI],AL
   IN AL,DX
   LES DI,GreenValue
   MOV [ES:DI],AL
   IN AL,DX
   LES DI,BlueValue
   MOV [ES:DI],AL
end;

procedure SetRGB(colorNumber, RedValue, GreenValue, BlueValue : Byte); Assembler;
asm
   MOV AL,colorNumber
   MOV DX,$3c8
   OUT DX,AL
   INC DL
   MOV AL,RedValue
   OUT DX,AL
   MOV AL,GreenValue
   OUT DX,AL
   MOV AL,BlueValue
   OUT DX,AL
end;

procedure CopyScreenPaletteTo(Var Palette : PaletteType);
var
   colorCount:byte;
begin
   for colorCount:=0 to (Maxcolors - 1) do
   GetRGB(colorCount,Palette.RedLevel[colorCount], Palette.GreenLevel[colorCount],Palette.BlueLevel[colorCount]);
end;

procedure LoadPalette(FileName: String; Var Palette : PaletteType);
var
   PaletteFile: File;
begin
   Assign(PaletteFile,FileName);
   {$i-}
   Reset(PaletteFile,1);
   {$i+}
   if IoResult = 0 then
   begin
      BlockRead(PaletteFile,Palette,SizeOf(Palette));
      Close(PaletteFile);
   end
   else
   begin
      Writeln('Error: Couldn''t load palette file ',FileName,'.');
      Halt(1);
   end;
end;

procedure SavePalette(FileName: String; Palette : PaletteType);
var
   PaletteFile: File;
begin
   Assign(PaletteFile,FileName);
   Rewrite(PaletteFile,1);
   BlockWrite(PaletteFile,Palette,SizeOf(Palette));
   Close(PaletteFile);
end;

procedure UsePalette(Palette : PaletteType); Assembler;
asm
   PUSH DS
   LDS BX, Palette
   XOR AL,AL
   MOV DX,$3c8
   OUT DX,AL
   INC DL
   MOV CX,Maxcolors
   MOV SI,BX
   ADD SI,Maxcolors
   MOV DI,SI
   ADD DI,Maxcolors
@WritePaletteInfo:
   MOV AL, [BX]
   OUT DX,AL
   MOV AL, [SI]
   OUT DX,AL
   MOV AL, [DI]
   OUT DX,AL
   INC DI
   INC BX
   INC SI
   DEC CX
   JNZ @WritePaletteInfo
   POP DS
end;

procedure Usecolor(Newcolor:byte); Assembler;
asm
    MOV AL,Newcolor
    MOV Currentcolor,AL
end;

function Getcolor: byte; Assembler;
asm
   MOV AL, Currentcolor;
end;

procedure Vwait(TimeOut:word); Assembler;
asm
   MOV CX,TimeOut
   MOV DX,$03DA
@WaitRetraceEnd:
   IN  AL,DX
   TEST AL,$08
   JZ @WaitRetraceEnd
@WaitRetraceStart:
   IN  AL,DX
   TEST AL,$08
   JNZ @WaitRetraceStart
   DEC CX
   JNZ @WaitRetraceEnd
end;

procedure palette(c,r,g,b:byte); assembler; asm
  mov dx,03c8h; mov al,c; out dx,al; inc dx; mov al,r
  out dx,al; mov al,g; out dx,al; mov al,b; out dx,al end;

procedure Box(x1,y1,x2,y2,c:integer);
var
  x, y, tempvar : integer;
  memcol : array [0..319] of byte;
begin
   if x1>x2 then
   begin
      TempVar:= x1;
      x1:= x2;
      x2:= TempVar;
   end;
   if x1<0 then x1:=0;
   if y1<0 then y1:=0;
   if x2<0 then x2:=0;
   if x2>319 then x2:=319;
   if y2<0 then y2:=0;
   if y2>199 then y2:=199;
   for x:=0 to 319 do memcol[x]:=c;
   for y:=y1 to y2 do
   begin
      move(memcol, mem[CurrentBitmapSegment:CurrentBitmapOffset+x1+y*320], x2-x1+1);
   end;
end;

procedure put(x, y : word; Image : pointer);
var x2, y2, ImageSegment, ImageOffset, width, height : word;
begin
   ImageSegment:=seg(Image^);
   ImageOffset:=ofs(Image^);
   move(mem[ImageSegment:ImageOffset], width,  2);
   ImageOffset:=ImageOffset+2;
   move(mem[ImageSegment:ImageOffset],height , 2);
   ImageOffset:=ImageOffset+2;
   for y2:=y to y+height-1 do
   begin
      move(mem[ImageSegment:ImageOffset], mem[CurrentBitmapSegment:CurrentBitmapOffset+(x)+(y2*320)], width);
      ImageOffset:=ImageOffset+width;
   end;
end;

procedure get(x1, y1, x2, y2 : word; var MemoryAccessVar : pointer);
var x, y, ImageSegment, ImageOffset, width, height : word;
begin
   if MemoryAccessVar<>nil then
   begin
      ImageSegment:=seg(MemoryAccessVar^);
      ImageOffset:=ofs(MemoryAccessVar^);
      move(mem[ImageSegment:ImageOffset], width,  2);
      ImageOffset:=ImageOffset+2;
      move(mem[ImageSegment:ImageOffset],height , 2);
      ImageOffset:=ImageOffset+2;
      FreeMem(MemoryAccessVar,width*height+4);
   end;
   width:=(x2-x1+1); height:=(y2-y1+1);
   GetMem(MemoryAccessVar,width*height+4);
   ImageSegment:=seg(MemoryAccessVar^);
   ImageOffset:=ofs(MemoryAccessVar^);
   move(width, mem[ImageSegment:ImageOffset], 2);
   ImageOffset:=ImageOffset+2;
   move(height, mem[ImageSegment:ImageOffset], 2);
   ImageOffset:=ImageOffset+2;
   for y:=y1 to y2 do
   begin
      move(mem[CurrentBitmapSegment:CurrentBitmapOffset+(x1)+(y*320)], mem[ImageSegment:ImageOffset], width);
      ImageOffset:=ImageOffset+width;
   end;
end;

procedure WriteAt(x, y : integer; message : string; c : byte);
var
   count : integer;
   OldX : integer;
begin
   Usecolor(c);
   OldX:=x;
   for count:= 1 to Length(message) do
   begin
      MoveTo(x, y);
      case message[count] of
         ' ' : x:= x+4;
         'A', 'a' : begin
                       Line(x, y+1, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y+1, x+2, y+4);
                       x:= x+4;
                    end;
         'B', 'b' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+1);
                       Line(x+2, y+3, x+2, y+4);
                       x:= x+4;
                    end;
         'C', 'c' : begin
                       Line(x, y+1, x, y+3);
                       Line(x+1, y, x+2, y);
                       Line(x+1, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'D', 'd' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y+1, x+2, y+3);
                       x:= x+4;
                    end;
         'E', 'e' : begin
                       Line(x, y, x, y+4);
                       Line(x+1, y, x+2, y);
                       PutPixel(x+1, y+2, c);
                       Line(x+1, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'F', 'f' : begin
                       Line(x, y, x, y+4);
                       Line(x+1, y, x+2, y);
                       PutPixel(x+1, y+2, c);
                       x:= x+4;
                    end;
         'G', 'g' : begin
                       Line(x, y, x, y+2);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+4);
                       Line(x, y+4, x+1, y+4);
                       x:= x+4;
                    end;
         'H', 'h' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'I', 'i' : begin
                       Line(x, y, x+2, y);
                       Line(x+1, y+1, x+1, y+3);
                       Line(x, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'J', 'j' : begin
                       Line(x, y, x+2, y);
                       Line(x+1, y+1, x+1, y+3);
                       Line(x, y+4, x+1, y+4);
                       x:= x+4;
                    end;
         'K', 'k' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+1);
                       Line(x+2, y+3, x+2, y+4);
                       x:= x+4;
                    end;
         'L', 'l' : begin
                       Line(x, y, x, y+4);
                       Line(x+1, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'M', 'm' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       Line(x+2, y+1, x+2, y+4);
                       PutPixel(x+3, y, c);
                       Line(x+4, y+1, x+4, y+4);
                       x:= x+6;
                    end;
         'N', 'n' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       Line(x+2, y+1, x+2, y+4);
                       x:= x+4;
                    end;
         'O', 'o' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'P', 'p' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+2);
                       x:= x+4;
                    end;
         'Q', 'q' : begin
                       Line(x, y, x, y+2);
                       PutPixel(x+1, y, c);
                       PutPixel(x+1, y+2, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'R', 'r' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y, c);
                       Line(x+1, y+2, x+1, y+3);
                       Line(x+2, y, x+2, y+2);
                       PutPixel(x+2, y+4, c);
                       x:= x+4;
                   end;
         'S', 's' : begin
                       Line(x, y, x+2, y);
                       PutPixel(x, y+1, c);
                       Line(x, y+2, x+2, y+2);
                       PutPixel(x+2, y+3, c);
                       Line(x, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         'T', 't' : begin
                       Line(x, y, x+2, y);
                       Line(x+1, y+1, x+1, y+4);
                       x:= x+4;
                    end;
         'U', 'u' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+4);
                       x:= x+4;
                    end;
         'V', 'v' : begin
                       Line(x, y, x, y+3);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+3);
                       x:= x+4;
                    end;
         'W', 'w' : begin
                       Line(x, y, x, y+4);
                       PutPixel(x+1, y+4, c);
                       Line(x+2, y, x+2, y+3);
                       PutPixel(x+3, y+4, c);
                       Line(x+4, y, x+4, y+3);
                       x:= x+6;
                    end;
         'X', 'x' : begin
                       Line(x, y, x, y+1);
                       Line(x+2, y, x+2, y+1);
                       PutPixel(x+1, y+2, c);
                       Line(x, y+3, x, y+4);
                       Line(x+2, y+3, x+2, y+4);
                       x:= x+4;
                    end;
         'Y', 'y' : begin
                       Line(x, y, x, y+2);
                       Line(x+2, y, x+2, y+2);
                       Line(x+1, y+2, x+1, y+4);
                       x:= x+4;
                    end;
         'Z', 'z' : begin
                       Line(x, y, x+2, y);
                       PutPixel(x+2, y+1, c);
                       PutPixel(x+1, y+2, c);
                       PutPixel(x, y+3, c);
                       Line(x, y+4, x+2, y+4);
                       x:= x+4;
                    end;
         #39 : begin
                  Line(x+1, y, x+1, y+1);
                  x:= x+4;
               end;
         '1' : begin
                  PutPixel(x, y+1, c);
                  Line(x+1, y, x+1, y+3);
                  Line(x, y+4, x+2, y+4);
                  x:= x+4;
               end;
         '2' : begin
                   PutPixel(x+1, y, c);
                   PutPixel(x, y+1, c);
                   Line(x+2, y+1, x+2, y+2);
                   PutPixel(x+1, y+3, c);
                   Line(x, y+4, x+2, y+4);
                   x:= x+4;
                end;
         '3' : begin
                  Line(x, y, x+1, y);
                  PutPixel(x+2, y+1, c);
                  PutPixel(x+1, y+2, c);
                  PutPixel(x+2, y+3, c);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '4' : begin
                  Line(x, y, x, y+2);
                  PutPixel(x+1, y+2, c);
                  Line(x+2, y, x+2, y+4);
                  x:= x+4;
               end;
         '5' : begin
                  Line(x, y, x+2, y);
                  PutPixel(x, y+1, c);
                  Line(x, y+2, x+1, y+2);
                  PutPixel(x+2, y+3, c);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '6' : begin
                  Line(x+1, y, x+2, y);
                  Line(x, y+1, x, y+4);
                  PutPixel(x+1, y+2, c);
                  PutPixel(x+1, y+4, c);
                  Line(x+2, y+2, x+2, y+4);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '7' : begin
                  Line(x, y, x+2, y);
                  Line(x+2, y+1, x+2, y+2);
                  Line(x+1, y+3, x+1, y+4);
                  x:= x+4;
               end;
         '8' : begin
                  Line(x, y, x, y+4);
                  Line(x+2, y, x+2, y+4);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+2, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         '9' : begin
                  Line(x, y, x, y+2);
                  Line(x+2, y, x+2, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+2, c);
                  Line(x, y+4, x+1, y+4);
                  x:= x+4;
               end;
         '0' : begin
                  Line(x, y+1, x, y+3);
                  Line(x+2, y+1, x+2, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         '(' : begin
                  Line(x, y+1, x, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         ')' : begin
                  Line(x+2, y+1, x+2, y+3);
                  PutPixel(x+1, y, c);
                  PutPixel(x+1, y+4, c);
                  x:= x+4;
               end;
         '.' : begin
                   PutPixel(x+1, y+4, c);
                   x:=x+4;
               end;
         ':' : begin
                   PutPixel(x+1, y+1, c);
                   PutPixel(x+1, y+3, c);
                   x:=x+4;
               end;
         '\' : begin
                   Line(x, y, x, y+1);
                   Line(x+1, y+2, x+1, y+3);
                   PutPixel(x+2, y+4, c);
                   x:=x+4;
               end;
         '_' : begin
                   Line(x, y+4, x+2, y+4);
                   x:=x+4;
               end;
         '?' : begin
                   Line(x, y, x+1, y);
                   Line(x+2, y+1, x+1, y+2);
                   PutPixel(x+1, y+4, c);
                   x:=x+4;
               end;
         #13 : y:=y+7;
         #10 : x:=OldX;
         else
               begin
                   PutPixel(x, y+1, c);
                   PutPixel(x+2, y+1, c);
                   PutPixel(x+1, y+2, c);
                   PutPixel(x, y+3, c);
                   PutPixel(x+2, y+3, c);
                   x:=x+4;
               end;
      end;
   end;
   MoveTo(x, y);
end;

procedure GetBackGround;
begin
   y4:=1;
   for y3:=mY to mY+7 do
   begin
      x4:= 1;
      for x3:=mX to mX+5 do
      begin
         BackGround[x4, y4]:= GetPixel(x3, y3);
         x4:= x4+1;
      end;
      y4:= y4+1;
   end;
end;

procedure PutBackGround;
begin
   y4:=1;
   for y3:=mY to mY+7 do
   begin
      x4:= 1;
      for x3:=mX to mX+5 do
      begin
         PutPixel(x3, y3, BackGround[x4, y4]);
         x4:= x4+1;
      end;
      y4:= y4+1;
   end;
end;

procedure ScrollUpButton(x, y : integer);
begin
   Button(x, y, x+8, y+8);
   HideMouse;
   PutPixel(x+4, y+3, 8);
   Usecolor(8);
   Line(x+3, y+4, x+5, y+4);
   Line(x+2, y+5, x+6, y+5);
   InitMouse;
end;

procedure ScrollDownButton(x, y : integer);
begin
   Button(x, y, x+8, y+8);
   HideMouse;
   Usecolor(8);
   Line(x+2, y+3, x+6, y+3);
   Line(x+3, y+4, x+5, y+4);
   PutPixel(x+4, y+5, 8);
   InitMouse;
end;

procedure MinimizeButton(x, y : integer);
begin
   Button(x, y, x+8, y+8);
   HideMouse;
   Usecolor(8);
   Rectangle(x+2, y+2, x+6, y+6);
   Line(x+3, y+3, x+5, y+3);
   InitMouse;
end;

procedure ScrollLeftButton(x, y : integer);
begin
   Button(x, y, x+8, y+8);
   HideMouse;
   Usecolor(8);
   PutPixel(x+3, y+4, 8);
   Line(x+4, y+3, x+4, y+5);
   Line(x+5, y+2, x+5, y+6);
   InitMouse;
end;

procedure ScrollRightButton(x, y : integer);
begin
   Button(x, y, x+8, y+8);
   HideMouse;
   Usecolor(8);
   Line(x+3, y+2, x+3, y+6);
   Line(x+4, y+3, x+4, y+5);
   PutPixel(x+5, y+4, 8);
   InitMouse;
end;

procedure ExitButton(x, y : integer);
begin
   Button(x, y, x+8, y+8);
   HideMouse;
   PutPixel(x+2, y+2, 8);
   PutPixel(x+6, y+2, 8);
   PutPixel(x+3, y+3, 8);
   PutPixel(x+5, y+3, 8);
   PutPixel(x+4, y+4, 8);
   PutPixel(x+3, y+5, 8);
   PutPixel(x+5, y+5, 8);
   PutPixel(x+2, y+6, 8);
   PutPixel(x+6, y+6, 8);
   InitMouse;
end;

procedure OkButton(x, y : integer);
begin
   HideMouse;
   Usecolor(15);
   Line(x, y, x+24, y);
   Line(x, y, x, y+8);
   Usecolor(8);
   Line(x+25, y, x+25, y+8);
   Line(x+1, y+8, x+25, y+8);
   Box(x+1, y+1, x+24, y+7, 7);
   WriteAt(x+9, y+2, 'OK', 8);
   InitMouse;
end;

procedure YesButton(x, y : integer);
begin
   HideMouse;
   Usecolor(15);
   Line(x, y, x+24, y);
   Line(x, y, x, y+8);
   Usecolor(8);
   Line(x+25, y, x+25, y+8);
   Line(x+1, y+8, x+25, y+8);
   Box(x+1, y+1, x+24, y+7, 7);
   WriteAt(x+7, y+2, 'YES', 8);
   InitMouse;
end;

procedure NoButton(x, y : integer);
begin
   HideMouse;
   Usecolor(15);
   Line(x, y, x+24, y);
   Line(x, y, x, y+8);
   Usecolor(8);
   Line(x+25, y, x+25, y+8);
   Line(x+1, y+8, x+25, y+8);
   Box(x+1, y+1, x+24, y+7, 7);
   WriteAt(x+9, y+2, 'NO', 8);
   InitMouse;
end;

procedure MousePointer;
begin
   Usecolor(0);
   Line(mX, mY, mX, mY+6);
   Line(mX+1, mY+6, mX+3, mY+6);
   PutPixel(mX+2, mY+1, 0);
   PutPixel(mX+2, mY+5, 0);
   Line(mX+3, mY+6, mX+3, mY+7);
   PutPixel(mX+4, mY+3, 0);
   PutPixel(mX+3, mY+2, 0);
   PutPixel(mX+1, mY, 0);
   PutPixel(mX+4, mY+5, 0);
   PutPixel(mX+4, mY+7, 0);
   Line(mX+5, mY+4, mX+5 ,mY+7);
   Usecolor(15);
   Line(mX+1, mY+1, mX+1, mY+5);
   Line(mX+2, mY+2, mX+2, mY+4);
   Line(mX+3, mY+3, mX+3, mY+5);
   PutPixel(mX+4, mY+4, 15);
   PutPixel(mX+4, mY+6, 15);
end;

procedure InitMouse;
begin
   MouseWindow(0, 0, 639, 199);
   mX:= (MouseX div 2); mY:= MouseY;
   GetBackGround;
   MousePointer;
end;

procedure ShowMouse;
begin
   if (mX=(MouseX div 2)) and (mY=MouseY) then exit;
   PutBackGround;
   mX:= (MouseX div 2); mY:= MouseY;
   GetBackGround;
   MousePointer;
end;

procedure HideMouse;
begin
   PutBackGround;
end;

procedure WallPaper(WlpFile: string);
var
   pal : PaletteType;
   count : integer;
begin
   for count:= 0 to 255 do
   begin
      pal.RedLevel[count]:=0;
      pal.GreenLevel[count]:=0;
      pal.BlueLevel[count]:=0;
   end;
   UsePalette(pal);
   LoadPCX(WlpFile, pal);
   InitMouse;
   UsePalette(pal);
end;

procedure Button(x1, y1, x2, y2: word);
begin
   if (x2<x1) or (y2<y1) then exit;
   if (y2-y1+1)<3 then exit;
   if (x2-x1+1)<3 then exit;
   HideMouse;
   Box(x1+1, y1+1, x2-1, y2-1, 7);
   UseColor(15);
   Line(x1, y1, x2-1, y1);
   Line(x1, y1, x1, y2);
   UseColor(8);
   Line(x2, y1, x2, y2);
   Line(x1+1, y2, x2, y2);
   InitMouse;
end;

procedure PressedButton(x1, y1, x2, y2: word);
begin
   if (x2<x1) or (y2<y1) then exit;
   if (y2-y1+1)<3 then exit;
   if (x2-x1+1)<3 then exit;
   HideMouse;
   UseColor(8);
   Line(x1, y1, x2-1, y1);
   Line(x1, y1, x1, y2);
   UseColor(15);
   Line(x2, y1, x2, y2);
   Line(x1+1, y2, x2, y2);
   InitMouse;
end;

procedure SunkenArea(x1, y1, x2, y2: word);
begin
   if (x2<x1) or (y2<y1) then exit;
   if (y2-y1+1)<3 then exit;
   if (x2-x1+1)<3 then exit;
   HideMouse;
   Box(x1+1, y1+1, x2-1, y2-1, 7);
   UseColor(8);
   Line(x1, y1, x2-1, y1);
   Line(x1, y1, x1, y2);
   UseColor(15);
   Line(x2, y1, x2, y2);
   Line(x1+1, y2, x2, y2);
   InitMouse;
end;

procedure ScrollBarUp(x : word; y1, y2 : byte);
begin
   ScrollUpButton(x, y1);
   HideMouse;
   Box(x, y1+9, x+8, y2-9, 8);
   InitMouse;
   ScrollDownButton(x, y2-8);
end;

procedure ScrollBarAcross(x1, x2 : word; y : byte);
begin
   ScrollLeftButton(x1, y);
   HideMouse;
   Box(x1+9, y, x2-9, y+8, 8);
   InitMouse;
   ScrollRightButton(x2-8, y);
end;

procedure Window(x1, y1, x2, y2: integer; title: string);
begin
   if (x2<x1) or (y2<y1) then exit;
   if (y2-y1+1)<16 then exit;
   if (x2-x1+1)<64 then exit;
   HideMouse;
   Box(x1+2, y1+13, x2-2, y2-2, 7);
   Box(x1+1, y1+1, x2-1, y1+11, 1);
   UseColor(15);
   Line(x1, y1, x2-1, y1);
   Line(x1+1, y1+12, x2-2, y1+12);
   Line(x1, y1+1, x1, y2);
   Line(x1+1, y1+12, x1+1, y2-1);
   UseColor(8);
   Line(x2-1, y1+12, x2-1, y2);
   Line(x2, y1, x2, y2);
   Line(x1+2, y2-1, x2, y2-1);
   Line(x1+1, y2, x2, y2);
   WriteAt(x1+5, y1+4, Title, 15);
   InitMouse;
   ExitButton(x2-11, y1+2);
   HideMouse;
   InitMouse;
end;

procedure DragWin(var WinBitmap : pointer; MaxX, MaxY : integer; var BackGround : pointer; var MainWinX, MainWinY : integer);
var Xdiff, YDiff, Xpos, Ypos : integer;
begin
   Xpos:=MouseX div 2; Ypos:=MouseY;
   Xdiff:=Xpos-MainWinX; Ydiff:=Ypos-MainWinY;
   while (Xpos>MainWinX) and (Ypos>MainWinY) and (Xpos<MainWinX+MaxX-12) and (Ypos<MainWinY+12) and (LeftPressed) do
   begin
      Xpos:=MouseX div 2; Ypos:=MouseY;
      MainWinX:=(MouseX div 2)-Xdiff;
      MainWinY:=MouseY-Ydiff;
      if MainWinX<2 then
      begin
         MainWinX:=2;
         Xpos:=MouseX div 2;
         Xdiff:=Xpos-MainWinX;
      end;
      if MainWinX+MaxX>317 then
      begin
         MainWinX:=317-MaxX;
         Xpos:=MouseX div 2;
         Xdiff:=Xpos-MainWinX;
      end;
      if MainWinY<2 then
      begin
         MainWinY:=2;
         Ypos:=MouseY;
         Ydiff:=Ypos-MainWinY;
      end;
      if MainWinY+MaxY>197 then
      begin
         MainWinY:=197-MaxY;
         Ypos:=MouseY;
         Ydiff:=Ypos-MainWinY;
      end;
      ShowAreaOfBitmap(Background, 0, 0, 319, MainWinY-1, 0, 0);
      ShowAreaOfBitmap(Background, 0, MainWinY+MaxY+1, 319, 199, 0, MainWinY+MaxY+1);
      ShowAreaOfBitmap(Background, 0, MainWinY, MainWinX-1, MainWinY+MaxY, 0, MainWinY);
      ShowAreaOfBitmap(Background, MainWinX+MaxX+1, MainWinY, 319, MainWinY+MaxY, MainWinX+MaxX+1, MainWinY);
      HideMouse;
      ShowAreaOfBitmap(WinBitmap, 0, 0, MaxX, MaxY, MainWinX, MainWinY);
      InitMouse;
      repeat until ((MouseX div 2)<>Xpos) or (MouseY<>Ypos) or (LeftPressed=False) or (KeyPressed);
   end;
end;

function MsgBox(title, message,message2 : string):byte;
var
   Finished : boolean;
   counter : longint;
   ch : char;
   WinX, WinY : integer;
begin
   HideMouse;
   CopyBitmap(ptr($A000,0), HiddenScreen);
   InitMouse;
   UseBitmap(WindowBitmap);
   Window(0, 0, 127, 71, Title);
   HideMouse;
   WriteAt(8, 20, Message, 8);
   WriteAt(8, 28, Message2, 8);

   InitMouse;
   OkButton(51, 57);
   HideMouse;
   UseBitmap(ptr($A000,0));
   WinX:=96; WinY:=64;
   ShowAllBitmap(HiddenScreen);
   ShowAreaOfBitmap(WindowBitmap, 0, 0, 127, 71, WinX, WinY);
   InitMouse;
   x2:=16;
   counter:=1;
   Finished:=False;
   repeat
      repeat
         ShowMouse;
         mX2:=MouseX; mY2:=MouseY;
         if (LeftPressed) and (mX2 div 2 > WinX) and (mY2 > WinY) and
            (mX2 div 2 < WinX + 116) and (mY2 < WinY + 12) then
         begin
            HideMouse;
            CopyAreaToBitmap(WinX, WinY, WinX+127, WinY+71, WindowBitmap, 0, 0);
            InitMouse;
            DragWin(WindowBitmap, 127, 71, HiddenScreen, WinX, WinY);
         end;
         if (LeftPressed) and (mX2 div 2 > WinX + 50) and (mX2 div 2 < WinX + 77) and
            (mY2 > WinY + 56) and (mY2 < WinY + 66) then
         begin
            PressedButton(WinX+51, WinY+57, WinX+76, WinY+65);
            MsgBox:=Ok;
            Finished:=True;
            delay(300);
         end;
         if (LeftPressed) and (mX2 div 2 > WinX + 115) and (mX2 div 2 < WinX + 125) and
            (mY2 > WinY + 1) and (mY2 < WinY + 11) then
         begin
            PressedButton(WinX+116, WinY+2, WinX+124, WinY+10);
            MsgBox:=Cancel;
            Finished:=True;
            delay(300);
         end;
      until (KeyPressed) or (Finished);
      if KeyPressed then
      begin
         ch:=ReadKey;
         if ch=#27 then
         begin
            MsgBox:=Cancel;
            Finished:=True;
         end;
         if ch=#13 then
         begin
            MsgBox:=Ok;
            Finished:=True;
         end;
         if WinX+x2>WinX+104 then
         begin
            if ch>#31 then ch:=#0;
         end;
      end;
   until Finished;
   HideMouse;
   ShowAllBitmap(HiddenScreen);
   InitMouse;
end;

function InputBox(title, message : string; var output : string):byte;
var
   Finished : boolean;
   counter : longint;
   ch : char;
   WinX, WinY : integer;
begin
   HideMouse;
   CopyBitmap(ptr($A000,0), HiddenScreen);
   InitMouse;
   UseBitmap(WindowBitmap);
   Window(0, 0, 127, 71, Title);
   HideMouse;
   WriteAt(8, 20, Message, 8);
   InitMouse;
   OkButton(51, 57);
   SunkenArea(13, 35, 112, 45);
   HideMouse;
   box(14, 36, 111, 44, 0);
   UseBitmap(ptr($A000,0));
   WinX:=96; WinY:=64;
   ShowAllBitmap(HiddenScreen);
   ShowAreaOfBitmap(WindowBitmap, 0, 0, 127, 71, WinX, WinY);
   InitMouse;
   output:='';
   x2:=16;
   counter:=1;
   Finished:=False;
   repeat
      HideMouse;
      WriteAt(WinX+x2, WinY+38, '_', 15);
      InitMouse;
      repeat
         ShowMouse;
         mX2:=MouseX; mY2:=MouseY;
         if (LeftPressed) and (mX2 div 2 > WinX) and (mY2 > WinY) and
            (mX2 div 2 < WinX + 116) and (mY2 < WinY + 12) then
         begin
            HideMouse;
            CopyAreaToBitmap(WinX, WinY, WinX+127, WinY+71, WindowBitmap, 0, 0);
            InitMouse;
            DragWin(WindowBitmap, 127, 71, HiddenScreen, WinX, WinY);
         end;
         if (LeftPressed) and (mX2 div 2 > WinX + 50) and (mX2 div 2 < WinX + 77) and
            (mY2 > WinY + 56) and (mY2 < WinY + 66) then
         begin
            PressedButton(WinX+51, WinY+57, WinX+76, WinY+65);
            InputBox:=Ok;
            Finished:=True;
            delay(300);
         end;
         if (LeftPressed) and (mX2 div 2 > WinX + 115) and (mX2 div 2 < WinX + 125) and
            (mY2 > WinY + 1) and (mY2 < WinY + 11) then
         begin
            PressedButton(WinX+116, WinY+2, WinX+124, WinY+10);
            InputBox:=Cancel;
            Finished:=True;
            delay(300);
         end;
      until (KeyPressed) or (Finished);
      if KeyPressed then
      begin
         ch:=ReadKey;
         if ch=#27 then
         begin
            output:='';
            InputBox:=Cancel;
            Finished:=True;
         end;
         if ch=#13 then
         begin
            Box(WinX+x2, WinY+38, WinX+x2+2, WinY+42, 0);
            InputBox:=Ok;
            Finished:=True;
         end;
         if WinX+x2>WinX+104 then
         begin
            if ch>#31 then ch:=#0;
         end;
         if Finished = False then
         begin
            if ch>#31 then
            begin
               output:=output+ch;
               HideMouse;
               Box(WinX+x2, WinY+38, WinX+x2+2, WinY+42, 0);
               WriteAt(WinX+x2, WinY+38, ch, 15);
               x2:=CursorX-WinX;
               InitMouse;
               counter:=counter+1
            end;
         end;
      end;
   until Finished;
   HideMouse;
   ShowAllBitmap(HiddenScreen);
   InitMouse;
end;

function ErrorBox(message : string):byte;
var
   Finished : boolean;
   counter : longint;
   ch : char;
   WinX, WinY : integer;
begin
   HideMouse;
   CopyBitmap(ptr($A000,0), HiddenScreen);
   InitMouse;
   UseBitmap(WindowBitmap);
   Window(0, 0, 127, 71, 'ERROR');
   HideMouse;
   UseColor(0);
   Line(14, 20, 18, 20);
   Line(12, 21, 13, 21);
   Line(19, 21, 20, 21);
   PutPixel(11, 22, 0);
   PutPixel(21, 22, 0);
   PutPixel(10, 23, 0);
   PutPixel(22, 23, 0);
   Line(9, 24, 9, 25);
   Line(23, 24, 23, 25);
   Line(8, 26, 8, 30);
   Line(24, 26, 24, 30);
   Line(9, 31, 9, 32);
   Line(23, 31, 23, 32);
   PutPixel(10, 33, 0);
   PutPixel(22, 33, 0);
   PutPixel(11, 34, 0);
   PutPixel(21, 34, 0);
   Line(12, 35, 13, 35);
   Line(19, 35, 20, 35);
   Line(14, 36, 18, 36);
   UseColor(4);
   Line(14, 21, 18, 21);
   Line(12, 22, 20, 22);
   Line(11, 23, 21, 23);
   for counter:=24 to 25 do Line(10, counter, 22, counter);
   for counter:=26 to 30 do Line(9, counter, 23, counter);
   for counter:=31 to 32 do Line(10, counter, 22, counter);
   Line(11, 33, 21, 33);
   Line(12, 34, 20, 34);
   Line(14, 35, 18, 35);
   UseColor(15);
   Line(13, 24, 20, 31);
   Line(13, 25, 19, 31);
   Line(12, 25, 19, 32);
   Line(19, 24, 12, 31);
   Line(19, 25, 13, 31);
   Line(20, 25, 13, 32);
   UseColor(8);
   PutPixel(22, 22, 8);
   PutPixel(23, 23, 8);
   Line(24, 24, 24, 25);
   Line(25, 25, 25, 33);
   Line(26, 27, 26, 31);
   Line(24, 31, 24, 34);
   Line(23, 33, 23, 35);
   PutPixel(22, 34, 8);
   Line(21, 35, 23, 35);
   Line(19, 36, 22, 36);
   Line(16, 37, 20, 37);
   WriteAt(34, 25, Message, 8);
   InitMouse;
   OkButton(51, 57);
   HideMouse;
   UseBitmap(ptr($A000,0));
   WinX:=96; WinY:=64;
   ShowAllBitmap(HiddenScreen);
   ShowAreaOfBitmap(WindowBitmap, 0, 0, 127, 71, WinX, WinY);
   InitMouse;
   write(#7);
   counter:=1;
   Finished:=False;
   repeat
      repeat
         ShowMouse;
         mX2:=MouseX; mY2:=MouseY;
         if (LeftPressed) and (mX2 div 2 > WinX) and (mY2 > WinY) and
            (mX2 div 2 < WinX + 116) and (mY2 < WinY + 12) then
         begin
            HideMouse;
            CopyAreaToBitmap(WinX, WinY, WinX+127, WinY+71, WindowBitmap, 0, 0);
            InitMouse;
            DragWin(WindowBitmap, 127, 71, HiddenScreen, WinX, WinY);
         end;
         if (LeftPressed) and (mX2 div 2 > WinX + 50) and (mX2 div 2 < WinX + 77) and
            (mY2 > WinY + 56) and (mY2 < WinY + 66) then
         begin
            PressedButton(WinX+51, WinY+57, WinX+76, WinY+65);
            ErrorBox:=Ok;
            Finished:=True;
            delay(300);
         end;
         if (LeftPressed) and (mX2 div 2 > WinX + 115) and (mX2 div 2 < WinX + 125) and
            (mY2 > WinY + 1) and (mY2 < WinY + 11) then
         begin
            PressedButton(WinX+116, WinY+2, WinX+124, WinY+10);
            ErrorBox:=Cancel;
            Finished:=True;
            delay(300);
         end;
      until (KeyPressed) or (Finished);
      if KeyPressed then
      begin
         ch:=ReadKey;
         if ch=#27 then
         begin
            ErrorBox:=Cancel;
            Finished:=True;
         end;
         if ch=#13 then
         begin
            ErrorBox:=Ok;
            Finished:=True;
         end;
         if WinX+x2>WinX+104 then
         begin
            if ch>#31 then ch:=#0;
         end;
      end;
   until Finished;
   HideMouse;
   ShowAllBitmap(HiddenScreen);
   InitMouse;
end;

procedure SetDefaultWallPaper;
var x, y, col, n : word;
begin
   UseBitmap(HiddenScreen);
   col:=192;
   for n:=63 downto 0 do
   begin
      palette(col, 0, 0, n);
      col:=col+1;
   end;
   cls;
   col:=192;
   box(0, 0, 319, 2, col);
   y:=2;
   repeat
      if y>2 then
      begin
         x:=0;
         repeat
            PutPixel(x, y, col);
            PutPixel(x + 1, y, col - 1);
            x:=x+2
         until x>318
      end;
      UseColor(col);
      line(0, y + 1, 319, y + 1);
      x:=0;
      repeat
         PutPixel(x, y + 2, col);
         PutPixel(x + 1, y + 2, col + 1);
         x:=x+2
      until x>318;
      col:=col+1;
      if col>255 then col:=255;
      y:=y+3
   until y>199;
   UseBitmap(ptr($A000,0));
   CopyBitmap(HiddenScreen, ptr($A000,0));
end;

procedure PlayMov(filename : string);
var
   MovPal, OldPal : PaletteType;
   MovFile : file;
   frames, count : longint;
   ImageSeg, ImageOfs : word;
   DisplayingFullScreen : boolean;
   h, m, s, hund, oh, n : word;
   DoneSameFrames : boolean;
   oldx, oldy : word;
begin
   n:=0;
   DisplayingFullScreen:=False;
   DoneSameFrames:=False;
   HideMouse;
   cls;
   Assign(MovFile, filename);
   Reset(MovFile, 1);
   BlockRead(MovFile, MovPal, 768);
   UsePalette(MovPal);
   frames:=(FileSize(MovFile)-768) div 16000;
   get(0, 0, 159, 99, Image);
   ImageSeg:=seg(Image^);
   ImageOfs:=ofs(Image^);
   BlockRead(MovFile, mem[ImageSeg:ImageOfs+4], 16000);
   put (80, 50, Image);
   InitMouse;
   repeat
      ShowMouse
   until LeftPressed;
   GetTime(h,m,s,hund);
   oh:=hund div 25;
   repeat
      ShowMouse;
      GetTime(h,m,s,hund);
      hund:=hund div 25;
   until hund<>oh;
   for count:=2 to frames do
   begin
      ImageSeg:=seg(Image^);
      ImageOfs:=ofs(Image^);
      BlockRead(MovFile, mem[ImageSeg:ImageOfs+4], 16000);
      if (LeftPressed) and (DoneSameFrames) then
      begin
         DisplayingFullScreen:=True;
         DoneSameFrames:=False;
         n:=0
      end;
      if (RightPressed) and (DoneSameFrames) and (DisplayingFullScreen) then
      begin
         DisplayingFullScreen:=False;
         DoneSameFrames:=False;
         n:=0;
         cls
      end;
      if DisplayingFullScreen then
      begin
         UseBitmap(HiddenScreen);
         asm
            mov ax,0
            mov y,ax
           @startY:
            mov ax,0
            mov x,ax
           @startX:
            mov ax,ImageSeg
            mov es,ax
            mov ax,y
            mov dx,160
            mul dx
            mov bx,ImageOfs
            add bx,4
            add bx,x
            add ax,bx
            mov di,ax
            mov ax,y
            mov dx,2
            mul dx
            mov bx,ax
            mov ax,x
            mov dx,2
            mul dx
            mov dl,[es:di]
            mov oldx,ax
            mov oldy,bx
            call fputpixel
            mov ax,oldx
            mov bx,oldy
            add ax,1
            call fputpixel
            mov ax,oldx
            mov bx,oldy
            add bx,1
            call fputpixel
            mov ax,oldx
            mov bx,oldy
            add ax,1
            add bx,1
            call fputpixel
            mov ax,x
            cmp ax,160
            jz @endX
            add ax,1
            mov x,ax
            jmp @startX
           @endX:
            mov ax,y
            cmp ax,100
            jz @endY
            add ax,1
            mov y,ax
            jmp @startY
           @endY:
         end;
         UseBitmap(ptr($A000,0));
         HideMouse;
         CopyBitmap(HiddenScreen, ptr($A000, 0));
         Initmouse;
      end else
      begin
         HideMouse;
         put (80, 50, Image);
         InitMouse;
      end;
      GetTime(h,m,s,hund);
      oh:=hund div 25;
      repeat
         ShowMouse;
         GetTime(h,m,s,hund);
         hund:=hund div 25;
      until hund<>oh;
      n:=n+1;
      if n=3 then DoneSameFrames:=True;
   end;
   Close(MovFile);
end;

procedure PlayFullScreen(filename : string);
var
   MovPal, OldPal : PaletteType;
   MovFile : file;
   frames, count : longint;
   ImageSeg, ImageOfs : word;
   h, m, s, hund, oh : word;
   DoneSameFrames : boolean;
   var oldx, oldy : word;
begin
   cls;
   Assign(MovFile, filename);
   Reset(MovFile, 1);
   BlockRead(MovFile, MovPal, 768);
   UsePalette(MovPal);
   frames:=(FileSize(MovFile)-768) div 16000;
   get(0, 0, 159, 99, Image);
   ImageSeg:=seg(Image^);
   ImageOfs:=ofs(Image^);
   BlockRead(MovFile, mem[ImageSeg:ImageOfs+4], 16000);
   UseBitmap(HiddenScreen);
   asm
      mov ax,0
      mov y,ax
     @startY:
      mov ax,0
      mov x,ax
     @startX:
      mov ax,ImageSeg
      mov es,ax
      mov ax,y
      mov dx,160
      mul dx
      mov bx,ImageOfs
      add bx,4
      add bx,x
      add ax,bx
      mov di,ax
      mov ax,y
      mov dx,2
      mul dx
      mov bx,ax
      mov ax,x
      mov dx,2
      mul dx
      mov dl,[es:di]
      mov oldx,ax
      mov oldy,bx
      call fputpixel
      mov ax,oldx
      mov bx,oldy
      add ax,1
      call fputpixel
      mov ax,oldx
      mov bx,oldy
      add bx,1
      call fputpixel
      mov ax,oldx
      mov bx,oldy
      add ax,1
      add bx,1
      call fputpixel
      mov ax,x
      cmp ax,160
      jz @endX
      add ax,1
      mov x,ax
      jmp @startX
     @endX:
      mov ax,y
      cmp ax,100
      jz @endY
      add ax,1
      mov y,ax
      jmp @startY
     @endY:
   end;
   UseBitmap(ptr($A000,0));
   CopyBitmap(HiddenScreen, ptr($A000, 0));
   GetTime(h,m,s,hund);
   oh:=hund div 25;
   repeat
      GetTime(h,m,s,hund);
      hund:=hund div 25;
   until hund<>oh;
   for count:=2 to frames do
   begin
      ImageSeg:=seg(Image^);
      ImageOfs:=ofs(Image^);
      BlockRead(MovFile, mem[ImageSeg:ImageOfs+4], 16000);
      UseBitmap(HiddenScreen);
      asm
         mov ax,0
         mov y,ax
        @startY:
         mov ax,0
         mov x,ax
        @startX:
         mov ax,ImageSeg
         mov es,ax
         mov ax,y
         mov dx,160
         mul dx
         mov bx,ImageOfs
         add bx,4
         add bx,x
         add ax,bx
         mov di,ax
         mov ax,y
         mov dx,2
         mul dx
         mov bx,ax
         mov ax,x
         mov dx,2
         mul dx
         mov dl,[es:di]
         mov oldx,ax
         mov oldy,bx
         call fputpixel
         mov ax,oldx
         mov bx,oldy
         add ax,1
         call fputpixel
         mov ax,oldx
         mov bx,oldy
         add bx,1
         call fputpixel
         mov ax,oldx
         mov bx,oldy
         add ax,1
         add bx,1
         call fputpixel
         mov ax,x
         cmp ax,160
         jz @endX
         add ax,1
         mov x,ax
         jmp @startX
        @endX:
         mov ax,y
         cmp ax,100
         jz @endY
         add ax,1
         mov y,ax
         jmp @startY
        @endY:
      end;
      UseBitmap(ptr($A000,0));
      CopyBitmap(HiddenScreen, ptr($A000, 0));
      GetTime(h,m,s,hund);
      oh:=hund div 25;
      repeat
         GetTime(h,m,s,hund);
         hund:=hund div 25;
      until hund<>oh;
   end;
   Close(MovFile);
end;

begin
   if not MouseInstalled then
   begin
      writeln('This program requires a Microsoft or compatable mouse.');
      halt;
   end;
   HiddenScreen:=New64Kbitmap;
   WindowBitmap:=New64Kbitmap;
   UseBitmap(ptr($A000,0));
   InitOffsets;
   UseColor(15);
   Cls;
end.
