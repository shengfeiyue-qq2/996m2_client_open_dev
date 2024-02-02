PlayerTitle_Look = {}--查看他人面板 称号
PlayerTitle_Look._ui = nil

function PlayerTitle_Look.main(data)
    local parent = GUI:Attach_Parent()
    PlayerTitle_Look._resPath = SLDefine.PATH_RES_PRIVATE .. "title_layer_ui_win32/"
    GUI:LoadExport(parent, "player_look/player_title_node_win32")
    PlayerTitle_Look._parent = parent
    PlayerTitle_Look._ui = GUI:ui_delegate(parent)
    if not PlayerTitle_Look._ui then
        return false
    end
    PlayerTitle_Look.refresh()
end

function PlayerTitle_Look.refresh()
    --已激活的称号
    local activateId = SL:GetMetaValue("L.M.ACTIVATE_TITLE")
    local titleListData = SL:GetMetaValue("L.M.TITLES") --称号数据

    GUI:setTouchEnabled(PlayerTitle_Look._ui.Button_curTitle, activateId ~= nil)
    if activateId then
        local res = SL:GetMetaValue("TITLE_IMAGE", activateId)
        GUI:Button_loadTextureNormal(PlayerTitle_Look._ui.Button_curTitle, res)
        GUI:Text_setString(PlayerTitle_Look._ui.Text_curTitle, SL:GetMetaValue("ITEM_NAME", activateId))
        GUI:Text_setTextColor(PlayerTitle_Look._ui.Text_curTitle, SL:GetHexColorByStyleId(SL:GetMetaValue("ITEM_NAME_COLORID", activateId)))
        GUI:Text_setFontSize(PlayerTitle_Look._ui.Text_curTitle,  16 )
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(PlayerTitle_Look._ui.Button_curTitle, contentSize.width, contentSize.height)
        end
    else
        local res = PlayerTitle_Look._resPath .. "title_3.png"
        GUI:Button_loadTextureNormal(PlayerTitle_Look._ui.Button_curTitle, res)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(PlayerTitle_Look._ui.Button_curTitle, contentSize.width, contentSize.height)
        end
        GUI:Text_setString(PlayerTitle_Look._ui.Text_curTitle, "")
    end
    GUI:setIgnoreContentAdaptWithSize(PlayerTitle_Look._ui.Button_curTitle, false)

    GUI:removeAllChildren(PlayerTitle_Look._ui.ListView_cells)

    --称号列表
    local titleList = SL:HashToSortArray(titleListData, function(a, b)
        return a.index < b.index
    end)

    if not titleList then
        titleList = {}
    end

    local count = math.max(5, #titleList)
    local cellPath = "player_look/title_cell_win32.lua"
    for i = 1, count do
        local widget = GUI:Widget_Create(PlayerTitle_Look._ui.ListView_cells, "title_cell_" .. i, 0, 0, 278, 42)
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
                SL:OpenOtherTitleTipsUI(data)
            end

            local function activeTitle()
            end

            GUI:addMouseMoveEvent(buttonIcon,
            {
                onEnterFunc = function()
                    if not SL:GetMetaValue("TOUCH_STATE") then
                        showTips()
                    end
                end,
                onLeaveFunc = function()
                    SL:CloseOtherTitleTipsUI()-- 关闭称号提示界面
                end
            }
            )

            GUI:addOnClickEvent(buttonIcon, function()
                activeTitle()
            end)
        else
            local res = PlayerTitle_Look._resPath .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

return PlayerTitle_win32Layer