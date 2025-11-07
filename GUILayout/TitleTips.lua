TitleTips = {}
TitleTips._ui = nil

local pcTag = SL:GetValue("IS_PC_OPER_MODE") and 1 or 2

local fontSizes = {
    [1] = 16,       -- PC
    [2] = 18
}
local textSize  = fontSizes[pcTag]
local tipsWidth = 270

function TitleTips.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.TitleTipsGUI, 0, 0, 0, 0, false, false, true, true, nil, nil, GUIDefine.UIZ.TOBOX)
    local data = GUI:GetLayerOpenParam()

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    if not data.pos then
        data.pos = GUI:p(screenW/2, screenH/2)
        data.anchorPoint = GUI:p(0.5, 0.5)
    end

    if data.node then
        TitleTips._panel = GUI:Layout_Create(data.node,"Layout_Main", 0, 0, 0, 0, false)
    elseif data.pos then
        local touchPanel = GUI:Layout_Create(parent,"Layout_Main_2", 0, 0, screenW, screenH, false) 
        GUI:setTouchEnabled(touchPanel,true)
        GUI:setSwallowTouches(touchPanel,false)
        GUI:addOnClickEvent(touchPanel,function()
            UIOperator:CloseTitleTipsUI()
        end)
        TitleTips._panel = touchPanel
    end

    TitleTips.InitUI(data)

    SL:RegisterLUAEvent(LUA_EVENT_USERINPUT_EVENT_NOTICE, "TitleTips", function()
        GUI:Win_Close(parent)
    end, parent)
end

function TitleTips.InitUI(data)
    GUI:removeAllChildren(TitleTips._panel)
    TitleTips._panelList = nil
    TitleTips._data = data

    TitleTips.CreateItemPanel(data)
end

