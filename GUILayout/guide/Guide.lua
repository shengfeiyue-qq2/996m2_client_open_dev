Guide = {}

Guide._dirMoveByDisX = {-10, -10, 0, 10, 10, 10, 0, -10}
Guide._dirMoveByDisY = {0, 10, 10, 10, 0, -10, -10, -10}

Guide._rimXPosScale = {-1, 1, -1, 1}
Guide._rimYPosScale = {1, 1, -1, -1}

function Guide.main()
    Guide._GuideWidgetConfig = SL:RequireFile(GUIDefine.PATH_GUIDE_CONFIG)
    Guide._data              = GUI:GetLayerOpenParam()
    Guide._widget            = nil
    Guide._parent            = nil
    Guide._position          = nil
    Guide._contentSize       = nil
    Guide._active            = true
    Guide._layer             = nil
    Guide._layoutBlack       = nil
    Guide._path              = GUIDefine.PATH_RES_PRIVATE .. "guide/"
    Guide._ssrWidget         = Guide._data and Guide._data.guideWidget
    Guide._ssrParent         = Guide._data and Guide._data.guideParent
    Guide._desc              = Guide._data and Guide._data.guideDesc
    Guide._isForce           = (Guide._data and Guide._data.isForce) == nil and true or Guide._data.isForce -- 默认强制
    Guide._hideMask          = Guide._data and Guide._data.hideMask        -- 禁止蒙版
    Guide._mainType          = Guide._data and tonumber(Guide._data.mainIdx)             -- 主界面
    Guide._autoExcute        = Guide._data and tonumber(Guide._data.autoExcute)
    Guide._clickCallback     = Guide._data and Guide._data.clickCB
    Guide._dir               = Guide._data and tonumber(Guide._data.dir)
    Guide._mainID            = Guide._data and tonumber(Guide._data.mainId) or tonumber(Guide._data.id)
    Guide._uiID              = Guide._data and tonumber(Guide._data.uiId) or tonumber(Guide._data.param)
    Guide._uiIDStr           = Guide._data and Guide._data.uiId or Guide._data.param

    -- 审核服屏蔽
    if SL:GetValue("REVIEW_STATUS") then
        return false
    end
    if not SL:GetValue("MAIN_PLAYER_IS_VALID") then
        return false
    end
    -- 主玩家死亡
    if SL:GetValue("USER_IS_DIE") then
        return false
    end

    Guide.Init()

    SL:SetValue("KEY_BOARD_ABLE", false)

    Guide.RegisterEvent()
end

