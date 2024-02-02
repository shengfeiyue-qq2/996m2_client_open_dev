PlayerTitle = {}--角色面板 称号
PlayerTitle._ui = nil

function PlayerTitle.main(data)
    local parent = GUI:Attach_Parent()
    local path = "player/player_title_node.lua"
    PlayerTitle._resPath = SLDefine.PATH_RES_PRIVATE .. "title_layer_ui/"

    GUI:LoadExport(parent, path)
    PlayerTitle._parent = parent
    PlayerTitle._ui = GUI:ui_delegate(parent)
    if not PlayerTitle._ui then
        return false
    end
    PlayerTitle.initUI()
end


function PlayerTitle.initUI(data)
    SL:ResquestTitleList()--请求称号列表
    local function showTips()
        local activateId = SL:GetMetaValue("ACTIVATE_TITLE")--获取激活的称号
        local data = {}
        data.id = activateId
        data.pos = GUI:getWorldPosition(PlayerTitle._ui.Button_curTitle)
        data.type = 2
        SL:OpenTitleTipsUI(data)
    end

    local function disboardTitle()
        local activateId = SL:GetMetaValue("ACTIVATE_TITLE")--获取激活的称号
        if activateId then
            local data = {}
            data.str = "是否取消当前称号？"
            data.btnType = 2
            data.callback = function(type, custom)
                if 1 == type then
                    SL:ResquestDisboardTitle()
                end
            end
            SL:OpenCommonTipsPop(data)
        end
    end
    
    local function delayCallback()
        if PlayerTitle._ui.Button_curTitle._doubleState then
            showTips()
            PlayerTitle._ui.Button_curTitle._doubleState = false
        end
    end
    PlayerTitle._ui.Button_curTitle._doubleState = false

    GUI:addOnClickEvent(PlayerTitle._ui.Button_curTitle, function()
        if not PlayerTitle._ui.Button_curTitle._doubleState then
            PlayerTitle._ui.Button_curTitle._doubleState = true
            SL:scheduleOnce(PlayerTitle._ui.Button_curTitle, delayCallback, SLDefine.CLICK_DOUBLE_TIME)
        else
            disboardTitle()
            PlayerTitle._ui.Button_curTitle._doubleState = false
        end
    end)
    
end

function PlayerTitle.refresh()
    --已激活的称号
    local activateId = SL:GetMetaValue("ACTIVATE_TITLE")
    local titleListData = SL:GetMetaValue("TITLES") --称号数据

    GUI:setTouchEnabled(PlayerTitle._ui.Button_curTitle, activateId ~= nil)
    if activateId then
        local res = SL:GetMetaValue("TITLE_IMAGE", activateId)
        GUI:Button_loadTextureNormal(PlayerTitle._ui.Button_curTitle, res)
        GUI:Text_setString(PlayerTitle._ui.Text_curTitle, SL:GetMetaValue("ITEM_NAME", activateId))
        GUI:Text_setTextColor(PlayerTitle._ui.Text_curTitle, SL:GetHexColorByStyleId(SL:GetMetaValue("ITEM_NAME_COLORID", activateId)))
        GUI:Text_setFontSize(PlayerTitle._ui.Text_curTitle,  18)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(PlayerTitle._ui.Button_curTitle, contentSize.width, contentSize.height)
        end
    else
        local res = PlayerTitle._resPath .. "title_3.png"
        GUI:Button_loadTextureNormal(PlayerTitle._ui.Button_curTitle, res)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(PlayerTitle._ui.Button_curTitle, contentSize.width, contentSize.height)
        end
        GUI:Text_setString(PlayerTitle._ui.Text_curTitle, "")
    end
    GUI:setIgnoreContentAdaptWithSize(PlayerTitle._ui.Button_curTitle, false)


    --称号列表
    local titleList = SL:HashToSortArray(titleListData, function(a, b)
        return a.index < b.index
    end)

    if not titleList then
        titleList = {}
    end
    

    local count = math.max(5, #titleList)
    local curItems =  GUI:ListView_getItems(PlayerTitle._ui.ListView_cells)
    local curItemsCount = #curItems
    if curItemsCount > count then 
        for i = count,curItemsCount - 1 do
            GUI:ListView_removeItemByIndex(PlayerTitle._ui.ListView_cells,i)
        end
    elseif curItemsCount < count then 
        local cellPath = "player/title_cell.lua"
        for i = curItemsCount+1,count  do
            local widget = GUI:Widget_Create(PlayerTitle._ui.ListView_cells, "title_cell_" .. i, 0, 0, 348, 55)
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
                SL:OpenTitleTipsUI(data)
            end

            local function activeTitle()
                if not buttonIcon._data then 
                    return
                end
                local titleId = buttonIcon._data.id
                local activateId = SL:GetMetaValue("ACTIVATE_TITLE")
                if titleId == activateId then
                    return
                end
                local name = SL:GetMetaValue("ITEM_NAME", titleId)
                local data = {}
                data.str = string.format("是否将%s设置为当前称号？", name)
                data.btnType = 2
                data.callback = function(type, custom)
                    if 1 == type then
                        SL:ResquestActivateTitle(titleId)
                    end
                end
                SL:OpenCommonTipsPop(data)
            end

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
                    SL:scheduleOnce(buttonIcon, delayCallback, SLDefine.CLICK_DOUBLE_TIME)
                else
                    activeTitle()
                    buttonIcon._doubleState = false
                end
            end)
        end
    end

    for i = 1, count do
        local widget = GUI:ListView_getItemByIndex(PlayerTitle._ui.ListView_cells,i-1)
        local ui = GUI:ui_delegate(widget)
        local buttonIcon = ui.Button_icon
        GUI:setTouchEnabled(buttonIcon, false)
        if titleList[i] then
            GUI:setTouchEnabled(buttonIcon, true)
            buttonIcon._data = titleList[i]
            local titleId = buttonIcon._data.id
            local time = buttonIcon._data.time
            local name = SL:GetMetaValue("ITEM_NAME", titleId)
            local res = SL:GetMetaValue("TITLE_LIST_IMAGE", titleId)
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, name)


            local contentSize = GUI:getImageContentSize(res)
            if contentSize.width > 0 then
                GUI:setContentSize(buttonIcon, contentSize)
            end

            if titleId == activateId then
                GUI:Button_setGrey(buttonIcon, true)
            else
                GUI:Button_setGrey(buttonIcon, false)
            end
            buttonIcon._doubleState = false
        else
            buttonIcon._data = nil
            local res = PlayerTitle._resPath .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

return PlayerTitle