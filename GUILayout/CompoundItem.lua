CompoundItem = {}

local MoneyType = {
    YuanBao     = 2,
    BindYuanBao = 4,
}

function CompoundItem.main()
    local parent = GUI:Attach_Parent()
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWin32 and "compound_item_layer_win32/compound_items_layer" or "compound_item_layer/compound_items_layer")

    CompoundItem._ui = GUI:ui_delegate(parent)

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:setPosition(CompoundItem._ui.Panel_1, SL:GetMetaValue("SCREEN_WIDTH") / 2, SL:GetMetaValue("PC_POS_Y"))
    else
        GUI:setPosition(CompoundItem._ui.Panel_1, SL:GetMetaValue("SCREEN_WIDTH") / 2,
        SL:GetMetaValue("SCREEN_HEIGHT") / 2)
    end

    -- 界面拖动
    GUI:Win_SetDrag(parent, CompoundItem._ui.Image_frame_bg)

    CompoundItem.defaultMargin = 10
    CompoundItem.defaultWidth = isWin32 and 250 or 300
    CompoundItem.defaultHeight = 64

    CompoundItem.choosePage1 = 0 -- 记录第一页签
    CompoundItem.choosePage2 = 0 -- 记录第二页签
    CompoundItem.chooseCompoundIndex = 0 -- 记录打开的合成Index
    CompoundItem._open_id = nil -- 记录打开的id,  每次打开需要通知脚本

    -- index
    local jumpIndex = SL:GetMetaValue("COMPOUND_OPEN_ID")
    if jumpIndex then
        local config = SL:GetMetaValue("COMPOUND_CONFIG_BY_INDEX", jumpIndex)
        if config and next(config) then
            CompoundItem.choosePage1 = config.page1
            CompoundItem.choosePage2 = config.page2 + CompoundItem.choosePage1 * 1000
            CompoundItem.chooseCompoundIndex = config.id
        end
    end

    CompoundItem.InitCompoudUI()
    CompoundItem.InitTypeMenu()
    CompoundItem.RefreshInfoMenu()

    CompoundItem.SetCompoundEvent()
    CompoundItem.SetCloseEvent()
    CompoundItem.RegisterEvent()
end

function CompoundItem.InitTypeMenu()
    local listview = CompoundItem._ui["ListView_list1"]
    GUI:ListView_removeAllItems(listview)

    local data = SL:GetMetaValue("COMPOUND_LIST_DATA")
    local list = {}

    for i, v in pairs(data) do 
        local page1 = math.floor(i / 1000)
        if not list[page1] then
            local isShow = SL:GetMetaValue("COMPOUND_CHECK_LIST_IS_SHOW", page1) 
            if isShow then
                list[page1] = 1
            end
        end
    end 

    local sortList = {}
    for i, v in pairs(list) do 
        table.insert(sortList, i)
    end 

    table.sort(sortList, function(a, b)
        return a < b
    end)

    for i, page1 in ipairs(sortList) do 
        local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", page1)
        if redState and CompoundItem.choosePage1 == 0 then
            CompoundItem.choosePage1 = page1
            break
        end
    end 

    if CompoundItem.choosePage1 == 0 then
        CompoundItem.choosePage1 = sortList[1]
    end

    for i, page1 in ipairs(sortList) do
        local cell = CompoundItem.CreateMenuType(page1)
        GUI:setTag(cell.layout, page1)
        GUI:Button_setTitleColor(cell.btnType, CompoundItem.choosePage1 == page1 and "#f8e6c6" or "#6c6861")
        GUI:Button_titleEnableOutline(cell.btnType, "#111111", 2)
        GUI:Button_setTitleFontSize(cell.btnType, SL:GetMetaValue("WINPLAYMODE") and 14 or 18)
        GUI:Button_setBright(cell.btnType, CompoundItem.choosePage1 ~= page1)
        GUI:addOnClickEvent(cell.btnType, function()
            CompoundItem.ChangeCompoundPage(page1)
        end)

        local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", page1)
        GUI:setVisible(cell.image_red, redState)

        GUI:ListView_pushBackCustomItem(listview, cell.layout)
    end
end