function Guide.Init()
    local idx = Guide._mainID
    local id = Guide._uiID
    ---------------------创建个吞噬触摸的
    local parent = Guide._mainType and GUI.ATTACH_GUIDE or
        GUI:Win_Create(UIConst.LAYERID.GuideGUI, 0, 0, 0, 0, false, false, false, false, true, nil,
            GUIDefine.UIZ.MASK)
    local layoutBlack = GUI:Widget_Create(parent, "layoutBlack", 0, 0, SL:GetValue("SCREEN_WIDTH"),
        SL:GetValue("SCREEN_HEIGHT"))
    GUI:setTouchEnabled(layoutBlack, true)
    GUI:addOnTouchEvent(layoutBlack, function(sender, eventType)
        if eventType == 0 then
            GUI:setSwallowTouches(layoutBlack, true)
        end
    end)
    Guide._layoutBlack = layoutBlack
    GUI:setLocalZOrder(layoutBlack, 999)
    -----------------------------
    -----------------------直接找控件
    if idx then
        local getNodesFunc = Guide._GuideWidgetConfig[idx]
        if not getNodesFunc then
            SL:SetValue("KEY_BOARD_ABLE", true)
            GUI:Win_Close(parent)
            return
        end
        local temp = {typeassist = Guide._uiIDStr}
        Guide._widget, Guide._parent = getNodesFunc(temp)
        Guide._StartEventName = GUIDefine.GuideEvent[idx] and GUIDefine.GuideEvent[idx].start
        Guide._EndEventName = GUIDefine.GuideEvent[idx] and GUIDefine.GuideEvent[idx].close
        Guide.getNodesFunc = getNodesFunc
        if idx == 110 then                --如果是任务就先把框漏出来
            SL:SetTaskBarState({ status = false })
        elseif idx == 109 then            -- 按钮模块 切换
            SL:onLUAEvent(LUA_EVENT_GUIDE_ENTER_TRANSITION, { name = "GUIDE_BEGIN_SKILL_BUTTON" })
        elseif idx == 1 or idx == 47 then -- 背包 英雄背包 的双击使用
            if idx == 1 then
                Guide._BagPage = BagData.GetBagPageByMakeIndex(Guide._uiIDStr)
                if Guide._BagPage and Guide._parent then --页数不对  得切换 一下
                    local curPage = Guide._parent.GetSelectPage and Guide._parent:GetSelectPage() or BagData.GetCurPage()
                    if curPage ~= Guide._BagPage then
                        UIOperator:OpenBagUI({ bag_page = Guide._BagPage })
                    end
                end
            end

            if id ~= -1 then
                Guide._clickCallback = function()
                    local nowItemData = BagData.GetItemDataByMakeIndex(Guide._uiIDStr)
                    if idx == 1 then
                        nowItemData.from = GUIDefine.ItemGoTo.BAG
                        SL:RequestUseItem(nowItemData)
                    else
                        nowItemData.from = GUIDefine.ItemGoTo.HERO_BAG
                        SL:RequestUseHeroItem(nowItemData)
                    end
                end
            end
        end

        --关闭chat
        SL:onLUAEvent(LUA_EVENT_CHAT_PANEL_CLOSE)
        if not Guide._widget or not Guide._parent then --有一个没有  就等一秒或等消息重新找
            Guide._scheduleId = SL:ScheduleOnce(function()
                if Guide._layoutBlack then
                    GUI:removeFromParent(Guide._layoutBlack)
                    Guide._layoutBlack = nil
                end
                Guide._widget, Guide._parent = getNodesFunc(temp)
                if not Guide._widget or not Guide._parent then --还没有直接gg
                    SL:SetValue("KEY_BOARD_ABLE", true)
                    GUI:Win_Close(parent)
                    return
                end
                Guide.CreateGuide()
            end, 1)
        else
            if Guide._layoutBlack then
                GUI:removeFromParent(Guide._layoutBlack)
                Guide._layoutBlack = nil
            end
            Guide.CreateGuide()
        end
    elseif Guide._ssrWidget and Guide._ssrParent and Guide._active then
        Guide._widget = Guide._ssrWidget
        Guide._parent = Guide._ssrParent
        GUI:removeChildByName(Guide._parent, "Guide")

        if GUI:Widget_IsNull(Guide._widget) or GUI:Widget_IsNull(Guide._parent) then
            Guide._widget = nil
            Guide._parent = nil
            return
        end

        if Guide._layoutBlack then
            GUI:removeFromParent(Guide._layoutBlack)
            Guide._layoutBlack = nil
        end
        Guide.CreateGuide()
    end
end

function Guide.OnMainPlayerDie()
    Guide.OnGuideStop()
end

function Guide.OnGuideStop()
    Guide.Exit()
end

-----
function Guide.onGuideNodeChange(data)
    if Guide._active then
        if data.widget then
            Guide._widget = data.widget
        else
            Guide._position = data.pos
            Guide._contentSize = data.size
        end

        Guide.CreateGuide()
        if Guide._scheduleId then
            SL:UnSchedule(Guide._scheduleId)
            Guide._scheduleId = nil
        end
        if Guide._layoutBlack then
            GUI:removeFromParent(Guide._layoutBlack)
            Guide._layoutBlack = nil
        end
    end
end

function Guide.isActive()
    return Guide._active
end

function Guide.onEventBegan(data)
    if Guide._StartEventName then
        if Guide._StartEventName == data.name and Guide._active then
            local temp = {typeassist = Guide._uiIDStr}
            Guide._widget, Guide._parent = Guide.getNodesFunc(temp)
            if Guide._widget and Guide._parent then
                Guide.CreateGuide()
                if Guide._scheduleId then
                    SL:UnSchedule(Guide._scheduleId)
                    Guide._scheduleId = nil
                end
                if Guide._layoutBlack then
                    GUI:removeFromParent(Guide._layoutBlack)
                    Guide._layoutBlack = nil
                end
            end
        end
    end
