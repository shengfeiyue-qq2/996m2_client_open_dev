SettingSkillRank = {}

function SettingSkillRank.main(parent, data)
    GUI:LoadExport(parent, "set/setting_auto_skill_rank")
    SettingSkillRank._ui = GUI:ui_delegate(parent)
    SettingSkillRank._parent = parent
    if not SettingSkillRank._ui then
        return false
    end
    SettingSkillRank._RankData = {}
    SettingSkillRank._selItem = nil
    SettingSkillRank.InitUI(data)
    SettingSkillRank.RegisterEvent()
end

function SettingSkillRank.InitUI(data)
    local ui = SettingSkillRank._ui
    local Panel_Size = GUI:getContentSize(ui.Panel_1)
    --调整一下位置
    local ScreenWidth = SL:GetMetaValue("SCREEN_WIDTH")
    local ScreenHeight = SL:GetMetaValue("SCREEN_HEIGHT")
    local posY = SL:GetMetaValue("WINPLAYMODE") and SL:GetMetaValue("PC_POS_Y") or ScreenHeight / 2
    GUI:setPosition(ui.Panel_1, ScreenWidth/2 + Panel_Size.width / 2 + 100, posY)

    SettingSkillRank._ProtectDataId = data.id
    GUI:addOnClickEvent(ui.Button_close,function()
        SL:CloseSkillRankPanelUI()
    end)
    GUI:addOnClickEvent(ui.Panel_cancle,function()
        SL:CloseSkillRankPanelUI()
    end)
    GUI:addOnClickEvent(ui.Button_add,function()
        SL:OpenSkillPanelUI()
    end)

    GUI:addOnClickEvent(ui.Button_del, function()
        if SettingSkillRank._selItem then
            GUI:ListView_removeChild(ui.ListView_1, SettingSkillRank._selItem)
            SettingSkillRank._selItem = nil
            SettingSkillRank._RankData.indexs = {}
            local items = GUI:ListView_getItems(ui.ListView_1)
            for order, item in ipairs(items) do
                local Text_order = GUI:getChildByName(item, "Text_order")
                GUI:Text_setString(Text_order, order)
                item.order = order
                table.insert(SettingSkillRank._RankData.indexs, item.index)
            end
            SettingSkillRank.saveSet()
        end
    end)

    ------------
    local contentSize = GUI:getContentSize(ui.ListView_1)
    local listWorldPos = GUI:getWorldPosition(ui.ListView_1)
    SettingSkillRank._listViewYMin = GUI:convertToNodeSpace(ui.Panel_touch, 0, listWorldPos.y).y
    SettingSkillRank._listViewYMax = contentSize.height + SettingSkillRank._listViewYMin
    -----------

    SettingSkillRank._RankData = SL:GetMetaValue("SETTING_RANK_DATA", SettingSkillRank._ProtectDataId)

    for order, index in ipairs(SettingSkillRank._RankData.indexs) do
        SettingSkillRank.addItem(order, index)
    end
    SettingSkillRank._touchItem = nil
    SettingSkillRank._touchIndex = nil
    GUI:setSwallowTouches(ui.Panel_touch, false)
    GUI:addOnTouchEvent(ui.Panel_touch, function(sender, type)
        if type == SLDefine.TouchEventType.began then
            local beginPos = GUI:getTouchBeganPosition(sender)
            if SettingSkillRank._selItem then
                local worldpos = GUI:getWorldPosition(SettingSkillRank._selItem)
                local contentSize = GUI:getContentSize(SettingSkillRank._selItem)
                local Rect = GUI:Rect(worldpos.x, worldpos.y, contentSize.width, contentSize.height)
                if not GUI:RectContainsPoint(Rect, beginPos) then
                    local last_Image_sel = GUI:getChildByName(SettingSkillRank._selItem, "Image_sel")
                    GUI:setVisible(last_Image_sel, false)
                    SettingSkillRank._selItem = nil
                    ui.Panel_touch.clear = true
                else
                    GUI:setSwallowTouches(ui.Panel_touch, true)
                end
            end
        elseif type == SLDefine.TouchEventType.moved then
            if SettingSkillRank._selItem then
                local movePos = GUI:getTouchMovePosition(sender)
                if not SettingSkillRank._touchItem then
                    local order = SettingSkillRank._selItem.order
                    local index = SettingSkillRank._selItem.index
                    SettingSkillRank._touchItem = SettingSkillRank.createItem(ui.Panel_touch, order + 100000)
                    SettingSkillRank._touchItem:setAnchorPoint(GUI:p(0.5, 0.5))
                    SettingSkillRank._touchItem:setTouchEnabled(false)
                    GUI:setAnchorPoint(SettingSkillRank._touchItem, 0.5, 0.5)
                    GUI:setTouchEnabled(SettingSkillRank._touchItem, false)
                    local name = SL:GetMetaValue("SKILL_NAME", index)--技能名字
                    local Text_name = GUI:getChildByName(SettingSkillRank._touchItem, "Text_name")
                    GUI:Text_setString(Text_name, name)

                end
                if SettingSkillRank._touchItem then
                    local nodePos = GUI:convertToNodeSpace(ui.Panel_touch, movePos)
                    GUI:setPosition(SettingSkillRank._touchItem, nodePos)
                    if nodePos.y >= SettingSkillRank._listViewYMax then
                        local Topitem = GUI:ListView_getTopmostItemInCurrentView(ui.ListView_1)
                        local TopIndex = GUI:ListView_getItemIndex(ui.ListView_1, Topitem)
                        GUI:ListView_scrollToTop(ui.ListView_1, TopIndex / 10, false)
                    elseif nodePos.y <= SettingSkillRank._listViewYMin then
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
            if not SettingSkillRank._selItem and not ui.Panel_touch.clear then
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
                        SettingSkillRank._selItem = item
                    end
                end
            end
            ui.Panel_touch.clear = false
            if SettingSkillRank._touchItem then
                GUI:removeFromParent(SettingSkillRank._touchItem)
                SettingSkillRank._touchItem = nil
                local endPos = GUI:getTouchEndPosition(sender)
                local items = GUI:ListView_getItems(ui.ListView_1)
                for i, item in ipairs(items) do
                    local bottomPos = GUI:getWorldPosition(item)
                    local contentSize = GUI:getContentSize(item)
                    if endPos.y >= bottomPos.y and endPos.y <= bottomPos.y + contentSize.height then
                        if endPos.y <= bottomPos.y + contentSize.height / 2 then
                            SettingSkillRank.updateItemsByIndex(i)
                        else
                            SettingSkillRank.updateItemsByIndex(i - 1)
                        end
                        break
                    end
                end
            end

        end

    end)
