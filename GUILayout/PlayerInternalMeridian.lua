PlayerInternalMeridian = {}

PlayerInternalMeridian._ui = nil
PlayerInternalMeridian._defType = 2 -- 默认冲脉

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

function PlayerInternalMeridian.main()
    local parent = GUI:Attach_Parent()
    PlayerInternalMeridian._isWIN32 = SL:GetMetaValue("WINPLAYMODE")
    PlayerInternalMeridian._resPath = "res/private/internal/meridian_ui/"
    if PlayerInternalMeridian._isWIN32 then
        GUI:LoadExport(parent, "internal_player/internal_meridian_node_win32")
        PlayerInternalMeridian._resPath = "res/private/internal_win32/meridian_ui/"
    else
        GUI:LoadExport(parent, "internal_player/internal_meridian_node")
    end

    PlayerInternalMeridian._init = {}
    PlayerInternalMeridian._selType = nil
    PlayerInternalMeridian._ui = GUI:ui_delegate(parent)
    if not PlayerInternalMeridian._ui then
        return false
    end

    PlayerInternalMeridian.InitUIData()

    local function refreshBtnShow()
        for i = 1, 5 do
            if not PlayerInternalMeridian._selType and PlayerInternalMeridian._openList[real_typeID[i]] then
                PlayerInternalMeridian._selType = i
            end
            local btn = PlayerInternalMeridian._ui["Button_" .. i]
            if btn then
                GUI:setVisible(btn, PlayerInternalMeridian._openList[real_typeID[i]])
                GUI:Button_setBright(btn, PlayerInternalMeridian._selType == i)
            end
            if PlayerInternalMeridian._ui["Panel_show_" .. i] then
                GUI:setVisible(PlayerInternalMeridian._ui["Panel_show_" .. i], PlayerInternalMeridian._selType == i)
            end
        end
        if not PlayerInternalMeridian._selType then
            PlayerInternalMeridian._selType = 1
        end
    end

    for i = 1, 5 do
        if PlayerInternalMeridian._ui["Button_"..i] then
            GUI:addOnClickEvent(PlayerInternalMeridian._ui["Button_" .. i], function()
                PlayerInternalMeridian._selType = i
                refreshBtnShow()
                PlayerInternalMeridian.RefreshShowPanel()
            end)
        end

        local panel = PlayerInternalMeridian._ui["Panel_show_" .. i]
        local buttonUp = GUI:getChildByName(panel, "Button_up")
        if buttonUp then
            GUI:addOnClickEvent(buttonUp, function()
                local typeID = real_typeID[i]
                SL:RequestMeridianLevelUp(typeID)
            end)
        end
    end

    if PlayerInternalMeridian._defType and PlayerInternalMeridian._openList[real_typeID[PlayerInternalMeridian._defType]] then
        PlayerInternalMeridian._selType = PlayerInternalMeridian._defType
    end
    refreshBtnShow()
    -- 固定文本尺寸
    GUI:Text_setTextAreaSize(PlayerInternalMeridian._ui.Text_show, PlayerInternalMeridian._isWIN32 and {width = 12, height = 60} or {width = 16, height = 76})
    if PlayerInternalMeridian._show then
        PlayerInternalMeridian.RefreshShowPanel()
    end

    PlayerInternalMeridian.RegisterEvent()
end

function PlayerInternalMeridian.InitUIData()
    PlayerInternalMeridian._openList = SL:GetMetaValue("MERIDIAN_OPEN_LIST")
    PlayerInternalMeridian._show = false
    for _, i in ipairs(real_typeID) do
        if PlayerInternalMeridian._openList[i] then
            PlayerInternalMeridian._show = true
            break
        end
    end
    -- 内容展示
    GUI:setVisible(PlayerInternalMeridian._ui.Panel_content, PlayerInternalMeridian._show)
end

