Rank = {}

function Rank.main()
    local type = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    if GUI:GetWindow(nil, UIConst.LAYERID.RankGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.RankGUI, 0, 0, 0, 0, false, false, true, true)
    Rank._layer = parent
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "rank/rank_win32")
    else
        GUI:LoadExport(parent, "rank/rank")
    end

    Rank._path = isWinMode and "res/private/rank_ui/rank_ui_win32/" or "res/private/rank_ui/rank_ui_mobile/"

    Rank._rankType = SL:GetL16Bit(type or 1)              -- 排行榜类型页签
    if not Rank._rankType or Rank._rankType == 0 then
        Rank._rankType = 1
    end
    Rank._selectType = SL:GetH16Bit(type or 1) + 1  -- 1:人物 2:英雄 (英雄预留)
    Rank._selectItemRk = nil
    Rank._chooseItemData = {}
    Rank._rankConfig = {}
    Rank._showLevel = false

    Rank._ui = GUI:ui_delegate(parent)
    Rank._rankList = Rank._ui.ListView_list
    Rank._cellWid = isWinMode and 370 or 450
    Rank._cellHei = isWinMode and 33 or 40

    -- 关闭
    local function closeCB()
        UIOperator:CloseRankUI()
    end
    GUI:addOnClickEvent(Rank._ui.Button_close, closeCB)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    -- 屏幕适配
    if isWinMode then
        GUI:setPosition(Rank._ui.Panel_1, screenW / 2, SL:GetValue("PC_POS_Y"))
        GUI:Win_SetDrag(parent, Rank._ui.Panel_1)
        GUI:Win_SetZPanel(parent, Rank._ui.Panel_1)
    else
        GUI:setPosition(Rank._ui.Panel_1, screenW / 2, screenH / 2)
        GUI:setContentSize(Rank._ui.CloseLayout, screenW, screenH)
        GUI:addOnClickEvent(Rank._ui.CloseLayout, closeCB)
    end


    -- 查看他人
    local function lookPlayerCB()
        GUI:delayTouchEnabled(Rank._ui.Button_looks)
        local playerData = Rank._chooseItemData.data
        if playerData and next(playerData) then
            if playerData.UserID then
                SL:RequestLookPlayer(playerData.UserID, true)
            end
        end
    end
    GUI:addOnClickEvent(Rank._ui.Button_looks, lookPlayerCB)

    Rank._showLevel = SL:CheckCondition(SL:GetValue("GAME_DATA", "rankshowlevel") or "")

    Rank.InitTypeBtn(true)

    Rank.RegisterEvent()

    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.Rank,
        root = Rank._ui.Panel_1
    })
   
end

function Rank.InitTypeBtn(isInit)
    if not SL:GetValue("USEHERO") then
        GUI:setVisible(Rank._ui.Panel_type, false)
    end

    local panelList = {"Panel_player", "Panel_hero"}
    local function setTypeFunc(type, initType)
        for i, v in ipairs(panelList) do
            local panel = Rank._ui[v]
            GUI:Button_setBright(GUI:getChildByName(panel, "Button_" .. i), i ~= type)
            local titleText = GUI:getChildByName(panel, "Text_title" .. i)
            GUI:Text_setTextColor(titleText, i == type and "#f8e6c6" or "#6c6861")
        end
        if Rank._selectType ~= type then
            Rank._selectType = type

            if not initType then
                -- 请求排行榜数据
                SL:RequestRankData(Rank._rankType, Rank._selectType)
            end
        end
        SL:RequestNotifyClickRankType(Rank._selectType)
    end

    for i, v in ipairs(panelList) do
        local btn = GUI:getChildByName(Rank._ui[v], "Button_" .. i)
        GUI:addOnClickEvent(btn, function()
            GUI:delayTouchEnabled(btn)
            setTypeFunc(i)
        end)
    end

    -- 1玩家 2英雄
    setTypeFunc(Rank._selectType or 1, isInit)

    Rank._groupCells = {}
    local config = SL:GetValue("RANK_CONFIG")
    if config and next(config) then
        for i, v in ipairs(config) do
            local cell = Rank.CreateGroupBtnCell(i, v[1].group)
            GUI:ListView_pushBackCustomItem(Rank._ui.ListView_btn, cell)
            GUI:addOnClickEvent(cell, function()
                GUI:delayTouchEnabled(cell)
                if Rank._selectGroup ~= i then
                    Rank._selectGroup = i
                    Rank._rankType = v[1].id
                    Rank.OnRefreshBtnShow()

                    -- 请求排行榜数据
                    SL:RequestRankData(Rank._rankType, Rank._selectType)
                end
            end)
            Rank._groupCells[i] = cell
            if not Rank._selectGroup then
                for _, data in ipairs(v) do
                    if v.id == Rank._rankType then  -- 当前选中
                        Rank._selectGroup = i
                        break
                    end
                end
            end
        end
    end
    Rank._rankConfig = config
    Rank._selectGroup = Rank._selectGroup or 1

    Rank.OnRefreshBtnShow()

    -- 初始化请求
    if isInit then
        SL:RequestRankData(Rank._rankType, Rank._selectType)
    end
