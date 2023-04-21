{SWAG=GRAPHICS.SWG,Menno Victor van der star,Graphics Library (BP7)}
Unit Graphics;
{----------------------------------------------------------------------------}
{  Graphics : An implementation of a graphics library. All standard VGA and  }
{             VESA modes are supported. A Tseng Labs ET4000 specific         }
{             implementation is also included.                               }
{****************************************************************************}
{  Author            : Menno Victor van der star                             }
{  E-Mail            : s795238@dutiwy.twi.tudelft.nl                         }
{  Developed on      : 08-06-'95                                             }
{  Last update on    : 07-09-'95                                             }
{  Status            : All modes are operational but some of the less        }
{                      frequently used ones are extremely slow because they  }
{                      use BIOS calls instead of mode-specific code.         }
{                      The NOT, AND, OR and XOR modes are not yet supported. }
{                      Due to GPF-faults, Vesa is defined for, and can       }
{                      subsequently only be used in Real mode.               }
{  Future extensions : - X-MODE specific implementation                      }
{                      - Support for fillpattern in BoundaryFill/FloodFill   }
{                      - Support for linestyles                              }
{                      - Support for write-modes other than NORMAL           }
{                      - More graphic functions like :                       }
{                         * Convex Hull                                      }
{                         * Etcetera...                                      }
{                      - Implementations for other chip-sets                  }
{----------------------------------------------------------------------------}
{$N+,E+,R-}
Interface

Uses Dos;

Type
  GraphicsMode = Record
                Mode, { Number to pass to BIOS to initialize video mode, if necessary }
                Width, Height : Word;  { Width and Height of video mode }
                ColorDepth : Byte;     { Colordepth in bits per pixel   }
              End;
  RGB = Record r, g, b : Byte; End;
  Point = Record x, y : Integer; End;
  Triangle = Array [1..3] Of Point;
  ByteArray = Array [0..0] Of Byte;
  PByteArray = ^ByteArray;

Const
  { Standard VGA modes }
  VGA320x200x4   : GraphicsMode = (Mode : $04; Width : 320; Height : 200; ColorDepth : 2);
  VGA640x200x2   : GraphicsMode = (Mode : $06; Width : 640; Height : 200; ColorDepth : 1);
  VGA320x200x16  : GraphicsMode = (Mode : $0D; Width : 320; Height : 200; ColorDepth : 4);
  VGA640x200x16  : GraphicsMode = (Mode : $0E; Width : 640; Height : 200; ColorDepth : 4);
  VGA640x350x4   : GraphicsMode = (Mode : $0F; Width : 640; Height : 350; ColorDepth : 2);
  VGA640x350x16  : GraphicsMode = (Mode : $10; Width : 640; Height : 350; ColorDepth : 4);
  VGA640x480x2   : GraphicsMode = (Mode : $11; Width : 640; Height : 480; ColorDepth : 1);
  VGA640x480x16  : GraphicsMode = (Mode : $12; Width : 640; Height : 480; ColorDepth : 4);
  VGA320x200x256 : GraphicsMode = (Mode : $13; Width : 320; Height : 200; ColorDepth : 8);

  {$IFNDEF DPMI}
  { Standard VESA modes, Vesa calls currently only possible in real mode :( }
  Vesa640x400x256   : GraphicsMode = (Mode : $100; Width : 640; Height : 400; ColorDepth : 8);
  Vesa640x480x256   : GraphicsMode = (Mode : $101; Width : 640; Height : 480; ColorDepth : 8);
  Vesa800x600x16    : GraphicsMode = (Mode : $102; Width : 800; Height : 600; ColorDepth : 4);
  Vesa800x600x256   : GraphicsMode = (Mode : $103; Width : 800; Height : 600; ColorDepth : 8);
  Vesa1024x768x16   : GraphicsMode = (Mode : $104; Width : 1024; Height : 768; ColorDepth : 4);
  Vesa1024x768x256  : GraphicsMode = (Mode : $105; Width : 1024; Height : 768; ColorDepth : 8);
  Vesa1280x1024x16  : GraphicsMode = (Mode : $106; Width : 1280; Height : 1024; ColorDepth : 4);
  Vesa1280x1024x256 : GraphicsMode = (Mode : $107; Width : 1280; Height : 1024; ColorDepth : 8);
  {$ENDIF}

  { Card-specific video modes for Tseng Labs ET4000 chipset }
  Tseng640x480x256  : GraphicsMode = (Mode : $2E; Width : 640; Height : 480; ColorDepth : 8);
  Tseng800x600x16   : GraphicsMode = (Mode : $29; Width : 800; Height : 600; ColorDepth : 4);
  Tseng800x600x256  : GraphicsMode = (Mode : $30; Width : 800; Height : 600; ColorDepth : 8);
  Tseng1024x768x16  : GraphicsMode = (Mode : $37; Width : 1024; Height : 768; ColorDepth : 4);
  Tseng1024x768x256 : GraphicsMode = (Mode : $38; Width : 1024; Height : 768; ColorDepth : 8);
  Tseng1280x1024x16 : GraphicsMode = (Mode : $3D; Width : 1280; Height : 1024; ColorDepth : 4);

  { Default rom font }
  DefaultFont : Array [0..2047] Of Byte =
  (  0,  0,  0,  0,  0,  0,  0,  0,126,129,165,129,189,153,129,126,
   126,255,219,255,195,231,255,126,108,254,254,254,124, 56, 16,  0,
    16, 56,124,254,124, 56, 16,  0, 56,124, 56,254,254,124, 56,124,
    16, 16, 56,124,254,124, 56,124,  0,  0, 24, 60, 60, 24,  0,  0,
   255,255,231,195,195,231,255,255,  0, 60,102, 66, 66,102, 60,  0,
   255,195,153,189,189,153,195,255, 15,  7, 15,125,204,204,204,120,
    60,102,102,102, 60, 24,126, 24, 63, 51, 63, 48, 48,112,240,224,
   127, 99,127, 99, 99,103,230,192,153, 90, 60,231,231, 60, 90,153,
   128,224,248,254,248,224,128,  0,  2, 14, 62,254, 62, 14,  2,  0,
    24, 60,126, 24, 24,126, 60, 24,102,102,102,102,102,  0,102,  0,
   127,219,219,123, 27, 27, 27,  0, 62, 99, 56,108,108, 56,204,120,
     0,  0,  0,  0,126,126,126,  0, 24, 60,126, 24,126, 60, 24,255,
    24, 60,126, 24, 24, 24, 24,  0, 24, 24, 24, 24,126, 60, 24,  0,
     0, 24, 12,254, 12, 24,  0,  0,  0, 48, 96,254, 96, 48,  0,  0,
     0,  0,192,192,192,254,  0,  0,  0, 36,102,255,102, 36,  0,  0,
     0, 24, 60,126,255,255,  0,  0,  0,255,255,126, 60, 24,  0,  0,
     0,  0,  0,  0,  0,  0,  0,  0, 48,120,120, 48, 48,  0, 48,  0,
   108,108,108,  0,  0,  0,  0,  0,108,108,254,108,254,108,108,  0,
    48,124,192,120, 12,248, 48,  0,  0,198,204, 24, 48,102,198,  0,
    56,108, 56,118,220,204,118,  0, 96, 96,192,  0,  0,  0,  0,  0,
    24, 48, 96, 96, 96, 48, 24,  0, 96, 48, 24, 24, 24, 48, 96,  0,
     0,102, 60,255, 60,102,  0,  0,  0, 48, 48,252, 48, 48,  0,  0,
     0,  0,  0,  0,  0, 48, 48, 96,  0,  0,  0,252,  0,  0,  0,  0,
     0,  0,  0,  0,  0, 48, 48,  0,  6, 12, 24, 48, 96,192,128,  0,
   124,198,206,222,246,230,124,  0, 48,112, 48, 48, 48, 48,252,  0,
   120,204, 12, 56, 96,204,252,  0,120,204, 12, 56, 12,204,120,  0,
    28, 60,108,204,254, 12, 30,  0,252,192,248, 12, 12,204,120,  0,
    56, 96,192,248,204,204,120,  0,252,204, 12, 24, 48, 48, 48,  0,
   120,204,204,120,204,204,120,  0,120,204,204,124, 12, 24,112,  0,
     0, 48, 48,  0,  0, 48, 48,  0,  0, 48, 48,  0,  0, 48, 48, 96,
    24, 48, 96,192, 96, 48, 24,  0,  0,  0,252,  0,  0,252,  0,  0,
    96, 48, 24, 12, 24, 48, 96,  0,120,204, 12, 24, 48,  0, 48,  0,
   124,198,222,222,222,192,120,  0, 48,120,204,204,252,204,204,  0,
   252,102,102,124,102,102,252,  0, 60,102,192,192,192,102, 60,  0,
   248,108,102,102,102,108,248,  0,254, 98,104,120,104, 98,254,  0,
   254, 98,104,120,104, 96,240,  0, 60,102,192,192,206,102, 62,  0,
   204,204,204,252,204,204,204,  0,120, 48, 48, 48, 48, 48,120,  0,
    30, 12, 12, 12,204,204,120,  0,230,102,108,120,108,102,230,  0,
   240, 96, 96, 96, 98,102,254,  0,198,238,254,254,214,198,198,  0,
   198,230,246,222,206,198,198,  0, 56,108,198,198,198,108, 56,  0,
   252,102,102,124, 96, 96,240,  0,120,204,204,204,220,120, 28,  0,
   252,102,102,124,108,102,230,  0,120,204,224,112, 28,204,120,  0,
   252,180, 48, 48, 48, 48,120,  0,204,204,204,204,204,204,252,  0,
   204,204,204,204,204,120, 48,  0,198,198,198,214,254,238,198,  0,
   198,198,108, 56, 56,108,198,  0,204,204,204,120, 48, 48,120,  0,
   254,198,140, 24, 50,102,254,  0,120, 96, 96, 96, 96, 96,120,  0,
   192, 96, 48, 24, 12,  6,  2,  0,120, 24, 24, 24, 24, 24,120,  0,
    16, 56,108,198,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,255,
    48, 48, 24,  0,  0,  0,  0,  0,  0,  0,120, 12,124,204,118,  0,
   224, 96, 96,124,102,102,220,  0,  0,  0,120,204,192,204,120,  0,
    28, 12, 12,124,204,204,118,  0,  0,  0,120,204,252,192,120,  0,
    56,108, 96,240, 96, 96,240,  0,  0,  0,118,204,204,124, 12,248,
   224, 96,108,118,102,102,230,  0, 48,  0,112, 48, 48, 48,120,  0,
    12,  0, 12, 12, 12,204,204,120,224, 96,102,108,120,108,230,  0,
   112, 48, 48, 48, 48, 48,120,  0,  0,  0,204,254,254,214,198,  0,
     0,  0,248,204,204,204,204,  0,  0,  0,120,204,204,204,120,  0,
     0,  0,220,102,102,124, 96,240,  0,  0,118,204,204,124, 12, 30,
     0,  0,220,118,102, 96,240,  0,  0,  0,124,192,120, 12,248,  0,
    16, 48,124, 48, 48, 52, 24,  0,  0,  0,204,204,204,204,118,  0,
     0,  0,204,204,204,120, 48,  0,  0,  0,198,214,254,254,108,  0,
     0,  0,198,108, 56,108,198,  0,  0,  0,204,204,204,124, 12,248,
     0,  0,252,152, 48,100,252,  0, 28, 48, 48,224, 48, 48, 28,  0,
    24, 24, 24,  0, 24, 24, 24,  0,224, 48, 48, 28, 48, 48,224,  0,
   118,220,  0,  0,  0,  0,  0,  0,  0, 16, 56,108,198,198,254,  0,
   120,204,192,204,120, 24, 12,120,  0,204,  0,204,204,204,126,  0,
    28,  0,120,204,252,192,120,  0,126,195, 60,  6, 62,102, 63,  0,
   204,  0,120, 12,124,204,126,  0,224,  0,120, 12,124,204,126,  0,
    48, 48,120, 12,124,204,126,  0,  0,  0,120,192,192,120, 12, 56,
   126,195, 60,102,126, 96, 60,  0,204,  0,120,204,252,192,120,  0,
   224,  0,120,204,252,192,120,  0,204,  0,112, 48, 48, 48,120,  0,
   124,198, 56, 24, 24, 24, 60,  0,224,  0,112, 48, 48, 48,120,  0,
   198, 56,108,198,254,198,198,  0, 48, 48,  0,120,204,252,204,  0,
    28,  0,252, 96,120, 96,252,  0,  0,  0,127, 12,127,204,127,  0,
    62,108,204,254,204,204,206,  0,120,204,  0,120,204,204,120,  0,
     0,204,  0,120,204,204,120,  0,  0,224,  0,120,204,204,120,  0,
   120,204,  0,204,204,204,126,  0,  0,224,  0,204,204,204,126,  0,
     0,204,  0,204,204,124, 12,248,195, 24, 60,102,102, 60, 24,  0,
   204,  0,204,204,204,204,120,  0, 24, 24,126,192,192,126, 24, 24,
    56,108,100,240, 96,230,252,  0,204,204,120,252, 48,252, 48, 48,
   248,204,204,250,198,207,198,199, 14, 27, 24, 60, 24, 24,216,112,
    28,  0,120, 12,124,204,126,  0, 56,  0,112, 48, 48, 48,120,  0,
     0, 28,  0,120,204,204,120,  0,  0, 28,  0,204,204,204,126,  0,
     0,248,  0,248,204,204,204,  0,252,  0,204,236,252,220,204,  0,
    60,108,108, 62,  0,126,  0,  0, 56,108,108, 56,  0,124,  0,  0,
    48,  0, 48, 96,192,204,120,  0,  0,  0,  0,252,192,192,  0,  0,
     0,  0,  0,252, 12, 12,  0,  0,195,198,204,222, 51,102,204, 15,
   195,198,204,219, 55,111,207,  3, 24, 24,  0, 24, 24, 24, 24,  0,
     0, 51,102,204,102, 51,  0,  0,  0,204,102, 51,102,204,  0,  0,
    34,136, 34,136, 34,136, 34,136, 85,170, 85,170, 85,170, 85,170,
   219,119,219,238,219,119,219,238, 24, 24, 24, 24, 24, 24, 24, 24,
    24, 24, 24, 24,248, 24, 24, 24, 24, 24,248, 24,248, 24, 24, 24,
    54, 54, 54, 54,246, 54, 54, 54,  0,  0,  0,  0,254, 54, 54, 54,
     0,  0,248, 24,248, 24, 24, 24, 54, 54,246,  6,246, 54, 54, 54,
    54, 54, 54, 54, 54, 54, 54, 54,  0,  0,254,  6,246, 54, 54, 54,
    54, 54,246,  6,254,  0,  0,  0, 54, 54, 54, 54,254,  0,  0,  0,
    24, 24,248, 24,248,  0,  0,  0,  0,  0,  0,  0,248, 24, 24, 24,
    24, 24, 24, 24, 31,  0,  0,  0, 24, 24, 24, 24,255,  0,  0,  0,
     0,  0,  0,  0,255, 24, 24, 24, 24, 24, 24, 24, 31, 24, 24, 24,
     0,  0,  0,  0,255,  0,  0,  0, 24, 24, 24, 24,255, 24, 24, 24,
    24, 24, 31, 24, 31, 24, 24, 24, 54, 54, 54, 54, 55, 54, 54, 54,
    54, 54, 55, 48, 63,  0,  0,  0,  0,  0, 63, 48, 55, 54, 54, 54,
    54, 54,247,  0,255,  0,  0,  0,  0,  0,255,  0,247, 54, 54, 54,
    54, 54, 55, 48, 55, 54, 54, 54,  0,  0,255,  0,255,  0,  0,  0,
    54, 54,247,  0,247, 54, 54, 54, 24, 24,255,  0,255,  0,  0,  0,
    54, 54, 54, 54,255,  0,  0,  0,  0,  0,255,  0,255, 24, 24, 24,
     0,  0,  0,  0,255, 54, 54, 54, 54, 54, 54, 54, 63,  0,  0,  0,
    24, 24, 31, 24, 31,  0,  0,  0,  0,  0, 31, 24, 31, 24, 24, 24,
     0,  0,  0,  0, 63, 54, 54, 54, 54, 54, 54, 54,255, 54, 54, 54,
    24, 24,255, 24,255, 24, 24, 24, 24, 24, 24, 24,248,  0,  0,  0,
     0,  0,  0,  0, 31, 24, 24, 24,255,255,255,255,255,255,255,255,
     0,  0,  0,  0,255,255,255,255,240,240,240,240,240,240,240,240,
    15, 15, 15, 15, 15, 15, 15, 15,255,255,255,255,  0,  0,  0,  0,
     0,  0,118,220,200,220,118,  0,  0,120,204,248,204,248,192,192,
     0,252,204,192,192,192,192,  0,  0,254,108,108,108,108,108,  0,
   252,204, 96, 48, 96,204,252,  0,  0,  0,126,216,216,216,112,  0,
     0,102,102,102,102,124, 96,192,  0,118,220, 24, 24, 24, 24,  0,
   252, 48,120,204,204,120, 48,252, 56,108,198,254,198,108, 56,  0,
    56,108,198,198,108,108,238,  0, 28, 48, 24,124,204,204,120,  0,
     0,  0,126,219,219,126,  0,  0,  6, 12,126,219,219,126, 96,192,
    56, 96,192,248,192, 96, 56,  0,120,204,204,204,204,204,204,  0,
     0,252,  0,252,  0,252,  0,  0, 48, 48,252, 48, 48,  0,252,  0,
    96, 48, 24, 48, 96,  0,252,  0, 24, 48, 96, 48, 24,  0,252,  0,
    14, 27, 27, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24,216,216,112,
    48, 48,  0,252,  0, 48, 48,  0,  0,118,220,  0,118,220,  0,  0,
    56,108,108, 56,  0,  0,  0,  0,  0,  0,  0, 24, 24,  0,  0,  0,
     0,  0,  0,  0, 24,  0,  0,  0, 15, 12, 12, 12,236,108, 60, 28,
   120,108,108,108,108,  0,  0,  0,112, 24, 48, 96,120,  0,  0,  0,
     0,  0, 60, 60, 60, 60,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0);

  { Standard Palette entries }
  DefaultPalette : Array [0..255] Of RGB =
  ((r:  0;g:  0;b:  0),(r:  0;g:  0;b: 42),(r:  0;g: 42;b:  0),(r:  0;g: 42;b: 42),
   (r: 42;g:  0;b:  0),(r: 42;g:  0;b: 42),(r: 42;g: 21;b:  0),(r: 42;g: 42;b: 42),
   (r: 21;g: 21;b: 21),(r: 21;g: 21;b: 63),(r: 21;g: 63;b: 21),(r: 21;g: 63;b: 63),
   (r: 63;g: 21;b: 21),(r: 63;g: 21;b: 63),(r: 63;g: 63;b: 21),(r: 63;g: 63;b: 63),
   (r:  0;g:  0;b:  0),(r:  5;g:  5;b:  5),(r:  8;g:  8;b:  8),(r: 11;g: 11;b: 11),
   (r: 14;g: 14;b: 14),(r: 17;g: 17;b: 17),(r: 20;g: 20;b: 20),(r: 24;g: 24;b: 24),
   (r: 28;g: 28;b: 28),(r: 32;g: 32;b: 32),(r: 36;g: 36;b: 36),(r: 40;g: 40;b: 40),
   (r: 45;g: 45;b: 45),(r: 50;g: 50;b: 50),(r: 56;g: 56;b: 56),(r: 63;g: 63;b: 63),
   (r:  0;g:  0;b: 63),(r: 16;g:  0;b: 63),(r: 31;g:  0;b: 63),(r: 47;g:  0;b: 63),
   (r: 63;g:  0;b: 63),(r: 63;g:  0;b: 47),(r: 63;g:  0;b: 31),(r: 63;g:  0;b: 16),
   (r: 63;g:  0;b:  0),(r: 63;g: 16;b:  0),(r: 63;g: 31;b:  0),(r: 63;g: 47;b:  0),
   (r: 63;g: 63;b:  0),(r: 47;g: 63;b:  0),(r: 31;g: 63;b:  0),(r: 16;g: 63;b:  0),
   (r:  0;g: 63;b:  0),(r:  0;g: 63;b: 16),(r:  0;g: 63;b: 31),(r:  0;g: 63;b: 47),
   (r:  0;g: 63;b: 63),(r:  0;g: 47;b: 63),(r:  0;g: 31;b: 63),(r:  0;g: 16;b: 63),
   (r: 31;g: 31;b: 63),(r: 39;g: 31;b: 63),(r: 47;g: 31;b: 63),(r: 55;g: 31;b: 63),
   (r: 63;g: 31;b: 63),(r: 63;g: 31;b: 55),(r: 63;g: 31;b: 47),(r: 63;g: 31;b: 39),
   (r: 63;g: 31;b: 31),(r: 63;g: 39;b: 31),(r: 63;g: 47;b: 31),(r: 63;g: 55;b: 31),
   (r: 63;g: 63;b: 31),(r: 55;g: 63;b: 31),(r: 47;g: 63;b: 31),(r: 39;g: 63;b: 31),
   (r: 31;g: 63;b: 31),(r: 31;g: 63;b: 39),(r: 31;g: 63;b: 47),(r: 31;g: 63;b: 55),
   (r: 31;g: 63;b: 63),(r: 31;g: 55;b: 63),(r: 31;g: 47;b: 63),(r: 31;g: 39;b: 63),
   (r: 45;g: 45;b: 63),(r: 49;g: 45;b: 63),(r: 54;g: 45;b: 63),(r: 58;g: 45;b: 63),
   (r: 63;g: 45;b: 63),(r: 63;g: 45;b: 58),(r: 63;g: 45;b: 54),(r: 63;g: 45;b: 49),
   (r: 63;g: 45;b: 45),(r: 63;g: 49;b: 45),(r: 63;g: 54;b: 45),(r: 63;g: 58;b: 45),
   (r: 63;g: 63;b: 45),(r: 58;g: 63;b: 45),(r: 54;g: 63;b: 45),(r: 49;g: 63;b: 45),
   (r: 45;g: 63;b: 45),(r: 45;g: 63;b: 49),(r: 45;g: 63;b: 54),(r: 45;g: 63;b: 58),
   (r: 45;g: 63;b: 63),(r: 45;g: 58;b: 63),(r: 45;g: 54;b: 63),(r: 45;g: 49;b: 63),
   (r:  0;g:  0;b: 28),(r:  7;g:  0;b: 28),(r: 14;g:  0;b: 28),(r: 21;g:  0;b: 28),
   (r: 28;g:  0;b: 28),(r: 28;g:  0;b: 21),(r: 28;g:  0;b: 14),(r: 28;g:  0;b:  7),
   (r: 28;g:  0;b:  0),(r: 28;g:  7;b:  0),(r: 28;g: 14;b:  0),(r: 28;g: 21;b:  0),
   (r: 28;g: 28;b:  0),(r: 21;g: 28;b:  0),(r: 14;g: 28;b:  0),(r:  7;g: 28;b:  0),
   (r:  0;g: 28;b:  0),(r:  0;g: 28;b:  7),(r:  0;g: 28;b: 14),(r:  0;g: 28;b: 21),
   (r:  0;g: 28;b: 28),(r:  0;g: 21;b: 28),(r:  0;g: 14;b: 28),(r:  0;g:  7;b: 28),
   (r: 14;g: 14;b: 28),(r: 17;g: 14;b: 28),(r: 21;g: 14;b: 28),(r: 24;g: 14;b: 28),
   (r: 28;g: 14;b: 28),(r: 28;g: 14;b: 24),(r: 28;g: 14;b: 21),(r: 28;g: 14;b: 17),
   (r: 28;g: 14;b: 14),(r: 28;g: 17;b: 14),(r: 28;g: 21;b: 14),(r: 28;g: 24;b: 14),
   (r: 28;g: 28;b: 14),(r: 24;g: 28;b: 14),(r: 21;g: 28;b: 14),(r: 17;g: 28;b: 14),
   (r: 14;g: 28;b: 14),(r: 14;g: 28;b: 17),(r: 14;g: 28;b: 21),(r: 14;g: 28;b: 24),
   (r: 14;g: 28;b: 28),(r: 14;g: 24;b: 28),(r: 14;g: 21;b: 28),(r: 14;g: 17;b: 28),
   (r: 20;g: 20;b: 28),(r: 22;g: 20;b: 28),(r: 24;g: 20;b: 28),(r: 26;g: 20;b: 28),
   (r: 28;g: 20;b: 28),(r: 28;g: 20;b: 26),(r: 28;g: 20;b: 24),(r: 28;g: 20;b: 22),
   (r: 28;g: 20;b: 20),(r: 28;g: 22;b: 20),(r: 28;g: 24;b: 20),(r: 28;g: 26;b: 20),
   (r: 28;g: 28;b: 20),(r: 26;g: 28;b: 20),(r: 24;g: 28;b: 20),(r: 22;g: 28;b: 20),
   (r: 20;g: 28;b: 20),(r: 20;g: 28;b: 22),(r: 20;g: 28;b: 24),(r: 20;g: 28;b: 26),
   (r: 20;g: 28;b: 28),(r: 20;g: 26;b: 28),(r: 20;g: 24;b: 28),(r: 20;g: 22;b: 28),
   (r:  0;g:  0;b: 16),(r:  4;g:  0;b: 16),(r:  8;g:  0;b: 16),(r: 12;g:  0;b: 16),
   (r: 16;g:  0;b: 16),(r: 16;g:  0;b: 12),(r: 16;g:  0;b:  8),(r: 16;g:  0;b:  4),
   (r: 16;g:  0;b:  0),(r: 16;g:  4;b:  0),(r: 16;g:  8;b:  0),(r: 16;g: 12;b:  0),
   (r: 16;g: 16;b:  0),(r: 12;g: 16;b:  0),(r:  8;g: 16;b:  0),(r:  4;g: 16;b:  0),
   (r:  0;g: 16;b:  0),(r:  0;g: 16;b:  4),(r:  0;g: 16;b:  8),(r:  0;g: 16;b: 12),
   (r:  0;g: 16;b: 16),(r:  0;g: 12;b: 16),(r:  0;g:  8;b: 16),(r:  0;g:  4;b: 16),
   (r:  8;g:  8;b: 16),(r: 10;g:  8;b: 16),(r: 12;g:  8;b: 16),(r: 14;g:  8;b: 16),
   (r: 16;g:  8;b: 16),(r: 16;g:  8;b: 14),(r: 16;g:  8;b: 12),(r: 16;g:  8;b: 10),
   (r: 16;g:  8;b:  8),(r: 16;g: 10;b:  8),(r: 16;g: 12;b:  8),(r: 16;g: 14;b:  8),
   (r: 16;g: 16;b:  8),(r: 14;g: 16;b:  8),(r: 12;g: 16;b:  8),(r: 10;g: 16;b:  8),
   (r:  8;g: 16;b:  8),(r:  8;g: 16;b: 10),(r:  8;g: 16;b: 12),(r:  8;g: 16;b: 14),
   (r:  8;g: 16;b: 16),(r:  8;g: 14;b: 16),(r:  8;g: 12;b: 16),(r:  8;g: 10;b: 16),
   (r: 11;g: 11;b: 16),(r: 12;g: 11;b: 16),(r: 13;g: 11;b: 16),(r: 15;g: 11;b: 16),
   (r: 16;g: 11;b: 16),(r: 16;g: 11;b: 15),(r: 16;g: 11;b: 13),(r: 16;g: 11;b: 12),
   (r: 16;g: 11;b: 11),(r: 16;g: 12;b: 11),(r: 16;g: 13;b: 11),(r: 16;g: 15;b: 11),
   (r: 16;g: 16;b: 11),(r: 15;g: 16;b: 11),(r: 13;g: 16;b: 11),(r: 12;g: 16;b: 11),
   (r: 11;g: 16;b: 11),(r: 11;g: 16;b: 12),(r: 11;g: 16;b: 13),(r: 11;g: 16;b: 15),
   (r: 11;g: 16;b: 16),(r: 11;g: 15;b: 16),(r: 11;g: 13;b: 16),(r: 11;g: 12;b: 16),
   (r: 32;g: 32;b: 32),(r: 63;g:  0;b:  0),(r:  0;g: 63;b:  0),(r: 63;g: 63;b:  0),
   (r:  0;g:  0;b: 63),(r: 63;g:  0;b: 63),(r:  0;g: 63;b: 63),(r: 63;g: 63;b: 63));

  NormalPut = 0;                 { WriteMode constants (not supported yet) }
  NotPut    = 1;
  AndPut    = 2;
  OrPut     = 3;
  XorPut    = 4;

  SolidFill       = 0;           { Fillpattern type }
  UserDefinedFill = 255;

  StdBufferSize = 4096;          { Buffer size for graphics functions }

  Err_VesaNotSupported = 200;    { Errorcodes }
  Err_VesaError        = 201;
  Err_InvalidViewPort  = 202;
  Err_InvalidFont      = 203;
  Err_InvalidCharSize  = 204;
  Err_InvalidFontScale = 205;

Type
  Palette2   = Array [0..  1] Of RGB;      { Standard palette structures }
  Palette4   = Array [0..  3] Of RGB;
  Palette16  = Array [0.. 15] Of RGB;
  Palette256 = Array [0..255] Of RGB;

  PFillPatternType = ^FillPatternType;
  FillPatternType = Record
                      Width, Height : Integer;
                      Data : Array [0..0] Of Byte;
                    End;

  PMGraphics = ^MGraphics;       { Pointer to abstract graphics object }
  MGraphics = Object             { abstract graphics object }

                { Pointer to array of bytes, exactly one scanline in size, }
                { meant for the user to play around with.                  }
                ScanlineBuffer : PByteArray;

                Constructor Init (NewGraphicsMode : GraphicsMode);
                Destructor  Done; Virtual;

                { Virtual methods, redefined by subclasses }

                Procedure SetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
                Procedure GetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
                Procedure SetLogicPalEntry (Entry : Word; Color : RGB); Virtual;
                Procedure GetLogicPalEntry (Entry : Word; Var Color : RGB); Virtual;

                { Standard graphics functions }

                Procedure PutPixel (x, y : Integer; Color : Byte);
                Function  GetPixel (x, y : Integer) : Byte;
                Procedure Line (x1, y1, x2, y2 : Integer);
                Procedure LineRel (dx, dy : Integer);
                Procedure LineTo (x, y : Integer);
                Procedure Rectangle (x1, y1, x2, y2 : Integer);
                Procedure Circle (x_center, y_center, radius : Integer);
                Procedure Ellipse (x_center, y_center, rx, ry : Integer);
                Procedure Arc (x_center, y_center, radius, s_angle, e_angle : Word);
                Procedure EllipseArc (x_center, y_center, rx, ry, s_angle, e_angle : Word);
                Procedure Curve (x1, y1, x2, y2, x3, y3 : Integer; Segments : Word);
                Procedure CubicBezierCurve (x1, y1, x2, y2, x3, y3, x4, y4 : Integer; Segments : Word);
                Procedure BSpline (NumPoints : Word; Var Points : Array Of Point; Segments : Word);
                Procedure DrawPoly (NumPoints : Word; Var Points : Array Of Point);
                Procedure FilledRectangle (x1, y1, x2, y2 : Integer);
                Procedure FilledCircle (x_center, y_center, radius : Integer);
                Procedure FilledEllipse (x_center, y_center, rx, ry : Integer);
                Procedure FilledConvexPoly  (NumPoints : Integer; Var Points : Array Of Point; FillColor : Byte);
                Procedure FilledConcavePoly (NumPoints : Integer; Var Points : Array Of Point; FillColor : Byte);
                Procedure BoundaryFill (x, y : Integer; Boundary, FillColor : Byte);
                Procedure FloodFill (x, y : Integer; Flood, FillColor : Byte);
                Procedure Paint (x, y, Width, Height : Integer; Color : Byte);
                Function  ImageSize (Width, Height : Integer) : LongInt;
                Procedure GetImage (x, y, Width, Height : Integer; Var ImageData);
                Procedure PutImage (x, y : Integer; Var ImageData);
                Procedure SetFillPattern (Style : Byte; Var Pattern);
                Procedure PrintAt (x, y : Integer; s : String; TextColor, BackColor : Byte);
                Procedure Print (s : String; TextColor, BackColor : Byte);
                Procedure SetFont (FontPtr : Pointer; FontWidth, FontHeight : Integer);
                Procedure SetFontScale (ScaleX, ScaleY : Integer);
                Procedure FontScale (Var ScaleX, ScaleY : Integer);
                Function  CharWidth : Integer;
                Function  CharHeight : Integer;
                Procedure Clear;
                Procedure MoveRel (dx, dy : Integer);
                Procedure MoveTo (x, y : Integer);
                Function  GetX : Integer;
                Function  GetY : Integer;
                Procedure SetWriteMode (Mode : Byte);
                Procedure SetColor (Color : Byte);
                Procedure SetBgColor (Color : Byte);
                Function  GetColor : Byte;
                Function  GetBgColor : Byte;
                Function  GetMaxX : Word;
                Function  GetMaxY : Word;
                Function  DeviceMaxX : Word;
                Function  DeviceMaxY : Word;
                Function  ColorDepth : Byte;
                Procedure SetViewport (MinX, MinY, MaxX, MaxY : Integer);
                Procedure GetViewport (Var MinX, MinY, MaxX, MaxY : Integer);

                { Color functions }

                Procedure SetLogicPalette (From, NumberOf : Integer; Entries : Array Of RGB);
                Procedure GetLogicPalette (From, NumberOf : Integer; Var Entries : Array Of RGB);

              Private

                Graphics_Mode : GraphicsMode;                 { Current video mode }
                LastGraphicsMode : Word;                   { Video mode before initialization }
                Buffer : Record                         { Union for byte and word addressing of buffer }
                           ByteIndex : Word;
                           WordIndex : Word;
                           Case Boolean Of
                             False : (Bytes : Array [0..StdBufferSize-1] Of Byte);
                             True  : (Words : Array [0..(StdBufferSize DIV 2)-1] Of Word);
                         End;
                Font : PByteArray;                      { Pointer to current font                     }
                FontScaleX, FontScaleY : Integer;       { Multiplication factors for fontwidth/height }
                CharDX, CharDY : Integer;               { Dimensions of characters in current font    }
                s1, s2, s3 : PByteArray;                { Three buffers for scanlines                 }
                FillStyle : Byte;                       { Filling method (solid, userdefined)         }
                FillPattern : PFillPatternType;         { Pointer to current fill pattern             }
                CP : Point;                             { Graphic 'cursor' position                   }
                VMinX, VMinY, VMaxX, VMaxY : Integer;   { Coordinates of viewport                     }
                FgColor, BgColor : Byte;                { Fore and background colors                  }
                WriteMode : Byte;                       { WriteMode (Normal, Not, Xor, And, Or )      }
                Regs : Registers;                       { General purpose register structure          }
                LastDev : Text;                         { Variable to store the old output device     }

                Function  CheckClip (Var Scanline, Index, Width, Offset : Integer) : Boolean;
                Procedure GetScanlinePattern (y, x, Width : Integer; Var Data);
                Procedure PushPoint (x, y : Integer);
                Procedure PopPoint (Var x, y : Integer);

             End;

  MGenericCard = Object (MGraphics)

                   Constructor Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);
                   Destructor  Done; Virtual;
                   Procedure   SetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
                   Procedure   GetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
                   Procedure   SetLogicPalEntry (Entry : Word; Color : RGB); Virtual;
                   Procedure   GetLogicPalEntry (Entry : Word; Var Color : RGB); Virtual;

                 End;

  MVGACard = Object (MGenericCard)

               Constructor Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);
               Destructor  Done; Virtual;
               Procedure   SetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
               Procedure   GetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
               Procedure   SetLogicPalEntry (Entry : Word; Color : RGB); Virtual;
               Procedure   GetLogicPalEntry (Entry : Word; Var Color : RGB); Virtual;

             End;

  MSuperVGACard = Object (MVGACard)  { Abstract class, don't use directly! }

                    Procedure SetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
                    Procedure GetScanline (Scanline, Index, Width : Integer; Var Data); Virtual;
                    Procedure SetBank (Bank : Word); Virtual;
                    Function  GetBank : Word; Virtual;

                    Procedure SetGranularity (Granularity : Word);

                  Private

                    Grain : LongInt;

                  End;

  {$IFNDEF DPMI}
  MVesaCard = Object (MSuperVGACard)

                Constructor Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);
                Destructor  Done; Virtual;
                Procedure SetBank (Bank : Word); Virtual;
                Function  GetBank : Word; Virtual;

              Private

                VesaInfo : Record
                             ModeAttr : Word; A_WinAttr : Byte; B_WinAttr : Byte;
                             WinGrain : Word; WinSize : Word; A_StartSeg : Word;
                             B_StartSeg : Word; BankSwitcher : Pointer; ScanlineBytes : Word;
                             ScreenWidth : Word; ScreenHeight : Word; CharWidth : Byte;
                             CharHeight : Byte; MemoryPlanes : Byte; BitsPerPixel : Byte;
                             Banks : Byte; MemoryModel : Byte; BankSize : Byte;
                             ImagePlanes : Byte;
                             Reserved : Array [1..226] Of Byte;
                           End;

                Function VesaError : Boolean;

              End;
  {$ENDIF}

  MTsengET4000Card = Object (MSuperVGACard)

                       Constructor Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);
                       Procedure SetBank (Bank : Word); Virtual;
                       Function  GetBank : Word; Virtual;

                     End;

