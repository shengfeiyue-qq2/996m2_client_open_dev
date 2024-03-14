SettingProtectSetting = {}

function SettingProtectSetting.main(parent, data)
    GUI:LoadExport(parent, "set/setting_protect_setting")
    SettingProtectSetting._ui = GUI:ui_delegate(parent)
    SettingProtectSetting._parent = parent
    if not SettingProtectSetting._ui then
        return false
    end

    SettingProtectSetting._RankData = {}
    SettingProtectSetting._selItem = nil
    SettingProtectSetting.InitUI(data)
end

function SettingProtectSetting.InitUI(data)
    local ui = SettingProtectSetting._ui
    local Panel_Size = GUI:getContentSize(ui.Panel_1)
    --调整一下位置
    local ScreenWidth = SL:GetMetaValue("SCREEN_WIDTH")
    local ScreenHeight = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or ScreenHeight / 2
    GUI:setPosition(ui.Panel_1, ScreenWidth/2 + Panel_Size.width / 2 + 100, posY)

    GUI:TextInput_setInputMode(ui.TextField_input, 2)
    GUI:TextInput_addOnEvent(ui.TextField_input, function(_, eventType)
        if eventType == 1 then
            local time = GUI:TextInput_getString(ui.TextField_input)
            if time ~= "" then
                time = tonumber(time) or 0
                local config = SL:GetMetaValue("SETTING_CONFIG", data.id)
                local minTime = config and config.time or 1000--配置的最小时间
                if time < minTime then
                    time = minTime
                    GUI:TextInput_setString(ui.TextField_input, time)
                end
                SettingProtectSetting._RankData.time = time
                SettingProtectSetting.saveSet()
            end
        end
    end)

    GUI:addOnClickEvent(ui.Button_close, function()
        SL:CloseProtectSettingUI()
    end)

    GUI:addOnClickEvent(ui.Panel_cancle, function()
        SL:CloseProtectSettingUI()
    end)

    SettingProtectSetting._ProtectDataId = data.id

    local contentSize = GUI:getContentSize(ui.ListView_1)

    local listWorldPos = GUI:getWorldPosition(ui.ListView_1)

    --listview 对于Panel_touch的最大高度和最低高度
    SettingProtectSetting._listViewYMin = GUI:convertToNodeSpace(ui.Panel_touch, 0, listWorldPos.y).y
    SettingProtectSetting._listViewYMax = contentSize.height + SettingProtectSetting._listViewYMin
    -----------
    local tipsSize = GUI:getContentSize(ui.Panel_tips)
    local richText = GUI:RichText_Create(ui.Panel_tips, "RichText_tips", tipsSize.width / 2, tipsSize.height / 2, data.tips or "", tipsSize.width, 14, "#ffffff")
    GUI:setAnchorPoint(richText, 0.5, 0.5)

    --排行的相关数据 {indexs = {} ,time = 1000,oriStr = config.indexs}
    SettingProtectSetting._RankData = SL:GetMetaValue("SETTING_RANK_DATA", SettingProtectSetting._ProtectDataId)

    for i, index in ipairs(SettingProtectSetting._RankData.indexs) do
        SettingProtectSetting.addItem(i, index)
    end
    GUI:TextInput_setString(ui.TextField_input, SettingProtectSetting._RankData.time)
    SettingProtectSetting._touchItem = nil
    SettingProtectSetting._touchIndex = nil
    GUI:setSwallowTouches(ui.Panel_touch, false)
    GUI:addOnTouchEvent(ui.Panel_touch, function(sender, type)
        if type == SLDefine.TouchEventType.began then
            local beginPos = GUI:getTouchBeganPosition(sender)
            if SettingProtectSetting._selItem then
                local worldpos = GUI:getWorldPosition(SettingProtectSetting._selItem)
                local contentSize = GUI:getContentSize(SettingProtectSetting._selItem)
                local Rect = GUI:Rect(worldpos.x, worldpos.y, contentSize.width, contentSize.height)
                if not GUI:RectContainsPoint(Rect, beginPos) then
                    local last_Image_sel = GUI:getChildByName(SettingProtectSetting._selItem, "Image_sel")
                    GUI:setVisible(last_Image_sel, false)
                    SettingProtectSetting._selItem = nil
                    ui.Panel_touch.clear = true
                else
                    GUI:setSwallowTouches(ui.Panel_touch, true)
                end
            end
        elseif type == SLDefine.TouchEventType.moved then
            if SettingProtectSetting._selItem then
                local movePos = GUI:getTouchMovePosition(sender)
                if not SettingProtectSetting._touchItem then
                    local order = SettingProtectSetting._selItem.order
                    local index = SettingProtectSetting._selItem.index
                    SettingProtectSetting._touchItem = SettingProtectSetting.createItem(ui.Panel_touch, order + 100000, index)
                    GUI:setAnchorPoint(SettingProtectSetting._touchItem, 0.5, 0.5)
                    GUI:setTouchEnabled(SettingProtectSetting._touchItem, false)
                    local name = SL:GetMetaValue("ITEM_NAME", index)--道具名字
                    local Text_name = GUI:getChildByName(SettingProtectSetting._touchItem, "Text_name")
                    GUI:Text_setString(Text_name, name)
                end
                if SettingProtectSetting._touchItem then
                    local nodePos = GUI:convertToNodeSpace(ui.Panel_touch, movePos)
                    GUI:setPosition(SettingProtectSetting._touchItem, nodePos)
                    if nodePos.y >= SettingProtectSetting._listViewYMax then
                        local Topitem = GUI:ListView_getTopmostItemInCurrentView(ui.ListView_1)
                        local TopIndex = GUI:ListView_getItemIndex(ui.ListView_1, Topitem)
                        GUI:ListView_scrollToTop(ui.ListView_1, TopIndex / 10, false)
                    elseif nodePos.y <= SettingProtectSetting._listViewYMin then
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
            if not SettingProtectSetting._selItem and not ui.Panel_touch.clear then
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
                        SettingProtectSetting._selItem = item

                    end
                end
            end
            ui.Panel_touch.clear = false
            if SettingProtectSetting._touchItem then
                GUI:removeFromParent(SettingProtectSetting._touchItem)
                SettingProtectSetting._touchItem = nil
                local endPos = GUI:getTouchEndPosition(sender)
                local items = GUI:ListView_getItems(ui.ListView_1)
                for i, item in ipairs(items) do
                    local bottomPos = GUI:getWorldPosition(item)
                    local contentSize = GUI:getContentSize(item)
                    if endPos.y >= bottomPos.y and endPos.y <= bottomPos.y + contentSize.height then
                        if endPos.y <= bottomPos.y + contentSize.height / 2 then
                            SettingProtectSetting.updateItemsByIndex(i)
                        else
                            SettingProtectSetting.updateItemsByIndex(i - 1)
                        end
                        break
                    end
                end
            end
        end
    end)
