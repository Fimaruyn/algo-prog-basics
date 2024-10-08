#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля (без внутренних перегородок)
РЕЗУЛЬТАТ: Робот - в исходном положении, на всем поле расставлены
маркеры в шахматном порядке, причем так, чтобы в клетке с роботом находился
маркер
=#

using HorizonSideRobots

function field!(robot)
    n = 0
    n += do_upora(robot, Sud)
    n += do_upora(robot, West)
    if n%2 == 0 
        flag = True 
    else 
        flag = False 
    end

    side = Ost
    while !isborder(robot, Nord) || !isborder(robot, Ost)
        markers!(robot, side, n)
        move!(robot, Nord)
        side = inverse(side)
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

function markers!(robot, side, flag::Bool)
    while !isborder(robot, side)
        if flag 
            putmarker!(robot) 
            move!(robot, side) 
        else move!(robot, side) 
            putmarker!(robot) 
        end
        if !isborder(robot, side) move!(robot, side) end
    end
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
