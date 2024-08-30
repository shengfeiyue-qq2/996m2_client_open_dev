HeroBaseAtt = {}

local getLevelFunc = function ()
    local level  = SL:GetValue("H.LEVEL")         -- 等级
    local reinLv = SL:GetValue("H.RELEVEL")       -- 转生等级
    if reinLv and reinLv > 0 then
        return string.format("%s转%s级", reinLv, level)
    end
    return string.format("%s级", level)
end

local baseAttrCfg = {
    {tip = "职   业", func = function () return SL:GetValue("H.JOBNAME") end},
    {tip = "等   级", func = getLevelFunc},
    {tip = "当前经验", func = function () return SL:GetValue("H.EXP") end},
    {tip = "升级经验", func = function () return SL:GetValue("H.MAXEXP") end}
}

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function HeroBaseAtt.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_base_attri_node_win32" or "hero/hero_base_attri_node")

    HeroBaseAtt._ui = GUI:ui_delegate(parent)
    if not HeroBaseAtt._ui then
        return false
    end

    HeroBaseAtt._listView = HeroBaseAtt._ui["ListView_base"]

    HeroBaseAtt.UpdateBaseAttri()

    GUI:RefPosByParent(parent)

    HeroBaseAtt.RegistEvent()

    -- 自定义组件
    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerState_hero})
end

-- 界面关闭回调
function HeroBaseAtt.OnClose()
    HeroBaseAtt.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerState_hero
    })
end

function HeroBaseAtt.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE, "HeroBaseAtt", HeroBaseAtt.UpdateBaseAttri)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_EXP_CHANGE, "HeroBaseAtt", HeroBaseAtt.UpdateBaseAttri)
end

-- 取消事件
function HeroBaseAtt.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE, "HeroBaseAtt")
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_EXP_CHANGE, "HeroBaseAtt")
end

function HeroBaseAtt.UpdateBaseAttri()
    GUI:removeAllChildren(HeroBaseAtt._listView)

    -- 基础属性
    for _, v in ipairs(baseAttrCfg) do
        if v then
            HeroBaseAtt.CreateAttri({tip = v.tip, value = v.func()})
        end
    end
end

function HeroBaseAtt.CreateAttri(data)
    local ui = GUI:LoadExportEx2(isPC and "hero/att_show_list_win32" or "hero/att_show_list", "att_cell")
    GUI:ListView_pushBackCustomItem(HeroBaseAtt._listView, ui)
    GUI:ui_IterChilds(ui, ui)

    local tip = data.tip or "ERROR"
    GUI:Text_setString(ui["Text_attName"], tip .. "：")

    local value = data.value or 0
    GUI:Text_setString(ui["Text_attValue"], value)

    return ui
end

HeroBaseAtt.main()