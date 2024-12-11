require("turtlelib")

args = { ... }

if #args ~= 3 or (args[3] ~= "l" and args[3] ~= "r") then
    print("Usage: <depth> <tunnels> [(l)eft|(r)ight]")
    return
end

depth = tonumber(args[1])
n = tonumber(args[2])
current_depth = 0

function dump()
    tryBack(current_depth - 1)

    turtle.select(16)
    assert(turtle.placeDown(), "Could not place chest!")
    print("Dumping inventory...")
    for i = 2, 15 do
        turtle.select(i)
        turtle.dropDown()
    end
    turtle.select(1)

    tryForward(current_depth - 1)
end

function digOne()
    while not turtle.forward() do
        assert(refuel(depth * 2), "Failed to refuel!")
        turtle.dig()
    end
    current_depth = current_depth + 1

    turtle.digUp()
    turtle.digDown()

    if turtle.getItemCount(15) ~= 0 then
        dump()
    end
end

function digConnector()
    for i = 1, 3 do
        while not turtle.forward() do
            assert(refuel(depth * 2), "Failed to refuel!")
            turtle.dig()
        end

        turtle.digUp()
        turtle.digDown()
    end
end

function digStripLeft()
    for i = 1, depth do
        digOne()
    end

    turtle.turnLeft()
    digConnector()
    tryBack(3)
    turtle.turnRight()

    tryBack(depth)

    turtle.turnLeft()
    digConnector()
    turtle.turnRight()
end

function digStripRight()
    for i = 1, depth do
        digOne()
    end

    turtle.turnRight()
    digConnector()
    tryBack(3)
    turtle.turnLeft()

    tryBack(depth)

    turtle.turnRight()
    digConnector()
    turtle.turnLeft()
end

function stripmine()
    dir = args[3]

    turtle.digUp()
    turtle.digDown()

    if dir == "l" then
        for i = 1, n do
            digStripLeft()
        end
    elseif dir == "r" then
        for i = 1, n do
            digStripRight()
        end
    end

    print("Mined " .. n " tunnels to depth " .. depth .. "." )
end

stripmine()