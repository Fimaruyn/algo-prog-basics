# ЗАДАЧИ 4-7 КМБО-11-24 Белов В.А

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



#=
ЗАДАЧА 6

ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля, на котором могут находиться также внутренние прямоугольные
перегородки (все перегородки изолированы друг от друга, прямоугольники
могут вырождаться в отрезки)
РЕЗУЛЬТАТ: Робот - в исходном положении и
a) по всему периметру внешней рамки стоят маркеры;
б) маркеры не во всех клетках периметра, а только в 4-х позициях -
напротив исходного положения робота
=#
#=
using HorizonSideRobots

#Главная функция
function perim_cross!(robot)
    path = []
    num_sud = 0
    num_west = 0

    # Маршрут из исходной клетки в юго-западный угол
    while !isborder(robot, Sud) || !isborder(robot, West)
        s = do_upora(robot, Sud)
        w = do_upora(robot, West)
        num_sud += s
        num_west += w
        push!(path, (s, w))
    end

    #Высота и ширина поля
    n = num_steps_Nord(robot)
    ww = num_steps_West(robot)

    # Робот перемещается по периметру и маркирует клетки относительно исходной
    for side in (Nord, Ost, Sud, West)
        if side == Nord
            for i in 1:num_sud
                move!(robot, Nord)
            end
        elseif side == Ost
            for i in 1:num_west
                move!(robot, Ost)
            end 
        elseif side == Sud
            for i in 1:(n - num_sud)
                move!(robot, Sud)
            end
        elseif side == West
            for i in 1:(ww - num_west)
                move!(robot, West)
            end 
        end

        putmarker!(robot)

        while !isborder(robot, side)
            move!(robot, side)
        end
    end 

    # Возвращение в исходную клетку
    for p in reverse(path)
        s = p[1]
        w = p[2]

        for i in 1:w
            move!(robot, Ost)
        end
        for k in 1:s
            move!(robot, Nord)
        end
        
    end
end

# Высота поля
function num_steps_Nord(robot)
    n = 0
    while !isborder(robot, Nord)
        move!(robot, Nord)
        n += 1
    end
    do_upora!(robot, Sud)
    return n
end

# Ширина поля
function num_steps_West(robot)
    w = 0
    while !isborder(robot, Ost)
        move!(robot, Ost)
        w += 1
    end
    do_upora!(robot, West)
    return w
end

function do_upora(robot, side)
    num_side = 0
    while !isborder(robot, side)
        num_side += 1
        move!(robot, side)
    end
    return num_side
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end
=#



#=
ЗАДАЧА 7

ДАНО: Робот - рядом с горизонтальной бесконечно продолжающейся в
обе стороны перегородкой (под ней), в которой имеется проход шириной в одну
клетку.
РЕЗУЛЬТАТ: Робот - в клетке под проходом
=#
#=
using HorizonSideRobots

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
HorizonSideRobots.move!(robot, side, num_steps) = for i in 1:num_steps move!(robot, side) end
=#
