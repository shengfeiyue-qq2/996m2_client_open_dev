PlayerBaseAtt = {}

local getLevelFunc = function ()
    local level  = SL:GetValue("LEVEL")         -- 等级
    local reinLv = SL:GetValue("RELEVEL")       -- 转生等级
    if reinLv and reinLv > 0 then
        return string.format("%s转%s级", reinLv, level)
    end
    return string.format("%s级", level)
end

local baseAttrCfg = {
    {tip = "职   业", func = function () return SL:GetValue("JOB_NAME") end},
    {tip = "等   级", func = getLevelFunc},
    {tip = "当前经验", func = function () return SL:GetValue("EXP") end},
    {tip = "升级经验", func = function () return SL:GetValue("MAXEXP") end}
}

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function PlayerBaseAtt.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if GUI:Win_IsNull(parent) then
        return false
    end
    GUI:LoadExport(parent, isPC and "player/player_base_attri_node_win32" or "player/player_base_attri_node")

    PlayerBaseAtt._ui = GUI:ui_delegate(parent)
    if not PlayerBaseAtt._ui then
        return false
    end

    PlayerBaseAtt._listView = PlayerBaseAtt._ui["ListView_base"]

    PlayerBaseAtt.UpdateBaseAttri()

    GUI:RefPosByParent(parent)

    PlayerBaseAtt.RegistEvent()

    -- 自定义组件
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerState})
end

-- 界面关闭回调
function PlayerBaseAtt.OnClose()
    PlayerBaseAtt.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerState
    })
end

function PlayerBaseAtt.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "PlayerBaseAtt", PlayerBaseAtt.UpdateBaseAttri)
    SL:RegisterLUAEvent(LUA_EVENT_EXP_CHANGE, "PlayerBaseAtt", PlayerBaseAtt.UpdateBaseAttri)
end

-- 取消事件
function PlayerBaseAtt.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "PlayerBaseAtt")
    SL:UnRegisterLUAEvent(LUA_EVENT_EXP_CHANGE, "PlayerBaseAtt")
end

function PlayerBaseAtt.UpdateBaseAttri()
    GUI:removeAllChildren(PlayerBaseAtt._listView)

    -- 基础属性
    for _, v in ipairs(baseAttrCfg) do
        if v then
            PlayerBaseAtt.CreateAttri({tip = v.tip, value = v.func()})
        end
    end

    -- 红点变量 客户端game_data配置 m2需对应配置
    local redValue = SL:GetValue("GAME_DATA", "RedPointValue")
    local data = string.split(redValue, "|")
    for _, v in ipairs(data) do 
        local temp = string.split(v, "#")
        local name = temp[1]
        local value = temp[2] 
        if value and name then   
            local newValue = nil
            if tonumber(value) then 
                newValue = string.format("&<TITEMCOUNT/%s>&", value)
            else 
                newValue = string.format("&<REDKEY/%s>&", value)
            end 
            local cell = PlayerBaseAtt.CreateAttri({tip = name, value = newValue})

            -- 添加监听更新
            SL:CustomAttrWidgetAdd(newValue, cell.Text_attValue)
        end 
    end 
end

function PlayerBaseAtt.CreateAttri(data)
    local ui = GUI:LoadExportEx2(isPC and "player/att_show_list_win32" or "player/att_show_list", "att_cell")
    GUI:ListView_pushBackCustomItem(PlayerBaseAtt._listView, ui)
    GUI:ui_IterChilds(ui, ui)

    local tip = data.tip or "ERROR"
    GUI:Text_setString(ui["Text_attName"], tip .. "：")

    local value = data.value or 0
    GUI:Text_setString(ui["Text_attValue"], value)

    return ui
end

PlayerBaseAtt.main()