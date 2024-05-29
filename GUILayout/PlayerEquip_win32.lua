-- 角色面板 装备
PlayerEquip = {}

PlayerEquip._ui = nil

-- 13 斗笠位置比较特殊 属于和头盔位置同部位
-- 要斗笠和头盔分开 需要设置Panel_pos13为显示 
PlayerEquip.showModelCapAndHelmet = false -- 斗笠和头盔分开情况下  模型是否显示 斗笠头盔
PlayerEquip.posSetting = {}
PlayerEquip._hideNodePos = {}
PlayerEquip.RoleType = {
    Self = 1 -- 自己
}

-- 剑甲分离出格子 需要对应相应装备位置
PlayerEquip.realUIPos = {
    [GUIDefine.EquipPosUI.Equip_Type_Dress] = 1000, 
    [GUIDefine.EquipPosUI.Equip_Type_Weapon] = 1001,
}

PlayerEquip.fictionalUIPos = {
    [1000] = GUIDefine.EquipPosUI.Equip_Type_Dress,
    [1001] = GUIDefine.EquipPosUI.Equip_Type_Weapon, 
}

function PlayerEquip.main(data)
    PlayerEquip.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, --1000, 1001 如有分离装备 需要添加
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_equip_node_win32")

    PlayerEquip._ui = GUI:ui_delegate(parent)
    if not PlayerEquip._ui then
        return false
    end
    PlayerEquip._parent = parent

    PlayerEquip._samePosDiff = {}

    -- 初始化装备槽
    PlayerEquip.InitEquipCells()
    -- 角色性别
    PlayerEquip.playerSex = SL:GetMetaValue("SEX")
    -- 发型
    PlayerEquip.playerHairID = SL:GetMetaValue("HAIR")
    -- 职业
    PlayerEquip.playerJob = SL:GetMetaValue("JOB")

    PlayerEquip.InitSamePosDiff()
    PlayerEquip.InitEquipEvent()
    PlayerEquip.InitEquipUI()
    PlayerEquip.UpdatePlayerView(nil, true)

    -- 首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 -- 首饰盒功能是否开启
    GUI:setVisible(PlayerEquip._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(PlayerEquip._ui.Best_ringBox,function()
        -- 请求玩家首饰盒状态
        SL:RequestOpenPlayerBestRings()

        GUI:delayTouchEnabled(PlayerEquip._ui.Best_ringBox, 0.3)
    end)
    --刷新首饰盒状态
    PlayerEquip.RefreshPlayerBestRingsOpenState()
    PlayerEquip.RefreshBestRingBox()
    ----------------------
    --刷新行会信息
    PlayerEquip.RefreshGuildInfo()
    ----------------------
    PlayerEquip.RegisterEvent()
end

function PlayerEquip.InitHideNodePos()
    PlayerEquip._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if PlayerEquip._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(PlayerEquip._ui[string.format("Node_%s", i)])
            if not visible then
                PlayerEquip._hideNodePos[i] = true
            end
        end
    end
end


function PlayerEquip.InitSamePosDiff()
    PlayerEquip._pos13Visible = GUI:getVisible(PlayerEquip._ui.Panel_pos13)
    if  PlayerEquip._pos13Visible then
        table.insert(PlayerEquip.posSetting, 13)
        table.insert(PlayerEquip.posSetting, 55)
        PlayerEquip._samePosDiff = {
            [4] = 4,
            [13] = 13
        }
    end
    GUI:setVisible(PlayerEquip._ui.Panel_pos55, PlayerEquip._pos13Visible)
    GUI:setVisible(PlayerEquip._ui.Node_55, PlayerEquip._pos13Visible)
end

function PlayerEquip.InitEquipEvent()
    local posSetting = PlayerEquip.posSetting
    for _, pos in ipairs(posSetting) do
        local equipPanel = PlayerEquip._ui["Panel_pos" .. pos]
        PlayerEquip.InitPanelMoveEvent(equipPanel, pos)
    end
end

function PlayerEquip.InitPanelMoveEvent(equipPanel, pos)

    local function GetEquipDataByPos(equipPos, equipList)
        local beginOnMoving = true
        if PlayerEquip._samePosDiff[equipPos] then
            equipList = false
            beginOnMoving = false
        end

        local equipItems = nil
        local posData = nil
        if equipList then
            equipItems = SL:GetMetaValue("EQUIP_DATA_LIST", equipPos)
        else
            posData = SL:GetMetaValue("EQUIP_DATA", equipPos, beginOnMoving) 
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

    local equipPos = PlayerEquip.fictionalUIPos and PlayerEquip.fictionalUIPos[pos] or pos
    local function refreshMoveState(_, bool)
        local setPos = equipPos
        if GUIFunction:CheckCanShowEquipItem(setPos) or PlayerEquip._samePosDiff[setPos] then
            local itemNode = PlayerEquip._ui["Node_" .. setPos]
            if PlayerEquip._hideNodePos[setPos] then
                GUI:setVisible(itemNode, false)
            else
                GUI:setVisible(itemNode, not bool)
            end
        else
            local noEquip = nil
            if bool then
                noEquip = {}
                if setPos == GUIDefine.EquipPosUI.Equip_Type_Dress then
                    noEquip.NoCloth = true
                elseif setPos == GUIDefine.EquipPosUI.Equip_Type_Weapon then
                    noEquip.NoWeapon = true
                elseif setPos == GUIDefine.EquipPosUI.Equip_Type_Helmet then
                    noEquip.NoHead = true
                elseif setPos == GUIDefine.EquipPosUI.Equip_Type_Cap then
                    noEquip.NoCap = true
                elseif setPos == GUIDefine.EquipPosUI.Equip_Type_Shield then
                    noEquip.NoShield = true
                elseif setPos == GUIDefine.EquipPosUI.Equip_Type_Veil then
                    noEquip.NoVeil = true
                end
            end
            PlayerEquip.UpdatePlayerView(noEquip)
        end

        if PlayerEquip.realUIPos and PlayerEquip.realUIPos[setPos] then 
            if bool then 
                PlayerEquip.HideEquipItemsUI(setPos)
            else 
                PlayerEquip.ShowEquipItemsUI(setPos)
            end 
        end

        if bool then
            PlayerEquip._moveItemData = SL:GetMetaValue("EQUIP_DATA", equipPos)
        else
            PlayerEquip._moveItemData = nil
        end
    end

    local function endMoveCallBack()
        PlayerEquip._moveItemData = nil
    end

    -- 双击
    local function doubleCallBack()
        if PlayerEquip._moveItemData then
            return
        end
        local isList = false
        if not PlayerEquip._samePosDiff[equipPos] then
            isList = equipPos == GUIDefine.EquipPosUI.Equip_Type_Helmet or equipPos == GUIDefine.EquipPosUI.Equip_Type_Super_Helmet
        end
        local itemData = SL:GetMetaValue("EQUIP_DATA", equipPos, isList)
        if itemData then
            SL:TakeOffPlayerEquip(itemData)
        end
    end

    -- 鼠标滚动
    local function scrollCallBack(data)
        SL:onLUAEvent(LUA_EVENT_ITEMTIPS_MOUSE_SCROLL, data)
    end

    local panelSize = GUI:getContentSize(equipPanel)
    local equipWidget = GUI:MoveWidget_Create(equipPanel, "move_equip_" .. pos, panelSize.width / 2 , panelSize.height / 2, panelSize.width, panelSize.height, SL:GetMetaValue("ITEMFROMUI_ENUM").PALYER_EQUIP, {
        equipPos = equipPos,
        equipList = not PlayerEquip._samePosDiff[equipPos] and true or false,
        beginMoveCB = refreshMoveState,
        cancelMoveCB = refreshMoveState,
        endMoveCB = endMoveCallBack,
        pcDoubleCB = doubleCallBack,
        mouseScrollCB = scrollCallBack,
    })

    local enterDelayTimer = nil
    local function CleanupTimer()
        if enterDelayTimer then
            GUI:stopAllActions(equipPanel)
            enterDelayTimer = nil
        end
    end

    local function mouseMoveCallBack()
        local itemData = GetEquipDataByPos(equipPos, true)
        if not itemData or PlayerEquip._moveItemData then
            return
        end
        local panelPos = GUI:getWorldPosition(equipPanel)
        local data = {}
        data.itemData = itemData[#itemData]
        data.itemData2 = itemData[#itemData - 1]
        data.itemData3 = itemData[#itemData - 2]
        data.pos = panelPos
        data.lookPlayer = false
        data.from = SL:GetMetaValue("ITEMFROMUI_ENUM").PALYER_EQUIP
        SL:OpenItemTips(data)
        CleanupTimer()
    end

    local function onEnterFunc()
        if enterDelayTimer then
            return
        end
        enterDelayTimer = SL:scheduleOnce(equipPanel, function()
            mouseMoveCallBack()
        end, 0.05)
    end

    local function onLeaveFunc()
        SL:CloseItemTips()
        CleanupTimer()
    end

    GUI:addMouseMoveEvent(equipPanel, {
        onEnterFunc = onEnterFunc,
        onLeaveFunc = onLeaveFunc,
        checkIsVisible = true
    })
end

function PlayerEquip.InitEquipUI()
    local equipDataByPos = SL:GetMetaValue("EQUIP_POS_DATAS")  
    for pos, data in pairs(equipDataByPos) do
        local equipPanel = PlayerEquip._ui["Panel_pos" .. pos]
        if equipPanel and (GUIFunction:CheckCanShowEquipItem(pos) or PlayerEquip._samePosDiff[pos]) then
            local item = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data)
            if item then 
                local itemNode = PlayerEquip._ui["Node_"..pos]
                GUI:removeAllChildren(itemNode)
                PlayerEquip.CreateEquipItem(itemNode, item, pos)
            end
        end
        PlayerEquip.ShowEquipItemsUI(pos)
    end
end

function PlayerEquip.CreateEquipItem(parent, data, uiPos)
    -- 剑甲分离装备框不显示内观特效
    local function checkPos(uiPos)
        if PlayerEquip.fictionalUIPos and PlayerEquip.fictionalUIPos[uiPos] then 
            local pos = PlayerEquip.fictionalUIPos[uiPos]
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
    info.from = SL:GetMetaValue("ITEMFROMUI_ENUM").PALYER_EQUIP
    local item = GUI:ItemShow_Create(parent, "item_" .. uiPos, 0, 0, info)
    GUI:setAnchorPoint(item, 0.5, 0.5)
end

function PlayerEquip.InitEquipCells()
    local uid = SL:GetMetaValue("USER_ID")
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    -- 额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerEquip.posSetting, 14)
        table.insert(PlayerEquip.posSetting, 15)
    else
        GUI:setVisible(PlayerEquip._ui.Panel_pos14, false)
        GUI:setVisible(PlayerEquip._ui.Panel_pos15, false)
        GUI:setVisible(PlayerEquip._ui.Node_14, false)
        GUI:setVisible(PlayerEquip._ui.Node_15, false)
    end

    -- 剑甲分离配置
    if SL:GetMetaValue("GAME_DATA", "DivideWeaponAndClothes") == 1 then 
        GUI:setVisible(PlayerEquip._ui.Panel_pos1000, true)
        GUI:setVisible(PlayerEquip._ui.Panel_pos1001, true)
        GUI:setVisible(PlayerEquip._ui.Node_1000, true)
        GUI:setVisible(PlayerEquip._ui.Node_1001, true)
        table.insert(PlayerEquip.posSetting, 1000)
        table.insert(PlayerEquip.posSetting, 1001)
    end 
end

function PlayerEquip.RefreshGuildInfo()
    local textGuildInfo = PlayerEquip._ui.Text_guildinfo
    local guildData = SL:GetMetaValue("GUILD_INFO") -- 行会数据
    local myGuildName = guildData.guildName
    local myJobName = SL:GetMetaValue("GUILD_OFFICIAL", guildData.rank)
    if not myGuildName then
        return
    end
    myJobName = myJobName or ""

    local guildInfo = myGuildName .. " " .. myJobName
    GUI:Text_setString(textGuildInfo, guildInfo)

    local color = SL:GetMetaValue("USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(textGuildInfo, SL:GetHexColorByStyleId(color))
    end
end

function PlayerEquip.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip.RoleType.Self)
    if activeState then
        GUI:Image_setGrey(PlayerEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip._ui.Image_box, true)
    end
    
    local function mouseMoveCallBack(touchPos)
        if not GUI:getVisible(PlayerEquip._ui.Best_ringBox) then 
            return
        end
        local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
        if SL:CheckNodeCanCallBack(PlayerEquip._ui.Best_ringBox, touchPos) and bestRingsName ~= "" then
            local tips = nil
            local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip.RoleType.Self)
            if activeState then
                tips = string.format("点击打开%s", bestRingsName)
            else
                tips = string.format("%s未开启", bestRingsName)
            end
            local worldPos = GUI:getWorldPosition(PlayerEquip._ui.Best_ringBox)
            worldPos.x = GUI:getContentSize(PlayerEquip._ui.Best_ringBox).width/2 + worldPos.x
            GUI:ShowWorldTips(tips, worldPos, GUI:p(0.5, 1))
        end
    end

    local function leaveItem()
        GUI:HideWorldTips()
    end

    GUI:addMouseMoveEvent(PlayerEquip._ui.Best_ringBox,
        {
            onEnterFunc = mouseMoveCallBack,
            onLeaveFunc = leaveItem
        }
    )
    if data and data.isOpen then
        if activeState then
            SL:OpenBestRingBoxUI(PlayerEquip.RoleType.Self, { param = {} })
        end
    end
end

function PlayerEquip.RefreshBestRingBox()
    SL:scheduleOnce(PlayerEquip._ui.Best_ringBox,function()
        local texture = "btn_jewelry_1_1.png"
        if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", PlayerEquip.RoleType.Self) then -- 首饰盒界面是否打开
            texture = "btn_jewelry_1_0.png"
        end
        GUI:Image_loadTexture(PlayerEquip._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_win32/" .. texture)
        -- 重置尺寸
        GUI:setIgnoreContentAdaptWithSize(PlayerEquip._ui.Image_box, true)
        PlayerEquip.RefreshPlayerBestRingsOpenState()
    end,0.1)
end

function PlayerEquip.GetShowUIPosByItemWhere(pos)
    local typeConfig = GUIDefine.EquipPosUI
    if pos == typeConfig.Equip_Type_Cap or pos == typeConfig.Equip_Type_Veil then
        pos = typeConfig.Equip_Type_Helmet
    elseif pos == typeConfig.Equip_Type_Super_Cap or pos == typeConfig.Equip_Type_Super_Veil then
        pos = typeConfig.Equip_Type_Super_Helmet
    end
    return pos
end

function PlayerEquip.UpdateEquipUI(data)
    if not data or not next(data) then
        return
    end
    local operatorType = data.opera
    local MakeIndex = data.MakeIndex
    local pos = data.Where
    if not PlayerEquip._samePosDiff[pos] then
        if not PlayerEquip._pos13Visible or pos ~= 55 then --面巾不处理
            pos = PlayerEquip.GetShowUIPosByItemWhere(pos)
        end
    end
    local equipPanel = PlayerEquip._ui["Panel_pos" .. pos]
    if not equipPanel then
        return
    end
    local isShowItem = false 
    if GUIFunction:CheckCanShowEquipItem(pos) or PlayerEquip._samePosDiff[pos] then
        isShowItem = true
    end
    PlayerEquip._moveItemData = nil
    if operatorType == 1 then -- 增
        if isShowItem then
            local itemNode = PlayerEquip._ui["Node_" .. pos]
            if not PlayerEquip._hideNodePos[pos] then
                GUI:setVisible(itemNode, true)
            else
                GUI:setVisible(itemNode, false)
            end
            GUI:removeAllChildren(itemNode)
            local item = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
            PlayerEquip.CreateEquipItem(itemNode, item, pos)
            if PlayerEquip._samePosDiff[pos] and PlayerEquip.showModelCapAndHelmet then 
                PlayerEquip.UpdatePlayerView()
                PlayerEquip.ShowEquipItemsUI(pos)
            end
        else
            PlayerEquip.UpdatePlayerView()
            PlayerEquip.ShowEquipItemsUI(pos)
        end
    elseif operatorType == 2 then -- 删
        if isShowItem then
            local itemNode = PlayerEquip._ui["Node_" .. pos]
            GUI:removeAllChildren(itemNode)
            if PlayerEquip._samePosDiff[pos] and PlayerEquip.showModelCapAndHelmet then 
                PlayerEquip.UpdatePlayerView()
                PlayerEquip.HideEquipItemsUI(pos)
            end
        else
            PlayerEquip.UpdatePlayerView()
            PlayerEquip.HideEquipItemsUI(pos)
        end
    elseif operatorType == 3 then -- 改
        -- 如果更新的装备不是更新Look  不进行更新内观的刷新
        if not data.isChangeLook then
            return
        end

        if isShowItem then
            local itemNode = PlayerEquip._ui["Node_" .. pos]
            GUI:removeAllChildren(itemNode)
            local item = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex)
            PlayerEquip.CreateEquipItem(itemNode, item, pos)
            if PlayerEquip._samePosDiff[pos] and PlayerEquip.showModelCapAndHelmet then 
                PlayerEquip.UpdatePlayerView()
            end
        else
            PlayerEquip.UpdatePlayerView()
        end
    end
end

function PlayerEquip.UpdatePlayerView(noEquipType, init)
    GUI:removeAllChildren(PlayerEquip._ui.Node_playerModel)
    local equipDataByPos = SL:GetMetaValue("EQUIP_POS_DATAS")
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
            local MakeIndex = equipDataByPos[equipType]
            --移动中处理
            if init and PlayerEquip._moveItemData and MakeIndex == PlayerEquip._moveItemData.MakeIndex then
                return show
            end
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex) or {}

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

            if PlayerEquip._samePosDiff[equipType] and not PlayerEquip.showModelCapAndHelmet then
                return {
                    look = nil,
                    effect = nil
                }
            end

            return show
        end
        return show
    end
    local hairID        = SL:GetMetaValue("HAIR")
    local clothShow     = GetLooks(equipTypeConfig.Equip_Type_Dress, noEquipType.NoCloth)
    local weaponShow    = GetLooks(equipTypeConfig.Equip_Type_Weapon, noEquipType.NoWeapon)
    local headShow      = GetLooks(equipTypeConfig.Equip_Type_Helmet, noEquipType.NoHead)
    local capShow       = GetLooks(equipTypeConfig.Equip_Type_Cap, noEquipType.NoCap)
    local shieldShow    = GetLooks(equipTypeConfig.Equip_Type_Shield, noEquipType.NoShield)
    local veilShow      = GetLooks(equipTypeConfig.Equip_Type_Veil, noEquipType.NoVeil)
    local tDressShow    = GetLooks(10004)
    local tWeaponShow   = GetLooks(10005)
    local embattle      = SL:GetMetaValue("EMBATTLE")

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

    local sex = SL:GetMetaValue("SEX")
    local job = SL:GetMetaValue("JOB")
    local uiModel = GUI:UIModel_Create(PlayerEquip._ui.Node_playerModel, "model", 0, 0, sex, modelData, nil, true, job, {showHelmet = showHelmet})
    GUI:setAnchorPoint(uiModel, 0.5, 0.5)
