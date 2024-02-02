PlayerTitle = {}--角色面板 称号
PlayerTitle._ui = nil

function PlayerTitle.main(data)
    local parent = GUI:Attach_Parent()
    PlayerTitle._resPath = SLDefine.PATH_RES_PRIVATE .. "title_layer_ui_win32/"
    GUI:LoadExport(parent, "player/player_title_node_win32")
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

    GUI:addMouseMoveEvent(PlayerTitle._ui.Button_curTitle,
    {
        onEnterFunc = function()
            if not SL:GetMetaValue("TOUCH_STATE") then
                showTips()
            end
        end,
        onLeaveFunc = function()
            SL:CloseTitleTipsUI()-- 关闭称号提示界面
        end
    }
    )

    GUI:addOnClickEvent(PlayerTitle._ui.Button_curTitle, function()
        local activateId = SL:GetMetaValue("ACTIVATE_TITLE")--获取激活的称号
        if activateId then
            disboardTitle()
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
        GUI:Text_setFontSize(PlayerTitle._ui.Text_curTitle,  16 )
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

    GUI:removeAllChildren(PlayerTitle._ui.ListView_cells)

    --称号列表
    local titleList = SL:HashToSortArray(titleListData, function(a, b)
        return a.index < b.index
    end)

    if not titleList then
        titleList = {}
    end

    local count = math.max(5, #titleList)
    local cellPath = "player/title_cell_win32.lua"
    for i = 1, count do
        local widget = GUI:Widget_Create(PlayerTitle._ui.ListView_cells, "title_cell_" .. i, 0, 0, 278, 42)
        GUI:LoadExport(widget, cellPath)
        local ui = GUI:ui_delegate(widget)

        local buttonIcon = ui.Button_icon
        GUI:setTouchEnabled(buttonIcon, false)
        if titleList[i] then
            GUI:setTouchEnabled(buttonIcon, true)
            local titleId = titleList[i].id
            local time = titleList[i].time
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

            local function showTips()
                local data = {}
                data.id = titleId
                data.pos = GUI:getWorldPosition(buttonIcon)
                data.type = 1
                data.time = time
                SL:OpenTitleTipsUI(data)
            end

            local function activeTitle()
                if titleId == activateId then
                    return
                end
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

            GUI:addMouseMoveEvent(buttonIcon,
            {
                onEnterFunc = function()
                    if not SL:GetMetaValue("TOUCH_STATE") then
                        showTips()
                    end
                end,
                onLeaveFunc = function()
                    SL:CloseTitleTipsUI()-- 关闭称号提示界面
                end
            }
            )

            GUI:addOnClickEvent(buttonIcon, function()
                activeTitle()
            end)
        else
            local res = PlayerTitle._resPath .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

return PlayerTitle_win32Layer