function TitleTips.CreateItemPanel(data)
    GUI:removeAllChildren(TitleTips._panel)
    if not data or (not data.pos and not data.node) then
        return false
    end

    local width = 420
    local tips = GUI:Layout_Create(TitleTips._panel,"Layout_Tips", 0, 0, 135, 173, false)
    GUI:Layout_setBackGroundImage(tips, GUIDefine.PATH_RES_PRIVATE .. "item_tips/bg_tipszy_05.png")
    GUI:Layout_setBackGroundImageScale9Slice(tips, 16, 16, 16, 16)
    GUI:setAnchorPoint(tips,0, 0)
    local listView = GUI:ListView_Create(tips,"PlayerListView", 10, 10, 0, 0, 1)
    GUI:ListView_setClippingEnabled(listView,true)
    GUI:ListView_setItemsMargin(listView, 0)
    GUI:setTouchEnabled(listView,false)
    GUI:setPosition(listView, 10, 10)

    local typeId = data.id
    local itemConfig = SL:GetValue("ITEM_DATA", typeId)
    local name = itemConfig.Name or ""
    local color = (itemConfig.Color and itemConfig.Color > 0) and SL:GetValue("ITEM_NAME_COLOR_VALUE", typeId) or "#FFFFFF"
    
    GUI:RichText_Create(listView, "rich_text", 0, 0, name, tipsWidth, textSize, color)

    --获取属性原始id
    local function getAttOriginId(id)
        return id >= 10000 and math.floor(id / 10000) or id
    end

    --显示 +
    local function getAddShow(id)
        if id == 1 or id == 2 or id == 13 or id == 14 or id == 15 or id == 16 or id == 17 or id == 18 or id == 19 or id == 20 or id == 38 or id == 39 then
            return "+"
        end
        return ""
    end
    -- 基础属性
    local attList = GUIFunction:ParseItemBaseAtt(itemConfig.Attribute, data.job)
    local stringAtt = GUIFunction:GetAttDataShow(attList, nil, true)

    local basicAttrShow = {}
    for id, v in pairs(stringAtt) do
        v.id = id
        local originId = getAttOriginId(id)
        local attConfig = SL:GetValue("ATTR_CONFIG", originId)  
        v.sort = attConfig and attConfig.sort or originId + 1000
        table.insert(basicAttrShow, v)
    end
    
    table.sort(basicAttrShow, function(a, b)
        return a.sort < b.sort
    end)

    local str = ""
    for _, v in pairs(basicAttrShow) do
        local oneStr = v.name .. getAddShow(v.id) .. v.value
        local color = v.color
        if color and color > 0 then
            oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)
        end

        str = str .. oneStr .. "<br>"
    end
    local strSize = SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE")
    GUI:RichText_Create(listView, "rich_attr", 0, 0, str, tipsWidth, strSize, "#FFFFFF") 

    local time = data.time 
    if time and time > SL:GetValue("SERVER_TIME") then
        local richText = GUI:RichText_Create(listView, "rich_time", 0, 0, string.format("剩余时间：%s", SL:TimeFormatToStr(time - SL:GetValue("SERVER_TIME"))), width, strSize, "#28EF01") 
    end

    if not data.lookOther then
        local desc = TitleTips.isWinPlayMode and (data.type == 1 and "(单击图标激活当前称号)" or "(单击图标取消当前称号)") or (data.type == 1 and "(双击图标激活当前称号)" or "(双击图标取消当前称号)")
        local richText = GUI:RichText_Create(listView, "rich_desc", 0, 0, desc, width, strSize, "#FFFFFF")
    end

    -- 道具说明
    local itemDescList = GUIFunction:GetItemDescList(itemConfig)
    local groupIdTab = itemDescList and table.keys(itemDescList) or {}
    table.sort(groupIdTab)
    for _, groupId in ipairs(groupIdTab) do
        local descStr = GUIFunction:GetItemDescStrByGroup(itemDescList, groupId)
        if descStr and string.len(descStr) > 0 then
            local rich_desc = GUI:RichText_Create(listView, "rich_desc_" .. groupId, 0, 0, descStr, width, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF")
        end
    end

    GUI:setPosition(tips, data.pos)
    TitleTips.RefreshItemPosition(tips, listView)
    local anchorPoint, pos = TitleTips.GetTipsAnchorPoint(tips, data.pos, TitleTips._data.anchorPoint or GUI:p(0,1))
    GUI:setAnchorPoint(tips, anchorPoint)
    GUI:setPosition(tips,pos)
end

function TitleTips.GetTipsAnchorPoint(widget, pos, ancPoint)
    ancPoint = ancPoint or GUI:getAnchorPoint(widget)
    local size = GUI:getContentSize(widget)
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local outScreenX = false
    local outScreenY = false
    if pos.y + size.height * ancPoint.y > screenH then
        ancPoint.y = 1
        outScreenY = true
    end
    if pos.y - size.height * ancPoint.y < 0 then
        if outScreenY then
            ancPoint.y = 0.5
            pos.y = screenH / 2
        else
            ancPoint.y = 0
        end
    end
    
    if pos.x + size.width * (1 - ancPoint.x) > screenW then
        ancPoint.x = 1
        outScreenX = true
    end
    if pos.x - size.width * ancPoint.x < 0 then
        if outScreenX then
            ancPoint.x = 0.5
            pos.x = screenW / 2
        else
            ancPoint.x = 0
        end
    end
    return ancPoint, pos
end

function TitleTips.RefreshItemPosition(tips, listView)
    GUI:ListView_doLayout(listView)
    local listHeight = GUI:ListView_getInnerContainerSize(listView).height
    local listWidth = 420
    local maxWidth = 0
    for _, v in ipairs(GUI:getChildren(listView)) do
        maxWidth = math.max(maxWidth, GUI:getContentSize(v).width)
    end
    listWidth = math.min(listWidth, maxWidth)

    GUI:setContentSize(listView, listWidth, listHeight)
    
    GUI:setContentSize(tips, listWidth + 20, listHeight + 20)
end

TitleTips.main()