ReinAttr = ReinAttr or {}

ReinAttr._dataCells    = {}
ReinAttr._addAttrPoint = {}
ReinAttr._addCustNums  = {}
ReinAttr._key          = {"DC", "MC", "SC", "AC", "MAC", "HP", "MP", "Hit", "Speed"}

ReinAttr._canAttrPointNew = SL:GetValue("BONUS_POINT")
ReinAttr._bonusAbilList   = SL:GetValue("BONUS_ABIL_DATA")   --服务器传的已加点数
ReinAttr._bonusTickList   = SL:GetValue("BONUS_TICK_DATA")   --加点基底
ReinAttr._nakedAbilList   = SL:GetValue("BONUS_NAKED_ABIL_DATA")   --用于计算五属性加值
ReinAttr._adjustList      = SL:GetValue("BONUS_ADJUST_ABIL_DATA")  --计算前的基础属性值
--------------------------- 新版
ReinAttr._isNew           = SL:GetValue("IS_NEW_BOUNS")

ReinAttr._isWinMode       = SL:GetValue("IS_PC_OPER_MODE")
function ReinAttr.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.ReinAttrGUI) then
        return
    end
    ReinAttr._layer = GUI:Win_Create(UIConst.LAYERID.ReinAttrGUI, 0, 0, 0, 0, false, false, true, true)
    if ReinAttr._isWinMode then
        GUI:LoadExport(ReinAttr._layer, "rein_attr/rein_attr_panel_win32")
    else
        GUI:LoadExport(ReinAttr._layer, "rein_attr/rein_attr_panel")
    end
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    ReinAttr._ui = GUI:ui_delegate(ReinAttr._layer)
    if not ReinAttr._ui then
        return false
    end

    GUI:setPosition(ReinAttr._ui.Panel_1, screenW / 2, ReinAttr._isWinMode and SL:GetValue("PC_POS_Y") or screenH / 2)

    -- 可拖拽
    GUI:Win_SetDrag(ReinAttr._layer, ReinAttr._ui.Panel_1)
    --设置最高层级
    GUI:Win_SetZPanel(ReinAttr._layer, ReinAttr._ui.Panel_1)
    -- 属性行间隔 (旧版)
    ReinAttr._interval = ReinAttr._isWinMode and 2 or 4

    ReinAttr.InitUI()

    GUI:Text_setString(ReinAttr._ui.Text_tip, "你当前还有剩余部分属性点未分配。\n请根据自己的意向，调整自己的属性值。\n已分配属性点数，不可以重新分配。\n在分配时要小心选择。")

    GUI:addOnClickEvent(ReinAttr._ui.btn_close, function()
        UIOperator:CloseReinAttrUI()
    end)

    GUI:setVisible(ReinAttr._ui.Panel_data, not ReinAttr._isNew)
    GUI:setVisible(ReinAttr._ui.Image_3, not ReinAttr._isNew)

    if ReinAttr._ui.Panel_data_new then
        GUI:setVisible(ReinAttr._ui.Panel_data_new, ReinAttr._isNew)
        GUI:setVisible(ReinAttr._ui.Text_point, ReinAttr._isNew)

        -- 新版UI加载
        if ReinAttr._isNew then
            ReinAttr._itemSize = ReinAttr._isWinMode and {width = 280, height = 18} or {width = 410, height = 30}
            ReinAttr._quickCells = {}
            ReinAttr.InitData()
            ReinAttr.InitNewUI()
        end
    end
    ReinAttr.RegisterEvent()
end

function ReinAttr.InitData()
    local addData = SL:GetValue("NEW_BOUNS_ADD_DATA")
    addData = addData and addData.Bonus or {}
    ReinAttr._addReinPoint = {}
    ReinAttr._oriAddReinPoint = {}
    for _, data in ipairs(addData) do
        if data.id and data.value then
            ReinAttr._addReinPoint[data.id] = data.value
            ReinAttr._oriAddReinPoint[data.id] = data.value
        end
    end
    ReinAttr._config = SL:GetValue("NEW_BOUNS_CONFIG")
    ReinAttr._canAttrPointNew = SL:GetValue("BONUS_POINT")