function CompoundItem.RefreshInfoMenu()
    local listview = CompoundItem._ui["ListView_list2"]
    GUI:ListView_removeAllItems(listview)

    local data = SL:GetMetaValue("COMPOUND_LIST_DATA")
    local list = {}

    for i, v in pairs(data) do 
        local page1 = math.floor(i / 1000)
        if not list[i] and CompoundItem.choosePage1 == page1 then
            local isShow = SL:GetMetaValue("COMPOUND_CHECK_LIST_IS_SHOW", page1, i) 
            if isShow then
                list[i] = 1
            end
        end
    end  

    local sortList = {}
    for i, v in pairs(list) do 
        table.insert(sortList, i)
    end 

    table.sort(sortList, function(a, b)
        return a < b
    end)

    for i, page2 in ipairs(sortList) do
        local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", CompoundItem.choosePage1, page2)
        if redState and CompoundItem.choosePage2 == 0 then
            CompoundItem.choosePage2 = page2
            break
        end
    end

    if CompoundItem.choosePage2 == 0 then
        CompoundItem.choosePage2 = sortList[1]
    end

    local jump_cell = nil
    local jump_child_cell = nil
    local childCount = 0

    for i, page2 in ipairs(sortList) do
        local cell = CompoundItem.CreateMenuCellLevel1(page2)
        GUI:setTag(cell.layout, page2)

        -- btn
        local pageName = SL:GetMetaValue("COMPOUND_PAGE_NAME", page2)
        GUI:Button_setTitleText(cell.btn_type, pageName)
        GUI:Button_setTitleColor(cell.btn_type, CompoundItem.choosePage2 == page2 and "#f8e6c6" or "#6c6861")
        GUI:Button_titleEnableOutline(cell.btn_type, "#111111", 2)
        GUI:Button_setTitleFontSize(cell.btn_type, SL:GetMetaValue("WINPLAYMODE") and 14 or 18)
        GUI:Button_setBright(cell.btn_type, CompoundItem.choosePage2 ~= page2)
        GUI:addOnClickEvent(cell.btn_type, function()
            CompoundItem.ChangeChoosList(page2)
        end)

        GUI:setRotation(cell.image_opened, CompoundItem.choosePage2 == page2 and 0 or 90)

        -- redpoint
        local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", CompoundItem.choosePage1, page2)
        GUI:setVisible(cell.image_red, redState)

        if CompoundItem.choosePage2 == page2 then
            jump_cell = cell.layout
        end

        GUI:ListView_pushBackCustomItem(listview, cell.layout)

        local childList = SL:GetMetaValue("COMPOUND_LIST_DATA_BY_INDEX", page2)
        if childList and next(childList) and CompoundItem.choosePage2 == page2 then
            for _, item in ipairs(childList) do
                local isShow = SL:GetMetaValue("COMPOUND_SHOW_CONDITION", item.showcondition)
                if isShow then
                    local compoudID = item.id
                    local itemRed = SL:GetMetaValue("COMPOUND_RED_POINT_BY_ID", compoudID)
                    if itemRed and CompoundItem.chooseCompoundIndex == 0 then
                        CompoundItem.UpdateCompoundLayer(compoudID)
                        break
                    end
                end
            end

            for index, item in ipairs(childList) do
                local isShow = SL:GetMetaValue("COMPOUND_SHOW_CONDITION", item.showcondition)
                if isShow then
                    local compoudID = item.id
                    if CompoundItem.chooseCompoundIndex == 0 then
                        CompoundItem.UpdateCompoundLayer(compoudID)
                    end

                    local cell = CompoundItem.CreateMenuCellLevel2(compoudID)
                    GUI:setTag(cell.layout, compoudID + 100000)
                    GUI:ListView_pushBackCustomItem(listview, cell.layout)
                    GUI:setVisible(cell.image_tag, CompoundItem.chooseCompoundIndex == compoudID)
                    GUI:addOnClickEvent(cell.layout, function()
                        CompoundItem._jumpIndex = GUI:ListView_getInnerContainerPosition(listview)
                        CompoundItem.ChangeChooseIndex(compoudID)
                    end)

                    GUI:setVisible(cell.image_red, SL:GetMetaValue("COMPOUND_RED_POINT_BY_ID", compoudID))
                    if index ~= 1 and CompoundItem.chooseCompoundIndex == compoudID then
                        jump_child_cell = cell.layout
                    end

                    local produceItem = item.shwo
                    local produceItemName = item.page3name
                    if not produceItemName or produceItemName == "" then
                        local produceItemID = tonumber(string.split(produceItem, "#")[1])
                        produceItemName = SL:GetMetaValue("ITEM_NAME", produceItemID)
                    end
                    GUI:Text_setString(cell.text_name, produceItemName)
                    GUI:setTouchEnabled(cell.layout, CompoundItem.chooseCompoundIndex ~= compoudID)

                    childCount = childCount + 1
                end
            end
        end
    end

    -- -- 动态跳到对应的标签，方便操作
    if jump_cell or jump_child_cell then
        local chooseCell = jump_child_cell and jump_child_cell or jump_cell
        local jump_index = GUI:ListView_getItemIndex(listview, chooseCell) + childCount
        local max_index = #GUI:ListView_getItems(listview) - 1
        local pos = math.min(jump_index-1, max_index)
        GUI:ListView_jumpToItem(listview, pos, GUI:p(0, 0), GUI:p(0, 0))
    end

    GUI:ListView_doLayout(listview)
