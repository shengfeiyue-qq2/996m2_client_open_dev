StoreDetail = {}

function StoreDetail.main()
    local parent = GUI:Attach_Parent()
    StoreDetail._ui = GUI:ui_delegate(parent)

    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if isWinMode then
        GUI:LoadExport(parent, "store/store_detail_win32")
    else
        GUI:LoadExport(parent, "store/store_detail")
    end

    local PMainUI = StoreDetail._ui["PMainUI"]

    -- 可拖拽
    GUI:Win_SetDrag(parent, PMainUI)
    GUI:Win_SetZPanel(parent, PMainUI)

    -- 关闭按钮
    GUI:addOnClickEvent(StoreDetail._ui["Button_close"], function()
        SL:CloseStoreDetailUI()
    end)
end

function StoreDetail.InitGoodsItem(data)
    GUI:removeAllChildren(StoreDetail._ui["Image_iconBg"])
    if data.Id and data.Look then
        local goodsData = {}
        goodsData.index = data.Id
        goodsData.look = true
        local ui_icon = GUI:ItemShow_Create(StoreDetail._ui["Image_iconBg"], "ui_icon", 0, 0, goodsData)
        local iconBgSize = GUI:getContentSize(StoreDetail._ui["Image_iconBg"])
        GUI:setAnchorPoint(ui_icon, 0.5, 0.5)
        GUI:setPosition(ui_icon, iconBgSize.width / 2, iconBgSize.height / 2)
    end

    if data.Name then
        GUI:Text_setString(StoreDetail._ui["Text_itemName"], data.Name)
        GUI:setVisible(StoreDetail._ui["Text_itemName"],true)
    end
end 