Storage = {}

-- 存取模式
local STORE_MODE = {
    normal = 1, -- 普通的双击存取
    quick  = 2, -- 快速存取
}

function Storage.Init(isWin32)
    Storage.lockImg        = "res/public/icon_tyzys_01.png"
    Storage._PWidth        = isWin32 and 336 or 508   -- 容器可见区域 宽
    Storage._PHeight       = isWin32 and 254.4 or 384 -- 容器可见区域 高
    Storage._PerPageNum    = 48
    Storage._PerRowItemNum = 8
    Storage._PerColItemNum = 6
    Storage._MaxPage       = 5
    Storage._selPage       = 0  -- 当前选中的页签
    Storage._pageBtns      = {}
    Storage._defaultNum    = 48 -- 官方默认仓库格子数量
end

function Storage.main()
    local data = GUI:GetLayerOpenParam()
    local page = data and data.initPage
    local parent = GUI:Win_Create(UIConst.LAYERID.NPCStorageGUI, 0, 0, 0, 0, false, false, true, true)
    local isWin32 = SL:GetValue("IS_PC_OPER_MODE")
    GUI:LoadExport(parent, isWin32 and "bag/storage_layer_win32" or "bag/storage_layer")

    -- 初始化数据
    Storage.Init(isWin32)

    Storage._ui = GUI:ui_delegate(parent)
    Storage._openedCount = SL:GetValue("STROAGE_OPEN_SIZE")
    Storage._PerPageNum = Storage._PerPageNum or SLDefine.NPC_STORAGE_MAX_PAGE

    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local pSizeH = GUI:getContentSize(Storage._ui["Panel_1"]).height
    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:setPositionY(Storage._ui["Panel_1"], screenH - pSizeH / 2 - 70)
    else
        GUI:setPositionY(Storage._ui["Panel_1"], screenH / 2 + 20)
    end

    local storage_row_col = SL:GetValue("GAME_DATA", "bag_storage_row_col_max")
    if isWinMode and storage_row_col then
        local slices = string.split(storage_row_col, "|")
        Storage._PerRowItemNum = tonumber(slices[1]) or 8
        Storage._PerColItemNum = tonumber(slices[2]) or 6
        Storage._PerPageNum = Storage._PerRowItemNum * Storage._PerColItemNum

        -- 隐藏页签
        if Storage._PerPageNum > Storage._defaultNum then
            for i = 1, Storage._MaxPage do
                local pageBtn = Storage._ui["Button_page" .. i]
                GUI:setVisible(pageBtn, false)
            end
        end
    end

    SL:SetValue("STORAGE_PAGE_INDEX", Storage._selPage)
    SL:SetValue("STORAGE_TOUCH_TYPE", STORE_MODE.normal)

    Storage._root = Storage._ui.Panel_1
    Storage._panelItems = Storage._root:getChildByName("Panel_items")

    -- 界面拖动
    GUI:Win_SetDrag(parent, Storage._ui["Panel_1"])

    Storage.InitUI()
    Storage.InitEditMode()
    Storage.InitMouseEvent()
    -- 初始化右侧页签
    Storage.InitPage()

    Storage.PageTo(page or 1)
    Storage.UpdateItemList()

    SL:AttachTXTSUI({
        root = Storage._root,
        index = SLDefine.SUIComponentTable.Storage
    })

    Storage.RegisterEvent()

    -- 交易行 截图节点 请勿删除
    Storage._screenshotRootNode = Storage._ui["Panel_1"]
end

function Storage.InitPage()
    local openNum = SL:GetValue("GAME_DATA", "warehouse_max_num") or 240
    SL:Print("仓库最大格子数量：", openNum)

    -- 当前最大显示几页
    Storage._openPage = math.ceil(openNum / Storage._PerPageNum)
    Storage._openPage = math.max(Storage._openPage, 1)
    Storage._openPage = math.min(Storage._openPage, Storage._MaxPage)

    for i = 1, Storage._MaxPage do
        local pageBtn = Storage._ui["Button_page" .. i]
        GUI:setVisible(pageBtn, false)
        if Storage._openPage ~= 1 and i <= Storage._openPage then
            GUI:setVisible(pageBtn, true)
            GUI:setTag(pageBtn, i)
            Storage._pageBtns[i] = pageBtn
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                Storage.PageTo(i)
                Storage.UpdateItemList()
            end)
        end
    end
end

function Storage.PageTo(page)
    if Storage._selPage == page then
        return false
    end

    SL:SetValue("STORGE_PAGE_CUR", page)
    Storage._selPage = page
    Storage.SetPageBtnStatus()
end

function Storage.SetPageBtnStatus()
    for i = 1, Storage._openPage do
        local btnPage = Storage._pageBtns[i]
        if btnPage then
            local isPress = i == Storage._selPage and true or false
            GUI:Button_setBright(btnPage, not isPress)
            GUI:setLocalZOrder(btnPage, isPress and Storage._openPage + 1 or GUI:getTag(btnPage))
            local pageText = GUI:getChildByName(btnPage, "PageText")
            GUI:Text_setTextColor(pageText, isPress and "#f8e6c6" or "#807256")
            GUI:setScale(pageText, isPress and 1 or 0.9)
        end
    end
