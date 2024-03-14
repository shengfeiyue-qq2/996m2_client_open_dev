-- 英雄面板 外框
HeroFrame = {}
HeroFrame._ui = nil

-- 页签ID
HeroFrame._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
}
-- 打开页签
HeroFrame.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI]  =  SL.OpenPlayerBaseAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO] =  SL.OpenPlayerExtraAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL]       =  SL.OpenPlayerSkillUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI
}
HeroFrame.OpenType = {
    Hero = 2 --英雄
}

-- 内功
HeroFrame._pageNGIDs = {1, 2, 3, 4}
-- 打开页签 内功
HeroFrame.OpenNGFunc = {
    [1]         =  SL.OpenInternalStateUI,
    [2]         =  SL.OpenInternalSkillUI,
    [3]         =  SL.OpenInternalMerdianUI,
    [4]         =  SL.OpenInternalComboUI,
}

HeroFrame._showType = 1    -- 1 基础 2 内功

function HeroFrame.main(data)
    local parent = GUI:Attach_Parent()
    HeroFrame._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1
    if HeroFrame._NGShow then
        GUI:LoadExport(parent, "hero/hero_layer_ng_win32")
    else
        GUI:LoadExport(parent, "hero/hero_layer_win32")
    end
    HeroFrame._ui = GUI:ui_delegate(parent)
    HeroFrame._parent = parent
    HeroFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    HeroFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    HeroFrame._showType = data and data.type or 1
    if not HeroFrame._ui then
        return false
    end
    local winHeight = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(HeroFrame._ui.Panel_1, winHeight - 470)
    -- 拖动的控件
    GUI:Win_SetDrag(parent, HeroFrame._ui.Panel_1)
    -- 名字添加触摸  点击私聊
    GUI:setTouchEnabled(HeroFrame._ui.Text_Name, true)
    -- 关闭
    local closeButton = HeroFrame._ui.ButtonClose
    if closeButton then
        GUI:addOnClickEvent(closeButton,function()
            SL:CloseMyPlayerHeroUI()
        end)
    end
    -- 注册事件
    HeroFrame.RegisterEvent()

    GUI:setTouchEnabled(HeroFrame._ui.Panel_btnList, false)

    -- 刷新名字
    HeroFrame.RefreshPlayerName()

    -- 切换内功显示
    HeroFrame._initBtn = {}
    if HeroFrame._NGShow then
        HeroFrame.InitTopTypePanel()
        HeroFrame.OnChangeTopShow()
    end

    -- 初始化页签
    HeroFrame.InitPageChangeBtn()
    HeroFrame.OpenPage(HeroFrame._pageid, {init = true, pageId = HeroFrame._pageid})
end