end 

-- 初始化 UI
function CompoundItem.InitCompoudUI()
    GUI:setVisible(CompoundItem._ui["Panel_material"], false)
    GUI:setVisible(CompoundItem._ui["Panel_get"], false)
    GUI:setVisible(CompoundItem._ui["Panel_money"], false)

    GUI:addOnClickEvent(CompoundItem._ui["Button_help"], function(sender)
        local curId = SL:GetMetaValue("COMPOUND_OPEN_ID")
        local data = SL:GetMetaValue("COMPOUND_CONFIG_BY_INDEX", curId)
        if not data then
            return
        end

        local pos = GUI:getWorldPosition(sender)
        pos.x = pos.x + 5

        local info = {
            str = data.helpdesc or "",
            worldPos = pos,
            width = 440,
            anchorPoint = {x = 0, y = 1}
        }
        SL:OpenCommonDescTipsPop(info)
    end)

    local listMaterial = CompoundItem._ui["ListView_2"] 
    local listGet = CompoundItem._ui["ListView_get"]

    local scorllEvent = function(listView, dir)
        if not dir then
            return
        end
        local innW = GUI:ListView_getInnerContainerSize(listView).width
        local listW = GUI:getContentSize(listView).width
        if innW > listW then
            local innerPos = GUI:ListView_getInnerContainerPosition(listView)
            local vWidth = innW - listW
            local percent = (vWidth + innerPos.x + 50 * dir) / vWidth * 100
            percent = math.min(math.max(0, percent), 100)
            GUI:ListView_scrollToPercentHorizontal(listView, percent, 0.03, false)
        end
    end

    -- 左箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_left"], function()
        scorllEvent(listMaterial, -1)
    end)

    -- 右箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_right"], function()
        scorllEvent(listMaterial, 1)
    end)

    -- 左箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_left2"], function()
        scorllEvent(listGet, -1)
    end)

    -- 右箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_right2"], function()
        scorllEvent(listGet, 1)
    end)

    -- 设置  defaultMargin
    GUI:ListView_setItemsMargin(listMaterial, GUI:ListView_getItemsMargin(listMaterial) + CompoundItem.defaultMargin)
    GUI:ListView_setItemsMargin(listGet, GUI:ListView_getItemsMargin(listGet) + CompoundItem.defaultMargin)
end 

