HeroTitle = {}
HeroTitle._ui = nil

local isPC = SL:GetValue("IS_PC_OPER_MODE")

HeroTitle._path = GUIDefine.PATH_RES_PRIVATE .. (isPC and "title_layer_ui_win32/" or "title_layer_ui/")

function HeroTitle.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "hero/hero_title_node_win32" or "hero/hero_title_node")

    HeroTitle._parent = parent
    HeroTitle._ui = GUI:ui_delegate(parent)
    if not HeroTitle._ui then
        return false
    end

    HeroTitle._listView = HeroTitle._ui["ListView_cells"]

    HeroTitle.RegistEvent()

    -- 请求称号列表
    SL:RequestTitleList()

    HeroTitle.InitUI()

    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.Title_hero})
end

-- 界面关闭回调
function HeroTitle.OnClose()
    HeroTitle.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.Title_hero
    })
end

function HeroTitle.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_HERO_TITLE_REFRESH, "HeroTitle", HeroTitle.OnRefresh)
end

-- 取消事件
function HeroTitle.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_HERO_TITLE_REFRESH, "HeroTitle")
end

function HeroTitle.InitUI()
    local function showTips()
        -- 获取激活的称号
        local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.HERO)
        local data = {}
        data.id = activeID
        data.pos = GUI:getWorldPosition(HeroTitle._ui["Button_curTitle"])
        data.type = 2
        data.job = SL:GetValue("H.JOB")
        UIOperator:OpenTitleTipsUI(data)
    end

    local function disboardTitle()
        -- 获取激活的称号
        local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.HERO)
        if activeID then
            local data = {}
            data.str = "是否取消当前称号？"
            data.btnType = 2
            data.callback = function(type, custom)
                if 1 == type then
                    SL:RequestDisboardTitle()
                end
            end
            UIOperator:OpenCommonTipsUI(data)
        end
    end

    if isPC then
        GUI:addMouseMoveEvent(HeroTitle._ui["Button_curTitle"],
        {
            onEnterFunc = function()
                if not SL:GetValue("TOUCH_STATE") then
                    showTips()
                end
            end,
            onLeaveFunc = function()
                -- 关闭称号提示界面
                UIOperator:CloseTitleTipsUI()
            end
        }
        )
    
        GUI:addOnClickEvent(HeroTitle._ui["Button_curTitle"], function()
            -- 获取激活的称号
            local activateID = TitleData.GetActiveTitle(GUIDefine.TitleType.HERO)
            if activateID then
                disboardTitle()
            end
        end)
    else
        local function delayCallback()
            if HeroTitle._ui["Button_curTitle"]._doubleState then
                showTips()
                HeroTitle._ui["Button_curTitle"]._doubleState = false
            end
        end
        HeroTitle._ui["Button_curTitle"]._doubleState = false

        GUI:addOnClickEvent(HeroTitle._ui["Button_curTitle"], function()
            if not HeroTitle._ui["Button_curTitle"]._doubleState then
                HeroTitle._ui["Button_curTitle"]._doubleState = true
                SL:scheduleOnce(HeroTitle._ui["Button_curTitle"], delayCallback, GUIDefine.CLICK_DOUBLE_TIME)
            else
                disboardTitle()
                HeroTitle._ui["Button_curTitle"]._doubleState = false
            end
        end)
    end
end

function HeroTitle.OnRefresh()
    -- 已激活的称号
    local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.HERO)

    HeroTitle.RefCurTitle(activeID)

    HeroTitle.RefTitleList(activeID)
end

-- 刷新当前穿戴
function HeroTitle.RefCurTitle(activeID)
    local btnCurTitle = HeroTitle._ui["Button_curTitle"]
    local lblCurTitle = HeroTitle._ui["Text_curTitle"]

    GUI:setTouchEnabled(btnCurTitle, activeID ~= nil)

    if activeID then
        local res = TitleData.GetTitleActivateImage(activeID)
        GUI:Button_loadTextureNormal(btnCurTitle, res)
        GUI:Text_setString(lblCurTitle, SL:GetValue("ITEM_NAME", activeID))
        GUI:Text_setTextColor(lblCurTitle, SL:GetHexColorByStyleId(SL:GetValue("ITEM_NAME_COLORID", activeID)))
        GUI:Text_setFontSize(lblCurTitle,  18)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(btnCurTitle, contentSize.width, contentSize.height)
        end
    else
        local res = HeroTitle._path .. "title_3.png"
        GUI:Button_loadTextureNormal(btnCurTitle, res)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(btnCurTitle, contentSize.width, contentSize.height)
        end
        GUI:Text_setString(lblCurTitle, "")
    end
    GUI:setIgnoreContentAdaptWithSize(btnCurTitle, false)