Implementation

Const
  Module_ID = 'Graphics';
  RadToDeg = 180/Pi;
  DegToRad = 1/RadToDeg;
  SmallValue = 1e-8;

{$F+}                                             { have to be far }
Function DevDummy (Var f : TextRec) : Integer;

Begin
  DevDummy:=0;
End;

Function DevOut (Var f : TextRec) : Integer;

Var
  s : String;
  Card : PMGraphics;

Begin
  Move (f.Buffer,s[1],f.BufPos);
  s[0]:=Chr (f.BufPos);
  Move (f.UserData,Card,4);
  Card^.Print (s,Card^.GetColor,Card^.GetBgColor);
  f.BufPos:=0;
  DevOut:=0;
End;
{$F-}

Constructor MGraphics.Init (NewGraphicsMode : GraphicsMode);

Var
  p : Pointer;

Begin
  Graphics_Mode:=NewGraphicsMode;
  { Claim memory for three scanlines }
  GetMem (s1,Graphics_Mode.Width);
  GetMem (s2,Graphics_Mode.Width);
  GetMem (s3,Graphics_Mode.Width);
  GetMem (ScanlineBuffer,Graphics_Mode.Width);
  { If not succesfull, fail to construct }
  If Not Assigned (s1) Or Not Assigned (s2) Or Not Assigned (s3) Or
     Not Assigned (ScanlineBuffer) then Fail;
  { Install rom font }
  SetFont (@DefaultFont,8,8);
  { Install solid fillpattern }
  SetFillPattern (SolidFill,p);
  { Initial clipping window is equal to the entire display }
  SetViewport (0,0,DeviceMaxX,DeviceMaxY);
  { Setup initial colors }
  FgColor:=15;                    { foreground color }
  BgColor:=0;                     { background color }
  CP.x:=0;                        { initial 'cursor' position }
  CP.y:=0;
  { Setup standard output to enable user to put text on the screen using the }
  { standard write(ln) statements.                                           }
  TextRec (LastDev):=TextRec (Output);
  With TextRec (Output) Do Begin
    Handle:=$FFFF;
    Mode:=fmOutput;
    BufSize:=SizeOf (Buffer);
    BufPtr:=@Buffer;
    Name[0]:=#0;
    p:=@Self;
    Move (p,UserData,4);{ Put 32-bit pointer to graphics object in device }
    OpenFunc:=@DevDummy;
    InOutFunc:=@DevOut;
    FlushFunc:=@DevOut;
    CloseFunc:=@DevDummy;
  End;
