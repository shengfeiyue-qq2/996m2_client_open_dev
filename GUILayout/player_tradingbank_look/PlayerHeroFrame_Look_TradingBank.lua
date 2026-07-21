-- 交易行查看他人面板 外框
PlayerHeroFrame_Look_TradingBank = {}
PlayerHeroFrame_Look_TradingBank._ui = nil
-- 子页签
PlayerHeroFrame_Look_TradingBank.ChildsUICfgs = {
    {Open = handler(UIOperator, UIOperator.OpenRoleEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleEquipUI)},
    {Open = handler(UIOperator, UIOperator.OpenRoleBaseAttUI), Close = handler(UIOperator, UIOperator.CloseRoleBaseAttUI)},
    {Open = handler(UIOperator, UIOperator.OpenRoleExtraAttUI), Close = handler(UIOperator, UIOperator.CloseRoleExtraAttUI)},
    {Open = handler(UIOperator, UIOperator.OpenRoleSkillUI), Close = handler(UIOperator, UIOperator.CloseRoleSkillUI)},
    {Open = handler(UIOperator, UIOperator.OpenRoleTitleUI),  Close = handler(UIOperator, UIOperator.CloseRoleTitleUI)},
    {Open = handler(UIOperator, UIOperator.OpenRoleSuperEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleSuperEquipUI)},
    {Open = handler(UIOperator, UIOperator.OpenRoleBuffUI), Close = handler(UIOperator, UIOperator.CloseRoleBuffUI)}
}

PlayerHeroFrame_Look_TradingBank.OpenPlayerType = {
    Player = 1, --交易行人物
    Hero = 2, --交易行英雄
    Money = 4, --交易行货币
}

PlayerHeroFrame_Look_TradingBank.OpenType = {
    Actor = 1, --角色/英雄信息
    Bag = 2, --背包
    Storage = 3, --仓库
    Money = 4 --货币
}

function PlayerHeroFrame_Look_TradingBank.main()
    local data = GUI:GetLayerOpenParam()
    local parent = data and data.parent
    PlayerHeroFrame_Look_TradingBank._page = data and data.page or SLDefine.TradingBankPlayerPages.Equip
    PlayerHeroFrame_Look_TradingBank._uid = data and data.role_id

    GUI:LoadExport(parent, "tradingbank/trading_bank_player_frame")
    PlayerHeroFrame_Look_TradingBank._ui = GUI:ui_delegate(parent)
    PlayerHeroFrame_Look_TradingBank._parent = parent
    PlayerHeroFrame_Look_TradingBank._openType = PlayerHeroFrame_Look_TradingBank.OpenType.Actor 
    PlayerHeroFrame_Look_TradingBank._ishero = false
    PlayerHeroFrame_Look_TradingBank.InitPageBtns()
    for i = 1, 4 do--人物  英雄 关闭 货币
        local btn = PlayerHeroFrame_Look_TradingBank._ui["Button_"..i]
        if btn then 
            if i == PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Hero then 
                if TradingBankLookPlayerData.GetHasHeroData() then--交易行查看他人是否有英雄数据 
                    GUI:Button_setTitleText(btn,"英雄")
                else
                    GUI:setVisible(btn, false)
                end
            end
            GUI:addOnClickEvent(btn,function()
                if i == PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Player then
                    PlayerHeroFrame_Look_TradingBank.SetButton(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Player)
                    PlayerHeroFrame_Look_TradingBank.ChangePlayerType(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Player)
                elseif i == PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Hero then 
                    PlayerHeroFrame_Look_TradingBank.SetButton(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Hero)
                    PlayerHeroFrame_Look_TradingBank.ChangePlayerType(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Hero)
                elseif i == PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Money then 
                    PlayerHeroFrame_Look_TradingBank.SetButton(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Money)
                    PlayerHeroFrame_Look_TradingBank.ChangePlayerType(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Money)
                else
                    UIOperator:CloseTradePlyerUI()
                    SL:CloseTradingBankLookInfoUI()
                    if  PlayerHeroFrame_Look_TradingBank._parent and not GUI:Widget_IsNull(PlayerHeroFrame_Look_TradingBank._parent) then
                        GUI:removeAllChildren(PlayerHeroFrame_Look_TradingBank._parent)
                    end
                end 
            end)
        end
    end

    PlayerHeroFrame_Look_TradingBank.SetButton(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Player)
    PlayerHeroFrame_Look_TradingBank.RefPanel()
    PlayerHeroFrame_Look_TradingBank.AddChildPanel(SLDefine.TradingBankPlayerPages.Equip)

    if data.position then
        GUI:setPosition(PlayerHeroFrame_Look_TradingBank._ui.Panel_1, data.position)
    end

    PlayerHeroFrame_Look_TradingBank.RegisterEvent()

     --货币
    PlayerHeroFrame_Look_TradingBank.listData = {}
    PlayerHeroFrame_Look_TradingBank._index = 0--添加的属性条编号
    local datalist = PlayerHeroFrame_Look_TradingBank.getAttSellShowMoneyList()
    local tradingShowMoneyList = nil
    if TradingBankLookPlayerData.getSellShowMoneyList then
        tradingShowMoneyList = TradingBankLookPlayerData.getSellShowMoneyList()
    end
    if datalist and next(datalist) and tradingShowMoneyList and next(tradingShowMoneyList) then
        for _, pair in ipairs(tradingShowMoneyList) do
            local key = pair["ID"] or nil
            local value = pair["Count"] or nil
            if key and value then
                for _, pair2 in ipairs(datalist) do
                    local key2 = pair2["ID"] or nil
                    local value2 = pair2["Count"] or nil
                    if key2 and value2 then
                        if key == key2 then
                            if PlayerHeroFrame_Look_TradingBank._ui.Button_4 then
                                GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Button_4, true)
                                GUI:setTouchEnabled(PlayerHeroFrame_Look_TradingBank._ui.Button_4, true)
                                GUI:Button_setTitleText(PlayerHeroFrame_Look_TradingBank._ui.Button_4, "货币")
                                local data = {
                                        str = value2,
                                        strValue = value
                                    }
                                table.insert(PlayerHeroFrame_Look_TradingBank.listData, data)
                                break
                            end
                            
                        end
                    end
                end
            end
        end
    end
