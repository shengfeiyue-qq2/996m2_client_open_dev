SettingBattle = {}

function SettingBattle.main()
    SettingBattle._parent = GUI:Attach_Parent()
    SettingBattle._width  = GUIShare.WinView.Width
    SettingBattle._height = GUIShare.WinView.Height

    -- 一行最多显示4个, place = 2 的占两个设置项的位置
    local iRow  = 4
    local itemWidth = (SettingBattle._width - 60) / iRow
    local itemHeight= 60

    -- listview 容器
    local FrameList = GUI:ScrollView_Create(SettingBattle._parent, "FrameList", 0, 0, SettingBattle._width, SettingBattle._height, 1)
    SettingBattle._FrameList = FrameList
    
    -- PC 鼠标齿轮滚动
    if SL:IsWinMode() then
        GUI:ListView_addMouseScrollPercent(FrameList)
    end

    if not (GUIShare.SetCfg and GUIShare.SetCfg.SetBattleCfg) then
        return false
    end
    if not (GUIShare.SetCfg and GUIShare.SetBattleTitleCfg) then
        return false
    end

    local showAll = SL:GetServerOption(GUIShare.ServerOption.SHOW_ALL_FIGHTPAGES) == 1
    local roleJob = SL:GetRoleData().job
    local titles  = GUIShare.SetBattleTitleCfg

    local controls = {}
    local ihh = 0
    for key,datas in ipairs(GUIShare.SetCfg.SetBattleCfg) do
        local showPage = key == 1 and true or (showAll or roleJob == (key-2))
        if showPage then
            local k = 0

            local TitleText = GUI:Text_Create(FrameList, "TitleText"..key, 15, 0, 18, "#f8e6c6", titles[key])
            table.insert(controls, {
                ctrl = TitleText, x = 15, y = ihh + 10
            })

            for idx,data in ipairs(datas) do
                local isShow = true
                if data.platform == 1 then
                    if not SL:IsWinMode() then
                        isShow = false
                    end
                end
                if isShow then
                    local id = data.id
                    local CheckBox = GUI:CheckBox_Create(FrameList, "CheckBox"..id, 0, 0, "res/public/1900000550.png", "res/public/1900000551.png")
                                        
                    local place = data.place or 1  --一个设置项占据几个位置, 默认一个
                    
                    local values = SL:GetSettingValue(id)
                    local isSelected = values[1] == 1
                    local skillID = values[2]
                    local value3  = values[3] or 0

                    local Text_desc = GUI:Text_Create(CheckBox, "Label", 40, 2, 16, "#ffffff", data.content)
                    if place == 2 then
                        local i_x, i_y = 0, -15
                        if id == 25 then
                            GUI:removeChildByName(CheckBox, "Label")
                            Text_desc = nil
                            local Text1 = GUI:Text_Create(CheckBox, "Text1", 40, 2, 16, "#ffffff", "生命值低于")
                            local Text1_width = GUI:getContentSize(Text1)
                            local input = SettingBattle.onCreateInput(CheckBox, Text1_width.width + 45, 2)
                            GUI:TextInput_setString(input, value3)
                            GUI:Win_SetParam(input, id)
                            GUI:TextInput_addOnEvent(input, SettingBattle.onInputEvent)
                            local Text2 = GUI:Text_Create(CheckBox, "Text2", Text1_width.width + 90, 2, 16, "#ffffff", "%时使用")
                            i_x = Text1_width.width + 85 + GUI:getContentSize(Text2).width + 10
                        elseif id == 38 then
                            i_x = 50 + GUI:getContentSize(Text_desc).width
                            -- 输入框
                            local input = SettingBattle.onCreateInput(CheckBox, i_x + 65, 2)
                            GUI:TextInput_setString(input, value3)
                            GUI:Win_SetParam(input, id)
                            GUI:TextInput_addOnEvent(input, SettingBattle.onInputEvent)
                            GUI:Text_Create(CheckBox, "Text", i_x + 65 + 55, 2, 16, "#ffffff", "秒")
                        else
                            i_x = 50 + GUI:getContentSize(Text_desc).width
                        end

                        local skill_bg = SettingBattle.onCreateSkillBox(CheckBox, i_x, i_y)
                        local Text_empty = GUI:getChildByName(skill_bg, "Text_empty")
                        local skill_pic  = SL:GetSkillPicPath(skillID)
                        if skill_pic then
                            local skill_bg_size = GUI:getContentSize(skill_bg)
                            local skill = GUI:Image_Create(skill_bg, "skill", skill_bg_size.width/2, skill_bg_size.height/2, skill_pic)
                            GUI:setAnchorPoint(skill, 0.5, 0.5)
                            GUI:setTouchEnabled(skill, false)
                            GUI:setScale(skill, 0.9)
                            GUI:setVisible(Text_empty, false)
                        else
                            GUI:setVisible(Text_empty, true)
                        end
                        GUI:Win_SetParam(skill_bg, id)
                        GUI:addOnClickEvent(skill_bg, SettingBattle.onClickSkill)
                    end

                    local matrix = SettingBasic.calculateMatrix(k, place, iRow)
                    k = matrix.k
                    table.insert(controls, {
                        ctrl = CheckBox, x = (matrix.c - 1) * itemWidth + 30, y = matrix.r * itemHeight + ihh
                    })

                    -- 复选框
                    GUI:CheckBox_setSelected(CheckBox, isSelected)
                    GUI:Win_SetParam(CheckBox, id)
                    GUI:CheckBox_addOnEvent(CheckBox, SettingBattle.onCheckBoxEvent)
                    
                    -- CheckBox 触摸层
                    if Text_desc then
                        GUI:Layout_Create(CheckBox, "TouchSize", 0, -1, GUI:getContentSize(CheckBox).width + 13 + GUI:getContentSize(Text_desc).width, 28, false)
                    end
                end
            end
            ihh = ihh + math.ceil(k / iRow) * itemHeight + 50
        end
    end

    -- 滚动层的内部滚动高度
    ihh = math.max(SettingBattle._height, ihh)
    GUI:ScrollView_setInnerContainerSize(FrameList, {width = SettingBattle._width, height = ihh})

    -- 设置item的位置
    for _,control in ipairs(controls) do
        if control.ctrl then
            GUI:setPosition(control.ctrl, control.x, ihh - 20 - control.y)
        end
    end

    SL:RegisterLUAEvent(LUA_EVENT_SETTING_CAHNGE, "SetBattle", SettingBattle.RefreshItem)
