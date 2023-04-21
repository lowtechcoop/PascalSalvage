{ This example shows the XSirds function }

Program Example2;

Uses
	XVGA;

Var
	Index	: Word;
	X,Y		: Integer;

Begin
	XMode(TRUE);
	{ Switch to graphics mode }

	For X:=0 To 20 Do
		XRectangle(X*16,0,X*16+15,199,X,$A000);
	{ Draw a gradual slope from left to right }

	{ Draw some random "higher" areas }
	For Index:=0 To 10 Do Begin
		X:=Random(320);
		Y:=Random(200);
		{ Calculate a random coordinate }

		XRectangle(X,Y,X+27,Y+27,21,$A000);
		{ Draw the area in color 21, slightly higher than the slope }
	End;

	XSirds($A000,$A000,41,0,15);
	{ Calculate the sirds image }

	ReadLn;
	{ Wait for the user to press enter }

	XMode(FALSE);
	{ Switch back to text-mode }
End.
