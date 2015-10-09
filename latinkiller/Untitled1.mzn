predicate leave_alone(var int:x, var int:y, var int:z) =
           if x+y+z == x \/ x+y+z == g \/ x+y+z == z then x = x /\ y = y /\ z = z
           elseif x > 0  /\ y > 0 then 
                if x > y then x = x-y else y = y-x endif
           elseif x > 0 /\ y == 0 /\ z > 0 then
                if x > z then x = x-z /\ z = 0 else z = z-x /\ x = 0 endif
           elseif x == 0 /\ y > 0 /\ z > 0 then 
                if y > z then y = y-1 /\ z = z-1 else z = z-y endif
           else false endif;