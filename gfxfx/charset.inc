{ TheDraw Pascal Crunched Screen Image.  Date: 01/11/94 }
const
  IMAGEDATA_WIDTH=80;
  IMAGEDATA_DEPTH=50;
  IMAGEDATA_LENGTH=1712;
  IMAGEDATA : array [1..1712] of Char = (
    #15,#16,#25, #5,#11,#26, #3,'�',' ',' ',#26, #4,'�',#25, #2,#26, #4,
    '�',' ',#26, #4,'�',' ',' ',#26, #5,'�',' ',#26, #5,'�',' ',' ',#26,
     #3,'�',' ',' ','�','�','�',' ','�','�',' ','�','�','�',#25, #4,'�',
    '�',' ','�','�','�',' ','�','�',#24,#25, #4,#19,'�','�','�',' ','�',
    '�', #3,#16,'�',#11,#19,'�','�','�',' ','�','�', #3,#16,'�',#11,#19,
    '�','�','�',' ', #3,#16,'�','�','�',#11,#19,'�','�','�',' ','�','�',
     #3,#16,'�',#11,#19,'�','�','�',' ', #3,#16,'�','�','�',#11,#19,'�',
    '�','�',' ', #3,#16,'�','�','�',#11,#19,'�','�','�',' ', #3,#16,'�',
    '�',' ',#11,#19,'�','�','�',' ','�','�', #3,#16,'�',#11,#19,'�','�',
    '�',' ',#16,#25, #3,#19,'�','�',' ','�','�','�',' ','�','�',' ',#24,
    #16,#25, #4,#19,'�','�','�','�','�','�',' ','�','�','�','�','�','�',
     #3,#16,'�',#11,#19,'�','�','�',' ',#16,#25, #2,#19,'�','�','�',' ',
    '�','�',' ','�','�','�','�','�', #3,#16,'�',' ',#11,#19,'�','�','�',
    '�','�', #3,#16,'�',' ',#11,#19,'�','�','�',' ','�',#16,'�', #3,'�',
    #11,#19,'�','�','�','�','�','�',' ','�','�','�', #3,#16,'�',#25, #3,
    #11,#19,'�','�',' ','�','�','�','�','�','�', #3,#16,'�',#24,#25, #4,
    #11,#19,'�','�','�',' ','�','�',' ','�','�','�','�','�','�',' ',#16,
    '�',#19,'�','�','�',#16,'�','�',' ',#19,'�','�','�','�','�','�',' ',
    '�','�','�','�',#16,'�','�',' ',#19,'�','�','�',' ',#16,#25, #2,'�',
    #19,'�','�','�','�','�', #3,#16,'�',#11,#19,'�','�','�',' ','�','�',
    ' ','�','�','�',' ',#16,'�',#19,'�','�',#16,'�',#19,'�','�',' ','�',
    '�','�',' ','�','�',' ',#24,#16,#25, #5, #3,'�','�','�',' ','�','�',
    ' ',#26, #4,'�',#25, #2,#26, #4,'�',' ',#26, #4,'�',' ',' ',#26, #5,
    '�',' ','�','�','�',#25, #4,#26, #3,'�',' ',' ','�','�','�',' ','�',
    '�',' ','�','�','�',' ',' ',#26, #3,'�',' ',' ','�','�','�',' ','�',
    '�',#24,#11,'�','�','�',#25, #3,#26, #7,'�',' ',' ',#26, #4,'�',#25,
     #2,#26, #3,'�',' ',' ',#26, #4,'�',#25, #2,#26, #3,'�',' ',' ',#26,
     #4,'�',#25, #2,#26, #4,'�',' ',#26, #4,'�',' ',' ','�','�','�',' ',
    '�','�',' ','�','�','�',' ','�','�',#24,#19,'�','�','�',' ',#16,#25,
     #2,#19,'�','�','�',' ','�','�',' ','�','�', #3,#16,'�',#11,#19,'�',
    '�','�',' ','�','�', #3,#16,'�',#11,#19,'�','�','�',' ','�','�', #3,
    #16,'�',#11,#19,'�','�','�',' ','�','�', #3,#16,'�',#11,#19,'�','�',
    '�',' ','�','�', #3,#16,'�',#11,#19,'�','�','�',' ','�','�', #3,#16,
    '�',#11,#19,'�','�','�',' ', #3,#16,'�','�','�',' ','�','�','�',#11,
    #19,'�','�', #3,#16,'�',#11,#19,'�','�','�',' ','�','�', #3,#16,'�',
    #11,#19,'�','�','�',' ','�','�',' ',#24,'�','�','�',' ',#16,#25, #2,
    #19,'�','�','�',' ','�','�',' ','�','�',' ','�','�','�',' ','�','�',
    ' ','�','�','�',' ','�','�',' ','�','�','�','�','�', #3,#16,'�','�',
    #11,#19,'�','�','�',' ','�','�',' ','�','�','�','�','�','�', #3,#16,
    '�',' ',#11,'�',#19,'�','�','�',#16,'�',#25, #4,#19,'�','�',' ','�',
    '�','�',' ','�','�',' ','�','�','�',' ','�','�',' ',#24,'�','�','�',
    '�',#16,'�','�',' ',#19,'�','�','�',' ','�','�',' ','�','�',' ','�',
    '�','�',' ','�','�',' ',#16,'�',#19,'�','�','�','�','�',' ','�','�',
    '�',' ',#16,#25, #2,'�',#19,'�','�','�','�','�',' ','�','�','�',' ',
    '�','�',' ',#16,#26, #3,'�',#19,'�','�',' ',#16,#25, #3,#19,'�','�',
    ' ',#16,'�',#19,'�','�','�','�','�',' ',#16,'�',#19,'�','�','�','�',
    '�',' ',#24,#16,' ', #3,#26, #5,'�',' ','�','�','�',' ','�','�',' ',
    '�','�',' ','�','�','�',' ','�','�',' ',' ',#26, #3,'�',' ',' ','�',
    '�','�',#25, #4,#26, #4,'�',' ','�','�','�',' ','�','�',' ',#26, #4,
    '�',#25, #5,'�','�',' ',' ',#26, #4,'�',' ',' ',#26, #3,'�',#24,#11,
    '�','�','�',' ','�','�',' ','�','�',' ','�','�','�',' ','�','�',' ',
    '�','�','�',' ','�','�',' ',#26, #5,'�',#25,#10,#19,'�','�','�', #3,
    #16,'�',#25, #5,#11,'�','�','�',' ',#26, #4,'�',#25, #2,'�','�','�',
    ' ','�','�','�',#24,#19,'�','�','�',' ','�','�',' ','�','�', #3,#16,
    '�',#11,#19,'�','�','�',' ','�','�',' ','�','�','�',' ','�','�',' ',
    #16,' ', #3,'�','�','�',#11,#19,'�','�',' ',#16,#25, #8,'�',#19,'�',
    '�',' ', #3,#16,'�',#25, #5,#11,#19,'�','�','�',' ',#16,' ', #3,'�',
    '�',#11,#19,'�','�','�', #3,#16,'�',#11,#19,'�','�','�',' ', #0,'�',
    #16,' ',#11,#19,'�','�','�', #3,#16,'�',#11,#19,'�','�','�', #3,#16,
    '�',#24,#11,#19,'�','�','�',' ','�','�',' ','�','�',' ',#16,'�',#19,
    '�','�','�','�','�', #3,#16,'�',' ',#11,'�',#19,'�','�','�','�',' ',
    #16,' ','�','�','�',#19,'�',' ', #3,#16,'�',#25,#13,#11,'�',#19,#26,
     #3,'�', #0,'�',#11,#16,'�',#19,'�','�',' ',#16,' ','�',#19,'�','�',
    ' ', #3,#16,'�','�',#11,#19,'�','�','�',' ',#16,' ',' ',#19,'�','�',
    '�',' ',#16,' ', #3,'�','�','�',#24,#11,'�',#19,'�','�','�','�','�',
    '�','�','�',' ','�','�','�',' ','�','�',' ',#16,'�',#19,'�','�',#16,
    '�',#19,'�','�',' ','�','�','�','�','�',#16,'�',' ',#19,'�','�','�',
     #3,#16,'�',' ',#11,#19,'�','�','�', #3,#16,'�',#25,#10,#11,#19,'�',
    '�','�', #3,#16,'�',' ',#11,#19,'�','�','�', #3,#16,'�',' ',' ',#11,
    '�',#19,'�','�','�',#16,' ','�',#19,'�','�','�',' ','�','�','�', #3,
    #16,'�',#24,' ',' ',#26, #6,'�',' ',' ','�','�','�',' ','�','�',' ',
    ' ',#26, #3,'�',' ',' ',#26, #5,'�',' ','�','�','�',#11,'�',#19,'�',
    '�',' ', #3,#16,'�',#25,#11,'�','�','�',' ',' ','�','�','�',#25, #3,
    '�','�', #0,#19,'�',#16,' ', #3,'�','�','�',' ',' ','�','�','�',#24,
    ' ',#11,#26, #3,'�',#25, #2,'�','�','�',' ',' ',#26, #3,'�',#25, #2,
    #26, #3,'�',' ',' ','�','�','�',' ','�','�',' ',#26, #5,'�',' ',' ',
    #26, #4,'�',' ',#26, #4,'�',#25, #2,#26, #3,'�',#25, #2,#26, #3,'�',
    #25, #3,'�','�','�',#24,#19,'�','�','�',' ','�','�', #3,#16,'�',#11,
    '�',#19,'�','�','�',' ',#16,'�',#19,'�',' ', #3,#16,'�',#11,#19,'�',
    '�', #3,#16,'�',#11,'�',#19,'�',' ', #3,#16,'�',#11,#19,'�','�', #3,
    #16,'�',#11,#19,'�','�','�',' ','�','�', #3,#16,'�',#11,#19,'�','�',
    '�',' ', #3,#16,'�','�','�',#11,#19,'�','�','�',' ', #3,#16,'�','�',
    '�',' ','�','�','�',#11,#19,'�','�', #3,#16,'�',#11,#19,'�','�','�',
    ' ','�','�', #3,#16,'�',#11,#19,'�','�','�',' ','�','�', #3,#16,'�',
    ' ',' ',#11,#19,'�','�','�',' ',#24,'�','�','�','�','�','�',' ',#16,
    ' ',#19,'�','�','�', #3,#16,'�',' ',#11,'�','�','�',#19,'�',' ', #3,
    #16,'�',' ',' ',#11,'�',#19,'�','�','�', #3,#16,'�',#11,'�',#19,'�',
    '�','�','�','�',' ',#16,'�',#19,'�','�','�','�',#16,'�',' ',#19,'�',
    '�','�','�','�',#16,'�',#25, #2,'�',#19,'�','�','�',' ',#16,'�',#19,
    '�','�','�','�','�', #3,#16,'�',' ',#11,'�',#19,'�','�','�','�',' ',
    #16,' ',#19,'�','�','�', #3,#16,'�','�',#24,#11,'�',#19,'�','�','�',
    '�','�',' ',#16,' ',#19,'�','�','�',' ','�','�','�','�','�',#16,'�',
    ' ','�','�','�','�',#19,'�','�',' ',#16,#25, #3,#19,'�','�',' ',#16,
    #26, #3,'�',#19,'�','�',' ',#16,'�',#19,'�','�','�','�','�',' ',#16,
    #25, #3,#19,'�','�',' ',#16,'�',#19,'�','�','�','�','�',' ',#16,'�',
    '�','�','�',#19,'�','�',' ','�','�','�',' ', #3,#16,'�',#24,' ',' ',
    #26, #3,'�',#25, #2,'�','�','�',' ',#26, #5,'�',' ',' ',#26, #3,'�',
    #25, #5,'�','�',' ',#26, #4,'�',#25, #2,#26, #3,'�',#25, #5,'�','�',
    ' ',' ',#26, #3,'�',#25, #2,#26, #3,'�',' ',' ','�','�','�',#24,#24,
    #24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,
    #24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24,#24);
