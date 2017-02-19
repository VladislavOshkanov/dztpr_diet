/* ASSIGN, Assignment Problem */

/* Written in GNU MathProg by Andrew Makhorin <mao@gnu.org> */

/* The assignment problem is one of the fundamental combinatorial
   optimization problems.

   In its most general form, the problem is as follows:

   There are a number of agents and a number of tasks. Any agent can be
   assigned to perform any task, incurring some cost that may vary
   depending on the agent-task assignment. It is required to perform all
   tasks by assigning exactly one agent to each task in such a way that
   the total cost of the assignment is minimized.

   (From Wikipedia, the free encyclopedia.) */

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

var e{i in I, j in J, k in K}, >= 0;
/* e = 1 means driver i works in day j on 
line k  at early shift */

var l{i in I, j in J, k in K}, >= 0;
/* e = 1 means driver i works in day j on 
line k at late shift */

s.t. es {j in J, k in K}: sum {i in I} e[i,j,k] = 1;
s.t. ls {j in J, k in K}: sum {i in I} l[i,j,k] = 1;

s.t. phi{i in I, j in J}: sum{k in K} e[i,j,k] <= 1;
/* each driver can work only at one route at the same time */

s.t. psi{i in I, j in J}: sum{k in K} l[i,j, k] <= 1;
/* each driver can work only at one route at the same time */

s.t. doe{i in I, j in J}: sum{k in K} e[i,j,k] * d[i,j] = 0;
s.t. dol{i in I, j in J}: sum{k in K} l[i,j,k] * d[i,j] = 0;
/* driver can't work at day-off */

minimize obj: sum{i in I}sum{j in J}sum{k in K}  if (e[i,j,k] + l[i,j,k] = 2 then 1);
/* the objective is to find a cheapest assignment */

solve;

printf "\n";
//printf "Agent  Task       Cost\n";
//printf{i in I} "%5d %5d %10g\n", i, sum{j in J} j * x[i,j],
//   sum{j in J} c[i,j] * x[i,j];
//printf "----------------------\n";
//printf "     Total: %10g\n", sum{i in I, j in J} c[i,j] * x[i,j];

printf {i in I, j in J, k in K}, i, j, k;
printf "\n";

data;

/* These data correspond to an example from [Christofides]. */

/* Optimal solution is 76 */

param m := 11;

param n := 14;

param kk := 3;




param d : 1  2  3  4  5  6  7  8  9 10 11 12 13 14 :=
      1   0  1  1  0  0  0  0  0  1  1  0  0  0  0 
      2   0  0  0  0  1  1  0  0  0  0  0  1  1  0
      3   0  0  0  1  0  1  0  0  0  0  1  0  1  0 
      4   1  0  1  0  0  0  0  1  0  1  0  0  0  0 
      5   0  1  0  0  0  0  1  0  1  0  0  0  0  1
      6   1  0  0  0  1  0  0  1  0  0  0  1  0  0 
      7   0  0  1  0  0  1  0  0  0  1  0  0  1  0 
      8   0  0  0  1  1  0  0  0  0  0  1  1  0  0 
      9   0  0  0  0  1  0  1  0  0  0  0  1  0  1
     10   1  0  1  0  0  0  0  1  0  1  0  0  0  0
     11   0  1  0  1  0  0  0  0  1  0  1  0  0  0 ;

end;
