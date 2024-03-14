local ui = {}
function ui.init(parent)
	-- Create enemy_cell
	local enemy_cell = GUI:Layout_Create(parent, "enemy_cell", 0.00, 0.00, 200.00, 40.00, false)
	GUI:setChineseName(enemy_cell, "选中目标组合")
	GUI:setAnchorPoint(enemy_cell, 0.50, 1.00)
	GUI:setTouchEnabled(enemy_cell, true)
	GUI:setTag(enemy_cell, -1)

	-- Create Image_target
	local Image_target = GUI:Image_Create(enemy_cell, "Image_target", 100.00, 20.00, "res/private/main/assist/1900000678.png")
	GUI:setContentSize(Image_target, 200, 40)
	GUI:setIgnoreContentAdaptWithSize(Image_target, false)
	GUI:setChineseName(Image_target, "选中目标_选中_图片")
	GUI:setAnchorPoint(Image_target, 0.50, 0.50)
	GUI:setTouchEnabled(Image_target, false)
	GUI:setTag(Image_target, -1)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(enemy_cell, "Image_icon", 35.00, 20.00, "res/private/main/assist/1900012534.png")
	GUI:setContentSize(Image_icon, 28, 28)
	GUI:setIgnoreContentAdaptWithSize(Image_icon, false)
	GUI:setChineseName(Image_icon, "选中目标_图标")
	GUI:setAnchorPoint(Image_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, -1)

	-- Create Image_name
	local Image_name = GUI:Image_Create(enemy_cell, "Image_name", 120.00, 33.00, "res/private/main/assist/1900012531.png")
	GUI:setChineseName(Image_name, "选中目标_目标昵称_背景图")
	GUI:setAnchorPoint(Image_name, 0.50, 1.00)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(enemy_cell, "Text_name", 120.00, 25.00, 16, "#ffffff", [[xxxxx]])
	GUI:setChineseName(Text_name, "选中目标_目标昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_hp
	local Image_hp = GUI:Image_Create(enemy_cell, "Image_hp", 120.00, 10.00, "res/private/main/assist/1900012531.png")
	GUI:setContentSize(Image_hp, 132, 8)
	GUI:setIgnoreContentAdaptWithSize(Image_hp, false)
	GUI:setChineseName(Image_hp, "选中目标_Hp边框_图片")
	GUI:setAnchorPoint(Image_hp, 0.50, 0.50)
	GUI:setTouchEnabled(Image_hp, false)
	GUI:setTag(Image_hp, -1)

	-- Create LoadingBar_hp
	local LoadingBar_hp = GUI:LoadingBar_Create(enemy_cell, "LoadingBar_hp", 120.00, 10.00, "res/private/main/assist/1900012532.png", 0)
	GUI:setContentSize(LoadingBar_hp, 130, 6)
	GUI:setIgnoreContentAdaptWithSize(LoadingBar_hp, false)
	GUI:LoadingBar_setPercent(LoadingBar_hp, 100)
	GUI:LoadingBar_setColor(LoadingBar_hp, "#ffffff")
	GUI:setChineseName(LoadingBar_hp, "选中目标_目标Hp")
	GUI:setAnchorPoint(LoadingBar_hp, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_hp, false)
	GUI:setTag(LoadingBar_hp, -1)
end
return ui