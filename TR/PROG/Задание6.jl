# ЗАДАЧИ 18-20 КМБО-11-24 Белов В.А




#=
ЗАДАЧА 18

Решить предыдущую задачу, но при дополнительном условии:
 а) на поле имеются внутренние изолированные прямолинейные
 перегородки конечной длины (только прямолинейных, прямоугольных
 перегородок нет);
 б) некоторые из прямолинейных перегородок могут быть
 полубесконечными.
=#
#=
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
        if !isborder(robot, side)
            move!(robot, side)
            n += 1 
        else
            shuttle!(robot, Nord) do side !isborder(robot, side) end 
            n += 1 
        end
    end 
    return stop_condition()
end

function shuttle!(stop_condition::Function, robot, side) 
    s = Ost
    n = 0 
    while !stop_condition(side) 
        move!(robot, s, n) 
        s = inverse(s) 
        n += 1 
    end 
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)
HorizonSideRobots.move!(robot, side, num_steps) = for _ in 1:num_steps move!(robot, side) end
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
=#



#=
ЗАДАЧА 19

Написать рекурсивную функцию, 
перемещающую робота до упора в заданном направлении.
=#
#=
using HorizonSideRobots

function movetoend!(robot, side)
    !isborder(robot, side) ? move!(robot, side) : return
    movetoend!(robot, side)
end
=#



#=
ЗАДАЧА 20

Написать рекурсивную функцию, перемещающую робота до упора в
заданном направлении, ставящую возле перегородки маркер и возвращающую
робота в исходное положение.
=#
#=
using HorizonSideRobots

function movemark!(robot, side)
    if !isborder(robot, side)  
        move!(robot, side) 
    else 
        putmarker!(robot)
        return
    end
    movemark!(robot, side)
    move!(robot, inverse(side))
end

function movetoend!(robot, side)
    !isborder(robot, side) && (move!(robot, side); return) 
    movetoend!(robot, side)
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
=#