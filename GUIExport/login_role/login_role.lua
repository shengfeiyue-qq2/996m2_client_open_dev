local ui = {}
function ui.init(parent)
	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(parent, "Panel_touch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_touch, "触摸层")
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_bg, "创建角色_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, -1)

	-- Create Image_server_bg
	local Image_server_bg = GUI:Image_Create(Panel_bg, "Image_server_bg", 568.00, 640.00, "res/private/login/bg_cjzy_05.png")
	GUI:setChineseName(Image_server_bg, "创建角色_区服背景图")
	GUI:setAnchorPoint(Image_server_bg, 0.50, 1.00)
	GUI:setTouchEnabled(Image_server_bg, false)
	GUI:setTag(Image_server_bg, -1)

	-- Create Text_server_name
	local Text_server_name = GUI:Text_Create(Panel_bg, "Text_server_name", 568.00, 627.00, 15, "#ffffff", [[服务器名]])
	GUI:setChineseName(Text_server_name, "创建角色_区服名称_文本")
	GUI:setAnchorPoint(Text_server_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_server_name, false)
	GUI:setTag(Text_server_name, -1)
	GUI:Text_enableOutline(Text_server_name, "#000000", 1)

	-- Create Panel_role_1
	local Panel_role_1 = GUI:Layout_Create(Panel_bg, "Panel_role_1", 568.00, 595.00, 350.00, 400.00, false)
	GUI:setChineseName(Panel_role_1, "创建角色_角色框1_组合")
	GUI:setAnchorPoint(Panel_role_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_1, true)
	GUI:setTag(Panel_role_1, -1)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_role_1, "Image_1", 175.00, 200.00, "res/private/login/bg_cjzy_03.png")
	GUI:setChineseName(Image_1, "创建角色_角色框1_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, -1)

	-- Create Node_anim_1
	local Node_anim_1 = GUI:Node_Create(Panel_role_1, "Node_anim_1", 175.00, 0.00)
	GUI:setChineseName(Node_anim_1, "创建角色_角色1_节点")
	GUI:setTag(Node_anim_1, -1)

	-- Create Panel_role_2
	local Panel_role_2 = GUI:Layout_Create(Panel_bg, "Panel_role_2", 568.00, 595.00, 350.00, 400.00, false)
	GUI:setChineseName(Panel_role_2, "创建角色_角色框2_组合")
	GUI:setAnchorPoint(Panel_role_2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_role_2, true)
	GUI:setTag(Panel_role_2, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_role_2, "Image_2", 175.00, 200.00, "res/private/login/bg_cjzy_04.png")
	GUI:setChineseName(Image_2, "创建角色_角色框2_背景图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)

	-- Create Node_anim_2
	local Node_anim_2 = GUI:Node_Create(Panel_role_2, "Node_anim_2", 175.00, 0.00)
	GUI:setChineseName(Node_anim_2, "创建角色_角色2_节点")
	GUI:setTag(Node_anim_2, -1)

	-- Create Panel_info_1
	local Panel_info_1 = GUI:Layout_Create(Panel_bg, "Panel_info_1", 284.00, 0.00, 210.00, 200.00, false)
	GUI:setChineseName(Panel_info_1, "角色信息1_组合")
	GUI:setAnchorPoint(Panel_info_1, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_info_1, false)
	GUI:setTag(Panel_info_1, -1)

	-- Create Img_infoBg_1
	local Img_infoBg_1 = GUI:Image_Create(Panel_info_1, "Img_infoBg_1", 105.00, 100.00, "res/private/login/bg_cjzy_01.png")
	GUI:setChineseName(Img_infoBg_1, "角色信息_背景图")
	GUI:setAnchorPoint(Img_infoBg_1, 0.50, 0.50)
	GUI:setTouchEnabled(Img_infoBg_1, false)
	GUI:setTag(Img_infoBg_1, -1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_info_1, "Image_3", 45.00, 140.00, "res/private/login/word_cjzy_04.png")
	GUI:setChineseName(Image_3, "角色信息_标识")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, -1)

	-- Create Button_select_1
	local Button_select_1 = GUI:Button_Create(Panel_info_1, "Button_select_1", 140.00, 140.00, "res/private/login/btn_cjzy_01.png")
	GUI:Button_loadTexturePressed(Button_select_1, "res/private/login/btn_cjzy_01_1.png")
	GUI:Button_setTitleText(Button_select_1, "选 择")
	GUI:Button_setTitleColor(Button_select_1, "#b0977a")
	GUI:Button_setTitleFontSize(Button_select_1, 16)
	GUI:Button_titleEnableOutline(Button_select_1, "#000000", 2)
	GUI:setChineseName(Button_select_1, "角色信息_选择_按钮")
	GUI:setAnchorPoint(Button_select_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_select_1, true)
	GUI:setTag(Button_select_1, -1)

	-- Create Text_info1
	local Text_info1 = GUI:Text_Create(Panel_info_1, "Text_info1", 20.00, 105.00, 16, "#b0977a", [[名字]])
	GUI:setChineseName(Text_info1, "角色信息_名字_文本")
	GUI:setAnchorPoint(Text_info1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info1, false)
	GUI:setTag(Text_info1, -1)
	GUI:Text_enableOutline(Text_info1, "#000000", 2)

	-- Create Text_info1_0
	local Text_info1_0 = GUI:Text_Create(Panel_info_1, "Text_info1_0", 20.00, 77.00, 16, "#b0977a", [[等级]])
	GUI:setChineseName(Text_info1_0, "角色信息_等级_文本")
	GUI:setAnchorPoint(Text_info1_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info1_0, false)
	GUI:setTag(Text_info1_0, -1)
	GUI:Text_enableOutline(Text_info1_0, "#000000", 2)

	-- Create Text_info1_1
	local Text_info1_1 = GUI:Text_Create(Panel_info_1, "Text_info1_1", 20.00, 50.00, 16, "#b0977a", [[职业]])
	GUI:setChineseName(Text_info1_1, "角色信息_职业_文本")
	GUI:setAnchorPoint(Text_info1_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info1_1, false)
	GUI:setTag(Text_info1_1, -1)
	GUI:Text_enableOutline(Text_info1_1, "#000000", 2)

	-- Create Image_10
	local Image_10 = GUI:Image_Create(Panel_info_1, "Image_10", 65.00, 105.00, "res/private/login/bg_cjzy_00.png")
	GUI:setContentSize(Image_10, 120, 20)
	GUI:setIgnoreContentAdaptWithSize(Image_10, false)
	GUI:setChineseName(Image_10, "角色信息_名字_背景框")
	GUI:setAnchorPoint(Image_10, 0.00, 0.50)
	GUI:setTouchEnabled(Image_10, false)
	GUI:setTag(Image_10, -1)

	-- Create Image_11
	local Image_11 = GUI:Image_Create(Panel_info_1, "Image_11", 65.00, 77.00, "res/private/login/bg_cjzy_00.png")
	GUI:setContentSize(Image_11, 120, 20)
	GUI:setIgnoreContentAdaptWithSize(Image_11, false)
	GUI:setChineseName(Image_11, "角色信息_等级_背景框")
	GUI:setAnchorPoint(Image_11, 0.00, 0.50)
	GUI:setTouchEnabled(Image_11, false)
	GUI:setTag(Image_11, -1)

	-- Create Image_12
	local Image_12 = GUI:Image_Create(Panel_info_1, "Image_12", 65.00, 50.00, "res/private/login/bg_cjzy_00.png")
	GUI:setContentSize(Image_12, 120, 20)
	GUI:setIgnoreContentAdaptWithSize(Image_12, false)
	GUI:setChineseName(Image_12, "角色信息_职业_背景框")
	GUI:setAnchorPoint(Image_12, 0.00, 0.50)
	GUI:setTouchEnabled(Image_12, false)
	GUI:setTag(Image_12, -1)

	-- Create Text_name_1
	local Text_name_1 = GUI:Text_Create(Panel_info_1, "Text_name_1", 70.00, 106.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_name_1, "角色信息_玩家昵称_文本")
	GUI:setAnchorPoint(Text_name_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name_1, false)
	GUI:setTag(Text_name_1, -1)
	GUI:Text_enableOutline(Text_name_1, "#000000", 1)

	-- Create Text_level_1
	local Text_level_1 = GUI:Text_Create(Panel_info_1, "Text_level_1", 70.00, 77.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_level_1, "角色信息_玩家等级_文本")
	GUI:setAnchorPoint(Text_level_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level_1, false)
	GUI:setTag(Text_level_1, -1)
	GUI:Text_enableOutline(Text_level_1, "#000000", 1)

	-- Create Text_job_1
	local Text_job_1 = GUI:Text_Create(Panel_info_1, "Text_job_1", 70.00, 50.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_job_1, "角色信息_玩家职业_文本")
	GUI:setAnchorPoint(Text_job_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job_1, false)
	GUI:setTag(Text_job_1, -1)
	GUI:Text_enableOutline(Text_job_1, "#000000", 1)

	-- Create Panel_info_2
	local Panel_info_2 = GUI:Layout_Create(Panel_bg, "Panel_info_2", 852.00, 0.00, 210.00, 200.00, false)
	GUI:setChineseName(Panel_info_2, "角色信息2_组合")
	GUI:setAnchorPoint(Panel_info_2, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_info_2, false)
	GUI:setTag(Panel_info_2, -1)

	-- Create Img_infoBg_2
	local Img_infoBg_2 = GUI:Image_Create(Panel_info_2, "Img_infoBg_2", 105.00, 100.00, "res/private/login/bg_cjzy_01_1.png")
	GUI:setChineseName(Img_infoBg_2, "角色信息_背景图")
	GUI:setAnchorPoint(Img_infoBg_2, 0.50, 0.50)
	GUI:setTouchEnabled(Img_infoBg_2, false)
	GUI:setTag(Img_infoBg_2, -1)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_info_2, "Image_4", 45.00, 140.00, "res/private/login/word_cjzy_05.png")
	GUI:setChineseName(Image_4, "角色信息_标识")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, -1)

	-- Create Button_select_2
	local Button_select_2 = GUI:Button_Create(Panel_info_2, "Button_select_2", 140.00, 140.00, "res/private/login/btn_cjzy_02.png")
	GUI:Button_loadTexturePressed(Button_select_2, "res/private/login/btn_cjzy_02_1.png")
	GUI:Button_setTitleText(Button_select_2, "选 择")
	GUI:Button_setTitleColor(Button_select_2, "#b0977a")
	GUI:Button_setTitleFontSize(Button_select_2, 16)
	GUI:Button_titleEnableOutline(Button_select_2, "#000000", 2)
	GUI:setChineseName(Button_select_2, "角色信息_选择_按钮")
	GUI:setAnchorPoint(Button_select_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_select_2, true)
	GUI:setTag(Button_select_2, -1)

	-- Create Text_info2
	local Text_info2 = GUI:Text_Create(Panel_info_2, "Text_info2", 20.00, 105.00, 16, "#b0977a", [[名字]])
	GUI:setChineseName(Text_info2, "角色信息_名字_文本")
	GUI:setAnchorPoint(Text_info2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info2, false)
	GUI:setTag(Text_info2, -1)
	GUI:Text_enableOutline(Text_info2, "#000000", 2)

	-- Create Text_info2_0
	local Text_info2_0 = GUI:Text_Create(Panel_info_2, "Text_info2_0", 20.00, 77.00, 16, "#b0977a", [[等级]])
	GUI:setChineseName(Text_info2_0, "角色信息_等级_文本")
	GUI:setAnchorPoint(Text_info2_0, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info2_0, false)
	GUI:setTag(Text_info2_0, -1)
	GUI:Text_enableOutline(Text_info2_0, "#000000", 2)

	-- Create Text_info2_1
	local Text_info2_1 = GUI:Text_Create(Panel_info_2, "Text_info2_1", 20.00, 50.00, 16, "#b0977a", [[职业]])
	GUI:setChineseName(Text_info2_1, "角色信息_职业_文本")
	GUI:setAnchorPoint(Text_info2_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_info2_1, false)
	GUI:setTag(Text_info2_1, -1)
	GUI:Text_enableOutline(Text_info2_1, "#000000", 2)

	-- Create Image_13
	local Image_13 = GUI:Image_Create(Panel_info_2, "Image_13", 65.00, 105.00, "res/private/login/bg_cjzy_00.png")
	GUI:setContentSize(Image_13, 120, 20)
	GUI:setIgnoreContentAdaptWithSize(Image_13, false)
	GUI:setChineseName(Image_13, "角色信息_名字_背景框")
	GUI:setAnchorPoint(Image_13, 0.00, 0.50)
	GUI:setTouchEnabled(Image_13, false)
	GUI:setTag(Image_13, -1)

	-- Create Image_14
	local Image_14 = GUI:Image_Create(Panel_info_2, "Image_14", 65.00, 77.00, "res/private/login/bg_cjzy_00.png")
	GUI:setContentSize(Image_14, 120, 20)
	GUI:setIgnoreContentAdaptWithSize(Image_14, false)
	GUI:setChineseName(Image_14, "角色信息_等级_背景框")
	GUI:setAnchorPoint(Image_14, 0.00, 0.50)
	GUI:setTouchEnabled(Image_14, false)
	GUI:setTag(Image_14, -1)

	-- Create Image_15
	local Image_15 = GUI:Image_Create(Panel_info_2, "Image_15", 65.00, 50.00, "res/private/login/bg_cjzy_00.png")
	GUI:setContentSize(Image_15, 120, 20)
	GUI:setIgnoreContentAdaptWithSize(Image_15, false)
	GUI:setChineseName(Image_15, "角色信息_职业_背景框")
	GUI:setAnchorPoint(Image_15, 0.00, 0.50)
	GUI:setTouchEnabled(Image_15, false)
	GUI:setTag(Image_15, -1)

	-- Create Text_name_2
	local Text_name_2 = GUI:Text_Create(Panel_info_2, "Text_name_2", 70.00, 106.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_name_2, "角色信息_玩家昵称_文本")
	GUI:setAnchorPoint(Text_name_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name_2, false)
	GUI:setTag(Text_name_2, -1)
	GUI:Text_enableOutline(Text_name_2, "#000000", 1)

	-- Create Text_level_2
	local Text_level_2 = GUI:Text_Create(Panel_info_2, "Text_level_2", 70.00, 77.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_level_2, "角色信息_玩家等级_文本")
	GUI:setAnchorPoint(Text_level_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level_2, false)
	GUI:setTag(Text_level_2, -1)
	GUI:Text_enableOutline(Text_level_2, "#000000", 1)

	-- Create Text_job_2
	local Text_job_2 = GUI:Text_Create(Panel_info_2, "Text_job_2", 70.00, 50.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Text_job_2, "角色信息_玩家职业_文本")
	GUI:setAnchorPoint(Text_job_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job_2, false)
	GUI:setTag(Text_job_2, -1)
	GUI:Text_enableOutline(Text_job_2, "#000000", 1)

	-- Create Panel_act
	local Panel_act = GUI:Layout_Create(Panel_bg, "Panel_act", 568.00, 0.00, 350.00, 200.00, false)
	GUI:setChineseName(Panel_act, "角色操作_组合框")
	GUI:setAnchorPoint(Panel_act, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_act, false)
	GUI:setTag(Panel_act, -1)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Panel_act, "Image_5", 175.00, 100.00, "res/private/login/bg_cjzy_01_2.png")
	GUI:setChineseName(Image_5, "角色操作_背景图")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, -1)

	-- Create Button_start
	local Button_start = GUI:Button_Create(Panel_act, "Button_start", 175.00, 144.00, "res/private/login/btn_kqyx_01.png")
	GUI:Button_loadTexturePressed(Button_start, "res/private/login/btn_fhyx_01_1.png")
	GUI:Button_setTitleText(Button_start, "开  始")
	GUI:Button_setTitleColor(Button_start, "#ffe400")
	GUI:Button_setTitleFontSize(Button_start, 16)
	GUI:Button_titleEnableOutline(Button_start, "#000000", 2)
	GUI:setChineseName(Button_start, "角色操作_开始_按钮")
	GUI:setAnchorPoint(Button_start, 0.50, 0.50)
	GUI:setTouchEnabled(Button_start, true)
	GUI:setTag(Button_start, -1)

	-- Create Button_leave
	local Button_leave = GUI:Button_Create(Panel_act, "Button_leave", 276.00, 100.00, "res/private/login/btn_fhyx_01.png")
	GUI:Button_loadTexturePressed(Button_leave, "res/private/login/btn_fhyx_01_1.png")
	GUI:Button_setTitleText(Button_leave, "返  回")
	GUI:Button_setTitleColor(Button_leave, "#b0977a")
	GUI:Button_setTitleFontSize(Button_leave, 16)
	GUI:Button_titleEnableOutline(Button_leave, "#000000", 2)
	GUI:setChineseName(Button_leave, "角色操作_返回_按钮")
	GUI:setAnchorPoint(Button_leave, 0.50, 0.50)
	GUI:setTouchEnabled(Button_leave, true)
	GUI:setTag(Button_leave, -1)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_act, "Button_create", 74.00, 100.00, "res/private/login/btn_hfrw_01.png")
	GUI:Button_loadTexturePressed(Button_create, "res/private/login/btn_fhyx_01_1.png")
	GUI:Button_setTitleText(Button_create, "创建人物")
	GUI:Button_setTitleColor(Button_create, "#ffe400")
	GUI:Button_setTitleFontSize(Button_create, 16)
	GUI:Button_titleEnableOutline(Button_create, "#000000", 2)
	GUI:setChineseName(Button_create, "角色操作_创建_按钮")
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, -1)

	-- Create Button_delete
	local Button_delete = GUI:Button_Create(Panel_act, "Button_delete", 175.00, 100.00, "res/private/login/btn_scrw_01.png")
	GUI:Button_loadTexturePressed(Button_delete, "res/private/login/btn_fhyx_01_1.png")
	GUI:Button_setTitleText(Button_delete, "删除人物")
	GUI:Button_setTitleColor(Button_delete, "#b0977a")
	GUI:Button_setTitleFontSize(Button_delete, 16)
	GUI:Button_titleEnableOutline(Button_delete, "#000000", 2)
	GUI:setChineseName(Button_delete, "角色操作_删除_按钮")
	GUI:setAnchorPoint(Button_delete, 0.50, 0.50)
	GUI:setTouchEnabled(Button_delete, true)
	GUI:setTag(Button_delete, -1)

	-- Create Button_restore
	local Button_restore = GUI:Button_Create(Panel_act, "Button_restore", 175.00, 56.00, "res/private/login/btn_hfrw_01.png")
	GUI:Button_loadTexturePressed(Button_restore, "res/private/login/btn_fhyx_01_1.png")
	GUI:Button_setTitleText(Button_restore, "恢复人物")
	GUI:Button_setTitleColor(Button_restore, "#b0977a")
	GUI:Button_setTitleFontSize(Button_restore, 16)
	GUI:Button_titleEnableOutline(Button_restore, "#000000", 2)
	GUI:setChineseName(Button_restore, "角色操作_恢复_按钮")
	GUI:setAnchorPoint(Button_restore, 0.50, 0.50)
	GUI:setTouchEnabled(Button_restore, true)
	GUI:setTag(Button_restore, -1)
end
return ui