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

    PlayerEquip_Look._samePosDiff = {}

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

function PlayerEquip_Look.InitSamePosDiff(isAfterF10Load)
    PlayerEquip_Look._pos13Visible = GUI:getVisible(PlayerEquip_Look._ui.Panel_pos13)
    if  PlayerEquip_Look._pos13Visible then
        table.insert(PlayerEquip_Look.posSetting, 13)
        table.insert(PlayerEquip_Look.posSetting, 55)
        PlayerEquip_Look._samePosDiff = {
            [4] = 4,
            [13] = 13
        }
    end
    GUI:setVisible(PlayerEquip_Look._ui.Panel_pos55, PlayerEquip_Look._pos13Visible)
    GUI:setVisible(PlayerEquip_Look._ui.Node_55, PlayerEquip_Look._pos13Visible)
    if isAfterF10Load then
        PlayerEquip_Look.InitEquipEvent()
        PlayerEquip_Look.InitEquipUI()
        PlayerEquip_Look.UpdatePlayerView()
    end
end

function PlayerEquip_Look.InitEquipEvent()
    local posSetting = PlayerEquip_Look.posSetting
    for _, pos in ipairs(posSetting) do
        local equipPanel = PlayerEquip_Look._ui["Panel_pos" .. pos]
        PlayerEquip_Look.InitPanelTouchEvent(equipPanel, pos)
    end
end

