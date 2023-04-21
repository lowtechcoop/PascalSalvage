{SWAG=GRAPHICS.SWG,SCOTT TUNSTALL,Very FAST VGA Graphics unit}
(*
****************************************************************

TITLE    : KOJAKVGA 3.1 (486 ENHANCED)

FILENAME : KOJAKVGA.PAS

AUTHOR   : SCOTT TUNSTALL (aka Lt. Kojak)

FINISH   : 18TH AUGUST 1996.. AND
DATE       29TH AUGUST 1996 - (That was something else which
	   finished - so sad!)


	   DISTRIBUTE FREELY TO YOUR WORST ENEMIES :)

****************************************************************

"Thanks to all who contacted me regarding games programming
	and especially to Susan Smith who's been a great help over
	the past couple of months.
	Also to Kenny who's done some of the graphic work (like the
	intro screens to all my games)"

DISCLAIMER
----------

Use this unit at your OWN RISK. I take NO responsibility if it
kills or crashes your system. This unit works fine on my machine.

Distribute this code if you like.. make sure the code & comments
are intact. if you write any software with this unit (or parts
from it) you are required to mention my name and KojakVGA V3 in
the credits.




ABOUT KOJAKVGA
--------------

I may have posted an earlier, crapper version of KOJAKVGA to
Gayle. Version 3.1 (This version) is where the action's at!
Use this version!

NEWGRAPH was my last attempt at a complete graphics unit. I had
been working on it from 1994-95 and had intended to release it
as shareware (if I knew about beerware back then... ;) )
but found that it lacked more serious functions and so I sent
it to the SWAG in June 96.

Over a 3 month period I altered NEWGRAPH beyond recognition,
removing minor bugs, optimising code and adding seriously cool
functions. I must be mad!!!

Let's just say KOJAKVGA kicks NEWGRAPH's ass all over the place.
And you're getting it FREE! What more could you ask for?



WHAT'S NEW THEN SCOTT?
----------------------


4 direction scrolling, Shape mirroring & scaling, faster
routines, more validation and enhanced notes. Is that enough? :)

NO?!!!

UPDATES
-------

Can't see an update to KOJAKVGA for some time. However, I am
considering using linear addressing (longints instead of pointers)
to allow XMS memory to be accessed for sprites, playfields etc.

MINIMUM SYSTEM REQUIREMENTS
---------------------------

o Turbo Pascal 6. However, KojakVGA was created with TP7,
  so you may need to remove some of the switches below if
  compiling with TP6.

o 486 processor. The previous versions (NEWGRAPH and KOJAKVGA v2)
  worked on a 386, but were intended to be used with a 486
  (does anyone use 386's now for games? ;) )


o VGA graphics card that supports mode 13h and the 262,144
  colour palette. And my 640 x 480 x 16.7m colour
  VESA unit (based on this) will blow your mind... I think ;)


*)

{$A+,B-,E+,F-,G+,N+,Q-,R-,S-}

UNIT KOJAKVGA;

INTERFACE

Const
      GetMaxX                 = 319;
      GetMaxY                 = 199;
      GetMaxColour            = 255;
      MaxColours              = 256;

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




{ Refer to V1 NEWGRAPH for description of these structs }


TYPE
PaletteType = record
   RedLevel:   Array[0..MaxColours-1] of byte;
   GreenLevel: Array[0..MaxColours-1] of byte;
   BlueLevel:  Array[0..MaxColours-1] of byte;
end;




FontType = record
   FontSeg       : Word;
   FontOfs       : Word;
   FontWidth     : Byte;
   FontByteWidth : Byte;
   FontHeight    : Byte;
   FontChars     : Byte;
End;









Procedure InitVGAMode;

{ Completely altered bitmap initialisation and manipulation
  routines which use pointers instead of that segm/offs
  crap. }

Function  New64KBitmap: pointer;
Procedure FreeBitmap(Var BmapPtr: pointer);


{ All singing, all dancing NEW bitmap stuff :) }

Procedure UseBitmap(BmapPtr: pointer);
Function  GetUsedBitmapAddr: pointer;
Procedure CopyBitmapTo (DstBMap: pointer);
Procedure CopyAreaToBitmap ( x1:word; y1:byte; x2:word; y2:byte;
	  dstbmap: pointer; DestX:word; DestY:byte);
Procedure ShowUsedBitmap;
Procedure FillArea(x1:word;y1:byte;x2:word;y2:byte;thecolour:byte);
Procedure Cls;
Procedure CCls(TheColour : byte);

{ These routines work with any bitmap }


Procedure CopyBitmap( SrcBMapPtr,  DstBMapPtr : pointer);
Procedure ShowAllBitmap( TheBMap: pointer);
Procedure ShowAreaOfBitmap ( TheBMap: Pointer; x1:word; y1:byte;
                             x2:word; y2:byte;
                             DestX:word; DestY: byte);


{ These scroll routines are GREAT, man :) }

Procedure ScrollUp(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
Procedure ScrollDown(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
Procedure ScrollLeft(x1:word;y1:byte;x2:word;y2,pixelstep:byte);
Procedure ScrollRight(x1:word;y1:byte;x2:word;y2,pixelstep:byte);


{ Drawing primitives }

Procedure PutPixel(x, y : integer; ColourValue : Byte);
Function  GetPixel(X,Y: integer): integer;
Procedure Line(X1, Y1, X2, Y2:integer);
Procedure LineRel(DiffX,DiffY: integer);
Procedure LineTo(EndX,Endy:integer);
Procedure Rectangle(x1,y1,x2,y2:integer);
Procedure MoveTo(NewCursX,NewCursY:integer);
Function  GetX: integer;
Function  GetY: integer;
Procedure PrintAt(x,y:integer; txt:string);
Procedure Print(txt:string);



{ Fast sprite (shape) routines. }


Procedure GetAShape(x1,y1,x2,y2:word;Var DataPtr);
Procedure FreeShape(DataPtr:pointer);
Procedure Blit(x,y:word; Var DataPtr);
Procedure ClipBlit(x,y:integer; Var DataPtr);
Procedure Block(x,y:word; Var DataPtr);
Procedure ClipBlock(x,y:integer; Var DataPtr);
Function  BlitColl(x,y :integer; Var dataptr) : boolean;



{ The new boys! }

Procedure ScaleShape(var DataPtr; x1:word;y1:byte;x2:word;y2:byte);
Procedure XFlipShape(Var DataPtr);
Procedure YFlipShape(Var DataPtr);



{ Back to the old school - only LoadShape has been altered }

Function  ShapeSize(x1,y1,x2,y2:word):word;
Function  ExtShapeSize(ShapeWidth, ShapeHeight : byte): word;
Function  ShapeWidth(Var DataPtr): byte;
Function  ShapeHeight(Var DataPtr): byte;
Procedure LoadShape(FileName:String; Var DataPtr:Pointer);
Procedure SaveShape(FileName:string; DataPtr:Pointer);




{ Hmm.. should I include a GIF loader in the next release? Naaaaaaahhh! }

Procedure LoadPCX(FileName:string; Var ThePalette: PaletteType);
Procedure LocatePCX(filename:string; Var ThePalette: PaletteType;
          x,y,widthtoshow,heighttoshow:word);
Procedure SavePCX(filename:string;ThePalette: PaletteType);
Procedure SaveAreaAsPCX(filename:string;ThePalette: PaletteType;
          x,y, PCXWidth,PCXHeight: word);




{ Font routines }


Function  UseFont(FontNumber:byte): boolean;
Function  GetFontCharOffset(CharNum:byte): word;
Function  GetCurrentFontAddress: pointer;
Procedure SetNewFontAddress(NewFontPtr: pointer);
Procedure GetCurrentFontSize(Var CurrFontWidth, CurrFontHeight:byte);
Procedure SetFontSize(NewFontWidth, NewFontHeight:byte);
Procedure LoadFont(FontFileName:String; Var FontRec: FontType);
Procedure UseLoadedFont(FontRec : FontType);
Procedure SaveFont(FontFileName:String; FirstChar, Numchars:byte);




{ Basic Palette stuff - from these primitives you can create fades etc. }

Procedure UseColour(NewColour:byte);
Function  GetColour: byte;
Procedure GetRGB(ColourNumber : Byte; VAR RedValue, GreenValue,
          BlueValue : Byte);
Procedure SetRGB(ColourNumber, RedValue, GreenValue, BlueValue : Byte);
Procedure LoadPalette(FileName: String; Var Palette : PaletteType);
Procedure SavePalette(FileName: String; Palette : PaletteType);
Procedure CopyScreenPaletteTo(Var Palette : PaletteType);
Procedure UsePalette(Palette : PaletteType);



{ Miscellaneous useful routines. Vwait bug fixed }

Procedure Vwait(TimeOut:word);
Function  GetVersion: word;






IMPLEMENTATION


Uses CRT,DOS;



type Pcxheader_rec=record
     manufacturer: 	byte;
     version: 		byte;
     encoding: 		byte;
     bits_per_pixel: 	byte;
     xmin, ymin: 	word;
     xmax, ymax: 	word;
     hres: 		word;
     vres: 		word;
     palette: 		array [0..47] of byte;
     reserved: 		byte;
     colour_planes: 	byte;
     bytes_per_line: 	word;
     palette_type: 	word;
     filler: 		array [1..58] of byte;

end;

Const KojakVGAVersion = $301;   { Major = 3, Minor = 1 }

Var
    ScanLineOffsets:            Array[0..199] of word;
    CurrentBitmapSegment:       word;
    CurrentBitmapOffset:        word;

    CurrentFontSegment:         word;
    CurrentFontOffset:          word;
    CurrentFontWidth:           byte;
    CurrentFontByteWidth:       byte;
    CurrentFontHeight:          byte;
    CurrentFontBytesPerChar:    byte;   { 255 bytes per char max! }

    CurrentColour:              byte;
    CursorX:                    integer;
    CursorY:                    integer;

    header:                     Pcxheader_rec;


{
 ==================================================================


 PROCEDURES


 ------------------------------------------------------------------
}

procedure calculateoffset; near; forward;

(*
Used to get the segment and offset of a pointer. Private to unit.

Expects : PT is a standard pointer.
          Segm and Offs are uninitialised word variables.

Returns : On exit Segm holds the segment part of the pointer
          Offs holds the offset.

Corrupts : AX,BX,DI,ES.

*)

Procedure GetPtrData(pt:pointer; VAR Segm, Offs:word); Assembler;
Asm
   LES DI,PT            { Point ES:DI to where PT is in memory }
   MOV AX,ES            { Set AX to hold segment }
   MOV BX,DI            { BX to hold offset }

   LES DI,Segm          { Now write directly to variable Segm }
   MOV [ES:DI],AX
   LES DI,Offs          { And variable Offs }
   MOV [ES:DI],BX
End;







{
Switch into VGA256 (320 x 200 x 256 Colour mode).

Expects  : Nothing

Returns  : I am sure that the INT $10 will return a value indicating
	   success on mode change (I can't be bothered checking my
           interrupt list :) ) but who gives a flying...

Corrupts : AX

Notes    : It affects the current screen mode (obviously) palette,
           Font. But KojakVGA still Prints in the font you
           last used.

           If all you want to do is clear the screen then use
	   Cls or CCls, which does not affect palettes etc.

}

Procedure InitVGAMode; Assembler;
asm
   XOR AH,AH
   MOV AL,$13
   INT $10
End;







{
****************************
BITMAP MANIPULATION ROUTINES
****************************
}







(*
Allocate memory for a virtual screen.

it is ALWAYS 64,000 bytes that are allocated - the same
size as what is used by the VGA bitmap! KojakVGA 3
will let you define your own bitmap sizes.

Expects  : Nothing

Returns  : A pointer to the bitmap allocated.

Corrupts : Probably all registers (except DS & BP of course)

*)


Function New64KBitmap: pointer;
Var MemoryAccessVar: pointer;
Begin
     GetMem(MemoryAccessVar,64000);
     New64KBitmap:=MemoryAccessVar;
End;









(*
This routine will release the memory occupied by a bitmap back to the
system.

Expects  :  BMapPtr points to an area of memory that was reserved
            by New64KBitmap.

Returns  :  Memory used by the bitmap (64000 bytes) should be returned
	    to the system heap. Of course, your machine may crash if
            you try and free a Bitmap that has not been allocated !
            Doh! :)

Corrupts :  Don't know which registers are altered. Yet again, assume
	    ALL registers (except DS & BP)

*)


Procedure FreeBitmap(Var BMapPtr: pointer);
Begin
     FreeMem(BMapPtr,64000);
     BMapPtr:=Nil;
End;








{
Set the bitmap to use for all drawing/sprite/scrolling routines.
This bitmap is referred to as the current bitmap

Expects  : BMapPtr is a pointer to the bitmap to use.
           You can create bitmaps by using the New64KBitmap function,
	   or to draw directly to screen use:

           UseBitmap(ptr($a000,0));

Returns  : Nothing

Corrupts : AX

}




Procedure UseBitmap(BMapPtr : pointer); Assembler;
Asm
   MOV AX,WORD PTR BMapPtr[0]
   MOV CurrentBitmapOffset,AX
   MOV AX,WORD PTR BMapPtr[2]
   MOV CurrentBitmapSegment,AX
End;





{
Return the address of the bitmap being used for graphics operations.

Expects  : SourceSeg, SourceOfs are 2 word variables.

Returns  : On exit, GetUsedBitmapAddr = Address of the current bitmap.

Corrupts : DX,AX
}


Function GetUsedBitmapAddr: pointer; Assembler;
Asm
   MOV DX,CurrentBitmapSegment
   MOV AX,CurrentBitmapOffset

End;














{
***************************

BITMAP SCROLL/COPY ROUTINES

***************************
}




{
POST INCREMENTAL MOVE
---------------------

You could put this in memory.swg if you like as it uses 32 bit
instructions to copy data from A to B.

Expects:     DS:SI = Source
	     ES:DI = Dest
             CX    = Count of bytes
             AX    = CX

Returns:     Zilch

Corrupts:    SI,DI, Direction Flag
}



Procedure PostIncMove; Assembler;
Asm
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
End;








{
PRE DECREMENTAL MOVE
--------------------

If you don't know what this does, don't panic, it's provided only
for the scroll routines.



Expects:     DS:SI = Source
             ES:DI = Dest
             CX    = Count of bytes
             AX    = CX

Returns:     Zilch

Corrupts:    SI,DI, Direction flag


}



