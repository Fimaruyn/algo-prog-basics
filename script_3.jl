# Маркеры по периметру в шахматном порядке

using HorizonSideRobots
robot = Robot(animate=true)

function perim_chess!(robot)
    do_upora!(robot, Sud)
    do_upora!(robot, West)
    for side in (Nord, Ost, Sud, West)
        while !isborder(robot, side)
                move!(robot, side)
                putmarker!(robot) 
        end
    end
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end


perim_chess!(robot)