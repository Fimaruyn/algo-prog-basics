#=
Написать функцию, расставляющие маркеры в каждой клетке внутри
 произвольного замкнутого лабиринта, ограниченного
 а) маркерами,
 б) перегородками,
 и возвращающую робота в исходное положение.
 Указание: воспользоваться рекурсией.
=#
using HorizonSideRobots

struct Coordinates 
    x::Int 
    y::Int 
end

function move(coord::Coordinates, side::HorizonSide) 
    x = coord.x 
    y = coord.y 
    if side == Nord 
        y += 1 
    elseif side == Sud 
        y -= 1 
    elseif side == Ost 
        x += 1 
    else #if side == West 
        x -= 1 
    end 
    return Coordinates(x, y) 
end

mutable struct CoordRobot 
    robot::Robot 
    coord::Coordinates 
end

CoordRobot(robot) = CoordRobot(robot, Coordinates(0,0)) # - дополнительный внешний конструктор для удобства использования

HorizonSideRobots.move!(robot::CoordRobot, side) = begin 
    move!(robot.robot, side) 
    robot.coord = move(robot.coord, side) 
end

HorizonSideRobots.isborder(robot::CoordRobot, side) = isborder(robot.robot, side)

struct LabirintRobot 
    coord_robot::CoordRobot 
    passed_coords::Set{Coordinates} 
    LabirintRobot(robot::Robot) = new(CoordRobot(robot), Set{Coordinates}()) # - внутренний конструктор, отменяющий конструктор по умолчаснию 
end

""" 
marklabirint_traversal!(actions::Function, lab_robot::LabirintRobot) 
- обобщенная функция, перемещающая робота по всему лабиринту, ограниченному маркерами 
""" 
function marklabirint_traversal!(actions::Function, lab_robot::LabirintRobot) 
    ((lab_robot.coord_robot.coord in lab_robot.passed_coords) || 
    ismarker(lab_robot.coord_robot.robot)) && return 
    push!(lab_robot.passed_coords, lab_robot.coord_robot.coord) 
    actions() 
    for side in (Nord, West, Sud, Ost) 
        move!(lab_robot.coord_robot, side) 
        marklabirint_traversal!(actions, lab_robot) 
        move!(lab_robot.coord_robot, inverse(side)) 
    end 
end

""" 
borderlabirint_traversal!(actions::Function, lab_robot::LabirintRobot) 
- обобщенная функция, перемещающая робота по всему лабиринту, ограниченному перегородками 
"""
function borderlabirint_traversal!(actions::Function, lab_robot::LabirintRobot) 
    (lab_robot.coord_robot.coord in lab_robot.passed_coords) && return 
    push!(lab_robot.passed_coords, lab_robot.coord_robot.coord) 
    actions() 
    for side in (Nord, West, Sud, Ost) 
        trymove!(lab_robot.coord_robot, side) && begin 
            borderlabirint_traversal!(actions, lab_robot) 
            move!(lab_robot.coord_robot, inverse(side))
    end
    end  
end 

function trymove!(robot, side)
    if isborder(robot, side) 
        return false 
    else 
        move!(robot, side) 
        return true 
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

function labirint!(robot::Robot) 
    marklabirint_traversal!(LabirintRobot(robot)) do 
        putmarker!(robot)
    end
end