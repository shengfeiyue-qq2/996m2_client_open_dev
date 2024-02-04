Rank = {}

local _RankType = {
    [1] = {
        [1] = 1,    -- 总榜 -- 玩家
        [2] = 2,    -- 战   -- 玩家
        [3] = 3,    -- 法   -- 玩家
        [4] = 4     -- 道   -- 玩家
    },
    [2] = {
        [1] = 6,    -- 总榜 -- 英雄
        [2] = 7,    -- 战   -- 英雄
        [3] = 8,    -- 法   -- 英雄
        [4] = 9     -- 道   -- 英雄
    }
}

local _DefaultRankType = 1  -- 默认是 1

function Rank.main( )
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "rank/rank")

    Rank._ui = GUI:ui_delegate(parent)
    if not Rank._ui then
        return false
    end
    Rank._parent = parent

    local PMainUI = Rank._ui["PMainUI"]
    GUI:Win_SetDrag(parent, PMainUI)
    GUI:setMouseEnabled(PMainUI, true)
    
    -- 关闭按钮
    GUI:addOnClickEvent(Rank._ui["CloseButton"], Rank.OnClose)

    -- 拖动层
    if SL:IsWinMode() then
        GUI:setVisible(Rank._ui["Layout"], false)
    else
        GUI:addOnClickEvent(Rank._ui["Layout"], Rank.OnClose)
        GUI:setVisible(Rank._ui["Layout"], true)
    end

    GUI:addOnClickEvent(Rank._ui["BtnLook"], Rank.OnLookPlayer)

    GUI:addOnClickEvent(Rank._ui["Page1"], function()
        Rank.PageTo(1)
    end)
    GUI:addOnClickEvent(Rank._ui["Page2"], function()
        Rank.PageTo(2)
    end)
    GUI:addOnClickEvent(Rank._ui["Page3"], function()
        Rank.PageTo(3)
    end)
    GUI:addOnClickEvent(Rank._ui["Page4"], function()
        Rank.PageTo(4)
    end)

    GUI:addOnClickEvent(Rank._ui["BtnPlayer"], function()
        Rank.ButtonTo(1)
    end)
    GUI:addOnClickEvent(Rank._ui["BtnHero"], function()
        Rank.ButtonTo(2)
    end)

    -- 注册事件
    Rank.RegistEvent()

    GUI:setVisible(Rank._ui["BtnHero"], true)
    GUI:setVisible(Rank._ui["BtnPlayer"], true)
    
    Rank._btnHero   = Rank._ui["BtnHero"]
    Rank._btnPlayer = Rank._ui["BtnPlayer"]

    Rank._SelUserID = nil
    Rank._SelType = 0
    Rank._SelPage = 0
    Rank._list = Rank._ui["ListView"]

    Rank.ButtonTo(1)
end

-- 注册事件
function Rank.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_RANK_UPDATE, "Rank", Rank.UpdateLayer)
    SL:RegisterLUAEvent(LUA_EVENT_RANK_UPDATE_MODEL, "Rank", Rank.UpdateChooseModel)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Rank", Rank.RemoveRegEvent)
end

function Rank.RemoveRegEvent(GUI)
    if GUI == "RankGUI" then
        Rank.UnRegisterEvent()
    end
end

-- 取消事件
function Rank.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_RANK_UPDATE, "Rank")
    SL:UnRegisterLUAEvent(LUA_EVENT_RANK_UPDATE_MODEL, "Rank")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Rank")
end

function Rank.ButtonTo(index)
    if Rank._SelType == index then
        return false
    end
    Rank._SelType = index

    if Rank._SelType == 1 then
        Rank.SetPageState(Rank._btnPlayer, true)
        Rank.SetPageState(Rank._btnHero, false)
    else
        Rank.SetPageState(Rank._btnPlayer, false)
        Rank.SetPageState(Rank._btnHero, true)
    end

    Rank.PageTo(1)
end

function Rank.PageTo(page)
    Rank._SelPage = page

    for i=1,4 do
        local upage = Rank._ui["Page"..i]
        if upage then
            Rank.SetPageState(upage, Rank._SelPage == i)
        end
    end
    Rank._SelUserID = nil

    Rank._ReqRankType = Rank.GetCurReqRankType()
    SL:RequestRankListData(Rank._ReqRankType)
end

function Rank.GetCurReqRankType()
    if _RankType[Rank._SelType] and _RankType[Rank._SelType][Rank._SelPage] then
        return _RankType[Rank._SelType][Rank._SelPage]
    end
    return _DefaultRankType
