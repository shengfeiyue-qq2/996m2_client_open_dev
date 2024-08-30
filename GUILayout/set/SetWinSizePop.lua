
SetWinSizePop = {}

SetWinSizePop._resolutions = {      -- 分辨率切换列表
    {width= 1920,   height = 1080},
    {width= 1600,   height = 1024},
    {width= 1600,   height = 900},
    {width= 1440,   height = 900},
    {width= 1366,   height = 768},
    {width= 1280,   height = 800},
    {width= 1280,   height = 768},
    {width= 1152,   height = 864},
    {width= 1024,   height = 768},
    {width= 800,    height = 600},
}

function SetWinSizePop.main()
    SetWinSizePop._parent = GUI:Win_Create(UIConst.LAYERID.SetWinSizeGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(SetWinSizePop._parent, "set/set_win_size_pop")
    SetWinSizePop._ui = GUI:ui_delegate(SetWinSizePop._parent)
    SetWinSizePop._curSize = SL:GetValue("PC_DESIGN_SIZE")
    SetWinSizePop.InitUI()
end

function SetWinSizePop.InitUI()
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(SetWinSizePop._ui.Panel_cancel, screenW, screenH)
    GUI:setPosition(SetWinSizePop._ui.PMainUI, screenW / 2, SL:GetValue("PC_POS_Y"))

    GUI:Win_SetDrag(SetWinSizePop._parent, SetWinSizePop._ui.PMainUI)
    GUI:Win_SetZPanel(SetWinSizePop._parent, SetWinSizePop._ui.PMainUI)
    
    GUI:Text_setString(SetWinSizePop._ui.Text_Resolution, SetWinSizePop._curSize.width.."x" .. SetWinSizePop._curSize.height)
    SetWinSizePop.InitShowList()
    ------------
    GUI:addOnClickEvent(SetWinSizePop._ui.Button_close, function()
        UIOperator:CloseResolutionSetUI()
    end)

    GUI:addOnClickEvent(SetWinSizePop._ui.Panel_cancel, function()
        if GUI:getVisible(SetWinSizePop._ui.Panel_show) then 
            SetWinSizePop.HideList()
        end
    end)
    GUI:setSwallowTouches(SetWinSizePop._ui.Panel_cancel, false)
    GUI:addOnClickEvent(SetWinSizePop._ui.Image_show, function()
        if not GUI:getVisible(SetWinSizePop._ui.Panel_show) then 
            SetWinSizePop.ShowList()
        end
    end)

    GUI:addOnClickEvent(SetWinSizePop._ui.Button_ok, function()
        local pcDesignSize = SL:GetValue("PC_DESIGN_SIZE")
        if SetWinSizePop._curSize.width ~= pcDesignSize.width or SetWinSizePop._curSize.height ~= pcDesignSize.height then 
            local index = 1
            for i,v in ipairs(SetWinSizePop._resolutions) do
                if SetWinSizePop._curSize.width == v.width and SetWinSizePop._curSize.height == v.height then 
                    index = i 
                    break
                end
            end
            SL:SetPCResolutionSize({size = SetWinSizePop._curSize, index = index})
        end
    end)
    
    return true
end

function SetWinSizePop.InitShowList()
    GUI:setVisible(SetWinSizePop._ui.Panel_show, false)
    GUI:setVisible(SetWinSizePop._ui.Panel_item, false)
    local itemSize = GUI:getContentSize(SetWinSizePop._ui.Panel_item) 
    local viewheight = itemSize.height * #SetWinSizePop._resolutions
    local viewSize =  GUI:getContentSize(SetWinSizePop._ui.Panel_show)
    GUI:setContentSize(SetWinSizePop._ui.Panel_show, viewSize.width, viewheight)
    GUI:setContentSize(SetWinSizePop._ui.ListView_1, viewSize.width, viewheight)
    GUI:setPosition(SetWinSizePop._ui.ListView_1, viewSize.width / 2, viewheight)
    for i,v in ipairs(SetWinSizePop._resolutions) do
        local item = GUI:Clone(SetWinSizePop._ui.Panel_item)
        GUI:setVisible(item, true)
        local Text_1 = GUI:getChildByName(item, "Text_1")
        GUI:Text_setString(Text_1, v.width.."x" .. v.height)
        GUI:addOnClickEvent(item, function()
            GUI:Text_setString(SetWinSizePop._ui.Text_Resolution, v.width.."x" .. v.height)
            SetWinSizePop._curSize = v
            SetWinSizePop.HideList()
        end)
        GUI:ListView_pushBackCustomItem(SetWinSizePop._ui.ListView_1, item)
    end
end

function SetWinSizePop.ShowList()
    GUI:setVisible(SetWinSizePop._ui.Panel_show, true)
    local items = GUI:ListView_getItems(SetWinSizePop._ui.ListView_1)
    for i,v in ipairs(items) do
        local Resolution = SetWinSizePop._resolutions[i]
        local Image_select = GUI:getChildByName(v, "Image_select")
        if Resolution.width == SetWinSizePop._curSize.width and Resolution.height == SetWinSizePop._curSize.height then 
            GUI:setVisible(Image_select, true)
        else
            GUI:setVisible(Image_select, false)
        end
    end
end

function SetWinSizePop.HideList()
    GUI:setVisible(SetWinSizePop._ui.Panel_show, false)
end

SetWinSizePop.main()