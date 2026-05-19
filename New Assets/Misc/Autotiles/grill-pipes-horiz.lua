-- setup autotile data

-- if not rained.tiles.isInstalled("Grill Pipe") then return end
-- this doesn't work and i don't know why please help

local autotile = rained.tiles.createAutotile("Horizontal Grill Pipes", "Budc - Pipes")
autotile.type = "rect"

autotile:addToggleOption("lCap", "Left Pipe Cap", true)
autotile:addToggleOption("rCap", "Right Pipe Cap", true)

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {
    "Grill Pipe T",
    "Grill Pipe",
    "Grill Pipe B",
    "Grill Pipe LT",
    "Grill Pipe L",
    "Grill Pipe LB",
    "Grill Pipe RT",
    "Grill Pipe R",
    "Grill Pipe RB"
}

-- this is the callback function that Rained invokes when the user
-- wants to autotile a given rectangle
---@param layer integer The layer to run the autotiler on
---@param left integer The X coordinate of the left side of the rectangle.
---@param top integer The Y coordinate of the top side of the rectangle.
---@param right integer The X coordinate of the right side of the rectangle.
---@param bottom integer The Y coordinate of the bottom side of the rectangle.
---@param forceModifier ForceModifier Force-placement mode, as a string. Can be nil, "force", or "geometry".
function autotile:tileRect(layer, left, top, right, bottom, forceModifier)
    local lCap = autotile:getOption("lCap")
    local rCap = autotile:getOption("rCap")
    local xMin = 2
    if not lCap and not rCap then xMin = 1 end

    -- the minimum size of the box is 2x2, 1x2 with no caps
    if (right - left) + 1 < xMin or (bottom - top) + 1 < 2 then
        rained.alert("The box is too small!")
        return
    end

    -- place grillpipe corners
    if lCap then
        rained.tiles.placeTile("Grill Pipe LT", left, top, layer, forceModifier)
        rained.tiles.placeTile("Grill Pipe LB", left, bottom, layer, forceModifier)
    else
        rained.tiles.placeTile("Grill Pipe T", left, top, layer, forceModifier)
        rained.tiles.placeTile("Grill Pipe B", left, bottom, layer, forceModifier)
    end
    if rCap then
        rained.tiles.placeTile("Grill Pipe RT", right, top, layer, forceModifier)
        rained.tiles.placeTile("Grill Pipe RB", right, bottom, layer, forceModifier)
    else
        rained.tiles.placeTile("Grill Pipe T", right, top, layer, forceModifier)
        rained.tiles.placeTile("Grill Pipe B", right, bottom, layer, forceModifier)
    end

    -- place grillpipe sides
    for x=left+1, right-1 do
        rained.tiles.placeTile("Grill Pipe T", x, top, layer, forceModifier)
        rained.tiles.placeTile("Grill Pipe B", x, bottom, layer, forceModifier)
    end

    for y=top+1, bottom-1 do
        if lCap then rained.tiles.placeTile("Grill Pipe L", left, y, layer, forceModifier) else rained.tiles.placeTile("Grill Pipe", left, y, layer, forceModifier) end
        if rCap then rained.tiles.placeTile("Grill Pipe R", right, y, layer, forceModifier) else rained.tiles.placeTile("Grill Pipe", right, y, layer, forceModifier) end
    end

    -- place grillpipe interiors
    for x=left+1, right-1 do
        for y=top+1, bottom-1 do
            rained.tiles.placeTile("Grill Pipe", x, y, layer, forceModifier)
        end
    end
end

function autotile:verifySize(left, top, right, bottom)
    -- the minimum size of the box is 2x2, 1x2 with no caps
    local lCap = autotile:getOption("lCap")
    local rCap = autotile:getOption("rCap")
    local xMin = 2
    if not lCap and not rCap then xMin = 1 end
    return not ((right - left) + 1 < xMin or (bottom - top) + 1 < 2)
end