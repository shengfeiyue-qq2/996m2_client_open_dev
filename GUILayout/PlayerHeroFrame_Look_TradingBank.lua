-- 交易行查看他人面板 外框
PlayerHeroFrame_Look_TradingBank = {}
PlayerHeroFrame_Look_TradingBank._ui = nil

-- 页签ID
PlayerHeroFrame_Look_TradingBank._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG,   --背包
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_STORAGE --仓库
}
-- 打开页签
PlayerHeroFrame_Look_TradingBank.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI]  =  SL.OpenPlayerBaseAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO] =  SL.OpenPlayerExtraAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL]       =  SL.OpenPlayerSkillUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI
}
PlayerHeroFrame_Look_TradingBank.OpenType = {
    TradingBankPlayer = 21, --交易行人物
    TradingBankHero = 22, --交易行英雄
}

function PlayerHeroFrame_Look_TradingBank.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "tradingbank/trading_bank_player_frame")
    PlayerHeroFrame_Look_TradingBank._ui = GUI:ui_delegate(parent)
    PlayerHeroFrame_Look_TradingBank._parent = parent
    PlayerHeroFrame_Look_TradingBank._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerHeroFrame_Look_TradingBank._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    if not PlayerHeroFrame_Look_TradingBank._ui then
        return false
    end
    PlayerHeroFrame_Look_TradingBank._curIdx = 1 -- 当前状态  1 人物信息  2 背包   3 仓库
    PlayerHeroFrame_Look_TradingBank._ishero = false
    PlayerHeroFrame_Look_TradingBank._nodePanel = PlayerHeroFrame_Look_TradingBank._ui.Node_panel
    PlayerHeroFrame_Look_TradingBank.InitPageChangeBtn()
    for i = 1,3 do--人物  英雄 关闭
        local btn = PlayerHeroFrame_Look_TradingBank._ui["Button_"..i]
        if i == 2 then 
            if SL:GetMetaValue("TRADINGBANK_HAVEDATA_HERO") then--交易行查看他人是否有英雄数据 
                GUI:Button_setTitleText(btn,"英雄")
            else
                GUI:setVisible(btn, false)
            end
        end
        GUI:addOnClickEvent(btn,function()
            if i == 1 then
                PlayerHeroFrame_Look_TradingBank._curIdx = 1
                PlayerHeroFrame_Look_TradingBank.setButton(1)
                PlayerHeroFrame_Look_TradingBank.changeHeroAndRole()
                PlayerHeroFrame_Look_TradingBank.RefPanel()
                PlayerHeroFrame_Look_TradingBank.InitPage()
            elseif i == 2 then 
                PlayerHeroFrame_Look_TradingBank._curIdx = 1
                PlayerHeroFrame_Look_TradingBank.setButton(2)
                PlayerHeroFrame_Look_TradingBank.changeHeroAndRole()
                PlayerHeroFrame_Look_TradingBank.RefPanel()
                PlayerHeroFrame_Look_TradingBank.InitPage()
            else
                PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._pageid)
                SL:CloseTradingBankLookPanelUI()
                SL:CloseTradingBankLookInfoUI()
            end 
        end)
    end
    PlayerHeroFrame_Look_TradingBank.RegisterEvent()
    PlayerHeroFrame_Look_TradingBank._uid = data.role_id

    PlayerHeroFrame_Look_TradingBank.setButton(1,true)
    if  data.noClose then
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Button_4, false)
    end
    PlayerHeroFrame_Look_TradingBank.RefPanel()
    PlayerHeroFrame_Look_TradingBank.InitPage()
end

function PlayerHeroFrame_Look_TradingBank.InitPageChangeBtn()
    local btnList = PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList
    for i, id in ipairs(PlayerHeroFrame_Look_TradingBank._pageIDs) do
        local btnName = "Button_page" .. id
        local pageBtn = GUI:getChildByName(btnList, btnName)
        local textName = GUI:getChildByName(pageBtn, "Text_name")
        GUI:setLocalZOrder(pageBtn, PlayerHeroFrame_Look_TradingBank._pageid == id and 1 or 0)
        GUI:addOnClickEvent(pageBtn, function()
            if PlayerHeroFrame_Look_TradingBank._pageid == id then
                return
            end

            if PlayerHeroFrame_Look_TradingBank.doTrack then 
                PlayerHeroFrame_Look_TradingBank.doTrack(id, PlayerHeroFrame_Look_TradingBank._ishero)
            end

            if id == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG or id == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_STORAGE then 
                PlayerHeroFrame_Look_TradingBank._curIdx = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG == id and 2 or 3
                PlayerHeroFrame_Look_TradingBank.ChangePage({index = id })
            else 
                PlayerHeroFrame_Look_TradingBank._curIdx = 1
                PlayerHeroFrame_Look_TradingBank.OpenPage(id, {pageId = id})
            end
            PlayerHeroFrame_Look_TradingBank.RefPanel()
        end)
    end