end

function PlayerHeroFrame_Look_TradingBank.InitPageBtns()
    local btnList = PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList
    for key, page in pairs(SLDefine.TradingBankPlayerPages) do
        local btnName = "Button_page" .. page
        local pageBtn = GUI:getChildByName(btnList, btnName)
        local textName = GUI:getChildByName(pageBtn, "Text_name")
        GUI:setLocalZOrder(pageBtn, PlayerHeroFrame_Look_TradingBank._page == page and 1 or 0)
        GUI:addOnClickEvent(pageBtn, function()
            if PlayerHeroFrame_Look_TradingBank._page == page then
                return
            end
            PlayerHeroFrame_Look_TradingBank.RefPageButton(PlayerHeroFrame_Look_TradingBank._page, false)
            PlayerHeroFrame_Look_TradingBank.RefPageButton(page, true)
            if page == SLDefine.TradingBankPlayerPages.Bag or page == SLDefine.TradingBankPlayerPages.Storage then 
                PlayerHeroFrame_Look_TradingBank._openType = SLDefine.TradingBankPlayerPages.Bag == page and PlayerHeroFrame_Look_TradingBank.OpenType.Bag or PlayerHeroFrame_Look_TradingBank.OpenType.Storage
                PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._page)
                
            else 
                PlayerHeroFrame_Look_TradingBank._openType = PlayerHeroFrame_Look_TradingBank.OpenType.Actor
                PlayerHeroFrame_Look_TradingBank.ChangePage(page)
            end
            PlayerHeroFrame_Look_TradingBank.RefPanel()
            PlayerHeroFrame_Look_TradingBank._page = page
        end)
    end
    PlayerHeroFrame_Look_TradingBank.RefPageButton(PlayerHeroFrame_Look_TradingBank._page, true)
end

