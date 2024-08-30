NPCMakeDrug = {}

NPCMakeDrug.perPageItemsCount = 10 -- 每页最多10条物品

function NPCMakeDrug.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local parent = GUI:GetWindow(nil, UIConst.LAYERID.NPCMakeDrugGUI)
    if not parent then
        parent = GUI:Win_Create(UIConst.LAYERID.NPCMakeDrugGUI, 0, 0, 0, 0, false, false, true, true)
        GUI:LoadExport(parent, "npc/npc_make_drug_layer")

        local ui = GUI:ui_delegate(parent)
        local screenH = SL:GetValue("SCREEN_HEIGHT")
        GUI:setPositionY(ui.Panel_1, screenH - 177)

        NPCMakeDrug._root = ui.Panel_1

        NPCMakeDrug.RegisterEvent()
    end
    NPCMakeDrug.InitUI(data)
end

-- 列表 cell
function NPCMakeDrug.CreateItemCell(parent)
    GUI:LoadExport(parent, "npc/npc_make_drug_cell")
end

function NPCMakeDrug.InitUI(data)
    NPCMakeDrug.itemList = data and data.items or {}
    NPCMakeDrug.maxPage = #GetPageData({ dataLength = #NPCMakeDrug.itemList, pageLength = NPCMakeDrug.perPageItemsCount })
    NPCMakeDrug.list = GUI:getChildByName(NPCMakeDrug._root, "ListView_list")
    NPCMakeDrug.btnOk = GUI:getChildByName(NPCMakeDrug._root, "Button_ok")
    NPCMakeDrug.btnLast = GUI:getChildByName(NPCMakeDrug._root, "Button_last")
    NPCMakeDrug.btnNext = GUI:getChildByName(NPCMakeDrug._root, "Button_next")
    NPCMakeDrug.btnClose = GUI:getChildByName(NPCMakeDrug._root, "Button_close")

    GUI:addOnClickEvent(NPCMakeDrug.btnClose, function()
        UIOperator:CloseNpcMakeDrugUI()
    end)

    GUI:addOnClickEvent(NPCMakeDrug.btnLast, function()
        NPCMakeDrug.ChangePage(true)
    end)

    GUI:addOnClickEvent(NPCMakeDrug.btnNext, function()
        NPCMakeDrug.ChangePage(false)
    end)

    GUI:addOnClickEvent(NPCMakeDrug.btnOk, function()
        GUI:delayTouchEnabled(NPCMakeDrug.btnOk)
        NPCMakeDrug.OnClickOkBtnEvent()
    end)

    NPCMakeDrug.RefreshList()
end

function NPCMakeDrug.ChangePage(isLeft)
    if isLeft and NPCMakeDrug.listPage <= 1 then
        return
    end

    if not isLeft and NPCMakeDrug.listPage >= NPCMakeDrug.maxPage then
        return
    end

    local changePage = isLeft and -1 or 1
    NPCMakeDrug.listPage = NPCMakeDrug.listPage + changePage

    NPCMakeDrug.CleanSelectData()

    NPCMakeDrug.selectItemCell = nil

    NPCMakeDrug.RefreshList()
end

function NPCMakeDrug.RefreshList()
    GUI:removeAllChildren(NPCMakeDrug.list)

    local data = NPCMakeDrug.itemList
    if not data or next(data) == nil then
        return
    end

    local beginIndex, endIndex = NPCMakeDrug.GetPageBeginAndEnd()
    for key = beginIndex, endIndex do
        local cell = NPCMakeDrug.CreateItemsListCell(data[key], key)
        GUI:ListView_pushBackCustomItem(NPCMakeDrug.list, cell.layout_bg)
    end
end

function NPCMakeDrug.GetPageBeginAndEnd()
    local page = NPCMakeDrug.listPage or 1
    local maxList = #NPCMakeDrug.itemList
    local data = {
        dataLength = maxList
    }
    local pageData = GetPageData(data)
    local beginIndex = pageData[page].beginItem
    local endIndex = pageData[page].endItem
    return beginIndex, endIndex
