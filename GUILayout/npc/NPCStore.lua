NPCStore = NPCStore or {}

NPCStore.perPageItemsCount = 8 -- 每页最多8个商品

function NPCStore.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local parent = GUI:GetWindow(nil, UIConst.LAYERID.NPCStoreGUI)
    if not parent then
        parent = GUI:Win_Create(UIConst.LAYERID.NPCStoreGUI, 0, 0, 0, 0, false, false, true, true)
        GUI:LoadExport(parent,
            SL:GetValue("IS_PC_OPER_MODE") and "npc/npc_store_layer_win32" or "npc/npc_store_layer")

        NPCStore._ui = GUI:ui_delegate(parent)
        local screenH = SL:GetValue("SCREEN_HEIGHT")
        GUI:setPositionY(NPCStore._ui.Panel_1, screenH - 177)

        NPCStore._pageMaxNums = NPCStore.perPageItemsCount or 1
        NPCStore._customize_panel = NPCStore._ui.Panel_customize
        NPCStore._root = NPCStore._ui.Panel_1

        NPCStore.RegisterEvent()
    end
    NPCStore.selectItemCell = nil
    NPCStore.listPage = 1
    NPCStore.InitUI(data)
end

function NPCStore.InitUI(data)
    data = data or {}
    if not data.Items then
        data.Items = {}
    end
    NPCStore.itemList = data.Items
    NPCStore.maxPage = math.ceil(#NPCStore.itemList / NPCStore._pageMaxNums)
    NPCStore.list = GUI:getChildByName(NPCStore._root, "ListView_list")
    NPCStore.btnOk = GUI:getChildByName(NPCStore._root, "Button_ok")
    NPCStore.btnLast = GUI:getChildByName(NPCStore._root, "Button_last")
    NPCStore.btnNext = GUI:getChildByName(NPCStore._root, "Button_next")
    NPCStore.btnClose = GUI:getChildByName(NPCStore._root, "Button_close")
    NPCStore.pagesText = GUI:getChildByName(NPCStore._root, "Text_pages")

    GUI:addOnClickEvent(NPCStore.btnClose, function()
        UIOperator:CloseNpcStoreUI()
    end)

    GUI:addOnClickEvent(NPCStore.btnOk, function()
        GUI:delayTouchEnabled(NPCStore.btnOk, 0.25)
        NPCStore.OnClickOkBtnEvent()
    end)

    GUI:addOnClickEvent(NPCStore.btnLast, function()
        NPCStore.ChangePage(true)
    end)

    GUI:addOnClickEvent(NPCStore.btnNext, function()
        NPCStore.ChangePage(false)
    end)

    GUI:Text_setString(NPCStore.pagesText, NPCStore.listPage .. "/" .. NPCStore.maxPage)

    NPCStore.RefreshList()
end

function NPCStore.ChangePage(isLeft)
    if isLeft and NPCStore.listPage <= 1 then
        return
    end
    if not isLeft and NPCStore.listPage >= NPCStore.maxPage then
        return
    end

    local changePage = isLeft and -1 or 1
    NPCStore.listPage = NPCStore.listPage + changePage

    NPCStore.CleanSelectData()

    NPCStore.selectItemCell = nil

    GUI:Text_setString(NPCStore.pagesText, NPCStore.listPage .. "/" .. NPCStore.maxPage)

    NPCStore.RefreshList()
end

function NPCStore.RefreshList(select_data)
    GUI:ScrollView_removeAllChildren(NPCStore.list)

    local data = NPCStore.itemList
    if not data or next(data) == nil then
        return
    end

    local beginIndex, endIndex = NPCStore.GetPageBeginAndEnd()
    for key = beginIndex, endIndex do
        local cell = NPCStore.CreateItemsListCell(data[key], key, select_data)
        if cell then
            GUI:ListView_pushBackCustomItem(NPCStore.list, cell)
        end
    end
end

function NPCStore.GetPageBeginAndEnd()
    local page = NPCStore.listPage or 1
    local maxList = #NPCStore.itemList
    if maxList < ((page - 1) * NPCStore._pageMaxNums + 1) then
        NPCStore.listPage = 1
        page = NPCStore.listPage
    end

    local beginIndex = (page - 1) * NPCStore._pageMaxNums + 1
    local endIndex = beginIndex + NPCStore._pageMaxNums - 1
    endIndex = math.min(maxList, endIndex)

    return beginIndex, endIndex
end

function NPCStore.CreateItemsListCell(data, key, select_data)
    local row, col = NPCStore.GetItemRowAndCol(key)
    local cell = nil
    if col == 1 then
        cell = GUI:Clone(GUI:getChildByName(NPCStore._customize_panel, "Panel_item"))
    else
        cell = GUI:ListView_getItemByIndex(NPCStore.list, row - 1)
    end
    local item = GUI:getChildByName(cell, "Panel_item" .. col)
    GUI:setVisible(item, true)
    local textItemName = GUI:getChildByName(item, "Text_item_name")
    local textItemPrice = GUI:getChildByName(item, "Text_item_price")
    local layout_bg = GUI:getChildByName(item, "Image_item_bg")
    local iconBg = GUI:getChildByName(item, "Image_icon_bg")

    GUI:setName(item, tostring(key))

    if data.MakeIndex then
        GUI:setStrTag(item, data.MakeIndex)
    end

    local name = data.Name or SL:GetValue("ITEM_NAME", data.Index)
    if name then
        GUI:Text_setString(textItemName, name)
    end

    if data.Price then
        GUI:Text_setString(textItemPrice, data.Price)
    end

    local Index = data.Index or SL:GetValue("ITEM_INDEX_BY_NAME", name)

    if Index then
        local itemCfg = SL:GetValue("ITEM_DATA", Index)
        if next(itemCfg) and data.Dura and data.DuraMax then
            itemCfg.Dura = data.Dura
            itemCfg.DuraMax = data.DuraMax
        else
            itemCfg = nil
        end
        local goodsItem = GUI:ItemShow_Create(iconBg, "goodsItem" .. Index, GUI:getContentSize(iconBg).width / 2, GUI:getContentSize(iconBg).height / 2, { itemData = itemCfg, index = Index, look = true })
        GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    end

    local function callback()
        NPCStore.CleanSelectData()
        NPCStore.ChooseItems(item, data)
        NPCStore.ResetSelectItemData(data)
    end
    GUI:addOnClickEvent(layout_bg, callback)

    if select_data and select_data.MakeIndex == data.MakeIndex then
        callback()
    end

    if col == 1 then
        return cell
    end

    return nil
end

-- 获取行列
function NPCStore.GetItemRowAndCol(index)
    local row = math.floor(index / 2)
    local col = 1

    if row > (NPCStore._pageMaxNums / 2) then
        row = row % (NPCStore._pageMaxNums / 2)
        if row == 0 then
            row = 4
        end
    end

    if index % 2 == 0 then
        col = 2
    end
    return row, col
end

function NPCStore.ResetSelectItemData(data)
    NPCStore.selectItemData = data or {}
end

function NPCStore.GetSelectItemData()
    return NPCStore.selectItemData
end

function NPCStore.CleanSelectData()
    NPCStore.selectItemData = nil
end

function NPCStore.ChooseItems(item, data)
    local function cleanSelectStatus()
        local textItemName = GUI:getChildByName(NPCStore.selectItemCell, "Text_item_name")
        local textItemPrice = GUI:getChildByName(NPCStore.selectItemCell, "Text_item_price")
        GUI:Text_setTextColor(textItemName, "#FFFFFF")
        GUI:Text_setTextColor(textItemPrice, "#FFFFFF")
        NPCStore.selectItemCell = nil
    end

    local function setSelect()
        local textItemName = GUI:getChildByName(item, "Text_item_name")
        local textItemPrice = GUI:getChildByName(item, "Text_item_price")
        GUI:Text_setTextColor(textItemName, "#FF0000")
        GUI:Text_setTextColor(textItemPrice, "#FF0000")
        NPCStore.selectItemCell = item
    end

    if not NPCStore.selectItemCell then
        setSelect()
    else
        cleanSelectStatus()
        setSelect()
    end
end

function NPCStore.OnClickOkBtnEvent()
    local data = NPCStore.GetSelectItemData()
    if not data or not next(data) then
        return
    end

    -- has menu
    if data.SubMenu and data.SubMenu > 0 then
        SL:RequestNpcStoreItemList(data)

        -- auto buy
    else
        SL:RequestNpcStoreBuy(data)
    end
end

function NPCStore.RemoveItems(MakeIndex)
    if MakeIndex and NPCStore.list then
        local cells = GUI:ListView_getItems(NPCStore.list)
        local removeTBIndex = nil
        for key, _cell in ipairs(cells) do
            for i = 1, 2 do
                local item = GUI:getChildByStrTag(_cell, MakeIndex)
                if item then
                    removeTBIndex = tonumber(GUI:getName(item))
                    break
                end
            end
        end

        if removeTBIndex then
            table.remove(NPCStore.itemList, removeTBIndex)
        end

        if NPCStore.GetSelectItemData() then
            NPCStore.CleanSelectData()
            NPCStore.selectItemCell = nil
            NPCStore.RefreshList()
        end
    end
end

function NPCStore.OnCloseLayer()
    UIOperator:CloseNpcStoreUI()
end

function NPCStore.OnClose(UID)
    if UID ~= UIConst.LAYERID.NPCStoreGUI then
        return false
    end

    NPCStore._ui = nil
    NPCStore.UnRegisterEvent()
end

function NPCStore.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NPCStore", NPCStore.OnClose) -- 关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "NPCStore", NPCStore.OnCloseLayer)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_STORE_ITEM_REMOVE, "NPCStore", NPCStore.RemoveItems)
end

function NPCStore.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NPCStore")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "NPCStore")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_STORE_ITEM_REMOVE, "NPCStore")
end

NPCStore.main()
