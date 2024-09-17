# Два периметра
using HorizonSideRobots
robot = Robot(animate=true)

function printer!(robot)
    do_upora!(robot, Sud)
    do_upora!(robot, West)

    side = Ost
    for i in 0:2:2
        while !(isborder(robot, HorizonSide(i)) && isborder(robot, HorizonSide(i+1)))
            while !isborder(robot, side)
                for i in (Nord, Ost, Sud, West)
                    if isborder(robot, i) && !ismarker(robot)
                        putmarker!(robot)
                        break
                    end            
                end
                move!(robot, side)
            end
            side = inverse(side)
            move!(robot, Nord)
        end
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end

printer!(robot)