-- 玩家面板 外框
PlayerFrame = {}

PlayerFrame._ui = nil

-- 1 基础 2 内功
PlayerFrame._showType = 1

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
        },
        [UIConst.LayerTable.PlayerBuff] = {
            Open = handler(UIOperator, UIOperator.OpenRoleBuffUI), Close = handler(UIOperator, UIOperator.CloseRoleBuffUI)
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

local roleUIType = GUIDefine.RoleUIType.PLAYER

-- 内功是否显示
local isShowNG = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1

local isPC = SL:GetValue("IS_PC_OPER_MODE")

local path = isPC and "res/private/player_main_layer_ui/player_main_layer_ui_win32/" or "res/private/player_main_layer_ui/player_main_layer_ui_mobile/"

function PlayerFrame.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.PlayerMainGUI, 0, 0, 0, 0, false, false, true, true)
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "player/player_layer_win32" or "player/player_layer")

    PlayerFrame._ui = GUI:ui_delegate(parent) 
    if not PlayerFrame._ui then
        return false
    end

    if isShowNG then
        GUI:Image_loadTexture(PlayerFrame._ui["Image_bg"], path .. "1900015000_ng.png")
        
        local offY = isPC and 3 or 18
        GUI:setPositionY(PlayerFrame._ui["Text_Name"], GUI:getPositionY(PlayerFrame._ui["Text_Name"]) + offY)
    else
        GUI:Image_loadTexture(PlayerFrame._ui["Image_bg"], path .. "1900015000.png")
    end

    GUI:RefPosByParent(parent)

    PlayerFrame._showType = data and data.type or 1
    PlayerFrame.typeCapture = data and data.typeCapture or nil
    local root = PlayerFrame._ui["Panel_1"]

    -- 适配
    local offY = isPC and 60 or 0
    GUI:setPosition(root, SL:GetValue("SCREEN_WIDTH") - 236, SL:GetValue("SCREEN_HEIGHT") / 2 + offY)

    -- 拖动的控件
    GUI:Win_SetDrag(parent, root)

    -- 点击 界面浮起
    GUI:Win_SetZPanel(parent, root)

    -- 关闭
    GUI:addOnClickEvent(PlayerFrame._ui["ButtonClose"],function()
        GUI:Win_Close(parent)
    end)

    GUI:Win_SetCloseCB(parent, PlayerFrame.OnClose)

    -- 注册事件
    PlayerFrame.RegisterEvent()

    -- 刷新名字
    PlayerFrame.RefreshPlayerName()

    PlayerFrame.InitEvent()

    PlayerFrame.OnOpenPage(data and data.page or UIConst.LayerTable.PlayerEquip)
    
    PlayerFrame.UpdateTopLayout()

    PlayerFrame.UpdateTopLayoutShowState()

    -- 初始化页签
    PlayerFrame.InitPageChangeBtn()

    -- TXT 挂接
    SL:AttachTXTSUI({root = root, index = SLDefine.SUIComponentTable.PlayerMain})

    -- 截图节点
    PlayerFrame._screenshotRootNode = root
end

function PlayerFrame.InitEvent()
    local addClickEvent = function (layers)
        for pageID, _ in pairs(layers) do
            local button = PlayerFrame._ui["Button_"..pageID]
            if button then
                GUI:addOnClickEvent(button, function()
                    PlayerFrame.OnOpenPage(pageID)
                end)
            end
        end
    end

    -- 页签点击事件
    for k, layers in ipairs(ChildsUICfgs) do
        addClickEvent(layers)
    end

    GUI:addOnClickEvent(PlayerFrame._ui["base_btn"], PlayerFrame.OnChangeShowType)
    GUI:setTag(PlayerFrame._ui["base_btn"], 1)

    GUI:addOnClickEvent(PlayerFrame._ui["ng_btn"], PlayerFrame.OnChangeShowType)
    GUI:setTag(PlayerFrame._ui["ng_btn"], 2)
end

function PlayerFrame.UpdateTopLayout()
    if not isShowNG then
        return false
    end

    local keyList = {"base_btn", "ng_btn"}
    for i, name in ipairs(keyList) do
        GUI:Button_setBright(PlayerFrame._ui[name], PlayerFrame._showType ~= i)
        GUI:setLocalZOrder(PlayerFrame._ui[name], PlayerFrame._showType == i and 1 or 0)
        local nameText = GUI:getChildByName(PlayerFrame._ui[name], "Text_1")
        GUI:Text_setTextColor(nameText, PlayerFrame._showType == i and "#f8e6c6" or "#807256")
    end
end

-- 刷新内功顶部栏显示
function PlayerFrame.UpdateTopLayoutShowState()
    if isShowNG and SL:GetValue("IS_LEARNED_INTERNAL") then
        GUI:setVisible(PlayerFrame._ui["topLayout"], true)
    else
        GUI:setVisible(PlayerFrame._ui["topLayout"], false)
    end
