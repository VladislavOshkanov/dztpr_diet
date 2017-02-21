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

param d{i in I, j in J}, >= 0;
/* driver i have day-off in day j */

param pd{i in I, j in J}, >=0;
/* driver i want to have day off in day j */


param can {i in I, k in K}, >= 0;
/* driver i can work at line k*/


var e{i in I, j in J, k in K},integer, >= 0;
/* e = 1 means driver i works in day j on
line k  at early shift */

var l{i in I, j in J, k in K},integer, >= 0;
/* e = 1 means driver i works in day j on
line k at late shift */

var c_earlyafterlate{i in I, j in 1..13}, integer, >= 0;
var c_earlyshiftspare{i in I, j in J}, integer, >=0;
var c_lateshiftspare{i in I, j in J}, integer, >=0;
var c_morethanfourdays {i in I}, integer, >=0;
var c_lessthanfourdays {i in I}, integer, >=0;
var c_preferreddayoff {i in I, j in J}, integer, >=0;

s.t. es {j in J, k in K}: sum {i in I} (e[i,j,k] + c_earlyshiftspare[i,j]) = 1;
s.t. ls {j in J, k in K}: sum {i in I} (l[i,j,k] + c_lateshiftspare[i,j]) = 1;
/*routes should be with drivers*/

s.t. prefer {i in I, j in J}: sum {k in K} (e[i,j,k]+l[i,j,k]) + pd [i, j] + (c_preferreddayoff[i, j]) <= 2;
s.t. efsefs {i in I, j in J}: (c_preferreddayoff[i,j]) <= 1;

s.t. phi{i in I, j in J}: sum{k in K} e[i,j,k] <= 1;
/* each driver can work only at one route at the same time */

s.t. psi{i in I, j in J}: sum{k in K} l[i,j, k] <= 1;
/* each driver can work only at one route at the same time */

s.t. doe{i in I, j in J}: sum{k in K} e[i,j,k] * d[i,j] = 0;
s.t. dol{i in I, j in J}: sum{k in K} l[i,j,k] * d[i,j] = 0;
/* driver can't work at day-off */

s.t. threeevenings{i in I, j in 1 .. 11}: sum {jj in j..j+3, k in K} l[i,jj,k] <= 3;
/* constraint forbids three consecutive late shifts */
/* s.t. notfollow{i in I, j in 1 .. 13}: sum { k in K } (l[i,j,k]+e[i,j+1,k]) <= 2; */

s.t. earlyafterlate{i in I, j in 1..13}: sum {k in K} (l[i,j,k]+e[i,j+1,k]) + c_earlyafterlate[i,j] <= 2;
s.t. c_early{i in I, j in 1..13}: c_earlyafterlate[i,j] <= 1;



s.t. fourlateshifts {i in I}: sum {k in K, j in J} l[i,j,k] <= 4;

s.t. oneshift {i in I, j in J}: sum {k in K} (e[i,j,k] + l[i,j,k]) <= 1;

s.t. morethanfourdays{i in I}: sum {j in J, k in K} l[i,j,k] - c_morethanfourdays[i] - 4 <= 0;
s.t. lessthanfourdays{i in I}: sum {j in J, k in K} l[i,j,k] + c_lessthanfourdays[i] - 4 >= 0;
/* constraints to check out, how many late shifts assigned to each driver */

s.t. quale {i in I, j in J, k in K}: e[i,j,k] * (1 - can[i,k]) = 0;
s.t. quall {i in I, j in J, k in K}: l[i,j,k] * (1 - can[i,k]) = 0;
/* driver's qualification constraints */

maximize constr: sum{i in I, j in 1..13} -30*(1-c_earlyafterlate[i,j]) +
    sum{i in I, j in 1..14} -20 * c_earlyshiftspare[i,j] + sum{i in I, j in 1..14} -20 * c_lateshiftspare[i,j]
    - 8 * sum{i in I} c_morethanfourdays[i] - 8 * sum{i in I} c_lessthanfourdays[i]
    + 4 * sum {i in I, j in J}  (c_preferreddayoff[i,j])*pd[i,j];

solve;

printf "\n";
/*printf "Agent  Task       Cost\n";
printf{i in I} "%5d %5d %10g\n", i, sum{j in J} j * x[i,j],
   sum{j in J} c[i,j] * x[i,j];
printf "----------------------\n";
printf "     Total: %10g\n", sum{i in I, j in J} c[i,j] * x[i,j];
*/
for {i in I}{
	for {j in J}{
		printf" {%d,%d}",if e[i,j,1] = 1 then 1 else if e[i,j,2] = 1 then 2 else if e[i,j,3] = 1 then 3 else 0,
        if l[i,j,1] = 1 then 1 else if l[i,j,2] = 1 then 2 else if l[i,j,3] = 1 then 3 else 0;
	}
  printf " Late Shifts: %d", sum{jj in J, k in K} l[i,jj,k];
	printf "\n";
}
printf "function value is : %d\n", constr -4290;


data;

/* These data correspond to an example from [Christofides]. */

/* Optimal solution is 76 */

param m := 11;

param n := 14;

param kk := 3;




param d :        1  2  3  4  5  6  7  8  9 10 11 12 13 14 :=

  /*A*/    1     0  1  1  0  0  0  0  0  1  1  0  0  0  0
  /*B*/    2     0  0  0  0  1  1  0  0  0  0  0  1  1  0
  /*C*/    3     0  0  0  1  0  1  0  0  0  0  1  0  1  0
  /*D*/    4     1  0  1  0  0  0  0  1  0  1  0  0  0  0
  /*E*/    5     0  1  0  0  0  0  1  0  1  0  0  0  0  1
  /*F*/    6     1  0  0  0  1  0  0  1  0  0  0  1  0  0
  /*G*/    7     0  0  1  0  0  1  0  0  0  1  0  0  1  0
  /*H*/    8     0  0  0  1  1  0  0  0  0  0  1  1  0  0
  /*I*/    9     0  0  0  0  1  0  1  0  0  0  0  1  0  1
  /*J*/   10     1  0  1  0  0  0  0  1  0  1  0  0  0  0
  /*K*/   11     0  1  0  1  0  0  0  0  1  0  1  0  0  0 ;

param pd :       1  2  3  4  5  6  7  8  9 10 11 12 13 14 :=

  /*A*/    1     0  0  0  0  0  1  0  0  0  0  0  1  0  1
  /*B*/    2     0  0  0  0  0  0  0  1  1  0  0  0  0  0
  /*C*/    3     1  1  0  0  0  0  0  1  0  0  0  0  0  0
  /*D*/    4     0  0  0  0  0  0  0  0  0  0  0  0  1  0
  /*E*/    5     0  0  0  0  1  0  0  0  0  0  0  1  0  0
  /*F*/    6     0  0  0  0  0  0  0  0  0  1  0  0  0  1
  /*G*/    7     1  0  0  0  0  0  0  1  0  0  0  0  0  0
  /*H*/    8     1  0  0  0  0  0  1  1  0  0  0  0  0  0
  /*I*/    9     1  0  0  0  0  0  0  0  0  1  0  0  0  0
  /*J*/   10     0  0  0  0  1  0  0  0  0  0  0  0  1  1
  /*K*/   11     0  0  0  0  0  1  0  0  0  0  0  0  0  1 ;
param can: 1 2 3 :=
        1  0 1 0
        2  0 0 1
        3  0 1 0
        4  1 0 0
        5  1 0 1
        6  0 0 1
        7  0 1 0
        8  1 1 0
        9  0 1 1
       10  1 0 1
       11  0 0 1 ;


end;