end

function ReinAttr.InitNewUI()
    GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)
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
        SL:RequestAddReinAttrNew(data, ReinAttr._canAttrPointNew)
        UIOperator:CloseReinAttrUI()
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
    GUI:Text_setString(ui.Text_data, SL:GetValue("CUR_ABIL_BY_ID", id) or 0)
    
    local addValue = ReinAttr._addReinPoint[id] or 0
    local rate = config.nRate
    local showAdd = addValue % rate
    GUI:Text_setString(ui.Text_num, string.format("%s/%s", showAdd, rate))

    local maxAdd = config.nMax
    GUI:delayTouchEnabled(ui.btn_add)
    GUI:addOnClickEvent(ui.btn_add, function()
        local addValue = ReinAttr._addReinPoint[id] or 0
        local addShow = addValue % rate
        local curAdd = 0
        if ReinAttr._canAttrPointNew >= 10 and ReinAttr._isWinMode and SL:GetValue("CTRL_PRESSED") then --CTRL +10
            addShow = addShow + 10
            curAdd = 10
        else
            addShow = addShow + 1
            curAdd = 1
        end
        if ReinAttr._canAttrPointNew < 1 then
            return
        end
        -- 超出能使用的最大转生点
        if addValue + curAdd > maxAdd then
            return
        end
        
        addValue = addValue + curAdd
        ReinAttr._addReinPoint[id] = addValue
        ReinAttr._canAttrPointNew = ReinAttr._canAttrPointNew - curAdd

        if addShow >= rate then
            local lastAddP = (ReinAttr._oriAddReinPoint[id] or 0) % rate
            local value = addValue - (ReinAttr._oriAddReinPoint[id] or 0) + lastAddP
            local addAttrValue = math.floor(value / rate)
            addShow = addValue % rate
            local value = (SL:GetValue("CUR_ABIL_BY_ID", id) or 0) + addAttrValue
            GUI:Text_setString(ui.Text_data, value)
        end

        GUI:Text_setString(ui.Text_num, string.format("%s/%s", addShow, rate))
        GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)
    end)

    GUI:delayTouchEnabled(ui.btn_sub)
    GUI:addOnClickEvent(ui.btn_sub, function()
        local addValue = ReinAttr._addReinPoint[id] or 0
        local addShow = addValue % rate
        local curSub = 0
        if addShow >= 10 and ReinAttr._isWinMode and SL:GetValue("CTRL_PRESSED") then --CTRL -10
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
        ReinAttr._canAttrPointNew = ReinAttr._canAttrPointNew + curSub

        GUI:Text_setString(ui.Text_num, string.format("%s/%s", addShow, rate))
        GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)
    end)

    return cell
end

function ReinAttr.OnUpdateData()
    if ReinAttr._layer and ReinAttr._ui.Panel_data_new and ReinAttr._isNew then
        ReinAttr.InitData()
        for i, cell in pairs(ReinAttr._quickCells) do 
            GUI:QuickCell_Exit(cell)
            GUI:QuickCell_Refresh(cell)
        end
    end
end

function LoByte( value )
    local high_value = math.floor(value/256)
    high_value = high_value*256
    local low_value = value - high_value
    return low_value
end

function HiByte( value )
    local high_value = math.floor(value/256)
    return high_value
end

function AdjustAb(abil, val)
    local lo = LoByte(abil)
    local hi = HiByte(abil)
    local lov = 0
    local hiv = 0
    for i=1, val do
        if (lo+1 < hi) then
            lo = lo + 1
            if lo > 255 then
                lo = 0
            end
            lov = lov +1
        else
            hi = hi + 1
            if hi > 255 then
                hi = 0
            end
            hiv = hiv + 1
        end
    end

    return lov, hiv
end

