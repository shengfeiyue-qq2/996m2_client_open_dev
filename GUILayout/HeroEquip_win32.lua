-- 英雄面板 装备
HeroEquip = {}

HeroEquip._ui = nil

-- 13 斗笠位置比较特殊 属于和头盔位置同部位
-- 要斗笠和头盔分开 需要设置Panel_pos13为显示 
HeroEquip.showModelCapAndHelmet = false -- 斗笠和头盔分开情况下  模型是否显示 斗笠头盔
HeroEquip._hideNodePos = {}
HeroEquip.RoleType = {
    Hero = 2 -- 英雄
}
function HeroEquip.main(data)
    HeroEquip.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_equip_node_win32")

    HeroEquip._ui = GUI:ui_delegate(parent)
    if not HeroEquip._ui then
        return false
    end
    HeroEquip._parent = parent

    HeroEquip._samePosDiff = {}

    -- 初始化装备槽
    HeroEquip.InitEquipCells()
    -- 角色性别
    HeroEquip.playerSex = SL:GetMetaValue("H.SEX")
    -- 发型
    HeroEquip.playerHairID = SL:GetMetaValue("H.HAIR")
    -- 职业
    HeroEquip.playerJob = SL:GetMetaValue("H.JOB")

    -- 首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 -- 首饰盒功能是否开启
    GUI:setVisible(HeroEquip._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    HeroEquip._ui.Best_ringBox, function()
        -- 请求玩家首饰盒状态
        SL:RequestOpenHeroBestRings()

        GUI:delayTouchEnabled(HeroEquip._ui.Best_ringBox, 0.3)
    end
    )
    --刷新首饰盒状态
    HeroEquip.RefreshPlayerBestRingsOpenState()
    HeroEquip.RefreshBestRingBox()
    HeroEquip.RegisterEvent()
end


function HeroEquip.InitHideNodePos()
    HeroEquip._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if HeroEquip._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(HeroEquip._ui[string.format("Node_%s", i)])
            if not visible then
                HeroEquip._hideNodePos[i] = true
            end
        end
    end
end
function HeroEquip.InitSamePosDiff(isAfterF10Load)
    HeroEquip._pos13Visible = GUI:getVisible(HeroEquip._ui.Panel_pos13)
    if  HeroEquip._pos13Visible then
        table.insert(HeroEquip.posSetting, 13)
        table.insert(HeroEquip.posSetting, 55)
        HeroEquip._samePosDiff = {
            [4] = 4,
            [13] = 13
        }
    end
    GUI:setVisible(HeroEquip._ui.Panel_pos55, HeroEquip._pos13Visible)
    GUI:setVisible(HeroEquip._ui.Node_55, HeroEquip._pos13Visible)
    if isAfterF10Load then
        HeroEquip.InitEquipEvent()
        HeroEquip.InitEquipUI()
        HeroEquip.UpdatePlayerView(nil, true)
    end
end

function HeroEquip.InitEquipEvent()
    local posSetting = HeroEquip.posSetting
    for _, pos in ipairs(posSetting) do
        local equipPanel = HeroEquip._ui["Panel_pos" .. pos]
        HeroEquip.InitPanelMoveEvent(equipPanel, pos)
    end
end