end

function SettingSkillRank.createItem(parent, order, index)
    local Panel_item = GUI:Layout_Create(parent, "Panel_item_" .. order, 11, 185, 314, 43, false)
    GUI:setTouchEnabled(Panel_item, true)

    local Image_1 = GUI:Image_Create(Panel_item, "Image_1", 1, 2, "res/public/bg_yyxsz_01.png")
    GUI:setContentSize(Image_1, 310, 2)
    GUI:setIgnoreContentAdaptWithSize(Image_1, false)
    GUI:setAnchorPoint(Image_1, 0, 0.5)
    GUI:setTouchEnabled(Image_1, false)

    local Image_sel = GUI:Image_Create(Panel_item, "Image_sel", 0, 21.5, "res/private/new_setting/btnbg.png")
    GUI:Image_setScale9Slice(Image_sel, 33, 33, 10, 8)
    GUI:setContentSize(Image_sel, 314, 43)
    GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
    GUI:setAnchorPoint(Image_sel, 0, 0.5)
    GUI:setTouchEnabled(Image_sel, false)

    local Text_order = GUI:Text_Create(Panel_item, "Text_order", 51, 23, 20, "#ffffff", [[1]])
    GUI:setAnchorPoint(Text_order, 0.5, 0.5)
    GUI:setTouchEnabled(Text_order, false)
    GUI:Text_enableOutline(Text_order, "#000000", 1)

    local Text_name = GUI:Text_Create(Panel_item, "Text_name", 200, 23, 18, "#ffffff", [[回城石]])
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
    GUI:setTouchEnabled(Text_name, false)
    GUI:Text_enableOutline(Text_name, "#000000", 1)

    return Panel_item
end

function SettingSkillRank.addItem(order, index)
    if not index then
        return
    end
    local ui = SettingSkillRank._ui
    local item = SettingSkillRank.createItem(ui.ListView_1, order, index)

    item.index = index
    item.order = order

    local cell = GUI:ui_delegate(item)
    GUI:Text_setString(cell.Text_order, order)
    GUI:setVisible(cell.Image_sel, false)

    local name = SL:GetMetaValue("SKILL_NAME", index)--技能名称
    GUI:Text_setString(cell.Text_name, name)

end

function SettingSkillRank.OnAddSkillRankData(skill)
    local find = false
    for i, v in ipairs(SettingSkillRank._RankData.indexs) do
        if v == skill.MagicID then
            find = true
            break
        end
    end
    if not find then
        table.insert(SettingSkillRank._RankData.indexs, skill.MagicID)
        SettingSkillRank.addItem(#SettingSkillRank._RankData.indexs, skill.MagicID)
        SettingSkillRank.saveSet()
    end
end

function SettingSkillRank.updateItemsByIndex(index)
    if not SettingSkillRank._selItem then
        return
    end
    local ui = SettingSkillRank._ui
    local idx = GUI:ListView_getItemIndex(ui.ListView_1, SettingSkillRank._selItem)
    if idx < index then
        index = index - 1
    end
    GUI:addRef(SettingSkillRank._selItem)--引用加一  不会在移除的时候被释放
    GUI:ListView_removeItemByIndex(ui.ListView_1, idx)--在原来的位置移除
    GUI:ListView_insertCustomItem(ui.ListView_1, SettingSkillRank._selItem, index)--插入新位置
    GUI:decRef(SettingSkillRank._selItem)--引用减一 
    GUI:ListView_jumpToItem(ui.ListView_1, index, GUI:p(0, 0), GUI:p(0, 0))
    SettingSkillRank._RankData.indexs = {}
    local items = GUI:ListView_getItems(ui.ListView_1)
    for i, item in ipairs(items) do
        local Text_order = GUI:getChildByName(item, "Text_order")
        GUI:Text_setString(Text_order, i)
        item.order = i
        table.insert(SettingSkillRank._RankData.indexs, item.index)
    end
    SettingSkillRank.saveSet()

end

function SettingSkillRank.saveSet()
    SL:SetMetaValue("SETTING_RANK_DATA", SettingSkillRank._ProtectDataId, SettingSkillRank._RankData)
end

function SettingSkillRank.CloseCallback()
    SettingSkillRank.UnRegisterEvent()
end

function SettingSkillRank.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_RANKDATA_ADD, "SettingSkillRank", SettingSkillRank.OnAddSkillRankData)
end

function SettingSkillRank.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SKILL_RANKDATA_ADD, "SettingSkillRank")
end