args = { ... }

if #args ~= 2 then
    print("Usage: stripmine <depth> <tunnels>")
    return
end

depth = tonumber(args[1])
n = tonumber(args[2])
current_depth = 0

function refuel(threshold)
    local fuel = turtle.getFuelLevel()
    
    if (fuel <= threshold) then
        for i = 1, 16 do
            turtle.select(i)
            if turtle.refuel() then
                turtle.select(1)
                return turtle.select(1)
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

function dump()
    turtle.turnLeft()
    turtle.turnLeft()
    tryForward(current_depth - 2)

    turtle.select(16)
    turtle.place()
    for i = 2, 15 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(1)

    turtle.turnLeft()
    turtle.turnLeft()
    tryForward(current_depth - 2)
end

function digOne()
    while not turtle.forward() do
        refuel(depth * 2)
        turtle.dig()
    end
    current_depth = current_depth + 1

    turtle.digUp()
    turtle.digDown()

    if turtle.getItemCount(15) ~= 0 then
        dump()
    end
end

function digStrip()
    for i = 1, depth do
        digOne()
    end
    tryBack(depth)

    turtle.turnRight()

    for i = 1, 3 do
        while not turtle.forward() do
            refuel(depth * 2)
            turtle.dig()
        end

        turtle.digUp()
    end

    turtle.turnLeft()
end

for i = 1, n do
    digStrip()
end