function PlayerHeroFrame_Look_TradingBank.RefreshPlayerName()
    local Text_Name = PlayerHeroFrame_Look_TradingBank._ui.Text_Name
    local Name = SL:GetValue("USER_NAME")
    GUI:Text_setString(Text_Name, Name)
    local color = SL:GetValue("USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end


-- 1角色 和英雄信息 2 背包  3仓库 4货币
function PlayerHeroFrame_Look_TradingBank:RefPanel()
    if PlayerHeroFrame_Look_TradingBank._openType == PlayerHeroFrame_Look_TradingBank.OpenType.Actor then 
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, false)
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList, true)
    elseif PlayerHeroFrame_Look_TradingBank._openType == PlayerHeroFrame_Look_TradingBank.OpenType.Money then
        -- 货币页签
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, true)
        GUI:stopAllActions(PlayerHeroFrame_Look_TradingBank._ui.ListView_1)
        GUI:ListView_removeAllItems(PlayerHeroFrame_Look_TradingBank._ui.ListView_1)
        GUI:removeAllChildren(PlayerHeroFrame_Look_TradingBank._ui.Node_panel)

        -- 隐藏左侧页签按钮
        local btnList = PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList
        GUI:setVisible(btnList, false)

        for _, moneyItem in ipairs(PlayerHeroFrame_Look_TradingBank.listData or {}) do
            PlayerHeroFrame_Look_TradingBank._index = PlayerHeroFrame_Look_TradingBank._index + 1
            local widget = GUI:Widget_Create(PlayerHeroFrame_Look_TradingBank._ui.ListView_1, "MoneyItem_"..PlayerHeroFrame_Look_TradingBank._index, 0, 0, 348, 27)
            GUI:LoadExport(widget, "player_look_tradingbank/trading_money_show_list")
            local itemUi = GUI:ui_delegate(widget)
            if moneyItem.str then
                GUI:Text_setString(itemUi.Text_attName, moneyItem.str .. "：")
            end
            if moneyItem.strValue then
                GUI:Text_setString(itemUi.Text_attValue, tostring(moneyItem.strValue))
            end
        end
    else
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, true)
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList, true)
        GUI:stopAllActions(PlayerHeroFrame_Look_TradingBank._ui.ListView_1)
        GUI:ListView_removeAllItems(PlayerHeroFrame_Look_TradingBank._ui.ListView_1)

        local data = {}
        if PlayerHeroFrame_Look_TradingBank._ishero then 
            if PlayerHeroFrame_Look_TradingBank._openType == PlayerHeroFrame_Look_TradingBank.OpenType.Storage then 
                return 
            end
            data = TradingBankLookPlayerData.GetHeroBagData()
        else
            if PlayerHeroFrame_Look_TradingBank._openType == PlayerHeroFrame_Look_TradingBank.OpenType.Bag then 
                data = TradingBankLookPlayerData.GetBagData()
            else
                data = TradingBankLookPlayerData.GetStoreData()
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

        end, 1/60)
    end
end

function PlayerHeroFrame_Look_TradingBank.SetButton(index)
    for i = 1, 4 do
        local btn = PlayerHeroFrame_Look_TradingBank._ui["Button_"..i]
        if btn then
            GUI:setEnabled(btn, index ~= i)
        end
    end
end

function PlayerHeroFrame_Look_TradingBank.ChangePlayerType(type)
    if type == PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Money then
        -- 货币页签：隐藏子页签面板，显示货币列表
        PlayerHeroFrame_Look_TradingBank._openType = PlayerHeroFrame_Look_TradingBank.OpenType.Money
        PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._page)
        PlayerHeroFrame_Look_TradingBank.RefPanel()
        return
    end
    PlayerHeroFrame_Look_TradingBank._openType = PlayerHeroFrame_Look_TradingBank.OpenType.Actor
    PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._page)
    PlayerHeroFrame_Look_TradingBank._ishero = type == PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Hero
    PlayerHeroFrame_Look_TradingBank.AddChildPanel(SLDefine.TradingBankPlayerPages.Equip)
    PlayerHeroFrame_Look_TradingBank.RefPanel()
    if PlayerHeroFrame_Look_TradingBank._page ~= SLDefine.TradingBankPlayerPages.Equip then
        PlayerHeroFrame_Look_TradingBank.RefPageButton(PlayerHeroFrame_Look_TradingBank._page, false)
        PlayerHeroFrame_Look_TradingBank.RefPageButton(SLDefine.TradingBankPlayerPages.Equip, true)
        PlayerHeroFrame_Look_TradingBank._page = SLDefine.TradingBankPlayerPages.Equip
    end
    
    
    local storageBtn =  GUI:getChildByName(PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList, "Button_page"..SLDefine.TradingBankPlayerPages.Storage)
    if storageBtn then 
        GUI:setVisible(storageBtn, not PlayerHeroFrame_Look_TradingBank._ishero)
    end
