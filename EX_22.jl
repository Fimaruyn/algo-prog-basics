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

function doubledist!(robot, side) 
    isborder(robot, inverse(side)) && return 
    move!(robot, inverse(side)) 
    doubledist!(robot, side) 
    move!(robot, side, 2) 
end

HorizonSideRobots.move!(robot, side, n) = for _ in 1:n move!(robot, side) end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
#??????????????????????????????? что такое заданное направление