end

function PlayerEquip.ShowEquipItemsUI(pos)
    if not pos then 
        return 
    end 

    if not PlayerEquip.realUIPos or not PlayerEquip.realUIPos[pos] then 
        return 
    end 

    local data = SL:GetMetaValue("EQUIP_DATA", pos)
    if not data then 
        return 
    end 

    local UIPos = PlayerEquip.realUIPos[pos]

    local itemPanel = PlayerEquip._ui["Panel_pos" .. UIPos]
    local bShow = GUI:getVisible(itemPanel)
    if not bShow then 
        return 
    end 

    local itemNode = PlayerEquip._ui["Node_" .. UIPos]
    if not itemNode then   
        return 
    end 

    GUI:setVisible(itemNode, true)
    GUI:removeAllChildren(itemNode)

    PlayerEquip.CreateEquipItem(itemNode, data, UIPos)
end

function PlayerEquip.HideEquipItemsUI(pos)
    if not pos then 
        return 
    end 

    if not PlayerEquip.realUIPos or not PlayerEquip.realUIPos[pos] then 
        return 
    end 

    local UIPos = PlayerEquip.realUIPos[pos] 

    local itemPanel = PlayerEquip._ui["Panel_pos" .. UIPos]
    local bShow = GUI:getVisible(itemPanel)
    if not bShow then 
        return 
    end 

    local itemNode = PlayerEquip._ui["Node_"..UIPos]
    if not itemNode then   
        return 
    end 

    GUI:setVisible(itemNode, false)
    GUI:removeAllChildren(itemNode)
