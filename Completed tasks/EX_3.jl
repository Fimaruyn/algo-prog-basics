#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля
промаркированы.
=#
using HorizonSideRobots

# Главная функция
function field!(robot)

    # Запоминание исходной точки
    s = 0; w = 0
    s += do_upora(robot, Sud)
    w += do_upora(robot, West)


    side = Ost; n = num_steps(robot)

    for i in 1:n+1
        markers!(robot, side)
        putmarker!(robot)
        side = inverse(side)
        if !isborder(robot, Nord)
            move!(robot, Nord)
        end
    end

    # Возвращение в исходное положение
    do_upora!(robot, Sud)
    do_upora!(robot, West)
    for i in 1:s
        move!(robot, Nord)
    end
    for k in 1:w
        move!(robot, Ost)
    end

end

# Инверсия стороны света
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

# Заполнить линию
function markers!(robot, side)
    while !isborder(robot, side)
        putmarker!(robot)
        move!(robot, side)
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

# Перемещение в заданном направлении до стенки
function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end

# Счетчик высоты поля
function num_steps(robot)
    n = 0
    while !isborder(robot, Nord)
        move!(robot, Nord)
        n += 1
    end
    do_upora!(robot, Sud)
    return n
end
