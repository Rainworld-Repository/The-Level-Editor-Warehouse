-- An easy to use template for making simple 1x1 path type autotiles
-- Configure settings below

local name = "Disc Tubes" -- The name of this autotile
local category = "Budc - Pipes"-- The category for this autotile
local hasJunctions = true -- Does this autotile support junctions
local hasX = false -- Does this autotile support X junctions
local hasCaps = true -- Does this autotile support endcaps

-- Tiles used for vertical and horizontal paths
local vertical="DiscTubeS_V"
local horizontal="DiscTubeS_H"

-- Tiles used for elbows, going clockwise from top left
local lu="DiscTubeS_CurveNW"
local ru="DiscTubeS_CurveNE"
local rd="DiscTubeS_CurveSE"
local ld="DiscTubeS_CurveSW"

-- -OPTIONAL- Tiles used for junctions, going clockwise from top
local tu="DiscTubeS_TJuncS"
local tr="DiscTubeS_TJuncW"
local td="DiscTubeS_TJuncN"
local tl="DiscTubeS_TJuncE"

local x="" -- -OPTIONAL- Tile used for X junctions

-- -OPTIONAL- Tiles used for endcaps, going clockwise from top OF PIPE CONNECTION
local capDown="DiscTubeS_VEndS"
local capLeft="DiscTubeS_HEndW"
local capUp="DiscTubeS_VEndN"
local capRight="DiscTubeS_HEndE"
----------------------------------









-- setup autotile data
local autotile = rained.tiles.createAutotile(name, category)
autotile.type = "path"
autotile.allowIntersections = hasJunctions
if hasJunctions then autotile:addToggleOption("junctions", "Allow Junctions", true) end
if hasCaps then autotile:addToggleOption("cap", "Use End Tiles", false) end

-- change "allowIntersections" property when junctions is turned on/off
if hasJunctions then
    function autotile:onOptionChanged(id)
        if id == "junctions" then
            autotile.allowIntersections = autotile:getOption(id)
        end
    end
end

-- Rained will not allow the user to use this autotile
-- if any of the tiles in this table are not installed
autotile.requiredTiles = {
	vertical,
    horizontal,
    ld,
    lu,
    rd,
    ru,
}

-- table of tiles to use for the standard autotiler function
local tileTable = {
    ld=ld,
    lu=lu,
    rd=rd,
    ru=ru,
    vertical=vertical,
    horizontal=horizontal,
    tr=tr,
    tu=tu,
    tl=tl,
    td=td,
    x=x,
    capRight=capRight,
    capUp=capUp,
    capLeft=capLeft,
    capDown=capDown,

    placeJunctions = hasJunctions,
    placeCaps = false
}
if not hasX then tileTable.x = "nothing" end

-- this is the callback function that Rained invokes when the user
-- wants to autotile a given path
---@param layer integer The layer to run the autotiler on
---@param segments PathSegment[] The list of path segments
---@param forceModifier ForceModifier Force-placement mode, as a string. Can be nil, "force", or "geometry".
function autotile:tilePath(layer, segments, forceModifier)

    if hasJunctions then tileTable.placeJunctions = self:getOption("junctions") else tileTable.placeJunctions = false end
    if hasCaps then tileTable.placeCaps = self:getOption("cap") else tileTable.placeCaps = false end

    -- run the standard autotiler
    rained.tiles.autotilePath(tileTable, layer, segments, forceModifier)

end