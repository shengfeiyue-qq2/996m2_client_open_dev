PlayerSuperEquip_Look_TradingBank = {}----交易行人物 时装
PlayerSuperEquip_Look_TradingBank._ui = nil
-- 头盔和斗笠分离出格子 需要对应相应装备位置
PlayerSuperEquip_Look_TradingBank.realUIPos = {
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Dress] = 1017, 
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Weapon] = 1018, 
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Cap] = 1019, 
    -- [GUIDefine.EquipPosUI.Equip_Type_Super_Helmet] = 1021,
}
PlayerSuperEquip_Look_TradingBank.fictionalUIPos = {
    -- [1017] = GUIDefine.EquipPosUI.Equip_Type_Super_Dress,
    -- [1018] = GUIDefine.EquipPosUI.Equip_Type_Super_Weapon,
    -- [1019] = GUIDefine.EquipPosUI.Equip_Type_Super_Cap,
    -- [1021] = GUIDefine.EquipPosUI.Equip_Type_Super_Helmet, 
}
function PlayerSuperEquip_Look_TradingBank.main(data)
    PlayerSuperEquip_Look_TradingBank.posSetting = {
        17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 43, 45--, 1017, 1018, 1019, 1021
    }
    local parent = GUI:Attach_Parent()
    local path = "player_look_tradingbank/player_super_equip_node"
    GUI:LoadExport(parent, path)

    PlayerSuperEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not PlayerSuperEquip_Look_TradingBank._ui then
        return false
    end
    PlayerSuperEquip_Look_TradingBank._parent = parent
    PlayerSuperEquip_Look_TradingBank._hideNodePos = {}
    local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
    PlayerSuperEquip_Look_TradingBank._show_naked_mold = fashionSwitch and tonumber(fashionSwitch) or 0 --是否显示裸模 0开启  1关闭

    PlayerSuperEquip_Look_TradingBank.playerSex = SL:GetMetaValue("T.M.SEX") --角色性别
    PlayerSuperEquip_Look_TradingBank.playerHairID = SL:GetMetaValue("T.M.HAIR") --发型
    PlayerSuperEquip_Look_TradingBank.playerJob = SL:GetMetaValue("T.M.JOB") --职业

    --初始化装备槽
    PlayerSuperEquip_Look_TradingBank.InitEquipCells()
    --初始化是否显示时装开关
    PlayerSuperEquip_Look_TradingBank.InitEquipSetting()
    return true
end

function PlayerSuperEquip_Look_TradingBank.InitEquipCells()
    -- 服务器开关 时装是否开启首饰
    local openFEquip = SL:GetMetaValue("SERVER_OPTION", SW_KEY_OPEN_F_EQUIP)
    if openFEquip and openFEquip == 0 then
        table.insert(PlayerSuperEquip_Look_TradingBank.posSetting, 42)
        table.insert(PlayerSuperEquip_Look_TradingBank.posSetting, 44)
        local newPosSetting = { 17, 18 }
        for i, pos in ipairs(PlayerSuperEquip_Look_TradingBank.posSetting) do
            if not newPosSetting[pos] then
                local equipPanel = PlayerSuperEquip_Look_TradingBank._ui["Panel_pos" .. pos]
                GUI:setVisible(equipPanel, false)
            end
        end
        PlayerSuperEquip_Look_TradingBank.posSetting = {}
        PlayerSuperEquip_Look_TradingBank.posSetting = newPosSetting
        return
    end

    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0--额外的装备位置
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerSuperEquip_Look_TradingBank.posSetting, 42)
        table.insert(PlayerSuperEquip_Look_TradingBank.posSetting, 44)
    else
        GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Panel_pos44, false)
        GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Panel_pos42, false)
    end

    -- 剑甲分离配置
    -- if SL:GetMetaValue("GAME_DATA", "DivideWeaponAndClothes") == 1 then 
    --     GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Panel_pos1017, true)
    --     GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Panel_pos1018, true)
    --     GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Node_1017, true)
    --     GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Node_1018, true)
    --     table.insert(PlayerSuperEquip_Look_TradingBank.posSetting, 1017)
    --     table.insert(PlayerSuperEquip_Look_TradingBank.posSetting, 1018)
    -- end 
end

function PlayerSuperEquip_Look_TradingBank.InitEquipSetting()
    GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.Text_shizhuang, false)
    GUI:setVisible(PlayerSuperEquip_Look_TradingBank._ui.CheckBox_shizhuang, false)
end

--[[    创建装备回调
    item 装备
    返回 item
]]
function PlayerSuperEquip_Look_TradingBank.CreateEquipItemCallBack(item)
    return item
end
--[[    创建人物模型回调
]]
function PlayerSuperEquip_Look_TradingBank.CreateModelCallBack(model)
    return model
end
return PlayerSuperEquip_Look_TradingBank