-- 刷新页面
function CompoundItem.UpdateCompoundLayer(index)
    local listMaterial = CompoundItem._ui["ListView_2"]
    local listGet = CompoundItem._ui["ListView_get"]
    local listMoney = CompoundItem._ui["ListView_money"]
    GUI:ListView_removeAllItems(listMaterial)
    GUI:ListView_removeAllItems(listGet)
    GUI:ListView_removeAllItems(listMoney)
    GUI:setVisible(CompoundItem._ui["Panel_material"], false)
    GUI:setVisible(CompoundItem._ui["Panel_get"], false)
    GUI:setVisible(CompoundItem._ui["Panel_money"], false)

    CompoundItem.chooseCompoundIndex = index
    SL:SetMetaValue("COMPOUND_OPEN_ID", index)
    local compoundData = SL:GetMetaValue("COMPOUND_CONFIG_BY_INDEX", index)
    if compoundData then
        if CompoundItem._open_id ~= compoundData.id then
            CompoundItem._open_id = compoundData.id
            SL:RequestCompoundChangeJson(compoundData.id) -- 发给脚本记录
        end

        CompoundItem.RefreshCompoundUI(compoundData)

        local material = compoundData.materialcost
        if #material > 0 then
            GUI:setVisible(CompoundItem._ui["Panel_material"], true)

            local isDoLayout = false
            local dataCount = 0
            for i, v in ipairs(material) do
                local itemData = {
                    index = v.id,
                    needNum = v.count,
                    bgVisible = true,
                    look = true
                }
                local goodsItem = CompoundItem.CreateItemIcon(itemData)
                GUI:ListView_pushBackCustomItem(listMaterial, goodsItem)
                dataCount = dataCount + 1
                isDoLayout = true
            end

            if isDoLayout then
                GUI:ListView_doLayout(listMaterial)
                CompoundItem.calcListWidth(listMaterial, CompoundItem.defaultWidth)
            end
        end

        local produce = compoundData.product
        if produce and produce ~= "" then
            GUI:setVisible(CompoundItem._ui["Panel_get"], true)
            local isDoLayout = false
            local dataCount = 0
            local produceArray = string.split(produce, "&")
            for i, v in ipairs(produceArray) do
                if v and v ~= "" then
                    local produceData = string.split(v, "#")
                    local produceID = tonumber(produceData[1])
                    local produceCount = tonumber(produceData[2])
                    local itemData = {
                        index = produceID,
                        count = produceCount,
                        bgVisible = true,
                        look = true
                    }
                    local goodsItem = CompoundItem.CreateItemIcon(itemData)
                    GUI:ListView_pushBackCustomItem(listGet, goodsItem)
                    isDoLayout = true
                    dataCount = dataCount + 1
                end
            end

            if isDoLayout then
                GUI:ListView_doLayout(listMaterial)
                CompoundItem.calcListWidth(listGet, CompoundItem.defaultWidth)
            end
        end

        local money = compoundData.moneycost
        if money and next(money) then
            GUI:setVisible(CompoundItem._ui["Panel_money"], true)
            GUI:ListView_setItemsMargin(listMoney, -10)

            local isDoLayout = false
            for i, data in ipairs(money) do
                if data and data.id then
                    local moneyCost = CompoundItem.CreateCostCell(data)
                    GUI:ListView_pushBackCustomItem(listMoney, moneyCost)
                    isDoLayout = true
                end
            end

            if isDoLayout then
                GUI:ListView_doLayout(listMaterial)
                CompoundItem.calcListHeight(listMoney, 70)
            end

            GUI:ListView_jumpToBottom(listMoney)
        end
    end

    local isCanCompound, compoudNum, equipList = SL:GetMetaValue("COMPOUND_CHECK_OK", compoundData, false)
    GUI:setGrey(CompoundItem._ui["Button_compound"], not isCanCompound)
end

--- 合成按钮事件
function CompoundItem.SetCompoundEvent()
    GUI:addOnClickEvent(CompoundItem._ui["Button_compound"], function()
        SL:ResquestCompoundItem()
    end)
end

--- 关闭按钮事件
function CompoundItem.SetCloseEvent()
    GUI:addOnClickEvent(CompoundItem._ui["Button_close"], function()
        SL:CloseCompoundItemsUI()
    end)
end

-- 第一页签改变
function CompoundItem.ChangeCompoundPage(page1)
    local oldPage1           = CompoundItem.choosePage1
    CompoundItem.choosePage1 = page1
    CompoundItem.choosePage2 = 0

    CompoundItem.UpdateCompoundLayer(0)

    if not CompoundItem.UpdatePageItems(oldPage1, page1) then
        CompoundItem.InitTypeMenu()
    end

    CompoundItem.RefreshInfoMenu()
end

