-- 玩家面板 外框
HeroFrame = {}

HeroFrame._ui = nil

-- 1 基础 2 内功
HeroFrame._showType = 1

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

local roleUIType = GUIDefine.RoleUIType.HERO

-- 内功是否显示
local isShowNG = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1

local isPC = SL:GetValue("IS_PC_OPER_MODE")

local path = isPC and "res/private/player_main_layer_ui/player_main_layer_ui_win32/" or "res/private/player_main_layer_ui/player_main_layer_ui_mobile/"

function HeroFrame.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.HeroMainGUI, 0, 0, 0, 0, false, false, true, true)
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_layer_win32" or "hero/hero_layer")

    HeroFrame._ui = GUI:ui_delegate(parent)
    if not HeroFrame._ui then
        return false
    end

    if isShowNG then
        GUI:Image_loadTexture(HeroFrame._ui["Image_bg"], path .. "1900015000_ng.png")

        local offY = isPC and 3 or 18
        GUI:setPositionY(HeroFrame._ui["Text_Name"], GUI:getPositionY(HeroFrame._ui["Text_Name"]) + offY)
    else
        GUI:Image_loadTexture(HeroFrame._ui["Image_bg"], path .. "1900015000.png")
    end

    GUI:RefPosByParent(parent)

    HeroFrame._showType = data and data.type or 1

    local root = HeroFrame._ui["Panel_1"]

    -- 适配
    local offY = isPC and 60 or 0
    GUI:setPositionY(root, SL:GetValue("SCREEN_HEIGHT") / 2 + offY)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, root)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, root)

    -- 关闭
    GUI:addOnClickEvent(HeroFrame._ui["ButtonClose"],function()
        GUI:Win_Close(parent)
    end)

    GUI:Win_SetCloseCB(parent, HeroFrame.OnClose)

    -- 注册事件
    HeroFrame.RegisterEvent()

    -- 刷新名字
    HeroFrame.RefreshHeroName()

    HeroFrame.InitEvent()

    HeroFrame.OnOpenPage(data and data.page or UIConst.LayerTable.PlayerEquip)
    
    HeroFrame.UpdateTopLayout()

    HeroFrame.UpdateTopLayoutShowState()

    -- 初始化页签
    HeroFrame.InitPageChangeBtn()

    -- TXT 挂接
    SL:AttachTXTSUI({root = root, index = SLDefine.SUIComponentTable.PlayerMain_hero})

    -- 截图节点
    HeroFrame._screenshotRootNode = root
end

function HeroFrame.InitEvent()
    local addClickEvent = function (layers)
        for pageID, _ in pairs(layers) do
            local button = HeroFrame._ui["Button_"..pageID]
            if button then
                GUI:addOnClickEvent(button, function()
                    HeroFrame.OnOpenPage(pageID)
                end)
            end
        end
    end

    -- 页签点击事件
    for k, layers in ipairs(ChildsUICfgs) do
        addClickEvent(layers)
    end

    GUI:addOnClickEvent(HeroFrame._ui["base_btn"], HeroFrame.OnChangeShowType)
    GUI:setTag(HeroFrame._ui["base_btn"], 1)

    GUI:addOnClickEvent(HeroFrame._ui["ng_btn"], HeroFrame.OnChangeShowType)
    GUI:setTag(HeroFrame._ui["ng_btn"], 2)
end

function HeroFrame.UpdateTopLayout()
    if not isShowNG then
        return false
    end

    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(HeroFrame._ui[name], HeroFrame._showType ~= i)
        GUI:setLocalZOrder(HeroFrame._ui[name], HeroFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(HeroFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, HeroFrame._showType == i and "#f8e6c6" or "#807256")
    end
end

-- 刷新内功顶部栏显示
function HeroFrame.UpdateTopLayoutShowState()
    if isShowNG and SL:GetValue("H.IS_LEARNED_INTERNAL") then
        GUI:setVisible(HeroFrame._ui["topLayout"], true)
    else
        GUI:setVisible(HeroFrame._ui["topLayout"], false)
    end
end

function HeroFrame.InitPageChangeBtn()
    local showType    = HeroFrame._showType
    local btnList     = HeroFrame._ui["Panel_btnList"]
    local btnListNG   = HeroFrame._ui["Panel_btnList_ng"]

    if isShowNG then 
        GUI:setVisible(btnList, showType == 1)
        GUI:setVisible(btnListNG, showType == 2)
    else
        GUI:setVisible(btnList, true)
        GUI:setVisible(btnListNG, false)
    end
end

function HeroFrame.OnChangeShowType(widget)
    local showType = GUI:getTag(widget)
    if HeroFrame._showType == showType then
        return false
    end

    HeroFrame.OperateChildUI(false)

    HeroFrame._showType = showType

    HeroFrame.UpdateTopLayout()
    HeroFrame.InitPageChangeBtn()

    HeroFrame._pageID = nil
    HeroFrame.OnOpenPage(({[1] = UIConst.LayerTable.PlayerEquip, [2] = UIConst.LayerTable.InternalState})[showType])
end

function HeroFrame.RefreshHeroName()
    local Text_Name = HeroFrame._ui["Text_Name"]
    GUI:Text_setString(Text_Name, SL:GetValue("H.USERNAME"))

    local color = SL:GetValue("HERO_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end
end

function HeroFrame.RefreshBtnState()
    local setChild = function (child)
        local isSelected = GUI:getName(child) == ("Button_" .. HeroFrame._pageID)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end

    local list = (isShowNG and HeroFrame._showType == 2) and HeroFrame._ui["Panel_btnList_ng"] or HeroFrame._ui["Panel_btnList"]
    local childs = GUI:getChildren(list)
    for _, child in ipairs(childs) do
        setChild(child)
    end
end

function HeroFrame.OperateChildUI(open)
    local uiCfg = (HeroFrame._pageID and ChildsUICfgs[HeroFrame._showType]) and ChildsUICfgs[HeroFrame._showType][HeroFrame._pageID]
    if not uiCfg then
        return false
    end

    if open then
        uiCfg.Open(roleUIType, HeroFrame._ui["Node_panel"])
    else
        uiCfg.Close(roleUIType)
    end
end

-- 打开子页签
function HeroFrame.OnOpenPage(pageID)
    if HeroFrame._pageID == pageID then
        return false
    end

    HeroFrame.OperateChildUI(false)

    HeroFrame._pageID = pageID

    HeroFrame.RefreshBtnState()

    -- 移除上个
    GUI:removeAllChildren(HeroFrame._ui["Node_panel"])

    -- 加载Layer
    HeroFrame.OperateChildUI(true)
end

function HeroFrame.OnClose()
    SL:UnAttachTXTSUI({index = SLDefine.SUIComponentTable.PlayerMain_hero})
    HeroFrame.OperateChildUI(false)
    HeroFrame.UnRegisterEvent()
    UIOperator:CloseItemTips()
end

function HeroFrame.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "HeroFrame", HeroFrame.RefreshHeroName)      -- 刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL, "HeroFrame", HeroFrame.UpdateTopLayoutShowState) -- 学习内功
end

function HeroFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL, "HeroFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_FRAME_NAME_RRFRESH, "HeroFrame")
end

HeroFrame.main()