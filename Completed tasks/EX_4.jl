#=
ДАНО: Робот находится в произвольной клетке ограниченного
прямоугольного поля без внутренних перегородок и маркеров.

РЕЗУЛЬТАТ: Робот — в исходном положении в центре косого креста из
маркеров, расставленных вплоть до внешней рамки.
=#
using HorizonSideRobots

# Главная функция
function xcross!(robot)
    for s in ((Nord, Ost), (Sud, Ost), (Sud, West), (Nord, West))
        n = xmark_direct!(robot, s)
        xmove!(robot, inverse.(s), n)
    end
end

# Движение до стенки с покраской клетки и счетчиком
function xmark_direct!(robot, side::NTuple{2, HorizonSide})
    n=0
    while !(isborder(robot, side[1]) || isborder(robot, side[2]))
        # перегородки нет с обох направлений
        move!(robot, side[1])
        move!(robot, side[2])
        putmarker!(robot)
        n+=1
    end
    return n
end

# Меняет сторону света на противоположную
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

# Измененный move!. Добавлен цикл с счетчиком
function xmove!(robot, side::NTuple{2, HorizonSide}, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side[1])
        move!(robot, side[2])
    end
end