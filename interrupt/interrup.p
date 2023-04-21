Interrupt List, part 16 of 16
Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------*-7E---------------------------------
INT 7E - RESERVED FOR DIP, Ltd. ROM LIBRARY
--------S-7E---------------------------------
INT 7E U - YTERM 1.4 - ???
SeeAlso: INT 7D"YTERM",INT 7F"YTERM"
--------E-7E---------------------------------
INT 7E - DJGPP GO32.EXE DOS EXTENDER - RELOCATED IRQ6
Program: GO32.EXE is a DOS extender included as part of the 80386 port of the
	  GNU C/C++ compiler by DJ Delorie and distributed as DJGPP
Notes:	this vector is overwritten when GO32 starts but is not restored by
	  early versions of the extender
	the newest versions of GO32 dynamically allocate the vectors used
	  for the relocated IRQs, much as DESQview does (see INT 50"DESQview")
SeeAlso: INT 0E"IRQ6",INT 7D"GO32",INT 7F"GO32"
--------s-7E00-------------------------------
INT 7E - MaxSBOS v0.21 - GET ???
	AH = 00h
Return: DX:AX -> ???
SeeAlso: AH=01h,AH=02h,AH=03h
--------s-7E0001-----------------------------
INT 7E - IWSBSDRV v1.41 - SEND MIDI BYTE
	AX = 0001h
	DX = game device handle
	BL = MIDI byte to send???
	???
Return: EAX = status
	    00000000h if successful
	    FFFFFFFFh on error (function disabled)
Program: IWSBSDRV is the resident portion of the InterWave SBOS sound card
	  emulator for the Gravis UltraSound Plug-and-Play
Note:	this function is only supported if the MIDISIMPLE device has been
	  opened via the InterWave Game API (see INT 2F/AX=CD21h)
SeeAlso: AX=0002h,INT 2F/AX=CD21h,#2707
--------s-7E0002-----------------------------
INT 7E - IWSBSDRV v1.41 - SEND MIDI STRING
	AX = 0002h
	DX = game device handle
	ES:EDI -> buffer containing MIDI string to be sent
	ECX = length of buffer in bytes
Return: EAX = status
	    00000000h if successful
	    FFFFFFFFh on error (function disabled)
Note:	this function is only supported if the MIDISIMPLE device has been
	  opened via the InterWave Game API (see INT 2F/AX=CD21h)
SeeAlso: AX=0001h,INT 2F/AX=CD21h,#2707
--------s-7E00F6-----------------------------
INT 7E - SBOS v3.82 - SET ???
	AX = 00F6h
	BL = ??? (max. 20h, value will be set to 20h if BL greater)
Return: AX=00F9h,AX=00FEh
--------s-7E00F7-----------------------------
INT 7E - SBOS v3.82 - GET ???
	AX = 00F7h
Return: AX = status
	    0000h failed
	    0001h successful
		BX = ??? (if nonzero, ??? is hooked) (see AX=00FFh)
		CH = ???
		CL = ???
SeeAlso: AX=00F6h,AX=00FDh,AX=00FFh
--------s-7E00F9-----------------------------
INT 7E - SBOS v3.82 - SET ???
	AX = 00F9h
	BX = ???
SeeAlso: AX=00F6h,AX=00FBh,AX=00FDh
--------s-7E00FB-----------------------------
INT 7E - SBOS v3.82 - SET ???
	AX = 00FBh
	BL = ???
SeeAlso: AX=00F6h,AX=00FDh,AX=00FFh
--------s-7E00FD-----------------------------
INT 7E - SBOS v3.82 - SET ???
	AX = 00FDh
	BL = ??? (max. 20h, value will be set to 20h if BL greater)
SeeAlso: AX=00F9h,AX=00FEh
--------s-7E00FE-----------------------------
INT 7E - SBOS v3.82 - UNINSTALL
	AX = 00FEh
Return: AX = status
	    0000h successful
	    00FCh unable to unhook INT 21
	    00FDh unable to unhook INT 09
	    00FEh unable to release memory
Program: SBOS is a SoundBlaster emulator for the Gravis UltraSound
Range:	SBOS may use INT 78-INT 7F
Notes:	the installation check for SBOS is to test for the ASCII signature
	  "SBOS" at offset 0Ah in the interrupt handler's segment (similar
	  to one of the possible EMS installation checks)
	this function may not be called if any SBOS vectors have been hooked
SeeAlso: INT 21/AX=FD12h,INT 78"UltraMID"
--------s-7E00FF-----------------------------
INT 7E - SBOS v3.82 - SET INTERRUPT FOR ???
	AX = 00FFh
	BL = new interrupt vector to hook
Return: BX = 03CDh if supported
Desc:	unhooks the current interrupt handler for ???, and reconnects it to the
	  specified new interrupt number
SeeAlso: AX=00F7h,AX=00F9h,AX=00FEh
--------s-7E01-------------------------------
INT 7E - MaxSBOS v0.21 - ???
	AH = 01h
	???
Return: ???
Program: MaxSBOS is a SoundBlaster FM synthesis emulator for the Gravis
	  UltraSound MAX
Range:	INT 78-INT 7F, selected by commandline parameter
Note:	the installation check is the same as for 'regular' SBOS (see AX=00FEh)
	  although the API in v0.21 does not provide the functions present in
	  the older SBOS
SeeAlso: AX=00FEh,AH=02h,AH=03h
--------s-7E02-------------------------------
INT 7E - MaxSBOS v0.21 - ???
	AH = 02h
Return: AX = FFFFh
SeeAlso: AX=00FEh,AH=01h,AH=03h
--------s-7E03-------------------------------
INT 7E - MaxSBOS v0.21 - NOP
	AH = 03h
Return: nothing
SeeAlso: AX=00FEh,AH=01h,AH=02h
--------m-7E5857BL57-------------------------
INT 7E - XLOAD - INSTALLATION CHECK
	AX = 5857h
	BL = 57h
Return: AX = 0000h if installed
Program: XLOAD is the LOADHIGH-equivalent from Helix Software's Netroom
SeeAlso: AX=5857h/BL=5Ah,AX=5857h/BL=5Bh
--------m-7E5857BL5A-------------------------
INT 7E - XLOAD - GET ???
	AX = 5857h
	BL = 5Ah
Return: AX = 0000h
	CX = ???
	DS:SI -> ???
SeeAlso: AX=5857h/BL=57h,AX=5857h/BL=5Bh
--------m-7E5857BL5B-------------------------
INT 7E - XLOAD - GET XLOAD MEMORY SIZE
	AX = 5857h
	BL = 5Bh
Return: AX = 0000h
	CX = segment of XLOAD TSR
	DX = size of memory block in which XLOAD TSR is located
SeeAlso: AX=5857h/BL=57h,AX=5857h/BL=5Ah
--------s-7E--80-----------------------------
INT 7E - IWSBSDRV v1.41 - GET ???
	AL = 80h
Return: DX:AX -> ???
SeeAlso: AL=81h,AL=82h,AL=83h,AL=84h,AL=85h,AL=86h,AL=87h
--------s-7E--81-----------------------------
INT 7E - IWSBSDRV v1.41 - ???
	AL = 81h
	???
Return: ???
SeeAlso: AL=80h,AL=82h,AL=83h,AL=84h,AL=85h,AL=86h,AL=87h
--------s-7E--82-----------------------------
INT 7E - IWSBSDRV v1.41 - GET ???
	AL = 82h
Return: AX = ??? (FFFFh)
SeeAlso: AL=80h,AL=81h,AL=83h,AL=84h,AL=85h,AL=86h,AL=87h
--------s-7E--83-----------------------------
INT 7E - IWSBSDRV v1.41 - ??? (CALLS VIWD.VXD)
	AL = 83h
	???
Return: ???
SeeAlso: AL=80h,AL=81h,AL=82h,AL=84h,AL=85h,AL=86h,AL=87h
SeeAlso: INT 2F/AX=1684h/BX=38DAh"VIWD"
--------s-7E--84-----------------------------
INT 7E - IWSBSDRV v1.41 - WAKE PROGRAM???
	AL = 84h
Return: AL = status
	    00h successful
	    else failed
SeeAlso: AL=80h,AL=81h,AL=82h,AL=83h,AL=85h,AL=86h,AL=87h
SeeAlso: INT 2F/AX=CD04h"InterWave"
--------s-7E--85-----------------------------
INT 7E - IWSBSDRV v1.41 - SET ??? FLAG
	AL = 85h
Return: nothing
SeeAlso: AL=80h,AL=81h,AL=82h,AL=83h,AL=84h,AL=86h,AL=87h
--------s-7E--86-----------------------------
INT 7E - IWSBSDRV v1.41 - HOOK INT 21
	AL = 86h
Return: AX,BX,DX,ES destroyed
SeeAlso: AL=80h,AL=81h,AL=82h,AL=83h,AL=84h,AL=85h,AL=87h
--------s-7E--87-----------------------------
INT 7E - IWSBSDRV v1.41 - RESTORE INT 21
	AL = 87h