end

function PlayerHeroFrame_Look_TradingBank.RefreshPlayerName()
    local Text_Name = PlayerHeroFrame_Look_TradingBank._ui.Text_Name
    local Name = SL:GetMetaValue("USER_NAME")
    GUI:Text_setString(Text_Name, Name)
    local color = SL:GetMetaValue("USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end
--初始化页签
function PlayerHeroFrame_Look_TradingBank.InitPage(  )
    PlayerHeroFrame_Look_TradingBank.ChangePage({index = SLDefine.MAIN_PLAYER_LAYER_EQUIP, init = true})
    PlayerHeroFrame_Look_TradingBank.OpenPage(SLDefine.MAIN_PLAYER_LAYER_EQUIP, {pageId = SLDefine.MAIN_PLAYER_LAYER_EQUIP, init = true})
end
--extent 1角色 和英雄信息 2 背包  3仓库
function PlayerHeroFrame_Look_TradingBank:RefPanel()
    if PlayerHeroFrame_Look_TradingBank._curIdx == 1 then 
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, false)
    else
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, true)
        GUI:stopAllActions(PlayerHeroFrame_Look_TradingBank._ui.ListView_1)
        GUI:ListView_removeAllItems(PlayerHeroFrame_Look_TradingBank._ui.ListView_1)

        local data
        if PlayerHeroFrame_Look_TradingBank._ishero then 
            if PlayerHeroFrame_Look_TradingBank._curIdx == 3 then 
                return 
            end
            data =  SL:GetMetaValue("TRADINGBANK_BAGDATA_HERO") 
        else
            if PlayerHeroFrame_Look_TradingBank._curIdx == 2 then 
                data = SL:GetMetaValue("TRADINGBANK_BAGDATA")
            else
                data = SL:GetMetaValue("TRADINGBANK_STOREDATA")
            end
        end
        local num = math.max(math.ceil(#data / 6), 8)
        local i = 1
        SL:schedule(PlayerHeroFrame_Look_TradingBank._ui.ListView_1,function()
            local Image_item = GUI:Image_Create(PlayerHeroFrame_Look_TradingBank._ui.ListView_1, "Image_item_"..i, 16.00, 425.00, "res/private/trading_bank/bg_jiaoyh_04.png")
            GUI:Image_setScale9Slice(Image_item, 125, 125, 21, 21)
            GUI:setContentSize(Image_item, 386, 60)
            GUI:setIgnoreContentAdaptWithSize(Image_item, false)
            GUI:setTouchEnabled(Image_item, false)
            GUI:setAnchorPoint(Image_item, 0.5, 0.5)
            for j = 1, 6 do
                local idx = (i - 1)* 6 + j
                local v = data[idx]
                if v then
                    local item = GUI:ItemShow_Create(Image_item, "Image_item_" .. j, (j - 1) * 64 + 32, 30, {index = v.Index, itemData = v, look = true,not_win32 = true})
                    GUI:setAnchorPoint(item, 0.5, 0.5)
                end
            end
            if i == num then
                GUI:stopAllActions(PlayerHeroFrame_Look_TradingBank._ui.ListView_1) 
            end
            i = i + 1

        end,1/60)
    end
end

function PlayerHeroFrame_Look_TradingBank.showHidePanel(idx)
    local lastidx = PlayerHeroFrame_Look_TradingBank._curIdx
    if idx  then 
        if idx == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG then 
            PlayerHeroFrame_Look_TradingBank._curIdx = 2
        else 
            PlayerHeroFrame_Look_TradingBank._curIdx = 3
        end
    else
        PlayerHeroFrame_Look_TradingBank._curIdx = 1
    end
    if lastidx ~= PlayerHeroFrame_Look_TradingBank._curIdx then 
        PlayerHeroFrame_Look_TradingBank.RefPanel(true)
    end
end

function PlayerHeroFrame_Look_TradingBank.setButton(index,init)
    for i = 1, 3 do
        local btn = PlayerHeroFrame_Look_TradingBank._ui["Button_"..i]
        GUI:setEnabled(btn,index ~= i)
    end
end

function PlayerHeroFrame_Look_TradingBank.changeHeroAndRole()
    if not (PlayerHeroFrame_Look_TradingBank._pageid == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG or PlayerHeroFrame_Look_TradingBank._pageid == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_STORAGE) then 
        PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._pageid)
    end
    if PlayerHeroFrame_Look_TradingBank._ishero then 
        PlayerHeroFrame_Look_TradingBank._ishero = false
    else
        PlayerHeroFrame_Look_TradingBank._ishero = true
    end
    local storageBtn =  GUI:getChildByName(PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList,"Button_page"..SLDefine.PlayerPage.MAIN_PLAYER_LAYER_STORAGE)
    if storageBtn then 
        GUI:setVisible(storageBtn, not PlayerHeroFrame_Look_TradingBank._ishero)
    end
end

function PlayerHeroFrame_Look_TradingBank.ShowPanel(t)--100背包  101仓库
    local pageKey = t.extent
    local isHero = t.isHero 
    if PlayerHeroFrame_Look_TradingBank.page == pageKey and PlayerHeroFrame_Look_TradingBank._ishero == isHero then
        return
    end

    if PlayerHeroFrame_Look_TradingBank._ishero ~= isHero then 
        PlayerHeroFrame_Look_TradingBank.changeHeroAndRole()
        PlayerHeroFrame_Look_TradingBank.RefPanel()
    end
    if pageKey == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG or pageKey == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_STORAGE then 
        PlayerHeroFrame_Look_TradingBank._curIdx = pageKey == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG and 2 or 3
        PlayerHeroFrame_Look_TradingBank.ChangePage({index = pageKey})
    else
        PlayerHeroFrame_Look_TradingBank._curIdx = 1
        PlayerHeroFrame_Look_TradingBank.OpenPage(pageKey, {pageId = pageKey})
    end
    PlayerHeroFrame_Look_TradingBank.RefPanel()
end

-- 切页
function PlayerHeroFrame_Look_TradingBank.ChangePage(data)
    PlayerHeroFrame_Look_TradingBank._lastPageid = PlayerHeroFrame_Look_TradingBank._pageid
    PlayerHeroFrame_Look_TradingBank._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    local btnList = PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList

    local btnLastPage = GUI:getChildByName(btnList, "Button_page" .. PlayerHeroFrame_Look_TradingBank._lastPageid)
    GUI:setLocalZOrder(btnLastPage, 0)
    GUI:setTouchEnabled(btnLastPage, true)
    GUI:Button_setBright(btnLastPage, true)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, "#807256")

    local btnNowPage = GUI:getChildByName(btnList, "Button_page" .. PlayerHeroFrame_Look_TradingBank._pageid)
    GUI:setLocalZOrder(btnNowPage, 1)
    GUI:setTouchEnabled(btnNowPage, false)
    GUI:Button_setBright(btnNowPage, false)
    local textNowName = GUI:getChildByName(btnNowPage, "Text_name")
    GUI:Text_setTextColor(textNowName, "#f8e6c6")

    if not data.init then
        PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._lastPageid)
    end

    PlayerHeroFrame_Look_TradingBank.CreateLayerPanelChild(data.child)
