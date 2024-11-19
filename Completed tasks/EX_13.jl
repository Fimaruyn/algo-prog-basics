#=
Решить задачу 9 с использованием обобщённой функции
 snake!(robot, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Ost,Nord))
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

#robot = ChessRobot(robot, corner!(robot, (West, Sud))); snake!(robot, (Ost,Nord)) do s isborder(robot,s)&&isborder(robot,Nord) end