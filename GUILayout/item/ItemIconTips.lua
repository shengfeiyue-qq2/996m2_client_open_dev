ItemIconTips = {}

function ItemIconTips.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.ItemIconTipsGUI, 0, 0, 0, 0, nil, nil, nil, nil, nil, nil, GUIDefine.UIZ.MOUSE)
    local data   = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local node = GUI:Widget_Create(parent, "widget_icon", 0, 0)
    GUI:LoadExport(node, "item/item_tips")
    local ui = GUI:ui_delegate(node)

    local itemSize = GUI:getContentSize(ui.tipsLayout)
    local nodeIcon = GUI:Node_Create(ui.tipsLayout, "NodeIcon", itemSize.width / 2, itemSize.height / 2)
	GUI:setAnchorPoint(nodeIcon, 0.50, 0.50)
    local goodsInfo = { itemData = data.itemData, index = data.itemData.Index }
    local goodsItem = GUI:ItemShow_Create(nodeIcon, "goodsItem", 0, 0, goodsInfo)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)

    -- 交易行 截图节点 请勿删除 
    ItemIconTips._screenshotRootNode = goodsItem

    GUI:Win_SetCloseCB(parent, ItemIconTips.OnClose)
end

-- 关闭界面
function ItemIconTips.OnClose()
    
end

ItemIconTips.main()