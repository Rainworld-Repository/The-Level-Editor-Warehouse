-- setup autotile data
local autotile = rained.tiles.createAutotile("Color2 window")
autotile.type = "rect"

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {
    "color2 window segment WN",
    "color2 window segment N",
    "color2 window segment EN",
    "color2 window segment W",
    "color2 window segment E",
    "color2 window segment WS",
    "color2 window segment S",
    "color2 window segment ES",
    "color2 window segment Centre"
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
    -- the minimum size of the box is 4x4
    if (right - left) + 1 < 2 or (bottom - top) + 1 < 2 then
        rained.alert("The box is too small!")
        return
    end

    -- place ventbox corners
    rained.tiles.placeTile("color2 window segment WN", left, top, layer, forceModifier)
    rained.tiles.placeTile("color2 window segment EN", right, top, layer, forceModifier)
    rained.tiles.placeTile("color2 window segment WS", left, bottom, layer, forceModifier)
    rained.tiles.placeTile("color2 window segment ES", right, bottom, layer, forceModifier)

    -- place ventbox sides
    for x=left+1, right-1 do
        rained.tiles.placeTile("color2 window segment N", x, top, layer, forceModifier)
        rained.tiles.placeTile("color2 window segment S", x, bottom, layer, forceModifier)
    end

    for y=top+1, bottom-1 do
        rained.tiles.placeTile("color2 window segment W", left, y, layer, forceModifier)
        rained.tiles.placeTile("color2 window segment E", right, y, layer, forceModifier)
    end

    -- place ventbox interiors
    for x=left, right do
        for y=top+1, bottom-1 do
            rained.tiles.placeTile("color2 window segment Centre", x, y, layer, forceModifier)
        end
    end
end

function autotile:verifySize(left, top, right, bottom)
    -- the minimum size of the box is 4x4
    return not ((right - left) + 1 < 2 or (bottom - top) + 1 < 2)
end