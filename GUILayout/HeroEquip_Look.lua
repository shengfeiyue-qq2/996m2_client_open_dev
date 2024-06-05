HeroEquip_Look = {}----查看他人英雄面板 装备
HeroEquip_Look._ui = nil
-- 13 斗笠位置比较特殊 属于和头盔位置同部位
-- 要斗笠和头盔分开 需要设置Panel_pos13为显示 
HeroEquip_Look.showModelCapAndHelmet = false -- 斗笠和头盔分开情况下  模型是否显示 斗笠头盔
HeroEquip_Look._hideNodePos = {}
HeroEquip_Look.RoleType = {
    OtherHero = 12 --他人英雄
}
function HeroEquip_Look.main(data)
    HeroEquip_Look.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look/hero_equip_node")

    HeroEquip_Look._ui = GUI:ui_delegate(parent)
    if not HeroEquip_Look._ui then
        return false
    end
    HeroEquip_Look._parent = parent

    HeroEquip_Look._samePosDiff = {}

    --初始化装备槽
    HeroEquip_Look.InitEquipCells()

    -- 角色性别
    HeroEquip_Look.playerSex = SL:GetMetaValue("L.M.SEX")
    -- 发型
    HeroEquip_Look.playerHairID = SL:GetMetaValue("L.M.HAIR")
    -- 职业
    HeroEquip_Look.playerJob = SL:GetMetaValue("L.M.JOB")

    -------首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 --首饰盒功能是否开启
    GUI:setVisible(HeroEquip_Look._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(
    HeroEquip_Look._ui.Best_ringBox, function()
        --首饰盒是否开启
        local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip_Look.RoleType.OtherHero)
        if activeState then
            SL:OpenBestRingBoxUI(HeroEquip_Look.RoleType.OtherHero, { param = {} })
        else
            --提示
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end)
    GUI:Text_setString(HeroEquip_Look._ui.Text_guildinfo, "")
    --刷新首饰盒状态
    HeroEquip_Look.RefreshPlayerBestRingsOpenState()
    HeroEquip_Look.RefreshBestRingBox()
    ----------------------
    HeroEquip_Look.RegisterEvent()
end

function HeroEquip_Look.InitHideNodePos()
    HeroEquip_Look._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if HeroEquip_Look._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(HeroEquip_Look._ui[string.format("Node_%s", i)])
            if not visible then
                HeroEquip_Look._hideNodePos[i] = true
            end
        end
    end
end

function HeroEquip_Look.InitSamePosDiff(isAfterF10Load)
    HeroEquip_Look._pos13Visible = GUI:getVisible(HeroEquip_Look._ui.Panel_pos13)
    if  HeroEquip_Look._pos13Visible then
        table.insert(HeroEquip_Look.posSetting, 13)
        table.insert(HeroEquip_Look.posSetting, 55)
        HeroEquip_Look._samePosDiff = {
            [4] = 4,
            [13] = 13
        }
    end
    GUI:setVisible(HeroEquip_Look._ui.Panel_pos55, HeroEquip_Look._pos13Visible)
    GUI:setVisible(HeroEquip_Look._ui.Node_55, HeroEquip_Look._pos13Visible)
    if isAfterF10Load then
        HeroEquip_Look.InitEquipEvent()
        HeroEquip_Look.InitEquipUI()
        HeroEquip_Look.UpdatePlayerView()
    end
end

function HeroEquip_Look.InitEquipEvent()
    local posSetting = HeroEquip_Look.posSetting
    for _, pos in ipairs(posSetting) do
        local equipPanel = HeroEquip_Look._ui["Panel_pos" .. pos]
        HeroEquip_Look.InitPanelTouchEvent(equipPanel, pos)
    end
end

function HeroEquip_Look.InitPanelTouchEvent(equipPanel, pos)
    -- 单击  
    local function GetEquipDataByPos(equipPos, equipList)
        local beginOnMoving = true
        if HeroEquip_Look._samePosDiff[equipPos] then
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
        local itemData = GetEquipDataByPos(pos, true)
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
        data.from = SL:GetMetaValue("ITEMFROMUI_ENUM").HERO_EQUIP
        SL:OpenItemTips(data)
    end
    GUI:setTouchEnabled(equipPanel, true)
    GUI:addOnClickEvent(equipPanel, clickCallBack)
end

