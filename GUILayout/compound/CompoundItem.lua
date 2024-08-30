CompoundItem = {}

local MoneyType = {
    YuanBao     = 2,
    BindYuanBao = 4,
}

function CompoundItem.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.CompoundItemGUI) then
        return
    end

    local compoundID = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if compoundID then
        CompoundItemData.SetOnCompoundID(compoundID)
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.CompoundItemGUI, 0, 0, 0, 0, false, false, true, true)
    CompoundItem._layer = parent
    CompoundItem._isWin32 = SL:GetValue("IS_PC_OPER_MODE")
    if CompoundItem._isWin32 then
        GUI:LoadExport(parent, "compound_item_layer_win32/compound_items_layer")
    else
        GUI:LoadExport(parent, "compound_item_layer/compound_items_layer")
    end
    

    CompoundItem._ui = GUI:ui_delegate(parent)
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    if CompoundItem._isWin32 then
        GUI:setPosition(CompoundItem._ui.Panel_1, screenW / 2, SL:GetValue("PC_POS_Y"))
    else
        GUI:setPosition(CompoundItem._ui.Panel_1, screenW / 2, screenH / 2)
    end

    -- 界面拖动
    GUI:Win_SetDrag(parent, CompoundItem._ui.Image_frame_bg)

    CompoundItem._defaultMargin = 10
    CompoundItem._defaultWidth = CompoundItem._isWin32 and 250 or 300
    CompoundItem._defaultHeight = 64

    CompoundItem._choosePage1 = 0        -- 记录第一页签
    CompoundItem._choosePageIndex = 0    -- 记录组合页签Index
    CompoundItem._chooseCompoundID = 0   -- 记录打开的合成ID, 每次打开需要通知脚本

    -- id
    local jumpID = CompoundItemData.GetOnCompoundID()
    if jumpID then
        local config = CompoundItemData.GetConfigByID(jumpID)
        if config and next(config) then
            CompoundItem._choosePage1 = config.page1
            CompoundItem._choosePageIndex = config.page2 + CompoundItem._choosePage1 * 1000
            CompoundItem._chooseCompoundID = config.id
        end
    end

    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.ItemCompound,
        root = CompoundItem._ui.Panel_show
    })

    CompoundItem.InitCompoundUI()
    CompoundItem.RegisterEvent()
end

function CompoundItem.InitTypeMenu()
    local menuList1 = CompoundItem._ui["ListView_list1"]
    GUI:ListView_removeAllItems(menuList1)

    local data = CompoundItemData.GetShowItemList()
    local list = {}

    for i, v in pairs(data) do
        local param = CompoundItem.GetPageParam(i)
        local page1 = param.page1
        if not list[page1] then
            local isShow = CompoundItemData.CheckTabIsShow(page1) 
            if isShow then
                list[page1] = true
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
        local redState = CompoundItemData.CheckTabRedState(page1)
        if redState and CompoundItem._choosePage1 == 0 then
            CompoundItem._choosePage1 = page1
            break
        end
    end 

    if CompoundItem._choosePage1 == 0 then
        CompoundItem._choosePage1 = sortList[1]
    end

    for i, page1 in ipairs(sortList) do
        local cell = CompoundItem.CreateMenuType(page1)
        GUI:ListView_pushBackCustomItem(menuList1, cell)

        local cellUI = GUI:ui_delegate(cell)
        GUI:setTag(cell, page1)

        local pageName = CompoundItemData.GetPageName(page1)
        GUI:Button_setTitleText(cellUI.Button_type, pageName)
        GUI:Button_setTitleColor(cellUI.Button_type, CompoundItem._choosePage1 == page1 and "#f8e6c6" or "#6c6861")
        GUI:Button_titleEnableOutline(cellUI.Button_type, "#111111", 2)
        GUI:Button_setTitleFontSize(cellUI.Button_type, CompoundItem._isWin32 and 14 or 18)
        GUI:Button_setBright(cellUI.Button_type, CompoundItem._choosePage1 ~= page1)
        GUI:addOnClickEvent(cellUI.Button_type, function()
            CompoundItem.ChangeCompoundPage(page1)
        end)

        -- 红点状态
        local redState = CompoundItemData.CheckTabRedState(page1)
        GUI:setVisible(cellUI.Image_red, redState)
    end
