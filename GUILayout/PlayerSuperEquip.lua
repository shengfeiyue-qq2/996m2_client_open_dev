PlayerSuperEquip = {}----角色面板 时装
PlayerSuperEquip._ui = nil

-- 头盔和斗笠分离出格子 需要对应相应装备位置
PlayerSuperEquip.realUIPos = {
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Dress] = 1017, 
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Weapon] = 1018, 
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Cap] = 1019, 
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Helmet] = 1021,
}
PlayerSuperEquip.fictionalUIPos = {
    -- [1017] = GUIDefine.EquipPosUI.Equip_Type_Super_Dress,
    -- [1018] = GUIDefine.EquipPosUI.Equip_Type_Super_Weapon,
    -- [1019] = GUIDefine.EquipPosUI.Equip_Type_Super_Cap,
    -- [1021] = GUIDefine.EquipPosUI.Equip_Type_Super_Helmet, 
}

function PlayerSuperEquip.main(data)
    -- 如果有分离装备 需添加
    PlayerSuperEquip.posSetting = {
        17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45 --, 1017, 1018, 1019, 1021
    }
    local parent = GUI:Attach_Parent()
    local path = "player/player_super_equip_node"
    GUI:LoadExport(parent, path)

    PlayerSuperEquip._ui = GUI:ui_delegate(parent)
    if not PlayerSuperEquip._ui then
        return false
    end
    PlayerSuperEquip._parent = parent
    PlayerSuperEquip._hideNodePos = {}
    local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
    PlayerSuperEquip._show_naked_mold = fashionSwitch and tonumber(fashionSwitch) or 0 --是否显示裸模 0开启  1关闭

    PlayerSuperEquip.playerSex =  SL:GetMetaValue("SEX") --角色性别
    PlayerSuperEquip.playerHairID = SL:GetMetaValue("HAIR")  --发型
    PlayerSuperEquip.playerJob =  SL:GetMetaValue("JOB")  --职业

    --初始化装备槽
    PlayerSuperEquip.InitEquipCells()
    --初始化是否显示时装开关
    PlayerSuperEquip.InitEquipSetting()
    return true
end

function PlayerSuperEquip.InitHideNodePos()
    PlayerSuperEquip._hideNodePos = {}
    for _, i in ipairs(PlayerSuperEquip.posSetting) do
        if i ~= 17 and  i ~= 18 and i ~= 45 and i ~= 21 then
            if PlayerSuperEquip._ui[string.format("Node_%s", i)] then
                local visible = GUI:getVisible(PlayerSuperEquip._ui[string.format("Node_%s", i)])
                if not visible then
                    PlayerSuperEquip._hideNodePos[i] = true
                end
            end
        end
    end
end

function PlayerSuperEquip.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip =  SL:GetMetaValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP) 
    if openFEquip and openFEquip == 0 then
        table.insert(PlayerSuperEquip.posSetting, 42)
        table.insert(PlayerSuperEquip.posSetting, 44)
        local newPosSetting = { 17, 18 }
        for i, pos in ipairs(PlayerSuperEquip.posSetting) do
            if not newPosSetting[pos] then
                local equipPanel = PlayerSuperEquip._ui["Panel_pos" .. pos]
                if equipPanel then 
                    GUI:setVisible(equipPanel, false)
                end 
            end
        end
        PlayerSuperEquip.posSetting = {}
        PlayerSuperEquip.posSetting = newPosSetting
        return
    end

    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0--额外的装备位置 1是6格 0是4格
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerSuperEquip.posSetting, 42)
        table.insert(PlayerSuperEquip.posSetting, 44)
    else
        GUI:setVisible(PlayerSuperEquip._ui.Panel_pos44,false)
        GUI:setVisible(PlayerSuperEquip._ui.Panel_pos42,false)
    end

    -- 剑甲分离配置
    -- if SL:GetMetaValue("GAME_DATA", "DivideWeaponAndClothes") == 1 then 
    --     GUI:setVisible(PlayerSuperEquip._ui.Panel_pos1017, true)
    --     GUI:setVisible(PlayerSuperEquip._ui.Panel_pos1018, true)
    --     GUI:setVisible(PlayerSuperEquip._ui.Node_1017, true)
    --     GUI:setVisible(PlayerSuperEquip._ui.Node_1018, true)
    --     table.insert(PlayerSuperEquip.posSetting, 1017)
    --     table.insert(PlayerSuperEquip.posSetting, 1018)
    -- end 
end

function PlayerSuperEquip.InitEquipSetting()
    GUI:setVisible(PlayerSuperEquip._ui.Text_shizhuang,true)
    GUI:setVisible(PlayerSuperEquip._ui.CheckBox_shizhuang,true)

    GUI:CheckBox_addOnEvent(PlayerSuperEquip._ui.CheckBox_shizhuang,function()
        SL:SetMetaValue("SUPEREQUIP_SHOW",GUI:CheckBox_isSelected(PlayerSuperEquip._ui.CheckBox_shizhuang))
        SL:SendSuperEquipSetting(1)--通知服务器 时装显示开关  2 --设置显示神魔 1 --设置时装显示
    end)
    PlayerSuperEquip.UpdateSettingShow()
end

function PlayerSuperEquip.UpdateSettingShow()
    local showSetting = SL:GetMetaValue("SUPEREQUIP_SHOW")
    GUI:CheckBox_setSelected(PlayerSuperEquip._ui.CheckBox_shizhuang,showSetting)
end

--[[
    创建装备回调
    item 装备
    返回 item
]]
function PlayerSuperEquip.CreateEquipItemCallBack(item)
    return item
end
--[[
    创建人物模型回调
]]
function PlayerSuperEquip.CreateModelCallBack(model)
    return model
end
return PlayerSuperEquip