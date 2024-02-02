-- 查看他人 首饰盒
PlayerBestRing_Look = {}

PlayerBestRing_Look._ui = nil
PlayerBestRing_Look.posSetting = { --装备位
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

PlayerBestRing_Look.RoleType = {
    Other = 11, --查看他人
}
--没装备的时候 是否隐藏默认icon  按装备位
PlayerBestRing_Look._HideDefaultIcon = {
    false,false,false,false,false,false,false,false,false,false,false,false,
}
function PlayerBestRing_Look.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look/player_equip_best_rings_layer_win32")

    PlayerBestRing_Look._ui = GUI:ui_delegate(parent)
    if not PlayerBestRing_Look._ui then
        return false
    end
    PlayerBestRing_Look._parent = parent

    local screeW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(PlayerBestRing_Look._ui.Panel_1, screeW / 2, SL:GetMetaValue("PC_POS_Y"))
    -- 可拖拽
    GUI:Win_SetDrag(parent, PlayerBestRing_Look._ui.Panel_1)
    GUI:Win_SetZPanel(parent, PlayerBestRing_Look._ui.Panel_1)

    GUI:addOnClickEvent(PlayerBestRing_Look._ui.Button_close, function()
        SL:CloseBestRingBoxUI(PlayerBestRing_Look.RoleType.Other)
    end)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerBestRing_Look.CreateEquipItemCallBack(item)
    return item
end


return PlayerBestRing_Look