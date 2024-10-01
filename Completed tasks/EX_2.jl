#=
ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок
и маркеров)

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру
внешней рамки промаркированы.
=#

using HorizonSideRobots

# Главная функция
function perim!(robot)
    s = 0; w = 0
    s += do_upora(robot, Sud)
    w += do_upora(robot, West)
    for side in (Nord, Ost, Sud, West)
        while !isborder(robot, side)
            move!(robot, side)
            putmarker!(robot)
        end
    end

    # Возвращение в исходное положение
    for i in 1:s
        move!(robot, Nord)
    end
    for k in 1:w
        move!(robot, Ost)
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
