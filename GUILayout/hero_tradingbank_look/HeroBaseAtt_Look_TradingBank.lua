HeroBaseAtt_Look_TradingBank = {}

local getLevelFunc = function ()
    local level  = TradingBankLookPlayerData.GetHeroCurAbilByID(GUIDefine.AttTypeTable.LEVEL)          -- 等级
    local reinLv = TradingBankLookPlayerData.GetHeroCurAbilByID(GUIDefine.AttTypeTable.Rein_LEVEL)       -- 转生等级
    if reinLv and reinLv > 0 then
        return string.format("%s转%s级", reinLv, level)
    end
    return string.format("%s级", level)
end

local baseAttrCfg = {
    {tip = "职   业", func = function () return SL:GetValue("JOB_NAME", TradingBankLookPlayerData.GetHeroJob()) end},
    {tip = "等   级", func = getLevelFunc},
    {tip = "当前经验", func = function () return TradingBankLookPlayerData.GetHeroCurAbilByID(GUIDefine.AttTypeTable.EXP)  end},
    {tip = "升级经验", func = function () return TradingBankLookPlayerData.GetHeroMaxAbilByID(GUIDefine.AttTypeTable.EXP) end}
}


function HeroBaseAtt_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_base_attri_node")

    HeroBaseAtt_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroBaseAtt_Look_TradingBank._ui then
        return false
    end

    HeroBaseAtt_Look_TradingBank._listView = HeroBaseAtt_Look_TradingBank._ui.ListView_base
    HeroBaseAtt_Look_TradingBank._index = 0--添加的属性条编号
    HeroBaseAtt_Look_TradingBank.UpdateBaseAttri()
end

-- 界面关闭回调
function HeroBaseAtt_Look_TradingBank.OnClose()
end

function HeroBaseAtt_Look_TradingBank.UpdateBaseAttri()
    GUI:removeAllChildren(HeroBaseAtt_Look_TradingBank._listView)

    -- 基础属性
    for _, v in ipairs(baseAttrCfg) do
        if v then
            HeroBaseAtt_Look_TradingBank.CreateAttri({tip = v.tip, value = v.func()})
        end
    end
end

function HeroBaseAtt_Look_TradingBank.CreateAttri(data)
    HeroBaseAtt_Look_TradingBank._index = HeroBaseAtt_Look_TradingBank._index + 1
    local widget = GUI:Widget_Create(HeroBaseAtt_Look_TradingBank._listView, "Attribute_"..HeroBaseAtt_Look_TradingBank._index, 0, 0, 348, 27)
    GUI:LoadExport(widget, "hero_look_tradingbank/att_show_list")
    local ui =  GUI:ui_delegate(widget)

    local tip = data.tip or "ERROR"
    GUI:Text_setString(ui.Text_attName, tip .. "：")

    local value = data.value or 0
    GUI:Text_setString(ui.Text_attValue, value)

    return ui
end

HeroBaseAtt_Look_TradingBank.main()