Return: AX,DX destroyed
SeeAlso: AL=80h,AL=81h,AL=82h,AL=83h,AL=84h,AL=85h,AL=86h
--------V-7F---------------------------------
INT 7F - Halo88 - API
	BX = function number (see #3498)
	additional parameters on stack
Return: ???
Program: Halo88 is a suite of graphics routines
Note:	according to Stuart Kemp, the code appears to make no provisions for
	   chaining

(Table 3498)
Values for Halo88 API function:
 64h	arc
 65h	bar
 66h	box
 67h	circle
 68h	clr
 69h	default hatch style
 6Ah	default line style
 6Bh	delhcur
 6Ch	delln / deltcur
 6Dh	ellipse
 6Eh	fill
 6Fh	flood
 70h	flood2
 71h	init graphics
 72h	init hcur
 73h	init marker
 74h	init tcur
 75h	inqarc
 76h	inqbknd
 77h	inqclr
 78h	inqerr
 79h	inqgcur
 7Ah	inqhcur
 7Bh	inqmarker
 7Dh	inqtcur
 7Eh	inqtext
 7Fh	lnabs
 80h	lnrel
 81h	markerabs
 82h	markerrel
 83h	moveabs
 84h	movehcurabs
 85h	movehcurrel
 86h	moverel
 87h	movetcurabs
 88h	movetcurrel
 89h	movefrom
 8Ah	moveto
 8Bh	pie
 8Ch	polylnabs
 8Dh	polylnrel
 8Eh	ptabs
 8Fh	ptrel
 91h	setasp
 92h	set color
 93h	set font
 94h	set hatch	style
 95h	set line style
 97h	settext
 98h	set text color
 99h	btext
 9Ah	setseg
 9Bh	display
 9Ch	setscreen
 9Eh	close graphics
 9Fh	ftinit
 A0h	ftlocate
 A1h	ftext
 A5h	set viewport
 A6h	set window
 A7h	set world
 AAh	ftcolor
 ACh	initlp
 ADh	inqasp
 AEh	inqdev
 AFh	inqdisplay
 B0h	inqft
 B1h	inqftcolor
 B2h	inqinterlace
 B3h	inqlpa
 B4h	inqlpg
 B5h	inqmode
 B6h	inqscreen
 B7h	inqversion
 B8h	roam
 B9h	scroll
 BAh	setieee
 BBh	set interlace
 BCh	shift
 BDh	start graphics
 BEh	vpan
 CBh	gwrite
 CCh	gread
 CDh	setxor
 CEh	rbox
 CFh	rcir
 D0h	rlnabs
 D1h	rlnrel
 D2h	delbox
 D3h	delcir
 D5h	setseg2
 DCh	worldoff
 DDh	mapwtod
 DEh	mapdtow
 DFh	mapwton
 E0h	mapntow
 E1h	mapdton
 E2h	mapntod
 E3h	inqworld
 E4h	inqviewport
 E5h	set line width
 E6h	lnjoint
 E7h	set locator
 E8h	read locator
 E9h	setdev
 EBh	setstext
 ECh	setstclr
 EDh	setstang
 EEh	stext
 EFh	inqstext
 F0h	setdegree
 F1h	inqstsize
 F2h	polyfabs
 F3h	polyfrel
 F4h	inqdrange
 F5h	inqstang
 F6h	orglocator
 F7h	inqlocator
 F8h	inqarea
 F9h	setipal
 FAh	setborder
 FBh	inqcrange
 FEh	setclip
 FFh	fcir
100h	setcrange
101h	setdrange
102h	setlattr
103h	polycabs
104h	polycrel
108h	memcom
109h	memexp
10Ah	memmov
10Eh	movefx
10Fh	movetx
110h	inqrgb
111h	save image
112h	restore image
113h	setapal
114h	setxpal
118h	inqtsize
12Eh	gprint
130h	setprn
131h	setpattr
133h	setbattr
135h	pexpand
136h	ptnorm
137h	pfnorm
13Bh	inqprn
13Ch	lopen
13Dh	lclose
13Eh	lappend
13Fh	lrecord
140h	lswitch
142h	inqfun
15Dh	lsetup
15Eh	lrest
15Fh	lsave
--------N-7F---------------------------------
INT 7F - CONVERGENT TECHNOLOGIES ClusterShare CTOS ACCESS VECTOR
	AL = request ID
	    01h "Request"/"RequestDirect"
		ES:BX -> pRq
		DX ignored
	    04h "Wait"
		ES:BX -> ppMsgRet
		DX = exchange
	    05h "AllocExch"
		ES:BX -> pExchRet
	    06h "DeAllocExch"
		DX = exchange
	    07h "Check"
		ES:BX -> ppMsgRet
		DX = exchange
	CX = 4354h ('CT')
Return: AX = status
	    0000h successful
--------S-7F---------------------------------
INT 7F - Telebit ACS SERIAL I/O
	ES:SI-> parameter block (see #3499)
Return: CF set on error
	CF clear on success
Notes:	the signature "PDGATEWRKSTNIF" appears just prior to the interrupt
	  handler; this serves as the installation check
Index:	installation check;Telebit ACS Serial I/O

Format of Telebit ACS parameter block:
Offset	Size	Description	(Table 3499)
 00h	BYTE	command (see #3500)
 01h	BYTE	gateway number
 02h	BYTE	reserved
 03h	BYTE	port
 04h 17 BYTEs	auxiliary buffer
 15h	BYTE	session
 16h	WORD	count of bytes passed to API
 18h	DWORD	buffer pointer passed to/from API
 1Ch	WORD	count of bytes passed from API
 1Eh	BYTE	return code (see #3501)

(Table 3500)
Values for Telebit ACS command:
 3Ch	status
 3Dh	connect
 3Eh	disconnect
 3Fh	read
 40h	data/command write
 41h	clear receive buffer
 42h	get configuration
 43h	get receiver status
 44h	raw write
 45h	search servers
 46h	set transmit buffer size

(Table 3501)
Values for Telebit ACS return code:
 00h	success
 01h	invalid session
 05h	servername invalid
 06h	NetWare fileserver bindery is locked
 07h	communication server not active
 08h	general failure in NetWare fileserver
 09h	not logged into a fileserver
 10h	connection table full
 11h	no response from communication server
 12h	connection attempt terminated abnormally
 13h	connection refused - no sessions available
 14h	gateway number/port already in use
 15h	invalid connection response
 16h	port invalid
 17h	incorrect version in server response
 18h	gateway number/port combination not configured
 19h	initialization has not been completed
 20h	no more sockets are available
 21h	no active poolname
 23h	FATAL internal interface error
 24h	registration of host workstation failed - name is already in use
 25h	registration of host workstation failed - workstation name table full
 26h	registration of host workstation failed - only one session may be
	  registered for dial-in
 FFh	Telebit ACS API is busy - retry later
--------N-7F---------------------------------
INT 7F - Non-dedicated NetWare 2.x File Server - ENTER CONSOLE MODE
Notes:	the installation check consists of checking for the signature "Lynn"
	  in the four bytes preceding the interrupt handler; if present, the
	  current program is running as a DOS task on a non-dedicated NetWare
	  2.x file server.
	Before placing the server into "console" mode, it is recommended that
	  NetWare broadcast messages be disabled with INT 21/AH=DEh/DL=00h.
SeeAlso: INT 21/AH=DEh/DL=04h
Index:	installation check;non-dedicated NetWare server
--------S-7F---------------------------------
INT 7F U - YTERM - ???
SeeAlso: INT 7E"YTERM"
--------E-7F---------------------------------
INT 7F - DJGPP GO32.EXE DOS EXTENDER - RELOCATED IRQ7
Notes:	this vector is overwritten when GO32 starts but is not restored by
	  early versions of the DOS extender
	the newest versions of GO32 dynamically allocate the vectors used
	  for the relocated IRQs, much as DESQview does (see INT 50"DESQview")
SeeAlso: INT 0F"IRQ7",INT 7E"GO32"
----------7F---------------------------------
INT 7F - Canon IXHND2 Scanner Interface
--------U-7F---------------------------------
INT 7F - SBS WinRun 1.00 - TRANSMITTER ENTRY POINT
	DS:SI -> WinRun control block (WCB) (see #3502)
Return: WinRun receiver status returned in WCB
Program: WinRun is a DOS/Windows utility written by Sven B. Schreiber to start
	  Windows applications from a virtual DOS machine under Windows
Note:	The WinRun transmitter (WINRUN-T.COM) and receiver (WINRUN-R.EXE) need
	  to be up and running

Format of the WinRun control block (WCB):
Offset	Size	Description	(Table 3502)
 00h	DWORD	pointer to ASCIZ command string
 04h	WORD	(ret) WinRun receiver status
		0000h-001Fh WinExec() error
		0020h-FFFEh WinExec() instance handle
		FFFFh	    Windows not running or WinRun receiver not
				  installed
--------N-7F---------------------------------
INT 7F - Alloy 386/MultiWare (MW386), Novell-Type Network Executive (NTNX)
Notes:	the words at C800h:0000h and C800h:0002h will both be 584Eh if the
	  MW386 multitasking system is present (i.e. signature "NXNX")
	NTNX allows its API to be placed on a different interrupt than 7Fh at
	  load time.  To determine the actual vector used, open the device
	  "SPOOLER" with INT 21/AX=3D02h, place it in RAW mode with
	  INT 21/AX=4400h and INT 21/AX=4401h, then read one byte which will
	  be the actual interrupt number being used; the other interrupts may
	  be found with INT 7F/AH=09h/CL=03h
--------N-7F---------------------------------
INT 7F - Alloy NetWare Support Kit (ANSK) v2.2+ - INSTALLATION CHECK
Note:	a program may determine that it is running on an ANSK Slave by checking
	  the five bytes at F000h:0000h for the ASCIZ signature "ANSK"; this
	  address is RAM, and should not be written.  However, the above check
	  will not work on Slaves with <1MB RAM or those using the SLIM.SYS
	  device driver
--------N-7F00-------------------------------
INT 7F - Alloy NTNX, MW386 - SEMAPHORE LOCK AND WAIT
	AH = 00h
	DS:DX -> ASCIZ semaphore name (max 64 bytes)
Return: AL = status (see #3503)
	AH = semaphore owner if status=02h
SeeAlso: AH=01h,AH=02h,AH=41h,INT 67/AH=00h

(Table 3503)
Values for Alloy function status:
 00h	successful
 01h	invalid function
 02h	semaphore already locked
 03h	unable to lock/unlock semaphore
 04h	semaphore space exhausted
 05h	host/target PC did not respond (NTNX)
--------T-7F00-------------------------------
INT 7F - MultiLink Advanced v1.0+ - ENQUEUE SYSTEM RESOURCE
	AH = 00h
	BX = resource identifier
	AL = wait flag
Return: AL = status
	    00h successful
	    01h resource not available
	    02h user error
Notes:	the installation check consists of ensuring that the interrupt vector
	  is not pointing at segment 0000h, then checking whether the byte
	  at offset 0000h in the interrupt handler's segment is E9h
	function will not return until the resource is available if AL is
	  nonzero on entry
	a maximum of 100 resources may be enqueued at once
SeeAlso: AH=01h"MultiLink"
--------N-7F00-------------------------------
INT 7F - G8BPQ v4.07+ - GET NODE/SWITCH VERSION AND DESCRIPTION
	AH = 00h
	ES:SI -> buffer for "USERS" text string
Return: AX = 4250h ('BP') if installed
	BX = 5120h ('Q ') if installed
	DX = version number (DH = major, DL = minor)
	CX = length of returned string
Program: the G8BPQ AX25 Networking Package is amateur packet radio software by
	  John Wiseman which allows a PC to act as a node in an AX.25 network
SeeAlso: AH=01h"G8BPQ",AH=09h"G8BPQ"
--------N-7F01-------------------------------
INT 7F - Alloy NTNX, MW386 - SEMAPHORE LOCK
	AH = 01h
	DS:DX -> ASCIZ semaphore name (max 64 bytes)
Return: AL = status (see #3503)
	AH = semaphore owner if status=02h
SeeAlso: AH=00h,AH=02h,AH=41h
--------T-7F01-------------------------------
INT 7F - MultiLink Advanced v1.0+ - DEQUEUE SYSTEM RESOURCE
	AH = 01h
	BX = resource identifier
Return: AL = status
	    00h successful
	    02h user error
Note:	the indicated resource may be dequeued even if it was enqueued by
	  another task
SeeAlso: AH=00h"MultiLink",AH=02h"MultiLink"
--------V-7F01-------------------------------
INT 7F - TIGA Communications Driver v2.05 - GET ENTRY POINTS
	AH = 01h
Return: BX = 1234h if installed
	    DX:AX -> array of FAR entry points
	    CH = driver major version
	    CL = driver minor version
Note:	TIGACD 2.05 returns CF set on unrecognized functions in AX
SeeAlso: AX=1234h,AX=4321h
--------N-7F01-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - SET APPLICATION FLAGS AND MASK
	AH = 01h
	AL = stream number (01h-40h)
	CL = new application flags
	    bit 7: monitored frames available via AH=0Bh"G8BPQ"
	DL = new application mask
Program: the G8BPQ AX25 Networking Package is amateur packet radio software by
	  John Wiseman which allows a PC to act as a node in an AX.25 network
Range:	INT 00h to INT FFh, set in configuration file BPQCFG.TXT for v4.03+
	  (earlier versions were hard-wired for INT 7F)
SeeAlso: AH=00h"G8BPQ",AH=02h"G8BPQ",AH=0Bh"G8BPQ"
--------I-7F0104BX0000-----------------------
INT 7F - HLLAPI (IBM 3270 High-Level Language API)/LLAPI (Rabbit Low Level API)
	AX = 0104h (HLLAPI gate ID)
	BX = 0000h
	DS:SI -> parameter control block (see #3504)
Return: parameter control block updated
Note:	the installation check for the Novell HLLAPI TSR is the signature
	  string "CXI" (for the company Novell bought) immediately prior to
	  the interrupt handler
SeeAlso: AX=0105h,AX=ABCDh

Format of HLLAPI parameter control block:
Offset	Size	Description	(Table 3504)
 00h  3 BYTEs	signature = 'PCB'
 03h	BYTE	function number (see #3505,#3506)
 04h	WORD	segment of control string
 06h	WORD	offset of control string
 08h	WORD	length of control string, unless explicit end-of-str char set
 0Ah	BYTE	unused (IBM)
		ControlString[0] (Rabbit)
 0Bh	WORD	return code (see #3508)
 0Dh	WORD	maximum length of control string (IBM)
		unused (Rabbit)

(Table 3505)
Values for HLLAPI function number:
 00h	OEM function (Query system for Attachmate implementation)
 01h	Connect presentation space
 02h	Disconnect presentation space
 03h	Send string of keystrokes as if typed from keyboard
 04h	Wait ~60s, returns status of presentation space
 05h	Copy current presentation space into a user-defined buffer
 06h	Search presentation space for first occurrence of a specified string
 07h	Query cursor location in current presentation space
 08h	Copy part or all of current presentation space into user buffer
 09h	Set session parameters; parameters vary by vendor (see #3507)
 0Ah	Get info on sessions currently connected
 0Bh	Lock current presentation space
 0Ch	Unlock previously locked presentation space
 0Dh	Return copy of operator info area (OIA) of current presentation space
 0Eh	get attribute byte for given position in the current presentation space
 0Fh	copy string of characters to the current presentation space
 10h	workstation control functions
 11h	storage manager functions, intended primarily for BASIC applications
	(not implemented by Rabbit)
 12h	set delay period in half-second intervals
 14h	get info on level of workstation support used
 15h	reset session parameters to default values
 16h	get detailed info on the current session
 17h	start host notification to application on presentation sp or OIA update
 18h	check host update when host notification enabled
 19h	stop host notification
 1Eh	search field within current presentation space for string
 1Fh	get first positionof a selected field in the current presentation space
 20h	get length of specified field
 21h	copy string into a specified field
 22h	copy specified field into a user-defined buffer
 23h	create alternate presentation space (IBM only), don't use with BASIC
 24h	switch to alternate presentation space (IBM only), not with BASIC
 25h	display cursor in specified area (IBM only), don't use with BASIC
 26h	display alternate presentation space (IBM only), don't use with BASIC
 27h	delete alternate presentation space (IBM only), don't use with BASIC
 28h	set cursor
 29h	start Close Intercept
 2Ah	query Close Intercept
 2Bh	stop Close Intercept
 32h	start intercepting keystrokes to allow filtering
 33h	get keystrokes after turning on interception
 34h	notify operator when keystroke rejected by filter subroutine
 35h	stop intercepting keystrokes
 5Ah	send file
 5Bh	receive file
 5Ch	run a program (not implemented by Rabbit)
 5Dh	execute DOS command (not implemented by Rabbit)
 63h	change presentation space position to PC display row/col or vice versa
 65h	connect to Window Services
 66h	disconnect from Window Services
 67h	set/query window coordinates
 68h	set/query window status
 69h	change presentation space name
 78h	connect Structured Fields
 79h	disconnect Structured Fields
 7Ah	query size of communications buffer
 7Bh	allocate communications buffer
 7Ch	free communications buffer
 7Dh	get request completion state
 7Eh	read Structured Fields
 7Fh	write Structured Fields
 FFh	Get info on DCA implementation

(Table 3506)
Values for LLAPI function number:
 80h	initialize LLAPI (internal call)
 83h	set Session ID (one-character ID)
 84h	read Session ID (one-character ID)
 85h	lock 327x keyboard
 86h	unlock 327x keyboard
 87h	wait for Clear to Send
 88h	type ASCII character
 89h	type 327x key
 8Ah	read keyboard lock state
 8Fh	force screen update
 90h	view session
 91h	relinquish (suspend foreground until background becomes idle)
 92h	poke screen character
 93h	poke translated character
 94h	peek screen character
 95h	peek translated character
 96h	set cursor position
 97h	send scan code (Rabbit only)
 98h	synchronize (returns after keystroke queue empty)
 99h	type PC key (Rabbit only)

(Table 3507)
Values for HLLAPI Function 09h Session Parameters:
 ASCII		??? (Rabbit only)
 ATTRIB		return attributes in hex
 NOATTRIB	return attributes as blanks
 CONPHYS	make physical connection
 CONLOG		only make logical connection
 EAB		copy extended attribute bytes along with data
 NOEAB		copy data only
 ESC=n		set escape character to "n" (default '@')
 EOT=n		set end of string character (default 00h)
 FPAUSE		full-duration pause
 FTNOWAIT	return immediately from functions 5Ah and 5Bh (Rabbit only)
 FTWAIT		wait for file transfer to complete (Rabbit only)
 IPAUSE		interruptable pause
 RABESC		??? (Rabbit only)
 NORABESC	??? (Rabbit only)
 SCANCODE	??? (Rabbit only)
 STRLEN		use explicit string lengths
 STREOT		use terminated strings
 SRCHALL	search entire presentation space
 SRCHFROM	search from specified offset
 SRCHFRWD	search forward from position 1
 SRCHBKWD	search backward from last position in presentation space
 TIMEOUT=n	??? (Rabbit only)
 TWAIT		wait specified time for keyboard ready
 LWAIT		wait until keyboard ready
 NWAIT		no wait
 TRON		enable tracing
 TROFF		disable tracing
 AUTORESET	send reset before sending keys with function 03h
 NORESET	don't send reset
 QUIET		don't display messages sent with INT 21/AH=09h
 NOQUIET	allow messages to be displayed
 TIMEOUT=n	set timeout in 30-second intervals, 0 = wait until ^Break
 XLATE		translate extended attribute bytes
 NOXLATE	don't translate
 NEWRET		use HLLAPI v3.0 return code conventions
 OLDRET		use HLLAPI v2.0 return code conventions

(Table 3508)
Values for Windows HLLAPI return code:
 00h	successful
 01h	Presentation Space not connected/requested size unavailable
 02h	invalid function or parameter error/invalid block ID
 03h	file transfer complete
 04h	file transfer complete (segmented)/Presentation Space busy
 05h	inhibited or keyboard locked
 06h	data truncated
 07h	invalid Presentation Space position
 08h	operation not available
 09h	system error
 0Ah	blocking error
 0Bh	resource not available
 0Ch	session stopped
 14h	undefined key combination
 15h	OIA updated
 16h	Presentation Space updated
 17h	both Presentation Space and OIA updated
 18h	no such field
 19h	no keystrokes available
 1Ah	Presentation Space or Operator Information Area changed
 1Bh	file transfer aborted
 1Ch	zero-length field
 1Eh	cursor type invalid
 1Fh	keystroke overflow
 20h	another application is already connected
 22h	message sent to host cancelled
 23h	transmission from host cancelled
 24h	lost contact with host
 25h	function successful
 26h	function incomplete
 27h	a DDM session is already connected
 28h	disconnected, but asynchronous requests still pending
 29h	buffer already in use
 2Ah	no matching request found
12Dh	invalid function number
12Eh	file not found
131h	access denied
134h	out of memory
136h	environment invalid
137h	format invalid
270Eh (9998) invalid Presentation Space ID
270Fh (9999) invalid row or column code
---Windows HLLAPI extensions---
F000h	asynchronous call already in progress
F001h	invalid asynchronous task ID
F002h	blocking call cancelled
F003h	underlying subsystem not started
F004h	unsupported application version
--------V-7F0105-----------------------------
INT 7F - IBM 8514/A Adapter Interface (HDILOAD.EXE)
	AX = 0105h
Return: CF set on error
	CF clear if successful
	    CX:DX -> array of FAR pointers to entry points (see #3509)
Note:	most functions are invoked by pushing the DWORD parameter block pointer
	  and then performing a FAR call via the appropriate vector of the
	  entry point array, placing the FAR address of the function's
	  parameter block on the top of the stack
SeeAlso: AX=0104h,AX=0106h,AX=ABCDh

(Table 3509)
Values for HDILOAD function number: (do FAR call via entry_points+4*function)
 08h	HOPEN	Open Adapter (see #3541)
 09h	HSMX	Set Mix (see #3570)
 10h	HINT	Interrupt (see #3537)
 13h	HLDPAL	Load Palette (see #3538)
 15h	HBBW	BitBLT Write Image Data (see #3524)
 17h	HBBR	BitBLT Read Image Data (see #3525)
 18h	HBBCHN	Chained Data Go (see #3523)
 19h	HBBC	BitBLT Copy Data (see #3522)
 1Dh	HQMODE	Get Current Mode (see #3547)
 20h	HRECT	Fill Rectangle (see #3549)
 22h	HCLOSE	Close Adapter and place in quiescent state (see #3530)
 30h	HINIT	Initialize State (see #3536)
 31h	HSYNC	Synchronize Adapter (see #3575)
 39h	HSPAL	Save Palette (see #3572)
 3Ah	HRPAL	Restore Palette (see #3552)
 ???	HSGQ	Set Graphics Quality (see #3561)
 ???	HSCOORD	Set Coordinate Type (see #3558)
 ???	HESC	Escape, Terminate Processing (see #3535)
 ???	HSBCOL	Set Background Color (see #3553)
 ???	HSBP	Set Bit Plane Controls (see #3554)
 ???	HSCMP	Set Color Comparison Register (see #3556)
 ???	HSCOL	Set Color (see #3557)
 ???	HSHS	Set Scissors (clipping rectangle) (see #3562)
 ???	HXLATE	Assign Text Color (see #3576)
 ???	HQMODES	Get Adapter Modes (see #3548)
 ???	HQDPS	Get Drawing Process State Size (see #3546)
 ???	HQDFPAL	Get Default Palette (see #3545)
 ???	HQCOORD	Get Coordinate Type (see #3543)
 ???	HQCP	Get Current Position (see #3544)
 ???	HSMODE	Change Mode (see #3568)
 ???	HLINE	Draw Line at Given Position (see #3539)
 ???	HCLINE	Draw Line at Current Position (see #3529)
 ???	HRLINE	Draw Line Relative from Given Position (see #3550)
 ???	HCRLINE	Draw Line Relative at Current Position (see #3532)
 ???	HSLT	Set Line Type (see #3565)
 ???	HSLW	Set Line Width (see #3567)
 ???	HSLPC	Save Line Pattern Count (see #3564)
 ???	HRLPC	Restore Line Pattern Count (see #3551)
 ???	HCBBW	BitBLT Write Image Data at Current Position (see #3526)
 ???	HBAR	Begin Area (see #3521)
 ???	HEAR	End Area (see #3533)
 ???	HSPATT	Set Pattern (see #3573)
 ???	HSPATTO	Set Pattern Reference Point (see #3574)
 ???	HEGS	Erase Graphics Screen (see #3534)
 ???	HSCP	Set Current Position (see #3559)
 ???	HMRK	Set Marker (see #3540)
 ???	HCMRK	Set Marker at Current Position (see #3531)
 ???	HSMARK	Set Marker Shape (see #3569)
 ???	HSCS	Set Character Set (see #3560)
 ???	HCHST	Write Character String at Given Position (see #3528)
 ???	HCCHST	Write Character String at Current Position (see #3527)
 ???	HSCELL	Set Cell Size for Alphanumeric Text (see #3555)
 ???	ABLOCKMFI Write Character/Attribute Block MFI (see #3512)
 ???	ABLOCKCGA Write Character Block CGA (see #3510)
 ???	AERASE	Erase Rectangle (see #3515)
 ???	ASCROLL Scroll Rectangle (see #3516)
 ???	ACURSOR	Set Alphanumerics Cursor Position (see #3514)
 ???	ASCUR	Set Alphanumeric Cursor Shape (see #3517)
 ???	ASFONT	Set Font (see #3518)
 ???	AXLATE	Assign Alphanumeric Color (see #3520)

Format of ABLOCKCGA parameter block:
Offset	Size	Description	(Table 3510)
 00h	WORD	000Ah (length of following data)
 02h	WORD	top-left coordinate of character block
 04h	WORD	width of block
 06h	DWORD	-> block of WORDs describing characters (see #3511)
 0Ah	BYTE	length of block in characters
 0Bh	BYTE	highlight attribute
		bit 4: transparent background
		bit 5: overstrike
		bit 6: reverse video
		bit 7: underscore
SeeAlso: #3512

Bitfields for one character in ABLOCKCGA character block:
Bit(s)	Description	(Table 3511)
 3-0	foreground attribute
 7-4	background attribute
 15-8	character code

Format of ABLOCKMFI parameter block:
Offset	Size	Description	(Table 3512)
 00h	WORD	0009h (length of following data)
 02h	WORD	top-left coordinate of character block
 04h	WORD	width of block
 06h	DWORD	-> block of DWORDs describing characters (see #3513)
 0Ah	BYTE	length of block in characters
SeeAlso: #3510

Bitfields for one character in ABLOCKMFI character block:
Bit(s)	Description	(Table 3513)
 7-0	reserved
 9-8	low two bits of font number
 12	transparent background
 13	overstrike
 14	reverse video
 15	underscore
 19-16	foreground color attribute
 23-20	background color attribute
 31-24	character code

Format of ACURSOR parameter block:
Offset	Size	Description	(Table 3514)
 00h	WORD	0002h (length of following data)
 02h	BYTE	column (0-based)
 03h	BYTE	row (0-based)
SeeAlso: #3517

Format of AERASE parameter block:
Offset	Size	Description	(Table 3515)
 00h	WORD	0005h (length of following data)
 02h	BYTE	left-most column (0-based)
 03h	BYTE	top-most row (0-based)
 04h	BYTE	rectangle's width in character cells
 05h	BYTE	rectangle's height in character cells
 06h	BYTE	background color (bits 7-4)
SeeAlso: #3516

Format of ASCROLL parameter block:
Offset	Size	Description	(Table 3516)
 00h	WORD	0006h (length of following data)
 02h	BYTE	left-most column (0-based) of source
 03h	BYTE	top-most row (0-based) of source
 04h	BYTE	rectangle's width in character cells
 05h	BYTE	rectangle's height in character cells
 06h	BYTE	left-most column (0-based) of destination
 07h	BYTE	top-most row (0-based) of destination
SeeAlso: #3515

Format of ASCUR parameter block:
Offset	Size	Description	(Table 3517)
 00h	WORD	0003h (length of following data)
 02h	BYTE	cursor start line (00h = top of cell, FFh = keep current shape)
 03h	BYTE	cursor stop line
 04h	BYTE	cursor attribute
		00h normal
		01h hidden
		02h left-arrow (requires start = 2 and stop = bottom of cell)
		03h right-arrow (requires start = 2 and stop = bottom of cell)
Notes:	no cursor is shown if the start line is greater than the stop line
	the alphanumeric cursor is hidden after each mode change
SeeAlso: #3514,INT 10/AH=01h

Format of ASFONT parameter block:
Offset	Size	Description	(Table 3518)
 00h	WORD	0005h (length of following data)
 02h	BYTE	font number (0-3)
 03h	DWORD	-> character set definition block (see #3519)

Format of 8514/A character set definition block:
Offset	Size	Description	(Table 3519)
 00h	BYTE	reserved
 01h	BYTE	type of character set
		00h bitmapped, 01h&02h reserved, 03h short-stroke font
 02h	BYTE	reserved
 03h	DWORD	reserved
 07h	BYTE	cell width in pixels
 08h	BYTE	cell height in pixels
 09h	BYTE	reserved
 0Ah	WORD	cell size in bytes
 0Ch	WORD	flags
		bit 15: reserved (0)
		bit 14: color bitmap
		bit 13: proportional spacing
 0Eh	DWORD	-> index table
 12h	DWORD	-> character width table
 16h	BYTE	initial code point
 17h	BYTE	final code point
 18h	DWORD	-> character definition table
 1Ch	WORD	reserved
 1Eh	DWORD	-> second character definition table
 22h	WORD	reserved
 24h	DWORD	-> third character definition table

Format of AXLATE parameter block:
Offset	Size	Description	(Table 3520)
 00h	WORD	0080h (length of following data)
 02h 64 BYTEs	character foreground translation table
 42h 64 BYTEs	character background translation table

Format of HBAR parameter block:
Offset	Size	Description	(Table 3521)
 00h	WORD	0000h (no data following)
SeeAlso: #3533

Format of HBBC parameter block:
Offset	Size	Description	(Table 3522)
 00h	WORD	0010h (length of following data)
 02h	WORD	data format
		0000h across-the-plane copy (color expansion)
		0008h through-the-plane copy
 04h	WORD	data rectangle's width
 06h	WORD	data rectangle's height
 08h	BYTE	source bit plane number (across-the-plane copies only)
 09h	BYTE	reserved
 0Ah  2 WORDs	X,Y coordinates of source's upper-left corner in display memory
 0Eh  2 WORDs	X,Y coordinates of destination's upper-left corner in
		  display memory
Note:	copies data from one location in video memory to another
SeeAlso: #3523

Format of HBBCHN parameter block:
Offset	Size	Description	(Table 3523)
 00h	WORD	0006h (length of following data)
 02h	DWORD	-> data buffer in system memory
 06h	WORD	number of bytes to transfer
Note:	this function performs the actual data transfer for a bitBLT set up
	  with HBBR, HBBW, or HCBBW
SeeAlso: #3522,#3524,#3525,#3526

Format of HBBR parameter block:
Offset	Size	Description	(Table 3524)
 00h	WORD	000Ch or 0014h (length of following data)
 02h	WORD	data format
		0000h across-the-plane copy (color expansion)
		0008h through-the-plane copy
 04h	WORD	data rectangle's width
 06h	WORD	data rectangle's height
 08h	BYTE	source bit plane number
 09h	BYTE	reserved
 0Ah  2 WORDs	X,Y coordinates of destination's upper-left corner in
		  display memory
---optional---
 0Eh	WORD	sub-rectangle left margin in pixels
 10h	WORD	sub-rectangle top margin in pixels
 12h	WORD	sub-rectangle width
 14h	WORD	sub-rectangle height
SeeAlso: #3523,#3524,#3526

Format of HBBW parameter block:
Offset	Size	Description	(Table 3525)
 00h	WORD	000Ah or 0012h (length of following data)
 02h	WORD	data format
		0000h across-the-plane copy (color expansion)
		0008h through-the-plane copy
 04h	WORD	data rectangle's width
 06h	WORD	data rectangle's height
 08h  2 WORDs	X,Y coordinates of destination in display memory
---optional---
 0Ch	WORD	sub-rectangle left margin in pixels
 0Eh	WORD	sub-rectangle top margin in pixels
 10h	WORD	sub-rectangle width
 12h	WORD	sub-rectangle height
SeeAlso: #3523,#3525,#3526

Format of HCBBW parameter block:
Offset	Size	Description	(Table 3526)
 00h	WORD	0006h or 000Eh (length of following data)
 02h	WORD	data format
		0000h across-the-plane copy (color expansion)
		0008h through-the-plane copy
 04h	WORD	data rectangle's width
 06h	WORD	data rectangle's height
---optional---
 08h	WORD	sub-rectangle left margin in pixels
 0Ah	WORD	sub-rectangle top margin in pixels
 0Ch	WORD	sub-rectangle width
 0Eh	WORD	sub-rectangle height
SeeAlso: #3523,#3524,#3525

Format of HCCHST parameter block:
Offset	Size	Description	(Table 3527)
 00h	WORD	length of following data
 02h  N BYTEs	ASCII string to display (length given by 'length' field above)
SeeAlso: #3528

Format of HCHST parameter block:
Offset	Size	Description	(Table 3528)
 00h	WORD	length of following data
 02h  2 WORDs	X,Y of left-bottom corner of string on screen
 06h  N BYTEs	ASCII string to display (length given by 'length' field above)
SeeAlso: #3527

Format of HCLINE parameter block:
Offset	Size	Description	(Table 3529)
 00h	WORD	length of following data (multiple of 4)
 02h 2N WORDs	X,Y coordinates for each of N points in polyline
Notes:	the first line segment is drawn beginning at the current position
	on completion, the current position is set to the last point drawn
SeeAlso: #3539,#3550,#3532

Format of HCLOSE parameter block:
Offset	Size	Description	(Table 3530)
 00h	WORD	0001h (length of following data)
 01h	BYTE	(ret) return code
SeeAlso: #3541

Format of HCMRK parameter block:
Offset	Size	Description	(Table 3531)
 00h	WORD	length of following data
 02h 2N WORDs	X,Y of N points
Note:	draws N+1 marker symbols, the first one at the current position
SeeAlso: #3540

Format of HCRLINE parameter block:
Offset	Size	Description	(Table 3532)
 00h	WORD	length of following data (multiple of 4)
 02h 2N WORDs	X,Y coordinates relative to the position of the previous point
		  (current position for first point) for each of N points in
		  polyline
Notes:	the first line segment is drawn beginning at the current position
	on completion, the current position is set to the last point drawn
SeeAlso: #3539,#3529,#3550

Format of HEAR parameter block:
Offset	Size	Description	(Table 3533)
 00h	WORD	0001h (length of following data)
 02h	BYTE	area definition flags
		bits 7-6: End Area type
			00 complete, perform fill
			01 suspend definition
			10 complete, but don't fill
SeeAlso: #3521

Format of HEGS parameter block:
Offset	Size	Description	(Table 3534)
 00h	WORD	0000h (no data following)

Format of HESC parameter block:
Offset	Size	Description	(Table 3535)
 00h	WORD	0000h (no data following)

Format of HINIT parameter block:
Offset	Size	Description	(Table 3536)
 00h	WORD	0002h (length of following data)
 02h	WORD	segment of task buffer
SeeAlso: #3575

Format of HINT parameter block:
Offset	Size	Description	(Table 3537)
 00h	WORD	0004h (length of following data)
 02h	DWORD	interrupt/event identifier
		bit 31: vertical blanking

Format of HLDPAL parameter block:
Offset	Size	Description	(Table 3538)
 00h	WORD	000Ah (length of following data)
 02h	BYTE	palette ID (00h = user, 01h = default)
 03h	BYTE	reserved
 04h	WORD	number of first palette entry
 06h	WORD	number of entries
 08h	DWORD	-> palette entries
SeeAlso: #3572

Format of HLINE parameter block:
Offset	Size	Description	(Table 3539)
 00h	WORD	length of following data (multiple of 4)
 02h 2N WORDs	X,Y coordinates for each of N points in polyline
Note:	on completion, the current position is set to the last point drawn
SeeAlso: #3529,#3550,#3532

Format of HMRK parameter block:
Offset	Size	Description	(Table 3540)
 00h	WORD	length of following data (multiple of 4)
 02h 2N WORDs	X,Y for N points
SeeAlso: #3531

Format of HOPEN parameter block:
Offset	Size	Description	(Table 3541)
 00h	WORD	0003h (length of following data)
 01h	BYTE	initialization flags
		bit 6: don't load default palette
		bit 7: clear bitplanes
 02h	BYTE	mode type (see #3542)
 03h	BYTE	(ret) return code
		bit 7: no adapter (hardware mismatch)
SeeAlso: #3530

(Table 3542)
Values for 8514/A display mode:
 0000h	12x20 characters, 1024x768
 0001h	8x14 characters, 640x480
 0002h	8x14 characters, 1024x768
 0003h	7x15 characters, 1024x768

Format of HQCOORD parameter block:
Offset	Size	Description	(Table 3543)
 00h	WORD	0004h (length of following data)
 02h	BYTE	(ret) coordinate format
		bits 7-4: bytes per coordinate
		bits 3-0: fraction bytes in coordinate
 03h	BYTE	(ret) relative coordinate format
		bits 7-4: bytes per coordinate
		bits 3-0: fraction bytes in coordinate
 04h	BYTE	(ret) number of dimensions (2-4)
 05h	BYTE	(ret) test results
		bit 7: coordinate format not supported
		bit 6: relative coordinate format not supported
		bit 5: specified dimension not supported

Format of HQCP parameter block:
Offset	Size	Description	(Table 3544)
 00h	WORD	0004h (length of following data)
 02h	WORD	(ret) current X position
 04h	WORD	(ret) current Y position

Format of HQDFPAL parameter block:
Offset	Size	Description	(Table 3545)
 00h	WORD	0040h (length of following data)
 02h 16	DWORDs	(ret) color index values
Note:	the default palette is set to match the default EGA/VGA 16-color
	  palettes

Format of HQDPS parameter block:
Offset	Size	Description	(Table 3546)
 00h	WORD	0006h (length of following data)
 02h	WORD	(ret) size of data buffer in bytes
 04h	WORD	(ret) stack size in bytes
 06h	WORD	(ret) size of palette save buffer in bytes

Format of HQMODE parameter block:
Offset	Size	Description	(Table 3547)
 00h	WORD	0012h (length of following data)
 02h	BYTE	current video mode (see #3542)
 03h	WORD	driver version
		bit 6: 80286/8086 CPU
		bit 5: 8 bit planes instead of 4 planes
		bits 4-0: hardware release number
 05h	BYTE	adapter type
		03h 8514/A
		04h XGA
 06h	BYTE	reserved (display type)
 07h	BYTE	character cell width
 08h	BYTE	character cell height
 09h	BYTE	number of bit planes
 0Ah	WORD	screen width (pixels)
 0Ch	WORD	screen height (pixels)
 0Eh	WORD	horizontal resolution (pixels/inch)
 10h	WORD	vertical resolution (pixels/inch)
 12h	BYTE	flag: 00h = monochrome, FFh = color
 13h	BYTE	intensity levels
SeeAlso: #3548

Format of HQMODES parameter block:
Offset	Size	Description	(Table 3548)
 00h	WORD	0021h (length of following data)
 02h	BYTE	(ret) adapter type
 03h 32 BYTEs	(ret) available display modes (FFh byte marks end of data)
SeeAlso: #3547

Format of HRECT parameter block:
Offset	Size	Description	(Table 3549)
 00h	WORD	0008h (legth of following data)
 02h  2 WORDs	X,Y coordinates of top left corner or rectangle
 06h	WORD	rectangle's width
 08h	WORD	rectangle's height
Note:	the rectangle is filled using the current pattern, color, and mix

Format of HRLINE parameter block:
Offset	Size	Description	(Table 3550)
 00h	WORD	length of following data (multiple of 4)
 02h  2 WORDs	X,Y coordinates of starting point
 06h 2N WORDs	X,Y coordinates relative to the position of the previous point
		  for each of N points in polyline
Note:	on completion, the current position is set to the last point drawn
SeeAlso: #3539,#3529,#3532

Format of HRLPC parameter block:
Offset	Size	Description	(Table 3551)
 00h	WORD	0000h (no data following)
Note:	used for continuity of lines crossing scissors boundaries
SeeAlso: #3564

Format of HRPAL parameter block:
Offset	Size	Description	(Table 3552)
 00h	WORD	0300h (length of following data)
 02h 768 BYTEs	buffer containing previously-saved palette table
SeeAlso: #3572

Format of HSBCOL parameter block:
Offset	Size	Description	(Table 3553)
 00h	WORD	0004h (length of following data)
 02h	DWORD	color index for new background color
SeeAlso: #3557

Format of HSBP parameter block:
Offset	Size	Description	(Table 3554)
 00h	WORD	000Ch (length of following data)
 02h	DWORD	bitmask for graphics updates
 06h	DWORD	bitmask for alphanumeric updates
 0Ah	DWORD	display bitmask

Format of HSCELL parameter block:
Offset	Size	Description	(Table 3555)
 00h

Format of HSCMP parameter block:
Offset	Size	Description	(Table 3556)
 00h	WORD	0005h (length of following data)
 02h	DWORD	comparison color
 06h	BYTE	logical operation
		00h True
		01h pel > testcolor
		02h pel == testcolor
		03h pel < testcolor
		04h False
		05h pel >= testcolor
		06h pel <> testcolor
		07h pel <= testcolor

Format of HSCOL parameter block:
Offset	Size	Description	(Table 3557)
 00h	WORD	0004h (length of following data)
 02h	DWORD	color index for new foreground color
SeeAlso: #3553

Format of HSCOORD parameter block:
Offset	Size	Description	(Table 3558)
 00h	WORD	0003h (length of following data)
 02h	BYTE	coordinate format
		bits 7-4: bytes per coordinate
		bits 3-0: fraction bytes in coordinate
 03h	BYTE	relative coordinates format
		bits 7-4: bytes per coordinate
		bits 3-0: fraction bytes in coordinate
 04h	BYTE	number of dimensions (2-4)

Format of HSCP parameter block:
Offset	Size	Description	(Table 3559)
 00h	WORD	0004h (length of following data)
 02h  2 WORDs	X,Y or coordinate for new current position

Format of HSCS parameter block:
Offset	Size	Description	(Table 3560)
 00h	WORD	0004h (length of following data)
 02h	DWORD	-> character set definition

Format of HSGQ parameter block:
Offset	Size	Description	(Table 3561)
 00h	WORD	0002h (length of following data)
 02h	WORD	quality settings (see #3563)

Format of HSHS parameter block:
Offset	Size	Description	(Table 3562)
 00h	WORD	0008h (length of following data)
 02h	WORD	left edge of clipping rectangle (-2048 to +6143)
 04h	WORD	right edge
 06h	WORD	top edge
 08h	WORD	bottom edget

Bitfields for 8514/A quality settings:
Bit(s)	Description	(Table 3563)
 15	reserved
 14	high precision
 13	reserved
 12-11	pel code
	00 not drawn
	01 drawn
	02 conditional on overpainting/mixes
 10	don't close areas to be filed
 9-0	reserved

Format of HSLPC parameter block:
Offset	Size	Description	(Table 3564)
 00h	WORD	0000h (no data following)
Note:	used for continuity of lines crossing scissors boundaries
SeeAlso: #3551

Format of HSLT parameter block:
Offset	Size	Description	(Table 3565)
 00h	WORD	0006h (length of following data)
 02h	BYTE	line type (see #3566)
 03h	BYTE	reserved
 04h	DWORD	-> user line-type definition (if user type)
SeeAlso: #3567

(Table 3566)
Values for 8514/A line type:
 00h	user line type
 01h	dotted
 02h	short dashes
 03h	dash-dot
 04h	double dotted
 05h	dashed
 06h	dash double dot
 07h	solid
 08h	invisible
SeeAlso: #3565

Format of HSLW parameter block:
Offset	Size	Description	(Table 3567)
 00h	WORD	0001h (length of following data)
 02h	BYTE	width of line in pixels
SeeAlso: #3565

Format of HSMODE parameter block:
Offset	Size	Description	(Table 3568)
 00h	WORD	0001h (length of following data)
 02h	BYTE	new display mode number (see #3542)

Format of HSMRK paramter block:
Offset	Size	Description	(Table 3569)
 00h	WORD	000Eh (length of following data)
 02h	BYTE	cell width
 03h	BYTE	cell height
 04h	BYTE	flags
 05h	BYTE	reserved
 06h	WORD	length of marker symbol
 08h	DWORD	-> image definition data
 0Ch	DWORD	-> color definition data
SeeAlso: #3573

Format of HSMX parameter block:
Offset	Size	Description	(Table 3570)
 00h	WORD	0002h (length of following data)
 02h	BYTE	foreground mix (see #3571)
 03h	BYTE	background mix (see #3571)

(Table 3571)
Values for 8514/A mix:
 00h	retain previous mix
 01h	source OR destination
 02h	source
 04h	source XOR destination
 05h	leave as-is
 06h	max(source,destination)
 07h	min(source,destination)
 08h	source+destination (clipped)
 09h	destination-source (clipped to zero)
 0Ah	source-destination (clipped to zero)
 0Bh	average source and destination
 10h	zero destination
 11h	source AND destination
 12h	source AND NOT destination
 13h	source
 14h	NOT source AND destination
 15h	leave as-is
 16h	source XOR destination
 17h	source OR destination
 18h	NOT source AND NOT destination
 19h	NOT (source XOR destination)
 1Ah	NOT destination
 1Bh	source OR NOT destination
 1Ch	NOT source
 1Dh	NOT source OR destination
 1Eh	NOT source OR NOT destination
 1Fh	set all bits of destination

Format of HSPAL parameter block:
Offset	Size	Description	(Table 3572)
 00h	WORD	0300h (length of following data)
 02h 768 BYTEs	buffer for palette table
SeeAlso: #3538,#3552

Format of HSPATT parameter block:
Offset	Size	Description	(Table 3573)
 00h	WORD	000Eh (length of following data)
 02h	BYTE	cell width
 03h	BYTE	cell height
 04h	BYTE	flags
 05h	BYTE	reserved
 06h	WORD	length of marker symbol
 08h	DWORD	-> image definition data
 0Ch	DWORD	-> color definition data
SeeAlso: #3569,#3574

Format of HSPATTO parameter block:
Offset	Size	Description	(Table 3574)
 00h	WORD	0004h (length of following data)
 02h  2 WORDs	X,Y of pattern reference point (origin)
SeeAlso: #3573

Format of HSYNC parameter block:
Offset	Size	Description	(Table 3575)
 00h	WORD	0002h (length of following data)
 02h	WORD	segment of task state buffer
SeeAlso: #3536

Format of HXLATE parameter block:
Offset	Size	Description	(Table 3576)
 00h	WORD	0020h (length of following data)
 02h 32 BYTEs	color index table
--------V-7F0105-----------------------------
INT 7F - IBM XGA Adapter Interface (XGAAIDOS.SYS)
	AX = 0105h
Return: CF set on error
	CF clear if successful
	    CX:DX -> array of FAR pointers to entry points (see #3509)
Note:	this API is a superset of the 8514/A Adapter Interface
	  (see AX=0105h"HDILOAD")
--------V-7F0106-----------------------------
INT 7F - HDILOAD Mach32 Adapter Interface - UNINSTALL
	AX = 0106h
Return: AX = 0105h if successfully unloaded
SeeAlso: AX=0105h
--------N-7F02-------------------------------
INT 7F - Alloy NTNX, MW386 - RELEASE SEMAPHORE
	AH = 02h
	DS:DX -> ASCIZ semaphore name (max 64 bytes)
Return: AL = status (see #3503)
	AH = semaphore owner if status=02h
SeeAlso: AH=00h,AH=01h,AH=42h
--------T-7F02-------------------------------
INT 7F - MultiLink Advanced v1.0+ - RELEASE CPU
	AH = 02h
Return: ???
Desc:	yields CPU to other tasks
SeeAlso: AH=00h"MultiLink",AH=09h"MultiLink",INT 15/AX=1000h
--------N-7F02-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - SEND FRAME
	AH = 02h
	AL = stream number (01h-40h)
	CX = length of frame
	ES:SI -> frame to be sent
SeeAlso: AH=00h"G8BPQ",AH=03h"G8BPQ",AH=07h"G8BPQ",AH=0Ah"G8BPQ"
--------f-7F0200-----------------------------
INT 7F - Btrieve Multi-User - GIVE UP TIME???
	AX = 0200h
SeeAlso: INT 2F/AX=AB01h,INT 2F/AX=AB02h,INT 7B"Btrieve"
--------N-7F03-------------------------------
INT 7F - Alloy ANSK, NTNX, MW386 - GET USER NUMBER
	AH = 03h
Return: AL = user number
	AH = machine number (MW386)
Note:	this function call is the recommended method for a CPU-bound process to
	  prevent its priority from being lowered
SeeAlso: AH=04h,AH=05h,AH=A1h
--------N-7F03-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - RECEIVE FRAME
	AH = 03h
	AL = stream number (01h-40h)
	ES:DI -> buffer for frame (must be large enough for a full frame; 350
		  bytes is usually sufficient)
Return: BX = number of pending frames (0000h if returned frame was last avail)
	CX = length of received frame
SeeAlso: AH=02h"G8BPQ",AH=07h"G8BPQ",AH=0Bh"G8BPQ"
--------N-7F04-------------------------------
INT 7F - Alloy NTNX, MW386 - GET NUMBER OF USERS
	AH = 04h
Return: AL = total number of users on currrent machine (MW386)
	AL = number of slaves on system (NTNX)
SeeAlso: AH=03h
--------N-7F04-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - GET STREAM STATUS
	AH = 04h
	AL = stream number (01h-40h)
Return: CX = state (0000h disconnected, 0001h connected)
	DX = delta state (0000h no change, 0001h changed since last check)
SeeAlso: AH=00h"G8BPQ",AH=02h"G8BPQ",AH=05h"G8BPQ"
--------N-7F05-------------------------------
INT 7F - Alloy NTNX (Host) - LOCK/UNLOCK SYSTEM, SPOOLER CONTROL
	AH = 05h
	AL = function
	    00h lock system (disable slave services)
	    01h unlock system
	    02h enable spooler
	    03h disable spooler
	    04h enable slave timer update
	    05h disable slave timer update
	    06h enable form feeds
	    07h disable form feeds
SeeAlso: INT 17/AH=A4h
--------N-7F05-------------------------------
INT 7F - Alloy NTNX (Slave), MW386 - GET USER PARAMETERS
	AH = 05h
	DX:DI -> buffer for user information record (see #3577)
Notes:	MW386 provides this function for backward compatibility only, and sets
	  many of the fields to zero because they are meaningless under MW386
	this function has no effect when called by the host (user 0)
SeeAlso: AH=03h

Format of Alloy user information record:
Offset	Size	Description	(Table 3577)
 00h	WORD	segment of video RAM
 02h	WORD	segment of secondary copy of video RAM
 04h	WORD	offset of screen update flag (see INT 10/AH=8Bh)
		flag nonzero if update needed
 06h	WORD	video NMI enable port
		(not used by MW386, set to 0000h)
 08h	WORD	video NMI disable port
		(not used by MW386, set to 0000h)
 0Ah	BYTE	processor type
		00h 8088
		01h V20
		02h 8086
		03h V30
		06h 80386
 0Bh	WORD	multitasking flag (00h = single tasking, 01h = multitasking)
		(not used by MW386, set to 0000h)
 0Dh	WORD	offset of terminal driver
		(not used by MW386, set to 0000h)
 0Fh	BYTE	port for console I/O
		(not used by MW386, set to 0000h)
 10h	WORD	offset of processor communication busy flag
		bit 7 set when slave communicating with host
 12h	WORD	pointer to FAR NX system call
		(not used by MW386, set to 0000h)
 14h	WORD	offset of 16-byte user configuration record (see AH=38h)
 16h	WORD	offset of command/status word
 18h	WORD	offset of screen valid flag (see INT 10/AH=93h)
		nonzero if screen must be repainted
 1Ah	WORD	offset of screen repaint flag
 1Ch	WORD	pointer to NEAR NX system call
		(not used by MW386, set to 0000h)
 1Eh	WORD	offset for intercept flags
		(not used by MW386, set to 0000h)
		intercept flag = FFh if MS-DOS intercepts should be disabled
 20h	WORD	offset of terminal lock flag (see INT 10/AH=92h)
		lock flag = FFh if backgrnd screen updates should be suspended
 22h 26 BYTEs	reserved
--------N-7F05-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - ACKNOWLEDGE STREAM STATUS CHANGE
	AH = 05h
	AL = stream number (01h-40h)
Note:	this function must be called in order to receive a report of another
	  status change
SeeAlso: AH=00h"G8BPQ",AH=04h"G8BPQ"
--------N-7F06-------------------------------
INT 7F - Alloy NTNX (Host) - GET SHARED DRIVE INFO
	AH = 06h
	AL = drive number (1=A:, 2=B:, etc)
	ES:DI -> drive info record (see #3578)
Return: AX = status
	    0000h successful
		ES:DI buffer filled
	    0001h not shared drive

Format of Alloy drive info record:
Offset	Size	Description	(Table 3578)
 00h	WORD	segment of drive IO-REQUEST structure (MS-DOS DPB)
 02h	WORD	segment of allocation map (owner table)
		one byte per FAT entry, containing user ID owning that entry
 04h	WORD	segment of master FAT for drive (copy of FAT on disk)
 06h	WORD	pointer to configuration file
 08h	WORD	total number of clusters
 0Ah	WORD	bytes per sector
 0Ch	WORD	sectors per cluster
 0Eh	BYTE	FAT type (0Ch = 12-bit, 10h = 16-bit)
--------N-7F06-------------------------------
INT 7F - Alloy NTNX (Slave) - ALLOCATE FREE CLUSTER ON SHARED DRIVE
	AH = 06h
	DL = drive number (1=A:,2=B:,etc)
	CX = number of clusters to allocate
Return: AH = status
	    00h successful
		CX = number of clusters still free
	    10h invalid shared drive request
		CL = first and second shared drives
	    11h invalid cluster count (must be 01h-FFh)
--------N-7F06-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - SESSION CONTROL
	AH = 06h
	AL = stream number (01h-40h)
	CX = subfunction
	    0000h connect to node
		DL bit 0: use BBS callsign instead of Node Call
	    0001h connect to node
		use BBS Call if APPLMASK=1
	    0002h disconnect
	    0003h return user to node
SeeAlso: AH=01h"G8BPQ",AH=04h"G8BPQ"
--------N-7F07-------------------------------
INT 7F - Alloy NTNX, MW386 - GET LIST OF SHARED DRIVES
	AH = 07h
Return: ES:DI -> shared drive list (see #3579)
Note:	MW386 considers all fixed disks to be shared drives; only C and D will
	  be returned as shared

Format of Alloy shared drive list:
Offset	Size	Description	(Table 3579)
 00h	BYTE	string length
 01h	BYTE	number of shared drives
 02h  N BYTEs	one byte per shared drive
--------N-7F07-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - GET BUFFER COUNTS FOR STREAM
	AH = 07h
	AL = stream number (01h-40h)
Return: BX = number of pending receive frames
	CX = number of unacknowledged sent frames
	DX = number of buffers available
SeeAlso: AH=02h"G8BPQ",AH=03h"G8BPQ"
--------N-7F08-------------------------------
INT 7F - Alloy NTNX (Host) - GET INTERRUPT VECTORS
	AH = 08h
	CL = function
	    00h get original interrupt vector
	    01h get Network Executive interrrupt
	AL = interrupt number
	DX:SI -> DWORD to hold interrupt vector
Return: AL = status
	    00h successful
	    01h interrupt vector not used by network executive
	    02h invalid subfunction
Note:	the network executive uses interrupts 02h,08h,09h,0Fh,10h,13h,16h-19h,
	  1Ch,20h,28h,2Ah,2Fh,5Bh,67h,7Fh,ECh, and F0h-FFh
SeeAlso: AH=09h/CL=03h,INT 21/AH=35h
--------N-7F08--CL02-------------------------
INT 7F - Alloy NTNX - SET MESSAGE DISPLAY TIMEOUT
	AH = 08h
	CL = 02h
	DX = timeout in seconds
Return: AL = status
	    00h successful
	    02h invalid subfunction
--------N-7F08-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - PORT CONTROL/INFORMATION
	AH = 08h
	AL = stream number (01h-40h)
Return: ES:DI -> 10-byte buffer containing blank-padded callsign
	---v4.05+ ---
	AL = radio port to which channel is connected (level 2)
	AH = session type (see #3580)
	BX = L2 paclen for session
	CX = maximum frame size
	DX = L4 window size or 0000h if not L4 circuit
Program: the G8BPQ AX25 Networking Package is amateur packet radio software by
	  John Wiseman which allows a PC to act as a node in an AX.25 network
SeeAlso: AH=01h"G8BPQ",AH=02h"G8BPQ",AH=03h"G8BPQ",AH=0Ah"G8BPQ"

Bitfields for G8BPQ session type:
Bit(s)	Description	(Table 3580)
 0	L2LINK
 1	SESSION
 2	UPLINK
 3	DOWNLIND
 5	BPQHOST
--------T-7F09-------------------------------
INT 7F - MultiLink Advanced v1.0+ - SET TASK PRIORITY
	AH = 09h
	AL = priority (0-7)
Note:	the installation check consists of ensuring that the interrupt vector
	  is not pointing at segment 0000h, then checking whether the byte
	  at offset 0000h in the interrupt handler's segment is E9h
Index:	installation check;MultiLink Advanced
SeeAlso: AH=00h"MultiLink",AH=0Ah"MultiLink"
--------N-7F09-------------------------------
INT 7F - G8BPQ - proposed addition - GET NODE/APPLICATION CALLSIGN AND ALIAS
	AH = 09h
	AL = application
	    00h node
	    01h BBS
	    02h HOST
	    03h SYSOP
	BL = what to get (00h callsign, 01h application name)
	ES:SI -> buffer for callsign/name string
Return: CX = length of returned string
SeeAlso: AH=00h"G8BPQ",AH=01h"G8BPQ",AH=0Ch"G8BPQ"
--------N-7F09-------------------------------
INT 7F - Alloy NTNX - ENABLE/DISABLE MUD FILE CHECKING
	AH = 09h
	CL = function
	    00h enable checking of RTNX.MUD file
	    01h disable RTNX.MUD checking
--------N-7F09--CL02-------------------------
INT 7F - Alloy NTNX - SWITCH HOST TO DEDICATED MODE
	AH = 09h
	CL = 02h
Note:	in dedicated mode, the host will only poll for I/O requests from the
	  slave processors, and not provide workstation services
--------N-7F09--CL03-------------------------
INT 7F - Alloy NTNX,MW386 - GET ALTERNATE INTERRUPT
	AH = 09h
	CL = 03h
	AL = default interrupt number (67h,7Fh,etc)
Return: CL = actual interrupt which handles specified interrupt's calls
SeeAlso: AH=08h
--------N-7F0A--CL00-------------------------
INT 7F - Alloy NTNX - GET SYSTEM FLAGS
	AH = 0Ah
	CL = 00h
	ES:DI -> buffer for system flags (see #3581)
Return: ES:DI buffer filled
Notes:	on a slave, only the NX_Busy flag is returned
	all three flags are at fixed positions, so this function only needs to
	  be called once
	an interrupt handler should only perform DOS or device accesses when
	  all three flags are 00h

Format of Alloy system flags:
Offset	Size	Description	(Table 3581)
 00h	DWORD	pointer to NX_Busy flag (nonzero when communicating with users)
 04h	DWORD	pointer to device driver busy flag
 08h	DWORD	pointer to InTimer flag
--------N-7F0A-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - TRANSMIT RAW (KISS) FRAME
	AH = 0Ah
	AL = radio port
	ES:SI -> buffer containing data to be sent
	CX = number of bytes to send
SeeAlso: AH=02h"G8BPQ",AH=08h"G8BPQ",AH=0Bh"G8BPQ"
--------T-7F0A-------------------------------
INT 7F - MultiLink Advanced v1.0+ - SET KEYBOARD TEST STATUS
	AH = 0Ah
	AL = task-switch status
	    00h normal (disable task when it repeatedly polls keyboard)
	    01h disable task until keyboard input available
	    FFh never disable task
Return: ???
SeeAlso: AH=09h"MultiLink"
--------N-7F0B--CL02-------------------------
INT 7F - Alloy NTNX (Host) - SET/RESET GRAPHICS DOS ON SLAVE
	AH = 0Bh
	CL = 02h
	AL = slave ID number
	CH = DOS to activate
	    00h graphics DOS
	    01h character DOS
Return: AL = status
	    00h successful
	    01h nothing done, proper DOS type already loaded
--------N-7F0B-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - RECEIVE TRACE (RAW DATA) FRAME
	AH = 0Bh
	ES:DI -> buffer for received data (see #3582)
Return: CX = number of bytes received
Note:	the specified buffer must be large enough to receive a full frame
SeeAlso: AH=03h"G8BPQ",AH=08h"G8BPQ",AH=0Ah"G8BPQ"

Format of G8BPQ received data:
Offset	Size	Description	(Table 3582)
 00h	WORD	internal control information
 02h	BYTE	port number (bit 7 set if transmitted frame)
 03h	WORD	frame length including this header
 05h	var	user data
--------N-7F0C-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - UPDATE SWITCH INFORMATION
	AH = 0Ch
	DX = function
	    0001h update beacon text
		CX = length of data
		ES:SI -> data to be sent in beacons
	    0002h (v4.07+) initiate NODES broadcast
SeeAlso: AH=09h"G8BPQ"
--------N-7F0D00-----------------------------
INT 7F - G8BPQ v4.07+ - HOST MODE - GET AVAILABLE STREAM
	AX = 0D00h
Return: AL = first available stream number, or FFh if none free
SeeAlso: AH=00h"G8BPQ",AH=0Dh
--------N-7F0D-------------------------------
INT 7F - G8BPQ v4.07+ - HOST MODE - ALLOCATE/DEALLOCATE STREAM
	AH = 0Dh
	AL = stream number (01h-FFh)
	CL = function
	    01h allocate stream
		Return: CX = status (0000h successful, else already in use)
	    02h deallocate stream
SeeAlso: AX=0D00h
--------N-7F0F-------------------------------
INT 7F - G8BPQ v4.00+ - HOST MODE - GET TIME MARKER
	AH = 0Fh
Return: AX = time marker (clock ticks modulo 64K)
Program: the G8BPQ AX25 Networking Package is amateur packet radio software by
	  John Wiseman which allows a PC to act as a node in an AX.25 network
SeeAlso: AH=01h"G8BPQ",AX=0D00h,INT 1A/AH=00h
--------N-7F10--CL00-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - OPEN CHANNEL
	AH = 10h
	CL = 00h
	AL = channel number
	DX:DI -> channel buffer
Return: AL = status (00h-03h,0Dh) (see #3583)
Note:	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=01h,AH=10h/CL=04h,AH=14h/CL=02h

(Table 3583)
Values for Alloy function status:
 00h	successful
 01h	busy
 02h	channel range error (not 00h-3Fh)
 03h	invalid subfunction
 0Ah	channel not open
 0Ch	channel already locked
 0Dh	unable to open
--------N-7F10--CL01-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - CLOSE CHANNEL
	AH = 10h
	CL = 01h
	AL = channel number
Return: AL = status (00h-03h,0Ah) (see #3583)
Note:	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=00h,AH=10h/CL=05h
--------N-7F10--CL02-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - LOCK CHANNEL
	AH = 10h
	CL = 02h
	AL = channel number
Return: AL = status (00h-03h,0Ah,0Ch) (see #3583)
Note:	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=03h,AH=10h/CL=06h,AH=10h/CL=08h
--------N-7F10--CL03-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - UNLOCK CHANNEL
	AH = 10h
	CL = 03h
	AL = channel number
Return: AL = status (00h-03h,0Ah) (see #3583)
Notes:	should only be used on channels locked with AH=10h/CL=02h, not on those
	  locked by receipt of a datagram
	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=02h,AH=10h/CL=04h,AH=10h/CL=09h
--------N-7F10--CL04-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - RELEASE BUFFER
	AH = 10h
	CL = 04h
	AL = channel number
Return: AL = status (00h-03h) (see #3583)
Notes:	unlocks buffer after received datagram has been processed
	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=00h
--------N-7F10--CL05-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - CLOSE ALL CHANNELS
	AH = 10h
	CL = 05h
Return: AL = status (00h-03h) (see #3583)
Notes:	clears all pending datagrams and clears buffer pointers before closing
	  the channels
	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=01h
--------N-7F10--CL06-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - LOCK ALL OPEN CHANNELS
	AH = 10h
	CL = 06h
Return: AL = status (00h-03h) (see #3583)
Note:	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=02h,AH=10h/CL=08h
--------N-7F10--CL07-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - UNLOCK ALL LOCKED IDLE CHANNELS
	AH = 10h
	CL = 07h
Return: AL = status (00h-03h) (see #3583)
Notes:	unlocks all locked channels which have no pending datagrams
	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=03h,AH=10h/CL=09h
--------N-7F10--CL08-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - LOCK MULTIPLE CHANNELS
	AH = 10h
	CL = 08h
	DX = maximum channel number to lock
Return: AL = status (00h-03h) (see #3583)
Notes:	locks channels numbered 00h through the value in DX
	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=02h,AH=10h/CL=06h,AH=10h/CL=09h
--------N-7F10--CL09-------------------------
INT 7F - Alloy NTNX, MW386 - CHANNEL CONTROL - UNLOCK MULTIPLE CHANNELS
	AH = 10h
	CL = 09h
	DX = maximum channel number to unlock
Return: AL = status (00h-03h) (see #3583)
Notes:	unlocks channels numbered 00h through the value in DX
	may not be invoked from within a hardware interrupt handler
SeeAlso: AH=10h/CL=03h,AH=10h/CL=07h,AH=10h/CL=08h
--------N-7F11-------------------------------
INT 7F - Alloy NTNX, MW386 - SEND DATAGRAM
	AH = 11h
	DX:SI -> request block (see #3585)
Return: AL = status (see #3584)
Note:	if wildcard channel FFh used, actual channel number will be filled in
SeeAlso: AH=12h

(Table 3584)
Values for Alloy function status:
 00h	successful
 01h	busy
 02h	channel range error (not 00h-3Fh)
 03h	invalid subfunction
 0Ah	packet too large (or <2 bytes if NTNX)
 0Bh	can't send packet to itself
 0Ch	invalid number of destinations
 0Dh	destination channel number out of range
 0Eh	destination user is busy
 0Fh	destination user has locked channel
 10h	channel not open
 11h	no datagram server on destination (NTNX)

Format of Alloy request block:
Offset	Size	Description	(Table 3585)
 00h	DWORD	pointer to packet to send
 04h	WORD	packet size in bytes (1-4096)
 06h	BYTE	number of destinations for packet (max 1Fh)
 07h 31 BYTEs	destination user IDs (FFh = broadcast to all except sender)
 26h 31 BYTEs	destination channels (FFh = first available channel)
 45h 31 BYTEs	return destination statuses
--------N-7F12-------------------------------
INT 7F - Alloy NTNX, MW386 - ACKNOWLEDGE DATAGRAM
	AH = 12h
	AL = channel number being acknowledged
	DI:DX = 32-bit status to return to sender
Return: AL = status (see #3586)
Note:	also unlocks the channel, allowing the next datagram to be received
SeeAlso: AH=11h,AH=15h/CL=04h

(Table 3586)
Values for Alloy function status:
 00h	successful
 01h	busy
 02h	channel range error (not 00h-3Fh)
 03h	invalid subfunction
 0Ah	channel not open
 0Bh	no message in channel
 0Ch	destination slave busy--retry (NTNX)
 0Dh	destination user not active
 0Eh	destination slave not active (NTNX)
 0Fh	destination disabled datagram service
--------V-7F1234-----------------------------
INT 7F - TIGA Communications Driver v2.05 - UNINSTALL
	AX = 1234h
SeeAlso: AX=4321h
--------N-7F13--CL00-------------------------
INT 7F - Alloy NTNX, MW386 - RESET USER DATAGRAMS
	AH = 13h
	CL = 00h
Note:	clears all pending datagrams and removes all channels opened in NTNX
	  compatibility mode
--------N-7F14--CL00-------------------------
INT 7F - Alloy NTNX, MW386 -  SET RECEIVE ISR
	AH = 14h
	CL = 00h
	DX:DI -> application FAR receive service routine (see #3587)
Return: AL = status (00h-03h) (see #3586)
SeeAlso: AH=14h/CL=01h,AH=14h/CL=03h

(Table 3587)
Values Alloy receive service routine is called with:
	DH = sender ID
	DL = channel with datagram
	interrupts disabled
Return: AL = response code
	    00h leave buffer locked, set channel status, and repeat call later
	    01h release channel buffer
	    02h change buffer pointer to DX:DI
	AH,CX,DX,DI,SI may be destroyed
--------N-7F14--CL01-------------------------
INT 7F - Alloy NTNX, MW386 - SET ACKNOWLEDGE ISR
	AH = 14h
	CL = 01h
	DX:DI -> application FAR acknowledge service routine (see #3588)
Return: AL = status (00h-03h) (see #3586)
Note:	the service routine will be called as soon as an acknowledgment arrives
SeeAlso: AH=12h,AH=14h/CL=00h,AH=14h/CL=04h,AH=15h/CL=04h

(Table 3588)
Values Alloy acknowledge service routine is called with:
	DS:SI -> acknowledge structure (see #3592)
Return: AL = response code
	    00h application busy, network executive should call again later
	    01h acknowledge accepted
	AH,DX,SI may be destroyed
--------N-7F14--CL02-------------------------
INT 7F - Alloy NTNX, MW386 - SET CHANNEL BUFFER POINTER
	AH = 14h
	CL = 02h
	AL = channel number
	DX:DI -> receive buffer
Return: AL = status (00h-03h) (see #3586)
Note:	may be called from within a receive ISR or when a datagram is pending
SeeAlso: AH=10h/CL=00h,AH=14h/CL=00h
--------N-7F14--CL03-------------------------
INT 7F - Alloy NTNX, MW386 - GET RECEIVE ISR
	AH = 14h
	CL = 03h
Return: DX:DI -> current receive ISR
SeeAlso: AH=14h/CL=00h,AH=14h/CL=04h
--------N-7F14--CL04-------------------------
INT 7F - Alloy NTNX, MW386 - GET ACKNOWLEDGE ISR
	AH = 14h
	CL = 04h
Return: DX:DI -> current acknowledge ISR
SeeAlso: AH=14h/CL=01h,AH=14h/CL=03h
--------N-7F14--CL05-------------------------
INT 7F - Alloy NTNX (Host), MW386 - GET BUSY POINTER
	AH = 14h
	CL = 05h
	DX:DI -> buffer for busy structure (see #3589)
Return: DX:DI buffer filled

Format of Alloy busy structure:
Offset	Size	Description	(Table 3589)
 00h	DWORD	pointer to busy flag byte
 04h	WORD	fixed port address (FF00h)
--------N-7F15--CL00-------------------------
INT 7F - Alloy NTNX, MW386 - GET CHANNEL STATUS
	AH = 15h
	CL = 00h
	AL = channel number
	DX:DI -> status structure (see #3590)
Return: AL = status (00h-03h) (see #3586)
SeeAlso: AH=15h/CL=01h

Format of Alloy channel status structure:
Offset	Size	Description	(Table 3590)
 00h	BYTE	channel status
		bit 0: channel open
		bit 1: channel buffer contains received data
		bit 7: channel locked
 01h	BYTE	sender ID
--------N-7F15--CL01-------------------------
INT 7F - Alloy NTNX, MW386 - GET NEXT FULL CHANNEL
	AH = 15h
	CL = 01h
	DX:DI -> full-channel structure (see #3591)
Return: AL = status
	    00h successful
	    01h busy
	    0Ah no datagrams available
Note:	MW386 v1.0 returns the lowest channel with a datagram; newer versions
	  and NTNX return the oldest datagram
SeeAlso: AH=15h/CL=00h

Format of Alloy full-channel structure:
Offset	Size	Description	(Table 3591)
 00h	BYTE	number of channel with oldest datagram
 01h	BYTE	sender ID
--------N-7F15--CL02-------------------------
INT 7F - Alloy NTNX, MW386 - GET MAXIMUM NUMBER OF CHANNELS
	AH = 15h
	CL = 02h
Return: AH = number of channels available (40h for MW386)
Note:	the application may always assume at least 32 channels available
SeeAlso: AH=15h/CL=03h
--------N-7F15--CL03-------------------------
INT 7F - Alloy NTNX, MW386 - GET MAXIMUM PACKET SIZE
	AH = 15h
	CL = 03h
	DX:DI -> WORD for return value
Return: buffer WORD filled with maximum packet size (4096 for MW386)
SeeAlso: AH=15h/CL=02h
--------N-7F15--CL04-------------------------
INT 7F - Alloy NTNX, MW386 - GET AND CLEAR ACKNOWLEDGE STATUS
	AH = 15h
	CL = 04h
	DX:DI -> status structure (see #3592)
Return: AL = status
	    00h successful
		DX:DI structure filled
	    01h busy
	    0Ah no acknowledgement has arrived
SeeAlso: AH=12h,AH=14h/CL=01h

Format of Alloy status structure:
Offset	Size	Description	(Table 3592)
 00h	BYTE	sender ID
 01h	BYTE	channel number
 02h  4 BYTEs	receiver status (see #3586)
--------N-7F16-------------------------------
INT 7F - Alloy NTNX, MW386 - DIRECT MEMORY TRANSFER
	AH = 16h
	DX:SI -> transfer structure (see #3593)
Return: AL = status
	    00h successful
	    0Ah source or destination out of range
	    0Bh transfer kernel busy--try again
Notes:	this call transfers memory contents directly between users; both source
	  and destination user IDs may differ from the caller's ID
	no segment wrap is allowed

Format of Alloy transfer structure:
Offset	Size	Description	(Table 3593)
 00h	WORD	bytes to transfer
 02h	BYTE	source ID
		FEh = caller
 03h	DWORD	source address
 07h	BYTE	destination ID
		FFh = all slaves except caller
		FEh = caller
 08h	DWORD	destination address
--------N-7F21-------------------------------
INT 7F - Alloy NTNX, MW386 - SEND MESSAGE OR COMMAND TO USER(S)
	AH = 21h
	AL = sender's user ID
	DS:DX -> control packet (see #3594)
Note:	messages or commands are ignored if disabled by the destination user
SeeAlso: AH=22h

Format of Alloy control packet:
Offset	Size	Description	(Table 3594)
 00h	BYTE	packet type
		00h message
		01h NTNX command
		02h MW386 command
 01h	BYTE	destination user ID or 'A' for all users
 02h 62 BYTEs	ASCIZ message (packet type 00h)
		BIOS keycodes terminated by NUL byte (type 01h) or word (02h)
Note:	a maximum of 16 keycodes will be processed for NTNX and MW386 commands
--------N-7F22-------------------------------
INT 7F - Alloy NTNX - GET MESSAGE
	AH = 22h
Return: pending messages displayed on user's screen
SeeAlso: AH=21h
--------N-7F24-------------------------------
INT 7F - Alloy NTNX, MW386 - ATTACH OR RELEASE DRIVE FOR LOW-LEVEL WRITE ACCESS
	AH = 24h
	CL = function
	    00h attach
	    01h release
	CH = drive (0=A:,1=B:,etc)
Return: AX = status (see #3595)
Note:	only drives on the current machine may be attached

(Table 3595)
Values for Alloy function status:
 00h	successful
 01h	invalid request
 02h	already attached
 03h	not attached
 04h	lock table full
--------N-7F24-------------------------------
INT 7F - Alloy NTNX - ATTACH/RELEASE HOST PROCESSOR
	AH = 24h
	CL = function
	    02h attach host
	    03h release host
Return: AX = status (see #3595)
Note:	the host processor may be attached in order to perform I/O via the host
--------N-7F25--CL00-------------------------
INT 7F - Alloy ANSK, NTNX, MW386 - GET NETWORK EXECUTIVE VERSION
	AH = 25h
	CL = 00h
Return: AH = version suffix letter
	CH = major version number
	CL = minor version number
SeeAlso: AH=25h/CL=01h
--------N-7F25--CL01-------------------------
INT 7F - Alloy ANSK, NTNX, MW386 - GET NETWORK EXECUTIVE TYPE
	AH = 25h
	CL = 01h
Return: CL = executive type (see #3596)
SeeAlso: AH=25h/CL=00h

(Table 3596)
Values for Alloy network executive type:
 00h	RTNX
 01h	ATNX
 02h	NTNX
 03h	BTNX
 04h	MW386
 05h	ANSK
--------V-7F2525-----------------------------
INT 7F - TIGA Communications Driver v2.05 - ???
	AX = 2525h
	BX = ???
Return: ???
SeeAlso: AX=4321h,AX=5555h
--------N-7F26--CL00-------------------------
INT 7F - Alloy NTNX, MW386 - GET NTNX FILE MODE
	AH = 26h
	CL = 00h
Return: AX = file mode bits (see #3597)
Note:	MW386 does not support file modes, and always returns AX=001Fh
SeeAlso: AH=26h,AH=26h/CL=06h

Bitfields for Alloy file mode bits:
Bit(s)	Description	(Table 3597)
 0	directory protection enabled
 1	extended open enabled
 2	flush on every disk write
 3	flush on every disk write in locked interval
 4	flush on reads from simultaneously opened file
--------N-7F26-------------------------------
INT 7F - Alloy NTNX - SET FILE I/O CHECKING LEVEL
	AH = 26h
	CL = check type to set/reset
	    01h directory protection
	    02h extended open
	    03h flush on every disk write
	    04h flush on disk write if any lock set during write
	    05h flush on all reads if file written
	AL = new state (00h off, 01h on)
SeeAlso: AH=26h/CL=00h,AH=26h/CL=06h
--------N-7F26--CL06-------------------------
INT 7F - Alloy NTNX - CANCEL FLUSH ON WRITE
	AH = 26h
	CL = 06h
Note:	cancels flags set by AH=26h/CL=03h and AH=26h/CL=04h
SeeAlso: AH=26h/CL=00h
--------N-7F30-------------------------------
INT 7F - Alloy MW386 - GET PORT INFORMATION
	AH = 30h
	CX = MW386 port number
Return: AL = result
	    FFh if port not found
	    else driver unit number
		BL = port mode
		BH = port type
		    02h remote
		DH = owner's machine ID
		DL = owner's user ID
SeeAlso: INT 17/AH=8Bh
--------N-7F31-------------------------------
INT 7F - Alloy MW386 v1.x only - CHECK PORT ASSIGNMENT
	AH = 31h
	???
Return: ???
--------N-7F37-------------------------------
INT 7F - Alloy NTNX (Host) - GET SEMAPHORE TABLE
	AH = 37h
Return: ES:AX -> semaphore table
--------N-7F37-------------------------------
INT 7F - Alloy ANSK, NTNX (Slave) - DUMP STRING TO TERMINAL
	AH = 37h
	DS:DX -> ASCIZ string to display
Note:	if the string is empty, a terminal update will be forced
--------N-7F38-------------------------------
INT 7F - Alloy NTNX (Slave), MW386 - SET NEW TERMINAL DRIVER
	AH = 38h
	AL = new terminal driver number
	    FFh dummy driver
	    FEh current driver
	    FDh load new driver
		DS:SI -> new driver
SeeAlso: AH=39h
--------N-7F39-------------------------------
INT 7F - Alloy MW386 - SET TERMINAL DRIVER FOR ANOTHER USER
	AH = 39h
	AL = new terminal driver number
	    FFh dummy driver
	    FEh current driver
	    FDh load new driver
		DS:SI -> new driver
	DL = user number (FFh = caller)
	DH = machine number if DL <> FFh
Return: CF set if invalid user number
	CF clear if successful
Notes:	only available to supervisors
	the new driver number will not take effect until the user is rebooted
SeeAlso: AH=38h
--------N-7F3A-------------------------------
INT 7F - Alloy MW386 - GET TERMINAL PARAMETERS
	AH = 3Ah
	DL = user number (FFh = caller)
	DH = machine number
Return: CF clear if successful
	    AH = terminal driver number
	    AL = baud rate (00h = 38400, 01h = 19200, etc)
	    CL = parity (00h none, 01h even, 02h odd)
	    CH = handshaking (00h none, 01h XON/XOFF, 02h DTR/DSR, 03h XPC)
	CF set if invalid user number
SeeAlso: AH=3Bh
--------N-7F3B-------------------------------
INT 7F - Alloy MW386 - SET TERMINAL PARAMETERS
	AH = 3Bh
	AL = baud rate (00h = 38400, 01h = 19200, etc)
	CL = parity (00h none, 01h even, 02h odd)
	CH = handshaking (00h none, 01h XON/XOFF, 02h DTR/DSR, 03h XPC)
	DL = user number (FFh = caller)
	DH = machine number for user
Return: CF set if invalid user number
Notes:	only available to supervisors
	the new parameters will take effect immediately if the user's terminal
	  has not been started, else AH=3Dh must be called to post the changes
SeeAlso: AH=3Ah,AH=3Dh
--------N-7F3C-------------------------------
INT 7F - Alloy MW386 - ENABLE/DISABLE AUTOBAUD DETECT
	AH = 3Ch
	AL = new state (00h disabled, 01h enabled)
	DL = user number (FFh = caller)
	DH = machine number for user
Return: CF set if invalid user number
Note:	only available to supervisors
SeeAlso: AH=3Dh
--------N-7F3D-------------------------------
INT 7F - Alloy MW386 - POST TERMINAL CONFIGURATION CHANGES
	AH = 3Dh
Note:	should be called whenever a program changes the terminal type or its
	  parameters
SeeAlso: AH=3Bh
--------N-7F41-------------------------------
INT 7F - Alloy NTNX - LOCK FILE FOR USER
	AH = 41h
	AL = user ID
	DS:DX -> ASCIZ filename
Return: AL = status (see #3598)
Note:	requests exclusive read/write access to file
SeeAlso: AH=00h,AH=41h"MW386",AH=42h"NTNX"

(Table 3598)
Values for Alloy function status:
 00h	successful
 01h	invalid function
 02h	already locked
 03h	unable to lock
 04h	lock table full or semaphore space exhausted
--------N-7F41-------------------------------
INT 7F - Alloy MW386 - LOCK SEMAPHORE FOR USER
	AH = 41h
	AL = user ID
	DS:DX -> ASCIZ semaphore name
Return: AL = status (see #3598)
SeeAlso: AH=00h,AH=42h"MW386"
--------s-7F4150BHC1-------------------------
INT 7F U - Voyetra - AAPISG - API
	AX = 4150h ('AP')
	BH = C1h
	BL = function (00h-13h)
	    00h initialize (fails except first time called)
	???
Return: AX = status???
	    0000h successful
	    0001h failed
Program: AAPISG is a driver by Voyetra for the Aztech Sound Galaxy sound board
BUG:	the function range check uses JL instead of JB, so it will cause a
	  crash if BL >= 80h on entry
SeeAlso: AX=4331h,AX=564Dh,AX=5658h
--------N-7F42-------------------------------
INT 7F - Alloy NTNX - UNLOCK FILE FOR USER
	AH = 42h
	AL = user ID
	DS:DX -> ASCIZ filename
Return: AL = status (see #3598)
SeeAlso: AH=00h,AH=41h"NTNX",AH=42h"MW386"
--------N-7F42-------------------------------
INT 7F - Alloy MW386 - UNLOCK SEMAPHORE FOR USER
	AH = 42h
	AL = user ID
	DS:DX -> ASCIZ semaphore name
Return: AL = status
	    00h successful
	    01h invalid function
	    03h unable to unlock semaphore
SeeAlso: AH=02h,AH=41h"MW386",AH=42h"NTNX"
--------V-7F4321-----------------------------
INT 7F - TIGA Communications Driver v2.05 - INSTALLATION CHECK
	AX = 4321h
Return: AX = 0000h if installed
Note:	INT 7F is the default, but may be overridden
SeeAlso: AH=01h"TIGA",AX=1234h,AX=2525h,AX=4321h,AX=5555h
--------s-7F4331BHC1-------------------------
INT 7F U - Voyetra - VAPISG - API
	AX = 4331h ('C1')
	BH = C1h
	BL = function (00h-7Ah)
	???
Return: ???
Program: VAPISG is a MIDI driver by Voyetra for the Aztech Sound Galaxy
	  sound board
SeeAlso: AX=4150h,AX=564Dh,AX=5658h
--------N-7F4E-------------------------------
INT 7F - Alloy MW386 v2+ - SET ERROR MODE
	AH = 4Eh
	AL = error mode flags
	    bit 0: display critical disk errors
	    bit 1: display sharing errors
	DX = 4E58h ("NX")
Return: AL = status
	    00h successful
SeeAlso: AH=4Fh
--------N-7F4F-------------------------------
INT 7F - Alloy MW386 v2+ - SET FCB MODE
	AH = 4Fh
	AL = FCB mode
	    02h read/write compatibility
	    42h read/write shared
	DX = 4E58h ("NX")
Return: AL = status
	    00h successful
--------V-7F5555-----------------------------
INT 7F - TIGA Communications Driver v2.05 - ???
	AX = 5555h
	BX = ???
Return: ???
SeeAlso: AX=4321h
--------s-7F564DBHC1-------------------------
INT 7F U - Voyetra Multimedia Player - VMP.EXE API
	AX = 564Dh ('VM')
	BH = C1h
	BL = function (00h-1Bh)
	    00h ???
		Return: CF clear
			AX = 0000h
	???
Return: AX = FFFFh if invalid function
	???
SeeAlso: AX=4331h,AX=5658h
--------s-7F5658BHC1-------------------------
INT 7F U - Voyetra - VAPISG - API
	AX = 5658h ('VX')
	BH = C1h
	BL = function (00h-1Bh)
	???
Return: ???
Program: VAPISG is a MIDI driver by Voyetra for the Aztech Sound Galaxy
	  sound board
SeeAlso: AX=4331h,AX=564Dh
--------N-7F81-------------------------------
INT 7F - Alloy NTNX - ATTACH DEVICE FOR USER
	AH = 81h
	AL = user ID
	DS:DX -> ASCIZ device name
SeeAlso: AH=82h
--------N-7F82-------------------------------
INT 7F - Alloy NTNX - RELEASE DEVICE FOR USER
	AH = 82h
	AL = user ID
	DS:DX -> ASCIZ device name
SeeAlso: AH=81h
--------N-7FA0-------------------------------
INT 7F - Alloy MW386 - GET USER NAME
	AH = A0h
	DL = user number (FFh = caller)
	DH = machine number for user
	ES:DI -> 17-byte buffer for ASCIZ user name
Return: CF set if invalid user number
SeeAlso: AH=03h,AH=A1h
--------N-7FA1-------------------------------
INT 7F - Alloy MW386 - GET MACHINE, USER, AND PROCESS NUMBER
	AH = A1h
Return: AL = process number
	DL = user number
	DH = machine number
SeeAlso: AH=03h,AH=A0h,AH=A2h
--------N-7FA2-------------------------------
INT 7F - Alloy MW386 - GET USER PRIVILEGE LEVEL
	AH = A2h
	DL = user number (FFh = caller)
	DH = machine number for user
Return: CF clear if successful
	    AL = privilege level
		00h supervisor
		01h high
		02h medium
		03h low
	CF set if invalid user number
SeeAlso: AH=A1h,AH=A3h
--------N-7FA3-------------------------------
INT 7F - Alloy MW386 - GET USER LOGIN STATE
	AH = A3h
	DL = user number
	DH = machine number for user
Return: CF clear if successful
	    AL = login state
		00h never logged in
		01h currently logged out
		03h currently logged in
	CF set if invalid user number or user not active
SeeAlso: AH=A2h
--------N-7FA4-------------------------------
INT 7F - Alloy MW386 - VERIFY USER PASSWORD
	AH = A4h
	DS:DX -> ASCIZ password (null-padded to 16 bytes)
Return: AL = status
	    00h	 accepted
	    else invalid password
--------N-7FA500-----------------------------
INT 7F - Alloy MW386 - GET USER STATUS
	AX = A500h
	DI = machine number and user number
Return: CF clear if successful
	    BX = user flags
		bit 5: allow messages
	    CL = scan code for task manager hotkey
	    CH = scan code for spooler hotkey
	    DL = scan code for task swapper hotkey
	    DH = modifier key status
	CF set if invalid user number
SeeAlso: AX=A501h
Index:	hotkeys;Alloy MW386
--------N-7FA501-----------------------------
INT 7F - Alloy MW386 - SET USER STATUS
	AX = A501h
	BX = user flags (see AX=A500h)
	CL = scan code for task manager hotkey
	CH = scan code for spooler hotkey
	DL = scan code for task swapper hotkey
	DH = modifier key status
	DI = machine number and user number
Return: CF set if invalid user number
Note:	must have supervisor privilege to set another user's status
SeeAlso: AX=A500h
Index:	hotkeys;Alloy MW386
--------V-7FABCDBX0000-----------------------
INT 7F - IBM 8516 Touch Screen Device Driver - GET API ENTRY
	AX = ABCDh
	BX = 0000h
Return: AX = total number of functions available
	ES:BX -> entry point array (see #3599)
SeeAlso: AX=0104h,AX=0105h

(Table 3599)
Values for 8516 Touch Screen function number:
 00h	check initialization and reset (see #3600)
 14h	set user-defined subroutine (see #3601)
Notes:	each driver function takes two stack parameters using Pascal calling
	  conventions: address of parameter block and address of results buffer
	all pointers are FAR pointers
	on return, AX contains the status of the call:
	    AX = 0000h successful
		 0001h invalid input
		 0002h interface error
		 0003h unable to perform function

Format of 8516 Touch Screen Function 00h parameter block:
Offset	Size	Description	(Table 3600)
 00h	WORD	0000h (function number)
Note:	this function should be called before any other device driver functions

Format of 8516 Touch Screen Function 00h results buffer:
Offset	Size	Description	(Table 3601)
 00h	WORD	touch screen status
		0000h unavailable
		0001h uncalibrated
		FFFFh available
 02h	WORD	aux mouse status (0000h not present, FFFFh present)
Notes:	the following driver parameters will have been reset to zero:
	  touchdown counter, liftoff counter, position at last touch, position
	  at last lift, int call mask, select on count, select off count,
	  pos select on count, pos select off count.
	the following driver parameters will have been reset as listed:
	  mouse emulation mode: left on
	  thresholds: 46 on screen, 96 push harder, 80 push release
	  x, y hysteresis: 400
	  data repeat rate: 40/sec
	  select mechanism: push-harder - first-touch
	  coordinate origin: upper left corner
	  filter frequency: medium
	  data block mask: all enabled
	  click lock: on
--------N-7FB0-------------------------------
INT 7F - Alloy NTNX, MW386 - RELEASE ALL SEMAPHORES FOR USER
	AH = B0h
	AL = user number
	DS = code segment
Note:	MW386 ignores AL and DS; it releases all semaphores locked using INT 67
	  or INT 7F locking functions
SeeAlso: AH=B1h,AH=B2h,AH=B3h,AH=B4h
--------N-7FB1--SF00-------------------------
INT 7F - Alloy NTNX, MW386 - RELEASE NORMAL SEMAPHORES FOR USER
	AH = B1h subfn 00h
	AL = (bits 7-5) 000
	     (bits 4-0) user ID
Note:	MW386 ignores AL; it releases all semaphores locked using INT 67 or
	  INT 7F locking functions
SeeAlso: AH=B0h,AH=B2h,AH=B3h,AH=B4h
--------N-7FB2--SF01-------------------------
INT 7F - Alloy NTNX - RELEASE MESSAGES FOR USER
	AH = B2h subfn 01h
	AL = (bits 7-5) 001
	     (bits 4-0) user ID
SeeAlso: AH=B0h,AH=B1h,AH=B3h,AH=B4h
--------N-7FB3--SF02-------------------------
INT 7F - Alloy NTNX - RELEASE FILES FOR USER
	AH = B3h subfn 02h
	AL = (bits 7-5) 010
	     (bits 4-0) user ID
SeeAlso: AH=B0h,AH=B1h,AH=B2h,AH=B4h
--------N-7FB4-------------------------------
INT 7F - Alloy NTNX - RELEASE DEVICES FOR USER
	AH = B4h
	AL = user ID
SeeAlso: AH=B0h,AH=B1h,AH=B2h,AH=B3h
--------N-7FC3-------------------------------
INT 7F - Alloy MW386 - WRITE BYTE TO TERMINAL AUX PORT
	AH = C3h
	AL = byte to write
Return: CF clear if successful
	CF set on error
SeeAlso: AH=C6h
--------N-7FC5-------------------------------
INT 7F - Alloy MW386 - CHANGE CONSOLE MODE
	AH = C5h
	AL = new console mode
	    00h keyboard indirect
	    01h keyboard direct
	    02h data handshake enforced
	    03h no data handshake
Return: CF clear if successful
	    AL = prior console mode
	CF set on error (caller is not remote user)
Note:	modes 2 and 3 may be used for input through the console port; no video
	  output should be performed in these modes
--------N-7FC6-------------------------------
INT 7F - Alloy MW386 - WRITE BYTE TO CONSOLE PORT
	AH = C6h
	AL = byte to write
Return: CF clear if successful
	CF set on error (caller is not remote user)
Note:	any terminal driver data translation will be bypassed
SeeAlso: AH=C3h,AH=C7h
--------N-7FC7-------------------------------
INT 7F - Alloy MW386 - READ CONSOLE DATA BYTE
	AH = C7h
Return: CF clear if successful
	    AL = byte read
	CF set on error (no data available or caller is not remote user)
Note:	used to read data after placing console in mode 2 or 3 (see AH=C5h)
SeeAlso: AH=C5h,AH=C6h,AH=C8h
--------N-7FC8-------------------------------
INT 7F - Alloy MW386 - READ CONSOLE DATA INTO BUFFER
	AH = C8h
	AL = maximum bytes to read
	ES:DI -> buffer for console data
Return: CF clear if successful
	    CX = number of bytes read
	CF set on error (caller is not remote user)
SeeAlso: AH=C7h
--------N-7FCF-------------------------------
INT 7F - Alloy NTNX - REBOOT USER PROCESSOR
	AH = CFh
	DS:DX -> ASCIZ string containing user number to be reset
SeeAlso: AH=D6h
--------N-7FD6-------------------------------
INT 7F - Alloy MW386 - RESET NETWORK EXECUTIVE
	AH = D6h
	DS:DX -> reset packet (see #3602)
Return: never if successful
Note:	all users will be shut down immediately if successful
SeeAlso: AH=CFh

Format of Alloy MW386 reset packet:
Offset	Size	Description	(Table 3602)
 00h	DWORD	reset code (60606060h)
 04h 16 BYTEs	ASCIZ supervisor password padded with nulls
--------N-7FD7-------------------------------
INT 7F - Alloy MW386 - POST EVENT
	AH = D7h
	AL = user number (if local event)
	DX = event number
--------N-7FD8-------------------------------
INT 7F - Alloy MW386 - FLUSH DISK BUFFERS
	AH = D8h
Return: CF set on error
Note:	forces all disk buffers to be written out immediately
SeeAlso: INT 21/AH=0Dh,INT 21/AX=5D01h,INT 2F/AX=1120h
--------N-7FDB-------------------------------
INT 7F - Alloy MW386 v2+ - GET MW386 INVOCATION DRIVE
	AH = DBh
Return: AL = drive from which MW386 was started (2=C:,3=D:,etc)
--------N-7FE0-------------------------------
INT 7F - Alloy MW386 - CREATE DOS TASK
	AH = E0h
	AL = memory size (00h=128K, 01h=256K, 02h=384K, 03h=512K, 04h=640K)
	DS:DX -> ASCIZ task name (max 16 bytes)
Return: CF clear if successful
	    AL = task create ID
	CF set on error
Note:	only foreground DOS tasks can use this function
SeeAlso: AH=E1h,AH=E2h,AH=E3h,AH=E6h,AH=E7h
--------N-7FE1-------------------------------
INT 7F - Alloy MW386 - GET DOS TASK PID FROM CREATE ID
	AH = E1h
	AL = create ID (from AH=E0h)
Return: AL = DOS process number
	CL = memory size (00h=128K, 01h=256K, 02h=384K, 03h=512K, 04h=640K)
Note:	this function should not be called immediately after creating a new
	  DOS task, since the new task is being initialized by a concurrent
	  process
SeeAlso: AH=E0h,AH=E2h
--------N-7FE2-------------------------------
INT 7F - Alloy MW386 - SWITCH TO NEW DOS TASK
	AH = E2h
	AL = DOS process number (from AH=E1h)
Return: CF set on error (invalid process number or caller not foreground task)
Notes:	specified task becomes the foreground task and current task is placed
	  in the background
	may only be called by a foreground task
SeeAlso: AH=E0h,AH=E1h
--------N-7FE3-------------------------------
INT 7F - Alloy MW386 - CHANGE NAME OF DOS TASK
	AH = E3h
	DS:DX -> ASCIZ task name
---v1.x---
	AL = user number
---v2+---
	BH = user number
	BL = task number
Return: CF clear if successful
	CF set on error (invalid process number)
SeeAlso: AH=E0h,AH=E4h,AH=E5h
--------N-7FE4-------------------------------
INT 7F - Alloy MW386 - GET TASK NAME FROM PROCESS NUMBER
	AH = E4h
	ES:DI -> buffer for task name
---v1.x---
	AL = user number
---v2+---
	BH = user number
	BL = task number
Return: CF clear if successful
	    CL = memory size (00h=128K, 01h=256K, 02h=384K, 03h=512K, 04h=640K)
	    DX = task flags
		bit 7: MS-DOS process
	    ES:DI buffer filled
	CF set on error (invalid process number)
SeeAlso: AH=E3h,AH=E5h
--------N-7FE5-------------------------------
INT 7F - Alloy MW386 - GET PROCESS NUMBER FROM TASK NAME
	AH = E5h
	DS:DX -> ASCIZ task name
	BH = user number
Return: CF clear if successful
	    AL = DOS process number
	    CL = memory size (00h=128K, 01h=256K, 02h=384K, 03h=512K, 04h=640K)
	CF set on error (no match for name)
SeeAlso: AH=E3h,AH=E4h
--------N-7FE6-------------------------------
INT 7F - Alloy MW386 - GET NUMBER OF AVAILABLE USER TASKS
	AH = E6h
Return: AX = number of processes available to current user
SeeAlso: AH=E0h
--------N-7FE7-------------------------------
INT 7F - Alloy MW386 - REMOVE DOS TASK
	AH = E7h
	AL = DOS process number
Return: CF clear if successful
	CF set on error (invalid process number or first process)
Note:	can only be called by a foreground task
SeeAlso: AH=E0h
--------N-7FE8-------------------------------
INT 7F - Alloy MW386 - DOS TASK DELAY
	AH = E8h
	CX = delay time in milliseconds
Note:	a delay of 0 may be used to surrender the current time slice
SeeAlso: INT 15/AX=1000h,INT 1A/AX=FF01h,INT 21/AH=EEh"DoubleDOS"
SeeAlso: INT 2F/AX=1680h
--------N-7FF0-------------------------------
INT 7F - Alloy MW386 - RESTRICT DIRECTORY TO GROUP
	AH = F0h
	AL = group number
	DS:DX -> ASCIZ directory name
Return: CF clear if successful
	    AX = status
		0002h directory not found
		0003h directory not found
		0005h directory in use, cannot be restricted
		02xxh restricted to group xxh
	CF set on error
Note:	the restriction on the directory may be removed by calling this
	  function with group 0, then using AH=F1h to assign the directory to
	  group 0
SeeAlso: AH=F1h,AH=F2h,AH=F3h
--------N-7FF1-------------------------------
INT 7F - Alloy MW386 - ASSIGN DIRECTORY TO GROUP
	AH = F1h
	AL = group number
	DS:DX -> ASCIZ directory name
Notes:	performs permanent assignment to a group; no immediate action is taken
	  unless the directory has been restricted with AH=F0h
	may be used to restrict a nonexistent directory
SeeAlso: AH=F0h
--------N-7FF2-------------------------------
INT 7F - Alloy MW386 - READ RESTRICTED DIRECTORY ENTRY
	AH = F2h
	CX = entry number
	ES:DI -> 64-byte buffer
Return: CF clear if successful
	    buffer filled with 63-byte directory info and 1-byte group number
	CF set on error (invalid entry)
SeeAlso: AH=F0h,AH=F3h
--------N-7FF3-------------------------------
INT 7F - Alloy MW386 - READ RESTRICTED DIRECTORY ENTRY FOR GROUP
	AH = F3h
	AL = group number
	CX = entry number
	ES:DI -> 64-byte buffer
Return: CF clear if successful
	    CX = next entry number
	    buffer filled with 63-byte directory info and 1-byte group number
	CF set on error (no more matching entries)
Note:	like AH=F2h, but only returns directories belonging to the specified
	  group
SeeAlso: AH=F2h
--------N-7FF8-------------------------------
INT 7F - Alloy MW386 - ASSIGN USER TO GROUP
	AH = F8h
	AL = group number
	DL = user number
	DH = machine number (currently 00h)
Return: CF clear if successful
	CF set on error (user already in maximum number of groups)
Note:	each user is allowed eight group assignments
SeeAlso: AH=F9h,AH=FAh
--------N-7FF9-------------------------------
INT 7F - Alloy MW386 - REMOVE USER FROM GROUP
	AH = F9h
	AL = group number
	DL = user number
	DH = machine number (currently 00h)
Return: CF clear if successful
	CF set if failed
SeeAlso: AH=F8h,AH=FAh
--------N-7FFA-------------------------------
INT 7F - Alloy MW386 - GET USER GROUP LIST
	AH = FAh
	DL = user number
	DH = machine number (currently 00h)
	ES:DI -> 16-byte buffer for group list
Return: CX = number of groups
	ES:DI buffer filled with group numbers
SeeAlso: AH=F8h,AH=F9h
--------N-7FFB-------------------------------
INT 7F - Alloy MW386 - ASSIGN GROUP NAME
	AH = FBh
	CL = group number
	ES:DI -> ASCIZ group name (max 17 bytes)
SeeAlso: AH=FCh
--------N-7FFC-------------------------------
INT 7F - Alloy MW386 - GET GROUP NAME
	AH = FCh
	CL = group number
	ES:DI -> 17-byte buffer for ASCIZ name
Return: ES:DI buffer filled
Note:	if the group has not been named, "(unnamed)" is returned
SeeAlso: AH=FBh
----------80---------------------------------
INT 80 - Q-PRO4 - ???
--------r-80---------------------------------
INT 80 - reserved for BASIC
Note:	this vector and INT 81 through INT ED are modified but not restored by
	  Direct Access v4.0, and may be left dangling by other programs
	  written with the same version of compiled BASIC
SeeAlso: INT 81"BASIC",INT 86"BASIC",INT EF"BASIC"
--------E-80---------------------------------
INT 80 - Phar Lap 386|DOS-Extender - RELOCATED PRINT-SCREEN
Note:	the extender relocates INT 05 to here by default, but can be told to
	  leave INT 05 alone with the commandline (or DOSX= environment
	  variable) flag -PRIVEC 5
SeeAlso: INT 05"PRINT SCREEN"
--------d-80---------------------------------
INT 80 - BusLogic BT-946C PCI SCSI Adapter - SCRATCHPAD RAM (NOT A VECTOR!)
Note:	the factory-default location for the eight bytes of scratchpad RAM
	  needed by the SCSI adapter is 0000h:0200h, which is interrupt
	  vectors 80h and 81h
SeeAlso: INT 81"BusLogic"
--------b-80---------------------------------
INT 80 U - AMI BIOS v1.00.12.AX1T - internal - BIOS SUBSYSTEM SELECTION
	AH = function
	    00h install and initialize BIOS subsystem
		AL = ??? (00h,01h,03h)
		CX:BX = subsystem ID (see #3603)
		ESI = address from which to load, or 00000000h for default for
			subsystem
		EDI = physical address at which to install, or 0 for default
		Note:	if CX=0000h on entry, this call is applied to all
			  subsystems whose ID has low word BX
	    01h get BIOS subsystem information
		CX:BX = subsystem ID (see #3603)
		Return: AL = ???
			AH = ???
			EDX = uncompressed size of subsystem in bytes
			SI = offset within subsystem of initialization
				routine, or FFFFh if none
			EDI = physical address of default location or 0
	    02h get matching subsystem identifier
		AL = index into subsystem list (return ALth occurrence
		      matching BX)
		BX = low word of subsystem identifier
			(0001h,0002h,0004h,0005h,000Bh,FFFFh)
		Return: CF clear if successful
			    CX = high word of ALth matching subsystem
			CF set on error
		Note:	the system is halted if AL=00h on entry
	    03h set up "big real" mode (4G segment limits)
	    04h turn off "big real" mode (restore 64K segment limits)
	    05h remove BIOS subsystem
		CX:BX = subsystem ID to leave out
		Note:	the system is halted if an invalid (not installed)
			  subsystem ID is specified
	    06h get installed subsystem info
		CX:BX = subsystem ID (see #3603)
		Return:	CF clear
			EDX = length of ???
			EDI = linear address of start of ???
		Note:	the system is halted if an invalid (not installed)
			  subsystem ID is specified
Return: CF clear if successful
	CF set on non-fatal error
Note:	this interrupt vector is cleared to 0000h:0000h near the end of the
	  BIOS startup sequence

(Table 3603)
Values for AMI BIOS subsystem ID:
 00010001h	ROM BIOS @F000-FFFF
 00010002h	setup??? (loaded @6000-68FF)
 00010005h	APM code
 0001000Bh	language-specific error message set (English)
 00020002h	PnP/PCI ACFG code (loaded @F000-F1FF)
 0001FFFFh
 0002FFFFh	recovery code
 00030004h
 0003FFFFh	BIOS decompression code
 0004000Bh
 00060004h
 0100FFFFh	ACFG data
 10000000h	ROM @C000 (64K)
 10000001h	HMA (48K)
 10000002h	RAM @7A00 (24K)
 10000003h	RAM @8000-BFFF
 10000004h
 10000005h	real-mode address space (0-1M)
 1000000Bh	installed language-specific message set???
--------s-80----BL00-------------------------
INT 80 - SBSIM - "STARTSND" - START SOUND ON SPECIFIED DRIVER
	BL = 00h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: AX = initialization result (see #3604)
Program: SBSIM is Creative Labs' SoundBlaster Simplified Interface Module,
	  which provides access to multiple drivers for the SoundBlaster
	  board through a single interface
Range:	INT 80h to INT BFh, selected automatically
Note:	the SBSIM installation check consists of testing for the signature
	  "SBSIM" at offset 103h in the interrupt handler's segment.
SeeAlso: INT 80/BL=01h"SBSIM",INT 80/BL=02h"SBSIM",INT 80/BL=03h"SBSIM"
SeeAlso: INT 80/BX=0000h"SBSIM"

(Table 3604)
Values for SBSIM error code:
 01h	busy--currently in use
 02h	bad driver specified
 03h	invalid function
 04h	voice process already active
 05h	couldn't start CT-VOICE
 06h	couldn't start CTVDSK
 07h	invalid SBSIM handle
 08h	buffer not initialized yet
 09h	bad filename
 0Ah	bad file handle
 0Bh	driver not started yet
 0Ch	XMS driver not installed
 0Dh	no free SBSIM handles
 0Eh	bad file type
 0Fh	couldn't free XMS block
 10h	invalid source selected
 11h	get pan position failed
 12h	set pan position failed
 13h	set volume failed
 14h	couldn't start fade/pan
 15h	couldn't stop fade/pan
 16h	couldn't pause fade/pan
 17h	not a fade/pan operation
 18h	bad mode for fade/pan
 19h	couldn't start fade/pan
 1Ah	source not fading/panning
 1Bh	FM or MIDI already playing
 1Ch	bad MIDI mapper format
--------s-80----BL01-------------------------
INT 80 - SBSIM - "PLAYSND" - PLAY MUSIC/VOICE ON SELECTED DRIVER
	BL = 01h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: AX = result (see #3604)
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=02h"SBSIM",INT 80/BL=04h"SBSIM"
--------s-80----BL02-------------------------
INT 80 - SBSIM - "STOPSND" - STOP MUSIC/VOICE ON SELECTED DRIVER
	BL = 02h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: nothing
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=01h"SBSIM",INT 80/BL=03h"SBSIM"
--------s-80----BL03-------------------------
INT 80 - SBSIM - "PAUSESND" - TEMPORARILY PAUSE PLAYBACK ON SELECTED DRIVER
	BL = 03h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: nothing
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=02h"SBSIM",INT 80/BL=04h"SBSIM"
SeeAlso: INT 80/BL=05h
--------s-80----BL04-------------------------
INT 80 - SBSIM - "RESUMESND" - RESTART PLAYBACK ON SELECTED DRIVER
	BL = 04h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: nothing
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=03h"SBSIM",INT 80/BL=05h"SBSIM"
--------s-80----BL05-------------------------
INT 80 - SBSIM - "GETSNDSTAT" - GET DRIVER'S STATUS
	BL = 05h
	BH = driver number (01h = FM, 02h=DDBV, 03h=memvoice, 05h=MIDI)
Return: AX = status
SeeAlso: INT 80/BL=00h"SBSIM",INT 80/BL=01h"SBSIM",INT 80/BL=03h"SBSIM"
--------s-80----BX0000-----------------------
INT 80 - SoundBlaster SBFM driver - GET VERSION
	BX = 0000h
Return: ???
Note:	SBFM installs at a free interrupt in the range 80h through BFh
SeeAlso: BX=0008h"SBFM",INT 2F/AX=FBFBh/ES=0000h
--------s-80----BX0000-----------------------
INT 80 - SBSIM - "QUERYVERSION" - GET VERSION
	BX = 0000h
Return: AX = version (AH = major, AL = minor)
Program: SBSIM is Creative Labs' SoundBlaster Simplified Interface Module,
	  which provides access to multiple drivers for the SoundBlaster
	  board through a single interface
Range:	INT 80h to INT BFh, selected automatically
Note:	the SBSIM installation check consists of testing for the signature
	  "SBSIM" at offset 103h in the interrupt handler's segment.
SeeAlso: BX=0001h"SBSIM",BX=0005h"SBSIM",INT 21/AX=4402h"CTMMSYS"
SeeAlso: INT 80/BL=00h"SBSIM"
Index:	installation check;SBSIM|installation check;SoundBlaster
--------s-80----BX0001-----------------------
INT 80 - SoundBlaster SBFM driver - SET MUSIC STATUS BYTE ADDRESS
	BX = 0001h
	DX:AX -> music status byte
SeeAlso: BX=0000h"SBFM",BX=0002h"SBFM",BX=0003h"SBFM"
--------s-80----BX0001-----------------------
INT 80 - SBSIM - "QUERYDRIVERS" - CHECK DRIVERS INSTALLED
	BX = 0001h
Return: AX = bit flags for loaded drivers (see #3605)
SeeAlso: BX=0000h"SBSIM",BX=0002h"SBSIM",BX=0005h"SBSIM",INT 80/BL=00h"SBSIM"

Bitfields for SBSIM loaded drivers:
Bit(s)	Description	(Table 3605)
 0	FM
 1	double disk-buffered voice driver (DDBV)
 2	memory voice driver
 3	auxiliary driver (mixer)
 4	MIDI
--------s-80----BX0002-----------------------
INT 80 - SoundBlaster SBFM driver - SET INSTRUMENT TABLE
	BX = 0002h
	CX = number of instruments
	DX:AX -> instrument table
SeeAlso: BX=0000h"SBFM",BX=0001h"SBFM",BX=0005h"SBFM"
--------s-80----BX0002-----------------------
INT 80 - SBSIM - GETADDRESS" - GET SELECTED DRIVER'S ENTRY POINT
	BX = 0002h
	AX = driver (00h = FM,01h = DDBV,02h = memvoice,03h = mixer,04h = MIDI)
Return: CF clear if successful
	    DX:AX -> entry point
	CF set on error
SeeAlso: BX=0000h"SBSIM",BX=0001h"SBSIM",BX=0005h"SBSIM",INT 80/BL=00h"SBSIM"
--------s-80----BX0003-----------------------
INT 80 - SoundBlaster SBFM driver - SET SYSTEM CLOCK RATE
	BX = 0003h
	AX = clock rate divisor (1193180 / desired frequency in Hertz)
	    FFFFh to restore to 18.2 Hz
SeeAlso: BX=0000h"SBFM",BX=0001h"SBFM",BX=0004h"SBFM"
--------s-80----BX0004-----------------------
INT 80 - SoundBlaster SBFM driver - SET DRIVER CLOCK RATE
	BX = 0004h
	AX = driver clock rate divisor (1193180 / frequency in Hertz)
Note:	default frequency is 96 Hz
SeeAlso: BX=0000h"SBFM",BX=0003h"SBFM"
--------s-80----BX0005-----------------------
INT 80 - SoundBlaster SBFM driver - TRANSPOSE MUSIC
	BX = 0005h
	AX = semi-tone offset
SeeAlso: BX=0000h"SBFM",BX=0002h"SBFM",BX=0006h"SBFM"
--------s-80----BX0005-----------------------
INT 80 - SBSIM - "GETBUFFERINFO" - GET DRIVER'S BUFFER ADDRESS
	BX = 0005h
	AX = driver (00h = FM, 01h = DDB Voice, 04h = MIDI)
Return: CF clear if successful
	    DX:AX -> buffer
	    CX = buffer size in K
	CF set on error
Program: SBSIM is Creative Labs' SoundBlaster Simplified Interface Module,
	  which provides access to multiple drivers for the SoundBlaster
	  board through a single interface
Range:	INT 80h to INT BFh, selected automatically
Note:	the SBSIM installation check consists of testing for the signature
	  "SBSIM" at offset 103h in the interrupt handler's segment.
SeeAlso: BX=0000h"SBSIM",BX=0001h"SBSIM",BX=0002h"SBSIM",INT 80/BL=00h"SBSIM"
--------s-80----BX0006-----------------------
INT 80 - SoundBlaster SBFM driver - PLAY MUSIC
	BX = 0006h
	DX:AX -> music block
Return: AX = status
	    0000h successful
	    0001h music already active
SeeAlso: BX=0000h"SBFM",BX=0007h"SBFM",BX=000Ah"SBFM",INT 1A/AX=FF04h
--------s-80----BX0007-----------------------
INT 80 - SoundBlaster SBFM driver - STOP MUSIC
	BX = 0007h
Return: AX = status
	    0000h successful
	    0001h music not active
SeeAlso: BX=0000h"SBFM",BX=0006h"SBFM",BX=0009h"SBFM",INT 1A/AX=FF05h
--------s-80----BX0008-----------------------
INT 80 - SoundBlaster SBFM driver - RESET DRIVER
	BX = 0008h
Return: AX = status
	    0000h successful
	    0001h music is active
SeeAlso: BX=0000h"SBFM"
--------s-80----BX0009-----------------------
INT 80 - SoundBlaster SBFM driver - PAUSE MUSIC
	BX = 0009h
Return: AX = status
	    0000h successful
	    0001h no music active
SeeAlso: BX=0000h"SBFM",BX=0007h"SBFM",BX=000Ah"SBFM",INT 1A/AX=FF01h
--------s-80----BX000A-----------------------
INT 80 - SoundBlaster SBFM driver - RESUME MUSIC
	BX = 000Ah
Return: AX = status
	    0000h successful
	    0001h no music paused
SeeAlso: BX=0000h"SBFM",BX=0006h"SBFM",BX=0009h"SBFM"
--------s-80----BX000B-----------------------
INT 80 - SoundBlaster SBFM driver - SET USER-DEF TRAP FOR SYSTEM-EXCLUSIVE CMDS
	BX = 000Bh
	DX:AX -> trap routine
SeeAlso: BX=0000h"SBFM"
--------s-80----BX0400-----------------------
INT 80 - SBSIM - "GETVOLUME" - GET SOURCE'S VOLUME
	BX = 0400h
	AX = sound source (see #3606)
Return: CF clear if successful
	    AX = volume
	CF set on error
	    AX = error code (see #3604 at INT 80/BL=00h)
SeeAlso: BX=0401h"SBSIM"

(Table 3606)
Values for SBSIM sound source:
 00h	master volume
 01h	voice
 02h	FM
 03h	CD
 04h	line in
 05h	microphone
--------s-80----BX0401-----------------------
INT 80 - SBSIM - "SETVOLUME" - SET SOURCE'S VOLUME
	BX = 0401h
	AX = sound source (see #3606)
	DX = new volume
Return: AX = result (0000h = success) (see also INT 80/BL=00h)
SeeAlso: BX=0400h"SBSIM"
--------N-8001-------------------------------
INT 80 - QPC Software PKTINT.COM - INITIALIZE
	AH = 01h
Return: AX = 0000h
	CX = FFFFh
	DX = FFFFh
Notes:	this interrupt is the WinQVTNet protected mode interface to Windows 3.0
	all buffer pointers are reset back to 0
--------N-8002-------------------------------
INT 80 - QPC Software PKTINT.COM - GET BUFFER ADDRESSES
	AH = 02h
	BX = extra bytes to allocate per packet
Return: AX = segment address of 10K buffer (for receives???)
	BX = segment address of 2K buffer (for sends???)
SeeAlso: AH=05h
--------N-8003-------------------------------
INT 80 - QPC Software PKTINT.COM - GET ENTRY POINT
	AH = 03h
Return: CX:DX -> receive call address
Note:	the returned address can be used in the packet driver calls since it
	  will be a valid address in all DOS boxes
SeeAlso: AH=06h
--------N-8004-------------------------------
INT 80 - QPC Software PKTINT.COM - ENABLE???
	AH = 04h
	BX = ???
Return: ???
SeeAlso: AH=01h
--------N-8005-------------------------------
INT 80 - QPC Software PKTINT.COM - GET RECEIVE STATISTICS
	AH = 05h
Return: AX = amount of buffer currently in use
	BX = current offset in buffer
	CX = number of times receive has been called
SeeAlso: AH=02h
--------N-8006-------------------------------
INT 80 - QPC Software PKTINT.COM - REMOVE RECEIVED PACKET
	AH = 06h
Return: BX = next packet offset
	CX = number of bytes still buffered
	DX = size of packet released back into buffer pool
SeeAlso: AH=03h
--------r-81---------------------------------
INT 81 - reserved for BASIC
Note:	this vector is modified but not restored by Direct Access v4.0, and
	  may be left dangling by other programs written with the same version
	  of compiled BASIC
SeeAlso: INT 80"BASIC",INT 82"BASIC"
--------N-81---------------------------------
INT 81 - IBM TOKEN RING ADAPTER - ???
SeeAlso: INT 82"TOKEN RING",INT 91"TOKEN RING"
--------d-81---------------------------------
INT 81 - BusLogic BT-946C PCI SCSI Adapter - SCRATCHPAD RAM (NOT A VECTOR!)
Note:	the factory-default location for the eight bytes of scratchpad RAM
	  needed by the SCSI adapter is 0000h:0200h, which is interrupt
	  vectors 80h and 81h
SeeAlso: INT 80"BusLogic"
--------b-81---------------------------------
INT 81 - AMI WinBIOS - SECOND HARD DRIVE AUTODETECTION
Notes:	used by WinBIOS with core version of July 1994 or later
	QEMM 7.5 began using this interrupt internally after the QPAT3
	  maintenance release when searching for "ROM holes", causing a
	  lengthy delay during bootup.	Adding the QEMM parameter RH:N will
	  avoid the QEMM call to INT 81 and speed up the boot process
--------s-810200---------------------------
INT 81 - Gravis UltraSound - MegaEm - PROCESS COMMAND LINE
	AX = 0200h
	BX = PSP segment
	SI = ??? (data area)
Return: AX = status (see #3607)
	BL = emulation state
	    bit 1   Emulation is on
	    bit 2   Emulation is off
Program: MegaEm is a protected-mode SoundBlaster, SoundCanvas, and MT-32
	  emulator for the Gravis UltraSound
Range:	INT 81 to INT FF (see INT 21/AX=FD12h), selected by scanning for an
	  interrupt with vector 0000h:0000h
SeeAlso: AX=0202h,AX=0300h,AX=0400h,INT 21/AX=FD12h/BX=3457h

(Table 3607)
Values for MegaEm status:
 0000h	successful
 0001h	invalid command line optie
 0002h	display options
 0003h	???
 0004h	invalid number of voices specified
 0005h	could not load enough patches to provide acceptable emulation
 0006h	to many warnings on patch loading
 0007h	??? (not used anymore)
 0008h	/CO and SCSI don't work together
 0009h	invalid music volume
 000Ah	invalid master volume
 000Bh	/SC switch is no longer valid
 0100h	??? (some error on patch loading)
--------s-810202---------------------------
INT 81 - Gravis UltraSound - MegaEm - ???
	AX = 0202h
Return: AX = ???
SeeAlso: AX=0200h,AX=0300h,AX=0400h,INT 21/AX=FD12h/BX=3457h
--------s-810300---------------------------
INT 81 - Gravis UltraSound - MegaEm - LOAD SAMPLE ???
	AX = 0300h
Return: AX = ???
SeeAlso: AX=0200h,AX=0202h,AX=0400h,INT 21/AX=FD12h/BX=3457h
--------s-810400---------------------------
INT 81 - Gravis UltraSound - MegaEm - ???
	AX = 0400h
	BX = ??? (segment)
Return: AX = ???
	BX = ???
Program: MegaEm is a protected-mode SoundBlaster, SoundCanvas, and MT-32
	  emulator for the Gravis UltraSound
SeeAlso: AX=0200h,AX=0202h,AX=0300h,INT 21/AX=FD12h/BX=3457h
--------s-812010------------------------
INT 81 - Gravis UltraSound - MEGA_EM v3.0+ - INT 78 REDIRECT
	AX = 2010h
	???
Return: ???
Note:	MegaEm calls this function from its INT 78 handler, and then
	  immediately returns (via RETF in v3.10, thus leaving the flags on
	  the stack); this permits it to operate while hooking only one
	  interrupt through the memory manager in protected mode
SeeAlso: AX=2011h,AX=2012h
--------s-812011------------------------
INT 81 - Gravis UltraSound - MEGA_EM v3.0+ - NMI REDIRECT
	AX = 2011h
	???
Return: ???
Note:	MegaEm calls this function from its NMI (INT 02) handler, and then
	  immediately returns; this permits it to operate while hooking only
	  one interrupt through the memory manager in protected mode
SeeAlso: AX=2010h,AX=2012h
--------s-812012------------------------
INT 81 - Gravis UltraSound - MEGA_EM v3.0+ - SOUNDCARD IRQ REDIRECT
	AX = 2012h
	???
Return: ???
Note:	MegaEm calls this function from its GUS IRQ handler, and then
	  immediately returns; this permits it to operate while hooking only
	  one interrupt through the memory manager in protected mode
SeeAlso: AX=2010h,AX=2011h
--------s-812015------------------------
INT 81 - Gravis UltraSound - MEGA_EM v3.0+ - ???
	AX = 2015h
	???
Return: ???
--------r-82---------------------------------
INT 82 - reserved for BASIC
SeeAlso: INT 81"BASIC",INT 83"BASIC"
--------N-82---------------------------------
INT 82 - IBM TOKEN RING ADAPTER - ???
	AH = function
	    00h display message???
		DS:BX -> string
	???
Return: ???
SeeAlso: INT 81"TOKEN RING",INT 91"TOKEN RING"
--------r-83---------------------------------
INT 83 - reserved for BASIC
SeeAlso: INT 82"BASIC",INT 84"BASIC"
--------s-8300-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 00h
	???
Return: CF clear (successful)
	AX = ??? (0302h)
Program: JM Pro Tracker is a public-domain resident .MOD (digital music)
	  player by Josha Munnik

(Table 3608)
Values for JM Pro Tracker error code:
 000Ah	???
 000Bh	???
 0014h	???
 001Eh	some required parameters have not yet been set
 001Fh	already playing???
 FExxh	busy (API call already in progress)
 FFxxh	invalid function number
--------s-8301-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 01h
	DX = ??? or FFFFh
	???
Return: CF clear if successful
	CF set on error
	    AX = error code (see #3608)
--------s-8302-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 02h
	BX = ???
	???
Return: CF clear if successful
	    AX = ???
	    BX = ???
	    CX = ???
	    DX = ???
	    SI = ???
	CF set on error
	    AX = error code (000Ah,000Bh,other) (see #3608)
--------s-8303-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 03h
	BX = ??? (only low four bits, must be nonzero)
	CX = ???
	???
Return: CF clear if successful
	CF set on error
	    AX = error code (0014h) (see #3608)
--------s-8304-------------------------------
INT 83 - JM Pro Tracker v5.0 - SET DMA BUFFER???
	AH = 04h
	CX = number of bytes in suggested buffer
	ES:DI -> suggested buffer for DMA transfers???
Return: CF clear if successful
	    ES:AX -> actual buffer (filled with bytes of 80h)
	    CX = actual length (multiple of 4)
	CF set on error
	    AX = error code (see #3608)
Note:	the buffer must not cross a 64K DMA page boundary
--------s-8305-------------------------------
INT 83 - JM Pro Tracker v5.0 - SET ??? BUFFER
	AH = 05h
	CX = length of buffer
	ES:DI -> buffer for/containing ???
Return: CF clear (successful)
SeeAlso: AH=06h,AH=07h,AH=18h
--------s-8306-------------------------------
INT 83 - JM Pro Tracker v5.0 - SET ??? BUFFER
	AH = 06h
	CX = length of buffer
	ES:DI -> buffer for/containing ???
Return: CF clear (successful)
SeeAlso: AH=05h,AH=07h,AH=18h
--------s-8307-------------------------------
INT 83 - JM Pro Tracker v5.0 - SET ??? BUFFER
	AH = 07h
	BX = ???
	CX = length of buffer
	ES:DI -> buffer for/containing ???
Return: CF clear (successful)
SeeAlso: AH=05h,AH=06h,AH=18h
--------s-8308-------------------------------
INT 83 - JM Pro Tracker v5.0 - START PLAYING???
	AH = 08h
	???
Return: CF clear if successful
	   ???
	CF set on error
	    AX = error code (001Eh,001Fh) (see #3608)
SeeAlso: AH=09h,AH=0Ah
--------s-8309-------------------------------
INT 83 - JM Pro Tracker v5.0 - PAUSE???
	AH = 09h
	???
Return: CF clear if successful
	CF set on error
	    AX = error code (see #3608)
SeeAlso: AH=08h,AH=0Ah
--------s-830A-------------------------------
INT 83 - JM Pro Tracker v5.0 - RESUME???
	AH = 0Ah
	???
Return: CF clear if successful
	CF set on error
	    AX = error code (001Fh) (see #3608)
SeeAlso: AH=08h,AH=09h
--------s-830B-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 0Bh
	BX = ???
	???
Return: CF clear if successful
	CF set on error
--------s-830C-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 0Ch
	DX bit 5 = ???
	???
Return: CF clear if successful
	    BX = ??? (FFFFh)
	    CX = ??? (0000h)
	    DX = ???
	CF set on error
	    AX = error code (see #3608)
--------s-830D-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 0Dh
	BX = ???
	???
Return: CF clear (successful)
--------s-830E-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 0Eh
	BX = ??? (ignored if ES:DI = 0000h:0000h)
	ES:DI -> ??? or 0000h:0000h
Return: CF clear (successful)
--------s-830F-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 0Fh
	???
Return: CF clear if successful
	    AX = ???
	CF set on error
	    AX = error code (see #3608)
--------s-8310-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 10h
	BL = subfunction???
	CX = ???
	DX = ???
	???
Return: CF clear if successful
	    CX = DX = ???
	CF set on error
	    AX = error code (see #3608)
SeeAlso: AH=18h
--------s-8311-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 11h
	BL = ???
	CX = ???
Return: CF clear (successful)
--------s-8312-------------------------------
INT 83 - JM Pro Tracker v5.0 - CLEAR ???
	AH = 12h
Return: nothing
--------s-8313-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 13h
	BX = ???
Return: CF clear (successful)
--------s-8314-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 14h
	???
Return: CF clear (successful)
	BX = ???
--------s-8315-------------------------------
INT 83 - JM Pro Tracker v5.0 - GET ???
	AH = 15h
	BX = what to get (zero/nonzero)
Return: CF clear if successful
	    BX = ???
	    DX = ???
	CF set on error
	    AX = error code (see #3608)
--------s-8316-------------------------------
INT 83 - JM Pro Tracker v5.0 - ???
	AH = 16h
	AL = subfunction
	    00h ???
		Return: BX = ???
			CX = ???
			DX = ???
			ES:DI -> ???
			CF indicates ???
	    01h ???
		Return: BX = ???
			CX = ???
			DX = ???
Return: CF clear if successful
	CF set on error
	    AX = error code (FFxxh) (see #3608)
--------s-8317-------------------------------
INT 83 - JM Pro Tracker v5.0 - UNHOOK API INTERRUPT
	AH = 17h
Return: CF clear if successful
	CF set on error (hooked by another program)
--------s-8318-------------------------------
INT 83 - JM Pro Tracker v5.0 - SET BUFFERS
	AH = 18h
	ES:DI -> buffer-pointer structure (see #3609)
Return: nothing
SeeAlso: AH=05h,AH=06h,AH=07h,AH=10h

Format of JM Pro Tracker buffer-pointer structure:
Offset	Size	Description	(Table 3609)
 00h	WORD	length of ??? buffer (see AH=05h)
 02h	DWORD	-> ??? buffer (see AH=05h)
 06h	WORD	length of ??? buffer (see AH=06h)
 08h	DWORD	-> ??? buffer (see AH=06h)
 0Ch	WORD	length of ??? buffer (see AH=07h)
 0Eh	DWORD	-> ??? buffer (see AH=07h)
 12h	WORD	??? (see AH=07h)
 14h	WORD	??? (see AH=10h) (subfunction 01h)
 16h	WORD	??? (see AH=10h) (subfunction 01h)
 18h	WORD	??? (see AH=10h) (subfunction 00h)
 1Ah	WORD	??? (see AH=10h) (subfunction 01h)
--------r-84---------------------------------
INT 84 - reserved for BASIC
SeeAlso: INT 83"BASIC",INT 85"BASIC"
--------r-85---------------------------------
INT 85 - reserved for BASIC
Note:	INT 80 through INT ED are modified but not restored by Direct Access
	  v4.0, and may be left dangling by other programs written with the
	  same version of compiled BASIC
SeeAlso: INT 84"BASIC",INT 86"BASIC"
--------N-86---------------------------------
INT 86 - NetBIOS - ORIGINAL INT 18
Note:	some implementations of NetBIOS reportedly relocate INT 18 here
SeeAlso: INT 18"BOOT HOOK"
--------r-86---------------------------------
INT 86 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 85"BASIC",INT 87"BASIC"
--------r-86---------------------------------
INT 86 - APL*PLUS/PC - Terminate APL session and return to DOS
SeeAlso: INT 21/AH=4Ch,INT 87"APL"
--------r-87---------------------------------
INT 87 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 86"BASIC",INT 88"BASIC"
--------r-87---------------------------------
INT 87 - APL*PLUS/PC - ???
SeeAlso: INT 86"APL",INT 88/AL=00h
--------v-87---------------------------------
INT 87 - VIRUS - "ZeroHunt" - VIRAL CODE (NOT A VECTOR!)
Note:	the ZeroHunt virus copies its resident code down to 0000h:021Ch and
	  following
SeeAlso: INT 8B"VIRUS"
--------r-88---------------------------------
INT 88 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 87"BASIC",INT 89"BASIC"
--------r-88--00-----------------------------
INT 88 - APL*PLUS/PC - CREATE OBJECT OF ARBITRARY RANK OR SHAPE
	AL = 00h
	BX = STPTR of the variable to be assigned
	ES:SI -> model of type, rank, and shape (see #3610)
Return: ES:DI -> first data byte of object
	DX:CX = number of elements in the object
SeeAlso: INT 88/AL=01h,INT 88/AL=08h,INT C8"APL"

Format of APL*PLUS/PC shape model:
Offset	Size	Description	(Table 3610)
 00h	BYTE	type
		01h character (2-byte dimension sizes)
		02h integer (2-byte dimension sizes)
		08h floating point (2-byte dimension sizes)
		11h character (4-byte dimension sizes)
		12h integer (4-byte dimension sizes)
		18h floating point (4-byte dimension sizes)
 01h	BYTE	rank
 02h	(D)WORD first dimension of shape
 N	(D)WORD second dimension of shape
	...
--------r-88--01-----------------------------
INT 88 - APL*PLUS/PC - CREATE CHARACTER SCALAR/VECTOR/MATRIX <64K IN SIZE
	AL = 01h
	AH = rank
	BX = STPTR of the variable to be assigned
	CX = first dimension (if any)
	DX = second dimension (if any)
Return: ES:DI -> object
	CX = number of elements in the object
Note:	each dimension must be 32767 or smaller
SeeAlso: AL=00h,AL=02h,AL=08h,INT C8"APL"
--------r-88--02-----------------------------
INT 88 - APL*PLUS/PC - CREATE INTEGER SCALAR/VECTOR/MATRIX <64K IN SIZE
	AL = 02h
	AH = rank
	BX = STPTR of the variable to be assigned
	CX = first dimension (if any)
	DX = second dimension (if any)
Return: ES:DI -> object
	CX = number of elements in the object
Note:	each dimension must be 32767 or smaller
SeeAlso: AL=01h,AL=08h,INT C8"APL"
--------r-88--08-----------------------------
INT 88 - APL*PLUS/PC - CREATE FLOATING POINT SCALAR/VECTOR/MATRIX <64K IN SIZE
	AL = 08h
	AH = rank
	BX = STPTR of the variable to be assigned
	CX = first dimension (if any)
	DX = second dimension (if any)
Return: ES:DI -> object
	CX = number of elements in the object
Note:	each dimension must be 32767 or smaller
SeeAlso: AL=01h,AL=02h,INT C8"APL"
--------r-88--F5-----------------------------
INT 88 - APL*PLUS/PC - FORCE OBJECT INTO REAL WORKSPACE FROM VIRTUAL
	AL = F5h
	BX = STPTR of object
SeeAlso: INT C8"APL"
--------r-88--F6-----------------------------
INT 88 - APL*PLUS/PC - MAKE NAME IMMUNE FROM OUTSWAPPING
	AL = F6h
	BX = STPTR of object
SeeAlso: AL=F7h,AL=F8h,INT C8"APL"
--------r-88--F7-----------------------------
INT 88 - APL*PLUS/PC - MAKE NAME ELIGIBLE FOR OUTSWAPPING
	AL = F7h
	BX = STPTR of object
SeeAlso: AL=F6h,AL=F8h,INT C8"APL"
--------r-88--F8-----------------------------
INT 88 - APL*PLUS/PC - REPORT WHETHER NAME IS ELIGIBLE FOR OUTSWAPPING
	AL = F8h
	BX = STPTR of object
Return: BX = name's outswapping status
	    0000h eligible
	    0001h not eligible
SeeAlso: AL=F6h,AL=F7h,INT C8"APL"
--------r-88--F9-----------------------------
INT 88 - APL*PLUS/PC - DETERMINE NAME STATUS
	AL = F9h
	ES:SI -> name
	CX = length of name
Return: CF set if name ill-formed or already in use
	    BX = STPTR if already in symbol table
	CF clear if name is available for use
	    BX = 0000h
Note:	does not force the name into the workspace
SeeAlso: AL=FEh,AL=FFh,INT C8"APL"
--------r-88--FC-----------------------------
INT 88 - APL*PLUS/PC - DETERMINE IF MEMORY AVAIL WITHOUT GARBAGE COLLECTION
	AL = FCh
	BX = amount of memory needed (paragraphs)
Return: CF clear if memory available
	CF set if a workspace compaction is required
SeeAlso: AL=FDh,INT C8"APL"
--------r-88--FD-----------------------------
INT 88 - APL*PLUS/PC - PERFORM GARBAGE COLLECTION AND RETURN AVAILABLE MEMORY
	AL = FDh
Return: BX = number of paragraphs available in workspace
SeeAlso: AL=FCh,INT C8"APL"
--------r-88--FE-----------------------------
INT 88 - APL*PLUS/PC - CREATE NAME
	AL = FEh
	ES:SI -> name
	CX = length of name
Return: BX = STPTR of name
	DX = interpreter's data segment
SeeAlso: AL=F9h,AL=FFh,INT C8"APL"
--------r-88--FF-----------------------------
INT 88 - APL*PLUS/PC - DETERMINE NAME STATUS
	AL = FFh
	ES:SI -> name
	CX = length of name
Return: CF set if name ill-formed or already in use
	    BX = STPTR if already in symbol table
	CF clear if name is available for use
	    BX = 0000h
Note:	forces the name into the workspace and makes it immune from outswapping
SeeAlso: AL=F9h,AL=FEh,INT C8"APL"
--------r-89---------------------------------
INT 89 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 88"BASIC",INT 8A"BASIC"
--------r-89---------------------------------
INT 89 - APL*PLUS/PC - ???
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT C9"APL"
--------r-8A---------------------------------
INT 8A - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 89"BASIC",INT 8B"BASIC"
--------r-8A---------------------------------
INT 8A - APL*PLUS/PC - PRINT SCREEN
Note:	same as INT 05
SeeAlso: INT 05"PRINT SCREEN",INT 8C"APL",INT CA"APL"
--------r-8B---------------------------------
INT 8B - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 8A"BASIC",INT 8C"BASIC"
--------r-8B---------------------------------
INT 8B - APL*PLUS/PC - BEEP
Note:	same as printing a ^G via INT 21/AH=02h
SeeAlso: INT 21/AH=02h,INT CB"APL"
--------v-8B---------------------------------
INT 8B - VIRUS - "ZeroHunt" - INSTALLATION CHECK (NOT A VECTOR!)
Note:	if the ZeroHunt virus is resident, this vector will contain either
	  EE83h:019Bh (ZH-411) or EE83h:019Fh (ZH-415)
SeeAlso: INT 70"VIRUS",INT 87"VIRUS",INT 9C"VIRUS"
--------r-8C---------------------------------
INT 8C - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-8C---------------------------------
INT 8C - APL*PLUS/PC - CLEAR SCREEN MEMORY
	AX = flag
	    0000h do not save display attributes
	    0001h save attributes
SeeAlso: INT CC"APL"
--------r-8D---------------------------------
INT 8D - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-8E---------------------------------
INT 8E - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-8F---------------------------------
INT 8F - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-90---------------------------------
INT 90 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-90---------------------------------
INT 90 - APL*PLUS/PC - USED BY PORT 10 PRINTER DRIVER
--------r-91---------------------------------
INT 91 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-91---------------------------------
INT 91 - IBM TOKEN RING ADAPTER - ???
SeeAlso: INT 81"TOKEN RING",INT 82"TOKEN RING",INT 93"TOKEN RING"
--------r-92---------------------------------
INT 92 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-92---------------------------------
INT 92 - Sangoma X.25 INTERFACE PROGRAM
	BX:DX -> control block
SeeAlso: INT 68"Sangoma"
--------e-92E1-------------------------------
INT 92 - Da Vinci eMail Dispatcher INTERFACE
	AH = E1h
	AL = function
	BX = stack count (number of words to push)
	CX:DX -> stack data (in word-reversed order ready to push)
Return: AX = status (see #3611)
Note:	preserves BP, DS, SI, DI; other registers may be destroyed

(Table 3611)
Values for Da Vinci eMail function status:
 0001h	success
 FF97h	"ERS_NOT_AVAILABLE"
 FF99h	"ERS_TOO_MANY_NAMES"
 FF9Ah	"ERS_BAD_NAME_PASSWORD"
 FFE3h	"ERS_NAME_NOT_FOUND"
 FFF8h	"ERS_USE_STRING" (call NetGetError to get error string)
 FFFFh	"ERS_NO_SUCH_FILE"
--------e-92E100-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetInitStart"
	AX = E100h
	BX = size of parameter block in words (000Ah)
	CX:DX -> parameter block (see #3612)
Return: AX = 0001h success
Desc:	this function is used to initialize the dispatcher
SeeAlso: AX=E101h,AX=E103h

Format of Da Vinci eMail "NetInitStart" parameter block:
Offset	Size	Description	(Table 3612)
 00h	WORD	segment of ???
 02h	WORD	offset of ???
 04h	WORD	high part of long ???
 06h	WORD	low part of long ???
 08h	WORD	high part of long ???
 0Ah	WORD	low part of long ???
 0Ch	WORD	high part of long ???
 0Eh	WORD	low part of long ???
 10h	WORD	high part of long ???
 12h	WORD	low part of long ???
--------e-92E101BX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetInitCheck"
	AX = E101h
	BX = 0000h
	CX:DX ignored
Return: AX = 0001h success
SeeAlso: AX=E100h,AX=E180h
--------e-92E102BX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetCheckDriver"
	AX = E102h
	BX = 0000h
	CX:DX ignored
Return: AX = 0001h success
Desc:	this function is used to determine if the dispatcher is loaded
SeeAlso: AX=E10Bh,AX=E180h
--------e-92E103BX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetTerminate"
	AX = E103h
	BX = 0000h
	CX:DX ignored
Return: AX = status (see #3611)
SeeAlso: AX=E100h
--------e-92E104-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetWhereIs"
	AX = E104h
	BX = size of parameter block in words (0006h)
	CX:DX -> parameter block (see #3613)
Return: AX = status (see #3611)
Desc:	this function is used to verify node address for usernames
SeeAlso: AX=E180h

Format of Da Vinci eMail "NetWhereIs" parameter block:
Offset	Size	Description	(Table 3613)
 00h	WORD	segment of node address buffer
 02h	WORD	offset of node address buffer
 04h	WORD	segment of uppercase username
 06h	WORD	offset of uppercase username
 08h	WORD	segment of "DVSEMAIL"
 0Ah	WORD	offset of "DVSEMAIL"
--------e-92E105-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetOpen"
	AX = E105h
	BX = size of parameter block in words (0007h)
	CX:DX -> parameter block (see #3614)
Return: AX = 0000h Error
	AX = handle
Desc:	this function is used to open a submission channel
SeeAlso: AX=E10Ah,AX=E106h,AX=E108h

Format of Da Vinci eMail "NetOpen" parameter block:
Offset	Size	Description	(Table 3614)
 00h	WORD	operation (1 = read, 2 = write)
 02h	WORD	segment of uppercase To: username
 04h	WORD	offset of uppercase To: username
 06h	WORD	segment of "DVSEMAIL"
 08h	WORD	offset of "DVSEMAIL"
 0Ah	WORD	segment of node address
 0Ch	WORD	offset of node address
--------e-92E106BX0004-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetRead"
	AX = E106h
	BX = 0004h
	CX:DX -> parameter block
Return: AX = 0001h
SeeAlso: AX=E108h
--------e-92E107BX0002-----------------------
INT 92 - Da Vinci eMail Dispatcher - "NetGetError"
	AX = E107h
	BX = 0002h
	CX:DX -> parameter block
Return: AX = 0001h
SeeAlso: AX=E109h,AX=E180h
--------e-92E108-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetWrite"
	AX = E108h
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #3615)
Return: AX = amount written
Desc:	This function is used to write transactions to the dispatcher.
	  The command block is written first and then another call is used
	  to write the associated data.
SeeAlso: AX=E106h

Format of Da Vinci eMail "NetWrite" parameter block:
Offset	Size	Description	(Table 3615)
 00h	WORD	buffer count (see #3617)
 02h	WORD	segment of command buffer (see #3616)
 04h	WORD	offset of command buffer
 06h	WORD	handle from NetOpen

Format of Da Vinci eMail command buffer:
Offset	Size	Description	(Table 3616)
 00h	BYTE	command
		21h '!' Protocol commands for remote control
		41h 'A' Authorization protocol element
		42h 'B' Return(back) routing information
		    Associated data is the From: username
		43h 'C' Carbon Copy list
		    Associated data is a comma delimitted list of usernames
		44h 'D' Distribution list
		    Associated data is a comma delimitted list of usernames
		45h 'E' Mail end marker
		    No associated data
		48h 'H' Mail message header
		    Associated data is a message header buffer
		4Dh 'M' Mail message
		    Associated data is the body of the message
		4Fh 'O' Object
		50h 'P' Paperclip attachment
		52h 'R' Routing information
		    Associated data is the To: username
		53h 'S' Subject
		    Associated data is the subject of the message
		54h 'T' Trail of Reply/Forwards
 01h	BYTE	subcommand
 02h	DWORD	length of associated data

Format of Da Vinci eMail message header buffer:
Offset	Size	Description	(Table 3617)
 00h 30 BYTEs	subject line
 1Eh 24 BYTEs	To
 36h 24 BYTEs	From
 4Eh	DWORD	Time
		BYTE	00h
		BYTE	hour
		BYTE	minute
		BYTE	second
 52h	DWORD	Date
		BYTE	00h
		BYTE	year
		BYTE	month
		BYTE	day
 56h	DWORD	serial number (00000000h)
 5Ah	WORD	mail types (see #3618)
 5Ch	WORD	special types (0)

Bitfields for Da Vinci eMail mail types:
Bit(s)	Description	(Table 3618)
 7	blind carbon copy
 6	carbon copy
 5	priority
 4	confidential
 3	certified
 2	bulk
 1-0	class (first, second, third, bulk)
--------e-92E109-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetErrorFix" (UNUSED)
	AX = E109h
	BX = size of parameter block in words (0001h)
	CX:DX -> parameter block (see #3619)
Return: AX = FF97h (ERS_NOT_AVAILABLE)
SeeAlso: AX=E107h,AX=E180h

Format of Da Vinci eMail "NetErrorFix" parameter block:
Offset	Size	Description	(Table 3619)
 00h	WORD	???
--------e-92E10A-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetClose"
	AX = E10Ah
	BX = size of parameter block in words (0001h)
	CX:DX -> parameter block (see #3620)
Return: AX = 0001h
Desc:	this function is used to close a dispatcher handle
SeeAlso: AX=E105h

Format of Da Vinci eMail "NetClose" parameter block:
Offset	Size	Description	(Table 3620)
 00h	WORD	handle from NetOpen
--------e-92E10B-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetCheckQueue"
	AX = E10Bh
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #3621)
Return: AX = 0001h
SeeAlso: AX=E102h,AX=E10Ch

Format of Da Vinci eMail "NetCheckQueue" parameter block:
Offset	Size	Description	(Table 3621)
 00h	WORD	segment of 24-byte username buffer
 02h	WORD	offset of 24-byte username buffer
 04h	WORD	segment of 24-byte protocol buffer
 06h	WORD	offset of 24-byte protocol buffer
--------e-92E10C-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetReadQueue"
	AX = E10Ch
	BX = size of parameter block in words (0002h)
	CX:DX -> parameter block (see #3622)
Return: AX = 0001h
SeeAlso: AX=E10Bh

Format of Da Vinci eMail "NetReadQueue" parameter block:
Offset	Size	Description	(Table 3622)
 00h	WORD	Segment of 128 byte node address buffer
 02h	WORD	Offset of 128 byte node address buffer
--------e-92E10D-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetSubmitName"
	AX = E10Dh
	BX = size of parameter block in words (0006h)
	CX:DX -> parameter block (see #3623)
Return: AX = status (see #3611)
Desc:	this function is used to verify username/password
SeeAlso: AX=E10Eh

Format of Da Vinci eMail "NetSubmitName" parameter block:
Offset	Size	Description	(Table 3623)
 00h	WORD	segment of uppercase password string
 02h	WORD	offset of uppercase password string
 04h	WORD	segment of uppercase username string
 06h	WORD	offset of uppercase username string
 08h	WORD	segment of "DVSEMAIL"
 0Ah	WORD	offset of "DVSEMAIL"
--------e-92E10E-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetRemoveName"
	AX = E10Eh
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #3624)
Return: AX = 0001h
Desc:	this function is used to remove a username
SeeAlso: AX=E10Dh

Format of Da Vinci eMail "NetRemoveName" parameter block:
Offset	Type	Description	(Table 3624)
 00h	WORD	segment of uppercase username
 02h	WORD	offset of uppercase username
 04h	WORD	segment of "DVSEMAIL"
 06h	WORD	offset of "DVSEMAIL"
--------e-92E10FBX0000-----------------------
INT 92 - Da Vinci eMail Dispatcher - IS ANYONE THERE? QUERY
	AX = E10Fh
	BX = 0000h
	CX:DX ignored
Return: AX = 0001h
SeeAlso: AX=E180h
--------e-92E110-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetGetAltRoute"
	AX = E110h
	BX = size of parameter block in words (0006h)
	CX:DX -> parameter block (see #3625)
Return: AX = 0001h
SeeAlso: AX=E111h,AX=E113h

Format of Da Vinci eMail "NetGetAltRoute" parameter block:
Offset	Size	Description	(Table 3625)
 00h  6 WORDs	???
--------e-92E111-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetDeleteAltRoutes"
	AX = E111h
	BX = size of parameter block in words (0004h)
	CX:DX -> parameter block (see #3626)
Return: AX = 0001h
SeeAlso: AX=E110h,AX=E113h

Format of Da Vinci eMail "NetDeleteAltRoutes" parameter block:
Offset	Size	Description	(Table 3626)
 00h  4 WORDs	???
--------e-92E112-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetChangePassword"
	AX = E112h
	BX = size of parameter block in words (0008h)
	CX:DX -> parameter block (see #3627)
Return: AX = 0001h
SeeAlso: AX=E180h

Format of Da Vinci eMail "NetChangePassword" parameter block:
Offset	Size	Description	(Table 3627)
 00h  8 WORDs	???
--------e-92E113-----------------------------
INT 92 - Da Vinci eMail Dispatcher - "NetSetAltRoute"
	AX = E113h
	BX = size of parameter block in words (0008h)
	CX:DX -> parameter block (see #3628)
Return: AX = 0001h
SeeAlso: AX=E110h,AX=E111h

Format of Da Vinci eMail "NetSetAltRoute" parameter block:
Offset	Size	Description	(Table 3628)
 00h  8 WORDs	???
--------e-92E175-----------------------------
INT 92 - Da Vinci eMail Dispatcher - BECOME MICRO TSR
	AX = E175h
Return: AX = 0012h
	BX = PSP
SeeAlso: AX=E180h
--------e-92E180-----------------------------
INT 92 - Da Vinci eMail Dispatcher - INSTALLATION CHECK
	AX = E180h
Return: AX = 0012h if installed
	ES:DX -> '$'-terminated driver information string
SeeAlso: AX=E102h,AX=E105h,AX=E10Fh,AX=E175h
--------r-93---------------------------------
INT 93 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-93---------------------------------
INT 93 - IBM TOKEN RING ADAPTER - ???
SeeAlso: INT 81"TOKEN RING",INT 91"TOKEN RING"
--------r-94---------------------------------
INT 94 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------s-94----SI0000-----------------------
INT 94 u - PCM driver - INITIALIZE SOUND
	SI = 0000h
	ES:BX -> parameters
Return: ???
Program: PCM.COM is a sound driver for Media Vision's Pro Audio Spectrum
	  sound boards
Note:	the installation check consists of testing for the signature string
	  "PCMDRIVER" immediately preceding the interrupt handler; the word
	  preceding the signature gives the PCM driver's version
SeeAlso: SI=0001h,SI=0002h,SI=0003h,SI=0004h,SI=0005h,SI=000Ah
Index:	installation check;PCM driver|PCM.COM;installation check
Index:	PCM driver;installation check
--------s-94----SI0001-----------------------
INT 94 u - PCM driver - INITIALIZE PCM
	SI = 0001h
	ES:BX -> parameters
Return: ???
SeeAlso: SI=0000h,SI=0002h,SI=0003h,SI=000Ah
--------s-94----SI0002-----------------------
INT 94 u - PCM driver - INITIALIZE PCM INFO
	SI = 0002h
	ES:BX -> parameters (see #3629)
Return: ???
SeeAlso: SI=0000h,SI=0001h,SI=0003h,SI=000Ah

Format of PCM driver function 0002h parameters:
Offset	Size	Description	(Table 3629)
 00h	DWORD	rate
 04h	WORD	channel number
 06h	WORD	"comp"
 08h	WORD	"dsize"
--------s-94----SI0003-----------------------
INT 94 u - PCM driver - INITIALIZE DMA BUFFER
	SI = 0003h
	ES:BX -> parameters (see #3630)
Return: ???
SeeAlso: SI=0000h,SI=000Ah,SI=000Bh

Format of PCM driver function 0003h parameters:
Offset	Size	Description	(Table 3630)
 00h	DWORD	-> DMA buffer
 04h	WORD	size of DMA buffer
 06h	WORD	number of divisions
--------s-94----SI0004-----------------------
INT 94 u - PCM driver - INITIALIZE USER FUNCTION
	SI = 0004h
	ES:BX -> parameters (see #3631)
Return: ???
SeeAlso: SI=0000h,SI=0001h

Format of PCM driver function 0004h parameters:
Offset	Size	Description	(Table 3631)
 00h	DWORD	-> user function
--------s-94----SI0005-----------------------
INT 94 u - PCM driver - BEGIN AUDIO PLAY
	SI = 0005h
Return: ???
SeeAlso: SI=0000h,SI=0006h,SI=0007h,SI=0009h
--------s-94----SI0006-----------------------
INT 94 u - PCM driver - BEGIN AUDIO RECORD
	SI = 0006h
Return: ???
SeeAlso: SI=0005h,SI=0007h,SI=0009h
--------s-94----SI0007-----------------------
INT 94 u - PCM driver - PAUSE AUDIO PLAY/RECORD
	SI = 0007h
Return: ???
SeeAlso: SI=0005h,SI=0006h,SI=0008h
--------s-94----SI0008-----------------------
INT 94 u - PCM driver - RESUME AUDIO PLAY/RECORD
	SI = 0008h
Return: ???
SeeAlso: SI=0007h
--------s-94----SI0009-----------------------
INT 94 u - PCM driver - STOP AUDIO PLAY/RECORD
	SI = 0009h
Return: ???
SeeAlso: SI=0005h,SI=0006h,SI=0007h
--------s-94----SI000A-----------------------
INT 94 u - PCM driver - UNHOOK INTERRUPTS AND TURN OFF DMA
	SI = 000Ah
Return: ???
SeeAlso: SI=0000h,SI=0001h,SI=0003h
Index:	uninstall;PCM driver
--------s-94----SI000B-----------------------
INT 94 u - PCM driver - FIND VALID DMA BUFFER IN HUGE MEMORY BLOCK
	SI = 000Bh
	ES:BX -> parameters (see #3632)
Return: ???
SeeAlso: SI=0003h

Format of PCM driver functio 000Bh parameters:
Offset	Size	Description	(Table 3632)
 00h	DWORD	-> memory block to contain DMA buffer
 04h	WORD	desired size of DMA buffer
--------s-94----SI000D-----------------------
INT 94 u - Media Vision PCM.COM - GET STATUS
	SI = 000Dh
Return: AX = status (0000h = waiting) (see #3633)

Bitfields for PCM.COM status:
Bit(s)	Description	(Table 3633)
 0	playing
 1	recording
 2	SBplaying
 3	SBrecording
 14	SBpaused
 15	paused
--------s-94----SI8000-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL DMA BUFFER ADDRESS
	SI = 8000h
Return: DX:AX -> DMA buffer
Program: PCM.COM is a superset of the standard PCM driver which provides
	  additional functions for fine control of the driver
Note:	the installation check for the Media Vision PCM.COM "shark" functions
	  consists of testing for the signature "PCM-SHARK" at offset 107h in
	  the INT 94 handler's segment
SeeAlso: SI=8001h,SI=8004h
Index:	installation check;Media Vision PCM.COM|PCM.COM;installation check
Index:	Media Vision PCM.COM;"shark" functions
--------s-94----SI8001-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL DMA BUFFER SIZE AND DIVISIONS
	SI = 8001h
Return: AX = DMA buffer size
	DX = divisions
SeeAlso: SI=8000h
--------s-94----SI8002-----------------------
INT 94 u - Media Vision PCM.COM - CHECK BOARD ADDRESS
	SI = 8002h
Return: AX = status
	    0000h if board not at specified I/O address
	    other if board found
Note:	the I/O address is specified by ORing the base I/O port shifted left
	  four bits into SI before calling INT 94
SeeAlso: SI=8000h
--------s-94----SI8004-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL NOTE BUFFER
	SI = 8004h
Return: AX = offset of note buffer (segment = segment of internal DMA buffer)
	DX = size of buffer in note structures
SeeAlso: SI=8000h
--------s-94----SI8005-----------------------
INT 94 u - Media Vision PCM.COM - SINGLE-STEP QUEUE
	SI = 8005h
Return: ???
--------s-94----SI8011-----------------------
INT 94 u - Media Vision PCM.COM - INITIALIZE
	SI = 8011h
	ES:BX -> "iobf91" structure
Return: ???
--------s-94----SI8012-----------------------
INT 94 u - Media Vision PCM.COM - LOAD SOUND FOR LATER PLAY THROUGH KEYBOARD
	SI = 8012h
	ES:BX -> "i94f92buf" structure
Return: ???
SeeAlso: SI=8013h,SI=8014h
--------s-94----SI8013-----------------------
INT 94 u - Media Vision PCM.COM - GET INTERNAL SOUND USAGE
	SI = 8013h
Return: AX = number of sounds used
	DX = maximum handles
--------s-94----SI8014-----------------------
INT 94 u - Media Vision PCM.COM - GET DATA FOR SPECIFIED SOUND
	SI = 8014h
	ES:BX -> "i94f92buf" structure to be filled in
		sound number field set to desired sound
Return: AX = status
	    0000h successful
	    FFFFh sound number out of range
SeeAlso: SI=8012h,SI=8013h
--------s-94----SI8015-----------------------
INT 94 u - Media Vision PCM.COM - GET/SET INTERNAL DMA BUFFER
	SI = 8015h
	ES:BX -> DMA info structure (see #3634)
Return: ???

Format of PCM.COM DMA info structure:
Offset	Size	Description	(Table 3634)
 00h	DWORD	-> DMA buffer (offset FFFFh = return current buffer info)
 04h	WORD	DMA buffer size
 06h	WORD	divisions
--------s-94----SI8016-----------------------
INT 94 u - Media Vision PCM.COM - SIMULATE DOUBLE-SHIFT HOTKEY
	SI = 8016h
	AX = hotkey number (01h-08h)
Return: ???
SeeAlso: AL=02h/SI=8017h
--------s-94--01SI8017-----------------------
INT 94 u - Media Vision PCM.COM - CTRL-G INTERCEPT
	AL = 01h
	SI = 8017h
	AH = new state (00h off, 01h on)
Return: ???
SeeAlso: AL=02h/SI=8017h
--------s-94--02SI8017-----------------------
INT 94 u - Media Vision PCM.COM - DOUBLE-SHIFT-HOTKEY SOUND FEATURE
	AL = 02h
	SI = 8017h
	AH = new state (00h off, 01h on)
Return: ???
--------s-94--04SI8017-----------------------
INT 94 u - Media Vision PCM.COM - RANDOM SOUND FEATURE
	AL = 04h
	SI = 8017h
	AH = new state
	    00h off
	    01h on
		CX = minimum delay
		DX = maximum delay
Return: ???
--------s-94--08SI8017-----------------------
INT 94 u - Media Vision PCM.COM - NO ACTIVITY FEATURE
	AL = 08h
	SI = 8017h
	AH = new state
	    00h off
	    01h on
		DX:CX = delay
Return: ???
SeeAlso: AL=10h/SI=8017h
--------s-94--10SI8017-----------------------
INT 94 u - Media Vision PCM.COM - TIMER CONTROL
	AL = 10h
	SI = 8017h
	AH = timer options (see #3635)
	DX:CX = delay if AH bit 7 set (one-shot if DX bit 15 set)
Return: ???
SeeAlso: AL=08h/SI=8017h

Bitfields for PCM.COM timer options:
Bit(s)	Description	(Table 3635)
 7	set timer
 6	timer active (timer turned off if clear)
 5-0	timer number
--------s-94----SI8018-----------------------
INT 94 u - Media Vision PCM.COM - GET INFO
	SI = 8018h
	AL = what to get
	    00h "F92state"
	    01h "F92bkgd"
	    02h "I10timer"
	    03h "I08state"
Return: DX:AX -> desired information
--------r-95---------------------------------
INT 95 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-95---------------------------------
INT 95 - APL*PLUS/PC - DETERMINE R= SPACE
Note:	use only when the R= option is invoked on entering APL
--------r-96---------------------------------
INT 96 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------U-96---------------------------------
INT 96 U - KILL.COM, QKILL.COM - POP UP
Program: KILL.COM is a TSR utility that allows you to terminate programs
	 by calling INT 21/AH=4Ch or reboot the computer (author unknown);
	 QKILL.COM is a modification of KILL.COM by Solar Designer that
	 supports QEMM's Quick Boot feature
Notes:	This interrupt is intercepted but not chained by KILL.COM; it is never
	  called by KILL.COM itself. It points into the middle of KILL.COM's
	  INT 09 handler and assumes specific values have been placed on the
	  stack (thus it can't be called as an interrupt).
	To invoke KILL, use the following code:
		pushf
		push cs
		push offset $+0Dh
		push ax
		push es
		push 0
		pop  es
		jmp  dword ptr es:[96h*4]
--------r-97---------------------------------
INT 97 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-98---------------------------------
INT 98 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-99---------------------------------
INT 99 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-9A---------------------------------
INT 9A - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 99,INT 9B
--------r-9B---------------------------------
INT 9B - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9A,INT 9C"BASIC"
--------r-9C---------------------------------
INT 9C - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9B,INT 9D"BASIC"
--------v-9C---------------------------------
INT 9C - VIRUS - "INT13" - ORIGINAL INT 13h VECTOR
SeeAlso: INT 8B"VIRUS",INT 9D"VIRUS",INT 9E"VIRUS",INT 9F"VIRUS"
--------r-9D---------------------------------
INT 9D - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9C"BASIC",INT 9E"BASIC"
--------v-9D---------------------------------
INT 9D - VIRUS - "INT13" - ROM INT 13h ENTRY POINT
Note:	this vector is used by the virus to store the result of a call to
	  INT 2F/AH=13h
SeeAlso: INT 2F/AH=13h,INT 9C"VIRUS",INT 9E"VIRUS",INT 9F"VIRUS"
--------r-9E---------------------------------
INT 9E - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9D"BASIC",INT 9F"BASIC"
--------v-9E---------------------------------
INT 9E - VIRUS - "INT13" - ORIGINAL INT 21h VECTOR
SeeAlso: INT 70"VIRUS",INT 9C"VIRUS",INT 9D"VIRUS",INT E0"VIRUS"
--------r-9F---------------------------------
INT 9F - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9D"BASIC",INT A0"BASIC"
--------v-9F---------------------------------
INT 9F - VIRUS - "INT13" - STORAGE FOR USER INT 13h VECTOR
Note:	while it is infecting a file, the INT13 virus grabs INT 13 and uses
	  this interrupt to store the existing INT 13 vector for later
	  restoration
SeeAlso: INT 9C"VIRUS",INT 9D"VIRUS",INT D3"VIRUS"
--------r-A0---------------------------------
INT A0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT 9F"BASIC",INT A1"BASIC"
--------r-A0---------------------------------
INT A0 - APL*PLUS/PC - USED BY APL/GSS*CGI GRAPHICS INTERFACE
SeeAlso: INT 59"GSS"
--------r-A1---------------------------------
INT A1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A0"BASIC",INT A2"BASIC"
--------r-A2---------------------------------
INT A2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A1"BASIC",INT A3"BASIC"
--------r-A3---------------------------------
INT A3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A2"BASIC",INT A4"BASIC"
--------r-A4---------------------------------
INT A4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A3"BASIC",INT A5"BASIC"
--------U-A4---------------------------------
INT A4 U - Right Hand Man - API
	AH = function number (v3.3 supports functions 00h-52h)
Return: CF set on error
	CF clear if successful
Program: Right Hand Man is a TSR desk-top utility originally by Red E Products
	  which has evolved into Futurus Team
Note:	this interrupt is only hooked while popped up
SeeAlso: INT 2F/AX=A4E0h
--------r-A5---------------------------------
INT A5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A4"BASIC",INT A6"BASIC"
--------r-A6---------------------------------
INT A6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT A5"BASIC",INT A7"BASIC"
--------r-A7---------------------------------
INT A7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-A8---------------------------------
INT A8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-A9---------------------------------
INT A9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AA---------------------------------
INT AA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AB---------------------------------
INT AB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AC---------------------------------
INT AC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AD---------------------------------
INT AD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AE---------------------------------
INT AE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-AF---------------------------------
INT AF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B0---------------------------------
INT B0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B1---------------------------------
INT B1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B2---------------------------------
INT B2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B3---------------------------------
INT B3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------U-B370-------------------------------
INT B3 - ZIPKEY - GET VERSION
	AH = 70h
Return: AH = major version
	AL = minor version
	CL = number of states and territories in current database
	DH = year of current database - 1900
	DL = month of current database's file date
Program: ZIPKEY is a resident ZIPCODE database by Eric Isaacson
Note:	if installed, the string "ZIPKEY" is present at offset 75h in the
	  interrupt handler's segment, and the byte at 7Bh contains the API
	  version number (00h for v1.x, 01h for v2.0)
--------U-B371-------------------------------
INT B3 - ZIPKEY - CONVERT TWO-LETTER ABBREVIATION TO STATE CODE
	AH = 71h
	BX = abbreviation, in either case (first letter in BL)
Return: CF set on error
	    AL = FFh
	CF clear if successful
	    AL = ZIPKEY state code
SeeAlso: AH=72h
--------U-B372-------------------------------
INT B3 - ZIPKEY - CONVERT STATE CODE TO TWO-LETTER ABBREVIATION
	AH = 72h
	BL = ZIPKEY state code
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    AX = abbreviation, in upper case
SeeAlso: AH=71h,AH=73h
--------U-B373-------------------------------
INT B3 - ZIPKEY - CONVERT STATE CODE TO STATE NAME
	AH = 73h
	BL = ZIPKEY state code
	ES:DI -> buffer for name
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    ES:DI points one byte beyond end of name
SeeAlso: AH=72h
--------U-B374-------------------------------
INT B3 - ZIPKEY - CONVERT ZIPCODE TO ASCII DIGITS
	AH = 74h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
	ES:DI -> buffer
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    ES:DI points one byte beyond end of digit string
--------U-B375-------------------------------
INT B3 - ZIPKEY - LOOK UP STATE CODE FOR ZIPCODE
	AH = 75h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
Return: CF set on error (zipcode not found)
	    AL = suggested state code, FFh if none
	CF clear if successful
	    AL = ZIPKEY state code
	    BX = area code (v2.0+)
SeeAlso: AH=76h,AH=79h
--------U-B376-------------------------------
INT B3 - ZIPKEY - LOOK UP CITY AND STATE FOR ZIPCODE
	AH = 76h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
	ES:DI -> buffer for name
Return: CF set on error
	    AL = suggested state code, FFh if none
	    ES:DI buffer filled with suggested city name
	CF clear if successful
	    AL = ZIPKEY state code
	    BX = area code (v2.0+)
	    ES:DI points one byte beyond end of name
SeeAlso: AH=75h,AH=78h,AH=7Eh
--------U-B377-------------------------------
INT B3 - ZIPKEY - PLAY BACK EXIT KEY FOR ENTRY WITH GIVEN ZIPCODE
	AH = 77h
	DX = zipcode region (0-999)
	CH = last two digits of zipcode (0-99)
	BX = 16-bit BIOS keycode for a defined ZIPKEY alternate exit key
Return: CF set on error
	    AX destroyed
	CF clear if successful
	    zipcode specification as defined by the BX keystroke is placed in
	      keyboard buffer, as if the user had popped up ZIPKEY and exited
	      by pressing the key specified by BX
--------U-B378-------------------------------
INT B3 - ZIPKEY - LOOK UP ZIPCODES FOR A GIVEN STATE AND CITY
	AH = 78h
	BL = ZIPKEY state code
	DS:SI -> city name, terminated with 0Dh if complete name, 00h if prefix
Return: BH = number of matching entries (set to 51 if more than 50)
	DX = zipcode region of first match (0-999)
	CL = last two digits of first zipcode in the range (0-99)
	CH = last two digits of last zipcode in the range (0-99)
	AX destroyed
SeeAlso: AH=79h,AH=7Ah
--------U-B379-------------------------------
INT B3 - ZIPKEY - LOOK UP ZIPCODES FOR A GIVEN CITY
	AH = 79h
	BL = ZIPKEY state code of first state to search
	DS:SI -> city name, terminated with 0Dh if complete name, 00h if prefix
Return: AL = ZIPKEY state code of first matching state
	BH = number of matching entries (set to 51 if more than 50)
	DX = zipcode region of first match (0-999)
	CL = last two digits of first zipcode in first range (0-99)
	CH = last two digits of last zipcode in first range (0-99)
Note:	to find all matching cities, repeat search with BL set to one more than
	  the returned AL
SeeAlso: AH=78h,AH=7Ah
--------U-B37A-------------------------------
INT B3 - ZIPKEY - FETCH AN ENTRY FROM A PREVIOUS LOOKUP
	AH = 7Ah
	BL = case number (0 to one less than value returned in BH by lookup)
Return: AL = ZIPKEY state code
	DX = zipcode region (0-999)
	CL = last two digits of first zipcode in the range (0-99)
	CH = last two digits of last zipcode in the range (0-99)
SeeAlso: AH=78h,AH=79h
--------U-B37B-------------------------------
INT B3 - ZIPKEY - GET VALUES NEEDED TO SAVE ZIPKEY CONTEXT
	AH = 7Bh
Return: BL = maximum number of characters for a city name
	BH = ZIPKEY state code for last city-name search, or FFh if none
	CX:DX = internal code identifying last city search
	AX destroyed
SeeAlso: AH=7Ch
--------U-B37C-------------------------------
INT B3 - ZIPKEY - RESTORE ZIPKEY CONTEXT
	AH = 7Ch
	BL = maximum number of characters for a city name
	BH = ZIPKEY state code for last city-name search, or FFh if none
	CX:DX = internal code returned by AH=7Bh
Return: CF set on error
	CF clear if successful
	AX destroyed
SeeAlso: AH=7Bh
--------U-B37D-------------------------------
INT B3 - ZIPKEY - REQUEST POP UP
	AH = 7Dh
	BL = index number to simulate pressing a hotkey
	    FFh for immediate popup with no playback on return
Return: CF set on error
	    AL = error code
		FDh already busy with another request
		FEh illegal function
	CF clear if successful
	    AX destroyed
	    window popped up and was closed by the user
SeeAlso: AH=70h
--------U-B37E-------------------------------
INT B3 - ZIPKEY - GET NAME OF PRIMARY CITY FOR A ZIPCODE REGION
	AH = 7Eh
	DX = zipcode region (0-999)
	ES:DI -> buffer for name
Return: CF set on error
	    AL = FFh region does not exist
	CF clear if successful
	    AL = ZIPKEY state code
	    ES:DI points one byte beyond end of name
SeeAlso: AH=76h
--------U-B37F-------------------------------
INT B3 - ZIPKEY - ENABLE/DISABLE HOTKEYS
	AH = 7Fh
	BL = function
	    00h turn off hotkeys
	    01h turn on hotkeys
	    02h return hotkey status
	    03h toggle hotkey status
Return: AL = hotkey status
	    00h off
	    01h on
--------U-B380-------------------------------
INT B3 - ZIPKEY v2.0+ - DETERMINE STATE FOR AREA CODE
	AH = 80h
	BX = telephone area code (decimal)
Return: CF clear if successful
	    AL = ZIPKEY state code
	    DX = first ZIP region for state (03E8h if Canada)
	    CX = number of ZIP regions in state
	CF set on error
	    AL = FFh
	    DX = 03E9h
--------r-B4---------------------------------
INT B4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-B4---------------------------------
INT B4 - StackMan - REQUEST NEW STACK
Return: SS:SP -> new stack
Program: StackMan is a freeware stack manager by Franz Veldman of ESaSS B.V.
	  which functions as a replacement for the DOS STACK= command as well
	  as permitting multiple TSRs to share a pool of stack space
Note:	the installation check consists of testing for the string "STACKXXX" at
	  offset 0Ah from the interrupt handler
SeeAlso: INT 2F/AX=C9FFh,INT B5"STACKMAN"
Index:	installation check;STACKMAN
--------r-B5---------------------------------
INT B5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B4"BASIC",INT B6"BASIC"
--------r-B5---------------------------------
INT B5 - StackMan - RESTORE ORIGINAL STACK
	SS:SP -> stack returned by INT B4
Return: SS:SP restored to value before INT B4
SeeAlso: INT 2F/AX=C9FFh,INT B4"StackMan"
--------m-B5---------------------------------
INT B5 U - Netroom NETSWAP4 - ???
	???
Return: ???
SeeAlso: INT 31/AH=57h
--------r-B6---------------------------------
INT B6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B5"BASIC",INT B7"BASIC"
--------y-B6---------------------------------
INT B6 - (NOT A VECTOR!) - USED BY TBFENCE
Program: TBFence is a security program by ESaSS B.V. which transparently
	  encrypts floppies and optionally allows only encrypted diskettes to
	  be accessed
Note:	the low word of this vector (0000h:02D8h) contains the segment of the
	  TBFence INT 13h code, which starts with the signature word E487h;
	  this forms the installation check
	the highest byte of this vector contains the start of a FAR JMP
	  instruction to ???
SeeAlso: INT B7"TBFENCE"
Index:	installation check;TBFence
--------r-B7---------------------------------
INT B7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B6"BASIC",INT B8"BASIC"
--------y-B7---------------------------------
INT B7 - TBFENCE - ???
SeeAlso: INT B6"TBFENCE"
--------r-B8---------------------------------
INT B8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT B7"BASIC",INT B9"BASIC"
--------r-B9---------------------------------
INT B9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BA---------------------------------
INT BA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BB---------------------------------
INT BB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BC---------------------------------
INT BC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BD---------------------------------
INT BD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-BE---------------------------------
INT BE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT BD"BASIC",INT BF"BASIC"
--------Q-BE---------------------------------
INT BE - DESQview/X - ???
Note:	points at an IRET
SeeAlso: INT 15/AX=BFDEh/BX=0006h,INT 63"DESQview"
--------r-BF---------------------------------
INT BF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT BE"BASIC",INT C0"BASIC"
--------r-C0---------------------------------
INT C0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT BF"BASIC",INT C1"BASIC"
--------d-C0---------------------------------
INT C0 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the first four bytes
	  of the hard disk parameter table
SeeAlso: INT 41"HARD DISK 0",INT 60"Adaptec",INT C1"AMI",INT C2"AMI"
SeeAlso: INT C3"AMI",INT C4"AMI"
--------r-C1---------------------------------
INT C1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C0"BASIC",INT C2"BASIC"
--------d-C1---------------------------------
INT C1 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the second four bytes
	  of the hard disk parameter table
SeeAlso: INT 41"HARD DISK 0",INT 60"Adaptec",INT C0"AMI",INT C2"AMI"
SeeAlso: INT C3"AMI"
--------r-C2---------------------------------
INT C2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C1"BASIC",INT C3"BASIC"
--------d-C2---------------------------------
INT C2 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the third four bytes
	  of the hard disk parameter table
SeeAlso: INT 41"DISK 0",INT 60"Adaptec",INT C0"AMI",INT C1"AMI",INT C3"AMI"
--------r-C3---------------------------------
INT C3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C2"BASIC",INT C4"BASIC"
--------d-C3---------------------------------
INT C3 - AMI BIOS - DRIVE 0 DATA
Note:	this vector is used by some AMI BIOSes to store the final four bytes
	  of the hard disk parameter table
SeeAlso: INT 41"DISK 0",INT 60"Adaptec",INT C0"AMI",INT C1"AMI",INT C2"AMI"
--------r-C4---------------------------------
INT C4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C3"BASIC",INT C5"BASIC"
--------d-C4---------------------------------
INT C4 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the first four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46"HARD DISK 1",INT 64"Adaptec",INT C0"AMI",INT C5"AMI"
SeeAlso: INT C6"AMI",INT C7"AMI"
--------r-C5---------------------------------
INT C5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C4"BASIC",INT C6"BASIC"
--------d-C5---------------------------------
INT C5 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the second four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46"HARD DISK 1",INT 64"Adaptec",INT C0"AMI",INT C4"AMI"
SeeAlso: INT C6"AMI",INT C7"AMI"
--------r-C6---------------------------------
INT C6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C5"BASIC",INT C7"BASIC"
--------r-C6---------------------------------
INT C6 - APL*PLUS/PC - IDENTICAL TO INT 86
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 86"APL"
--------d-C6---------------------------------
INT C6 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the third four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46"HARD DISK 1",INT 64"Adaptec",INT C0"AMI",INT C4"AMI"
SeeAlso: INT C5"AMI",INT C7"AMI"
--------r-C7---------------------------------
INT C7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C6"BASIC",INT C8"BASIC"
--------r-C7---------------------------------
INT C7 - APL*PLUS/PC - ???
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 87"APL"
--------d-C7---------------------------------
INT C7 - AMI BIOS - DRIVE 1 DATA
Note:	this vector is used by some AMI BIOSes to store the final four bytes
	  of the second hard disk's parameter table
SeeAlso: INT 46"HARD DISK 1",INT 64"Adaptec",INT C0"AMI",INT C4"AMI"
SeeAlso: INT C5"AMI",INT C6"AMI"
--------r-C8---------------------------------
INT C8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C7"BASIC",INT C9"BASIC"
--------r-C8---------------------------------
INT C8 - APL*PLUS/PC - IDENTICAL TO INT 88
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 88/AL=00h"APL",INT 88/AL=08h"APL"
--------r-C9---------------------------------
INT C9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C8"BASIC",INT CA"BASIC"
--------r-C9---------------------------------
INT C9 - APL*PLUS/PC - ???
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 89"APL"
--------r-CA---------------------------------
INT CA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT C9"BASIC",INT CB"BASIC"
--------r-CA---------------------------------
INT CA - APL*PLUS/PC - PRINT SCREEN
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 8A"APL"
--------r-CB---------------------------------
INT CB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CA"BASIC",INT CC"BASIC"
--------r-CB---------------------------------
INT CB - APL*PLUS/PC - BEEP
Notes:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
	same as printing a ^G via INT 21/AH=02h
SeeAlso: INT 8B"APL"
--------r-CC---------------------------------
INT CC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CB"BASIC",INT CD"BASIC"
--------r-CC---------------------------------
INT CC - APL*PLUS/PC - CLEAR SCREEN MEMORY
	AX = flag
	    0000h do not save display attributes
	    0001h save attributes
Note:	STSC moved its interrupts from 86h-8Ch to C6h-CCh, but did not delete
	  the older interrupts
SeeAlso: INT 8C"APL"
--------r-CD---------------------------------
INT CD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CC"BASIC",INT CE"BASIC"
--------r-CD---------------------------------
INT CD - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-CE---------------------------------
INT CE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CD"BASIC",INT CF"BASIC"
--------r-CE---------------------------------
INT CE - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-CF---------------------------------
INT CF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CE"BASIC",INT D0"BASIC"
--------r-CF---------------------------------
INT CF - APL*PLUS/PC - DEFAULT LOW-RESOLUTION TIMER FOR QUAD MF FUNCTION
SeeAlso: INT E0"APL"
--------r-D0---------------------------------
INT D0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT CF"BASIC",INT D1"BASIC"
--------r-D0---------------------------------
INT D0 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------U-D0---------------------------------
INT D0 - [not a vector!] - NJFRERAM SIGNATURE VECTOR
Program: NJFRERAM is a resident free-memory display utility by Mike "Nifty
	  James" Blaszczak
Note:	if NJFRERAM is installed, this vector points at the signature "NJ"
Index:	installation check;NJFRERAM
--------r-D1---------------------------------
INT D1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D0"BASIC",INT D2"BASIC"
--------r-D1---------------------------------
INT D1 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D2---------------------------------
INT D2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D1"BASIC",INT D3"BASIC"
--------r-D2---------------------------------
INT D2 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D3---------------------------------
INT D3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D2"BASIC",INT D4"BASIC"
--------r-D3---------------------------------
INT D3 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------v-D3---------------------------------
INT D3 - VIRUS - "Antiexe" - RELOCATED INT 13
SeeAlso: INT 9F"VIRUS"
--------r-D4---------------------------------
INT D4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D3"BASIC",INT D5"BASIC"
--------r-D4---------------------------------
INT D4 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------O-D400-------------------------------
INT D4 O - PC-MOS/386 v5.01 - OBSOLETE FUNCTIONS
	AH = 00h and 01h
Return: nothing
Desc:	PC-MOS/386 v5.01 reports that these functions are no longer supported
	  and enters an endless loop
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
--------O-D402-------------------------------
INT D4 - PC-MOS/386 v3.0+ - GET SYSTEM CONTROL BLOCK POINTER
	AH = 02h
Return: AX = 0000h
	ES:BX -> System Control Block in V86 mode (see #3636)
	ES:EBX -> System Control Block in native mode (see #3636)
Note:	superseded by AH=26h
SeeAlso: AH=04h,AH=10h,AH=26h,AH=28h,AH=29h,AH=2Ah,INT 21/AX=3000h,INT 38

Format of PC-MOS/386 System Control Block:
Offset	Size	Description	(Table 3636)
 00h	WORD	pointer to first TCB in chain
 02h 17 BYTEs	reserved
 13h	WORD	pointer to current task's TCB
 15h	WORD	pointer to TCB of visible (console) task
--------O-D403-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET EXTENDED DIRECTORY INFORMATION
	AH = 03h
	AL = subfunction (00h get, 01h set)
	DS:(E)DX -> pathname
	ES:(E)BX -> 10-byte buffer for directory information (see #3637)
Return: CF clear if successful
	    AL = permitted access level for file (00h-03h)
	    ES:(E)BX -> modified buffer (AL=01h on entry)
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Notes:	BX/DX are used in V86 mode, EBX/EDX in native mode
	the file class cannot be changed for files because it affects the
	  encryption method, but directories can have their classes changed

Format of PC-MOS/386 directory information:
Offset	Size	Description	(Table 3637)
 00h	BYTE	reserved (0)
 01h	BYTE	file class ('A'-'Z' or 00h)
 02h	DWORD	user ID of file creator
 06h	WORD	file creation time (see #1317 at INT 21/AX=5700h)
 08h	WORD	file creation date (see #1318 at INT 21/AX=5700h)
--------O-D404-------------------------------
INT D4 - PC-MOS/386 v3.0+ - GET TASK CONTROL BLOCK
	AH = 04h
	BX = task ID or FFFFh for calling task
Return: CF clear if successful
	    ES = segment of Task Control Block (TCB) (see #3638)
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Note:	superseded by AH=27h
SeeAlso: AH=02h,AH=27h,AH=28h,AH=29h,AH=2Ah,INT 38

Format of PC-MOS/386 Task Control Block:
Offset	Size	Description	(Table 3638)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "T" = TCB
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---TCB---
 10h	WORD	TCB task ID
 12h	WORD	native context save area
 14h	WORD	start address of task
 16h	WORD	end address of task
 18h	BYTE	task priority
 19h	BYTE	task time slice
 1Ah	BYTE	"TCBWAIT" run status of task
 1Bh	BYTE	"TCBSTAT" what the task is waiting for
 1Ch	DWORD	address of polling routine
 20h	BYTE	error code from last function call
 21h 11 BYTEs	name of currently executing task
 2Ch  4 BYTEs	???
 30h	BYTE	keyboard disabled if bit 1 set
 31h	BYTE	current shift state and toggles
 32h  2 BYTEs	???
 34h	BYTE	current video mode
 35h	BYTE	current video page
 36h	BYTE	number of text columns per screen
 37h	BYTE	number of text rows per screen
 38h	WORD	length of video buffer
 3Ah	WORD	video page length
 3Ch	WORD	apge start address in video RAM
 3Eh  4 WORDs	current cursor positions for four screen pages
 46h  8 BYTEs	???
 4Eh	WORD	current cursor type
 50h	BYTE	current palette setting
 51h	BYTE	original video mode
 52h	BYTE	start CRT row (00h or 01h)
 53h	BYTE	video RAM in task active
 54h	WORD	handle of video save area
 56h	WORD	page count of video save area
 58h	WORD	segment address of video save area
 5Ah	WORD	poitner to first Task File Block (see #3641)
 5Ch	WORD	pointer to first Current Directory Block (see #3644)
 5Eh	WORD	pointer to active Current Directory Block (see #3644)
 60h	BYTE	number of drives
 61h	BYTE	current drive (0=A:, etc.)
 62h	DWORD	disk transfer address
 66h  4 BYTEs	???
 6Ah	BYTE	verify flag (nonzero = on)
 6Bh	BYTE	break flag (nonzero = on)
 6Ch	WORD	share/lock retry count
 6Eh	WORD	ticks between share/lock retries
 70h	BYTE	remote printer flags (see #3639)
 71h	BYTE	ETX/ACK delay count
 72h	WORD	spooler segment address
 74h  2 BYTEs	???
 76h  3 BYTEs	remote printer redirection for LPT1 through LPT3 (see #3640)
 79h  2 BYTEs	???
 7Bh	DWORD	offset of username in TCB
 7Fh	BYTE	current output class
 80h  7 BYTEs	protection access rights, 2 bits per class (writeable!)
 87h 122 BYTEs	???
101h	BYTE	TCB sleep downcounter value
102h 20 BYTEs	???
116h	BYTE	last scan code
	...
5D0h	DWORD	far pointer to Device Driver Terminal's entry point
5D4h	WORD	offset of logical screen
5D6h	WORD	segment of logical screen
5D8h	WORD	cursor offset within page
5DAh	BYTE	screen columns
5DBh	WORD	async port number (0000h = none)
5DDh	DWORD	physical baudrate
5E1h 19 BYTEs	reserved for Device Driver Terminal (DDT)
	...
7A6h	DWORD	far pointer to unregister calling chain

Bitfields for PC-MOS/386 remote printer flags:
Bit(s)	Description	(Table 3639)
 0	LPT1 to terminal
 1	LPT2 to terminal
 2	LPT3 to terminal
 3	escape to printer pending
 4	use XON/XOFF
 5	use ETX/ACK
 6	waiting for ACK or XON
 7	transparent printing on

(Table 3640)
Values for PC-MOS/386 remote printer redirection:
 00h	not redirected
 01h	redirected to COM1
 ...
 18h	redirected to COM24
 51h	redirected to LPT1
 52h	redirected to LPT2
 53h	redirected to LPT3

Format of PC-MOS/386 Task File Block:
Offset	Size	Description	(Table 3641)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "F" = task file block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---TFB---
 10h	WORD	segment address of next TFB
 12h	WORD	segment address of previous TFB
 14h	WORD	segment address of TFB's Global File Block (see #3643)
 16h	WORD	segment address of owner's PSP
 18h	WORD	file handle
 1Ah  3 BYTEs	???
 1Dh	DWORD	file position
 21h  4 BYTEs	???
 25h	BYTE	IOCTL flags (see #3642)
 26h  2 BYTEs	???

Bitfields for PC-MOS/386 IOCTL flags:
Bit(s)	Description	(Table 3642)
 0	stdin
 1	stdout
 2	null device
 3	clock device
 4	reserved
 5	ASCII mode instead of binary
 6	EOF encountered on input
 7	device rather than file

Format of PC-MOS/386 Global File Block:
Offset	Size	Description	(Table 3643)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "G" = global file block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---GFB---
 10h 10 BYTEs	???
 1Ah	WORD	file attribute
 1Ch	BYTE	???
 1Dh	DWORD	address of device driver
 21h	WORD	first cluster
 23h	WORD	time of last modification
 25h	WORD	date of last modification
 27h	DWORD	size of file in bytes
 2Bh 11 BYTEs	???
 36h 11 BYTEs	device name or FCB-format filename
 41h	WORD	segment address of TFB list
 43h	WORD	segment address of first RLB (see #3646) (0000h = none)
 45h	BYTE	flag: nonzero if GFB refers to character device
 46h	WORD	address of Block Device Block (see #3645)
 48h	WORD	sector of file's directory entry (see #1007)
 4Ah	WORD	high word of file's directory entry
 4Ch	WORD	ofsset of directory entry within sector

Format of PC-MOS/386 Current Directory Block:
Offset	Size	Description	(Table 3644)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "C" = current directory block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---CDB---
 10h	BYTE	drive number
 11h	BYTE	???
 12h 64 BYTEs	directory name
 52h	WORD	first directory cluster (0000h = root)

Format of PC-MOS/386 Block Device Block:
Offset	Size	Description	(Table 3645)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "B" = block device block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---BDB---
 10h	BYTE	logical drive
 11h	BYTE	unit passed to driver
 12h	WORD	sector size
 14h	BYTE	cluster mask
 15h	BYTE	cluster shift count
 16h	WORD	starting sector of first FAT
 18h	BYTE	number of FATs
 19h	WORD	number of root directories
 1Bh	WORD	sector number of first data sector (cluster 0002h)
 1Dh	WORD	number of clusters + 1 (number of highest data cluster)
 1Fh	BYTE	number of sectors in FAT
 20h	WORD	beginning root directory sector number
 22h	DWORD	device driver address
 26h	BYTE	media descriptor byte
 27h  5 BYTEs	???
 2Ch	BYTE	flag: volume > 32MB
 2Dh	BYTE	???
 2Eh	BYTE	number of sectors per cluster
 2Fh	WORD	number of clusters on device
 31h	WORD	number of free clusters (FFFFh = unknown)
 33h	WORD	root directory cluster number
 35h	WORD	pointer to alias/subst string
 37h	WORD	TCB segment address of owner (0000h = none)

Format of PC-MOS/386 Record Lock Block:
Offset	Size	Description	(Table 3646)
 00h	BYTE	signature byte "H" if allocated from system memory pool
 01h	BYTE	header block ID, "R" = record lock block
 02h	WORD	length of block in paragraphs
 04h	WORD	segment address of next header block (0000h if last)
 06h	WORD	segment address of previous header block (0000h if first)
 08h	WORD	pointer to next TCB
 0Ah	WORD	pointer to previous TCB
 0Ch	WORD	pointer to associated TCB (if applicable)
 0Eh	WORD	reserved
---RLB---
 10h	WORD	segment address of owner's PSP
 12h	WORD	segment address of Global File Block (see #3643)
 14h	WORD	segment address of owner's Task File Block (see #3641)
 16h	DWORD	file offset of locked region start
 1Ah	DWORD	length of locked region
 1Eh	WORD	owner's handle for file
--------O-D407-------------------------------
INT D4 - PC-MOS/386 v3.0+ - WAIT FOR EVENT
	AH = 07h
	AL = events to monitor (see #3647)
	BX = number of timer ticks until timeout if AL bit 1 set
	CX = bitmap of IRQs to monitor if AL bit 2 set
		(bit 0 = IRQ0 .. bit 15 = IRQ15)
	DX = port to monitor if AL bit 3 set
Return: CF clear if successful
	    AL = type of event which woke up task (see #3647)
	    CX = IRQ (if any) which awakened task
	    DX = port (if any) which awakened task
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Note:	a device driver may make this call with AL=00h, which indicates that
	  the driver is responsible for setting and clearing the TCBWAIT field
	  in the TCB.  To put task to sleep, set TCBWAIT bits 2-0 to 001; to
	  reawaken it, set bit 1 (leaving other bits unchanged)
SeeAlso: AH=04h,INT 16/AH=00h,INT 38

Bitfields for PC-MOS/386 events to monitor:
Bit(s)	Description	(Table 3647)
 0	keystroke
 1	timeout
 2	IRQ
 3	port access
 7	return status of user poll routine (other ignored if set)
--------O-D410-------------------------------
INT D4 - PC-MOS/386 v3.0+ - ENTER/LEAVE NATIVE 386 EXECUTION MODE
	AH = 10h
	AL = direction (00h return to V86 mode, 01h enter native mode)
	CX = length in bytes of Native Context Area ( >=1024 )
	DX = segment of Native Context Area
Return: CF clear if successful
	    running in desired mode at instruction following INT D4 call
	    all segment registers converted to appropriate selectors/segments
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Note:	MS-DOS calls are available in protected mode
SeeAlso: AH=11h,AH=12h,AH=13h,INT 2F/AX=1687h,INT 67/AX=DE0Ch,INT 38
--------O-D411-------------------------------
INT D4 - PC-MOS/386 v3.0+ - ALLOCATE NATIVE MODE MEMORY BLOCK
	AH = 11h
	EBX = block length in bytes
Return: CF clear if successful
	    EBX = number of bytes actually allocated
	    ES = selector for allocated block
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
Note:	the memory must be released before the program terminates
SeeAlso: AH=10h,AH=12h,INT 38
--------O-D412-------------------------------
INT D4 - PC-MOS/386 v3.0+ - FREE NATIVE MODE MEMORY BLOCK
	AH = 12h
	ES = selector for block to free
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=10h,AH=11h,AH=13h,INT 38
--------O-D413-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET ALIAS FOR SELECTOR (NATIVE MODE ONLY)
	AH = 13h
	AL = type of alias selector (00h data, 01h stack, 02h code)
	BX = selector
Return: CF clear if successful
	    AX = new selector or 0000h if BX selector not found
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=11h,AH=12h
--------O-D416-------------------------------
INT D4 - PC-MOS/386 v5.01 - SET/CLEAR IRQ RESERVATION
	AH = 16h
	AL = function (00h clear, 01h set reservation)
	CX = IRQ number
Return: AX = status
	    (0000h successful, 0001h currently reserved by another task)
SeeAlso: AH=07h,INT 14/AH=11h"PC-MOS"
--------O-D419-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET TASK ID
	AH = 19h
Return: BX = caller's task ID
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=1Dh,AH=1Eh
--------O-D41A-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET TASK PRIORITY
	AH = 1Ah
	AL = subfunction (00h read, 01h set, 02h get and set)
	BX = task ID (FFFFh for current task)
	CL = new priority value
Return: CF clear if successful
	    CL = current priority value
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=1Bh,AH=1Ch
--------O-D41B-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET TIME SLICE
	AH = 1Bh
	AL = subfunction (00h read, 01h set, 02h get and set)
	BX = task ID (FFFFh for current task) (see AH=19h)
	CL = new time slice value
Return: CF clear if successful
	    CL = current time slice value
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=1Ah,AH=1Ch
--------O-D41C-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET KEYBOARD MODE
	AH = 1Ch
	AL = subfunction (00h enable, 01h disable, 02h get mode)
	BX = task ID (FFFFh for current task)
Return: CF clear if successful
	    CL = current keyboard state
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=1Ah,AH=1Bh
--------O-D41D-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET CURRENT PROGRAM NAME
	AH = 1Dh
	BX = task ID (FFFFh for current task) (see AH=19h)
	ES:DI -> buffer for program name (see #3648)
Return: CF clear if successful
	    ES:DI buffer filled
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=19h,AH=1Eh

Format of PC-MOS/386 program name buffer:
Offset	Size	Description	(Table 3648)
 00h  8 BYTEs	filename
 08h  3 BYTEs	extension
--------O-D41E-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET CURRENT USERNAME AND SECURITY CLASS
	AH = 1Eh
	BX = task ID (FFFFh for current task)
	ES:DI -> 4-byte buffer for username
Return: CF clear if successful
	    CL = security class
		20h (' ') none
		41h-5Ah ('A'-'Z') security level
	    ES:DI buffer filled
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=19h,AH=1Dh
--------O-D41F-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET TASK PARTITION INFORMATION
	AH = 1Fh
	BX = task ID (FFFFh for current task) (see AH=19h)
Return: CF clear if successful
	    CX = start segment of task
	    DX = ending segment of task
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=2Dh
--------O-D420-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET PORT AND BAUDRATE INFORMATION
	AH = 20h
	BX = task ID (FFFFh for current task) (see AH=19h)
Return: CF clear if successful
	    CX = port number (0000h if none)
	    DI:SI = baudrate (if CX nonzero)
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: INT 14/AH=0Ch"FOSSIL"
--------O-D421-------------------------------
INT D4 - PC-MOS/386 v5.01 - REMOVE A TASK
	AH = 21h
	BX = task ID (FFFFh for current task) (see AH=19h)
Return: CF clear if successful
	    AX = ASCII percentage of System Memory Pool used
		(AH = tens digit, AL = ones digit)
	    DS,SI destroyed
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=22h
--------O-D422-------------------------------
INT D4 - PC-MOS/386 v5.01 - ADD A TASK TO THE SYSTEM
	AH = 22h
	DS:SI -> addtask data structure (see #3650)
Return: CF clear if successful
	    ES = segment address of the new task's TCB data structure
	CF set on error
	    AX = error code (see #3649)
SeeAlso: AH=21h

(Table 3649)
Values for PC-MOS/386 error code:
 08h	insufficient memory
 0Bh	invalid addtask structure format
 12h	insufficient available space in system memory pool
 1Fh	general failure
 55h	already allocated
 57h	if task already in use or invalid parameter

Format of PC-MOS/386 addtask data structure:
Offset	Size	Description	(Table 3650)
 00h	WORD	task size in KB (min 16KB)
 02h	WORD	task ID (0000h for automatic selection)
 04h	BYTE	task class (' ' or 'A'-'Z')
 05h	DWORD	-> ASCIZ name of task startup batchfile
 09h	DWORD	-> task's terminal driver (0000000h = background task)
 0Dh	WORD	task port
 0Fh	DWORD	task baud rate
 13h	DWORD	(ret) total extended memory
 17h	DWORD	(ret) number of 4K extended memory pages allocated
 1Bh	WORD	(ret) paragraphs of system memory pool allocated
 1Dh	WORD	(ret) system memory pool size in paragraphs
 1Fh	WORD	(ret) ASCII task percentage of system memory pool
 21h  3 BYTEs	reserved
--------O-D423-------------------------------
INT D4 - PC-MOS/386 v5.01 - CHANGE TERMINAL DRIVER
	AH = 23h
	BX = task ID (FFFFh for current task)
	DS:SI -> entry point of the new Device Driver Terminal
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
--------O-D424-------------------------------
INT D4 U - PC-MOS/386 v5.01 - GET OPERATING SYSTEM SERIAL NUMBER
	AH = 24h
Return: DS:DX -> '$'-terminated string containing the serial number
--------O-D425-------------------------------
INT D4 - PC-MOS/386 v5.01 - IDENTIFY LOAD ADDRESS OF DEVICE DRIVER LOCATION
	AH = 25h
	DX = driver's CS value
Return: AX = segment address of driver in system memory pool
	    (0000h if the driver is not within the system memory pool)
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
--------O-D426-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET SYSTEM CONTROL BLOCK SEGMENT/SELECTOR
	AH = 26h
Return: DX = segment/selector of the System Control Block (see #3636)
Note:	this function supersedes AH=02h
SeeAlso: AH=02h,AH=27h,AH=28h,AH=29h,AH=2Ah
--------O-D427-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET TASK CONTROL BLOCK SEGMENT/SELECTOR
	AH = 27h
	BX = task ID (FFFFh if current task) (see AH=19h)
Return: CF clear if successful
	    DX = segment/selector for the Task Control Block (see #3638)
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
Note:	this function supersedes AH=04h
SeeAlso: AH=26h,AH=28h,AH=29h,AH=2Ah
--------O-D428-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET CONTROL BLOCK DATA FROM SCB OR TCB
	AH = 28h
	BX = offset into control block at which to start reading
	CX = number of bytes to read
	DX = segment/selector of control block obtained via AH=26h or AH=27h
	ES:DI -> buffer for data
Return: CF clear if successful
	CF set on error
	    AX = error code (see also #1332 at INT 21/AH=59h/BX=0000h)
		05h access denied due to an invalid segment/selector
SeeAlso: AH=26h,AH=27h,AH=29h,AH=2Ah
--------O-D429-------------------------------
INT D4 - PC-MOS/386 v5.01 - WRITE CONTROL BLOCK DATA INTO SCB OR TCB
	AH = 29h
	BX = offset into control block at which to start writing
	CX = number of bytes to write
	DX = segment/selector of control block obtained via AH=26h or AH=27h
	DS:SI -> buffer containing data to be written
Return: CF clear if successful
	CF set on errro
	    AX = error code (see also #1332 at INT 21/AH=59h/BX=0000h)
		05h access denied due to an invalid segment/selector
Note:	 this function performs no bounds checking
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=26h,AH=27h,AH=28h,AH=2Ah
--------O-D42A-------------------------------
INT D4 - PC-MOS/386 v5.01 - SWAP CONTROL BLOCK DATA OF SCB OR TCB
	AH = 2Ah
	BX = offset into control block at which to start swap
	CX = number of bytes to swap
	DX = segment/selector of control block obtained via AH=26h or AH=27h
	DS:SI -> buffer containing new data and to receive current data
Return: CF clear if successful
	CF set on error
	    AX = error code (see also #1332 at INT 21/AH=59h/BX=0000h)
		05h access denied due to an invalid segment/selector
Note:	the interrupts are disabled during the swap to prevent corruption
SeeAlso: AH=26h,AH=27h,AH=28h,AH=29h
--------O-D42C-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET/SET SPOOLER PARAMETERS
	AH = 2Ch
	AL = function
	    00h set spooler timeout
		CX = timout value in seconds
	    01h get spooler timeout
		Return: CX = current timeout in seconds
	    02h get spooler parameters
		Return: CH = priority (00h-09h)
			CL = disposition (d, h, i, n, s)
			SI = class (a - z)
	    03h set spooler parameters
		CH = priority (00h-09h)
		CL = disposition (d, h, i, n, s)
		SI = class (a - z)
		BX = task ID (FFFFh for current task)
		DX = LPT number
Return: CF clear if successful
	CF set on error
	    AX = error code (see #1332 at INT 21/AH=59h/BX=0000h)
SeeAlso: AH=00h,AH=02h,AH=03h
--------O-D42D-------------------------------
INT D4 - PC-MOS/386 v5.01 - GET MAXIMUM TASK SIZE
	AH = 2Dh
Return: DX = maximum task size in paragraphs
	BX = start address of task space
Program: PC-MOS/386 is a multitasking/multiuser MS-DOS-compatible operating
	  system by The Software Link, Inc.
SeeAlso: AH=1Fh,AH=22h
--------r-D5---------------------------------
INT D5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D4"BASIC",INT D6"BASIC"
--------r-D5---------------------------------
INT D5 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D6---------------------------------
INT D6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D5"BASIC",INT D7"BASIC"
--------r-D6---------------------------------
INT D6 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D7---------------------------------
INT D7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D6"BASIC",INT D8"BASIC"
--------r-D7---------------------------------
INT D7 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------r-D8---------------------------------
INT D8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D7"BASIC",INT D9"BASIC"
--------r-D8---------------------------------
INT D8 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-D8---------------------------------
INT D8 - Screen Thief v1.00 - RELOCATED IRQ0
Range:	INT 78h to INT E0h, selected by commandline switch
Note:	Screen Thief relocates IRQs 0 through 7 to INT D8 to INT DF by default,
	  but may be directed via a commandline switch to use any range
	  starting at a multiple of 8 between 78h and E0h
SeeAlso: INT 08"IRQ0",INT 2D/AL=10h"Screen Thief",INT 50"DESQview"
SeeAlso: INT D9"Screen Thief"
--------r-D9---------------------------------
INT D9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D8"BASIC",INT DA"BASIC"
--------r-D9---------------------------------
INT D9 - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-D9---------------------------------
INT D9 - Screen Thief v1.00 - RELOCATED IRQ1
Range:	INT 79h to INT E1h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 09"IRQ1",INT D8"Screen Thief",INT DA"Screen Thief"
--------r-DA---------------------------------
INT DA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT D9"BASIC",INT DB"BASIC"
--------r-DA---------------------------------
INT DA - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-DA---------------------------------
INT DA - Screen Thief v1.00 - RELOCATED IRQ2
Range:	INT 7Ah to INT E2h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0A"IRQ2",INT D9"Screen Thief",INT DB"Screen Thief"
--------r-DB---------------------------------
INT DB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DA"BASIC",INT DC"BASIC"
--------r-DB---------------------------------
INT DB - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-DB---------------------------------
INT DB - Screen Thief v1.00 - RELOCATED IRQ3
Range:	INT 7Bh to INT E3h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0B"IRQ3",INT DA"Screen Thief",INT DC"Screen Thief"
--------u-DC---------------------------------
INT DC - PC/370 v4.1- - API
SeeAlso: INT 60"PC/370"
--------r-DC---------------------------------
INT DC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DB"BASIC",INT DD"BASIC"
--------r-DC---------------------------------
INT DC - STSC APL*PLUS/PC - MAY BE USED IN FUTURE RELEASES
--------H-DC---------------------------------
INT DC - Screen Thief v1.00 - RELOCATED IRQ4
Range:	INT 7Ch to INT E4h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0C"IRQ4",INT DB"Screen Thief",INT DD"Screen Thief"
--------r-DD---------------------------------
INT DD - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DC"BASIC",INT DE"BASIC"
--------r-DD---------------------------------
INT DD - STSC APL*PLUS/PC v9.0 - PLACE KEYSTROKE EVENTS IN INPUT BUFFER
	BX = where to place keystrokes
	    FFFFh insert before current buffer contents
	    0000h replace current contents
	    0001h insert after current contents
	CX = number of keystroke events to insert
	ES:SI -> data to be placed into buffer (list of WORD key codes)
	    4000h + N = normal ASCII keystroke N (N = 00h to FFh)
	    4100h + N = extended ASCII keystroke N (N = 03h to 84h)
Return: nothing
SeeAlso: INT 16/AH=05h
--------H-DD---------------------------------
INT DD - Screen Thief v1.00 - RELOCATED IRQ5
Range:	INT 7Dh to INT E5h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0D"IRQ5",INT DC"Screen Thief",INT DE"Screen Thief"
--------r-DE---------------------------------
INT DE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DD"BASIC",INT DF"BASIC"
--------r-DE---------------------------------
INT DE - APL*PLUS/PC - ???
Note:	appears to be the same as INT 16
--------H-DE---------------------------------
INT DE - Screen Thief v1.00 - RELOCATED IRQ6
Range:	INT 7Eh to INT E6h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0E"IRQ6",INT DD"Screen Thief",INT DF"Screen Thief"
--------b-DF---------------------------------
INT DF - Victor 9000/Sirius 1 - SuperBIOS
SeeAlso: INT 21/AH=EAh"NetWare"
--------r-DF---------------------------------
INT DF - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DE"BASIC",INT E0"BASIC"
--------r-DF---------------------------------
INT DF - APL*PLUS/PC - SAME AS INT 10
SeeAlso: INT 10/AH=00h,INT 10/AH=0Eh
--------H-DF---------------------------------
INT DF - Screen Thief v1.00 - RELOCATED IRQ7
Range:	INT 7Fh to INT E7h, selected by commandline switch
Note:	(see INT D8"Screen Thief")
SeeAlso: INT 0F"IRQ7",INT DE"Screen Thief"
--------r-E0---------------------------------
INT E0 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT 80"BASIC",INT DF"BASIC",INT E1"BASIC"
--------r-E0---------------------------------
INT E0 - APL*PLUS/PC - RESTIME HIGH-RESOLUTION TIMER FOR QUAD MF FUNCTION
SeeAlso: INT CF"APL"
--------v-E0---------------------------------
INT E0 - VIRUS - "Micro-128" - ???
Note:	Micro-128 also overwrites the upper half of the interrupt table
SeeAlso: INT 9E"VIRUS",INT F1"VIRUS"
----------E0---------------------------------
INT E0 - DeskMate (Tandy) - DESK EXECUTIVE API
	AX = function code (numerous)
	parameters passed in BX, DX, ES, DI, and/or BP
Return: AX = return from function
Program: DeskMate is a proprietary GUI from Tandy distributed with several
	  models of the Tandy 1000's, 2500's, 3000's, and laptops.  Retail
	  and runtime versions also exist.  Some Tandy's are designed to
	  boot directly into DeskMate.
SeeAlso: INT 15/AX=7002h,INT E1"DeskMate"
--------O-E0---------------------------------
INT E0 - CP/M-86, Concurrent CP/M, DR Multiuser DOS - FUNCTION CALLS
	CL = function number (see #3651,#3652)
	DS,DX contain parameter(s):
		DL = byte parameter
		DX = word parameter
		DS:DX -> structure
Return: as appropriate for function:
		AL = byte result
		AX = word
		ES:AX -> structure (and BX=ES)
	CX is often the error code (see #3653)
Notes:	several functions are covered in more detail in following entries
	most of these calls are also supported by Digital Research's DOS Plus
	  v2.1; the unsupported functions are 26h,29h-2Bh,3Ah,3Dh-62h,71h-8Ch,
	  90h-92h,94h-97h,9Bh-ABh, and AEh-FFh
SeeAlso: INT 21/AX=4459h,INT 21/AH=E0h"DOS Plus"

(Table 3651)
Values for CP/M-86,DR Multiuser DOS function number:
 00h	terminate calling process (see INT E0/CL=00h,INT 21/AH=00h)
 01h	read a character (see INT E0/CL=01h,INT 21/AH=01h)
 02h	write character to default console (see INT E0/CL=02h,INT 21/AH=02h)
 03h	read character from default AUX (see INT E0/CL=03h,INT 21/AH=03h)
 04h	write character to default AUX (see INT E0/CL=04h,INT 21/AH=04h)
 05h	write character to default list device
	(see INT E0/CL=05h,INT 21/AH=05h)
 06h	perform raw I/O on default console (see INT E0/CL=06h,INT 21/AH=06h)
 07h	return default AUX input status (see INT E0/CL=07h)
 08h	return default AUX output status (see INT E0/CL=08h)
 09h	write string to default console (see INT E0/CL=09h,INT 21/AH=09h)
 0Ah	read string from default console (see INT E0/CL=0Ah,INT 21/AH=0Ah)
 0Bh	return default console input status (see INT E0/CL=0Bh,INT 21/AH=0Bh)
 0Ch	get BDOS release ID (see INT E0/CL=0Ch)
 0Dh	reset all disk drives (see also INT 21/AH=0Dh)
 0Eh	set default drive (see also INT 21/AH=0Eh"DOS 1+")
 0Fh	open file via FCB (see also INT 21/AH=0Fh,#1000)
 10h	close file via FCB (see also INT 21/AH=10h)
 11h	search for first matching file with FCB (see also INT 21/AH=11h)
 12h	search for next matching file with FCB (see also INT 21/AH=12h)
 13h	delete file via FCB (see also INT 21/AH=13h)
 14h	sequential read via FCB (see also INT 21/AH=14h)
 15h	sequential write via FCB (see also INT 21/AH=15h)
 16h	create file via FCB (see also INT 21/AH=16h)
 17h	rename file via FCB (see also INT 21/AH=17h)
 18h	get bit map of logged drives
 19h	get default drive (see also INT 21/AH=19h)
 1Ah	set DMA address offset
 1Bh	get default disk allocation vector (see also INT 21/AH=1Bh)
 1Ch	set default drive to read-only
 1Dh	get bit map of read-only drives
 1Eh	set file attributes via FCB (see also INT 21/AX=4301h)
 1Fh	get address of disk parameter block (see also INT 21/AH=1Fh)
 20h	get/set default user number
 21h	read random record via FCB (see also INT 21/AH=21h)
 22h	write random record via FCB (see also INT 21/AH=22h)
 23h	compute file size with FCB (see also INT 21/AH=23h)
 24h	get FCB random record number (see also INT 21/AH=24h)
 25h	reset specified drives
 26h	access specified drives (not in DR DOS Plus v2.1)
 27h	free specified drives
 28h	write random with FCB, zero fill (see also INT 21/AH=28h)
 2Ah	lock records in FCB file (see also INT 21/AH=5Ch)
 2Bh	unlock records in FCB file (see also INT 21/AH=5Ch)
 2Ch	set BDOS multisector count
 2Dh	set BDOS error mode
 2Eh	get free space on disk
 2Fh	load, initialize, and jump to process ("chain process")
	(see INT E0/CL=2Fh,INT 21/AH=4Bh)
 30h	flush write-deferred buffers
 31h	get/set system variable (DOS Plus v2.1)
 32h	call BIOS (XIOS) character routine (see #3652)
 33h	set DMA address segment
 34h	get DMA buffer address
 35h	CP/M-86 allocate maximum memory (see INT E0/CL=35h)
 36h	allocate maximum memory at specified segment (see INT E0/CL=36h)
 37h	CP/M-86 allocate memory segment (see INT E0/CL=37h,INT 21/AH=48h)
 38h	allocate memory at specified segment (see INT E0/CL=38h)
 39h	CP/M-86 free specified memory segment (see INT E0/CL=39h,INT 21/AH=49h)
 3Ah	CP/M-86 free all memory (not in DOS Plus v2.1) (see INT E0/CL=3Ah)
 3Bh	load .CMD file into memory (see INT E0/CL=3Bh)
 3Ch	(DOS Plus v2.1) call RSX program
 40h	(DR-NET, REAL/32) log on a server (see INT E0/CL=40h)
 41h	(DR-NET, REAL/32) log off a server (see INT E0/CL=41h)
 42h	(DR-NET) send a message
 43h	(DR-NET) receive a message
 44h	(DR-NET, REAL/32) get network status (see INT E0/CL=44h)
 45h	(DR-NET, REAL/32) get requestor configuration table (see INT E0/CL=45h)
 46h	(DR-NET) set compatibility attributes
 47h	(DR-NET, REAL/32) get server configuration table (see INT E0/CL=47h)
 48h	(DR-NET, REAL/32) set network error mode (see INT E0/CL=48h)
 49h	(DR-NET, REAL/32) attach network
 4Ah	(DR-NET, REAL/32) detach network
 4Bh	(DR-NET, REAL/32) set default password
 4Ch	(DR-NET, REAL/32) get-set long timeout
 4Dh	(DR-NET, REAL/32) get parameter table
 4Fh	(REAL/32) get extended network error
 50h	(DR-NET, REAL/32) get network information
 53h	get current time (see also INT 21/AH=2Ch)
 54h	set current time (see also INT 21/AH=2Dh)
 55h	get binary system date (see also INT 21/AH=2Ah)
 56h	set system date (see also INT 21/AH=2Bh"DATE")
 57h	allocate system flag
 58h	deallocate system flag
 59h	reserve memory in global area (see INT E0/CL=59h)
 5Ah	lock physical drive
 5Bh	unlock physical drive
 5Ch	search path for executable file
 5Dh	load and execute command (see also INT 21/AH=4Bh)
 5Eh	get/set process exit code
 5Fh	set country information
 60h	get country information
 63h	truncate FCB file (see also INT 21/AH=28h)
 64h	create/update directory label
 65h	get directory label
 66h	get FCB date stamp and password mode
 67h	write extended FCB
 68h	set system date and time
 69h	get system date and time in binary
 6Ah	establish password for file access
 6Bh	get OS serial number
 6Ch	(DOS Plus v2.1) get/set program return code
 6Dh	get/set console mode
 6Eh	get/set string delimiter
 6Fh	write block to default console
 70h	write block to default list device
 71h	execute DOS-compatible function (see INT E0/CL=71h)
 74h	set FCB time and date stamps
 80h	allocate memory
 82h	deallocate memory
 83h	poll I/O device
 84h	wait on system flag
 85h	set system flag
 86h	create message queue (see INT E0/CL=86h)
 87h	open message queue (see INT E0/CL=87h)
 88h	delete message queue
 89h	read from message queue (see INT E0/CL=89h)
 8Ah	conditionally read from message queue (see INT E0/CL=8Ah)
 8Bh	write to message queue (see INT E0/CL=8Bh)
 8Ch	conditionally write to message queue (see INT E0/CL=8Ch)
 8Dh	delay calling process
 8Eh	call process dispatcher (yield CPU) (see INT E0/CL=8Eh)
 8Fh	terminate calling process (same as function 00h)
 90h	create a process
 91h	set calling process' priority (see INT E0/CL=91h)
 92h	attach to default console
 93h	detach from default console (see INT E0/CL=93h)
 94h	(REAL/32) set the process' default console
 95h	assign default console to process
 96h	interpret and execute commandline
 97h	resident procedure library
 98h	parse ASCII string into FCB (see also INT 21/AH=29h)
 99h	return default console
 9Ah	get address of system data (SYSDAT)
 9Bh	get system time and date
 9Ch	return calling process' descriptor
 9Dh	terminate process by name or PD address
 9Eh	attach to default list device
 9Fh	detach from default list device
 A0h	select default list device
 A1h	conditionally attach to default list device
 A2h	conditionally attach to default console
 A3h	get OS version number
 A4h	get default list device
 A5h	attach to default AUX (see INT E0/CL=A5h)
 A6h	detach from default AUX (see INT E0/CL=A6h)
 A7h	conditionally attach to default AUX (see INT E0/CL=A7h)
 A8h	set default AUX (see INT E0/CL=A8h)
 A9h	return default AUX (see INT E0/CL=A9h)
 ACh	read block from default AUX (see INT E0/CL=ACh)
 ADh	(DOS Plus v2.1) write block to default AUX (see INT E0/CL=ADh)
 B0h	configure default AUX (see INT E0/CL=B0h)
 B1h	get/set device control parameters (see INT E0/CL=B1h)
 B2h	send Break through default AUX (see INT E0/CL=B2h)
 B3h	allocate physical memory
 B4h	free physical memory
 B5h	map physical memory
 B6h	nondestructive message queue read
 B7h	timed wait on system flag
 B8h	get/set I/O port mapping
 B9h	set list device timeout
 BAh	set AUX timeout value
 BBh	execute XIOS service
 BDh	(DR Multiuser DOS) delay (see INT E0/CL=BDh)
 FFh	return 80386 to native mode
SeeAlso: #3652,#3653

(Table 3652)
Values for DOS Plus v2.1 XIOS functions:
 00h	terminate program
 01h	???
 02h	check for console input status
 03h	read character from console
 04h	write character to console
 05h	write character to list device
 06h	write character to auxiliary device
 07h	read character from auxiliary device
 0Fh	get list device status
 10h-14h reserved
 15h	device initialization
 16h	check console output status
 17h-7Fh reserved
---BBC Acorn---
 80h	get XIOS version
 81h	get Tube semaphore
 82h	release Tube semaphore
 83h	select text/graphics
 84h	update B&W graphics rectangle
 85h	update color graphics rectangle
 86h	get/release/update mouse
 87h	get system error info
 88h	entry in CLOCK called by WatchDog RSP
 89h	BBC OSBYTE function
 8Ah	BBC OSWORD function
SeeAlso: #3651

(Table 3653)
Values for DR Multiuser DOS Error Return Code:
 00h	no error
 01h	system call not implemented
 02h	illegal system call number
 03h	cannot find memory
 04h	illegal flag number
 05h	flag overrun
 06h	flag underrun
 07h	no unused Queue Descriptors
 08h	no free queue buffer
 09h	cannot find queue
 0Ah	queue in use
 0Ch	no free Process Descriptors
 0Dh	no queue access
 0Eh	empty queue
 0Fh	full queue
 10h	CLI queue missing
 11h	no 8087 in system
 12h	no unused Memory Descriptors
 13h	illegal console number
 14h	no Process Descriptor match
 15h	no console match
 16h	no CLI process
 17h	illegal disk number
 18h	illegal filename
 19h	illegal filetype
 1Ah	character not ready
 1Bh	illegal Memory Descriptor
 1Ch	bad return from BDOS load
 1Dh	bad return from BDOS read
 1Eh	bad return from BDOS open
 1Fh	null command
 20h	not owner of resource
 21h	no CSEG in load file
 22h	process Descriptor exists on Thread Root
 23h	could not terminate process
 24h	cannot attach to process
 25h	illegal list device number
 26h	illegal password
 28h	external termination occurred
 29h	fixup error upon load
 2Ah	flag set ignored
 2Bh	illegal auxilliary device number
SeeAlso: #3651
--------O-E0----CL00-------------------------
INT E0 - REAL/32 - "P_TERMCPM" - TERMINATE CALLING PROCESS
	CL = 00h
Return: AX = error code
	    FFFFh on failure
	may destroy SI,DI???
Program: REAL/32 is the descendant of IMS Multiuser DOS, which in turn is
	  derived from DR Multiuser DOS and its predecessors (Concurrent DOS,
	  etc.)
Note:	sets the exit code (ERRORLEVEL) to 00h
SeeAlso: INT 21/AH=00h
--------O-E0----CL01-------------------------
INT E0 - REAL/32 - "C_READ" - FETCH CHARACTER FROM THE DEFAULT CONSOLE
	CL = 01h
Return: AX = character
	may destroy SI,DI???
Notes:	this function echos the character to the screen, expanding Tab
	  characters to the next multiple of eight columns; Ctrl-C is
	  ignored if the calling process can not terminate
	the calling process is suspended until a character is available; if
	  the caller does not own the console, it is suspended until it
	  can attach to the console
SeeAlso: INT E0/CL=02h,INT E0/CL=06h,INT 21/AH=01h
--------O-E0----CL02-------------------------
INT E0 - REAL/32 - "C_WRITE" - WRITE CHARACTER TO DEFAULT CONSOLE
	CL = 02h
	DX = character
Return: nothing
	may destroy SI,DI???
Note:	Tab characters are expanded to blanks up to the next multiple of
	  eight columns
SeeAlso: INT E0/CL=01h,INT E0/CL=06h,INT 21/AH=02h
--------O-E0----CL03-------------------------
INT E0 - DR Multiuser DOS - "A_READ" - READ CHARACTER FROM DEFAULT AUX DEVICE
	CL = 03h
Return: AL = ASCII character
	may destroy SI,DI???
Notes:	A_READ reads the next 8-bit character from the logical auxilliary
	  input device (AUXn:); control is not returned to the calling
	  process until a character has been read.
	if another process owns AUX, this call blocks until the device becomes
	  available
	this function is also supported by REAL/32
SeeAlso: INT 21/AH=03h,INT E0/CL=04h,INT E0/CL=07h,INT E0/CL=A5h,INT E0/CL=ACh
--------O-E0----CL04-------------------------
INT E0 - DR Multiuser DOS - "A_WRITE" - WRITE CHARACTER TO DEFAULT AUX DEVICE
	CL = 04h
	DL = BYTE to write
Return: nothing
	may destroy SI,DI,DH???
Note:	if another process owns AUX, this call blocks until the device becomes
	  available
SeeAlso: INT 21/AH=04h,INT E0/CL=03h,INT E0/CL=08h,INT E0/CL=A5h,INT E0/CL=ADh
--------O-E0----CL05-------------------------
INT E0 - REAL/32 - "L_WRITE" - WRITE CHARACTER TO DEFAULT LIST DEVICE
	CL = 05h
	DL = char to write
Return: nothing
	may destroy SI,DI???
Note:	if another process owns the list device, this call blocks until the
	  device becomes available
SeeAlso: INT 21/AH=05h
--------O-E0----CL06-------------------------
INT E0 - REAL/32 - "C_RAWIO" - PERFORM RAW I/O WITH DEFAULT CONSOLE
	CL = 06h
	DL = mode describing the operation to be performed
	    FFh get console input/status
	    FEh get console status
	    FDh get console input (blocking)
	    else output DL to the console as a character
Return: AX = returned value
	    for DL = FFh, the character or 00h if none available
	    for DL = FEh, 00h if no characters available, FFh if any available
	    for DL = FDh, the character read from the console
	    else AX = 0000h
	may destroy SI,DI???
Notes:	during raw I/O, the special characters ^C, ^O, ^P, and ^S are not
	  interpreted, but are passed through
	if the virtual console is in ^S mode and the owning process calls
	  this function, the ^S state is cleared
SeeAlso: INT E0/CL=01h,INT E0/CL=02h,INT 21/AH=06h
--------O-E0----CL07-------------------------
INT E0 - DR Multiuser DOS - "A_STATIN" - GET INPUT STATUS OF AUX DEVICE
	CL = 07h
Return: AL = status
	    00h not ready
	    FFh character available
Desc:	determine whether the current AUX device has input available
SeeAlso: INT E0/CL=03h,INT E0/CL=08h
--------O-E0----CL08-------------------------
INT E0 - DR Multiuser DOS - "A_STATOUT" - GET OUTPUT STATUS OF AUX DEVICE
	CL = 08h
Return: AL = status
	    00h not ready
	    FFh ready for output
Desc:	determine whether the current AUX device is able to accept more output
SeeAlso: INT E0/CL=04h,INT E0/CL=07h
--------O-E0----CL09-------------------------
INT E0 - REAL/32 - "C_WRITESTR" - WRITE STRING TO DEFAULT CONSOLE
	CL = 09h
	DS:DX -> string
Return: nothing
	may destroy SI,DI,DS???
Note:	the string terminated with a '$' character (24h) by default; the
	  terminator may be changed with C_DELIMIT
	tabs are expanded to the next multiple of eight columns
--------O-E0----CL0A-------------------------
INT E0 - REAL/32 - "C_READSTR" - READ STRING FROM DEFAULT CONSOLE
	CL = 0Ah
	DS:DX -> buffer for string (see #3654)
Return: nothing

Format of REAL/32 "C_READSTR" buffer:
Offset	Size	Description	(Table 3654)
 00h	BYTE	maximum number of characters buffer can hold
 01h	BYTE	actual number of buffers read
 02h  N BYTEs	input line
--------O-E0----CL0B-------------------------
INT E0 - REAL/32 - "C_STAT" - RETURN DEFAULT CONSOLE INPUT STATUS
	CL = 0Bh
Return: AX = status
	    0000h no characters ready
	    0001h character available
	may destroy SI,DI???
Note:	after setting bit 0 of the console mode word with C_MODE, this function
	  will only return AX=0001h when the user presses Ctrl-C.
--------O-E0----CL0C-------------------------
INT E0 - REAL/32 - "S_BDOSVER" - GET BDOS VERSION
	CL = 0Ch
Return: AX = version (see #3655)
	may destroy SI,DI???

(Table 3655)
Values for REAL/32 BDOS version:
 1432h	- DR Concurrent PC DOS Version 3.2
 1441h	- DR Concurrent DOS Version 4.1
 1450h	- DR Concurrent DOS/XM Version 5.0
 1463h	- DR Multiuser DOS Release 5.0
 1465h	- DR Multiuser DOS Release 5.01
 1466h	- DR Multiuser DOS Release 5.1, IMS Multiuser DOS Enhanced Release 5.1
 1467h	- IMS Multiuser DOS Version 7.0, 7.1
 1468h	- IMS REAL/32 Version 7.50, 7.51
 1469h	- IMS REAL/32 Version 7.52, 7.53
 14??h	- IMS REAL/32 Version 7.6
--------O-E0----CL2F-------------------------
INT E0 - REAL/32 - "P_CHAIN" - CHAIN PROCESS
	CL = 2Fh
	[DTA] = ASCIZ command line for process to start
Return: AX = return code
	    0000h successful
	    FFFFh failed
	may destroy SI,DI???
--------O-E0----CL35-------------------------
INT E0 R - REAL/32 - "MC_MAX" - CP-M/86 ALLOCATE MAXIMUM MEMORY
	CL = 35h
	DS:DX -> MCB (see #3656)
Return: AX = status
	may destroy SI,DI,DS???
SeeAlso: INT E0/CL=39h

Format of REAL/32 MCB (Memory Control Block):
Offset	Size	Description	(Table 3656)
 00h	WORD	segment address of memory block
 02h	WORD	length of block in paragraphs
 04h	BYTE	reserved (0)
--------O-E0----CL36-------------------------
INT E0 R - REAL/32 - "MC_ABSMAX" - ALLOCATE MAXIMUM MEMORY SEGMENT ABSOLUTE
	CL = 36h
	DS:DX -> MCB (see #3656)
Return: AX = status
	may destroy SI,DI,DS???
SeeAlso: INT E0/CL=39h
--------O-E0----CL37-------------------------
INT E0 R - REAL/32 - "MC_ALLOC" - CP-M/86 ALLOCATE MEMORY SEGMENT
	CL = 37h
	DS:DX -> MCB (see #3656)
Return: AX = status
	may destroy SI,DI,DS???
SeeAlso: INT E0/CL=39h
--------O-E0----CL38-------------------------
INT E0 R - REAL/32 - "MC_ABSALLOC" - ALLOCATE MEMORY SEGMENT ABSOLUTE
	CL = 38h
	DS:DX -> MCB (see #3656)
Return: AX = status
	may destroy SI,DI,DS???
SeeAlso: INT E0/CL=39h
--------O-E0----CL39-------------------------
INT E0 R - REAL/32 - "MC_FREE" - CP-M/86 FREE SPECIFIED MEMORY SEGMENT
	CL = 39h
	DS:DX -> MCB (see #3656)
Return: AX = status
	may destroy SI,DI,DS???
SeeAlso: INT E0/CL=3Ah
--------O-E0----CL3A-------------------------
INT E0 R - REAL/32 - "MC_ALLFREE" - CP-M/86 FREE ALL MEMORY
	CL = 3Ah
Return: nothing???
Desc:	release all of the calling process's memory except the User Data Area
SeeAlso: INT E0/CL=39h
--------O-E0----CL3B-------------------------
INT E0 u - REAL/32 - "P_LOAD" - LOAD .CMD FILE INTO MEMORY
	CL = 3Bh
	???
Return: ???
Note:	IMS does not document the details of this call because .CMD files are
	  supported for backward compatibility only
--------O-E0----CL40-------------------------
INT E0 - REAL/32 - "N_LOGON" - LOG ONTO A SERVER
	CL = 40h
	DS:DX -> LPB !!!
Return: AX = status (0000h,00FFh,07FFh,0DFFh,0EFFh,FFFFh) (see #3657)
	may destroy SI,DI,DS???

(Table 3657)
Values for REAL/32 "N_LOGON" status:
 0000h	successful
 00FFh	server could not create shadow process
 07FFh	incorrect password
 0CFFh	not logged into specified server
 0DFFh	process already logged onto 16 servers,
	LPB process not attached to network
 0EFFh	physical transmission prevented message or response from getting thru
	network error during logoff
 FFFFh	calling process not attached to network
--------O-E0----CL41-------------------------
INT E0 - REAL/32 - "N_LOGON" - LOG OFF A SERVER
	CL = 41h
	DS:DX -> LPB !!!
Return: AX = status (0000h,0CFFh,0DFFh,0EFFh,FFFFh) (see #3657)
	may destroy SI,DI,DS???
--------O-E0----CL44-------------------------
INT E0 - REAL/32 - "N_STAT" - GET NETWORK STATUS
	CL = 44h
Return: AX = network status or 0FFFh on error
	    bit 8: calling process is attached to network
	may destroy SI,DI???
--------O-E0----CL45-------------------------
INT E0 - REAL/32 - "N_RCT" - GET REQUESTOR CONFIGURATION TABLE
	CL = 45h
	DS:DX -> RCT Control Block !!!
Return: AX = status or error code (see #3658,#3657)
	may destroy SI,DI,DS???
SeeAlso: INT E0/CL=47h

(Table 3658)
Values for REAL/32 "N_RCT" status:
 0000h	successful
 0001h	invalid local device
 0002h	invalid remote device
 0003h	no queue entry space
--------O-E0----CL47-------------------------
INT E0 - REAL/32 - "N_SCT" - GET SERVER CONFIGURATION TABLE
	CL = 47h
	DS:DX -> 112-byte buffer for Server Configuration Table !!!
Return: AX = status (0000h successful, else error code)
	may destroy SI,DI,DS???
Note:	the first byte of the SCT buffer is set to the desired server number
	  prior to calling this function
SeeAlso: INT E0/CL=45h
--------O-E0----CL48-------------------------
INT E0 - REAL/32 - "N_ERRMODE" - SET NETWORK ERROR MODE
	CL = 48h
	DL = new error mode
	    FFh return error in registers AX,BX,CX
	    FEh display message and return error
	    FDh display message and abort (default)
Return: CX = error code (0000h successful, FFFFh failed)
	may destroy SI,DI???	
Desc:	specify how the REAL/32 Net Server responds to error numbers 0CFFh,
	  0DFFh, and 0EFFh (see #3657)
--------O-E0----CL59-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "S_MEMORY" - RESERVE MEMORY IN GLOBAL AREA
	CL = 59h
	DX = size in bytes
Return: AX = status
	    FFFFh failed
	    other successful
		ES:BX -> reserved memory
--------O-E0----CL71-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - EXECUTE DOS-COMPATIBLE FUNCTIONS
	CL = 71h
	DS:DX -> parameter block (see !!!)
Return: AX = status
--------O-E0----CL86-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_MAKE" - CREATE MESSAGE QUEUE
	CL = 86h
	DS:DX -> queue descriptor (see #3659)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #3653)
SeeAlso: INT E0/CL=87h

Format of DR Multiuser DOS queue descriptor:
Offset	Size	Description	(Table 3659)
 00h  2 WORDs	internal use, initialize to zeros
 04h	WORD	flags
 06h  8 BYTEs	queue name
 0Eh	WORD	length of message
 10h	WORD	number of messages
 12h  4 WORDs	internal use, initialize to zeros
 1Ah	WORD	offset in system area of buffer for messages
--------O-E0----CL87-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_OPEN" - OPEN MESSAGE QUEUE
	CL = 87h
	DS:DX -> queue parameter block (see #3660)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #3653)
SeeAlso: INT E0/CL=86h,INT E0/CL=89h

Format of DR Multiuser DOS queue parameter block:
Offset	Size	Description	(Table 3660)
 00h	WORD	internal use, initialize to zero
 02h	WORD	queue ID (set by INT E0/CL=87h)
 04h	WORD	internal use, initialize to zero
 06h	WORD	offset of queue message buffer
 08h  8 BYTEs	queue name
--------O-E0----CL89-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_READ" - READ MESSAGE QUEUE
	CL = 89h
	DS:DX -> queue parameter block (see #3660)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #3653)
SeeAlso: INT E0/CL=87h,INT E0/CL=8Ah,INT E0/CL=8Bh
--------O-E0----CL8A-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_CREAD" - CONDITIONALLY READ MSG QUEUE
	CL = 8Ah
	DS:DX -> queue parameter block (see #3660)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #3653)
SeeAlso: INT E0/CL=87h,INT E0/CL=89h,INT E0/CL=8Ch
--------O-E0----CL8B-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_WRITE" - WRITE MESSAGE QUEUE
	CL = 8Bh
	DS:DX -> queue parameter block (see #3660)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #3653)
SeeAlso: INT E0/CL=89h,INT E0/CL=8Ch
--------O-E0----CL8C-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "Q_CWRITE" - CONDITIONALLY WRITE MSG QUEUE
	CL = 8Ch
	DS:DX -> queue parameter block (see #3660)
Return: AX = status (0000h success, FFFFh failure)
	CX = error code (see #3653)
SeeAlso: INT E0/CL=8Ah,INT E0/CL=8Bh
--------O-E0----CL8E-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "P_DISPATCH" - CALL DISPATCHER
	CL = 8Eh
	DX = FFFFh (optional) to force dispatch
Return: nothing
Desc:	allow other processes of the same or higher priority to run if they
	  are ready
Note:	if DX=FFFFh, a dispatch is forced even if no other process is ready
SeeAlso: INT E0/CL=91h,INT 15/AX=1000h,INT 2F/AX=1680h
--------O-E0----CL91-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "P_PRIORITY" - SET PROCESS PRIORITY
	CL = 91h
	DL = new priority (00h highest to FFh lowest)
Return: nothing
Note:	sets priority of calling process; transient processes are initialized
	  to priority C8h
SeeAlso: INT E0/CL=8Eh
--------O-E0----CL93-------------------------
INT E0 - ConcCP/M,DR Multiuser DOS - "C_DETACH" - DETACH FROM DEFAULT CONSOLE
	CL = 93h
Return: AX = status
	    0000h successfully detached
	    FFFFh detach failed
SeeAlso: INT E0/CL=A6h
--------O-E0----CLA5-------------------------
INT E0 - DR Multiuser DOS - "A_ATTACH" - ATTACH AUX DEVICE
	CL = A5h
Return: nothing
Desc:	attaches the default auxiliary device to the calling process unless
	  it is already attached to another process, in which case the call
	  blocks until the device becomes available
Note:	this call should be used before attempting to read or write from
	  the AUX device; however, the I/O calls internally call this function
	  to ensure device ownership
SeeAlso: INT E0/CL=03h,INT E0/CL=04h,INT E0/CL=A6h,INT E0/CL=A7h,INT E0/CL=A8h
SeeAlso: INT E0/CL=ACh,INT E0/CL=ADh,INT E0/CL=B0h
--------O-E0----CLA6-------------------------
INT E0 - DR Multiuser DOS - "A_DETACH" - DETACH FROM AUX DEVICE
	CL = A6h
Return: AX = status
	    0000h successfully detached
	    FFFFh detach failed
	CX = error code
SeeAlso: INT E0/CL=93h,INT E0/CL=A5h,INT E0/CL=A7h
--------O-E0----CLA7-------------------------
INT E0 - DR Multiuser DOS - "A_CATTACH" - CONDITIONALLY ATTACH TO AUX DEVICE
	CL = A7h
Return: AX = status
	    0000h attached
	    FFFFh unable to attach
Desc:	attaches the default auxiliary device to the calling process if it is
	  available
Note:	does not block if the device is already in use
SeeAlso: INT E0/CL=A5h,INT E0/CL=A6h,INT E0/CL=A8h,INT E0/CL=B0h
--------O-E0----CLA8-------------------------
INT E0 - DR Multiuser DOS - "A_SET" - SET DEFAULT AUX DEVICE NUMBER
	CL = A8h
	DL = auxiliary device number
Return: AX = status
	    0000h successful
	    FFFFh failed
	CX = error code
Desc:	specify which physical device will become AUX
SeeAlso: INT E0/CL=A5h,INT E0/CL=A9h
--------O-E0----CLA9-------------------------
INT E0 - DR Multiuser DOS - "A_GET" - GET DEFAULT AUX DEVICE NUMBER
	CL = A9h
Return: AL = current default auxiliary device number
Desc:	determine which physical device is currently AUX
SeeAlso: INT E0/CL=A8h
--------O-E0----CLAC-------------------------
INT E0 - DR Multiuser DOS - "A_READBLK" - READ STRING FROM AUX DEVICE
	CL = ACh
	DS:DX -> character control block (CHCB) (see #3661)
Return: AX = number of characters read
Desc:	read characters from the default auxiliary (AUXn:) device into a buffer
	  until the buffer is full or the device is no longer ready
Notes:	if the device is initially not ready, blocks until at least one
	  character has been read
	if another process owns AUX, this call blocks until the device becomes
	  available
SeeAlso: INT E0/CL=03h,INT E0/CL=A5h,INT E0/CL=ADh

Format of DR Multiuser DOS character control block (CHCB):
Offset	Size	Description	(Table 3661)
 00h	DWORD	pointer to character buffer
 04h	WORD	length of character buffer
--------O-E0----CLAD-------------------------
INT E0 - DR Multiuser DOS - "A_WRITEBLK" - WRITE STRING TO AUX DEVICE
	CL = ADh
	DS:DX -> character control block (see #3661)
Return: AX = number of characters written
Note:	does not return until at least one character has been written
SeeAlso: INT E0/CL=04h,INT E0/CL=A5h,INT E0/CL=ACh
--------O-E0----CLB0-------------------------
INT E0 - DR Multiuser DOS - "A_CONFIG" - GET/SET AUX DEVICE PARAMETERS
	CL = B0h
	DX:DX -> AUX device parameter block (see #3662)
Return: AX = status
	    0000h successful
		parameter block updated
	    FFFFh failed
		CX = error code
SeeAlso: INT E0/CL=A5h,INT E0/CL=B1h

Format of DR Multiuser DOS AUX device parameter block:
Offset	Size	Description	(Table 3662)
 00h	BYTE	function (00h get, 01h set)
 01h	BYTE	baud rate (see #3664) FFh = don't change/unknown
 02h	BYTE	parity (see #3663)
 03h	BYTE	stop bits (00h one, 01h 1.5, 02h two, FFh unknown/don't change)
 04h	BYTE	data bits (05h-08h or FFh unknown/don't change)
 05h	BYTE	handshake (00h none, 01h DTS/DSR, 02h RTS/CTS, 04h XON/XOFF,
		FFh unknown/don't change)
 06h	BYTE	XON character, FFh unknown/don't change
 07h	BYTE	XOFF character, FFh unknown/don't change

(Table 3663)
Values for DR Multiuser DOS AUX parity:
 00h	none
 01h	odd
 02h	none
 03h	even
 04h	stick parity bit
 FFh	don't change/unknown
SeeAlso: #3662,#3664

(Table 3664)
Values for DR Multiuser DOS AUX baud rate:
 00h	50 baud
 01h	62.5 baud
 02h	75 baud
 03h	110 baud
 04h	134.5 baud
 05h	150 baud
 06h	200 baud
 07h	300 baud
 08h	600 baud
 09h	1200 baud
 0Ah	1800 baud
 0Bh	2000 baud
 0Ch	2400 baud
 0Dh	3600 baud
 0Eh	4800 baud
 0Fh	7200 baud
 10h	9600 baud
 11h	19200 baud
 12h	38400 baud
 13h	56000 baud
 14h	76800 baud
 15h	115200 baud
SeeAlso: #3662,#3663
--------O-E0----CLB1-------------------------
INT E0 - DR Multiuser DOS - "A_CONTROL" - GET/SET AUX CONTROL PARAMETERS
	CL = B1h
	DS:DX -> AUX device control block (see #3665)
Return: AX = status
	    0000h successful
		control block updated
	    FFFFh failed
		CX = error code
SeeAlso: INT E0/CL=B0h,INT E0/CL=B2h

Format of DR Multiuser DOS AUX device control block:
Offset	Size	Description	(Table 3665)
 00h	BYTE	function (00h get, 01h set)
 01h	BYTE	DTR state (00h low, 01h high, FFh unknown/don't change)
 02h	BYTE	RTS state (00h low, 01h high, FFh unknown/don't change)
 03h	BYTE	DSR state (00h low, 01h high, FFh unknown/don't change)
 04h	BYTE	CTS state (00h low, 01h high, FFh unknown/don't change)
 05h	BYTE	DCD state (00h low, 01h high, FFh unknown/don't change)
 06h	BYTE	RI state (00h inactive, 01h active, FFh unknown/don't change)
--------O-E0----CLB2-------------------------
INT E0 - DR Multiuser DOS - "A_BREAK" - SEND BREAK TO AUX DEVICE
	CL = B2h
	DX = duration of break in system ticks (0001h-FFFFh)
Return: AX = status
	    0000h successful
		break signal completed
	    FFFFh failed
		CX = error code
Note:	if the AUX device is currently owned by another process, this call will
	  block until the device becomes available
SeeAlso: INT E0/CL=A5h,INT E0/CL=B1h
--------O-E0----CLBD-------------------------
INT E0 - DR Multiuser DOS - "P_DELAY" - DELAY EXECUTION
	CL = BDh
	DX = delay in system ticks
Return: after the delay elapses
Notes:	the length of a system tick is installation-dependent (typically
	  1/50 or 1/60 second); the length may be determined by reading the
	  TICKSPERSEC value from the system data segment
	the actual delay before the process is rescheduled to run may be up to
	  one tick longer than requested; the delay between rescheduling and
	  actual execution cannot be predicted if higher-priority processes
	  are awaiting a turn at the CPU
SeeAlso: INT 15/AH=86h,INT 1A/AX=FF01h,INT 2F/AX=1224h,INT 62/AX=0096h
--------g-E00000-----------------------------
INT E0 - PCROBOTS v1.41 - "SWAPTASK" - END CURRENT ROBOT'S TURN
	AX = 0000h
Return: nothing
Program: PCROBOTS is P.D. Smith's adaptation of Tom Poindexter's CROBOTS, in
	  which specially-written .COM or .EXE programs form robots battling
	  each other in a user-defined arena
--------g-E00001-----------------------------
INT E0 - PCROBOTS v1.41 - "MOVEMENT" - START MOVING
	AX = 0001h
	BX = speed (0-maximum for robot)
	CX = direction (0-359 degrees)
Return: nothing
Notes:	the speed will change to the specified value at the maximum
	  acceleration the robot is capable of; if the robot is already moving
	  faster than its maximum maneuverability speed, it will not be able
	  to change direction
	this call also terminates the current robot's turn
SeeAlso: AX=0000h,AX=0002h,AX=0003h
--------g-E00002-----------------------------
INT E0 - PCROBOTS v1.41 - "SCAN" - SCAN FOR OTHER ROBOTS IN THE GIVEN DIRECTION
	AX = 0002h
	BX = direction (0-359 degrees)
	CX = resolution (0-45 degrees)
Return: AX = status
	    FFFFh if nothing detected
	    else robot ID (0-19)
		BX = range to detected robot
Notes:	the scan searches within CX degrees to either side of the specified
	  direction
	the scanner will see right through walls, but shells will not pass
	  through walls
	this call also terminates the current robot's turn
SeeAlso: AX=0000h,AX=0001h,AX=0003h
--------g-E00003-----------------------------
INT E0 - PCROBOTS v1.41 - "SHOOT" - FIRE A SHELL AT ANOTHER ROBOT
	AX = 0003h
	BX = direction (0-359 degrees)
	CX = range (0-700)
Return: AX = status (0000h not fired, else ID of shell fired)
Notes:	up to seven shells may be in flight for a robot at one time; the cannon
	  takes 50 ticks to reload
	this call also terminates the current robot's turn
SeeAlso: AX=0000h,AX=0001h,AX=0002h,AX=002Ch
--------g-E00010-----------------------------
INT E0 - PCROBOTS v1.41 - "GETXY" - GET ROBOT'S CURRENT POSITION
	AX = 0010h
Return: BX = current X coordinate (0-999)
	CX = current Y coordinate (0-999)
--------g-E00011-----------------------------
INT E0 - PCROBOTS v1.41 - "TRANSMIT" - SEND DATA TO ANOTHER ROBOT
	AX = 0011h
	BX = target robot ID
	CX = data to be sent
Return: AX = status (0000h data could not be sent, 0001h data sent)
Note:	this call costs one unit of battery power
--------g-E00012-----------------------------
INT E0 - PCROBOTS v1.41 - "RECEIVE" - GET DATA FROM OTHER ROBOTS
	AX = 0012h
Return: AX = status
	    0000h no data available
	    0001h data retrieved
		BX = sender's ID
		CX = data
Note:	each robot has a 20-word receive FIFO; if the FIFO is full, other
	  robots will be unable to send more data until some is read
--------g-E00013-----------------------------
INT E0 - PCROBOTS v1.41 - "DAMAGE" - DETERMINE HOW MUCH DAMAGE SUSTAINED
	AX = 0013h
Return: BX = damage status
Note:	the initial value depends on configuration, but is typically 100; as
	  the robot is damaged, it decreases
--------g-E00014-----------------------------
INT E0 - PCROBOTS v1.41 - "SPEED" - DETERMINE HOW FAST ROBOT IS MOVING
	AX = 0014h
Return: BX = current speed
--------g-E00015-----------------------------
INT E0 - PCROBOTS v1.41 - "BATTERY" - DETERMINE HOW MUCH BATTERY POWER LEFT
	AX = 0015h
Return: BX = current battery charge
Note:	the battery starts off with 1000 units of charge, and is constantly
	  being charged by solar panels and constantly discharged by motion;
	  the battery is charged at 4 units per turn and discharged at
	  0.1*speed units per turn.
--------g-E00016-----------------------------
INT E0 - PCROBOTS v1.41 - "TICKS" - DETERMINE HOW LONG SINCE GAME STARTED
	AX = 0016h
Return: BX:CX = number of game ticks elapsed (not related to real time)
--------g-E00017-----------------------------
INT E0 - PCROBOTS v1.41 - "L_SIN" - GET SCALED SINE OF AN ANGLE
	AX = 0017h
	BX = angle (0-359 degrees)
Return: BX:CX = 100000*sine of angle
SeeAlso: AX=0018h,AX=0019h,AX=001Ah,AX=001Bh
--------g-E00018-----------------------------
INT E0 - PCROBOTS v1.41 - "L_COS" - GET SCALED COSINE OF AN ANGLE
	AX = 0018h
	BX = angle (0-359 degrees)
Return: BX:CX = 100000*cosine of angle
SeeAlso: AX=0017h,AX=0019h,AX=001Ah
--------g-E00019-----------------------------
INT E0 - PCROBOTS v1.41 - "L_TAN" - GET SCALED TANGENT OF AN ANGLE
	AX = 0019h
	BX = angle (0-359 degrees)
Return: BX:CX = 100000*tangent of angle
SeeAlso: AX=0017h,AX=0018h,AX=001Ah
--------g-E0001A-----------------------------
INT E0 - PCROBOTS v1.41 - "L_ATAN" - GET ANGLE GIVEN SCALED TANGENT
	AX = 001Ah
	BX:CX = 100000*tangent of an angle
Return: AX = angle (-90 to +90 degrees)
SeeAlso: AX=0017h,AX=0018h,AX=0019h
--------g-E0001B-----------------------------
INT E0 - PCROBOTS v1.41 - "SQRT" - DETERMINE SQUARE ROOT OF A NUMBER
	AX = 001Bh
	BX:CX = value
Return: BX:CX = square root
SeeAlso: AX=0017h
--------g-E0001C-----------------------------
INT E0 - PCROBOTS v1.41 - "SET_PATTERN" - SPECIFY ROBOT'S DISPLAY IMAGE
	AX = 001Ch
	BX:CX -> pattern array
Return: nothing
Note:	the pattern array consists of five bytes, the low five bits of each
	  specifying the bit pattern for one line of the robot's screen display
--------g-E0001D-----------------------------
INT E0 - PCROBOTS v1.41 - "DEBUG_FLAG" - SET/CLEAR MARKERS NEXT TO ROBOT'S NAME
	AX = 001Dh
	BX = flag number (0 or 1)
	CX = new value (0 reset, 1 set)
Return: nothing
Program: PCROBOTS is P.D. Smith's adaptation of Tom Poindexter's CROBOTS, in
	  which specially-written .COM or .EXE programs form robots battling
	  each other in a user-defined arena
Note:	the two flag markers may be used for any purpose, typically for
	  debugging to provide a visual display of progress
--------g-E0001E-----------------------------
INT E0 - PCROBOTS v1.41 - "BUY_ARMOUR" - BUY OR SELL ARMOR FOR ROBOT
	AX = 001Eh
	BX = number of armor units to buy (negative to sell)
Return: nothing
Note:	each armor unit is worth 50 battery units; the robot's armor rating
	  will not go above its initial rating, so attempts to purchase more
	  will waste battery units
SeeAlso: AX=001Fh
--------g-E0001F-----------------------------
INT E0 - PCROBOTS v1.41 - "BUY_SHELLS" - BUY ADDITIONAL CANNON SHELLS
	AX = 001Fh
	BX = number of shells to buy
Return: nothing
Note:	each shell costs ten battery units
SeeAlso: AX=001Eh,AX=0020h
--------g-E00020-----------------------------
INT E0 - PCROBOTS v1.41 - "SHELLS LEFT" - DETERMINE HOW MANY SHELLS ROBOT HAS
	AX = 0020h
Return: BX = number of shells remaining
SeeAlso: AX=001Fh
--------g-E00021-----------------------------
INT E0 - PCROBOTS v1.41 - "GET LOCAL MAP"
	AX = 0021h
	BX:CX -> 81-byte buffer for map (see #3666)
Return: buffer filled with 9x9 area of map centered on robot's position

(Table 3666)
Values for PCROBOTS map squares:
 2Eh '.' empty square
 44h 'D' damaging trap
 52h 'R' refueling point
 58h 'X' wall
--------g-E00022-----------------------------
INT E0 - PCROBOTS v1.41 - "INVISIBILITY" - CONTROL ROBOT'S INVISIBILITY DEVICE
	AX = 0022h
	BX = new state (0000h become visible, 0001h become invisible)
Return: nothing
Notes:	this function has no effect if the robot is not capable of invisibility
	the robot can only stay invisible for 100 turns, after which it will
	  automatically become visible; it must also be remain visible for
	  as many turns as it was invisible before it can turn invisible
	  again
SeeAlso: AX=0024h,AX=0080h
--------g-E00023-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_SHELL_STATUS" - FIND OUT WHAT HAPPENED TO SHELL
	AX = 0023h
Return: BX = status of last shell to land
	    0000h missed completely
	    0001h hit a wall
	    0002h hit a robot within 50-square radius
	    0003h hit a robot within 25-square radius
	    0004h hit a robot within 5-square radius
--------g-E00024-----------------------------
INT E0 - PCROBOTS v1.41 - "IS_INVISIBLE" - DETERMINE WHETHER ROBOT IS INVISIBLE
	AX = 0024h
Return: BX = visibility (0000h visible, 0001h invisible)
SeeAlso: AX=0022h,AX=0080h
--------g-E00025-----------------------------
INT E0 - PCROBOTS v1.41 - "L_ATAN2" - GET ARCTANGENT
	AX = 0025h
	BX = Y
	CX = X
Return: AX = angle (arctangent of Y/X)
--------g-E00026-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_ROBOT_ID" - DETERMINE CURRENT ROBOT'S IDENTIFIER
	AX = 0026h
Return: AX = robot ID
--------g-E00027-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_IFF" - REGISTER FRIEND/FOE IDENT STRING
	AX = 0027h
	BX:CX = ASCIZ IFF string
Return: nothing
Note:	the IFF string may only be set once
SeeAlso: AX=0028h,AX=0029h
--------g-E00028-----------------------------
INT E0 - PCROBOTS v1.41 - "CHECK_IFF" - QUERY FRIEND/FOE IDENTIFICATION STRING
	AX = 0028h
	BX = robot ID to test
Return: AX = status
	    0000h IFF strings match
	    0001h IFF strings differ or invalid robot ID
SeeAlso: AX=0027h
--------g-E00029-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_NAME" - SPECIFY ROBOT'S NAME
	AX = 0029h
	BX:CX -> ASCIZ name string
Return: nothing
Note:	the name may only be set once
SeeAlso: AX=0027h,AX=002Ah
--------g-E0002A-----------------------------
INT E0 - PCROBOTS v1.41 - "FIND_NAME" - SEARCH FOR ROBOT WITH GIVEN NAME
	AX = 002Ah
	BX:CX -> ASCIZ name string
	DX = first ID to check
Return: AX = robot ID or FFFFh if no robot with specified name
SeeAlso: AX=0028h,AX=0029h,AX=002Bh
--------g-E0002B-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_TEAM_ID" - DETERMINE TEAM MEMBERSHIP OF ROBOT
	AX = 002Bh
Return: AX = team ID (0-2) or FFFFh if 'loner'
SeeAlso: AX=0029h
--------g-E0002C-----------------------------
INT E0 - PCROBOTS v1.41 - "GET_ASHELL_STATUS" - FIND OUT WHAT HAPPENED TO SHELL
	AX = 002Ch
	BX = shell ID
Return: AX = status
	    0000h missed completely
	    0001h hit a wall
	    0002h hit a robot within a 50-square radius
	    0003h hit a robot within a 25-square radius
	    0004h hit a robot within a 5-square radius
	    0005h shell not known (too old or not yet fired)
	    0006h shell still in flight
SeeAlso: AX=0003h
--------g-E0002D-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_X" - SELECT AUTOMATIC X POSITION UPDATES
	AX = 002Dh
	BX:CX -> X word variable
Return: AX = status (0001h OK, 0000h problem with address)
Note:	after this call, PCROBOTS will automatically update the specified
	  word whenever the robot moves
SeeAlso: AX=002Eh
--------g-E0002E-----------------------------
INT E0 - PCROBOTS v1.41 - "REGISTER_Y" - SELECT AUTOMATIC Y POSITION UPDATES
	AX = 002Eh
	BX:CX -> Y word variable
Return: AX = status (0001h OK, 0000h problem with address)
Note:	after this call, PCROBOTS will automatically update the specified
	  word whenever the robot moves
SeeAlso: AX=002Dh
--------g-E00080-----------------------------
INT E0 - PCROBOTS v1.41 - "CONFIGURE" - CUSTOMIZE ROBOT
	AX = 0080h
	BX = basic configuration (see #3667)
	CX = advanced configuration (see #3668)
Return: AX = status (0001h OK, 0000h not first call in program)
Program: PCROBOTS is P.D. Smith's adaptation of Tom Poindexter's CROBOTS, in
	  which specially-written .COM or .EXE programs form robots battling
	  each other in a user-defined arena
Notes:	a maximum of ten points may be allocated to the robot; if you attempt
	  to allocate more, some items will be given a value of zero.  If this
	  function is not called, each attribute is set to the default value
	  of 2.
	if the invisibility option is chosen, the robot will start with only
	  900 cannon shells instead of the default 1000

Bitfields for PCROBOTS basic configuration:
Bit(s)	Description	(Table 3667)
 0-3	maximum speed (0-4 = 50,75,100,150,200)
 4-7	maneuverability (0-4 = 20%,35%,50%,75%,100%)
 8-11	cannon range (0-4 = 300,500,700,1000,1500)
 12-15	robot armor (0-4 = 50,75,100,150,200)

Bitfields for PCROBOTS advanced configuration:
Bit(s)	Description	(Table 3668)
 0-2	robot acceleration (0-4 = 5,7,10,15,20)
 3	capable of invisibility
--------r-E1---------------------------------
INT E1 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-E1---------------------------------
INT E1 - PC Cluster Disk Server Information (NOT A VECTOR!)
Desc:	points at a data table
SeeAlso: INT E2
--------O-E1---------------------------------
INT E1 - MP/M-86, - ALTERNATE CP/M-86 FUNCTION CALLS
	CL = function number (see #3651,#3652)
	DS,DX = parameters
Return: as appropriate for function
	CX is often the error code (see #3653)
Desc:	used by some applications which alter CP/M functions while running a
	  child program, to store the original INT E0 vector before
	  intercepting INT E0
SeeAlso: #3651 at INT E0"CP/M"
----------E1---------------------------------
INT E1 - DeskMate (Tandy) - TASK DATA SEGMENTS (NOT A VECTOR!)
Desc:	used to store data; the	low word of the vector is the data segment for
	  the first task; the high word is the data segment of the second task
	  (DeskMate supports 2-way task switching between small- or
	  medium-model applications)
Program: DeskMate is a proprietary GUI from Tandy distributed with several
	  models of the Tandy 1000's, 2500's, 3000's, and laptops.  Retail
	  and runtime versions also exist.  Some Tandy's are designed to
	  boot directly into DeskMate.
SeeAlso: INT E0"DeskMate"
--------r-E2---------------------------------
INT E2 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-E2---------------------------------
INT E2 - PC Cluster Program - RELOCATED INT 1C
SeeAlso: INT 1C
--------r-E3---------------------------------
INT E3 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E40005-----------------------------
INT E4 - Logitech Modula v2.0 - MonitorEntry
	AX = 0005h
	BX = priority
Return: nothing
SeeAlso: AX=0006h
--------r-E40006-----------------------------
INT E4 - Logitech Modula v2.0 - MonitorExit
	AX = 0006h
Return: nothing
SeeAlso: AX=0005h
--------r-E4---------------------------------
INT E4 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E5---------------------------------
INT E5 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E6---------------------------------
INT E6 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------O-E600-------------------------------
INT E6 - Linux DOSEMU - INSTALLATION CHECK
	AH = 00h
Return: AX = AA55h if installed
	    BH = major version number
	    BL = minor version number
	    CX = patchlevel
Notes:	check for the BIOS date string "02/25/93" at F000:FFF5 before
	  calling this function.  In addition, the segment address of this
	  vector should be F000h (for existing versions of DOSemu, the
	  vector is F000h:0E60h)
SeeAlso: AH=FFh
--------O-E601-------------------------------
INT E6 - Linux DOSEMU - REGISTER DUMP
	AH = 01h
Return: nothing
SeeAlso: AH=00h
--------O-E602-------------------------------
INT E6 - Linux DOSEMU - SET I/O PORT PERMISSIONS
	AH = 02h
	BX = base I/O port address
	CX = number of consecutive I/O ports
	CF set to allow DOS to use ports
	CF clear if DOS should not be allowed to use ports
Return: nothing
SeeAlso: AH=00h
--------O-E605-------------------------------
INT E6 - Linux DOSEMU - STARTUP BANNER
	AH = 05h
Return: nothing
SeeAlso: AH=00h
--------O-E612-------------------------------
INT E6 - Linux DOSEMU - SET "HOGTHRESHOLD"
	AH = 12h
	BX = new "hogthreshold" (00h-99h)
Return: nothing
Desc:	specify how much CPU time DOSEMU may use
SeeAlso: AH=00h
--------O-E622-------------------------------
INT E6 - Linux DOSEMU - GET EMS STATUS
	AH = 22h
Return: ???
SeeAlso: AH=00h
--------O-E630-------------------------------
INT E6 - Linux DOSEMU - SET BOOTDISK FLAG
	AH = 30h
	BX = new flag state (0 = false, 1 = true)
Return: nothing
SeeAlso: AH=00h
--------O-E650-------------------------------
INT E6 - Linux DOSEMU - EXECUTE UNIX COMMAND
	AH = 50h
	ES:DX -> ASCIZ Unix command
SeeAlso: AH=00h,AH=51h
--------O-E651-------------------------------
INT E6 - Linux DOSEMU - EXECUTE DOS COMMAND FROM UNIX
	AH = 51h
	ES:DX -> ASCIZ DOS command
SeeAlso: AH=00h,AH=50h
--------O-E680-------------------------------
INT E6 - Linux DOSEMU - GET CURRENT UNIX DIRECTORY
	AH = 80h
Return: ES:DX -> current Unix directory
	AX = length of current directory name
SeeAlso: AH=00h,AH=81h
--------O-E681-------------------------------
INT E6 - Linux DOSEMU - CHANGE CURRENT UNIX DIRECTORY
	AH = 81h
	ES:DX -> ASCIZ directory name
Return: nothing
SeeAlso: AH=00h,AH=80h
--------O-E6FF-------------------------------
INT E6 - Linux DOSEMU - TERMINATE
	AH = FFh
SeeAlso: AH=00h
--------r-E7---------------------------------
INT E7 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E8---------------------------------
INT E8 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-E9---------------------------------
INT E9 - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-EA---------------------------------
INT EA - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-EB---------------------------------
INT EB - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------r-EC---------------------------------
INT EC - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC
	BASIC.COM/BASICA.COM do not restore vector on termination
--------N-EC---------------------------------
INT EC - used by Alloy NTNX
--------r-EC---------------------------------
INT EC - Exact - RUNTIME INTERFACE MULTIPLEXOR
	AX = function number (0000h to 0140h)
	STACK:	DWORD address to return to
		any arguments required by function
Return: STACK:	return address popped, but otherwise unchanged
Desc:	this is the interface from applications to the runtime system by Exact
	  Automatisering B.V. of the Netherlands.  By using this interrupt,
	  it can provide DLL-style capabilities under MS-DOS.
Note:	the interrupt handler removes the return address and flags placed on
	  the stack by the INT EC, then jumps to the appropriate function
--------r-ED---------------------------------
INT ED - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
	INT 80 through INT ED are modified but not restored by Direct Access
	  v4.0, and may be left dangling by other programs written with the
	  same version of compiled BASIC
SeeAlso: INT EC"BASIC",INT EE"BASIC"
--------r-EE---------------------------------
INT EE - IBM ROM BASIC - used while in interpreter
Notes:	called by ROM BASIC, but pointed at IRET by BASIC.COM/BASICA.COM
	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT ED"BASIC",INT EE"BASIC"
--------r-EF---------------------------------
INT EF - BASIC - ORIGINAL INT 09 VECTOR
Note:	BASIC.COM/BASICA.COM do not restore vector on termination
SeeAlso: INT EE"BASIC",INT F0"BASIC"
--------O-EF----CX0473-----------------------
INT EF - GEM - INTERFACE
	CX = 0473h
	DS:DX -> GEM parameter block
--------r-F0---------------------------------
INT F0 - BASICA.COM, GWBASIC, compiled BASIC - ORIGINAL INT 08 VECTOR
Note:	BASICA.COM does not restore vector on termination
SeeAlso: INT EF"BASIC"
--------*-F1---------------------------------
INT F1 - reserved for user interrupt
--------s-F1---------------------------------
INT F1 - SPEECH.COM - CONVERT TEXT STRING TO SPEECH
	DS:BX -> '$'-terminated text string
Return: nothing
Program: SPEECH.COM is a resident text-to-speech converter by Douglas Sisco
--------s-F1---------------------------------
INT F1 - Andy C. McGuire SPEECH.COM/SAY.COM
SeeAlso: INT F2"SPEECH"
--------U-F1---------------------------------
INT F1 - AQUEDUCT, PIPELINE - GET DATA AREA ADDRESS
Return: AX:BX -> data area
Program: AQUEDUCT and PIPELINE are TSRs by James W. Birdsall to connect COM1
	  and COM2 in software
Note:	The installation check consists of testing for the following signature
	  immediately preceding the interrupt handler: "JWBtvv" where 't' is
	  either "A" for AQUEDUCT or "P" for PIPELINE and "vv" is a two-digit
	  version number
Index:	installation check;AQUEDUCT|installation check;PIPELINE
--------N-F1---------------------------------
INT F1 - NetWare Remote Boot - INSTALLATION CHECK (NOT A VECTOR!)
Note:	if this vector contains the value 5774654Eh ("NetW"), the remote boot
	  BIOS extension is active, and access to the floppy disk is redirected
	  to an image file in the server's SYS:LOGIN directory
SeeAlso: INT F2"NetWare",INT F3"NetWare",INT F4"NetWare"
--------v-F1---------------------------------
INT F1 - VIRUS - "Violetta" - ???
Note:	used but not chained by virus
SeeAlso: INT E0"VIRUS",INT FF"VIRUS"
----------F101-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-REGISTER" - INITIALIZE CAPI
	AH = 01h
	ES:BX -> buffer for CAPI's use (refer to note below)
	CX = minimum number of pending messages
	DX = maximum simultaneous Level 3 connections
	SI = maximum concurrent received B3 data blocks
	DI = maximum B3 data block size
Return: AX = CAPI-assigned application ID
	    0000h on error
		BX = error number
		    1001h registration error
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
	the CAPI interrupt handler begins with a header which is nearly
	  identical to the IBM Interrupt Sharing Protocol header
	  (see #2223 at INT 2D"AMIS"), except that the short jump instruction
	  to a hardware reset handler at offset 09h is replaced by the
	  signature bytes "IA"
	the maximum length of a message is fixed at 180 bytes; the standard
	  document suggests using CX=10, DI=1, SI=7, and DI=130 for
	  applications which use only a single connection and standard
	  protocols
	the total size of the application-provided buffer must be at least
	  180*CX + DX*SI*DI bytes
SeeAlso: AH=02h,INT F1/AL=01h
Index:	installation check;Common ISDN API
----------F1--01-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_REGISTER" - INITIALIZE CAPI
	AL = 01h
	AH = CAPI version number * 10 (14h for v2.0)
	ES:BX -> buffer for CAPI's use (refer to note below)
	CX = number of bytes for message buffer
	DX = maximum simultaneous logical (Level 3) connections
	SI = maximum concurrent received B3 data blocks (min. 2)
	DI = maximum B3 data block size (up to 2048 bytes)
Return: AX = CAPI-assigned application ID
	    0000h on error
		BX = error number
		    1001h registration error
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
	the CAPI interrupt handler begins with a header (see #3669) which is
	  nearly identical to the IBM Interrupt Sharing Protocol header
	  (see #2223 at INT 2D"AMIS"), except that the short jump instruction
	  to a hardware reset handler at offset 09h is zeroed out and the
	  entire header is inexplicably shortened by one byte
	the standard document suggests using 1024 + (1024*DX) bytes for the
	  message buffer for typical applications
	the total size of the application-provided buffer must be at least
	  CX + DX*SI*DI bytes
SeeAlso: AH=01h,INT F1/AL=02h
Index:	installation check;Common ISDN API

Format of CAPI v2.0 interrupt handler entry point:
Offset	Size	Description	(Table 3669)
 00h  2 BYTEs	short jump to actual start of interrupt handler, immediately
		  following this data block (EBh 0Fh)
 02h	DWORD	address of next handler in chain
 06h	WORD	signature 424Bh
 08h	BYTE	EOI flag (80h)
		80h primary hardware interrupt handler (will issue EOI)
 09h  2 BYTEs	reserved (0)
		(is short jump to hardware reset routine in ISP header)
 0Bh  4 BYTEs	signature "CAPI"
 0Fh  2 BYTEs	two-digit CAPI version number in ASCII ('20')
SeeAlso: #2223 at INT 2D
----------F102-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-RELEASE" - UNREGISTER FROM CAPI
	AH = 02h
	DX = application ID (see AH=01h)
Return: AX = status (0000h,1002h) (see #3670)
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=01h,INT F1/AL=02h

(Table 3670)
Values for CAPI v1.1 error code:
 0000h	successful
 1001h	registration error
 1002h	invalid application ID
 1003h	message too small or incorrectly coded message number
 1004h	invalid command or subcommand
 1005h	message queue full
 1006h	message queue empty
 1007h	message(s) lost due to queue overflow
 1008h	error uninstalling
SeeAlso: #3671
----------F1--02-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_RELEASE" - UNREGISTER FROM CAPI
	AL = 02h
	AH = CAPI version number * 10 (14h for v2.0)
	DX = application ID (see INT F1/AL=01h)
Return: AX = status (0000h,11xxh) (see #3671)
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=02h,INT F1/AL=01h,INT F1/AL=03h

(Table 3671)
Values for CAPI v2.0 error code:
 0000h	successful
 1001h	too many applications
 1002h	logical block size too small (must be at least 128 bytes)
 1003h	buffer > 64K
 1004h	message buffer too small (minimum 1024 bytes)
 1005h	too many logical connections requested
 1006h	reserved
 1007h	could not register because CAPI busy, try again
 1008h	OS resource unavailable (out of memory, etc.)
 1009h	COMMON-ISDN-API not installed
 100Ah	controller does not support external equipment
 100Bh	controller supports only external equipment
 1101h	invalid application ID
 1102h	illegal command or subcommand, or message too short
 1103h	message queue full
 1104h	queue empty
 1105h	queue overflowed (message lost)
 1106h	unknown notification parameter
 1107h	could not accept message because CAPI busy, try again
 1108h	OS resource unavailable (out of memory, etc.)
 1109h	COMMON-ISDN-API not installed
 110Ah	controller does not support external equipment
 110Bh	controller supports only external equipment
 2001h	message not supported in current state
 2002h	illegal controller/PLCI/NCCI
 2003h	out of PLCI
 2004h	out of NCCI
 2005h	out of LISTEN
 2006h	out of FAX resources (T.30 protocol)
 2007h	illegal message parameter coding
 3001h	unsupported B1 protocol
 3002h	unsupported B2 protocol
 3003h	unsupported B3 protocol
 3004h	unsupported B1 protocol parameter
 3005h	unsupported B2 protocol parameter
 3006h	unsupported B3 protocol parameter
 3007h	unsupported B protocol combination
 3008h	NCPI not supported
 3009h	unknown CIP value
 300Ah	unsupported flags (reserved bits set)
 300Bh	unsupported facility
 300Ch	data length not supported by current protocol
 300Dh	reset procedure not supported by current protocol
SeeAlso: #3670
----------F103-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-PUT-MESSAGE"
	AH = 03h
	DX = application ID (see AH=01h)
	ES:BX -> message to be sent (see #3672)
Return: AX = status (0000h,1002h,1003h,1004h,1005h) (see #3670)
Notes:	the caller is required to provide at least 512 bytes of stack space
	the message buffer may be reused as soon as this call returns
SeeAlso: AH=01h,AH=04h,INT F1/AL=03h

Format of CAPI message:
Offset	Size	Description	(Table 3672)
 00h	WORD	total message length, including header
 02h	WORD	application ID (see AH=01h)
 04h	BYTE	command (see #3673,#3674)
 05h	BYTE	subcommand (see #3673,#3674)
 06h	WORD	message sequence number
		0000h-7FFFh messages from application to CAPI (and replies)
		8000h-FFFFh messages from CAPI to application (and replies)
 08h	var	message data (max 172 bytes for v1.1 only)

(Table 3673)
Values for CAPI v1.1 message command/subcommand:
Cmd/SubCmd	Name			Description
 01h/00h    RESET-B3-REQ	request resetting of a Level 3 connection
 01h/01h    RESET-B3-CONF	confirm Level 3 connection reset
 01h/02h    RESET-B3-IND	indication from CAPI that Level 3 conn. reset
 01h/03h    RESET-B3-RESP	confirm receipt of RESET-B3-IND
 02h/00h    CONNECT-REQ		establish B-channel connection
 02h/01h    CONNECT-CONF	confirm start of connection establishment
 02h/02h    CONNECT-IND		indication from CAPI of incoming connection
 02h/03h    CONNECT-RESP	accept incoming connection
 03h/02h    CONNECT-ACTIVE-IND	indication that B-channel connection complete
 03h/03h    CONNECT-ACTIVE-RESP	confirm connection-complete indication
 04h/00h    DISCONNECT-REQ	request shutdown of B-channel connection
 04h/01h    DISCONNECT-CONF	confirm shutdown of B-channel connection
 04h/02h    DISCONNECT-IND	indication that B-channel is shutting down
 04h/03h    DISCONNECT-RESP	confirm that application knows of shutdown
 05h/00h    LISTEN-REQ		enable indication of incoming connections
 05h/01h    LISTEN-CONF		confirm enabling of incoming conn. indication
 06h/00h    GET-PARAMS-REQ	request B-channel parameters
 06h/01h    GET-PARAMS-CONF	return B-channel parameters
 07h/00h    INFO-REQ		set B-channel info to be signalled to app
 07h/01h    INFO-CONF		confirm B-channel info signalling
 07h/02h    INFO-IND		signal B-channel events to application
 07h/03h    INFO-CONF		confirm receipt of INFO-IND
 08h/00h    DATA-REQ		send D-channel data
 08h/01h    DATA-CONF		confirm receipt of DATA-REQ
 08h/02h    DATA-IND		receive D-channel data
 08h/03h    DATA-RESP		confirm receipt fo DATA-IND
 09h/00h    CONNECT-INFO-REQ	request connection information
 09h/01h    CONNECT-INFO-CONF	return connection information
 40h/00h    SELECT-B2-PROTOCOL-REQ  select Level 2 protocol
 40h/01h    SELECT-B2-PROTOCOL-CONF confirm receipt of SELECT-B2-PROTOCOL-REQ
 80h/00h    SELECT-B3-PROTOCOL-REQ  select Level 3 protocol
 80h/01h    SELECT-B3-PROTOCOL-CONF confirm receipt of SELECT-B3-PROTOCOL-REQ
 81h/00h    LISTEN-B3-REQ	enable notification of incoming Level 3 calls
 81h/01h    LISTEN-B3-CONF	confirm receipt of LISTEN-B3-REQ
 82h/00h    CONNECT-B3-REQ	establish Level 3 connection
 82h/01h    CONNECT-B3-CONF	confirm start of connection establishment
 82h/02h    CONNECT-B3-IND	indication of incoming Level 3 connection
 82h/03h    CONNECT-B3-RESP	accept incoming connection
 83h/02h    CONNECT-B3-ACTIVE-IND  indication that Level 3 connection complete
 83h/03h    CONNECT-B3-ACTIVE-RESP confirm connection-complete indication
 84h/00h    DISCONNECT-B3-REQ	request shutdown of Level 3 connection
 84h/01h    DISCONNECT-B3-CONF	confirm shutdown of Level 3 connection
 84h/02h    DISCONNECT-B3-IND	indication that Level 3 is shutting down
 84h/03h    DISCONNECT-B3-RESP	confirm that application knows of shutdown
 85h/00h    GET-B3-PARAMS-REQ	request Level 3 parameters
 85h/01h    GET-B3-PARAMS-CONF	return Level 3 parameters
 86h/00h    DATA-B3-REQ		send data on Level 3
 86h/01h    DATA-B3-CONF	confirm sending of Level 3 data
 86h/02h    DATA-B3-IND		indication of incoming Level 3 data
 86h/03h    DATA-B3-RESP	confirm receipt of Level 3 data
 87h/02h    HANDSET-IND		indication of Handset events
 87h/03h    HANDSET-RESP	confirm receipt of Handset event
 FFh/00h    MANUFACTURER-REQ	vendor-specific request
 FFh/01h    MANUFACTURER-CONF	vendor-specific request confirmation
 FFh/02h    MANUFACTURER-IND	vendor-specific notification
 FFh/03h    MANUFACTURER-RESP	vendor-specific notification confirmation
SeeAlso: #3672,#3674
----------F1--03-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_PUT_MESSAGE"
	AL = 03h
	AH = CAPI version number * 10 (14h for v2.0)
	DX = application ID (see INT F1/AL=01h)
	ES:BX -> message to be sent (see #3672)
Return: AX = status (0000h,11xxh) (see #3671)
Notes:	the caller is required to provide at least 512 bytes of stack space
	the message buffer may be reused as soon as this call returns
SeeAlso: AH=03h,INT F1/AL=01h,INT F1/AL=04h

(Table 3674)
Values for CAPI v2.0 message command/subcommand:
Cmd/SubCmd	Name			Description
 01h/80h    ALERT_REQ		indicate compatibility with incoming calls
 01h/81h    ALERT_CONF		confirm receipt of ALERT_REQ
 02h/80h    CONNECT_REQ		establish B-channel connection
 02h/81h    CONNECT_CONF	confirm start of connection establishment
 02h/82h    CONNECT_IND		indication from CAPI of incoming connection
 02h/83h    CONNECT_RESP	accept incoming connection
 03h/82h    CONNECT_ACTIVE_IND	indication that B-channel connection complete
 03h/83h    CONNECT_ACTIVE_RESP	confirm connection-complete indication
 04h/80h    DISCONNECT_REQ	request shutdown of B-channel connection
 04h/81h    DISCONNECT_CONF	confirm shutdown of B-channel connection
 04h/82h    DISCONNECT_IND	indication that B-channel is shutting down
 04h/83h    DISCONNECT_RESP	confirm that application knows of shutdown
 05h/80h    LISTEN_REQ		enable signalling on incoming events
 05h/81h    LISTEN_CONF		confirm enabling of incoming event signalling
 08h/80h    INFO_REQ		send protocol information for physical connect
 08h/81h    INFO_CONF		confirm INFO_REQ
 08h/82h    INFO_IND		indicate event for physical connection
 08h/83h    INFO_CONF		confirm receipt of INFO_IND
 41h/80h    SELECT_B_PROTOCOL_REQ   change protocol on already-active connect
 41h/81h    SELECT_B_PROTOCOL_CONF  confirm receipt of SELECT_B_PROTOCOL_REQ
 80h/80h    FACILITY_REQ	control optional facilities
 80h/81h    FACILITY_CONF	confirm acceptance of FACILITY_REQ
 80h/82h    FACILITY_IND	indicate facility-dependent event
 80h/83h    FACILITY_RESP	confirm receipt of FACILITY_IND
 82h/80h    CONNECT_B3_REQ	establish Level 3 connection
 82h/81h    CONNECT_B3_CONF	confirm start of connection establishment
 82h/82h    CONNECT_B3_IND	indication of incoming Level 3 connection
 82h/83h    CONNECT_B3_RESP	accept incoming connection
 83h/82h    CONNECT_B3_ACTIVE_IND  indication that Level 3 connection complete
 83h/83h    CONNECT_B3_ACTIVE_RESP confirm connection-complete indication
 84h/80h    DISCONNECT_B3_REQ	request shutdown of Level 3 connection
 84h/81h    DISCONNECT_B3_CONF	confirm shutdown of Level 3 connection
 84h/82h    DISCONNECT_B3_IND	indication that Level 3 is shutting down
 84h/83h    DISCONNECT_B3_RESP	confirm that application knows of shutdown
 85h/80h    GET_B3_PARAMS_REQ	request Level 3 parameters
 85h/81h    GET_B3_PARAMS_CONF	return Level 3 parameters
 86h/80h    DATA_B3_REQ		send data on Level 3
 86h/81h    DATA_B3_CONF	confirm sending of Level 3 data
 86h/82h    DATA_B3_IND		indication of incoming Level 3 data
 86h/83h    DATA_B3_RESP	confirm receipt of Level 3 data
 87h/80h    RESET_B3_REQ	request resetting of a logical connection
 87h/81h    RESET_B3_CONF	confirm logical connection reset
 87h/82h    RESET_B3_IND	indication from CAPI that logical conn. reset
 87h/83h    RESET_B3_RESP	confirm receipt of RESET_B3_IND
 88h/82h    CONNECT_B3_T90_ACTIVE_IND  indicate switch from T.70 to T.90
 88h/83h    CONNECT_B3_T90_ACTIVE_RESP confirm receipt of T90_ACTIVE_IND
 FFh/80h    MANUFACTURER_REQ	vendor-specific request
 FFh/81h    MANUFACTURER_CONF	vendor-specific request confirmation
 FFh/82h    MANUFACTURER_IND	vendor-specific notification
 FFh/83h    MANUFACTURER_RESP	vendor-specific notification confirmation
SeeAlso: #3672,#3673
----------F104-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-GET-MESSAGE"
	AH = 04h
	DX = application ID (see AH=01h)
Return: AX = status (0000h,1002h,1006h,1007h) (see #3670)
	ES:BX -> message if successful (see #3672)
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
	the returned message may be overwritten by the next call to this
	  function
SeeAlso: AH=03h
----------F1--04-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_GET_MESSAGE"
	AL = 04h
	AH = CAPI version number * 10 (14h for v2.0)
	DX = application ID (see AH=01h)
Return: AX = status (0000h,11xxh) (see #3671)
	ES:BX -> message if successful (see #3672)
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
	the returned message may be overwritten by the next call to this
	  function
SeeAlso: AH=04h,INT F1/AL=03h
----------F105-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-SET-SIGNAL" - SIGNAL HANDLING
	AH = 05h
	DX = application ID (see AH=01h)
	ES:BX -> signal handler or 0000h:0000h to disable
Return: AX = status (0000h,1002h) (see #3670)
Notes:	the caller is required to provide at least 512 bytes of stack space
	the signal handler is called as though it were an interrupt, with
	  interrupts disabled; the handler must preserve all registers and
	  return with an IRET
SeeAlso: AH=01h
----------F1--05-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_SET_SIGNAL" - SIGNAL HANDLING
	AL = 05h
	AH = CAPI version number * 10 (14h for v2.0)
	DX = application ID (see AH=01h)
	ES:BX -> signal handler or 0000h:0000h to disable
	SI:DI = parameter to pass to signal handler
Return: AX = status (0000h,11xxh) (see #3671)
Notes:	the caller is required to provide at least 512 bytes of stack space
	the signal handler is called as though it were an interrupt, with
	  interrupts disabled and DX,SI,DI set as they were when this function
	  was called; the handler must preserve all registers and return with
	  an IRET
	the signal handler may call CAPI_PUT_MESSAGE, CAPI_GET_MESSAGE, and
	  CAPI_SET_SIGNAL
SeeAlso: INT F1/AL=01h
----------F106-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-DEINSTALL" - UNINSTALL
	AH = 06h
	BX = force flag
	    0000h normal uninstall
	    0001h forced uninstall
Return: AX = status (0000h,1008h) (see #3670)
Desc:	reset ISDN controller, close all ISDN Level 1 connections except for
	  telephone connections
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: INT F1/AL=01h,INT F1/AH=01h
----------F1F0-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-GET-MANUFACTURER"
	AH = F0h
	ES:BX -> 64-byte buffer for manufacturer identification information
Return: ES:BX buffer filled with ASCIZ idnetification string
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=01h,AH=F1h,AH=F2h,AH=FFh,INT F1/AL=F0h
----------F1--F0-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_GET_MANUFACTURER"
	AL = F0h
	AH = CAPI version number * 10 (14h for v2.0)
	ES:BX -> 64-byte buffer for manufacturer identification information
Return: ES:BX buffer filled with ASCIZ idnetification string
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=F0h,INT F1/AL=01h,INT F1/AL=F1h,INT F1/AL=F2h,INT F1/AL=FFh
----------F1F1-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-GET-VERSION"
	AH = F1h
	ES:BX -> 64-byte buffer for CAPI version number
Return: ES:BX buffer filled with ASCIZ version string
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=01h,AH=F0h,AH=F2h,AH=FFh
----------F1--F1-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_GET_VERSION"
	AL = F1h
	AH = CAPI version number * 10 (14h for v2.0)
Return: AH = CAPI major version number
	AL = CAPI minor version number
	DH = vendor-specific major version
	DL = vendor-specific minor version
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=F1h,INT F1/AL=01h,INT F1/AL=F0h,INT F1/AL=F2h,INT F1/AL=FFh
----------F1F2-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-GET-SERIAL-NUMBER"
	AH = F2h
	ES:BX -> 64-byte buffer for CAPI serial number
Return: ES:BX buffer filled with ASCIZ serial number (seven digits), empty
	      string if no serial number
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=01h,AH=F0h,AH=F1h,AH=FFh
----------F1--F2-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_GET_SERIAL_NUMBER"
	AL = F2h
	AH = CAPI version number * 10 (14h for v2.0)
	ES:BX -> 64-byte buffer for CAPI serial number
Return: ES:BX buffer filled with ASCIZ serial number (seven digits), empty
	      string if no serial number
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=F2h,INT F1/AL=01h,INT F1/AL=F0h,INT F1/AL=F1h,INT F1/AL=F3h
----------F1--F3-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_GET_PROFILE" - GET CAPABILITIES
	AL = F3h
	AH = CAPI version number * 10 (14h for v2.0)
	ES:BX -> 64-byte buffer for CAPI capabilities (see #3675)
	CX = controller number (01h-06h) or 0000h to get number of controllers
Return: AX = status (0000h,11xxh) (see #3671)
	ES:BX buffer filled if successful
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: INT F1/AL=01h,INT F1/AL=F0h,INT F1/AL=F2h,INT F1/AH=FFh

Format of CAPI v2.0 capabilities:
Offset	Size	Description	(Table 3675)
 00h	WORD	number of installed controllers
 02h	WORD	number of supported B channels
 04h	DWORD	global options (see #3676)
 08h	DWORD	B1 protocol support flags (see #3677)
 0Ch	DWORD	B2 protocol support flags (see #3678)
 10h	DWORD	B3 protocol support flags (see #3679)
 14h 24 BYTEs	reserved for CAPI use
 2Ch 20 BYTEs	vendor-specific information

Bitfields for CAPI v2.0 global options:
Bit(s)	Description	(Table 3676)
 0	internal controller supported
 1	external controller supported
 2	handset supported (only if bit 1 also set)
 3	DTMF supported
 4-31	reserved (0)
SeeAlso: #3675

Bitfields for CAPI v2.0 B1 protocol support:
Bit(s)	Description	(Table 3677)
 0	64k bps with HDLC framing (required, always set)
 1	64k bps bit-transparent operation with network byte framing
 2	V.110 asynchronous with start/stop byte framing
 3	V.110 synchronous with HDLC framing
 4	T.30 modem for group 3 FAX
 5	64k bps inverted with HDLC framing
 6	56k bps bit-transparent operation with network byte framing
 7-31	reserved (0)
SeeAlso: #3675

Bitfields for CAPI v2.0 B2 protocol support:
Bit(s)	Description	(Table 3678)
 0	ISO 7776 (X.75 SLP) (required, always set)
 1	transparent
 2	SDLC
 3	Q.921 LAPD (D-channel X.25)
 4	T.30 for group 3 FAX
 5	point-to-point protocol (PPP)
 6	transparent (ignoring B1 framing errors)
 7-31	reserved (0)
SeeAlso: #3675

Bitfields for CAPI v2.0 B3 protocol support:
Bit(s)	Description	(Table 3679)
 0	transparent (required, always set)
 1	T.90NL with T.70NL compatibility
 2	ISO 8208 (X.25 DTE-DTE)
 3	X.25 DCE
 4	T.30 for group 3 FAX
 5-31	reserved (0)
SeeAlso: #3675
----------F1FF-------------------------------
INT F1 - Common ISDN API (CAPI) v1.1 - "API-MANUFACTURER" - VENDOR-SPECIFIC
	AH = FFh
	other registers vendor-specific
Return: registers vendor-specific
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=01h,AH=F0h,AH=F1h,AH=F2h,INT F1/AH=FFh
----------F1--FF-----------------------------
INT F1 - Common ISDN API (CAPI) v2.0 - "CAPI_MANUFACTURER" - VENDOR-SPECIFIC
	AL = FFh
	AH = CAPI version number * 10 (14h for v2.0)
	other registers vendor-specific
Return: registers vendor-specific
Range:	INT 00 to INT FF, selectable by program parameter
Notes:	the caller is required to provide at least 512 bytes of stack space
SeeAlso: AH=FFh,INT F1/AL=01h,INT F1/AL=F0h,INT F1/AL=F1h,INT F1/AL=F2h
--------*-F2---------------------------------
INT F2 - reserved for user interrupt
--------s-F2---------------------------------
INT F2 - Andy C. McGuire SPEECH.COM/SAY.COM
SeeAlso: INT F1"SPEECH"
--------N-F2---------------------------------
INT F2 - NetWare Remote Boot - ORIGINAL INT 13
SeeAlso: INT F1"NetWare",INT F3"NetWare",INT F4"NetWare"
----------F2---------------------------------
INT F2 - ICCTSR 1.0 - ImageCapture COLOR Developer's Kit - API
	AH = function number (see #3680)
	???
Return: ???
Program: ImageCapture is a product of International Computers
SeeAlso: INT F3"ICCTSR"

(Table 3680)
Values for ImageCapture function:
 01h	power up
 02h	power down
 03h	set controls
 04h	capture image
 05h	display image
 06h	read file
 07h	write file
 08h	write array
 09h	read pixel
 0Ah	write pixel
 0Bh	check if VGA present
 0Ch	set video mode
 0Dh	check for keystroke
 0Eh	delay
--------*-F3---------------------------------
INT F3 - reserved for user interrupt
SeeAlso: INT F2"user",INT F4"user"
--------s-F3---------------------------------
INT F3 - SoundBlaster - POINTER TO ECHO VALUE
Note:	this is not a vector, but a pointer to a DWORD containing the echo
	  value selected with SET-ECHO.EXE
SeeAlso: INT 2F/AX=FBFBh/ES=0000h
----------F3---------------------------------
INT F3 - ICCTSR 1.0 - HANDSHAKE ID VECTOR
Program: ImageCapture is a product of International Computers
SeeAlso: INT F2"ICCTSR"
--------N-F3---------------------------------
INT F3 - NetWare Remote Boot - BOOT ROM'S INT 13 HANDLER
SeeAlso: INT F1"NetWare",INT F2"NetWare",INT F4"NetWare"
--------*-F4---------------------------------
INT F4 - reserved for user interrupt
SeeAlso: INT F3"user",INT F5"user"
--------T-F4---------------------------------
INT F4 - DoubleDOS - GIVE UP REST OF CURRENT CLOCK TICK AND ALL OF NEXT TICK
SeeAlso: INT 21/AH=EEh"DoubleDOS",INT F5"DoubleDOS",INT FE"DoubleDOS"
--------N-F4---------------------------------
INT F4 - NetWare Remote Boot - ???
SeeAlso: INT F1"NetWare",INT F2"NetWare",INT F3"NetWare"
--------*-F5---------------------------------
INT F5 - reserved for user interrupt
SeeAlso: INT F4"user",INT F6"user"
--------T-F5---------------------------------
INT F5 - DoubleDOS - ???
SeeAlso: INT F4"DoubleDOS",INT F6"DoubleDOS"
--------*-F6---------------------------------
INT F6 - reserved for user interrupt
SeeAlso: INT F5"user",INT F7"user"
--------T-F6---------------------------------
INT F6 - DoubleDOS - ???
SeeAlso: INT F5"DoubleDOS",INT F7"DoubleDOS"
--------*-F7---------------------------------
INT F7 - reserved for user interrupt
SeeAlso: INT F6"user"
--------T-F7---------------------------------
INT F7 - DoubleDOS - ???
SeeAlso: INT F6"DoubleDOS"
----------F700-------------------------------
INT F7 - FSBBS 2.0 - CONFIGURATION RECORD
	AH = 00h
	AL = function
	    00h get configuration record
		Return: DS:DX -> configuration record
	    01h set configuration record
		Return: nothing
	    02h get path for option
		DS:DX -> option name
		Return: DS:DX -> path
	    03h determine whether configuration record set
		Return: AX = status
			    0000h set
			    0001h not yet set
	    04h get link state
		Return: AX = state
			    0000h unlinked
			    0001h linked
Notes:	this information is preliminary and still subject to change
	all of the INT F7 calls for FSBBS are used for interprogram
	  communication between the BBS kernel and the programs it spawns
SeeAlso: AH=01h
----------F701-------------------------------
INT F7 - FSBBS 2.0 - USER RECORD
	AH = 01h
	AL = function
	    00h get user record for user currently online
		Return: DS:DX -> user record
	    01h set user record
		DS:DX -> user record
		Return: nothing
SeeAlso: AH=00h,AH=02h
----------F702-------------------------------
INT F7 - FSBBS 2.0 - GET ACCOUNT NAME
	AH = 02h
Return: DS:DX -> 8-character blank-padded account name
SeeAlso: AH=01h
----------F703-------------------------------
INT F7 - FSBBS 2.0 - TERMINAL NUMBER
	AH = 03h
	AL = function
	    00h get terminal index number
		Return: DX = index number
	    01h set terminal index number
		DX = terminal index
		Return: nothing
----------F704-------------------------------
INT F7 - FSBBS 2.0 - PASSDATA BUFFER
	AH = 04h
	AL = function
	    00h get PassData buffer contents
		DS:DX -> buffer for PassData contents
		Return: DS:DX buffer filled
	    01h set PassData contents
		DS:DX -> buffer containing new PassData
		CH = length of data in buffer
		Return: nothing
----------F705-------------------------------
INT F7 - FSBBS 2.0 - TIMER FUNCTIONS
	AH = 05h
	AL = function
	    00h get time remaining
		Return: DX = number of minutes remaining
	    01h get current time
		Return: DS:DX -> 8-character time string
	    02h increment time
		DX = number of additional minutes
	    03h decrement time
		DX = number of minutes
SeeAlso: AH=06h
----------F706-------------------------------
INT F7 - FSBBS 2.0 - FUNCTION AVAILABILITY
	AH = 06h
	AL = function
	    00h determine whether function is available
		DX = index of function
	    01h set function availability
		DX = index of function
		???
Return: nothing
SeeAlso: AH=05h,AH=07h
----------F707-------------------------------
INT F7 - FSBBS 2.0 - DUMP FUNCTIONS
	AH = 07h
	AL = function
	    00h get current dump mode
		Return: DL = mode
	    01h set dump mode
		DL = mode
SeeAlso: AH=06h
--------*-F8---------------------------------
INT F8 - reserved for user interrupt
--------h-F8---------------------------------
INT F8 - Sanyo MBC-550/555 - IRQ0 - 100 HZ INTERRUPT
Note:	normally masked off at 8259 interrupt controller
SeeAlso: INT 08"IRQ0",INT F9"Sanyo",INT FA"Sanyo"
--------T-F8---------------------------------
INT F8 - DoubleDOS - ???
--------*-F9---------------------------------
INT F9 - reserved for user interrupt
--------T-F9---------------------------------
INT F9 - DoubleDOS - ???
--------h-F9---------------------------------
INT F9 - Sanyo MBC-550/555 - IRQ1 - ???
Note:	documented as "for system use only"; normally enabled at the 8259
SeeAlso: INT 09"IRQ1",INT F8"Sanyo",INT FA"Sanyo"
--------*-FA---------------------------------
INT FA - reserved for user interrupt
--------h-FA---------------------------------
INT FA - Sanyo MBC-550/555 - IRQ2 - SERIAL PORT USART INTERRUPT
Note:	this vector is not used on the Tandy 1000TL
SeeAlso: INT 0A"IRQ2",INT F9"Sanyo",INT FB"Sanyo"
--------T-FA---------------------------------
INT FA - DoubleDOS - TURN OFF TIMESHARING
SeeAlso: INT 21/AH=EAh"DoubleDOS",INT FB"DoubleDOS"
----------FA---------------------------------
INT FA P - ASM Edit - INSTALLATION CHECK
Program: ASM Edit is a shareware programmer's editor
Note:	ASM Edit hooks this vector in protected mode to allow DPMI programs
	  to detect whether they were run while shelled to DOS from ASM Edit

Format of ASM Edit signature block:
Offset	Size	Description	(Table 3681)
 00h	BYTE	CFh (IRET)
 01h  8 BYTEs	signature "ASM Edit" (no trailing NUL)
--------*-FB---------------------------------
INT FB - reserved for user interrupt
--------h-FB---------------------------------
INT FB - Sanyo MBC-550/555 - IRQ3 - KEYBOARD USART RECEIVE INTERRUPT
SeeAlso: INT 0B"IRQ3",INT FA"Sanyo",INT FC"Sanyo"
--------T-FB---------------------------------
INT FB - DoubleDOS - TURN ON TIMESHARING
SeeAlso: INT 21/AH=EBh"DoubleDOS",INT FA"DoubleDOS"
--------*-FC---------------------------------
INT FC - reserved for user interrupt
--------T-FC---------------------------------
INT FC - DoubleDOS - GET CURRENT SCREEN BUFFER ADDRESS
Return: ES = segment of display buffer
Desc:	determine the address of the virtual screen to which the program
	  should write instead of the actual video memory, so that the
	  multitasked programs do not interfere with each other's output
Note:	the display buffer may be moved if multitasking is enabled
SeeAlso: INT 21/AH=ECh"DoubleDOS",INT FB"DoubleDOS"
--------h-FC---------------------------------
INT FC - Sanyo MBC-550/555 - IRQ4 - PRINTER READY INTERRUPT
Note:	normally masked off at the 8259 interrupt controller
SeeAlso: INT 0C"IRQ4",INT FB"Sanyo",INT FD"Sanyo"
--------*-FD---------------------------------
INT FD - reserved for user interrupt
--------T-FD---------------------------------
INT FD - DoubleDOS - ???
--------h-FD---------------------------------
INT FD - Sanyo MBC-550/555 - IRQ5 - FLOPPY DISK CONTROLLER
SeeAlso: INT 0D"IRQ5",INT FC"Sanyo",INT FE"Sanyo"
--------S-FD---------------------------------
INT FD - TFPCX - INSTALLATION CHECK
	AH = function (also see separate entries below)
Program: TFPCX is an interface between modem and terminal program for packet-
	  radio communications
Notes:	the installation check consists of testing for the string "N5NX" three
	  bytes beyond the interrupt handler; INT FD is the default, but may
	  be changed, so the full installation check consists of scanning
	  for the signature
	TFPCX returns AX=FFFFh on any unsupported function call
SeeAlso: AH=01h,AH=03h,AH=FEh
--------S-FD01-------------------------------
INT FD - TFPCX - TEST FOR CHARACTER WAITING
	AH = 01h
Return: AX = status
	    0000h no characters waiting
	    0001h character available for input
Program: TFPCX is an interface between modem and terminal program for packet-
	  radio communications
SeeAlso: AH=02h
--------S-FD02-------------------------------
INT FD - TFPCX - GET CHARACTER
	AH = 02h
Return: AL = character
Notes:	this call is only allowed if AH=01h indicated that a character is
	  available
	all available characters should be read before sending any additional
	  characters
SeeAlso: AH=01h,AH=03h
--------S-FD03-------------------------------
INT FD - TFPCX - OUTPUT CHARACTER
	AH = 03h
	AL = character to send
Return: nothing
SeeAlso: AH=02h
--------S-FDFE-------------------------------
INT FD - TFPCX - GET VERSION
	AH = FEh
Return: AH = major version
	AL = minor version
Program: TFPCX is an interface between modem and terminal program for packet-
	  radio communications
SeeAlso: AH=01h,AH=03h
--------B-FE---------------------------------
INT FE - AT/XT286/PS50+ - destroyed by return from protected mode
Note:	the ROM BIOS uses 0030h:0100h as the initial stack on startup, which
	  is the last fourth of the interrupt vector table.  If the processor
	  is returned to real mode via a hardware reset (the only possibility
	  on an 80286, though there are a number of ways of generating one),
	  then the BIOS startup code stacks three words on its scratch stack
	  before determining that a return to real mode has been requested.
	  As a result, INT FE and INT FF are corrupted.
SeeAlso: INT FF"XT286"
--------T-FE---------------------------------
INT FE - DoubleDOS - GIVE UP TIME
	AL = number of 55ms time slices to give away
Return: after other program (if active) has run
SeeAlso: INT 21/AH=EEh"DoubleDOS",INT F4"DoubleDOS"
--------G-FE---------------------------------
INT FE - Turbo Debugger 8086 v2.5+ - OVERLAY MANAGER
SeeAlso: INT 3F
--------h-FE---------------------------------
INT FE - Sanyo MBC-550/555 - IRQ6 - 8087 COPROCESSOR INTERRUPT
Note:	normally masked off at the 8259 interrupt controller
SeeAlso: INT 0E"IRQ6",INT FD"Sanyo",INT FF"Sanyo"
--------B-FF---------------------------------
INT FF - AT/XT286/PS50+ - destroyed by return from protected mode
Note:	(see INT FE"XT286")
SeeAlso: INT FE"XT286"
--------b-FF---------------------------------
INT FF - Z100 - WARM BOOT
SeeAlso: INT 40"Z100"
--------h-FF---------------------------------
INT FF - Sanyo MBC-550/555 - IRQ7 - USER INTERRUPT FOR EXTERNAL INTERRUPT
Note:	normally masked off at the 8259 interrupt controller
SeeAlso: INT 0F"IRQ7",INT FE"Sanyo"
--------Q-FF---------------------------------
INT FF U - QEMM-386.SYS v6.0+ - internal
Notes:	requires that a byte in the conventional-memory stub be set to the
	  desired function number (00h through 0Ch)
SeeAlso: #3682

(Table 3682)
Values for QEMM internal functions:
 00h	reflect back to Virtual86-mode interrupt handler (default)
 01h	???
 02h	access DR7???
 03h	QPI upcall (see INT 67/AH=3Fh)
 04h	???
 05h	???
 06h	INT 15/AH=87h
 07h	EMS services (see INT 67/AH=40h,INT 67/AH=5Dh)
 08h	???
 09h	QEMM exception handler
 0Ah	XMS services (see INT 2F/AX=4310h"XMS")
 0Bh	Virtual DMA Services (see INT 4B/AX=8102h)
 0Ch	???
--------v-FF---------------------------------
INT FF - VIRUS - "Violetta" - ???
Note:	used but not chained by virus
SeeAlso: INT E0"VIRUS",INT F1"VIRUS"
--------V-FF----BX0000-----------------------
INT FF - PC/FORTH - GRAPHICS API - VIDEO STATUS CHANGE
	BX = 0000h
	DS:SI -> FORTH program counter
	SS:BP -> FORTH parameter stack
	SS:SP -> FORTH return stack
	DS:DX -> FORTH video parameter area
Desc:	called to inform graphics driver of any status changes such as video
	  mode changes, character color changes, graphics XOR mode turned on
	  or off, etc.; also used as an installation check
Index:	installation check;PC/FORTH
--------V-FF---------------------------------
INT FF - PC/FORTH - GRAPHICS API
	BX = function number
	    0001h function REDRAW
	    0002h function !PEL
	    0003h function @PEL
	    0004h function LINE
	    0005h function ARC
	    0006h function @BLOCK
	    0007h function !BLOCK
	    0008h function FLOOD
	DS:SI -> FORTH program counter
	SS:BP -> FORTH parameter stack
	SS:SP -> FORTH return stack
	details of parameters not available
Return:	AX,BX,CX,DX,ES,DI may be destroyed
Note:	these functions all display an error message if the graphics routines
	  are not resident
--------!---Admin----------------------------
Highest Table Number = 3682
--------!---FILELIST-------------------------
Please redistribute all of the files comprising the interrupt list (listed at
the beginning of the list and in INTERRUP.1ST) unmodified as a group, in a
quartet of archives named INTER54A through INTER54D (preferably the original
authenticated PKZIP archives), the utility programs in a fifth archive
called INTER54E.ZIP, the WinHelp-related programs in a sixth archive
named INTER54F.ZIP, and the non-WinHelp hypertext programs in a seventh archive
names INTER54G.ZIP.

Copyright (c) 1989,1990,1991,1992,1993,1994,1995,1996,1997 Ralf Brown
--------!---CONTACT_INFO---------------------
Internet: ralf@pobox.com (currently forwards to ralf@telerama.lm.com)
UUCP: {uunet,harvard}!pobox.com!ralf
FIDO: Ralf Brown 1:129/26.1
	or post a message to me in the DR_DEBUG echo (I probably won't see it
	unless you address it to me)
CIS:  >INTERNET:ralf@pobox.com