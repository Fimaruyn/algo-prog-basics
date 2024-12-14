#=
Написать рекурсивную функцию, суммирующую все элементы
заданного вектора (реализовать хвостовую рекурсию).
=#
using HorizonSideRobots

function summa(vector)
    @assert !isempty(vector)
    (length(vector)==1) && return vector[begin]
    return summa(vector[begin:end-1]) + vector[end] 
end