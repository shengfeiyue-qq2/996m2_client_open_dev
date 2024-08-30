LookHeroFrame = {}

LookHeroFrame._ui = nil

-- 子界面打开配置
local ChildsUICfgs = {
    [UIConst.LayerTable.PlayerEquip] = {
        Open = handler(UIOperator, UIOperator.OpenRoleEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleEquipUI)
    },
    [UIConst.LayerTable.PlayerTitle] = {
        Open = handler(UIOperator, UIOperator.OpenRoleTitleUI),  Close = handler(UIOperator, UIOperator.CloseRoleTitleUI)
    },
    [UIConst.LayerTable.PlayerSuperEquip] = {
        Open = handler(UIOperator, UIOperator.OpenRoleSuperEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleSuperEquipUI)
    }
}

local roleUIType = GUIDefine.RoleUIType.HERO_OTHER

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookHeroFrame.main()
    SL:PrintTraceback()
    local parent = GUI:Win_Create(UIConst.LAYERID.LookHeroMainGUI, 0, 0, 0, 0, false, false, true, true)
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero_look/hero_layer_win32" or "hero_look/hero_layer")

    LookHeroFrame._ui = GUI:ui_delegate(parent)
    if not LookHeroFrame._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    local root = LookHeroFrame._ui["Panel_1"]

    -- 适配
    local offY = isPC and 60 or 0
    GUI:setPositionY(root, SL:GetValue("SCREEN_HEIGHT") / 2 + offY)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, root)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, root)

    -- 关闭
    GUI:addOnClickEvent(LookHeroFrame._ui["ButtonClose"],function()
        GUI:Win_Close(parent)
    end)

    GUI:Win_SetCloseCB(parent, LookHeroFrame.OnClose)

    -- 初始化名字
    LookHeroFrame.InitName()

    -- 页签点击事件
    LookHeroFrame.InitEvent()

    local pageID = data and data.page or 0
    pageID = pageID > 0 and pageID or UIConst.LayerTable.PlayerEquip
    LookHeroFrame.OnOpenPage(pageID)

    SL:AttachTXTSUI({index = SLDefine.SUIComponentTable.PlayerMain_hero})
end

-- 页签点击事件
function LookHeroFrame.InitEvent()
    for pageID, _ in pairs(ChildsUICfgs) do
        local button = LookHeroFrame._ui["Button_"..pageID]
        if button then
            GUI:addOnClickEvent(button, function()
                LookHeroFrame.OnOpenPage(pageID)
            end)
        end
    end
end

function LookHeroFrame.InitName()
    -- 名字
    local Text_Name = LookHeroFrame._ui["Text_Name"]
    GUI:Text_setString(Text_Name, LookPlayerData.GetPlayerName())

    -- 名字颜色
    local color = LookPlayerData.GetPlayerNameColor()
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end

    -- 查看他人 点击私聊
    GUI:addOnClickEvent(Text_Name, function()
        SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = LookPlayerData.GetPlayerName(), uid = LookPlayerData.GetPlayerUID()})
    end)
end

-- 打开子页签
function LookHeroFrame.OnOpenPage(pageID)
    if LookHeroFrame._pageID == pageID then
        return false
    end

    LookHeroFrame.OperateChildUI(false)

    LookHeroFrame._pageID = pageID

    LookHeroFrame.RefreshBtnState()

    -- 移除上个
    GUI:removeAllChildren(LookHeroFrame._ui["Node_panel"])

    -- 加载Layer
    LookHeroFrame.OperateChildUI(true)
end

function LookHeroFrame.RefreshBtnState()
    local setChild = function (child)
        local isSelected = GUI:getName(child) == ("Button_" .. LookHeroFrame._pageID)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end

    for _, child in ipairs(GUI:getChildren(LookHeroFrame._ui["Panel_btnList"])) do
        setChild(child)
    end
end

-- 关闭子页签
function LookHeroFrame.OperateChildUI(open)
    local uiCfg = LookHeroFrame._pageID and ChildsUICfgs[LookHeroFrame._pageID]
    if not uiCfg then
        return false
    end

    if open then
        uiCfg.Open(roleUIType, LookHeroFrame._ui["Node_panel"])
    else
        uiCfg.Close(roleUIType)
    end
end

function LookHeroFrame.OnClose()
    SL:UnAttachTXTSUI({index = SLDefine.SUIComponentTable.PlayerMain_hero})
    LookHeroFrame.OperateChildUI(false)
    UIOperator:CloseItemTips()
end

LookHeroFrame.main()
