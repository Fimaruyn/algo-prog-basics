# ЗАДАЧИ 1-3 КМБО-11-24 Белов В.А

#= 
ЗАДАЧА 1

ДАНО: Робот находится в произвольной клетке ограниченного
прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из
маркеров, расставленных вплоть до внешней рамки (в клетке с роботом маркера
нет)
=#
#=
using HorizonSideRobots

function mark_cross(robot, sides)
    for side in sides 
        n = mark_direct(robot, side)
        s = inverse(side)
        for _ in 1:n move!(robot, s) end
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)

function mark_direct(robot, side)
    n::Int = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end

HorizonSideRobots.isborder(robot, side::NTuple{2, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])
HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end
=#



#=
ЗАДАЧА 2

ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок
и маркеров)
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру
внешней рамки промаркированы.
=#
#=
using HorizonSideRobots

function perimeter!(robot)
    corner!(robot, (Sud, West))
    for s in (Nord, Ost, Sud, West)
        while !stop_condition()
            putmarker!(robot)
            move!(robot, s)
        end
    end
end

function corner!(robot, sides::NTuple{2, HorizonSide})
    for s in sides 
        movetoend!(robot, s) do 
            isborder(robot, s)
        end
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end
=#



#=
ЗАДАЧА 3

ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля
РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля
промаркированы.
=#
#=
using HorizonSideRobots

function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide}) 
    s=sides[1] 
    while !stop_condition(s) 
        movetoend!(robot, s) do 
            stop_condition(s) || isborder(robot, s)
        end 
        if stop_condition(s) 
            putmarker!(robot)
            break 
        end 
        s = inverse(s) 
        putmarker!(robot)
        move!(robot, sides[2]) 
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() putmarker!(robot); move!(robot, side) end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)

function corner!(robot, sides::NTuple{2, HorizonSide})
    for s in sides 
        movetoend!(robot, s) do 
            isborder(robot, s)
        end
    end
end
=#