end

function CompoundItem.GetPageParam(pageIndex)
    local param = {}
    param.page1 = math.floor(pageIndex / 1000)
    param.page2 = pageIndex - param.page1 * 1000
    return param
end

function CompoundItem.RefreshInfoMenu()
    local menuList2 = CompoundItem._ui["ListView_list2"]
    GUI:ListView_removeAllItems(menuList2)

    local data = CompoundItemData.GetShowItemList()
    local list = {}

    for i, v in pairs(data) do 
        local param = CompoundItem.GetPageParam(i)
        if not list[i] and CompoundItem._choosePage1 == param.page1 then
            local isShow = SL:GetValue("COMPOUND_CHECK_LIST_IS_SHOW", param.page1, param.page2) 
            if isShow then
                list[i] = true
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

    for _, pageIndex in ipairs(sortList) do
        local param = CompoundItem.GetPageParam(pageIndex)
        local redState = CompoundItemData.CheckTabRedState(CompoundItem._choosePage1, param.page2)
        if redState and CompoundItem._choosePageIndex == 0 then
            CompoundItem._choosePageIndex = pageIndex
            break
        end
    end

    if CompoundItem._choosePageIndex == 0 then
        CompoundItem._choosePageIndex = sortList[1]
    end

    local jumpCell = nil
    local jumpChildCell = nil
    local childCount = 0

    for i, pageIndex in ipairs(sortList) do
        local cell = CompoundItem.CreateMenuCellLevel2(pageIndex)
        GUI:ListView_pushBackCustomItem(menuList2, cell)

        local cellUI = GUI:ui_delegate(cell)
        GUI:setTag(cell, pageIndex)

        -- btn
        local pageName = CompoundItemData.GetPageName(pageIndex)
        GUI:Button_setTitleText(cellUI.Button_type2, pageName)
        GUI:Button_setTitleColor(cellUI.Button_type2, CompoundItem._choosePageIndex == pageIndex and "#f8e6c6" or "#6c6861")
        GUI:Button_titleEnableOutline(cellUI.Button_type2, "#111111", 2)
        GUI:Button_setTitleFontSize(cellUI.Button_type2, CompoundItem._isWin32 and 14 or 18)
        GUI:Button_setBright(cellUI.Button_type2, CompoundItem._choosePageIndex ~= pageIndex)
        GUI:addOnClickEvent(cellUI.Button_type2, function()
            CompoundItem.ChangeChooseList(pageIndex)
        end)

        GUI:setRotation(cellUI.Image_opened, CompoundItem._choosePageIndex == pageIndex and 0 or 90)

        -- red point
        local param = CompoundItem.GetPageParam(pageIndex)
        local redState = CompoundItemData.CheckTabRedState(CompoundItem._choosePage1, param.page2)
        GUI:setVisible(cellUI.Image_red, redState)

        if CompoundItem._choosePageIndex == pageIndex then
            jumpCell = cell
        end

        local childList = CompoundItemData.GetShowItemListByPageIndex(pageIndex)
        if childList and next(childList) and CompoundItem._choosePageIndex == pageIndex then
            if CompoundItem._chooseCompoundID == 0 then
                for _, item in ipairs(childList) do
                    local isShow = CompoundItemData.CheckStrCondition(item.showcondition)
                    if isShow then
                        local compoundID = item.id
                        local itemRedState = CompoundItemData.GetCompoundStateByID(compoundID)
                        if itemRedState and CompoundItem._chooseCompoundID == 0 then
                            CompoundItem._chooseCompoundID = compoundID
                            break
                        end
                    end
                end
            end

            if CompoundItem._chooseCompoundID ~= 0 then
                CompoundItem.UpdateCompoundLayer(CompoundItem._chooseCompoundID)
            end

            for index, item in ipairs(childList) do
                local isShow = CompoundItemData.CheckStrCondition(item.showcondition)
                if isShow then
                    local compoundID = item.id
                    if CompoundItem._chooseCompoundID == 0 then
                        CompoundItem.UpdateCompoundLayer(compoundID)
                    end
        
                    local cell = CompoundItem.CreateMenuCellLevel3(compoundID)
                    GUI:ListView_pushBackCustomItem(menuList2, cell)

                    local cellUI = GUI:ui_delegate(cell)
                    GUI:setTag(cell, compoundID + 100000)

                    GUI:setVisible(cellUI.Image_tag, CompoundItem._chooseCompoundID == compoundID)
                    GUI:addOnClickEvent(cell, function()
                        CompoundItem.ChangeChooseID(compoundID)
                    end)

                    GUI:setVisible(cellUI.Image_red, CompoundItemData.GetCompoundStateByID(compoundID))
                    if index ~= 1 and CompoundItem._chooseCompoundID == compoundID then
                        jumpChildCell = cell
                    end

                    local productItemID = item.production and item.production.id
                    local nameTitle = item.page3name
                    if (not nameTitle or nameTitle == "") and productItemID  then
                        nameTitle = SL:GetValue("ITEM_NAME", productItemID)
                    end
                    GUI:Text_setString(cellUI.Text_name, nameTitle)
                    GUI:setTouchEnabled(cell, CompoundItem._chooseCompoundID ~= compoundID)

                    childCount = childCount + 1
                end
            end
        end
    end

    -- 动态跳到对应的标签，方便操作
    if jumpCell or jumpChildCell then
        local chooseCell = jumpChildCell or jumpCell
        local jumpIndex = GUI:ListView_getItemIndex(menuList2, chooseCell) + childCount
        local maxIndex = #GUI:ListView_getItems(menuList2) - 1
        local pos = math.min(jumpIndex - 1, maxIndex)
        GUI:ListView_jumpToItem(menuList2, pos, GUI:p(0, 0), GUI:p(0, 0))
    end

    GUI:ListView_doLayout(menuList2)