function HeroEquip.InitPanelMoveEvent(equipPanel, pos)

    local function GetEquipDataByPos(equipPos, equipList)
        local beginOnMoving = true
        if HeroEquip._samePosDiff[equipPos] then
            equipList = false
            beginOnMoving = false
        end

        local equipItems = nil
        local posData = nil
        if equipList then
            equipItems = SL:GetMetaValue("H.EQUIP_DATA_LIST", equipPos)
        else
            posData = SL:GetMetaValue("H.EQUIP_DATA", equipPos, beginOnMoving) 
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

    local equipPos = pos
    local function refreshMoveState(_, bool)
        local setPos = equipPos
        if GUIFunction:CheckCanShowEquipItem(setPos) or HeroEquip._samePosDiff[setPos] then
            local itemNode = HeroEquip._ui["Node_" .. setPos]
            if HeroEquip._hideNodePos[setPos] then
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
            HeroEquip.UpdatePlayerView(noEquip)
        end

        if bool then
            HeroEquip._moveItemData = SL:GetMetaValue("H.EQUIP_DATA", equipPos)
        else
            HeroEquip._moveItemData = nil
        end
    end

    local function endMoveCallBack()
        HeroEquip._moveItemData = nil
    end

    -- 双击
    local function doubleCallBack()
        if HeroEquip._moveItemData then
            return
        end
        local isList = false
        if not HeroEquip._samePosDiff[equipPos] then
            isList = equipPos == GUIDefine.EquipPosUI.Equip_Type_Helmet or equipPos == GUIDefine.EquipPosUI.Equip_Type_Super_Helmet
        end
        local itemData = SL:GetMetaValue("H.EQUIP_DATA", equipPos, isList)
        if itemData then
            SL:TakeOffHeroEquip(itemData)
        end
    end

    -- 鼠标滚动
    local function scrollCallBack(data)
        SL:onLUAEvent(LUA_EVENT_ITEMTIPS_MOUSE_SCROLL, data)
    end

    local panelSize = GUI:getContentSize(equipPanel)
    local equipWidget = GUI:MoveWidget_Create(equipPanel, "move_equip_" .. pos, panelSize.width / 2 , panelSize.height / 2, panelSize.width, panelSize.height, SL:GetMetaValue("ITEMFROMUI_ENUM").HERO_EQUIP, {
        equipPos = equipPos,
        equipList = not HeroEquip._samePosDiff[equipPos] and true or false,
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
        if not itemData or HeroEquip._moveItemData then
            return
        end
        local panelPos = GUI:getWorldPosition(equipPanel)
        local data = {}
        data.itemData = itemData[#itemData]
        data.itemData2 = itemData[#itemData - 1]
        data.itemData3 = itemData[#itemData - 2]
        data.pos = panelPos
        data.lookPlayer = false
        data.from = SL:GetMetaValue("ITEMFROMUI_ENUM").HERO_EQUIP
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

function HeroEquip.InitEquipUI()
    local equipDataByPos = SL:GetMetaValue("H.EQUIP_POS_DATAS")  
    for pos, data in pairs(equipDataByPos) do
        local equipPanel = HeroEquip._ui["Panel_pos" .. pos]
        if equipPanel and (GUIFunction:CheckCanShowEquipItem(pos) or HeroEquip._samePosDiff[pos]) then
            local item = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", data, true)
            if item then 
                local itemNode = HeroEquip._ui["Node_"..pos]
                GUI:removeAllChildren(itemNode)
                HeroEquip.CreateEquipItem(itemNode, item, pos)
            end
        end
    end
end

function HeroEquip.CreateEquipItem(parent, data, uiPos)
    -- 剑甲分离装备框不显示内观特效
    local function checkPos(uiPos)
        if HeroEquip.fictionalUIPos and HeroEquip.fictionalUIPos[uiPos] then 
            local pos = HeroEquip.fictionalUIPos[uiPos]
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
    info.from = SL:GetMetaValue("ITEMFROMUI_ENUM").HERO_EQUIP
    local item = GUI:ItemShow_Create(parent, "item_" .. uiPos, 0, 0, info)
    GUI:setAnchorPoint(item, 0.5, 0.5)
end

function HeroEquip.InitEquipCells()
    local uid = SL:GetMetaValue("HERO_ID")
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    -- 额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroEquip.posSetting, 14)
        table.insert(HeroEquip.posSetting, 15)
    else
        GUI:setVisible(HeroEquip._ui.Panel_pos14, false)
        GUI:setVisible(HeroEquip._ui.Panel_pos15, false)
        GUI:setVisible(HeroEquip._ui.Node_14, false)
        GUI:setVisible(HeroEquip._ui.Node_15, false)
    end
end

function HeroEquip.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip.RoleType.Hero)
    if activeState then
        GUI:Image_setGrey(HeroEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip._ui.Image_box, true)
    end

    local function mouseMoveCallBack(touchPos)
        if not GUI:getVisible(HeroEquip._ui.Best_ringBox) then 
            return
        end
        local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
        if SL:CheckNodeCanCallBack(HeroEquip._ui.Best_ringBox, touchPos) and bestRingsName ~= "" then
            local tips = nil
            local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip.RoleType.Hero)
            if activeState then
                tips = string.format("点击打开%s", bestRingsName)
            else
                tips = string.format("%s未开启", bestRingsName)
            end
            local worldPos = GUI:getWorldPosition(HeroEquip._ui.Best_ringBox)
            worldPos.x = GUI:getContentSize(HeroEquip._ui.Best_ringBox).width/2 + worldPos.x
            GUI:ShowWorldTips(tips, worldPos, GUI:p(0.5, 1))
        end
    end

    local function leaveItem()
        GUI:HideWorldTips()
    end

    GUI:addMouseMoveEvent(HeroEquip._ui.Best_ringBox,
        {
            onEnterFunc = mouseMoveCallBack,
            onLeaveFunc = leaveItem
        }
    )
    if data and data.isOpen then
        if activeState then
            SL:OpenBestRingBoxUI(HeroEquip.RoleType.Hero, { param = {} })
        end
    end
end

function HeroEquip.RefreshBestRingBox()
    SL:scheduleOnce(HeroEquip._ui.Best_ringBox, function()
        local texture = "btn_jewelry_1_1.png"
        if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", HeroEquip.RoleType.Hero) then -- 首饰盒界面是否打开
            texture = "btn_jewelry_1_0.png"
        end
        GUI:Image_loadTexture(HeroEquip._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
        -- 重置尺寸
        GUI:setIgnoreContentAdaptWithSize(HeroEquip._ui.Image_box, true)
        HeroEquip.RefreshPlayerBestRingsOpenState()
    end, 0.1)
end

function HeroEquip.GetShowUIPosByItemWhere(pos)
    local typeConfig = GUIDefine.EquipPosUI
    if pos == typeConfig.Equip_Type_Cap or pos == typeConfig.Equip_Type_Veil then
        pos = typeConfig.Equip_Type_Helmet
    elseif pos == typeConfig.Equip_Type_Super_Cap or pos == typeConfig.Equip_Type_Super_Veil then
        pos = typeConfig.Equip_Type_Super_Helmet
    end
    return pos
end

function HeroEquip.UpdateEquipUI(data)
    if not data or not next(data) then
        return
    end
    local operatorType = data.opera
    local MakeIndex = data.MakeIndex
    local pos = data.Where
    if not HeroEquip._samePosDiff[pos] then
        if not HeroEquip._pos13Visible or pos ~= 55 then --面巾不处理
            pos = HeroEquip.GetShowUIPosByItemWhere(pos)
        end
    end
    local equipPanel = HeroEquip._ui["Panel_pos" .. pos]
    if not equipPanel then
        return
    end
    local isShowItem = false 
    if GUIFunction:CheckCanShowEquipItem(pos) or HeroEquip._samePosDiff[pos] then
        isShowItem = true
    end
    HeroEquip._moveItemData = nil
    if operatorType == 1 then -- 增
        if isShowItem then
            local itemNode = HeroEquip._ui["Node_" .. pos]
            if not HeroEquip._hideNodePos[pos] then
                GUI:setVisible(itemNode, true)
            else
                GUI:setVisible(itemNode, false)
            end
            GUI:removeAllChildren(itemNode)
            local item = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true)
            HeroEquip.CreateEquipItem(itemNode, item, pos)
            if HeroEquip._samePosDiff[pos] and HeroEquip.showModelCapAndHelmet then 
                HeroEquip.UpdatePlayerView()
            end
        else
            HeroEquip.UpdatePlayerView()
        end
    elseif operatorType == 2 then -- 删
        if isShowItem then
            local itemNode = HeroEquip._ui["Node_" .. pos]
            GUI:removeAllChildren(itemNode)
            if HeroEquip._samePosDiff[pos] and HeroEquip.showModelCapAndHelmet then 
                HeroEquip.UpdatePlayerView()
            end
        else
            HeroEquip.UpdatePlayerView()
        end
    elseif operatorType == 3 then -- 改
        -- 如果更新的装备不是更新Look  不进行更新内观的刷新
        if not data.isChangeLook then
            return
        end

        if isShowItem then
            local itemNode = HeroEquip._ui["Node_" .. pos]
            GUI:removeAllChildren(itemNode)
            local item = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true)
            HeroEquip.CreateEquipItem(itemNode, item, pos)
            if HeroEquip._samePosDiff[pos] and HeroEquip.showModelCapAndHelmet then 
                HeroEquip.UpdatePlayerView()
            end
        else
            HeroEquip.UpdatePlayerView()
        end
    end
end

function HeroEquip.UpdatePlayerView(noEquipType, init)
    GUI:removeAllChildren(HeroEquip._ui.Node_playerModel)
    local equipDataByPos = SL:GetMetaValue("H.EQUIP_POS_DATAS")
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
            if init and HeroEquip._moveItemData and MakeIndex == HeroEquip._moveItemData.MakeIndex then
                return show
            end
            local equipData = SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, true) or {}

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

            if HeroEquip._samePosDiff[equipType] and not HeroEquip.showModelCapAndHelmet then
                return {
                    look = nil,
                    effect = nil
                }
            end

            return show
        end
        return show
    end
    local hairID        = SL:GetMetaValue("H.HAIR")
    local clothShow     = GetLooks(equipTypeConfig.Equip_Type_Dress, noEquipType.NoCloth)
    local weaponShow    = GetLooks(equipTypeConfig.Equip_Type_Weapon, noEquipType.NoWeapon)
    local headShow      = GetLooks(equipTypeConfig.Equip_Type_Helmet, noEquipType.NoHead)
    local capShow       = GetLooks(equipTypeConfig.Equip_Type_Cap, noEquipType.NoCap)
    local shieldShow    = GetLooks(equipTypeConfig.Equip_Type_Shield, noEquipType.NoShield)
    local veilShow      = GetLooks(equipTypeConfig.Equip_Type_Veil, noEquipType.NoVeil)
    local tDressShow    = GetLooks(10004)
    local tWeaponShow   = GetLooks(10005)
    local embattle      = SL:GetMetaValue("H.EMBATTLE")

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

    local sex = SL:GetMetaValue("H.SEX")
    local job = SL:GetMetaValue("H.JOB")
    local uiModel = GUI:UIModel_Create(HeroEquip._ui.Node_playerModel, "model", 0, 0, sex, modelData, nil, true, job, {showHelmet = showHelmet})
    GUI:setAnchorPoint(uiModel, 0.5, 0.5)
