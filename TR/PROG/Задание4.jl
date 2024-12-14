# ЗАДАЧИ 11-14 КМБО-11-24 Белов В.А


#=
ЗАДАЧА 11

ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля, на поле расставлены горизонтальные перегородки различной длины
(перегородки длиной в несколько клеток, считаются одной перегородкой), не
касающиеся внешней рамки.
РЕЗУЛЬТАТ: Робот — в исходном положении, подсчитано и возвращено
число всех перегородок на поле.
=#
#=
using HorizonSideRobots

# Главная функция
function partitions!(robot)
    w = do_upora(robot, West)

    n = do_upora(robot, Nord)

    k = 0
    num_part = 0
    side = Ost
    while (!isborder(robot, Sud) || !isborder(robot, Ost)) && (!isborder(robot, Sud) || !isborder(robot, West))
        num_part += numborders!(robot, side)
            (robot, side)
        if !isborder(robot, Sud)
            move!(robot, Sud)
            k +=1
        end
        side = inverse(side)
    end

    # В исходную клетку
    do_upora(robot, West)
    for i in 1:(k-n)
        move!(robot, Nord)
    end
    for i in 1:w
        move!(robot, Ost)
    end
    
    println(num_part)
end


inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

# Перемещение по строке с подсчетом перегородок
function numborders!(robot, side)
    state = 0
    num_borders = 0
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            (isborder(robot, Sud) == true) && (state = 1; num_borders += 1)
        elseif state == 1
            (isborder(robot, Sud) == false) && (state = 0)
        end
    end
    return num_borders
end

# Перемещение в заданном направлении до стенки с подсчетом клеток
function do_upora(robot, side)
    num_steps = 0
    while !isborder(robot, side)
        num_steps += 1
        move!(robot, side)
    end
    return num_steps
end
=#



#=
ЗАДАЧА 12

Отличается от предыдущей задачи тем, что если в перегородке имеются
разрывы не более одной клетки каждый, то такая перегородка считается одной
перегородкой.
=#
#=
using HorizonSideRobots

# Главная функция
function partitions!(robot)
    w = do_upora(robot, West)

    n = do_upora(robot, Nord)

    k = 0
    num_part = 0
    side = Ost
    while (!isborder(robot, Sud) || !isborder(robot, Ost)) && (!isborder(robot, Sud) || !isborder(robot, West))
        num_part += numborders!(robot, side)
        if !isborder(robot, Sud)
            move!(robot, Sud)
            k +=1
        end
        side = inverse(side)
    end

    # В исходную клетку
    do_upora(robot, West)
    for i in 1:(k-n)
        move!(robot, Nord)
    end
    for i in 1:w
        move!(robot, Ost)
    end
    
    println(num_part)
end


inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

# Перемещение по строке с подсчетом перегородок
function numborders!(robot, side)
    state = 0
    num_borders = 0
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            (isborder(robot, Sud) == true) && (state = 1; num_borders += 1)
        elseif state == 1
            (isborder(robot, Sud) == false) && (state = 2)
        elseif state == 2
            (isborder(robot, Sud) == false) && (state = 0)
        end
    end
    return num_borders
end

# Перемещение в заданном направлении до стенки с подсчетом клеток
function do_upora(robot, side)
    num_steps = 0
    while !isborder(robot, side)
        num_steps += 1
        move!(robot, side)
    end
    return num_steps
end
=#



#=
ЗАДАЧА 13

Решить задачу 9 с использованием обобщённой функции
snake!(robot, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Ost,Nord))
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

mutable struct ChessRobot
    robot::Robot
    coord::Coordinates
end


function HorizonSideRobots.move!(robot::ChessRobot, side::HorizonSide) 
    x = mod(robot.coord.x, 2) 
    y = mod(robot.coord.y, 2) 
    (x == y) && putmarker!(robot.robot)
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
end

HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robot.robot)

function chessmark!(robot::Robot)
    robot = ChessRobot(robot, Coordinates(0,0))
    corner!(robot, (Sud, West))
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



#=
ЗАДАЧА 14

Решить предыдущую задачу, но при условии наличия на поле простых
внутренних перегородок.
Под простыми перегородками мы понимаем изолированные
прямолинейные или прямоугольные перегородки.
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

mutable struct ChessRobot
    robot::Robot
    coord::Coordinates
end

function HorizonSideRobots.move!(robot::ChessRobot, side::HorizonSide) 
    x = mod(robot.coord.x, 2) 
    y = mod(robot.coord.y, 2) 
    if x == y
        putmarker!(robot.robot)
    end 
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
end

HorizonSideRobots.move!(robot::ChessRobot, side, nsteps::Integer) = for _ in 1:nsteps move!(robot, side) end

HorizonSideRobots.isborder(robot::ChessRobot, side) = isborder(robot.robot, side)
HorizonSideRobots.putmarker!(robot::ChessRobot) = putmarker!(robot.robot)

function chessmark!(robot::Robot)
    robot = ChessRobot(robot, Coordinates(0,0))
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
    for s in sides 
        movetoend!(robot, s) do 
            isborder(robot, s)
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