end

function CompoundItem.ClearCompoundUI()
    GUI:ListView_removeAllItems(CompoundItem._ui["ListView_2"])
    GUI:ListView_removeAllItems(CompoundItem._ui["ListView_get"])
    GUI:ListView_removeAllItems(CompoundItem._ui["ListView_money"])

    GUI:setVisible(CompoundItem._ui["Panel_material"], false)
    GUI:setVisible(CompoundItem._ui["Panel_get"], false)
    GUI:setVisible(CompoundItem._ui["Panel_money"], false)
end

-- 初始化 UI
function CompoundItem.InitCompoundUI()
    CompoundItem.ClearCompoundUI()

    -- 关闭按钮
    GUI:addOnClickEvent(CompoundItem._ui["Button_close"], function()
        UIOperator:CloseCompoundItemUI()
    end)

    -- 帮助按钮
    GUI:addOnClickEvent(CompoundItem._ui["Button_help"], function(sender)
        local config = CompoundItemData.GetOnCompoundData()
        if not config then
            return
        end

        local pos = GUI:getWorldPosition(sender)
        local info = {
            str = config.helpdesc or "",
            worldPos = {x = pos.x + 5, y = pos.y},
            width = 440,
            anchorPoint = {x = 0, y = 1}
        }
        UIOperator:OpenCommonDescTipsUI(info)
    end)

    -- 合成按钮
    GUI:addOnClickEvent(CompoundItem._ui["Button_compound"], function()
        CompoundItem.SubmitCompoundItem()
    end)

    local materialList = CompoundItem._ui["ListView_2"] 
    local productList = CompoundItem._ui["ListView_get"]

    local scrollEvent = function(listView, dir)
        if not dir then
            return
        end
        local innerW = GUI:ListView_getInnerContainerSize(listView).width
        local listW = GUI:getContentSize(listView).width
        if innerW > listW then
            local innerPos = GUI:ListView_getInnerContainerPosition(listView)
            local intervalW = innerW - listW
            local percent = (intervalW + innerPos.x + 50 * dir) / intervalW * 100
            percent = math.min(math.max(0, percent), 100)
            GUI:ListView_scrollToPercentHorizontal(listView, percent, 0.03, false)
        end
    end

    -- 左箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_left"], function()
        scrollEvent(materialList, -1)
    end)

    -- 右箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_right"], function()
        scrollEvent(materialList, 1)
    end)

    -- 左箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_left2"], function()
        scrollEvent(productList, -1)
    end)

    -- 右箭头
    GUI:addOnClickEvent(CompoundItem._ui["Button_right2"], function()
        scrollEvent(productList, 1)
    end)

    -- 设置间隔
    GUI:ListView_setItemsMargin(materialList, GUI:ListView_getItemsMargin(materialList) + CompoundItem._defaultMargin)
    GUI:ListView_setItemsMargin(productList, GUI:ListView_getItemsMargin(productList) + CompoundItem._defaultMargin)


    -- 初始化菜单
    CompoundItem.InitTypeMenu()

    -- 刷新菜单详情展示
    CompoundItem.RefreshInfoMenu()
