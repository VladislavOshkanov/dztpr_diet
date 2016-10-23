set N;
/* nutrients */
set F;
/* foods */
param b{N};
/* required daily allowances of nutrients */
param m{N};
/* maximal daily allowances of nutrients */
param maxq{i in F};
/* maximal quantity of each product*/
param p{i in F};
/*price*/
param d := 30;
/*how many days*/
param a{F,N};
/* nutritive value of foods (per dollar spent) */
/*var x{f in F} = 0;*/
/* dollars of food f to be purchased daily */
var q{f in F} >= 0,integer;
/* quantity of food to be purchased daily*/

s.t. nb{n in N}: sum{f in F} a[f,n] * q[f] >= b[n]*d;
s.t. ub{n in N}: sum{f in F} a[f,n] * q[f] <= m[n]*d;
s.t. mb{f in F}: q[f] <= maxq[f]*d;
/* nutrient balance (units) */
minimize cost : sum{f in F} q[f] * p[f];
/*minimize cost: sum{f in F} x[f]; */
/* total food bill (dollars) */
data;

param maxq :=
	Beef  4
	Bread 1
	Egg   0.2
	Cucumber 4
	Apple 	2
	Butter 	0.2
	Cottage_cheese 1
	Potatoe		4
	Carrot 		4
	Rice		0.5
	Milk 		0.8;

param p :=
	Beef  28.6
	Bread 26
	Egg   52
	Cucumber 10.5
	Apple 	16.6
	Butter 	110
	Cottage_cheese 104
	Potatoe		1.7
	Carrot 		1.7
	Rice		86
	Milk 		67;
	
param : N : b :=
         Protein       65	/* grams */
	 Lipids        70	
         Carbohydrates 257	    /* grams */
         Iron          10	/* milligrams */
	 Calcium       1000	/*milligrams*/;

param m :=
         Protein       117	/* grams */
	 Lipids        154	
         Carbohydrates 586	    /* grams */
         Iron          12	/* milligrams */
	 Calcium       1200	/*milligrams*/;
set F := Beef, Bread, Egg, Cucumber, Apple, Butter, Cottage_cheese, Potatoe,Carrot,Rice, Milk;
param a default 0
:            Protein   Lipids  Carbohydrates  	Iron   Calcium :=	
#            (g)    (g)      (g)    		(mg)   (mg)  	 
Beef		26	15	0		2.6	18
Bread		63	22.7	343		25.2	1820
Egg		65	55	5.5		6	25
Cucumber	.7	.1	3.6		.3	160
Apple		0.6	.4	28		.2	12
Butter		1.8	145.8	0.18		.	43.2
Cottage_cheese 	39.6	19.8	6.6 		0.88 	360.8
Potatoe		20	1	170		8	120
Carrot		10	.2	10.0		.3	33.0
Rice		13.5	1.5	140		1	84
Milk		34	1	5		.	125;
		
end;