End;

Destructor MGraphics.Done;

Begin
  { Deallocate memory }
  If Assigned (s1) then FreeMem (s1,Graphics_Mode.Width);
  If Assigned (s2) then FreeMem (s2,Graphics_Mode.Width);
  If Assigned (s3) then FreeMem (s3,Graphics_Mode.Width);
  If Assigned (ScanlineBuffer) then FreeMem (ScanlineBuffer,Graphics_Mode.Width);
  s1:=NIL; s2:=NIL; s3:=NIL; ScanlineBuffer:=NIL;
  TextRec (Output):=TextRec (LastDev);
End;

Procedure MGraphics.SetScanline (Scanline, Index, Width : Integer; Var Data);

Begin
  RunError (211);  { Abstract class so no direct calls }
End;

Procedure MGraphics.GetScanline (Scanline, Index, Width : Integer; Var Data);

Begin
  RunError (211);  { Abstract class so no direct calls }
End;

Procedure MGraphics.SetLogicPalEntry (Entry : Word; Color : RGB);

Begin
  RunError (211);  { Abstract class so no direct calls }
End;

Procedure MGraphics.GetLogicPalEntry (Entry : Word; Var Color : RGB);

Begin
  RunError (211);  { Abstract class so no direct calls }
End;

Procedure MGraphics.PutPixel (x, y : Integer; Color : Byte);
{ Putpixel puts a pixel on the screen on position (x,y) with color 'Color' }
Begin
  SetScanline (y,x,1,Color);
