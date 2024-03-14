--查看他人 外框
PlayerFrame_Look = {}
PlayerFrame_Look._ui = nil

-- 页签ID
PlayerFrame_Look._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BUFF
}
-- 打开页签
PlayerFrame_Look.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BUFF]        =  SL.OpenPlayerBuffUI
}
PlayerFrame_Look.OpenType = {
    Other = 11  --查看他人
}

function PlayerFrame_Look.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look/player_layer")
    PlayerFrame_Look._ui = GUI:ui_delegate(parent)
    PlayerFrame_Look._parent = parent
    PlayerFrame_Look._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame_Look._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    if not PlayerFrame_Look._ui then
        return false
    end

    --适配
    GUI:setPositionY(PlayerFrame_Look._ui.Panel_1, SL:GetMetaValue("SCREEN_HEIGHT") / 2)

    --拖动的控件
    GUI:Win_SetDrag(parent, PlayerFrame_Look._ui.Panel_1)

    --点击 界面浮起
    GUI:Win_SetZPanel(parent, PlayerFrame_Look._ui.Panel_1)

    --关闭
    local closeButton = PlayerFrame_Look._ui.ButtonClose
    if closeButton then
        GUI:addOnClickEvent(closeButton,function()
            SL:CloseOtherPlayerUI()
        end)
    end

    --注册事件
    PlayerFrame_Look.RegisterEvent()

    GUI:setTouchEnabled(PlayerFrame_Look._ui.Panel_btnList, false)

    --刷新名字
    PlayerFrame_Look.RefreshPlayerName()

    --查看他人 点击私聊
    GUI:setTouchEnabled(PlayerFrame_Look._ui.Text_Name, true)
    GUI:addOnClickEvent(
        PlayerFrame_Look._ui.Text_Name,
        function()
            local targetName = SL:GetMetaValue("LOOK_USER_NAME")
            local targetId = SL:GetMetaValue("LOOK_USER_ID")
            SL:PrivateChatWithTarget(targetId, targetName)
        end
    )

    --初始化页签
    PlayerFrame_Look.InitPageChangeBtn()
    PlayerFrame_Look.OpenPage(PlayerFrame_Look._pageid, {init = true, pageId = PlayerFrame_Look._pageid})
end

function PlayerFrame_Look.InitPageChangeBtn()
    local btnList = PlayerFrame_Look._ui.Panel_btnList
    for i, pageId in ipairs(PlayerFrame_Look._pageIDs) do
        local configId = pageId + 100
        if pageId == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP then
            configId = 1000 + SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
        end
        local btnName = "Button_" .. pageId
        local panelBtn = GUI:getChildByName(btnList, btnName)
        if panelBtn then
            local textName = GUI:getChildByName(panelBtn, "Text_name")
            GUI:setLocalZOrder(panelBtn, PlayerFrame_Look._pageid == pageId and 1 or 0)
            GUI:addOnClickEvent(
                panelBtn,
                function()
                    if not SL:CheckMenuLayerConditionByID(configId) then
                        SL:ShowSystemTips("条件不满足!")
                        return 
                    end
                    if PlayerFrame_Look._pageid == pageId then
                        return
                    end
                    PlayerFrame_Look.OpenPage(pageId, {pageId = pageId})
                end
            )
        end
    end
end

function PlayerFrame_Look.RefreshPlayerName()
    local Text_Name = PlayerFrame_Look._ui.Text_Name
    local Name = SL:GetMetaValue("LOOK_USER_NAME")
    GUI:Text_setString(Text_Name, Name)
    local color = SL:GetMetaValue("LOOK_USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

-- 切页
function PlayerFrame_Look.ChangePage(data)
    PlayerFrame_Look._lastPageid = PlayerFrame_Look._pageid
    PlayerFrame_Look._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    local btnList = PlayerFrame_Look._ui.Panel_btnList

    local btnLastPage = GUI:getChildByName(btnList, "Button_" .. PlayerFrame_Look._lastPageid)
    GUI:setLocalZOrder(btnLastPage, 0)
    GUI:setTouchEnabled(btnLastPage, true)
    GUI:Button_setBright(btnLastPage, true)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, "#807256")

    local btnNowPage = GUI:getChildByName(btnList, "Button_" .. PlayerFrame_Look._pageid)
    GUI:setLocalZOrder(btnNowPage, 1)
    GUI:setTouchEnabled(btnNowPage, false)
    GUI:Button_setBright(btnNowPage, false)
    local textNowName = GUI:getChildByName(btnNowPage, "Text_name")
    GUI:Text_setTextColor(textNowName, "#f8e6c6")

    if not data.init then
        SL:CloseOtherPlayerPageUI(PlayerFrame_Look._lastPageid)
    end

    PlayerFrame_Look.CreateLayerPanelChild(data.child)
end

-- 添加子页面到外框
function PlayerFrame_Look.CreateLayerPanelChild(panel)
    if panel then
        GUI:addChild(PlayerFrame_Look._ui.Node_panel, panel)
    end
end

-- 切换子页面
function PlayerFrame_Look.ChangeOpenedPage(id, data)
    PlayerFrame_Look.OpenPage(id)
end

-- 关闭外框
function PlayerFrame_Look.OnCloseMainLayer()
    PlayerFrame_Look.UnRegisterEvent()
    --关闭子页
    SL:CloseOtherPlayerPageUI(PlayerFrame_Look._pageid)
end

-- 打开子页签
function PlayerFrame_Look.OpenPage(LayerID, data)
    local openFunc = PlayerFrame_Look.OpenFunc[LayerID]
    local openType = PlayerFrame_Look.OpenType.Other
    if openFunc then
        openFunc(SL, openType, data)
    end
end

function PlayerFrame_Look.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LOOK_FRAME_PAGE_ADD, "PlayerFrame_Look", PlayerFrame_Look.ChangePage)
end

function PlayerFrame_Look.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_LOOK_FRAME_PAGE_ADD, "PlayerFrame_Look")
end