end

-- 刷新排行榜
function Rank.UpdateRankUI(data)
    local rankType = data.rankType
    local selectType = data.selectType
    if rankType ~= Rank._rankType and selectType ~= Rank._selectType then
        return
    end

    GUI:stopAllActions(Rank._ui.Panel_1)
    Rank.UpdateRankList()
end

function Rank.UpdateRankList()
    local data = SL:GetValue("RANK_DATA_BY_TYPE", Rank._rankType, Rank._selectType) or {}
    local myID = SL:GetValue("USER_ID")
    if Rank._selectType == 2 then       -- 英雄排行榜
        myID = SL:GetValue("HERO_ID")
    end
    local myInfo = {rank = 0, guildName = ""}
    for i, v in ipairs(data) do
        if v.UserID and v.UserID == myID then
            myInfo.rank = i
            myInfo.guildName = v.GuildName
            break
        end
    end
    Rank.UpdateMyInfoPanel(myInfo)

    GUI:removeAllChildren(Rank._rankList)
    Rank._selectItemRk = nil

    for i, v in ipairs(data) do
        v.rank = i
        GUI:QuickCell_Create(Rank._rankList, "rank" .. i, 0, 0, Rank._cellWid, Rank._cellHei, function(parent)
            local cell = Rank.CreateListCell(parent, v)
            if not Rank._selectItemRk then
                Rank.ResetSelectItem(v)
            end
            return cell
        end)
    end

end

function Rank.UpdateMyInfoPanel(data)
    if data and next(data) then
        local rankStr = "未上榜"
        if data.rank and data.rank > 0 then
            rankStr = string.format("第%d名", data.rank)
        end
        GUI:Text_setString(Rank._ui.Text_level, rankStr)

        local guildStr = "无"
        if data.guildName and data.guildName ~= "" then
            guildStr = data.guildName
        end
        GUI:Text_setString(Rank._ui.Text_guildName, guildStr)
    end
end

function Rank.CheckSuffixDesc()
    if Rank._typeConfig and next(Rank._typeConfig) then
        return Rank._typeConfig.valuename or ""
    end
    return ""
end

function Rank.CreateGroupBtnCell(index, name)
    if not index then
        return
    end
    local cell = GUI:Widget_Create(-1, "btn_group_" .. index, 0, 0, 0, 0)
    GUI:LoadExport(cell, SL:GetValue("IS_PC_OPER_MODE") and "rank/rank_group_btn_cell_win32" or "rank/rank_group_btn_cell")

    local ui = GUI:ui_delegate(cell)
    local btn = ui.button_group
    GUI:Text_setString(ui.Text_name, name)
    GUI:removeFromParent(btn)
    return btn
end

function Rank.CreateTypeBtnCell(data)
    if not data then
        return
    end
    local cell = GUI:Widget_Create(-1, "btn_type_" .. data.id, 0, 0, 0, 0)
    GUI:LoadExport(cell, SL:GetValue("IS_PC_OPER_MODE") and "rank/rank_btn_cell_win32" or "rank/rank_btn_cell")

    local ui = GUI:ui_delegate(cell)
    local btn = ui.button_type
    GUI:Text_setString(ui.Text_name, data.name)
    GUI:removeFromParent(btn)
    return btn
end

