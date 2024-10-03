#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется
ровно одна внутренняя перегородка в форме прямоугольника. Робот - в
произвольной клетке поля между внешней и внутренней перегородками.

РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру
внутренней, как внутренней, так и внешней, перегородки поставлены маркеры
=#
using HorizonSideRobots

# Главная функция
function printer!(robot)

    # Запоминание исходной точки
    s = 0; w = 0
    while !isborder(robot, Sud) || !isborder(robot, West)
        s+=do_upora(robot, Sud)
        w+=do_upora(robot, West)
    end

    n = num_steps(robot)

 
    for i in (Ost, West) #Nord = 0, Ost = 1, Sud = 2, West = 3

        side = i
        steps = 0
        m = 0

        while steps != (n+1)
            while !isborder(robot, side)

                for i in (Nord, Ost, Sud, West)
                    if isborder(robot, i) == true && ismarker(robot) == false
                        putmarker!(robot)
                        break
                    end            
                end

                move!(robot, side) # Ost -> West
            end

            if m < n
                putmarker!(robot)
                if i == Ost
                    move!(robot, Nord)
                else
                    move!(robot, Sud)
                end
                m += 1
            end

            side = inverse(side)

            steps += 1
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

# Инверсия стороны света
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

# Подсчет высоты поля
function num_steps(robot)
    n = 0
    while !isborder(robot, Nord)
        move!(robot, Nord)
        n += 1
    end
    do_upora(robot, Sud)
    return n
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

# Улучшить запоминания маршрута из исходной клетки в юго-западный угол с использованием patch