End;

Function MGraphics.GetPixel (x, y : Integer) : Byte;
{ return pixelvalue at position (x,y) }
Var
  Color : Byte;

Begin
  GetScanline (y,x,1,Color);
  GetPixel:=Color;
End;

Procedure MGraphics.Line (x1, y1, x2, y2 : Integer);
{ Draw a line from (x1,y1) to (x2,y2). No restrictions are placed on these }
{ input values. (so x1>x2 is no problem)                                   }
Var
  d, ax, ay, sx, sy, dx, dy : Integer;

Begin
  { bressenham line algorithm uses only integer arithmetic }
  dx := x2-x1;  ax := Abs (dx) SHL 1; If dx<0 then sx:=-1 Else sx:=1;
  dy := y2-y1;  ay := Abs (dy) SHL 1; If dy<0 then sy:=-1 Else sy:=1;
  PutPixel (x1, y1, FgColor);
  If ax>ay then Begin
    d:=ay-(ax SHR 1);
    While x1<>x2 Do Begin
      If d>=0 then Begin Inc (y1,sy); Dec (d,ax); End;
      Inc (x1,sx);
      Inc (d,ay);
      PutPixel (x1, y1, FgColor);
    End;
  End
  Else Begin
    d:=ax-(ay SHR 1);
    While y1<>y2 Do Begin
      If d>=0 then Begin Inc (x1,sx); Dec (d,ay); End;
      Inc (y1,sy);
      Inc (d,ax);
      PutPixel (x1, y1, FgColor);
    End;
  End;
End;

Procedure MGraphics.LineRel (dx, dy : Integer);

Begin
  Line (CP.x,CP.y,CP.x+dx,CP.y+dy);
  Inc (CP.x,dx);
  Inc (CP.y,dy);
End;

Procedure MGraphics.LineTo (x, y : Integer);

Begin
  Line (CP.x,CP.y,x,y);
  CP.x:=x;
  CP.y:=y;
End;

Procedure MGraphics.Rectangle (x1, y1, x2, y2 : Integer);
{ Draw a rectangle with upperleft corner (x1,y1) and lowerright corner (x2,y2) }
{ When other writemode are implemented this algorithm has to be changed as     }
{ the corner pointer are plot more than once, which causes problems in other   }
{ writemodes                                                                   }
Begin
  Line (x1,y1,x2,y1);
  Line (x2,y1,x2,y2);
  Line (x2,y2,x1,y2);
  Line (x1,y2,x1,y1);
End;

Procedure MGraphics.Circle (x_center, y_center, radius : Integer);
{ Draw a circle with center (x_center,y_center) and radius 'radius' }
Var
  x, y, d : Integer;

Begin
  { bressenham circle algorithm using integer-only arithmetic }
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 Do Begin
    PutPixel (x_center+x,y_center+y,FgColor);
    PutPixel (x_center+x,y_center-y,FgColor);
    PutPixel (x_center-x,y_center+y,FgColor);
    PutPixel (x_center-x,y_center-y,FgColor);
    If d + y > 0 then Begin
      Dec (y);
      Dec (d,2*y+1);
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,2*x+1);
    End;
  End;
End;

Procedure MGraphics.Ellipse (x_center, y_center, rx, ry : Integer);
{ Draw an Ellipse with center (x_center,y_center), horizontal radius 'rx' }
{ and vertical radius 'ry'. This algorithm partially uses floating point  }
{ arithmetic to still get an accurate ellipse when rx or ry is small !    }
Var
   x, y, x2, dx : Integer;
   Sqrry : LongInt;
   rxryDiv : Real;

Begin
  FillChar (s1^,1+DeviceMaxX,FgColor);
  Dec(ry);
  If ry>0 then Begin
    Sqrry:=Sqr (LongInt (ry));
    rxryDiv:=rx/ry;
    X2:=rx;
    For y:=0 to ry Do Begin
      x:=Round (rxryDiv*Sqrt(Sqrry-Sqr(y-0.5)));
      If x<>x2 then Begin
        dx:=1+x2-x;
        SetScanline (y_center+y,x_center+x,dx,s1^);
        SetScanline (y_center+y,x_center-x2,dx,s1^);
        SetScanline (y_center-y,x_center+x,dx,s1^);
        SetScanline (y_center-y,x_center-x2,dx,s1^);
      End
      Else Begin
        SetScanline (y_center+y,x_center+x,1,s1^);
        SetScanline (y_center+y,x_center-x2,1,s1^);
        SetScanline (y_center-y,x_center+x,1,s1^);
        SetScanline (y_center-y,x_center-x2,1,s1^);
      End;
      x2:=x;
    End;
  End
  Else x:=rx;
  Inc(ry);
  SetScanline (y_center+ry,x_center-x,2*x+1,s1^);
  SetScanline (y_center-ry,x_center-x,2*x+1,s1^);
End;

Procedure MGraphics.Arc (x_center, y_center, radius, s_angle, e_angle : Word);
{ An algorithm to draw an arc. Crude but it works (anyone have a better one?) }
Var
  p : Integer;
  x, y : Word;
  Alpha : Real;