Procedure PreIncMove; Assembler;
Asm
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
   ADD SI,3                     { Point to previous bytes written -1 }
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
End;










{
Copy a rectangular area from the Current Bitmap to the bitmap pointed
to by dstbmap. No masking of colour 0 is performed, so the area
will be moved as is, blank bits underneath and all.

Expects:  x1,y1,x2,y2 define the rectangular area of the Current Bitmap
          to be moved.

	  DstBmap is a pointer to the bitmap where the rectangular
	  area will be copied. Must NOT be Nil!

	  DestX and DestY specify where this area will be placed on
          DstBMap.



Returns:  nothing

Corrupts: AX,BX,CX,DX,SI,DI,Upper word of EBP, ES, Direction flag
}





Procedure CopyAreaToBitmap ( x1:word;y1:byte;x2:word;y2:byte;
          dstbmap : pointer; DestX:word;DestY:byte); Assembler;
Asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX                { Instead of pushing BX on stack }
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
     INC CX             { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL             { DL = Number of lines to move }

     DB $66; SHL BP,16
     MOV BP,SI          { Oh well that's knackered local var access then :) }
     MOV BX,DI


@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX

     MOV AX,CX
     CALL PostIncMove

     MOV SI,BP          { point source & dest to next lines }
     MOV DI,BX

     DEC DL
     JNZ @Outer

     DB $66; SHR BP,16             { Restore the 2 essential registers }
     POP DS
End;












{
Fill an area of the Current Bitmap with a given colour.

I provided this function so that you could erase the "trails" left
by scrolling, or even to clear the screen in a fancy way...

Expects: x1,y1,x2,y2 define a rectangular area on the Current Bitmap
         to fill with colour <thecolour>

	 i.e. FillArea(0,0,319,199,255) fills the entire source
         bitmap with colour 255.

Returns: Nothing

Corrupts: AX, BX, CX, DX, SI, DI, ES
}


Procedure FillArea(x1:word;y1:byte;x2:word;y2:byte;thecolour:byte);
Assembler;
Asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV DI,BX

     MOV ES,CurrentBitmapSegment


     MOV CX,X2
     SUB CX,X1
     INC CX             { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL             { DL = Number of lines to move }

     MOV AL,TheColour
     MOV AH,AL
     MOV BX,AX
     DB $66; SHL AX,16  { Fill EAX with AL }
     MOV AX,BX


     MOV SI,BP          { Save BP in SI }
     MOV BP,DI

     CLD

@Outer:
     ADD BP,320         { Point BP to next line }

     MOV BX,CX

     SHR CX,2           { Count number of long words in CX }
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
     MOV DI,BP          { point source & dest to next lines }

     DEC DL
     JNZ @Outer


     MOV BP,SI
End;













{
Clear the Current Bitmap with Colour 0 (Always).

Expects  : CurrentBitmapSegment, CurrentBitmapOffset to point to the source
	   Bitmap (of course).

Returns  : Nothing.

Corrupts : AX,CX,DI,ES

Notes    : If only a blitter was made standard for the PC... how I could
	   clear those screens so quickly...

	   Better watch out, I feel an anorak coming on. ;)
}

Procedure Cls; Assembler;
Asm
     MOV ES,CurrentBitmapSegment
     MOV DI,CurrentBitmapOffset

     MOV CX,4000         { 4000 x 16 byte moves are executed }
     DB $66
     XOR AX,AX           { XOR EAX,EAX - Colour 0 used to clear screen }

@ClearLoop:
     DB $66; STOSW       { STOSD }
     DB $66; STOSW
     DB $66; STOSW
     DB $66; STOSW
     DEC CX
     JNZ @ClearLoop

End;









{
Clear the screen with the graphics colour specified.

Expects : CurrentColour set to non-zero value
	  Current Bitmap initialised with Bitmap

Returns : Nothing

Corrupts : AX,BX,CX,DI,ES
}

Procedure CCls(TheColour : byte); Assembler;
Asm
   MOV ES,CurrentBitmapSegment
   MOV DI,CurrentBitmapOffset

   MOV CX,4000
   MOV AH,TheColour
   MOV AL,AH
   MOV BX,AX

   DB $66; SHL AX,16            { SHL EAX,16 -> Move AH & AL into
                                  upper word of EAX}
   MOV AX,BX                    { Now EAX is fully set }

@FillLoop:
   DB $66; STOSW                { STOSD }
   DB $66; STOSW
   DB $66; STOSW
   DB $66; STOSW
   DEC CX
   JNZ @FillLoop                { You could use LOOP but I heard this
                                  method is faster }
End;












{
Procedure used to blit one bitmap to another bitmap. Private
to unit.

Expects : DS:SI points to source page
          ES:DI points to destination page
          DX holds data segment address

Corrupts : CX,SI,DI, Direction flag.

Returns : Nothing

Notes   : This routine is gonna get changed soon,

	  In the future the parameters will be:

          DS:ESI points to source
          ES:EDI points to dest
	  ECX will be set to the number of bytes the bitmap to copy
              occupies.
	  DX still same


}



Procedure FastCopy; Assembler;
Asm
     MOV CX,2000
     CLD


@Copy:
     DB $66; MOVSW      { MOVSD }
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW
     DB $66; MOVSW      { 32 bytes moved in one loop. Whoa !}
     DEC CX
     JNZ @Copy          { On my 486 this is faster than LOOP }

     MOV DS,DX
End;





{
Added Sept 7th 1996 - after a major heartbreak :) I managed to add this!

This routine copies the bitmap currently in use to another bitmap.

Expects:   DstBmap points to the bitmap to copy to.

Returns:   Nothing

Corrupts:  DX, SI, DI, ES
}




Procedure CopyBitmapTo(DstBmap: pointer); Assembler;
Asm
   MOV DX,DS
   MOV ES,WORD PTR DstBmap[2]
   MOV DI,WORD PTR DstBmap[0]
   MOV SI,CurrentBitmapOffset
   MOV DS,CurrentBitmapSegment
   CALL FastCopy
End;







{
Instead of specifying the source, dest bitmaps you can copy basically
any bitmap you like to where you like.

Expects: SrcBmapPtr points to the source (bitmap to copy FROM)
	 If Set to Nil then the current bitmap is used.

         DstBmapPtr points to the destination (bitmap copying TO)
         If Set To Nil then the current bitmap is used.

Returns: Nothing


Corrupts: CX, SI, DI, ES
}



Procedure CopyBitmap( SrcBMapPtr,DstBMapPtr : pointer);
Assembler;
Asm
   MOV DX,DS
   MOV AX,WORD PTR DstBMapPtr[2]	{ Check if Segment is Nil }
   OR  AX,AX
   JNZ @UseDestBMap			{ If not, use that seg as dest }
   MOV DI,CurrentBitmapOffset
   MOV ES,CurrentBitmapSegment
   JMP @NowCheckDest

@UseDestBMap:
   MOV DI,WORD PTR DstBMapPtr		{ Get offset }
   MOV ES,AX				{ ES:DI is set }

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
End;





{
Added 12:08:96
}



Procedure ShowUsedBitmap; Assembler;
Asm
   MOV AX,$a000
   MOV ES,AX
   MOV DI,0
   MOV SI,CurrentBitmapOffset
   MOV DX,DS
   MOV DS,CurrentBitmapSegment
   CALL FastCopy
End;





{
Copy a bitmap in memory to the VGA memory, therefore showing it
on screen immediately.

Expects  : TheBMap points to the bitmap to display on screen.
           If Set to Nil then the current bitmap is used.

Returns  : Nothing

Corrupts : AX,CX,DX,SI,DI,ES
}


Procedure ShowAllBitmap(TheBmap:pointer); Assembler;
Asm
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
End;









{
This command shows a portion (or all) of the specified bitmap
immediately on screen.


Expects : TheBMap is a pointer to the bitmap to use.
          If set Nil then the current bitmap is used.

          x1,y1,x2,y2 define the rectangular window to be shown.
	  (i.e. values 0,0,319,199 means the entire bitmap)
          DestX, DestY define where the rectangular area shall be
	  placed ** on screen **

          e.g.
          ShowAreaOfBitmap(MyBMap, 0,0,319,199,0,0) would place the entire
          bitmap which resides at MyBMap on the top left of your
	  screen.

Returns : Nothing


Corrupts: AX,BX,CX,DX,SI,DI,Upper word of EBP, ES, direction flag.
}






Procedure ShowAreaOfBitmap( TheBMap: pointer; x1:word; y1:byte;
                            x2:word; y2:byte; DestX:word; DestY: byte);
Assembler;
Asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX                { Instead of pushing BX on stack }
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


{ Check if Nil pointer passed in }

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
     INC CX                     { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL                     { DL = Number of lines to move }

     DB $66; SHL BP,16
     MOV BP,SI                  { Faster than using el pusho }

     MOV BX,DI


@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX

     MOV AX,CX
     CALL PostIncMove

     MOV SI,BP                  { point source & dest to next lines }
     MOV DI,BX

     DEC DL
     JNZ @Outer

     DB $66; SHR BP,16          { Restore the 2 essential registers }
     POP DS
End;













{
==================================================================


SCROLL ROUTINES


------------------------------------------------------------------
}




{
Scroll a rectangular region of the Current Bitmap UP

Expects:  x1,y1,x2,y2 define the rectangular area.
          pixelstep is the number of pixels UP you wish to scroll.

Returns:  Nothing

Corrupts: AX,BX,CX,DX,SI,DI,Upper word of EBP,ES,Direction flag
}



Procedure ScrollUp(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
Asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX                { Instead of pushing BX on stack }
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX

     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     SUB BX,CX
     CALL CalculateOffset    { Calculate address for X1,(Y1 - pixelstep) }
     MOV DI,BX

     PUSH DS

     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX

     MOV CX,X2
     SUB CX,X1
     INC CX             { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL             { DL = Number of lines to move }

     DB $66; SHL BP,16
     MOV BP,SI          { Oh well that's knackered local var access then :) }
     MOV BX,DI


@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX

     MOV AX,CX
     CALL PostIncMove

     MOV SI,BP          { point source & dest to next lines }
     MOV DI,BX

     DEC DL
     JNZ @Outer

     DB $66; SHR BP,16             { Restore the 2 essential registers }
     POP DS
End;







{
Scroll a rectangular region of the Current Bitmap DOWN

Notice how most of the code is similar to scrollup. Well if this was
C/C++ I could've made the code body an inline procedure and then the
source file would've been v. small.

So Borland, how's about upgrading ye olde Pascal?


Expects:  x1,y1,x2,y2 define the rectangular area.
          pixelstep is the number of pixels down you wish to scroll.

Returns:  Nothing

Corrupts: AX,BX,CX,DX,SI,DI,Upper word of EBP,ES, Direction flag
}



Procedure ScrollDown(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
Asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y2
     MOV DX,BX                { Instead of pushing BX on stack }
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX

     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     ADD BX,CX
     CALL CalculateOffset    { Calculate address for X1,(Y1 + pixelstep) }
     MOV DI,BX

     PUSH DS

     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX

     MOV CX,X2
     SUB CX,X1
     INC CX             { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL             { DL = Number of lines to move }


     DB $66; SHL BP,16
     MOV BP,SI          { Oh well that's knackered local var access then :) }
     MOV BX,DI          { ^ Do you get this deja vu feeling I've said that
                          before? :) }


@Outer:
     MOV AX,320
     SUB BP,AX
     SUB BX,AX

     MOV AX,CX
     CALL PostIncMove

     MOV SI,BP          { point source & dest to next lines }
     MOV DI,BX

     DEC DL
     JNZ @Outer

     DB $66; SHR BP,16             { Restore the 2 essential registers }
     POP DS
End;







{
Scroll a rectangular region of the Current Bitmap LEFT

Expects:  x1,y1,x2,y2 define the rectangular area.
          pixelstep is the number of pixels left you wish to scroll.

Returns:  Nothing

Corrupts: AX,BX,CX,DX,SI,DI,Upper word of EBP,ES, Direction flag
}



Procedure ScrollLeft(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
Asm
     MOV AX,X1
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX                { Instead of pushing BX on stack }
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX

     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     SUB AX,CX
     CALL CalculateOffset    { Calculate address for (X1-pixelstep),Y1 }
     MOV DI,BX

     PUSH DS
     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX

     MOV CX,X2
     SUB CX,X1
     INC CX                  { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL                  { DL = Number of lines to move }

     DB $66; SHL BP,16
     MOV BP,SI               { Oh well that's knackered local var
                               access then (spot the block copying) :) }
     MOV BX,DI


@Outer:
     MOV AX,320
     ADD BP,AX
     ADD BX,AX

     MOV AX,CX
     CALL PostIncMove

     MOV SI,BP               { point source & dest to next lines }
     MOV DI,BX

     DEC DL
     JNZ @Outer

     DB $66; SHR BP,16       { Restore the 2 essential registers }
     POP DS
End;







{
Scroll a rectangular region of the Current Bitmap RIGHT

Expects:  x1,y1,x2,y2 define the rectangular area.
          pixelstep is the number of pixels right you wish to scroll.

Returns:  Nothing

Corrupts: AX,BX,CX,DX,SI,DI,Upper word of EBP,ES, Direction flag

Notes:    The PreInc routine was a bloody nightmare to write so it
	  had better be appreciated :)
}



Procedure ScrollRight(x1:word;y1:byte;x2:word;y2,pixelstep:byte); Assembler;
Asm
     MOV AX,X2
     XOR BH,BH
     MOV BL,Y1
     MOV DX,BX                { Instead of pushing BX on stack }
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset
     MOV SI,BX

     MOV BX,DX
     XOR CH,CH
     MOV CL,pixelstep
     ADD AX,CX
     CALL CalculateOffset    { Calculate address for (X1-pixelstep),Y1 }
     MOV DI,BX

     PUSH DS

     MOV AX,CurrentBitmapSegment
     MOV DS,AX
     MOV ES,AX

     MOV CX,X2
     SUB CX,X1
     INC CX             { CX = Number of bytes per line to move }

     MOV DL,Y2
     SUB DL,Y1
     INC DL             { DL = Number of lines to move }


     DB $66; SHL BP,16
     MOV BP,SI          { Oh well that's knackered local var access then :) }
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
End;









{
***********************

PRIMITIVE DRAWING TOOLS

***********************
}






{
PRIVATE TO UNIT!

			WARNING!

Do NOT expect this routine to be present in version 3!
This routine was only provided to speed up calculation
of an offset for the standard VGA 200 line screen.

As a consequence, when the LargeBitmap() functions
become available in V3 (which remove the bitmap size
restrictions) a calculation routine involving a huge
look-up table seems wasteful of memory..

So this'll go! :)
}




Procedure InitOffsets; Assembler;
Asm
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
End;








{
Calculate the address for a pixel on screen.
Private to KojakVGA unit.

          DO NOT ALTER THIS ROUTINE UNLESS YOU KNOW WHAT YOU
          ARE DOING - MESSING UP REGISTERS ** WILL **
	  CAUSE SOME OF THE GRAPHICS ROUTINES TO FAIL !


Expects:  AX = X coord (0-GetMaxX)
          BX = Y coord (0-GetMaxY)
          DS set to point at Data Segment

Returns:  If BX = -1 then coordinates were invalid.
	  Otherwise, BX holds screen offset.

Corrupts: BX

Notes   : I am considering re-writing this so that registers DX:AX
	  hold the offset instead (as I will be using 32bit TASM
          stuff for V3)

	  Other considerations are that I may set the carry flag
          to indicate coordinates are off screen.. should be
          a lot faster than setting BX to -1!

	  For those who don't intend adding/altering any stuff
          to/in this unit, please ignore what I've just said
	  and go back to sleep. :)

}

Procedure CalculateOffset; assembler;
Asm
   CMP AX,319
   JA @InvalidCoord
   CMP BX,199
   JA @InvalidCoord

   SHL BX,1
   ADD BX,OFFSET ScanLineOffsets
   MOV BX,[BX]
   ADD BX,AX
   RET                                  { Don't f*** about with this :) }

@InvalidCoord:
   MOV BX,-1
End;








{
Originally I wanted KojakVGA to be a complete replacement for Borland's
rather slow BGI but it dawned on me that I'd never have the time to
translate all of the BGI commands to Mode13h! What's the point anyway?
A 320x200 BGI already exists.. it doesn't have any of the scrolling/sprite
commands that KojakVGA does though!!!


Expects  : X and Y specify the horizontal and vertical coordinates of
           a pixel. X may be 0..GetMaxX, Y may be 0..GetMaxY.

Returns  : If the coordinates are within screen bounds, then GetPixel =
           Colour at X,Y. If not, then GetPixel = -1.

Corrupts : AX/BX/CX/DX/FS.
}

Function GetPixel(X,Y: integer): integer; Assembler;
Asm
   MOV AX,X
   MOV BX,Y

   CALL CalculateOffset         { Now get offset in BX }
   CMP BX,-1                    { Is coordinate off screen ? }
   JZ @NoGet                    { Yes, so return value of -1 }
   ADD BX,CurrentBitmapOffset    { Otherwise, take into account the
                                  Current Bitmap offset too }

   DB $8E, $26
   DW OFFSET CurrentBitmapSegment

   XOR AH,AH
   DB $64
   MOV AL,[BX]

   JMP @Finished                { Can't put a RET here - maybe this
                                  unit was compiled in FAR mode, and
                                  a crash would occur! }

@NoGet:
   MOV AX,BX                    { AX = -1, meaning no pixel could be
                                  read }

@Finished:
End;






{
Write a pixel to the screen.

Expects  :  AX to be the X coord for a pixel (0 to GetMaxX),
	    BX for the Y coord (0 to GetMaxY) - Don't be tempted
	    to optimize the code by using BL, as this causes
            problems when using negative Y coordinates. (As some
            programs will)
            DL is the colour (0 to 255) to plot.

Returns  :  Nothing

Corrupts :  AX,BX,CX,DL,FS

Notes    :  This putpixel is private to the unit and should be
            used when plotting pixels that MAY be off screen
            to keep in step with the rest of the unit.

}


Procedure FPutPixel; Near; Assembler;
Asm
   CALL CalculateOffset                 { AX/ BX already set up }
   CMP BX,-1                            { Coordinates off screen ? }
   JZ @NoPlot                           { Yeah, so don't put pixel }
   ADD BX,CurrentBitmapOffset

   DB $8E,$26                           { MOV FS, [CurrentBitmapSegment] }
   DW OFFSET CurrentBitmapSegment
   DB $64                               { MOV [FS:BX],DL }
   MOV [BX],DL

@NoPlot:
End;







{
If Turbo Pascal supported 'Macros' or inline procedures (NOT COMPOSED
OF 99000 HEXADECIMAL CODES) then this would have been perfect.


Expects  : X = Horizontal coordinate of a pixel (0-GetMaxX)
           Y = Vertical coordinate of a pixel (0-GetMaxY)
	   ColourValue = Colour to plot , 0 - 255.

Returns  : Nothing

Corrupts : See FPutPixel.
}

Procedure PutPixel(x, y : integer; ColourValue : Byte); Assembler;
Asm
   MOV AX,x               { Wish pascal allowed Macros! }
   MOV BX,y
   MOV DL,ColourValue
   CALL FPutPixel         { Don't use a JMP, your program will crash }
End;









{
(Smarmy comment removed) Draw a line. (temptation to add smarmy
comment resisted :) )


Expects : X1,Y1 defines the horizontal, vertical start of the line
          X2,Y2 defines the horizontal, vertical end of the line.
	  Coordinates may be negative or exceed screen bounds.
          Line will be drawn in CurrentColour, and will be clipped
          as necessary.


Returns : Nothing

Corrupts: AX,BX,CX,DX,SI,DI,ES,FS.

Notes   : Sean Palmer's line draw routine IS fast (faster than this!)
          but there is absolutely NO LINE CLIPPING in Sean's
          procedure so drawing off the screen edges causes (ahem)
          problems. And no, I couldn't be bothered adding my own
	  clipping algorithms to his code either.



}


Procedure Line(X1, Y1, X2, Y2: Integer); Assembler;
Var
  LgDelta,
  ShDelta,
  LgStep,
  ShStep,
  Cycle : word;

Asm
  MOV BX,X2               { LgDelta = X2 - X1 }
  MOV SI,X1
  SUB BX,SI
  MOV LgDelta,BX

  MOV CX,Y2               { ShDelta = Y2 - Y1 }
  MOV DI,Y1
  SUB CX,DI
  MOV ShDelta,CX

  TEST BH,$80             { If bit 7 not set .. }
  JZ @LgDeltaPos          { Goto LgDeltaPos }

  NEG BX
  MOV LgDelta,BX
  MOV LgStep,-1
  JMP @Cont1

@LgDeltaPos:
  MOV LgStep,1

@Cont1:
  CMP CH,$80             { If ShDelta < 0 Then.. }
  JB @ShDeltaPos
  NEG CX
  MOV ShDelta,CX
  MOV ShStep,-1          { Means move up }
  JMP @Cont2

@ShDeltaPos:
  MOV ShStep,1           { Means move down }

@Cont2:
  CMP BX,CX              { BX = LgDelta, CX = ShDelta }
  JB @OtherWay

  SHR BX,1               { Cycle:= LgDelta SHR 1 }
  MOV Cycle,BX

  MOV CX,X2


{
Best to leave AX free actually as it's the fastest register to work with
}



@FirstLoop:
  CMP SI,CX              { While X1 <> X2 }
  JZ @GetTheShitOut      { When end of line reached }

  MOV AX,SI              { Set AX and BX to X1,Y1 ready for call }
  MOV BX,DI              { BX = Y1 }

  MOV DL,CurrentColour
  CALL FPutPixel

  ADD SI,LgStep         { X1 = X1 + LgStep }
  MOV AX,Cycle
  ADD AX,ShDelta         { Inc(Cycle,ShDelta) }
  MOV Cycle,AX           { Yes I did check the code and this is fastest }

  MOV BX,LgDelta
  CMP AX,BX              { If Cycle > LgDelta }
  JB @FirstLoop

  ADD DI,ShStep          { Y1 = Y1 + ShStep }
  SUB Cycle,BX           { Dec(Cycle,LgDelta) }
  JMP @FirstLoop

  {
  O.K. If we go in a different direction..

  On entry, BX = LgDelta, CX = ShDelta

  }

@OtherWay:
  MOV AX,CX
  SHR AX,1              { ShDelta SHR 1 }
  MOV Cycle,AX
  XCHG BX,CX            { BX = ShDelta, CX = LgDelta }
  MOV LgDelta, BX
  MOV ShDelta, CX

  MOV AX,LgStep         { Swap LgStep and ShStep round }
  MOV BX,ShStep
  MOV ShStep,AX
  MOV LgStep,BX

  MOV CX,Y2



@SecondLoop:
  CMP DI,CX             { While Y1 <> Y2 do }
  JZ @GetTheShitOut


{
If it can, then it's time for action!
}

  MOV AX,SI             { Set AX and BX to X1,Y1 }
  MOV BX,DI             { BX = Y1 }

  MOV DL,CurrentColour
  CALL FPutPixel

  ADD DI,LgStep         { Inc(Y1,LgStep) }
  MOV AX,Cycle          { Inc(Cycle,ShDelta) }
  ADD AX,ShDelta
  MOV Cycle,AX

  MOV BX,LgDelta

  CMP AX,BX             { If Cycle > LgDelta Then.. }
  JB @SecondLoop

  ADD SI,ShStep         { Inc(X1,ShStep) }
  SUB Cycle,BX          { Dec(Cycle,LgDelta) }
  JMP @SecondLoop


@GetTheShitOut:
  MOV AX,X2             { Write last pixel. This was an absolute }
  MOV BX,Y2             { b****** to debug :-) }
  MOV DL,CurrentColour
  CALL FPutPixel        { Just a wee bit of Scottish humour there }

End;
















{
Draw a line relative from the current cursor position.
Relative means that the DiffX and DiffY values are added to the
current cursor coordinates to give the resulting horizontal and vertical
end points of the line.

For example, if CursorX and CursorY were 10,10 and DiffX and DiffY
were -10,-10 then the line would be drawn to position 0,0. Conversely,
if DiffX was 10 and DiffY was 20 then the cursor would be drawn to
X 20, Y 30.


Expects : DiffX is a non zero value that may be negative, which
          specifies the relative distance from the current horizontal
          cursor position.

	  DiffY specifies the relative distance from the current
          vertical position.

Returns : Nothing

Corrupts : Probably the same as the Line routine.
}

Procedure LineRel(DiffX,DiffY: integer); Assembler;
Asm
     MOV  AX,CursorX    { Calculate X + DiffX }
     MOV  BX,AX
     ADD  AX,DiffX
     PUSH AX

     MOV  AX,CursorY    { Y + Diffy }
     MOV  CX,AX
     ADD  AX,DiffY
     PUSH AX

     PUSH BX            { X }
     PUSH CX            { Y }

     CALL Line

End;








{
Draw from the current cursor position to the horizontal and vertical
positions specified by EndX and EndY. The Graphics Cursor will be
moved to EndX, EndY.

Expects : EndX to be the horizontal position of the line end. (0 to GetMaxX)
	  EndY to be the vertical position of the line end. (0 to GetMaxY)

Returns : Nothing, but you should be aware that the graphics cursor
          position is now at EndX, EndY.

Corrupts : AX,BX,CX,DX,SI,DI,ES,FS

Notes   : The Pascal stack frame is mighty strange!
	  When pushing values on stack for the line(x1,y1,x2,y2) call
          this is the order:

          PUSH EndX
	  PUSH EndY
          PUSH CursorX
	  PUSH CursorY

          Why is that?

          Why not:

          PUSH CursorX
	  PUSH CursorY
          PUSH EndX
          PUSH EndY

          ?
}


Procedure LineTo(EndX,EndY:integer); Assembler;
Asm
   PUSH EndX
   PUSH EndY
   PUSH CursorX
   PUSH CursorY
   CALL Line
   MOV AX,EndX
   MOV CursorX,AX
   MOV AX,EndY
   MOV CursorY,AX
End;







{
I STILL couldn't be bothered optimizing this, as, lets face it
it's fast enough already for my uses and typing in 20 PUSH
instructions is not my idea of breaking programming boundaries :)


Expects  : X1,Y1,X2,Y2 define the rectangular area.

Returns  : Nothing

Corrupts : See Line Routine.

Notes    : This routine does not move the graphics cursor.
}


Procedure Rectangle(x1,y1,x2,y2:integer);
Begin
     Line(x1,y1,x2,y1);         { Top Line    }
     Line(x1,y2,x2,y2);         { Bottom Line }
     Line(x1,y1+1,x1,y2-1);     { Left edge   }
     Line(x2,y1+1,x2,y2-1);     { Right edge  }
End;












{
Change position of graphics cursor.

Expects : NewCursX and NewCursY are the horizontal and vertical
          coordinates that you wish to move the cursor to.
          NewCursX may be negative or more than GetMaxX.
          NewCursY may be negative or more than GetMaxY.

Returns : Nothing

Corrupts : AX.
}


Procedure MoveTo(NewCursX,NewCursY:integer); Assembler;
Asm
   MOV AX,NewCursX
   MOV CursorX,AX
   MOV AX,NewCursY
   MOV CursorY,AX
End;










{
Returns horizontal position of graphics cursor.
GetX May be negative.

Expects : Nothing

Returns : GetX = Current graphics cursor horizontal position, which
          may be negative or even exceed GetMaxX.
}


Function GetX: integer; Assembler;
Asm
   MOV AX,CursorX
End;








{
Returns vertical position of graphics cursor.
GetY may be negative.

Expects : Nothing

Returns : GetY = Current graphics cursor vertical position, which
          may be negative or even exceed GetMaxY.

Notes   : Yet another suitable candidate for an inline procedure
	  or macro!!!
}

Function GetY: integer; Assembler;
Asm
     MOV AX, CursorY
End;














{
====================================================================


SPRITE FUNCTIONS


--------------------------------------------------------------------

}




{
Get the width of a shape

Expects : DataPtr^ points to a shape in memory

Returns : Width of shape (1-255)

Corrupts : ES, DI
}

Function ShapeWidth(Var DataPtr): byte; assembler;
Asm
   LES DI,DataPtr
   MOV AL,[ES:DI]
End;






{
Get the height (in pixels) of a shape.

Expects : DataPtr^ points to a shape held in memory

Returns : Height of shape (1-255)

Corrupts : ES,DI
}

Function ShapeHeight(Var DataPtr): byte; assembler;
Asm
   LES DI,DataPtr
   MOV AL,[ES:DI+1]
End;







{
This Function returns the number of bytes required to store
a shape object of a given width and height.

Expects  : ShapeWidth is the width of the Shape (1-255). You can
	   obtain the width of a shape by using the ShapeWidth
           Function above.

	   Shapeheight is the height of the Shape (1-255). You can
           obtain the height of a shape by using the ShapeHeight
           Function above.

Returns  : ExtShapeSize = No of bytes shape uses.


Corrupts : AL,BL.

}


Function ExtShapeSize(ShapeWidth, ShapeHeight : byte): word; Assembler;
Asm
   MOV AL, ShapeWidth
   MOV BL, ShapeHeight
   MUL BL
   INC AX
   INC AX
End;









{
Calculate the number of bytes required to hold a shape in memory,
if grabbed from the screen.

Expects :     X1, Y1, X2, and Y2 define a rectangular region that
              lies on an imaginary screen (No reading of source/
              dest Bitmap is done!). X1 and X2 must be in the range of
              0-319; Y1 and Y2 must be in the range of 0-199.

              You are restricted to images up to 255 x 200 pixels
              in size. (Why 200? Well, you can't grab past the
	      vertical limits of the VGA screen can you ?)

	      Next version of KOJAKVGA allows the user to grab sprites
	      of any size.. And yes, I WILL write a sprite conversion
	      utility so that you don't need to re-grab images for the
	      new shape format required.



Returns :     Number of bytes used to hold image. If 0, then this
              means the image is too large to load into a 64K
	      portion of RAM.

Corrupts :    BX,DX.
}


Function ShapeSize(x1,y1,x2,y2:word):word; Assembler;
Asm
     MOV AX,x2          { Width = (X2 - X1) + 1 }
     SUB AX,x1
     INC AX             { Add one extra width byte }
     AND AH,$7F
     OR AH,AH
     JNZ @TooBig

     MOV BX,y2          { Height = (Y2 - Y1) + 1 }
     SUB BX,y1
     INC BX
     AND BH,$7F         { And again }
     CMP BX,201
     JB @ShapeFine      { No, shape is OK in width and height }

@TooBig:
     XOR AX,AX          { Set AX to return 0, meaning error }
     JMP @Finished

@ShapeFine:
     MUL BL             { SpriteDataSize = Width * Height }
     INC AX
     INC AX

@Finished:
End;











{
Display a shape at a given position on the Current Bitmap,
over the current background (Most games with sprites use this
technique). Hopefully this'll be the fastest sprite routine in the
SWAG. If not, then gimme pointers in the right direction and I'll
be glad to update this... (please DON'T refer me to Intel manuals
telling me about clock cycles/T-states etc)


Expects : X and Y specify a horizontal and vertical position for
          the TOP LEFT of a shape. (Regardless whether or not the
          shape's edge is transparent)

          X and Y are presumed ALWAYS valid : i.e. Within bounds of
          Current Bitmap; Also, it is presumed that the sprite is not
          placed in a position on screen that over runs the screen
          borders: unexpected effects would occur. Sorry! Use
          ClipBlit if you must place sprites in the border.

	  DataPtr, the untyped variable, must point to data for a
          sprite which is up to 255 pixels wide and 200 pixels
          tall.

Returns : Nothing

Corrupts : AX,BX,CX,DX,SI,DI,ES, & Direction Flag

}


Procedure Blit(x,y:word; Var DataPtr); Assembler;
Asm
   MOV AX,x
   MOV BX,y
   CALL CalculateOffset         { Calculate where to blit to }

   MOV ES,CurrentBitmapSegment   { Point ES to Current Bitmap }

   MOV CX,DS                    { Faster than stack }
   LDS SI,DataPtr               { resides in memory. }

   MOV DX,[SI]                  { Get Width into DL and height to DH }
   INC SI                       { Faster than ADD SI,2 - I think }
   INC SI
   CLD                          { Make sure writes are descending }

   MOV AH,DL                    { Save width in CL }

@Outer:
   MOV DL,AH                    { Reload DL }
   MOV DI,BX                    { DI = Where to write to }


@Main:
   LODSB                { Read byte from DS:SI }
   OR AL,AL             { Is it value 0, meaning transparent ? }
   JZ @NoBlit           { Yes, so ignore byte }
   MOV [ES:DI],AL       { Otherwise write it to the screen. Don't
                          use STOSB ! }

@NoBlit:
   INC DI
   DEC DL               { Reduce horizontal counter }
   JNZ @Main            { If not zero then do next byte of the
			  sprite column }

@NextScanLine:
   ADD BX,320           { Move down 1 scan line }
   DEC DH               { Reduce vertical count }
   JNZ @Outer           { If not all lines of sprite done back to @Outer }
   MOV DS,CX            { Restore Data Segment }
End;











{
This routine writes a shape to the Current Bitmap with no Colour 0
transparency, totally overwriting everything "beneath" it.
Also, there is no clipping of Shape. (Use ClipBlock for this
purpose)

Expects  : X and Y specify the horizontal and vertical coordinate
           of the Shape pointed to by DataPtr.

Returns  : Nothing

Corrupts : AX,BX,CL,DX,SI,DI,ES

Notes    : Block is especially useful for "tile" based maps.
}

Procedure Block(x,y:word; Var DataPtr); Assembler;
Asm
   MOV AX,x
   MOV BX,y
   CALL CalculateOffset
   CMP BX,-1                    { Off screen ? }
   JZ @StupidUser
   ADD BX,CurrentBitmapOffset


   MOV DX,DS                    { Save DS with DX }
   MOV ES,CurrentBitmapSegment   { ES: BX -> Where sprite written to }

   CLD                          { Make sure writes are descending }
   LDS SI,DataPtr               { This has to be last access of memory
				  variable as DS is now altered }
   MOV CX,[SI]                  { Get width into CL, height into CH }
   INC SI
   INC SI


@Outer:
   MOV DI,BX                    { DI = Offset into VGA screen }
   MOV AL,CL                    { AL = Width of sprite }

   CMP AL,4                     { Bytes left < 4 ? }
   JB @MoveRemaining            { Yeah, so can't do the 4 byte blit }

   SHR AL,2                     { Divide Bytes left by 4 }

@CopyLong:
   DB $66                       { Otherwise, store longword to [ES:DI] ! }
   MOVSW
   DEC AL                       { AL is long word count }
   JNZ @CopyLong                { If AL <> 0 go back to CopyLong }

   TEST CL,3                    { Any remaining bytes to move ? }
   JZ @NoBytesLeft              { nah! }

   MOV AL,CL
   AND AL,3

@MoveRemaining:
   MOVSB                        { Store the remaining bytes }
   DEC AL
   JNZ @MoveRemaining


@NoBytesLeft:
   ADD BX,320                   { Advance BX to next scan line }
   DEC CH                       { Reduce Y count }
   JNZ @Outer                   { if <>0 then go to Outer }
   MOV DS,DX                    { Restore DS }

@StupidUser:
End;











{
Perform clipping calculations on an object.

Expects : AX to be an X coordinate for a sprite
          BX to be a Y coordinate
          ES:DI to point to the sprite data

Returns : If no draw can be done, carry is set TRUE.
	  Else carry is FALSE and :

          SI will point to first byte to blit
          DI will be the VGA screen offset for first blit
          (ES still is at sprite segment however so must
	  be changed afterwards)
          CL is the number of bytes to blit ACROSS
	  CH is the number of bytes to blit DOWN
          DX is the MODULO for the image (i.e. how many bytes SI should
          skip (after reload) to get to the start of next row of
          sprite data)

Notes :   Unless you are planning to write extra routines which may
          clip images up to 256 x 256 it is wise to leave this Procedure
	  as private to the unit as it is quite complex.
}


Procedure ClipCalculations; Near; Assembler;
Asm
   CMP BX,199              { Y > 199 ? }
   JG @NoDraw              { JG is for SIGNED integers. If Y pos is
                             > 199 then no blit }

   CMP AX,319              { X > 319 ? }
   JG @NoDraw              { Yes, Do not do any blits at all }

   MOV SI,DI
   INC SI
   INC SI                  { Make SI point to actual sprite data }

   XOR CH,CH
   MOV CL,[ES:DI]          { CL holds Clipwidth }

   CMP AH,$80              { Quick test if X position is negative }
   JB @XNotNegative        { If not then check if image is off right hand
                             of screen }
   NEG AX                  { Make X position positive }

   CMP AX,CX               { If Abs(X) >= Image Width Then Don't Draw }
   JA @NoDraw

   SUB CX,AX               { Dec(ClipWidth, Abs(X)) }
   ADD SI,AX               { Inc(DataStart, Abs(X)) }
   XOR AX,AX               { Set X to 0 }
   JMP @NowDoY             { Do Y portion of data now. }


@XNotNegative:
   MOV DX,CX               { Set DX to clipwidth }
   ADD DX,AX               { If X + ClipWidth < 320 Then }
   CMP DX,320
   JB @NowDoY              { Do Y part (No need to clip width) }
   MOV CX,320
   SUB CX,AX               { ClipWidth = 320 - X }


{
At this point:

AX is the X position of the Shape
BX is the Y position of the Shape
CL is the clipped width of the Shape.

Now it is time to do the height part and set the result in
CH.
}

@NowDoY:
   XOR DH,DH               { Make DX the height of image }
   MOV DL,[ES:DI+1]
   MOV CH,DL               { Set CH also to height for main blit routine }

   CMP BH,$80              { Quick test if Y position is negative }
   JB @YNotNegative

   NEG BX                  { Make Y a positive number }

   CMP BX,DX               { If Y > ClipHeight }
   JA @NoDraw
   SUB DX,BX               { Dec(ClipHeight, Abs(Y) ) }
   MOV CH,DL               { As an image can only be 255 bytes high
                             this works fine.. }
   PUSH AX                 { Save X Coord on stack }
   XOR AH,AH
   MOV AL,[ES:DI]          { AX = Width }
   MUL BX                  { Calculate Y * Width }
   ADD SI,AX               { Inc(DataStart, Abs(Y) * Width ) }
   POP AX
   XOR BX,BX               { Set Y to 0 }
   JMP @NowDoBlit          { NOW do the blit work. Whew! }



@YNotNegative:
   ADD DX,BX               { If Y + ClipHeight > 199 Then }
   CMP DX,200
   JB @NowDoBlit
   MOV DX,200
   SUB DX,BX               { ClipHeight = 200 - Y }
   MOV CH,DL


{
At this point AX is the X position
              BX is the Y position
              CL is the ClipWidth and
              CH is the ClipHeight.

As the width/height of a shape can only be an 8 bit
quantity (i.e. < 256) I can discard the H portions of
the registers. Whew!

Now follows some weird code.. I'm going to make :

DX = Modulo for datastart (which is the width in bytes of Shape.
And yes, I do know that Width could be held in DL but adding extra
code just to satisfy you optimisation junkies is v. boring.)

DS:SI already points to data
ES:DI points to active (source) Bitmap

}

@NowDoBlit:
   PUSH CX                     { Save ClipWidth & ClipHeight on stack }
   CALL CalculateOffset        { Use AX and BX to calculate screen
                                 offset. On exit BX is offset }
   POP CX                      { Restore ClipWidth and ClipHeight }
   ADD BX,CurrentBitmapOffset


   XOR DH,DH
   MOV DL,[ES:DI]              { DX = Modulo }
   MOV DI,BX                   { Ahhh. Now DI points to the screen offset }
   CLC
   JMP @End

@NoDraw:
   STC                         { Indicate no blit possible }

@End:
End;









{
This routine does the same as Blit but takes into account
the fact that the sprite may be off the edges of the
screen.

Its quite a bit slower than the normal Blit, but that's only
to be expected as there's more computations to be
done.

Expects  : X, Y specify the horizontal and vertical position of the Shape,
          DataPtr points to the data to blit.

Returns  : Nothing

Corrupts : AX, BX,CX,DX,SI,DI,ES.
}



Procedure ClipBlit(x,y:integer; Var DataPtr); Assembler;
Asm
   MOV AX,X
   MOV BX,Y
   LES DI,DataPtr
   CALL ClipCalculations
   JC @NoDraw

   MOV AX,DS
   DB $66; SHL AX,16           { Save DS in upper word of EAX }
   DB $66; SHL BP,16           { Save BP in upper word of EBP }

   MOV AX,CurrentBitmapSegment
   MOV BX,ES
   MOV DS,BX                   { Now DS: SI points to correct space }
   MOV ES,AX

   MOV BX,SI                   { BX to be used to reload SI }
   MOV BP,DI                   { And the screen modulo }

   MOV AH,CL                   { AH = Width }
   CLD                         { Make sure LODSB works OK }

@Outer:
   MOV CL,AH                   { Re-load CL }
   MOV SI,BX                   { And SI with address of next sprite row }
   MOV DI,BP                   { And DI with address of next scan line }


@WriteByte:
   LODSB                       { Read byte from DS:SI }
   OR AL,AL                    { Is byte 0 (transparent) ? }
   JZ @NoBlit                  { yes, so don't blit }
   MOV [ES:DI],AL              { Otherwise store byte }

@NoBlit:
   INC DI                       { Move DI to next pos. on screen }
   DEC CL                       { Reduce shape width count }
   JNZ @WriteByte               { If not zero, end of shape not reached }

   ADD BX,DX                    { BX = BX + Modulo, so BX now points
				  to first byte of next sprite line
				  to blit }
   ADD BP,320                   { Make BP point to next line. Note :
				  If you are going to add some extra
				  stuff here make sure you're not
				  accessing local variables! }


   DEC CH
   JNZ @Outer

   DB $66; SHR BP,16
   DB $66; SHR AX,16
   MOV DS,AX
@NoDraw:
End;

{
This routine does the same as Block except that it takes into account
that the shape object may be off screen.

Expects  : Same as Block.

Returns  : Nothing

Corrupts : AX,BX,CX,DX,SI,DI,ES.
}



Procedure ClipBlock(x,y:integer; Var DataPtr); Assembler;
Asm
   MOV AX,X
   MOV BX,Y
   LES DI,DataPtr          { ES:DI points to data }
   CALL ClipCalculations
   JC @NoDraw


{
Prepare for blit !
}

   PUSH DS
   PUSH BP

   MOV AX,CurrentBitmapSegment
   MOV BX,ES
   MOV DS,BX                   { Now DS: SI points to correct space }
   MOV ES,AX

   MOV BX,SI                   { BX to be used to reload SI (+Image Width) }
   MOV BP,DI                   { And BP to reload DI (+Screen Width) }

   CLD                         { Make sure LODSB works OK }

@Outer:

   MOV AL,CL                   { AL is set to ClipWidth }

   MOV SI,BX
   MOV DI,BP

   CMP AL,4                     { Bytes left < 4 ? }
   JB @MoveRemaining            { Yeah, so can't do the longword blit }

   SHR AL,2                     { Divide Bytes left by 4 }

@CopyLong:
   DB $66                       { Otherwise, store longword to [ES:DI] ! }
   MOVSW
   DEC AL                       { Reduce long word count }
   JNZ @CopyLong

   TEST CL,3
   JZ @NoBytesLeft

   MOV AL,CL                    { As AL is faster }
   AND AL,3

@MoveRemaining:
   MOVSB
   DEC AL
   JNZ @MoveRemaining




@NoBytesLeft:
   ADD BX,DX                    { BP to next byte of image to read }
   ADD BP,320                   { Advance BX to next scan line }

   DEC CH                       { Reduce Y count }
   JNZ @Outer                   { if <>0 then go to Outer }

   POP BP                       { Restore base pointer and }
   POP DS                       { Data Segment }

@NoDraw:
End;



















{
Grab a rectangular area of bytes from the Current Bitmap for use
as a shape object.


Expects     : X1,Y1 define the TOP LEFT of the area to grab.
              X2,Y2 define the BOTTOM RIGHT of the area.

	      X1 MUST be less than X2;
              Similarly, Y1 MUST be less than Y2.

              Also, it is NOT possible to grab an image that
              is more than 255 pixels wide and 200 pixels
              high.

Returns     : Nothing

Notes       : Use the ExtShapeSize or ShapeSize Functions to
              calculate bytes needed to hold shape object in
              memory .

              An example:

	      GetMem(shapeptr,ShapeSize(0,0,15,15));
              GetAShape(0,0,15,15,ShapePtr^);
              Blit... etc etc.
              FreeShape(shapeptr);


Corrupts    : AX,BX,CX,DX,SI,DI,ES

}


Procedure GetAShape(x1,y1,x2,y2:word;Var DataPtr); Assembler;
Asm
   MOV AX,x1
   MOV BX,y1
   CALL CalculateOffset
   CMP BX,-1
   JZ @StupidUser
   ADD BX,CurrentBitmapOffset


   MOV AX,x2                    { Width = (X2 - X1) +1 }
   SUB AX,x1
   INC AX                       { Take into account extra pixel }
   MOV CL,AL

   MOV AX,y2                    { Height = (Y2 - Y1) +1 }
   SUB AX,y1
   INC AX
   MOV CH,AL

   LES DI,DataPtr
   MOV [ES:DI],CX               { Store Width & Height }
   INC DI
   INC DI

   MOV DX,DS

   MOV DS,CurrentBitmapSegment
   CLD                          { Make sure writes are descending }


@Outer:
   MOV SI,BX                    { SI = Offset into VGA screen }
   MOV AL,CL                    { AL = Width of sprite held in CL }

   CMP AL,4                     { Bytes left < 4 ? }
   JB @MoveRemaining            { Yeah, so can't do the 4 byte blit }

   SHR AL,2                     { Divide Count by 4 }

@CopyLong:
   DB $66                       { Otherwise, store longword to [ES:DI] ! }
   MOVSW
   DEC AL                       { CL is long word count }
   JNZ @CopyLong                { If CL <> 0 go back to CopyLong }

   TEST CL,3
   JZ @NoBytesLeft

   MOV AL,CL
   AND AL,3

@MoveRemaining:
   MOVSB                        { Write remaining bytes }
   DEC AL
   JNZ @MoveRemaining


@NoBytesLeft:
   ADD BX,320                   { Advance BX to next scan line }
   DEC CH                       { Reduce Y count }
   JNZ @Outer                   { if <>0 then go to Outer }

   DB $66; SHR AX,16
   MOV DS,DX                    { Restore data segment }


@StupidUser:
End;












{
This routine checks if the data contained within a Shape will
"Collide" with the background. (Background data is held within
the Current Bitmap)

This command is very useful for games that need accurate
Shape to background collision detection.

Expects : X and Y specify the horizontal and vertical position
          of a shape pointed to by DataPtr.

Returns : If the Shape has collided with ANY background (represented
          by colours 1-255) on the Current Bitmap then BlitColl is TRUE.

Corrupts : AX,BX,CX,DX,SI,DI,upper word of EBP,ES
}



Function BlitColl(x,y :integer; Var dataptr) : boolean; Assembler;
Asm
   MOV AX,x
   MOV BX,y
   CALL CalculateOffset         { On exit, BX will hold screen "Offset" }
   ADD BX,CurrentBitmapOffset


   MOV ES,CurrentBitmapSegment

   PUSH DS
   DB $66; SHL BP,16       { Save BP in upper word of EBP }

   LDS SI,DataPtr


   MOV DX,[SI]             { DL= Width, DH = Height }
   INC SI
   INC SI                  { Make SI point to sprite data }

   CLD                     { Make sure writes are descending }

   MOV CL,DL

@Outer:
   MOV DI,BX               { DI = Offset into Current Bitmap }
   MOV DL,CL

{ Check if any long words can be checked }

   CMP DL,4                { Is width at least 4 bytes ? }
   JB @CantCheckLong       { No }
   SHR DL,2                { Otherwise, divide width by 4 so that
                             DL will hold number of LONGs to check }


@CheckLong:
   DB $66; LODSW           { LODSD : Load EAX from DS:SI }
   DB $66; OR AX,AX        { OR EAX,EAX }
   JZ @NoCheckBackLong     { If EAX is zero then no point in checking
			     background is there ? }

   DB $66
   MOV BP,AX               { Make a copy of EAX }
   DB $66
   XOR AX,[ES:DI]          { XOR EAX, [ES:DI]  (Xor EAX with Background) }
   DB $66
   CMP BP,AX               { Is EAX unaffected by the XOR - i.e.
                             No collision }
   JNZ @CollisionOccurred


@NoCheckBackLong:
   ADD DI,4                { Bump DI to next long word }
   DEC DL                  { Reduce long word count }
   JNZ @CheckLong          { And now do the collision check for long word }



   MOV DL,CL               { Restore DL to it's previous contents }
   AND DL,3                { Mask out all but bits 0 & 1 }


{ Any words left to be checked ? }

@CantCheckLong:
   CMP DL,2                { Is there at least 2 bytes left to move ? }
   JB @CantCheckWord       { No }

@CheckWord:
   LODSW                   { Read word from DS:SI into AX }
   OR AX,AX                { Is Shape data zero ? }
   JZ @CantCheckWord       { Yes, so can't be a collision }

   MOV BP,AX
   XOR AX,[ES:DI]          { Otherwise, check background too }
   CMP BP,AX               { Is AX different ? }
   JNZ @CollisionOccurred  { Yes, so this means a collision }
   ADD DI,2                { Otherwise move to next word }

@CantCheckWord:
   TEST CL,1               { Is there a single byte left to check }
   JZ @AllChecksDone       { Nope }
   LODSB                   { Otherwise, read it }
   OR AL,AL                { Zero ? }
   JZ @AllChecksDone       { Yes, so basically no more checks to do }

   MOV CH,AL
   XOR AL,[ES:DI]          { No, so check background byte }
   CMP CH,AL               { Is AL different ? }
   JNZ @CollisionOccurred  { Yes, so a collision has occurred }


@AllChecksDone:
   ADD BX,320              { 320 is the number of bytes in one scan-line }
   DEC DH                  { Reduce vertical count (Counts from height of Shape) }
   JNZ @Outer              { If <>0 then check for next line of Shape }
   MOV AL,False            { If all lines have been done then this means
			     that no collision has occurred }

   JMP @Exit               { And exit. Don't insert a RET here -
                             you'll crash the program ! }

@CollisionOccurred:
   MOV AL,True             { This part is only reached if a collision has
                             occurred. }

@Exit:
   DB $66; SHR BP,16       { Restore Base Pointer }
   POP DS                  { Restore data segment }
End;














{
Scale a shape object (as if you hadn't guessed) :)
Code originally by Sean Palmer, optimised and converted into
32 bit assembler by Scott Tunstall.

A question Sean: did you figure the algorithm out by yourself?
If you did you must be a genius mate :)



Expects : DataPtr^ points to the shape to scale
          x1,y1,x2,y2 define the window on the Current Bitmap
          where the sprite will be scaled TO.

Returns : Nothing


Corrupts: AX,BX,ECX,DX,ESI,DI,ES
}




Procedure ScaleShape(var DataPtr; x1:word;y1:byte;x2:word;y2:byte);
assembler;

type
  fixed = record
    case boolean of
      true  : (w : longint);
      false : (f, i : word);
    end;

var
  x,y        : word;  { Makes those muls easier }
  s, w, h    : word;
  sx, sy, cy : fixed;

asm
     MOV SI, WORD PTR DataPtr
     MOV ES, WORD PTR DataPtr+2

     XOR AH,AH                  { Get shape width into X }
     MOV AL,[ES:SI]
     MOV x,AX
     INC SI

     MOV AL,[ES:SI]             { Get shape height into Y }
     MOV y,AX
     INC SI

     MOV AX,x1
     XOR BH,BH
     MOV BL,y1
     CALL CalculateOffset
     ADD BX,CurrentBitmapOffset

     MOV DI,BX

     MOV BX,x2
     XCHG AX,BX                 { AX = X2, BX = X1 }
     SUB AX,BX
     INC AX
     MOV CX,AX
     MOV w,AX

     MOV AX,320                 { s = 320 - w }
     SUB AX,CX
     MOV s,AX

     XOR DX,DX                  { Make DX:AX = 65536 }
     INC DL
     XOR AX,AX
     DIV CX                     { 65536 / w }

     MUL x                      { * x }
     MOV WORD [sx.w],AX
     MOV WORD [sx.w+2],DX


     XOR AH,AH                  { Calc (y2 - y1) + 1 }
     MOV AL,y2
     SUB AL,y1
     INC AL
     MOV h,AX                   { h = result }
     MOV BX,AX

     XOR DX,DX                  { Make DX:AX = 65536 }
     INC DL
     XOR AX,AX
     DIV BX                     { 65536 / h }
     MUL y                      { * y }
     MOV WORD [sy.w],AX
     MOV WORD [sy.w+2],DX

     DB $66; XOR AX,AX
     DB $66; MOV WORD PTR cy.w, AX



     PUSH DS

     MOV AX,ES
     MOV ES,CurrentBitmapSegment
     MOV DS,AX




{
At this point

   CX    = width
   DX    = height
   DS:SI = points to top left of shape
   ES:DI = points to ADDress on screen where scaled shape
           will be placed
}


    cld


@L2:

    MOV AX,SI                   { I THINK this is faster than a push }
    DB $66; SHL SI,16           { I mean, there are no memory accesses }
    MOV SI,AX                   { right ? Nor any stack pointer updates }


    MOV  AX, cy.i
    MUL  X                      { It would have been nice if intel
                                  created a 16 bit MUL which didn't
                                  f**k up DX }
    ADD  SI,AX


    MOV  AX,CX                  { Get width }
    DB $66; shl CX,16           { Put it in MSW of EAX }
    MOV  CX, AX

    XOR  BX, BX
    MOV  DX, sx.f

@L:
    MOV AL,[SI]
    STOSB

    ADD  BX, DX
    ADC  SI, sx.i               { if carry or sx.i<>0,
				  new source pixel }

    DEC CX
    JNZ @L

    DB $66; SHR SI,16           { Restore SI }
    DB $66; SHR CX,16           { And CX }

    ADD  DI, s                  { skip to next screen row}
    DB $66; MOV  AX, sy.f       { MOV EAX, sy.f }
    DB $66; ADD  cy.f, AX       { ADD DWORD PTR cy.f, EAX }

    DEC  WORD PTR h
    JNZ  @L2
    POP  DS
end;









{
This routine flips a shape object horizontally. The original shape object
is replaced with it's mirror image.


Expects : DataPtr^ points to the shape object to flip.

Returns : Nothing

Corrupts: AX, BX, CX, DX, ESI, EDI

}



Procedure XFlipShape(Var DataPtr); Assembler;
Asm
     PUSH DS
     LDS SI,DataPtr

     XOR DH,DH          { DX = Modulo (Used to get from 1 line to next) }
     MOV DL,[SI]
     MOV CL,DL
     INC SI
     MOV CH,[SI]
     INC SI             { SI now points at actual shape data }

     MOV DI,SI
     ADD DI,DX

     CMP CL,4           { If less 4 bytes per line on shape }
     JB @SmallShape     { Call the rather sexy small shape handler }

     SUB DI,2
     SHR CL,2           { Otherwise divide width by 2 }



@Outer:
     MOV AX,SI          { This should be faster than a PUSH }
     DB $66; SHL SI,16  { Put SI reload into upper word of ESI }
     MOV SI,AX

     MOV AX,DI
     DB $66; SHL DI,16  { Put DI reload into upper word of EDI }
     MOV DI,AX



@SwapBytes:

     MOV AX,[SI]        { Read bytes from beginning of line }
     XCHG AL,AH         { Swap the two around }
     MOV BX,[DI]        { Read bytes from end of line }
     XCHG BL,BH         { Swap them around }

     MOV [SI],BX
     MOV [DI],AX
     INC SI             { Move to next bytes }
     INC SI
     DEC DI             { Move to previous bytes }
     DEC DI
     DEC CL             { Reduce X counter which is #Words on sprite line }
     JNZ @SwapBytes


{ An easy way of finding out whether a middle byte exists is to check
  if (DI - SI) = 1 as SI & DI are postincremented/decremented during
  word swaps. When the count in CL reaches zero, DI should be less than
  SI. If it is not then a single byte on either side of the middle byte
  remain to be swapped.

}


     CMP DI,SI
     JB @NoMiddleByte
     INC DI
     MOV AL,[SI]
     XCHG AL,[DI]
     MOV [SI],AL

@NoMiddleByte:
     DB $66; SHR SI,16  { Reload SI & DI }
     DB $66; SHR DI,16


     MOV CL,DL
     SHR CL,2           { Divide shape width by 4 again }

     ADD SI,DX
     ADD DI,DX

     DEC CH
     JNZ @Outer
     JMP @ExitProg


{
This part of the program handles really small shapes which are less than
4 pixels wide. I have never used < 4 pixel wide sprites in my software
but I guess some of you might, so....
}


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
End;









{
Mirror shape vertically, so that it looks upside down.

Expects : DataPtr^ points to the shape object to flip.

Returns : Nothing

Corrupts: EAX, BX, CX, DX, SI, DI, Upper word of EBP
}





Procedure YFlipShape(Var DataPtr); Assembler;
Asm
   PUSH DS
   LDS SI,DataPtr

   DB $66; SHL BP,16

   MOV AX,[SI]         { AL = Width of shape, AH = Height }
   INC SI
   INC SI

   XOR DH,DH           { DX = Modulo, to get to next line }
   MOV DL,AL

   MOV CH,AH
   SHR CH,1            { Divide height by 2 }


   DEC AH              { Want to get to start of last line
			 of sprite }

   MUL AH
   ADD AX,SI
   MOV DI,AX           { DI points to start of last sprite
			 line }


@Outer:
   MOV BP,SI           { Make BP point to next line from SI }
   ADD BP,DX
   MOV BX,DI           { Make BX point to previous line from DI }
   SUB BX,DX


   MOV CL,DL           { Check width of shape }
   CMP CL,4
   JB @NoLongsToSwap
   SHR CL,2

@SwapLong:
   DB $66; MOV AX,[SI]         { Swap long words }
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
   MOV AL,[SI]        { Swap remaining bytes }
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
End;











{
De-allocate memory for a shape.

Expects  : DataPtr is a shape pointer.

Returns  : Nothing

Corrupts : The assembler part uses AX,DI and ES. Don't know about
           the Pascal part however. Assume that all registers (
           except of course DS & BP) are corrupted.

Notes    : Isn't FreeMem a pile of shit ?
           Even DOS manages to free mem with you only passing a
	   pointer :)
}

Procedure FreeShape(DataPtr:pointer);
Var ImWidth,
    ImHeight: byte;
Begin
     Asm
     LES DI,DataPtr
     MOV AX,[ES:DI]
     MOV ImWidth,AL
     MOV ImHeight,AH
     End;
     FreeMem(DataPtr,ExtShapeSize(ImWidth,ImHeight));
End;







{
Load in a .IMG file from disk.

WARNING! This is NOT the IMG file type used by some paint packages!
It is a non-standard file (albeit very simple) format that KojakVGA
writes, so trying to load a shape created from a paint package
etc. will not work.


Expects  :  FileName to be a valid MS-DOS path.
            DataPtr to be a valid pointer to where data will be stored.

Returns  :  Exits with error message if specified shape doesn't
            exist on disk or if no memory can be allocated for shape.
            ( I realised no-one uses continuous sprite loading during
            game execution any more :) )

            If shelling the program which loads shapes, an error code
            of <1> shall be returned as the error level.


Corrupts :  Don't know. Let me see: err, AX yup, BX, CX, DX,
            how long have you got to debug the code? ;)

}

Procedure LoadShape(FileName:String; Var DataPtr: Pointer);
Type ShapeHeader = record
     ShapeWidth  : byte;        { Guess who's been converting this to C++
                                  then ? :) }
     ShapeHeight : byte;        { Does it show <g> ? }
     end;



Var F            : File;
    ShapeBuf     : ShapeHeader;
    DestSeg      : word;
    DestOffset   : word;
    ImgSize      : word;


Begin
     Assign(F,FileName);


{ I decided to add validation here :) }

     {$i-}
     Reset(F,1);
     {$i+}

     if IoResult = 0 Then
        Begin
        BlockRead(F,shapebuf,sizeof(shapeheader));


        {
        Calculate number of bytes that need to be reserved for the
        Shape.
        }

        ImgSize:= ExtShapeSize( ShapeBuf.ShapeWidth,
                                ShapeBuf.ShapeHeight);

        If ImgSize < MaxAvail Then
           Begin

           GetMem(DataPtr,ImgSize);
	   GetPtrData(DataPtr,DestSeg,DestOffset);

           Reset(F,1);
           BlockRead(F,Mem[DestSeg:DestOffset], ImgSize);
           Close(F);
           End
        Else
            Begin
            Writeln('Error: Not enough memory to load shape ',FileName,'.');
	    Halt(1);
	    End;
        End
     Else
         Begin
         Writeln('Error: Couldn''t find shape file ',FileName,'.');
         Halt(1);
     End;

End;








{
Write a shape to disk, where you could convert it if you like
to a PCX.

Expects  :  FileName is a standard DOS filename.
	    P is a pointer to where the sprite data exists in memory.

Returns  :  Nothing.

Corrupts :  All 16 bit registers except DS & BP I'd bet.
}



Procedure SaveShape(FileName:string; DataPtr:Pointer);
Var F: File;
    SourceSeg, SourceOffset: word;

Begin
     Assign(F,FileName);
     Rewrite(F,1);
     GetPtrData(DataPtr,SourceSeg,SourceOffset);

     BlockWrite(F, Mem[SourceSeg:SourceOffset],
                   ExtShapeSize(mem[SourceSeg:SourceOffset],
                   mem[SourceSeg:SourceOffset+1]));
     Close(F);
End;












{
====================================================================


PCX LOAD AND SAVE ROUTINES (Smarmy comment removed :) )


--------------------------------------------------------------------
}



{
This will put a mode 13h 256 colour PCX at position X,Y and
show a defined area. Useful for low res multimedia applications. :-)

This PCX loader can handle PCX's of variable dimensions up to
width 320 and height 200 so you could design sprites
with a graphics package and save them as a PCX then grab them
off the screen as Shapes (With my GRABIMG utils preferably)

(Smarmy comment removed - my what a job this is, removing
the smarm ;) - I must have seemed like a real asshole last time
but I was tired and bla bla bla etc. ;) )


Expects: Filename is an MS-DOS filespec relating to the PCX's name.
         ThePalette is a PaletteType record used to hold the PCX's
         palette data.

         X,Y specifies the top left coordinates on screen of where
         the PCX is to be drawn. X should be in the range of 0 to
	 319, Y should be in the range of 0 to 199. The picture
	 will be clipped as necessary.

         WidthToShow can be a number between 1 and 320,
         HeightToShow can be between 1 and 200.


Returns: Your program will halt with an error message if the PCX file
         does not exist, or if the PCX is not of the correct "type".
         (I.E. It's not 256 colour. Note: This proc can load
         PCXs larger than 320 x 200 but it only shows the image
         up to 320 x 200 dimensions)


Corrupts: Err.. ahem. Probably everything.
}




Procedure LocatePCX(filename:string; Var ThePalette: PaletteType;
          x,y,widthtoshow,heighttoshow:word);

var PCXFile: file;

    ReadingFromMem  : Boolean;      { If True it means All/Some PCX
                                      Data is in RAM }
    MemRequired     : longint;      { Size of PCX bitmap data }
    BytesRead       : longint;      { Number of PCX bytes read }
    PCXFileSize     : longint;      { How many bytes PCX uses }
    Count           : integer;      { I is a general counter used to set
                                      the PCX's palette and then count
                                      scan lines }
    RedVal          : byte;         { Used for ColourMap, Palette values }
    GreenVal        : byte;         { which define a colour }
    BlueVal         : byte;

    MemoryAccessVar : pointer;      { Pointer to read bitmap data }
    BufferSeg,                      { Where PCX will be loaded to }
    BufferOffset    : word;

    SrcBmapOffs       : word;         { Screen offset }

    Width,Height,                   { Width is number of horizontal bytes to grab
                                      Height is number of vertical bytes to grab }
    N,Bytes             : word;     { N counts up to Bytes }
    RunLength,c     : byte;         { RunLength is the Run Length Encoding
                                      byte, C is the character read from
                                      PCX data }
    PastHorizontalLimit : boolean;  { Set true this means no more
                                     horizontal pixel writes to do, advance
                                     to next line as soon as poss.}

begin
    assign(PCXFile,FileName);

{$i-}
    reset (PCXFile,1);
{$i+}
    If IOResult = 0 Then
       Begin

       blockread (PCXFile, header, sizeof (header));       { Read in PCX header }

       if (header.manufacturer=10) and (header.version=5) and
          (header.bits_per_pixel=8) and (header.colour_planes=1) then
          begin
               seek (PCXFile, filesize (PCXFile)-769);     { Move to palette data }
	       blockread (PCXFile, c, 1);                  { Read Colourmap type }
               if (c=12) then                              { 12 is correct type }
               begin
                    {
                    Read palette data and write to palette
                    structure.
                    }

                    for Count:=0 to 255 do
                        Begin
                          BlockRead(PCXFile,RedVal,1);
                          BlockRead(PCXFile,GreenVal,1);
                          BlockRead(PCXFile,BlueVal,1);

			  ThePalette.RedLevel[Count]:=RedVal SHR 2;
                          ThePalette.GreenLevel[Count]:=GreenVal SHR 2;
                          ThePalette.BlueLevel[Count]:=BlueVal SHR 2;
                      End;


                  seek (PCXFile, 128);

		  {
		  If entire size of PCX is less than 64K in length then
                  it can be stored in a memory buffer and uncompacted
                  from there. However, if PCX exceeds 64K then it must
                  be split into several chunks. If your machine does
                  not have 64K left for the buffer used (You're in trouble !!)
                  then the system will read the PCX from disk continually,
		  which works OK but is very slow. So there.
                  }

                  MemRequired:=Filesize(PCXFile)-897;
                  PCXFileSize:=MemRequired;
                  BytesRead:=0;

		  If (MemRequired < 65528) And (MaxAvail > MemRequired) Then
                     Begin
                     getmem(MemoryAccessVar,MemRequired);
                     GetPtrData(MemoryAccessVar, BufferSeg, BufferOffset);
                     BlockRead(PCXFile,Mem[BufferSeg:BufferOffset],MemRequired);
		     ReadingFromMem:=True;
                     End
                  Else

		  {
                  If the PCX occupies more than approx. 64K bytes then it
                  is necessary to read the data into memory in 64K chunks
                  which is still considerably faster than the
                  final method (continual reading from disk)
                  }

                      If (MaxAvail > 65527) Then
                         Begin
                         GetMem(MemoryAccessVar,65528);
                         GetPtrData(MemoryAccessVar, BufferSeg, BufferOffset);
                         BlockRead(PCXFile,Mem[BufferSeg:BufferOffset],65528);
                         BytesRead:=65528;
                         MemRequired:=65528;
			 ReadingFromMem:=True;
                         End
                      Else
                          { CLUCK!! Oh well, system is just going to have
                          to read from disk as there is not even 64K
                          memory left. (A very bad situation) }

                          ReadingFromMem:=False;

		  {
                  Find out width & height of PCX.
                  }

                  With Header Do
                  Begin
		       width:=(xmax - xmin)+1;
                       height:=(ymax - ymin)+1;
                       bytes:=bytes_per_line;
                  End;


                  {
		  Adjust width & height of PCX if necessary so that PCX
                  "fits" on screen.

                  }

		  if widthtoshow > width Then
                     widthtoshow:=width;

                  if (widthtoshow + x) > 320 Then
		     widthtoshow:=width-x;

                  if heighttoshow > height Then
                     heighttoshow:=height;

                  if (heighttoshow + y)> 200 Then
                     heighttoshow:=height-y;


                  {
                  Do all scan lines.
                  }

                  for Count:=0 to (heighttoshow-1) do
		  begin
                      n:=0;
                      PastHorizontalLimit:=False;
                      SrcBmapOffs:= CurrentBitmapOffset+((Y+Count)* 320)+X;

                      while (n<bytes) do
                      begin

			   { Display any more pixels width wise from PCX ? }

                           If N >= WidthToShow Then
                              PastHorizontalLimit:=True;

                           If ReadingFromMem Then
                               Begin
			       c:=Mem[BufferSeg:BufferOffset];
                               Inc(BufferOffset);
                               If BufferOffset = 65528 Then
                                  Begin
                                  { End of buffer has been reached, so
                                    it's time to load another part of the
                                    PCX }

                                  If (PCXFileSize - BytesRead)> 65527 Then
                                     Begin
                                     BlockRead(PCXFile,Mem[BufferSeg:0],65528);
                                     Inc(BytesRead,65528);
				     End
                                  Else
                                      { Load last chunk of PCX }

				      Begin
                                      BlockRead(PCXFile,Mem[BufferSeg:0],
                                      (PCXFileSize - BytesRead));
                                      End;

                                  {
                                  Now reset buffer pointer to start
                                  }

                                  BufferOffset:=0;
                                  End;
                               End
                            Else
                                BlockRead(PCXFile,c,1);

{
At this point one element of data has been read, and stored in
variable C. If bits 6 & 7 of C are set then this means to the system
a "run of bytes" has been found. (i.e. a number sequence - for example,
four 1's, twenty 15's, any sequence of identical numbers).

In this case, the 6 least significant bits of C indicate how long the run
of bytes is. For example, if a sequence of five bytes has been found
the run = 5. Of course, using 6 bits limits you to a maximum run length
of 63 bytes but that should be more than enough for most pictures.

Quite a simple method of compaction eh? Definitely the easiest format to
understand!

}

                            if ((c and 192)=192) then
                            begin

                               { Get the 6 least significant bits }
                               RunLength:=c and 63;

                               { get the run byte }

                               If ReadingFromMem Then
                                  Begin
				  c:=Mem[BufferSeg:BufferOffset];
                                  Inc(BufferOffset);

                               { Time to read in more data from disk ? }

                                  If BufferOffset = 65528 Then
                                     Begin
                                     If (PCXFileSize - BytesRead)> 65527 Then
                                        Begin
                                        BlockRead(PCXFile,Mem[BufferSeg:0],65528);
                                        Inc(BytesRead,65528);
                                        End
                                     Else
                                         Begin
                                         BlockRead(PCXFile,Mem[BufferSeg:0],
                                         (PCXFileSize - BytesRead));
                                     End;

				     BufferOffset:=0;
                                     End;
                                  End
                               Else
                                   BlockRead(PCXFile,c,1);

                               {
                               Can't do blit if past the horizontal limit
			       of the window.
			       }

                               If Not PastHorizontalLimit Then
                                  Begin
                                  If n+RunLength > widthtoshow Then
                                     fillchar(Mem[CurrentBitmapSegment:SrcBmapOffs],WidthToShow-n,c)
				  else
                                      fillchar(Mem[CurrentBitmapSegment:SrcBmapOffs],RunLength,c);

                                  inc(SrcBmapOffs,RunLength);
                               End;

                               inc(n,RunLength);
			       end
                            else
                                begin
                                If Not PastHorizontalLimit Then
                                   Begin
				   mem [CurrentBitmapSegment:SrcBmapOffs]:=c;
                                   inc (SrcBmapOffs);
                                End;
                                inc (n);
			    end;

                      end;

                  end;

                  If ReadingFromMem Then
                     freemem(MemoryAccessVar,MemRequired);
               end
          else
              Begin
              DirectVideo:=False;
              Writeln('Error: PCX file ',FileName,
              's ColourMap is not of required type.');
	      Close(PCXFile);
              Halt(1);
              End;
          end
       Else
           Begin
           DirectVideo:=False;
           Writeln('Error: PCX file ',FileName,
	   'unsuitable for loading.');

           Close(PCXFile);
           Halt(1);
       End;

       close (PCXFile);  { Do this anyway ! }

       end
    Else
        Begin
        DirectVideo:=False;
        Writeln('Error: PCX File ',FileName,' not found.');
        Close(PCXFile);
	Halt(1);
        End;

end;













{
What this does is load a PCX at the TOP LEFT of the Current Bitmap,
very quickly. If you need to put the PCX somewhere else use LocatePCX.


Expects:  FileName to be a standard MS-DOS filename, relating to a
	  320 x 200 PCX.
          ThePalette to be of type Palette. This holds the colour
          information of the PCX file you are loading.

          You can then use UsePalette to set the VGA palette so that
          the pic can display properly.

Returns:  Error code 1 back to parent process if PCX failed to load.

Corrupts: Probably everything!! :)
}


Procedure LoadPCX(FileName:string; Var ThePalette: PaletteType);
Begin
     LocatePCX(Filename,ThePalette,0,0,320,200);
End;









{
Save area of Current Bitmap to file. (Smarmy comment removed ;) )

Expects:    FileName is the name of the PCX to save.
            ThePalette is a PaletteType variable, which has been
	    initialised by, for example, the CopyScreenPaletteTo routine.
            X,Y specify the horizontal and vertical positions of where to
            begin grabbing the PCX data from.
            PCXWidth and PCXHeight specify the width & height of the
            window to grab. Easy eh?

            For example, to grab one half of the VGA screen you could use:
            SaveAreaAsPCX('1STHALF.PCX',MyPalette,0,0,160,200);

            And the other half with :

            SaveAreaAsPCX('2NDHALF.PCX',MyPalette,160,0,160,200);

            These files can then be loaded into a paint package such
	    as PC Paintbrush or Neopaint (great program!) and manipulated.

            Use the SAVEPCX routine below to save an entire PCX screen.


Returns:    Program will halt if the PCX is not found.


Notes  :    Smarmy comment removed!!! :)
	    Apologies to all who were offended by my rather rude
            remark in the last KojakVGA.

}


Procedure SaveAreaAsPCX(filename:string;ThePalette: PaletteType;
          x,y, PCXWidth,PCXHeight: word);

Var f: File;                    { File for writing PCX to }
    ColourMapID: byte;           { Always holds 12, for the PCX }
    ColourCount: byte;           { Counts up to number of colours on
                                  screen (255) }
    RedValue: byte;             { Palette Values of a colour }
    GreenValue: byte;
    BlueValue: byte;

    LastOffset: word;           { Used as a latch for SrcBmapOffs }
    SrcBmapOffs: word;          { Offset into Current Bitmap }
    VerticalCount: byte;        { Number of scan lines to use }
    LastByte : byte;            { The last byte read from Current Bitmap }
    NewByte: byte;              { The current byte }
    RunLength : byte;           { Counter for run length compression }
    ByteCount: word;            { Counts up to bytes per scan line (320) }



Begin
     Assign(f,filename);
     Rewrite(f,1);

     With header do
     Begin
          Manufacturer := 10;
          Version := 5;
          Encoding :=0;
	  Bits_per_pixel:=8;    { 8 bits = 256 colours }
          XMin:=0;
          YMin:=0;

          {
          Can't save a PCX more than 320 x 200 in size.
          }

	  if (PCXwidth + x) > 320 Then
	     PCXwidth:=320-x;
          if (PCXheight+ y) > 200 Then
             PCXheight:=200-y;

          XMax:=(PCXWidth-1);
          YMax:=(PCXHeight-1);
	  Hres:=320;                        { Hres/Vres could be used to
                                              determine screen mode -
                                              probably :-( }
          VRes:=200;

          Colour_planes:=1;                 { Mode 13h is not planar }
          Bytes_per_line:=PCXWidth;         { One byte per pixel }
	  Palette_type:=12;                 { Dunno what 12 is for }
     End;

     BlockWrite(F,Header,SizeOf(Header));

     Asm
     MOV AX,X
     MOV BX,Y
     CALL CalculateOffset
     MOV SrcBmapOffs,BX
     End;

     For VerticalCount:=0 to PCXHeight-1 do
     Begin
          LastOffset:=SrcBmapOffs;
          ByteCount:=0;
          LastByte:=0;

          Repeat
                NewByte:=Mem[CurrentBitmapSegment:SrcBmapOffs];

                {
                If the last byte read is equal to the new byte read
		then a run of bytes has been identified and so the
                system needs to count how many identical bytes (up
                to a total of 63) follow. When finished, the
                system writes this count to disk PLUS a value of
                192 (which is the signal to the PCX reader that
                a run of bytes follows) then writes the byte that
                was prevalent in the run.

		For example, say in the data stream there were 10
		values :

                0 1 2 6 9 8 7 7 7 4

                When the system gets to 8 it would then compare
                that number with the next value (7) and see that 8 is
		not equal to 7, then the computer would move to said 7
                (after the 8) and compare it to the next digit, which
                is also a 7.

                As a match has been found, the system counts the
                number of 7s there, which is (all together now !)
                3!! and then adds 192 to the result.. to give 195.

                As stated before, bits 6 + 7 of the byte have
                been set in order to "flag" to the PCX reader that
                a run of bytes have been found.

		The value 195 is written to disk, then value 7 so the
                PCX reader that loads this file knows what value (and
                how many times) to write to the screen during unpacking.

		I hope this has explained one of the PCX mysteries. If
                it hasn't I typed all that for nothing!! :-)
                }

                If NewByte = LastByte Then
                   Begin

                   RunLength:=0;
                   While (NewByte = LastByte) and (RunLength < 63)
                      and (ByteCount <> PCXWidth) do
                      Begin
                      Inc(RunLength);
                      Inc(ByteCount);

		      {
                      Move to next byte on Current Bitmap
                      }

                      Inc(SrcBmapOffs);

                      NewByte:=Mem[CurrentBitmapSegment:SrcBmapOffs];
                   End;

		   { Signal run of bytes }

                   Asm
                   OR Byte Ptr RunLength, 192
                   End;

		   BlockWrite(f,RunLength,1);
                   BlockWrite(f,LastByte,1);

                   LastByte:=NewByte;
                   End
                Else

                { How to deal with colours > 191. }
		    If (NewByte > 191) Then
                       Begin
                       Inc(ByteCount);
                       Inc(SrcBmapOffs);                { Point to next byte on screen }
		       RunLength:=193;
		       BlockWrite(f,RunLength,1);     { Write run length byte of 1  ! }
		       BlockWrite(f,NewByte,1);       { The ONLY way to get round }
		       LastByte:=NewByte;
		       End
		    Else
			Begin
                        Inc(ByteCount);
                        Inc(SrcBmapOffs);
                        BlockWrite(f,NewByte,1);
                        LastByte:=NewByte;
                        End;

          Until ByteCount = PCXWidth;

          SrcBmapOffs:=LastOffset+320;
     End;

     {
     12 is Colourmap ID.
     }

     ColourMapID:=12;
     BlockWrite(f,ColourMapID,1);


     For ColourCount:=0 to 255 do
         Begin

         RedValue:=ThePalette.   RedLevel[ColourCount] SHL 2;
	 GreenValue:=ThePalette. GreenLevel[ColourCount] SHL 2;
         BlueValue:=ThePalette.  BlueLevel[ColourCount] SHL 2;

	 BlockWrite(F,RedValue,1);
         BlockWrite(F,GreenValue,1);
         BlockWrite(F,BlueValue,1);
     End;

     Close(F);
End;






{
Save the entire Current Bitmap to a PCX file.

Expects  :  Filename is the MS-DOS filespec , i.e. "C:\PICS\MYFILE.PCX"
            ThePalette specifies a PaletteType record to save to disk in
            the PCX file.

Returns  :  Nothing

Corrupts :  Don't know !!
}


Procedure SavePCX(filename:string;ThePalette: PaletteType);
Begin
     SaveAreaAsPCX(filename,ThePalette,0,0,320,200);
End;

















{
====================================================================


FONT ROUTINES


--------------------------------------------------------------------
}







{
Select which of the Fonts in ROM you use to write text to the
screen.

Expects : FontNumber can be:

	  0: For CGA Font (Dunno what size it is tho')
	  1: For 8 x 8 Font
	  2: For 8 x 14 Font
	  3: For 8 x 8 Font
	  4: For 8 x 8 Font high 128 characters
	  5: For Rom Alpha Alternate Font
	  6: For 8 x 16 Font
	  7: For Rom Alternate 9 x 16 Font


Returns : If you could use the font, this function returns TRUE.


Corrupts : AX,BX,ES

}


Function UseFont(FontNumber:byte): boolean; Assembler;
Asm
     MOV AX,$1130                      { Get Font address }
     MOV BH,FontNumber
     CMP BH,7                          { Font number > 7 ? }
     JA @NoWriteSize                   { Yes, so it's invalid }

     PUSH BP                           { Mustn't corrupt BP, as Turbo
                                         needs it preserved for local
                                         variable access }
     PUSH BX                           { Nor BH as it's to be used later }
     INT $10                           { Now get Font address }
     MOV CurrentFontSegMent,ES         { ES:BP points to where Font is }
     MOV CurrentFontOffset,BP          { located in ROM }
     POP BX                            { Restore Font number }
     POP BP                            { Restore BP }

     CMP BH,Int1fFont                  { User Font in memory ? }
     JZ @NoWriteSize                   { Don't set size, could be more than
                                         8 x 8. User will have to set himself.
                                         Please correct me if I am wrong }
     CMP BH,StandardVGAFont
     JZ @Set8x8
     CMP BH,Font8x8dd
     JZ @Set8x8
     CMP BH,Font8x8ddHigh
     JZ @Set8x8
     CMP BH,AlphaAlternateFont
     JNZ @Check8x14Font

@Set8x8:
     MOV AL,8                          { Width of 8 }
     MOV AH,8                          { Height of 8 }
     JMP @DoWrite


@Check8x14Font:
     CMP BH,Font8x14
     JNZ @Check8x16Font
     MOV AL,8                          { Width 8, Height 14, ByteWidth 1 }
     MOV AH,14
     JMP @DoWrite

@Check8x16Font:
     CMP BH,Font8x16
     JNZ @UseRomAlternateFont
     MOV AL,8                          { Oh C'mon do I have to document }
     MOV AH,16                         { this ? }
     JMP @DoWrite

@UseRomAlternateFont:
     MOV AL,9
     MOV AH,16


@DoWrite:
     MOV CurrentFontWidth,AL           { Write Font details so that }
     MOV CurrentFontHeight,AH          { this Font }
     SHR AL,3
     MOV CurrentFontByteWidth,AL

     MUL AH
     MOV CurrentFontBytesPerChar,AL
     MOV AL,True
     JMP @NowExit

@NoWriteSize:
     MOV AL,False

@NowExit:
End;






{
If you wish to do your own text routines, then this returns the
address of the current font.

Expects  : Nothing

Returns  : A pointer to where the current font is stored.

Corrupts : AX,DX.
}

Function GetCurrentFontAddress: pointer; Assembler;
Asm
   MOV DX,CurrentFontSegment
   MOV AX,CurrentFontOffset
End;






{
If you want to use a Font loaded in from disk use SetNewFontAddress to
specify where the new Font resides in memory.

Expects  : NewFontPtr is the address of the font to use.

Returns  : Nothing

Corrupts : AX
}

Procedure SetNewFontAddress(NewFontPtr: pointer); Assembler;
Asm
   MOV AX,WORD PTR NewFontPtr[2]
   MOV CurrentFontSegment,AX
   MOV AX,WORD PTR NewFontPtr
   MOV CurrentFontOffset,AX
End;







{
Find out what width and height the current Font is.

Expects: CurrFontWidth and CurrFontHeight are two uninitialised
         variables.

Returns: CurrFontWidth and CurrFontHeight on exit hold the width
         and height of the current Font. (Bet you never guessed that, huh)

Corrupts : AX,DI,ES
}


Procedure GetCurrentFontSize(Var CurrFontWidth, CurrFontHeight:byte); Assembler;
Asm
   MOV AL,CurrentFontWidth
   MOV AH,CurrentFontHeight

   LES DI,CurrFontWidth         { ES: DI points to variable now }
   MOV [ES:DI],AL
   LES DI,CurrFontHeight
   MOV [ES:DI],AH
End;







{
Specify width and height of a user created Font.

Expects  : NewFontWidth must be above 7
           NewFontHeight can be any non-zero number.

Returns  : Nothing

Corrupts : AX

}

Procedure SetFontSize(NewFontWidth, NewFontHeight:byte); Assembler;
Asm
     MOV AL,NewFontWidth
     MOV AH,NewFontHeight

     CMP AL,8                   { Width >= 8 ? }
     JB @IllegalSize
     OR AH,AH                   { Is Height 0 ? }
     JZ @IllegalSize

     MOV CurrentFontWidth,AL
     MOV CurrentFontHeight,AH
     SHR AL,3                   { Calculate byte width of characters
                                  i.e. divide width in pixels by 8 }
     MOV CurrentFontByteWidth,AL
     MUL AH
     MOV CurrentFontBytesPerChar,AL
     JMP @ExitNow

@IllegalSize:
     XOR AL,AL
     MOV BYTE PTR CurrentFontWidth,0
     MOV BYTE PTR CurrentFontHeight,0

@ExitNow:
End;







{
For those of you who want to do your own text routines, this
Procedure may lighten your workload a bit.

Expects : Characternumber to be (obviously) the number of the
          character.

Returns : This Function returns the offset address of character.

Corrupts : AX,BX,DX
}

Function GetFontCharOffset(CharNum:byte): word; assembler;
Asm
   MOV AL,CharNum                  { Get number of character into AL }
   MOV BH,CurrentFontByteWidth
   MOV BL,CurrentFontHeight
   MUL BL                          { Multiply character num by FontHeight }
   MOV BL,BH
   XOR BH,BH
   MUL BX                          { And FontWidth }
   ADD AX,CurrentFontOffset        { Now add in the font offset }
End;







(*
I've examined Compugraphic fonts and come to a standstill. So I reckoned
I'd update my GRABIMG utility so I could nick fonts from a PCX!

Watch this space!


This command will load a font into memory and put the information
about the font's size, mem usage etc into the FontRec record.

Expects: FontFileName is the MS-DOS name of the font to load.
         FontRec is the record used to hold the fonts details.

Returns: FontRec will be filled with data if font loaded OK.
         If Not, then your program halts and returns an error level
         of 1 to the parent process.


*)


Procedure LoadFont(FontFileName:String; Var FontRec: FontType);
Var FontFile : File;
    BytesToReserve : word;
    FontPtr : Pointer;

Begin
     Assign(FontFile,FontFileName);

     {$i-}
     Reset(FontFile,1);
     {$i+}
     If IoResult = 0  Then
        Begin
        BlockRead(FontFile,FontRec,SizeOf(FontRec));
        With FontRec Do
             Begin
             BytesToReserve:=FontChars * (FontByteWidth * FontHeight);
             GetMem(FontPtr,BytesToReserve);
             GetPtrData(FontPtr,FontSeg,FontOfs);
             BlockRead(FontFile,Mem[FontSeg:FontOfs],BytesToReserve);
        End;
	Close(FontFile);
        End
     Else
         Begin
         Writeln('Error: Couldn''t load font file ',FontFileName,'.');
         Halt(1);
     End;
End;







{
This routine will save a portion (or all) of the current Font to disk.

Expects : FontFileName to be an MS-DOS filename to hold the char data.
          FirstChar to be the number of the first character to save
          (0-255);
          NumChars to be the number of characters to save (You may
          only want to save part of a Font).

Returns  : Nothing

Corrupts : Don't know.
}


Procedure SaveFont(FontFileName:String; FirstChar, Numchars:byte);
Var TempFontRec     : FontType;
    FontFile        : File;
    BytesPerChar    : word;
    FirstCharOffset : word;

Begin
     With TempFontRec do
          Begin
          FontSeg:=0;               { 0 Meaning uninitialised }
          FontOfs:=0;
          FontByteWidth:=CurrentFontByteWidth;
          FontWidth:=CurrentFontWidth;
          FontHeight:=CurrentFontHeight;
          FontChars:=NumChars;
     End;

     Assign(FontFile,FontFileName);
     Rewrite(FontFile,1);
     BlockWrite(FontFile,TempFontRec,SizeOf(TempFontRec));

     BytesPerChar:=CurrentFontByteWidth * CurrentFontHeight;
     FirstCharOffset:=CurrentFontOffset+(FirstChar * BytesPerChar);

     BlockWrite(FontFile, Mem[CurrentFontSegment:FirstCharOffset],
     NumChars * BytesPerChar);

     Close(FontFile);


End;






{
Use a Font loaded in from disk. Yes, I know there are many Font load
routines in the SWAG and most (if not ALL) use interrupt 10h to do
the business. But my routine doesn't because quite frankly using the
BIOS is slow, cack, and is far too limiting.

This routine allows characters of ANY size.

Expects : Variable FontRec to have been initialised (usually by LoadFont).
	  You could initialise FontRec yourself if you liked and
	  that would be faster than using SetNewFontAddress, SetFontSize etc.

Returns : Nothing

Corrupts : Don't know. That's the thing about Pascal!
}


Procedure UseLoadedFont(FontRec : FontType);
Begin
     With FontRec Do
	  Begin
	  CurrentFontSegment:=FontSeg;
	  CurrentFontOffset:=FontOfs;
	  SetFontSize(FontWidth,FontHeight);
     End;
End;






{
DAMN! The last text print routine (called OutTextXY) had a bug
which was a right rotten beggar. It's been sorted here tho' -
I did tell you I didn't have much time to test all my
work did I? (And no chars > 8 pixels to grab? :) )


Expects  : x,y specify the horizontal, vertical position of text <txt>
           to print.

Returns  : Nothing

Corrupts : AX, BX, CX, DX, SI, DI, ES.

Notes    : Changed PrintXY to PrintAt as it's now a whole new beast
           from OutTextXY.
}




Procedure PrintAt(x,y: integer; txt:string); Assembler;
Var Chars   : byte;
    TextSeg : word;
    Currx   : word;

Asm
   les si,txt
   mov textseg,es
   mov al,[es:si]
   mov chars,al
   inc si




{ Calculate font ofs }

@GetNextChar:
   mov es,textseg
   mov al, [es:si]
   inc si
   mul byte ptr currentfontbytesperchar

   mov di, currentfontoffset
   add di,ax


   mov es,currentfontsegment    { The following 4 regs only get re-loaded }
   mov dl,currentcolour         { after moving to the next character }
   mov bx,y
   mov ch,currentfontheight

@downloop:
   mov cl,currentfontbytewidth  { Used to count across }
   mov ax,x

@acrossloop:
   mov dh,8                     { 8 bits in a byte, remember :) }

   push cx
   mov cl,[es:di]               { Read byte from charmap }

@bitsloop:
   test cl,$80                  { Bit 7 set ? }
   jz @noplot                   { Nope, so don't put a pixel }

   push bx                      { need to preserve BX as it's the Y coord }
   call FPutPixel               { Draw a dot }
   pop bx

@noplot:
   shl cl,1                     { Shift bit from character map }
   inc ax                       { Update X coord }
   dec dh                       { Reduce bit count }
   jnz @bitsloop

   inc di
   pop cx
   dec cl
   jnz @acrossloop

   inc bx                       { Do next row }
   dec ch

   jnz @downloop

{ Now update the temporary graphics cursor }

   clc
   mov ax,x
   add al,currentfontwidth
   adc ah,0
   mov x,ax

{ Reduce character count }

   dec byte ptr chars
   jnz @getnextchar
End;












{
Display a string of text at the current cursor position, using
the current Font.

Expects : Txt is the text to write at the current cursor position.

Returns : Graphics cursor has moved.

Corrupts : See PrintAt.
}

Procedure Print(txt:string);
Begin
     PrintAt(CursorX,CursorY,txt);
End;












{
====================================================================


PALETTE ROUTINES


--------------------------------------------------------------------

}




{
Get the red, green and blue components of a colour.

Expects  :  ColourNumber is the number of the colour of which you
	    want to read the Palette values (0-255).
            RedValue, GreenValue, BlueValue need not be initialised.

Returns  :  The Red, Green, Blue Values of the colour specified
            by ColourNumber.

Corrupts :  AL, DX, DI, ES

}

Procedure GetRGB(ColourNumber : Byte;
          VAR RedValue, GreenValue, BlueValue : Byte); Assembler;
Asm
   MOV DX,$3C7          { $3C7 is colour ** READ ** select port. }
   MOV AL,ColourNumber   { Select colour to read }
   OUT DX,AL
   ADD DL,2             { DX now = $3C9, which must be read 3 times
                          in order to obtain the Red, Green and
                          Blue values of a colour }

   IN AL,DX             { Read red amount. Don't use IN AX,DX as
                          for some strange reason it doesn't work ! }
   LES DI,RedValue
   MOV [ES:DI],AL       { (Smarmy comment removed :) ) }


   IN AL,DX             { IN AX,DX doesn't seem to work on my card }
   LES DI,GreenValue
   MOV [ES:DI],AL

   IN AL,DX             { Read blue }
   LES DI,BlueValue
   MOV [ES:DI],AL
End;









{
This will change the red green and blue components of a colour,
thereby affecting it's shade. How's that for picturesque speech ?

Note : You don't need a PaletteType record to use this command,
it affects the screen directly.

Expects  : ColourNumber is the number of the colour from 0 to 255.
           RedValue is the red component of the colour (0-63).
           GreenValue is the green component of the colour (0-63).
	   BlueValue is the blue component of the colour (0-63).

Returns  : Nothing

Corrupts : AL,DX
}


Procedure SetRGB(ColourNumber, RedValue, GreenValue, BlueValue : Byte); Assembler;
Asm
   MOV AL,ColourNumber
   MOV DX,$3c8          { Write to Port $3C8 with number of Colour to alter }
   OUT DX,AL
   INC DL               { $3C9 again ! }
   MOV AL,RedValue      { Store Red }
   OUT DX,AL
   MOV AL,GreenValue    { Store Green }
   OUT DX,AL
   MOV AL,BlueValue     { Store Blue }
   OUT DX,AL
End;







(*
This Procedure takes a snapshot of all of the colours on screen.

Expects : Palette is a variable of type PaletteType which will
          hold the 256 colour palette.

Returns : Nothing

Notes   : Use this command just before a mode change so that
	  you can restore the palette to it's original state
          (via UsePalette) at the end of the program.

          (Smarmy comment removed :) )

*)


Procedure CopyScreenPaletteTo(Var Palette : PaletteType);
Var ColourCount:byte;
Begin
     For ColourCount:=0 to (MaxColours - 1) do
     GetRGB(ColourCount,Palette.RedLevel[ColourCount],
     Palette.GreenLevel[ColourCount],Palette.BlueLevel[ColourCount]);
End;







{
Do I need to explain what this does? It loads in a Palette
from file FileName and stores it in the variable Palette.
Easy enough to use.

Expects : FileName is standard MS-DOS filename which refers to the
          palette file.
          Palette is variable of type PaletteType used to hold
          the palette data.

Returns : Palette should contain the data read from palette file.

Corrupts : Don't know.
}

Procedure LoadPalette(FileName: String; Var Palette : PaletteType);
Var PaletteFile: File;
Begin
     Assign(PaletteFile,FileName);
     {$i-}
     Reset(PaletteFile,1);
     {$i+}
     If IoResult = 0 Then
	Begin
        BlockRead(PaletteFile,Palette,SizeOf(Palette));
        Close(PaletteFile);
        End
     Else
         Begin
         Writeln('Error: Couldn''t load palette file ',FileName,'.');
         Halt(1);
     End;
End;





{
Guess what this does then !.

Expects  : FileName is the MS-DOS file spec of the palette to be saved.
           Palette is the palette to be saved.

Returns  : Nothing

Corrupts : The whole damn shebang! Except DS & BP.
}


Procedure SavePalette(FileName: String; Palette : PaletteType);
Var PaletteFile: File;
Begin
     Assign(PaletteFile,FileName);
     Rewrite(PaletteFile,1);
     BlockWrite(PaletteFile,Palette,SizeOf(Palette));
     Close(PaletteFile);
End;







{
This sets the DACs to the Colours specified in your
Palette array. Do NOT alter the Palette data structure
or else this won't work.

Expects : Palette is an initialised palette of PaletteType.

Returns : Nothing

Corrupts : AL, BX, CX (It was CL before), DX, SI, DI, ES

Notes    : Slightly optimised for all you Diamond Stealth owners
           out there ;)
}


Procedure UsePalette(Palette : PaletteType); Assembler;
Asm
   PUSH DS
   LDS BX, Palette      { DS:BX points to Palette record }
   XOR AL,AL
   MOV DX,$3c8          { $3c8 selects the first colour to alter.
                          After 3 writes to $3c9, the VGA automatically
                          moves to the next Colour so there is no
                          need to write to $3c8 again. }
   OUT DX,AL
   INC DL                { Make DX = $3c9, which is used to set the
                           Red / Green and Blue values of a Colour }

   MOV CX,MaxColours     { 256 colours }

   MOV SI,BX
   ADD SI,MaxColours     { Make SI point to green levels }
   MOV DI,SI
   ADD DI,MaxColours     { Make DI point to blue levels }


@WritePaletteInfo:
   MOV AL, [BX]         { Read red level from Palette struct }
   OUT DX,AL            { Write to port $3c9 }
   MOV AL, [SI]         { Read green level from Palette struct }
   OUT DX,AL            { Write to port $3c9 }
   MOV AL, [DI]         { Read blue level from Palette struct }
   OUT DX,AL            { Write to port $3c9 }

   INC DI               { Next Red part of record }
   INC BX               { Next Green }
   INC SI               { Next Blue }

   DEC CX
   JNZ @WritePaletteInfo
   POP DS
End;






{
Set the new graphics colour. Also affects text routines as well.

Expects : NewColour is the new graphics Colour.

Returns : Nothing.

Corrupts : AL.
}


Procedure UseColour(NewColour:byte); Assembler;
Asm
    MOV AL,NewColour
    MOV CurrentColour,AL
End;






{
Get the current graphics colour.

Expects  : Nothing

Returns  : GetColour = Current graphics colour

Corrupts : My mind when I document one liner pieces of crap (code)
           like this :)
}

Function GetColour: byte; Assembler;
Asm
     MOV AL, CurrentColour;
End;
















{
====================================================================


MISCELLANEOUS ROUTINES


--------------------------------------------------------------------
}







{
Wait for a certain number of vertical retraces, specified by
the number in TimeOut.

Expects : TimeOut is the number of vertical retraces you want to wait
          for.

Returns : Nothing.


Corrupts: AL,CX,DX

}


Procedure Vwait(TimeOut:word); Assembler;
Asm
   MOV CX,TimeOut         { CX = Number of times to wait }
   MOV DX,$03DA

@WaitRetraceEnd:

   IN  AL,DX              { Wait until the current retrace
                            has finished (if one is in progress) }
   TEST AL,$08
   JZ @WaitRetraceEnd

@WaitRetraceStart:        { Then wait until a retrace starts }
   IN  AL,DX
   TEST AL,$08
   JNZ @WaitRetraceStart

   DEC CX
   JNZ @WaitRetraceEnd

End;







(*
Return the version number of the current KojakVGA unit.
This function is NOT present in the NEWGRAPH unit.

Expects:  Nothing

Returns:  GetVersion = Current Version of KojakVGA.
          AH = Major version
          AL = Minor version

	  KOJAKVGA 3.01 returns AH = 3. AL = 1

Corrupts: AX
*)


Function GetVersion: word; Assembler;
Asm
   MOV AX,KojakVGAVersion
End;










{
====================================================================


INITIALISATION SECTION


--------------------------------------------------------------------

}




Begin
     InitOffsets;
     UseBitmap(ptr($a000,0));

     Cls;                            { Flush video mem }
     MoveTo(0,0);                    { Graphics Cursor to top left }
     UseColour(1);                   { Use Colour 1 }
     UseFont(StandardVGAFont);       { standard 8 x 8 }

     Write('KOJAKVGA (486 enhanced) version ');
     Write(GetVersion DIV 256,'.',GetVersion AND $FF);
     Writeln(' (C) 1996 Scott Tunstall.');
     Writeln('This unit is FREEWARE. Please distribute source/compiled code');
     Writeln('freely in it''s original, unaltered state.');
     Writeln;
End.
