# ЗАДАЧИ 8-10 КМБО-11-24 Белов В.А


#=
ЗАДАЧА 8

ДАНО: Где-то на неограниченном со всех сторон поле без внутренних
перегородок имеется единственный маркер. Робот - в произвольной клетке этого
поля.
РЕЗУЛЬТАТ: Робот - в клетке с маркером
=#
#=
using HorizonSideRobots

#Главная функция
function findmarker!(robot)::Nothing
    side = Nord
    max_nsteps = 0
    while !findmarker!(robot, side, max_nsteps)
        side = left(side)
        (side in (Nord, Sud) && (max_nsteps += 1))
    end
end

# Добавлено количество шагов
function findmarker!(robot, side, max_nsteps)::Bool
    for _ in 0:max_nsteps
        ismarker(robot) && return true
        move!(robot, side)
    end
    return ismarker(robot)
end

#Поворот стороны света в лево
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
=#



#=
ЗАДАЧА 9

ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля (без внутренних перегородок)
РЕЗУЛЬТАТ: Робот - в исходном положении, на всем поле расставлены
маркеры в шахматном порядке, причем так, чтобы в клетке с роботом находился
маркер
=#
#=
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
=#



#=
ЗАДАЧА 10

ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля (без внутренних перегородок)
РЕЗУЛЬТАТ: Робот - в исходном положении, и на всем поле расставлены
маркеры в шахматном порядке клетками размера N*N (N-параметр функции),
начиная с юго-западного угла
=#
#=
using HorizonSideRobots

mutable struct Coordinates
    x::Int
    y::Int
end

function move(coord::Coordinates, side::HorizonSide) 
    side == Nord && return Coordinates(coord.x, coord.y+1) 
    side == Sud && return Coordinates(coord.x, coord.y-1) 
    side == Ost && return Coordinates(coord.x+1, coord.y) 
    side == West && return Coordinates(coord.x-1, coord.y) 
end

mutable struct ChessRobot{N}
    robot::Robot
    coord::Coordinates
end


function HorizonSideRobots.move!(robot::ChessRobot{N}, side::HorizonSide) where {N}
    x = mod(robot.coord.x, 2*N) 
    y = mod(robot.coord.y, 2*N) 
    if ((x in 0:N-1) && (y in 0:N-1)) || ((x in N:2*N-1) && (y in N:2*N-1)) 
        putmarker!(robot.robot)
    end 
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
end

HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robot.robot)

function chessmark!(robot::Robot, N::Int)
    corner!(robot, (Sud, West))
    robot = ChessRobot{N}(robot, Coordinates(0,0))
    snake!(robot, (Ost, Nord)) do side
        isborder(robot, side) && isborder(robot, Nord)
    end
end

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
        move!(robot, sides[2]) 
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end


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