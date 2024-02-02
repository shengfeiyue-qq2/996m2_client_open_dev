HeroInternalMeridian = {}

HeroInternalMeridian._ui = nil
HeroInternalMeridian._defType = 2 -- 默认冲脉

local title_strs = {
    [1] = "qijing",
    [2] = "chongmai",
    [3] = "yinqiao",
    [4] = "yinwei",
    [5] = "renmai"
}

local real_typeID = {
    [1] = 5,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4,
}

function HeroInternalMeridian.main()
    local parent = GUI:Attach_Parent()
    HeroInternalMeridian._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    HeroInternalMeridian._resPath = "res/private/internal/meridian_ui/"
    if HeroInternalMeridian._isWIN32 then
        GUI:LoadExport(parent, "internal_hero/internal_meridian_node_win32")
        HeroInternalMeridian._resPath = "res/private/internal_win32/meridian_ui/"
    else
        GUI:LoadExport(parent, "internal_hero/internal_meridian_node")
    end

    HeroInternalMeridian._init = {}
    HeroInternalMeridian._selType = nil
    HeroInternalMeridian._ui = GUI:ui_delegate(parent)
    if not HeroInternalMeridian._ui then
        return false
    end

    HeroInternalMeridian.InitUIData()

    local function refreshBtnShow()
        for i = 1, 5 do
            if not HeroInternalMeridian._selType and HeroInternalMeridian._openList[real_typeID[i]] then
                HeroInternalMeridian._selType = i
            end
            local btn = HeroInternalMeridian._ui["Button_" .. i]
            if btn then
                GUI:setVisible(btn, HeroInternalMeridian._openList[real_typeID[i]])
                GUI:Button_setBright(btn, HeroInternalMeridian._selType == i)
            end
            if HeroInternalMeridian._ui["Panel_show_"..i] then
                GUI:setVisible(HeroInternalMeridian._ui["Panel_show_"..i], HeroInternalMeridian._selType == i)
            end
        end
        if not HeroInternalMeridian._selType then
            HeroInternalMeridian._selType = 1
        end
    end

    for i = 1, 5 do
        if HeroInternalMeridian._ui["Button_"..i] then
            GUI:addOnClickEvent(HeroInternalMeridian._ui["Button_"..i], function()
                HeroInternalMeridian._selType = i
                refreshBtnShow()
                HeroInternalMeridian.RefreshShowPanel()
            end)
        end

        local panel = HeroInternalMeridian._ui["Panel_show_" .. i]
        local buttonUp = GUI:getChildByName(panel, "Button_up")
        if buttonUp then
            GUI:addOnClickEvent(buttonUp, function()
                local typeID = real_typeID[i]
                SL:RequestMeridianLevelUp(typeID, true)
            end)
        end
    end

    if HeroInternalMeridian._defType and HeroInternalMeridian._openList[real_typeID[HeroInternalMeridian._defType]] then
        HeroInternalMeridian._selType = HeroInternalMeridian._defType
    end
    refreshBtnShow()
    -- 固定文本尺寸
    GUI:Text_setTextAreaSize(HeroInternalMeridian._ui.Text_show, HeroInternalMeridian._isWIN32 and {width = 12, height = 60} or {width = 16, height = 76})
    if HeroInternalMeridian._show then
        HeroInternalMeridian.RefreshShowPanel()
    end

    HeroInternalMeridian.RegisterEvent()
end

function HeroInternalMeridian.InitUIData()
    HeroInternalMeridian._openList = SL:GetMetaValue("H.MERIDIAN_OPEN_LIST")
    HeroInternalMeridian._show = false
    for _, i in ipairs(real_typeID) do
        if HeroInternalMeridian._openList[i] then
            HeroInternalMeridian._show = true
            break
        end
    end
    -- 内容展示
    GUI:setVisible(HeroInternalMeridian._ui.Panel_content, HeroInternalMeridian._show)
end

