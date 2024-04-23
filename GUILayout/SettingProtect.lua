SettingProtect = {}

function SettingProtect.main()
    local parent  = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    local iRow = 2      -- 单行最多显示2个
    local itemWidth = (attachW - 40) / iRow
    local itemHeight= 70
    --------------------------------------------------------------------------------------------------------------------------

    -- ScrollView 容器
    local FrameList = GUI:ScrollView_Create(parent, "FrameList", 0, 102.5, attachW, attachH - 102.5, 1)

    -- 线
    local line = GUI:Image_Create(parent, "line", 0, 100, "res/public/bg_yyxsz_01.png")
    GUI:setContentSize(line, {width = attachW, height = 2})

    -- 标题
    local TitleText = GUI:Text_Create(FrameList, "TitleText", 15, 0, 18, "#f8e6c6", "保护设置")
    local ihh = 50

    local barimg = "res/public/bg_szjm_01.png"
    local pbarimg = "res/public/bg_szjm_02.png"
    local nimg = "res/private/setting_basic/icon_xdtzy_17.png"

    if not (GUIShare.SetCfg and GUIShare.SetCfg.SetProtectCfg) then
        return false
    end

    -- 基本设置
    local controls = {}
    local num = 0
    for idx,data in ipairs(GUIShare.SetCfg.SetProtectCfg) do
        if data then
            local CheckBox = GUI:CheckBox_Create(FrameList, "CheckBox"..idx, 0, 0, "res/public/1900000550.png", "res/public/1900000551.png")

            local id = data.id
            local values = SL:GetSettingValue(id)
            local isSelected = values[1] == 1
            local percent = values[2] or 50
            
            -- 描述
            local Text_desc = GUI:RichText_Create(CheckBox, "RichText", 15, 25, string.format(data.content, percent), 300, 16, "#FFFFFF")

            -- 滑动条
            local slider = GUI:Slider_Create(CheckBox, "slider", 35, 7, barimg, pbarimg, nimg)
            GUI:setContentSize(slider, cc.size(185, 14))
            GUI:Slider_setPercent(slider, percent)
            GUI:Win_SetParam(slider, {_ID = id, _content = data.content})
            GUI:Slider_addOnEvent(slider, SettingProtect.onSliderEvent)
            GUI:addOnClickEvent(slider, SettingProtect.onSliderClickEvent)

            -- 配置背景
            local btnProtectSet = GUI:Button_Create(CheckBox, "btnProtectSet", 290, 14, "res/private/setting/textBg.png")
            GUI:Image_setScale9Slice(btnProtectSet, 33, 33, 9, 9)
            GUI:setContentSize(btnProtectSet, 59, 28)
            GUI:setIgnoreContentAdaptWithSize(btnProtectSet, false)
            GUI:setAnchorPoint(btnProtectSet, 0.5, 0.5)
            GUI:setTouchEnabled(btnProtectSet, true)
            GUI:addOnClickEvent(btnProtectSet, function () SL:OpenProtectSettingUI(id) end)

            -- 配置
            local Text_desc_0 = GUI:Text_Create(btnProtectSet, "Text_desc_0", 28, 14, 16, "#109c18", [[配置]])
            GUI:setAnchorPoint(Text_desc_0, 0.5, 0.5)
            GUI:setTouchEnabled(Text_desc_0, false)
            GUI:Text_enableOutline(Text_desc_0, "#111111", 1)

            -- 复选框添加事件
            GUI:CheckBox_setSelected(CheckBox, isSelected)
            GUI:Win_SetParam(CheckBox, id)
            GUI:CheckBox_addOnEvent(CheckBox, SettingProtect.onCheckBoxEvent)

            -- 位置信息
            table.insert(controls, {
                CheckBox = CheckBox, x = idx % 2 == 1 and 20 or itemWidth + 30, y = math.ceil(idx / iRow) * itemHeight
            })
            num = num + 1
        end
    end
    ihh = ihh + math.ceil(num / iRow) * itemHeight

    -- 计算滚动层的内部滚动高度
    ihh = math.max(attachH - 102.5, ihh)
    GUI:ScrollView_setInnerContainerSize(FrameList, {width = attachW, height = ihh})

    -- 设置复选框的位置
    for _,control in ipairs(controls) do
        if control.CheckBox then
            GUI:setPosition(control.CheckBox, control.x, ihh - 20 - control.y)
        end
    end

    -- 设置内部标题位置
    GUI:setPositionY(TitleText, ihh - 30)

    -- 备注
    local BeizhuText = GUI:Text_Create(parent, "BeizhuText", 15, 65, 18, "#f8e6c6", "备注")
    -- 需要自定义备注描述
    local example = GUI:RichText_Create(parent, "RichText", 30, 62, "这是啥玩意？ 我也不懂。。。", attachW - 60, 16, "#FFFFFF")
    GUI:setAnchorPoint(example, 0, 1)
end

-------------------------------------------------------------------
-- 创建输入框
function SettingProtect.onCreateInput(parent)
    local input_bg = GUI:Image_Create(parent, "Input_bg", 225, 2, "res/public/1900000676.png")
    local input = GUI:TextInput_Create(parent, "Input", 227, 3.5, 60, 19, 16)
    GUI:setContentSize(input_bg, {width = 65, height = 22})
    GUI:Image_setScale9Slice(input_bg, 21, 21, 10, 10)
    GUI:Text_setTextHorizontalAlignment(input, 1) 
    GUI:TextInput_setInputMode(input, 2)
    return input
end

---------------------------------------------------------------------
-- CheckBox 点击事件
function SettingProtect.onCheckBoxEvent(sender, eventType)
    local id = GUI:Win_GetParam(sender)
    local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
    SL:SetSettingValue(id, {isSelected})
end

---------------------------------------------------------------------
-- Slider 滑动事件
function SettingProtect.onSliderEvent(sender, eventType)
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

function SettingProtect.onSliderClickEvent(sender, eventType)
    local param = GUI:Win_GetParam(sender)
    SL:SetSettingValue(param._ID, {nil, GUI:Slider_getPercent(sender)})
end