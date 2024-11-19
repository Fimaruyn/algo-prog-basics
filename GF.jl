import HorizonSideRobots as HSR

###############################
#        ТИПЫ  РОБОТОВ        #
###############################

#Тип робота: АБСТРАКТНЫЙ
abstract type AbstractRobot end

move!(robot::AbstractRobot, side) = HSR.move!(getbaserobot(robot), side)
isborder(robot::AbstractRobot, side) = HSR.isborder(getbaserobot(robot), side)
putmarker!(robot::AbstractRobot) = HSR.putmarker!(getbaserobot(robot))
ismarker(robot::AbstractRobot) = HSR.ismarker(getbaserobot(robot))
temperature(robot::AbstractRobot) = HSR.temperature(getbaserobot(robot))

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

#Тип робота: ИДУЩИЙ ПО КООРДИНАТАМ 
mutable struct CoordRobot <: AbstractRobot
    robot::Robot
    coord::Coordinates
end

CoordRobot(robot) = CoordRobot(robot, Coordinates(0,0))
# - дополнительный внешний конструктор для удобства использования

HSR.move!(robot::CoordRobot, side) = begin
    move!(robot.robot, side)
    robot.coord = move(robot.coord, side)
end

#Тип робота: ШАХМАТИСТ
mutable struct ChessRobot <: AbstractRobot
    robot::Robot
    flag::Bool
end

function HSR.move!(robot::ChesRobot, side)
    flag && putmarker!(robot.robot)
    robot.flag = !robot.flag
    move!(robot.robot, side)
end

#Тип робота: ШАХМАТИСТ N*N
mutable struct Chess_Robot{N} <: AbstractRobot
    robot::Robot
    coord::Coordinates
end

function HorizonSideRobots.move!(robot::ChessRobot{N}, side) where N <: Integer
    x = robot.coord.x % 2N
    y = robot.coord.y % 2N
    if ((x in 0:N-1) && (y in 0:N-1)) || ((x in N:2N-1) && (x in N:2N-1))
        putmarker!(robot.robot)
    end
    move!(robot.robot, side)
end

#Тип робота: СПЛОШНОЕ ЗАКРАШИВАНИЕ
struct MarkRobot <: AbstractRobot
    robot::Robot
end

function HSR.move!(robot::MarkRobot, side)
    putmarker!(robot.robot)
    move!(robot.robot, side)
end

#Тип робота: МАКСИМАЛЬНАЯ ТЕМПЕРАТУРА
mutable struct MaxTmprRobot <: AbstractRobot
    robot::Robot
    max_tmpr::Int
end

function HorizonSideRobots.move!(robot::MaxTmprRobot, side)
    move!(robot.robot, side)
    t=temperature(robot.robot)
    robot.max_tmpr = max(robot.max_tmpr, t)
    nothing
end

#Тип робота: СЧЕТЧИК ПЕРЕГОРОДОК 
mutable struct CountBorders{N} <: AbstractRobot
    robot::Robot
    num_borders::Int
    state::Int
end

function HorizonSideRobots.move!(robot::CountBorders{0}, side)
    move!(robot.robot, side)
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0
            (isborder(robot, Nord) == true) && (state = 1; num_borders += 1)
        elseif state == 1
            (isborder(robot, Nord) == false) && (state = 0)
        end
    end
end
function HorizonSideRobots.move!(robot::CountBorders{1}, side)
    move!(robot.robot, side)
    if state == 0 # на двух последних шагах перегородки не нет
        (isborder(robot, Nord) == true) && (state = 1; num_borders += 1)
    elseif state == 1 # на предпоследнем шаге перегородка есть
        (isborder(robot.robot, Nord) == false) && (state = 2)
    elseif state == 2 # на предпоследнем шаге перегородки нет
        (isborder(robot, Nord) == false) && (state = 0)
    end
end

#Тип робота: БЕГУЩИЙ ПО ЛАБИРИНТУ 
struct LabirintRobot
    coord_robot::CoordRobot
    passed_coords::Set{Coordinates} # - множество с координатами
    LabirintRobot(robot::Robot) = new(CoordRobot(robot), Set{Coordinates}())
    # - это внуренний конструктор, отменяющий конструктор по умолчанию
end

###############################
#           ФУНКЦИИ           #
###############################

#Перемещение до упора в перегородку
function movetoend!(robot, side)
    while trymove!(robot, side) 
    end
end

#Проверка на возможность перемещения в указанную сторону
function trymove!(robot, side)
    #замена условного оператора if/else
    isborder(robot, side) && return false
    move!(robot, side)
    return true
end

# Инверсирование стороны света
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))


###############################
#           ЗАДАНИЯ           #
###############################

# №1, 4: Движение крестом

function cross!(robot, sides = (Nord, Ost, Sud, West))
    for s = sides
        n = mark_direct!(robot, s)
        move!(robot, inverse(s), n)
    end
end

function mark_direct!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end

HSR.isborder(robor, side::NTuple{HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])
HSR.move!(robot, side::Any) = for s in side move!(robot, s) end
HSR.move!(robot, side, n) = for _ in side move!(robot, s) end