end

-------------------------------------------------------------------
-- 行列
function SettingBattle.calculateMatrix(k, place, iRow)
    k = k + place
    local mod = k % iRow
    k = (place == 2 and mod == 1) and k + 1 or k
    local _Col = place == 2 and (mod > 1 and mod - 1 or (mod > 0 and 1 or (iRow-1))) or (mod > 0 and mod or iRow)
    local _Row = math.ceil(k / iRow)
    return _Col, _Row
end

-- 创建输入框
function SettingBattle.onCreateInput(parent, x, y)
    local input_bg = GUI:Image_Create(parent, "Input_bg", x, y, "res/public/1900000676.png")
    local input = GUI:TextInput_Create(parent, "Input", x + 5, y + 1.5, 30, 19, 16)
    GUI:setContentSize(input_bg, {width = 40, height = 22})
    GUI:Text_setTextHorizontalAlignment(input, 1) 
    GUI:TextInput_setInputMode(input, 2)
    return input
end

-- 输入框事件
function SettingBattle.onInputEvent(sender, eventType)
    if eventType == 1 then
        local input = GUI:TextInput_getString(sender)
        local id = GUI:Win_GetParam(sender)
        local input_value = math.min(math.max(tonumber(input) or 1, 1), 99)
        SL:SetSettingValue(id, {nil, nil, input_value})
    end
end

---------------------------------------------------------------------
-- CheckBox 点击事件
function SettingBattle.onCheckBoxEvent(sender, eventType)
    local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
    local id = GUI:Win_GetParam(sender)
    SL:SetSettingValue(id, {isSelected})
    print("onCheckBoxEvent...")
end

---------------------------------------------------------------------
-- 创建技能框
function SettingBattle.onCreateSkillBox(parent, x, y)
    local skill_bg = GUI:Image_Create(parent, "skill_bg", x, y, "res/public/1900000651.png")
    local Text_empty = GUI:Text_Create(skill_bg, "Text_empty", 30, 30, 16, "#FFFFFF", "无")
    GUI:setAnchorPoint(Text_empty, 0.5, 0.5)
    GUI:setTouchEnabled(skill_bg, true)
    return skill_bg