-- 第一页签 item 刷新
function CompoundItem.UpdatePageItems(oldPage1, page1)
    if not page1 then
        return false
    end

    local listview = CompoundItem._ui["ListView_list1"]         
    if oldPage1 then
        local item = GUI:getChildByTag(listview, oldPage1)
        if item then
            local typeBtn = GUI:getChildByName(item, "Button_type")
            GUI:Button_setTitleColor(typeBtn, "#6c6861")
            GUI:Button_setBright(typeBtn, true)
            local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", oldPage1)
            GUI:setVisible(GUI:getChildByName(item, "Image_red"), redState)
            GUI:setTouchEnabled(typeBtn, true)
        end
    end

    local item = GUI:getChildByTag(listview, page1)
    if item then
        local typeBtn = GUI:getChildByName(item, "Button_type")
        GUI:Button_setTitleColor(typeBtn, "#f8e6c6")
        GUI:Button_setBright(typeBtn, false)
        local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", page1)
        GUI:setVisible(GUI:getChildByName(item, "Image_red"), redState)
        GUI:setTouchEnabled(typeBtn, false)
        return true
    end
    return false
end

-- 第二页签改变
function CompoundItem.ChangeChoosList(page2)
    CompoundItem.choosePage2 = page2

    CompoundItem.UpdateCompoundLayer(0)
    CompoundItem.RefreshInfoMenu()
end

-- 第二页签 展开 改变
function CompoundItem.ChangeChooseIndex(index)
    CompoundItem.UpdateCompoundLayer(index)

    if not CompoundItem.UpdatePageItems(CompoundItem.choosePage1, CompoundItem.choosePage1) then
        CompoundItem.InitTypeMenu()
    end 

    if not CompoundItem.UpdateChooseItems(index) then
        CompoundItem.RefreshInfoMenu()
    end
end

-- 第二页签 展开 item 刷新
function CompoundItem.UpdateChooseItems(index)
    if not index then
        return false
    end
    
    local isUpdate = false
    local childTag = index + 100000
    local listview = CompoundItem._ui["ListView_list2"]     
    local items = GUI:ListView_getItems(listview)
    for k, item in pairs(items) do
        local isShowImg = childTag == GUI:getTag(item)
        local img = nil
        if isShowImg then
            isUpdate = true
            img = GUI:getChildByName(item, "Image_tag")
            CompoundItem.UpdateCompoundLayer(index)
        else
            img = GUI:getChildByName(item, "Image_tag")
        end

        if img then
            GUI:setVisible(img, isShowImg)
        end

        GUI:setTouchEnabled(item, not isShowImg)
    end
    return isUpdate
end

function CompoundItem.CreateMenuType(index)
    local parent = GUI:Widget_Create(CompoundItem._ui["ListView_list1"], "widget"..index, 0, 0)

    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    if isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compoud_list_btn1")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compoud_list_btn1")
    end 

    local layout = GUI:getChildByName(parent, "Panel_1")
    GUI:removeFromParent(parent)
    GUI:removeFromParent(layout)


    local btnType = GUI:getChildByName(layout, "Button_type")
    local image_red = GUI:getChildByName(layout, "Image_red")

    local pageName = SL:GetMetaValue("COMPOUND_PAGE_NAME", index)
    GUI:Button_setTitleText(btnType, pageName)

    return {
        layout = layout,
        btnType = btnType,
        image_red = image_red
    }
end

function CompoundItem.CreateMenuCellLevel1(index)
    local parent = GUI:Widget_Create(CompoundItem._ui["ListView_list2"], "widgetlevel1"..index, 0, 0)

    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    if isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compoud_list_btn2")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compoud_list_btn2")
    end 

    local layout = GUI:getChildByName(parent, "Panel_1")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(layout)

    local btn_type = GUI:getChildByName(layout, "Button_type2")
    local image_red = GUI:getChildByName(layout, "Image_red")
    local image_opened = GUI:getChildByName(layout, "Image_opened")

    local cell = {
        layout = layout,
        btn_type = btn_type,
        image_red = image_red,
        image_opened = image_opened
    }
    return cell
end

