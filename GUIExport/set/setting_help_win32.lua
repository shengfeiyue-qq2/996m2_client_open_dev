local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 606.00, 390.00, false)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 6)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_1, "Image_1", 14.00, 380.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_1, 33, 33, 9, 9)
	GUI:setContentSize(Image_1, 578, 370)
	GUI:setIgnoreContentAdaptWithSize(Image_1, false)
	GUI:setAnchorPoint(Image_1, 0.00, 1.00)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 19)

	-- Create Image_6
	local Image_6 = GUI:Image_Create(Image_1, "Image_6", 127.00, 0.00, "res/private/new_setting/textBg.png")
	GUI:Image_setScale9Slice(Image_6, 33, 33, 9, 9)
	GUI:setContentSize(Image_6, 450, 369)
	GUI:setIgnoreContentAdaptWithSize(Image_6, false)
	GUI:setTouchEnabled(Image_6, false)
	GUI:setTag(Image_6, 193)

	-- Create ListView_1
	local ListView_1 = GUI:ListView_Create(Image_1, "ListView_1", 130.00, 3.00, 445.00, 362.00, 1)
	GUI:ListView_setBackGroundImageScale9Slice(ListView_1, -33, -478, -9, -371)
	GUI:ListView_setGravity(ListView_1, 5)
	GUI:setTouchEnabled(ListView_1, true)
	GUI:setTag(ListView_1, 518)

	-- Create Text_1
	local Text_1 = GUI:Text_Create(ListView_1, "Text_1", 178.50, 307.50, 12, "#ffffff", [[快捷键说明
  F1到F8   可以自设置的技能快捷键
  F9       打开/关闭包裹窗口
  F10      打开/关闭角色窗口
  F11      打开/关闭角色技能窗口
  F12      打开/关闭辅助功能窗口
  Alt+X    返回到角色选择界面
  Alt+Q    直接退出游戏
  Pause    在游戏中截图保存在游戏\Images目录下面 
  Ctrl+B   打开/关闭商铺窗口
  Ctrl+H   选择自己喜欢的攻击模式：
  　和平攻击模式 - 对任何玩家攻击都无效
  　行会攻击模式 - 对自己行会内的其他玩家攻击无效
  　编组攻击模式 - 处于同一小组的玩家攻击无效
  　全体攻击模式 - 对所有的玩家都具有攻击效果
  　善恶攻击模式 - PK红名专用攻击模式
特殊命令说明
  /玩家名字     私聊
  !交流文字     喊话
  !!文字        组队聊天
  !~文字        行会聊天
  !#文字        国家聊天
  上下方向键    查看过去的聊天信息
  @拒绝私聊     拒绝所有的私人聊天的命令
  @拒绝+人名    对特定的某一个人聊天文字进行屏蔽 
  @拒绝行会聊天 屏蔽行会聊天所有消息的命令 
  @退出门派     脱离行会 
快速编组说明
  鼠标点中要组队的角色同时按ALT+W即可自动和该角色组队，再次
  按ALT+E即可自动把该角色从队伍中删除
英雄操作快捷键
  Ctrl+E  切换英雄三中状态：跟随、休息、战斗 
  Ctrl+Q  启动/关闭英雄“守护”状态
  Ctrl+W  指定英雄攻击鼠标点中的目标
  Ctrl+S  释放合击技能
其他快捷键
  TAB           切换小地图.
  Alt+W         快速组队
  Alt+鼠标右键  快速复制人名.
  M键           显示自动寻路窗口
  Esc键         关闭所有窗口]])
	GUI:setAnchorPoint(Text_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_1, false)
	GUI:setTag(Text_1, 541)
	GUI:Text_enableOutline(Text_1, "#000000", 1)

	-- Create ListView_2
	local ListView_2 = GUI:ListView_Create(Image_1, "ListView_2", 4.00, 367.00, 120.00, 364.00, 1)
	GUI:ListView_setGravity(ListView_2, 2)
	GUI:ListView_setItemsMargin(ListView_2, 10)
	GUI:setAnchorPoint(ListView_2, 0.00, 1.00)
	GUI:setTouchEnabled(ListView_2, true)
	GUI:setTag(ListView_2, 520)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Image_1, "Button_1", 0.00, 402.00, "res/public/1900000673.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public/1900000674.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/public/1900000674.png")
	GUI:Button_setScale9Slice(Button_1, 16, 14, 12, 10)
	GUI:setContentSize(Button_1, 120, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "隐私")
	GUI:Button_setTitleColor(Button_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_1, 16)
	GUI:Button_titleEnableOutline(Button_1, "#000000", 1)
	GUI:setAnchorPoint(Button_1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 540)
end
return ui