end

function SettingProtectSetting.createItem(parent, order, index)
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
    local Image_sel = GUI:Image_Create(Panel_item, "Image_sel", -2, 23, "res/private/new_setting/btnbg.png")
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

function SettingProtectSetting.addItem(order, index)
    local ui = SettingProtectSetting._ui
    local item = SettingProtectSetting.createItem(ui.ListView_1, order, index)
    item.index = index
    item.order = order

    local cell = GUI:ui_delegate(item)
    GUI:Text_setString(cell.Text_order, order)
    GUI:setVisible(cell.Image_sel, false)

    local name = SL:GetMetaValue("ITEM_NAME", index)--道具名字
    GUI:Text_setString(cell.Text_name, name)
end

function SettingProtectSetting.updateItemsByIndex(index)
    if not SettingProtectSetting._selItem then
        return
    end
    local ui = SettingProtectSetting._ui
    local idx = GUI:ListView_getItemIndex(ui.ListView_1, SettingProtectSetting._selItem)
    if idx < index then
        index = index - 1
    end
    GUI:addRef(SettingProtectSetting._selItem)--引用加一  不会在移除的时候被释放
    GUI:ListView_removeItemByIndex(ui.ListView_1, idx)--在原来的位置移除
    GUI:ListView_insertCustomItem(ui.ListView_1, SettingProtectSetting._selItem, index)--插入新位置
    GUI:decRef(SettingProtectSetting._selItem)--引用减一 
    GUI:ListView_jumpToItem(ui.ListView_1, index, GUI:p(0, 0), GUI:p(0, 0))
    SettingProtectSetting._RankData.indexs = {}
    local items = GUI:ListView_getItems(ui.ListView_1)
    for i, item in ipairs(items) do
        local Text_order = GUI:getChildByName(item, "Text_order")
        GUI:Text_setString(Text_order, i)
        item.order = i
        table.insert(SettingProtectSetting._RankData.indexs, item.index)
    end
    SettingProtectSetting.saveSet()

end

function SettingProtectSetting.saveSet()
    SL:SetMetaValue("SETTING_RANK_DATA", SettingProtectSetting._ProtectDataId, SettingProtectSetting._RankData)
end