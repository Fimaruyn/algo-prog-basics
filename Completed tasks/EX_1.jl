#= 
ДАНО: Робот находится в произвольной клетке ограниченного
прямоугольного поля без внутренних перегородок и маркеров.

РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из
маркеров, расставленных вплоть до внешней рамки (в клетке с роботом маркера
нет)
=#

using HorizonSideRobots

# Главная функция
function cross!(robot)
    for side in (Nord, Ost, Sud, West)
        num_steps = mark_direct!(robot, side)
        side = inverse(side)
        move!(robot, side, num_steps)
    end
end

# Измененный move!. Добавлен цикл с счетчиком
function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)        
    end
end

# Меняет сторону света на противоположную
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

# Движение до стенки с покраской клетки и счетчиком
function mark_direct!(robots, side)::Int
    n::Int = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end