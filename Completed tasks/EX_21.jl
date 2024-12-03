#=
Написать рекурсивную функцию, перемещающую робота в соседнюю
клетку в заданном направлении, при этом на пути робота может находиться
изолированная прямолинейная перегородка конечной длины.
=#

using HorizonSideRobots

function moveborder!(robot, side)
    !isborder(robot, side) && (move!(robot,side); return) 
    move!(robot, right(side)) 
    move_border!(robot, side) 
    move!(robot, left(side)) 
end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))