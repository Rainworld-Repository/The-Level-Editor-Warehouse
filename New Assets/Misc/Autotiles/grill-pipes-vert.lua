-- setup autotile data
local autotile = rained.tiles.createAutotile("Vertical Grill Pipes", "Budc - Pipes")
autotile.type = "rect"

autotile:addToggleOption("uCap", "Top Pipe Cap", true)
autotile:addToggleOption("dCap", "Bottom Pipe Cap", true)

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {
    "Vert Grill Pipe L",
    "Vert Grill Pipe",
    "Vert Grill Pipe R",
    "Vert Grill Pipe TL",
    "Vert Grill Pipe T",
    "Vert Grill Pipe TR",
    "Vert Grill Pipe BL",
    "Vert Grill Pipe B",
    "Vert Grill Pipe BR"
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
    local uCap = autotile:getOption("uCap")
    local dCap = autotile:getOption("dCap")
    local yMin = 2
    if not uCap and not dCap then yMin = 1 end

    -- the minimum size of the box is 2x2, 2x1 with no caps
    if (right - left) + 1 < 2 or (bottom - top) + 1 < yMin then
        rained.alert("The box is too small!")
        return
    end

    -- place grillpipe corners
    if uCap then
        rained.tiles.placeTile("Vert Grill Pipe TL", left, top, layer, forceModifier)
        rained.tiles.placeTile("Vert Grill Pipe TR", right, top, layer, forceModifier)
    else
        rained.tiles.placeTile("Vert Grill Pipe L", left, top, layer, forceModifier)
        rained.tiles.placeTile("Vert Grill Pipe R", right, top, layer, forceModifier)
    end
    if dCap then
        rained.tiles.placeTile("Vert Grill Pipe BL", left, bottom, layer, forceModifier)
        rained.tiles.placeTile("Vert Grill Pipe BR", right, bottom, layer, forceModifier)
    else
        rained.tiles.placeTile("Vert Grill Pipe L", left, bottom, layer, forceModifier)
        rained.tiles.placeTile("Vert Grill Pipe R", right, bottom, layer, forceModifier)
    end

    -- place grillpipe sides
    for x=left+1, right-1 do
        if uCap then rained.tiles.placeTile("Vert Grill Pipe T", x, top, layer, forceModifier) else rained.tiles.placeTile("Vert Grill Pipe", x, top, layer, forceModifier) end
        if dCap then rained.tiles.placeTile("Vert Grill Pipe B", x, bottom, layer, forceModifier) else rained.tiles.placeTile("Vert Grill Pipe", x, bottom, layer, forceModifier) end
    end

    for y=top+1, bottom-1 do
        rained.tiles.placeTile("Vert Grill Pipe L", left, y, layer, forceModifier)
        rained.tiles.placeTile("Vert Grill Pipe R", right, y, layer, forceModifier)
    end

    -- place grillpipe interiors
    for x=left+1, right-1 do
        for y=top+1, bottom-1 do
            rained.tiles.placeTile("Vert Grill Pipe", x, y, layer, forceModifier)
        end
    end
end

function autotile:verifySize(left, top, right, bottom)
    -- the minimum size of the box is 2x2, 2x1 with no caps
    local uCap = autotile:getOption("uCap")
    local dCap = autotile:getOption("dCap")
    local yMin = 2
    if not uCap and not dCap then yMin = 1 end
    return not ((right - left) + 1 < 2 or (bottom - top) + 1 < yMin)
end