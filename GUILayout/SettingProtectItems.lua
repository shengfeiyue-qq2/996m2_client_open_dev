SettingProtectItems = {}

function SettingProtectItems.main(parent, id)
    GUI:LoadExport(parent, "set/setting_protect_setting")
    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    SettingProtectItems._ui = ui
    SettingProtectItems._parent = parent

    SettingProtectItems._RankData = {}
    SettingProtectItems._selItem = nil
    SettingProtectItems._ProtectDataId = id

    GUI:addOnClickEvent(ui["Button_close"], function() SL:CloseProtectSettingUI() end)
    GUI:addOnClickEvent(ui["Panel_cancle"], function() SL:CloseProtectSettingUI() end)

    SettingProtectItems.InitUI()
end

function SettingProtectItems.InitUI()
    local ui = SettingProtectItems._ui
    local Panel_Size = GUI:getContentSize(ui.Panel_1)
    --调整一下位置
    local ScreenWidth  = SL:GetScreenWidth()
    local ScreenHeight = SL:GetScreenHeight()
    GUI:setPosition(ui.Panel_1, ScreenWidth - Panel_Size.width / 2 - 50, ScreenHeight / 2)

    local id = SettingProtectItems._ProtectDataId

    local cdCfg     = GUIShare.FindEatCDByIndex(id)
    local maxCD     = cdCfg.maxCD
    local minCD     = cdCfg.minCD
    local defaultCD = cdCfg.CD

    local values    = SL:GetSettingValue(id)
    local cdtime    = values[3] or defaultCD

    GUI:TextInput_setString(ui.TextField_input, cdtime)
    GUI:TextInput_setInputMode(ui.TextField_input, 2)
    GUI:Win_SetParam(ui.TextField_input, {_ID = id, _minCD = minCD, _maxCD = maxCD})
    GUI:TextInput_addOnEvent(ui.TextField_input, SettingProtectItems.onInputEvent)

    local contentSize = GUI:getContentSize(ui.ListView_1)



    local listWorldPos = GUI:getWorldPosition(ui.ListView_1)

    -- listview 对于Panel_touch的最大高度和最低高度
    SettingProtectItems._listViewYMin = GUI:convertToNodeSpace(ui.Panel_touch, 0, listWorldPos.y).y
    SettingProtectItems._listViewYMax = contentSize.height + SettingProtectItems._listViewYMin

    -- 数据
    SettingProtectItems._RankData = SL:GetProtectItems(id)
    for i, index in ipairs(SettingProtectItems._RankData) do
        SettingProtectItems.addItem(i, index)
    end

    SettingProtectItems._touchItem = nil
    SettingProtectItems._touchIndex = nil
    GUI:setSwallowTouches(ui.Panel_touch, false)
    GUI:addOnTouchEvent(ui.Panel_touch, function(sender, type)
        if type == GUIShare.TouchEventType.began then
            local beginPos = GUI:getTouchBeganPosition(sender)
            if SettingProtectItems._selItem then
                local worldpos = GUI:getWorldPosition(SettingProtectItems._selItem)
                local contentSize = GUI:getContentSize(SettingProtectItems._selItem)
                local Rect = GUI:Rect(worldpos.x, worldpos.y, contentSize.width, contentSize.height)
                if not GUI:RectContainsPoint(Rect, beginPos) then
                    local last_Image_sel = GUI:getChildByName(SettingProtectItems._selItem, "Image_sel")
                    GUI:setVisible(last_Image_sel, false)
                    SettingProtectItems._selItem = nil
                    ui.Panel_touch.clear = true
                else
                    GUI:setSwallowTouches(ui.Panel_touch, true)
                end
            end
        elseif type == GUIShare.TouchEventType.moved then
            if SettingProtectItems._selItem then
                local movePos = GUI:getTouchMovePosition(sender)
                if not SettingProtectItems._touchItem then
                    local order = SettingProtectItems._selItem.order
                    local index = SettingProtectItems._selItem.index
                    SettingProtectItems._touchItem = SettingProtectItems.createItem(ui.Panel_touch, order + 100000, index)
                    GUI:setAnchorPoint(SettingProtectItems._touchItem, 0.5, 0.5)
                    GUI:setTouchEnabled(SettingProtectItems._touchItem, false)
                    local name = SL:GetMetaValue("ITEM_NAME", index)--道具名字
                    local Text_name = GUI:getChildByName(SettingProtectItems._touchItem, "Text_name")
                    GUI:Text_setString(Text_name, name)
                    local Text_order = GUI:getChildByName(SettingProtectItems._touchItem, "Text_order")
                    GUI:Text_setString(Text_order, order)
                end
                if SettingProtectItems._touchItem then
                    local nodePos = GUI:convertToNodeSpace(ui.Panel_touch, movePos)
                    GUI:setPosition(SettingProtectItems._touchItem, nodePos)
                    if nodePos.y >= SettingProtectItems._listViewYMax then
                        local Topitem = GUI:ListView_getTopmostItemInCurrentView(ui.ListView_1)
                        local TopIndex = GUI:ListView_getItemIndex(ui.ListView_1, Topitem)
                        GUI:ListView_scrollToTop(ui.ListView_1, TopIndex / 10, false)
                    elseif nodePos.y <= SettingProtectItems._listViewYMin then
                        local Bottomitem = GUI:ListView_getBottommostItemInCurrentView(ui.ListView_1)
                        local BottomIndex = GUI:ListView_getItemIndex(ui.ListView_1, Bottomitem)
                        local items = GUI:ListView_getItems(ui.ListView_1)
                        local itemCount = #items
                        GUI:ListView_scrollToBottom(ui.ListView_1, (itemCount - BottomIndex) / 10, false)
                    end
                end
            end
        else
            GUI:setSwallowTouches(ui.Panel_touch, false)
            if not SettingProtectItems._selItem and not ui.Panel_touch.clear then
                local endPos = GUI:getTouchEndPosition(sender)
                local beginPos = GUI:getTouchBeganPosition(sender)

                local items = GUI:ListView_getItems(ui.ListView_1)
                for i, item in ipairs(items) do
                    local worldpos = GUI:getWorldPosition(item)
                    local contentSize = GUI:getContentSize(item)
                    local Rect = GUI:Rect(worldpos.x, worldpos.y, contentSize.width, contentSize.height)
                    if GUI:RectContainsPoint(Rect, endPos) and GUI:RectContainsPoint(Rect, beginPos) then
                        local last_Image_sel = GUI:getChildByName(item, "Image_sel")
                        GUI:setVisible(last_Image_sel, true)
                        SettingProtectItems._selItem = item

                    end
                end
            end
            ui.Panel_touch.clear = false
            if SettingProtectItems._touchItem then
                GUI:removeFromParent(SettingProtectItems._touchItem)
                SettingProtectItems._touchItem = nil
                local endPos = GUI:getTouchEndPosition(sender)
                local items = GUI:ListView_getItems(ui.ListView_1)
                for i, item in ipairs(items) do
                    local bottomPos = GUI:getWorldPosition(item)
                    local contentSize = GUI:getContentSize(item)
                    if endPos.y >= bottomPos.y and endPos.y <= bottomPos.y + contentSize.height then
                        if endPos.y <= bottomPos.y + contentSize.height / 2 then
                            SettingProtectItems.updateItemsByIndex(i)
                        else
                            SettingProtectItems.updateItemsByIndex(i - 1)
                        end
                        break
                    end
                end
            end
        end
    end)