end 

-- 刷新页面
function CompoundItem.UpdateCompoundLayer(id)
    CompoundItem.ClearCompoundUI()
    local materialList = CompoundItem._ui["ListView_2"]
    local productList = CompoundItem._ui["ListView_get"]
    local moneyList = CompoundItem._ui["ListView_money"]

    local lastChooseID = CompoundItem._chooseCompoundID
    CompoundItem._chooseCompoundID = id
    CompoundItemData.SetOnCompoundID(id)
    local config = CompoundItemData.GetConfigByID(id)
    if config then
        if CompoundItem._chooseCompoundID ~= lastChooseID then
            SL:RequestCompoundChangeJson(CompoundItem._chooseCompoundID) -- 发给脚本记录
        end

        local material = config.materialCost
        if #material > 0 then
            GUI:setVisible(CompoundItem._ui["Panel_material"], true)

            local resetSize = false
            for i, v in ipairs(material) do
                local itemData = {
                    index = v.id,
                    needNum = v.count,
                    look = true,
                    bgVisible = true
                }
                local item = CompoundItem.CreateItemIcon(itemData)
                GUI:ListView_pushBackCustomItem(materialList, item)
                resetSize = true
            end

            if resetSize then
                CompoundItem.CalcListWidth(materialList, CompoundItem._defaultWidth)
            end
        end

        local product = config.production
        if product and next(product) then
            GUI:setVisible(CompoundItem._ui["Panel_get"], true)

            local itemData = {
                index = product.id,
                count = product.count,
                bgVisible = true,
                look = true
            }
            local item = CompoundItem.CreateItemIcon(itemData)
            GUI:ListView_pushBackCustomItem(productList, item)
            CompoundItem.CalcListWidth(productList, CompoundItem._defaultWidth)
        end

        local money = config.moneyCost
        if money and next(money) then
            GUI:setVisible(CompoundItem._ui["Panel_money"], true)
            GUI:ListView_setItemsMargin(moneyList, -10)

            local resetSize = false
            for i, data in ipairs(money) do
                if data and data.id then
                    local moneyCost = CompoundItem.CreateCostCell(data)
                    GUI:ListView_pushBackCustomItem(moneyList, moneyCost)
                    resetSize = true
                end
            end

            if resetSize then
                CompoundItem.CalcListHeight(moneyList, 70)
            end
            GUI:ListView_jumpToBottom(moneyList)
        end
    end

    local isCanCompound = CompoundItemData.CheckIsCanCompoud(config, false)
    GUI:Button_setGrey(CompoundItem._ui["Button_compound"], not isCanCompound)
end

