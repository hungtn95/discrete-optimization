include "inverse.mzn";
include "value_precede_chain.mzn";
include "increasing.mzn";

int: n;                 % number of gangs
set of int: Gang = 1..n; 
array[Gang] of int: m;  % size of each gang

int: t = sum(i in Gang)(m[i]);
set of int: Time = 1..t;
set of int: Student = 1..t;
int: r; % number of rivalries
set of int: Rival = 1..r;
array[Rival] of Gang: g1;
array[Rival] of Gang: g2;

array[Time] of var Student: order;
array[Student] of var Time: time;
array[Student] of var int: confession;
array[Gang] of Student: leader = [if i == 1 then 1 else sum([m[j] | j in 1..i-1]) + 1 endif | i in Gang];
array[Student] of Gang : gang_id = [ g | g in Gang, j in 1..m[g]];

%%%%%%%

% add your constraints here

constraint inverse(order, time);
constraint forall (i in 1..t-1) (gang_id[order[i]] != gang_id[order[i+1]]);
%constraint forall (i in Student where time[i] < t) (gang_id[order[time[i]]] != gang_id[order[time[i] + 1]]);
%constraint forall (i, j in Student where gang_id[i] = gang_id[j] /\ i < j) (abs(time[i] - time[j]) != 1);

constraint forall (i in Gang where m[i] > 1) (increasing([time[j] | j in (leader[i] + 1)..(leader[i] + m[i] - 1)]));
%constraint forall (i in Gang where m[i] > 1) (value_precede_chain([s | s in Student where gang_id[s] = i /\ s != leader[i]], order));
%constraint forall (i in Gang) (time[leader[i]] < time[leader[j]]);

%constraint forall (i in leader) (increasing([time[j] | j in leader where m[gang_id[i]] = m[gang_id[j]]]));
constraint forall (i in Student) (if i != leader[gang_id[i]] then confession[i] = bool2int(time[i] < time[leader[gang_id[i]]]) else confession[i] = 3*bool2int(time[i] < t div 2) endif);

%constraint forall (i in Time) (if order[i] != leader[gang_id[order[i]]] then confession[order[i]] = bool2int(i < time[leader[gang_id[order[i]]]]) else confession[order[i]] = 3*bool2int(i < t div 2) endif);

constraint forall (i in Rival, j, k in Student where gang_id[j] = g1[i] /\ gang_id[k] = g2[i]) (abs(time[j] - time[k]) != 1);
%constraint forall (i in Rival, j in 1..t-1 where gang_id[order[j]] = g1[i]) (gang_id[order[j+1]] != g2[i]);
%constraint forall (i in Rival, j in 1..t-1 where gang_id[order[j]] = g2[i]) (gang_id[order[j+1]] != g1[i]);

%%%%%%%
var int: obj = sum(confession);
solve::int_search(order, first_fail, indomain_max, complete)
maximize obj;

output ["order = ",show(order),
	";\nobj = ", show(obj),
	";\n" ];




