# ЗАДАЧИ 1-5 КМБО-11-24 Белов В.А

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



#=
ЗАДАЧА 4

ДАНО: Робот находится в произвольной клетке ограниченного
прямоугольного поля без внутренних перегородок и маркеров.
РЕЗУЛЬТАТ: Робот — в исходном положении в центре косого креста из
маркеров, расставленных вплоть до внешней рамки.
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
ЗАДАЧА 5

ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется
ровно одна внутренняя перегородка в форме прямоугольника. Робот - в
произвольной клетке поля между внешней и внутренней перегородками.
РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру
внутренней, как внутренней, так и внешней, перегородки поставлены маркеры
=#
#=
using HorizonSideRobots

mutable struct MarkRobot
    robot::Robot
end

function HorizonSideRobots.move!(robot::MarkRobot, side::HorizonSide) 
    if isborder(robot, Nord) || isborder(robot, Ost) || isborder(robot, Sud) || isborder(robot, West)
        putmarker!(robot)
    end
    move!(robot.robot, side)
end

HorizonSideRobots.move!(robot::MarkRobot, side, nsteps::Integer) = for _ in 1:nsteps move!(robot, side) end

HorizonSideRobots.isborder(robot::MarkRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::MarkRobot) = putmarker!(robot.robot)

function mark!(robot::Robot)
    robot = MarkRobot(robot)
    corner!(robot, (Sud, West))
    snake!(robot, (Ost, Nord)) do side
        isborder(robot, side) && isborder(robot, Nord)
    end
end

function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s=sides[1] 
    while !stop_condition(s) 
        movetoborder!(robot, s) 
        if stop_condition(s)
            break 
        end 
        s = inverse(s) 
        move!(robot, sides[2]) 
    end
end

movetoborder!(robot, side) = while trymove!(robot, side) end
movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end


inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))

function corner!(robot, sides::NTuple{2, HorizonSide})
    while !isborder(robot, sides[1]) || !isborder(robot, sides[2])
        movetoend!(robot, sides[1]) do 
            isborder(robot, sides[1])
        end
        movetoend!(robot, sides[2]) do 
            isborder(robot, sides[2])
        end
    end
end

nummovetoend!(stop_condition::Function, robot, side) = begin 
    n = 0 
    while !stop_condition() 
        move!(robot, side) 
        n += 1 
    end 
    return n
end

function trymove!(robot, side)::Bool 
    nsteps = nummovetoend!(robot, right(side)) do 
        !isborder(robot, side) || isborder(robot, right(side)) #-условие останова 
    end 
    if !isborder(robot, side) # => обойти препятствие возможно 
        move!(robot, side) 
        if nsteps > 0 # => робот находится "в состоянии обхода" 
            movetoend!(robot, side) do # - проход через толщу препятсятвия 
                !isborder(robot, left(side)) 
            end 
        end # иначе надо ограичиться только одним шагом в направлении side
        result = true 
    else # isborder(robot, right(side)) => обход препятствия не возможен 
        result = false 
    end 
    move!(robot, left(side), nsteps) 
    # робот перемещен в направленн обратном тому, в котором он обходил или пытался 
    #обойти препятствие 
    return result 
end
=#