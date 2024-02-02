PlayerEquip_Look_TradingBank = {}----交易行人物 装备
PlayerEquip_Look_TradingBank._ui = nil 
-- 13 斗笠位置比较特殊 属于和头盔位置同部位
-- 要斗笠和头盔分开 需要设置Panel_pos13为显示 
PlayerEquip_Look_TradingBank.showModelCapAndHelmet = false -- 斗笠和头盔分开情况下  模型是否显示 斗笠头盔
PlayerEquip_Look_TradingBank._hideNodePos = {}
PlayerEquip_Look_TradingBank.RoleType = {
    TradingBankPlayer = 21, --交易行人物
}
-- 剑甲分离出格子 需要对应相应装备位置
PlayerEquip_Look_TradingBank.realUIPos = {
    [GUIDefine.EquipPosUI.Equip_Type_Dress] = 1000, 
    [GUIDefine.EquipPosUI.Equip_Type_Weapon] = 1001,
}

PlayerEquip_Look_TradingBank.fictionalUIPos = {
    [1000] = GUIDefine.EquipPosUI.Equip_Type_Dress,
    [1001] = GUIDefine.EquipPosUI.Equip_Type_Weapon, 
}
function PlayerEquip_Look_TradingBank.main(data)
    PlayerEquip_Look_TradingBank.posSetting = {-- 13 斗笠位置比较特殊 属于和头盔位置同部位
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16--1000, 1001 如有分离装备 需要添加
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look_tradingbank/player_equip_node")

    PlayerEquip_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not PlayerEquip_Look_TradingBank._ui then
        return false
    end
    PlayerEquip_Look_TradingBank._parent = parent

    --初始化装备槽
    PlayerEquip_Look_TradingBank.InitEquipCells()

    -- 角色性别
    PlayerEquip_Look_TradingBank.playerSex = SL:GetMetaValue("T.M.SEX")
    -- 发型
    PlayerEquip_Look_TradingBank.playerHairID = SL:GetMetaValue("T.M.HAIR")
    -- 职业
    PlayerEquip_Look_TradingBank.playerJob = SL:GetMetaValue("T.M.JOB")
    -------首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 --首饰盒功能是否开启
    GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    PlayerEquip_Look_TradingBank._ui.Best_ringBox, function()
        --首饰盒是否开启
        local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look_TradingBank.RoleType.TradingBankPlayer)
        if activeState then
            SL:OpenBestRingBoxUI(PlayerEquip_Look_TradingBank.RoleType.TradingBankPlayer, { param = {} })
        else
            --提示
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(PlayerEquip_Look_TradingBank._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end
    )
    --刷新首饰盒状态
    PlayerEquip_Look_TradingBank.RefreshPlayerBestRingsOpenState()
    PlayerEquip_Look_TradingBank.RefreshBestRingBox()
    ----------------------
    --刷新行会信息
    PlayerEquip_Look_TradingBank.RefreshGuildInfo()
    ----------------------
    PlayerEquip_Look_TradingBank.InitSamePosDiff()
    PlayerEquip_Look_TradingBank.RegisterEvent()
end

-- 初始化相同部位显示不同
function PlayerEquip_Look_TradingBank.InitSamePosDiff()
    PlayerEquip_Look_TradingBank._pos13Visible = false
    if PlayerEquip_Look_TradingBank._pos13Visible then
        table.insert(PlayerEquip_Look_TradingBank.posSetting, 13)
        table.insert(PlayerEquip_Look_TradingBank.posSetting, 55)
        PlayerEquip_Look_TradingBank.samePosDiff = {
            [4] = 4,
            [13] = 13
        }
    end
    GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Panel_pos55, PlayerEquip_Look_TradingBank._pos13Visible)
    GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Node_55, PlayerEquip_Look_TradingBank._pos13Visible)
end

function PlayerEquip_Look_TradingBank.InitEquipCells()
    local uid = SL:GetMetaValue("LOOK_USER_ID")

    --请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    --额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerEquip_Look_TradingBank.posSetting, 14)
        table.insert(PlayerEquip_Look_TradingBank.posSetting, 15)
    else
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Panel_pos14, false)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Panel_pos15, false)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Node_14, false)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Node_15, false)
    end

    -- 剑甲分离配置
    if SL:GetMetaValue("GAME_DATA", "DivideWeaponAndClothes") == 1 then 
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Panel_pos1000, true)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Panel_pos1001, true)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Node_1000, true)
        GUI:setVisible(PlayerEquip_Look_TradingBank._ui.Node_1001, true)
        table.insert(PlayerEquip_Look_TradingBank.posSetting, 1000)
        table.insert(PlayerEquip_Look_TradingBank.posSetting, 1001)
    end 
end

function PlayerEquip_Look_TradingBank.RefreshGuildInfo()
    local textGuildInfo = PlayerEquip_Look_TradingBank._ui.Text_guildinfo
    local guildData = SL:GetMetaValue("T.M.GUILD_INFO") --行会数据
    local myGuildName = guildData.guildName
    local myJobName = guildData.rankName
    if not myGuildName then
        return
    end
    myJobName = myJobName or ""

    local guildInfo = myGuildName .. " " .. myJobName
    GUI:Text_setString(textGuildInfo, guildInfo)

    local color = SL:GetMetaValue("T.M.USERNAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(textGuildInfo, SL:GetHexColorByStyleId(color))
    end
end

function PlayerEquip_Look_TradingBank.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look_TradingBank.RoleType.TradingBankPlayer)
    if activeState then
        GUI:Image_setGrey(PlayerEquip_Look_TradingBank._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip_Look_TradingBank._ui.Image_box, true)
    end

    if data and data.isOpen then
        if not activeState then
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(PlayerEquip_Look_TradingBank._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1)) --提示
        end
    end
end

function PlayerEquip_Look_TradingBank.RefreshBestRingBox()
    SL:scheduleOnce(
    PlayerEquip_Look_TradingBank._ui.Best_ringBox,
    function()
        local texture = "btn_jewelry_1_1.png"
        if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", PlayerEquip_Look_TradingBank.RoleType.TradingBankPlayer) then --首饰盒界面是否打开
            texture = "btn_jewelry_1_0.png"
        end
        GUI:Image_loadTexture(PlayerEquip_Look_TradingBank._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
        GUI:setIgnoreContentAdaptWithSize(PlayerEquip_Look_TradingBank._ui.Image_box, true) --重置尺寸
        PlayerEquip_Look_TradingBank.RefreshPlayerBestRingsOpenState()
    end,
    0.1
    )
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerEquip_Look_TradingBank.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function PlayerEquip_Look_TradingBank.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function PlayerEquip_Look_TradingBank.CloseCallback()
    PlayerEquip_Look_TradingBank.UnRegisterEvent()
end

function PlayerEquip_Look_TradingBank.RegisterEvent()
end

function PlayerEquip_Look_TradingBank.UnRegisterEvent()
end