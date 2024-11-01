#=
Отличается от предыдущей задачи тем, что если в перегородке имеются
разрывы не более одной клетки каждый, то такая перегородка считается одной
перегородкой.
=#

using HorizonSideRobots

# Главная функция
function partitions!(robot)
    w = do_upora(robot, West)

    n = do_upora(robot, Nord)

    k = 0
    num_part = 0
    side = Ost
    while (!isborder(robot, Sud) || !isborder(robot, Ost)) && (!isborder(robot, Sud) || !isborder(robot, West))
        num_part += line(robot, side)
        if !isborder(robot, Sud)
            move!(robot, Sud)
            k +=1
        end
        side = inverse(side)
    end

    # В исходную клетку
    do_upora(robot, West)
    for i in 1:(k-n)
        move!(robot, Nord)
    end
    for i in 1:w
        move!(robot, Ost)
    end
    
    println(num_part)
end


inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

# Перемещение по строке с подсчетом перегородок
function line(robot, side)
    num_part = 0
    while !isborder(robot, side)
        move!(robot, side)
        if isborder(robot, Sud)
            num_part += 1
            while isborder(robot, Sud)
                move!(robot, side)
            end
        elseif isborder(robot, Sud) 
            while isborder(robot, Sud)
                move!(robot, side)
            end
        end
    end
    return num_part
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