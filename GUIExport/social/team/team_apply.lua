local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Scene, "Panel_2", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 66)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 568.00, 320.00, 680.00, 400.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 36)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 340.00, 200.00, "res/public/1900000675.jpg")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 37)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_1, "Image_3", 340.00, 195.00, "res/private/team/1900014004.png")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 43)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 693.00, 380.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 38)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_1, "Image_title", 340.00, 369.00, "res/private/team/1900014002.png")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 41)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_1, "Text_name", 108.00, 339.00, 16, "#ffffff", [[名字]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 47)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(Panel_1, "Text_guild", 242.00, 339.00, 16, "#ffffff", [[行会]])
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 45)
	GUI:Text_enableOutline(Text_guild, "#000000", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Panel_1, "Text_level", 378.00, 339.00, 16, "#ffffff", [[等级]])
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 46)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_operation
	local Text_operation = GUI:Text_Create(Panel_1, "Text_operation", 543.00, 339.00, 16, "#ffffff", [[操作]])
	GUI:setAnchorPoint(Text_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Text_operation, false)
	GUI:setTag(Text_operation, 48)
	GUI:Text_enableOutline(Text_operation, "#000000", 1)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_1, "ListView", 40.00, 43.00, 600.00, 280.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 42)
end
return ui