end

-- 创建技能弹窗
function SettingBattle.createSkillPop(data)
    local width, height = SettingBattle._width, SettingBattle._height
    
    local PopView = GUI:getChildByName(SettingBattle._parent, "PopView")
    if not PopView then
        PopView = GUI:Layout_Create(SettingBattle._parent, "PopView", width / 2, height / 2, width, height)
        GUI:Layout_setBackGroundColor(PopView, "#000000")
        GUI:Layout_setBackGroundColorOpacity(PopView, 50)
        GUI:Layout_setBackGroundColorType(PopView, 1)
        GUI:setAnchorPoint(PopView, {x=0.5, y=0.5})
        GUI:setTouchEnabled(PopView, true)
        GUI:addOnClickEvent(PopView, function () GUI:setVisible(PopView, false) end)

        local bg = GUI:Image_Create(PopView, "pBg", width / 2, height / 2, "res/public/1900000677.png")
        GUI:setContentSize(bg, {width = width - 360, height = height})
        GUI:Image_setScale9Slice(bg, 8, 8, 15, 15)
        GUI:setAnchorPoint(bg, {x=0.5, y=0.5})
    end
    local list = GUI:getChildByName(PopView, "pList")
    if not list then
        list = GUI:ListView_Create(PopView, "pList", 185, 5, width - 370, height - 10, 1)
    end
    GUI:removeAllChildren(list)
    for i,skill in ipairs(data) do
        local item = GUI:Layout_Create(list, "item"..i, 0, 0, width - 370, 90)
        GUI:addOnClickEvent(item, function ()
            SL:SetSettingValue(skill.ID, {nil, skill.group})
            GUI:setVisible(PopView, false)
        end)
        GUI:setTouchEnabled(item, true)

        local icBg = GUI:Image_Create(item, "icBg", 35, 45, "res/public/1900000651.png")
        GUI:setAnchorPoint(icBg, 0.5, 0.5)

        local icon = GUI:Image_Create(item, "icon", 35, 45, skill.pic)
        GUI:setAnchorPoint(icon, 0.5, 0.5)
        GUI:setScale(icon, 0.9)

        local sDesc = GUI:RichText_Create(item, "desc", 70, 45, skill.desc, width - 370 - 75, 16)
        GUI:setAnchorPoint(sDesc, 0, 0.5)
    end
    GUI:ListView_jumpToItem(list, 1)

    PopView:setVisible(true)
end

function SettingBattle.onClickSkill(sender, eventType)
    local showSkills = SettingBattle._GetShowSkills(GUI:Win_GetParam(sender))
    if showSkills then
        SettingBattle.createSkillPop(showSkills)
    end
end

function SettingBattle.RefreshItem(data)
    if not data or not data.id or not data.values then
        return false
    end

    if not SettingBattle._FrameList then
        return false
    end

    local setID = data.id

    local item = GUI:getChildByName(SettingBattle._FrameList, "CheckBox"..setID)
    if not item then

        return false
    end

    if data.values[1] then
        GUI:CheckBox_setSelected(item, data.values[1] == 1)
    end

    -- 设置技能
    if not (setID == 47 or setID == 21 or setID == 38 or setID == 25 or setID == 26) then
        return false    
    end

    local ui_skill_bg = GUI:getChildByName(item, "skill_bg")
    if not ui_skill_bg then
        return false
    end

    local ui_skill = GUI:getChildByName(ui_skill_bg, "skill")

    local Text_empty = GUI:getChildByName(ui_skill_bg, "Text_empty")

    local skillID = data.values[2]
    local skill_pic  = SL:GetSkillPicPath(skillID)
    if not skill_pic then
        GUI:setVisible(Text_empty, true)
        return false
    end
    
    if ui_skill then
        GUI:Image_loadTexture(ui_skill, skill_pic)
    else
        local skill_bg_size = GUI:getContentSize(ui_skill_bg)
        local skill = GUI:Image_Create(ui_skill_bg, "skill", skill_bg_size.width/2, skill_bg_size.height/2, skill_pic)
        GUI:setAnchorPoint(skill, 0.5, 0.5)
        GUI:setTouchEnabled(skill, false)
        GUI:setScale(skill, 0.9)
    end

    GUI:setVisible(Text_empty, false)
end
