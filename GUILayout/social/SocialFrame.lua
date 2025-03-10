SocialFrame = {}

SocialInfo = SocialInfo or {}

function SocialFrame.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    local pageIndex = data or 1
    local layer = GUI:GetWindow(nil, UIConst.LAYERID.SocialGUI)
    SocialFrame._layer = layer
    if not SocialFrame._layer then 
        SocialFrame.InitData()
        local layerID = SocialInfo._pageIDVec[pageIndex]
        SocialFrame.InitUI(layerID)
        SocialFrame.RegisterEvent()
    else
        local layerID = SocialInfo._pageIDVec[pageIndex]
        SocialFrame.PageTo(layerID)
    end
end

function SocialFrame.InitData()
    SocialInfo._isWin32 = SL:GetValue("IS_PC_OPER_MODE")
    SocialInfo._Pages = {}
    SocialInfo._pageID = 0
    -- 页签ID
    SocialInfo._pageIDVec = {
        UIConst.LayerTable.NearPlayer,
        UIConst.LayerTable.Team,
        UIConst.LayerTable.Friend,
        UIConst.LayerTable.Mail,
        UIConst.LayerTable.Relation,
    }

    SocialInfo._pageCloseEvent = {
        [UIConst.LayerTable.NearPlayer] = LUA_EVENT_SOCIAL_NRAR_PLAYER_LAYER_CLOSE,
        [UIConst.LayerTable.Team] = LUA_EVENT_SOCIAL_TEAM_LAYER_CLOSE,
        [UIConst.LayerTable.Friend] = LUA_EVENT_SOCIAL_FRIEND_LAYER_CLOSE,
        [UIConst.LayerTable.Mail] = LUA_EVENT_SOCIAL_MAIL_LAYER_CLOSE,
        [UIConst.LayerTable.Relation] = LUA_EVENT_SOCIAL_RELATION_LAYER_CLOSE,
    }

    SocialInfo._pageOpenFile = {
        [UIConst.LayerTable.NearPlayer] = UIConst.LUAFile.LUA_FILE_NEAR_PLAYER,
        [UIConst.LayerTable.Team] = UIConst.LUAFile.LUA_FILE_TEAM,
        [UIConst.LayerTable.Friend] = UIConst.LUAFile.LUA_FILE_FRIEND,
        [UIConst.LayerTable.Mail] = UIConst.LUAFile.LUA_FILE_MAIL,
        [UIConst.LayerTable.Relation] = UIConst.LUAFile.LUA_FILE_RELATION,
    }
end

function SocialFrame.InitUI(layerID)
    local parent = GUI:Win_Create(UIConst.LAYERID.SocialGUI, 0, 0, 0, 0, false, false, true, true)
    SocialFrame._layer = parent
    GUI:LoadExport(parent, SocialInfo._isWin32 and "social/social_frame_win32" or "social/social_frame")
    
    SocialInfo._ui = GUI:ui_delegate(parent)
    
    local CloseLayout = SocialInfo._ui.CloseLayout
    local FrameLayout = SocialInfo._ui.FrameLayout
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(CloseLayout, winSizeW, winSizeH)
    GUI:Win_SetZPanel(parent, FrameLayout)

    if SocialInfo._isWin32 then
        -- 显示适配
        GUI:setPosition(FrameLayout, winSizeW / 2, SL:GetValue("PC_POS_Y"))
                
        -- 可拖拽
        GUI:Win_SetDrag(parent, FrameLayout)
        GUI:setVisible(CloseLayout, false)
    else
        -- 全屏关闭
        GUI:setVisible(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(parent)
        end)

        -- 显示适配
        GUI:setPosition(FrameLayout, winSizeW / 2, winSizeH / 2)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(SocialInfo._ui["CloseButton"], function()
        GUI:Win_Close(parent)
    end)

    for i, layerId in ipairs(SocialInfo._pageIDVec) do
        local btnName = "page_cell_"..i
        local pageBtn = SocialInfo._ui[btnName]
        if pageBtn then
            GUI:Win_SetParam(pageBtn, layerId)
            GUI:addOnClickEvent(GUI:getChildByName(pageBtn, "TouchSize"), function()
                SocialFrame.PageTo(layerId)
            end)
            SocialInfo._Pages[btnName] = pageBtn
        end
    end

    -- 默认跳到第一个
    SocialFrame.PageTo(layerID)
end

function SocialFrame.PageTo(pageID)
    if not pageID or SocialInfo._pageID == pageID then
        return
    end

    SocialFrame.OnClose()

    SocialInfo._pageID = pageID

    SocialFrame.OnOpen()

    SocialFrame.SetPageStatus()
end

function SocialFrame.OnClose()
    SL:onLUAEvent(SocialInfo._pageCloseEvent[SocialInfo._pageID])
    GUI:removeAllChildren(SocialInfo._ui.AttachLayout)
end

function SocialFrame.OnOpen()
    GUI:SetLayerOpenParam(SocialInfo._ui.AttachLayout)
    GUI:Win_Open(SocialInfo._pageOpenFile[SocialInfo._pageID])
end

function SocialFrame.SetPageStatus()
    for _, uiPage in pairs(SocialInfo._Pages) do
        if uiPage then
            local index = GUI:Win_GetParam(uiPage)
            local isSel = index == SocialInfo._pageID and true or false
            GUI:Button_setBright(uiPage, not isSel)
            GUI:setLocalZOrder(uiPage, isSel and 2 or 0)

            local uiText = GUI:getChildByName(uiPage, "PageText")
            if uiText then
                GUI:Text_setFontSize(uiText, SL:GetValue("IS_PC_OPER_MODE") and 13 or 16)
                local selColor = SL:GetValue("IS_PC_OPER_MODE") and "#e6e7a7" or "#f8e6c6"
                GUI:Text_setTextColor(uiText, isSel and selColor or "#807256")
                GUI:Text_enableOutline(uiText, "#111111", 2)
                if isSel then
                    local titleStr = string.gsub(GUI:Text_getString(uiText), "\n", "")
                    GUI:Text_setString(SocialInfo._ui["TitleText"], titleStr)
                end
            end
        end
    end
end

--------------------------- 注册事件 -----------------------------
function SocialFrame.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "SocialFrame", SocialFrame.OnCloseLayer) --关闭界面
end
-------------------------------------------------------------------

-- 关闭监听
function SocialFrame.OnCloseLayer(id)
    if UIConst.LAYERID.SocialGUI == id and SocialInfo then 
        SocialFrame.OnClose()
        SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "SocialFrame")
        SocialInfo = nil
    end
end

SocialFrame.main()