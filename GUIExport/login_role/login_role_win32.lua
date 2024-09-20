local ui = {}
function ui.init(parent)
	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(parent, "Panel_touch", 0.00, 0.00, 1024.00, 768.00, false)
	GUI:setChineseName(Panel_touch, "触摸层")
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 512.00, 384.00, 1024.00, 640.00, false)
	GUI:Layout_setBackGroundImage(Panel_bg, "res/private/login/bg_cjzy_02_1.png")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 53)

	-- Create Node_server
	local Node_server = GUI:Node_Create(Panel_bg, "Node_server", 512.00, 640.00)
	GUI:setAnchorPoint(Node_server, 0.50, 0.50)
	GUI:setTag(Node_server, 37)

	-- Create Image_server_bg
	local Image_server_bg = GUI:Image_Create(Node_server, "Image_server_bg", 4.00, 0.00, "res/private/login/bg_cjzy_05.png")
	GUI:setAnchorPoint(Image_server_bg, 0.50, 1.00)
	GUI:setTouchEnabled(Image_server_bg, false)
	GUI:setTag(Image_server_bg, 34)

	-- Create Text_server_name
	local Text_server_name = GUI:Text_Create(Node_server, "Text_server_name", 0.00, -16.00, 15, "#ffffff", [[经典传奇]])
	GUI:setAnchorPoint(Text_server_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_server_name, false)
	GUI:setTag(Text_server_name, 102)
	GUI:Text_enableOutline(Text_server_name, "#000000", 1)

	-- Create Panel_role_1
	local Panel_role_1 = GUI:Layout_Create(Panel_bg, "Panel_role_1", 196.00, 488.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_role_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_1, true)
	GUI:setTag(Panel_role_1, 54)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_role_1, "Image_select", 0.00, 0.00, "res/private/login/select_role.png")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_role_job
	local Image_role_job = GUI:Image_Create(Panel_role_1, "Image_role_job", 0.00, 2.00, "res/private/login/role_job_0.png")
	GUI:setAnchorPoint(Image_role_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_role_job, true)
	GUI:setTag(Image_role_job, 91)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_role_1, "Button_create", 0.00, 0.00, "res/private/login/img_role_create_normal.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_role_create_pressed.png")
	GUI:Button_loadTextureDisabled(Button_create, "res/private/login/img_role_create_normal.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 96, 94)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#414146")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleDisableOutLine(Button_create)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 151)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_role_1, "Image_name", -118.00, 22.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_name, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 92)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_name, "Text_name", 0.00, 12.00, 18, "#ffffff", [[名字啊十七个字]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 93)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_level
	local Image_level = GUI:Image_Create(Panel_role_1, "Image_level", -118.00, -6.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_level, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_level, false)
	GUI:setAnchorPoint(Image_level, 0.50, 0.50)
	GUI:setTouchEnabled(Image_level, false)
	GUI:setTag(Image_level, 94)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Image_level, "Text_level", 0.00, 12.00, 18, "#ffffff", [[9999999级]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 95)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(Panel_role_1, "Image_job", -118.00, -34.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_job, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_job, false)
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, 96)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Image_job, "Text_job", 0.00, 12.00, 18, "#ffffff", [[男战士]])
	GUI:setAnchorPoint(Text_job, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 97)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Panel_role_2
	local Panel_role_2 = GUI:Layout_Create(Panel_bg, "Panel_role_2", 196.00, 342.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_role_2, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_2, true)
	GUI:setTag(Panel_role_2, 54)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_role_2, "Image_select", 0.00, 0.00, "res/private/login/select_role.png")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_role_job
	local Image_role_job = GUI:Image_Create(Panel_role_2, "Image_role_job", 0.00, 2.00, "res/private/login/role_job_0.png")
	GUI:setAnchorPoint(Image_role_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_role_job, true)
	GUI:setTag(Image_role_job, 91)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_role_2, "Button_create", 0.00, 0.00, "res/private/login/img_role_create_normal.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_role_create_pressed.png")
	GUI:Button_loadTextureDisabled(Button_create, "res/private/login/img_role_create_normal.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 96, 94)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#414146")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 1)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 151)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_role_2, "Image_name", -118.00, 22.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_name, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 92)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_name, "Text_name", 0.00, 12.00, 18, "#ffffff", [[名字啊十七个字]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 93)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_level
	local Image_level = GUI:Image_Create(Panel_role_2, "Image_level", -118.00, -6.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_level, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_level, false)
	GUI:setAnchorPoint(Image_level, 0.50, 0.50)
	GUI:setTouchEnabled(Image_level, false)
	GUI:setTag(Image_level, 94)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Image_level, "Text_level", 0.00, 12.00, 18, "#ffffff", [[9999999级]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 95)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(Panel_role_2, "Image_job", -118.00, -34.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_job, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_job, false)
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, 96)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Image_job, "Text_job", 0.00, 12.00, 18, "#ffffff", [[男战士]])
	GUI:setAnchorPoint(Text_job, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 97)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Panel_role_3
	local Panel_role_3 = GUI:Layout_Create(Panel_bg, "Panel_role_3", 196.00, 196.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_role_3, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_3, true)
	GUI:setTag(Panel_role_3, 54)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_role_3, "Image_select", 0.00, 0.00, "res/private/login/select_role.png")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_role_job
	local Image_role_job = GUI:Image_Create(Panel_role_3, "Image_role_job", 0.00, 2.00, "res/private/login/role_job_0.png")
	GUI:setAnchorPoint(Image_role_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_role_job, true)
	GUI:setTag(Image_role_job, 91)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_role_3, "Button_create", 0.00, 0.00, "res/private/login/img_role_create_normal.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_role_create_pressed.png")
	GUI:Button_loadTextureDisabled(Button_create, "res/private/login/img_role_create_normal.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 96, 94)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#414146")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 1)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 151)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_role_3, "Image_name", -118.00, 22.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_name, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 92)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_name, "Text_name", 0.00, 12.00, 18, "#ffffff", [[名字啊十七个字]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 93)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_level
	local Image_level = GUI:Image_Create(Panel_role_3, "Image_level", -118.00, -6.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_level, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_level, false)
	GUI:setAnchorPoint(Image_level, 0.50, 0.50)
	GUI:setTouchEnabled(Image_level, false)
	GUI:setTag(Image_level, 94)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Image_level, "Text_level", 0.00, 12.00, 18, "#ffffff", [[9999999级]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 95)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(Panel_role_3, "Image_job", -118.00, -34.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_job, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_job, false)
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, 96)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Image_job, "Text_job", 0.00, 12.00, 18, "#ffffff", [[男战士]])
	GUI:setAnchorPoint(Text_job, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 97)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Panel_role_4
	local Panel_role_4 = GUI:Layout_Create(Panel_bg, "Panel_role_4", 988.00, 488.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_role_4, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_4, true)
	GUI:setTag(Panel_role_4, 114)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_role_4, "Image_select", -158.00, 0.00, "res/private/login/select_role.png")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_role_job
	local Image_role_job = GUI:Image_Create(Panel_role_4, "Image_role_job", -158.00, 2.00, "res/private/login/role_job_0.png")
	GUI:setAnchorPoint(Image_role_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_role_job, true)
	GUI:setTag(Image_role_job, 115)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_role_4, "Button_create", -158.00, 0.00, "res/private/login/img_role_create_normal.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_role_create_pressed.png")
	GUI:Button_loadTextureDisabled(Button_create, "res/private/login/img_role_create_normal.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 96, 94)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#414146")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleDisableOutLine(Button_create)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 148)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_role_4, "Image_name", -38.00, 22.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_name, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 116)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_name, "Text_name", 0.00, 12.00, 18, "#ffffff", [[名字啊十七个字]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 117)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_level
	local Image_level = GUI:Image_Create(Panel_role_4, "Image_level", -38.00, -6.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_level, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_level, false)
	GUI:setAnchorPoint(Image_level, 0.50, 0.50)
	GUI:setTouchEnabled(Image_level, false)
	GUI:setTag(Image_level, 118)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Image_level, "Text_level", 0.00, 12.00, 18, "#ffffff", [[9999999级]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 119)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(Panel_role_4, "Image_job", -38.00, -34.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_job, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_job, false)
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, 120)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Image_job, "Text_job", 0.00, 12.00, 18, "#ffffff", [[男战士]])
	GUI:setAnchorPoint(Text_job, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 121)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Panel_role_5
	local Panel_role_5 = GUI:Layout_Create(Panel_bg, "Panel_role_5", 988.00, 342.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_role_5, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_5, true)
	GUI:setTag(Panel_role_5, 114)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_role_5, "Image_select", -158.00, 0.00, "res/private/login/select_role.png")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_role_job
	local Image_role_job = GUI:Image_Create(Panel_role_5, "Image_role_job", -158.00, 2.00, "res/private/login/role_job_0.png")
	GUI:setAnchorPoint(Image_role_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_role_job, true)
	GUI:setTag(Image_role_job, 115)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_role_5, "Button_create", -158.00, 0.00, "res/private/login/img_role_create_normal.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_role_create_pressed.png")
	GUI:Button_loadTextureDisabled(Button_create, "res/private/login/img_role_create_normal.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 96, 94)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#414146")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 1)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 148)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_role_5, "Image_name", -38.00, 22.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_name, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 116)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_name, "Text_name", 0.00, 12.00, 18, "#ffffff", [[名字啊十七个字]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 117)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_level
	local Image_level = GUI:Image_Create(Panel_role_5, "Image_level", -38.00, -6.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_level, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_level, false)
	GUI:setAnchorPoint(Image_level, 0.50, 0.50)
	GUI:setTouchEnabled(Image_level, false)
	GUI:setTag(Image_level, 118)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Image_level, "Text_level", 0.00, 12.00, 18, "#ffffff", [[9999999级]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 119)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(Panel_role_5, "Image_job", -38.00, -34.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_job, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_job, false)
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, 120)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Image_job, "Text_job", 0.00, 12.00, 18, "#ffffff", [[男战士]])
	GUI:setAnchorPoint(Text_job, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 121)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Panel_role_6
	local Panel_role_6 = GUI:Layout_Create(Panel_bg, "Panel_role_6", 988.00, 196.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_role_6, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_6, true)
	GUI:setTag(Panel_role_6, 114)

	-- Create Image_select
	local Image_select = GUI:Image_Create(Panel_role_6, "Image_select", -158.00, 0.00, "res/private/login/select_role.png")
	GUI:setAnchorPoint(Image_select, 0.50, 0.50)
	GUI:setTouchEnabled(Image_select, false)
	GUI:setTag(Image_select, -1)
	GUI:setVisible(Image_select, false)

	-- Create Image_role_job
	local Image_role_job = GUI:Image_Create(Panel_role_6, "Image_role_job", -158.00, 2.00, "res/private/login/role_job_0.png")
	GUI:setAnchorPoint(Image_role_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_role_job, true)
	GUI:setTag(Image_role_job, 115)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_role_6, "Button_create", -158.00, 0.00, "res/private/login/img_role_create_normal.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_role_create_pressed.png")
	GUI:Button_loadTextureDisabled(Button_create, "res/private/login/img_role_create_normal.png")
	GUI:Button_setScale9Slice(Button_create, 15, 15, 11, 11)
	GUI:setContentSize(Button_create, 96, 94)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#414146")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 1)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 148)

	-- Create Image_name
	local Image_name = GUI:Image_Create(Panel_role_6, "Image_name", -38.00, 22.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_name, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_name, false)
	GUI:setAnchorPoint(Image_name, 0.50, 0.50)
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, 116)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_name, "Text_name", 0.00, 12.00, 18, "#ffffff", [[名字啊十七个字]])
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 117)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_level
	local Image_level = GUI:Image_Create(Panel_role_6, "Image_level", -38.00, -6.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_level, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_level, false)
	GUI:setAnchorPoint(Image_level, 0.50, 0.50)
	GUI:setTouchEnabled(Image_level, false)
	GUI:setTag(Image_level, 118)

	-- Create Text_level
	local Text_level = GUI:Text_Create(Image_level, "Text_level", 0.00, 12.00, 18, "#ffffff", [[9999999级]])
	GUI:setAnchorPoint(Text_level, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 119)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(Panel_role_6, "Image_job", -38.00, -34.00, "res/private/login/img_wzdt.png")
	GUI:setContentSize(Image_job, 128, 24)
	GUI:setIgnoreContentAdaptWithSize(Image_job, false)
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, 120)

	-- Create Text_job
	local Text_job = GUI:Text_Create(Image_job, "Text_job", 0.00, 12.00, 18, "#ffffff", [[男战士]])
	GUI:setAnchorPoint(Text_job, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 121)
	GUI:Text_enableOutline(Text_job, "#000000", 1)

	-- Create Panel_act
	local Panel_act = GUI:Layout_Create(Panel_bg, "Panel_act", 512.00, 0.00, 0.00, 0.00, false)
	GUI:setAnchorPoint(Panel_act, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_act, true)
	GUI:setTag(Panel_act, 39)

	-- Create Button_start
	local Button_start = GUI:Button_Create(Panel_act, "Button_start", 0.00, 54.00, "res/private/login/img_ksyx_1.png")
	GUI:Button_loadTexturePressed(Button_start, "res/private/login/img_ksyx_2.png")
	GUI:Button_setScale9Slice(Button_start, 49, 48, 18, 18)
	GUI:setContentSize(Button_start, 146, 54)
	GUI:setIgnoreContentAdaptWithSize(Button_start, false)
	GUI:Button_setTitleText(Button_start, "")
	GUI:Button_setTitleColor(Button_start, "#ffffff")
	GUI:Button_setTitleFontSize(Button_start, 14)
	GUI:Button_titleEnableOutline(Button_start, "#000000", 1)
	GUI:setAnchorPoint(Button_start, 0.50, 0.50)
	GUI:setTouchEnabled(Button_start, true)
	GUI:setTag(Button_start, 59)

	-- Create Image_start
	local Image_start = GUI:Image_Create(Button_start, "Image_start", 73.00, 27.00, "res/private/login/c00005.png")
	GUI:setAnchorPoint(Image_start, 0.50, 0.50)
	GUI:setTouchEnabled(Image_start, false)
	GUI:setTag(Image_start, 376)
	GUI:setVisible(Image_start, false)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_start, "TouchSize", 73.00, 27.00, 95.00, 40.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 68)
	GUI:setVisible(TouchSize, false)

	-- Create Button_leave
	local Button_leave = GUI:Button_Create(Panel_act, "Button_leave", 304.00, 54.00, "res/private/login/img_fh_1.png")
	GUI:Button_loadTexturePressed(Button_leave, "res/private/login/img_fh_2.png")
	GUI:Button_setScale9Slice(Button_leave, 15, 15, 11, 11)
	GUI:setContentSize(Button_leave, 146, 54)
	GUI:setIgnoreContentAdaptWithSize(Button_leave, false)
	GUI:Button_setTitleText(Button_leave, "")
	GUI:Button_setTitleColor(Button_leave, "#ffffff")
	GUI:Button_setTitleFontSize(Button_leave, 14)
	GUI:Button_titleEnableOutline(Button_leave, "#000000", 1)
	GUI:setAnchorPoint(Button_leave, 0.50, 0.50)
	GUI:setTouchEnabled(Button_leave, true)
	GUI:setTag(Button_leave, 60)

	-- Create Image_leave
	local Image_leave = GUI:Image_Create(Button_leave, "Image_leave", 73.00, 27.00, "res/private/login/c00002.png")
	GUI:setAnchorPoint(Image_leave, 0.50, 0.50)
	GUI:setTouchEnabled(Image_leave, false)
	GUI:setTag(Image_leave, 387)
	GUI:setVisible(Image_leave, false)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_leave, "TouchSize", 73.00, 27.00, 95.00, 40.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 69)
	GUI:setVisible(TouchSize, false)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_act, "Button_create", -304.00, 54.00, "res/private/login/img_cjjs_1.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/img_cjjs_2.png")
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#ffffff")
	GUI:Button_setTitleFontSize(Button_create, 14)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 1)
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, 38)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_create, "TouchSize", 73.00, 27.00, 95.00, 40.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 70)
	GUI:setVisible(TouchSize, false)

	-- Create Image_create
	local Image_create = GUI:Image_Create(Button_create, "Image_create", 73.00, 27.00, "res/private/login/c00001.png")
	GUI:setAnchorPoint(Image_create, 0.50, 0.50)
	GUI:setTouchEnabled(Image_create, false)
	GUI:setTag(Image_create, 382)
	GUI:setVisible(Image_create, false)

	-- Create Button_delete
	local Button_delete = GUI:Button_Create(Panel_act, "Button_delete", 160.00, 54.00, "res/private/login/img_scjs_1.png")
	GUI:Button_loadTexturePressed(Button_delete, "res/private/login/img_scjs_2.png")
	GUI:Button_setScale9Slice(Button_delete, 15, 15, 11, 11)
	GUI:setContentSize(Button_delete, 146, 54)
	GUI:setIgnoreContentAdaptWithSize(Button_delete, false)
	GUI:Button_setTitleText(Button_delete, "")
	GUI:Button_setTitleColor(Button_delete, "#ffffff")
	GUI:Button_setTitleFontSize(Button_delete, 14)
	GUI:Button_titleEnableOutline(Button_delete, "#000000", 1)
	GUI:setAnchorPoint(Button_delete, 0.50, 0.50)
	GUI:setTouchEnabled(Button_delete, true)
	GUI:setTag(Button_delete, 35)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_delete, "TouchSize", 73.00, 27.00, 95.00, 40.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 71)
	GUI:setVisible(TouchSize, false)

	-- Create Image_delete
	local Image_delete = GUI:Image_Create(Button_delete, "Image_delete", 73.00, 27.00, "res/private/login/c00006.png")
	GUI:setAnchorPoint(Image_delete, 0.50, 0.50)
	GUI:setTouchEnabled(Image_delete, false)
	GUI:setTag(Image_delete, 384)
	GUI:setVisible(Image_delete, false)

	-- Create Button_restore
	local Button_restore = GUI:Button_Create(Panel_act, "Button_restore", -160.00, 54.00, "res/private/login/img_hfjs_1.png")
	GUI:Button_loadTexturePressed(Button_restore, "res/private/login/img_hfjs_2.png")
	GUI:Button_setScale9Slice(Button_restore, 15, 15, 11, 11)
	GUI:setContentSize(Button_restore, 146, 54)
	GUI:setIgnoreContentAdaptWithSize(Button_restore, false)
	GUI:Button_setTitleText(Button_restore, "")
	GUI:Button_setTitleColor(Button_restore, "#ffffff")
	GUI:Button_setTitleFontSize(Button_restore, 14)
	GUI:Button_titleEnableOutline(Button_restore, "#000000", 1)
	GUI:setAnchorPoint(Button_restore, 0.50, 0.50)
	GUI:setTouchEnabled(Button_restore, true)
	GUI:setTag(Button_restore, 36)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_restore, "TouchSize", 73.00, 27.00, 95.00, 40.00, false)
	GUI:setAnchorPoint(TouchSize, 0.50, 0.50)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 72)
	GUI:setVisible(TouchSize, false)

	-- Create Image_restore
	local Image_restore = GUI:Image_Create(Button_restore, "Image_restore", 73.00, 27.00, "res/private/login/c00004.png")
	GUI:setAnchorPoint(Image_restore, 0.50, 0.50)
	GUI:setTouchEnabled(Image_restore, false)
	GUI:setTag(Image_restore, 383)
	GUI:setVisible(Image_restore, false)

	-- Create Panel_anim
	local Panel_anim = GUI:Layout_Create(Panel_bg, "Panel_anim", 266.00, 112.00, 490.00, 474.00, false)
	GUI:setTouchEnabled(Panel_anim, false)
	GUI:setTag(Panel_anim, 152)
end
return ui