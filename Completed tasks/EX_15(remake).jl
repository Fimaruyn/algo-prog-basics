#=
Решить задачу 4, но при условии наличия на поле простых внутренних перегородок.
=#

using HorizonSideRobots

function mark_cross(robot, sides)
    for side in sides 
        nsteps = movetoborder!(robot, side)
        #move!(robot, inverse(side), nsteps) 
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)+3, 4))

function movetoborder!(robot, side)
    n::Int = 0
    while true
        if !isborder(robot, side)
            move!(robot, side)
            putmarker!(robot)
            n += 1
        elseif trymove!(robot, side)
            putmarker!(robot)
            n += 1
        elseif !trymove!(robot, side)
            return n
        end
    end

end    


HorizonSideRobots.move!(robot, side, nsteps::Integer) = for _ in 1:nsteps move!(robot, side) end
HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end

HorizonSideRobots.isborder(robot, side::NTuple{2, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])
HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end


movetoend!(stop_condition::Function, robot, side) = while !stop_condition() move!(robot, side) end

function trymove!(robot, sides::NTuple{2, HorizonSide})::Bool 
    for side in sides
        nsteps = nummovetoend!(robot, right(side)) do 
            !isborder(robot, side) || isborder(robot, right(side)) #-условие останова 
        end 
        if !isborder(robot, side) # => обойти препятствие возможно 
            move!(robot, side) 
            if nsteps > 0 # => робот находится "в состоянии обхода" 
                movetoend!(robot, side) do # - проход через толщу препятсятвия 
                    !isborder(robot, left(side)) 
                end 
            end # иначе надо ограичиться только одним шагом в направлении side
            result = true 
        else # isborder(robot, right(side)) => обход препятствия не возможен 
            result = false 
        end 
        move!(robot, left(side), nsteps) 
        # робот перемещен в направленн обратном тому, в котором он обходил или пытался 
        #обойти препятствие 
        return result 
    end
end

nummovetoend!(stop_condition::Function, robot, side) = begin 
    n = 0 
    while !stop_condition() 
        move!(robot, side) 
        n += 1 
    end 
    return n
end