end

function SettingProtectItems.createItem(parent, order, index)
    -- Create Panel_item
    local Panel_item = GUI:Layout_Create(parent, "Panel_item_" .. order, 11, 185, 314, 43, false)
    GUI:setTouchEnabled(Panel_item, true)

    -- Create Image_1
    local Image_1 = GUI:Image_Create(Panel_item, "Image_1", 0, 2, "res/public/bg_yyxsz_01.png")
    GUI:Image_setScale9Slice(Image_1, 242, 240, 0, 0)
    GUI:setContentSize(Image_1, 312, 2)
    GUI:setIgnoreContentAdaptWithSize(Image_1, false)
    GUI:setAnchorPoint(Image_1, 0, 0.5)
    GUI:setTouchEnabled(Image_1, false)

    -- Create Image_sel
    local Image_sel = GUI:Image_Create(Panel_item, "Image_sel", -2, 23, "res/private/setting/btnbg.png")
    GUI:Image_setScale9Slice(Image_sel, 33, 33, 10, 8)
    GUI:setContentSize(Image_sel, 314, 46)
    GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
    GUI:setAnchorPoint(Image_sel, 0, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    -- Create Text_order
    local Text_order = GUI:Text_Create(Panel_item, "Text_order", 51, 23, 20, "#ffffff", [[1]])
    GUI:setAnchorPoint(Text_order, 0.5, 0.5)
    GUI:setTouchEnabled(Text_order, false)
    GUI:Text_enableOutline(Text_order, "#000000", 1)

    -- Create Text_name
    local Text_name = GUI:Text_Create(Panel_item, "Text_name", 200, 23, 18, "#ffffff", [[回城石]])
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
    GUI:setTouchEnabled(Text_name, false)
    GUI:Text_enableOutline(Text_name, "#000000", 1)

    return Panel_item
end

function SettingProtectItems.addItem(order, index)
    local ui = SettingProtectItems._ui
    local item = SettingProtectItems.createItem(ui.ListView_1, order, index)
    item.index = index
    item.order = order

    local cell = GUI:ui_delegate(item)
    GUI:Text_setString(cell.Text_order, order)
    GUI:setVisible(cell.Image_sel, false)

    -- 道具名字
    local name = SL:GetMetaValue("ITEM_NAME", index)
    GUI:Text_setString(cell.Text_name, name)
end

function SettingProtectItems.updateItemsByIndex(index)
    if not SettingProtectItems._selItem then
        return
    end
    local ui = SettingProtectItems._ui
    local idx = GUI:ListView_getItemIndex(ui.ListView_1, SettingProtectItems._selItem)
    if idx < index then
        index = index - 1
    end
    GUI:Retain(SettingProtectItems._selItem)--引用加一  不会在移除的时候被释放
    GUI:ListView_removeItemByIndex(ui.ListView_1, idx)--在原来的位置移除
    GUI:ListView_insertCustomItem(ui.ListView_1, SettingProtectItems._selItem, index)--插入新位置
    GUI:Release(SettingProtectItems._selItem)--引用减一 
    GUI:ListView_jumpToItem(ui.ListView_1, index, GUI:p(0, 0), GUI:p(0, 0))
    SettingProtectItems._RankData = {}
    local items = GUI:ListView_getItems(ui.ListView_1)
    for i, item in ipairs(items) do
        local Text_order = GUI:getChildByName(item, "Text_order")
        GUI:Text_setString(Text_order, i)
        item.order = i
        table.insert(SettingProtectItems._RankData, item.index)
    end
    SL:SetProtectItems(SettingProtectItems._ProtectDataId, SettingProtectItems._RankData)
end

-- 输入框事件
function SettingProtectItems.onInputEvent(sender, eventType)
    local param = GUI:Win_GetParam(sender)
    if eventType == 1 then
        local input = GUI:TextInput_getString(sender)
        local input_value = math.min(math.max(tonumber(input) or 1, param._minCD), param._maxCD)
        GUI:TextInput_setString(sender, input_value)
        SL:SetSettingValue(param._ID, {nil, nil, input_value})
    end
end