end

-- 切页
function PlayerHeroFrame_Look_TradingBank.ChangePage(page)
    PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._page)
    PlayerHeroFrame_Look_TradingBank.AddChildPanel(page)
end

function PlayerHeroFrame_Look_TradingBank.RefPageButton(page, select)
    local btnList = PlayerHeroFrame_Look_TradingBank._ui.Panel_btnList
    local btnLastPage = GUI:getChildByName(btnList, "Button_page" .. page)
    GUI:setLocalZOrder(btnLastPage, select and 1 or 0)
    GUI:setTouchEnabled(btnLastPage, not select)
    GUI:Button_setBright(btnLastPage, not select)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, select and "#f8e6c6" or "#807256")
end

-- 打开子页签
function PlayerHeroFrame_Look_TradingBank.AddChildPanel(page)
    local parent = PlayerHeroFrame_Look_TradingBank._ui.Node_panel
    local type = PlayerHeroFrame_Look_TradingBank._ishero and GUIDefine.RoleUIType.TRADE_HERO or GUIDefine.RoleUIType.TRADE_PLAYER
    PlayerHeroFrame_Look_TradingBank.ChildsUICfgs[page].Open(type, parent)
end

function PlayerHeroFrame_Look_TradingBank.CloseChildPanel(page)
    if page == SLDefine.TradingBankPlayerPages.Bag or page == SLDefine.TradingBankPlayerPages.Storage then 
        return 
    end
    if PlayerHeroFrame_Look_TradingBank._openType == PlayerHeroFrame_Look_TradingBank.OpenType.Money then
        return
    end 
    GUI:removeAllChildren(PlayerHeroFrame_Look_TradingBank._ui.Node_panel)
    local type = PlayerHeroFrame_Look_TradingBank._ishero and GUIDefine.RoleUIType.TRADE_HERO or GUIDefine.RoleUIType.TRADE_PLAYER
    PlayerHeroFrame_Look_TradingBank.ChildsUICfgs[page].Close(type)
end

function PlayerHeroFrame_Look_TradingBank.getAttSellShowMoneyList()
    local BoxSellShowMoneyList = {}
    local showMoneyList = SL:GetMetaValue("GAME_DATA", "BoxSellShowMoney")
    if showMoneyList then
        local slices = string.split(showMoneyList, "|")
        for i, slice in ipairs(slices) do
            local slice2 = string.split(slice, "#")
            if not BoxSellShowMoneyList[i] then
                BoxSellShowMoneyList[i] = {}
            end
            local sl1 = slice2[1] or nil
            local sl2 = slice2[2] or nil
            local data = {}
            data["ID"] = sl1
            data["Count"] = sl2
            BoxSellShowMoneyList[i] = data
        end
    end
    return BoxSellShowMoneyList
end

-- 关闭外框
function PlayerHeroFrame_Look_TradingBank.OnCloseMainLayer()
    PlayerHeroFrame_Look_TradingBank.CloseChildPanel(PlayerHeroFrame_Look_TradingBank._page)
    PlayerHeroFrame_Look_TradingBank.UnRegisterEvent()
end

function PlayerHeroFrame_Look_TradingBank.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TRADE_BANK_PLAYER_FRAME_CLOSE, "PlayerHeroFrame_Look_TradingBank", PlayerHeroFrame_Look_TradingBank.OnCloseMainLayer)
end

function PlayerHeroFrame_Look_TradingBank.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TRADE_BANK_PLAYER_FRAME_CLOSE, "PlayerHeroFrame_Look_TradingBank")
end

PlayerHeroFrame_Look_TradingBank.main()