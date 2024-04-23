SkillSettingWin32 = {}

local KEY_NUM = 16

function SkillSettingWin32.main(skillID)
	local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "skill_setting_win32/skill_setting")

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end
    SkillSettingWin32._ui = ui


	local PMainUI = ui["PMainUI"]
	GUI:setPosition(PMainUI, SL:GetScreenWidth()/2, SL:GetScreenHeight()/2)
	GUI:setMouseEnabled(PMainUI, true)
	GUI:Win_SetDrag(parent, PMainUI)

	GUI:addOnClickEvent(ui["Button_clean"], SkillSettingWin32.OnCleanKey)
	GUI:addOnClickEvent(ui["Button_close"], SkillSettingWin32.OnClose)
	GUI:addOnClickEvent(ui["Button_submit"], SkillSettingWin32.OnSubmitKey)

	SkillSettingWin32._keyCodeCells = {}
    SkillSettingWin32._skillID = skillID
    SkillSettingWin32._skillKey = SL:GetSkillKey(skillID)

	SkillSettingWin32.InitKeyEvent()
	SkillSettingWin32.OnUpdate()
end

function SkillSettingWin32.InitKeyEvent()
	for key = 1, KEY_NUM do
        local btn = SkillSettingWin32._ui["Button_F" .. key]
        if btn then
			SkillSettingWin32._keyCodeCells[key] = btn
			GUI:addOnClickEvent(btn, function ()
				SkillSettingWin32._skillKey = key
				SkillSettingWin32.UpdateKeyCode()
			end)
        end
    end
end

function SkillSettingWin32.OnUpdate()
	local Text_name = SkillSettingWin32._ui["Text_name"]
	local str = SL:GetMetaValue("SKILL_NAME", SkillSettingWin32._skillID) .. "快捷键设置为"
	GUI:Text_setString(Text_name, str)

	-- icon 
	local icon_bg  = SkillSettingWin32._ui["icon_bg"]
	local icon = GUI:getChildByName(icon_bg, "icon")
	if icon then
		GUI:Image_loadTexture(icon, SL:GetSkillPicPath(SkillSettingWin32._skillID))
	else
		local size = GUI:getContentSize(icon_bg)
		icon = GUI:Image_Create(icon_bg, "icon", size.width / 2, size.height / 2, SL:GetSkillPicPath(SkillSettingWin32._skillID))
		GUI:setAnchorPoint(icon, 0.5, 0.5)
		GUI:setIgnoreContentAdaptWithSize(icon, false)
		GUI:setContentSize(icon, 40, 40)
	end

    SkillSettingWin32.UpdateKeyCode()
end

function SkillSettingWin32.UpdateKeyCode()
    for key, cell in pairs(SkillSettingWin32._keyCodeCells) do
        GUI:setVisible(GUI:getChildByName(cell, "Image_sel"), SkillSettingWin32._skillKey == key)
    end
end

-- 清空快捷技能键设置
function SkillSettingWin32.OnCleanKey()
	local skillID = SkillSettingWin32._skillID
	if not skillID then
		return false
	end
	
	local key = SL:GetSkillKey(skillID)
	if key < 1 or key > KEY_NUM then
		SL:Print("skill key error, key: ", key)
		return false
	end

	SL:DeleteSkillKey(skillID)
	SL:ShowSystemTips(string.format("%s快捷键位置已被清空", key > 8 and string.format("Ctrl + F%s", key - 8) or string.format("F%s", key)))

	SkillSettingWin32.OnClose()
end

function SkillSettingWin32.OnClose()
	SL:CloseSkillSetWin32UI()
end

function SkillSettingWin32.OnSubmitKey()
	local skillID = SkillSettingWin32._skillID
	if not skillID then
		return false
	end

	local oldKey = SL:GetSkillKey(skillID)
	local newKey = SkillSettingWin32._skillKey

	if oldKey == newKey then
		return SkillSettingWin32.OnClose()
	end

	if newKey < 1 or newKey > KEY_NUM then
		SL:Print("new skill key error, key: ", newKey)
		return false
	end

	-- 设置 Key
	SL:SetSkillKey(skillID, newKey)

	SL:ShowSystemTips(string.format("[%s]快捷键设置为%s", SL:GetMetaValue("SKILL_NAME", skillID), newKey > 8 and string.format("Ctrl + F%s", newKey - 8) or string.format("F%s", newKey)))

	SkillSettingWin32.OnClose()
end

return SkillSettingWin32