Begin
  If radius=0 then Begin PutPixel (x_center,y_center,FgColor); Exit; End;
  s_angle:=s_angle MOD 361;
  e_angle:=e_angle MOD 361;
  If s_angle>e_angle then Begin
    s_angle:=s_angle Xor e_angle; e_angle:=e_angle Xor s_angle; s_angle:=e_angle Xor s_angle;
  End;
  x:=0;
  y:=Radius;
  p:=3-2*Radius;
  While x<=y Do
    Begin
      Alpha:=RadToDeg*Arctan (x/y);
      If (Alpha>=s_angle) And (Alpha<=e_angle) then PutPixel (x_center-x, y_center-y, FgColor);
      If (90-Alpha>=s_angle) And (90-Alpha<=e_angle) then PutPixel (x_center-y, y_center-x, FgColor);
      If (90+Alpha>=s_angle) And (90+Alpha<=e_angle) then PutPixel (x_center-y, y_center+x, FgColor);
      If (180-Alpha>=s_angle) And (180-Alpha<=e_angle) then PutPixel (x_center-x, y_center+y, FgColor);
      If (180+Alpha>=s_angle) And (180+Alpha<=e_angle) then PutPixel (x_center+x, y_center+y, FgColor);
      If (270-Alpha>=s_angle) And (270-Alpha<=e_angle) then PutPixel (x_center+y, y_center+x, FgColor);
      If (270+Alpha>=s_angle) And (270+Alpha<=e_angle) then PutPixel (x_center+y, y_center-x, FgColor);
      If (360-Alpha>=s_angle) And (360-Alpha<=e_angle) then PutPixel (x_center+x, y_center-y, FgColor);
      If p<0 then
        p:=p+4*x+6
      Else
        Begin
          p:=p+4*(x-y)+10;
          Dec (y);
        End;
      Inc (x);
    End;
End;

Procedure MGraphics.EllipseArc (x_center, y_center, rx, ry, s_angle, e_angle : Word);
{ Draw an ellipse arc. Crude but it works (anyone have a better one?) }
Var
  aSqr, bSqr, twoaSqr, twobSqr, x, y, twoXbSqr, twoYaSqr, error : LongInt;
  Alpha : Real;

Procedure PlotPoints;

Begin
  If (Alpha>=s_angle) And (Alpha<=e_angle) then PutPixel (x_center-x,y_center-y,FgColor);
  If (180-Alpha>=s_angle) And (180-Alpha<=e_angle) then PutPixel (x_center-x,y_center+y,FgColor);
  If (180+Alpha>=s_angle) And (180+Alpha<=e_angle) then PutPixel (x_center+x,y_center+y,FgColor);
  If (360-Alpha>=s_angle) And (360-Alpha<=e_angle) then PutPixel (x_center+x,y_center-y,FgColor);
End;

Begin
  If rx=0 then Begin
    Line (x_center,y_center-ry,x_center,y_center+ry);
    Exit;
  End;
  s_angle:=s_angle MOD 361;
  e_angle:=e_angle MOD 361;
  If s_angle>e_angle then Begin
    s_angle:=s_angle Xor e_angle; e_angle:=e_angle Xor s_angle; s_angle:=e_angle Xor s_angle;
  End;
  aSqr:=LongInt (rx)*LongInt (rx);
  bSqr:=LongInt (ry)*LongInt (ry);
  twoaSqr:=2*aSqr;
  twobSqr:=2*bSqr;
  x:=0;
  y:=ry;
  twoXbSqr:=0;
  twoYaSqr:=y*twoaSqr;
  error:=-y*aSqr;
  While twoXbSqr<=twoYaSqr Do Begin
    If y=0 then Alpha:=90 Else Alpha:=RadToDeg*Arctan (x/y); { Crude but it works }
    PlotPoints;
    Inc (x);
    Inc (twoXbSqr,twobSqr);
    Inc (error,twoXbSqr-bSqr);
    If error>=0 then Begin
      Dec (y);
      Dec (twoYaSqr,twoaSqr);
      Dec (error,twoYaSqr);
    End;
  End;
  x:=rx;
  y:=0;
  twoXbSqr:=x*twobSqr;
  twoYaSqr:=0;
  error:=-x*bSqr;
  While twoXbSqr>twoYaSqr Do Begin
    If y=0 then Alpha:=90 Else Alpha:=RadToDeg*Arctan (x/y);
    PlotPoints;
    Inc (y);
    Inc (twoYaSqr,twoaSqr);
    Inc (error,twoYaSqr-aSqr);
    If error>=0 then Begin
      Dec (x);
      Dec (twoXbSqr,twobSqr);
      Dec (error,twoXbSqr);
    End;
  End;
End;

Procedure MGraphics.Curve (x1, y1, x2, y2, x3, y3 : Integer; Segments : Word);
{ Draw a curve from (x1,y1) through (x2,y2) to (x3,y3) divided in 'Segments' segments }
Var
  lsteps, ex, ey, fx, fy : LongInt;
  t1, t2 : Integer;

Begin
  x2:=(x2 SHL 1)-((x1+x3) SHR 1);
  y2:=(y2 SHL 1)-((y1+y3) SHR 1);
  lsteps:=Segments;
  If (lsteps<2) then lsteps:=2;
  If (lsteps>128) then lsteps:=128;  { Clamp value to avoid overcalculation }
  ex:=(LongInt (x2-x1) SHL 17) DIV lsteps;
  ey:=(LongInt (y2-y1) SHL 17) DIV lsteps;
  fx:=(LongInt (x3-(2*x2)+x1) SHL 16) DIV (lsteps*lsteps);
  fy:=(LongInt (y3-(2*y2)+y1) SHL 16) DIV (lsteps*lsteps);
  Dec (lsteps);
  While lsteps>0 Do Begin
    t1:=x3;
    t2:=y3;
    x3:=(((fx*lsteps+ex)*lsteps) SHR 16)+x1;
    y3:=(((fy*lsteps+ey)*lsteps) SHR 16)+y1;
    Line (t1,t2,x3,y3);
    Dec (lsteps);
  End;
  Line (x3,y3,x1,y1);
End;

Procedure MGraphics.CubicBezierCurve (x1, y1, x2, y2, x3, y3, x4, y4 : Integer; Segments : Word);
{ Draw a cubic bezier-curve directly using the basis functions }
Var
  tx1, tx2, tx3, ty1, ty2, ty3, mu, mu2, mu3, mudelta : Real;
  xstart, ystart, xend, yend, n : Integer;

Begin
  If (Segments<1) then Exit;
  If Segments>128 then Segments:=128;

  mudelta:=1/Segments;
  mu:=0;
  tx1:=-x1+3*x2-3*x3+x4; ty1:=-y1+3*y2-3*y3+y4;
  tx2:=3*x1-6*x2+3*x3;   ty2:=3*y1-6*y2+3*y3;
  tx3:=-3*x1+3*x2;       ty3:=-3*y1+3*y2;

  xstart:=x1;
  ystart:=y1;
  mu:=mu+mudelta;
  For n:=1 to Segments Do Begin
    mu2:=mu*mu;
    mu3:=mu2*mu;
    xend:=Round (mu3*tx1+mu2*tx2+mu*tx3+x1);
    yend:=Round (mu3*ty1+mu2*ty2+mu*ty3+y1);
    Line (xstart, ystart, xend, yend);
    mu:=mu+mudelta;
    xstart:=xend;
    ystart:=yend;
  End;
End;

Procedure MGraphics.BSpline (NumPoints : Word; Var Points : Array Of Point; Segments : Word);
{ Draw a BSpline approximating a curve defined by the array of points. }
{ Beware! A B-Spline generaly does not normally pass through the points}
{ defining it !                                                        }
Function Calculate (mu : Real; p0, p1, p2, p3 : Integer) : Integer;

Var
  mu2, mu3 : Real;

Begin
  mu2:=mu*mu;
  mu3:=mu2*mu;
  Calculate:=Round ((1/6)*(mu3*(-p0+3*p1-3*p2+p3)+
                           mu2*(3*p0-6*p1+3*p2)+
                           mu *(-3*p0+3*p2)+(p0+4*p1+p2)));
End;

Var
  mu, mudelta : Real;
  x1, y1, x2, y2, n, h : Integer;

Begin
  If (NumPoints<4) Or (NumPoints>16383) then Exit;
  mudelta:=1/Segments;
  For n:=3 to NumPoints-1 Do Begin
    mu:=0;
    x1:=Calculate (mu,Points[n-3].x,Points[n-2].x,Points[n-1].x,Points[n].x);
    y1:=Calculate (mu,Points[n-3].y,Points[n-2].y,Points[n-1].y,Points[n].y);
    mu:=mu+mudelta;
    For h:=1 to Segments Do Begin
      x2:=Calculate (mu,Points[n-3].x,Points[n-2].x,Points[n-1].x,Points[n].x);
      y2:=Calculate (mu,Points[n-3].y,Points[n-2].y,Points[n-1].y,Points[n].y);
      Line (x1, y1, x2, y2);
      mu:=mu+mudelta;
      x1:=x2;
      y1:=y2;
    End;
  End;
End;

Procedure MGraphics.DrawPoly (NumPoints : Word; Var Points : Array Of Point);
{ Draw the outline of a polygon }
Var
  n : Word;

Begin
  If (NumPoints=0) Or (NumPoints>16383) then Exit;
  For n:=0 to NumPoints-1 Do Begin
    Line (Points[n].x,Points[n].y,Points[(n+1) MOD NumPoints].x,Points[(n+1) MOD NumPoints].y);
  End;
End;

Procedure MGraphics.FilledRectangle (x1, y1, x2, y2 : Integer);
{ Draw a filled rectangle }
Begin
  If x1<=x2 then
    If y1<y2 then
      Paint (x1,y1,1+x2-x1,1+y2-y1,FgColor)
    Else
      Paint (x1,y2,1+x2-x1,1+y1-y2,FgColor)
  Else
    If y1<y2 then
      Paint (x2,y1,1+x1-x2,1+y2-y1,FgColor)
    Else
      Paint (x2,y2,1+x1-x2,1+y1-y2,FgColor);
End;

Procedure MGraphics.FilledCircle (x_center, y_center, radius : Integer);
{ Draw a filled circle }
Var
  x, y, d : Integer;
  bx, BitmapX, BitmapY : Integer;

Begin
  x:=0; y:=radius; d:=2*(1-radius);
  While y>=0 Do Begin
    Paint (x_center-x,y_center+y,1+2*x,1,FgColor);
    Paint (x_center-x,y_center-y,1+2*x,1,FgColor);
    If d+y > 0 then Begin
      Dec (y);
      Dec (d,2*y+1);
    End;
    If x > d then Begin
      Inc (x);
      Inc (d,2*x+1);
    End;
  End;
End;

Procedure MGraphics.FilledEllipse (x_center, y_center, rx, ry : Integer);
{ Draw a filled ellipse }
Var
   x, y, x2, dx : Integer;
   Sqrry : LongInt;
   rxryDiv : Real;

Begin
  Dec(ry);
  If ry>0 then Begin
    Sqrry:=Sqr (LongInt (ry));
    rxryDiv:=rx/ry;
    X2:=rx;
    For y:=0 to ry Do Begin
      x:=Round (rxryDiv*Sqrt(Sqrry-Sqr(y-0.5)));
      Paint (x_center-x2,y_center+y,1+x+x2,1,FgColor);
      Paint (x_center-x2,y_center-y,1+x+x2,1,FgColor);
      x2:=x;
    End;
  End
  Else x:=rx;
  Inc (ry);
  Paint (x_center-x,y_center+ry,2*x+1,1,FgColor);
  Paint (x_center-x,y_center-ry,2*x+1,1,FgColor);
