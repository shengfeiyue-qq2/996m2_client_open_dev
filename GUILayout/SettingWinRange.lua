SettingWinRange = {}

SettingWinRange._ui = nil
local group1 = {
    SLDefine.SETTINGID.SETTING_IDX_ROCKER_SHOW_DISTANCE, --轮盘侧边距
    SLDefine.SETTINGID.SETTING_IDX_SKILL_SHOW_DISTANCE, --技能侧边距
}
local group2 = {
    SLDefine.SETTINGID.SETTING_IDX_CAMERA_ZOOM, --地图缩放
}
local showImagePath = "res/private/new_setting/imgBg.png" --示意图片

local getConfigFunc = function(group)
    local configs = {}
    local config
    for i, id in ipairs(group) do
        config = SL:GetMetaValue("SETTING_CONFIG", id)
        if config and (config.platform == 0 or config.platform == SL:GetMetaValue("CURRENT_OPERMODE")) then
            if not config.order or  not tonumber(config.order) then
                config.order = 0 
            end
            table.insert(configs, config)
        end
    end
    table.sort(configs, function(a, b)
        return a.order < b.order
    end)
    return configs
end

function SettingWinRange.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "set/setting_win_range")

    SettingWinRange._ui = GUI:ui_delegate(parent)
    if not SettingWinRange._ui then
        return false
    end

    -- 示意图片
    local Image_1 = GUI:Image_Create(SettingWinRange._ui.ListView_1, "Image_1", 343, 80, showImagePath)
    GUI:setAnchorPoint(Image_1, 0, 0)
    GUI:setContentSize(Image_1, 686, 160)
    --第一组滑条
    SettingWinRange.initGroup1()
    --第二组滑条
    SettingWinRange.initGroup2()
end

function SettingWinRange.initGroup1()
    local groupConfig = getConfigFunc(group1)
    local ListView = SettingWinRange._ui.ListView_1
    for i, config in ipairs(groupConfig) do
        SettingWinRange.CreateProgressCell_1(ListView, config)
    end
    GUI:ListView_doLayout(ListView)
end

function SettingWinRange.initGroup2()
    local groupConfig = getConfigFunc(group2)
    local parent = SettingWinRange._ui.Image_2
    for i, config in ipairs(groupConfig) do
        SettingWinRange.CreateProgressCell(parent, config)
    end
end

function SettingWinRange.CreateProgressCell_1(parent, data)
    local Panel = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 686, 70, false)
    -- 描述
    local Text_desc = GUI:Text_Create(Panel, "Text_desc", 27, 41, 16, "#ffffff", data.content or "")
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    -- 滑动条
    local value = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    local Slider_progress = GUI:Slider_Create(Panel, "Slider_progress", 393, 40.99, "res/private/new_setting/bg_progress.png", "res/private/new_setting/bg_progress2.png", "res/private/new_setting/icon_xdtzy_17.png")
    GUI:setContentSize(Slider_progress, 500, 14)
    GUI:setIgnoreContentAdaptWithSize(Slider_progress, false)
    GUI:setAnchorPoint(Slider_progress, 0.5, 0.5)
    GUI:Slider_setPercent(Slider_progress, value or 0)

    local Text_desc_0 = GUI:Text_Create(Panel, "Text_desc_0", 143, 17, 16, "#ffffff", "短")
    GUI:setAnchorPoint(Text_desc_0, 0, 0.5)

    local Text_desc_1 = GUI:Text_Create(Panel, "Text_desc_1", 622, 17, 16, "#ffffff", "高")
    GUI:setAnchorPoint(Text_desc_1, 0, 0.5)

    GUI:Slider_addOnEvent(Slider_progress, function(_, eventType)
        if eventType == 0 then
            local percent = GUI:Slider_getPercent(Slider_progress)
            local value = math.floor((SL:GetMetaValue("SETTING_ENABLED", (data.id)) or 100) / 10) * 10
            local newValue = math.floor(percent / 10) * 10
            if math.abs(value - newValue) >= 10 then
                --设置新值
                SL:SetMetaValue("SETTING_VALUE", data.id, { newValue })
            end
        end
    end)

    return Panel
end

function SettingWinRange.CreateProgressCell(parent, data)
    local value = SL:GetMetaValue("SETTING_ENABLED", (data.id))
    local Panel = GUI:Layout_Create(parent, "Panel_" .. data.id, 0, 0, 686, 100, false)
    -- 描述
    local Text_desc = GUI:Text_Create(Panel, "Text_desc", 65, 65, 16, "#ffffff", string.format("%s(%.1f倍)", data.content, value))
    GUI:setAnchorPoint(Text_desc, 0, 0.5)

    --  滑动条
    local Slider_progress = GUI:Slider_Create(Panel, "Slider_progress", 65, 35, "res/private/new_setting/bg_progress.png", "res/private/new_setting/bg_progress2.png", "res/private/new_setting/icon_xdtzy_17.png")
    GUI:setContentSize(Slider_progress, 556, 14)
    GUI:setIgnoreContentAdaptWithSize(Slider_progress, false)
    GUI:setAnchorPoint(Slider_progress, 0, 0.5)
    GUI:Slider_setPercent(Slider_progress, SL:GetMetaValue("MAPSCALE_PER", value)) -- 地图缩放百分比

    GUI:Slider_addOnEvent(Slider_progress, function(_, eventType)
        if eventType == 0 then
            local percent = GUI:Slider_getPercent(Slider_progress)
            local value    = SL:GetMetaValue("SETTING_ENABLED", (data.id))
            local newValue = math.floor(SL:GetMetaValue("MAPSCALE_VALUE", percent) * 10) / 10
            if math.abs((math.round(value * 10) - math.round(newValue * 10))) >= 1 then
                --设置新值
                SL:SetMetaValue("SETTING_VALUE", data.id, { newValue })
                --刷新ui
                GUI:Text_setString(Text_desc, string.format("%s(%.1f倍)", data.content, newValue))
            end
        elseif eventType == 1 then--按下
            GUI:SetLayerMovingOpacity(true)
        elseif eventType == 2 then--抬起
            GUI:SetLayerMovingOpacity(false)
            SL:ReloadMap()
        end
    end)
end