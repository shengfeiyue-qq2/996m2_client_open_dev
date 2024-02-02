-- 查看他人英雄 首饰盒
HeroBestRing_Look = {}

HeroBestRing_Look._ui = nil
HeroBestRing_Look.posSetting = { --装备位
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

HeroBestRing_Look.RoleType = {
    OtherHero = 12, --查看他人英雄
}
HeroBestRing_Look._HideDefaultIcon = {
    false,false,false,false,false,false,false,false,false,false,false,false,
}
function HeroBestRing_Look.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look/hero_equip_best_rings_layer_win32")

    HeroBestRing_Look._ui = GUI:ui_delegate(parent)
    if not HeroBestRing_Look._ui then
        return false
    end
    HeroBestRing_Look._parent = parent

    local screeW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(HeroBestRing_Look._ui.Panel_1, screeW / 2, SL:GetMetaValue("PC_POS_Y"))
    -- 可拖拽
    GUI:Win_SetDrag(parent, HeroBestRing_Look._ui.Panel_1)
    GUI:Win_SetZPanel(parent, HeroBestRing_Look._ui.Panel_1)

    GUI:addOnClickEvent(HeroBestRing_Look._ui.Button_close, function()
        SL:CloseBestRingBoxUI(HeroBestRing_Look.RoleType.OtherHero)
    end)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function HeroBestRing_Look.CreateEquipItemCallBack(item)
    return item
end


return HeroBestRing_Look