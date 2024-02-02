StorePage = {}

function StorePage.main()
    local parent = GUI:Attach_Parent()

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "store/page_store_panel_win32")
    else
        GUI:LoadExport(parent, "store/page_store_panel")
    end

    StorePage._parent = parent
    StorePage._ui = GUI:ui_delegate(parent)
    StorePage._costItems = {}
end

function StorePage.refreshStorePageUI(pageData)
    local ui_panel = StorePage._ui["Panel_1"]
    local ui_scroll = StorePage._ui["ScrollView_list"]
    GUI:stopAllActions(ui_panel)
    GUI:removeAllChildren(ui_scroll)

    local showData = {}
    StorePage._costItems = {}
    for i, v in pairs(pageData) do
        if not v.condis or v.condis == "" or SL:CheckCondition(v.condis) then
            table.insert(showData, v)
            if v.ArrConstID and next(v.ArrConstID) then
                for _, id in ipairs(v.ArrConstID) do
                    StorePage._costItems[id] = true
                end
            else
                StorePage._costItems[v.CostID] = true
            end
        end
    end

    local width = 244
    local height = 140
    if SL:GetMetaValue("WINPLAYMODE") then
        width = 202
        height = 120
    end

    local lookSize = GUI:getContentSize(ui_scroll)
    GUI:ScrollView_setInnerContainerSize(ui_scroll, lookSize.width, math.ceil(#showData / 3) * height)
    local innerSize = GUI:ScrollView_getInnerContainerSize(ui_scroll)
    table.sort(showData, function(a, b)
        local sortindexA = a.sortindex or 0
        local sortindexB = b.sortindex or 0
        return sortindexA < sortindexB
    end)

    local index = 0
    local count = #showData
    SL:schedule(ui_panel, function()
        index = index + 1
        if index > count then
            GUI:stopAllActions(ui_panel)
            return 
        end
        local data = showData[index]
        local cell = StorePage.CreateStoreItemCell(data)
        local x = (index + 2) % 3 * width
        local y = innerSize.height - (math.floor((index - 1) / 3) + 1) * height
        GUI:setPosition(cell.layout, x, y)
    end, 0.01)
end

function StorePage.CreateStoreItemCell(data)
    local parent = GUI:Widget_Create(StorePage._ui["ScrollView_list"], "node" .. data.Id, 0, 0)

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "store/page_store_cell_win32")
    else
        GUI:LoadExport(parent, "store/page_store_cell")
    end

    local layout = GUI:getChildByName(parent, "Panel_item")

    local ui_textTitle = GUI:getChildByName(layout, "Text_itemName")
    local ui_icon = GUI:getChildByName(layout, "Node_icon")
    local ui_condition = GUI:getChildByName(layout, "Text_condition")
    local ui_price = GUI:getChildByName(layout, "Node_price")
    local ui_priceNow = GUI:getChildByName(layout, "Node_priceNow")
    local ui_imgTag = GUI:getChildByName(layout, "Image_tag")
    GUI:setContentSize(ui_condition, SL:GetMetaValue("WINPLAYMODE") and 100 or 140, 24)

    ui_icon:removeAllChildren()
    ui_price:removeAllChildren()
    ui_priceNow:removeAllChildren()

    if data.Index then
        layout["guide_id"] = data.Index
    end

    if data.Name then
        GUI:Text_setString(ui_textTitle, data.Name)
        local colorID = SL:GetMetaValue("ITEM_NAME_COLORID", data.Id)
        SL:SetColorStyle(ui_textTitle, colorID)
    end

    if data.Id and data.Look then
        local goodsData = {}
        goodsData.index = data.Id
        goodsData.look = true
        goodsData.checkPower = true
        local goodItem = GUI:ItemShow_Create(ui_icon, "ui_icon", 0, 0, goodsData)
        goodItem:setAnchorPoint(0.5, 0.5)
    end
    
    GUI:setVisible(ui_imgTag, false)

    local imageName = StorePage.GetTagImage(data.ShowLable)
    if imageName then
        ui_imgTag:loadTexture(SLDefine.PATH_RES_PRIVATE .. "page_store_ui/page_store_ui_mobile/" .. imageName)
        GUI:setVisible(ui_imgTag, true)
    end

    StorePage.refreshConditionAndPrice(layout, data)

    return {
        layout = layout,
        textitemName = ui_textTitle,
        nodeIcon = ui_icon,
        textCondition = ui_condition,
        nodePrice = ui_price,
        nodePriceNow = ui_priceNow,
    }
end

function StorePage.InitMoneyCell()
    local ui_listView = StorePage._ui["ListView_cells"]
    GUI:ListView_removeAllItems(ui_listView)
    if StorePage._costItems and next(StorePage._costItems) then
        local showList = {}
        for i, v in pairs(StorePage._costItems) do
            table.insert(showList, i)
        end

        if showList and #showList > 1 then
            table.sort(showList, function(a, b)
                return a < b
            end)
        end

        for i = 1, 3 do
            if showList[i] then
                local moneyId = showList[i]
                local count = SL:GetMetaValue("MONEY", moneyId)

                local costNode = GUI:Node_Create(StorePage._ui["Panel_1"], "costNode" .. i, 0, 0)
                GUI:LoadExport(costNode, "store/page_store_cost_cell")
                local costCell = GUI:getChildByName(costNode, "Panel_costcell")

                GUI:removeFromParent(costCell)
                GUI:setTag(costCell, moneyId)
                GUI:setVisible(costCell, true)

                local textNum = GUI:getChildByName(costCell, "Text_num")
                GUI:Text_setString(textNum, count)

                local panelIcon = GUI:getChildByName(costCell, "Panel_icon")
                local moneyInfo = {}
                moneyInfo.index = moneyId
                moneyInfo.noMouseTips = true
                local moneyCellItem = GUI:ItemShow_Create(panelIcon, "panelIcon", 0, 0, moneyInfo)
                GUI:setAnchorPoint(moneyCellItem, 0.5, 0.5)
                GUI:setScale(moneyCellItem, 0.7)

                GUI:ListView_pushBackCustomItem(ui_listView, costCell)
            end
        end
    end
end

function StorePage.RefreshMoney(data)
    local ui_listView = StorePage._ui["ListView_cells"]
    local moenyList = GUI:getChildren(ui_listView)

    if moenyList and next(moenyList) then
        for k, v in pairs(moenyList) do
            if v and not tolua.isnull(v) then
                local tag = v:getTag() or 0
                if tag ~= 0 and tag == data.id then
                    local textNum = GUI:getChildByName(v, "Text_num")
                    if textNum then
                        local moneyCount = SL:GetMetaValue("MONEY", tag)
                        GUI:Text_setString(textNum, moneyCount)
                    end
                    break
                end
            end
        end
    end
end

function StorePage.GetTagImage(index)
    if not index then
        return nil
    end
    local tagImage = {
        [1] = "1900020100.png",
        [2] = "1900020103.png",
        [3] = "1900020104.png",
        [4] = "1900020101.png",
        [5] = "1900020105.png",
        [6] = "1900020102.png",
    }
    return tagImage[index]
end