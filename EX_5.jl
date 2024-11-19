#=
ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется
ровно одна внутренняя перегородка в форме прямоугольника. Робот - в
произвольной клетке поля между внешней и внутренней перегородками.

РЕЗУЛЬТАТ: Робот - в исходном положении и по всему периметру
внутренней, как внутренней, так и внешней, перегородки поставлены маркеры
=#
using HorizonSideRobots









function move_border!(robot, side)
    if !isborder(robot, side)
        move!(robot, side) # - первый шаг в сторону препятствия         
        movetoend!(robot, side) do # - проход через толщу препятсятвия
            !isborder(robot, left(side))
        end
        return # - завершение очередного рекурсивного вызова
    end
    move!(robot, right(side)) # - шаг в сторону обхода препятсятвия
    move_border!(robot, side) # - рекурсия
    move!(robot, left(side)) # - отложенный до окончания рекурсии обратный шаг
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))