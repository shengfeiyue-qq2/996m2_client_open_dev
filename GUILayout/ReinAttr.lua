
ReinAttr = {}

function ReinAttr.main()
    local parent = GUI:Attach_Parent()

    ReinAttr._isWinMode = SL:GetMetaValue("WINPLAYMODE")
    if ReinAttr._isWinMode then
        GUI:LoadExport(parent, "rein_attr/rein_attr_panel_win32")
    else
        GUI:LoadExport(parent, "rein_attr/rein_attr_panel")
    end

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    ReinAttr._ui = GUI:ui_delegate(parent)
    GUI:setPosition(ReinAttr._ui.Panel_1, screenW / 2, ReinAttr._isWinMode and SL:GetMetaValue("PC_POS_Y") or screenH / 2)

    -- 可拖拽
    GUI:Win_SetDrag(parent, ReinAttr._ui.Panel_1)
    GUI:Win_SetZPanel(parent, ReinAttr._ui.Panel_1)

    -- 属性行间隔 (旧版)
    ReinAttr._interval = SL:GetMetaValue("WINPLAYMODE") and 2 or 4

    GUI:Text_setString(ReinAttr._ui.Text_tip, "你当前还有剩余部分属性点未分配。\n请根据自己的意向，调整自己的属性值。\n已分配属性点数，不可以重新分配。\n在分配时要小心选择。")

    GUI:addOnClickEvent(ReinAttr._ui.btn_close, function()
        SL:CloseReinAttrUI()
    end)

    local isNew = SL:GetMetaValue("IS_NEW_BOUNS")
    GUI:setVisible(ReinAttr._ui.Panel_data, not isNew)
    GUI:setVisible(ReinAttr._ui.Image_3, not isNew)

    if ReinAttr._ui.Panel_data_new then
        GUI:setVisible(ReinAttr._ui.Panel_data_new, isNew)
        GUI:setVisible(ReinAttr._ui.Text_point, isNew)

        -- 新版UI加载
        if isNew then
            ReinAttr._itemSize = ReinAttr._isWinMode and {width = 280, height = 18} or {width = 410, height = 30}
            ReinAttr._quickCells = {}
            ReinAttr.InitData()
            ReinAttr.InitNewUI()
            ReinAttr.RegisterEvent()
        end
    end
end

function ReinAttr.InitData()
    local addData = SL:GetMetaValue("NEW_BOUNS_ADD_DATA")
    addData = addData and addData.Bonus or {}

    ReinAttr._addReinPoint = {}
    ReinAttr._oriAddReinPoint = {}
    for _, data in ipairs(addData) do
        if data.id and data.value then
            ReinAttr._addReinPoint[data.id] = data.value
            ReinAttr._oriAddReinPoint[data.id] = data.value
        end
    end

    ReinAttr._config = SL:GetMetaValue("NEW_BOUNS_CONFIG")
    ReinAttr._canAttrPointN = SL:GetMetaValue("BONUSPOINT")
end

function ReinAttr.InitNewUI()
    
    GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointN)

    if not ReinAttr._config or not next(ReinAttr._config) then
        return
    end

    for _, config in ipairs(ReinAttr._config) do
        local function createCell(parent)
            local cell = ReinAttr.CreateNewAttrItemCell(parent, config) 
            return cell 
        end
        local quickCell = GUI:QuickCell_Create(ReinAttr._ui.ListView_data, "item_" .. config.nId, 0, 0, ReinAttr._itemSize.width, ReinAttr._itemSize.height, createCell)
        ReinAttr._quickCells[config.nId] = quickCell
    end

    -- 同意
    GUI:addOnClickEvent(ReinAttr._ui.btn_agree, function()
        local data = {}
        data.Bonus = {}
        for id, value in pairs(ReinAttr._addReinPoint) do
            if value > 0 then
                table.insert(data.Bonus, {id = id, value = value})
            end
        end
        if #data.Bonus == 0 then
            return
        end

        SL:RequestAddReinAttr_N(data, ReinAttr._canAttrPointN)

        SL:CloseReinAttrUI()
    end)
    
end

