local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 348.00, 478.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 39)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 174.00, 239.00, "res/private/internal/ng_bg.png")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 244)

	-- Create Panel_content
	local Panel_content = GUI:Layout_Create(Panel_1, "Panel_content", 174.00, 16.00, 310.00, 446.00, false)
	GUI:setAnchorPoint(Panel_content, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_content, true)
	GUI:setTag(Panel_content, 247)

	-- Create Image_show
	local Image_show = GUI:Image_Create(Panel_content, "Image_show", 0.00, 444.00, "res/private/internal/m_bg0_0.png")
	GUI:setAnchorPoint(Image_show, 0.00, 1.00)
	GUI:setTouchEnabled(Image_show, false)
	GUI:setTag(Image_show, -1)

	-- Create Image_m
	local Image_m = GUI:Image_Create(Image_show, "Image_m", 0.00, 0.00, "res/private/internal/meridian_ui/qijing_00.png")
	GUI:setTouchEnabled(Image_m, false)
	GUI:setTag(Image_m, -1)

	-- Create Image_l
	local Image_l = GUI:Image_Create(Image_show, "Image_l", 0.00, 0.00, "res/private/internal/meridian_ui/qijing_xing.png")
	GUI:setTouchEnabled(Image_l, false)
	GUI:setTag(Image_l, -1)

	-- Create Image_icon
	local Image_icon = GUI:Image_Create(Image_show, "Image_icon", 160.00, 276.00, "res/private/internal/meridian_ui/1.png")
	GUI:setTouchEnabled(Image_icon, false)
	GUI:setTag(Image_icon, -1)

	-- Create Text_show
	local Text_show = GUI:Text_Create(Image_show, "Text_show", 177.00, 36.00, 16, "#efd6ad", [[几
重
经
络]])
	GUI:setTouchEnabled(Text_show, false)
	GUI:setTag(Text_show, -1)
	GUI:setVisible(Text_show, false)
	GUI:Text_enableOutline(Text_show, "#000000", 1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(Panel_content, "Image_line", 214.00, 0.00, "res/private/internal/line_0.png")
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, -1)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_content, "Button_1", 221.00, 378.00, "res/private/internal/1_1.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/internal/1_2.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/internal/1_2.png")
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, -1)

	-- Create Button_2
	local Button_2 = GUI:Button_Create(Panel_content, "Button_2", 221.00, 313.00, "res/private/internal/2_1.png")
	GUI:Button_loadTexturePressed(Button_2, "res/private/internal/2_2.png")
	GUI:Button_loadTextureDisabled(Button_2, "res/private/internal/2_2.png")
	GUI:Button_setTitleText(Button_2, "")
	GUI:Button_setTitleColor(Button_2, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_2, 14)
	GUI:Button_titleEnableOutline(Button_2, "#000000", 1)
	GUI:setTouchEnabled(Button_2, true)
	GUI:setTag(Button_2, -1)

	-- Create Button_3
	local Button_3 = GUI:Button_Create(Panel_content, "Button_3", 221.00, 248.00, "res/private/internal/3_1.png")
	GUI:Button_loadTexturePressed(Button_3, "res/private/internal/3_2.png")
	GUI:Button_loadTextureDisabled(Button_3, "res/private/internal/3_2.png")
	GUI:Button_setTitleText(Button_3, "")
	GUI:Button_setTitleColor(Button_3, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_3, 14)
	GUI:Button_titleEnableOutline(Button_3, "#000000", 1)
	GUI:setTouchEnabled(Button_3, true)
	GUI:setTag(Button_3, -1)
	GUI:setVisible(Button_3, false)

	-- Create Button_4
	local Button_4 = GUI:Button_Create(Panel_content, "Button_4", 221.00, 184.00, "res/private/internal/4_1.png")
	GUI:Button_loadTexturePressed(Button_4, "res/private/internal/4_2.png")
	GUI:Button_loadTextureDisabled(Button_4, "res/private/internal/4_2.png")
	GUI:Button_setTitleText(Button_4, "")
	GUI:Button_setTitleColor(Button_4, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_4, 14)
	GUI:Button_titleEnableOutline(Button_4, "#000000", 1)
	GUI:setTouchEnabled(Button_4, true)
	GUI:setTag(Button_4, -1)
	GUI:setVisible(Button_4, false)

	-- Create Button_5
	local Button_5 = GUI:Button_Create(Panel_content, "Button_5", 221.00, 124.00, "res/private/internal/5_1.png")
	GUI:Button_loadTexturePressed(Button_5, "res/private/internal/5_2.png")
	GUI:Button_loadTextureDisabled(Button_5, "res/private/internal/5_2.png")
	GUI:Button_setTitleText(Button_5, "")
	GUI:Button_setTitleColor(Button_5, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_5, 14)
	GUI:Button_titleEnableOutline(Button_5, "#000000", 1)
	GUI:setTouchEnabled(Button_5, true)
	GUI:setTag(Button_5, -1)
	GUI:setVisible(Button_5, false)

	-- Create Panel_show_1
	local Panel_show_1 = GUI:Layout_Create(Panel_content, "Panel_show_1", 0.00, 444.00, 214.00, 333.00, false)
	GUI:setAnchorPoint(Panel_show_1, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_show_1, false)
	GUI:setTag(Panel_show_1, -1)

	-- Create point_1
	local point_1 = GUI:Button_Create(Panel_show_1, "point_1", 90.00, 261.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_1, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_1, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_1, "")
	GUI:Button_setTitleColor(point_1, "#efd6ad")
	GUI:Button_setTitleFontSize(point_1, 14)
	GUI:Button_titleEnableOutline(point_1, "#000000", 1)
	GUI:setTouchEnabled(point_1, true)
	GUI:setTag(point_1, -1)

	-- Create point_2
	local point_2 = GUI:Button_Create(Panel_show_1, "point_2", 155.00, 134.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_2, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_2, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_2, "")
	GUI:Button_setTitleColor(point_2, "#efd6ad")
	GUI:Button_setTitleFontSize(point_2, 14)
	GUI:Button_titleEnableOutline(point_2, "#000000", 1)
	GUI:setTouchEnabled(point_2, true)
	GUI:setTag(point_2, -1)

	-- Create point_3
	local point_3 = GUI:Button_Create(Panel_show_1, "point_3", 23.00, 134.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_3, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_3, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_3, "")
	GUI:Button_setTitleColor(point_3, "#efd6ad")
	GUI:Button_setTitleFontSize(point_3, 14)
	GUI:Button_titleEnableOutline(point_3, "#000000", 1)
	GUI:setTouchEnabled(point_3, true)
	GUI:setTag(point_3, -1)

	-- Create point_4
	local point_4 = GUI:Button_Create(Panel_show_1, "point_4", 115.00, 14.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_4, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_4, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_4, "")
	GUI:Button_setTitleColor(point_4, "#efd6ad")
	GUI:Button_setTitleFontSize(point_4, 14)
	GUI:Button_titleEnableOutline(point_4, "#000000", 1)
	GUI:setTouchEnabled(point_4, true)
	GUI:setTag(point_4, -1)

	-- Create point_5
	local point_5 = GUI:Button_Create(Panel_show_1, "point_5", 65.00, 15.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_5, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_5, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_5, "")
	GUI:Button_setTitleColor(point_5, "#efd6ad")
	GUI:Button_setTitleFontSize(point_5, 14)
	GUI:Button_titleEnableOutline(point_5, "#000000", 1)
	GUI:setTouchEnabled(point_5, true)
	GUI:setTag(point_5, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_show_1, "Text_1", 43.00, 269.00, 16, "#efd6ad", [[神冲]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_show_1, "Text_2", 127.00, 155.00, 16, "#efd6ad", [[夹脊]])
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_show_1, "Text_3", 47.00, 129.00, 16, "#efd6ad", [[二百]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_show_1, "Text_4", 91.00, 35.00, 16, "#efd6ad", [[八风]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_show_1, "Text_5", 27.00, 22.00, 16, "#efd6ad", [[涌泉]])
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, -1)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Button_up
	local Button_up = GUI:Button_Create(Panel_show_1, "Button_up", 12.00, -86.00, "res/private/internal/meridian_ui/btn_1.png")
	GUI:Button_loadTexturePressed(Button_up, "res/private/internal/meridian_ui/btn_2.png")
	GUI:Button_setTitleText(Button_up, "修炼奇经")
	GUI:Button_setTitleColor(Button_up, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleEnableOutline(Button_up, "#000000", 1)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, -1)

	-- Create Panel_show_2
	local Panel_show_2 = GUI:Layout_Create(Panel_content, "Panel_show_2", 0.00, 444.00, 214.00, 333.00, false)
	GUI:setAnchorPoint(Panel_show_2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_show_2, false)
	GUI:setTag(Panel_show_2, -1)
	GUI:setVisible(Panel_show_2, false)

	-- Create point_1
	local point_1 = GUI:Button_Create(Panel_show_2, "point_1", 74.00, 241.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_1, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_1, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_1, "")
	GUI:Button_setTitleColor(point_1, "#efd6ad")
	GUI:Button_setTitleFontSize(point_1, 14)
	GUI:Button_titleEnableOutline(point_1, "#000000", 1)
	GUI:setTouchEnabled(point_1, true)
	GUI:setTag(point_1, -1)

	-- Create point_2
	local point_2 = GUI:Button_Create(Panel_show_2, "point_2", 75.00, 202.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_2, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_2, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_2, "")
	GUI:Button_setTitleColor(point_2, "#efd6ad")
	GUI:Button_setTitleFontSize(point_2, 14)
	GUI:Button_titleEnableOutline(point_2, "#000000", 1)
	GUI:setTouchEnabled(point_2, true)
	GUI:setTag(point_2, -1)

	-- Create point_3
	local point_3 = GUI:Button_Create(Panel_show_2, "point_3", 78.00, 170.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_3, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_3, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_3, "")
	GUI:Button_setTitleColor(point_3, "#efd6ad")
	GUI:Button_setTitleFontSize(point_3, 14)
	GUI:Button_titleEnableOutline(point_3, "#000000", 1)
	GUI:setTouchEnabled(point_3, true)
	GUI:setTag(point_3, -1)

	-- Create point_4
	local point_4 = GUI:Button_Create(Panel_show_2, "point_4", 88.00, 137.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_4, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_4, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_4, "")
	GUI:Button_setTitleColor(point_4, "#efd6ad")
	GUI:Button_setTitleFontSize(point_4, 14)
	GUI:Button_titleEnableOutline(point_4, "#000000", 1)
	GUI:setTouchEnabled(point_4, true)
	GUI:setTag(point_4, -1)

	-- Create point_5
	local point_5 = GUI:Button_Create(Panel_show_2, "point_5", 99.00, 156.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_5, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_5, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_5, "")
	GUI:Button_setTitleColor(point_5, "#efd6ad")
	GUI:Button_setTitleFontSize(point_5, 14)
	GUI:Button_titleEnableOutline(point_5, "#000000", 1)
	GUI:setTouchEnabled(point_5, true)
	GUI:setTag(point_5, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_show_2, "Text_1", 127.00, 250.00, 16, "#efd6ad", [[幽门]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_show_2, "Text_2", 129.00, 209.00, 16, "#efd6ad", [[通谷]])
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_show_2, "Text_3", 31.00, 178.00, 16, "#efd6ad", [[商曲]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_show_2, "Text_4", 38.00, 144.00, 16, "#efd6ad", [[四满]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_show_2, "Text_5", 151.00, 165.00, 16, "#efd6ad", [[横骨]])
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, -1)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Button_up
	local Button_up = GUI:Button_Create(Panel_show_2, "Button_up", 12.00, -86.00, "res/private/internal/meridian_ui/btn_1.png")
	GUI:Button_loadTexturePressed(Button_up, "res/private/internal/meridian_ui/btn_2.png")
	GUI:Button_setTitleText(Button_up, "修炼冲脉")
	GUI:Button_setTitleColor(Button_up, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleEnableOutline(Button_up, "#000000", 1)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, -1)

	-- Create Panel_show_3
	local Panel_show_3 = GUI:Layout_Create(Panel_content, "Panel_show_3", 0.00, 444.00, 214.00, 333.00, false)
	GUI:setAnchorPoint(Panel_show_3, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_show_3, false)
	GUI:setTag(Panel_show_3, -1)
	GUI:setVisible(Panel_show_3, false)

	-- Create point_1
	local point_1 = GUI:Button_Create(Panel_show_3, "point_1", 91.00, 258.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_1, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_1, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_1, "")
	GUI:Button_setTitleColor(point_1, "#efd6ad")
	GUI:Button_setTitleFontSize(point_1, 14)
	GUI:Button_titleEnableOutline(point_1, "#000000", 1)
	GUI:setTouchEnabled(point_1, true)
	GUI:setTag(point_1, -1)

	-- Create point_2
	local point_2 = GUI:Button_Create(Panel_show_3, "point_2", 90.00, 184.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_2, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_2, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_2, "")
	GUI:Button_setTitleColor(point_2, "#efd6ad")
	GUI:Button_setTitleFontSize(point_2, 14)
	GUI:Button_titleEnableOutline(point_2, "#000000", 1)
	GUI:setTouchEnabled(point_2, true)
	GUI:setTag(point_2, -1)

	-- Create point_3
	local point_3 = GUI:Button_Create(Panel_show_3, "point_3", 99.00, 133.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_3, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_3, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_3, "")
	GUI:Button_setTitleColor(point_3, "#efd6ad")
	GUI:Button_setTitleFontSize(point_3, 14)
	GUI:Button_titleEnableOutline(point_3, "#000000", 1)
	GUI:setTouchEnabled(point_3, true)
	GUI:setTag(point_3, -1)

	-- Create point_4
	local point_4 = GUI:Button_Create(Panel_show_3, "point_4", 111.00, 81.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_4, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_4, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_4, "")
	GUI:Button_setTitleColor(point_4, "#efd6ad")
	GUI:Button_setTitleFontSize(point_4, 14)
	GUI:Button_titleEnableOutline(point_4, "#000000", 1)
	GUI:setTouchEnabled(point_4, true)
	GUI:setTag(point_4, -1)

	-- Create point_5
	local point_5 = GUI:Button_Create(Panel_show_3, "point_5", 115.00, 25.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_5, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_5, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_5, "")
	GUI:Button_setTitleColor(point_5, "#efd6ad")
	GUI:Button_setTitleFontSize(point_5, 14)
	GUI:Button_titleEnableOutline(point_5, "#000000", 1)
	GUI:setTouchEnabled(point_5, true)
	GUI:setTag(point_5, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_show_3, "Text_1", 43.00, 265.00, 16, "#efd6ad", [[晴明]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_show_3, "Text_2", 42.00, 192.00, 16, "#efd6ad", [[盘缺]])
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_show_3, "Text_3", 147.00, 142.00, 16, "#efd6ad", [[交信]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_show_3, "Text_4", 70.00, 88.00, 16, "#efd6ad", [[照海]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_show_3, "Text_5", 72.00, 33.00, 16, "#efd6ad", [[然谷]])
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, -1)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Button_up
	local Button_up = GUI:Button_Create(Panel_show_3, "Button_up", 12.00, -86.00, "res/private/internal/meridian_ui/btn_1.png")
	GUI:Button_loadTexturePressed(Button_up, "res/private/internal/meridian_ui/btn_2.png")
	GUI:Button_setTitleText(Button_up, "修炼阴跷")
	GUI:Button_setTitleColor(Button_up, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleEnableOutline(Button_up, "#000000", 1)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, -1)

	-- Create Panel_show_4
	local Panel_show_4 = GUI:Layout_Create(Panel_content, "Panel_show_4", 0.00, 444.00, 214.00, 333.00, false)
	GUI:setAnchorPoint(Panel_show_4, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_show_4, false)
	GUI:setTag(Panel_show_4, -1)
	GUI:setVisible(Panel_show_4, false)

	-- Create point_1
	local point_1 = GUI:Button_Create(Panel_show_4, "point_1", 89.00, 236.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_1, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_1, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_1, "")
	GUI:Button_setTitleColor(point_1, "#efd6ad")
	GUI:Button_setTitleFontSize(point_1, 14)
	GUI:Button_titleEnableOutline(point_1, "#000000", 1)
	GUI:setTouchEnabled(point_1, true)
	GUI:setTag(point_1, -1)

	-- Create point_2
	local point_2 = GUI:Button_Create(Panel_show_4, "point_2", 78.00, 189.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_2, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_2, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_2, "")
	GUI:Button_setTitleColor(point_2, "#efd6ad")
	GUI:Button_setTitleFontSize(point_2, 14)
	GUI:Button_titleEnableOutline(point_2, "#000000", 1)
	GUI:setTouchEnabled(point_2, true)
	GUI:setTag(point_2, -1)

	-- Create point_3
	local point_3 = GUI:Button_Create(Panel_show_4, "point_3", 79.00, 141.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_3, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_3, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_3, "")
	GUI:Button_setTitleColor(point_3, "#efd6ad")
	GUI:Button_setTitleFontSize(point_3, 14)
	GUI:Button_titleEnableOutline(point_3, "#000000", 1)
	GUI:setTouchEnabled(point_3, true)
	GUI:setTag(point_3, -1)

	-- Create point_4
	local point_4 = GUI:Button_Create(Panel_show_4, "point_4", 72.00, 92.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_4, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_4, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_4, "")
	GUI:Button_setTitleColor(point_4, "#efd6ad")
	GUI:Button_setTitleFontSize(point_4, 14)
	GUI:Button_titleEnableOutline(point_4, "#000000", 1)
	GUI:setTouchEnabled(point_4, true)
	GUI:setTag(point_4, -1)

	-- Create point_5
	local point_5 = GUI:Button_Create(Panel_show_4, "point_5", 68.00, 38.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_5, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_5, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_5, "")
	GUI:Button_setTitleColor(point_5, "#efd6ad")
	GUI:Button_setTitleFontSize(point_5, 14)
	GUI:Button_titleEnableOutline(point_5, "#000000", 1)
	GUI:setTouchEnabled(point_5, true)
	GUI:setTag(point_5, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_show_4, "Text_1", 41.00, 244.00, 16, "#efd6ad", [[廉泉]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_show_4, "Text_2", 134.00, 199.00, 16, "#efd6ad", [[期门]])
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_show_4, "Text_3", 35.00, 150.00, 16, "#efd6ad", [[府舍]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_show_4, "Text_4", 120.00, 101.00, 16, "#efd6ad", [[冲门]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_show_4, "Text_5", 113.00, 46.00, 16, "#efd6ad", [[筑宾]])
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, -1)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Button_up
	local Button_up = GUI:Button_Create(Panel_show_4, "Button_up", 12.00, -86.00, "res/private/internal/meridian_ui/btn_1.png")
	GUI:Button_loadTexturePressed(Button_up, "res/private/internal/meridian_ui/btn_2.png")
	GUI:Button_setTitleText(Button_up, "修炼阴维")
	GUI:Button_setTitleColor(Button_up, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleEnableOutline(Button_up, "#000000", 1)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, -1)

	-- Create Panel_show_5
	local Panel_show_5 = GUI:Layout_Create(Panel_content, "Panel_show_5", 0.00, 444.00, 214.00, 333.00, false)
	GUI:setAnchorPoint(Panel_show_5, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_show_5, false)
	GUI:setTag(Panel_show_5, -1)
	GUI:setVisible(Panel_show_5, false)

	-- Create point_1
	local point_1 = GUI:Button_Create(Panel_show_5, "point_1", 90.00, 258.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_1, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_1, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_1, "")
	GUI:Button_setTitleColor(point_1, "#efd6ad")
	GUI:Button_setTitleFontSize(point_1, 14)
	GUI:Button_titleEnableOutline(point_1, "#000000", 1)
	GUI:setTouchEnabled(point_1, true)
	GUI:setTag(point_1, -1)

	-- Create point_2
	local point_2 = GUI:Button_Create(Panel_show_5, "point_2", 90.00, 233.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_2, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_2, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_2, "")
	GUI:Button_setTitleColor(point_2, "#efd6ad")
	GUI:Button_setTitleFontSize(point_2, 14)
	GUI:Button_titleEnableOutline(point_2, "#000000", 1)
	GUI:setTouchEnabled(point_2, true)
	GUI:setTag(point_2, -1)

	-- Create point_3
	local point_3 = GUI:Button_Create(Panel_show_5, "point_3", 91.00, 201.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_3, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_3, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_3, "")
	GUI:Button_setTitleColor(point_3, "#efd6ad")
	GUI:Button_setTitleFontSize(point_3, 14)
	GUI:Button_titleEnableOutline(point_3, "#000000", 1)
	GUI:setTouchEnabled(point_3, true)
	GUI:setTag(point_3, -1)

	-- Create point_4
	local point_4 = GUI:Button_Create(Panel_show_5, "point_4", 90.00, 173.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_4, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_4, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_4, "")
	GUI:Button_setTitleColor(point_4, "#efd6ad")
	GUI:Button_setTitleFontSize(point_4, 14)
	GUI:Button_titleEnableOutline(point_4, "#000000", 1)
	GUI:setTouchEnabled(point_4, true)
	GUI:setTag(point_4, -1)

	-- Create point_5
	local point_5 = GUI:Button_Create(Panel_show_5, "point_5", 91.00, 132.00, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTexturePressed(point_5, "res/private/internal/meridian_ui/point_normal.png")
	GUI:Button_loadTextureDisabled(point_5, "res/private/internal/meridian_ui/point_active.png")
	GUI:Button_setTitleText(point_5, "")
	GUI:Button_setTitleColor(point_5, "#efd6ad")
	GUI:Button_setTitleFontSize(point_5, 14)
	GUI:Button_titleEnableOutline(point_5, "#000000", 1)
	GUI:setTouchEnabled(point_5, true)
	GUI:setTag(point_5, -1)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(Panel_show_5, "Text_1", 41.00, 265.00, 16, "#efd6ad", [[承浆]])
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, -1)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create Text_2
	local Text_2 = GUI:Text_Create(Panel_show_5, "Text_2", 145.00, 241.00, 16, "#efd6ad", [[天突]])
	GUI:setTouchEnabled(Text_2, false)
	GUI:setTag(Text_2, -1)
	GUI:Text_enableOutline(Text_2, "#000000", 1)

	-- Create Text_3
	local Text_3 = GUI:Text_Create(Panel_show_5, "Text_3", 42.00, 210.00, 16, "#efd6ad", [[鸠尾]])
	GUI:setTouchEnabled(Text_3, false)
	GUI:setTag(Text_3, -1)
	GUI:Text_enableOutline(Text_3, "#000000", 1)

	-- Create Text_4
	local Text_4 = GUI:Text_Create(Panel_show_5, "Text_4", 144.00, 181.00, 16, "#efd6ad", [[气海]])
	GUI:setTouchEnabled(Text_4, false)
	GUI:setTag(Text_4, -1)
	GUI:Text_enableOutline(Text_4, "#000000", 1)

	-- Create Text_5
	local Text_5 = GUI:Text_Create(Panel_show_5, "Text_5", 44.00, 141.00, 16, "#efd6ad", [[曲骨]])
	GUI:setTouchEnabled(Text_5, false)
	GUI:setTag(Text_5, -1)
	GUI:Text_enableOutline(Text_5, "#000000", 1)

	-- Create Button_up
	local Button_up = GUI:Button_Create(Panel_show_5, "Button_up", 12.00, -86.00, "res/private/internal/meridian_ui/btn_1.png")
	GUI:Button_loadTexturePressed(Button_up, "res/private/internal/meridian_ui/btn_2.png")
	GUI:Button_setTitleText(Button_up, "修炼任脉")
	GUI:Button_setTitleColor(Button_up, "#efd6ad")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleEnableOutline(Button_up, "#000000", 1)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, -1)
end
return ui