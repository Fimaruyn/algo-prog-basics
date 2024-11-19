using HorizonSideRobots
#EX_1: mark_cross(robot, (Nord, Ost, Sud, West))
#EX_4: mark_cross(robot, ((Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord)))

function mark_cross(robot, sides)
    for side in sides 
        n = mark_direct(robot, side)
        s = inverse(side)
        for i in 1:n move!(robot, s) end
    end
end

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
inverse(side::NTuple{2, HorizonSide}) = inverse.(side)


function mark_direct(robot, side)
    n::Int = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        n += 1
    end
    return n
end

HorizonSideRobots.isborder(robor, side::NTuple{2, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])
HorizonSideRobots.move!(robot, side::Any) = for s in side move!(robot, s) end