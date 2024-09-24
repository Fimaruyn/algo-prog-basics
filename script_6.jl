# Два периметра
using HorizonSideRobots
#robot = Robot(animate=true)

function printer!(robot)
    while !isborder(robot, Sud) || !isborder(robot, West)
        do_upora(robot, Sud)
        do_upora(robot, West)
    end

    n = num_steps(robot)

 
    for i in (Ost, West) #Nord = 0, Ost = 1, Sud = 2, West = 3

        side = i
        steps = 0
        m = 0

        while steps != (n+1)
            while !isborder(robot, side)

                for i in (Nord, Ost, Sud, West)
                    if isborder(robot, i) == true && ismarker(robot) == false
                        putmarker!(robot)
                        break
                    end            
                end

                move!(robot, side) # Ost -> West
            end

            if m < n
                putmarker!(robot)
                if i == Ost
                    move!(robot, Nord)
                else
                    move!(robot, Sud)
                end
                m += 1
            end

            side = inverse(side)

            steps += 1
        end
    end 
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function num_steps(robot)
    n = 0
    while !isborder(robot, Nord)
        move!(robot, Nord)
        n += 1
    end
    do_upora!(robot, Sud)
    return n
end

function do_upora!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
    end
end

#printer!(robot)