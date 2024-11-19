#=
ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок
и маркеров)

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру
внешней рамки промаркированы.
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

#HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robo.robot) 
HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
#HorizonSideRobots.ismarker(robot::ChessRobot) = ismarker(robot.robot)
#HorizonSideRobots.temperature(robot::ChessRobot) = temperature(robot.robot)

function corner(robot, side)
    for s in side 
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

#corner(robot, (Sud, West)); robot = ChessRobot(robot, true); perimeter!(robot)