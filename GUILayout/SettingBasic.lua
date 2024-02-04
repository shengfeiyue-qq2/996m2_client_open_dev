SettingBasic = {}

function SettingBasic.main()
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    local iRow = 4      -- 单行最多显示2个
    local itemWidth = (attachW - 60) / iRow
    local itemHeight= 60
    --------------------------------------------------------------------------------------------------------------------------

    -- listview 容器
    local FrameList = GUI:ScrollView_Create(parent, "FrameList", 0, 0, attachW, attachH, 1)
    GUI:setSwallowTouches(FrameList, false)

    -- 标题
    local TitleText = GUI:Text_Create(FrameList, "TitleText", 15, 0, 18, "#f8e6c6", "基 本")
    local ihh = 50

    if not (GUIShare.SetCfg and GUIShare.SetCfg.SetBaseCfg) then
        return false
    end

    -- 基本设置
    local num = 0
    local controls = {}
    for idx,data in ipairs(GUIShare.SetCfg.SetBaseCfg[1]) do
        if data then
            local isShow = true
            if data.platform == 1 then
                if not SL:IsWinMode() then
                    isShow = false
                end
            end
            if isShow then
                local CheckBox = GUI:CheckBox_Create(FrameList, "CheckBox"..idx, 0, 0, "res/public/1900000550.png", "res/public/1900000551.png")

                local place = data.place or 1
                local id = data.id

                local values = SL:GetSettingValue(id)
                local isSelected = values[1] == 1
                local inputValue = values[2] or 1

                local Text_desc = GUI:Text_Create(CheckBox, "Label", 40, 2, 16, "#ffffff", data.content)
                local Text_desc_width = GUI:getContentSize(Text_desc).width
                if place == 2 then
                    -- 输入框
                    local input = SettingBasic.onCreateInput(CheckBox, 60 + Text_desc_width, 2)
                    GUI:TextInput_setString(input, inputValue)
                    GUI:Win_SetParam(input, id)
                    GUI:TextInput_addOnEvent(input, SettingBasic.onInputEvent)
                end

                local matrix = SettingBasic.calculateMatrix(num, place, iRow)
                num = matrix.k
                table.insert(controls, {
                    CheckBox = CheckBox, x = (matrix.c - 1) * itemWidth + 30, y = matrix.r * itemHeight 
                })

                GUI:CheckBox_setSelected(CheckBox, isSelected)
                GUI:Win_SetParam(CheckBox, id)
                GUI:CheckBox_addOnEvent(CheckBox, SettingBasic.onCheckBoxEvent)
                
                -- CheckBox 触摸层
                GUI:Layout_Create(CheckBox, "TouchSize", 0, -1, GUI:getContentSize(CheckBox).width + 13 + Text_desc_width, 28, false)
            end
        end
    end
    ihh = ihh + math.ceil(num / iRow) * itemHeight

    local barimg = "res/public/bg_szjm_01.png"
    local pbarimg = "res/public/bg_szjm_02.png"
    local nimg = "res/private/setting_basic/icon_xdtzy_17.png"

    local sliderZoom = nil
    local labelZoom = nil
    -- 场景缩放
    if not SL:IsWinMode() then
        local cfg     = GUIShare.SetCfg.SetBaseCfg[2][1]
        local id      = cfg.id
        local content = cfg.content
        local data    = SL:GetSettingValue(id)
        local perVal  = data[2]  -- 缩放值

        labelZoom = GUI:Text_Create(FrameList, "labelZoom", 30, 0, 16, "#ffffff", string.format("%s(%.1f倍)", content, perVal))
        sliderZoom = GUI:Slider_Create(FrameList, "sliderZoom", 30, 0, barimg, pbarimg, nimg)
        GUI:setContentSize(sliderZoom, cc.size(680, 14))
        GUI:Slider_setPercent(sliderZoom, ((perVal-0.7) / (2.3-0.7)) * 100)
        GUI:Win_SetParam(sliderZoom, {id = id, content = content, label = labelZoom})
        GUI:Slider_addOnEvent(sliderZoom, SettingBasic.onSliderZoomEvent)
        ihh = ihh + 80
    end
    
    -- 背景音乐
    local cfg = GUIShare.SetCfg.SetBaseCfg[3][1]
    local id  = cfg.id
    local content = cfg.content
    local data = SL:GetSettingValue(id)
    local perVal = data[2] or 100  -- 缩放值
    local labelbgSound = GUI:Text_Create(FrameList, "labelbgSound", 30, 0, 16, "#ffffff", string.format("%s(%s%%)", content, perVal))
    local sliderBgSound = GUI:Slider_Create(FrameList, "sliderBgSound", 30, 0, barimg, pbarimg, nimg)
    GUI:setContentSize(sliderBgSound, cc.size(325, 14))
    GUI:Slider_setPercent(sliderBgSound, perVal)
    GUI:Win_SetParam(sliderBgSound, {id = id, content = content, label = labelbgSound})
    GUI:Slider_addOnEvent(sliderBgSound, SettingBasic.onSliderSoundEvent)

    -- 游戏音乐
    local cfg = GUIShare.SetCfg.SetBaseCfg[4][1]
    local id  = cfg.id
    local content = cfg.content
    local data = SL:GetSettingValue(id)
    local perVal = data[2] or 100  -- 缩放值
    local labelgameSound = GUI:Text_Create(FrameList, "labelgameSound", 385, 0, 16, "#ffffff", string.format("%s(%s%%)", content, perVal))
    local sliderGameSound = GUI:Slider_Create(FrameList, "sliderGameSound", 385, 0, barimg, pbarimg, nimg)
    GUI:setContentSize(sliderGameSound, cc.size(325, 14))
    GUI:Slider_setPercent(sliderGameSound, perVal)
    GUI:Win_SetParam(sliderGameSound, {id = id, content = content, label = labelgameSound})
    GUI:Slider_addOnEvent(sliderGameSound, SettingBasic.onSliderSoundEvent)

    ihh = ihh + 60

    -- 滚动层的内部滚动高度
    ihh = math.max(attachH, ihh)
    GUI:ScrollView_setInnerContainerSize(FrameList, {width = attachW, height = ihh})

    GUI:setPositionY(sliderBgSound, 20)
    GUI:setPositionY(sliderGameSound, 20)

    GUI:setPositionY(labelbgSound, 40)
    GUI:setPositionY(labelgameSound, 40)
    
    if not SL:IsWinMode() then
        if sliderZoom then
            GUI:setPositionY(sliderZoom, 85)
        end
        if labelZoom then
            GUI:setPositionY(labelZoom, 105)
        end
    end

    for _,control in ipairs(controls) do
        if control.CheckBox then
            GUI:setPosition(control.CheckBox, control.x, ihh - 20 - control.y)
        end
    end

    GUI:setPositionY(TitleText, ihh - 30)
