#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля, на котором могут находиться также внутренние прямоугольные
перегородки (все перегородки изолированы друг от друга, прямоугольники
могут вырождаться в отрезки)

РЕЗУЛЬТАТ: Робот - в исходном положении и
a) по всему периметру внешней рамки стоят маркеры;
б) маркеры не во всех клетках периметра, а только в 4-х позициях -
напротив исходного положения робота
=#

using HorizonSideRobots

#Главная функция
function perim_cross!(robot)
    path = []
    num_sud = 0
    num_west = 0

    # Маршрут из исходной клетки в юго-западный угол
    while !isborder(robot, Sud) || !isborder(robot, West)
        s = do_upora(robot, Sud)
        w = do_upora(robot, West)
        num_sud += s
        num_west += w
        push!(path, (s, w))
    end

    #Высота и ширина поля
    n = num_steps_Nord(robot)
    ww = num_steps_West(robot)

    # Робот перемещается по периметру и маркирует клетки относительно исходной
    for side in (Nord, Ost, Sud, West)
        if side == Nord
            for i in 1:num_sud
                move!(robot, Nord)
            end
        elseif side == Ost
            for i in 1:num_west
                move!(robot, Ost)
            end 
        elseif side == Sud
            for i in 1:(n - num_sud)
                move!(robot, Sud)
            end
        elseif side == West
            for i in 1:(ww - num_west)
                move!(robot, West)
            end 
        end

        putmarker!(robot)

        while !isborder(robot, side)
            move!(robot, side)
        end
    end 

    # Возвращение в исходную клетку
    for p in reverse(path)
        s = p[1]
        w = p[2]

        for i in 1:w
            move!(robot, Ost)
        end
        for k in 1:s
            move!(robot, Nord)
        end
        
    end
end

# Высота поля
function num_steps_Nord(robot)
    n = 0
    while !isborder(robot, Nord)
        move!(robot, Nord)
        n += 1
    end
    do_upora!(robot, Sud)
    return n
end

# Ширина поля
function num_steps_West(robot)
    w = 0
    while !isborder(robot, Ost)
        move!(robot, Ost)
        w += 1
    end
    do_upora!(robot, West)
    return w
end

function do_upora(robot, side)
    num_side = 0
    while !isborder(robot, side)
        num_side += 1
        move!(robot, side)
    end
    return num_side
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end