
program Effect;
{ Bitmap effect, no3, Zoom (SLOW!), by Bas van Gaalen, Holland, PD }
uses
  crt;

const
  Palette : array[0..$2ff] of byte = (
0,0,0,2,2,2,4,4,4,6,6,6,8,8,8,
10,10,10,12,12,12,14,14,14,16,16,16,18,18,18,20,
20,20,22,22,22,24,24,24,26,26,26,28,28,28,30,30,
30,33,33,33,35,35,35,37,37,37,39,39,39,41,41,41,
43,43,43,45,45,45,47,47,47,49,49,49,51,51,51,53,
53,53,55,55,55,57,57,57,59,59,59,61,61,61,63,63,
63,63,51,51,63,63,51,51,63,51,51,63,63,51,51,63,
63,51,63,63,39,39,63,51,39,63,63,39,51,63,39,39,
63,39,39,63,51,39,63,63,39,51,63,39,39,63,51,39,
63,63,39,63,63,39,51,63,27,27,63,39,27,63,51,27,
63,63,27,51,63,27,39,63,27,27,63,27,27,63,39,27,
63,51,27,63,63,27,51,63,27,39,63,27,27,63,39,27,
63,51,27,63,63,27,63,63,27,51,63,27,39,63,15,15,
63,27,15,63,39,15,63,51,15,63,63,15,51,63,15,39,
63,15,27,63,15,15,63,15,15,63,27,15,63,39,15,63,
51,15,63,63,15,51,63,15,39,63,15,27,63,15,15,63,
27,15,63,39,15,63,51,15,63,63,15,63,63,15,51,63,
15,39,63,15,27,63,3,15,63,3,3,63,15,3,63,27,
3,63,39,3,63,51,3,63,63,3,51,63,3,39,63,3,
27,63,3,15,63,3,3,63,3,3,63,15,3,63,27,3,
63,39,3,63,51,3,63,63,3,51,63,3,39,63,3,27,
63,3,15,63,3,3,63,15,3,63,27,3,63,39,3,63,
51,3,63,63,3,63,63,3,51,63,3,39,63,3,27,51,
3,15,51,3,3,51,15,3,51,27,3,51,39,3,51,51,
3,39,51,3,27,51,3,15,51,3,3,51,3,3,51,15,
3,51,27,3,51,39,3,51,51,3,39,51,3,27,51,3,
15,51,3,3,51,15,3,51,27,3,51,39,3,51,51,3,
51,51,3,39,51,3,27,39,3,15,39,3,3,39,15,3,
39,27,3,39,39,3,27,39,3,15,39,3,3,39,3,3,
39,15,3,39,27,3,39,39,3,27,39,3,15,39,3,3,
39,15,3,39,27,3,39,39,3,39,39,3,27,27,3,15,
27,3,3,27,15,3,27,27,3,15,27,3,3,27,3,3,
27,15,3,27,27,3,15,27,3,3,27,15,3,27,27,3,
27,15,3,3,15,15,3,3,15,3,3,15,15,3,3,15,
15,3,15,27,15,15,27,27,15,15,27,15,15,27,27,15,
15,27,27,15,27,39,15,15,39,27,15,39,39,15,27,39,
15,15,39,15,15,39,27,15,39,39,15,27,39,15,15,39,
27,15,39,39,15,39,39,15,27,51,15,15,51,27,15,51,
39,15,51,51,15,39,51,15,27,51,15,15,51,15,15,51,
27,15,51,39,15,51,51,15,39,51,15,27,51,15,15,51,
27,15,51,39,15,51,51,15,51,51,15,39,51,15,27,51,
27,27,51,39,27,51,51,27,39,51,27,27,51,27,27,51,
39,27,51,51,27,39,51,27,27,51,39,27,51,51,27,51,
51,27,39,51,39,39,51,51,39,39,51,39,39,51,51,39,
39,51,51,39,51,39,27,27,39,39,27,27,39,27,27,39,
39,27,27,39,39,27,39,3,3,3,15,15,15,27,27,27,
39,39,39,51,51,51,63,63,63,63,22,3,39,7,5,36,
36,63,0,0,0,22,22,22,38,38,38,52,52,52,63,0,0);

  Picture : array[0..102*32] of byte = (
0,0,0,0,242,242,2,180,180,180,180,180,180,180,180,180,
180,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,1,2,180,180,180,180,180,180,180,
180,180,180,242,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,1,242,242,242,242,242,242,1,1,1,242,242,
242,242,242,180,180,173,173,173,173,173,159,159,159,159,159,180,
173,173,180,1,0,0,0,0,0,173,173,173,173,159,139,139,
139,139,139,139,139,139,159,173,180,180,242,242,242,242,1,0,
0,0,0,0,0,0,0,0,0,0,0,0,1,180,173,159,
139,139,138,138,159,139,139,139,159,173,242,0,0,0,1,1,
242,242,242,1,1,0,1,242,2,2,180,180,180,180,180,180,
180,180,180,173,173,173,173,173,173,173,173,159,159,138,138,138,
113,113,113,113,139,173,158,158,173,2,0,0,0,0,173,139,
139,138,138,138,112,112,112,112,112,112,112,112,138,159,159,173,
173,173,173,173,180,2,242,242,242,242,242,242,242,1,0,0,
1,242,180,159,138,112,112,112,112,112,138,112,112,112,139,173,
180,242,242,242,180,173,173,173,173,173,180,2,3,3,180,180,
179,173,173,173,173,173,173,173,159,139,139,137,139,138,138,139,
138,138,138,112,112,112,111,110,110,110,137,111,138,158,172,180,
1,0,0,180,159,112,112,112,112,112,111,138,138,138,138,138,
138,138,138,138,159,159,159,138,138,139,159,173,173,173,173,173,
173,173,173,173,180,180,173,173,159,139,112,111,138,138,138,138,
138,138,138,138,138,159,173,180,173,173,159,139,138,138,139,159,
173,180,4,180,173,172,172,158,159,159,158,137,139,139,139,111,
111,111,112,112,112,112,112,112,111,138,138,138,138,138,138,138,
138,138,138,138,158,180,2,1,0,180,139,112,111,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,112,112,138,
138,159,138,138,138,138,138,138,139,159,173,173,159,139,138,138,
112,138,138,138,138,138,138,138,138,138,138,159,159,158,138,138,
138,112,112,112,138,139,173,173,173,159,158,158,138,138,138,159,
111,112,112,111,111,111,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,158,172,180,242,0,180,
139,112,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,112,112,112,112,112,138,138,
159,139,138,112,112,111,111,138,138,138,138,138,138,138,138,138,
138,138,111,111,111,111,111,111,138,138,138,138,159,159,158,138,
138,138,112,112,112,112,111,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,158,172,180,1,180,139,112,138,138,138,138,138,138,138,138,
138,138,138,211,211,211,211,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,159,111,111,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,158,138,138,138,112,112,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,158,180,2,180,139,112,138,138,
138,138,138,211,211,211,211,211,225,46,46,46,62,212,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,111,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,112,112,112,112,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,158,172,
180,180,159,138,138,138,138,138,211,46,46,46,46,46,45,36,
46,250,62,212,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,211,211,211,211,138,138,138,138,211,211,
211,211,211,211,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,158,172,1,180,173,159,158,138,138,225,36,
46,46,46,46,46,250,62,62,84,138,138,138,211,211,138,138,
138,138,138,138,211,138,138,138,138,138,226,46,46,46,46,250,
211,138,138,211,46,46,46,46,46,226,212,138,138,138,138,138,
211,211,138,138,138,138,138,138,138,138,138,211,211,211,211,211,
211,138,138,138,138,138,138,138,138,138,138,138,211,211,138,138,
211,211,211,211,211,211,211,138,138,138,138,158,172,0,242,180,
173,158,137,211,61,46,250,62,62,62,62,62,62,212,138,138,
138,211,46,250,211,138,138,138,138,211,226,211,138,138,138,226,
45,36,46,250,250,250,62,212,138,211,46,46,46,250,62,212,
138,138,138,138,138,226,46,46,46,46,46,250,211,138,138,211,
225,46,46,46,46,46,250,211,211,138,138,138,138,138,211,211,
211,225,46,250,212,211,46,46,46,46,46,46,61,212,138,138,
138,158,172,0,2,173,159,138,111,137,211,250,250,62,212,212,
212,212,138,138,138,138,138,211,46,46,62,138,138,138,138,226,
225,212,138,138,211,46,36,250,62,212,212,62,62,62,138,211,
46,46,250,62,212,138,138,138,138,138,226,45,36,46,250,250,
250,250,62,138,212,225,46,36,46,46,46,46,250,250,61,211,
138,138,138,226,46,46,46,45,36,250,212,226,36,46,250,62,
250,250,250,211,138,138,138,158,179,1,180,159,138,111,111,137,
226,46,46,62,212,138,138,138,138,138,137,138,138,211,250,250,
62,212,138,138,211,225,226,138,138,138,225,36,46,62,212,138,
138,211,250,62,212,211,46,46,250,62,138,138,137,138,138,211,
46,36,250,84,212,212,62,250,62,212,138,211,46,250,62,62,
62,62,62,250,250,62,212,138,211,46,36,46,46,46,250,62,
211,46,36,62,212,138,212,62,62,62,138,138,138,158,179,242,
173,139,112,111,138,211,46,36,250,62,211,211,211,137,138,138,
138,138,138,138,211,62,62,62,211,137,225,46,211,138,138,211,
61,46,62,212,138,138,137,211,46,250,212,211,46,46,62,212,
138,138,138,138,138,225,36,250,212,138,138,138,211,62,62,211,
138,211,46,250,212,212,212,212,211,62,250,250,62,138,211,46,
46,62,62,62,62,84,211,250,250,84,138,138,137,211,62,62,
212,138,138,158,179,2,173,138,112,138,138,211,46,46,250,250,
250,46,61,212,138,138,138,138,138,138,138,212,62,62,62,62,
46,46,212,138,138,138,211,250,62,212,138,137,138,211,46,62,
212,211,45,46,62,212,138,137,138,138,211,46,45,62,138,138,
138,137,138,211,250,62,137,211,46,250,212,138,138,138,138,211,
250,46,62,212,211,46,250,212,212,212,212,138,211,250,62,212,
138,137,211,211,61,62,212,138,138,158,172,180,159,138,112,138,
138,211,46,46,250,250,250,250,62,212,138,138,138,138,138,138,
138,138,211,62,250,46,46,226,138,138,138,138,211,46,62,212,
138,138,138,225,45,62,138,211,45,46,62,212,138,138,138,138,
211,46,250,212,138,138,138,138,138,211,46,250,212,211,46,250,
62,137,138,138,137,225,46,46,62,138,211,46,250,212,138,138,
138,138,211,46,62,212,137,225,45,46,46,62,212,138,138,158,
172,173,138,112,111,138,138,211,46,46,250,62,212,212,138,138,
138,138,138,138,138,138,138,226,46,46,46,46,250,211,211,137,
138,138,211,46,250,211,211,211,225,45,45,62,138,211,45,46,
62,212,138,138,138,138,211,46,62,138,138,137,138,138,138,211,
46,62,212,211,46,46,62,212,138,138,226,45,36,62,212,138,
225,45,250,62,211,211,137,138,211,46,250,62,61,45,36,46,
62,212,138,138,138,158,172,173,138,111,138,138,138,226,46,250,
250,62,212,138,138,138,137,211,211,138,138,211,225,45,36,46,
250,62,62,250,61,211,138,138,211,46,250,62,46,46,46,46,
62,212,138,211,45,46,62,212,138,138,138,138,211,46,62,138,
138,138,138,138,138,211,46,62,138,211,45,46,62,211,138,211,
46,36,250,84,138,211,45,36,250,250,250,61,211,138,211,46,
46,250,46,45,46,62,84,138,138,137,138,158,172,173,138,138,
138,138,226,45,45,250,250,62,211,137,137,211,225,46,250,212,
211,46,36,36,46,250,62,212,212,62,250,62,212,138,211,46,
46,250,250,62,62,212,212,138,138,210,46,46,62,212,138,138,
138,138,211,46,250,211,211,138,138,138,138,211,46,62,138,211,
45,46,250,62,211,225,36,46,62,212,138,211,46,46,62,62,
62,62,211,138,211,46,46,250,250,250,250,62,62,211,211,211,
211,158,158,173,158,138,138,211,61,45,46,250,250,250,62,211,
225,46,36,36,250,212,211,45,46,250,62,62,62,138,138,211,
250,250,62,138,211,46,46,62,212,212,138,138,138,138,137,225,
45,46,62,212,138,138,138,138,211,46,250,62,61,211,138,138,
138,211,46,62,138,211,45,46,250,250,250,46,45,62,84,138,
138,137,211,250,62,212,212,212,138,138,211,46,46,250,62,62,
250,250,250,62,61,61,226,196,158,173,159,138,138,211,61,46,
250,250,250,250,250,250,46,36,46,250,62,212,225,45,46,250,
62,212,138,138,138,211,46,46,62,138,211,46,46,62,212,138,
138,138,137,137,226,45,36,250,62,211,211,211,211,211,211,46,
46,250,250,211,211,211,211,226,46,62,138,211,45,46,250,250,
250,250,62,62,62,211,137,138,211,46,62,212,138,138,138,138,
211,46,46,62,212,212,61,250,250,250,250,250,211,196,172,180,
159,139,138,211,225,250,62,62,62,250,250,46,46,250,250,250,
62,211,61,45,250,62,62,138,138,138,138,211,46,250,212,138,
225,45,46,62,212,138,138,138,138,211,46,36,46,250,250,250,
46,46,250,62,62,250,250,250,250,250,46,46,250,61,46,62,
212,225,45,46,250,62,212,212,211,250,250,62,211,138,211,46,
250,211,211,211,137,138,211,46,46,62,212,138,211,62,250,250,
250,62,212,172,1,180,159,138,138,138,211,211,212,212,211,62,
62,62,250,250,250,250,62,212,211,62,62,212,138,138,138,138,
138,211,61,62,138,211,45,36,250,62,211,138,138,138,138,225,
36,46,250,250,250,46,46,46,250,250,62,83,62,250,250,46,
46,46,250,250,46,62,211,46,36,250,62,212,138,138,211,61,
250,250,62,211,211,250,250,62,46,250,211,211,226,46,46,62,
212,138,138,211,250,46,250,83,138,172,1,180,139,112,111,138,
138,138,138,138,138,137,212,211,62,62,62,62,212,138,138,138,
138,138,138,138,138,138,138,138,212,212,138,225,36,46,250,250,
62,137,138,138,211,225,46,62,62,62,62,62,250,250,250,250,
62,212,212,62,250,250,250,250,250,250,250,83,211,250,46,250,
62,212,138,137,137,211,250,250,250,62,212,211,62,62,46,250,
250,62,226,61,250,62,211,138,138,211,61,62,62,212,158,172,
180,180,139,112,138,138,138,138,138,138,138,138,138,138,137,212,
212,138,138,138,137,138,138,138,137,138,138,138,138,138,138,138,
211,225,46,62,62,62,62,138,138,138,138,211,211,212,212,212,
212,211,62,250,250,62,212,138,138,211,62,62,62,62,62,62,
62,212,138,211,62,62,62,211,211,137,138,212,62,250,250,62,
212,138,138,212,62,62,250,62,211,212,211,62,211,138,138,138,
211,212,138,138,138,158,180,180,139,112,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,137,138,138,138,138,138,138,
138,138,138,138,138,138,138,211,211,212,212,212,138,138,138,138,
138,138,138,138,138,138,138,138,211,62,62,62,138,138,137,138,
138,212,212,212,212,212,138,138,138,138,211,62,62,62,226,212,
138,138,211,62,250,62,212,138,138,138,138,211,62,62,138,138,
138,138,138,138,138,138,138,138,138,138,138,158,180,180,139,112,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
212,138,138,138,138,138,138,138,138,138,138,138,138,138,137,138,
138,138,212,212,212,138,138,138,138,211,62,62,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,158,179,180,139,112,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,158,158,159,159,159,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,158,172,180,159,139,138,138,138,138,
138,138,138,138,138,138,138,138,138,158,158,172,159,159,138,138,
138,138,138,138,138,138,138,138,138,159,173,180,180,180,180,173,
159,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,139,139,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,158,159,159,159,159,173,242,
173,173,159,159,159,138,138,138,138,159,159,159,158,158,172,172,
179,180,180,173,159,159,159,159,159,159,158,159,159,159,173,180,
180,242,1,0,1,180,173,159,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,138,
138,138,138,138,138,138,159,159,159,159,159,173,173,173,159,159,
158,159,159,159,158,159,159,159,158,158,138,138,138,158,159,173,
180,180,180,180,180,0,242,180,180,180,173,159,159,159,173,173,
180,180,180,180,180,2,1,0,1,180,180,180,180,180,180,180,
180,180,180,180,180,242,1,0,0,0,0,242,180,173,159,159,
159,159,159,158,158,158,158,158,158,158,158,158,158,158,138,138,
138,138,138,138,138,138,158,158,158,158,159,173,180,180,180,180,
180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,172,
158,159,159,173,180,180,2,2,2,2,2,0,0,1,1,1,
180,180,180,180,180,2,242,0,0,0,0,0,0,0,0,1,
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,242,180,180,180,180,180,180,180,180,180,180,180,180,180,
180,180,180,173,173,173,173,173,173,173,173,173,173,180,180,180,
180,180,242,1,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,1,242,180,180,180,180,180,180,2,242,1,1,1,1,1);

