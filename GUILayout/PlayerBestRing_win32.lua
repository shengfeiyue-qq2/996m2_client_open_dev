-- 角色面板 首饰盒
PlayerBestRing = {}

PlayerBestRing._ui = nil
PlayerBestRing.posSetting = { --装备位
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

PlayerBestRing.RoleType = {
    Self = 1, -- 自己
}

--没装备的时候 是否隐藏默认icon  按装备位
PlayerBestRing._HideDefaultIcon = {
    false,false,false,false,false,false,false,false,false,false,false,false,
}
function PlayerBestRing.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_equip_best_rings_layer_win32")

    PlayerBestRing._ui = GUI:ui_delegate(parent)
    if not PlayerBestRing._ui then
        return false
    end
    PlayerBestRing._parent = parent

    local screeW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(PlayerBestRing._ui.Panel_1, screeW / 2, SL:GetMetaValue("PC_POS_Y"))
    -- 可拖拽
    GUI:Win_SetDrag(parent, PlayerBestRing._ui.Panel_1)
    GUI:Win_SetZPanel(parent, PlayerBestRing._ui.Panel_1)

    GUI:addOnClickEvent(PlayerBestRing._ui.Button_close, function()
        SL:CloseBestRingBoxUI(PlayerBestRing.RoleType.Self)
    end)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerBestRing.CreateEquipItemCallBack(item)
    return item
end


return PlayerBestRing