#=
Решить предыдущую задачу, но при дополнительном условии:
 а) на поле имеются внутренние изолированные прямолинейные
 перегородки конечной длины (только прямолинейных, прямоугольных
 перегородок нет);
 б) некоторые из прямолинейных перегородок могут быть
 полубесконечными.
=#

using HorizonSideRobots

function spiral!(stop_condition::Function, robot) 
    nmax_steps = 1
    s = Nord 
    while !find_direct!(stop_condition::Function, robot, s, nmax_steps) 
        (s in (Nord, Sud)) && (nmax_steps += 1) 
        s = left(s) 
    end 
end 

function find_direct!(stop_condition::Function, robot, side, nmax_steps) 
    n = 0 
    while !stop_condition() && (n < nmax_steps)
        move!(robot, side) 
        n += 1 
    end 
    return stop_condition()
end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))