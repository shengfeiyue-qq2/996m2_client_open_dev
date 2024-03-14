HeroSuperEquip = {} --英雄面板 时装
HeroSuperEquip._ui = nil

function HeroSuperEquip.main(data)
    HeroSuperEquip.posSetting = {
        17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45
    }
    local parent = GUI:Attach_Parent()
    local path = "hero/hero_super_equip_node_win32"
    GUI:LoadExport(parent, path)

    HeroSuperEquip._ui = GUI:ui_delegate(parent)
    if not HeroSuperEquip._ui then
        return false
    end
    HeroSuperEquip._parent = parent
    HeroSuperEquip._hideNodePos = {}
    local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
    HeroSuperEquip._show_naked_mold = fashionSwitch and tonumber(fashionSwitch) or 0 --是否显示裸模 0开启  1关闭

    HeroSuperEquip.playerSex =  SL:GetMetaValue("H.SEX") --英雄性别
    HeroSuperEquip.playerHairID = SL:GetMetaValue("H.HAIR")  --发型
    HeroSuperEquip.playerJob =  SL:GetMetaValue("H.JOB")  --职业

    --初始化装备槽
    HeroSuperEquip.InitEquipCells()
    --初始化是否显示时装开关
    HeroSuperEquip.InitEquipSetting()
    return true
end

function HeroSuperEquip.InitHideNodePos()
    HeroSuperEquip._hideNodePos = {}
    for _, i in ipairs(HeroSuperEquip.posSetting) do
        if i ~= 17 and  i ~= 18 and i ~= 45 and i ~= 21 then
            if HeroSuperEquip._ui[string.format("Node_%s", i)] then
                local visible = GUI:getVisible(HeroSuperEquip._ui[string.format("Node_%s", i)])
                if not visible then
                    HeroSuperEquip._hideNodePos[i] = true
                end
            end
        end
    end
end

function HeroSuperEquip.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetMetaValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(HeroSuperEquip.posSetting, 42)
        table.insert(HeroSuperEquip.posSetting, 44)
        local newPosSetting = { 17, 18 }
        for i, pos in ipairs(HeroSuperEquip.posSetting) do
            if not newPosSetting[pos] then
                local equipPanel = HeroSuperEquip._ui["Panel_pos" .. pos]
                GUI:setVisible(equipPanel,false)
            end
        end
        HeroSuperEquip.posSetting = {}
        HeroSuperEquip.posSetting = newPosSetting
        return
    end

    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0--额外的装备位置
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroSuperEquip.posSetting, 42)
        table.insert(HeroSuperEquip.posSetting, 44)
    else
        GUI:setVisible(HeroSuperEquip._ui.Panel_pos44,false)
        GUI:setVisible(HeroSuperEquip._ui.Panel_pos42,false)
    end
end

function HeroSuperEquip.InitEquipSetting()
    GUI:setVisible(HeroSuperEquip._ui.Text_shizhuang,true)
    GUI:setVisible(HeroSuperEquip._ui.CheckBox_shizhuang,true)

    GUI:CheckBox_addOnEvent(HeroSuperEquip._ui.CheckBox_shizhuang,function()
        SL:SetMetaValue("HERO_SUPEREQUIP_SHOW",GUI:CheckBox_isSelected(HeroSuperEquip._ui.CheckBox_shizhuang))
        SL:SendSuperEquipSetting_Hero(1)--通知服务器 时装显示开关  2 --设置显示神魔 1 --设置时装显示
    end)
    HeroSuperEquip.UpdateSettingShow()
end

function HeroSuperEquip.UpdateSettingShow()
    local showSetting = SL:GetMetaValue("HERO_SUPEREQUIP_SHOW")
    GUI:CheckBox_setSelected(HeroSuperEquip._ui.CheckBox_shizhuang,showSetting)
end

--[[
    创建装备回调
    item 装备
    返回 item
]]
function HeroSuperEquip.CreateEquipItemCallBack(item)
    return item
end
--[[
    创建人物模型回调
]]
function HeroSuperEquip.CreateModelCallBack(model)
    return model
end
return HeroSuperEquip