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

function MergePlayerFrame.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "merge_player/merge_layer")
    MergePlayerFrame._ui = GUI:ui_delegate(parent)
    MergePlayerFrame._parent = parent
    MergePlayerFrame._pageid = data and data.extent or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP

    MergePlayerFrame._lastPageid = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    MergePlayerFrame._showtype = data and data.showtype or 1 --1人物 2英雄
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
        GUI:addOnClickEvent(closeButton,function()
            if MergePlayerFrame._showtype == 1 then 
                SL:CloseMyPlayerUI()
            else
                SL:CloseMyPlayerHeroUI()
            end
        end)
    end
    GUI:setEnabled(MergePlayerFrame._ui.Button_player, MergePlayerFrame._showtype == 2)
    GUI:setEnabled(MergePlayerFrame._ui.Button_hero, MergePlayerFrame._showtype == 1)

    --人物
    GUI:addOnClickEvent(MergePlayerFrame._ui.Button_player,function()
        GUI:setEnabled(MergePlayerFrame._ui.Button_player,false)
        GUI:setEnabled(MergePlayerFrame._ui.Button_hero,true)
        MergePlayerFrame.OpenPage(MergePlayerFrame._pageid, {pageId = MergePlayerFrame._pageid}, 1)
    end) 

    --英雄
    GUI:addOnClickEvent(MergePlayerFrame._ui.Button_hero,function()
        if not SL:GetMetaValue("HERO_IS_ACTIVE") then
            SL:ShowSystemTips("英雄还未激活")
            return 
        end 
        if not SL:GetMetaValue("HERO_IS_ALIVE")  then
            SL:ShowSystemTips("英雄还未召唤")
            return 
        end
        GUI:setEnabled(MergePlayerFrame._ui.Button_hero,false)
        GUI:setEnabled(MergePlayerFrame._ui.Button_player,true)
        MergePlayerFrame.OpenPage(MergePlayerFrame._pageid, {pageId = MergePlayerFrame._pageid}, 2)
    end) 

    -- 注册事件
    MergePlayerFrame.RegisterEvent()

    GUI:setTouchEnabled(MergePlayerFrame._ui.Panel_btnList, false)

    -- 刷新名字
    MergePlayerFrame.RefreshPlayerName()
    
    -- 初始化页签
    MergePlayerFrame.InitPageChangeBtn()
    MergePlayerFrame.OpenPage(MergePlayerFrame._pageid, {init = true, pageId = MergePlayerFrame._pageid})
end

function MergePlayerFrame.InitPageChangeBtn()
    local btnList = MergePlayerFrame._ui.Panel_btnList
    for i, pageId in ipairs(MergePlayerFrame._pageIDs) do
        local configId = pageId + 100
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
        SL:SetColorStyle(Text_Name, color)
    end
end

function MergePlayerFrame.ChangePage_role(data)
    MergePlayerFrame.ChangePage(data,1)
end

function MergePlayerFrame.ChangePage_hero(data, showtype)
    MergePlayerFrame.ChangePage(data,2)
end
-- 切页
function MergePlayerFrame.ChangePage(data, showtype)
    MergePlayerFrame._lastPageid = MergePlayerFrame._pageid
    MergePlayerFrame._pageid = data.index or SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP
    local lastshowtype = MergePlayerFrame._showtype
    MergePlayerFrame._showtype = showtype
    local btnList = MergePlayerFrame._ui.Panel_btnList

    local btnLastPage = GUI:getChildByName(btnList, "Button_" .. MergePlayerFrame._lastPageid)
    GUI:setLocalZOrder(btnLastPage, 0)
    GUI:setTouchEnabled(btnLastPage, true)
    GUI:Button_setBright(btnLastPage, true)
    local textLastName = GUI:getChildByName(btnLastPage, "Text_name")
    GUI:Text_setTextColor(textLastName, "#807256")

    local btnNowPage = GUI:getChildByName(btnList, "Button_" .. MergePlayerFrame._pageid)
    GUI:setLocalZOrder(btnNowPage, 1)
    GUI:setTouchEnabled(btnNowPage, false)
    GUI:Button_setBright(btnNowPage, false)
    local textNowName = GUI:getChildByName(btnNowPage, "Text_name")
    GUI:Text_setTextColor(textNowName, "#f8e6c6")

    if not data.init then
        if lastshowtype ~= MergePlayerFrame._showtype or  MergePlayerFrame._lastPageid ~= MergePlayerFrame._pageid then
            if lastshowtype == 1 then
                SL:CloseMyPlayerPageUI(MergePlayerFrame._lastPageid)
            else 
                SL:CloseMyPlayerHeroPageUI(MergePlayerFrame._lastPageid)
            end
            if lastshowtype ~= MergePlayerFrame._showtype then
                MergePlayerFrame.RefreshPlayerName()
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
        SL:CloseMyPlayerPageUI(MergePlayerFrame._pageid)
    else 
        SL:CloseMyPlayerHeroPageUI(MergePlayerFrame._pageid)
    end
end

-- 打开子页签
function MergePlayerFrame.OpenPage(LayerID, data, showtype)
    local showtype = showtype or MergePlayerFrame._showtype
    local openFunc = MergePlayerFrame.OpenFunc[LayerID]
    local openType = showtype == 1 and  MergePlayerFrame.OpenType.Self or MergePlayerFrame.OpenType.Hero
    if openFunc then
        openFunc(SL, openType, data)
    end
end

function MergePlayerFrame.RegisterEvent()
    --添加子页
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "MergePlayerFrame", MergePlayerFrame.ChangePage_role)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "MergePlayerFrame", MergePlayerFrame.ChangePage_hero)
    --刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "MergePlayerFrame", MergePlayerFrame.RefreshPlayerName_role)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "MergePlayerFrame", MergePlayerFrame.RefreshPlayerName_hero)
end

function MergePlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_PAGE_ADD, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_PAGE_ADD, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "MergePlayerFrame")
end