end

-- 刷新称号列表
function HeroTitle.RefTitleList(activeID)
    -- 称号数据
    local titles = TitleData.GetTitleList(GUIDefine.TitleType.HERO)

    -- 称号列表
    local titleList = SL:HashToSortArray(titles, function(a, b)
        return a.index < b.index
    end)

    titleList = titleList or {}

    local curItems = GUI:ListView_getItems(HeroTitle._listView)
    local curItemsCount = #curItems
    local count = math.max(5, #titleList)
    if curItemsCount > count then 
        for i = count, curItemsCount - 1 do
            GUI:ListView_removeItemByIndex(HeroTitle._listView,i)
        end
    elseif curItemsCount < count then 
        local cellPath = isPC and "hero/title_cell_win32.lua" or "hero/title_cell.lua"
        local cellSize = isPC and {width = 278, height = 42} or {width = 348, height = 55}
        for i = curItemsCount+1,count  do
            local widget = GUI:Widget_Create(HeroTitle._listView, "title_cell_" .. i, 0, 0, cellSize.width, cellSize.height)
            GUI:LoadExport(widget, cellPath)

            local ui = GUI:ui_delegate(widget)
            local buttonIcon = ui.Button_icon
            local function showTips()
                if not buttonIcon._data then 
                    return
                end
                local titleId = buttonIcon._data.id
                local time = buttonIcon._data.time
                local data = {}
                data.id = titleId
                data.pos = GUI:getWorldPosition(buttonIcon)
                data.type = 1
                data.time = time
                data.job = SL:GetValue("H.JOB")
                UIOperator:OpenTitleTipsUI(data)
            end

            local function activeTitle()
                if not buttonIcon._data then 
                    return
                end
                local titleId = buttonIcon._data.id
                local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.HERO)
                if titleId == activeID then
                    return
                end
                local name = SL:GetValue("ITEM_NAME", titleId)
                local data = {}
                data.str = string.format("是否将%s设置为当前称号？", name)
                data.btnType = 2
                data.callback = function(type, custom)
                    if 1 == type then
                        SL:RequestActivateTitle(titleId)
                    end
                end
                UIOperator:OpenCommonTipsUI(data)
            end

            if isPC then
                GUI:addMouseMoveEvent(buttonIcon,
                {
                    onEnterFunc = function()
                        if not buttonIcon._data then 
                            return
                        end
                        if not SL:GetValue("TOUCH_STATE") then
                            showTips()
                        end
                    end,
                    onLeaveFunc = function()
                        -- 关闭称号提示界面
                        UIOperator:CloseTitleTipsUI()
                    end
                })
                GUI:addOnClickEvent(buttonIcon, function()
                    activeTitle()
                end)
            else
                local function delayCallback()
                    if buttonIcon._doubleState then
                        showTips()
                        buttonIcon._doubleState = false
                    end
                end
                buttonIcon._doubleState = false
                GUI:addOnClickEvent(buttonIcon, function()
                    if not buttonIcon._data then 
                        return
                    end
                    if not buttonIcon._doubleState then
                        buttonIcon._doubleState = true
                        SL:scheduleOnce(buttonIcon, delayCallback, GUIDefine.CLICK_DOUBLE_TIME)
                    else
                        activeTitle()
                        buttonIcon._doubleState = false
                    end
                end)
            end
        end
    end

    for i = 1, count do
        local widget = GUI:ListView_getItemByIndex(HeroTitle._listView,i-1)
        local ui = GUI:ui_delegate(widget)
        local buttonIcon = ui.Button_icon
        GUI:setTouchEnabled(buttonIcon, false)
        if titleList[i] then
            GUI:setTouchEnabled(buttonIcon, true)
            buttonIcon._data = titleList[i]
            local titleId = buttonIcon._data.id
            local time = buttonIcon._data.time
            local name = SL:GetValue("ITEM_NAME", titleId)
            local res = TitleData.GetTitleListImage(titleId)
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, name)


            local contentSize = GUI:getImageContentSize(res)
            if contentSize.width > 0 then
                GUI:setContentSize(buttonIcon, contentSize)
            end

            if titleId == activeID then
                GUI:Button_setGrey(buttonIcon, true)
            else
                GUI:Button_setGrey(buttonIcon, false)
            end
            buttonIcon._doubleState = false
        else
            buttonIcon._data = nil
            local res = HeroTitle._path .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

HeroTitle.main()