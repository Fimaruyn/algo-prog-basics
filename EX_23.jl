#=
Написать рекурсивную функцию, перемещающую робота в позицию,
симметричную по отношению к перегородке, находящейся с заданного
направления, т.е. требуется, чтобы в результате робот оказался на расстоянии от
противоположной перегородки равном расстоянию до заданной перегородки.
=#

using HorizonSideRobots

function movesym!(robot, side) 
    isborder(robot, inverse(side)) && (movetoend!(robot, side); return)
    move!(robot, inverse(side))
    movesym!(robot, side) 
    #move!(robot, (side))
end

#=
function movesym!(robot, side) 
    isborder(robot, (side)) && (movetoend!(robot, inverse(side)); return)
    move!(robot, side)
    movesym!(robot, side) 
    move!(robot, inverse(side))
end
=#

function movetoend!(robot, side)
    !isborder(robot, side) && (move!(robot, side); return) 
    movetoend!(robot, side)
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))