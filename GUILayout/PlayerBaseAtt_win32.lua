PlayerBaseAtt = {}--角色面板 状态

PlayerBaseAtt._ui = nil
PlayerBaseAtt._baseAttributeStr = {
    "职   业",
    "等   级",
    "当前经验",
    "升级经验",
}

local function getAttValue(key)
    local str = ""
    local min = 0
    local max = 0
    if key == 1 then
        str = SL:GetMetaValue("JOB_NAME")--职业名
    elseif key == 2 then
        local level = SL:GetMetaValue("LEVEL")--等级
        local reinLv = SL:GetMetaValue("RELEVEL")--转生等级
        if reinLv and reinLv > 0 then
            str = string.format("%s转%s级", reinLv, level)
        else 
            str = string.format("%s级", level)
        end
    elseif key == 3 then
        str = SL:GetMetaValue("EXP")--经验值
    elseif key == 4 then
        str = SL:GetMetaValue("MAXEXP")--升级经验
    end
    return str
end

function PlayerBaseAtt.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_base_attri_node_win32")

    PlayerBaseAtt._ui = GUI:ui_delegate(parent)
    PlayerBaseAtt._parent = parent
    if not PlayerBaseAtt._ui then
        return false
    end
    PlayerBaseAtt._index = 0--添加的属性条编号
    PlayerBaseAtt.UpdateBaseAttri()
end

function PlayerBaseAtt.UpdateBaseAttri()
    local list = PlayerBaseAtt._ui.ListView_base
    GUI:removeAllChildren(list)
    for k, v in ipairs(PlayerBaseAtt._baseAttributeStr) do
        local listData = {
            str = v,
            strValue = getAttValue(k)
        }
        PlayerBaseAtt.CreateAttri(list,listData)
    end

    --脚本添加的额外属性
    local variableInfo = SL:GetMetaValue("EX_ATTR")
    local variableList = string.split(variableInfo, "|")
    for i, v in ipairs(variableList) do
        local attList = string.split(v, "#")
        if attList[1] and attList[2] then
            local listData = {
                str = attList[1],
                strValue = attList[2]
            }
            local cell = PlayerBaseAtt.CreateAttri(list,listData)
            if string.find(attList[2], "&<(.-)>&") then
                SL:CustomAttrWidgetAdd(attList[2],cell.Text_attValue)--脚本变量额外属性 添加监听更新
            end
        end
    end

     -- 红点变量 客户端game_data配置 m2需对应配置
    local redValue = SL:GetMetaValue("GAME_DATA", "RedPointValue")
    local data = string.split(redValue, "|")
    for i, v in ipairs(data) do 
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

            local listData = {
                str = name,
                strValue = newValue
            }
            local cell = PlayerBaseAtt.CreateAttri(list, listData)
            SL:CustomAttrWidgetAdd(newValue, cell.Text_attValue) -- 添加监听更新         
        end  
    end    
end

function PlayerBaseAtt.CreateAttri(parent,data)
    PlayerBaseAtt._index = PlayerBaseAtt._index + 1
    local widget = GUI:Widget_Create(parent, "Attribute_"..PlayerBaseAtt._index, 0, 0, 272, 22)
    GUI:LoadExport(widget, "player/att_show_list_win32")
    local ui =  GUI:ui_delegate(widget)
    if data.str then
        GUI:Text_setString(ui.Text_attName,data.str .. "：")
    end
    GUI:Text_setString(ui.Text_attValue,data.strValue )
    return ui
end