function ReinAttr.CreateNewAttrItemCell(parent, config)
    if ReinAttr._isWinMode then
        GUI:LoadExport(parent, "rein_attr/rein_attr_cell_n_win32")
    else
        GUI:LoadExport(parent, "rein_attr/rein_attr_cell_n")
    end

    local cell = GUI:getChildByName(parent, "Panel_cell_new")
    local ui = GUI:ui_delegate(parent)

    local id = config.nId
    -- 属性名
    GUI:Text_setString(ui.Text_title, config.sName)
    -- 属性值
    GUI:Text_setString(ui.Text_data, SL:GetMetaValue("ATT_BY_TYPE", id) or 0)
    
    local addValue = ReinAttr._addReinPoint[id] or 0
    local rate = config.nRate
    local showAdd = addValue % rate
    GUI:Text_setString(ui.Text_num, string.format("%s/%s", showAdd, rate))

    local maxAdd = config.nMax
    GUI:addOnClickEvent(ui.btn_add, function()
        local addValue = ReinAttr._addReinPoint[id] or 0
        local addShow = addValue % rate
        local curAdd = 0
        if ReinAttr._canAttrPointN >= 10 and ReinAttr._isWinMode and SL:GetMetaValue("CTRL_PRESSED") then --CTRL +10
            addShow = addShow + 10
            curAdd = 10
        else
            addShow = addShow + 1
            curAdd = 1
        end
        if ReinAttr._canAttrPointN < 1 then
            return
        end
        -- 超出能使用的最大转生点
        if addValue + curAdd > maxAdd then
            return
        end
        
        addValue = addValue + curAdd
        ReinAttr._addReinPoint[id] = addValue
        ReinAttr._canAttrPointN = ReinAttr._canAttrPointN - curAdd

        if addShow >= rate then
            local lastAddP = (ReinAttr._oriAddReinPoint[id] or 0) % rate
            local value = addValue - (ReinAttr._oriAddReinPoint[id] or 0) + lastAddP
            local addAttrValue = math.floor(value / rate)
            addShow = addValue % rate
            local value = (SL:GetMetaValue("ATT_BY_TYPE", id) or 0) + addAttrValue
            GUI:Text_setString(ui.Text_data, value)
        end

        GUI:Text_setString(ui.Text_num, string.format("%s/%s", addShow, rate))
        GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointN)

        GUI:delayTouchEnabled(ui.btn_add)
    end)

    GUI:addOnClickEvent(ui.btn_sub, function()
        local addValue = ReinAttr._addReinPoint[id] or 0
        local addShow = addValue % rate
        local curSub = 0
        if addShow >= 10 and ReinAttr._isWinMode and SL:GetMetaValue("CTRL_PRESSED") then --CTRL -10
            addShow = addShow - 10
            curSub = 10
        else
            addShow = addShow - 1
            curSub = 1
        end
        if addShow < 0 then
            return
        end
        
        addValue = addValue - curSub
        ReinAttr._addReinPoint[id] = addValue
        ReinAttr._canAttrPointN = ReinAttr._canAttrPointN + curSub

        GUI:Text_setString(ui.Text_num, string.format("%s/%s", addShow, rate))
        GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointN)

        GUI:delayTouchEnabled(ui.btn_sub)
    end)

    return cell
end

function ReinAttr.OnUpdateData()
    ReinAttr.InitData()

    for i, cell in pairs(ReinAttr._quickCells) do 
        GUI:QuickCell_Exit(cell)
        GUI:QuickCell_Refresh(cell)
    end 
end

function ReinAttr.OnCloseWin(ID)
    if ID == "ReinAttrGUI" then
        ReinAttr.RemoveEvent()
    end
end

function ReinAttr.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ReinAttr", ReinAttr.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_REIN_ATTR_CHANGE, "ReinAttr", ReinAttr.OnUpdateData)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "ReinAttr", ReinAttr.OnUpdateData)
end

function ReinAttr.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ReinAttr")
    SL:UnRegisterLUAEvent(LUA_EVENT_REIN_ATTR_CHANGE, "ReinAttr")
    SL:UnRegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "ReinAttr")
end