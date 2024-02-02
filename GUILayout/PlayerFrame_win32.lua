-- 玩家面板 外框
PlayerFrame = {}
PlayerFrame._ui = nil


-- 页签ID
PlayerFrame._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
}
-- 打开页签 基础
PlayerFrame.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI]  =  SL.OpenPlayerBaseAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO] =  SL.OpenPlayerExtraAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL]       =  SL.OpenPlayerSkillUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI
}

-- 内功
PlayerFrame._pageNGIDs = {1, 2, 3, 4}
-- 打开页签 内功
PlayerFrame.OpenNGFunc = {
    [1]         =  SL.OpenInternalStateUI,
    [2]         =  SL.OpenInternalSkillUI,
    [3]         =  SL.OpenInternalMerdianUI,
    [4]         =  SL.OpenInternalComboUI,
}

PlayerFrame.OpenType = {
    Self = 1 --自己
}

PlayerFrame._showType = 1    -- 1 基础 2 内功

function PlayerFrame.main(data)
    local parent = GUI:Attach_Parent()
    PlayerFrame._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1
    if PlayerFrame._NGShow then
        GUI:LoadExport(parent, "player/player_layer_ng_win32")
    else
        GUI:LoadExport(parent, "player/player_layer_win32")
    end
    PlayerFrame._ui = GUI:ui_delegate(parent)
    PlayerFrame._parent = parent
    PlayerFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame._isFast = data and data.isFast or false -- 快捷键打开
    PlayerFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    PlayerFrame._showType = data and data.type or 1
    if not PlayerFrame._ui then
        return false
    end

    -- 适配
    GUI:setPositionY(PlayerFrame._ui.Panel_1, SL:GetMetaValue("PC_POS_Y"))

    -- 拖动的控件
    GUI:Win_SetDrag(parent, PlayerFrame._ui.Panel_1)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, PlayerFrame._ui.Panel_1)

    -- 名字添加触摸  点击私聊
    GUI:setTouchEnabled(PlayerFrame._ui.Text_Name, true)
    GUI:addOnClickEvent(
        PlayerFrame._ui.Text_Name,
        function()
            local targetName = SL:GetMetaValue("USER_NAME")
            local targetId = SL:GetMetaValue("USER_ID")
            SL:PrivateChatWithTarget(targetId, targetName)
        end
    )
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

    -- 切换内功显示
    PlayerFrame._initBtn = {}
    if PlayerFrame._NGShow then
        PlayerFrame.InitTopTypePanel()
        PlayerFrame.OnChangeTopShow()
    end

    -- 初始化页签
    PlayerFrame.InitPageChangeBtn()
    PlayerFrame.OpenPage(PlayerFrame._pageid, {init = true, pageId = PlayerFrame._pageid})
end

