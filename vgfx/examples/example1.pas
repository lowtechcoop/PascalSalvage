{ This example shows the usage of fake-screen drawing and the usage of
  the sin and cos lookup tables }

Program Example1;

Uses
	Crt,XVGA;
{ CRT is linked because of the KeyPressed function }

Var
	Angle	: Integer;
	Index	: Byte;

	DX,DY	: Integer;

	FakePtr	: Pointer;
	FakeSeg	: Word;
	{ Variables for the "fake" screen }

Begin
	XMode(TRUE);
	{ Switch to graphics mode }

	For Index:=0 To 63 Do
		XSetRGB(Index,Index,Index,Index);
	{ Set the first 64 colors to a gradual shade from black to white }

	Angle:=0;
	InitSinCos(10);
	{ Prepare the lookup tables with 1024 (2^10) sin and cos values }

	GetMem(FakePtr,64016);
	{ Allocate 64016 bytes for the "fake" screen. The reason for the
	  extra 16 bytes (320*200 = 64000) is that pascal may align the
	  memory block on the offsets 0 or 8. By allocating 16 extra bytes,
	  we can just skip the first segment (16 or 8 bytes) and use the
	  next 64000 bytes without problems }
	FakeSeg:=Seg(FakePtr^)+1;
	{ Create the segment reference }

	Repeat
		ClearFake(FakeSeg);
		{ Clear the "fake" screen }

		For Index:=0 To 63 Do Begin
			DX:=_S^[(Angle+Index) And TableMask] Div 3;
			DY:=_C^[(Angle+Index) And TableMask] Div 3;
			{ Calculate the end-point values of the lines }

			XLine(160+DX,100+DY,160-DX,100-DY,Index,FakeSeg);
			{ Draw the lines }
		End;

		VRet;
		{ Wait for vertical retrace }

		ShowFake(FakeSeg);
		{ Copy the "fake" screen to the visible screen }

		Angle:=(Angle+5) And TableMask;
		{ Adjust the angle, so as to rotate the lines }
	Until KeyPressed;
	{ Loop unti a key is pressed }

	XMode(FALSE);
	{ Switch back to text-mode }
End.
