#=
Решить предыдущую задачу, но при условии наличия на поле простых
внутренних перегородок.
Под простыми перегородками мы понимаем изолированные
прямолинейные или прямоугольные перегородки.
=#

using HorizonSideRobots

mutable struct ChessRobot
    robot::Robot
    flag::Bool
end

function HorizonSideRobots.move!(robot::ChessRobot, side)
    robot.flag && putmarker!(robot.robot)
    robot.flag = !robot.flag
    move!(robot.robot, side)
end
HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)


function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide}) 
    s=sides[1] 
    while !stop_condition(s) 
        movetoend!(robot, s) do 
            stop_condition(s) || isborder(robot, s)
        end 
        if stop_condition(s) 
            break 
        end 
        s = inverse(s) 
        move!(robot, sides[2]) 
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end
function movetoend!(robot, s) 
    n = 0
    while !isborder(robot, s) 
        n += 1 
        move!(robot, s) 
    end
    return n
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)

function corner!(robot, sides::NTuple{2, HorizonSide})
    n = 0
    for s in sides 
        n += movetoend!(robot, s)
    end
    if n%2==0 flag = true else flag = false end
    return flag
end

function move_border!(robot, side)
    if !isborder(robot, side)
        move!(robot, side) # - первый шаг в сторону препятствия         
        movetoend!(robot, side) do # - проход через толщу препятсятвия
            !isborder(robot, left(side))
        end
        return # - завершение очередного рекурсивного вызова
    end
    move!(robot, right(side)) # - шаг в сторону обхода препятсятвия
    move_border!(robot, side) # - рекурсия
    move!(robot, left(side)) # - отложенный до окончания рекурсии обратный шаг
end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

#robot = ChessRobot(robot, corner!(robot, (West, Sud))); snake!(robot, (Ost,Nord)) do s isborder(robot,s)&&isborder(robot,Nord) end