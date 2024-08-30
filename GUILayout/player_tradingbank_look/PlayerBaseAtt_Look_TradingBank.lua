PlayerBaseAtt_Look_TradingBank = {}

local getLevelFunc = function ()
    local level  = TradingBankLookPlayerData.GetCurAbilByID(GUIDefine.AttTypeTable.LEVEL)       -- 等级
    local reinLv = TradingBankLookPlayerData.GetCurAbilByID(GUIDefine.AttTypeTable.Rein_LEVEL)      -- 转生等级
    if reinLv and reinLv > 0 then
        return string.format("%s转%s级", reinLv, level)
    end
    return string.format("%s级", level)
end

local baseAttrCfg = {
    {tip = "职   业", func = function () return SL:GetValue("JOB_NAME", TradingBankLookPlayerData.GetPlayerJob()) end},
    {tip = "等   级", func = getLevelFunc},
    {tip = "当前经验", func = function () return TradingBankLookPlayerData.GetCurAbilByID(GUIDefine.AttTypeTable.EXP) end},
    {tip = "升级经验", func = function () return TradingBankLookPlayerData.GetMaxAbilByID(GUIDefine.AttTypeTable.EXP) end}
}


function PlayerBaseAtt_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "player_look_tradingbank/player_base_attri_node")

    PlayerBaseAtt_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not PlayerBaseAtt_Look_TradingBank._ui then
        return false
    end

    PlayerBaseAtt_Look_TradingBank._listView = PlayerBaseAtt_Look_TradingBank._ui.ListView_base
    PlayerBaseAtt_Look_TradingBank._index = 0--添加的属性条编号
    PlayerBaseAtt_Look_TradingBank.UpdateBaseAttri()
end

-- 界面关闭回调
function PlayerBaseAtt_Look_TradingBank.OnClose()
end

function PlayerBaseAtt_Look_TradingBank.UpdateBaseAttri()
    GUI:removeAllChildren(PlayerBaseAtt_Look_TradingBank._listView)

    -- 基础属性
    for _, v in ipairs(baseAttrCfg) do
        if v then
            PlayerBaseAtt_Look_TradingBank.CreateAttri({tip = v.tip, value = v.func()})
        end
    end
end

function PlayerBaseAtt_Look_TradingBank.CreateAttri(data)
    PlayerBaseAtt_Look_TradingBank._index = PlayerBaseAtt_Look_TradingBank._index + 1
    local widget = GUI:Widget_Create(PlayerBaseAtt_Look_TradingBank._listView, "Attribute_"..PlayerBaseAtt_Look_TradingBank._index, 0, 0, 348, 27)
    GUI:LoadExport(widget, "player_look_tradingbank/att_show_list")
    local ui =  GUI:ui_delegate(widget)

    local tip = data.tip or "ERROR"
    GUI:Text_setString(ui.Text_attName, tip .. "：")

    local value = data.value or 0
    GUI:Text_setString(ui.Text_attValue, value)

    return ui
end

PlayerBaseAtt_Look_TradingBank.main()