end

function NPCMakeDrug.CreateItemsListCell(data, key)
    local root = GUI:Node_Create(-1, "root", 0, 0)
    NPCMakeDrug.CreateItemCell(root)

    local layout_bg = GUI:getChildByName(root, "Panel_item")
    GUI:removeFromParent(layout_bg)
    local point = GUI:getChildByName(layout_bg, "Text_point")
    local textItemName = GUI:getChildByName(layout_bg, "Text_itemName")
    local textItemPrice = GUI:getChildByName(layout_bg, "Text_itemPrice")
    local textItemDura = GUI:getChildByName(layout_bg, "Text_itemDura")
    GUI:setVisible(textItemDura, false)
    GUI:setVisible(point, false)

    if data.name then
        GUI:Text_setString(textItemName, data.name)
    end

    if data.price then
        GUI:Text_setString(textItemPrice, string.format("%s 金币", data.price))
    end

    if data.stock and data.subMenu and data.subMenu > 0 then
        GUI:Text_setString(textItemDura, ">>>")
    end

    local cell = {
        layout_bg = layout_bg,
        text_name = textItemName,
        text_price = textItemPrice,
        text_dura = textItemDura,
        point = point
    }

    local function callback()
        NPCMakeDrug.CleanSelectData()
        NPCMakeDrug.ChooseItems(cell, data)
        NPCMakeDrug.ResetSelectItemData(data)
    end
    GUI:addOnClickEvent(layout_bg, callback)

    return cell
end

function NPCMakeDrug.ResetSelectItemData(data)
    NPCMakeDrug.selectItemData = data or {}
end

function NPCMakeDrug.GetSelectItemData()
    return NPCMakeDrug.selectItemData
end

function NPCMakeDrug.CleanSelectData()
    NPCMakeDrug.selectItemData = nil
end

function NPCMakeDrug.ChooseItems(cell, data)
    local function cleanSelectStatus()
        local textItemName = NPCMakeDrug.selectItemCell.text_name
        local textItemPrice = NPCMakeDrug.selectItemCell.text_price
        local textItemDura = NPCMakeDrug.selectItemCell.text_dura
        local point = NPCMakeDrug.selectItemCell.point
        GUI:setVisible(point, false)
        GUI:setVisible(textItemDura, data.Dura ~= nil)
        GUI:Text_setTextColor(textItemName, "#ffffff")
        GUI:Text_setTextColor(textItemPrice, "#ffffff")
        GUI:Text_setTextColor(textItemDura, "#ffffff")
        NPCMakeDrug.selectItemCell = nil
    end

    local function setSelect()
        GUI:Text_setTextColor(cell.text_name, "#ff0000")
        GUI:Text_setTextColor(cell.text_price, "#ff0000")
        GUI:Text_setTextColor(cell.text_dura, "#ff0000")
        GUI:setVisible(cell.point, true)
        GUI:setVisible(cell.text_dura, true)
        NPCMakeDrug.selectItemCell = cell
    end

    if not NPCMakeDrug.selectItemCell then
        setSelect()
    else
        cleanSelectStatus()
        setSelect()
    end
end

function NPCMakeDrug.OnClickOkBtnEvent()
    local data = NPCMakeDrug.GetSelectItemData()
    if not data or not next(data) then
        return
    end

    SL:RequestNpcMakeDrug(data)
end

function NPCMakeDrug.OnCloseLayer()
    UIOperator:CloseNpcMakeDrugUI()
end

function NPCMakeDrug.OnClose(UID)
    if UID ~= UIConst.LAYERID.NPCMakeDrugGUI then
        return false
    end
    NPCMakeDrug.UnRegisterEvent()
end

function NPCMakeDrug.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NPCMakeDrug", NPCMakeDrug.OnClose)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "NPCMakeDrug", NPCMakeDrug.OnCloseLayer)
end

function NPCMakeDrug.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NPCMakeDrug")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "NPCMakeDrug")
end

NPCMakeDrug.main()