end

function Guide.OnGuideEventEnded(data)
    if Guide._EndEventName then
        if Guide._EndEventName == data.name and Guide._active then
            if Guide._BagPage and data.bag_page then
                if Guide._BagPage == data.bag_page then --背包有多页  相同的页数才能退
                    Guide.Exit()
                end
            else
                Guide.Exit()
            end
        end
    end
end

function Guide.Exit()
    if Guide._layer and not GUI:Widget_IsNull(Guide._layer) then
        GUI:stopAllActions(Guide._layer)
        GUI:removeFromParent(Guide._layer)
    end
    GUI:Win_CloseByID(UIConst.LAYERID.GuideGUI)
    Guide._active = false
    Guide._layer = nil
    SL:SetValue("KEY_BOARD_ABLE", true)
    Guide.UnRegisterEvent()
end

-----
function Guide.CreateGuide()
    if not Guide._layer then
        Guide._layer = GUI:Widget_Create(Guide._parent, "Guide", 0, 0, 0, 0)
        GUI:setLocalZOrder(Guide._layer, 99)
    end

    GUI:stopAllActions(Guide._layer)
    GUI:removeAllChildren(Guide._layer)

    Guide.ShowForceGuide()
end

local function getRootPosDis(wid, hei, dir)
    if dir == 1 then
        return - wid / 2, 0
    elseif dir == 2 then
        return - (wid / 2 + 10), hei / 2 + 10
    elseif dir == 3 then
        return 0, hei / 2
    elseif dir == 4 then
        return wid / 2 + 10, hei / 2 + 10
    elseif dir == 5 then
        return wid / 2, 0
    elseif dir == 6 then
        return wid / 2 + 10, - (hei / 2 + 10)
    elseif dir == 7 then
        return 0, - hei / 2
    elseif dir == 8 then
        return - (wid / 2 + 10), - (hei / 2 + 10)
    end
end

function Guide.ShowDesc(wid, hei, pos, desc)
    if not Guide._dir then
        local path = "guide/desc_"
        local size = GUI:Size(186, 59)
        local isleft = false
        if pos.x - wid / 2 - size.width > 0 then
            isleft = true
        end
        path = path .. (isleft and "1" or "2")
        GUI:LoadExport(Guide._layer, path)
        local root = GUI:ui_delegate(Guide._layer)
        local nodeDesc = root["Node_desc"]
        local windex = desc and string.find(desc, "widget:")
        if windex and windex == 1 then
            local function callback(data)
                SL:SubmitAct(data)
            end

            local widgetstr = string.sub(desc, windex + 7)
            local elements  = SL:LexicalHelperParse(widgetstr)
            local rootRect  = GUI:Rect(0, 0, 0, 0)
            local widget    = GUI:GetSUILoaderLoadContentRender(elements, callback, nil, rootRect)
            GUI:addChild(nodeDesc, widget)
        else
            local richText = GUI:RichText_Create(nodeDesc, "richText", 0, 0, desc or "", 400, 16, "#ffffff")
            GUI:setAnchorPoint(richText, 0.5, 0.5)
        end

        local pWpos = GUI:convertToNodeSpace(Guide._layer, pos.x, pos.y)
        GUI:setPosition(root["Node"], pWpos.x + (isleft and - wid / 2 or wid / 2), pWpos.y)

        local disX = isleft and 10 or -10
        local disY = 0
        GUI:runAction(root["Node"],
            GUI:ActionRepeatForever(
                GUI:ActionSequence(
                    GUI:ActionMoveBy(0.5, -disX, -disY),
                    GUI:ActionMoveBy(0.5, disX, disY)
                )
            )
        )

        GUI:setVisible(root["Node"], false)
        local delay = 0
        SL:scheduleOnce(root["Node"], function()
            GUI:setVisible(root["Node"], true)
        end, delay)
    else
        local path = string.format("guide/desc_dir_%s", Guide._dir)
        GUI:LoadExport(Guide._layer, path)
        local root = GUI:ui_delegate(Guide._layer)
        local nodeDesc = root["Node_desc"]
        local richText = GUI:RichText_Create(nodeDesc, "richText", 0, 0, desc or "", 400, 16, "#ffffff")
        GUI:setAnchorPoint(richText, 0.5, 0.5)

        local endedPos = GUI:convertToNodeSpace(Guide._layer, pos.x, pos.y)
        local rootPosDisX, rootPosDisY = getRootPosDis(wid, hei, Guide._dir)
        endedPos.x = endedPos.x + rootPosDisX
        endedPos.y = endedPos.y + rootPosDisY
        GUI:setPosition(root["Node"], endedPos)

        local disX = Guide._dirMoveByDisX[Guide._dir]
        local disY = Guide._dirMoveByDisY[Guide._dir]
        GUI:runAction(root["Node"],
            GUI:ActionRepeatForever(
                GUI:ActionSequence(
                    GUI:ActionMoveBy(0.5, -disX, -disY),
                    GUI:ActionMoveBy(0.5, disX, disY)
                )
            )
        )
        
        GUI:setVisible(root["Node"], false)
        local delay =  0
        SL:scheduleOnce(root["Node"], function()
            GUI:setVisible(root["Node"], true)
        end, delay)
    end
