Notice = {}

Notice.isPC = SL:GetValue("IS_PC_OPER_MODE")
-- 全服消息
Notice._serverNotice = {}
Notice._serverNoticeStatus = false
Notice._serverNotice_11 = {}
Notice._serverNoticeStatus_11 = false
Notice._serverIndex = 0
Notice._serverIndex11 = 0

-- 消息 系统 跑马灯 和 顶端弹窗
Notice._systemNotice = {}
Notice._systemNoticeFlag = {}
Notice._systemIndex = 0
Notice._sysScaleIndex = 0

-- 系统 提示弹窗 警告
Notice._systemTips = {}
Notice._sysTipsIndex = 0

-- 系统 设置XY 跑马灯 
Notice._systemXYCells = {}
Notice._sysXYIndex = 0

-- 提示 警告
Notice._timerIndex = 0
Notice._timerXYIndex = 0

-- 飘字 物品拾取获得消耗
Notice._itemTipsData = {}
Notice._itemTipsCells = {}
Notice._itemTimer = nil
Notice._itemIndex = 0

-- 飘字 属性变化
Notice._attributeData = {}
Notice._attributeCDing = nil
Notice._attrIndex = 0

-- 飘字 经验值变化
Notice._expNode = nil
Notice._expCells = {}
Notice._expIndex = 0

-- 掉落物品提示
Notice._dropTipsCells = {}
Notice._dropIndex = 0

-- 内功经验值提示
Notice._ngExpNode = nil
Notice._ngExpCells = {}
Notice._ngExpIndex = 0
Notice._ngExpParam = {}

function Notice.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "notice/notice")

    Notice._ui = GUI:ui_delegate(parent)
    Notice._root              = Notice._ui["Node_notice"]
    Notice._rootServerTips    = Notice._ui["Node_server_tips"]
    Notice._rootSystem        = Notice._ui["Node_system"]
    Notice._rootSystemXY      = Notice._ui["Node_system_xy"]
    Notice._rootSystemTips    = Notice._ui["Node_system_tips"]
    Notice._rootTimerTipsXY   = Notice._ui["Node_timer_xy_tips"]
    Notice._rootTimerTips     = Notice._ui["Node_timer_tips"]
    Notice._listviewTimerTips = Notice._ui["ListView_timer_tips"]
    Notice._rootAttribute     = Notice._ui["Node_attribute"]
    Notice._rootItemTips      = Notice._ui["Node_item_tips"]
    Notice._rootDropTips      = Notice._ui["Node_drop_tips"]
    Notice._rootNormalTips    = Notice._ui["Node_normal_tips"]

    Notice.OnAdapet()
    Notice.InitNGEXPSetParam()
    Notice.RegisterEvent()
end

function Notice.close(isRemovedEvent)
    Notice._ui = nil
    -- 全服消息
    Notice._serverNotice = {}
    Notice._serverNoticeStatus = false
    Notice._serverNotice_11 = {}
    Notice._serverNoticeStatus_11 = false
    Notice._serverIndex = 0
    Notice._serverIndex11 = 0

    -- 消息 系统 跑马灯 和 顶端弹窗
    Notice._systemNotice = {}
    Notice._systemNoticeFlag = {}
    Notice._systemIndex = 0
    Notice._sysScaleIndex = 0

    -- 系统 提示弹窗 警告
    Notice._systemTips = {}
    Notice._sysTipsIndex = 0

    -- 系统 设置XY 跑马灯 
    Notice._systemXYCells = {}
    Notice._sysXYIndex = 0

    -- 提示 警告
    Notice._timerIndex = 0
    Notice._timerXYIndex = 0

    -- 飘字 物品拾取获得消耗
    Notice._itemTipsData = {}
    Notice._itemTipsCells = {}
    Notice._itemTimer = nil
    Notice._itemIndex = 0

    -- 飘字 属性变化
    Notice._attributeData = {}
    Notice._attributeCDing = nil
    Notice._attrIndex = 0

    -- 飘字 经验值变化
    Notice._expNode = nil
    Notice._expCells = {}
    Notice._expIndex = 0

    -- 掉落物品提示
    Notice._dropTipsCells = {}
    Notice._dropIndex = 0

    -- 内功经验值提示
    Notice._ngExpNode = nil
    Notice._ngExpCells = {}
    Notice._ngExpIndex = 0
    Notice._ngExpParam = {}
    if isRemovedEvent then
        return
    end
    Notice.RemoveEvent()
end


function Notice.OnAdapet()
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local notch, rect = SL:GetValue("NOTCH_PHONE_INFO")

    GUI:setPosition(Notice._rootTimerTipsXY, screenW / 2, 200)
    GUI:setPosition(Notice._rootTimerTips, screenW / 2, 200)
    GUI:setPosition(Notice._rootSystemTips, screenW / 2, screenH / 2)
    GUI:setPositionX(Notice._rootAttribute, screenW - 300)
    GUI:setPositionY(Notice._rootServerTips, screenH)
    GUI:setPosition(Notice._rootSystem, screenW / 2, screenH)
    GUI:setPositionX(Notice._rootItemTips, rect.x + 50)
    GUI:setPositionX(Notice._rootNormalTips, screenW / 2)
end

function Notice.createAttribute(parent)
    GUI:LoadExport(parent, "notice/attribute_cell")
    local ui = ui_delegate(parent)
    local cell = ui["cell"]
    return cell
end

function Notice.OnShowServerNotice(data)
    table.insert(Notice._serverNotice, data)
    Notice.CheckServerNotice()
