-- 玩家面板 外框
PlayerFrame = {}
PlayerFrame._ui = nil


-- 页签ID
--[[
    MAIN_PLAYER_LAYER_EQUIP         = 1,
	MAIN_PLAYER_LAYER_BASE_ATTRI    = 2,
	MAIN_PLAYER_LAYER_EXTRA_ATTRO   = 3,
	MAIN_PLAYER_LAYER_SKILL         = 4,
	MAIN_PLAYER_LAYER_TITLE         = 6,
	MAIN_PLAYER_LAYER_SUPER_EQUIP   = 11,
]]
PlayerFrame._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP,
}
-- 打开页签
PlayerFrame.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI]  =  SL.OpenPlayerBaseAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO] =  SL.OpenPlayerExtraAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL]       =  SL.OpenPlayerSkillUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI
}
PlayerFrame.OpenType = {
    Self = 1 --自己
}

function PlayerFrame.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_layer")
    PlayerFrame._ui = GUI:ui_delegate(parent)
    PlayerFrame._parent = parent
    PlayerFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    if not PlayerFrame._ui then
        return false
    end

    -- 适配
    GUI:setPositionY(PlayerFrame._ui.Panel_1, SL:GetMetaValue("SCREEN_HEIGHT") / 2)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, PlayerFrame._ui.Panel_1)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, PlayerFrame._ui.Panel_1)

    -- 名字添加触摸  点击私聊
    GUI:setTouchEnabled(PlayerFrame._ui.Text_Name, true)

    -- 关闭
    local closeButton = PlayerFrame._ui.ButtonClose
    if closeButton then
        GUI:addOnClickEvent(closeButton,function()
            SL:CloseMyPlayerUI()
        end)
    end

    -- 注册事件
    PlayerFrame.RegisterEvent()

    GUI:setTouchEnabled(PlayerFrame._ui.Panel_btnList, false)

    -- 刷新名字
    PlayerFrame.RefreshPlayerName()

    -- 初始化页签
    PlayerFrame.InitPageChangeBtn()
    PlayerFrame.OpenPage(PlayerFrame._pageid, {init = true, pageId = PlayerFrame._pageid})
end

function PlayerFrame.InitPageChangeBtn()
    local btnList = PlayerFrame._ui.Panel_btnList
    for i, pageId in ipairs(PlayerFrame._pageIDs) do
        local configId = pageId + 100
        local btnName = "Button_" .. pageId
        local panelBtn = GUI:getChildByName(btnList, btnName)
        if panelBtn then
            local textName = GUI:getChildByName(panelBtn, "Text_name")
            GUI:setLocalZOrder(panelBtn, PlayerFrame._pageid == pageId and 1 or 0)
            GUI:addOnClickEvent(
                panelBtn,
                function()
                    if not SL:CheckMenuLayerConditionByID(configId) then
                        SL:ShowSystemTips("条件不满足!")
                        return 
                    end
                    if PlayerFrame._pageid == pageId then
                        return
                    end
                    PlayerFrame.OpenPage(pageId, {pageId = pageId})
                end
            )
        end
    end
end

function PlayerFrame.RefreshPlayerName()
    local Text_Name = PlayerFrame._ui.Text_Name
    local Name = SL:GetMetaValue("USER_NAME")
    GUI:Text_setString(Text_Name, Name)
    local color = SL:GetMetaValue("USER_NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(Text_Name, color)
    end
end

-- 切页
function PlayerFrame.ChangePage(data)
    PlayerFrame._lastPageid = PlayerFrame._pageid
    PlayerFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    local btnList = PlayerFrame._ui.Panel_btnList

    local btnLastPage = GUI:getChildByName(btnList, "Button_" .. PlayerFrame._lastPageid)
    GUI:setLocalZOrder(btnLastPage, 0)
    GUI:setTouchEnabled(btnLastPage, true)
    GUI:Button_setBright(btnLastPage, true)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, "#807256")

    local btnNowPage = GUI:getChildByName(btnList, "Button_" .. PlayerFrame._pageid)
    GUI:setLocalZOrder(btnNowPage, 1)
    GUI:setTouchEnabled(btnNowPage, false)
    GUI:Button_setBright(btnNowPage, false)
    local textNowName = GUI:getChildByName(btnNowPage, "Text_name")
    GUI:Text_setTextColor(textNowName, "#f8e6c6")

    if not data.init then
        SL:CloseMyPlayerPageUI(PlayerFrame._lastPageid)
    end

    PlayerFrame.CreateLayerPanelChild(data.child)
end

-- 添加子页面到外框
function PlayerFrame.CreateLayerPanelChild(panel)
    if panel then
        GUI:addChild(PlayerFrame._ui.Node_panel, panel)
    end
end

-- 切换子页面
function PlayerFrame.ChangeOpenedPage(id, data)
    PlayerFrame.OpenPage(id)
end

-- 关闭外框
function PlayerFrame.OnCloseMainLayer()
    PlayerFrame.UnRegisterEvent()
    --关闭子页
    SL:CloseMyPlayerPageUI(PlayerFrame._pageid)
end

-- 打开子页签
function PlayerFrame.OpenPage(LayerID, data)
    local openFunc = PlayerFrame.OpenFunc[LayerID]
    local openType = PlayerFrame.OpenType.Self
    if openFunc then
        openFunc(SL, openType, data)
    end
end

function PlayerFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "PlayerFrame", PlayerFrame.ChangePage)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame", PlayerFrame.RefreshPlayerName)
end

function PlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "PlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame")
end
