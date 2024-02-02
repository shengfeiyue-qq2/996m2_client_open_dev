-- 英雄面板 首饰盒
HeroBestRing = {}

HeroBestRing._ui = nil
HeroBestRing.posSetting = { --装备位
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
}

HeroBestRing.RoleType = {
    Hero = 2, -- 英雄
}
HeroBestRing._HideDefaultIcon = {
    false,false,false,false,false,false,false,false,false,false,false,false,
}
function HeroBestRing.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_equip_best_rings_layer_win32")

    HeroBestRing._ui = GUI:ui_delegate(parent)
    if not HeroBestRing._ui then
        return false
    end
    HeroBestRing._parent = parent

    local screeW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(HeroBestRing._ui.Panel_1, screeW / 2, SL:GetMetaValue("PC_POS_Y"))
    -- 可拖拽
    GUI:Win_SetDrag(parent, HeroBestRing._ui.Panel_1)
    GUI:Win_SetZPanel(parent, HeroBestRing._ui.Panel_1)

    GUI:addOnClickEvent(HeroBestRing._ui.Button_close, function()
        SL:CloseBestRingBoxUI(HeroBestRing.RoleType.Hero)
    end)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function HeroBestRing.CreateEquipItemCallBack(item)
    return item
end


return HeroBestRing