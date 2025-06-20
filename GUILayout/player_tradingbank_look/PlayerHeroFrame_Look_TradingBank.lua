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
}

PlayerHeroFrame_Look_TradingBank.OpenType = {
    Actor = 1, --角色/英雄信息
    Bag = 2, --背包
    Storage = 3 --仓库
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
    for i = 1, 3 do--人物  英雄 关闭
        local btn = PlayerHeroFrame_Look_TradingBank._ui["Button_"..i]
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
            else
                UIOperator:CloseTradePlyerUI()
                SL:CloseTradingBankLookInfoUI()
                if  PlayerHeroFrame_Look_TradingBank._parent and not GUI:Widget_IsNull(PlayerHeroFrame_Look_TradingBank._parent) then
                    GUI:removeAllChildren(PlayerHeroFrame_Look_TradingBank._parent)
                end
            end 
        end)
    end

    PlayerHeroFrame_Look_TradingBank.SetButton(PlayerHeroFrame_Look_TradingBank.OpenPlayerType.Player)
    PlayerHeroFrame_Look_TradingBank.RefPanel()
    PlayerHeroFrame_Look_TradingBank.AddChildPanel(SLDefine.TradingBankPlayerPages.Equip)
    if data.noClose then
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Button_4, false)
    end

    if data.position then
        GUI:setPosition(PlayerHeroFrame_Look_TradingBank._ui.Panel_1, data.position)
    end

    PlayerHeroFrame_Look_TradingBank.RegisterEvent()
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

-- 1角色 和英雄信息 2 背包  3仓库
function PlayerHeroFrame_Look_TradingBank:RefPanel()
    if PlayerHeroFrame_Look_TradingBank._openType == PlayerHeroFrame_Look_TradingBank.OpenType.Actor then 
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, false)
    else
        GUI:setVisible(PlayerHeroFrame_Look_TradingBank._ui.Image_bg2, true)
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
    for i = 1, 3 do
        local btn = PlayerHeroFrame_Look_TradingBank._ui["Button_"..i]
        GUI:setEnabled(btn, index ~= i)
    end
end

function PlayerHeroFrame_Look_TradingBank.ChangePlayerType(type)
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
    GUI:removeAllChildren(PlayerHeroFrame_Look_TradingBank._ui.Node_panel)
    local type = PlayerHeroFrame_Look_TradingBank._ishero and GUIDefine.RoleUIType.TRADE_HERO or GUIDefine.RoleUIType.TRADE_PLAYER
    PlayerHeroFrame_Look_TradingBank.ChildsUICfgs[page].Close(type)
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