end

function Notice.CheckServerNotice()
    if Notice._serverNoticeStatus then
        return
    end

    if not next(Notice._serverNotice) then
        return
    end

    Notice._serverNoticeStatus = true
    GUI:setVisible(Notice._rootServerTips, true)

    local data  = table.remove(Notice._serverNotice, 1)
    data.FColor = data.FColor or 255
    data.BColor = data.BColor or 255
    
    local FColorRGB = SL:GetColorByStyleId(data.FColor)
    local BColorRGB = SL:GetColorByStyleId(data.BColor)

    -- richText
    local outlineParam = {
        outlineSize = 1, 
        outlineColor = BColorRGB
    }
    Notice._serverIndex = Notice._serverIndex + 1
    local richText = GUI:RichTextFCOLOR_Create(Notice._rootServerTips, "richTextServer"..Notice._serverIndex, 0, 0, data.Msg, 10000, 18, FColorRGB, nil, nil, nil, outlineParam)
    GUI:setAnchorPoint(richText, 0, 1)

    -- action
    local visibleSize = SL:GetValue("SCREEN_SIZE")
    local textContent = GUI:getContentSize(richText)
    local actionTime  = 15 + (textContent.width / visibleSize.width * 15)
    local function callback()
        GUI:removeFromParent(richText)
        Notice._serverNoticeStatus = false
        GUI:setVisible(Notice._rootServerTips, false)
        Notice:CheckServerNotice()
    end
    local move1 = GUI:ActionMoveTo(0, visibleSize.width, 0)
    local move2 = GUI:ActionMoveTo(actionTime, 0 - textContent.width, 0)
    local sequence = GUI:ActionSequence(move1, move2, GUI:CallFunc(callback))
    GUI:runAction(richText, sequence)
end

function Notice.OnShowServerEventNotice(data)
    if data.Type == 11 then
        Notice.ShowServerEventNotice_11(data)
    end
end

