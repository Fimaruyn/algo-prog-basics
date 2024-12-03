#=
Написать рекурсивную функцию, 
перемещающую робота до упора в заданном направлении.
=#
using HorizonSideRobots

function movetoend!(robot, side)
    !isborder(robot, side) ? move!(robot, side) : return Nothing
    movetoend!(robot, side)
end