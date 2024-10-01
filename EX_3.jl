#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля
промаркированы.
=#
using HorizonSideRobots

function field!(robot)
    do_upora!(robot, Sud)
    do_upora!(robot, West)
    side = Ost; n = num_steps(robot)
    for i in 1:n+1
        markers!(robot, side)
        putmarker!(robot)
        side = inverse(side)
        if isborder(robot, Nord)
        move!(robot, Nord)
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function markers!(robot, side)
    while !isborder(robot, side)
        putmarker!(robot)
        move!(robot, side)
    end
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end

function num_steps(robot)
    n = 0
    while !isborder(robot, Nord)
        move!(robot, Nord)
        n += 1
    end
    do_upora!(robot, Sud)
    return n
end