function PlayerFrame.InitTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(PlayerFrame._ui[name], PlayerFrame._showType ~= i)
        GUI:setLocalZOrder(PlayerFrame._ui[name], PlayerFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(PlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, PlayerFrame._showType == i and "#f8e6c6" or "#807256")
        GUI:addOnClickEvent(PlayerFrame._ui[name], function()
            if PlayerFrame._showType == i then
                return
            end
            PlayerFrame.ChangeShowType(i)
            PlayerFrame.OpenPage(1, {pageId = 1})
        end)
    end
end

function PlayerFrame.RefreshTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(PlayerFrame._ui[name], PlayerFrame._showType ~= i)
        GUI:setLocalZOrder(PlayerFrame._ui[name], PlayerFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(PlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, PlayerFrame._showType == i and "#f8e6c6" or "#807256")
    end
end

function PlayerFrame.InitPageChangeBtn()
    local btnList = PlayerFrame._ui.Panel_btnList
    if PlayerFrame._NGShow then 
        btnList = PlayerFrame._showType == 1 and PlayerFrame._ui.Panel_btnList or PlayerFrame._ui.Panel_btnList_ng
        GUI:setVisible(PlayerFrame._ui.Panel_btnList, PlayerFrame._showType == 1)
        GUI:setVisible(PlayerFrame._ui.Panel_btnList_ng, PlayerFrame._showType == 2)
    end
    local menu_groupID = PlayerFrame._showType == 1 and 1 or 7
    local pageIDList = PlayerFrame._showType == 1 and PlayerFrame._pageIDs or PlayerFrame._pageNGIDs
    if not PlayerFrame._initBtn[PlayerFrame._showType] then
        for i, pageId in ipairs(pageIDList) do
            local configId = pageId + (100 * menu_groupID)
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
        PlayerFrame._initBtn[PlayerFrame._showType] = true
    end
end

function PlayerFrame.ChangeShowType(i)
    if PlayerFrame._showType == i then
        return
    end
    PlayerFrame._lastType = PlayerFrame._showType
    PlayerFrame._showType = i
    PlayerFrame.RefreshTopTypePanel()
    PlayerFrame.InitPageChangeBtn()
end

function PlayerFrame.RefreshPlayerName()
    local Text_Name = PlayerFrame._ui.Text_Name
    local Name = SL:GetMetaValue("USER_NAME")
    if PlayerFrame._isFast then
        Name = SL:GetMetaValue("REAL_USER_NAME") -- 真实名字  神秘人时显示真实名字
    end
    GUI:Text_setString(Text_Name, Name)
    local color = SL:GetMetaValue("USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

function PlayerFrame.RefreshBtnState()
    local btnList = PlayerFrame._ui.Panel_btnList
    if PlayerFrame._NGShow then 
        btnList = PlayerFrame._showType == 1 and PlayerFrame._ui.Panel_btnList or PlayerFrame._ui.Panel_btnList_ng
    end
    for _, child in ipairs(GUI:getChildren(btnList)) do
        local isSelected = GUI:getName(child) == ("Button_" .. PlayerFrame._pageid)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end
end

-- 切页
function PlayerFrame.ChangePage(data)
    PlayerFrame._lastPageid = PlayerFrame._pageid
    PlayerFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    PlayerFrame.RefreshBtnState()

    if PlayerFrame._lastType == 1 then
        SL:CloseMyPlayerPageUI(PlayerFrame._lastPageid)
        PlayerFrame._lastType = false
    elseif PlayerFrame._lastType == 2 then
        SL:CloseMyPlayerInternalPageUI(PlayerFrame._lastPageid)
        PlayerFrame._lastType = false
    elseif not data.init then
        if data.isInternal then
            SL:CloseMyPlayerInternalPageUI(PlayerFrame._lastPageid)
        else
            SL:CloseMyPlayerPageUI(PlayerFrame._lastPageid)
        end
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
    if PlayerFrame._showType == 1 then
        SL:CloseMyPlayerPageUI(PlayerFrame._pageid)
    else
        SL:CloseMyPlayerInternalPageUI(PlayerFrame._pageid)
    end
end

-- 打开子页签
function PlayerFrame.OpenPage(id, data)
    local openFunc = PlayerFrame._showType == 1 and PlayerFrame.OpenFunc[id] or PlayerFrame.OpenNGFunc[id]
    local openType = PlayerFrame.OpenType.Self
    if openFunc then
        openFunc(SL, openType, data)
    end
end

-- 刷新内功顶部栏显示
function PlayerFrame.OnChangeTopShow()
    if PlayerFrame._NGShow then
        if SL:GetMetaValue("IS_LEARNED_INTERNAL") then
            GUI:setVisible(PlayerFrame._ui["topLayout"], true)
        else
            GUI:setVisible(PlayerFrame._ui["topLayout"], false)
        end
    end
end

function PlayerFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "PlayerFrame", PlayerFrame.ChangePage)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame", PlayerFrame.RefreshPlayerName)
    --学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "PlayerFrame", PlayerFrame.OnChangeTopShow)
end

function PlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "PlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "PlayerFrame")
end
