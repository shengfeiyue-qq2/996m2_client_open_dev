Stall = {}

function Stall.main(data)
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "stall/stall_layer_win32")
    else
        GUI:LoadExport(parent, "stall/stall_layer")
    end
    Stall._isWinMode = isWinMode

    -- 购买
    Stall._sell = data and data.buy or false

    Stall._ui = GUI:ui_delegate(parent)
    local winSizeW = SL:GetMetaValue("SCREEN_WIDTH")
    local winSizeH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(Stall._ui.PMainUI, isWinMode and SL:GetMetaValue("PC_POS_Y") or winSizeH / 2)

    GUI:Win_SetZPanel(parent, Stall._ui.PMainUI)
    GUI:Win_SetDrag(parent, Stall._ui.Image_move)

    -- 
    Stall._maxNum          = 20
    Stall._itemWid          = isWinMode and 40.5 or 62
    Stall._itemHei          = isWinMode and 42 or 64
    Stall._itemPanelWid     = isWinMode and 209 or 316
    Stall._itemPanelHei     = isWinMode and 168 or 256
    Stall._rowMaxItemNum    = 5
    
    Stall._selectTag        = nil

    GUI:setSwallowTouches(Stall._ui.Panel_addItem, false)
    GUI:setVisible(Stall._ui.Button_cancel, not Stall._sell)
    GUI:Button_setTitleText(Stall._ui.Button_do, Stall._sell and "购买" or "摆摊")
    GUI:Text_setString(Stall._ui.Text_titleName, Stall._sell and SL:GetMetaValue("SELL_SHOW_NAME") or "我的摊位")

    SL:SetMetaValue("STALL_SELECT_ID", nil)
    Stall.InitChooseTag()

end

function Stall.InitChooseTag()
    local chooseTag = GUI:Image_Create(Stall._ui.Panel_addItem, "chooseTag", 0, 0, "res/public/1900000678_1.png")
    GUI:setIgnoreContentAdaptWithSize(chooseTag, false)
    GUI:setAnchorPoint(chooseTag, 0.5, 0.5)
    GUI:Image_setScale9Slice(chooseTag, 20, 20, 20, 20)
    GUI:setContentSize(chooseTag, Stall._isWinMode and 48 or 66, Stall._isWinMode and 48 or 68)
    GUI:setVisible(chooseTag, false)
    Stall._selectTag = chooseTag
end

function Stall.RefreshChoosTag(index)
    if not index then
        GUI:Text_setString(Stall._ui.Text_price, "")
        GUI:Text_setString(Stall._ui.Text_itemName, "")
        if Stall._selectTag then
            GUI:setPosition(Stall._selectTag, 0, 0)
            GUI:setVisible(Stall._selectTag, false)
        end
        return
    end

    local itemData = Stall._sell and SL:GetMetaValue("ONSELL_DATA_BY_MAKEINDEX", index) or SL:GetMetaValue("MYSELL_DATA_BY_MAKEINDEX", index)
    if itemData then
        local price = tonumber(Stall._sell and itemData.Price or itemData.price) or 0
        local goldTypeName = SL:GetMetaValue("ITEM_NAME", itemData.goldtype)
        GUI:Text_setString(Stall._ui.Text_price, price .. goldTypeName)
        GUI:Text_setString(Stall._ui.Text_itemName, itemData.Name)
    end

    if not Stall._selectTag then
        return
    end

    local item = GUI:getChildByTag(Stall._ui.Panel_items, index)
    if item then
        local posX = GUI:getPositionX(item)
        local posY = GUI:getPositionY(item)
        GUI:setPosition(Stall._selectTag, posX, posY)
        GUI:setVisible(Stall._selectTag, true)
    else
        GUI:setPosition(Stall._selectTag, 0, 0)
        GUI:setVisible(Stall._selectTag, false)
    end
end

function Stall.RefreshStallName()
    GUI:Text_setString(Stall._ui.Text_titleName, Stall._sell and SL:GetMetaValue("SELL_SHOW_NAME") or "我的摊位")
end

function Stall.UpdateStallPanelInfo()
    Stall.RefreshChoosTag(nil)
    Stall.RefreshStallName()
    GUI:removeAllChildren(Stall._ui.Panel_items)

    local items = Stall._sell and SL:GetMetaValue("ONSELL_DATA") or SL:GetMetaValue("MYSELL_DATA")
    for k, data in ipairs(items) do
        if k > Stall._maxNum then
            return
        end

        local YPos = math.floor((k - 1) / Stall._rowMaxItemNum)
        local XPos = (k - 1) %  Stall._rowMaxItemNum
        local posX = XPos * (Stall._itemWid + 1.5) + Stall._itemWid / 2   -- 底图带框 适当偏移
        local posY = Stall._itemPanelHei - Stall._itemHei / 2 - Stall._itemHei * YPos
        local item = GUI:ItemShow_Create(Stall._ui.Panel_items, "Item_" .. data.MakeIndex, posX, posY, {
            itemData    = data,
            index       = data.Index,
            look        = true,
            movable     = not Stall._sell,
            from        = SL:GetMetaValue("ITEMFROMUI_ENUM").AUTO_TRADE
        })
        GUI:setAnchorPoint(item, 0.5, 0.5)
        GUI:setTag(item, data.MakeIndex)

        local function OnTouchEvent()
            local tipsPos = GUI:getWorldPosition(item)
            if not tipsPos or next(tipsPos) == nil then
                return
            end
            SL:OpenItemTips({
                itemData   = data,
                pos        = tipsPos,
                from       = SL:GetMetaValue("ITEMFROMUI_ENUM").AUTO_TRADE
            })
            SL:SetMetaValue("STALL_SELECT_ID", data.MakeIndex)
            Stall.RefreshChoosTag(data.MakeIndex)
        end
        GUI:addOnTouchEvent(item, OnTouchEvent)

        if Stall._isWinMode then
            local function mouseMoveCallBack()
                if item._movingState then
                    return
                end
                SL:OpenItemTips({
                    itemData   = data,
                    pos        = GUI:getWorldPosition(item),
                    from       = SL:GetMetaValue("ITEMFROMUI_ENUM").AUTO_TRADE
                })
            end

            local function leaveItem()
                SL:CloseItemTips()
            end

            GUI:addMouseMoveEvent(item, {
                onEnterFunc = mouseMoveCallBack,
                onLeaveFunc = leaveItem
            })
        end  
    end
end