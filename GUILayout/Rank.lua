Rank = {}

Rank._rankType = 1       -- 排行榜类型页签
Rank._showDataType = 1   -- 排行榜展示数据类型 （人物1-4 英雄6-9 总 战 法 道）
Rank._showLevel = false

Rank._path = "res/private/rank_ui/rank_ui_mobile/"

function Rank.main(type)
    local parent = GUI:Attach_Parent()
    if not parent then
        return
    end
    GUI:LoadExport(parent, "rank/rank")

    Rank._rankType = SL:GetL16Bit(type or 1)
    Rank._selectType = SL:GetH16Bit(type or 1) + 1
    Rank._selectItemRk = nil
    Rank._chooseItemData = {}

    Rank.UI = GUI:ui_delegate(parent)
    Rank._rankList = Rank.UI.ListView_list

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    -- 屏幕适配
    GUI:setPosition(Rank.UI.Panel_1, screenW / 2, screenH / 2)
    GUI:setContentSize(Rank.UI.CloseLayout, screenW, screenH)

    -- 关闭
    local function closeCB()
        SL:CloseRankUI()
    end
    GUI:addOnClickEvent(Rank.UI.CloseLayout, closeCB)
    GUI:addOnClickEvent(Rank.UI.Button_close, closeCB)

    -- 查看他人
    local function lookPlayerCB()
        local playerData = Rank._chooseItemData.data
        if playerData and next(playerData) then
            if playerData.UserID then
                SL:RequestLookPlayer(playerData.UserID, true)
            end
        end
    end
    GUI:addOnClickEvent(Rank.UI.Button_looks, lookPlayerCB)

    Rank._showLevel = SL:CheckCondition(SL:GetMetaValue("GAME_DATA", "rankshowlevel") or "")

    Rank.InitTypeBtn()

    -- 玩家个人数据刷新
    SL:RegisterLUAEvent(LUA_EVENT_RANK_PLAYER_UPDATE, "Rank", Rank.UpdateChooseModel)
    -- 排行榜分类数据刷新
    SL:RegisterLUAEvent(LUA_EVENT_RANK_DATA_UPDATE, "Rank", Rank.UpdateRankLayer)
    --
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Rank", Rank.RemoveEvent)
end

-- 注销事件
function Rank.RemoveEvent(ID)
    if ID ~= "RankGUI" then
        return false
    end
    SL:UnRegisterLUAEvent(LUA_EVENT_RANK_PLAYER_UPDATE, "Rank")
    SL:UnRegisterLUAEvent(LUA_EVENT_RANK_DATA_UPDATE, "Rank")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Rank")
end

function Rank.InitTypeBtn()
    if not SL:GetMetaValue("USEHERO") then
        GUI:setVisible(Rank.UI.Panel_type, false)
    end

    local isInitRequest = true

    local btnsName = {"Panel_player", "Panel_hero"}
    local function setTypeFunc(type, isInit)
        for i, v in ipairs(btnsName) do
            local panel = Rank.UI[v]
            GUI:Button_setBright(GUI:getChildByName(panel, "Button_" .. i), i ~= type)
            local titleText = GUI:getChildByName(panel, "Text_title" .. i)
            GUI:Text_setFontSize(titleText, 18)
            GUI:Text_setTextColor(titleText, i == type and "#f8e6c6" or "#6c6861")
            GUI:Text_enableOutline(titleText, "#111111", 2)
        end

        if not isInit and Rank._selectType == 2 and type == 1 then
            Rank._rankType = Rank._showDataType - 5
        end

        Rank._selectType = type
        local showDataType = isInit and Rank._rankType or (type == 2 and (Rank._rankType + 5) or Rank._rankType)
        if showDataType ~= Rank._showDataType then
            isInitRequest = false
            Rank._showDataType = showDataType
            -- 请求排行榜数据
            SL:RequestRankData(Rank._showDataType)
        end
        SL:ReqNotifyClickRankType(Rank._selectType)
    end

    for i, v in ipairs(btnsName) do
        local btn = GUI:getChildByName(Rank.UI[v], "Button_" .. i)
        GUI:addOnClickEvent(btn, function()
            setTypeFunc(i)
        end)
    end

    -- 1玩家 2英雄
    setTypeFunc(Rank._selectType or 1, true)

    -- 初始化请求
    if isInitRequest then
        SL:RequestRankData(Rank._showDataType)
    end
end

-- 刷新排行榜
function Rank.UpdateRankLayer(dataType)
    if dataType and dataType ~= Rank._showDataType then
        return
    end

    GUI:stopAllActions(Rank.UI.Panel_1)
    Rank.UpdateRankList()
end

