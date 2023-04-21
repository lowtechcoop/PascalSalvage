{ This program shows the usage of the AsmRotate32, MovePoints32,
  AddPerspective32, QSort32 and the gourad-shading tetragon procedures,
  and using the XSirds to make real-time sirds animation. This
  is based on the EXAMPLE3.PAS file, and you should look at that file
  to see how the shape looks. }

Program Example5;

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
	Index		: Word;
	FaceIndex	: Word;
	AngleX		: Integer;
	AngleY		: Integer;
	AngleZ		: Integer;

	CPoints		: Array[1..High(Points)] Of TPoint32;
	{ Temporary storage for rotated points }
	FaceList	: Array[1..High(Faces)] Of TSortRec32;

	FakePtr		: Pointer;
	FakeSeg		: Word;
	SirdPtr		: Pointer;
	SirdSeg		: Word;
	{ Variables for the "fake" screen }

	X1,Y1,Z1	: Integer;
	X2,Y2,Z2	: Integer;
	X3,Y3,Z3	: Integer;
	C1,C2,C3	: Integer;

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
	GetMem(SirdPtr,64016);
	SirdSeg:=Seg(SirdPtr^)+1;
	{ Do the same for the sirds buffer }

	AngleX:=0;
	AngleY:=0;
	AngleZ:=0;
	InitSinCos(10);
	{ Prepare the lookup tables with 1024 (2^10) sin and cos values }

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
				C1:=14-(Z1 Div 4);
				C2:=14-(Z2 Div 4);
				C3:=14-(Z3 Div 4);
				{ Calculate the corner colors by using the depth-values (z) as
				  bases }

				XTetraGourad(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3,FakeSeg);
				{ Draw the gourad-shaded face }
			End;
		End;

		XSirds(FakeSeg,SirdSeg,57,0,63);
		{ Create the sirds image }

		VRet;
		{ Wait for vertical retrace }

		ShowFake(SirdSeg);
		{ Copy the "sird" screen to the visible screen }

		AngleX:=(AngleX+5) And TableMask;
		AngleY:=(AngleY+7) And TableMask;
		AngleZ:=(AngleZ+9) And TableMask;
		{ Adjust the angles, so as to rotate the object }
	Until KeyPressed;
	{ Loop until a key is pressed }

	XMode(FALSE);
	{ Switch back to text-mode }
End.
