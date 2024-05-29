-- 查看他人英雄 外框
HeroFrame_Look = {}
HeroFrame_Look._ui = nil

-- 页签ID
HeroFrame_Look._pageIDs = {
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP,
    SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BUFF,
}
-- 打开页签
HeroFrame_Look.OpenFunc = {
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP]       =  SL.OpenPlayerEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_TITLE]       =  SL.OpenPlayerTitleUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP] =  SL.OpenPlayerSuperEquipUI,
    [SLDefine.PlayerPage.MAIN_PLAYER_LAYER_BUFF]        =  SL.OpenPlayerBuffUI
}
HeroFrame_Look.OpenType = {
    OtherHero = 12 --查看他人英雄
}

function HeroFrame_Look.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero_look/hero_layer_win32")
    HeroFrame_Look._ui = GUI:ui_delegate(parent)
    HeroFrame_Look._parent = parent
    HeroFrame_Look._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    HeroFrame_Look._isFast = data and data.isFast or false -- 快捷键打开
    HeroFrame_Look._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    if not HeroFrame_Look._ui then
        return false
    end
    local winHeight = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(HeroFrame_Look._ui.Panel_1, winHeight - 470)
    -- 拖动的控件
    GUI:Win_SetDrag(parent, HeroFrame_Look._ui.Panel_1)
    -- 名字添加触摸  点击私聊
    GUI:setTouchEnabled(HeroFrame_Look._ui.Text_Name, true)
    -- 关闭
    local closeButton = HeroFrame_Look._ui.ButtonClose
    if closeButton then
        GUI:addOnClickEvent(closeButton,function()
            SL:CloseOtherPlayerHeroUI()
        end)
    end
    -- 注册事件
    HeroFrame_Look.RegisterEvent()

    GUI:setTouchEnabled(HeroFrame_Look._ui.Panel_btnList, false)
    -- 刷新名字
    HeroFrame_Look.RefreshPlayerName()
    -- 初始化页签
    HeroFrame_Look.InitPageChangeBtn()
    HeroFrame_Look.OpenPage(HeroFrame_Look._pageid, {init = true, pageId = HeroFrame_Look._pageid})
end

function HeroFrame_Look.InitPageChangeBtn()
    local btnList = HeroFrame_Look._ui.Panel_btnList
    for i, pageId in ipairs(HeroFrame_Look._pageIDs) do
        local configId = pageId + 100
        if pageId == SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP then
            configId = 1000 + SLDefine.PlayerPage.MAIN_PLAYER_LAYER_SUPER_EQUIP
        end
        local btnName = "Button_" .. pageId
        local panelBtn = GUI:getChildByName(btnList, btnName)
        if panelBtn then
            local textName = GUI:getChildByName(panelBtn, "Text_name")
            GUI:setLocalZOrder(panelBtn, HeroFrame_Look._pageid == pageId and 1 or 0)
            GUI:addOnClickEvent(
                panelBtn,
                function()
                    if not SL:CheckMenuLayerConditionByID(configId) then
                        SL:ShowSystemTips("条件不满足!")
                        return 
                    end
                    if HeroFrame_Look._pageid == pageId then
                        return
                    end
                    HeroFrame_Look.OpenPage(pageId, {pageId = pageId})
                end
            )
        end
    end
end

function HeroFrame_Look.RefreshPlayerName()
    local Text_Name = HeroFrame_Look._ui.Text_Name
    local Name = SL:GetMetaValue("LOOK_USER_NAME")
    local namestrs = string.split(Name,"\\")
    local name = namestrs[1] or ""
    GUI:Text_setString(Text_Name, name)
    local color = SL:GetMetaValue("LOOK_USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

-- 切页
function HeroFrame_Look.ChangePage(data)
    HeroFrame_Look._lastPageid = HeroFrame_Look._pageid
    HeroFrame_Look._pageid = data.index or 1

    local btnList = HeroFrame_Look._ui.Panel_btnList

    local btnLastPage = GUI:getChildByName(btnList, "Button_" .. HeroFrame_Look._lastPageid)
    GUI:setLocalZOrder(btnLastPage, 0)
    GUI:setTouchEnabled(btnLastPage, true)
    GUI:Button_setBright(btnLastPage, true)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, "#807256")

    local btnNowPage = GUI:getChildByName(btnList, "Button_" .. HeroFrame_Look._pageid)
    GUI:setLocalZOrder(btnNowPage, 1)
    GUI:setTouchEnabled(btnNowPage, false)
    GUI:Button_setBright(btnNowPage, false)
    local textNowName = GUI:getChildByName(btnNowPage, "Text_name")
    GUI:Text_setTextColor(textNowName, "#e6e7a7")

    if not data.init then
        SL:CloseOtherPlayerHeroPageUI(HeroFrame_Look._lastPageid)
    end

    HeroFrame_Look.CreateLayerPanelChild(data.child)
end

-- 添加子页面到外框
function HeroFrame_Look.CreateLayerPanelChild(panel)
    if panel then
        GUI:addChild(HeroFrame_Look._ui.Node_panel, panel)
    end
end

-- 切换子页面
function HeroFrame_Look.ChangeOpenedPage(id, data)
    HeroFrame_Look.OpenPage(id)
end

-- 关闭外框
function HeroFrame_Look.OnCloseMainLayer()
    HeroFrame_Look.UnRegisterEvent()
    --关闭子页
    SL:CloseOtherPlayerHeroPageUI(HeroFrame_Look._pageid)
end

-- 打开子页签
function HeroFrame_Look.OpenPage(LayerID, data)
    local openFunc = HeroFrame_Look.OpenFunc[LayerID]
    local openType = HeroFrame_Look.OpenType.OtherHero
    if openFunc then
        openFunc(SL, openType, data)
    end
end

function HeroFrame_Look.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOOK_FRAME_PAGE_ADD, "HeroFrame_Look", HeroFrame_Look.ChangePage)
end

function HeroFrame_Look.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_LOOK_FRAME_PAGE_ADD, "HeroFrame_Look")
end
