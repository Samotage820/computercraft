function refuel(threshold)
    local fuel = turtle.getFuelLevel()
    
    if (fuel <= threshold) then
        print("Refueling...")
        for i = 1, 16 do
            turtle.select(i)
            if turtle.refuel() then
                print("Current fuel: " .. turtle.getFuelLevel())
                turtle.select(1)
                return true
            end
            turtle.select(1)
        end

        return false
    end

    return true
end

function tryForward(n)
    for i = 1, n do
        assert(turtle.forward(), "Could not move forward!")
    end
end

function tryBack(n)
    for i = 1, n do
        assert(turtle.back(), "Could not move back!")
    end
end