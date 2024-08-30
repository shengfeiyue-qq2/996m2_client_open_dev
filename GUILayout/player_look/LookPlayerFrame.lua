LookPlayerFrame = {}

LookPlayerFrame._ui = nil

-- 子界面配置
local ChildsUICfgs = {
    [UIConst.LayerTable.PlayerEquip] = {
        Open = handler(UIOperator, UIOperator.OpenRoleEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleEquipUI)
    },
    [UIConst.LayerTable.PlayerTitle] = {
        Open = handler(UIOperator, UIOperator.OpenRoleTitleUI),  Close = handler(UIOperator, UIOperator.CloseRoleTitleUI)
    },
    [UIConst.LayerTable.PlayerSuperEquip] = {
        Open = handler(UIOperator, UIOperator.OpenRoleSuperEquipUI), Close = handler(UIOperator, UIOperator.CloseRoleSuperEquipUI)
    },
    [UIConst.LayerTable.PlayerBuff] = {
        Open = handler(UIOperator, UIOperator.OpenRoleBuffUI), Close = handler(UIOperator, UIOperator.CloseRoleBuffUI)
    }
}

local roleUIType = GUIDefine.RoleUIType.PLAYER_OTHER

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookPlayerFrame.main()
    SL:PrintTraceback()
    local parent = GUI:Win_Create(UIConst.LAYERID.LookPlayerMainGUI, 0, 0, 0, 0, false, false, true, true)
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "player_look/player_layer_win32" or "player_look/player_layer")

    LookPlayerFrame._ui = GUI:ui_delegate(parent)
    LookPlayerFrame._parent = parent

    if not LookPlayerFrame._ui then
        return false
    end

    GUI:RefPosByParent(parent)

    local root = LookPlayerFrame._ui["Panel_1"]

    -- 适配
    local offY = isPC and 60 or 0
    GUI:setPosition(root, SL:GetValue("SCREEN_WIDTH") - 236, SL:GetValue("SCREEN_HEIGHT") / 2 + offY)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, root)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, root)

    -- 关闭
    GUI:addOnClickEvent(LookPlayerFrame._ui["ButtonClose"],function()
        GUI:Win_Close(parent)
    end)

    GUI:Win_SetCloseCB(parent, LookPlayerFrame.OnClose)

    -- 初始化名字
    LookPlayerFrame.InitName()

    -- 页签点击事件
    LookPlayerFrame.InitEvent()

    local pageID = data and data.page or 0
    pageID = pageID > 0 and pageID or UIConst.LayerTable.PlayerEquip
    LookPlayerFrame.OnOpenPage(pageID)

    SL:AttachTXTSUI({root = root, index = SLDefine.SUIComponentTable.PlayerMainO})
end

-- 页签点击事件
function LookPlayerFrame.InitEvent()
    for pageID, _ in pairs(ChildsUICfgs) do
        local button = LookPlayerFrame._ui["Button_"..pageID]
        if button then
            GUI:addOnClickEvent(button, function()
                LookPlayerFrame.OnOpenPage(pageID)
            end)
        end
    end
end

function LookPlayerFrame.InitName()
    -- 名字
    local Text_Name = LookPlayerFrame._ui["Text_Name"]
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
function LookPlayerFrame.OnOpenPage(pageID)
    if LookPlayerFrame._pageID == pageID then
        return false
    end

    LookPlayerFrame.OperateChildUI(false)

    LookPlayerFrame._pageID = pageID

    LookPlayerFrame.RefreshBtnState()

    -- 移除上个
    GUI:removeAllChildren(LookPlayerFrame._ui["Node_panel"])

    -- 加载Layer
    LookPlayerFrame.OperateChildUI(true)
end

function LookPlayerFrame.RefreshBtnState()
    local setChild = function (child)
        local isSelected = GUI:getName(child) == ("Button_" .. LookPlayerFrame._pageID)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end

    for _, child in ipairs(GUI:getChildren(LookPlayerFrame._ui["Panel_btnList"])) do
        setChild(child)
    end
end

-- 关闭子页签
function LookPlayerFrame.OperateChildUI(open)
    local uiCfg = LookPlayerFrame._pageID and ChildsUICfgs[LookPlayerFrame._pageID]
    if not uiCfg then
        return false
    end

    if open then
        uiCfg.Open(roleUIType, LookPlayerFrame._ui["Node_panel"])
    else
        uiCfg.Close(roleUIType)
    end
end

function LookPlayerFrame.OnClose()
    SL:UnAttachTXTSUI({index = SLDefine.SUIComponentTable.PlayerMainO})
    LookPlayerFrame.OperateChildUI(false)
    UIOperator:CloseItemTips()
end

LookPlayerFrame.main()
