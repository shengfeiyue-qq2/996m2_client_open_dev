-- 玩家英雄合并 面板 外框
MergePlayerFrame = {}

MergePlayerFrame._ui = nil

-- 1人物; 2英雄
MergePlayerFrame._roleType = 1

-- 1基础; 2内功
MergePlayerFrame._showType = 1

-- 子界面配置
local ChildsUICfgs = {
    [1] = {
        [UIConst.LayerTable.PlayerEquip] = {
            Open = handler(UIOperator, UIOperator.OpenRoleEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleEquipUI)
        },
        [UIConst.LayerTable.PlayerBaseAtt] = {
            Open = handler(UIOperator, UIOperator.OpenRoleBaseAttUI), Close = handler(UIOperator, UIOperator.CloseRoleBaseAttUI)
        },
        [UIConst.LayerTable.PlayerExtraAtt] = {
            Open = handler(UIOperator, UIOperator.OpenRoleExtraAttUI), Close = handler(UIOperator, UIOperator.CloseRoleExtraAttUI)
        },
        [UIConst.LayerTable.PlayerSkill] = {
            Open = handler(UIOperator, UIOperator.OpenRoleSkillUI), Close = handler(UIOperator, UIOperator.CloseRoleSkillUI)
        },
        [UIConst.LayerTable.PlayerTitle] = {
            Open = handler(UIOperator, UIOperator.OpenRoleTitleUI),  Close = handler(UIOperator, UIOperator.CloseRoleTitleUI)
        },
        [UIConst.LayerTable.PlayerSuperEquip] = {
            Open = handler(UIOperator, UIOperator.OpenRoleSuperEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleSuperEquipUI)
        }
    },

    -- 内功
    [2] = {
        [UIConst.LayerTable.InternalState] = {
            Open = handler(UIOperator, UIOperator.OpenInternalStateUI), Close = handler(UIOperator, UIOperator.CloseInternalStateUI)
        },
        [UIConst.LayerTable.InternalSkill] = {
            Open = handler(UIOperator, UIOperator.OpenInternalSkillUI), Close = handler(UIOperator, UIOperator.CloseInternalSkillUI)
        },
        [UIConst.LayerTable.InternalMeridian] = {
            Open = handler(UIOperator, UIOperator.OpenInternalMerdianUI), Close = handler(UIOperator, UIOperator.CloseInternalMerdianUI)
        },
        [UIConst.LayerTable.InternalCombo] = {
            Open = handler(UIOperator, UIOperator.OpenInternalComboUI), Close = handler(UIOperator, UIOperator.CloseInternalComboUI)
        }
    }
}

-- 内功是否显示
local isShowNG = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1

function MergePlayerFrame.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.MergePlayerMainGUI, 0, 0, 0, 0, false, false, true, true)
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "merge_player/merge_layer")

    MergePlayerFrame._ui = GUI:ui_delegate(parent)
    if not MergePlayerFrame._ui then
        return false
    end

    -- 1人物; 2英雄
    MergePlayerFrame._roleType = data and data.roleType or 1

    -- 1基础; 2内功
    MergePlayerFrame._showType = data and data.type or  1

    MergePlayerFrame.typeCapture = data and data.typeCapture or nil

    local root = MergePlayerFrame._ui["Panel_1"]

    -- 适配
    GUI:setPosition(root, SL:GetValue("SCREEN_WIDTH") - 236, SL:GetValue("SCREEN_HEIGHT") / 2)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, root)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, root)

    -- 关闭
    GUI:addOnClickEvent(MergePlayerFrame._ui["ButtonClose"],function()
        GUI:Win_Close(parent)
    end)

    GUI:Win_SetCloseCB(parent, MergePlayerFrame.OnClose)

    -- 注册事件
    MergePlayerFrame.RegisterEvent()

    GUI:setTouchEnabled(MergePlayerFrame._ui.Panel_btnList, false)

    -- 刷新名字
    MergePlayerFrame.RefreshPlayerName()

    MergePlayerFrame.InitEvent()

    GUI:setEnabled(MergePlayerFrame._ui["Button_player"], MergePlayerFrame._roleType == 2)
    GUI:setEnabled(MergePlayerFrame._ui["Button_hero"],   MergePlayerFrame._roleType == 1)

    MergePlayerFrame.OnOpenPage(data and data.page or UIConst.LayerTable.PlayerEquip)
    
    MergePlayerFrame.UpdateTopLayout()

    MergePlayerFrame.UpdateTopLayoutShowState()
    
    -- 初始化页签
    MergePlayerFrame.InitPageChangeBtn()

    -- TXT 挂接
    SL:AttachTXTSUI({root = root, index = SLDefine.SUIComponentTable.PlayerMain})

    -- 截图节点
    MergePlayerFrame._screenshotRootNode = root