End;

Procedure MGraphics.FilledConvexPoly (NumPoints : Integer; Var Points : Array Of Point; FillColor : Byte);
{ Draw a filled CONVEX poly, using the same arithmetic as the bressenham }
{ line algorithm to produce accurately filled polygon. A polygon is      }
{ convex when every path between any two points defining the polygon lies}
{ inside that polygon. (translation : don't use weird shapes :) )        }
Type
  LineData = Record Index, x, y, dy, d, ax, ay, sx : Integer; End;

Var
  Min_y, Smallest, n, ToDo : Integer;
  First, Second : LineData;

Procedure InitPolyline (Var Data : LineData; p1, p2 : Integer);

Begin
  If p1<0 then p1:=NumPoints+p1; p1:=p1 MOD NumPoints;
  If p2<0 then p2:=NumPoints+p2; p2:=p2 MOD NumPoints;
  Data.x:=Points[p1].x;
  Data.y:=Points[p1].y;
  If Points[p2].x<Points[p1].x then Begin
    Data.ax:=(Points[p1].x-Points[p2].x) SHL 1;
    Data.sx:=-1;
  End
  Else Begin
    Data.ax:=(Points[p2].x-Points[p1].x) SHL 1;
    Data.sx:=1;
  End;
  Data.ay:=(Points[p2].y-Points[p1].y) SHL 1;
  Data.d:=Data.ax-(Data.ay SHR 1);
  Data.dy:=Abs (Points[p2].y-Points[p1].y);
  Data.Index:=p1;
End;

Begin
  If (NumPoints<3) Or (NumPoints>16383) then Exit;
  FillChar (s1^,1+DeviceMaxX,FillColor);
  Smallest:=0;
  Min_y:=Points[0].y;
  For n:=0 to NumPoints-1 Do
    If Points[n].y<Min_y then Begin Min_y:=Points[n].y; Smallest:=n; End;

  InitPolyline (First,Smallest,Smallest+1);
  InitPolyline (Second,Smallest,Smallest-1);
  ToDo:=NumPoints-2;

  While ToDo>=0 Do Begin
    If First.x<Second.x then
      SetScanline (First.y,First.x,1+Second.x-First.x,s1^)
    Else
      SetScanline (Second.y,Second.x,1+First.x-Second.x,s1^);
    With First Do Begin
      While (d>=0) And (ay<>0) Do Begin Inc (x,sx); Dec (d,ay); End;
      Inc (d,ax);
      Dec (dy);
      Inc (y);
    End;
    With Second Do Begin
      While (d>=0) And (ay<>0) Do Begin Inc (x,sx); Dec (d,ay); End;
      Inc (d,ax);
      Dec (dy);
      Inc (y);
    End;
    If First.dy<=0 then Begin
      InitPolyline (First,First.Index+1,First.Index+2);
      Dec (Todo);
    End;
    If Second.dy<=0 then Begin
      InitPolyline (Second,Second.Index-1,Second.Index-2);
      Dec (ToDo);
    End;
  End;
End;

Procedure MGraphics.FilledConcavePoly (NumPoints : Integer; Var Points : Array Of Point; FillColor : Byte);
{ Draw a filled concave polygon using floating point arithmetic : less accurate }
{ but able to fill ANY polygon, not just convex ones.                           }
Type
  XValueType = Array [0..32766] Of Integer;

Var
  MaxIndex, Min_y, Max_y, Index, n, h, i, j, k, l : Integer;
  m : Real;
  XValue : ^XValueType;

Procedure QuickSort (l, r : Integer);
{ Quicksort to sort the X-Values fast }
Var
  i, j, x, y : Integer;

Begin
  i:=l; j:=r; x:=XValue^[(l+r) DIV 2];
  REPEAT
    While XValue^[i]<x do Inc (i);
    While x<XValue^[j] do Dec (j);
    If i<=j then Begin
      y:=XValue^[i]; XValue^[i]:=XValue^[j]; XValue^[j]:=y;
      Inc (i); Dec (j);
    End;
  Until i>j;
  If l<j then QuickSort (l,j);
  If i<r then QuickSort (i,r);
End;

Begin
  If (NumPoints<3) Or (NumPoints>16383) then Exit;
  FillChar (s1^,1+DeviceMaxX,FillColor);
  MaxIndex:=StdBufferSize DIV 2;
  XValue:=@Buffer;
  Min_y:=Graphics_Mode.Height-1;
  Max_y:=0;
  For n:=0 to NumPoints-1 Do Begin
    If Points[n].y<Min_y then Min_y:=Points[n].y;
    If Points[n].y>Max_y then Max_y:=Points[n].y;
  End;
  For n:=Min_y to Max_y Do Begin
    Index:=0;
    For i:=0 to NumPoints-1 Do Begin
      l:=(i+1) MOD NumPoints;
      h:=Points[i].y; j:=Points[l].y;
      If h>j then Begin k:=h; h:=j; j:=k; End;
      If (h<=n) And (n<j) And (Index<=MaxIndex) then Begin
        m:=(Points[i].x-Points[l].x) / (Points[i].y-Points[l].y);
        XValue^[Index]:=Round (m*(n-Points[l].y))+Points[l].x;
        Inc (Index);
      End;
    End;
    If Index>0 then QuickSort (0,Index-1);
    j:=0;
    While (j<Index) Do Begin
      SetScanline (n,XValue^[j],XValue^[j+1]-XValue^[j]+1,s1^);
      Inc (j,2);  { j is guaranteed to be even ! }
    End;
  End;
End;

Procedure MGraphics.BoundaryFill (x, y : Integer; Boundary, FillColor : Byte);
{ Fill a region of the screen bounded by 'Boundary' colored pixels }
Var
  Beginx : Integer;
  d, e, a : Byte;
  Equal : Boolean;

Begin
  If (x<0) Or (y<0) Or (x>GetMaxX) Or (y>GetMaxY) then Exit;
  Buffer.WordIndex:=0;
  PushPoint (x,y);
  While Buffer.WordIndex>0 Do Begin
    PopPoint (x,y);
    GetScanline (y,0,Graphics_Mode.Width,s1^);
    GetScanline (y-1,0,Graphics_Mode.Width,s2^);
    GetScanline (y+1,0,Graphics_Mode.Width,s3^);
    While Not (s1^[x] IN [Boundary,FillColor]) And (x<=GetMaxX) Do Inc (x);
    d:=0;
    e:=0;
    Dec (x);
    Beginx:=x;
  REPEAT
    If y<GetMaxY then Begin
      Equal:=s3^[x] IN [Boundary,FillColor];
      If (e=0) And Not Equal then Begin
        PushPoint (x,y+1);
        e:=1;
      End
      Else
        If (e=1) And Equal then e:=0;
    End;
    If y>0 then Begin
      Equal:=s2^[x] IN [Boundary,FillColor];
      If (d=0) And Not Equal then Begin
        PushPoint (x,y-1);
        d:=1;
      End
      Else
        If (d=1) And Equal then d:=0;
    End;
    Dec (x);
  Until (x<0) Or (s1^[x]=Boundary);
    Paint (x+1,y,Beginx-x,1,FillColor);
  End;
End;

Procedure MGraphics.FloodFill (x, y : Integer; Flood, FillColor : Byte);
{ Fill a region of the screen bounded by any color not equal to color 'Flood' }
Var
  Beginx : Integer;
  d, e, a : Byte;
  Cont : Boolean;

Begin
  If (x<0) Or (y<0) Or (x>GetMaxX) Or (y>GetMaxY) then Exit;
  Buffer.WordIndex:=0;
  PushPoint (x,y);
  While Buffer.WordIndex>0 Do Begin
    PopPoint (x,y);
    GetScanline (y-1,0,Graphics_Mode.Width,s2^);
    GetScanline (y,0,Graphics_Mode.Width,s1^);
    GetScanline (y+1,0,Graphics_Mode.Width,s3^);
    While (s1^[x]=Flood) And (x<=GetMaxX) Do Inc (x);
    d:=0;
    e:=0;
    Dec (x);
    Beginx:=x;
  REPEAT
    If y<GetMaxY then Begin
      Cont:=(s3^[x]=Flood) And (s3^[x]<>FillColor);
      If (e=0) And Cont then Begin
        PushPoint (x,y+1);
        e:=1;
      End
      Else
        If (e=1) And Not Cont then e:=0;
     End;
    If y>0 then Begin
      Cont:=(s2^[x]=Flood) And (s2^[x]<>FillColor);
      If (d=0) And Cont then Begin
        PushPoint (x,y-1);
        d:=1;
      End
      Else
        If (d=1) And Not Cont then d:=0;
    End;
    Dec (x);
  Until (x<0) Or (s1^[x]<>Flood);
    Paint (x+1,y,Beginx-x,1,FillColor);
  End;
End;

Procedure MGraphics.Paint (x, y, Width, Height : Integer; Color : Byte);
{ Fill a region of the screen with color 'Color' }
Var
  n : Integer;

Begin
  If Width>1+DeviceMaxX then Width:=1+DeviceMaxX;
  If FillStyle<>UserDefinedFill then FillChar (s1^,Width,Color);
  For n:=y to y+Height-1 Do Begin
    If FillStyle=UserDefinedFill then GetScanlinePattern (n,x,Width,s1^);
    SetScanline (n,x,Width,s1^);
  End;
End;

Function MGraphics.ImageSize (Width, Height : Integer) : LongInt;

Begin
  ImageSize:=4+LongInt(Width)*LongInt(Height);
End;

Procedure MGraphics.GetImage (x, y, Width, Height : Integer; Var ImageData);
{ 'Get' an image from the screen an put it in the given stream. The image }
{ must not consume more than 64 Kb of memory. If it does, use             }
{ GetLargeImage instead.                                                  }
Var
  Image : Record
            Width, Height : Integer;
            Data : Array [0..0] Of Byte;
          End ABSOLUTE ImageData;
  Index : Word;

Begin
  If (Width<=0) Or (Height<=0) Or (LongInt(Width)*LongInt(Height)>65528) then Exit;
  Image.Width:=Width;
  Image.Height:=Height;
  Index:=0;
  For y:=y to y+Height-1 Do Begin
    GetScanline (y,x,Width,Image.Data[Index]);
    Inc (Index,Width);
  End;
End;

Procedure MGraphics.PutImage (x, y : Integer; Var ImageData);
{ 'Put' an image on the screen at (x,y) }
Var
  Image : Record
            Width, Height : Integer;
            Data : Array [0..0] Of Byte;
          End ABSOLUTE ImageData;
  Index : Word;

Begin
  Index:=0;
  For y:=y to y+Image.Height-1 Do Begin
    SetScanline (y,x,Image.Width,Image.Data[Index]);
    Inc (Index,Image.Width);
  End;
End;

Procedure MGraphics.SetFillPattern (Style : Byte; Var Pattern);
{ Install either a user defined fill pattern or a standard pattern }
Begin
  Case Style Of
    SolidFill       : ;
    UserDefinedFill : FillPattern:=@Pattern;
  Else
    Exit;
  End;
  FillStyle:=Style;
End;

Procedure MGraphics.PrintAt (x, y : Integer; s : String; TextColor, BackColor : Byte);
{ Put the given string on the screen using the current font }
Var
  ByteRange, c, n, h, i : Integer;
  DataIndex, Index, Size : Word;
  b : Byte;

Begin
  If Font=NIL then Exit;
  Size:=FontScaleX*CharDX;
  ByteRange:=1+((CharDX-1) SHR 3);
  For c:=1 to Length (s) Do Begin
    Index:=Ord (s[c])*(ByteRange)*CharDY-1;
    i:=y;
    For n:=0 to CharDY-1 Do Begin
      DataIndex:=0;
      For h:=0 to CharDX-1 Do Begin
        If (h And 7)=0 then Begin Inc (Index); b:=Font^[Index]; End;
        If b>=128 then
          FillChar (s1^[DataIndex],FontScaleX,TextColor)
        Else
          FillChar (s1^[DataIndex],FontScaleX,BackColor);
        Inc (DataIndex,FontScaleX);
        b:=b SHL 1;
      End;
      For h:=0 to FontScaleY-1 Do
        SetScanline (i+h,x+Size*(c-1),Size,s1^);
      Inc (i,FontScaleY);
    End;
  End;
End;

Procedure MGraphics.Print (s : String; TextColor, BackColor : Byte);
{ Put the given string on the screen using the current font }

Begin
  PrintAt (CP.x,CP.y,s,TextColor,BackColor);
  Inc (CP.x,Length (s)*CharDX);
End;

Procedure MGraphics.SetFont (FontPtr : Pointer; FontWidth, FontHeight : Integer);
{ Install a new font }
Begin
  If Not Assigned (FontPtr) Or (FontWidth=0) Or (FontHeight=0) then Exit;
  Font:=FontPtr;
  CharDX:=FontWidth;
  CharDY:=FontHeight;
  SetFontScale (1,1);
End;

Procedure MGraphics.SetFontScale (ScaleX, ScaleY : Integer);

Begin
  If (ScaleX=0) Or (ScaleY=0) then Exit;
  FontScaleX:=ScaleX;
  FontScaleY:=ScaleY;
End;

Procedure MGraphics.FontScale (Var ScaleX, ScaleY : Integer);

Begin
  ScaleX:=FontScaleX;
  ScaleY:=FontScaleY;
End;

Function MGraphics.CharWidth : Integer;
{ Return the width of a character in the current font }
Begin
  If Font=NIL then CharWidth:=0 Else CharWidth:=CharDX*FontScaleX;
End;

Function MGraphics.CharHeight : Integer;
{ Return the height of a character in the current font }
Begin
  If Font=NIL then CharHeight:=0 Else CharHeight:=CharDY*FontScaleY;
End;

Procedure MGraphics.SetColor (Color : Byte);
{ Set the foreground color }
Begin
  FgColor:=Color;
End;

Procedure MGraphics.SetBgColor (Color : Byte);
{ Set the background color }
Begin
  BgColor:=Color;
End;

Function MGraphics.GetColor : Byte;
{ Return the current foreground color }
Begin
  GetColor:=FgColor;
End;

Function MGraphics.GetBgColor : Byte;
{ Return the current background color }
Begin
  GetBgColor:=BgColor;
End;

Function MGraphics.GetMaxX : Word;
{ Return the highest possible x-coordinate of the current viewport }
Begin
  GetMaxX:=VMaxX-VMinX;
End;

Function MGraphics.GetMaxY : Word;
{ Return the highest possible y-coordinate of the current viewport }
Begin
  GetMaxY:=VMaxY-VMinY;
End;

Function MGraphics.DeviceMaxX : Word;
{ Return the highest possible x-coordinate on the current device }
Begin
  DeviceMaxX:=Graphics_Mode.Width-1;
End;

Function MGraphics.DeviceMaxY : Word;
{ Return the highest possible y-coordinate on the current device }
Begin
  DeviceMaxY:=Graphics_Mode.Height-1;
End;

Function MGraphics.ColorDepth : Byte;
{ Return the colordepth of the current device }
Begin
  ColorDepth:=Graphics_Mode.ColorDepth;
End;

Procedure MGraphics.SetViewport (MinX, MinY, MaxX, MaxY : Integer);
{ Set the current viewport }
Var
  WrongViewPort : Boolean;

Begin
  WrongViewPort:=(MinX<0) Or (MinY<0) Or (MaxX<0) Or (MaxY<0);
  WrongViewPort:=WrongViewPort Or ((MinX>MaxX) Or (MinY>MaxY));
  WrongViewPort:=WrongViewPort Or ((MaxX>=Graphics_Mode.Width) Or (MaxY>=Graphics_Mode.Height));
  If Not WrongViewPort then Begin
    VMinX:=MinX;
    VMinY:=MinY;
    VMaxX:=MaxX;
    VMaxY:=MaxY;
  End;
End;

Procedure MGraphics.GetViewport (Var MinX, MinY, MaxX, MaxY : Integer);
{ Return the current viewport }
Begin
  MinX:=VMinX;
  MinY:=VMinY;
  MaxX:=VMaxX;
  MaxY:=VMaxY;
End;

Procedure MGraphics.Clear;
{ Clear the current viewport using the current background color }
Var
  SaveMode : Byte;

Begin
  SaveMode:=WriteMode;
  WriteMode:=NormalPut;
  Paint (0,0,1+GetMaxX,1+GetMaxY,BgColor);
  WriteMode:=SaveMode;
  CP.x:=0;
  CP.y:=0;
End;

Procedure MGraphics.MoveRel (dx, dy : Integer);

Begin
  Inc (CP.x,dx);
  Inc (CP.y,dy);
End;

Procedure MGraphics.MoveTo (x, y : Integer);

Begin
  CP.x:=x;
  CP.y:=y;
End;

Function MGraphics.GetX : Integer; Begin GetX:=CP.x; End;
Function MGraphics.GetY : Integer; Begin GetY:=CP.y; End;

Procedure MGraphics.SetWriteMode (Mode : Byte);
{ Set the current writemode }
Begin
  If Mode IN [NormalPut..XorPut] then WriteMode:=Mode;
End;

Procedure MGraphics.SetLogicPalette (From, NumberOf : Integer; Entries : Array Of RGB);
{ Set (part of) a logic palette }
Var
  n : Integer;

Begin
  For n:=From to From+NumberOf-1 Do SetLogicPalEntry (n,Entries[n-From]);
End;

Procedure MGraphics.GetLogicPalette (From, NumberOf : Integer; Var Entries : Array Of RGB);
{ Return (part of) a logic palette }
Var
  n : Integer;

Begin
  For n:=From to From+NumberOf-1 Do GetLogicPalEntry (n,Entries[n-From]);
End;

Function MGraphics.CheckClip (Var Scanline, Index, Width, Offset : Integer) : Boolean;

Begin
  Offset:=0;
  CheckClip:=False;
  Inc (Index,VMinX);
  Inc (Scanline,VMinY);
  If (Scanline<VMinY) Or (Scanline>VMaxY) Or (Index>VMaxX) then Exit;
  If Index<VMinX then Begin Offset:=VMinX-Index; Dec (Width,Offset); Index:=VMinX; End;
  If Index+Width>(VMaxX+1) then Width:=1+VMaxX-Index;
  CheckClip:=Width>0;
End;

Procedure MGraphics.GetScanlinePattern (y, x, Width : Integer; Var Data);

Var
  BitMapX, BitMapY, bx : Integer;
  Offset : Word;
  ScanlineData : Array [0..0] Of Byte ABSOLUTE Data;

Begin
  BitmapY:=y MOD FillPattern^.Height; If BitmapY<0 then BitmapY:=FillPattern^.Height-BitmapY;
  Offset:=BitMapY*FillPattern^.Width;
  BitmapX:=x MOD FillPattern^.Width; If BitmapX<0 then BitmapX:=FillPattern^.Width+BitmapX;
  For bx:=0 to Width-1 Do Begin
    ScanlineData[bx]:=FillPattern^.Data[Offset+BitMapX];
    Inc (BitMapX); If BitMapX=FillPattern^.Width then BitMapX:=0;
  End;
End;

Procedure MGraphics.PushPoint (x, y : Integer);

Begin
  If Buffer.WordIndex<(StdBufferSize DIV 2) then Begin
    Buffer.Words[Buffer.WordIndex]:=x;
    Buffer.Words[Buffer.WordIndex+1]:=y;
    Inc (Buffer.WordIndex,2);
  End;
End;

Procedure MGraphics.PopPoint (Var x, y : Integer);

Begin
  If Buffer.WordIndex>1 then Begin
    x:=Buffer.Words[Buffer.WordIndex-2];
    y:=Buffer.Words[Buffer.WordIndex-1];
    Dec (Buffer.WordIndex,2);
  End
  Else Begin x:=-1; y:=-1; End;
End;

Constructor MGenericCard.Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);

Begin
  If Not Inherited Init (NewGraphicsMode) then Fail;
  Regs.AH:=$0F;
  Intr ($10,Regs);
  LastGraphicsMode:=Regs.AL;
  If LastGraphicsMode=NewGraphicsMode.Mode then
    If ClearMem then Clear Else
  Else Begin
    Regs.AH:=0;
    Regs.AL:=NewGraphicsMode.Mode;
    If Not ClearMem then Regs.AL:=Regs.AL Or 128;
    Intr ($10,Regs);
  End;
End;

Destructor MGenericCard.Done;

Begin
  Regs.AH:=$0F;
  Intr ($10,Regs);
  If LastGraphicsMode<>Regs.AL then Begin
    Regs.AH:=0;
    Regs.AL:=LastGraphicsMode;
    Intr ($10,Regs);
  End;
  Inherited Done;
End;

Procedure MGenericCard.SetScanline (Scanline, Index, Width : Integer; Var Data);

Var
  Bytes : Array [0..0] Of Byte ABSOLUTE Data;
  x, Offset : Integer;

Begin
  If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
  For x:=0 to Width-1 Do Begin
    Regs.AH:=$0C;
    Regs.AL:=Bytes[Offset+x];
    If (Graphics_Mode.Mode=$0F) And (Regs.AL And 2>0) then Regs.AL:=4 Or (Regs.AL And 1);
    Regs.BH:=0;
    Regs.CX:=Index+x;
    Regs.DX:=Scanline;
    Intr ($10,Regs);
  End;
End;

Procedure MGenericCard.GetScanline (Scanline, Index, Width : Integer; Var Data);

Var
  Bytes : Array [0..0] Of Byte ABSOLUTE Data;
  Offset, x : Integer;

Begin
  If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
  For x:=0 to Width-1 Do Begin
    Regs.AH:=$0D;
    Regs.BH:=0;
    Regs.CX:=Index+x;
    Regs.DX:=Scanline;
    Intr ($10,Regs);
    Bytes[Offset+x]:=Regs.AL;
    If Graphics_Mode.Mode=$0F then
      If Regs.AL And 4>0 then
        Bytes[x]:=2 Or (Regs.AL And 1)
      Else
        Bytes[x]:=Regs.AL And 1;
  End;
End;

Procedure MGenericCard.SetLogicPalEntry (Entry : Word; Color : RGB);

Begin
  Port [$03C8]:=Entry;
  Port [$03C9]:=Color.r;
  Port [$03C9]:=Color.g;
  Port [$03C9]:=Color.b;
End;

Procedure MGenericCard.GetLogicPalEntry (Entry : Word; Var Color : RGB);

Begin
  Port [$03C7]:=Entry;
  Color.r:=Port [$03C9];
  Color.g:=Port [$03C9];
  Color.b:=Port [$03C9];
End;

Constructor MVGACard.Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);

