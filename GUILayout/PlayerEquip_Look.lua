PlayerEquip_Look = {}----查看他人面板 装备
PlayerEquip_Look._ui = nil 
-- 13 斗笠位置比较特殊 属于和头盔位置同部位
-- 要斗笠和头盔分开 需要设置Panel_pos13为显示 
PlayerEquip_Look.showModelCapAndHelmet = false -- 斗笠和头盔分开情况下  模型是否显示 斗笠头盔

PlayerEquip_Look.posSetting = {}
PlayerEquip_Look._hideNodePos = {}
PlayerEquip_Look.RoleType = {
    Other = 11 --他人
}
-- 剑甲分离出格子 需要对应相应装备位置
PlayerEquip_Look.realUIPos = {
    [GUIDefine.EquipPosUI.Equip_Type_Dress] = 1000, 
    [GUIDefine.EquipPosUI.Equip_Type_Weapon] = 1001,
}

PlayerEquip_Look.fictionalUIPos = {
    [1000] = GUIDefine.EquipPosUI.Equip_Type_Dress,
    [1001] = GUIDefine.EquipPosUI.Equip_Type_Weapon, 
}
function PlayerEquip_Look.main(data)
    PlayerEquip_Look.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, --1000, 1001 如有分离装备 需要添加
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look/player_equip_node")

    PlayerEquip_Look._ui = GUI:ui_delegate(parent)
    if not PlayerEquip_Look._ui then
        return false
    end
    PlayerEquip_Look._parent = parent

    --初始化装备槽
    PlayerEquip_Look.InitEquipCells()

    -- 角色性别
    PlayerEquip_Look.playerSex = SL:GetMetaValue("L.M.SEX")
    -- 发型
    PlayerEquip_Look.playerHairID = SL:GetMetaValue("L.M.HAIR")
    -- 职业
    PlayerEquip_Look.playerJob = SL:GetMetaValue("L.M.JOB")
    -------首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 --首饰盒功能是否开启
    GUI:setVisible(PlayerEquip_Look._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    PlayerEquip_Look._ui.Best_ringBox, function()
        --首饰盒是否开启
        local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look.RoleType.Other)
        if activeState then
            SL:OpenBestRingBoxUI(PlayerEquip_Look.RoleType.Other, { param = {} })
        else
            --提示
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(PlayerEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end
    )
    --刷新首饰盒状态
    PlayerEquip_Look.RefreshPlayerBestRingsOpenState()
    PlayerEquip_Look.RefreshBestRingBox()
    ----------------------
    --刷新行会信息
    PlayerEquip_Look.RefreshGuildInfo()
    ----------------------
    PlayerEquip_Look.RegisterEvent()
end

function PlayerEquip_Look.InitHideNodePos()
    PlayerEquip_Look._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if PlayerEquip_Look._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(PlayerEquip_Look._ui[string.format("Node_%s", i)])
            if not visible then
                PlayerEquip_Look._hideNodePos[i] = true
            end
        end
    end
end

function PlayerEquip_Look.InitEquipCells()
    local uid = SL:GetMetaValue("LOOK_USER_ID")

    --请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    --额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerEquip_Look.posSetting, 14)
        table.insert(PlayerEquip_Look.posSetting, 15)
    else
        GUI:setVisible(PlayerEquip_Look._ui.Panel_pos14, false)
        GUI:setVisible(PlayerEquip_Look._ui.Panel_pos15, false)
        GUI:setVisible(PlayerEquip_Look._ui.Node_14, false)
        GUI:setVisible(PlayerEquip_Look._ui.Node_15, false)
    end

    -- 剑甲分离配置
    if SL:GetMetaValue("GAME_DATA", "DivideWeaponAndClothes") == 1 then 
        GUI:setVisible(PlayerEquip_Look._ui.Panel_pos1000, true)
        GUI:setVisible(PlayerEquip_Look._ui.Panel_pos1001, true)
        GUI:setVisible(PlayerEquip_Look._ui.Node_1000, true)
        GUI:setVisible(PlayerEquip_Look._ui.Node_1001, true)
        table.insert(PlayerEquip_Look.posSetting, 1000)
        table.insert(PlayerEquip_Look.posSetting, 1001)
    end 
end

function PlayerEquip_Look.RefreshGuildInfo()
    local textGuildInfo = PlayerEquip_Look._ui.Text_guildinfo
    local guildData = SL:GetMetaValue("L.M.GUILD_INFO") --行会数据
    local myGuildName = guildData.guildName
    local myJobName = guildData.rankName
    if not myGuildName then
        return
    end
    myJobName = myJobName or ""

    local guildInfo = myGuildName .. " " .. myJobName
    GUI:Text_setString(textGuildInfo, guildInfo)

    local color = SL:GetMetaValue("LOOK_USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(textGuildInfo, SL:GetHexColorByStyleId(color))
    end
end

function PlayerEquip_Look.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look.RoleType.Other)
    if activeState then
        GUI:Image_setGrey(PlayerEquip_Look._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip_Look._ui.Image_box, true)
    end

    if data and data.isOpen then
        if not activeState then
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(PlayerEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1)) --提示
        end
    end
end

function PlayerEquip_Look.RefreshBestRingBox()
    SL:scheduleOnce(
    PlayerEquip_Look._ui.Best_ringBox,
    function()
        local texture = "btn_jewelry_1_1.png"
        if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", PlayerEquip_Look.RoleType.Other) then --首饰盒界面是否打开
            texture = "btn_jewelry_1_0.png"
        end
        GUI:Image_loadTexture(PlayerEquip_Look._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
        GUI:setIgnoreContentAdaptWithSize(PlayerEquip_Look._ui.Image_box, true) --重置尺寸
        PlayerEquip_Look.RefreshPlayerBestRingsOpenState()
    end,
    0.1
    )
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerEquip_Look.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function PlayerEquip_Look.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function PlayerEquip_Look.CloseCallback()
    PlayerEquip_Look.UnRegisterEvent()
end

function PlayerEquip_Look.RegisterEvent()
end

function PlayerEquip_Look.UnRegisterEvent()
end