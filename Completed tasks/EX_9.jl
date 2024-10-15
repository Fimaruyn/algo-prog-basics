#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля (без внутренних перегородок)
РЕЗУЛЬТАТ: Робот - в исходном положении, на всем поле расставлены
маркеры в шахматном порядке, причем так, чтобы в клетке с роботом находился
маркер
=#

using HorizonSideRobots

#Главная функция
function field!(robot)
    #Юго-западная клетка + четность/нечетность пути
    n = 0; s = 0; w = 0
    s += do_upora(robot, Sud)
    w += do_upora(robot, West)
    n = s + w
    if n%2 == 0 
        flag = 1
    else 
        flag = 0
    end
    
    side = Ost
    while !isborder(robot, Nord) || !isborder(robot, Ost)
        markers!(robot, side, flag)
        if !isborder(robot, Nord)
            move!(robot, Nord)
        end
        side = inverse(side)
    end

    #В исходную клетку
    do_upora(robot, Sud)
    do_upora(robot, West)
    for i in 1:s
        move!(robot, Nord)
    end
    for i in 1:w
        move!(robot, Ost)
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

# Закрашивание линии в шахматном порядке
function markers!(robot, side, flag)
    while !isborder(robot, side)
        if flag == 1
            putmarker!(robot) 
            move!(robot, side) 
        elseif flag == 0
            move!(robot, side) 
            putmarker!(robot) 
        end
        if !isborder(robot, side) 
            move!(robot, side) 
        end
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