{----------------------------------------------------------------------------}

procedure SetGraphics(Mode : byte); assembler;
asm mov AH,0; mov AL,Mode; int 10h; end;

{----------------------------------------------------------------------------}

procedure InstallColors;

var I : byte; C : word;

begin
  C := 0;
  for I := 0 to $ff do begin
    port[$3C8] := I;
    port[$3C9] := Palette[C];
    port[$3C9] := Palette[C+1];
    port[$3C9] := Palette[C+2];
    inc(C,3);
  end;
end;

{----------------------------------------------------------------------------}

procedure PutPicture;

var
  X,Y,I,J,Xend,Yend : byte;

begin
  Xend := 1; Yend := 1;
  repeat

    while (port[$3da] and 8) <> 8 do;
    while (port[$3da] and 8) = 8 do;

    for X := 0 to 101 do { 101 }
      for Y := 0 to 31 do { 31 }
        for I := 1 to Xend do
          for J := 1 to Yend do
            if ((X*Xend+I) < 320) and ((Y*Yend+J) < 200) then
              mem[$a000:(Y*Yend+J)*320+X*Xend+I] := Picture[Y*102+X];
    inc(Xend); inc(Yend);
  until keypressed or (Xend = 20);
  delay(1000);
end;

{----------------------------------------------------------------------------}

begin
  SetGraphics($13);
  InstallColors;
  PutPicture;
  textmode(lastmode);
end.
