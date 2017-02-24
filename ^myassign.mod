param m, integer, > 0;
/* number of drivers */

param n, integer, > 0;
/* number of days */

param kk, integer, > 0;
/* number of lines */

set I := 1..m;
/* set of drivers */

set J := 1..n;
/* set of days */

set K := 1..kk;
/* set of lines */

param d{i in I, j in J}, binary;
/* driver i have day-off in day j */

param pd{i in I, j in J}, binary;
/* driver i want to have day off in day j */

param pe {i in I, j in J}, binary;
param pl {i in I, j in J}, binary;
/* driver's preferenses for Early or Late shift*/

param can {i in I, k in K}, binary;
/* driver i can work at line k*/

var e{i in I, j in J, k in K},binary;
/* e = 1 means driver i works in day j on
line k  at early shift */

var l{i in I, j in J, k in K},binary;
/* e = 1 means driver i works in day j on
line k at late shift */

var c_earlyafterlate{i in I, j in 1..13}, binary;
var c_earlyshiftspare{i in I, j in J}, integer, >=0;
var c_lateshiftspare{i in I, j in J}, integer, >=0;
var c_morethanfourdays {i in I}, integer, >=0;
var c_lessthanfourdays {i in I}, integer, >=0;
var c_threedaysoff {i in I, j in J}, binary;
/*var c_preferreddayoff {i in I, j in J}, integer, >=0;*/

s.t. es {j in J, k in K}: sum {i in I} (e[i,j,k] + c_earlyshiftspare[i,j]) = 1;
s.t. ls {j in J, k in K}: sum {i in I} (l[i,j,k] + c_lateshiftspare[i,j]) = 1;
/*routes should be with drivers*/


s.t. phi{i in I, j in J}: sum{k in K} e[i,j,k] <= 1;
s.t. psi{i in I, j in J}: sum{k in K} l[i,j, k] <= 1;
/* each driver can work only at one route at the same time */

s.t. doe{i in I, j in J}: sum{k in K} e[i,j,k] * d[i,j] = 0;
s.t. dol{i in I, j in J}: sum{k in K} l[i,j,k] * d[i,j] = 0;
/* driver can't work at day-off */

s.t. threeevenings{i in I, j in 1 .. 11}: sum {jj in j..j+3, k in K} l[i,jj,k] <= 3;
/* constraint forbids three consecutive late shifts */
/* s.t. notfollow{i in I, j in 1 .. 13}: sum { k in K } (l[i,j,k]+e[i,j+1,k]) <= 2; */

s.t. limit7{i in I, j  in 1..13}: sum{k in K} (e[i,j+1,k] + l[i,j,k]) - c_earlyafterlate[i,j] <= 1 ;




s.t. oneshift {i in I, j in J}: sum {k in K} (e[i,j,k] + l[i,j,k]) <= 1;

s.t. morethanfourdays{i in I}: sum {j in J, k in K} l[i,j,k] - c_morethanfourdays[i] - 4 <= 0;
s.t. lessthanfourdays{i in I}: sum {j in J, k in K} l[i,j,k] + c_lessthanfourdays[i] - 4 >= 0;
/* constraints to check out, how many late shifts assigned to each driver */

s.t. quale {i in I, j in J, k in K}: e[i,j,k] * (1 - can[i,k]) = 0;
s.t. quall {i in I, j in J, k in K}: l[i,j,k] * (1 - can[i,k]) = 0;
/* driver's qualification constraints */

s.t. limit8{i in 1..8, j in 1..12}: sum{k in K} (e[i,j,k] + l[i,j,k] + e[i,j+1,k] + l[i,j+1,k] + e[i,j+2,k] + l[i,j+2,k]) + 3*c_threedaysoff[i,j] <= 3;
s.t.  foo {i in 1..8}: sum {j in 1..12} c_threedaysoff[i,j] <=1;

