HeroBaseAtt = {} --英雄面板 状态

HeroBaseAtt._ui = nil
HeroBaseAtt._baseAttributeStr = {
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
        str = SL:GetMetaValue("H.JOBNAME")--职业名
    elseif key == 2 then
        local level = SL:GetMetaValue("H.LEVEL")--等级
        local reinLv = SL:GetMetaValue("H.RELEVEL")--转生等级
        if reinLv and reinLv > 0 then
            str = string.format("%s转%s级",reinLv,level)
        else 
            str = string.format("%s级",level)
        end
    elseif key == 3 then
        str = SL:GetMetaValue("H.EXP")--经验值
    elseif key == 4 then
        str = SL:GetMetaValue("H.MAXEXP")--升级经验
    end
    return str
end

function HeroBaseAtt.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_base_attri_node_win32")

    HeroBaseAtt._ui = GUI:ui_delegate(parent)
    HeroBaseAtt._parent = parent
    if not HeroBaseAtt._ui then
        return false
    end
    HeroBaseAtt._index = 0--添加的属性条编号
    HeroBaseAtt.UpdateBaseAttri()
end

function HeroBaseAtt.UpdateBaseAttri()
    local list = HeroBaseAtt._ui.ListView_base
    GUI:removeAllChildren(list)
    for k, v in ipairs(HeroBaseAtt._baseAttributeStr) do
        local listData = {
            str = v,
            strValue = getAttValue(k)
        }
        HeroBaseAtt.CreateAttri(list,listData)
    end
end

function HeroBaseAtt.CreateAttri(parent,data)
    HeroBaseAtt._index = HeroBaseAtt._index + 1
    local widget = GUI:Widget_Create(parent, "Attribute_"..HeroBaseAtt._index, 0, 0, 272, 22)
    GUI:LoadExport(widget, "hero/att_show_list_win32")
    local ui =  GUI:ui_delegate(widget)
    if data.str then
        GUI:Text_setString(ui.Text_attName,data.str .. "：")
    end
    GUI:Text_setString(ui.Text_attValue,data.strValue )
    return ui
end