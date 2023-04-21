program bfire; { My first Fire! }
uses crt,gfx3;
var x,y:integer;
    col:byte;

function setscreenmode(mode:byte):boolean; assembler;
asm
 mov al,[mode]
 xor ah,ah
 int $10
 mov ah,$f
 int $10
 cmp al,[mode]
 je @itworked
 xor al,al
 jmp @end
@itworked:
 mov al,1
@end:
end;

procedure setpal;
var pall:byte;
begin;
pall:=0;

repeat
   pal(pall,pall*8 ,0,0);
   pall:=pall+1
until pall=7;

repeat
   pal(pall,63 ,pall*8,0);
   pall:=pall+1
until pall=15;

repeat
   pal(pall,63 ,63,pall*4);
   pall:=pall+1
until pall=31;
repeat
   pal(pall,63 ,63,pall*4);
   pall:=pall+1
until pall=63;

end;




{procedure PutPixel (x,y: integer; c: byte); assembler;
 asm
  mov ax,y
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,x
  mov ax,0a000h
  mov es,ax
  mov al,c
  mov es:[bx],al
 end;
{--------------------------------------------------------}
{function GetPixel (x,y: integer): byte;

begin
 asm
  mov ax,y
  mov bx,ax
  shl ax,8
  shl bx,6
  add bx,ax
  add bx,x
  mov ax,0a000h
  mov es,ax
  mov al,es:[bx]
  mov @result,al
 end;
end;
{********************************************************}



procedure drawfire;

begin;
    x:=0;
    repeat
    col:=random(255);
    putpixel(x,199,col,vaddr);
     x:=x+1;

    until x>319;
end;

procedure changefire;
var cury,curx,newcol:word;
    t1,t2,t3,t4:byte;
    tr:integer;
begin;
     cury:=198;
     repeat
       curx:=0;
       repeat
         t1:=getpixel(curx+1,cury,Vaddr);
         t2:=getpixel(curx-1,cury,Vaddr);
         t3:=getpixel(curx,cury+1,vaddr);
         t4:=getpixel(curx,cury-1,vaddr);
         tr:=(t1+t2+t3+t4) div 4;
         if tr>0 then tr:=tr-1;
         putpixel(curx,cury-1,tr,vaddr);
         curx:=curx+1;
       until curx=319;
       cury:=cury-1;

     until cury=(199-20);



end;
function stdpal:boolean;
begin
asm

  mov dx, $03C9     { Routine to set up the palette       }
  mov cl, 32       { CH is already zero                    }
@L1:
  mov al, cl       { Set up the reds. Less red (only 32 or so}
  dec dx           {   palette entries) makes the flames seem }
  out dx, al       {   hotter                                  }
  shl al, 1
  dec ax           { Same effect as dec al, but with one less byte}
  inc dx
  out dx, al
  xor al, al
  out dx, al
  out dx, al
  loop @L1

  mov cl, 63       { CH is already zero  }
@L2:
  mov al, cl       { Set the oranges      }
  add al, 32
  dec dx
  out dx, al
  mov al, 63
  inc dx
  out dx, al
  mov al, cl
  out dx, al
  xor al, al
  out dx, al

  mov al, cl       {; This section sets the yellows }
  add al, 95
  dec dx
  out dx, al
  mov al, 63
  inc dx
  out dx, al
  out dx, al
  mov al, cl
  out dx, al

  mov al, cl       {; This section sets the blues    }
  add al, 158
  dec dx
  out dx, al
  mov al, 64
  sub al, cl
  inc dx
  out dx, al
  out dx, al
  mov al, 63
  out dx, al
  loop @L2
end;
end;


begin;
randomize;
setupvirtual;
setmcga;

stdpal;
cls(vaddr,0);
cls(VGA,0);
repeat
drawfire;
changefire;
hline(0,320,199,0,vaddr);
flip(vaddr,vga);
until keypressed=true;
shutdown;
settext;

end.
                                                                                                                                                                                                                                                                                                                                              U   1     \!¢Sb16         1     \!£Sbcd     ë   1     !}E scanned SCANNED    6   1     D!´£ send SEND       1     l#e) Snoop SNOOP    Ì   1     k#¼-Starcon2     	   1     c"*Stuff     b	   1     Ä"x7Symantec     ­	   1     ª"i- tasm TASM    ø	   1     %#SATc3     C
   1     8$Ç tek TEK    
   1     n#«Temc     Ù
   1     D!5 temp TEMP    $   1     x#4Temptemp     o   1     t#]Tmate     º   1     G#ãTools        1     #YToolwork.s     P   1     v!D¸Tp        1     "$ØTps     æ   1     \!
"Univbe     1   1     s#Vb     |   1     h#Vbe     Ç   1     #¾ vbs VBS       1     B!?Win95     ]   1     %#I winamp WINAMP    ¨    1     D $5 winfract WINFRACT    ó   1     n#6Wolfsrc     >   1     y""Worms        1     [!T²Zips     Ô  & 2   "K" __ofidx.ffa __OFIDX.FFA      & 2  °  "K" __ofidx.ffl __OFIDX.FFL    j  ( 2  Ð
 "K" __ofidx0.ffx __OFIDX0.FFX    µ   2 ~ ê"Ò 80839_~1.jpg        & 2 X  ½"Ì2  96_OVAL.txt 96_OVAL.TXT    K   2 û+  Â"r  Addd.doc        2   Â"e" Addres~1.doc     á   2 ¥  9$9¦ Autoexec.bat     ,  6 2  @  ."
  bill and etta jan 1997.doc BILLAN~1.DOC    w   2 Â` <"| Cm.zip     Â   2 Æj ê@¦Command.com        2   t#Y Config.sys     X   2 çk  $#0 Crack.uue     £   2 0   û¹ Deer.bat     î   2 w ê@¦Drvspace.bin     9   2   ê@¦  exp.bak EXP.BAK      ( 2   E!Í! explorer.exe EXPLORER.EXE    Ï    2 Z  ½"ÏA  file.reg FILE.REG       2 ­ í &³ Fmail102.zip     e  - 2  :  X"0  French Street.doc FRENCH~1.DOC    °   2 ¥\  í"] Hubble.gif     û   2 |  í"É Hubble.xxe     F   2  ( þ"G!Image.bak        2  ( þ"G!Image.dat     Ü   2    þ"G'Image.idx     '   2 ¬g ê@¦Io.sys     r   2 Ûf  Û L.com     ½   2 6ø N"Ê Logo.bmp        2 :õ ?"e¹ Logo.sys     S   2    T b. Magic_pc.os        2 i   #u Mailmer.bas     é   2 y  æ"P± Mars.txt     4   2 ¥í  í" Mars.xxe        2 ¦©  í"d Marsufo.gif     Ê   2 2è  í" " Marsufo.tif        2 K y#±5 Me.me     `   2    y# Me.reg     «   2 t   ÿ" Menu.bat     ö   2 Ö  #C Merge.dat     A   2  Q  ­¤ Mouse.com        2 z   Ã"ÏMsdos.sys     ×   2 ]   c!: Netscape.lck     "   2 + #K Nodelist.zip     m   2 ay > j% Ontrk702.zip     ¸   2 ¹  HRC Ovalcheq.95        2 Âr  ?h Pkunzip.exe     N  * 2 Ú  1#e&  Principals.ans PRINCI~1.ANS      * 2 ñ  1#W&  Principals.txt PRINCI~1.TXT    ä   2 4   x#MA Regis.reb     /   2 (  ã"> Robvga.pas     z   2    '#6 Runwin.bat     Å   2 ì #9 Scanne.jpg        2 ¦¸ 8# Scanne.wmf     [   2 -  x#­A'System.dat     ¦   2 D¤ z#ô System.wor     ñ    2 t  E#-  temp.txt TEMP.TXT    <    2 # x#MA'User.dat         2     z#ô User.wor     Ò   " 2   ê@¦  usere.bak USERE.BAK    !   2   ;$Î  Win386.swp     ;  & 1     ;$X' Earth Worm Jim EARTHW~1    h!   1     ;$i0 MiBDemo MIBDEMO    h!      O  °  O        Text        ö Layout     è             þÿÿÿþÿÿÿ  è              þÿÿÿ     è             ÿÿÿÿÿÿÿÿ  è            ÿÿÿÿÿÿÿÿ      è      è      è            ÿÿÿÿÿÿÿÿ     è             ÿÿÿÿÿÿÿÿ     è             ÿÿÿÿÿÿÿÿ     è             ÿÿÿÿÿÿÿÿ         	  LayoutAux              Wrap    f   Ø  f         msacm.imaadpcm         MaxRTEncodeSetting            MaxRTDecodeSetting   f   Ù  f         msacm.msgsm610         MaxRTEncodeSetting            MaxRTDecodeSetting     Ë            0       A  bhhphijojgfcdocagmhjgjbhmieinfap immbkmbpjfdkajbkncahcedfmndgehbaMicrosoft Corporation       A  bhhphijojgfcdocagmhjgjbhmieinfap immbkmbpjfdkajbkncahcedfmndgehbaMicrosoft Corporation       A  bhhphijojgfcdocagmhjgjbhmieinfap cdikdekkiddcimdmcgedabijgpeobdhdProgressive Networks, Inc.A  bhhphijojgfcdocagmhjgjbhmieinfap cdikdekkiddcimdmcgedabijgpeobdhdProgressive Networks, Inc.ny of New Zealand Limitedocagmhjgjbhmieinfap inngpejjbbcpimikohnbjkbpnddoaphaThe Internet Company of New Zealand Limited-   Ì             Active Setup   u   µ  u %   Ú            jobsst        .   Ü  !          IE40.Comctl32stallModes012*   Ý     	       RegBackup       Prio.   Þ  !          IE40.ControlsM         *   ß     	       RegBackupInstallFlagA+   à     
       IE40.Assocÿ¯        *   á     	       RegBackupes012       -   â             IE40.Browseriority2   h  *   ã     	       RegBackup      Insta1   ä  $          IE40.OnlyBrowser         Pr*   å     	       RegBackup BRANDING.CAB.   æ  !          mshtml.DllReg    ReInsta*   ç     	       RegBackup  e   ÿÿÿÿH° /   è  "          mshtml.InstalllModes      *   é     	       RegBackup Priority  &   ê  %         Msxml           %   ë            CTLs  ReInstall%   ì            Rooty   P   ÿÿÿÿ-   í             Certificatesents        %   î            CRLs  i   ÿÿÿÿK®%   ï            CTLs      Insta«  ð  «  (      234157A672940A39C07CF8039E8ECE11D1DC53DC        _Blob         #AW¦r
9À|øÎÑÜSÜ	         0++         00v 0	*H÷ 0Î10	UZA10UWestern Cape10U	Cape Town10U
Thawte Consulting cc1(0&UCertification Services Division1!0UThawte Premium Server CA1(0&	*H÷	premium-server@thawte.com0960727180714Z980727180714Z0Î10	UZA10UWestern Cape10U	Cape Town10U
Thawte Consulting cc1(0&UCertification Services Division1!0UThawte Premium Server CA1(0&	*H÷	premium-server@thawte.com00	*H÷  0 Ò66j×Â[ÚAb8îIUÖÐïGïH5:Rô+j;/êVã¯÷´euMïË	¢!QØÐgÐºsÔË* \N¼úRüòDnÚJn/-ãùª:s¶FSXÈ½¸s?ªôBMç@7 0	*H÷  ºÑH4YU«!Ëö[ÑÃÑ"~ûèä¤ÙÞås6|°á?#%ä<ëºHô´7°)Üi{ê«â^û¬¸ö´D~}WTóì¹3£1ò"0­úá_ð|ÇBý	.¿èDAÌöüJÝV]-°"hÌ¬¯©ÅÂ  ñ    (      A2FE21413C2840117978985BEA1E91DA9008B1F0        KBlob         ¢þ!A<(@yx[êÚ±ð	         0++       ý  0ù0b 0	*H÷ 0Ä10	UZA10UWestern Cape10U	Cape Town10U
Thawte Consulting cc1(0&UCertification Services Division10UThawte Server CA1&0$	*H÷	server-certs@thawte.com0960727180757Z980727180757Z0Ä10	UZA10UWestern Cape10U	Cape Town10U
Thawte Consulting cc1(0&UCertification Services Division10UThawte Server CA1&0$	*H÷	server-certs@thawte.com00	*H÷  0 Ó¤PnÈÿVkæÏ]¶êhuG¢ªÂÚ%ü¨ôGQÚµ tuÉéaõm0néRÀbÛMâjD8Íþ¾ãd	pÅþ±k)¶/IÈ;Ô'%/çmÀ(B×LCÞÃõ!mT]ÃXáÀäÙ[°¸Ü´{ß6:Âµf"Ö 0	*H÷  /¸_tT"»Ø^ÚHà3¢&êÎÁWe÷|7îmÑvuÔÅ 38u×·®dïÍFP&(côßb0Äïv'%+ä7£OÚng¼P¨ù.Nú?ãæQC´ Æ¯x?(á§ðèòüh66¼ÁÆHù}û»Ñ  ò  Ñ  (      36863563FD5128C7BEA6F005CFE9B43668086CCE        Blob         65cýQ(Ç¾¦ðÏé´6hlÎ	          0+++       -  0)0  0	*H÷ 0Ï10	UZA10UWestern Cape10U	Cape Town10U
Thawte Consulting1(0&UCertification Services Division1#0!UThawte Personal Premium CA1*0(	*H÷	personal-premium@thawte.com0960101000000Z201231235959Z0Ï10	UZA10UWestern Cape10U	Cape Town10U
Thawte Consulting1(0&UCertification Services Division1#0!UThawte Personal Premium CA1*0(	*H÷	personal-premium@thawte.com00	*H÷  0 ÉfÙøDÏ¹.ð¡ïElßÞ'Q6All;íþ}åBþ`1Ãf·s:H®NÐ27µ¶ÙóòDÙÕÝvMòüo#zñØENïBÐCumJÞâªÉ1ÿ p|fÏ%ºúî éFf';ª[òÝ6B²Úu £00Uÿ0ÿ0	*H÷  i6÷4*3r/m;Ô"²¸oÅ6f<¡±uZæý5Óø¨òogÞ+¹â°: ð¢ ßón»ÈZùÿ¾t=óþ0%Ñ74gú¥qy0a)rÀà,LûVä:¨oå2YRÛu(PYøä¬Ù¯/PÛÃê«3àõ+1Á  ó  Á  (      9E87803EC5689AEFE77F92F91ABFA7467C76ED02        uBlob         >Åhïçù¿§F|ví      .   A T T   D i r e c t o r y   S e r v i c e s   	          0+++       ã  0ß0H 0	*H÷ 0910	UUS10U
AT&T10UDirectory Services0960118210352Z010116210352Z0910	UUS10U
AT&T10UDirectory Services00	*H÷  0 dr '¬Æ"þ @iH¯ÆÍ#3ãÅ1~¶¢¬ã°*l¶ÔÞKúñ¢ }ÎK¾¾&H	ÞË"çÂîDQþgÕ[Zà7T¸;2±Ml¤©v¬¸¤÷«l¥CºnOÅN 0<?Ú¢ ºív¬ Õm0	*H÷  8P
Ó»¢lªBä%«ûU®mºSgìUr_$°ÛÊd½dªÂÙ=¢E·ÆqQïíáQTV5¡ÎäDÄGfÿÚ#Â³ÔbJ¼U³ÝOíZµ.¼øKÎÆÔp³³"ø^\6z¦¸9sFC\½~§Ï%6Ñ  ô  Ñ  (      A275E026ACD854794A4AA2CB53F66233129C55B6        Blob         ¢uà&¬ØTyJJ¢ËSöb3U¶      (   G T E   C y b e r T r u s t   R o o t   	          0+++       ù  0õ0^ 0	*H÷ 0E10	UUS10U
GTE Corporation10UGTE CyberTrust Root09602231915Z9912312359Z0E10	UUS10U
GTE Corporation10UGTE CyberTrust Root00	*H÷  0 ¸æOºÛ|q|¯D·ÓFÙdåÁBÇºI5-zç½å1YÆ±/
û§?¢	fV7)é~Ê¥õ£Õ¢FØhLÑ7h¯½ø°³ð)õZ	aw
"%ÔOEªÇ½åßùÔ¨BÌ$À'Jµmc9Ä¢^8 0	*H÷  4	BH|$ÂexkM*¯ííðj-7ëWQ­-¡@jAöir¿ NUç¦W]CÉøqã>$9ëa"÷¢B#Ê6
ÑÈJñ³ý ÐÆîUòLb´sHØ°N°u¼¹ñ ¢íÿ£O¢  õ    (      245C97DF7514E7CF2DF8BE72AE957B9E04741E85        3Blob         $\ßuçÏ-ø¾r®{t      2   M i c r o s o f t   T i m e s t a m p   R o o t   	         0
+       ±  0­00	*H÷ 01 0U
Microsoft Trust Network10UMicrosoft Corporation1-0+U$Microsoft Time Stamping Service Root1+0)U"Copyright (c) 1997 Microsoft Corp.0970513161259Z991230235959Z01 0U
Microsoft Trust Network10UMicrosoft Corporation1-0+U$Microsoft Time Stamping Service Root1+0)U"Copyright (c) 1997 Microsoft Corp.00	*H÷  0 ·Z8õ7Ì©CÄÜ$¾òR´[_¹Km¨ÿÍ@PlÓ Ó\GÂ¹÷äÍ}5i7¯=Ýý4ÂÄyÌYtoÃèë8GSáñäð Ú*z=ÂRÿ{2¿X%&ËÉÄ$¼I×z³%3¼mG 0	*H÷  P[ÅkoR[É½¬4sÊ
Ê®LJº¤ëRp!àµ¡`N÷CQ¯:pÎ¿¶(gëè@\ý¸%û6oov>ÅLâ§QúÊÁcº^$GröDÎ§:P±Y«Ï>ßÇúÃkÜd@+E$®I/öß  ö    (      18F7C1FCC3090203FD5BAA2F861A754976C8DD25        DBlob         ÷ÁüÃ	ý[ª/uIvÈÝ%      4   V e r i S i g n   T i m e   S t a m p i n g   C A   	         0
+       À  0¼0%JÒ8Y¥]s_]Ü£0	*H÷ 010U
VeriSign Trust Network10UVeriSign, Inc.1,0*U#VeriSign Time Stamping Service Root1402U+NO LIABILITY ACCEPTED, (c)97 VeriSign, Inc.0970512000000Z040107235959Z010U
VeriSign Trust Network10UVeriSign, Inc.1,0*U#VeriSign Time Stamping Service Root1402U+NO LIABILITY ACCEPTED, (c)97 VeriSign, Inc.00	*H÷  0 Ó. ðh|,-.±²§·WÚSØuãÉ3*²Ôö	[4óéþ	ÐÛZ¹Íçö±À%ë}XsjxËqýÆXö)«X^ý-bXÊqÕ"X/ÕÌ6ºª´MJéî;"­V~!lÀJGj´¦6Õü	-Ó´9 0	*H÷  aU>{Ç~"ÌÔ³+[èDäx¤~ó§râYïÌãLÛNaï³¤ûF=P4pVö*Îåc¿yis.°(õíª©Ò]Í
Ê	Î³¯(Äy)ÜÿºgBH¦ä¿aøSåÑs?øýO¬UÑýcc  ÷    (      0D974461703713CB74932D2A75ACBC714B281266        ¹Blob         Dap7Ët-*u¬¼qK(f      <   V e r i S i g n / R S A   S e c u r e   S e r v e r   C A   	         0
+       -  0)0A  0	*H÷ 0_10	UUS1 0U
RSA Data Security, Inc.1.0,U%Secure Server Certification Authority0941109235417Z991231235417Z0_10	UUS1 0U
RSA Data Security, Inc.1.0,U%Secure Server Certification Authority00	*H÷  0~ ÎzÁ®>ZªW¬%v­®,7Îë5xdTå@QÉ¿âÒ7Ué±!­vh¢KÉK%f"Vl÷Ymepqv>wLãPVH¹§).JYÕIT,s:i±9mpgHåÝ-ÖÈ{ 0	*H÷ ~ ÑÑy!ÎâèøÁ}4S?aÙ¶8¶è¾! ¸S~Dg"½'àÌJö;²â¾Óåé¯\Fÿ¡^>è6Xzs¦
ø"kÃ	8~&»sï ½¤ó0?ap{ þ2£³ôgRÜ´î6 Þq!©'  ø  '  (      4EFD5F66EF74D6B69F89744B25D67BC98EA57A79        ÛBlob         Ný_fïtÖ¶tK%Ö{É¥zy      8   V e r i S i g n   C l a s s   4   P r i m a r y   C A   	      *   0(++++       5  010¦  0	*H÷ 0_10	UUS10U
VeriSign, Inc.1705U.Class 4 Public Primary Certification Authority0960129000000Z991231235959Z0_10	UUS10U
VeriSign, Inc.1705U.Class 4 Public Primary Certification Authority00	*H÷  0 Ð²uöxÐ®ZPôéP©×ïpèÒ$vÖß¬æ2ðG¼e®¿éuc ½X¨Á$éå1x½ü-7jxéFuùí£û{ÈÁLÒ£ïõ<°bJ];Ýg¹Á<Ö§&ìÃ;zÙM¼mèãðG© 0	*H÷  SÝÓð$~@ªâü ×Úü2a¸óúW3|¯éaÈz³·ÿ±ÜÜ¬üpÉ8BíDö.[k3i¬Ó\ç_ZÇ±-yAA±<º9Æ;ð&Éî½ÌBÿÇ?Txõ¼ª`|~~~}~}}}~}~|~}|}~}|~|{~|{}|{|||{z||z}{{}z|{y|{z{zyzzy{zx{yy{ywy{yxyzyxzyxyyyzyxyxwzyxwxxwyzwwyxwxxxxywxxxxxvwywwywvyxwxwvyyvyxxxwyzvxzxxxxzxy{yx{zyyy{zzyy{yz|zy{{z{|zy||{|{z|{y|}}|z{{|~zz||||{|}||}|}}|}|~}}~~}}~~~~~|~~~~~~~}~~~~~~|~}|~|}}}|}}}||||}{|}{|}{{||{{z{z{{z{zz|{x||y{yy|zxx{yx{zzyyzzzyyx|zw{zwzywzww{wwzwxywxwxxvxxwyxvywwxvwwwxuwyuwyvvxxxvwywwywwy{zvxzxyzyzyyzyy{zyz{{zz{z{|y||y{{{{z||zz|zz|zz}|z{|{||{}||~|{}}}~||~}}}~}~}}~}~~~~~|}}~~|~}}}}}}}|}||}||}|}|{{{{{|{{{{{z|yy}zz|xy|yy|yx{zyww}zx{yy{xxzzzzyzzyzxy{zzxx{{xxyxzywxywyzxzzvxywxywxxxyxwwyywwyxwyxxywwyywxzzxxzyx{yxz|{xy{{yz{z{{yzz||zz{||xy~|z{|y{|}||||~}z{}|{}|{}~{|~}z~{}~}~}}~}}~~~~~~~~~~}~~}}}}}{|~~~||~|~~{|}}|{}|{||zz|z}{x|}zzy{|zyz{y{zxzzyyyyyzyxx{yvzzwzzzyxyzxw{zvyzxwyxx{xx{xvxywxzxwywvyxwyxvwyxvwzxwyxwywvzywyxwxyxxyyxzxwzzxyyyzxy}ywz{zyz{zz|zy|zz}z||z{}{z|~{z}{z~{y}{z{|z~{~}|~~|}~~~~~~~~~~~|~~}||~~~}}~{}|}{{|{~~|{{}~{z{||{||{z|{z|zz}yy|yy|{xz{yy{xy{zyyyy{ywz{xz{wx{zxwy{xwxxyzxvxyxxywvzyvxxxwwwwxwxwvwwwwwxywvxxxwwxxxwxyyww{yxzxyzyzxz|yxzzz{zy{zzzz|{zz{}zz{{|{z{||{{{{{|{{}{{{{}{{||~}y{}{~}{~|}~~|~}}~~~}~~~}~~~~~~~~~~}{~|{~{~}|}{}}{|{{|{z|{{{z}{y|{zzyz{{xy|zwz{yz{ywy{xwzzxyyyzxxyzzxxxxzyxxwxzyvyzxxyxxzxvxwwyvuzxuywtxyvwxwvwvwzvuzxvzyvyxwyxxxywv{xv{zxzzyzzzyy|yx{yy{yyzz{zzz{{zzz{{|{y|{z{{}|z}|z|}z{}}~{|||}~~|~~~}~~~~~||~~|}}}~}~|}~}}|}}}|||{}||}{{|{{{|{y{~zz}{yz}{w||xz}zx{{yz{yy{{xz{xy|yv|{vzzx|zvyzyyxxyyxyxxxzxwzxwyvvyywvwxvwwwyyvxxwyxvxxyywxxwyxy{ww|yyzyyzzzyyzzzyy||x{|z||z{z{|{z{|z{{||z{{}|z{{||z||{{|{|}{{}}{{~}{|~}|~~}}}~~~|~~~~~~}}}~}~~~~~}}~}~}{~||}||||}|z||{{z||z||z{|y{|z{z{zyz{{yz{{{xy|zyz{xx|zwy|zw{zwzzyyyxzywyxyzwxyxyxyxyzwwywwzwv{vu{vvzwwxvwywwxwxyxxwwywyywzzwz{xyzxy{zyyyyzzzzzz{{x{|z{{z{}zy}|z{{z|}z|}z|||}|z{{z~|{}||}|}{{~~~}~~}}~~~~~}}}}~}}~~}|~~}}}|~}|}||}z|}{z{|z{}zz|yz}{yzy{{xz{yy{zyyxzyxzzyxz{wx}yx{zyzzxzxw{zxxyyy{zxxyyxyyxxwyyvyyvwzywxwwwwxwwwxxxxwxwxywxxwyyuxzxyyxzzx{zw{|yzyz|yz{y|{{|z{|{}|z||z}|{~{{~{|~|{}{{}|}}||}}|{~}{~~{{}~~|~}~}~~~~~~~}~~~}}~}~~~~~~}}~}}||~~{|}|{|}{z}}{}zx}x||y{{y{|zxz{{yxx{yx|{wyzyzzywy{xzxwzzxxywyxxyxxxxyyxwwxyzxwxxwwxxxvvywwxvxwxxvxxvxyvxyvxxvxxxzwxywyzxxyxyyyzyxyzyyyz{yw|{xzzz|yz|yz{z{{z}zy~zy|||z|}{||||}}{|}||~}~}}}}~~}~~~~~~}~~~~~~}~~~}}~{~~}~~~|}~||~}{}}{|}||}{|{y~}z||{|{||y|{y|{yzzz{zy|yw}zx{zzzyyzyyzyxyzzxyzxyyxzywxzxwyxxzyxyxxyxxzxvyywxwwxxyxwywxxxyxxyxwzywywx{xvzyyzyxzzzyz{xy|xx|{yyz{yy}|yy{|yzzz||{{{{|{{{|||||y{z{|{}|}|{|~}~}|}|}}}~~}~}}~~~~~~|~{{}~}|}~}{{~|}{{~|||z{}{{|{|{z|zz}zz|zy|yy}zx{|zyz{|zyzz{y{zwz|xyzxzzw{yv{zvyyxywxyux{wvyywwxxwyvuzyuxzuw{vtyyxwwyyxuwzxvzzvzzxyzyyz{yxzzzyzz{{yz{{{zy{{y{{{zzz{{{|z{|}|y|}z{|z|}{|~{{}|{|}z|}{}~}}~~|~}}}}~~~~~}~~~|~{}~}|}}|~z~~zy}~{|}{}|z}{{|{|{{{{|zzzz{{yy|xw}{w{{xyyyyzzyyzyzzv{{wyyxyxyzywwzzwxzxxywxxxyxxyxxywwzwwyxwvxywwxxxywwyxxyywx|xw{yxzxx|zw|zw{}xy|yy|zxz|{y{{z|{z|z{}{{|{z{|{|z}}|}z{}{{}{|~z|{{}||~~}}}}}}~~}}~~~~~}~~|~~}}|~|}}{}|z}}y|}z{{|}{||xz}{zyy|zy{yzzzyyzzyy{zwz{xyyyzyyyxy{yvzyy{xwyzyxxzxvyzwyyvxywwxxyxvxxwxwwwxuwyuyxtx{vxyvxxwyxuzzvxyxyzyxx{ywzzy{yv}{w}{x{|yy{|yz}{z|y{yz}z||{{{|}{{}{}|{{|z|{|}}~}||}~}}~~~~~|}~}|~~{~{}|||}}}|z}}z||y}|x|}y{|x|}yy}{x{|y{{x}|w||x{{z{zx{{yz{{yy{yyzzzyyzyyy{yx{yxzyxyywzywxywwzwuyxvxxxxvwxwxvvzwvyxyywxzxxyxxxyyxyyz{yy{zy||xy|zz|zx}}z{{{|{{z|{z||zz|||}{{{|~|y}|{{{~|{}||~}{}}~~|}~}}{|~}|}~~~~~~~~~~~~~}}~|}~~}~~{}{|}|}~|{}||}{|}z{{|{y||yz|zyy|{x{|wx|yyzzzxzzyzzyzyx{yxzzxxzzxxyzyxyzywyyxzyyzxwyyxyyxyxxyxxxxxwwyzux{wwyxxywvzzxwyzwyywy{xxzxz{xzzyzzzyy}yy~zx|{y{{{zz}yy~{y||{||{{||z|~|{~|{~}~}{}~|~~|~}}~~~~~~~~}~~~~~}~}}~{|~|}}|||{}~|{{{|{y||y{z{}yz{{zxz{yzzyz|xx{xy{yyyz{ywz{xyzzxx{yxzxxzxwzyxyyxxzxxywxywwwwxyxxxvwxyyvwzxwwxxxwwxxxxwxyxyxwyzyyzyzzxyzy{xy}zyyy{{y{{y|{y}zy|{z{{z{{|}y{}zz|}|zz}|z{||}|{}|{~{}{|}}}|~|~{~~~~~~~~}~|}~}~~}|~y~{{}|{{}|y}}z}{z}zz}{z{z||y{{{|xy|{z{yz{y{{xz|zxy{yw|zxzxxzyxzxx{yvyzxxzxw{ywywvxyvvzwuzwuwxwwvxwwxwuxwwxwwxvxzwvyzwvyyvyzxyzxy{yxzzy{xy|yy|yy{|zzy{|y{|yz}{zz|{{{{z{|z||y}|y~}z|}}||}||~~|}||}~}}|~~~}~}|~~}|~~}|~~|~~{||y}{z|~|{|{|||{{{z||y{|{yz|{yy}{y{{{{z{|zxzzz{yy{zy{zyyyzy{zwxzzzxyyyyywxzxxwvyxvywwyxwyxvwwwxwwwwwxwwywvyzwwyxwyzyxyyyyyyyyzzxzxx|yx|zyzyz||yz|zy{{zzzz}|yz}zz}yz|{{|zz}z{}{yz~|y}~z{}}}{}~}~~|}~}}~~}~~~~~~~~~~|~}~}~~}}}}~}z}}z}~z{}|z{}z||{}|yz}zzz{|xz|yz|yz{zz{x{{yz{yyzyyy{{xyyx{xw|xx{xxyxxxyzxyzvyzuyzvyyuyywxyxwwyxwxyxwxywwxxxyxxywwyyxwyxx{xx|yw{zwz{xy{{xy|{y|zyz|{y{z{|z|{{z{|z||z{{z{||{{|||||||}|}|{~z}~{}~||}~~~}~}~~}~~}~~|}~~}~}}}|~}|}||~}|||{}y{{zz|{z|z{{y{{zzzy{}xz|xy{{y{zxzzzyy{xxzyyzyxyyzyvxyyywzzwxxxyywyyxywwyyxwyywwxyxyywxxxwxxwxyxwyyvzzvz{wyzxzzxy{yy{zxy}{x|zz|zy}{y||zz{{{{{{z|{z|||{z|||||||}||||}|}}|}}}||}|~|}}~~}}~~~}~~}||~~}}||}~{}||}{||||{}|{}|{||{{{{|y{}yz|zz{y{{zz{zyzzyzyxy|zvy{wy{yxzxxzxyywxyzxxzxwxwwzxvyxwxwyxvxwxwuxyuw{wuxwwwvyxvwxwwyyywxzzwxzyxyyyyyzyz{yy}{x{{yzzyz|zy{{zz|z{|z{{z|{y||z}{z}|{|{|~|{}~{{~|~{|~}~~}~~~~~~~~~}}~~}~}~~|}~}||}|}{z|||z}}z|}{{}{{{z|{{{z|yx}{x}{y|yy{z|yx|yx|zwzyzzxzyxyyzyyxx{yvzzwzzuwyxyxwxxywvzxwywxywvwzywwwxwwxxyxyxxzyvx{xv{yvzzwyyyyyyz{yyzzyzyy|{yz{{yy|{z{zz{{{z{|{|{y||z|{|}{||||}}}||}|||}~~}|}|~~~~~~~~}~~|~~}~}|~}|~|}{z~}z}|z}|z}{z}{zzz{{yz{z|{zzz{zzyzzz{yy{zz{y{{wz{yyyy|zxyzzyyzyxyxxzyxyxwxxwyyxwxyvwxwxwxwvwwwxwvyxvywvyxvyywwxywxyyxxxyzyyzyx{{z{xy|zx{{y{zz{z{y{}{y||yz{|zy~{x{x~}z|}{{|{||}{|~z{{{~~}~||~~}}~~}~}}~~~~|}||~|}~}|{}~||}||{y|}{{||z{|zz|{y{|yzzz{yz|zyz{{zy{zx{zwzzxzzxzzwzzxxzyx{yvx{ywyvyzvzyvzxwyxwyxvxyxvwzwwxwzxvyyvxzwvzywwzyyyxxxzzyyxxzzxzzx{|xyzz|{xy~yw||zz|}zz|{y{}{{z{{{|{z||{{{{}{z|}{{||{}~{}{}~}}~}~~~~~~~}~~~~~~~~~~~}~~|~||~}|}}}~||}}|}|{||||{{zz||{{{{}z{{yzzy{zy{zyz{zxz{zyyyzywzyx|xvzzxzywyyxyyxxxvxxwxxwxxvwxwwwxvwwwxuvyyuuyxvwwwyywvxwxxwyxxyyyyyyyzyxy|zx{{yzzzx{{{{y{|{{z{{{|zy{{z{|z||y|~{z}||~y{}y|zy~}}~|~~}~{|}}~||~~~~}~||}~~~{~|}}|{}|{|{}~{||zz}{yy|}yz{{|zz||zz{{yy{zz{y{|xz|yy}yw{yy{yxxz{yyzxy{xwxzzywxxyywxzwxywvxxwxywvyywxzxwxxxxyxvyzwxxxyyzwx{xy{xw{yyzxx{zzzzzyyzzyz{{yz|yy}{y}zx|{y{|yy}}x|}{z{}}{{}{|}z|{{}||~~~|}}}}}~~}~~~~~~~}}}~{}|}|~||~|}|{}}{|}|{|}{{|{{}|{{{{{zz||yz}{z{|zz|zzzy{yy|zxzzyywzzxyyyvw{yvyywxxyzwvyxvyyvyzvwywxyvwxxwyyvxzwwyxwyxxyxxyxxyyyzxyzxyxwz|yxzzyy{{y{{z|{xz|zzy{{z{zz|{z|zz||{zz}{z~|y|}||{}}z}}||}~}|~~}}}~}~~}~}~~~~}~}~}~}~|}|{{|}}|{|}{z}||{z|{{{{yy{{zz{z{|xz|zz{{y|{x{{yz{y{zx{yy|xxzyzzxy|xwyzywyzuy|uv{xwzyvxzwwyxxxwxxxxxwxwwzxvyxwwxxxxyyxxxyywy{wxzxyyxz{zyz|zx{{yzzzyz{{{z||y{|zz|z{}yz|{{{{{}~yz~}{||{}|{{|}|}|~~}}}~~}|~|~~~~}~~~}~~|}~~}|~|~}}~|}}|||{}}{}{{||{y|{z|{z}{z~zw}{x|zz|yzzyzzxz{xy{yyzyzyyyxy{yx{xwyxyxvzxuyyvxwxwvxxvwvwxuvxuyytwzwwwwxwwwwxxywx{xwzzxyyyxxzyy{yz|xz|wz}xz{xy|zyz{z{{{y|{x|}zzy{|{{{y||y}|x~}y{}|{{}~z|}z~{|~|~~}~~~}~~~~~}~|~}}|~{}{}~{}}{|}|||zy}}z{|z{{z{|zz{zz{}yx|}zwz{yyzzy{zx{zyzyxx{{wxzzxxzxxzyvyywzywywxyvyxxyvwywwwwyxwxvxzwvyxxywwxxxyxvxzwwzyxxyyzxx{wy|yyxyzzzzzzzz{zzzzz{{zz{{{|{z{{{|{z}{z}}zz|||}|z|}{}}z~~{|~}|~~{}}{}~}~~~~~~}~}~~}}}~}}|}}|~y}~{}|}|z}|y}}z|{z|{z|{z{{zzzyy{{xz|y{zxz{zxzyy{xwzywzyxzyxzxxyxxyyxwzyvyywywxzwwzxwzxwxwywwxwxwwxwwwyxwwxxyywwyyvvyyxxwyywyzyyyzzxzzzzy{yy|zz}zy|{yz{y{{z{yz||{{|{z}|zz}|y|{{}|{{}||~|{}~}}}~{~|}}}}~~~~~|}|}~|}~}}~~}~}|~|{}}}{z}}{||{{|z|}zz}zz|z{{{|{zy{}yy{{yz|zyzz{yw{{xzzwz{wyyx{ywyxxzwvzzxvxzvvyxwyxxxvyywxyxvyxvxwxzxvzywyxxyyxxxyxyyw|yxzxy|yx{yy{yyyz{yyzy|{x{{zzz}zy||y{|y|{y|zz}{{z|}z||z{}{{~{}~{~}|}}}|}~}~~~}~~}}~~}}~~~}~}~~|~~||~~{||}|{}||{{|z||{|{z{{{zzy|{y{zzzzzyzzxy{yxzyy{xy{xxyyyyyyywyyxywxyxxxwwxwxyvwxwxxwywuyytxyuxzuwyvwyuwzvxxvyywxyxxxyyxyzzyyyyxz{xy|yx{zyy|yy|zyz{|{y{|{y{|zz||{z||{|{{|{{}|{|||}{|~|}~~||~|~}}}~~~~~~~~~~~~|~~}}~}|~~|}~}|}}||}}||}{|}{|{z}zz}|{{y|}z{{z{z{}zyz}{x{{xz}zwz{zyyzzxyzzzyzxwzyvxzvyzwyywxywyywwwxxxyww{xuzyvzxuzywyxwyywxzywz{wyzxyzxyyy{ywz{xx|xx|xw|{xzzx{{wy}yx{zy{{y{|yy}{yz{z|{z|z|}{}}{|}|}}|}}|}~||||}~~~~~~~~~}~}~|}~~~|}}}~}|}}{}}z{|{|{{}yz}{z|||zz}|yz|zy}zy{zyz{{{xy|xy{yxyz{xw|ywzxyyxxwzxxzyvxzwxyvzzvvxxwywxxwyvw{wwzwxywwwyzvv{ww|ww{ywwyzxxyyyzyyyy|yx|{zyx|{wy|zzz{z{|z{{z{{y{~{y{|{{z|~{{}|{||{|}}}}}||}~}}~}~{}}}}~~}~}~~~~}~~~~~}}~}~||~{|{z~}|||}}{||{{|}}{y|}z{{{{{{zzy|zy|zz{zzzzzyw|{uz|vxzxyyyzyxyxyywxxxzwwyxzwu{xu{yvyzxwwyxwzxvywxzwxzxxzxwzyx{xv|xw{xxzzxyzyyy{yxzyzzxzzz{yz}zx}yz}y{{y}{x|{{|z{{{|zz|z{}{{|{|}||{{}|}}|~~~||~|}~}~~~~~  ÄéÃÿÿPèÃÿÿÄÇEüÿÿÿÿ3ÀMðd    _^[å]Â Eì  EäÿuìPèPy  ÄÃeèÿuäèµz  ë½ÿ´ÛøVè8ÿÿÄÿt	WèÇz  Ä3ÀéÃÿÿPèÿÿÄé²ÃÿÿPèÿÿÄé¯ÃÿÿPèÿÿÿÄé¬ÃÿÿPèñÿÿÄé©ÃÿÿPèãÿÿÄé¦ÃÿÿPèÕÿÿÄé£ÃÿÿjpjèÒ¹ÿÿÄðöt3V¡4ÛPÿ¨ÛÀt"ÿ¬ÛÇFÿÿÿÿÇF   ÇFPàÛé¢Ãÿÿjèÿ  ÄéÃÿÿ3Àé÷ÃÿÿÀPQèÍ¨  ÄÀuè¤Äÿÿ3ÀéÄÿÿ+áüÈéñÃÿÿjèº  ÄéÄÿÿ¡ÄûÚPèÿÿÄÀPÿ5ÄûÚè|¨  ÄÀuèSÄÿÿ3ÀéJÄÿÿÀûÚ+ÄûÚáü£ÄûÚÈÀûÚéÄÿÿNÇÛètÆÿÿéÜÄÿÿNÇ@ÛèaÆÿÿéMÅÿÿ3ÀéûÅÿÿNÉ3Æÿÿjÿé(ÆÿÿNé2Æÿÿ3ÀéèÆÿÿ3ÀéEÇÿÿP5|ÛÿÖéÇÿÿPÿÖéÇÿÿÿ!Èÿÿ¨ÈÿÿSè£ÊÿÿÄøÿÈÿÿÇD$ÿÿÿÿéúÇÿÿD$é¢ÇÿÿWCè}a ÄéÈÿÿÄÃ¸ÿÿÿÿé'Éÿÿ3ÿéÙÈÿÿWQPèiJ Ä;ÇÎÈÿÿ~  t)FN+øWÁPQèµÿÿÄ¸ÿÿÿÿéèÈÿÿÈ+Ëé¹Èÿÿ~Là/ÛöÂt;Øs;
uAC;ØrõöÂtA÷ÙjQWèÔ  ÄøÿÈÿÿ¸ÿÿÿÿéÈÿÿ¸ÿÿÿÿéÐÈÿÿF+ØÛ­ÉÿÿSPÿvèÉI Ä;ÃuF¨Éÿÿ$ýFéÉÿÿN ¿ÿÿÿÿéyÉÿÿ¸ÿÿÿÿé¦ÉÿÿÿvèÚ  Äø¸    ÐÿéÉÿÿècÂÿÿ^[Ãè%  élÊÿÿFÀ¯ÊÿÿPè9ÿÿÄé¡Êÿÿ_ü3ÆkÀTN,8xíTÍèÊÿÿNyóSé±Êÿÿ|$ tBè4 |ÛD$L$Û=Û uèH ÛD$T$p/ÛÃèª ë¼èï£ ÿt$è¤ Ähÿ   ÿÛÄÃ¸ÛÃ¸/ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸$ÛÃ¸lÛÃ¸pÛÃ¸tÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸ÛÃ¸tÛÃ¸xÛÃ¸pÛÃ¡l+ÛÃL$Áà;Á¸ÿÿÿÿu¡p/Ûp/ÛÃ¡p/ÛÃUìVW}? tè
  uöFft$ t} ujÿWÿuÿuèQ  Ä¸   ëK tó>csmàuH~ v?F@Àt5PèìÿÿÄÀt!ÿu$ÿu ÿuWÿuÿuFÿuVÿPÄ _^]Ãè	  ë£ÿu ÿuÿu$WÿuÿuÿuVè   Ä ëUD$ììPSVUìWúÿ|E9PèW	  M9csmàuuyuoy ufy u`è½¾ÿÿxh §  è®¾ÿÿHhMè£¾ÿÿ@ljÿuEè  ÄÀuèü  M9csmàuyuy uy uè×  M9csmà  yz  y m  EäMèPQÿuìÿu ÿuè[  ÄMèEð9Mäõ   UìMð9Ô   9QË   AQUôÒº   MQJyUüÒ   MQUøPÒÂ   z ¸   9Qt3ÂqÆ:   
ÛtZ:^   ÂÆ
ÛuÜ3ÒÒu#ötö tMø	öÁtö t
öÁtbö u]3ÉÉu^ÇÿMü}ü oÿÿÿÀÿMô}ô FÿÿÿEðÿEèEè9Eäÿÿÿ} tjÿuèP  Ä_^[å]ÃÒÚÿé|ÿÿÿ¹   ëÿu$ÿu ÿuðÿ7Pÿuÿuÿuÿuÿuèc  Ä(ë} u"ÿu$ÿu ÿuìÿuÿuÿuÿuÿuè   Ä ëè  ëìSVWUè¼ÿÿxd ®   |$4t$,ÿt$8W\$,Vÿt$4Sÿt$4ÿt$4è	  ÄÀu{D$L$PQÿt$8WVè   ÄèD$9D$vWD$09E =9E|8MÁáMAôÀtx u"ÿt$8WUéj QVÿt$@Sÿt$@ÿt$@è  Ä(ÅÿD$D$9D$w©]_^[ÄÃ\$$t$,|$4élÿÿÿD$ìSHL$VWp|$ Ut$t$ÿ|>ÎD$kÉl$(\þÿuè   ëN9+}9k}þÿuOL$L$t$ÿ}ÓFD$,T$0L$0D$ 
9Hr;Îsèº  köD$]Æ_^[ÄÃd¡    Uìjÿh  ÛhU0ÙPEd%    ÀìEàMäSVWeèÇEü    ;MtGuÜ}]Ø}äÿ~Eä9GèM  ]äÁãGtöt	ÿuVèã  GEäE9EäuÂÇEüÿÿÿÿE9Eätè  EäMà_^[Eðåd£    ]Ã¸   ÃeèèT  ëÄD$SVÀWUtp\$(P|$St$WVè­  ÄD$8VÀu]WèÌ  D$0l$$ÿ0Uÿt$(WèõþÿÿL$@Äÿt$4A@GÿsUÿt$(WVè$   ÄÀtWPèE  ]_^[Ãt$|$\$(ëPë¡d¡    Uìjÿh ÛhU0ÙPd%    ì SVWu}eèFü}äEàMÔè¥¹ÿÿHhMØè¹ÿÿHlMÜè¹ÿÿMHhè¹ÿÿMHlÇEü   ÿuWÿuVè  ÄEäÇEüÿÿÿÿhËØMÔEàèK¹ÿÿMØHhè@¹ÿÿMÜHlE8csmàu&xu x u}ä tè«w  PÿuèM  ÄÃÿuìè2   ÄÃeè3öuäjÿEðPè%w  ÄÆMð_d    ^[å]ÃEäëêD$ 8csmàuxux ux ¸   t3ÀÃd¡    Uìjÿh( ÛhU0ÙPUd%    BìÀSVWeètix tcJÉt\EtÇEü    ötY]jÿsè¹  ÄÀ_  jVèÄ  ÄÀL  C}ÇWPèÃ  ÄÇEüÿÿÿÿEð_d£    ^[å]Ã}ötW]jÿsèX  ÄÀþ   jVèc  ÄÀë   ÿwÿsVèëªÿÿÄu¡ÀtÇWPèO  Äë ]jÿsuDèû  ÄÀ¡   jVè  ÄÀ   ÿwÇWÿsè  ÄPVèªÿÿÄé8ÿÿÿè·  ÄÀtajVèÆ  ÄÀtRÿwè¾ÿÿÄÀtCöt jGPÿsè¹   ÄPÿwVè  ééþÿÿGPÿsè   ÄPÿwVèa  éËþÿÿèL  éÁþÿÿ¸   Ãeèè¥   é®þÿÿd¡    Uìjÿh8 ÛhU0ÙPMd%    Aì@ÀSVWeètÇEü    Pÿqèõ  ÇEüÿÿÿÿEð_d£    ^[å]Ã}À@Ãeèè6   ë×L$Vt$ÆQÒ|I2
Á^Ãè-¶ÿÿx` tè"¶ÿÿÿP`d¡    UìjÿhH ÛhU0ÙPd%    ìSVWeèÇEü    èíµÿÿx\ tÇEü   èÛµÿÿÿP\ÇEü    ÇEüÿÿÿÿhþØj
èS Äjèàn  Äjèl  ÄÃ¸   ÃEð_d£    ^[å]Ãeèë³d¡    Uìjÿh` ÛhU0ÙPd%    ìSVWeèÇEü    ¡tÛÀtÇEü   ÿÐÇEü    ÇEüÿÿÿÿhpØéÿÿÿ¸   ÃEð_d£    ^[å]ÃeèëÍU¹   ìì VW¾x Û}àó¥EMUôEøRMüÿuðÿuäÿuàÿäÛ_^å]Â UD$ìÀìEøEUmøÿÐ]EüEüå]Â UD$ìÀìEüSd    d£    E]cümüÿàXY$ÿàXY$ÿàXY$ÿàUììSVWd¡    EüÇEøUØj ÿuÿuøÿuè^5 E`ýd¡    ]üd    _^[ÉÂ UììSVWüEøj j j ÿuøÿuÿuÿuÿuèEôÿÿÄ Eü_^[Eüå]ÃL$ÿqÿq(j ÿqèªøÿÿÄÂ UD$ììMEôEMøÇEì    ÇEðØ@Eüd¡    EìEìd£    QÿuèºþÿÿÈEìd£    Áå]ÃüL$j Qÿqÿqj ÿt$ ÿqÿt$ è§óÿÿÄ ÃUìì4SVWÇEÌ    ÇEÐØEEÔEEØEEÜE EàÇEä    ÇEè    ÇEì    ÇEð    ÇEäÖØeèmìd¡    EÌEÌd£    ÇEü   EEôEEøEôPEÿ0èÕ²ÿÿÿPdÄÇEü    }ð td    ]Ìd    Eü_^[ÉÃEÌd£    ëíUìSVüuöFftEÇ@$   ¸   ^[]ÃjEÿpÿpÿpj ÿuÿpVèòÿÿÄ My$ uVQè×ýÿÿ]ck ÿcVt$8csmàuxux uèûûÿÿ¸   ^Â = àÚ t¡ àÚPèÿÿÄÀt	Vÿ àÚëØ3ÀëÔVW3ÿt$;÷tVèoÿÿÄÀtèË±ÿÿx`èÃ±ÿÿp`Ç_^ÃVW3ÿt$;÷tVèAÿÿÄÀtè±ÿÿxdè±ÿÿpdÇ_^ÃV¾   ÿt$ÿt$ÿØÛÀt3öÆ^ÃV¾   ÿt$ÿt$ÿÔÛÀt3öÆ^ÃAàøÀ#ÁÃD$x4 }À8PèÞ{ÿÿÄÃD$x4 }À8PèK³ÿÿÄÃh(áÚè¹{ÿÿÄÃh(áÚè/³ÿÿÄÃA8ÃAÃD$AÂ ÿI0ÃA0À@A0Ãy0 }Á4Qèv{ÿÿÄÃy0 }Á4Qèç²ÿÿÄÃA4ÃQ(A,;Ðr3ÀÃ+ÂëûQA;Ðw+ÂÃ3ÀëûA(9A$r¾D$PÿP$Â HT$A(A(¾ ëëA9A wÿt$ÿPÂ PQL$¶Áëìÿt$ÿt$ÿPÂ ÿt$ÿt$ÿPÂ AÃAÃAI;Áv+ÁÃ3ÀëûAÃAÃA ÃA$ÃA(ÃA,Ãy, tD$A(Â y  tD$AÂ D$T$A$Q(ÇAÿÿÿÿD$A,Â D$T$AAQ Â AÃD$AÂ Vt$~4 }F8Pè&zÿÿÄ¡dÛÈà÷Ñ#N$È~4 N$}F8Pè±ÿÿÄÆ^ÃVt$~4 }F8PèåyÿÿÄ¡dÛÈà@÷Ñ#N$È~4 N$}F8PèC±ÿÿÄÆ^ÃVt$~4 }F8Pè¤yÿÿÄ¡dÛÈà ÷Ñ#N$È~4 N$}F8Pè±ÿÿÄÆ^ÃA$ÃA$T$Q$Â VWy4 ñ}F8PèSyÿÿÄ~$L$Ñ#L$÷Ò#×Ñ~4 V$}Æ8Vè¯°ÿÿÄÇ_^Â VWy4 ù}G8PèyÿÿÄw$D$Æ4 G$}Ç8Wèt°ÿÿÄÆ_^Â VWy4 ù}G8PèÓxÿÿÄw$D$÷Ð#Æ4 G$}Ç8Wè7°ÿÿÄÆ_^Â A0ÃA0T$Q0Â A T$Q Â A ÃA,ÃA,T$Q,Â A(T$Q(Â A(ÃAÃAàÃAàÃVñy4 }F8PèAxÿÿÄ~4 D$F}Æ8Vè¬¯ÿÿÄ^Â AàÃAàÃyÀ÷ØÃAÃD$ÛÂ D$ÛÂ D$ÿH4@ÀtÿH0ÃD$H4ÉAH4HÉtA0À@A0ÃD$@x0 }À4Pè wÿÿÄÃD$@x0 }À4Pè
¯ÿÿÄÃVñHD1x0 }À4Pèë®ÿÿÄ@Æx4 }À8PèÒ®ÿÿÄ^ÃAÃT$@ÿtè¦)  Â VQñÿT$ÄÆ^Â V¸    ñöt@ÆPÿT$ÄÆ^Â ÿt$è+  Â ÿt$è÷*  Â ÿt$èÖ'  Â ÿt$èÊ'  Â ÿt$ÿt$ÿt$è±5  Â ÿt$ÿt$ÿt$è5  Â ÿt$è¯4  Â ÿt$è£4  Â Vñ@Æx4 }À8PèuvÿÿÄÎÿFÿt$ÿt$ÿt$èP5  AÆx4 }À8PèÊ­ÿÿÄÆ^Â Vñ@Æx4 }À8Pè$vÿÿÄÎÿFÿt$ÿt$ÿt$èÿ4  AÆx4 }À8Pèy­ÿÿÄÆ^Â Vñ@Æx4 }À8PèÓuÿÿÄÎÿFÿt$ÿt$ÿt$è®4  AÆx4 }À8Pè(­ÿÿÄÆ^Â Vñ@Æx4 }À8PèuÿÿÄD$Î@ÿFÿt$Pj è]4  AÆx4 }À8Pè×¬ÿÿÄÆ^Â ÿt$ÿt$è¿3  Â ÿt$ÿt$è¯3  Â T$@ÿtè'  Â ÿt$è'  Â Vt$ÎèÆ+  Æ^ÃT$@ÿtèBB  Â VQñÿT$ÄÆ^Â V¸    ñöt@ÆPÿT$ÄÆ^Â ÿt$èb>  Â ÿt$èV>  Â ÿt$èHA  Â ÿt$è<A  Â ÙD$ÇA   ìÝ$èÂ>  Â ÿt$èGI  Â ÿt$è;I  Â ÿt$ÿt$èI  Â ÿt$ÿt$èpI  Â T$@ÿtèzA  Â ÿt$ènA  Â L$Vñ@Æx4 }À8PèósÿÿÄHD1x0 }À4PèØsÿÿÄPL2ÿPøÿu
HL1HD1x0 }À4Pè$«ÿÿÄ@Æx4 }À8Pè«ÿÿÄÆ^ÃL$Vj
è-=  Pðè\ÿÿÿÄÆ^ÃL$j è=  ÃVWùt$Vè¾%  VOè@  Ç_^Â T$VWù@tVè%  VOèv@  Ç_^Â IL¸ÿÿÿÿùÿtÁÃAL@øÀ@ÃPD
ÃPD
HL¸ÿÿÿÿùÿtÁÃPL
AL@øÀ@Ãÿt$BLè  Â PD
ÃPD
HL¸ÿÿÿÿùÿtÁÃPL
AL@øÀ@Ãÿt$BLèH  Â PD
ÃPD
HL¸ÿÿÿÿùÿtÁÃPL
AL@øÀ@Ãÿt$BLèü  Â Vñèe±ÿÿöD$t	VèrÿÿÄÆ^Â SVt$WUù÷Æ   t/_ü3ÆkÀPN,8xíPÍè#±ÿÿNyóSèMrÿÿÄÇ]_^[Â Ïè±ÿÿ÷Æ   tèWëÝVÁt$WNHVPNHVPNHVPNHV P N$H$Æ4x4VôP(NøH,¹   VüP0ó¥_Ç  Û^Â VÁt$WNHVPNHVPNHVPNHV P N$H$Æ4x4VôP(NøH,¹   VüP0ó¥_^Â Vñè§¯ÿÿöD$t	VèPqÿÿÄÆ^Â SVt$WUù÷Æ   t/wüÃkÀLK,8xíLÍèe¯ÿÿKyóVèqÿÿÄÇ]_^[Â ÏèI¯ÿÿ÷Æ   tèWëÝVñè«ÿÿÎè²¯ÿÿöD$tFôPèÕpÿÿÄFô^Â SVt$WUù÷Æ   t1_ð3ÆkÀ\Nl8ôxí\Íè2   NyóSèpÿÿÄGô]_^[Â Ïè2«ÿÿÏèG¯ÿÿ÷Æ   tàGôPëÒVqÎè«ÿÿÎè'¯ÿÿ^Ã|$ VWñt@|$¸    ÇÈ Ûÿt@ÇPNèr  j ÎWè³!  _HÆÇ1Ð Û^Â |$ëÝVWñ|$ùÈ Ûu¸    ÿt@ÇPIÎèy  Hÿt9Îè²!  Æ_^Â Vñè^ªÿÿÎè®ÿÿöD$tFôPè¤oÿÿÄFô^Â SVt$WUù÷Æ   t1_ð3ÆkÀ\Nl8ôxí\Íè2   NyóSèdoÿÿÄGô]_^[Â Ïèó©ÿÿÏè®ÿÿ÷Æ   tàGôPëÒVqÎèÓ©ÿÿÎèö­ÿÿ^ÃVñè^¬ÿÿÎèå­ÿÿöD$tFøPèoÿÿÄFø^Â SVt$WUù÷Æ   t1wôÃkÀXKl8øxíXÍè2   KyóVèÈnÿÿÄGø]_^[Â Ïèó«ÿÿÏèz­ÿÿ÷Æ   tàGøPëÒVqÎèÓ«ÿÿÎèZ­ÿÿ^Ã|$ VWñt@|$¸    ÇØ Ûÿt@ÇPNè¥  j ÎWèÙ:  _HÆÇ1à Û^Â |$ëÝVWñ|$ùØ Ûu¸    ÿt@ÇPIÎè¬  Hÿt9ÎèÍ:  Æ_^Â Vñè«ÿÿÎè´¬ÿÿöD$tFøPè×mÿÿÄFø^Â SVt$WUù÷Æ   t1wôÃkÀXKl8øxíXÍè2   KyóVèmÿÿÄGø]_^[Â Ïè´ªÿÿÏèI¬ÿÿ÷Æ   tàGøPëÒVqÎèªÿÿÎè)¬ÿÿ^ÃVñè  Îè¬ÿÿöD$tFìPè;mÿÿÄFì^Â SVt$WUù÷Æ   t1_è3ÆkÀdNl8ìxídÍè2   NyóSèûlÿÿÄGì]_^[Â Ïè°  Ïè­«ÿÿ÷Æ   tàGìPëÒVqÎè  Îè«ÿÿ^ÃD$ ÁÂ VñèÔªÿÿöD$t	VèlÿÿÄÆ^Â SVWÙt$U÷Æ   t(sü>,OxMÍèªÿÿOyõVèelÿÿÄÃ]_^[Â Ëè}ªÿÿ÷Æ   tèSëÝVÁT$WJHJHJHJHJHJHJHJ H J$H$J(r4x4H(J,H,J0H0¹   ó¥_Ç  ÛJL^HLRPPPÇ è ÛÂ VÁT$WJHJHJHJHJHJHJHJ H J$H$J(r4x4H(J,H,J0H0¹   ó¥JL_^HLRPPPÂ VñèM©ÿÿöD$t	VèJkÿÿÄÆ^Â |$ VWñt@|$¸    ÇÛÿt@ÇPNè[  j ÎWè  _HÆÇ1 Û^Â |$ëÝVWñ|$ùÛu¸    ÿt@ÇPIÎèb  Hÿt9Îè  Æ_^Â Vñèè  Îèj©ÿÿöD$tFôPèjÿÿÄFô^Â SVt$WUù÷Æ   t1_ð3ÆkÀ\Nl8ôxí\Íè2   NyóSèMjÿÿÄGô]_^[Â Ïè}  Ïèÿ¨ÿÿ÷Æ   tàGôPëÒVqÎè]  Îèß¨ÿÿ^Ã|$ VWñt@|$¸    Ç(Ûÿt@ÇPNè*  j ÎWè^6  _HÆÇ10Û^Â |$ëÝVWñ|$ù(Ûu¸    ÿt@ÇPIÎè1  Hÿt9ÎèR6  Æ_^Â Vñè1  Îè9¨ÿÿöD$tFøPè\iÿÿÄFø^Â SVt$WUù÷Æ   t1_ô3ÆkÀXNl8øxíXÍè2   NyóSèiÿÿÄGø]_^[Â Ïè£0  ÏèÎ§ÿÿ÷Æ   tàGøPëÒVqÎè0  Îè®§ÿÿ^Ã|$ VWñtG|$¸    Ç@ÛÿÇF8Ût@ÇPNèò  j ÎWèø  _HÆÇ1HÛ^Â |$ëÝVWùt$ù@Ûu¸    öt@ÆPIÏèù  Ht1ÏVè1  VOè5  Ç_^Â Vñèì  Îè÷¦ÿÿöD$tFìPèhÿÿÄFì^Â SVt$WUù÷Æ   t1_è3ÆkÀdNl8ìxídÍè2   NyóSèÚgÿÿÄGì]_^[Â Ïè  Ïè¦ÿÿ÷Æ   tàGìPëÒVqÎèa  Îèl¦ÿÿ^Ã+÷ÎÿÕKy÷]_^[Â VñèÌÿÿÆÇè ÛÇFP    ÇFLÿÿÿÿ^ÃVñè¬ÿÿÎÇè Ûÿt$ÿt$è  L$ÆÇFP    NL^Â VWyLÿñt`~0 }F4PèfÿÿÄÎÿPÿvLøè·`  Äøÿt#ÿÿtÇFLÿÿÿÿ~0 }F4PèåÿÿÄÆ_^Ã~0 }Æ4VèÎÿÿÄ3ÀëçVñè²F  øÿu	¸ÿÿÿÿ^Â Îè¢ÿÿøÿu¸ÿÿÿÿëéNÉuFVFFV |$ÿtÉuF V;ÂvL$BF
¸   ë«D$jPÿvLèv# Äøtâ¸ÿÿÿÿëìVA,ñI(;È   ÎèF  øÿu
¸ÿÿÿÿ^ÄÃÎèw¡ÿÿøÿu¸ÿÿÿÿëè~ t$D$jPÿvLèá  ÄÀ¸ÿÿÿÿëÅ¶D$ë¾NF;Èv+ÈQPÿvLèïà  ÄÀ¸ÿÿÿÿë3ÉëäÇFÿÿÿÿNÁN$N(F,¶éyÿÿÿD$VWÀùtøt$øt&¸ÿÿÿÿ_^Â 3öÏèÓ ÿÿøÿu¸ÿÿÿÿëæ¾   ëæ¾   ëßVÿt$ÿwLèm¬  ÄÈ¸ÿÿÿÿùÿt¼Áë¸SVWñyLÿt~ t3À_^[Â |$ÿt>\$Û~6~0 }F4PèwdÿÿÄj PÎWè/E  ~0 }F4PèÛÿÿÄÆë´ÇF   ëóVñyLÿt3À^Â ~0 }F4Pè)dÿÿÄD$FLøÿt$~ u~ uh   èÖdÿÿÄÀuÇF   ~0 }F4PèkÿÿÄÆë¤j   QPÎèD  ë×SVWñyLÿt3À_^[Â |$Ç%   øÉá ÀÿÿÁ   ÷Ç    uÍ÷Ç@   tÍ÷Ç   tÏÉ÷Ç   tÏÍ÷Ç   t{÷Ç   tnÉ÷ÇM   uÏÍº@   XÛTÛD$PÛ#Ãt=   tK= 
  tK=   tK=   tKh  RQÿt$èGÓ  ÄFLøÿu73Àé.ÿÿÿÉë÷Ç   u3Àéÿÿÿº   ëÃº    ë¼º0   ëµº@   ë®~0 }F4Pè¯bÿÿÄÇFP   ~ u~ uh   èacÿÿÄÀu@ÇF   ÷Ç   tDWjÎj ÿPøÿu3Îè°ûÿÿ~0 }Æ4VèÖÿÿÄ3Àéþÿÿj   QPÎè C  ë´~0 }F4PèªÿÿÄÆé\þÿÿVWñ|$9=\Ût9=`Ût
¸ÿÿÿÿ_^Â ~0 }F4PèëaÿÿÄ~Lÿt0ÎÿPøÿt$WÿvLèÆá  Äø~0 }Æ4Vè=ÿÿÄÇë³¿ÿÿÿÿëã|$ VñtNÇ@ÛÇF8ÛèzÿÿjTèWbÿÿÄÀt:Èèuúÿÿj ÎPè
  HÇ1HÛ¹   PL2PÆL2^Â 3ÀëÉ|$ VñtNÇ@ÛÇF8ÛèÿÿjTèìaÿÿÄÀtoÈè
úÿÿj ÎPè	  HÇ1HÛ¹   ÿt$ÿt$ÿt$PL2PL2AL0èøüÿÿÀu¹   PL2PL2Æ^Â 3Àë|$ VñtNÇ@ÛÇF8ÛèoÿÿjTèLaÿÿÄÀt>ÿt$Èè¿ÿÿj ÎPèõ  HÇ1HÛ¹   PL2PÆL2^Â 3ÀëÉ|$ VñtNÇ@ÛÇF8Ûè ÿÿjTèÝ`ÿÿÄÀtFÿt$ÿt$ÿt$Èèùÿÿj ÎPè~  HÇ1HÛ¹   PL2PÆL2^Â 3ÀëÉAìPÇD
ìHÛVAìùñHÇD1ìÛNøu3ÉÁèSÿÿNøè½ÿÿ^ÃSVWUñPL2yLÿu!ÿt$ÿt$ÿSÀtHD1]_^[Â xþ_+Í4 }G8Pè+_ÿÿÄ+4 }Ç8WèÿÿÄXÞ{7Î{4 }C8Pèö^ÿÿÄ7{4 }Ã8SèfÿÿÄ3ÀëSVWñUQÿt$L2è|úÿÿÀuhhî}Ë}4 }E8Pè¡^ÿÿÄ}4 }Å8UèÿÿÄp^;Ï~4 }F8Pèn^ÿÿÄ;~4 }Æ8VèÞÿÿÄ]_^[Â SVWUñPL2yLÿuÿt$ÿt$ÿt$è]úÿÿÀujXÞ{/Í{4 }C8Pè^ÿÿÄ/{4 }Ã8SèxÿÿÄXÞ{7Î{4 }C8PèÓ]ÿÿÄ7{4 }Ã8SèCÿÿÄ]_^[Â SVWUñPL2èðöÿÿÀtexþ4 }G8Pè]ÿÿÄÇG    4 }Ç8WèòÿÿÄp~4 }F8PèW]ÿÿÄÇF    ~4 }Æ8VèÂÿÿÄ]_^[ÃXÞ{/Í{4 }C8Pè]ÿÿÄ/{4 }Ã8SèÿÿÄXÞs>Ï{4 }C8Pèå\ÿÿÄ>{4 }Ã8Së|$ VñtNÇÛèªÿÿjTè]ÿÿÄÀt0Èè¥õÿÿj ÎPènÿÿHÇ1 ÛHÆÇD1   ^Â 3ÀëÓ|$ VñtNÇÛèPÿÿjTè-]ÿÿÄÀt[ÈèKõÿÿj ÎPèÿÿÿt$HÇ1 ÛHD$ÇD1   PBÿt$L0è@øÿÿÀu
HL1Æ^Â 3Àë¨|$ VñtNÇÛèËÿÿjTè¨\ÿÿÄÀt4ÿt$Èèÿÿj ÎPèÿÿHÇ1 ÛHÆÇD1   ^Â 3ÀëÓ|$ VñtNÇÛèmÿÿjTèJ\ÿÿÄÀt<ÿt$ÿt$ÿt$Èè|ôÿÿj ÎPè%ÿÿHÇ1 ÛHÆÇD1   ^Â 3ÀëÓAôPÇD
ô ÛéZÿÿSVWñPL2yLÿu ÿt$ÿt$ÿSÀtHD1_^[Â xþwË4 }G8PèÌZÿÿÄ4 }Ç8Wè<ÿÿÄ3ÀëÁSVWñÿt$QL2èSöÿÿÀu5XÞ{7Î{4 }C8PèxZÿÿÄ7{4 }Ã8SèèÿÿÄ_^[Â SVWñPL2yLÿuÿt$D$Pÿt$èföÿÿÀu5XÞ{7Î{4 }C8PèZÿÿÄ7{4 }Ã8SèÿÿÄ_^[Â VWñ¿    PL2è,óÿÿÀuH|1Ïp~4 }F8Pè¹YÿÿÄ~~4 }Æ8Vè(ÿÿÄ_^ÃD$VÇpÛAWñøÀ3ÿà~F~~ ~$~0~ÇF(   ÆF, ÇF4ÿÿÿÿN8QèâÿÿÄ¡ Ûÿ ÛÀuh(áÚèÆÿÿÄÆ_^Â VÇpÛÇA    ÇA    ÿt$ñÎè5   ÇF4ÿÿÿÿF8PèÿÿÄ¡ Ûÿ ÛÀuh(áÚènÿÿÄÆ^Â T$B A B$A$¾B(A(B,A,y ¾B0A0BAuAÁÂ Vh(áÚèXÿÿÄ5|Ûþ|¾ÿÿÿÿh(áÚèøÿÿÄÆ^ÃF5|ÛëæVh(áÚèYXÿÿÄ5xÛöh(áÚ5xÛèÂÿÿÄÆ^ÃPD
ÃPL
ÇAL    AÃPD
H@;Èw+ÁÃ3ÀëûPD
ÃPL
ëÆPD
H@;Èw+ÁÃ3ÀëûPD
ÃPL
ëALÃPD
Ã|$ VñtNÇÛÇFxÛè|ÿÿj Îèg	  j Nè[$  HÆÇ1Û^Â |$ VWñtNÇÛÇFxÛè7ÿÿ|$j WÎèÿÿj NWè}ÿÿ_HÆÇ1Û^Â |$ VWñtNÇÛÇFxÛèëÿÿ|$j WÎè	  ÿt!Çj NWèî#  _HÆÇ1Û^Â 3ÿëÞVÁT$WJHJHJHJHJHJHJHJ H J$H$J(r4x4H(J,H,J0H0¹   ó¥Ç  ÛJLHLJPHPJTHTJX_HXJ\^H\R`P`Ç ÛÂ VÁT$WJHJHJHJHJHJHJHJ H J$H$J(r4x4H(J,H,J0H0¹   ó¥JLHLJPHPJTHTJX_HXJ\^H\R`P`Â VñèÉ9  öD$t	Vè$VÿÿÄÆ^Â SVt$WUù÷Æ   t/_ü3ÆkÀdN,8xídÍè9  NyóSèæUÿÿÄÇ]_^[Â Ïèk9  ÷Æ   tèWëÝ|$ VWñt@|$¸    ÇÀÛÿt@ÇPNèâûÿÿj ÎWè#  _HÆÇ1ÈÛ^Â |$ëÝVWñ|$ùÀÛu¸    ÿt@ÇPIÎèéûÿÿHÿt9Îè"  Æ_^Â VñèÅ<  ÎèñÿÿöD$tFôPèUÿÿÄFô^Â SVt$WUù÷Æ   t1_ð3ÆkÀ\Nl8ôxí\Íè2   NyóSèÔTÿÿÄGô]_^[Â ÏèZ<  Ïèÿÿ÷Æ   tàGôPëÒVqÎè:<  Îèfÿÿ^Ã|$ VWñt@|$¸    ÇÐÛÿt@ÇPNè±úÿÿj ÎWèå   _HÆÇ1ØÛ^Â |$ëÝVWñ|$ùÐÛu¸    ÿt@ÇPIÎè¸úÿÿHÿt9ÎèÙ   Æ_^Â Vñè<  ÎèÀÿÿöD$tFøPèãSÿÿÄFø^Â SVt$WUù÷Æ   t1_ô3ÆkÀXNl8øxíXÍè2   NyóSè£SÿÿÄGø]_^[Â Ïè<  ÏèUÿÿ÷Æ   tàGøPëÒVqÎèý;  Îè5ÿÿ^Ã|$ VWñtG|$¸    ÇèÛÿÇFàÛt@ÇPNèyùÿÿj ÎWèûÿÿ_HÆÇ1ðÛ^Â |$ëÝVWùt$ùèÛu¸    öt@ÆPIÏèùÿÿHt1ÏVè¸  VOè  Ç_^Â Vñèb<  Îè~ÿÿöD$tFìPè¡RÿÿÄFì^Â SVt$WUù÷Æ   t1_è3ÆkÀdNl8ìxídÍè2   NyóSèaRÿÿÄGì]_^[Â Ïè÷;  Ïèÿÿ÷Æ   tàGìPëÒVqÎè×;  Îèóÿÿ^ÃVÁT$WJHJHJHJHJHJHJHJ H J$H$J(r4x4H(J,H,J0H0¹   ó¥_Ç  ÛRL^PLÇ øÛÂ VÁT$WJHJHJHJHJHJHJHJ H J$H$J(r4x4H(J,H,J0H0¹   ó¥RL_^PLÂ Vñè)  öD$t	Vè3QÿÿÄÆ^Â SVt$WUù÷Æ   t/wüÃkÀPK,8xíPÍèÒ(  KyóVèõPÿÿÄÇ]_^[Â Ïè¶(  ÷Æ   tèWëÝ|$ VWñtG|$¸    Ç0ÛÿÇF(Ût@ÇPNèêöÿÿj ÎWèðøÿÿ_HÆÇ18Û^Â |$ëÝVWùt$ù0Ûu¸    öt@ÆPIÏèñöÿÿHt1ÏVè)  VOè  Ç_^Â Vñè,  ÎèïÿÿöD$tFìPèPÿÿÄFì^Â SVt$WUù÷Æ   t1wèÃkÀdKl8ìxídÍè2   KyóV