#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного
поля (без внутренних перегородок)

РЕЗУЛЬТАТ: Робот - в исходном положении, и на всем поле расставлены
маркеры в шахматном порядке клетками размера N*N (N-параметр функции),
начиная с юго-западного угла
=#
using HorizonSideRobots

#Главная функция
function big_chess!(robot)
    n = 3; s = 0; w = 0
    k = 0
    s += do_upora(robot, Sud)
    w += do_upora(robot, West)

    x = 0
    y = 0
    side = Ost
    #Закрасить поле в шахматном порядке клетками размером n*n
    while !isborder(robot, Nord) || !isborder(robot, Ost)
        
        while !isborder(robot, side)
            if (mod(x, 2*n) <= n-1) && (mod(y, 2*n) <= n-1) || (mod(x, 2*n) > n-1) && (mod(y, 2*n) > n-1)
                putmarker!(robot)
            end
            move!(robot, side)
            if side == Ost
                x += 1
            else
                x -= 1
            end
            
        end

        if !isborder(robot, Nord)
            if (mod(x, 2*n) <= n-1) && (mod(y, 2*n) <= n-1) || (mod(x, 2*n) > n-1) && (mod(y, 2*n) > n-1)
                putmarker!(robot)
            end
            move!(robot, Nord)
            y += 1
        end
        side = inverse(side)
    end

    # Проверка на закрашивание северо-восточного угла
    if (mod(x, 2*n) <= n-1) && (mod(y, 2*n) <= n-1) || (mod(x, 2*n) > n-1) && (mod(y, 2*n) > n-1)
        putmarker!(robot)
    end

    # Возврат в исходную клетку
    for i in 1:(y - s)
        move!(robot, Sud)
    end
    for i in 1:(x - w)
        move!(robot, West)
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

# Перемещение в заданном направлении до стенки с подсчетом клеток
function do_upora(robot, side)
    num_steps = 0
    while !isborder(robot, side)
        num_steps += 1
        move!(robot, side)
    end
    return num_steps
end