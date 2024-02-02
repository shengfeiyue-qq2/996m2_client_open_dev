TitleTips_Look = {}--查看他人 称号提示
TitleTips_Look._ui = nil
local tipsWidth = 270
local textSize = 18

function TitleTips_Look.main(data)
    local parent = GUI:Attach_Parent()
    TitleTips_Look._parent = parent
    TitleTips_Look.isWinPlayMode = SL:GetMetaValue("WINPLAYMODE")
    if TitleTips_Look.isWinPlayMode then
        textSize = 16
    end
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    if not data.pos then
        data.pos = GUI:p(screenW/2, screenH/2)
        data.anchorPoint = GUI:p(0.5, 0.5)
    end

    if data.node then
        TitleTips_Look._panel = GUI:Layout_Create(data.node,"Layout_Main", 0, 0, 0, 0, false)
    elseif data.pos then
        local touchPanel = GUI:Layout_Create(parent,"Layout_Main_2", 0, 0, screenW, screenH, false) 
        GUI:setTouchEnabled(touchPanel,true)
        GUI:setSwallowTouches(touchPanel,false)
        GUI:addOnClickEvent(touchPanel,function()
            SL:CloseOtherTitleTipsUI()
        end)
        TitleTips_Look._panel = touchPanel
    end
    TitleTips_Look.InitLayer(data)
end

function TitleTips_Look.InitLayer(data)
    GUI:removeAllChildren(TitleTips_Look._panel)
    TitleTips_Look._panelList = nil
    TitleTips_Look._data = data

    TitleTips_Look.CreateItemPanel(data)
end

function TitleTips_Look.CreateItemPanel( data )
    GUI:removeAllChildren(TitleTips_Look._panel)
    if not data or (not data.pos and not data.node) then
        return false
    end

    local width = 420
    local tips = GUI:Layout_Create(TitleTips_Look._panel,"Layout_Tips", 0, 0, 135, 173, false)
    GUI:Layout_setBackGroundImage(tips,SLDefine.PATH_RES_PRIVATE .. "item_tips/bg_tipszy_05.png")
    GUI:Layout_setBackGroundImageScale9Slice(tips, 44, 44, 57, 57)
    GUI:setAnchorPoint(tips,0, 0)
    local listView = GUI:ListView_Create(tips,"PlayerListView", 10, 10, 0, 0, 1)
    GUI:ListView_setClippingEnabled(listView,true)
    GUI:ListView_setItemsMargin(listView, 0)
    GUI:setTouchEnabled(listView,false)
    GUI:setPosition(listView, 10, 10)

    local typeId = data.id
    local itemConfig = SL:GetMetaValue("ITEM_DATA",typeId)
    local name = itemConfig.Name or ""
    local color = (itemConfig.Color and itemConfig.Color > 0) and SL:GetMetaValue("ITEM_NAME_COLOR_VALUE",typeId) or "#FFFFFF"
    
    local rich_name = GUI:RichText_Create(listView, "rich_text", 0, 0, name, tipsWidth, textSize, color)

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
    local attList = GUIFunction:ParseItemBaseAtt(itemConfig.attribute)
    local stringAtt = GUIFunction:GetAttDataShow(attList)

    local basicAttrShow = {}
    for id,v in pairs(stringAtt) do
        v.id = id
        local originId = getAttOriginId(id)
        local attConfig = SL:GetMetaValue("ATTR_CONFIG",originId)  
        v.sort = (attConfig and attConfig.sort) and attConfig.sort or originId + 1000
        table.insert(basicAttrShow, v)
    end
    
    table.sort(basicAttrShow, function(a, b)
        return a.sort < b.sort
    end)

    local str = ""
    for _,v in pairs(basicAttrShow) do
        local oneStr = v.name .. getAddShow(v.id) .. v.value
        local color = v.color
        if color and color > 0 then
            oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)
        end

        str = str .. oneStr .. "<br>"
    end
    local strSize = TitleTips_Look.isWinPlayMode and 12 or 16
    local strColor = "#FFFFFF"
    local rich_att = GUI:RichText_Create(listView, "rich_attr", 0, 0, str, tipsWidth, strSize, strColor) 

    local time = data.time 
    if time and time > SL:GetMetaValue("SERVER_TIME") then
        local strSize = TitleTips_Look.isWinPlayMode and 12 or 16
        local strColor = "#28EF01"
        local richText = GUI:RichText_Create(listView, "rich_time", 0, 0, string.format("剩余时间：%s",SL:TimeFormatToStr(time - SL:GetMetaValue("SERVER_TIME"))), width, strSize, strColor) 
        GUI:setAnchorPoint(richText, 0, 0)
    end

    local function pushDescItem(desc, descTag)
        if not desc then
            return
        end
        local movePosY = 0
        if desc and next(desc) then
            for i,v in ipairs(desc) do
                if v.text then
                    local textSize 
                    if v.fontsize and v.fontsize > 0 then
                        textSize = v.fontsize
                    end
                    local richText = GUI:RichTextFCOLOR_Create(listView, "desc_" .. (descTag or "") .. i, 0, 0, v.text, width, textSize or SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF")
                    GUI:setAnchorPoint(richText, 0, 0)
                end
            end
        end
    end

    --道具说明
    local itemDescs = GUIFunction:GetParseItemDesc(itemConfig.Desc)
    local topDescs = itemDescs.top_desc
    if topDescs then
        pushDescItem(topDescs, "top")
    end
    local desc = itemDescs.desc
    if desc then
        pushDescItem(desc)
    end
    local bottomDescs = itemDescs.bottom_desc
    if bottomDescs then
        pushDescItem(bottomDescs, "bottom")
    end
    GUI:setPosition(tips,data.pos)
    TitleTips_Look.refreshItemPosition(tips, listView)
    local anchorPoint, pos = TitleTips_Look.getTipsAnchorPoint(tips, data.pos, TitleTips_Look._data.anchorPoint or GUI:p(0,1))
    GUI:setAnchorPoint(tips, anchorPoint)
    GUI:setPosition(tips,pos)
end

function TitleTips_Look.getTipsAnchorPoint(widget, pos, ancPoint)
    ancPoint = ancPoint or GUI:getAnchorPoint(widget)
    local size = GUI:getContentSize(widget)
    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    local outScreenX = false
    local outScreenY = false
    if pos.y + size.height*ancPoint.y > screenH then
        ancPoint.y = 1
        outScreenY = true
    end
    if pos.y - size.height*ancPoint.y < 0 then
        if outScreenY then
            ancPoint.y = 0.5
            pos.y = screenH / 2
        else
            ancPoint.y = 0
        end
    end
    
    if pos.x + size.width*(1-ancPoint.x) > screenW then
        ancPoint.x = 1
        outScreenX = true
    end
    if pos.x - size.width*ancPoint.x < 0 then
        if outScreenX then
            ancPoint.x = 0.5
            pos.x = screenW / 2
        else
            ancPoint.x = 0
        end
    end
    return ancPoint, pos
end


function TitleTips_Look.refreshItemPosition(tips, listView)
    GUI:ListView_doLayout(listView)
    local listHeight = GUI:ListView_getInnerContainerSize(listView).height
    local listWidth = 420
    local maxWidth = 0
    for _,v in pairs(GUI:getChildren(listView)) do
        maxWidth = math.max(maxWidth, GUI:getContentSize(v).width)
    end
    listWidth = math.min(listWidth, maxWidth)

    GUI:setContentSize(listView,listWidth, listHeight)
    
    GUI:setContentSize(tips, listWidth + 20, listHeight + 20)
end

return TitleTips_Look