end

-- 添加子页面到外框
function PlayerHeroFrame_Look_TradingBank.CreateLayerPanelChild(panel)
    if panel then
        GUI:addChild(PlayerHeroFrame_Look_TradingBank._ui.Node_panel, panel)
    end
end

-- 切换子页面
function PlayerHeroFrame_Look_TradingBank.ChangeOpenedPage(id, data)
    PlayerHeroFrame_Look_TradingBank.OpenPage(id)
end

function PlayerHeroFrame_Look_TradingBank.CloseChildPanel(extent )
    if extent == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BAG or extent == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_STORAGE then 
        return 
    end 
    if PlayerHeroFrame_Look_TradingBank._ishero then 
        SL:CloseTradingBankHeroPageUI(extent)
    else
        SL:CloseTradingBankPlayerPageUI(extent)
    end
end
-- 关闭外框
function PlayerHeroFrame_Look_TradingBank.OnCloseMainLayer()
    PlayerHeroFrame_Look_TradingBank.UnRegisterEvent()
    PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._pageid)
end

-- 打开子页签
function PlayerHeroFrame_Look_TradingBank.OpenPage(LayerID, data)
    LayerID = LayerID or PlayerHeroFrame_Look_TradingBank._pageid
    local openFunc = PlayerHeroFrame_Look_TradingBank.OpenFunc[LayerID]
    local openType = PlayerHeroFrame_Look_TradingBank._ishero and  PlayerHeroFrame_Look_TradingBank.OpenType.TradingBankHero or PlayerHeroFrame_Look_TradingBank.OpenType.TradingBankPlayer
    if openFunc then
        openFunc(SL, openType, data)
    end
end

function PlayerHeroFrame_Look_TradingBank.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_TRAD_PLAYER_LOOK_FRAME_PAGE_ADD, "PlayerHeroFrame_Look_TradingBank", PlayerHeroFrame_Look_TradingBank.ChangePage)
    SL:RegisterLUAEvent(LUA_EVENT_TRAD_HERO_LOOK_FRAME_PAGE_ADD, "PlayerHeroFrame_Look_TradingBank", PlayerHeroFrame_Look_TradingBank.ChangePage)
end

function PlayerHeroFrame_Look_TradingBank.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TRAD_PLAYER_LOOK_FRAME_PAGE_ADD, "PlayerHeroFrame_Look_TradingBank")
    SL:UnRegisterLUAEvent(LUA_EVENT_TRAD_HERO_LOOK_FRAME_PAGE_ADD, "PlayerHeroFrame_Look_TradingBank")
end
