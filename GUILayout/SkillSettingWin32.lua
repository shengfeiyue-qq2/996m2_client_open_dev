SkillSettingWin32 = {}
function SkillSettingWin32.main()
	local parent = GUI:Attach_Parent()
	local width  = 489
    local height = 196

	local PMainUI = GUI:Layout_Create(parent, "PMainUI", SL:GetScreenWidth()/2, SL:GetScreenHeight()/2, width, height)
	GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)
	GUI:Win_SetDrag(parent, PMainUI)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0, 0, "res/private/skill-win32/img_bg.png")

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(PMainUI, "Image_icon", 76.00, 150.00, "res/private/skill-win32/img_sel.png")
	GUI:setAnchorPoint(Image_icon, 0.00, 0.50)
	GUI:setTouchEnabled(Image_icon, false)

	-- Create Text_1
	local Text_name = GUI:Text_Create(PMainUI, "Text_name", 131.00, 150.00, 16, "#ffffff", [[普通攻击快捷键设置为]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)

	for key=1,8 do
		local posX = 36 + (key-1) * 52
		local btn = GUI:Button_Create(PMainUI, "Button_F"..key, posX, 66.00, "res/private/skill-win32/btn_1.png")
		GUI:Button_loadTexturePressed(btn, "res/private/skill-win32/btn_2.png")
		local Image_key = GUI:Image_Create(btn, "Image_key", 26.00, 25.00, string.format("res/private/skill-win32/key_F%s.png", key))
		GUI:setAnchorPoint(Image_key, 0.50, 0.50)
		local Image_sel = GUI:Image_Create(btn, "Image_sel", 26.00, 25.00, "res/public/1900000678_1.png")
		GUI:setContentSize(Image_sel, 45, 45)
		GUI:setIgnoreContentAdaptWithSize(Image_sel, false)
		GUI:setAnchorPoint(Image_sel, 0.50, 0.50)
		GUI:setVisible(Image_sel, false)
	end

	-- Create Button_clean
	local Button_clean = GUI:Button_Create(PMainUI, "Button_clean", 130.00, 15.00, "res/private/skill-win32/btn_4.png")
	GUI:Button_loadTexturePressed(Button_clean, "res/private/skill-win32/btn_4_1.png")
	GUI:setAnchorPoint(Button_clean, 0.50, 0.00)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(PMainUI, "Button_submit", 370.00, 15.00, "res/private/skill-win32/btn_3.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/private/skill-win32/btn_3_1.png")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.00)

	-- 关闭按钮
	local Button_close = GUI:Button_Create(PMainUI, "Button_close", width, height, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:setAnchorPoint(Button_close, 0, 1)
	GUI:addOnClickEvent(Button_close, function () GUI:Win_Close(parent) end)
end
return SkillSettingWin32