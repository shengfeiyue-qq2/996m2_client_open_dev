SettingHero = {}

function SettingHero.main()
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height
    --------------------------------------------------------------------------------------------------------------------------

    -- ScrollView 容器
    local FrameList = GUI:ScrollView_Create(parent, "FrameList", 0, 0, attachW, attachH, 1)

    -------------------------------------------------保护设置-------------------------------------------------------------
    local TitleText1 = GUI:Text_Create(FrameList, "TitleText1", 15, 0, 18, "#f8e6c6", "保护设置")
    local ihh = 50

    local barimg = "res/public/bg_szjm_01.png"
    local pbarimg = "res/public/bg_szjm_02.png"
    local nimg = "res/private/setting_basic/icon_xdtzy_17.png"

    if not (GUIShare.SetCfg and GUIShare.SetCfg.SetHeroCfg) then
        return false
    end

    local iRow = 2
    local itemWidth = (attachW - 40) / iRow
    local itemHeight= 70
    local controls = {}
    local ihh = 0
    local num = 0
    for idx,data in ipairs(GUIShare.SetCfg.SetHeroCfg[1]) do
        if data then
            local id = data.id
            local CheckBox = GUI:CheckBox_Create(FrameList, "CheckBox"..id, 0, 0, "res/public/1900000550.png", "res/public/1900000551.png")

            local cdCfg     = GUIShare.FindEatCDByIndex(id)
            local maxCD     = cdCfg.maxCD
            local minCD     = cdCfg.minCD
            local defaultCD = cdCfg.CD

            local values = SL:GetSettingValue(id)
            local isSelected = values[1] == 1
            local percent = values[2] or 50
            local cdtime  = values[3] or defaultCD
            
            -- 描述
            local Text_desc = GUI:RichText_Create(CheckBox, "RichText", 15, 25, string.format(data.content, percent), 300, 16, "#FFFFFF")

            -- 滑动条
            local slider = GUI:Slider_Create(CheckBox, "slider", 35, 7, barimg, pbarimg, nimg)
            GUI:setContentSize(slider, cc.size(185, 14))
            GUI:Slider_setPercent(slider, percent)
            GUI:Win_SetParam(slider, {_ID = id, _content = data.content})
            GUI:Slider_addOnEvent(slider, SettingHero.onSliderEvent)
            GUI:addOnClickEvent(slider, SettingHero.onSliderClickEvent)

            -- 输入框
            local input = SettingHero.onCreateInput(CheckBox)
            GUI:TextInput_setString(input, cdtime)
            GUI:Win_SetParam(input, {_ID = id, _minCD = minCD, _maxCD = maxCD})
            GUI:TextInput_addOnEvent(input, SettingHero.onInputEvent)

            -- 毫秒
            GUI:Text_Create(CheckBox, "Text", 295, 2, 16, "#ffffff", "毫秒")

            -- 复选框添加事件
            GUI:CheckBox_setSelected(CheckBox, isSelected)
            GUI:Win_SetParam(CheckBox, id)
            GUI:CheckBox_addOnEvent(CheckBox, SettingHero.onCheckBoxEvent)

            -- 位置信息
            table.insert(controls, {
                CheckBox = CheckBox, x = idx % 2 == 1 and 20 or itemWidth + 30, y = math.ceil(idx / iRow) * itemHeight
            })
            num = num + 1
        end
    end
    ihh = ihh + math.ceil(num / iRow) * itemHeight + 90

    -------------------------------------------------英雄设置-------------------------------------------------------------
    -- 设置内部标题位置
    local TitleText2 = GUI:Text_Create(FrameList, "TitleText2", 15, 0, 18, "#f8e6c6", "英雄设置")

    local posY = ihh - 30

    -- 英雄设置
    local iRow = 4
    local itemWidth = (attachW - 60) / iRow
    local itemHeight= 60
    local num = 0
    -- local controls = {}
    for idx,data in ipairs(GUIShare.SetCfg.SetHeroCfg[2]) do
        if data then
            local id = data.id
            local CheckBox = GUI:CheckBox_Create(FrameList, "CheckBox"..id, 0, 0, "res/public/1900000550.png", "res/public/1900000551.png")
            -- 一个设置项占据几个位置, 默认一个
            local place = data.place or 1

            local values = SL:GetSettingValue(id)
            local isSelected = values[1] == 1
            local inputValue = values[2] or 1

            local Text_desc = GUI:Text_Create(CheckBox, "Label", 40, 2, 16, "#ffffff", data.content)
            local Text_desc_width = GUI:getContentSize(Text_desc).width
            if place == 2 then
                -- 输入框
                local input = SettingHero.onCreateInput(CheckBox, 60 + Text_desc_width, 2)
                GUI:TextInput_setString(input, inputValue)
                GUI:Win_SetParam(input, id)
                GUI:TextInput_addOnEvent(input, SettingHero.onInputEvent)
            end

            local matrix = SettingHero.calculateMatrix(num, place, iRow)
            num = matrix.k
            table.insert(controls, {
                tag = 2, CheckBox = CheckBox, x = (matrix.c - 1) * itemWidth + 30, y = matrix.r * itemHeight
            })

            GUI:CheckBox_setSelected(CheckBox, isSelected)
            GUI:Win_SetParam(CheckBox, id)
            GUI:CheckBox_addOnEvent(CheckBox, SettingHero.onCheckBoxEvent)
            
            -- CheckBox 触摸层
            GUI:Layout_Create(CheckBox, "TouchSize", 0, -1, GUI:getContentSize(CheckBox).width + 13 + Text_desc_width, 28, false)
        end
    end
    ihh = ihh + math.ceil(num / iRow) * itemHeight

    -- 计算滚动层的内部滚动高度
    GUI:ScrollView_setInnerContainerSize(FrameList, {width = attachW, height = ihh})

    GUI:setPositionY(TitleText1, ihh - 40)
    GUI:setPositionY(TitleText2, ihh - posY)

    -- 设置复选框的位置
    for _,control in ipairs(controls) do
        if control.CheckBox then
            if control.tag then
                GUI:setPosition(control.CheckBox, control.x, ihh - control.y - posY)
            else
                GUI:setPosition(control.CheckBox, control.x, ihh - 20 - control.y)
            end
        end
    end
