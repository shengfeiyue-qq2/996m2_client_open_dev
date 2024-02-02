-- 交易行英雄 首饰盒
HeroBestRing_Look_TradingBank = {}

HeroBestRing_Look_TradingBank._ui = nil
HeroBestRing_Look_TradingBank.posSetting = { --装备位
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

HeroBestRing_Look_TradingBank.RoleType = {
    TradingBankPlayer = 21, --交易行人物
}
HeroBestRing_Look_TradingBank._HideDefaultIcon = {
    false,false,false,false,false,false,false,false,false,false,false,false,
}
function HeroBestRing_Look_TradingBank.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_equip_best_rings_layer")

    HeroBestRing_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroBestRing_Look_TradingBank._ui then
        return false
    end
    HeroBestRing_Look_TradingBank._parent = parent

    local screeW = SL:GetMetaValue("SCREEN_WIDTH")
    local screeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPosition(HeroBestRing_Look_TradingBank._ui.Panel_1, screeW / 2, screeH / 2)
    -- 可拖拽
    GUI:Win_SetDrag(parent, HeroBestRing_Look_TradingBank._ui.Panel_1)
    GUI:Win_SetZPanel(parent, HeroBestRing_Look_TradingBank._ui.Panel_1)

    GUI:addOnClickEvent(HeroBestRing_Look_TradingBank._ui.Button_close, function()
        SL:CloseBestRingBoxUI(HeroBestRing_Look_TradingBank.RoleType.TradingBankPlayer)
    end)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function HeroBestRing_Look_TradingBank.CreateEquipItemCallBack(item)
    return item
end


return HeroBestRing_Look_TradingBank