Begin
  If Not Inherited Init (NewGraphicsMode,ClearMem) then Fail;
End;

Destructor MVGACard.Done;

Begin
  Inherited Done;
End;

Procedure MVGACard.SetScanline (Scanline, Index, Width : Integer; Var Data);

Var
  Bytes : Array [0..0] Of Byte ABSOLUTE Data;
  Mask : Byte;
  Offset, x : Integer;
  Sg, Sto : Word;

Begin
  Case Graphics_Mode.Mode Of
    $11 : Begin
            If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
            Sto:=(Scanline*80)+(Index SHR 3);
            Mask:=128 SHR (Index And 7);
            For x:=0 to Width-1 Do Begin
              If Bytes[Offset+x]=1 then
                Mem [SegA000:Sto]:=Mem [SegA000:Sto] Or Mask
              Else
                Mem [SegA000:Sto]:=Mem [SegA000:Sto] And (Mask Xor 255);
              Mask:=Mask SHR 1;
              If Mask=0 then Begin Mask:=128; Inc (Sto); End;
            End;
          End;
    $0D,$0E,$10,$12 : Begin
            If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
            Port [$03CE]:=5; Port [$03CF]:=2;
            Port [$03CE]:=3; Port [$03CF]:=0;
            Mask:=128 SHR (Index And 7);
            Sto:=(Graphics_Mode.Width SHR 3)*Scanline+(Index SHR 3);
            Port [$03CE]:=8;
            For x:=0 to Width-1 Do Begin
              Port [$03CF]:=Mask;
              Mem [SegA000:Sto]:=(Mem [SegA000:Sto] And 0) Or Bytes[Offset+x];
              Mask:=Mask SHR 1;
              If Mask=0 then Begin Mask:=128; Inc (Sto); End;
            End;
          End;
    $13 : Begin
            If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
            Move (Bytes[Offset],Mem [SegA000:Scanline*320+Index],Width);
          End;
    Else
      Inherited SetScanline (Scanline,Index,Width,Data);
  End;