end

function PlayerFrame.InitPageChangeBtn()
    local showType    = PlayerFrame._showType
    local btnList     = PlayerFrame._ui["Panel_btnList"]
    local btnListNG   = PlayerFrame._ui["Panel_btnList_ng"]
    local btnListLeft = PlayerFrame._ui["Panel_btnList_left"]

    if isShowNG then 
        GUI:setVisible(btnList, showType == 1)
        GUI:setVisible(btnListNG, showType == 2)
        GUI:setVisible(btnListLeft, showType == 1)
    else
        GUI:setVisible(btnList, true)
        GUI:setVisible(btnListNG, false)
        GUI:setVisible(btnListLeft, true)
    end
end

function PlayerFrame.OnChangeShowType(widget)
    local showType = GUI:getTag(widget)
    if PlayerFrame._showType == showType then
        return false
    end

    PlayerFrame.OperateChildUI(false)

    PlayerFrame._showType = showType

    PlayerFrame.UpdateTopLayout()
    PlayerFrame.InitPageChangeBtn()

    PlayerFrame._pageID = nil
    PlayerFrame.OnOpenPage(({[1] = UIConst.LayerTable.PlayerEquip, [2] = UIConst.LayerTable.InternalState})[showType])
end

function PlayerFrame.RefreshPlayerName()
    local Text_Name = PlayerFrame._ui["Text_Name"]
    GUI:Text_setString(Text_Name, SL:GetValue("USER_NAME"))

    local color = SL:GetValue("USER_NAME_COLOR")
    if color and color > 0 then
        GUI:Text_setTextColor(Text_Name, SL:GetHexColorByStyleId(color))
    end

    -- PC 点击私聊
    if isPC then
        GUI:addOnClickEvent(Text_Name, function()
            SL:onLUAEvent(LUA_EVENT_CHAT_PRIVATE_TARGET, {name = SL:GetMetaValue("USER_NAME"), uid = SL:GetMetaValue("USER_ID")})
        end)
    end
end

function PlayerFrame.RefreshBtnState()
    local setChild = function (child)
        local isSelected = GUI:getName(child) == ("Button_" .. PlayerFrame._pageID)
        GUI:setLocalZOrder(child, isSelected and 1 or 0)
        GUI:setTouchEnabled(child, not isSelected)
        GUI:Button_setBright(child, not isSelected)
        local nameText = GUI:getChildByName(child, "Text_name")
        GUI:Text_setTextColor(nameText, isSelected and "#f8e6c6" or "#807256")
    end

    local list = (isShowNG and PlayerFrame._showType == 2) and PlayerFrame._ui["Panel_btnList_ng"] or PlayerFrame._ui["Panel_btnList"]
    local childs = GUI:getChildren(list)
    for _, child in ipairs(childs) do
        setChild(child)
    end

    local btnListLeft = PlayerFrame._ui["Panel_btnList_left"]
    if btnListLeft then
        for _, child in ipairs(GUI:getChildren(btnListLeft)) do
            setChild(child)
        end
    end
end

function PlayerFrame.OperateChildUI(open)
    local uiCfg = (PlayerFrame._pageID and ChildsUICfgs[PlayerFrame._showType]) and ChildsUICfgs[PlayerFrame._showType][PlayerFrame._pageID]
    if not uiCfg then
        return false
    end

    if open then
        uiCfg.Open(roleUIType, PlayerFrame._ui["Node_panel"])
    else
        uiCfg.Close(roleUIType)
    end
end

-- 打开子页签
function PlayerFrame.OnOpenPage(pageID)
    if PlayerFrame._pageID == pageID then
        return false
    end

    PlayerFrame.OperateChildUI(false)

    PlayerFrame._pageID = pageID

    PlayerFrame.RefreshBtnState()

    -- 移除上个
    GUI:removeAllChildren(PlayerFrame._ui["Node_panel"])

    -- 加载Layer
    PlayerFrame.OperateChildUI(true)
end

-- 是否重复打开
function PlayerFrame:IsReOpen(pageID)
    return PlayerFrame._pageID == pageID
end

function PlayerFrame.OnClose()
    SL:UnAttachTXTSUI({index = SLDefine.SUIComponentTable.PlayerMain})
    PlayerFrame.OperateChildUI(false)
    PlayerFrame.UnRegisterEvent()
    UIOperator:CloseItemTips()
    PlayerFrame._pageID = nil
end

function PlayerFrame.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame", PlayerFrame.RefreshPlayerName)      -- 刷新名字
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "PlayerFrame", PlayerFrame.UpdateTopLayoutShowState) -- 学习内功
end

function PlayerFrame.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_LEARNED_INTERNAL, "PlayerFrame")
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH, "PlayerFrame")
end

PlayerFrame.main()