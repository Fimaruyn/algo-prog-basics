#=
 Написать рекурсивную функцию, перемещающую робота на расстояние
 вдвое большее исходного расстояния от перегородки, находящейся с заданного
 направления (предполагается, что размеры поля позволяют это сделать).
 Доработать эту функцию таким образом, чтобы она возвращала значение
 true, в случае, если размеры поля позволяют удвоить расстояние, или - значение
 false, в противном случае (в этом случае робот должен быть перемещен на
 максимально возможное расстояние).
 Как при этом можно было бы сделать так, чтобы в случае невозможности
 переместить робота на удвоенное расстояние, в результате робот оставался бы в
 исходном положении?
=#

using HorizonSideRobots
#=
function doubledist!(robot, side) 
    isborder(robot, (side)) && return 
    move!(robot, (side)) 
    doubledist!(robot, (side)) 
    move!(robot, inverse(side), 2) 
end

HorizonSideRobots.move!(robot, side, n) = for _ in 1:n move!(robot, side) end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
=#
function trydoubledist!(robot, side)
    n, m = trydoubledist_!(robot, side)
    if m == 2*n 
        return true
    else
        move!(robot, inverse(side), 2*n-m)
        return false
    end
end

function trydoubledist_!(robot, side)
    trymove!(robot, side) || return 0, 0
    num_forward_steps, num_inverse_steps = trydoubledist_!(robot, side)
    if trymove!(robot, inverse(side))
        if trymove!(robot, inverse(side))
            return num_forward_steps + 1, num_inverse_steps + 2
        else
            return num_forward_steps + 1, num_inverse_steps + 1
        end
    else
        return num_forward_steps + 1, num_inverse_steps
    end
end

function trymove!(robot, side)
    isborder(robot, side) && return false
    move!(robot, side)
    return true
end

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    num_steps == 0 && return
    move!(robot, side)
    move!(robot, side, num_steps-1)
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
