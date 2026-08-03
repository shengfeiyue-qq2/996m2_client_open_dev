LookPlayerTitle = {}
LookPlayerTitle._ui = nil

local isPC = SL:GetValue("IS_PC_OPER_MODE")

LookPlayerTitle._path = GUIDefine.PATH_RES_PRIVATE .. (isPC and "title_layer_ui_win32/" or "title_layer_ui/")

function LookPlayerTitle.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "player_look/player_title_node_win32" or "player_look/player_title_node")

    LookPlayerTitle._ui = GUI:ui_delegate(parent)
    if not LookPlayerTitle._ui then
        return false
    end

    LookPlayerTitle.InitUI()

    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.TitleO})
end

-- 界面关闭回调
function LookPlayerTitle.OnClose()
    -- 自定义组件卸载
    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.TitleO
    })
end

function LookPlayerTitle.InitUI()
    -- 已激活的称号
    local activeID = LookPlayerData.GetActiveTitle()

    LookPlayerTitle.RefCurTitle(activeID)

    LookPlayerTitle.RefTitleList(activeID)
end

-- 刷新当前穿戴
function LookPlayerTitle.RefCurTitle(activeID)
    local btnCurTitle = LookPlayerTitle._ui["Button_curTitle"]
    local lblCurTitle = LookPlayerTitle._ui["Text_curTitle"]

    GUI:setTouchEnabled(btnCurTitle, activeID ~= nil)

    if activeID then
        local res = TitleData.GetTitleActivateImage(activeID)
        GUI:Button_loadTextureNormal(btnCurTitle, res)
        GUI:Text_setString(lblCurTitle, SL:GetValue("ITEM_NAME", activeID))
        GUI:Text_setTextColor(lblCurTitle, SL:GetHexColorByStyleId(SL:GetValue("ITEM_NAME_COLORID", activeID)))
        GUI:Text_setFontSize(lblCurTitle,  18)
        GUI:setContentSize(btnCurTitle, GUI:getRemoteResImageSize(res))
    else
        local res = LookPlayerTitle._path .. "title_3.png"
        GUI:Button_loadTextureNormal(btnCurTitle, res)
        GUI:setContentSize(btnCurTitle, GUI:getRemoteResImageSize(res))
        GUI:Text_setString(lblCurTitle, "")
    end
    GUI:setIgnoreContentAdaptWithSize(btnCurTitle, false)
end

-- 刷新称号列表
function LookPlayerTitle.RefTitleList(activeID)
    -- 称号数据
    local titles = LookPlayerData.GetTitle()

    -- 称号列表
    local titleList = SL:HashToSortArray(titles, function(a, b)
        return a.index < b.index
    end)

    titleList = titleList or {}

    local list = LookPlayerTitle._ui["ListView_cells"]
    GUI:removeAllChildren(list)


    local cellPath = isPC and "player_look/title_cell_win32.lua" or "player_look/title_cell.lua"
    local cellSize = isPC and {width = 278, height = 42} or {width = 348, height = 55}

    local count = math.max(5, #titleList)
    for i = 1, count do
        local widget = GUI:Widget_Create(list, "title_cell_" .. i, 0, 0, cellSize.width, cellSize.height)
        GUI:LoadExport(widget, cellPath)
        local ui = GUI:ui_delegate(widget)

        local buttonIcon = ui.Button_icon
        GUI:setTouchEnabled(buttonIcon, false)
        if titleList[i] then
            GUI:setTouchEnabled(buttonIcon, true)
            local titleId = titleList[i].id
            local time = titleList[i].time
            local name = SL:GetValue("ITEM_NAME", titleId)
            local res  = TitleData.GetTitleListImage(titleId)
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, name)

            GUI:setContentSize(buttonIcon, GUI:getRemoteResImageSize(res))

            if titleId == activeID then
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
                data.job = SL:GetMetaValue("L.M.JOB")
                data.lookOther = true
                UIOperator:OpenTitleTipsUI(data)
            end

            if isPC then
                GUI:addMouseMoveEvent(buttonIcon,
                {
                    onEnterFunc = function()
                        if not SL:GetValue("TOUCH_STATE") then
                            showTips()
                        end
                    end,
                    onLeaveFunc = function()
                        UIOperator:CloseTitleTipsUI()-- 关闭称号提示界面
                    end
                }
                )
            else
                local function delayCallback()
                    if buttonIcon._doubleState then
                        showTips()
                        buttonIcon._doubleState = false
                    end
                end

                buttonIcon._doubleState = false
                GUI:addOnClickEvent(buttonIcon, function()
                    if not buttonIcon._doubleState then
                        buttonIcon._doubleState = true
                        SL:scheduleOnce(buttonIcon, delayCallback, GUIDefine.CLICK_DOUBLE_TIME)
                    else
                        buttonIcon._doubleState = false
                    end
                end)
            end
        else
            local res = LookPlayerTitle._path .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getRemoteResImageSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

LookPlayerTitle.main()