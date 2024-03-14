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

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:ListView_addMouseScrollPercent(StorePage._ui["ScrollView_list"])
    end 
end

function StorePage.refreshStorePageUI(pageData)
    local ui_panel = StorePage._ui["Panel_1"]
    local ui_scroll = StorePage._ui["ScrollView_list"]
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

    table.sort(showData, function(a, b)
        local sortindexA = a.sortindex or 0
        local sortindexB = b.sortindex or 0
        return sortindexA < sortindexB
    end)

    local width = SL:GetMetaValue("WINPLAYMODE") and 202 or 244
    local height = SL:GetMetaValue("WINPLAYMODE") and 120 or 140
    local lookSize = GUI:getContentSize(ui_scroll)
    GUI:ScrollView_setInnerContainerSize(ui_scroll, lookSize.width, math.ceil(#showData / 3) * height)
    local innerSize = GUI:ScrollView_getInnerContainerSize(ui_scroll)

    for i, data in ipairs(showData) do 
        local function createCell(parent)
            return StorePage.CreateStoreItemCell(parent, data)
        end 

        local x = (i + 2) % 3 * width
        local y = innerSize.height - (math.floor((i - 1) / 3) + 1) * height
        local cell = GUI:QuickCell_Create(ui_scroll, "cell"..i, x, y, width, height, createCell)
    end 
end

function StorePage.CreateStoreItemCell(parent, data)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "store/page_store_cell_win32")
    else
        GUI:LoadExport(parent, "store/page_store_cell")
    end

    local cell = GUI:getChildByName(parent, "Panel_item")
    local ui_textTitle = GUI:getChildByName(cell, "Text_itemName")
    local ui_imgTag = GUI:getChildByName(cell, "Image_tag")
    local ui_limit = GUI:getChildByName(cell, "Panel_limit")
    local ui_price = GUI:getChildByName(cell, "Panel_price")
    local ui_nowPrice = GUI:getChildByName(cell, "Panel_nowPrice")
    local ui_icon = GUI:getChildByName(cell, "Node_icon")
    GUI:removeAllChildren(ui_icon)

    if data.Index then
        cell["guide_id"] = data.Index
    end

    if data.Name then
        GUI:Text_setString(ui_textTitle, data.Name)
        local colorID = SL:GetMetaValue("ITEM_NAME_COLORID", data.Id)
        if colorID then
            GUI:Text_setTextColor(ui_textTitle, SL:GetHexColorByStyleId(colorID))
        end
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

    -- limit
    local isLimit = false
    local isBuyMax = false
    local TextType = {
        "现价",
        "今日限购",
        "每周限购",
        "永久限购",
    }
    if data.LimitCount and data.LimitCount > 0 and data.LimitType then
        local buyCount = data.BuyCount or 0
        local leftCount = data.LimitCount - buyCount
        local str = string.format("%s：%s/%s", TextType[data.LimitType + 1], leftCount, data.LimitCount)
        if buyCount >= data.LimitCount then
            isBuyMax = true
            str = "售罄"
        end

        local limit_count = GUI:getChildByName(ui_limit, "Text_info")
        GUI:Text_setString(limit_count, str)
        GUI:Text_setTextColor(limit_count, "#F2E7CE")
        isLimit = true
    end

    local price = nil
    local nowPrice = nil
    local showPrice = nil
    local isAlone = false
    if isLimit then 
        if data.Price and data.Price > 0 then 
            showPrice = data.Price 
        end 

        if data.NowPrice and data.NowPrice > 0 then 
            showPrice = data.NowPrice
        end 
        nowPrice = showPrice
    else 
        if data.Price and data.Price > 0 and data.NowPrice and data.NowPrice > 0 then 
            price = data.Price
            nowPrice = data.NowPrice
        else 
            if data.Price and data.Price > 0  then 
                showPrice = data.Price
                isAlone = true
            end 

            if data.NowPrice and data.NowPrice > 0 then 
                showPrice = data.NowPrice
                isAlone = true
            end 
            nowPrice = showPrice      
        end 
    end 
    GUI:setVisible(ui_limit, isLimit)
    GUI:setVisible(ui_price, price and price > 0 or false)
    GUI:setVisible(ui_nowPrice, nowPrice and nowPrice > 0 or false)

    
    -- price
    if price and price > 0 then
        -- 自己的货币
        local haveNum = 0
        local costId = data.CostID

        if data.ArrConstID and next(data.ArrConstID) then 
            for i, moneyId in pairs(data.ArrConstID) do         
                haveNum = haveNum + tonumber(SL:GetMetaValue("MONEY", moneyId)) or 0
            end 
            costId = data.ArrConstID[1]
        else 
            haveNum = tonumber(SL:GetMetaValue("MONEY", data.CostID)) or 0
            local isBind = SL:GetMetaValue("SERVER_OPTIONS", "BindGold")
            if isBind then 
                if data.CostID == 4 then 
                    haveNum = haveNum + tonumber(SL:GetMetaValue("MONEY", 2))
                end 
            end 
        end 

        -- icon
        local price_icon = GUI:getChildByName(ui_price, "Node_icon")
        GUI:removeAllChildren(price_icon)
        local info = {
            index = costId,
            bgVisible = false,
            look = true
        }
        local goodsItem = GUI:ItemShow_Create(price_icon, "goodsItem".. data.Name, 0, 0, info)
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    
        -- count
        local price_count = GUI:getChildByName(ui_price, "Node_count")
        GUI:removeAllChildren(price_count)
        local color = haveNum >= price and "#28ef01" or "#FB0000"
        local strPrice = string.format("<del>%s</del>", SL:GetSimpleNumber(price, 1))
        local richText = GUI:RichText_Create(price_count, "richText".. data.Name, 0, 0, strPrice, 100, 16, color)
        GUI:setAnchorPoint(richText, 0, 0.5)
    end

    if nowPrice and nowPrice > 0 then 
        local haveNum = 0
        local costId = data.CostID

        if data.ArrConstID and next(data.ArrConstID) then -- 配置多种消耗 exp: 2#1#4 
            for i, moneyId in pairs(data.ArrConstID) do         
                haveNum = haveNum + tonumber(SL:GetMetaValue("MONEY", moneyId)) or 0 -- 显示多种消耗总和 注：2和4同时配置
            end 
            costId = data.ArrConstID[1] -- 显示第一个
        else 
            haveNum = tonumber(SL:GetMetaValue("MONEY", data.CostID)) or 0 -- 配置消耗一种 配置4绑定元宝 需加上 元宝
            local isBind = SL:GetMetaValue("SERVER_OPTIONS", "BindGold")
            if isBind then 
                if data.CostID == 4 then 
                    haveNum = haveNum + tonumber(SL:GetMetaValue("MONEY", 2))
                end 
            end 
        end 

        -- icon
        local price_icon = GUI:getChildByName(ui_nowPrice, "Node_icon")
        GUI:removeAllChildren(price_icon)
        local info = {
            index = costId,
            bgVisible = false,
            look = true
        }
        local goodsItem = GUI:ItemShow_Create(price_icon, "goodsItem2".. data.Name, 0, 0, info)
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    
        -- count
        local price_count = GUI:getChildByName(ui_nowPrice, "Node_count")
        GUI:removeAllChildren(price_count)
        local color = haveNum >= nowPrice and "#28ef01" or "#FB0000"
        local strPrice = SL:GetSimpleNumber(nowPrice, 1)
        local richText = GUI:RichText_Create(price_count, "richText2".. data.Name, 0, 0, strPrice, 100, 16, color)
        GUI:setAnchorPoint(richText, 0, 0.5)

        if isAlone then 
            GUI:setPositionY(ui_nowPrice, GUI:getPositionY(ui_icon)) -- 单独居中
        end 
    end 

    GUI:addOnClickEvent(cell, function()
        if isBuyMax then 
            return
        end 
        SL:OpenStoreDetailUI(data.Index)
    end)

    return cell
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

                local costNode = GUI:getChildByName(StorePage._ui["Panel_1"],"costNode" .. i)
                if costNode then
                    GUI:removeFromParent(costNode)
                    costNode= nil
                end
                costNode = GUI:Node_Create(StorePage._ui["Panel_1"], "costNode" .. i, 0, 0)
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