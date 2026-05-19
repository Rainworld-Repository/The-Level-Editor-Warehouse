-- An easy to use template for making simple box type autotiles
-- Configure settings below

local name = "Box Template" -- The name of this autotile
local category = "Misc"-- The category for this autotile
local sideSize = 2 -- Size of the tiles used for sides and corners of this autotile

-- Tiles used for corners, going clockwise from top left
local topLeft = "Ventbox NW"
local topRight = "Ventbox NE"
local bottomRight = "Ventbox SE"
local bottomLeft = "Ventbox SW"

-- Tiles used for sides, going clockwise from top
local topTile = "Ventbox N"
local rightTile = "Ventbox E"
local bottomTile = "Ventbox S"
local leftTile = "Ventbox W"

local inner = "Ventbox" -- Tile used for the inside of the box
----------------------------------









-- setup autotile data
local autotile = rained.tiles.createAutotile(name, category)
autotile.type = "rect"

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {topLeft, topRight, bottomRight, bottomLeft, topTile, rightTile, bottomTile, leftTile, inner}

-- this is the callback function that Rained invokes when the user
-- wants to autotile a given rectangle
---@param layer integer The layer to run the autotiler on
---@param left integer The X coordinate of the left side of the rectangle.
---@param top integer The Y coordinate of the top side of the rectangle.
---@param right integer The X coordinate of the right side of the rectangle.
---@param bottom integer The Y coordinate of the bottom side of the rectangle.
---@param forceModifier ForceModifier Force-placement mode, as a string. Can be nil, "force", or "geometry".
function autotile:tileRect(layer, left, top, right, bottom, forceModifier)
    local offset = sideSize-1
    -- the minimum size of the box is 4x4
    if (right - left) + 1 < sideSize*2 or (bottom - top) + 1 < sideSize*2 then
        rained.alert("The box is too small!")
        return
    end

    -- place ventbox corners
    rained.tiles.placeTile(topLeft, left, top, layer, forceModifier)
    rained.tiles.placeTile(topRight, right-offset, top, layer, forceModifier)
    rained.tiles.placeTile(bottomLeft, left, bottom-offset, layer, forceModifier)
    rained.tiles.placeTile(bottomRight, right-offset, bottom-offset, layer, forceModifier)

    -- place ventbox sides
    for x=left+sideSize, right-sideSize do
        rained.tiles.placeTile(topTile, x, top, layer, forceModifier)
        rained.tiles.placeTile(bottomTile, x, bottom-offset, layer, forceModifier)
    end

    for y=top+sideSize, bottom-sideSize do
        rained.tiles.placeTile(leftTile, left, y, layer, forceModifier)
        rained.tiles.placeTile(rightTile, right-offset, y, layer, forceModifier)
    end

    -- place ventbox interiors
    for x=left+sideSize, right-sideSize do
        for y=top+sideSize, bottom-sideSize do
            rained.tiles.placeTile(inner, x, y, layer, forceModifier)
        end
    end
end

function autotile:verifySize(left, top, right, bottom)
    -- the minimum size of the box is 4x4
    return not ((right - left) + 1 < sideSize*2 or (bottom - top) + 1 < sideSize*2)
end