end

function Storage.InitEditMode(...)
    local items = {
        "Image_bg",
        "Button_quick",
        "Button_reset",
        "Button_close",
        "Panel_items",
        "Panel_itemstouch",
    }
    for _, widgetName in ipairs(items) do
        if Storage._ui[widgetName] then
            Storage._ui[widgetName].editMode = 1
        end
    end

    for i = 1, Storage._MaxPage do
        if Storage._ui["Button_page" .. i] then
            Storage._ui["Button_page" .. i].editMode = 1
            local btnText = Storage._ui["Button_page" .. i]:getChildByName("PageText")
            if btnText then
                btnText.editMode = 1
            end
        end
    end
end

function Storage.InitMouseEvent()
    local function addItemIntoStorage(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        if state then
            local goToName = GUIDefine.ItemGoTo.STORAGE
            local data = {}
            data.target = goToName
            data.pos = touchPos
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    local function setNoSwallowMouse()
        return -1
    end

    local addItemPanel = GUI:getChildByName(Storage._root, "Panel_itemstouch")
    GUI:setSwallowTouches(addItemPanel, false)
    GUI:addMouseButtonEvent(addItemPanel, {
        onRightDownFunc = setNoSwallowMouse,
        onSpecialRFunc = addItemIntoStorage
    })
end

function Storage.InitUI()
    -- 关闭
    local btnClose = GUI:getChildByName(Storage._root, "Button_close")
    local function closePanel()
        UIOperator:CloseNpcStorageUI()
    end
    GUI:addOnClickEvent(btnClose, closePanel)

    -- 快速存取
    local btnQuickPut = GUI:getChildByName(Storage._root, "Button_quick")
    local function quickPut(sender)
        local touchType = SL:GetValue("STORAGE_TOUCH_TYPE")
        if touchType == STORE_MODE.normal then
            touchType = STORE_MODE.quick
        else
            touchType = STORE_MODE.normal
        end
        SL:SetValue("STORAGE_TOUCH_TYPE", touchType)
        local text = touchType == STORE_MODE.normal and "快速存取" or "取消选中"
        GUI:Button_setTitleText(sender, text)
    end
    GUI:addOnClickEvent(btnQuickPut, quickPut)

    -- 整理仓库
    local btnRefresh = GUI:getChildByName(Storage._root, "Button_reset")
    local function refreshStorage()
        GUI:delayTouchEnabled(btnRefresh, 0.5)
        SL:ArrangeStorageData(Storage._selPage)
        Storage._resetList = true
        Storage.UpdateItemList()
    end
    GUI:addOnClickEvent(btnRefresh, refreshStorage)
end

function Storage.UpdateItemList(page)
    GUI:removeAllChildren(Storage._panelItems)

    local maxHeight = Storage._PHeight
    local maxWidth = Storage._PWidth
    local itemHeight = maxHeight / Storage._PerColItemNum
    local itemWidth = maxWidth / Storage._PerRowItemNum
    local notOpenedIndex = Storage._selPage * Storage._PerPageNum - Storage._openedCount

    if notOpenedIndex > 0 then
        local clockPos = Storage._PerPageNum - notOpenedIndex + 1
        local noOpen = math.floor(notOpenedIndex / Storage._PerPageNum)
        clockPos = noOpen > 0 and 1 or clockPos
        for i = clockPos, Storage._PerPageNum do
            local gridY = math.floor((clockPos - 1) / Storage._PerRowItemNum)
            local gridX = (clockPos - 1) % Storage._PerRowItemNum
            local posX = gridX * itemWidth + itemWidth / 2
            local posY = maxHeight - itemHeight / 2 - itemHeight * gridY

            local clockImage = GUI:Image_Create(Storage._panelItems, "clock" .. i, posX, posY,
                Storage.lockImg or SLDefine.PATH_RES_PUBLIC .. "icon_tyzys_01.png")
            GUI:setScale(clockImage, SL:GetValue("IS_PC_OPER_MODE") and 0.7 or 1)
            GUI:setAnchorPoint(clockImage, 0.5, 0.5)

            clockPos = clockPos + 1
        end
    end

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    local storage_row_col = SL:GetValue("GAME_DATA", "bag_storage_row_col_max")
    local bBig = false -- 是否大仓库
    if isWinMode and storage_row_col then
        local slices = string.split(storage_row_col, "|")
        local row = tonumber(slices[1]) or 8
        local col = tonumber(slices[2]) or 6
        if row * col > SLDefine.NPC_STORAGE_MAX_PAGE then
            bBig = true
        end
    end

    local itemData = {}
    if bBig then
        itemData = SL:GetValue("NPC_STORAGE_DATA")
    else
        itemData = SL:GetValue("NPC_STORAGE_DATA_BY_PAGE", Storage._selPage)
    end

    if not itemData or next(itemData) == nil then
        return
    end

    Storage._resetList = false

    local pos = 1
    for _, data in pairs(itemData) do
        if pos > Storage._selPage * Storage._PerPageNum then
            break
        end

        local info = {}
        info.itemData = data
        info.index = data.Index
        info.look = true
        info.movable = true
        info.starLv = true
        info.from = GUIDefine.ItemGoTo.STORAGE

        local gridY = math.floor((pos - 1) / Storage._PerRowItemNum)
        local gridX = (pos - 1) % Storage._PerRowItemNum
        local posX = gridX * itemWidth + itemWidth / 2
        local posY = maxHeight - itemHeight / 2 - itemHeight * gridY
        local goodItem = GUI:ItemShow_Create(Storage._panelItems, "goodItem" .. pos, posX, posY, info)
        GUI:setStrTag(goodItem, data.MakeIndex)
        GUI:setAnchorPoint(goodItem, 0.5, 0.5)

        -- 取出物品
        local function putOutStorageItem()
            UIOperator:CloseItemTips()
            SL:RequestPutOutStorageData(data)
            GUI:delayTouchEnabled(goodItem)
        end

        -- 单击
        GUI:ItemShow_addReplaceClickEvent(goodItem, function()
            local touchType = SL:GetValue("STORAGE_TOUCH_TYPE")
            local isQuick = touchType == STORE_MODE.quick
            if isQuick then
                putOutStorageItem()
            end
            return not isQuick
        end)

        if SL:GetValue("IS_PC_OPER_MODE") then
            local function mouseMoveCallBack()
                if goodItem._movingState then
                    return
                end
                local tipsData = {}
                tipsData.itemData = data
                tipsData.pos = GUI:getWorldPosition(goodItem)
                UIOperator:OpenItemTips(tipsData)
            end

            local function leaveItem()
                UIOperator:CloseItemTips()
            end

            GUI:addMouseMoveEvent(goodItem, {
                onEnterFunc = mouseMoveCallBack,
                onLeaveFunc = leaveItem
            })

            -- 双击和右键取出
            GUI:addMouseButtonEvent(goodItem, {
                onRightDownFunc = putOutStorageItem,
                onDoubleLFunc = putOutStorageItem
            })
        else
            -- 双击取出
            GUI:ItemShow_addDoubleEvent(goodItem, putOutStorageItem)
        end

        pos = pos + 1
    end
end

function Storage.UpdateStorageItemState(data)
    if data and next(data) then
        if data.resetItem then
            Storage.UpdatePutOutData(data.resetItem)
        end
    end
end

function Storage.UpdatePutOutData(data)
    if data and next(data) then
        local onPutOutNode = GUI:getChildByStrTag(Storage._panelItems, data.MakeIndex)
        if onPutOutNode then
            GUI:setVisible(onPutOutNode, data.state and data.state > 0)
            onPutOutNode._movingState = not (data.state and data.state > 0)
        end
    end
end

function Storage.UpdateStorageOpenNum()
    local lastIndex = math.min(Storage._openedCount - (Storage._selPage - 1) * Storage._PerPageNum, Storage._PerPageNum)
    Storage._openedCount = SL:GetValue("STROAGE_OPEN_SIZE")
    local openIndex = math.min(Storage._openedCount - (Storage._selPage - 1) * Storage._PerPageNum, Storage._PerPageNum)
    if openIndex > 0 then
        if openIndex <= lastIndex then
            return
        end
        for i = lastIndex + 1, openIndex do
            if Storage._panelItems:getChildByName("clock_" .. i) then
                Storage._panelItems:removeChildByName("clock_" .. i)
            end
        end
    end
end

function Storage.OnCloseLayer()
    UIOperator:CloseNpcMakeDrugUI()
end

function Storage.OnClose(UID)
    if UID ~= UIConst.LAYERID.NPCStorageGUI then
        return false
    end
    Storage.UnRegisterEvent()

    SL:SetValue("STORAGE_TOUCH_TYPE", 0)
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.Storage
    })
end

function Storage.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Storage", Storage.OnClose)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "Storage", Storage.OnCloseLayer)
    SL:RegisterLUAEvent(LUA_EVENT_STORAGE_DATA_UPDATE, "Storage", Storage.UpdateItemList)
    SL:RegisterLUAEvent(LUA_EVENT_STORAGE_ITEM_STATE, "Storage", Storage.UpdateStorageItemState)
    SL:RegisterLUAEvent(LUA_EVENT_STORAGE_SIZE_CHANGE, "Storage", Storage.UpdateStorageOpenNum)
end

function Storage.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "Storage")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "Storage")
    SL:UnRegisterLUAEvent(LUA_EVENT_STORAGE_DATA_UPDATE, "Storage")
    SL:UnRegisterLUAEvent(LUA_EVENT_STORAGE_ITEM_STATE, "Storage")
end

Storage.main()
