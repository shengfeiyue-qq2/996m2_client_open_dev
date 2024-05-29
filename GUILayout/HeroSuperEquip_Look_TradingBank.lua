HeroSuperEquip_Look_TradingBank = {}----交易行英雄 时装
HeroSuperEquip_Look_TradingBank._ui = nil

function HeroSuperEquip_Look_TradingBank.main(data)
    HeroSuperEquip_Look_TradingBank.posSetting = {
        17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45
    }
    local parent = GUI:Attach_Parent()
    local path = "hero_look_tradingbank/hero_super_equip_node"
    GUI:LoadExport(parent, path)

    HeroSuperEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroSuperEquip_Look_TradingBank._ui then
        return false
    end
    HeroSuperEquip_Look_TradingBank._parent = parent
    HeroSuperEquip_Look_TradingBank._hideNodePos = {}
    local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
    HeroSuperEquip_Look_TradingBank._show_naked_mold = fashionSwitch and tonumber(fashionSwitch) or 0 --是否显示裸模 0开启  1关闭

    HeroSuperEquip_Look_TradingBank.playerSex = SL:GetMetaValue("T.H.SEX") --角色性别
    HeroSuperEquip_Look_TradingBank.playerHairID = SL:GetMetaValue("T.H.HAIR") --发型
    HeroSuperEquip_Look_TradingBank.playerJob = SL:GetMetaValue("T.H.JOB") --职业

    --初始化装备槽
    HeroSuperEquip_Look_TradingBank.InitEquipCells()
    --初始化是否显示时装开关
    HeroSuperEquip_Look_TradingBank.InitEquipSetting()
    return true
end

function HeroSuperEquip_Look_TradingBank.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip = SL:GetMetaValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(HeroSuperEquip_Look_TradingBank.posSetting, 42)
        table.insert(HeroSuperEquip_Look_TradingBank.posSetting, 44)
        local newPosSetting = { 17, 18 }
        for i, pos in ipairs(HeroSuperEquip_Look_TradingBank.posSetting) do
            if not newPosSetting[pos] then
                local equipPanel = HeroSuperEquip_Look_TradingBank._ui["Panel_pos" .. pos]
                GUI:setVisible(equipPanel, false)
            end
        end
        HeroSuperEquip_Look_TradingBank.posSetting = {}
        HeroSuperEquip_Look_TradingBank.posSetting = newPosSetting
        return
    end

    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0--额外的装备位置
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroSuperEquip_Look_TradingBank.posSetting, 42)
        table.insert(HeroSuperEquip_Look_TradingBank.posSetting, 44)
    else
        GUI:setVisible(HeroSuperEquip_Look_TradingBank._ui.Panel_pos44, false)
        GUI:setVisible(HeroSuperEquip_Look_TradingBank._ui.Panel_pos42, false)
    end
end

function HeroSuperEquip_Look_TradingBank.InitEquipSetting()
    GUI:setVisible(HeroSuperEquip_Look_TradingBank._ui.Text_shizhuang, false)
    GUI:setVisible(HeroSuperEquip_Look_TradingBank._ui.CheckBox_shizhuang, false)
end

--[[    创建装备回调
    item 装备
    返回 item
]]
function HeroSuperEquip_Look_TradingBank.CreateEquipItemCallBack(item)
    return item
end
--[[    创建人物模型回调
]]
function HeroSuperEquip_Look_TradingBank.CreateModelCallBack(model)
    return model
end
return HeroSuperEquip_Look_TradingBank