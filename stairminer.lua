require("turtlelib")

args = { ... }

if #args ~= 1 then
    print("Usage: <depth>")
    return
end

local depth = tonumber(args[1])
local current_depth = 0

function dump()
    turtle.select(16)
    assert(turtle.placeDown(), "Could not place chest!")
    print("Dumping inventory...")
    for i = 2, 15 do
        turtle.select(i)
        turtle.dropDown()
    end
    turtle.select(1)
end

function digOne()
    while not turtle.forward() do
        assert(refuel(depth * 2), "Failed to refuel!")
        turtle.dig()
    end

    turtle.digUp()

    if current_depth % 5 == 0 then
        placeTorch()
    end

    turtle.digDown()
    sleep(1)
    turtle.down()
    turtle.digDown()

    if turtle.getItemCount(14) ~= 0 then
        dump()
    end
end

function placeTorch()
    turtle.select(15)
    turtle.placeUp()
    turtle.select(1)
end

function digStairs(n)
    while current_depth < depth do
        digOne()
        current_depth = current_depth + 1
    end
end

digStairs(depth)