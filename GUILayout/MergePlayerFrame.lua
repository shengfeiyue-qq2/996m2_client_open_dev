-- 玩家英雄合并 面板 外框
MergePlayerFrame = {}
MergePlayerFrame._ui = nil

-- 页签ID
MergePlayerFrame._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
}
-- 打开页签
MergePlayerFrame.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BASE_ATTRI]  =  SL.OpenPlayerBaseAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EXTRA_ATTRO] =  SL.OpenPlayerExtraAttrUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SKILL]       =  SL.OpenPlayerSkillUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI
}
MergePlayerFrame.OpenType = {
    Self = 1, --自己
    Hero = 2, --英雄
}

-- 内功
MergePlayerFrame._pageNGIDs = {1, 2, 3, 4}
-- 打开页签 内功
MergePlayerFrame.OpenNGFunc = {
    [1]         =  SL.OpenInternalStateUI,
    [2]         =  SL.OpenInternalSkillUI,
    [3]         =  SL.OpenInternalMerdianUI,
    [4]         =  SL.OpenInternalComboUI,
}

MergePlayerFrame._pageWay = 1 -- 1 基础 2 内功

function MergePlayerFrame.main(data)
    local parent = GUI:Attach_Parent()
    MergePlayerFrame._NGShow = tonumber(SL:GetMetaValue("GAME_DATA", "OpenNGUI")) == 1
    if MergePlayerFrame._NGShow then
        GUI:LoadExport(parent, "merge_player/merge_layer_ng")
    else
        GUI:LoadExport(parent, "merge_player/merge_layer")
    end
    MergePlayerFrame._ui = GUI:ui_delegate(parent)
    MergePlayerFrame._parent = parent
    MergePlayerFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    MergePlayerFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    MergePlayerFrame._showtype = data and data.showtype or 1 --1人物 2英雄
    MergePlayerFrame._pageWay = data and data.type or 1
    if not MergePlayerFrame._ui then
        return false
    end

    -- 适配
    GUI:setPositionY(MergePlayerFrame._ui.Panel_1, SL:GetMetaValue("SCREEN_HEIGHT") / 2)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, MergePlayerFrame._ui.Panel_1)

    -- 名字添加触摸  点击私聊
    GUI:setTouchEnabled(MergePlayerFrame._ui.Text_Name, true)

    -- 关闭
    local closeButton = MergePlayerFrame._ui.ButtonClose
    if closeButton then
        GUI:addOnClickEvent(closeButton, function()
            if MergePlayerFrame._showtype == 1 then 
                SL:CloseMyPlayerUI()
            else
                SL:CloseMyPlayerHeroUI()
            end
        end)
    end
    GUI:setEnabled(MergePlayerFrame._ui.Button_player, MergePlayerFrame._showtype == 2)
    GUI:setEnabled(MergePlayerFrame._ui.Button_hero, MergePlayerFrame._showtype == 1)

    local function setPageWayNormal()
        MergePlayerFrame._lastWay = MergePlayerFrame._pageWay
        MergePlayerFrame._pageWay = 1
        MergePlayerFrame.RefreshTopTypePanel()
        MergePlayerFrame.InitPageChangeBtn()
    end

    --人物
    GUI:addOnClickEvent(MergePlayerFrame._ui.Button_player, function()
        if MergePlayerFrame._showtype == 1 then 
            return
        end
        GUI:setEnabled(MergePlayerFrame._ui.Button_player, false)
        GUI:setEnabled(MergePlayerFrame._ui.Button_hero, true)
        setPageWayNormal()
        MergePlayerFrame.OpenPage(MergePlayerFrame._pageid, {pageId = MergePlayerFrame._pageid}, 1)
    end) 

    --英雄
    GUI:addOnClickEvent(MergePlayerFrame._ui.Button_hero, function()
        if MergePlayerFrame._showtype == 2 then 
            return
        end
        if not SL:GetMetaValue("HERO_IS_ACTIVE") then
            SL:ShowSystemTips("英雄还未激活")
            return 
        end 
        if not SL:GetMetaValue("HERO_IS_ALIVE")  then
            SL:ShowSystemTips("英雄还未召唤")
            return 
        end
        GUI:setEnabled(MergePlayerFrame._ui.Button_hero, false)
        GUI:setEnabled(MergePlayerFrame._ui.Button_player, true)
        setPageWayNormal()
        MergePlayerFrame.OpenPage(MergePlayerFrame._pageid, {pageId = MergePlayerFrame._pageid}, 2)
    end) 

    -- 注册事件
    MergePlayerFrame.RegisterEvent()

    GUI:setTouchEnabled(MergePlayerFrame._ui.Panel_btnList, false)

    -- 刷新名字
    MergePlayerFrame.RefreshPlayerName()

    -- 切换内功显示
    MergePlayerFrame._initBtn = {}
    if MergePlayerFrame._NGShow then
        MergePlayerFrame.InitTopTypePanel()
        MergePlayerFrame.OnChangeTopShow()
    end
    
    -- 初始化页签
    MergePlayerFrame.InitPageChangeBtn()
    MergePlayerFrame.OpenPage(MergePlayerFrame._pageid, {init = true, pageId = MergePlayerFrame._pageid})
