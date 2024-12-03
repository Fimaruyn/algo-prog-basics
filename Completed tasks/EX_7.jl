#=
ДАНО: Робот - рядом с горизонтальной бесконечно продолжающейся в
обе стороны перегородкой (под ней), в которой имеется проход шириной в одну
клетку.

РЕЗУЛЬТАТ: Робот - в клетке под проходом

using HorizonSideRobots; robot = Robot("field_ex_7.sit", animate = true); include("EX_7.jl"); prohod!(robot)
=#
using HorizonSideRobots

# Главная функция
function passage!(robot)
    # Принцип маятника
    side = Ost
    num_steps = 1
    while isborder(robot, Nord)
        move!(robot, side, num_steps)
        side = inverse(side)
        num_steps += 1
    end    
end

# Меняет сторону света на противоположную
inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function HorizonSideRobots.move!(robot, side, num_steps)
    for i in 1:num_steps
        move!(robot, side)
    end
end
