#ЗАДАЧИ 6-10 КМБО-11-24 Белов В.А.

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