end

function Rank.SetPageState(button, isSel)
    if isSel then
        GUI:setTouchEnabled(button, false)
        GUI:Button_setBright(button, false)
        SL:SetColorStyle(GUI:getChildByName(button, "Text"), 1025)
    else
        GUI:setTouchEnabled(button, true)
        GUI:Button_setBright(button, true)
        SL:SetColorStyle(GUI:getChildByName(button, "Text"), 1026)
    end
end

function Rank.OnLookPlayer()
    if Rank._SelUserID then
        SL:CheckPlayerEquipInfo(Rank._SelUserID)
    end
end

function Rank.OnClose()
    SL:CloseRankUI()
end

function Rank.UpdateChooseModel(data)
    if Rank._SelUserID and Rank._SelUserID == data.UserID then
        Rank.UpdateModel(data)
    end
end

function Rank.UpdateLayer(rankType)
    if rankType and rankType == Rank._ReqRankType then
        local data = SL:GetRankDatas(rankType)
        Rank.SetMyRankInfo(data)
        Rank.UpdateRankList(data)
    end
end

function Rank.UpdateRankList(data)
    if GUI:Win_IsNull(Rank._list) then
        return false
    end

    GUI:stopAllActions(Rank._list)
    GUI:removeAllChildren(Rank._list)

    if not data or not next(data) then
        Rank._SelItemRank = 0
        Rank.UpdateModel()
        return false
    end

    Rank._Cells = {}
    for i, v in ipairs(data) do
        local quickCell = GUI:QuickCell_Create(Rank._list, "Cell" .. i, 0, 0, 451, 40, function(parent) return Rank.CreateCell(parent, v, i) end)
        Rank._Cells[i] = quickCell
    end
end

function Rank.CreateCell(parent, data, rank)
    GUI:LoadExport(parent, "rank/rank_cell")
    local ui = GUI:ui_delegate(parent)

    if rank > 3 then
        GUI:setVisible(ui.ImageRank, false)
        GUI:setVisible(ui.TRankBg, false)
        GUI:setVisible(ui.TextRank, true)
        GUI:Text_setString(ui.TextRank, rank)
    elseif rank > 0 then
        GUI:setVisible(ui.TextRank, false)
        GUI:setVisible(ui.ImageRank, true)
        GUI:setVisible(ui.TRankBg, true)
        local path = "res/private/rank_ui/rank_ui_mobile/" .. 1900020024 + rank .. ".png"
        GUI:Image_loadTexture(ui.ImageRank, path)
    else
        GUI:setVisible(ui.ImageRank, false)
        GUI:setVisible(ui.TRankBg, false)
        GUI:setVisible(ui.TextRank, true)
        GUI:Text_setString(ui.TextRank, "未上榜")
    end

    GUI:setVisible(ui.CellBg, rank % 2 == 1)

    local userID = data.UserID

    if Rank._SelUserID and Rank._SelUserID == userID then
        GUI:setVisible(ui.SelRankBg, true)
        SL:RequestPlayerShowData(Rank._SelUserID, Rank._SelType)
    elseif not Rank._SelUserID and rank == 1 then
        Rank._SelUserID = userID
        Rank._SelItemRank = 1
        GUI:setVisible(ui.SelRankBg, true)
        SL:RequestPlayerShowData(Rank._SelUserID, Rank._SelType)
    else
        GUI:setVisible(ui.SelRankBg, false)
    end

    -- 名字
    GUI:Text_setString(ui.TextName, data.Name)

    -- 等级
    GUI:Text_setString(ui.TextLevel, string.format("%s级", data.Level))

    -- 行会
    GUI:Text_setString(ui.TextGuildName, data.GuildName)

    local cell = ui.Cell
    GUI:addOnClickEvent(cell, function ()
        if userID and userID ~= Rank._SelUserID then        
            Rank._SelUserID = userID
            Rank._SelItemRank = rank
            Rank.RefreshCells(userID)
        end
    end)

    GUI:setVisible(cell, true)

    return cell
end

function Rank.RefreshCells(userID)
    for index, cell in ipairs(Rank._Cells) do
        if cell then
            GUI:QuickCell_Exit(cell)
            GUI:QuickCell_Refresh(cell)
        end
    end
end

