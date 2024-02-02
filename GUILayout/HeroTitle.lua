HeroTitle = {} --英雄面板 称号
HeroTitle._ui = nil

function HeroTitle.main(data)
    local parent = GUI:Attach_Parent()
    local path = "hero/hero_title_node.lua"
    HeroTitle._resPath = SLDefine.PATH_RES_PRIVATE .. "title_layer_ui/"

    GUI:LoadExport(parent, path)
    HeroTitle._parent = parent
    HeroTitle._ui = GUI:ui_delegate(parent)
    if not HeroTitle._ui then
        return false
    end
    HeroTitle.initUI()
end


function HeroTitle.initUI(data)
    SL:ResquestTitleList_Hero()--请求称号列表
    local function showTips()
        local activateId = SL:GetMetaValue("H.ACTIVATE_TITLE")--获取激活的称号
        local data = {}
        data.id = activateId
        data.pos = GUI:getWorldPosition(HeroTitle._ui.Button_curTitle)
        data.type = 2
        SL:OpenTitleTipsUI(data)
    end

    local function disboardTitle()
        local activateId = SL:GetMetaValue("H.ACTIVATE_TITLE")--获取激活的称号
        if activateId then
            local data = {}
            data.str = "是否取消当前称号？"
            data.btnType = 2
            data.callback = function(type, custom)
                if 1 == type then
                    SL:ResquestDisboardTitle_Hero()
                end
            end
            SL:OpenCommonTipsPop(data)
        end
    end
    
    local function delayCallback()
        if HeroTitle._ui.Button_curTitle._doubleState then
            showTips()
            HeroTitle._ui.Button_curTitle._doubleState = false
        end
    end
    HeroTitle._ui.Button_curTitle._doubleState = false

    GUI:addOnClickEvent(HeroTitle._ui.Button_curTitle, function()
        if not HeroTitle._ui.Button_curTitle._doubleState then
            HeroTitle._ui.Button_curTitle._doubleState = true
            SL:scheduleOnce(HeroTitle._ui.Button_curTitle, delayCallback, SLDefine.CLICK_DOUBLE_TIME)
        else
            disboardTitle()
            HeroTitle._ui.Button_curTitle._doubleState = false
        end
    end)
    
end

function HeroTitle.refresh()
    --已激活的称号
    local activateId = SL:GetMetaValue("H.ACTIVATE_TITLE")
    local titleListData = SL:GetMetaValue("H.TITLES") --称号数据

    GUI:setTouchEnabled(HeroTitle._ui.Button_curTitle, activateId ~= nil)
    if activateId then
        local res = SL:GetMetaValue("TITLE_IMAGE", activateId)
        GUI:Button_loadTextureNormal(HeroTitle._ui.Button_curTitle, res)
        GUI:Text_setString(HeroTitle._ui.Text_curTitle, SL:GetMetaValue("ITEM_NAME", activateId))
        GUI:Text_setTextColor(HeroTitle._ui.Text_curTitle, SL:GetHexColorByStyleId(SL:GetMetaValue("ITEM_NAME_COLORID", activateId)))
        GUI:Text_setFontSize(HeroTitle._ui.Text_curTitle,  18)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(HeroTitle._ui.Button_curTitle, contentSize.width, contentSize.height)
        end
    else
        local res = HeroTitle._resPath .. "title_3.png"
        GUI:Button_loadTextureNormal(HeroTitle._ui.Button_curTitle, res)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(HeroTitle._ui.Button_curTitle, contentSize.width, contentSize.height)
        end
        GUI:Text_setString(HeroTitle._ui.Text_curTitle, "")
    end
    GUI:setIgnoreContentAdaptWithSize(HeroTitle._ui.Button_curTitle, false)

    GUI:removeAllChildren(HeroTitle._ui.ListView_cells)

    --称号列表
    local titleList = SL:HashToSortArray(titleListData, function(a, b)
        return a.index < b.index
    end)

    if not titleList then
        titleList = {}
    end

    local count = math.max(5, #titleList)
    local cellPath = "player/title_cell.lua"
    for i = 1, count do
        local widget = GUI:Widget_Create(HeroTitle._ui.ListView_cells, "title_cell_" .. i, 0, 0, 348, 55)
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
                        SL:ResquestActivateTitle_Hero(titleId)
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
                if not buttonIcon._doubleState then
                    buttonIcon._doubleState = true
                    SL:scheduleOnce(buttonIcon, delayCallback, SLDefine.CLICK_DOUBLE_TIME)
                else
                    activeTitle()
                    buttonIcon._doubleState = false
                end
            end)

        else
            local res = HeroTitle._resPath .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

return PlayerTitleLayer