function Rank.UpdateRankList()
    local data = SL:GetMetaValue("RANK_DATA_BY_TYPE", Rank._showDataType) or {}

    local myID = SL:GetMetaValue("USER_ID")
    if Rank._selectType == 2 then -- 英雄排行榜
        myID = SL:GetMetaValue("HERO_ID")
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
        GUI:QuickCell_Create(Rank._rankList, "rank" .. i, 0, 0, 451, 40, function(parent)
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
        GUI:Text_setString(Rank.UI.Text_level, rankStr)

        local guildStr = "无"
        if data.guildName and data.guildName ~= "" then
            guildStr = data.guildName
        end
        GUI:Text_setString(Rank.UI.Text_guildName, guildStr)
    end
end

function Rank.CheckLvDesc()
    local descConfig = SL:GetMetaValue("GAME_DATA", "RankDesc") 
    if not Rank._rankDesc and descConfig and string.len(descConfig) > 0 then
        descConfig = string.split(descConfig, "|")
        Rank._rankDesc = {}
        for _, config in ipairs(descConfig) do
            local t = string.split(config, "#")
            if tonumber(t[1]) and string.len(t[2]) > 0 then
                Rank._rankDesc[tonumber(t[1])] = t[2]
            end
        end
    end

    if Rank._rankDesc then
        return Rank._rankDesc[Rank._showDataType] or ""
    end
    return ""
end

function Rank.CreateListCell(parent, data)
    GUI:LoadExport(parent, "rank/rank_cell")

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

    local showLvStr = data.Value
    local guildText = ui.Text_3
    if Rank._showLevel then
        guildText = ui.Text_4
        GUI:Text_setString(ui.Text_3, showLvStr and (showLvStr .. Rank.CheckLvDesc()) or "")
    end
    GUI:Text_setString(guildText, data.GuildName)
    GUI:Text_setString(ui.Text_1, data.Name)

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
        SL:ReqNotifyClickRankValue(rk)
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
            Rank.SetChooseItemData(Rank._showDataType, data)
        end
    end
end

function Rank.SetChooseItemData(rankType, data)
    Rank._chooseItemData = {}
    if rankType and data then
        Rank._chooseItemData = {
            rankType = rankType,
            data = data
        }
    end
end

function Rank.UpdateChooseModel(data)
    if Rank._chooseItemData and next(Rank._chooseItemData) then
        local rankType = Rank._chooseItemData.rankType
        local chooseData = Rank._chooseItemData.data
        if rankType == Rank._showDataType and chooseData.UserID == data.UserID then
            Rank.UpdateModel(data)
        end
    end
end

local function IsFashionEquip(item)
    if item and item.StdMode then
        local fashionStdMode = {[66] = true, [67] = true, [68] = true, [69] = true}
        if fashionStdMode[item.StdMode] then
            return true
        end
    end
    return false
end

function Rank.UpdateModel(looks)
    GUI:removeAllChildren(Rank.UI.Node_model)
    if Rank._selectItemRk and Rank._selectItemRk ~= 0 then
        local dataList = SL:GetMetaValue("RANK_DATA_BY_TYPE", Rank._showDataType)
        local rankData = dataList[Rank._selectItemRk]
        if rankData then
            local weaponIndex = (looks.weaponID and looks.weaponID > 0) and looks.weaponID or nil
            local helmetIndex = (looks.Helmet and looks.Helmet > 0) and looks.Helmet or nil
            local dressIndex = (looks.clothID and looks.clothID > 0) and looks.clothID or nil
            local capsIndex = (looks.Cap and looks.Cap > 0) and looks.Cap or nil
            local veilIndex = (looks.face and looks.face > 0) and looks.face or nil
            local shieldIndex = (looks.Shield and looks.Shield > 0) and looks.Shield or nil
            local weaponData = weaponIndex and SL:GetMetaValue("ITEM_DATA", weaponIndex) or nil
            local helmetData = helmetIndex and SL:GetMetaValue("ITEM_DATA", helmetIndex) or nil
            local dressData = dressIndex and SL:GetMetaValue("ITEM_DATA", dressIndex) or nil
            local capData = capsIndex and SL:GetMetaValue("ITEM_DATA", capsIndex) or nil
            local veilData = veilIndex and SL:GetMetaValue("ITEM_DATA", veilIndex) or nil
            local shieldData = shieldIndex and SL:GetMetaValue("ITEM_DATA", shieldIndex) or nil
            local hairId = looks.Hair
            local sex = tonumber(looks.Sex)
            local noHead = (weaponData and weaponData.show) or (dressData and dressData.show)
            local modelData = {}
            if IsFashionEquip(dressData) then
                local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
                local show_naked_mold = fashionSwitch and tonumber(fashionSwitch) or 0
                modelData = {
                    clothID = dressData and dressData.Looks or nil,
                    clothEffectID = dressData and dressData.sEffect or nil,
                    weaponID = weaponData and weaponData.Looks or nil,
                    weaponEffectID = weaponData and weaponData.sEffect or nil,
                    notShowMold = show_naked_mold == 1,
                    notShowHair = show_naked_mold == 1
                }
            else
                modelData = {
                    clothID = dressData and dressData.Looks or nil,
                    clothEffectID = dressData and dressData.sEffect or nil,
                    weaponID = weaponData and weaponData.Looks or nil,
                    weaponEffectID = weaponData and weaponData.sEffect or nil,
                    headID = helmetData and helmetData.Looks or nil,
                    headEffectID = helmetData and helmetData.sEffect or nil,
                    hairID = hairId,
                    capID = capData and capData.Looks or nil,
                    capEffectID = capData and capData.sEffect or nil,
                    veilID = veilData and veilData.Looks or nil,
                    veilEffectID = veilData and veilData.sEffect or nil,
                    shieldID = shieldData and shieldData.Looks or nil,
                    shieldEffectID = shieldData and shieldData.sEffect or nil,
                    noHead = noHead
                }
                if dressData and dressData.shonourSell and tonumber(dressData.shonourSell) == 1 then
                    modelData.notShowMold = true
                    modelData.notShowHair = true
                end
            end
            -- 配置隐藏头盔斗笠显示
            if SL:GetMetaValue("GAME_DATA", "hideRankHeadCapShow") == 1 then
                modelData.headID = nil
                modelData.headEffectID = nil
                modelData.capID = nil
                modelData.capEffectID = nil
            end

            local UIModel = GUI:UIModel_Create(Rank.UI.Node_model, "UIMODEL", 0, 0, sex, modelData, nil, true, tonumber(looks.Job))
        end
    end
end
