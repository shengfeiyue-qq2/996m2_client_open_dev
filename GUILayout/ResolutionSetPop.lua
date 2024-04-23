ResolutionSetPop = {}

local cfgs = {
    {width = 1920, height = 1080},
    {width = 1600, height = 1024},
    {width = 1600, height = 900},
    {width = 1440, height = 900},
    {width = 1366, height = 768},
    {width = 1280, height = 800},
    {width = 1280, height = 768},
    {width = 1152, height = 864},
    {width = 1024, height = 768}
}

ResolutionSetPop._curSize = nil

function ResolutionSetPop.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "resolution/resolution_set_pop")

    ResolutionSetPop._ui = GUI:ui_delegate(parent)
    if not ResolutionSetPop._ui then
        return false
    end

    local PMainUI = ResolutionSetPop._ui["PMainUI"]
    GUI:Win_SetDrag(parent, PMainUI)                                                      
    GUI:setMouseEnabled(PMainUI, true)

    local size = SL:GetMetaValue("SCREEN_DESIGN_SIZE")
    ResolutionSetPop._curSize = size

    GUI:setSwallowTouches(ResolutionSetPop._ui["pnlTouch"], false)

    GUI:Text_setString(ResolutionSetPop._ui["txtResolution"], size.width .. "x" .. size.height)
    
    ResolutionSetPop.InitEvent()

    ResolutionSetPop.InitShowList()
end

function ResolutionSetPop.InitEvent()
    -- 关闭按钮
    GUI:addOnClickEvent(ResolutionSetPop._ui["btnClose"], function ()
        SL:CloseResolutionSetUI()
    end)

    GUI:addOnClickEvent(ResolutionSetPop._ui["PMainUI"], function ()
        ResolutionSetPop.SetListVisible(false)
    end)

    GUI:addOnClickEvent(ResolutionSetPop._ui["pnlTouch"], function ()
        ResolutionSetPop.SetListVisible(false)
    end)

    GUI:addOnClickEvent(ResolutionSetPop._ui["imgShow"], function ()
        ResolutionSetPop.UpdateList()
        ResolutionSetPop.SetListVisible(not GUI:getVisible(ResolutionSetPop._ui["pnlShow"]))
    end)
    
    GUI:addOnClickEvent(ResolutionSetPop._ui["btnOk"], function ()
        ResolutionSetPop.OnSave()
    end)
end

function ResolutionSetPop.InitShowList()
    ResolutionSetPop.SetListVisible(false)
    GUI:setVisible(ResolutionSetPop._ui["item"], false)

    for i, size in ipairs(cfgs) do
        local item = GUI:Clone(ResolutionSetPop._ui["item"])
        GUI:ListView_pushBackCustomItem(ResolutionSetPop._ui["ListView_1"], item)
        GUI:setVisible(item, true)

        GUI:Text_setString(GUI:getChildByName(item, "Text"), size.width .. "x" .. size.height)

        GUI:addOnClickEvent(item, function ()
            GUI:Text_setString(ResolutionSetPop._ui["txtResolution"], size.width .. "x" .. size.height)
            ResolutionSetPop._curSize = size
            ResolutionSetPop.SetListVisible(false)
        end)
    end
end

function ResolutionSetPop.OnSave()
    if ResolutionSetPop._curSize.width == SL:GetMetaValue("SCREEN_DESIGN_SIZE").width and ResolutionSetPop._curSize.height == SL:GetMetaValue("SCREEN_DESIGN_SIZE").height then
        return false
    end

    for index, size in ipairs(cfgs) do
        if ResolutionSetPop._curSize.width == size.width and ResolutionSetPop._curSize.height == size.height then 
            SL:SetResolutionSize({size = size, index = index})
            break
        end
    end
end

function ResolutionSetPop.SetListVisible(visible)
    GUI:setVisible(ResolutionSetPop._ui["pnlShow"], visible)
end

function ResolutionSetPop.UpdateList()
    local items = GUI:ListView_getItems(ResolutionSetPop._ui["ListView_1"])
    local index = 1
    for i, item in ipairs(items) do
        local size = cfgs[i]
        local imgSelect = GUI:getChildByName(item, "imgSelect")
        local text      = GUI:getChildByName(item, "Text")
        if size.width ==  ResolutionSetPop._curSize.width and size.height ==  ResolutionSetPop._curSize.height then
            GUI:Text_setTextColor(text, "#9D0000")
            GUI:setVisible(imgSelect, true)
            index = i
        else
            GUI:Text_setTextColor(text, "#FFFFFF")
            GUI:setVisible(imgSelect, false)
        end
    end

    if index > 6 then
        GUI:ListView_jumpToItem(ResolutionSetPop._ui["ListView_1"], index - 1) 
    end
end