function HeroFrame.InitTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(HeroFrame._ui[name], HeroFrame._showType ~= i)
        GUI:setLocalZOrder(HeroFrame._ui[name], HeroFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(HeroFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, HeroFrame._showType == i and "#f8e6c6" or "#807256")
        GUI:addOnClickEvent(HeroFrame._ui[name], function()
            if HeroFrame._showType == i then
                return
            end
            HeroFrame.ChangeShowType(i)
            HeroFrame.OpenPage(1, {pageId = 1})
        end)
    end
end

function HeroFrame.RefreshTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(HeroFrame._ui[name], HeroFrame._showType ~= i)
        GUI:setLocalZOrder(HeroFrame._ui[name], HeroFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(HeroFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, HeroFrame._showType == i and "#f8e6c6" or "#807256")
    end
end

function HeroFrame.InitPageChangeBtn()
    local btnList = HeroFrame._ui.Panel_btnList
    if HeroFrame._NGShow then 
        btnList = HeroFrame._showType == 1 and HeroFrame._ui.Panel_btnList or HeroFrame._ui.Panel_btnList_ng
        GUI:setVisible(HeroFrame._ui.Panel_btnList, HeroFrame._showType == 1)
        GUI:setVisible(HeroFrame._ui.Panel_btnList_ng, HeroFrame._showType == 2)
    end
    local menu_groupID = HeroFrame._showType == 1 and 1 or 7
    local pageIDList = HeroFrame._showType == 1 and HeroFrame._pageIDs or HeroFrame._pageNGIDs
    if not HeroFrame._initBtn[HeroFrame._showType] then
        for i, pageId in ipairs(pageIDList) do
            local configId = pageId + (100 * menu_groupID)
            if pageId == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP then
                configId = 1000 + SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
            end
            local btnName = "Button_" .. pageId
            local panelBtn = GUI:getChildByName(btnList, btnName)
            if panelBtn then
                local textName = GUI:getChildByName(panelBtn, "Text_name")
                GUI:setLocalZOrder(panelBtn, HeroFrame._pageid == pageId and 1 or 0)
                GUI:addOnClickEvent(
                    panelBtn,
                    function()
                        if not SL:CheckMenuLayerConditionByID(configId) then
                            SL:ShowSystemTips("条件不满足!")
                            return 
                        end
                        if HeroFrame._pageid == pageId then
                            return
                        end
                        HeroFrame.OpenPage(pageId, {pageId = pageId})
                    end
                )
            end
        end
        HeroFrame._initBtn[HeroFrame._showType] = true
    end
end

function HeroFrame.ChangeShowType(i)
    if HeroFrame._showType == i then
        return
    end
    HeroFrame._lastType = HeroFrame._showType
    HeroFrame._showType = i
    HeroFrame.RefreshTopTypePanel()
    HeroFrame.InitPageChangeBtn()
end

function HeroFrame.RefreshPlayerName()
    local Text_Name = HeroFrame._ui.Text_Name
    local Name = SL:GetMetaValue("H.USERNAME")
    local namestrs = string.split(Name,"\\")
    local name = namestrs[1] or ""
    GUI:Text_setString(Text_Name, name)
    local color = SL:GetMetaValue("HERO_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

function HeroFrame.RefreshBtnState()
    local btnList = HeroFrame._ui.Panel_btnList
    if HeroFrame._NGShow then 
        btnList = HeroFrame._showType == 1 and HeroFrame._ui.Panel_btnList or HeroFrame._ui.Panel_btnList_ng
    end
    for _, child in ipairs(GUI:getChildren(btnList)) do
        local isSelected = GUI:getName(child) == ("Button_" .. HeroFrame._pageid)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end
end

-- 切页
function HeroFrame.ChangePage(data)
    HeroFrame._lastPageid = HeroFrame._pageid
    HeroFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    HeroFrame.RefreshBtnState()

    if HeroFrame._lastType == 1 then
        SL:CloseMyPlayerHeroPageUI(HeroFrame._lastPageid)
        HeroFrame._lastType = false
    elseif HeroFrame._lastType == 2 then
        SL:CloseMyHeroInternalPageUI(HeroFrame._lastPageid)
        HeroFrame._lastType = false
    elseif not data.init then
        if data.isInternal then
            SL:CloseMyHeroInternalPageUI(HeroFrame._lastPageid)
        else
            SL:CloseMyPlayerHeroPageUI(HeroFrame._lastPageid)
        end
    end

    HeroFrame.CreateLayerPanelChild(data.child)
end

-- 添加子页面到外框
function HeroFrame.CreateLayerPanelChild(panel)
    if panel then
        GUI:addChild(HeroFrame._ui.Node_panel, panel)
    end
end

-- 切换子页面
function HeroFrame.ChangeOpenedPage(id, data)
    HeroFrame.OpenPage(id)
end

-- 关闭外框
function HeroFrame.OnCloseMainLayer()
    HeroFrame.UnRegisterEvent()
    --关闭子页
    if HeroFrame._showType == 1 then
        SL:CloseMyPlayerHeroPageUI(HeroFrame._pageid)
    else
        SL:CloseMyHeroInternalPageUI(HeroFrame._pageid)
    end
end

-- 打开子页签
function HeroFrame.OpenPage(id, data)
    local openFunc = HeroFrame._showType == 1 and HeroFrame.OpenFunc[id] or HeroFrame.OpenNGFunc[id]
    local openType = HeroFrame.OpenType.Hero
    if openFunc then
        openFunc(SL, openType, data)
    end
end

-- 刷新内功顶部栏显示
function HeroFrame.OnChangeTopShow()
    if HeroFrame._NGShow then
        if SL:GetMetaValue("H.IS_LEARNED_INTERNAL") then
            GUI:setVisible(HeroFrame._ui["topLayout"], true)
        else
            GUI:setVisible(HeroFrame._ui["topLayout"], false)
        end
    end
end

function HeroFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "HeroFrame", HeroFrame.ChangePage)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "HeroFrame", HeroFrame.RefreshPlayerName)
    --学习内功
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL, "HeroFrame", HeroFrame.OnChangeTopShow)
end

function HeroFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "HeroFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "HeroFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL, "HeroFrame")
end