end

function HeroEquip.OnOpenOrCloseWin(data)
    if data == "PlayerHeroBestRingGUI" then
        HeroEquip.RefreshBestRingBox()
    end
end

--[[    
    界面关闭回调
]]
function HeroEquip.CloseCallback()
    HeroEquip.UnRegisterEvent()
end

function HeroEquip.RegisterEvent()
    -- 刷新装备信息
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroEquip", HeroEquip.UpdateEquipUI)
    -- 刷新法阵
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EMBATTLE_CHANGE, "HeroEquip", HeroEquip.UpdatePlayerView)
    -- 刷新性别
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SEX_CHANGE, "HeroEquip", HeroEquip.UpdatePlayerView)
    -- 打开/关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_OPENWIN, "HeroEquip", HeroEquip.OnOpenOrCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroEquip", HeroEquip.OnOpenOrCloseWin)
    -- 首饰盒状态改变
    SL:RegisterLUAEvent(LUA_EVENT_HERO_BESTRINGBOX_STATE, "HeroEquip", HeroEquip.RefreshPlayerBestRingsOpenState)
end

function HeroEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EQUIP_CHANGE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EMBATTLE_CHANGE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_SEX_CHANGE, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_OPENWIN, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroEquip")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_BESTRINGBOX_STATE, "HeroEquip")
end