End;

Procedure MVGACard.GetScanline (Scanline, Index, Width : Integer; Var Data);

Var
  Bytes : Array [0..0] Of Byte ABSOLUTE Data;
  Mask, b, Bit : Byte;
  Offset, x : Integer;
  Sg, Sto : Word;

Begin
  Case Graphics_Mode.Mode Of
    $11 : Begin
            If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
            Sto:=(Scanline*80)+(Index SHR 3);
            Mask:=128 SHR (Index And 7);
            For x:=0 to Width-1 Do Begin
              If Mem [SegA000:Sto] And Mask>0 then Bytes[Offset+x]:=1 Else Bytes[Offset+x]:=0;
              Mask:=Mask SHR 1;
              If Mask=0 then Begin Mask:=128; Inc (Sto); End;
            End;
          End;
    $0D,$0E,$10,$12 : Begin
            If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
            b:=128 SHR (Index And 7);
            Sto:=(Graphics_Mode.Width SHR 3)*Scanline+(Index SHR 3);
            For x:=0 to Width-1 Do Begin
              Port [$03CE]:=8;
              Port [$03CF]:=b;
              Bytes[Offset+x]:=0;
              For Bit:=0 to 3 Do Begin
                Port [$03CE]:=4; Port [$03CF]:=Bit;
                If Mem [SegA000:Sto] And b>0 then Bytes[Offset+x]:=Bytes[Offset+x] Or 16;
                Bytes[Offset+x]:=Bytes[Offset+x] SHR 1;
              End;
              b:=b SHR 1;
              If b=0 then Begin b:=128; Inc (Sto); End;
            End;
          End;
    $13 : Begin
            If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
            Move (Mem [SegA000:Scanline*320+Index],Bytes[Offset],Width);
          End;
    Else
      Inherited GetScanline (Scanline,Index,Width,Data);
  End;
End;

Const
  ColorIndices2 : Array [0..1] Of Byte = (0,63);
  ColorIndices3 : Array [0..3] Of Byte = (0,8,24,1);
  ColorIndices4 : Array [0..3] Of Byte = (0,19,21,23);
  ColorIndices16 : Array [0..15] Of Byte = (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
  ColorIndices32 : Array [0..15] Of Byte = (0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23);

Procedure MVGACard.SetLogicPalEntry (Entry : Word; Color : RGB);

Begin
  Case Graphics_Mode.Mode Of
    $04,$06,$0D,$0E,$0F,$10,$11,$12 : Begin
      If Entry>=(1 SHL ColorDepth) then Exit;
      Case Graphics_Mode.Mode Of
        $04 : Inherited SetLogicPalEntry (ColorIndices4[Entry],Color);
        $06 : Inherited SetLogicPalEntry (ColorIndices2[Entry],Color);
        $0D : Inherited SetLogicPalEntry (ColorIndices32[Entry],Color);
        $0E : Inherited SetLogicPalEntry (ColorIndices32[Entry],Color);
        $0F : Inherited SetLogicPalEntry (ColorIndices3[Entry],Color);
        $10 : Inherited SetLogicPalEntry (ColorIndices16[Entry],Color);
        $11 : Inherited SetLogicPalEntry (ColorIndices2[Entry],Color);
        $12 : Inherited SetLogicPalEntry (ColorIndices16[Entry],Color);
      End;
    End;
    Else Begin
      Case Graphics_Mode.ColorDepth Of
        2 : Inherited SetLogicPalEntry (ColorIndices2[Entry],Color);
        4 : Inherited SetLogicPalEntry (ColorIndices16[Entry],Color);
        8 : Inherited SetLogicPalEntry (Entry,Color);
      End;
    End;
  End;
End;

Procedure MVGACard.GetLogicPalEntry (Entry : Word; Var Color : RGB);

Begin
  Case Graphics_Mode.Mode Of
    $04,$06,$0D,$0E,$0F,$10,$11,$12 : Begin
      If Entry>=(1 SHL ColorDepth) then Exit;
      Case Graphics_Mode.Mode Of
        $04 : Inherited GetLogicPalEntry (ColorIndices4[Entry],Color);
        $06 : Inherited GetLogicPalEntry (ColorIndices2[Entry],Color);
        $0D : Inherited GetLogicPalEntry (ColorIndices32[Entry],Color);
        $0E : Inherited GetLogicPalEntry (ColorIndices32[Entry],Color);
        $0F : Inherited GetLogicPalEntry (ColorIndices3[Entry],Color);
        $10 : Inherited GetLogicPalEntry (ColorIndices16[Entry],Color);
        $11 : Inherited GetLogicPalEntry (ColorIndices2[Entry],Color);
        $12 : Inherited GetLogicPalEntry (ColorIndices16[Entry],Color);
      End;
    End;
    Else Begin
      Case Graphics_Mode.ColorDepth Of
        2 : Inherited GetLogicPalEntry (ColorIndices2[Entry],Color);
        4 : Inherited GetLogicPalEntry (ColorIndices16[Entry],Color);
        8 : Inherited GetLogicPalEntry (Entry,Color);
      End;
    End;
  End;
End;

Procedure MSuperVGACard.SetScanline (Scanline, Index, Width : Integer; Var Data);

Var
  Bytes : Array [0..0] Of Byte ABSOLUTE Data;
  l : LongInt;
  Sto, h : Word;
  b : Byte;
  Offset : Integer;

Begin
  If Graphics_Mode.Mode<=$13 then  { Standard VGA mode }
    Inherited SetScanline (Scanline,Index,Width,Data)
  Else Begin                 { Supervga mode }
    If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
    Case Graphics_Mode.ColorDepth Of
      4 : Inherited SetScanline (Scanline, Index, Width, Data);
      8 : Begin
            l:=Scanline; l:=l*Graphics_Mode.Width+Index;
            b:=l DIV (Grain SHL 10);
            SetBank (b);
            Sto:=l MOD (Grain SHL 10);
            If Sto<(65536-Graphics_Mode.Width) then
              Move (Bytes[Offset],Mem [SegA000:Sto],Width)
            Else Begin
              h:=1+(Sto Xor 65535);
              If h>=Width then h:=Width;
              Move (Bytes[Offset],Mem [SegA000:Sto],h);
              SetBank (b+1);
              Move (Bytes[Offset+h],Mem [SegA000:0],Width-h);
            End;
          End;
    End;
  End;
End;

Procedure MSuperVGACard.GetScanline (Scanline, Index, Width : Integer; Var Data);

Var
  Bytes : Array [0..0] Of Byte ABSOLUTE Data;
  l : LongInt;
  Sto, h : Word;
  b : Byte;
  Offset : Integer;

Begin
  If Graphics_Mode.Mode<=$13 then
    Inherited GetScanline (Scanline,Index,Width,Data)
  Else Begin
    If Not CheckClip (Scanline,Index,Width,Offset) then Exit;
    Case Graphics_Mode.ColorDepth Of
      4 : Inherited GetScanline (Scanline, Index, Width, Data);
      8 : Begin
            l:=Scanline; l:=l*Graphics_Mode.Width+Index;
            b:=l DIV (Grain SHL 10);
            SetBank (b);
            Sto:=(l MOD (Grain SHL 10));
            If Sto<(65536-Graphics_Mode.Width) then
              Move (Mem [SegA000:Sto],Bytes[Offset],Width)
            Else Begin
              h:=1+(Sto Xor 65535);
              If h>=Width then h:=Width;
              Move (Mem [SegA000:Sto],Bytes[Offset],h);
              SetBank (b+1);
              Move (Mem [SegA000:0],Bytes[Offset+h],Width-h);
            End;
          End;
    End;
  End;
End;

Procedure MSuperVGACard.SetBank (Bank : Word);

Begin
  RunError (211);
End;

Function MSuperVGACard.GetBank : Word;

Begin
  RunError (211);
End;

Procedure MSuperVGACard.SetGranularity (Granularity : Word);
{ Set memorybank grain. Usually 64 Kb, but may differ! }
Begin
  Grain:=Granularity;
End;

Constructor MTsengET4000Card.Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);

Begin
  SetGranularity (64);  { ET4000 has a bank-granularity of 64 Kb }
  Inherited Init (NewGraphicsMode,ClearMem)
End;

Procedure MTsengET4000Card.SetBank (Bank : Word);

Begin
  Port [$03CD]:=Bank+(Bank SHL 4);
End;

Function MTsengET4000Card.GetBank : Word;

Begin
  GetBank:=Port [$03CD] And 15;
End;

{$IFNDEF DPMI}
Constructor MVesaCard.Init (NewGraphicsMode : GraphicsMode; ClearMem : Boolean);

Begin
  If NewGraphicsMode.Mode<$100 then   { Not a vesa mode, redirect to standard vgacard }
    Inherited Init (NewGraphicsMode,ClearMem)
  Else Begin
    MGraphics.Init (NewGraphicsMode);
    Regs.AX:=$4F03;
    Intr ($10,Regs);
    If VesaError then Exit;
    LastGraphicsMode:=Regs.BX;
    Regs.AX:=$4F01;
    Regs.CX:=NewGraphicsMode.Mode;
    Regs.ES:=Seg (VesaInfo);
    Regs.DI:=Ofs (VesaInfo);
    Intr ($10,Regs);
    If VesaError then Exit;
    Regs.AX:=$4F02;
    Regs.BX:=NewGraphicsMode.Mode;
    If Not ClearMem then Regs.BX:=Regs.BX Or 32768;
    Intr ($10,Regs);
    If VesaError then Exit;
    SetGranularity (VesaInfo.WinGrain);
  End;
End;

Destructor MVesaCard.Done;

Begin
  Regs.AX:=$4F02;
  Regs.BX:=LastGraphicsMode;
  Intr ($10,Regs);
End;

Procedure MVesaCard.SetBank (Bank : Word);

Begin
  Regs.AX:=$4F05;
  Regs.BH:=0;
  Regs.DX:=Bank;
  Regs.BL:=0;
  Intr ($10,Regs);
  Regs.AX:=$4F05;
  Regs.BH:=0;
  Regs.DX:=Bank;
  Regs.BL:=1;
  Intr ($10,Regs);
  VesaError;
End;

Function MVesaCard.GetBank : Word;

Begin
  Regs.AX:=$4F05;
  Regs.BH:=1;
  Regs.BL:=0;
  Intr ($10,Regs);
  GetBank:=Regs.DX;
  VesaError;
End;

Function MVesaCard.VesaError : Boolean;

Begin
  VesaError:=(Regs.AL<>$4F) Or (Regs.AH=1);
End;
{$ENDIF}
End.