function ReinAttr.InitUI()
    -- 旧版保持原状
    if not ReinAttr._isNew then
        local reinData = SL:GetValue("BONUS_DATAS")
        if not reinData or not next(reinData) then
            return
        end
        GUI:addOnClickEvent(ReinAttr._ui.btn_agree, function()
            --同意 
            local data = {}
            data.BonusAbil = {}
            for i = 1, 9 do
                if ReinAttr._addCustNums[i] then
                    data.BonusAbil[ReinAttr._key[i]] = ReinAttr._addCustNums[i]
                else
                    data.BonusAbil[ReinAttr._key[i]] = 0
                end
            end
            SL:RequestAddReinAttr(data, ReinAttr._canAttrPointNew)
            --清空
            ReinAttr._addCustNums = {}
            UIOperator:CloseReinAttrUI()
        end)
        GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)
        ReinAttr.InitDataPanel()
        ReinAttr.UpdateData()
        if nil == ReinAttr._timer then
            ReinAttr._timer = SL:Schedule(ReinAttr.Tick, 2.0)
        end
    end
end

function ReinAttr.getAttValue(key)
    local reinData = SL:GetValue("BONUS_DATAS")
    if not reinData or not next(reinData) then
        return
    end
    local abil = ReinAttr._nakedAbilList[ReinAttr._key[key]]
    local lowN, highN = 0,0
    if  ReinAttr._addAttrPoint[key]  and key >= 1 and key <= 5 then
        lowN, highN = AdjustAb(abil ,ReinAttr._addAttrPoint[key])
    end

    local addNum = 0
    if key > 5 and key <= 9 and ReinAttr._addAttrPoint[key] then
        addNum = ReinAttr._addAttrPoint[key]
    end

    local str = ""
    local min = 0
    local max = 0
    if key >= 1 and key <= 5 then
        min = ReinAttr._adjustList[ReinAttr._key[key].."1"] + lowN
        max = ReinAttr._adjustList[ReinAttr._key[key].."2"] + highN
        str = string.format("%d-%d", min, max)
    elseif key == 6 then
        min = SL:GetValue("HP")
        max = ReinAttr._adjustList[ReinAttr._key[key]] + addNum
        str = string.format("%s/%s", min, max)
    elseif key == 7 then
        min = SL:GetValue("MP")
        max = ReinAttr._adjustList[ReinAttr._key[key]] + addNum
        str = string.format("%s/%s", min, max)
    else -- 准确、敏捷得到的不是基础值
        str = ReinAttr._adjustList[ReinAttr._key[key]] + addNum
    end

    return str
end

function ReinAttr.InitDataPanel()
    GUI:setVisible(ReinAttr._ui.Panel_cell, false)

    local max = 9
    for i= 1, max do
        local data_cell = GUI:Clone(ReinAttr._ui.Panel_cell)
        local cell_ui = ui_delegate(data_cell)
        ReinAttr.InitAssignPoint(cell_ui, i)

        GUI:addOnClickEvent(cell_ui.btn_add, function()
            local str = GUI:Text_getString(cell_ui.Text_num)
            local num1 = tonumber(string.split(str, "/")[1])
            local num2 = tonumber(string.split(str, "/")[2])

            local curAdd = 0
            if ReinAttr._canAttrPointNew >= 10 and ReinAttr._isWinMode and SL:GetValue("CTRL_PRESSED") then --CTRL+ 10
                num1 = num1 + 10
                curAdd = 10
            else
                num1 = num1 + 1
                curAdd = 1
            end

            if  ReinAttr._canAttrPointNew < 1 then
                return false
            end
            if num1 >= tonumber(num2) then
                local addRealPoint = math.floor(num1 / num2)
                num1 = num1 % num2
                if nil == ReinAttr._addAttrPoint[i] then
                    ReinAttr._addAttrPoint[i] = addRealPoint
                else
                    ReinAttr._addAttrPoint[i] = ReinAttr._addAttrPoint[i] + addRealPoint
                end
                GUI:Text_setString(cell_ui.Text_data, ReinAttr.getAttValue(i))
            end

            if nil ==  ReinAttr._addCustNums[i] then
                ReinAttr._addCustNums[i] = curAdd
            else
                ReinAttr._addCustNums[i] = ReinAttr._addCustNums[i] + curAdd
            end
            
            ReinAttr._canAttrPointNew = ReinAttr._canAttrPointNew - curAdd
            GUI:Text_setString(cell_ui.Text_num, num1 .. "/" .. num2)
            GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)
        end)


        GUI:addOnClickEvent(cell_ui.btn_sub, function()
            local str = GUI:Text_getString(cell_ui.Text_num)
            local num1 = tonumber(string.split(str, "/")[1])
            local num2 = tonumber(string.split(str, "/")[2])

            local curSub = 0
            if num1 >= 10 and ReinAttr._isWinMode and SL:GetValue("CTRL_PRESSED") then --CTRL- 10
                num1 = num1 - 10
                curSub = 10
            else
                num1 = num1 - 1
                curSub = 1
            end
            
            if num1 < 0 then
                return false
            end
            if not ReinAttr._addCustNums[i] or ReinAttr._addCustNums[i] <= 0 then
                return 
            end
            ReinAttr._addCustNums[i] = ReinAttr._addCustNums[i] - curSub

            ReinAttr._canAttrPointNew = ReinAttr._canAttrPointNew + curSub
            GUI:Text_setString(cell_ui.Text_num, num1 .. "/" .. num2)
            GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)
        end)
        GUI:Text_setString(cell_ui.Text_data, ReinAttr.getAttValue(i))
        local cellSize = GUI:getContentSize(data_cell)
        GUI:setPositionY(data_cell, (max-i) * (cellSize.height + (ReinAttr._interval or 4)))
        GUI:setVisible(data_cell, true)
        ReinAttr._dataCells[i] = data_cell
        GUI:addChild(ReinAttr._ui.Panel_data, data_cell)
    end