end

function PlayerEquip.OnOpenOrCloseWin(data)
    if data == "PlayerBestRingGUI" then
        PlayerEquip.RefreshBestRingBox()
    end
end

--[[    
    界面关闭回调
]]
function PlayerEquip.CloseCallback()
    PlayerEquip.UnRegisterEvent()
end

function PlayerEquip.RegisterEvent()
    --刷新行会信息
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_GUILD_INFO_CHANGE, "PlayerEquip", PlayerEquip.RefreshGuildInfo)
    -- 刷新装备信息
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerEquip", PlayerEquip.UpdateEquipUI)
    -- 刷新法阵
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EMBATTLE_CHANGE, "PlayerEquip", PlayerEquip.UpdatePlayerView)
    -- 刷新性别
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_SEX_CHANGE, "PlayerEquip", PlayerEquip.UpdatePlayerView)
    -- 打开/关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_OPENWIN, "PlayerEquip", PlayerEquip.OnOpenOrCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "PlayerEquip", PlayerEquip.OnOpenOrCloseWin)
    -- 首饰盒状态改变
    SL:RegisterLUAEvent(LUA_EVENT_BESTRINGBOX_STATE, "PlayerEquip", PlayerEquip.RefreshPlayerBestRingsOpenState)
end

function PlayerEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_GUILD_INFO_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_EMBATTLE_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_SEX_CHANGE, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_OPENWIN, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "PlayerEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_BESTRINGBOX_STATE, "PlayerEquip")
end