end

function MergePlayerFrame.InitEvent()
    local addClickEvent = function (layers)
        for pageID, _ in pairs(layers) do
            local button = MergePlayerFrame._ui["Button_"..pageID]
            if button then
                GUI:addOnClickEvent(button, function()
                    MergePlayerFrame.OnOpenPage(pageID)
                end)
            end
        end
    end

    -- 页签点击事件
    for k, layers in ipairs(ChildsUICfgs) do
        addClickEvent(layers)
    end

    GUI:addOnClickEvent(MergePlayerFrame._ui["base_btn"], MergePlayerFrame.OnChangeShowType)
    GUI:setTag(MergePlayerFrame._ui["base_btn"], 1)

    GUI:addOnClickEvent(MergePlayerFrame._ui["ng_btn"], MergePlayerFrame.OnChangeShowType)
    GUI:setTag(MergePlayerFrame._ui["ng_btn"], 2)
    
    -------------------------------------------------------------------------------------------------
    -- 人物
    GUI:addOnClickEvent(MergePlayerFrame._ui["Button_player"], MergePlayerFrame.OnChangeRoleType) 
    GUI:setTag(MergePlayerFrame._ui["Button_player"], 1)
    -- 英雄
    GUI:addOnClickEvent(MergePlayerFrame._ui["Button_hero"], MergePlayerFrame.OnChangeRoleType) 
    GUI:setTag(MergePlayerFrame._ui["Button_hero"], 2)
end

function MergePlayerFrame.OnChangeRoleType(widget)
    local roleType = GUI:getTag(widget)
    if MergePlayerFrame._roleType == roleType then
        return false
    end

    if roleType == 2 then
        if not SL:GetValue("HERO_IS_ACTIVE") then
            return SL:ShowSystemTips("英雄还未激活")
        end 

        if not SL:GetValue("HERO_IS_ALIVE")  then
            return SL:ShowSystemTips("英雄还未召唤")
        end
    end

    local lastRoleType = MergePlayerFrame._roleType

    MergePlayerFrame._roleType = roleType

    MergePlayerFrame.RefreshPlayerName()

    GUI:setEnabled(MergePlayerFrame._ui["Button_player"], roleType ~= 1)
    GUI:setEnabled(MergePlayerFrame._ui["Button_hero"],   roleType == 1)

    MergePlayerFrame.OnChangeShowType(MergePlayerFrame._ui["base_btn"], lastRoleType)
    
    MergePlayerFrame.OnOpenPage(UIConst.LayerTable.PlayerEquip, lastRoleType)
end

function MergePlayerFrame.OnChangeShowType(widget, lastRoleType)
    local showType = GUI:getTag(widget)
    if MergePlayerFrame._showType == showType then
        return false
    end
    local lastShowType = MergePlayerFrame._showType
    MergePlayerFrame._showType = showType

    MergePlayerFrame.UpdateTopLayout()
    MergePlayerFrame.InitPageChangeBtn()

    local pageID = MergePlayerFrame._showType == 1 and UIConst.LayerTable.PlayerEquip or UIConst.LayerTable.InternalState
    MergePlayerFrame.OnOpenPage(pageID, lastRoleType, lastShowType)
end

-- 打开子页签
function MergePlayerFrame.OnOpenPage(pageID, lastRoleType, lastShowType)
    if not lastRoleType and MergePlayerFrame._pageID == pageID then
        return false
    end

    MergePlayerFrame.OperateChildUI(false, lastRoleType, lastShowType)

    MergePlayerFrame._pageID = pageID

    MergePlayerFrame.RefreshBtnState()

    -- 移除上个
    GUI:removeAllChildren(MergePlayerFrame._ui["Node_panel"])

    -- 加载Layer
    MergePlayerFrame.OperateChildUI(true)
end