end

function Guide.ShowRim(wid, hei, pos)
    -- 外框
    local moveDis = 5
    
    for i = 1, 4 do
        local image = GUI:Image_Create(-1, "layerImage", 0, 0, Guide._path .. "dec_else_3.png")
        GUI:setAnchorPoint(image, 0.5, 0.5)
        GUI:addChild(Guide._layer, image)
        if i == 2 then
            GUI:setFlippedX(image, true)
        elseif i == 3 then
            GUI:setFlippedY(image, true)
        elseif i == 4 then
            GUI:setFlippedY(image, true)
            GUI:setFlippedX(image, true)
        end
        local pWpos = GUI:convertToNodeSpace(Guide._layer, pos.x, pos.y)
        GUI:setPosition(image, pWpos.x + Guide._rimXPosScale[i] * (wid / 2), pWpos.y + Guide._rimYPosScale[i] * (hei / 2))
        local disX = Guide._rimXPosScale[i] * moveDis
        local disY = Guide._rimYPosScale[i] * moveDis
        GUI:runAction(image,
            GUI:ActionRepeatForever(
                GUI:ActionSequence(
                    GUI:ActionMoveBy(0.5, -disX, -disY),
                    GUI:ActionMoveBy(0.5, disX, disY)
                )
            )
        )
    end
end

