{ This program shows the usage of the AsmRotate32, MovePoints32,
  AddPerspective32, QSort32 and the texture-mapping tetragon procedures }

Program Example3;

Uses
	Crt,XVGA;
{ CRT is linked because of the KeyPressed function }

Const
	Points		: Array[1..8] Of TPoint32 = (
		(-40, -40, -40),	{ Define a cube like this:		}
		( 40, -40, -40),	{     1--------2    <-- front	}
		( 40,  40, -40),	{     |\       |\	<-- back	}
		(-40,  40, -40),	{	  | 5------|-6 				}
		(-40, -40,  40),	{	  | |	   | |				}
		( 40, -40,  40),	{	  4--------3 |				}
		( 40,  40,  40),	{      \|       \|				}
		(-40,  40,  40)		{       8--------7				}
	);

	Faces		: Array[1..12] Of TPoint32 = (	{ Uses TPoint32 because
												  three values for faces }
		(1, 2, 3),
		(3, 4, 1),
		(6, 5, 8),
		(8, 7, 6),
		(1, 5, 6),
		(6, 2, 1),
		(2, 6, 7),
		(7, 3, 2),
		(3, 7, 8),
		(8, 4, 3),
		(4, 8, 5),
		(5, 1, 4)
	);
	{ Object definition, a cube }

Var
	Index			: Word;
	FaceIndex		: Word;
	AngleX			: Integer;
	AngleY			: Integer;
	AngleZ			: Integer;

	CPoints			: Array[1..High(Points)] Of TPoint32;
	{ Temporary storage for rotated points }
	FaceList		: Array[1..High(Faces)] Of TSortRec32;

	FakePtr			: Pointer;
	FakeSeg			: Word;
	{ Variables for the "fake" screen }

	X1,Y1,Z1		: Integer;
	X2,Y2,Z2		: Integer;
	X3,Y3,Z3		: Integer;
	C1,C2,C3		: Integer;

	TexturePtr		: Pointer;
	TexturePChar	: Pointer;
	TextureSeg		: Word;
	X,Y				: Word;
	{ Variables for the texture screen }

Begin
	XMode(TRUE);
	{ Switch to graphics mode }

	For Index:=0 To 63 Do
		XSetRGB(Index,Index,Index,Index);
	{ Set the first 64 colors to a gradual shade from black to white }

	GetMem(FakePtr,64016);
	{ Allocate 64016 bytes for the "fake" screen. The reason for the
	  extra 16 bytes (320*200 = 64000) is that pascal may align the
	  memory block on the offsets 0 or 8. By allocating 16 extra bytes,
	  we can just skip the first segment (16 or 8 bytes) and use the
	  next 64000 bytes without problems }
	FakeSeg:=Seg(FakePtr^)+1;
	{ Create the segment reference }

	GetMem(TexturePtr,64016);
	TextureSeg:=Seg(TexturePtr^)+1;
	TexturePChar:=Ptr(TextureSeg,0);
	{ Do the same for the texture screen }

	AngleX:=0;
	AngleY:=0;
	AngleZ:=0;
	InitSinCos(10);
	{ Prepare the lookup tables with 1024 (2^10) sin and cos values }

	For X:=0 To 319 Do
		For Y:=0 To 199 Do
			XPlot(X,Y,(X XOR Y) And $FF,TextureSeg);
	{ Draw a sample texture }

	Repeat
		ClearFake(FakeSeg);
		{ Clear the "fake" screen }

		AsmRotate32(Points,CPoints,High(Points),AngleX,AngleY,AngleZ);
		{ Rotate the object }
		AddPerspective32(CPoints,High(Points),8,200);
		{ Apply perspective }
		MovePoints32(CPoints,High(Points),160,100,0);
		{ Move object to center of screen }

		For Index:=1 To High(Faces) Do Begin
			FaceList[Index].ID:=Index;
			FaceList[Index].SortValue:=
				CPoints[Faces[Index,1],3]+
				CPoints[Faces[Index,2],3]+
				CPoints[Faces[Index,3],3];
			{ Calculate the center z-value of the face by adding all the
			  z-values of the corners of the face. To get the true
			  middle point, I would have to divide by 3, but if I scale all
			  values up by 3, I can drop the DIV 3 for all the faces and
			  speed up the calculations }
		End;

		QSort32(FaceList,High(Faces));
		{ Sort the faces depth-first }

		For Index:=1 To High(Faces) Do Begin
			FaceIndex:=FaceList[Index].ID;
			{ Get index of face to draw }

			X1:=CPoints[Faces[FaceIndex,1],1];
			Y1:=CPoints[Faces[FaceIndex,1],2];
			Z1:=CPoints[Faces[FaceIndex,1],3];
			{ Coordinates for first corner }

			X2:=CPoints[Faces[FaceIndex,2],1];
			Y2:=CPoints[Faces[FaceIndex,2],2];
			Z2:=CPoints[Faces[FaceIndex,2],3];
			{ Coordinates for second corner }

			X3:=CPoints[Faces[FaceIndex,3],1];
			Y3:=CPoints[Faces[FaceIndex,3],2];
			Z3:=CPoints[Faces[FaceIndex,3],3];
			{ Coordinates for third corner }

			If Visible(X1,Y1,X2,Y2,X3,Y3)>=0 Then Begin
			{ Determine if face is visible }
				If FaceIndex Mod 2=0 Then
					XTetraTexture320(X1,Y1,X2,Y2,X3,Y3,0,0,319,0,319,199,TexturePChar,FakeSeg)
				Else
					XTetraTexture320(X1,Y1,X2,Y2,X3,Y3,319,199,0,199,0,0,TexturePChar,FakeSeg)
				{ Draw the texture-mapped tetragon, using the FaceIndex
				  variable to determine if it is the upper-left or
				  lower-right part of the quadragon to draw }
			End;
		End;

		VRet;
		{ Wait for vertical retrace }

		ShowFake(FakeSeg);
		{ Copy the "fake" screen to the visible screen }

		AngleX:=(AngleX+5) And TableMask;
		AngleY:=(AngleY+7) And TableMask;
		AngleZ:=(AngleZ+9) And TableMask;
		{ Adjust the angles, so as to rotate the object }
	Until KeyPressed;
	{ Loop until a key is pressed }

	XMode(FALSE);
	{ Switch back to text-mode }
End.