function CompoundItem.SubmitCompoundItem()
    local config = CompoundItemData.GetOnCompoundData()
    if not config then
        return
    end

    local isCanCompound = CompoundItemData.CheckIsCanCompoud(config, false)
    if not isCanCompound then
        return
    end

    local function chooseToCompound()
        SL:ResquestCompoundItem(config.id)
    end

    if config.confirmtype and config.confirmtype > 0 then
        local produceItemID = config.production and config.production.id
        local productItemName = produceItemID and SL:GetValue("ITEM_NAME", produceItemID)
        local function callback(bType)
            if bType == 1 then
                chooseToCompound()
            end
        end
        local data = {}
        data.str = string.format("确认合成 <font color='#28ef01' size='%s'>%s</font> ？", SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), productItemName)
        data.callback = callback
        data.btnType = 2
        UIOperator:OpenCommonTipsUI(data)
    else
        chooseToCompound()
    end
end

-- 第一页签切换
function CompoundItem.ChangeCompoundPage(page1)
    local oldPage1 = CompoundItem._choosePage1
    CompoundItem._choosePage1 = page1
    CompoundItem._choosePageIndex = 0

    CompoundItem.UpdateCompoundLayer(0)

    if not CompoundItem.UpdateMenuType1Show(oldPage1, page1) then
        CompoundItem.InitTypeMenu()
    end

    CompoundItem.RefreshInfoMenu()
end

-- 第一页签 item 刷新
function CompoundItem.UpdateMenuType1Show(oldPage1, page1)
    if not page1 then
        return false
    end

    local menuList1 = CompoundItem._ui["ListView_list1"]         
    if oldPage1 then
        local item = GUI:getChildByTag(menuList1, oldPage1)
        if item then
            local typeBtn = GUI:getChildByName(item, "Button_type")
            GUI:Button_setTitleColor(typeBtn, "#6c6861")
            GUI:Button_setBright(typeBtn, true)
            local redState = CompoundItemData.CheckTabRedState(oldPage1)
            GUI:setVisible(GUI:getChildByName(item, "Image_red"), redState)
            GUI:setTouchEnabled(typeBtn, true)
        end
    end

    local item = GUI:getChildByTag(menuList1, page1)
    if item then
        local typeBtn = GUI:getChildByName(item, "Button_type")
        GUI:Button_setTitleColor(typeBtn, "#f8e6c6")
        GUI:Button_setBright(typeBtn, false)
        local redState = CompoundItemData.CheckTabRedState(page1)
        GUI:setVisible(GUI:getChildByName(item, "Image_red"), redState)
        GUI:setTouchEnabled(typeBtn, false)
        return true
    end
    return false
end

-- 第二页签切换
function CompoundItem.ChangeChooseList(page2)
    CompoundItem._choosePageIndex = page2

    CompoundItem.UpdateCompoundLayer(0)
    CompoundItem.RefreshInfoMenu()
end

-- 第二页签 展开 改变
function CompoundItem.ChangeChooseID(id)
    CompoundItem.UpdateCompoundLayer(id)

    if not CompoundItem.UpdateChooseItems(id) then
        CompoundItem.RefreshInfoMenu()
    end
end

-- 第二页签 展开 item 刷新
function CompoundItem.UpdateChooseItems(id)
    if not id then
        return false
    end
    
    local isUpdate = false
    local chooseTag = id + 100000
    local menuList2 = CompoundItem._ui["ListView_list2"]     
    local items = GUI:ListView_getItems(menuList2)
    for k, item in ipairs(items) do
        local isShow = chooseTag == GUI:getTag(item)
        local tagImg = GUI:getChildByName(item, "Image_tag")
        if isShow then
            isUpdate = true
            CompoundItem.UpdateCompoundLayer(id)
        end

        if tagImg then
            GUI:setVisible(tagImg, isShow)
        end
        GUI:setTouchEnabled(item, not isShow)
    end
    return isUpdate
end

function CompoundItem.CreateMenuType(index)
    local parent = GUI:Widget_Create(-1, "widget" .. index, 0, 0)
    if CompoundItem._isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compound_list_btn1")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compound_list_btn1")
    end 

    local cell = GUI:getChildByName(parent, "Panel_1")
    GUI:removeFromParent(cell)
    return cell
end