function HeroInternalMeridian.RefreshShowPanel()
    local function GetBgResPath()
        if HeroInternalMeridian._selType == 2 then
            return string.format("m_bg1_%s.png", SL:GetMetaValue("H.SEX"))
        end
        return string.format("m_bg0_%s.png", SL:GetMetaValue("H.SEX"))
    end
    local path = (HeroInternalMeridian._isWIN32 and "res/private/internal_win32/" or "res/private/internal/").. GetBgResPath()
    GUI:Image_loadTexture(HeroInternalMeridian._ui.Image_show, path)
    local lv = SL:GetMetaValue("H.MERIDIAN_LV", real_typeID[HeroInternalMeridian._selType])
    GUI:setVisible(HeroInternalMeridian._ui.Text_show, lv > 0)
    if lv > 0 then
        GUI:Text_setString(HeroInternalMeridian._ui.Text_show, string.format("%s重经络", SL:NumberToChinese(lv)))
    end
    GUI:Image_loadTexture(HeroInternalMeridian._ui.Image_m, HeroInternalMeridian._resPath .. string.format("%s_%02d.png", title_strs[HeroInternalMeridian._selType], math.min(lv, 5)))
    GUI:Image_loadTexture(HeroInternalMeridian._ui.Image_l, HeroInternalMeridian._resPath .. string.format("%s_xing.png", title_strs[HeroInternalMeridian._selType]))
    GUI:Image_loadTexture(HeroInternalMeridian._ui.Image_icon, HeroInternalMeridian._resPath .. string.format("%s.png", HeroInternalMeridian._selType))
    
    local showPanel = HeroInternalMeridian._ui["Panel_show_" .. HeroInternalMeridian._selType]
    local ui = GUI:ui_delegate(showPanel)
    for i = 1, 5 do
        local realID = real_typeID[HeroInternalMeridian._selType]
        local openState = SL:GetMetaValue("H.MERIDIAN_AUCPOINT_STATE", realID)
        local isOpen = tonumber(openState and openState[i]) == 1
        GUI:Button_setBright(ui["point_" .. i], not isOpen)
        local function showTips(sender)
            local pos = GUI:getTouchBeganPosition(sender)
            local index = (realID - 1) * 5 + i
            local openState = SL:GetMetaValue("H.MERIDIAN_AUCPOINT_STATE", realID)
            local isOpen = tonumber(openState and openState[i]) == 1
            local descList = SL:GetMetaValue("MERIDIAN_DESC")
            if descList and descList[index] then
                local tips =  isOpen and descList[index].openTips or descList[index].unableTips 
                local data = {}
                data.str = tips or ""
                data.worldPos = pos
                data.anchorPoint = {x = 0, y = 0}
                data.formatWay = 1
                if not isOpen then
                    data.btnShow = {
                        btnRes = "res/public/1900000679.png",
                        btnName = "激活",
                        clickFunc = function()
                            SL:RequestAucPointOpen(realID, i, true)
                        end
                    }
                end
                SL:OpenCommonDescTipsPop(data)
            end
            if HeroInternalMeridian._selType == 1 and i == 1 and isOpen then -- 奇经-神冲 已激活
                -- Open 奇经修炼界面
            end
        end
        if not HeroInternalMeridian._init[HeroInternalMeridian._selType] then
            GUI:addOnClickEvent(ui["point_" .. i], showTips)
            GUI:setTouchEnabled(ui["Text_" .. i], true)
            GUI:addOnClickEvent(ui["Text_" .. i], showTips)
        end
    end
    HeroInternalMeridian._init[HeroInternalMeridian._selType] = true
end

function HeroInternalMeridian.OnRefreshShow()
    HeroInternalMeridian.InitUIData()

    local _selType = nil
    for i = 1, 5 do
        if not _selType and HeroInternalMeridian._openList[real_typeID[i]] then
            _selType = i
            break
        end
    end
    if _selType and HeroInternalMeridian._selType and not HeroInternalMeridian._openList[real_typeID[HeroInternalMeridian._selType]] then
        HeroInternalMeridian._selType = _selType
    end
    for i = 1, 5 do
        local btn = HeroInternalMeridian._ui["Button_" .. i]
        if btn then
            GUI:setVisible(btn, HeroInternalMeridian._openList[real_typeID[i]])
            GUI:Button_setBright(btn, HeroInternalMeridian._selType == i)
        end
        if HeroInternalMeridian._ui["Panel_show_" .. i] then
            GUI:setVisible(HeroInternalMeridian._ui["Panel_show_" .. i], HeroInternalMeridian._selType == i)
        end
    end

    if HeroInternalMeridian._show then
        HeroInternalMeridian.RefreshShowPanel()
    end
end

function HeroInternalMeridian.OnClose()
    HeroInternalMeridian.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function HeroInternalMeridian.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_MERIDIAN_DATA_REFRESH, "HeroInternalMeridian", HeroInternalMeridian.OnRefreshShow)
end

function HeroInternalMeridian.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_MERIDIAN_DATA_REFRESH, "HeroInternalMeridian")
end