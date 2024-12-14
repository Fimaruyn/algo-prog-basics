#=
Написать рекурсивную функцию, перемещающую робота на расстояние
от перегородки с заданного направления вдвое меньшее исходного.
Указание: воспользоваться косвенной рекурсией.
=#
using HorizonSideRobots

function halfdist_minus!(robot, side) 
    isborder(robot, side) && return 
    move!(robot, side) 
    halfdist_plus!(robot, side) 
end

function halfdist_plus!(robot, side) 
    isborder(robot, side) && return 
    move!(robot, side) 
    halfdist_minus!(robot, side) 
    move!(robot, inverse(side)) 
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))