function CompoundItem.CreateMenuCellLevel2(index)
    local parent = GUI:Widget_Create(-1, "menu_level2_" .. index, 0, 0)
    if CompoundItem._isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compound_list_btn2")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compound_list_btn2")
    end 

    local cell = GUI:getChildByName(parent, "Panel_1")
    GUI:removeFromParent(cell)

    return cell
end

function CompoundItem.CreateMenuCellLevel3(index)
    local parent = GUI:Widget_Create(-1, "menu_level3_" .. index, 0, 0)
    if CompoundItem._isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compound_list_btn3")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compound_list_btn3")
    end 

    local cell = GUI:getChildByName(parent, "Panel_1")
    GUI:removeFromParent(cell)

    return cell
end

-- 创建Icon
function CompoundItem.CreateItemIcon(data)
    local parent = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    if CompoundItem._isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compound_item_cell")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compound_item_cell")
    end
    
    local cell = GUI:getChildByName(parent, "Panel_icon")

    if not data or not next(data) then 
        GUI:removeFromParent(cell)
        return cell
    end 

    local uiNode = GUI:getChildByName(cell, "Node_icon")
    local info = {
        index = data.index,
        bgVisible = false,
        look = true
    }
    local item = GUI:ItemShow_Create(uiNode, "item_" .. data.index, 0, 0, info)
    GUI:setAnchorPoint(item, 0.5, 0.5)
    
    local countText = GUI:getChildByName(cell, "Text_count")
    GUI:setVisible(countText, data.count ~= nil)
    if data.count then 
        GUI:Text_setString(countText, SL:GetSimpleNumber(data.count))
    end 

    local haveText = GUI:getChildByName(cell, "Text_have")
    local needText = GUI:getChildByName(cell, "Text_need")
    GUI:setVisible(haveText, data.needNum ~= nil)
    GUI:setVisible(needText, data.needNum ~= nil)
    GUI:setAnchorPoint(haveText, 1, 0.5)
    GUI:setAnchorPoint(needText, 1, 0.5)

    if data.needNum then 
        local haveNum = tonumber(SL:GetValue("MONEY", data.index)) or 0
        local needNum = data.needNum or 0
        local color = tonumber(haveNum) < tonumber(needNum) and "#ff0500" or "#28ef01"

        haveNum = SL:GetSimpleNumber(haveNum)
        needNum = SL:GetSimpleNumber(needNum)
        GUI:Text_setTextColor(haveText, color)
        GUI:Text_setString(haveText, haveNum)
        GUI:Text_setString(needText, "/" .. needNum)

        local haveWid = GUI:getContentSize(haveText).width
        local needWid = GUI:getContentSize(needText).width
        local iconWid = GUI:getContentSize(cell).width
        GUI:setPositionX(needText, iconWid - 2)
        GUI:setPositionX(haveText, iconWid - needWid - 2)
    end 

    GUI:removeFromParent(cell)
    return cell
end

function CompoundItem.CreateCostCell(data)
    local parent = GUI:Widget_Create(-1, "widget", 0, 0, 0, 0)
    if CompoundItem._isWin32 then 
        GUI:LoadExport(parent, "compound_item_layer_win32/compound_cost_cell")
    else 
        GUI:LoadExport(parent, "compound_item_layer/compound_cost_cell")
    end
    
    local cell = GUI:getChildByName(parent, "item_money")

    local costNode = GUI:getChildByName(cell, "Node_cost")
    local numText = GUI:getChildByName(cell, "Text_num")

    local info = {
        index = data.id,
        bgVisible = false,
        look = true
    }
    local item = GUI:ItemShow_Create(costNode, "item_" .. data.id, 0, 0, info)
    GUI:setAnchorPoint(item, 0, 0.5)
    GUI:setScale(item, 0.5)

    local haveNum = 0
    local isBind = SL:GetValue("SERVER_OPTIONS", "BindGold")
    if isBind and data.id == MoneyType.BindYuanBao then
        haveNum = tonumber(SL:GetValue("MONEY", data.id)) + tonumber(SL:GetValue("MONEY", MoneyType.YuanBao))
    else
        haveNum = tonumber(SL:GetValue("MONEY_ASSOCIATED", data.id)) or 0
    end 

    local needNum = data.count or 0
    local color = tonumber(haveNum) < tonumber(needNum) and "#ff0500" or "#28ef01"

    haveNum = SL:GetSimpleNumber(haveNum)
    needNum = SL:GetSimpleNumber(needNum)
    GUI:Text_setTextColor(numText, color)
    GUI:Text_setString(numText, haveNum .. "/" .. needNum)

    GUI:removeFromParent(cell)
    return cell
