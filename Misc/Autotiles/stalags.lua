-- setup autotile data
local autotile = rained.tiles.createAutotile("Stalagmites")
autotile.type = "rect"

function checkAndSetMaterial(x, y, layer)
    if rained.cells.getGeo(x, y, layer) == 1 then
        local allSurroundingAreOne = true
        for dx = -1, 1 do
            for dy = -1, 1 do
                if not (dx == 0 and dy == 0) and rained.cells.getGeo(x + dx, y + dy, layer) ~= 1 then
                    allSurroundingAreOne = false
                    break
                end
            end
            if not allSurroundingAreOne then break end
        end

        if allSurroundingAreOne then
            rained.cells.setMaterial(x, y, layer, "Rough Rock")
        else
            rained.cells.setMaterial(x, y, layer, "Dirt")
        end
    end
end

-- this is the callback function that Rained invokes when the user
-- wants to autotile a given rectangle
---@param layer integer The layer to run the autotiler on
---@param left integer The X coordinate of the left side of the rectangle.
---@param top integer The Y coordinate of the top side of the rectangle.
---@param right integer The X coordinate of the right side of the rectangle.
---@param bottom integer The Y coordinate of the bottom side of the rectangle.
---@param forceModifier ForceModifier Force-placement mode, as a string. Can be nil, "force", or "geometry".
function autotile:tileRect(layer, left, top, right, bottom, forceModifier)
    for x=left, right do
        for y=top, bottom do
            checkAndSetMaterial(x, y, layer)
        end
    end
end