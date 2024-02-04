MiniMap = {}
MiniMap._Colors = { [1] = "#00ff00", [2] = "#ff0000" }

function MiniMap.main()
    local parent = GUI:Attach_Parent()

    local MapNameBG = GUI:Image_Create(parent, "MapNameBG", 230, 408, "res/private/minimap/1900012107.png")

    local MapName = GUI:Text_Create(parent, "MapName", 330, 420, 16, "#ffffff", "")
    GUI:setAnchorPoint(MapName, {x=0.5, y=0.5})

    -- name
    GUI:Text_setString(MapName, SL:GetMetaValue("MAP_NAME"))
    GUI:Text_setTextColor(MapName, SL:GetMetaValue("IN_SAFE_AREA") and MiniMap._Colors[1] or MiniMap._Colors[2])
end