end

function MergePlayerFrame.InitTopTypePanel()
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(MergePlayerFrame._ui[name], MergePlayerFrame._pageWay ~= i)
        GUI:setLocalZOrder(MergePlayerFrame._ui[name], MergePlayerFrame._pageWay == i and 1 or 0)
        local nameText = GUI:getChildByName(MergePlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, MergePlayerFrame._pageWay == i and "#f8e6c6" or "#807256")
        GUI:addOnClickEvent(MergePlayerFrame._ui[name], function()
            MergePlayerFrame.ChangePageWay(i)
            MergePlayerFrame.OpenPage(1, {pageId = 1})
        end)
    end
end

function MergePlayerFrame.RefreshTopTypePanel()
    if not MergePlayerFrame._NGShow then
        return
    end
    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(MergePlayerFrame._ui[name], MergePlayerFrame._pageWay ~= i)
        GUI:setLocalZOrder(MergePlayerFrame._ui[name], MergePlayerFrame._pageWay == i and 1 or 0)
        local nameText = GUI:getChildByName(MergePlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, MergePlayerFrame._pageWay == i and "#f8e6c6" or "#807256")
    end
end

function MergePlayerFrame.InitPageChangeBtn()
    local btnList = MergePlayerFrame._ui.Panel_btnList
    if MergePlayerFrame._NGShow then 
        btnList = MergePlayerFrame._pageWay == 1 and MergePlayerFrame._ui.Panel_btnList or MergePlayerFrame._ui.Panel_btnList_ng
        GUI:setVisible(MergePlayerFrame._ui.Panel_btnList, MergePlayerFrame._pageWay == 1)
        GUI:setVisible(MergePlayerFrame._ui.Panel_btnList_ng, MergePlayerFrame._pageWay == 2)
    end
    local menu_groupID = MergePlayerFrame._pageWay == 1 and 1 or 7
    local pageIDList = MergePlayerFrame._pageWay == 1 and MergePlayerFrame._pageIDs or MergePlayerFrame._pageNGIDs
    if not MergePlayerFrame._initBtn[MergePlayerFrame._pageWay] then
        for i, pageId in ipairs(pageIDList) do
            local configId = pageId + (100 * menu_groupID)
            local btnName = "Button_" .. pageId
            local panelBtn = GUI:getChildByName(btnList, btnName)
            if panelBtn then
                local textName = GUI:getChildByName(panelBtn, "Text_name")
                GUI:setLocalZOrder(panelBtn, MergePlayerFrame._pageid == pageId and 1 or 0)
                GUI:addOnClickEvent(
                    panelBtn,
                    function()
                        if not SL:CheckMenuLayerConditionByID(configId) then
                            SL:ShowSystemTips("条件不满足!")
                            return 
                        end
                        if MergePlayerFrame._pageid == pageId then
                            return
                        end
                        MergePlayerFrame.OpenPage(pageId, {pageId = pageId})
                    end
                )
            end
        end
        MergePlayerFrame._initBtn[MergePlayerFrame._pageWay] = true
    end