function HeroEquip_Look.InitEquipUI()
    local equipDataByPos = SL:GetMetaValue("L.M.EQUIP_POS_DATAS")  
    for pos, data in pairs(equipDataByPos) do
        local equipPanel = HeroEquip_Look._ui["Panel_pos" .. pos]
        if equipPanel and (GUIFunction:CheckCanShowEquipItem(pos) or HeroEquip_Look._samePosDiff[pos]) then
            local item = SL:GetMetaValue("LOOKPLAYER_DATA_BY_MAKEINDEX", data.MakeIndex)
            if item then 
                local itemNode = HeroEquip_Look._ui["Node_" .. pos]
                GUI:removeAllChildren(itemNode)
                HeroEquip_Look.CreateEquipItem(itemNode, item, pos)
            end
        end
    end
end

function HeroEquip_Look.CreateEquipItem(parent, data, uiPos)
    local info = {}
    info.itemData = data
    info.index = data.Index
    info.noMouseTips = true
    info.showModelEffect = true
    local item = GUI:ItemShow_Create(parent, "item_" .. uiPos, 0, 0, info)
    GUI:setAnchorPoint(item, 0.5, 0.5)
end

function HeroEquip_Look.InitEquipCells()
    local uid = SL:GetMetaValue("LOOK_USER_ID")

    --请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    --额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(HeroEquip_Look.posSetting, 14)
        table.insert(HeroEquip_Look.posSetting, 15)
    else
        GUI:setVisible(HeroEquip_Look._ui.Panel_pos14, false)
        GUI:setVisible(HeroEquip_Look._ui.Panel_pos15, false)
        GUI:setVisible(HeroEquip_Look._ui.Node_14, false)
        GUI:setVisible(HeroEquip_Look._ui.Node_15, false)
    end
end

function HeroEquip_Look.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", HeroEquip_Look.RoleType.OtherHero)
    if activeState then
        GUI:Image_setGrey(HeroEquip_Look._ui.Image_box, false)
    else
        GUI:Image_setGrey(HeroEquip_Look._ui.Image_box, true)
    end

    if data and data.isOpen then
        if not activeState then
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(HeroEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1)) --提示
        end
    end
end

function HeroEquip_Look.RefreshBestRingBox()
    SL:scheduleOnce(
    HeroEquip_Look._ui.Best_ringBox,
    function()
        local texture = "btn_jewelry_1_1.png"
        if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", HeroEquip_Look.RoleType.OtherHero) then --首饰盒界面是否打开
            texture = "btn_jewelry_1_0.png"
        end
        GUI:Image_loadTexture(HeroEquip_Look._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_mobile/" .. texture)
        GUI:setIgnoreContentAdaptWithSize(HeroEquip_Look._ui.Image_box, true) --重置尺寸
        HeroEquip_Look.RefreshPlayerBestRingsOpenState()
    end,
    0.1
    )
end

function HeroEquip_Look.UpdatePlayerView(noEquipType)
    GUI:removeAllChildren(HeroEquip_Look._ui.Node_playerModel)
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

            if HeroEquip_Look._samePosDiff[equipType] and not HeroEquip_Look.showModelCapAndHelmet then
                return {
                    look = nil,
                    effect = nil
                }
            end

            return show
        end
        return show
    end
    local hairID        = HeroEquip_Look.playerHairID
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

    local sex = HeroEquip_Look.playerSex
    local job = HeroEquip_Look.playerJob
    local uiModel = GUI:UIModel_Create(HeroEquip_Look._ui.Node_playerModel, "model", 0, 0, sex, modelData, nil, true, job, {showHelmet = showHelmet})
    GUI:setAnchorPoint(uiModel, 0.5, 0.5)
end

function HeroEquip_Look.OnOpenOrCloseWin(data)
    if data == "LookHeroBestRingGUI" then
        HeroEquip_Look.RefreshBestRingBox()
    end
end

--[[    
    界面关闭回调
]]
function HeroEquip_Look.CloseCallback()
    HeroEquip_Look.UnRegisterEvent()
end

function HeroEquip_Look.RegisterEvent()
    -- 打开/关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_OPENWIN, "HeroEquip_Look", HeroEquip_Look.OnOpenOrCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroEquip_Look", HeroEquip_Look.OnOpenOrCloseWin)
end

function HeroEquip_Look.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_OPENWIN, "HeroEquip_Look")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "HeroEquip_Look")
end