function Guide.ShowForceGuide(data)
    local wid
    local hei
    local pos
    if Guide._position and Guide._contentSize then
        pos = Guide._position
        wid = Guide._contentSize.width
        hei = Guide._contentSize.height
    else
        local widget = Guide._widget
        if GUI:Widget_IsNull(widget) then
            return
        end

        local worldPos = GUI:convertToWorldSpace(widget, 0, 0)
        local content = GUI:getContentSize(widget)
        local scaleX = GUI:getScaleX(widget)
        local scaleY = GUI:getScaleY(widget)
        wid = content.width * scaleX
        hei = content.height * scaleY
        pos = {
            x = worldPos.x + 0.5 * wid,
            y = worldPos.y + 0.5 * hei
        }
    end

    -- 裁剪背景
    local layoutBlack = GUI:Layout_Create(-1, "layoutBlack", 0, 0, 0, 0)
    GUI:setContentSize(layoutBlack, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))
    GUI:Layout_setBackGroundColorType(layoutBlack, 1)
    GUI:Layout_setBackGroundColorOpacity(layoutBlack, 0)
    GUI:Layout_setBackGroundColor(layoutBlack, "#000000")
    GUI:setTouchEnabled(layoutBlack, true)
    GUI:setMouseEnabled(layoutBlack, true)
    GUI:addMouseButtonEvent(layoutBlack, {
        onRightDownFunc = function()
        end,
        onRightUpFunc   = function()
        end,
        onSpecialRFunc  = function()
        end,
        swallow         = 1
    })

    -- 裁剪模板
    local layoutClip = GUI:Layout_Create(-1, "layoutClip", 0, 0, 0, 0)
    GUI:addChild(layoutBlack, layoutClip)
    GUI:Layout_setBackGroundColorType(layoutClip, 1)
    GUI:setAnchorPoint(layoutClip, 0.5, 0.5)
    GUI:setPosition(layoutClip, pos.x, pos.y)
    GUI:setContentSize(layoutClip, wid, hei)

    -- 裁剪
    local nodePos = GUI:convertToNodeSpace(Guide._layer, 0, 0)
    local clippingNode = GUI:Clipping_Create(Guide._layer, "clippingNode", layoutClip, nodePos.x, nodePos.y)
    GUI:addChild(clippingNode, layoutBlack)

    local function touchCallback(_, eventType)
        local clipBox = GUI:getBoundingBox(layoutClip)
        if eventType == 0 then
            local beganPos = GUI:getTouchBeganPosition(layoutBlack)
            if Guide._isForce then -- 强制指引
                local isTouchedBox = GUI:RectContainsPoint(clipBox, beganPos)
                GUI:setSwallowTouches(layoutBlack, not isTouchedBox)
                if Guide._clickCallback then --如果有自定义的触发条件就吞噬
                    GUI:setSwallowTouches(layoutBlack, true)
                end
            else
                GUI:setSwallowTouches(layoutBlack, false)
                if Guide._clickCallback and GUI:RectContainsPoint(clipBox, beganPos) then
                    GUI:setSwallowTouches(layoutBlack, true)
                end
            end
        elseif eventType == 2 then
            local endPos = GUI:getTouchEndPosition(layoutBlack)
            local isTouchedBox2 = GUI:RectContainsPoint(clipBox, endPos)
            if isTouchedBox2 then
                local func = function()
                    if Guide._clickCallback then
                        Guide._clickCallback()
                    end
                    Guide.Exit()
                end
                if (Guide._mainID == 1 or Guide._mainID == 47) and Guide._uiID ~= -1 then -- 背包的双击使用
                    if layoutBlack._clicking then
                        func()
                        GUI:stopAllActions(layoutBlack)
                        layoutBlack._clicking = false
                    else
                        layoutBlack._clicking = true
                        SL:scheduleOnce(layoutBlack, function()
                            layoutBlack._clicking = false
                        end, GUIDefine.CLICK_DOUBLE_TIME)
                    end
                else
                    func()
                end
            else -- 不在指引区域内
                if not Guide._isForce then
                    if Guide._hideMask then
                        GUI:setSwallowTouches(layoutBlack, false)
                    else
                        Guide.Exit()
                    end
                end
            end
        end
    end

    GUI:addOnTouchEvent(layoutBlack, touchCallback)
    GUI:Layout_setBackGroundColorOpacity(layoutBlack, 100)

    if Guide._autoExcute then
        SL:scheduleOnce(layoutBlack, function ( ... )
            local notExit = false
            if Guide._clickCallback then
                notExit = Guide._clickCallback(Guide)
            elseif Guide._widget and not GUI:Widget_IsNull(Guide._widget) then
                local touchCB = GUI:getOnTouchEvent(Guide._widget)
                if tolua.type(touchCB) == "function" then
                    touchCB(Guide._widget, 2)
                end
            end
            if type(notExit) == "boolean" and notExit then
                return
            end
            if Guide then
                Guide.Exit()
            end
        end, Guide._autoExcute)
    end

    local desc = Guide._desc
    Guide.ShowRim(wid, hei, pos)
    Guide.ShowDesc(wid, hei, pos, desc)
end

function Guide.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE, "Guide", Guide.OnMainPlayerDie)
    SL:RegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Guide", Guide.OnGuideStop)
    SL:RegisterLUAEvent(LUA_EVENT_GUIDE_EVENT_BEGAN, "Guide", Guide.onEventBegan)
    SL:RegisterLUAEvent(LUA_EVENT_GUIDE_EVENT_ENDED, "Guide", Guide.OnGuideEventEnded)
    SL:RegisterLUAEvent(LUA_EVENT_GUIDE_EXIT, "Guide", Guide.Exit)
end

function Guide.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE, "Guide")
    SL:UnRegisterLUAEvent(LUA_EVENT_DEVICE_ROTATION_CHANGED, "Guide")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUIDE_EVENT_BEGAN, "Guide")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUIDE_EVENT_ENDED, "Guide")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUIDE_EXIT, "Guide")
end

Guide.main()
