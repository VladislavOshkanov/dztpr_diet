set N;
/* nutrients */
set F;
/* foods */
param b{N};
/* required daily allowances of nutrients */
param p{i in F};
/*price*/
param a{F,N};
/* nutritive value of foods (per dollar spent) */
/*var x{f in F} >= 0;*/
/* dollars of food f to be purchased daily */
var q{f in F} >= 0;
/* quantity of food to be purchased daily*/

s.t. nb{n in N}: sum{f in F} a[f,n] * q[f] = b[n];
/* nutrient balance (units) */
minimize cost : sum{f in F} q[f] * p[f];
/*minimize cost: sum{f in F} x[f]; */
/* total food bill (dollars) */
data;
param p :=
	Beef  286
	Bread 26
	Egg   5.2
	Cucumber 105
	Apple 	83
	Butter 	611
	Cottage_cheese 468
	Potatoe		17
	Carrot 		17
	Rice		168
	Milk 		67;
	
param : N : b :=
         Protein       65 /* grams */
	 Lipids        70
         Carbohydrates 257      /* grams */
         Iron          10 /* milligrams */
	 Calcium       1000 /*milligrams*/;

set F := Beef, Bread, Egg, Cucumber, Apple, Butter, Cottage_cheese, Potatoe,Carrot,Rice, Milk;
param a default 0
:            Protein   Lipids  Carbohydrates  	Iron   Calcium :=	
#            (g)    (g)      (g)    		(mg)   (mg)  	 
Beef		260	150	0		26	180
Bread		63	22.7	343		25.2	1820
Egg		6.5	5.5	0.55		0.6	25
Cucumber	7	1	36		3	160
Apple		3	2	140		1	60
Butter		10	810	1		.	240
Cottage_cheese 	180	90	30 		4 	1640
Potatoe		20	1	170		8	120
Carrot		10	2	100		3	330
Rice		27	3	280		2	100
Milk		34	1	5		.	125;
		
end;
