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

function HeroFrame.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_layer")
    HeroFrame._ui = GUI:ui_delegate(parent)
    HeroFrame._parent = parent
    HeroFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    HeroFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    if not HeroFrame._ui then
        return false
    end

    -- 适配
    GUI:setPositionY(HeroFrame._ui.Panel_1, SL:GetMetaValue("SCREEN_HEIGHT") / 2)

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

    -- 初始化页签
    HeroFrame.InitPageChangeBtn()
    HeroFrame.OpenPage(HeroFrame._pageid, {init = true, pageId = HeroFrame._pageid})
end

function HeroFrame.InitPageChangeBtn()
    local btnList = HeroFrame._ui.Panel_btnList
    for i, pageId in ipairs(HeroFrame._pageIDs) do
        local configId = pageId + 100
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
end

function HeroFrame.RefreshPlayerName()
    local Text_Name = HeroFrame._ui.Text_Name
    local Name = SL:GetMetaValue("H.USERNAME")
    local namestrs = string.split(Name,"\\")
    local name = namestrs[1] or ""
    GUI:Text_setString(Text_Name, name)
    local color = SL:GetMetaValue("HERO_NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(Text_Name, color)
    end
end

-- 切页
function HeroFrame.ChangePage(data)
    HeroFrame._lastPageid = HeroFrame._pageid
    HeroFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    local btnList = HeroFrame._ui.Panel_btnList

    local btnLastPage = GUI:getChildByName(btnList, "Button_" .. HeroFrame._lastPageid)
    GUI:setLocalZOrder(btnLastPage, 0)
    GUI:setTouchEnabled(btnLastPage, true)
    GUI:Button_setBright(btnLastPage, true)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, "#807256")

    local btnNowPage = GUI:getChildByName(btnList, "Button_" .. HeroFrame._pageid)
    GUI:setLocalZOrder(btnNowPage, 1)
    GUI:setTouchEnabled(btnNowPage, false)
    GUI:Button_setBright(btnNowPage, false)
    local textNowName = GUI:getChildByName(btnNowPage, "Text_name")
    GUI:Text_setTextColor(textNowName, "#f8e6c6")

    if not data.init then
        SL:CloseMyPlayerHeroPageUI(HeroFrame._lastPageid)
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
    SL:CloseMyPlayerHeroPageUI(HeroFrame._pageid)
end

-- 打开子页签
function HeroFrame.OpenPage(LayerID, data)
    local openFunc = HeroFrame.OpenFunc[LayerID]
    local openType = HeroFrame.OpenType.Hero
    if openFunc then
        openFunc(SL, openType, data)
    end
end

function HeroFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "HeroFrame", HeroFrame.ChangePage)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "HeroFrame", HeroFrame.RefreshPlayerName)
end

function HeroFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "HeroFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "HeroFrame")
end