maximize constr:

    - 4 * (sum{i in I, j in J} (pd[i,j] * sum{k in K} (e[i,j,k] + l[i,j,k])))

    - 8 * sum{i in I} c_morethanfourdays[i]

    - 8 * sum{i in I} c_lessthanfourdays[i]

    - 30 * sum{i in I, j in 1..13} c_earlyafterlate[i,j]

    - 20 * sum{i in I, j in J} c_earlyshiftspare[i,j]

    - 20 * sum{i in I, j in J} c_lateshiftspare[i,j]

    + 3 * (sum{i in I, j in J, k in K}(pe[i,j] * e[i,j,k] + pl[i,j] * l[i,j,k]))

    + 5*(sum{i in 1..8, j in 1..12} c_threedaysoff[i,j]);


solve;

printf "\n";

for {i in I}{
  printf "%s ",
    if i = 1 then 'A'
    else if i = 2 then 'B'
    else if i = 3 then 'C'
    else if i = 4 then 'D'
    else if i = 5 then 'E'
    else if i = 6 then 'F'
    else if i = 7 then 'G'
    else if i = 8 then 'H'
    else if i = 9 then 'I'
    else if i = 10 then 'J'
    else if i = 11 then 'K';


	for {j in J}{
    printf "%d", j;
		printf"{%d,%d} ",if e[i,j,1] = 1 then 1 else if e[i,j,2] = 1 then 2 else if e[i,j,3] = 1 then 3 else 0,
        if l[i,j,1] = 1 then 1 else if l[i,j,2] = 1 then 2 else if l[i,j,3] = 1 then 3 else 0;
	}
  printf " Late Shifts: %d", sum{jj in J, k in K} l[i,jj,k];
	printf "\n";
}
printf "function value is : %d\n", constr + 4 * sum{i in I, j in J} pd[i,j];

printf "earlyshiftspare  %d\n", sum{i in I, j in J} c_earlyshiftspare[i,j];
printf "lateshiftspare  %d\n", sum{i in I, j in J} c_lateshiftspare[i,j];
printf "earlyafterlate  %d\n", sum{i in I, j in 1 .. 13} c_earlyafterlate[i,j];
printf "morethanfourdays  %d\n", sum{i in I} c_morethanfourdays[i];
printf "lessthanfourdays  %d\n", sum{i in I} c_lessthanfourdays[i];

data;

/* These data correspond to an example from [Christofides]. */

/* Optimal solution is 76 */

param m := 11;

param n := 14;