end

function MergePlayerFrame.ChangePageWay(i)
    if MergePlayerFrame._pageWay == i then
        return
    end
    MergePlayerFrame._lastWay = MergePlayerFrame._pageWay
    MergePlayerFrame._pageWay = i
    MergePlayerFrame.RefreshTopTypePanel()
    MergePlayerFrame.InitPageChangeBtn()
end

function MergePlayerFrame.ChangeShowType(i, pageWay, pageId)
    GUI:setEnabled(MergePlayerFrame._ui.Button_player, i ~= 1)
    GUI:setEnabled(MergePlayerFrame._ui.Button_hero, i == 1)

    MergePlayerFrame._lastWay = MergePlayerFrame._pageWay
    MergePlayerFrame._pageWay = pageWay
    MergePlayerFrame.RefreshTopTypePanel()
    MergePlayerFrame.InitPageChangeBtn()
    MergePlayerFrame.OpenPage(pageId, {pageId = pageId}, i)
end

function MergePlayerFrame.RefreshPlayerName_role()
    if MergePlayerFrame._showtype ~= 1 then 
        return 
    end
    MergePlayerFrame.RefreshPlayerName()
end

function MergePlayerFrame.RefreshPlayerName_hero()
    if MergePlayerFrame._showtype ~= 2 then 
        return 
    end
    MergePlayerFrame.RefreshPlayerName()
end

function MergePlayerFrame.RefreshPlayerName()
    local Text_Name = MergePlayerFrame._ui.Text_Name
    local Name = ""
    if MergePlayerFrame._showtype == 1 then 
        Name = SL:GetMetaValue("USER_NAME")
    else
        Name = SL:GetMetaValue("H.USERNAME")
        local namestrs = string.split(Name,"\\")
        Name = namestrs[1] or ""
    end
    GUI:Text_setString(Text_Name, Name)

    local color = 0
    if MergePlayerFrame._showtype == 1 then 
        color = SL:GetMetaValue("USER_NAME_COLOR")
    else
        color = SL:GetMetaValue("HERO_NAME_COLOR")
    end
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

function MergePlayerFrame.ChangePage_role(data)
    MergePlayerFrame.ChangePage(data, 1)
end

function MergePlayerFrame.ChangePage_hero(data)
    MergePlayerFrame.ChangePage(data, 2)
end

function MergePlayerFrame.RefreshBtnState()
    local btnList = MergePlayerFrame._ui.Panel_btnList
    if MergePlayerFrame._NGShow then 
        btnList = MergePlayerFrame._pageWay == 1 and MergePlayerFrame._ui.Panel_btnList or MergePlayerFrame._ui.Panel_btnList_ng
    end
    for _, child in ipairs(GUI:getChildren(btnList)) do
        local isSelected = GUI:getName(child) == ("Button_" .. MergePlayerFrame._pageid)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end
end

