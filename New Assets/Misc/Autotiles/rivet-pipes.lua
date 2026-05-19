-- based on the thinner pipes autotile

-- setup autotile data
local autotile = rained.tiles.createAutotile("Rivet Pipes", "Budc - Pipes")
autotile.type = "path"
autotile.allowIntersections = true
autotile:addToggleOption("junctions", "Allow Junctions", true)
autotile:addToggleOption("cap", "Use End Tiles", false)
autotile:addIntOption("sep", "Separator Spacing (0 to Disable)", 3, 0, 20)

-- change "allowIntersections" property when junctions is turned on/off
function autotile:onOptionChanged(id)
    if id == "junctions" then
        autotile.allowIntersections = autotile:getOption(id)
    end
end

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {
	"Rivet Pipe Plain Vertical",
    "Rivet Pipe Separator Vertical",
    "Rivet Pipe Plain Horizontal",
    "Rivet Pipe Separator Horizontal",
    "Rivet Pipe Corner NW",
    "Rivet Pipe Corner NE",
    "Rivet Pipe Corner SE",
    "Rivet Pipe Corner SW",
    "Rivet Pipe T Junction N",
    "Rivet Pipe T Junction E",
    "Rivet Pipe T Junction S",
    "Rivet Pipe T Junction W",
    "Rivet Pipe Valve Box",
    "Rivet Pipe Separator End N",
    "Rivet Pipe Separator End E",
    "Rivet Pipe Separator End S",
    "Rivet Pipe Separator End W"
}

-- table of tiles to use for the standard autotiler function
local tileTable = {
    ld = "Rivet Pipe Corner SW",
    lu = "Rivet Pipe Corner NW",
    rd = "Rivet Pipe Corner SE",
    ru = "Rivet Pipe Corner NE",
    vertical = "Rivet Pipe Plain Vertical",
    horizontal = "Rivet Pipe Plain Horizontal",
    tr = "Rivet Pipe T Junction W",
    tu = "Rivet Pipe T Junction S",
    tl = "Rivet Pipe T Junction E",
    td = "Rivet Pipe T Junction N",
    x = "Rivet Pipe Valve Box",
    capRight = "Rivet Pipe Separator End E",
    capUp = "Rivet Pipe Separator End N",
    capLeft = "Rivet Pipe Separator End W",
    capDown = "Rivet Pipe Separator End S",

    placeJunctions = true,
    placeCaps = false
}

-- this is the callback function that Rained invokes when the user
-- wants to autotile a given path
---@param layer integer The layer to run the autotiler on
---@param segments PathSegment[] The list of path segments
---@param forceModifier ForceModifier Force-placement mode, as a string. Can be nil, "force", or "geometry".
function autotile:tilePath(layer, segments, forceModifier)

    tileTable.placeJunctions = self:getOption("junctions")
    tileTable.placeCaps = self:getOption("cap")

    -- run the standard autotiler
    rained.tiles.autotilePath(tileTable, layer, segments, forceModifier)

    local i2 = 0
    local seperator = self:getOption("sep") + 1
    for i, seg in ipairs(segments) do
        local tileName = rained.tiles.getTileAt(seg.x, seg.y, layer)
        i2 = i2 + 1
        if i2 >= seperator and seperator ~= 1 then
            if tileName == "Rivet Pipe Plain Vertical" then
                rained.tiles.deleteTile(seg.x, seg.y, layer)
                rained.tiles.placeTile("Rivet Pipe Separator Vertical", seg.x, seg.y, layer, forceModifier)
                i2 = 0
            elseif tileName == "Rivet Pipe Plain Horizontal" then
                rained.tiles.deleteTile(seg.x, seg.y, layer)
                rained.tiles.placeTile("Rivet Pipe Separator Horizontal", seg.x, seg.y, layer, forceModifier)
                i2 = 0
            else
                i2 = i2 - 1
            end
        end
    end
end