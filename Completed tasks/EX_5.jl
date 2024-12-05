#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется
ровно одна внутренняя перегородка в форме прямоугольника. Робот - в
произвольной клетке поля между внешней и внутренней перегородками.

РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру
внутренней, как внутренней, так и внешней, перегородки поставлены маркеры
=#
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