-- 切页
function MergePlayerFrame.ChangePage(data, showtype)
    MergePlayerFrame._lastPageid = MergePlayerFrame._pageid
    MergePlayerFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    local lastshowtype = MergePlayerFrame._showtype
    MergePlayerFrame._showtype = showtype
    if lastshowtype ~= showtype then
        MergePlayerFrame.OnChangeTopShow()
        MergePlayerFrame.RefreshPlayerName()
    end
   
    MergePlayerFrame.RefreshBtnState()

    if MergePlayerFrame._lastWay == 1 then
        if lastshowtype == 1 then
            SL:CloseMyPlayerPageUI(MergePlayerFrame._lastPageid)
        else
            SL:CloseMyPlayerHeroPageUI(MergePlayerFrame._lastPageid)
        end
        MergePlayerFrame._lastWay = false
    elseif MergePlayerFrame._lastWay == 2 then
        if lastshowtype == 1 then
            SL:CloseMyPlayerInternalPageUI(MergePlayerFrame._lastPageid)
        else
            SL:CloseMyHeroInternalPageUI(MergePlayerFrame._lastPageid)
        end
        MergePlayerFrame._lastWay = false
    elseif not data.init then
        if lastshowtype ~= MergePlayerFrame._showtype or MergePlayerFrame._lastPageid ~= MergePlayerFrame._pageid then
            if lastshowtype == 1 then
                if data.isInternal then
                    SL:CloseMyPlayerInternalPageUI(MergePlayerFrame._lastPageid)
                else
                    SL:CloseMyPlayerPageUI(MergePlayerFrame._lastPageid)
                end
            else 
                if data.isInternal then
                    SL:CloseMyHeroInternalPageUI(MergePlayerFrame._lastPageid)
                else
                    SL:CloseMyPlayerHeroPageUI(MergePlayerFrame._lastPageid)
                end
            end
        end
    end
    MergePlayerFrame.CreateLayerPanelChild(data.child)
end

-- 添加子页面到外框
function MergePlayerFrame.CreateLayerPanelChild(panel)
    if panel then
        GUI:addChild(MergePlayerFrame._ui.Node_panel, panel)
    end
end

-- 切换子页面
function MergePlayerFrame.ChangeOpenedPage(id, data)
    MergePlayerFrame.OpenPage(id)
end

-- 关闭外框
function MergePlayerFrame.OnCloseMainLayer()
    MergePlayerFrame.UnRegisterEvent()
    --关闭子页
    if MergePlayerFrame._showtype == 1 then
        if MergePlayerFrame._pageWay == 1 then
            SL:CloseMyPlayerPageUI(MergePlayerFrame._pageid)
        else
            SL:CloseMyPlayerInternalPageUI(MergePlayerFrame._pageid)
        end
    else 
        if MergePlayerFrame._pageWay == 1 then
            SL:CloseMyPlayerHeroPageUI(MergePlayerFrame._pageid)
        else
            SL:CloseMyHeroInternalPageUI(MergePlayerFrame._pageid)
        end
    end
end

-- 打开子页签
function MergePlayerFrame.OpenPage(LayerID, data, showtype)
    local showtype = showtype or MergePlayerFrame._showtype
    local openFunc = MergePlayerFrame._pageWay == 1 and MergePlayerFrame.OpenFunc[LayerID] or MergePlayerFrame.OpenNGFunc[LayerID]
    local openType = showtype == 1 and  MergePlayerFrame.OpenType.Self or MergePlayerFrame.OpenType.Hero
    if openFunc then
        openFunc(SL, openType, data)
    end
end

-- 刷新内功顶部栏显示
function MergePlayerFrame.OnChangeTopShow()
    if MergePlayerFrame._NGShow then
        local learned = MergePlayerFrame._showtype == 1 and SL:GetMetaValue("IS_LEARNED_INTERNAL") or SL:GetMetaValue("H.IS_LEARNED_INTERNAL")
        if learned then
            GUI:setVisible(MergePlayerFrame._ui["topLayout"], true)
        else
            GUI:setVisible(MergePlayerFrame._ui["topLayout"], false)
        end
    end
end

function MergePlayerFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "MergePlayerFrame", MergePlayerFrame.ChangePage_role)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "MergePlayerFrame", MergePlayerFrame.ChangePage_hero)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "MergePlayerFrame", MergePlayerFrame.RefreshPlayerName_role)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "MergePlayerFrame", MergePlayerFrame.RefreshPlayerName_hero)
    --学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "MergePlayerFrame", MergePlayerFrame.OnChangeTopShow)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL, "MergePlayerFrame", MergePlayerFrame.OnChangeTopShow)
end

function MergePlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL, "MergePlayerFrame")
end