function PlayerInternalMeridian.RefreshShowPanel()
    local function GetBgResPath()
        if PlayerInternalMeridian._selType == 2 then
            return string.format("m_bg1_%s.png", SL:GetMetaValue("SEX"))
        end
        return string.format("m_bg0_%s.png", SL:GetMetaValue("SEX"))
    end
    local path = (PlayerInternalMeridian._isWIN32 and "res/private/internal_win32/" or "res/private/internal/").. GetBgResPath()
    GUI:Image_loadTexture(PlayerInternalMeridian._ui.Image_show, path)
    local lv = SL:GetMetaValue("MERIDIAN_LV", real_typeID[PlayerInternalMeridian._selType])
    GUI:setVisible(PlayerInternalMeridian._ui.Text_show, lv > 0)
    if lv > 0 then
        GUI:Text_setString(PlayerInternalMeridian._ui.Text_show, string.format("%s重经络", SL:NumberToChinese(lv)))
    end
    GUI:Image_loadTexture(PlayerInternalMeridian._ui.Image_m, PlayerInternalMeridian._resPath .. string.format("%s_%02d.png", title_strs[PlayerInternalMeridian._selType], math.min(lv, 5)))
    GUI:Image_loadTexture(PlayerInternalMeridian._ui.Image_l, PlayerInternalMeridian._resPath .. string.format("%s_xing.png", title_strs[PlayerInternalMeridian._selType]))
    GUI:Image_loadTexture(PlayerInternalMeridian._ui.Image_icon, PlayerInternalMeridian._resPath .. string.format("%s.png", PlayerInternalMeridian._selType))

    local showPanel = PlayerInternalMeridian._ui["Panel_show_" .. PlayerInternalMeridian._selType]
    local ui = GUI:ui_delegate(showPanel)
    for i = 1, 5 do
        local realID = real_typeID[PlayerInternalMeridian._selType]
        local openState = SL:GetMetaValue("MERIDIAN_AUCPOINT_STATE", realID)
        local isOpen = tonumber(openState and openState[i]) == 1
        GUI:Button_setBright(ui["point_" .. i], not isOpen)
        local function showTips(sender)
            local pos = GUI:getTouchBeganPosition(sender)
            local index = (realID - 1) * 5 + i
            local openState = SL:GetMetaValue("MERIDIAN_AUCPOINT_STATE", realID)
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
                            SL:RequestAucPointOpen(realID, i)
                        end
                    }
                end
                SL:OpenCommonDescTipsPop(data)
            end

            if PlayerInternalMeridian._selType == 1 and i == 1 and isOpen then -- 奇经-神冲 已激活
                -- Open 奇经修炼界面
            end
        end
        if not PlayerInternalMeridian._init[PlayerInternalMeridian._selType] then
            GUI:addOnClickEvent(ui["point_" .. i], showTips)
            GUI:setTouchEnabled(ui["Text_" .. i], true)
            GUI:addOnClickEvent(ui["Text_" .. i], showTips)
        end
    end
    PlayerInternalMeridian._init[PlayerInternalMeridian._selType] = true
end

function PlayerInternalMeridian.OnRefreshShow()
    PlayerInternalMeridian.InitUIData()

    local _selType = nil
    for i = 1, 5 do
        if not _selType and PlayerInternalMeridian._openList[real_typeID[i]] then
            _selType = i
            break
        end
    end
    if _selType and PlayerInternalMeridian._selType and not PlayerInternalMeridian._openList[real_typeID[PlayerInternalMeridian._selType]] then
        PlayerInternalMeridian._selType = _selType
    end
    for i = 1, 5 do
        local btn = PlayerInternalMeridian._ui["Button_" .. i]
        if btn then
            GUI:setVisible(btn, PlayerInternalMeridian._openList[real_typeID[i]])
            GUI:Button_setBright(btn, PlayerInternalMeridian._selType == i)
        end
        if PlayerInternalMeridian._ui["Panel_show_" .. i] then
            GUI:setVisible(PlayerInternalMeridian._ui["Panel_show_" .. i], PlayerInternalMeridian._selType == i)
        end
    end

    if PlayerInternalMeridian._show then
        PlayerInternalMeridian.RefreshShowPanel()
    end
end

function PlayerInternalMeridian.OnClose()
    PlayerInternalMeridian.UnRegisterEvent()
end

-----------------------------------注册事件--------------------------------------
function PlayerInternalMeridian.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MERIDIAN_DATA_REFRESH, "PlayerInternalMeridian", PlayerInternalMeridian.OnRefreshShow)
end

function PlayerInternalMeridian.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MERIDIAN_DATA_REFRESH, "PlayerInternalMeridian")
end