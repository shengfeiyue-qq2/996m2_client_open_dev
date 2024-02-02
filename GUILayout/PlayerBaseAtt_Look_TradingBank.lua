PlayerBaseAtt_Look_TradingBank = {}--交易行 人物面板 状态

PlayerBaseAtt_Look_TradingBank._ui = nil
PlayerBaseAtt_Look_TradingBank._baseAttributeStr = {
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
        str = SL:GetMetaValue("T.M.JOB")--职业
    elseif key == 2 then
        local level = SL:GetMetaValue("T.M.LEVEL")--等级
        local reinLv = SL:GetMetaValue("T.M.RELEVEL")--转生等级
        if reinLv and reinLv > 0 then
            str = string.format("%s转%s级",reinLv,level)
        else 
            str = string.format("%s级",level)
        end
    elseif key == 3 then
        str = SL:GetMetaValue("T.M.EXP")--经验值
    elseif key == 4 then
        str = SL:GetMetaValue("T.M.MAXEXP")--升级经验
    end
    return str
end

function PlayerBaseAtt_Look_TradingBank.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look_tradingbank/player_base_attri_node")

    PlayerBaseAtt_Look_TradingBank._ui = GUI:ui_delegate(parent)
    PlayerBaseAtt_Look_TradingBank._parent = parent
    if not PlayerBaseAtt_Look_TradingBank._ui then
        return false
    end
    PlayerBaseAtt_Look_TradingBank._index = 0--添加的属性条编号
    PlayerBaseAtt_Look_TradingBank.UpdateBaseAttri()
end

function PlayerBaseAtt_Look_TradingBank.UpdateBaseAttri()
    local list = PlayerBaseAtt_Look_TradingBank._ui.ListView_base
    GUI:removeAllChildren(list)
    for k, v in ipairs(PlayerBaseAtt_Look_TradingBank._baseAttributeStr) do
        local listData = {
            str = v,
            strValue = getAttValue(k)
        }
        PlayerBaseAtt_Look_TradingBank.CreateAttri(list,listData)
    end
end

function PlayerBaseAtt_Look_TradingBank.CreateAttri(parent,data)
    PlayerBaseAtt_Look_TradingBank._index = PlayerBaseAtt_Look_TradingBank._index + 1
    local widget = GUI:Widget_Create(parent, "Attribute_"..PlayerBaseAtt_Look_TradingBank._index, 0, 0, 348, 27)
    GUI:LoadExport(widget, "player_look_tradingbank/att_show_list")
    local ui =  GUI:ui_delegate(widget)
    if data.str then
        GUI:Text_setString(ui.Text_attName,data.str .. "：")
    end
    GUI:Text_setString(ui.Text_attValue,data.strValue )
    return ui
end