param kk := 3;




   param d :    1  2  3  4  5  6  7     8  9 10 11 12 13 14 :=

     /*A*/ 1    1  0  0  0  0  0  1/*A*/1  0  0  0  0  0  1  /*A*/
     /*B*/ 2    0  0  1  1  0  0  0/*B*/0  0  1  1  0  0  0  /*B*/
     /*C*/ 3    0  1  0  1  0  0  0/*C*/0  1  0  1  0  0  0  /*C*/
     /*D*/ 4    1  0  0  0  0  1  0/*D*/1  0  0  0  0  1  0  /*D*/
     /*E*/ 5    0  0  0  0  1  0  1/*E*/0  0  0  0  1  0  1  /*E*/
     /*F*/ 6    0  0  1  0  0  1  0/*F*/0  0  1  0  0  1  0  /*F*/
              /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/
     /*G*/7     1  0  0  1  0  0  0/*G*/1  0  0  1  0  0  0  /*G*/
     /*H*/8     0  1  1  0  0  0  0/*H*/0  1  1  0  0  0  0  /*H*/
     /*I*/9     0  0  1  0  1  0  0/*I*/0  0  1  0  1  0  0  /*I*/
     /*J*/10    1  0  0  0  0  1  0/*J*/1  0  0  0  0  1  0  /*J*/
     /*K*/11    0  1  0  0  0  0  1/*K*/0  1  0  0  0  0  1 ;/*K*/
              /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/



    param pd :   1  2  3  4  5  6  7     8  9 10 11 12 13 14 :=

      /*A*/ 1    0  0  1  0  1  0  0/*A*/0  0  0  1  1  0  0  /*A*/
      /*B*/ 2    0  0  0  0  0  1  0/*B*/1  0  0  0  0  1  0  /*B*/
      /*C*/ 3    0  0  0  0  0  0  0/*C*/0  0  0  0  0  1  0  /*C*/
      /*D*/ 4    0  0  0  0  0  0  0/*D*/0  0  1  1  0  0  0  /*D*/
      /*E*/ 5    0  1  1  0  0  0  0/*E*/0  1  0  0  0  0  0  /*E*/
      /*F*/ 6    1  0  0  0  0  0  0/*F*/1  0  0  0  0  0  0  /*F*/
               /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/
      /*G*/7     0  0  0  0  0  1  0/*G*/0  0  0  0  0  1  1  /*G*/
      /*H*/8     0  0  0  0  0  1  0/*H*/0  0  0  0  0  1  0  /*H*/
      /*I*/9     0  0  0  0  0  0  1/*I*/0  0  0  0  0  0  1  /*I*/
      /*J*/10    0  0  1  0  0  0  0/*J*/0  0  1  1  0  0  0  /*J*/
      /*K*/11    0  0  0  0  1  0  0/*K*/0  0  0  1  0  0  0 ;/*K*/
               /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/



   param pe :   1  2  3  4  5  6  7     8  9 10 11 12 13 14 :=

     /*A*/ 1    0  0  0  0  0  0  0/*A*/0  0  1  0  0  0  0  /*A*/
     /*B*/ 2    1  0  0  0  0  0  0/*B*/0  0  0  0  0  0  0  /*B*/
     /*C*/ 3    0  0  0  0  0  0  0/*C*/0  0  0  0  0  0  0  /*C*/
     /*D*/ 4    0  0  0  1  0  0  0/*D*/0  0  0  0  1  0  0  /*D*/
     /*E*/ 5    0  0  0  1  0  0  0/*E*/0  0  0  0  0  0  0  /*E*/
     /*F*/ 6    0  0  0  0  1  0  1/*F*/0  0  0  0  0  0  0  /*F*/
              /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/
     /*G*/7     0  0  0  0  0  0  0/*G*/0  0  0  0  1  0  0  /*G*/
     /*H*/8     0  0  0  0  1  0  0/*H*/0  0  0  0  1  0  0  /*H*/
     /*I*/9     1  0  0  0  0  0  0/*I*/0  1  0  0  0  0  0  /*I*/
     /*J*/10    0  0  0  0  0  0  0/*J*/0  1  0  0  0  0  0  /*J*/
     /*K*/11    0  0  0  1  0  1  0/*K*/0  0  0  0  0  0  0 ;/*K*/
              /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/



    param pl :   1  2  3  4  5  6  7     8  9 10 11 12 13 14 :=

      /*A*/ 1    0  1  0  1  0  0  0/*A*/0  0  0  0  0  0  0  /*A*/
      /*B*/ 2    0  1  0  0  0  0  0/*B*/0  0  0  0  0  0  0  /*B*/
      /*C*/ 3    0  0  0  0  0  0  1/*C*/0  0  1  0  0  0  0  /*C*/
      /*D*/ 4    0  0  0  0  0  0  0/*D*/0  0  0  0  0  0  0  /*D*/
      /*E*/ 5    1  0  0  0  0  1  0/*E*/0  0  0  0  0  1  0  /*E*/
      /*F*/ 6    0  0  0  0  0  0  0/*F*/0  0  0  0  0  0  1  /*F*/
               /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/
      /*G*/7     0  0  1  0  0  0  0/*G*/0  0  0  0  0  0  0  /*G*/
      /*H*/8     0  0  0  0  0  0  0/*H*/0  0  0  0  0  0  0  /*H*/
      /*I*/9     0  0  0  0  0  0  0/*I*/0  0  0  0  0  1  0  /*I*/
      /*J*/10    0  0  0  0  1  0  0/*J*/0  0  0  0  1  0  1  /*J*/
      /*K*/11    0  0  0  0  0  0  0/*K*/0  0  0  0  0  0  0 ;/*K*/
               /*1  2  3  4  5  6  7     8  9  10 11 12 13 14*/


param can: 1 2 3 :=
        1  1 0 1
        2  0 1 0
        3  1 1 0
        4  1 0 0
        5  1 0 0
        6  0 1 1
        7  0 0 1
        8  0 0 1
        9  1 0 0
       10  0 1 1
       11  0 0 1 ;


end;
