#=
ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок
и маркеров)

РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру
внешней рамки промаркированы.
=#

using HorizonSideRobots

function perimeter!(robot)
    corner!(robot, (Sud, West))
    for s in (Nord, Ost, Sud, West)
        while !stop_condition()
            putmarker!(robot)
            move!(robot, s)
        end
    end
end

function corner!(robot, sides::NTuple{2, HorizonSide})
    for s in sides 
        movetoend!(robot, s) do 
            isborder(robot, s)
        end
    end
end

movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end
 