function CompoundItem.CreateMenuCellLevel2(index)
    local parent = GUI:Widget_Create(CompoundItem._ui["ListView_list2"], "widgetlevel2"..index, 0, 0)

    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    if isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compoud_list_btn3")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compoud_list_btn3")
    end 

    local layout = GUI:getChildByName(parent, "Panel_1")

    GUI:removeFromParent(parent)
    GUI:removeFromParent(layout)

    local image_bg  = GUI:getChildByName(layout, "Image_bg")
    local text_name = GUI:getChildByName(layout, "Text_name")
    local image_tag = GUI:getChildByName(layout, "Image_tag")
    local image_red = GUI:getChildByName(layout, "Image_red")

    local cell = {
        layout = layout,
        image_bg = image_bg,
        text_name = text_name,
        image_tag = image_tag,
        image_red = image_red
    }
    return cell
end

-- 创建Icon
function CompoundItem.CreateItemIcon(data)
    local file = SL:GetMetaValue("WINPLAYMODE") and "compound_item_layer_win32/compound_item_cell" or "compound_item_layer/compound_item_cell"
    local widget = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    GUI:LoadExport(widget, file)
    
    local icon = GUI:getChildByName(widget, "Panel_icon")

    GUI:removeFromParent(icon)
    
    if not data or next(data) == nil then 
        return icon
    end 

    local ui_bg = GUI:getChildByName(icon, "Image_iconBg")
    local ui_node = GUI:getChildByName(icon, "Node_icon")
    local info = {
        index = data.index,
        bgVisible = false,
        look = true
    }
    local goodsItem = GUI:ItemShow_Create(ui_node, "goodsItem".. data.index, 0, 0, info)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    local ui_count = GUI:getChildByName(icon, "Text_count")
    GUI:setVisible(ui_count, data.count ~= nil)
    if data.count then 
        GUI:Text_setString(ui_count, SL:GetSimpleNumber(data.count))
    end 

    local ui_have = GUI:getChildByName(icon, "Text_have")
    local ui_need = GUI:getChildByName(icon, "Text_need")
    GUI:setVisible(ui_have, data.needNum ~= nil)
    GUI:setVisible(ui_need, data.needNum ~= nil)
    GUI:setAnchorPoint(ui_have, 1, 0.5)
    GUI:setAnchorPoint(ui_need, 1, 0.5)

    if data.needNum then 
        local haveNum = tonumber(SL:GetMetaValue("MONEY", data.index)) or 0
        local needNum = data.needNum or 0
        local color = tonumber(haveNum) < tonumber(needNum) and "#ff0500" or "#28ef01"

        haveNum = SL:GetSimpleNumber(haveNum)
        needNum = SL:GetSimpleNumber(needNum)
        GUI:Text_setTextColor(ui_have, color)
        GUI:Text_setString(ui_have, haveNum)
        GUI:Text_setString(ui_need, "/"..needNum)

        local haveW = GUI:getContentSize(ui_have).width
        local needW = GUI:getContentSize(ui_need).width
        local iconW = GUI:getContentSize(icon).width
        GUI:setPositionX(ui_need, iconW - 2)
        GUI:setPositionX(ui_have, iconW - needW - 2)
    end 

    return icon
end

function CompoundItem.CreateCostCell(data)
    local file = SL:GetMetaValue("WINPLAYMODE") and "compound_item_layer_win32/compound_cost_cell" or "compound_item_layer/compound_cost_cell"
    local widget = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    GUI:LoadExport(widget, file)

    local item = GUI:getChildByName(widget, "item_money")

    GUI:removeFromParent(item)

    local node_cost = GUI:getChildByName(item, "Node_cost")
    local ui_num = GUI:getChildByName(item, "Text_num")

    local info = {
        index = data.id,
        bgVisible = false,
        look = true
    }
    local goodsItem = GUI:ItemShow_Create(node_cost, "goodsItem".. data.id, 0, 0, info)
    GUI:setAnchorPoint(goodsItem, 0, 0.5)
    GUI:setScale(goodsItem, 0.5)

    local haveNum = 0
    local isBind = SL:GetMetaValue("SERVER_OPTIONS", "BindGold")
    if isBind and data.id == MoneyType.BindYuanBao then
        haveNum = tonumber(SL:GetMetaValue("MONEY", data.id)) + tonumber(SL:GetMetaValue("MONEY", MoneyType.YuanBao))
    else
        haveNum = tonumber(SL:GetMetaValue("MONEY_ASSOCIATED", data.id)) or 0
    end 

    local needNum = data.count or 0
    local color = tonumber(haveNum) < tonumber(needNum) and "#ff0500" or "#28ef01"

    haveNum = SL:GetSimpleNumber(haveNum)
    needNum = SL:GetSimpleNumber(needNum)
    GUI:Text_setTextColor(ui_num, color)
    GUI:Text_setString(ui_num, haveNum.."/"..needNum)

    return item
