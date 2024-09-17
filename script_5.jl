#Заполнить поле в шахматном порядке

using HorizonSideRobots
robot = Robot(animate=true)

function field!(robot)
    do_upora!(robot, Sud)
    do_upora!(robot, West)
    side = Ost
    while !(isborder(robot, Nord) && isborder(robot, Ost))
        markers!(robot, side)
        move!(robot, Nord)
        side = inverse(side)
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function markers!(robot, side)
    while !isborder(robot, side)
        putmarker!(robot)
        move!(robot, side)
        if !isborder(robot, side) move!(robot, side) end
    end
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end

field!(robot)