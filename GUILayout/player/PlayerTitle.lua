PlayerTitle = {}
PlayerTitle._ui = nil

local isPC = SL:GetValue("IS_PC_OPER_MODE")

PlayerTitle._path = GUIDefine.PATH_RES_PRIVATE .. (isPC and "title_layer_ui_win32/" or "title_layer_ui/")

function PlayerTitle.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    if GUI:Win_IsNull(parent) then
        return false
    end
    GUI:LoadExport(parent, isPC and "player/player_title_node_win32" or "player/player_title_node")

    PlayerTitle._parent = parent
    PlayerTitle._ui = GUI:ui_delegate(parent)
    if not PlayerTitle._ui then
        return false
    end

    PlayerTitle._listView = PlayerTitle._ui["ListView_cells"]
    if PlayerFrame and PlayerFrame.typeCapture == 1 then
        GUI:ListView_setClippingEnabled(PlayerTitle._listView,false)
        PlayerExtraAtt.manyHeight = 0
    end
    
    PlayerTitle.RegistEvent()

    -- 请求称号列表
    SL:RequestTitleList()

    PlayerTitle.InitUI()

    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.Title})
end

-- 界面关闭回调
function PlayerTitle.OnClose()
    PlayerTitle.UnRegisterEvent()

    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.Title
    })
end

function PlayerTitle.RegistEvent()
    SL:RegisterLUAEvent(LUA_EVENT_TITLE_REFRESH, "PlayerTitle", PlayerTitle.OnRefresh)
end

-- 取消事件
function PlayerTitle.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_TITLE_REFRESH, "PlayerTitle")
end

function PlayerTitle.InitUI()
    local function showTips()
        -- 获取激活的称号
        local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.PLAYER)
        local data = {}
        data.id = activeID
        data.pos = GUI:getWorldPosition(PlayerTitle._ui["Button_curTitle"])
        data.type = 2
        UIOperator:OpenTitleTipsUI(data)
    end

    local function disboardTitle()
        -- 获取激活的称号
        local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.PLAYER)
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
        GUI:addMouseMoveEvent(PlayerTitle._ui["Button_curTitle"],
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
    
        GUI:addOnClickEvent(PlayerTitle._ui["Button_curTitle"], function()
            -- 获取激活的称号
            local activateID = TitleData.GetActiveTitle(GUIDefine.TitleType.PLAYER)
            if activateID then
                disboardTitle()
            end
        end)
    else
        local function delayCallback()
            if PlayerTitle._ui["Button_curTitle"]._doubleState then
                showTips()
                PlayerTitle._ui["Button_curTitle"]._doubleState = false
            end
        end
        PlayerTitle._ui["Button_curTitle"]._doubleState = false

        GUI:addOnClickEvent(PlayerTitle._ui["Button_curTitle"], function()
            if not PlayerTitle._ui["Button_curTitle"]._doubleState then
                PlayerTitle._ui["Button_curTitle"]._doubleState = true
                SL:scheduleOnce(PlayerTitle._ui["Button_curTitle"], delayCallback, GUIDefine.CLICK_DOUBLE_TIME)
            else
                disboardTitle()
                PlayerTitle._ui["Button_curTitle"]._doubleState = false
            end
        end)
    end
end

function PlayerTitle.OnRefresh()
    -- 已激活的称号
    local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.PLAYER)

    PlayerTitle.RefCurTitle(activeID)

    PlayerTitle.RefTitleList(activeID)
end

-- 刷新当前穿戴
function PlayerTitle.RefCurTitle(activeID)
    local btnCurTitle = PlayerTitle._ui["Button_curTitle"]
    local lblCurTitle = PlayerTitle._ui["Text_curTitle"]

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
        local res = PlayerTitle._path .. "title_3.png"
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
function PlayerTitle.RefTitleList(activeID)
    -- 称号数据
    local titles = TitleData.GetTitleList(GUIDefine.TitleType.PLAYER)

    -- 称号列表
    local titleList = SL:HashToSortArray(titles, function(a, b)
        return a.index < b.index
    end)

    titleList = titleList or {}

    local curItems = GUI:ListView_getItems(PlayerTitle._listView)
    local curItemsCount = #curItems
    local count = math.max(5, #titleList)
    if curItemsCount > count then 
        for i = count, curItemsCount - 1 do
            GUI:ListView_removeItemByIndex(PlayerTitle._listView,i)
        end
    elseif curItemsCount < count then 
        local cellPath = isPC and "player/title_cell_win32.lua" or "player/title_cell.lua"
        local cellSize = isPC and {width = 278, height = 42} or {width = 348, height = 55}
        for i = curItemsCount+1,count  do
            local widget = GUI:Widget_Create(PlayerTitle._listView, "title_cell_" .. i, 0, 0, cellSize.width, cellSize.height)
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
                UIOperator:OpenTitleTipsUI(data)
            end

            local function activeTitle()
                if not buttonIcon._data then 
                    return
                end
                local titleId = buttonIcon._data.id
                local activeID = TitleData.GetActiveTitle(GUIDefine.TitleType.PLAYER)
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
        local widget = GUI:ListView_getItemByIndex(PlayerTitle._listView,i-1)
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
            local res = PlayerTitle._path .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
    GUI:ListView_doLayout(PlayerTitle._listView)
    local manyHeight = GUI:ListView_getInnerContainerSize(PlayerTitle._listView).height - GUI:getContentSize(PlayerTitle._listView).height
    PlayerTitle.manyHeight = math.max(0, manyHeight)
end

PlayerTitle.main()