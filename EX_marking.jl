using HorizonSideRobots
#EX_2
#EX_3
#EX_10

#=
mutable struct ChessRobot
    robot::Robot
    flag::Bool
end

function HorizonSideRobots.move!(robot::ChessRobot, side)
    robot.flag && putmarker!(robot.robot)
    robot.flag = !robot.flag
    move!(robot.robot, side)
end

#HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robo.robot) 
HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
#HorizonSideRobots.ismarker(robot::ChessRobot) = ismarker(robot.robot)
#HorizonSideRobots.temperature(robot::ChessRobot) = temperature(robot.robot)

=#

#Тип робота: НЕИЗМЕНЯЕМЫЙ. КООРДИНАТЫ 
struct Coordinates
    x::Int
    y::Int
end

function move(coord::Coordinates, side::HorizonSide)
    side == Nord && return Coordinates(coord.x, coord.y+1)
    side == Sud  && return Coordinates(coord.x, coord.y-1)
    side == Ost  && return Coordinates(coord.x+1, coord.y)
    side == West && return Coordinates(coord.x-1, coord.y)
end

#Тип робота: ШАХМАТИСТ N*N
mutable struct ChessRobot{N}
    robot::Robot
    coord::Coordinates
end

function HorizonSideRobots.move!(robot::ChessRobot{N}, side) where N <: Integer
    x = robot.coord.x % 2*N
    y = robot.coord.y % 2*N
    if ((x in 0:N-1) && (y in 0:N-1)) || ((x in N:2*N-1) && (x in N:2*N-1))
        putmarker!(robot.robot)
    end
    move!(robot.robot, side)
end

HorizonSideRobot.isborder(robot::ChessRobot{N}, side) = isborder(robot.robot, side)

chesmark!(robot::Robot, N::Int) = snake!(ChessRobot{N}(robot, Coordinates(0,0)), (Ost, Nord)) do side isborder(robot, side) && isborder(robot, Nord) end

function snake!(stop_condition::Function, robot, sides::NTuple{2,HorizonSide})
    s = side[1]
    while !stop_condition(s)
        movetoend!(robot,s) do
            stop_condition(s) || isborder(robot, s) # - условие останова
        end
        if stop_condition(s)
            break
        end
        s = inverse(s)
        move!(robot, sides[2])
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)




function corner(robot, sides::NTuple{2, HorizonSide})
    for s in sides 
        movetoend!(robot, s) 
    end
end

function perimeter!(robot)
    for s in (Nord, Ost, Sud, West)
        movetoend!(robot, s)
    end
end

function movetoend!(robot, side)
    while trymove!(robot, side) end
end

function trymove!(robot, side)
    isborder(robot, side) && return false
    move!(robot, side)
    return true
end