end

-------------------------------------------------------------------

-- 行列
function SettingBasic.calculateMatrix(k, place, iRow)
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
function SettingBasic.onCreateInput(parent, x, y)
    local input_bg = GUI:Image_Create(parent, "Input_bg", x, y, "res/public/1900000676.png")
    local input = GUI:TextInput_Create(parent, "Input", x + 2, y + 1.5, 95, 19, 16)
    GUI:setContentSize(input_bg, {width = 100, height = 22})
    GUI:Image_setScale9Slice(input_bg, 21, 21, 10, 10)
    GUI:Text_setTextHorizontalAlignment(input, 1) 
    GUI:TextInput_setInputMode(input, 2)
    return input
end

-- 输入框事件
function SettingBasic.onInputEvent(sender, eventType)
    if eventType == 1 then
        local id = GUI:Win_GetParam(sender)
        local input = GUI:TextInput_getString(sender)
        local input_value = math.min(math.max(tonumber(input) or 1, 1), 2000000000)
        SL:SetSettingValue(id, {nil, input_value})
    end
end

---------------------------------------------------------------------
-- CheckBox 点击事件
function SettingBasic.onCheckBoxEvent(sender, eventType)
    local id = GUI:Win_GetParam(sender)
    local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
    SL:SetSettingValue(id, {isSelected})
end

function SettingBasic.onSliderZoomEvent(ref, eventType)
    if eventType == 0 then
        local data    = GUI:Win_GetParam(ref)
        local label   = data.label
        local id      = data.id
        local content = data.content
        
        local percent = GUI:Slider_getPercent(ref)
        local values  = SL:GetSettingValue(id)
        local value   = values[2]
        local newValue = math.floor((0.7+(2.3-0.7)*(percent/100)) * 10) / 10
        if math.abs((math.round(value * 10) - math.round(newValue * 10))) >= 1 then
            SL:SetSettingValue(id, {nil, newValue})
            label:setString(string.format("%s(%.1f倍)", data.content, newValue))
        end
    elseif eventType == 2 then
        SL:ReloadMap()
    end
end

function SettingBasic.onSliderSoundEvent(ref, eventType)
    if eventType == 0 then
        local data     = GUI:Win_GetParam(ref)
        local label    = data.label
        local id       = data.id
        local content  = data.content

        local percent  = GUI:Slider_getPercent(ref)
        local values   = SL:GetSettingValue(id)
        local value    = math.floor((values[2] or 100) / 10) * 10
        local newValue = math.floor(percent/10) * 10
        if math.abs(value - newValue) >= 10 then
            SL:SetSettingValue(id, {nil, newValue})
            label:setString(string.format("%s(%s%%)", content, newValue))
        end
    end
end