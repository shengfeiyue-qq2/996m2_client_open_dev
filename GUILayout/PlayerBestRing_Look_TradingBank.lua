-- 交易行人物 首饰盒
PlayerBestRing_Look_TradingBank = {}

PlayerBestRing_Look_TradingBank._ui = nil
PlayerBestRing_Look_TradingBank.posSetting = { --装备位
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

PlayerBestRing_Look_TradingBank.RoleType = {
    TradingBankPlayer = 21, --交易行人物
}
--没装备的时候 是否隐藏默认icon  按装备位
PlayerBestRing_Look_TradingBank._HideDefaultIcon = {
    false,false,false,false,false,false,false,false,false,false,false,false,
}
function PlayerBestRing_Look_TradingBank.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look_tradingbank/player_equip_best_rings_layer")

    PlayerBestRing_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not PlayerBestRing_Look_TradingBank._ui then
        return false
    end
    PlayerBestRing_Look_TradingBank._parent = parent

    local screeW = SL:GetMetaValue("SCREEN_WIDTH")
    local screeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(PlayerBestRing_Look_TradingBank._ui.Panel_1, screeW / 2, screeH / 2)
    -- 可拖拽
    GUI:Win_SetDrag(parent, PlayerBestRing_Look_TradingBank._ui.Panel_1)
    GUI:Win_SetZPanel(parent, PlayerBestRing_Look_TradingBank._ui.Panel_1)

    GUI:addOnClickEvent(PlayerBestRing_Look_TradingBank._ui.Button_close, function()
        SL:CloseBestRingBoxUI(PlayerBestRing_Look_TradingBank.RoleType.TradingBankPlayer)
    end)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerBestRing_Look_TradingBank.CreateEquipItemCallBack(item)
    return item
end


return PlayerBestRing_Look_TradingBank