end

function ReinAttr.InitAssignPoint(cell_ui, index)
    local reinData = SL:GetValue("BONUS_DATAS")
    if not reinData or not next(reinData) then
        return
    end

    local serverAdd = ReinAttr._bonusAbilList[ReinAttr._key[index]]

    local max = ReinAttr._bonusTickList[ReinAttr._key[index]]
    local add = serverAdd % max
    local str = string.format("%s/%s", add, max)
    GUI:Text_setString(cell_ui.Text_num, str)
end

function ReinAttr.Tick()
    for i,v in ipairs(ReinAttr._dataCells) do
        local textNode = GUI:getChildByName(v, "Text_data")
        GUI:Text_setString(textNode, ReinAttr.getAttValue(i))
    end
end

function ReinAttr.UpdateData()
    
    ReinAttr._canAttrPointNew = SL:GetValue("BONUS_POINT")
    GUI:Text_setString(ReinAttr._ui.attr_pointN, ReinAttr._canAttrPointNew)

    ReinAttr._bonusAbilList = SL:GetValue("BONUS_ABIL_DATA")
    ReinAttr._bonusTickList = SL:GetValue("BONUS_TICK_DATA")
    ReinAttr._nakedAbilList = SL:GetValue("BONUS_NAKED_ABIL_DATA")
    ReinAttr._adjustList    = SL:GetValue("BONUS_ADJUST_ABIL_DATA")

    for i= 1, 9 do
        local curNum  = tonumber(ReinAttr._bonusAbilList[ReinAttr._key[i]])
        local baseNum = tonumber(ReinAttr._bonusTickList[ReinAttr._key[i]])
        ReinAttr._addAttrPoint[i] = math.floor(curNum / baseNum)

        if i == 8 or i == 9 then
            ReinAttr._addAttrPoint[i] = 0
        end
    end

    ReinAttr.Tick()
end

function ReinAttr.OnCloseWin(id)
    if id ~= UIConst.LAYERID.ReinAttrGUI then
        return
    end
    if ReinAttr._timer then
        SL:UnSchedule(ReinAttr._timer)
        ReinAttr._timer = nil
    end
    ReinAttr.RemoveEvent()
    ReinAttr._layer = nil
end

function ReinAttr.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ReinAttr", ReinAttr.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_REIN_ATTR_CHANGE, "ReinAttr", ReinAttr.OnUpdateData, ReinAttr._layer)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "ReinAttr", ReinAttr.OnUpdateData, ReinAttr._layer)
end

function ReinAttr.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "ReinAttr")
end

ReinAttr.main()