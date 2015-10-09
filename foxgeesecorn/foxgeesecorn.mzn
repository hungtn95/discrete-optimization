int: f;
int: g;
int: c;
int: k;
set of int: Cap = 0..k;
int: t;
set of int: Trips = 1..t;
int: pf;
int: pg;
int: pc;

array[Trips] of var Cap: fox;
array[Trips] of var Cap: geese;
array[Trips] of var Cap: corn;

array[Trips] of var 0..f: f_w;
array[Trips] of var 0..g: g_w;
array[Trips] of var 0..c: c_w;

array[Trips] of var 0..f: f_e;
array[Trips] of var 0..g: g_e;
array[Trips] of var 0..c: c_e;

var 0..t: trips;

var int: obj = f_e[trips]*pf+g_e[trips]*pg+c_e[trips]*pc;

%%%%%%%%%%%%%%%%%%%%%%%%%%% ADD constraints in here %%%%%%%%%%%%%
constraint forall (i in Trips where i > trips) (fox[i]+geese[i]+corn[i] = 0);
constraint forall (i in Trips where i <= trips) (fox[i]+geese[i]+corn[i] <= k);
constraint forall (i in Trips where i <= trips) 
                  (if i == 1 then f_w[i] = f-fox[i] /\ g_w[i] = g-geese[i] /\ c_w[i] = c-corn[i] /\ f_e[i] = fox[i] /\ g_e[i] = geese[i] /\ c_e[i] = corn[i]
                   elseif i mod 2 == 0 then f_e[i] = f_e[i-1]-fox[i] /\ g_e[i] = g_e[i-1]-geese[i] /\ c_e[i] = c_e[i-1]-corn[i] /\ leave_alone(f_w[i-1], g_w[i-1], c_w[i-1], f_w[i], g_w[i], c_w[i], fox[i], geese[i], corn[i])                      
                   elseif i mod 2 == 1 then f_w[i] = f_w[i-1]-fox[i] /\ g_w[i] = g_w[i-1]-geese[i] /\ c_w[i] = c_w[i-1]-corn[i] /\ leave_alone(f_e[i-1], g_e[i-1], c_e[i-1], f_e[i], g_e[i], c_e[i], fox[i], geese[i], corn[i])
                   else false endif);

predicate leave_alone(var int:f_0, var int:g_0, var int:c_0, var int:f_1, var int:g_1, var int:c_1, var int:f_b, var int:g_b, var int:c_b) =
           if f_0+g_0+c_0 == f_0 \/ f_0+g_0+c_0 == g_0 \/ f_0+g_0+c_0 == c_0 then f_1 = f_0+f_b /\ g_1 = g_0+g_b /\ c_1 = c_0+c_b
           elseif f_0 > 0 /\ g_0 > 0 then 
                  if f_0 > g_0 then f_1 = f_0-1+f_b /\ g_1 = g_0+g_b /\ c_1 = c_0+c_b else g_1 = g_0-f_0+g_b /\ f_1 = f_0+f_b /\ c_1 = c_0+c_b endif
           elseif f_0 > 0 /\ g_0 == 0 /\ c_0 > 0 then
                  if f_0 > c_0 then f_1 = f_0-c_0+f_b /\ c_1 = c_b /\ g_1 = g_b else c_1 = c_0-f_0+c_b /\ f_1 = f_b /\ g_1 = g_b endif
           elseif f_0 == 0 /\ g_0 > 0 /\ c_0 > 0 then 
                  if g_0 > c_0 then g_1 = g_0-1+g_b /\ c_1 = c_0-1+c_b /\ f_1 = f_b else c_1 = c_0-g_0+c_b /\ f_1 = f_b /\ g_1 = g_0+g_b endif
           else false endif;

%%%%%%%%%%%%%%%%% you may want to modify the search strategy below
solve :: int_search([trips], input_order, indomain_min, complete)
      maximize obj;

output ["  fox = ", show(fox),
     ";\ngeese = ", show(geese),
     ";\n corn = ", show(corn),
     ";\ntrips = ", show(trips), 
     ";\n  obj = ", show(obj), ";\n"];