function Rank.SetMyRankInfo(data)
    if not Rank._ui then
        return false
    end
    
    local myPlayerID = Rank._SelType == 2 and SL:GetMetaValue("H.USERID") or SL:GetMetaValue("USERID")
    local myRank, myGuildName = 0, ""
    for rank,v in ipairs(data or {}) do
        if v.UserID and v.UserID == myPlayerID then
            myRank, myGuildName = rank, v.GuildName
            break
        end
    end

    -- 我的排名
    local rankStr = myRank > 0 and string.format("第%d名", myRank) or "未上榜"
    GUI:Text_setString(Rank._ui["pRank"], rankStr)

    -- 我的行会
    local guildNameStr = string.len(myGuildName) > 0 and myGuildName or "无"
    GUI:Text_setString(Rank._ui["GuildName"], guildNameStr)
end

function Rank.IsFashionEquip(item)
    if item and item.StdMode then
        local fashionStdMode = {[66] = true, [67] = true, [68] = true, [69] = true}
        if fashionStdMode[item.StdMode] then
            return true
        end
    end
    return false
end

function Rank.UpdateModel(looks)
    if not Rank._ui then
        return false
    end
    
    local Node_model = Rank._ui["Node_model"]
    GUI:removeAllChildren(Node_model)

    if not (Rank._SelItemRank and Rank._SelItemRank ~= 0) then
        return false
    end

    local dataList = SL:GetRankDatas(Rank._ReqRankType)
    local rankData = dataList[Rank._SelItemRank]
    if not rankData then
        return false
    end

    local weaponIndex = (looks.weaponID and looks.weaponID > 0) and looks.weaponID      or nil
    local helmetIndex = (looks.Helmet   and looks.Helmet > 0)   and looks.Helmet        or nil
    local dressIndex  = (looks.clothID  and looks.clothID > 0)  and looks.clothID       or nil
    local capsIndex   = (looks.Cap      and looks.Cap > 0)      and looks.Cap           or nil
    local veilIndex   = (looks.face     and looks.face > 0)     and looks.face          or nil
    local shieldIndex = (looks.Shield   and looks.Shield > 0)   and looks.Shield        or nil
    local weaponData  = weaponIndex     and SL:GetMetaValue("ITEM_DATA", weaponIndex)   or nil
    local helmetData  = helmetIndex     and SL:GetMetaValue("ITEM_DATA", helmetIndex)   or nil
    local dressData   = dressIndex      and SL:GetMetaValue("ITEM_DATA", dressIndex)    or nil
    local capData     = capsIndex       and SL:GetMetaValue("ITEM_DATA", capsIndex)     or nil
    local veilData    = veilIndex       and SL:GetMetaValue("ITEM_DATA", veilIndex)     or nil
    local shieldData  = shieldIndex     and SL:GetMetaValue("ITEM_DATA", shieldIndex)   or nil
    local hairId      = looks.Hair
    local sex         = tonumber(looks.Sex)
    local noHead      = (weaponData and weaponData.show) or (dressData and dressData.show)
    local feature     = {}
    if Rank.IsFashionEquip(dressData) then
        local fashionSwitch = SL:GetMetaValue("GAME_DATA", "Fashionfx")
        local nodemodel = fashionSwitch and tonumber(fashionSwitch) or 0
        feature = {
            clothID         = dressData     and dressData.Looks     or nil,
            clothEffectID   = dressData     and dressData.sEffect   or nil,
            weaponID        = weaponData    and weaponData.Looks    or nil,
            weaponEffectID  = weaponData    and weaponData.sEffect  or nil,
            showNodeModel   = nodemodel ~= 1,
            showHair        = nodemodel ~= 1
        }
    else
        feature = {
            clothID         = dressData     and dressData.Looks     or nil,
            clothEffectID   = dressData     and dressData.sEffect   or nil,
            weaponID        = weaponData    and weaponData.Looks    or nil,
            weaponEffectID  = weaponData    and weaponData.sEffect  or nil,
            headID          = helmetData    and helmetData.Looks    or nil,
            headEffectID    = helmetData    and helmetData.sEffect  or nil,
            capID           = capData       and capData.Looks       or nil,
            capEffectID     = capData       and capData.sEffect     or nil,
            veilID          = veilData      and veilData.Looks      or nil,
            veilEffectID    = veilData      and veilData.sEffect    or nil,
            shieldID        = shieldData    and shieldData.Looks    or nil,
            shieldEffectID  = shieldData    and shieldData.sEffect  or nil,
            hairID          = hairId,
            noHead          = noHead
        }

        feature.showNodeModel = not (dressData and dressData.shonourSell and tonumber(dressData.shonourSell) == 1)
        feature.showHair = not (capData and capData.AniCount == 0)
    end
    GUI:UIModel_Create(Node_model, "UIMODEL", 0, 0, sex, feature, nil, true)
end