function MergePlayerFrame.OperateChildUI(open, lastRoleType, lastShowType)
    local uiCfg = nil
    if not open and lastShowType then
        uiCfg = (MergePlayerFrame._pageID and ChildsUICfgs[lastShowType]) and ChildsUICfgs[lastShowType][MergePlayerFrame._pageID]
    else
        uiCfg = (MergePlayerFrame._pageID and ChildsUICfgs[MergePlayerFrame._showType]) and ChildsUICfgs[MergePlayerFrame._showType][MergePlayerFrame._pageID]
    end
    if not uiCfg then
        return false
    end

    if open then
        uiCfg.Open(MergePlayerFrame._roleType, MergePlayerFrame._ui["Node_panel"])
    else
        uiCfg.Close(lastRoleType or MergePlayerFrame._roleType)
    end
end

function MergePlayerFrame.UpdateTopLayout()
    if not isShowNG then
        return false
    end

    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(MergePlayerFrame._ui[name], MergePlayerFrame._showType ~= i)
        GUI:setLocalZOrder(MergePlayerFrame._ui[name], MergePlayerFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(MergePlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, MergePlayerFrame._showType == i and "#f8e6c6" or "#807256")
    end
end

function MergePlayerFrame.InitPageChangeBtn()
    local showType    = MergePlayerFrame._showType
    local btnList     = MergePlayerFrame._ui["Panel_btnList"]
    local btnListNG   = MergePlayerFrame._ui["Panel_btnList_ng"]

    if isShowNG then 
        GUI:setVisible(btnList, showType == 1)
        GUI:setVisible(btnListNG, showType == 2)
    else
        GUI:setVisible(btnList, true)
        GUI:setVisible(btnListNG, false)
    end
end

function MergePlayerFrame.RefreshBtnState()
    local setChild = function (child)
        local isSelected = GUI:getName(child) == ("Button_" .. MergePlayerFrame._pageID)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end

    local list = (isShowNG and MergePlayerFrame._showType == 2) and MergePlayerFrame._ui["Panel_btnList_ng"] or MergePlayerFrame._ui["Panel_btnList"]
    local childs = GUI:getChildren(list)
    for _, child in ipairs(childs) do
        setChild(child)
    end

    local btnListLeft = MergePlayerFrame._ui["Panel_btnList_left"]
    if btnListLeft then
        for _, child in ipairs(GUI:getChildren(btnListLeft)) do
            setChild(child)
        end
    end
end

function MergePlayerFrame.RefreshPlayerName()
    local setColor = function (color)
        if color and color > 0 then
            GUI:Text_setTextColor(MergePlayerFrame._ui["Text_Name"], SL:GetHexColorByStyleId(color))
        end
    end

    if MergePlayerFrame._roleType == 2 then
        local name = SL:GetValue("H.USERNAME")
        GUI:Text_setString(MergePlayerFrame._ui["Text_Name"], name)

        local color = SL:GetValue("HERO_NAME_COLOR")
        setColor(color)
    else
        local name = SL:GetValue("USER_NAME")
        GUI:Text_setString(MergePlayerFrame._ui["Text_Name"], name)

        local color = SL:GetValue("USER_NAME_COLOR")
        setColor(color)
    end
end

-- 刷新内功顶部栏显示
function MergePlayerFrame.UpdateTopLayoutShowState()
    local isVisible = false
    if isShowNG then
        local learned = MergePlayerFrame._roleType == 1 and SL:GetValue("IS_LEARNED_INTERNAL") or SL:GetValue("H.IS_LEARNED_INTERNAL")
        if learned then
            isVisible = true
        end
    end
    GUI:setVisible(MergePlayerFrame._ui["topLayout"], isVisible)
end

function MergePlayerFrame.OnClose()
    SL:UnAttachTXTSUI({index = SLDefine.SUIComponentTable.PlayerMain})
    MergePlayerFrame.OperateChildUI(false)
    MergePlayerFrame.UnRegisterEvent()
    UIOperator:CloseItemTips()
end

function MergePlayerFrame.RegisterEvent()
    -- 刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH,    "MergePlayerFrame", MergePlayerFrame.RefreshPlayerName)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH,      "MergePlayerFrame", MergePlayerFrame.RefreshPlayerName)

    -- 学习内功
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL,      "MergePlayerFrame", MergePlayerFrame.UpdateTopLayoutShowState)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL,        "MergePlayerFrame", MergePlayerFrame.UpdateTopLayoutShowState)
end

function MergePlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH,  "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH,    "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL,    "MergePlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL,      "MergePlayerFrame")
end

MergePlayerFrame.main()
