-- setup autotile data
local autotile = rained.tiles.createAutotile("Thinner Pipes", "Pipes")
autotile.type = "path"
autotile.allowIntersections = true
autotile:addToggleOption("junctions", "Allow Junctions", true)
autotile:addIntOption("altChance", "Alt Chance", 2, 1, 20)

-- change "allowIntersections" property when junctions is turned on/off
function autotile:onOptionChanged(id)
    if id == "junctions" then
        autotile.allowIntersections = autotile:getOption(id)
    end
end

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {
	"Vertical Thinner Pipes",
	"Horizontal Thinner Pipes",
	"Thinner Pipes ES",
	"Thinner Pipes WS",
	"Thinner Pipes WN",
	"Thinner Pipes EN",
	"Thinner Pipes T-Junct N",
	"Thinner Pipes T-Junct E",
	"Thinner Pipes T-Junct S",
	"Thinner Pipes T-Junct W",
	"Thinner Pipes X-Junct A",
	"Thinner Pipes X-Junct B",
	"Thinner Pipes X-Junct C",
}

-- table of tiles to use for the standard autotiler function
local tileTable = {
    ld = "Thinner Pipes WS",
    lu = "Thinner Pipes WN",
    rd = "Thinner Pipes ES",
    ru = "Thinner Pipes EN",
    vertical = "Vertical Thinner Pipes",
    horizontal = "Horizontal Thinner Pipes",
    tr = "Thinner Pipes T-Junct E",
    tu = "Thinner Pipes T-Junct N",
    tl = "Thinner Pipes T-Junct W",
    td = "Thinner Pipes T-Junct S",
    x = "Thinner Pipes X-Junct A",

    placeJunctions = false,
    placeCaps = false
}

-- this is the callback function that Rained invokes when the user
-- wants to autotile a given path
---@param layer integer The layer to run the autotiler on
---@param segments PathSegment[] The list of path segments
---@param forceModifier ForceModifier Force-placement mode, as a string. Can be nil, "force", or "geometry".
function autotile:tilePath(layer, segments, forceModifier)

    tileTable.placeJunctions = self:getOption("junctions")

    -- run the standard autotiler
    rained.tiles.autotilePath(tileTable, layer, segments, forceModifier)

    -- replace random X-Junctions with B or C variant
    local altChance = autotile:getOption("altChance")
    for i, seg in ipairs(segments) do
        local tileName = rained.tiles.getTileAt(seg.x, seg.y, layer)

        if (tileName == "Thinner Pipes X-Junct A" and math.random(altChance)) == 1 then
            rained.tiles.deleteTile(seg.x, seg.y, layer)
			if math.random(0, 1) == 0 then
				rained.tiles.placeTile("Thinner Pipes X-Junct B", seg.x, seg.y, layer, forceModifier)
			else
				rained.tiles.placeTile("Thinner Pipes X-Junct C", seg.x, seg.y, layer, forceModifier)
            end
        end
	end
end