end

function CompoundItem.RefreshCompoundRedPoint(upData)
    if not upData or next(upData) == nil then
        return
    end

    if upData.id then
        local function refreshRed()
            local secondPage = SL:GetMetaValue("COMPOUND_PAGE_BY_ID", upData.id)
            if secondPage then
                local firstPage = math.floor(secondPage / 1000)
                local firstLayout = GUI:getChildByTag(CompoundItem._ui["ListView_list1"], firstPage)

                if firstLayout then
                    local redState = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", firstPage)
                    local imgRed = GUI:getChildByName(firstLayout, "Image_red")
                    GUI:setVisible(imgRed, redState)
                end

                local secondLayout = GUI:getChildByTag(CompoundItem._ui["ListView_list2"], secondPage)
                if secondLayout then
                    local redState2 = SL:GetMetaValue("COMPOUND_CHECK_LIST_RED_POINT", firstPage, secondPage)
                    local imgRed2 = GUI:getChildByName(secondLayout, "Image_red")
                    GUI:setVisible(imgRed2, redState2)
                end

                local itemLayout = GUI:getChildByTag(CompoundItem._ui["ListView_list2"], upData.id + 100000) 
                if itemLayout then
                    local redState3 = SL:GetMetaValue("COMPOUND_RED_POINT_BY_ID", upData.id)
                    local imgRed3 = GUI:getChildByName(itemLayout, "Image_red")
                    GUI:setVisible(imgRed3, redState3)
                end 

                CompoundItem.UpdateCompoundLayer(CompoundItem.chooseCompoundIndex)
            end
        end 

        if upData.isAdd then 
            refreshRed()
        else 
            if upData.id == CompoundItem.chooseCompoundIndex then 
                refreshRed()
            end 
        end 
    end 
end

function CompoundItem.calcListWidth(node_list, defaultWidth)
    local itemCnt = #GUI:getChildren(node_list)
    if itemCnt > 0 then
        local item = GUI:ListView_getItemByIndex(node_list, 0)
        local itemW = GUI:getContentSize(item).width
        local listSize = GUI:getContentSize(node_list)
        local margin = GUI:ListView_getItemsMargin(node_list)
        local newW = itemCnt * itemW + (itemCnt - 1) * margin
        if newW < 0 or newW > defaultWidth then
            newW = defaultWidth
        end
        GUI:setContentSize(node_list, newW, listSize.height)
    end
end

function CompoundItem.calcListHeight(node_list, defaultHeight)
    local itemCnt = #GUI:getChildren(node_list)
    if itemCnt > 0 then
        local item = GUI:ListView_getItemByIndex(node_list, 0)
        local itemH = GUI:getContentSize(item).height
        local listSize = GUI:getContentSize(node_list)
        local margin = GUI:ListView_getItemsMargin(node_list)
        local newH = itemCnt * itemH + (itemCnt - 1) * margin
        if newH < 0 or newH > defaultHeight then
            newH = defaultHeight
        end
        GUI:setContentSize(node_list, listSize.width, newH)
    end
end

-- 刷新页面数据
function CompoundItem.RefreshCompoundUI(data)

end

-- 关闭界面
function CompoundItem.OnClose(ID)
    if ID == "CompoundItemGUI" then
        CompoundItem.RemoveEvent()
    end
end

-----------------------------------注册事件--------------------------------------
function CompoundItem.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_COMPOUND_RED_POINT, "CompoundItem", CompoundItem.RefreshCompoundRedPoint)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "CompoundItem", CompoundItem.OnClose)
end

function CompoundItem.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_COMPOUND_RED_POINT, "CompoundItem")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "CompoundItem")
end