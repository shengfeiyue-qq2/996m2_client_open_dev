MiniMap = {}
MiniMap._Colors = { [1] = "#00ff00", [2] = "#ff0000" }

function MiniMap.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "minimap/mini_map")

    local ui      = GUI:ui_delegate(parent)
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setContentSize(ui["CloseLayout"], screenW, screenH)
    GUI:setPosition(ui["Panel_1"], screenW / 2, screenH / 2)

    --关闭
    local function closeLayer()
        SL:CloseMiniMap()
    end
    GUI:addOnClickEvent(ui["CloseLayout"], closeLayer)
    GUI:addOnClickEvent(ui["CloseButton"], closeLayer)

    -- name
    GUI:Text_setString(ui["Text_mapName"], SL:GetMetaValue("MAP_NAME"))
    GUI:Text_setTextColor(ui["Text_mapName"], SL:GetMetaValue("IN_SAFE_AREA") and MiniMap._Colors[1] or MiniMap._Colors[2])
end