#=
Написать рекурсивную функцию, перемещающую робота в заданном
направлении до упора и расставляющую маркеры в шахматном порядке,
a) начиная с установки маркера;
б) начиная без установки маркера (в стартовой клетке).
Указание: воспользоваться косвенной рекурсией
=#

using HorizonSideRobots

function markchess_a!(robot, side) 
    putmarker!(robot) 
    isborder(robot, side) && return
    move!(robot, side) 
    markchess_0!(robot, side) 
end

function markchess_b!(robot, side) 
    isborder(robot, side) && return
    move!(robot, side) 
    putmarker!(robot)
    markchess_1!(robot, side) 
end