function Rank.OnRefreshBtnShow()

    local function changeCellShow(cell, isSelected)
        GUI:setTouchEnabled(cell, not isSelected)
        GUI:Button_setBright(cell, not isSelected)
        local nameText = GUI:getChildByName(cell, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end

    for i, btn in ipairs(Rank._groupCells) do
        local isSelected = i == Rank._selectGroup
        changeCellShow(btn, isSelected)
    end

    -- 插入分类按钮
    local btnListView = Rank._ui.ListView_btn
    local child = GUI:getChildByName(btnListView, "typeList")
    if child then
        GUI:ListView_removeChild(btnListView, child)
    end

    local items = Rank._selectGroup and Rank._rankConfig[Rank._selectGroup] or {}
    if #items > 0 then
        local typeList = GUI:ListView_Create(-1, "typeList", 0, 0, 0, 0, 1)
        GUI:ListView_setGravity(typeList, 2)
        GUI:ListView_addMouseScrollPercent(typeList)
        GUI:ListView_insertCustomItem(btnListView, typeList, Rank._selectGroup)

        local function refreshTypeBtnShow(lastType, curType)
            local lastTypeBtn = GUI:getChildByTag(typeList, lastType)
            if lastTypeBtn then
                changeCellShow(lastTypeBtn, false)
            end
            local curTypeBtn = GUI:getChildByTag(typeList, curType)
            changeCellShow(curTypeBtn, true)
        end

        local itemHei = nil
        for _, data in ipairs(items) do
            local type = data.id
            local selected = type == Rank._rankType
            if selected then
                Rank._typeConfig = data
            end
            local cell = Rank.CreateTypeBtnCell(data)
            GUI:setTag(cell, type)
            GUI:ListView_pushBackCustomItem(typeList, cell)
            changeCellShow(cell, selected)

            GUI:addOnClickEvent(cell, function()
                GUI:delayTouchEnabled(cell)
                if Rank._rankType ~= type then
                    refreshTypeBtnShow(Rank._rankType, type)
                    Rank._rankType = type
                    Rank._typeConfig = data
        
                    -- 请求排行榜数据
                    SL:RequestRankData(Rank._rankType, Rank._selectType)
                end
            end)

            if not itemHei then
                itemHei = GUI:getContentSize(cell).height
            end
        end
        local listWid = GUI:getContentSize(btnListView).width
        local listHei = itemHei * #items
        GUI:setContentSize(typeList, listWid, listHei)
    end
end

function Rank.CreateListCell(parent, data)
    if SL:GetValue("IS_PC_OPER_MODE") then
        GUI:LoadExport(parent, "rank/rank_cell_win32")
    else
        GUI:LoadExport(parent, "rank/rank_cell")
    end

    local cell = GUI:getChildByName(parent, "Panel_cells")
    local ui = GUI:ui_delegate(cell)
    local rank = tonumber(data.rank) or 1
    if rank > 0 and rank <= 3 then
        GUI:setVisible(ui.Text_rank, false)
        GUI:setVisible(ui.Image_rank, true)
        GUI:Image_loadTexture(ui.Image_rank, Rank._path .. string.format("%s.png", 1900020024 + rank))
    else
        GUI:setVisible(ui.Text_rank, true)
        GUI:setVisible(ui.Panel_ranks, false)
        GUI:Text_setString(ui.Text_rank, rank == 0 and "未上榜" or rank)
    end
    -- 背景底图
    GUI:setVisible(ui.Image_bg, rank % 2 == 1)

    local value = data.Value
    local guildText = ui.Text_3
    if Rank._showLevel then
        guildText = ui.Text_4
        GUI:Text_setString(ui.Text_3, value and (value .. Rank.CheckSuffixDesc()) or "")
    end
    GUI:Text_setString(guildText, "")
    GUI:Text_setString(ui.Text_1, "")

    local guildScrollText = GUI:ScrollText_Create(guildText, "guildScrollText", 0, 0, 120, GUI:Text_getFontSize(guildText), GUI:Text_getTextColor(guildText) or "#ffffff", data.GuildName)
    GUI:setAnchorPoint(guildScrollText, 0.5, 0.5)
    local nameScrollText = GUI:ScrollText_Create(ui.Text_1, "nameScrollText", 0, 0, 120, GUI:Text_getFontSize(ui.Text_1), GUI:Text_getTextColor(ui.Text_1) or "#ffffff", data.Name)
    GUI:setAnchorPoint(nameScrollText, 0.5, 0.5)

    local function panelCB()
        Rank.ResetSelectItem(data)
    end
    GUI:addOnClickEvent(ui.Panel_touch, panelCB)

    return cell
end

function Rank.ResetSelectItem(data)
    if not data or not data.rank then
        return
    end
    local rk = tonumber(data.rank)

    if Rank._selectItemRk then
        SL:RequestNotifyClickRankValue(rk)
    end

    Rank._selectItemRk = rk

    local childs = GUI:ListView_getItems(Rank._rankList)
    for _, cell in ipairs(childs) do
        local idx = GUI:ListView_getItemIndex(Rank._rankList, cell)
        local ui = GUI:ui_delegate(cell)
        local chooseImg = ui.Image_select
        if chooseImg then
            GUI:setVisible(chooseImg, idx == rk - 1)
        end
        if idx == rk - 1 then
            SL:RequestPlayerRankData(data.UserID, Rank._selectType)
            Rank.SetChooseItemData(data)
        end
    end
end

function Rank.SetChooseItemData(data)
    Rank._chooseItemData = {}
    if data then
        Rank._chooseItemData = {
            rankType = Rank._rankType,
            selectType = Rank._selectType,
            data = data
        }
    end
end

function Rank.UpdateChooseModel(data)
    if Rank._chooseItemData and next(Rank._chooseItemData) then
        local rankType = Rank._chooseItemData.rankType
        local selectType = Rank._chooseItemData.selectType
        local chooseData = Rank._chooseItemData.data
        if rankType == Rank._rankType and selectType == Rank._selectType and chooseData.UserID == data.UserID then
            Rank.UpdateModel(data)
        end
    end
end

local fashionStdMode = {[66] = true, [67] = true, [68] = true, [69] = true}
local function isFashionEquip(item)
    if item and item.StdMode then
        if fashionStdMode[item.StdMode] then
            return true
        end
    end
    return false
end

function Rank.UpdateModel(looks)
    GUI:removeAllChildren(Rank._ui.Node_model)
    if Rank._selectItemRk and Rank._selectItemRk ~= 0 then
        local dataList = SL:GetValue("RANK_DATA_BY_TYPE", Rank._rankType, Rank._selectType)
        local rankData = dataList[Rank._selectItemRk]
        if rankData then
            local weaponIndex = (looks.weaponID and looks.weaponID > 0) and looks.weaponID or nil
            local helmetIndex = (looks.Helmet and looks.Helmet > 0) and looks.Helmet or nil
            local dressIndex = (looks.clothID and looks.clothID > 0) and looks.clothID or nil
            local capsIndex = (looks.Cap and looks.Cap > 0) and looks.Cap or nil
            local veilIndex = (looks.face and looks.face > 0) and looks.face or nil
            local shieldIndex = (looks.Shield and looks.Shield > 0) and looks.Shield or nil
            local weaponData = weaponIndex and SL:GetValue("ITEM_DATA", weaponIndex) or nil
            local helmetData = helmetIndex and SL:GetValue("ITEM_DATA", helmetIndex) or nil
            local dressData = dressIndex and SL:GetValue("ITEM_DATA", dressIndex) or nil
            local capData = capsIndex and SL:GetValue("ITEM_DATA", capsIndex) or nil
            local veilData = veilIndex and SL:GetValue("ITEM_DATA", veilIndex) or nil
            local shieldData = shieldIndex and SL:GetValue("ITEM_DATA", shieldIndex) or nil
            local sex = tonumber(rankData.Sex)
            local modelData = {}
            if isFashionEquip(dressData) then
                local fashionSwitch = SL:GetValue("GAME_DATA", "Fashionfx")
                local noShowNakedModel = fashionSwitch and tonumber(fashionSwitch) or 0
                modelData = {
                    clothID = dressData and dressData.Looks or nil,
                    clothEffectID = dressData and dressData.sEffect or nil,
                    weaponID = weaponData and weaponData.Looks or nil,
                    weaponEffectID = weaponData and weaponData.sEffect or nil,
                    showNodeModel = noShowNakedModel == 0,
                    showHair = noShowNakedModel == 0,
                }
            else
                modelData = {
                    clothID = dressData and dressData.Looks or nil,
                    clothEffectID = dressData and dressData.sEffect or nil,
                    weaponID = weaponData and weaponData.Looks or nil,
                    weaponEffectID = weaponData and weaponData.sEffect or nil,
                    headID = helmetData and helmetData.Looks or nil,
                    headEffectID = helmetData and helmetData.sEffect or nil,
                    hairID = looks.Hair,
                    capID = capData and capData.Looks or nil,
                    capEffectID = capData and capData.sEffect or nil,
                    veilID = veilData and veilData.Looks or nil,
                    veilEffectID = veilData and veilData.sEffect or nil,
                    shieldID = shieldData and shieldData.Looks or nil,
                    shieldEffectID = shieldData and shieldData.sEffect or nil,
                    showNodeModel = true,
                    showHair = true
                }
                if dressData and dressData.zblmtkz and tonumber(dressData.zblmtkz) == 1 then
                    modelData.showNodeModel = false
                    modelData.showHair = false
                end
            end
            -- 配置隐藏头盔斗笠显示
            if SL:GetValue("GAME_DATA", "hideRankHeadCapShow") == 1 then
                modelData.headID = nil
                modelData.headEffectID = nil
                modelData.capID = nil
                modelData.capEffectID = nil
            end

            local UIModel = GUI:UIModel_Create(Rank._ui.Node_model, "UIMODEL", 0, 0, sex, modelData, nil, true, tonumber(rankData.Job))
        end
    end
end


function Rank.RegisterEvent()
    -- 玩家个人数据刷新
    SL:RegisterLUAEvent(LUA_EVENT_RANK_PLAYER_UPDATE, "Rank", Rank.UpdateChooseModel, Rank._layer)
    -- 排行榜分类数据刷新
    SL:RegisterLUAEvent(LUA_EVENT_RANK_DATA_UPDATE, "Rank", Rank.UpdateRankUI, Rank._layer)
    -- 关闭界面监听
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Rank", Rank.OnClose)
end

function Rank.OnClose(id)
    if id ~= UIConst.LAYERID.RankGUI then
        return false
    end
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.Rank
    })
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Rank")
end

Rank.main()