function PlayerEquip_Look.InitPanelTouchEvent(equipPanel, pos)
    -- 单击  
    local function GetEquipDataByPos(equipPos, equipList)
        local beginOnMoving = true
        if PlayerEquip_Look._samePosDiff[equipPos] then
            equipList = false
            beginOnMoving = false
        end

        local equipItems = nil
        local posData = nil
        if equipList then
            equipItems = SL:GetMetaValue("L.M.EQUIP_DATA_LIST", equipPos)
        else
            posData = SL:GetMetaValue("L.M.EQUIP_DATA", equipPos, beginOnMoving) 
        end

        if not equipItems and posData then
            if not beginOnMoving then
                equipItems = {}
                table.insert(equipItems, posData)
            else
                equipItems = posData
            end
        end
        
        return equipItems
    end

    local function clickCallBack()
        local equipPos = PlayerEquip_Look.fictionalUIPos and PlayerEquip_Look.fictionalUIPos[pos] or pos
        local itemData = GetEquipDataByPos(equipPos, true)
        if not itemData then
            return
        end
        local panelPos = GUI:getWorldPosition(equipPanel)
        local data = {}
        data.itemData = itemData[#itemData]
        data.itemData2 = itemData[#itemData - 1]
        data.itemData3 = itemData[#itemData - 2]
        data.pos = panelPos
        data.lookPlayer = true
        data.from = SL:GetMetaValue("ITEMFROMUI_ENUM").PALYER_EQUIP
        SL:OpenItemTips(data)
    end
    GUI:setTouchEnabled(equipPanel, true)
    GUI:addOnClickEvent(equipPanel, clickCallBack)
end

function PlayerEquip_Look.InitEquipUI()
    local equipDataByPos = SL:GetMetaValue("L.M.EQUIP_POS_DATAS")  
    for pos, data in pairs(equipDataByPos) do
        local equipPanel = PlayerEquip_Look._ui["Panel_pos" .. pos]
        if equipPanel and (GUIFunction:CheckCanShowEquipItem(pos) or PlayerEquip_Look._samePosDiff[pos]) then
            local item = SL:GetMetaValue("LOOKPLAYER_DATA_BY_MAKEINDEX", data.MakeIndex)
            if item then 
                local itemNode = PlayerEquip_Look._ui["Node_" .. pos]
                GUI:removeAllChildren(itemNode)
                PlayerEquip_Look.CreateEquipItem(itemNode, item, pos)
            end
        end
        PlayerEquip_Look.ShowEquipItemsUI(pos)
    end
end

function PlayerEquip_Look.CreateEquipItem(parent, data, uiPos)
    -- 剑甲分离装备框不显示内观特效
    local function checkPos(uiPos)
        if PlayerEquip_Look.fictionalUIPos and PlayerEquip_Look.fictionalUIPos[uiPos] then 
            local pos = PlayerEquip_Look.fictionalUIPos[uiPos]
            if pos == GUIDefine.EquipPosUI.Equip_Type_Dress or pos == GUIDefine.EquipPosUI.Equip_Type_Weapon then
                return false
            end
        end
        return true
    end

    local info = {}
    info.itemData = data
    info.index = data.Index
    info.noMouseTips = true
    info.showModelEffect = checkPos(uiPos)
    local item = GUI:ItemShow_Create(parent, "item_" .. uiPos, 0, 0, info)
    GUI:setAnchorPoint(item, 0.5, 0.5)
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

function PlayerEquip_Look.UpdatePlayerView(noEquipType)
    GUI:removeAllChildren(PlayerEquip_Look._ui.Node_playerModel)
    local equipDataByPos = SL:GetMetaValue("L.M.EQUIP_POS_DATAS")
    local equipTypeConfig = GUIDefine.EquipPosUI

    noEquipType = noEquipType or {}

    local showNakedMold = true --装备进行判断是否显示裸模  默认显示
    local showHelmet = false
    local function getFileName(looks)
        local fileName = string.format("%06d", looks % 10000)
        return fileName, math.floor(looks / 10000)
    end

    local function GetLooks(equipType, need)
        local show = {
            look = nil,
            effect = nil
        }
        if equipType > 10000 then
            local fashionShow = {}
            return fashionShow
        end
        if not need and equipType and equipDataByPos[equipType] then
            local MakeIndex = equipDataByPos[equipType].MakeIndex
            local equipData = SL:GetMetaValue("LOOKPLAYER_DATA_BY_MAKEINDEX", MakeIndex) or {}

            if equipType == equipTypeConfig.Equip_Type_Dress then
                if showNakedMold and equipData and equipData.shonourSell and tonumber(equipData.shonourSell) == 1 then --xslm==1不显示裸模
                    showNakedMold = false
                end
            end

            if equipData and equipData.Looks then
                show.look = equipData.Looks
            end

            if equipData and equipData.sEffect then
                show.effect = equipData.sEffect
            end

            if equipType == equipTypeConfig.Equip_Type_Cap and equipData.AniCount == 0 then
                showHelmet = true
            end

            if PlayerEquip_Look._samePosDiff[equipType] and not PlayerEquip_Look.showModelCapAndHelmet then
                return {
                    look = nil,
                    effect = nil
                }
            end

            return show
        end
        return show
    end
    local hairID        = PlayerEquip_Look.playerHairID
    local clothShow     = GetLooks(equipTypeConfig.Equip_Type_Dress, noEquipType.NoCloth)
    local weaponShow    = GetLooks(equipTypeConfig.Equip_Type_Weapon, noEquipType.NoWeapon)
    local headShow      = GetLooks(equipTypeConfig.Equip_Type_Helmet, noEquipType.NoHead)
    local capShow       = GetLooks(equipTypeConfig.Equip_Type_Cap, noEquipType.NoCap)
    local shieldShow    = GetLooks(equipTypeConfig.Equip_Type_Shield, noEquipType.NoShield)
    local veilShow      = GetLooks(equipTypeConfig.Equip_Type_Veil, noEquipType.NoVeil)
    local tDressShow    = GetLooks(10004)
    local tWeaponShow   = GetLooks(10005)
    local embattle      = SL:GetMetaValue("L.M.EMBATTLE")

    local modelData = {
        clothID         = clothShow.look,
        clothEffectID   = clothShow.effect,
        weaponID        = weaponShow.look,
        weaponEffectID  = weaponShow.effect,
        headID          = headShow.look,
        headEffectID    = headShow.effect,
        hairID          = hairID,
        capID           = capShow.look,
        capEffectID     = capShow.effect,
        veilID          = veilShow.look,
        veilEffectID    = veilShow.effect,
        shieldID        = shieldShow.look,
        shieldEffectID  = shieldShow.effect,
        tDressID        = tDressShow.look,
        tDressEffectID  = tDressShow.effect,
        tWeaponID       = tWeaponShow.look,
        tWeaponEffectID = tWeaponShow.effect,
        embattlesID     = embattle,
        notShowMold     = not showNakedMold,
        notShowHair     = not showNakedMold,
    }

    local sex = PlayerEquip_Look.playerSex
    local job = PlayerEquip_Look.playerJob
    local uiModel = GUI:UIModel_Create(PlayerEquip_Look._ui.Node_playerModel, "model", 0, 0, sex, modelData, nil, true, job, {showHelmet = showHelmet})
    GUI:setAnchorPoint(uiModel, 0.5, 0.5)
end

function PlayerEquip_Look.ShowEquipItemsUI(pos)
    if not pos then 
        return 
    end 

    if not PlayerEquip_Look.realUIPos or not PlayerEquip_Look.realUIPos[pos] then 
        return 
    end 

    local data = SL:GetMetaValue("L.M.EQUIP_DATA", pos)
    if not data then 
        return 
    end 

    local UIPos = PlayerEquip_Look.realUIPos[pos]

    local itemPanel = PlayerEquip_Look._ui["Panel_pos" .. UIPos]
    local bShow = GUI:getVisible(itemPanel)
    if not bShow then 
        return 
    end 

    local itemNode = PlayerEquip_Look._ui["Node_" .. UIPos]
    if not itemNode then   
        return 
    end 

    GUI:setVisible(itemNode, true)
    GUI:removeAllChildren(itemNode)

    PlayerEquip_Look.CreateEquipItem(itemNode, data, UIPos)
end

function PlayerEquip_Look.HideEquipItemsUI(pos)
    if not pos then 
        return 
    end 

    if not PlayerEquip_Look.realUIPos or not PlayerEquip_Look.realUIPos[pos] then 
        return 
    end 

    local UIPos = PlayerEquip_Look.realUIPos[pos] 

    local itemPanel = PlayerEquip_Look._ui["Panel_pos" .. UIPos]
    local bShow = GUI:getVisible(itemPanel)
    if not bShow then 
        return 
    end 

    local itemNode = PlayerEquip_Look._ui["Node_"..UIPos]
    if not itemNode then   
        return 
    end 

    GUI:setVisible(itemNode, false)
    GUI:removeAllChildren(itemNode)
end

function PlayerEquip_Look.OnOpenOrCloseWin(data)
    if data == "LookPlayerBestRingGUI" then
        PlayerEquip_Look.RefreshBestRingBox()
    end
end

--[[    
    界面关闭回调
]]
function PlayerEquip_Look.CloseCallback()
    PlayerEquip_Look.UnRegisterEvent()
end

function PlayerEquip_Look.RegisterEvent()
    -- 打开/关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_OPENWIN, "PlayerEquip_Look", PlayerEquip_Look.OnOpenOrCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "PlayerEquip_Look", PlayerEquip_Look.OnOpenOrCloseWin)
end

function PlayerEquip_Look.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_OPENWIN, "PlayerEquip_Look")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "PlayerEquip_Look")
end