end

-------------------------------------------------------------------

-- 行列
function SettingHero.calculateMatrix(k, place, iRow)
    local num = k + place
    local mod = num % iRow
    num = (place == 2 and mod == 1) and num + 1 or num
    local col = place == 2 and (mod > 1 and mod - 1 or (mod > 0 and 1 or (iRow-1))) or (mod > 0 and mod or iRow)
    local row = math.ceil(num / iRow)
    return {
        k = num, c = col, r = row
    }
end

-- 创建输入框
function SettingHero.onCreateInput(parent)
    local input_bg = GUI:Image_Create(parent, "Input_bg", 225, 2, "res/public/1900000676.png")
    local input = GUI:TextInput_Create(parent, "Input", 227, 3.5, 60, 19, 16)
    GUI:setContentSize(input_bg, {width = 65, height = 22})
    GUI:Image_setScale9Slice(input_bg, 21, 21, 10, 10)
    GUI:Text_setTextHorizontalAlignment(input, 1) 
    GUI:TextInput_setInputMode(input, 2)
    return input
end

-- 输入框事件
function SettingHero.onInputEvent(sender, eventType)
    local param = GUI:Win_GetParam(sender)
    if eventType == 1 then
        local input = GUI:TextInput_getString(sender)
        local input_value = math.min(math.max(tonumber(input) or 1, param._minCD), param._maxCD)
        GUI:TextInput_setString(sender, input_value)
        SL:SetSettingValue(param._ID, {nil, nil, input_value})
    end
end

---------------------------------------------------------------------
-- CheckBox 点击事件
function SettingHero.onCheckBoxEvent(sender, eventType)
    local id = GUI:Win_GetParam(sender)
    local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
    SL:SetSettingValue(id, {isSelected})
end

---------------------------------------------------------------------
-- Slider 滑动事件
function SettingHero.onSliderEvent(sender, eventType)
    local param = GUI:Win_GetParam(sender)

    -- 先删除 RichText， 在重新创建一个新的
    local parent = GUI:getParent(sender)
    local Text_desc = GUI:getChildByName(parent, "RichText")
    if Text_desc then
        GUI:removeFromParent(Text_desc)
    end
    local tmp = GUI:Slider_getPercent(sender)
    GUI:RichText_Create(parent, "RichText", 15, 25, string.format(param._content, tmp), 300, 16, "#FFFFFF")
end

function SettingHero.onSliderClickEvent(sender, eventType)
    local param = GUI:Win_GetParam(sender)
    SL:SetSettingValue(param._ID, {nil, GUI:Slider_getPercent(sender)})
end