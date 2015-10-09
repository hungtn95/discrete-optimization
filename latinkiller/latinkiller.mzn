include "alldifferent.mzn";

int: n;
set of int: Num = 1..n;
int: m;
set of int: Group = 1..m;
set of int: Group0 = 0..m;
array[Group] of int: s;
array[Num,Num] of Group0: a;

array[Num,Num] of var Num: x;

%%%%%%%

% add your constraints here
constraint forall (i in Num) ( alldifferent( [ x[i,j] | j in Num ]) );

constraint forall (j in Num) ( alldifferent( [ x[i,j] | i in Num ]) );

constraint forall (k in Group) ( alldifferent( [ x[i,j] | i,j in Num where a[i,j] = k]) );

constraint forall (k in Group) ( s[k] = sum( [ x[i,j] | i,j in Num where a[i,j] = k]) );

%%%%%%%

solve satisfy;

output ["x = [|"] ++
       [ if j = 1 /\ 2 <= i /\ i <= n then "| " else "" endif ++
         show(x[i,j]) ++ 
         if j == n then "\n" else ", " endif  
       | i,j in Num ] 
       ++
       ["|];\n"]
;