end

function CompoundItem.RefreshCompoundRedPoint(upData)
    if not upData or next(upData) == nil then
        return
    end

    if upData.id then
        local function refreshRed()
            local secondPage = SL:GetValue("COMPOUND_PAGE_BY_ID", upData.id)
            local config = CompoundItemData.GetConfigByID(upData.id)
            local firstPage = config and config.page1
            local secondPage = config and config.page2
            if firstPage and secondPage then
                local firstLayout = GUI:getChildByTag(CompoundItem._ui["ListView_list1"], firstPage)

                if firstLayout then
                    local redState = CompoundItemData.CheckTabRedState(firstPage)
                    local imgRed = GUI:getChildByName(firstLayout, "Image_red")
                    GUI:setVisible(imgRed, redState)
                end

                local secondLayout = GUI:getChildByTag(CompoundItem._ui["ListView_list2"], secondPage)
                if secondLayout then
                    local redState2 = CompoundItemData.CheckTabRedState(firstPage, secondPage)
                    local imgRed2 = GUI:getChildByName(secondLayout, "Image_red")
                    GUI:setVisible(imgRed2, redState2)
                end

                local itemLayout = GUI:getChildByTag(CompoundItem._ui["ListView_list2"], upData.id + 100000) 
                if itemLayout then
                    local redState3 = CompoundItemData.GetCompoundStateByID(upData.id)
                    local imgRed3 = GUI:getChildByName(itemLayout, "Image_red")
                    GUI:setVisible(imgRed3, redState3)
                end 

                if CompoundItem._chooseCompoundID == upData.id then
                    CompoundItem.UpdateCompoundLayer(CompoundItem._chooseCompoundID)
                end
            end
        end 

        refreshRed()
    end 
end

function CompoundItem.CalcListWidth(listView, defaultWidth)
    local itemNum = #GUI:getChildren(listView)
    if itemNum > 0 then
        local item = GUI:ListView_getItemByIndex(listView, 0)
        local itemW = GUI:getContentSize(item).width
        local margin = GUI:ListView_getItemsMargin(listView)
        local newWid = itemNum * itemW + (itemNum - 1) * margin
        if newWid < 0 or newWid > defaultWidth then
            newWid = defaultWidth
        end
        local listSize = GUI:getContentSize(listView)
        GUI:setContentSize(listView, newWid, listSize.height)
    end
end

function CompoundItem.CalcListHeight(listView, defaultHeight)
    local itemNum = #GUI:getChildren(listView)
    if itemNum > 0 then
        local item = GUI:ListView_getItemByIndex(listView, 0)
        local itemH = GUI:getContentSize(item).height
        local margin = GUI:ListView_getItemsMargin(listView)
        local newH = itemNum * itemH + (itemNum - 1) * margin
        if newH < 0 or newH > defaultHeight then
            newH = defaultHeight
        end
        local listSize = GUI:getContentSize(listView)
        GUI:setContentSize(listView, listSize.width, newH)
    end
end


-- 关闭界面
function CompoundItem.OnClose(ID)
    if ID == UIConst.LAYERID.CompoundItemGUI then
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.ItemCompound,
        })
        CompoundItemData.SetOnCompoundID()
        CompoundItem.RemoveEvent()
    end
end

-----------------------------------注册事件--------------------------------------
function CompoundItem.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_COMPOUND_RED_POINT, "CompoundItem", CompoundItem.RefreshCompoundRedPoint, CompoundItem._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "CompoundItem", CompoundItem.OnClose)
end

function CompoundItem.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "CompoundItem")
end
--------------------------------------------------------------------------------

CompoundItem.main()