function Notice.ShowServerEventNotice_11(data)
    table.insert(Notice._serverNotice_11, data)

    local function showServerEvent()
        if Notice._serverNoticeStatus_11 then
            return
        end
        if not next(Notice._serverNotice_11) then
            return
        end
        
        Notice._serverNoticeStatus_11 = true
        GUI:setVisible(Notice._rootServerTips, true)

        local item  = table.remove(Notice._serverNotice_11, 1)
        item.FColor = item.FColor or 255
        item.BColor = item.BColor or 255

        local FColorRGB     = SL:GetColorByStyleId(item.FColor)
        local BColorRGB     = SL:GetColorByStyleId(item.BColor)
        local visibleSize   = SL:GetValue("SCREEN_SIZE")
        local capacitySize  = {width = visibleSize.width * 0.5, height = 30}

        -- layout
        Notice._serverIndex11 = Notice._serverIndex11 + 1
        local layout = GUI:Layout_Create(Notice._rootServerTips, "layout11"..Notice._serverIndex11, visibleSize.width/2, -30, capacitySize.width, capacitySize.height, false)
        GUI:Layout_setBackGroundColor(layout, "#000000")
        GUI:Layout_setBackGroundColorType(layout, 1)
        GUI:Layout_setBackGroundColorOpacity(layout, 80)
        GUI:Layout_setClippingEnabled(layout, true)
        GUI:setAnchorPoint(layout, 0.5, 1)

        -- richText
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE_NOTICE") or 16
        local outlineParam = {
            outlineSize = 1, 
            outlineColor = BColorRGB
        }
        local richText = GUI:RichTextFCOLOR_Create(layout, "richText", 0, 0, item.Msg, 10000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
        GUI:setAnchorPoint(richText, 0, 0.5)

        -- action
        local contentSize = GUI:getContentSize(richText)
        local actionTime = 10 + (contentSize.width / capacitySize.width * 10)
        local function callback()
            Notice._serverNoticeStatus_11 = false
            GUI:removeFromParent(layout)
            GUI:setVisible(Notice._rootServerTips, false)
            showServerEvent()
        end

        local move1 = GUI:ActionMoveTo(0, capacitySize.width, capacitySize.height/2)
        local move2 = GUI:ActionMoveTo(actionTime, 0 - capacitySize.width, capacitySize.height/2)
        local sequence = GUI:ActionSequence(move1, move2, GUI:CallFunc(callback))
        GUI:runAction(richText, sequence)
    end

    showServerEvent()
end

function Notice.OnShowSystemNotice(data)
    data.Y              = data.Y or 0
    data.Count          = data.Count or 1
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255

    local posY = data.Y
    Notice._systemNotice[posY] = Notice._systemNotice[posY] or {}
    table.insert(Notice._systemNotice[posY], data)

    local function showSystemNotice()
        if Notice._systemNoticeFlag[posY] then
            return
        end

        local items = Notice._systemNotice[posY]
        local item = table.remove(items, 1)
        if not item then
            return
        end

        Notice._systemNoticeFlag[posY] = true
        local FColorRGB = SL:GetColorByStyleId(item.FColor)
        local BColorRGB = SL:GetColorByStyleId(item.BColor)
        local visibleSize = SL:GetValue("SCREEN_SIZE")
        local capacitySize = {width = math.floor(visibleSize.width * 0.6), height = 30}

        -- layout
        Notice._systemIndex = Notice._systemIndex + 1
        local layout = GUI:Layout_Create(Notice._rootSystem, "layout"..Notice._systemIndex, 0, 0 - item.Y, capacitySize.width, capacitySize.height, true)
        GUI:Layout_setBackGroundColor(layout, "#000000")
        GUI:Layout_setBackGroundColorType(layout, 1)
        GUI:Layout_setBackGroundColorOpacity(layout, 80)
        GUI:setAnchorPoint(layout, 0.5, 1)

        -- richText
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE_NOTICE") or 16
        local outlineParam = {
            outlineSize = 1, 
            outlineColor = BColorRGB
        }
        local richText = GUI:RichTextFCOLOR_Create(layout, "richText", capacitySize.width, capacitySize.height / 2, item.Msg, 10000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
        GUI:setAnchorPoint(richText, 0, 0.5)

        -- action
        local contentSize = GUI:getContentSize(richText) 
        local actionTime    = math.ceil(10 + (contentSize.width / capacitySize.width * 10))
        local function callback()
            Notice._systemNoticeFlag[posY] = false
            GUI:removeFromParent(layout)
            showSystemNotice()
        end
        local move1 = GUI:ActionMoveTo(0, capacitySize.width, capacitySize.height/2)
        local move2 = GUI:ActionMoveTo(actionTime, 0 - contentSize.width, capacitySize.height/2)
        local sequence = GUI:ActionSequence(move1, move2)
        local acRepeat = GUI:ActionRepeat(sequence, item.Count)
        local action = GUI:ActionSequence(acRepeat, GUI:CallFunc(callback))
        GUI:runAction(richText, action)
    end

    showSystemNotice()
end

function Notice.OnShowSystemScaleNotice(data)
    data.Y              = data.Y or 125
    data.Count          = data.Count or 1
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255
    data.ShowTime       = data.ShowTime or 1.4

    local posY = data.Y
    Notice._systemNotice[posY] = Notice._systemNotice[posY] or {}
    table.insert(Notice._systemNotice[posY], data)

    local function showSystemScaleNotice()
        if Notice._systemNoticeFlag[posY] then
            return
        end
        local items = Notice._systemNotice[posY]
        local item  = table.remove(items, 1)
        if not item then
            return
        end

        Notice._systemNoticeFlag[posY] = true
        local FColorRGB     = SL:GetColorByStyleId(item.FColor)
        local BColorRGB     = SL:GetColorByStyleId(item.BColor)
        local visibleSize   = SL:GetValue("SCREEN_SIZE")
        local capacitySize  = {visibleSize.width * 0.6, 30} 

        -- bg
        Notice._sysScaleIndex = Notice._sysScaleIndex + 1
        local imageBG = GUI:Image_Create(Notice._rootSystem, "imageBg"..Notice._sysScaleIndex, 0, 0 - item.Y, "res/public/bg_hhzy_01_2.png")
        GUI:setCascadeOpacityEnabled(imageBG, true)
        GUI:setAnchorPoint(imageBG, 0.5, 1)

        -- richText
        local contentSize   = GUI:getContentSize(imageBG)
        local fontSize      = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE_NOTICE") or 16
        local outlineParam = {
            outlineSize = 1, 
            outlineColor = BColorRGB
        }
        local richText = GUI:RichTextFCOLOR_Create(imageBG, "richText", contentSize.width/2, contentSize.height/2, item.Msg, 10000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
        GUI:setAnchorPoint(richText, 0.5, 0.5)
        GUI:setCascadeOpacityEnabled(richText, true)

        -- action
        local function callback()
            GUI:removeFromParent(imageBG)
            Notice._systemNoticeFlag[posY] = nil
            showSystemScaleNotice()
        end

        local sequence = GUI:ActionSequence(
            GUI:ActionScaleTo(0, 1.5), 
            GUI:ActionEaseBackOut(GUI:ActionScaleTo(0.3, 1)), 
            GUI:DelayTime(item.ShowTime), 
            GUI:ActionFadeOut(0.5)
        )
       
        local acRepeat = GUI:ActionRepeat(sequence, item.Count)
        local action = GUI:ActionSequence(acRepeat, GUI:CallFunc(callback))
        GUI:runAction(imageBG, action)
    end

    showSystemScaleNotice()
end

function Notice.OnShowSystemXYNotice(data)
    local X             = tonumber(data.X)
    local Y             = tonumber(data.Y)
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255
    local FColorRGB     = GET_COLOR_BYID_C3B(data.FColor)
    local BColorRGB     = GET_COLOR_BYID_C3B(data.BColor)

    if not X or not Y then
        return
    end

    local visibleSize   = SL:GetValue("SCREEN_SIZE")
    Y                   = visibleSize.height - Y
    GUI:setPosition(Notice._rootSystemXY, X, Y)

    -- node
    Notice._sysXYIndex = Notice._sysXYIndex + 1
    local node = GUI:Node_Create(Notice._rootSystemXY, "nodeSysXYTip"..Notice._sysXYIndex, 0, 0)
    GUI:setAnchorPoint(node, 0.5, 0)
    GUI:setCascadeOpacityEnabled(node, true)

    table.insert(Notice._systemXYCells, node)

    -- action
    local function callback()
        table.remove(Notice._systemXYCells, 1)
    end 
    local sequence = GUI:ActionSequence(GUI:DelayTime(2.5), GUI:ActionFadeOut(0.5), GUI:ActionRemoveSelf(), GUI:CallFunc(callback))
    GUI:runAction(node, sequence)
    
    -- richText
    local fontSize  = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE_NOTICE") or 16
    local outlineParam = {
        outlineSize = 1, 
        outlineColor = BColorRGB
    }
    local richText = GUI:RichTextFCOLOR_Create(node, "richText", 0, 0, data.Msg, 10000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
    GUI:setCascadeOpacityEnabled(richText, true)
    GUI:setAnchorPoint(richText, 0, 1)

    local height = 30
    local count = #Notice._systemXYCells
    for key, cell in pairs(Notice._systemXYCells) do
        GUI:setPositionY(cell, (count-key) * height)
    end
end

function Notice.OnShowSystemTips(str)
    -- node
    Notice._sysTipsIndex = Notice._sysTipsIndex + 1
    local node = GUI:Node_Create(Notice._rootNormalTips, "nodeSysTip"..Notice._sysTipsIndex, 0, 0)
    GUI:setAnchorPoint(node, 0.5, 0.5)
    GUI:setCascadeOpacityEnabled(node, true)

    -- bg
    local imageBG = GUI:Image_Create(node, "imageBG", 0, 0, "res/public/bg_hhzy_01_2.png")
    GUI:Image_setScale9Slice(imageBG, 184, 184, 11, 11)
    GUI:setAnchorPoint(imageBG, 0.5, 0.5)

    -- text
    local text = GUI:RichText_Create(node, "text", 0, 0, str, 0xffffff, 16, "#ffffff")
    GUI:setCascadeOpacityEnabled(text, true)
    GUI:setAnchorPoint(text, 0.5, 0.5)
    local size = {width = GUI:getContentSize(text).width, height = 30}
    GUI:setContentSize(imageBG, size.width + 20, size.height)

    table.insert(Notice._systemTips, node)
    -- 最多7条
    if #Notice._systemTips > 7 then 
        GUI:removeFromParent(Notice._systemTips[1])
        table.remove(Notice._systemTips, 1)
    end 

    -- action
    local function callback()
        GUI:removeFromParent(node)
        table.remove(Notice._systemTips, 1)
    end

    local sequence = GUI:ActionSequence(GUI:DelayTime(2), GUI:ActionFadeOut(0.8), GUI:CallFunc(callback))
    GUI:runAction(node, sequence)

    local actionTag = 999
    for i = 1, #Notice._systemTips do
        local cell = Notice._systemTips[i]
        if cell then 
            GUI:setPositionY(cell, size.height * (#Notice._systemTips - i - 0.5))
            local action  = GUI:ActionMoveTo(0.15, 0, size.height * (#Notice._systemTips - i + 0.5))
            GUI:setTag(action, actionTag)
            GUI:stopActionByTag(cell, actionTag)
            GUI:runAction(cell, action)
        end 
    end
end

function Notice.OnShowTimerNotice(data)
    data.Time           = data.Time or 5
    data.Label          = data.Label or ""
    data.X              = data.X or 0
    data.Y              = data.Y or 0
    data.Count          = data.Count or 1
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255
    local FColorRGB     = SL:GetColorByStyleId(data.FColor)
    local BColorRGB     = SL:GetColorByStyleId(data.BColor)
    local visibleSize   = SL:GetValue("SCREEN_SIZE")
    local capacitySize  = {width = math.floor(visibleSize.width), height = (Notice.isPC and 20 or 30) + data.Y}

    -- layout
    local function resetListview()
        local count = GUI:ListView_getItemCount(Notice._listviewTimerTips)
        local height = count * capacitySize.height
        GUI:setContentSize(Notice._listviewTimerTips, capacitySize.width, height)
    end

    Notice._timerIndex = Notice._timerIndex + 1
    local layout = GUI:Layout_Create(Notice._listviewTimerTips, "layoutTimer"..Notice._timerIndex, 0, 0, capacitySize.width, capacitySize.height, false)
    resetListview()

    local remaining = data.Time
    local Msg = FixStringFormatCharacter(data.Msg)
    local hasFormat = string.find(Msg, "%%") 
    local function callback()
        local str = Msg 
        local formatMsg = function()
            str = hasFormat and string.format(Msg, remaining) or Msg
        end
        if not pcall(formatMsg) then 
            SL:release_print("ERROR :TimerNotice "..Msg.." 格式错误")
            GUI:ListView_removeChild(Notice._listviewTimerTips, layout)
            resetListview()
            return 
        end

        GUI:removeAllChildren(layout)

        -- richText
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE_NOTICE") or 16
        local outlineParam = {
            outlineSize = 1, 
            outlineColor = BColorRGB
        }
        local richText = GUI:RichTextFCOLOR_Create(layout, "richText", 0, 0, str, 1000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
        GUI:setAnchorPoint(richText, 0.5, 0.5)
        GUI:setPosition(richText, capacitySize.width/2 + data.X, capacitySize.height/2 + data.Y)

        if remaining < 0 then
            if data.Label and string.len(data.Label) > 0 then
                SL:SubmitAct({Act = data.Label})
            end
            GUI:ListView_removeChild(Notice._listviewTimerTips, layout)
            resetListview()
        end
        remaining = remaining - 1
    end

    GUI:schedule(layout, callback, 1)
    callback()
end

function Notice.OnDeleteTimerNotice()
    GUI:ListView_removeAllItems(Notice._listviewTimerTips)
    local visibleSize = SL:GetValue("SCREEN_SIZE")
    local capacitySize = {width = visibleSize.width * 0.6, height = Notice.isPC and 20 or 30}
    local count = GUI:ListView_getItemCount(Notice._listviewTimerTips)
    local height = count * capacitySize.height
    GUI:setContentSize(Notice._listviewTimerTips, capacitySize.width, height)
end

function Notice.OnShowTimerXYNotice(data)
    data.Time           = data.Time or 5
    data.Y              = data.Y or 0
    data.X              = data.X or 0
    data.Count          = data.Count or 1
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 0
    local FColorRGB     = SL:GetColorByStyleId(data.FColor)
    local BColorRGB     = SL:GetColorByStyleId(data.BColor)

    local visibleSize   = SL:GetValue("SCREEN_SIZE")
    local capacitySize  = {width = visibleSize.width * 0.6, height = Notice.isPC and 20 or 30}

    GUI:removeAllChildren(Notice._rootTimerTipsXY)

    if data.X == 0 then
        GUI:setPositionX(Notice._rootTimerTipsXY, visibleSize.width/2)
    else
        GUI:setPositionX(Notice._rootTimerTipsXY, data.X)
    end

    Notice._timerXYIndex = Notice._timerXYIndex + 1
    local layout = GUI:Layout_Create(Notice._rootTimerTipsXY, "layoutXYTimer"..Notice._timerXYIndex, 0, 0, capacitySize.width, capacitySize.height, false)
    if data.X == 0 then
        GUI:setAnchorPoint(layout, 0.5, 0)
    else
        GUI:setAnchorPoint(layout, 0, 0)
    end

    local remaining = data.Time - 1
    local Msg = FixStringFormatCharacter(data.Msg)
    local hasFormat = string.find(Msg, "%%")
    local function callback()
        local str = Msg 
        local formatMsg = function()
            str = hasFormat and string.format(Msg, SL:SecondToHMS(remaining, true)) or Msg
        end
        if not pcall(formatMsg) then 
            SL:release_print("ERROR :TimerNoticeXY "..Msg.." 格式错误")
            GUI:removeAllChildren(Notice._rootTimerTipsXY)
            return
        end

        GUI:removeAllChildren(layout)
        local fontSize = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
        local outlineParam = {
            outlineSize = 1, 
            outlineColor = BColorRGB
        }
        local richText = GUI:RichTextFCOLOR_Create(layout, "richText", capacitySize.width/2, capacitySize.height/2, str, 1000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
        GUI:setAnchorPoint(richText, 0.5, 0.5)

        local text =  GUI:Text_Create(layout, "text", 0, 0, fontSize, "#ffffff", str)
        GUI:setVisible(text, false)
        local textWidth = GUI:getContentSize(text).width
        if data.X ~= 0 then 
            GUI:setPositionX(Notice._rootTimerTipsXY, data.X - (capacitySize.width/2 - textWidth/2))
        end

        if remaining < 0 then
            if data.Label and string.len(data.Label) > 0 then
                SL:SubmitAct({Act = data.Label})
            end
            GUI:removeAllChildren(Notice._rootTimerTipsXY)
        end
        remaining = remaining - 1
    end
    GUI:schedule(layout, callback, 1)
    callback()
end

function Notice.OnDeleteTimerXYNotice()
    GUI:removeAllChildren(Notice._rootTimerTipsXY)
end


function Notice.OnShowItemTips(info)
    local size = {width = 170, height = 20}

    table.insert(Notice._itemTipsData, info)
    if #Notice._itemTipsData > 4 then 
        table.remove(Notice._itemTipsData, #Notice._itemTipsData)
    end 

    local function showTips()
        if #Notice._itemTipsData == 0 then
            SL:UnSchedule(Notice._itemTimer)
            Notice._itemTimer = nil 
            return 
        end

        local tipsData = table.remove(Notice._itemTipsData, #Notice._itemTipsData)
        local data = tipsData.data
        local str = tipsData.str

        -- node
        Notice._itemIndex = Notice._itemIndex + 1
        local node = GUI:Node_Create(Notice._rootItemTips, "nodeItem"..Notice._itemIndex, 0, 0)
        table.insert(Notice._itemTipsCells, node)

        -- richText
        if Notice.isPC then 
            local text = GUI:BmpText_Create(node, "text", 0, 0, SL:ConvertColorFromHexString(data.color), str)
            if data.heroStr then 
                local text2 = GUI:BmpText_Create(node, "text2", -4, 0, SL:ConvertColorFromHexString(data.heroColor), data.heroStr)
                GUI:setAnchorPoint(text2, 1, 0)
            end
        else
            local text = GUI:RichText_Create(node, "text", 0, 0, str, 1136)
            GUI:setAnchorPoint(text, 0, 0.5)
            GUI:setCascadeOpacityEnabled(text, true)
        end

        -- 最多4条
        while #Notice._itemTipsCells > 4 do
            GUI:removeFromParent(Notice._itemTipsCells[1])
            table.remove(Notice._itemTipsCells, 1)
        end

        -- action
        local function callback()
            GUI:removeFromParent(node)
            table.remove(Notice._itemTipsCells, 1)
        end

        GUI:setCascadeOpacityEnabled(node, true)
        local sequence = GUI:ActionSequence(GUI:DelayTime(2), GUI:ActionFadeTo(0.8,50), GUI:CallFunc(callback))
        GUI:runAction(node, sequence)
    
        local actionTag = 999
        for i = 1, #Notice._itemTipsCells do
            if Notice._itemTipsCells[i] then 
                GUI:setPositionY(Notice._itemTipsCells[i], size.height * (#Notice._itemTipsCells - i - 0.5))
                local action  = GUI:ActionMoveTo(0.15, 0, size.height * (#Notice._itemTipsCells - i + 0.5))
                GUI:setTag(action, actionTag)
                GUI:stopActionByTag(Notice._itemTipsCells[i], actionTag)
                GUI:runAction(Notice._itemTipsCells[i], action)
            end 
        end
    end

    if not Notice._itemTimer then
        Notice._itemTimer = SL:Schedule(showTips, 1/60)
    end
end

function Notice.OnShowAttributeTips(data)
    -- 空消息
    if not next(data) then
        return
    end

    -- 最多七条
    table.insert(Notice._attributeData, data)
    if #Notice._attributeData > 1 then 
        table.remove(Notice._attributeData, 1)
    end 

    Notice.CheckNoticeAttribute()
end

function Notice.CheckNoticeAttribute()
    -- 解析cd中
    if Notice._attributeCDing then
        return false
    end

    -- 没有消息
    if #Notice._attributeData == 0 then
        return false
    end

    -- 解析下一个
    local function nextEvent()
        Notice._attributeCDing = false
        Notice.CheckNoticeAttribute()
    end
    
    SL:scheduleOnce(Notice._rootAttribute, nextEvent, 2.5)

    Notice._attributeCDing = true
    local data = Notice._attributeData[1]
    table.remove(Notice._attributeData, 1)

    local attributes = data.attributes
    local attr_type = data.attr_type or 0

    local attr_data = {}
    local showAttrs = GUIFunction:GetAttShowOrder(attributes)
    for i, v in ipairs(showAttrs) do
        -- 最多显示7条
        if i > 7 then
            break
        end

        local data = {}
        data.name = v.name
        data.attr = v.value
        table.insert(attr_data, data)
    end

    Notice.ShowAttributes(attr_data)
end

function Notice.ShowAttributes(attrs)
    local attributeCells = {}
    for i, v in ipairs(attrs) do
        -- cell
        Notice._attrIndex = Notice._attrIndex + 1
        local widget = GUI:Widget_Create(Notice._rootAttribute, "widget"..Notice._attrIndex, 0, 0)
        local cell = Notice.createAttribute(widget)
        GUI:setVisible(cell, true)
        table.insert(attributeCells, cell)

        local textName = GUI:getChildByName(cell, "Text_name") 
        local textAttr = GUI:getChildByName(cell, "Text_attr") 
        -- name
        GUI:Text_setFontSize(textName, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16)
        GUI:Text_setTextColor(textName, "#28ef01")
        GUI:Text_enableOutline(textName, "#111111", 1)
        GUI:Text_setString(textName, v.name)
        GUI:setPositionX(textName, 0)
        -- attribute
        GUI:Text_setFontSize(textAttr, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16)
        GUI:Text_setTextColor(textAttr, "#28ef01")
        GUI:Text_enableOutline(textAttr, "#111111", 1)
        GUI:Text_setString(textAttr, "+  " .. v.attr)
        local posX = GUI:getPositionX(textName) + GUI:getContentSize(textName).width + 0
        GUI:setPositionX(textAttr, posX)

        -- action
        local attrPos = 0 - (i - 1) * 30
        GUI:setPositionY(cell, attrPos - 100)
        GUI:setOpacity(cell, 0)

        local function delayEvent()
            if next(attributeCells) then
                table.remove(attributeCells, 1)
            end
            for _, vNode in ipairs(attributeCells) do
                GUI:runAction(vNode, GUI:ActionMoveBy(0.15, 0, 40))
            end
        end

        local delay = (i - 1) * 0.15
        local spawn1 = GUI:ActionSpawn(GUI:ActionFadeIn(0.2), GUI:ActionMoveBy(0.2, 0, 100))
        local spawn2 = GUI:ActionSpawn(GUI:CallFunc(delayEvent), 
            GUI:ActionFadeOut(0.2), 
            GUI:ActionScaleTo(0.2, 0.8), 
            GUI:ActionMoveBy(0.2, 100, 20)
        )
        local sequence = GUI:ActionSequence(GUI:DelayTime(delay), spawn1, GUI:DelayTime(1.5), spawn2, GUI:ActionRemoveSelf())
        GUI:runAction(cell, sequence)
    end
end

function Notice.OnShowPlayerEXPNotice(data)
    local X             = tonumber(data.X)
    local Y             = tonumber(data.Y)
    data.FColor         = data.FColor or 255
    data.BColor         = data.BColor or 255
    local FColorRGB     = SL:GetColorByStyleId(data.FColor)
    local BColorRGB     = SL:GetColorByStyleId(data.BColor)

    if not X or not Y then
        return
    end
    
    if not Notice._expNode then
        Notice._expNode = GUI:Node_Create(Notice._root, "_expNode", 0, 0)
        GUI:setAnchorPoint(Notice._expNode, 0, 0)
    end
    local notch, rect = SL:GetValue("NOTCH_PHONE_INFO")
    local bangsX = rect and rect.x or 0
    local visibleSize = SL:GetValue("SCREEN_SIZE")
    Y = visibleSize.height - Y
    GUI:setPosition(Notice._expNode, X + bangsX, Y)

    -- node
    Notice._expIndex = Notice._expIndex + 1
    local node = GUI:Node_Create(Notice._expNode, "nodeEXP"..Notice._expIndex, 0, 0)
    GUI:setAnchorPoint(node, 0, 0)
    GUI:setCascadeOpacityEnabled(node, true)

    -- richText
    local fontSize  = SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
    local outlineParam = {
        outlineSize = 1, 
        outlineColor = BColorRGB
    }
    local richText = GUI:RichTextFCOLOR_Create(node, "richText", 0, 0, data.Msg, 10000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
    GUI:setCascadeOpacityEnabled(richText, true)
    GUI:setAnchorPoint(richText, 0, 1)
    GUI:setIgnoreContentAdaptWithSize(richText, false)

    -- action
    Notice._expCells[#Notice._expCells + 1] = node
    while #Notice._expCells > 4 do
        GUI:removeFromParent(Notice._expCells[1])
        table.remove(Notice._expCells, 1)
    end

    local function callback()
        GUI:removeFromParent(node)
        table.remove(Notice._expCells, 1)
    end 
    local sequence = GUI:ActionSequence(GUI:DelayTime(2), GUI:ActionFadeOut(0.5), GUI:CallFunc(callback))
    GUI:runAction(node,sequence)

    local tag = 999
    for index, cell in pairs(Notice._expCells) do
        cell:setPositionY(30 * (#Notice._expCells - index - 1))
        local action = GUI:ActionMoveTo(0.15, 0, 30 * (#Notice._expCells - index))
        GUI:setTag(action, tag)
        GUI:stopActionByTag(cell, tag)
        GUI:runAction(cell, action)
    end
end

function Notice.OnShowItemDropNotice(data)
    if not GUIDefineEx.ShowDropNoticeParam or not next(GUIDefineEx.ShowDropNoticeParam) then
        return
    end
    local X             = GUIDefineEx.ShowDropNoticeParam.x
    local Y             = GUIDefineEx.ShowDropNoticeParam.y
    local interval      = GUIDefineEx.ShowDropNoticeParam.interval
    local setFontSize   = GUIDefineEx.ShowDropNoticeParam.setFontSize
    local maxCount      = GUIDefineEx.ShowDropNoticeParam.maxCount
    local delayTime     = GUIDefineEx.ShowDropNoticeParam.delayTime
    local opacity       = GUIDefineEx.ShowDropNoticeParam.opacity
    data.FColor         = data.FColor or 255
    local FColorHEX     = SL:GetHexColorByStyleId(data.FColor)
    local BColorRGB     = data.BColor and SL:GetHexColorByStyleId(data.BColor)

    -- node
    local viewSize = SL:GetValue("SCREEN_SIZE")
    Notice._rootDropTips:setPositionX(viewSize.width / 2 + X)
    local originY = viewSize.height - 50
    Notice._rootDropTips:setPositionY(originY + Y)
    Notice._dropIndex = Notice._dropIndex + 1
    local node = GUI:Node_Create(Notice._rootDropTips, "nodeDrop" .. Notice._dropIndex, 0, 0)
    GUI:setAnchorPoint(node, 0.5, 0)
    GUI:setCascadeOpacityEnabled(node, true)

    -- layout
    local layout = nil
    if BColorRGB and (data.BColor and data.BColor ~= -1) then
        layout = GUI:Layout_Create(node, "layout", 0, 0, 200, 30, true)
        GUI:Layout_setBackGroundColor(layout, BColorRGB)
        GUI:Layout_setBackGroundColorType(layout, 1)
        GUI:Layout_setBackGroundColorOpacity(layout, opacity)
        GUI:setAnchorPoint(layout, 0.5, 0)
    end

    -- richText
    local fontSize  = setFontSize or SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
    local richText = GUI:RichText_Create(node, "richText", 0, 0, data.Msg, 10000, fontSize, FColorHEX)
    GUI:setCascadeOpacityEnabled(richText, true)
    GUI:setAnchorPoint(richText, 0.5, 0)

    -- size
    local sizeW = GUI:getContentSize(richText).width
    local sizeH = GUI:getContentSize(richText).height
    if layout then
        GUI:setContentSize(layout, sizeW, sizeH)
    end

    -- action
    table.insert(Notice._dropTipsCells, node)
    if #Notice._dropTipsCells > maxCount then 
        GUI:removeFromParent(Notice._dropTipsCells[1])
        table.remove(Notice._dropTipsCells, 1)
    end 

    local function callback()
        GUI:removeFromParent(node)
        table.remove(Notice._dropTipsCells, 1)
    end 
    local sequence = GUI:ActionSequence(GUI:DelayTime(delayTime), GUI:ActionFadeOut(0.8), GUI:CallFunc(callback))
    GUI:runAction(node, sequence)

    local tag = 999
    for i = 1, #Notice._dropTipsCells do
        local node = Notice._dropTipsCells[i]
        if node then 
            local action = GUI:ActionMoveTo(0.15, 0, (sizeH + interval) * (#Notice._dropTipsCells - i ) - interval)
            GUI:setTag(action, tag)
            GUI:stopActionByTag(node, tag)
            GUI:setPositionY(node, (sizeH + interval) * (#Notice._dropTipsCells - i - 1) - interval)
            GUI:runAction(node, action)
        end 
    end
end

function Notice.InitNGEXPSetParam()
    -- 解析配置
    if SL:GetValue("GAME_DATA", "NGEXPcoordinate") then
        local slicesP = string.split(SL:GetValue("GAME_DATA", "NGEXPcoordinate"), "|")
        -- 下标： 1 移动端位置XY  2 PC端位置XY  3 颜色FColor#BColor  4 需满足的经验值
        for i = 1, 4 do
            local pointXY   = string.split(slicesP[i] or "0#0","#")
            local param1    = tonumber(pointXY[1]) or (i == 3 and 255 or 0)
            local param2    = tonumber(pointXY[2]) or 0
            if i == 4 then
                Notice._ngExpParam[i] = param1
            elseif i == 3 then
                Notice._ngExpParam[i] = {FColor = param1, BColor = param2}
            else
                Notice._ngExpParam[i] = {X = param1, Y = param2}
            end
        end
    end
end

function Notice.OnShowNGEXPNotice(data)
    if not Notice._ngExpParam or not next(Notice._ngExpParam) then
        return
    end
    local needExp = Notice._ngExpParam[4]
    if not data.changed or data.changed < needExp then
        return
    end

    local type          = Notice.isPC and 2 or 1
    local X             = Notice._ngExpParam[type].X
    local Y             = Notice._ngExpParam[type].Y
    data.FColor         = Notice._ngExpParam[3].FColor or 255
    data.BColor         = Notice._ngExpParam[3].BColor or 255
    local FColorRGB     = SL:GetColorByStyleId(data.FColor)
    local BColorRGB     = SL:GetColorByStyleId(data.BColor)

    if not X or not Y then
        return
    end
    
    if not Notice._ngExpNode then
        Notice._ngExpNode = GUI:Node_Create(Notice._root, "_ngExpNode", 0, 0)
        GUI:setAnchorPoint(Notice._ngExpNode, 0, 0)
    end
    local visibleSize = SL:GetValue("SCREEN_SIZE")
    Y = visibleSize.height - Y
    GUI:setPosition(Notice._ngExpNode, X, Y)

    -- node
    Notice._ngExpIndex = Notice._ngExpIndex + 1
    local node = GUI:Node_Create(Notice._ngExpNode, "nodeNGEXP" .. Notice._ngExpIndex, 0, 0)
    GUI:setAnchorPoint(node, 0, 0)
    GUI:setCascadeOpacityEnabled(node, true)

    -- richText
    local fontSize  = SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE") or 16
    local outlineParam = {
        outlineSize = 1, 
        outlineColor = BColorRGB
    }
    if string.find(data.Msg, "%%s") then
        data.Msg = string.format(data.Msg, data.changed)
    end
    local richText = GUI:RichTextFCOLOR_Create(node, "richText", 0, 0, data.Msg, 10000, fontSize, FColorRGB, nil, nil, nil, outlineParam)
    GUI:setCascadeOpacityEnabled(richText, true)
    GUI:setAnchorPoint(richText, 0, 1)
    GUI:setIgnoreContentAdaptWithSize(richText, false)

    -- action
    Notice._ngExpCells[#Notice._ngExpCells + 1] = node
    while #Notice._ngExpCells > 4 do
        GUI:removeFromParent(Notice._ngExpCells[1])
        table.remove(Notice._ngExpCells, 1)
    end

    local function callback()
        GUI:removeFromParent(node)
        table.remove(Notice._ngExpCells, 1)
    end 
    local sequence = GUI:ActionSequence(GUI:DelayTime(2), GUI:ActionFadeOut(0.5), GUI:CallFunc(callback))
    GUI:runAction(node,sequence)

    local tag = 999
    for index, cell in pairs(Notice._ngExpCells) do
        cell:setPositionY(30 * (#Notice._ngExpCells - index - 1))
        local action = GUI:ActionMoveTo(0.15, 0, 30 * (#Notice._ngExpCells - index))
        GUI:setTag(action, tag)
        GUI:stopActionByTag(cell, tag)
        GUI:runAction(cell, action)
    end
end

function Notice.OnShowHeroNGEXPNotice(data)
    local msg = "%s <英雄/FCOLOR=22>内功经验值增加."
    data.Msg = msg
    Notice.OnShowNGEXPNotice(data)
end

function Notice.OnShowPlayerNGEXPNotice(data)
    local msg = "%s 内功经验值增加."
    data.Msg = msg
    Notice.OnShowNGEXPNotice(data)
end

-----------------------------------注册事件--------------------------------------
function Notice.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "Notice", Notice.OnAdapet)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_SERVER, "Notice", Notice.OnShowServerNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_SERVER_EVENT, "Notice", Notice.OnShowServerEventNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM, "Notice", Notice.OnShowSystemNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM_TIPS, "Notice", Notice.OnShowSystemTips)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM_SCALE, "Notice", Notice.OnShowSystemScaleNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM_XY, "Notice", Notice.OnShowSystemXYNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_TIMER, "Notice", Notice.OnShowTimerNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_DELETE_TIMER, "Notice", Notice.OnDeleteTimerNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_TIMER_XY, "Notice", Notice.OnShowTimerXYNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_DELETE_TIMER_XY, "Notice", Notice.OnDeleteTimerXYNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_ITEM_TIPS, "Notice", Notice.OnShowItemTips)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_ATTRIBUTE, "Notice", Notice.OnShowAttributeTips)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_EXP, "Notice", Notice.OnShowPlayerEXPNotice)
    SL:RegisterLUAEvent(LUA_EVENT_NOTICE_DROP, "Notice", Notice.OnShowItemDropNotice)
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_EXP_CHANGE, "Notice", Notice.OnShowPlayerNGEXPNotice)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_EXP_CHANGE, "Notice", Notice.OnShowHeroNGEXPNotice)
    SL:RegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Notice", Notice.OnAdapet)
end

function Notice.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_SERVER, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_SERVER_EVENT, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM_TIPS, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM_SCALE, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_SYSYTEM_XY, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_TIMER, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_DELETE_TIMER, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_TIMER_XY, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_DELETE_TIMER_XY, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_ITEM_TIPS, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_ATTRIBUTE, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_EXP, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_NOTICE_DROP, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_INTERNAL_EXP_CHANGE, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_EXP_CHANGE, "Notice")
    SL:UnRegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Notice")
end
