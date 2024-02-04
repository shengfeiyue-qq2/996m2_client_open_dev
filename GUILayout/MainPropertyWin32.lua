MainPropertyWin32 = {}

MainPropertyWin32.QUICK_USE_NUM = 6  -- 快捷框个数 (最大：6)

MainPropertyWin32._ResPath = "res/private/main-win32/"

MainPropertyWin32._pkModes = {0, 1, 4, 5, 6, 3, 2, 7, 10}
MainPropertyWin32._pkModeStr = {
    [0]     =   "[全体模式]",
    [1]     =   "[和平模式]",
    [2]     =   "[夫妻模式]",
    [3]     =   "[师徒模式]",
    [4]     =   "[编组模式]",
    [5]     =   "[行会模式]",
    [6]     =   "[善恶模式]",
    [7]     =   "[国家模式]",
    [10]    =   "[区服模式]"
}

local CHANNEL   = SL:ChatChannel()
local _channels = {
    [CHANNEL.Shout]   = "res/private/main-win32/chat/1.png",
    [CHANNEL.Private] = "res/private/main-win32/chat/2.png",
    [CHANNEL.Guild]   = "res/private/main-win32/chat/3.png",
    [CHANNEL.Team]    = "res/private/main-win32/chat/4.png",
    [CHANNEL.Near]    = "res/private/main-win32/chat/5.png",
    [CHANNEL.World]   = "res/private/main-win32/chat/6.png",
}


local screenW = SL:GetScreenWidth()
local screenH = SL:GetScreenHeight()

function MainPropertyWin32.main()
    local parent = GUI:Attach_Parent()
    MainPropertyWin32._parent = parent

    local Panel_bg_touch = GUI:Layout_Create(parent, "Panel_bg_touch", -screenW/2, 0, screenW, screenH, true)
    GUI:setTouchEnabled(Panel_bg_touch, true)
    GUI:setSwallowTouches(Panel_bg_touch, false)
    GUI:addOnTouchEvent(Panel_bg_touch, function () 
        GUI:setVisible(MainPropertyWin32.PanelChannel, false) 
        if ChatExtend and ChatExtend.OnExit then
            ChatExtend.OnExit()
        end
    end)

    local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 0, 0, screenW, screenH)
    GUI:setAnchorPoint(Panel_bg, 0.5, 0)
    MainPropertyWin32.Panel_bg = Panel_bg

    local Image_bg = GUI:Image_Create(Panel_bg, "Image_bg", screenW/2, 0, MainPropertyWin32._ResPath.."bg.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0)
    GUI:setLocalZOrder(Image_bg, 2)

--  聊天相关-----------------------------------------------------------------------
    -- Panel_chat
    local chatW = 604
    local chatH = 145

    local Panel_chat = GUI:Layout_Create(Panel_bg, "Panel_chat", screenW/2, 10, chatW, chatH, false)
    GUI:setAnchorPoint(Panel_chat, 0.5, 0)
    GUI:setTouchEnabled(Panel_chat, true)

    local Panel_mask = GUI:Layout_Create(Panel_chat, "Panel_mask", chatW/2, 0, chatW, 24, false)
    GUI:setAnchorPoint(Panel_mask, 0.5, 0)
    GUI:setTouchEnabled(Panel_mask, true)
    GUI:Layout_setBackGroundColorType(Panel_mask, 1)
    GUI:Layout_setBackGroundColorOpacity(Panel_mask, 180)
    GUI:Layout_setBackGroundColor(Panel_mask, "#000000")

    -- 聊天背景框
    local Image_chat_bg = GUI:Image_Create(Panel_chat, "Image_chat_bg", chatW/2, -10, MainPropertyWin32._ResPath.."00000056.png")
    GUI:setAnchorPoint(Image_chat_bg, 0.5, 0)
    GUI:Image_setScale9Slice(Image_chat_bg, 105, 105, 33, 22)
    GUI:setLocalZOrder(Image_chat_bg, 1)

    -- 聊天内容层
    local ListView_chat = GUI:ListView_Create(Panel_chat, "ListView_chat", chatW/2, 24, chatW - 4, chatH-50, 1)
    GUI:setAnchorPoint(ListView_chat, 0.5, 0)
    GUI:ListView_setClippingEnabled(ListView_chat, true)
    GUI:ListView_setBackGroundColorType(ListView_chat, 1)
    GUI:ListView_setBackGroundColorOpacity(ListView_chat, 180)
    GUI:ListView_setBackGroundColor(ListView_chat, "#000000")

    local ListView_chat_ex = GUI:ListView_Create(Panel_chat, "ListView_chat_ex", chatW/2, chatH-25, chatW - 4, 1, 1)
    GUI:setAnchorPoint(ListView_chat_ex, 0.5, 1)
    GUI:ListView_setClippingEnabled(ListView_chat_ex, true)
    GUI:setTouchEnabled(ListView_chat_ex, false)

    -- chat_touch
    local Panel_chat_touch = GUI:Layout_Create(Panel_chat, "Panel_chat_touch", 0, chatH, chatW, 25)
    GUI:setAnchorPoint(Panel_chat_touch, 0, 1)
    GUI:setTouchEnabled(Panel_chat_touch, true)
    GUI:setLocalZOrder(Panel_chat_touch, 2)

    local Panel_scroll_bar = GUI:Layout_Create(Panel_chat, "Panel_scroll_bar", chatW-17, 24, 14, chatH-50)
    GUI:setTouchEnabled(Panel_scroll_bar, true)
    -- 线
    local Image_scroll_bg = GUI:Image_Create(Panel_scroll_bar, "Image_scroll_bg", 7, chatH/2 - 25, MainPropertyWin32._ResPath.."chat/line.png")
    GUI:setContentSize(Image_scroll_bg, GUI:getContentSize(Image_scroll_bg).width, chatH-50)
    GUI:setAnchorPoint(Image_scroll_bg, 0.5, 0.5)
    GUI:Image_setScale9Slice(Image_scroll_bg, 2, 2, 16, 16)
    -- 上
    local Button_scroll_top = GUI:Button_Create(Panel_scroll_bar, "Button_scroll_top", 7, chatH-50, MainPropertyWin32._ResPath.."chat/t.png")
    GUI:Button_loadTexturePressed(Button_scroll_top, MainPropertyWin32._ResPath.."chat/t_1.png")
    GUI:setAnchorPoint(Button_scroll_top, 0.5, 1)
    -- 下
    local Button_scroll_btm = GUI:Button_Create(Panel_scroll_bar, "Button_scroll_btm", 7, 0, MainPropertyWin32._ResPath.."chat/b.png")
    GUI:Button_loadTexturePressed(Button_scroll_btm, MainPropertyWin32._ResPath.."chat/b_1.png")
    GUI:setAnchorPoint(Button_scroll_btm, 0.5, 0)
    -- bar
    local Slider_bar = GUI:Slider_Create(Panel_scroll_bar, "Slider_bar", 7, chatH/2-25, "res/public/0.png", "res/public/0.png", MainPropertyWin32._ResPath.."chat/p.png")
    GUI:setContentSize(Slider_bar, chatH-90-16, 14)
    GUI:setAnchorPoint(Slider_bar, 0.5, 0.5)
    GUI:setRotation(Slider_bar, 90)
    GUI:Slider_setPercent(Slider_bar, 100)

    -- chat_func
    local Panel_chat_funcs = GUI:Layout_Create(Panel_chat, "Panel_chat_funcs", 25, chatH-12.5, 300, 15)
    GUI:setAnchorPoint(Panel_chat_funcs, 0, 0.5)
    GUI:setTouchEnabled(Panel_chat_funcs, false)
    GUI:setLocalZOrder(Panel_chat_funcs, 2)

    local Button_map = GUI:Button_Create(Panel_chat_funcs, "Button_map", 14, 7.5, MainPropertyWin32._ResPath.."1900011009.png")
    GUI:Button_loadTexturePressed(Button_map, MainPropertyWin32._ResPath.."1900011010.png")
    GUI:setAnchorPoint(Button_map, 0.5, 0.5)

    local Button_trade = GUI:Button_Create(Panel_chat_funcs, "Button_trade", 48, 7.5, MainPropertyWin32._ResPath.."1900011011.png")
    GUI:Button_loadTexturePressed(Button_trade, MainPropertyWin32._ResPath.."1900011012.png")
    GUI:setAnchorPoint(Button_trade, 0.5, 0.5)

    local Button_guild = GUI:Button_Create(Panel_chat_funcs, "Button_guild", 82, 7.5, MainPropertyWin32._ResPath.."1900011015.png")
    GUI:Button_loadTexturePressed(Button_guild, MainPropertyWin32._ResPath.."1900011016.png")
    GUI:setAnchorPoint(Button_guild, 0.5, 0.5)

    local Button_team = GUI:Button_Create(Panel_chat_funcs, "Button_team", 116, 7.5, MainPropertyWin32._ResPath.."1900011013.png")
    GUI:Button_loadTexturePressed(Button_team, MainPropertyWin32._ResPath.."1900011014.png")
    GUI:setAnchorPoint(Button_team, 0.5, 0.5)

    local Button_rank = GUI:Button_Create(Panel_chat_funcs, "Button_rank", 150, 7.5, MainPropertyWin32._ResPath.."1900011027.png")
    GUI:Button_loadTexturePressed(Button_rank, MainPropertyWin32._ResPath.."1900011028.png")
    GUI:setAnchorPoint(Button_rank, 0.5, 0.5)

    local Button_private = GUI:Button_Create(Panel_chat_funcs, "Button_private", 184, 7.5, MainPropertyWin32._ResPath.."1900011029.png")
    GUI:Button_loadTexturePressed(Button_private, MainPropertyWin32._ResPath.."1900011030.png")
    GUI:setAnchorPoint(Button_private, 0.5, 0.5)
    
    local tradeAble = SL:GetServerOption(GUIShare.ServerOption.SHOW_ALL_FIGHTPAGES) and true or false
    GUI:setVisible(Button_trade, tradeAble)
    if not tradeAble then
        GUI:setPositionX(Button_guild, 48)
        GUI:setPositionX(Button_team, 48)
        GUI:setPositionX(Button_rank, 82)
        GUI:setPositionX(Button_private, 116)
        GUI:setPositionX(Button_guild, 150)
    end

    -- exit_func
    local Panel_exit_funcs = GUI:Layout_Create(Panel_chat, "Panel_exit_funcs", chatW - 30, chatH-12.5, 80, 15)
    GUI:setAnchorPoint(Panel_exit_funcs, 1, 0.5)
    GUI:setTouchEnabled(Panel_exit_funcs, false)
    GUI:setLocalZOrder(Panel_exit_funcs, 2)
    
    local Button_out = GUI:Button_Create(Panel_exit_funcs, "Button_out", 32, 7.5, MainPropertyWin32._ResPath.."1900011017.png")
    GUI:Button_loadTexturePressed(Button_out, MainPropertyWin32._ResPath.."1900011018.png")
    GUI:setAnchorPoint(Button_out, 0.5, 0.5)

    local Button_end = GUI:Button_Create(Panel_exit_funcs, "Button_end", 66, 7.5, MainPropertyWin32._ResPath.."1900011019.png")
    GUI:Button_loadTexturePressed(Button_end, MainPropertyWin32._ResPath.."1900011020.png")
    GUI:setAnchorPoint(Button_end, 0.5, 0.5)

--  切换频道选择层-------------------------------------------------------------------------------------
    local PanelChannel = GUI:Layout_Create(Panel_chat, "PanelChannel", 4, 25, 45, 108, true)
    GUI:setTouchEnabled(PanelChannel, true)
    GUI:setLocalZOrder(PanelChannel, 3)
    GUI:setVisible(PanelChannel, false)

    local ListView_channel_bg = GUI:Image_Create(PanelChannel, "ListView_channel_bg", 0, 0, "res/public/1900000677.png")
    GUI:Image_setScale9Slice(ListView_channel_bg, 9, 9, 12, 12)
    GUI:setContentSize(ListView_channel_bg, 45, 108)
    local ListView_channel = GUI:ListView_Create(PanelChannel, "ListView_channel", 2, 2, 36, 102, 1)
    GUI:ListView_setItemsMargin(ListView_channel, 3)
    GUI:ListView_setGravity(ListView_channel, 2)

    MainPropertyWin32.PanelChannel = PanelChannel
    MainPropertyWin32.ListView_channel = ListView_channel

    -- 喊话
    local Image_shout = GUI:Image_Create(ListView_channel, "Image_shout", 22.5, 14, _channels[CHANNEL.Shout])
    local select = GUI:Image_Create(Image_shout, "select", 22.5, 7, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 60, 17)
    GUI:setTouchEnabled(Image_shout, true)
    GUI:setTag(Image_shout, CHANNEL.Shout)
    GUI:addOnClickEvent(Image_shout, MainPropertyWin32.OnChatChanel)

    -- 私聊
    local Image_private = GUI:Image_Create(ListView_channel, "Image_private", 22.5, 14, _channels[CHANNEL.Private])
    local select = GUI:Image_Create(Image_private, "select", 22.5, 7, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 60, 17)
    GUI:setTouchEnabled(Image_private, true)
    GUI:setTag(Image_private, CHANNEL.Private)
    GUI:addOnClickEvent(Image_private, MainPropertyWin32.OnChatChanel)

    -- 行会
    local Image_guild = GUI:Image_Create(ListView_channel, "Image_guild", 22.5, 14, _channels[CHANNEL.Guild])
    local select = GUI:Image_Create(Image_guild, "select", 22.5, 7, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 60, 17)
    GUI:setTouchEnabled(Image_guild, true)
    GUI:setTag(Image_guild, CHANNEL.Guild)
    GUI:addOnClickEvent(Image_guild, MainPropertyWin32.OnChatChanel)

    -- 组队
    local Image_team = GUI:Image_Create(ListView_channel, "Image_team", 22.5, 14, _channels[CHANNEL.Team])
    local select = GUI:Image_Create(Image_team, "select", 22.5, 7, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 60, 17)
    GUI:setTouchEnabled(Image_team, true)
    GUI:setTag(Image_team, CHANNEL.Team)
    GUI:addOnClickEvent(Image_team, MainPropertyWin32.OnChatChanel)

    -- 附近
    local Image_near = GUI:Image_Create(ListView_channel, "Image_near", 22.5, 14, _channels[CHANNEL.Near])
    local select = GUI:Image_Create(Image_near, "select", 22.5, 7, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 60, 17)
    GUI:setTouchEnabled(Image_near, true)
    GUI:setTag(Image_near, CHANNEL.Near)
    GUI:addOnClickEvent(Image_near, MainPropertyWin32.OnChatChanel)

    -- 世界
    local Image_world = GUI:Image_Create(ListView_channel, "Image_world", 22.5, 14, _channels[CHANNEL.World])
    local select = GUI:Image_Create(Image_world, "select", 22.5, 7, "res/public/1900000678.png")
    GUI:setAnchorPoint(select, 0.5, 0.5)
    GUI:setContentSize(select, 60, 17)
    GUI:setTouchEnabled(Image_world, true)
    GUI:setTag(Image_world, CHANNEL.World)
    GUI:addOnClickEvent(Image_world, MainPropertyWin32.OnChatChanel)

    -------------------------------------------------------------------------------------------------------------------------------------

    local Button_channel = GUI:Button_Create(Panel_chat, "Button_channel", 4, 12, MainPropertyWin32._ResPath.."btn_channel.png")
    GUI:Button_loadTexturePressed(Button_channel, MainPropertyWin32._ResPath.."btn_channel_1.png")
    GUI:setAnchorPoint(Button_channel, 0, 0.5)
    local Button_arrow = GUI:Button_Create(Button_channel, "Button_arrow", 49, 10, MainPropertyWin32._ResPath.."chat/arr.png")
    GUI:Button_loadTexturePressed(Button_arrow, MainPropertyWin32._ResPath.."chat/arr_1.png")
    GUI:addOnClickEvent(Button_arrow, MainPropertyWin32.OnSetChatChanel)
    GUI:setAnchorPoint(Button_arrow, 0.5, 0.5)
    local Image_channel = GUI:Image_Create(Button_channel, "Image_channel", 22, 10)
    GUI:setAnchorPoint(Image_channel, 0.5, 0.5)
    GUI:addOnClickEvent(Button_channel, MainPropertyWin32.OnSetChatChanel)
    MainPropertyWin32.Button_channel = Button_channel
    MainPropertyWin32.Button_arrow = Button_arrow

    local Image_input = GUI:Image_Create(Panel_chat, "Image_input", 65, 12, MainPropertyWin32._ResPath.."chat/input_bg.png")
    GUI:setContentSize(Image_input, chatW - 115, 20)
    GUI:Image_setScale9Slice(Image_input, 28, 28, 6, 6)
    GUI:setAnchorPoint(Image_input, 0, 0.5)


    local TextField_input = GUI:TextInput_Create(Panel_chat, "TextField_input", 67, 12, chatW - 120, 16, 13)
    GUI:Text_setTextHorizontalAlignment(TextField_input, 0)
    GUI:TextInput_setPlaceholderFontSize(TextField_input, 13)
    GUI:TextInput_setPlaceHolder(TextField_input, "点击或回车输入内容")
    GUI:TextInput_setInputMode(TextField_input, 6)
    GUI:TextInput_setMaxLength(TextField_input, SL._DEBUG and 9999 or 60)
    GUI:setAnchorPoint(TextField_input, 0, 0.5)

    -- 发送 按钮
    local Button_send = GUI:Button_Create(Panel_chat, "Button_send", chatW-2, 11, MainPropertyWin32._ResPath.."chat/send.png")
    GUI:Button_loadTexturePressed(Button_send, MainPropertyWin32._ResPath.."chat/send_1.png")
    GUI:setAnchorPoint(Button_send, 1, 0.5)

--  血条进度-----------------------------------------------------------------------
    -- Panel_hp
    local Panel_hp = GUI:Layout_Create(Panel_bg, "Panel_hp", screenW/2-chatW/2+5, 0, 200, 200, false)
    GUI:setAnchorPoint(Panel_hp, 1, 0)
    GUI:setTouchEnabled(Panel_hp, true)
    MainPropertyWin32.Panel_hp = Panel_hp

    -- 血量背景
    local Image_fhp_bg = GUI:Image_Create(Panel_hp, "Image_fhp_bg", 91, 95, MainPropertyWin32._ResPath.."1900000500.png")
    GUI:setAnchorPoint(Image_fhp_bg, 0.5, 0.5)
    GUI:setVisible(Image_fhp_bg, false)

    -- hp 进度条
    local LoadingBar_hp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_hp", 57, 92, MainPropertyWin32._ResPath.."1900000502.png", 0)
    GUI:setAnchorPoint(LoadingBar_hp, 0.5, 0.5)
    GUI:setRotation(LoadingBar_hp, 270)
    GUI:setRotationSkewX(LoadingBar_hp, 270)
    GUI:setRotationSkewY(LoadingBar_hp, 270)
    GUI:setVisible(LoadingBar_hp, false)

    -- mp 进度条
    local LoadingBar_mp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_mp", 123, 92, MainPropertyWin32._ResPath.."1900000503.png", 0)
    GUI:setAnchorPoint(LoadingBar_mp, 0.5, 0.5)
    GUI:setRotation(LoadingBar_mp, 270)
    GUI:setRotationSkewX(LoadingBar_mp, 270)
    GUI:setRotationSkewY(LoadingBar_mp, 270)
    GUI:setVisible(LoadingBar_mp, false)

    -- fhp 
    local LoadingBar_fhp = GUI:LoadingBar_Create(Panel_hp, "LoadingBar_fhp", 91, 92, MainPropertyWin32._ResPath.."1900000501.png", 0)
    GUI:setAnchorPoint(LoadingBar_fhp, 0.5, 0.5)
    GUI:setRotation(LoadingBar_fhp, 270)
    GUI:setRotationSkewX(LoadingBar_fhp, 270)
    GUI:setRotationSkewY(LoadingBar_fhp, 270)
    GUI:setVisible(LoadingBar_fhp, false)

    -- 魔血球动画示例
    MainPropertyWin32.pSize = MainPropertyWin32.ShowMHpEffect(Panel_hp, false)

    local Image_fhp_line = GUI:Image_Create(Panel_hp, "Image_fhp_line", 91, 92, MainPropertyWin32._ResPath.."1900012513.png")
    GUI:setAnchorPoint(Image_fhp_line, 0.5, 0.5)
    GUI:setVisible(Image_fhp_line, false)

--  血条其他属性-----------------------------------------------------------------------
    local Panel_hp_other = GUI:Layout_Create(Panel_bg, "Panel_hp_other", screenW/2-chatW/2+5, 0, 200, 200, false)
    GUI:setAnchorPoint(Panel_hp_other, 1, 0)
    GUI:setTouchEnabled(Panel_hp_other, true)
    MainPropertyWin32.Panel_hp_other = Panel_hp_other
    GUI:setLocalZOrder(Panel_hp_other, 3)
    
    -- 血量显示文本
    local Image_Text_hmp_bg = GUI:Image_Create(Panel_hp_other, "Image_Text_hmp_bg", 85, 34, MainPropertyWin32._ResPath.."000009.png")
    GUI:setAnchorPoint(Image_Text_hmp_bg, 0.5, 0.5)
    GUI:setVisible(Image_Text_hmp_bg, false)
    -- Text_hp
    --local Text_hp = GUI:Text_Create(Panel_hp_other, "Text_hp", 54, 35, 12, "#ffffff", "")
    local Text_hp = GUI:BmpText_Create(Panel_hp_other, "Text_hp", 54, 35, "#ffffff", "")
    GUI:setAnchorPoint(Text_hp, 0.5, 0.5)
    GUI:Text_enableOutline(Text_hp, "#000000", 1)
    GUI:setVisible(Text_hp, false)
    -- Text_mp
    --local Text_mp = GUI:Text_Create(Panel_hp_other, "Text_mp", 116, 35, 12, "#ffffff", "")
    local Text_mp = GUI:BmpText_Create(Panel_hp_other, "Text_mp", 116, 35, "#ffffff", "")
    GUI:setAnchorPoint(Text_mp, 0.5, 0.5)
    GUI:Text_enableOutline(Text_mp, "#000000", 1)
    GUI:setVisible(Text_mp, false)

    -- Text_position
    --local Text_position = GUI:Text_Create(Panel_hp_other, "Text_position", 15, 12, 12, "#ffffff", "")
    local Text_position = GUI:BmpText_Create(Panel_hp_other, "Text_position", 15, 15, "#ffffff", "")
    GUI:setAnchorPoint(Text_position, 0, 0.5)
    GUI:setVisible(Text_position, false)

--  聊天相关按钮-----------------------------------------------------------------------
    local Panel_chat_btns = GUI:Layout_Create(Panel_bg, "Panel_chat_btns", screenW/2-chatW/2+5, 0, 200, 252, false)
    GUI:setAnchorPoint(Panel_chat_btns, 1, 0)
    MainPropertyWin32.Panel_chat_btns = Panel_chat_btns
    GUI:setLocalZOrder(Panel_chat_btns, 4)

    -- 是否允许所有公聊信息按钮
    local Button_chat_1 = GUI:Button_Create(Panel_chat_btns, "Button_chat_1", 184, 133, MainPropertyWin32._ResPath.."190001100.png")
    GUI:Button_loadTextureDisabled(Button_chat_1, MainPropertyWin32._ResPath.."190001101.png")
    GUI:Button_loadTexturePressed(Button_chat_1, MainPropertyWin32._ResPath.."190001100.png")
    GUI:setAnchorPoint(Button_chat_1, 0.5, 0.5)

    -- 是否允许所有喊话信息按钮
    local Button_chat_2 = GUI:Button_Create(Panel_chat_btns, "Button_chat_2", 184, 113, MainPropertyWin32._ResPath.."190001102.png")
    GUI:Button_loadTextureDisabled(Button_chat_2, MainPropertyWin32._ResPath.."190001103.png")
    GUI:Button_loadTexturePressed(Button_chat_2, MainPropertyWin32._ResPath.."190001102.png")
    GUI:setAnchorPoint(Button_chat_2, 0.5, 0.5)

    -- 是否允许所有私聊信息按钮
    local Button_chat_3 = GUI:Button_Create(Panel_chat_btns, "Button_chat_3", 184, 93, MainPropertyWin32._ResPath.."190001104.png")
    GUI:Button_loadTextureDisabled(Button_chat_3, MainPropertyWin32._ResPath.."190001105.png")
    GUI:Button_loadTexturePressed(Button_chat_3, MainPropertyWin32._ResPath.."190001104.png")
    GUI:setAnchorPoint(Button_chat_3, 0.5, 0.5)

    -- 是否允许行会聊天信息按钮
    local Button_chat_4 = GUI:Button_Create(Panel_chat_btns, "Button_chat_4", 184, 73, MainPropertyWin32._ResPath.."190001106.png")
    GUI:Button_loadTextureDisabled(Button_chat_4, MainPropertyWin32._ResPath.."190001107.png")
    GUI:Button_loadTexturePressed(Button_chat_4, MainPropertyWin32._ResPath.."190001106.png")
    GUI:setAnchorPoint(Button_chat_4, 0.5, 0.5)

    -- 是否自动喊话开关按钮
    local Button_chat_5 = GUI:Button_Create(Panel_chat_btns, "Button_chat_5", 184, 53, MainPropertyWin32._ResPath.."190001108.png")
    GUI:Button_loadTextureDisabled(Button_chat_5, MainPropertyWin32._ResPath.."190001109.png")
    GUI:Button_loadTexturePressed(Button_chat_5, MainPropertyWin32._ResPath.."190001108.png")
    GUI:setAnchorPoint(Button_chat_5, 0.5, 0.5)

    -- 特殊命令按钮
    local Button_chat_6 = GUI:Button_Create(Panel_chat_btns, "Button_chat_6", 184, 33, MainPropertyWin32._ResPath.."190001110.png")
    GUI:Button_loadTextureDisabled(Button_chat_6, MainPropertyWin32._ResPath.."190001111.png")
    GUI:Button_loadTexturePressed(Button_chat_6, MainPropertyWin32._ResPath.."190001110.png")
    GUI:setAnchorPoint(Button_chat_6, 0.5, 0.5)

    -- 聊天背包
    local Button_chat_bag = GUI:Button_Create(Panel_chat_btns, "Button_chat_bag", 160, 64, MainPropertyWin32._ResPath.."0001.png")
    GUI:Button_loadTextureDisabled(Button_chat_bag, MainPropertyWin32._ResPath.."0001_1.png")
    GUI:setAnchorPoint(Button_chat_bag, 0.5, 0.5) 
    GUI:setSwallowTouches(Button_chat_bag, true)
    GUI:addOnClickEvent(Button_chat_bag, function () SL:OpenChatExtendUI(3) end)
    GUI:addMouseOverTips(Button_chat_bag, "道具", {x=-10,y=-20}, {x=1, y=0.5})
    -- 聊天表情
    local Button_chat_emoj = GUI:Button_Create(Panel_chat_btns, "Button_chat_emoj", 160, 39, MainPropertyWin32._ResPath.."0002.png")
    GUI:Button_loadTextureDisabled(Button_chat_emoj, MainPropertyWin32._ResPath.."0002_1.png")
    GUI:setAnchorPoint(Button_chat_emoj, 0.5, 0.5)
    GUI:setSwallowTouches(Button_chat_emoj, true)
    GUI:addOnClickEvent(Button_chat_emoj, function () SL:OpenChatExtendUI(2) end)
    GUI:addMouseOverTips(Button_chat_emoj, "聊天表情", {x=-10,y=-20}, {x=1, y=0.5})
    -- 定位
    local Button_chat_pos = GUI:Button_Create(Panel_chat_btns, "Button_chat_pos", 160, 14, MainPropertyWin32._ResPath.."0003.png")
    GUI:Button_loadTextureDisabled(Button_chat_pos, MainPropertyWin32._ResPath.."0003_1.png")
    GUI:setAnchorPoint(Button_chat_pos, 0.5, 0.5)
    GUI:addOnClickEvent(Button_chat_pos, function () SL:SendPosMsgToChat() end)
    GUI:addMouseOverTips(Button_chat_pos, "发送位置", {x=-10,y=-20}, {x=1, y=0.5})

--  pk 模式---------------------------------------------------------------------------
    local Panel_pkmode = GUI:Layout_Create(Panel_bg, "Panel_pkmode", screenW/2-chatW/2+5, 0, 200, 252, false)
    GUI:setAnchorPoint(Panel_pkmode, 1, 0)
    MainPropertyWin32.Panel_pkmode = Panel_pkmode
    GUI:setLocalZOrder(Panel_pkmode, 3)

    local Image_pkmode_bg = GUI:Image_Create(Panel_pkmode, "Image_pkmode_bg", 91, 15, MainPropertyWin32._ResPath.."pk_mode_bg.png")
    GUI:setAnchorPoint(Image_pkmode_bg, 0.5, 0.5)
    
    -- local Text_pkmode = GUI:Text_Create(Panel_pkmode, "Text_pkmode", 91, 15, 13, "FFFFFF", "-")
    local Text_pkmode = GUI:BmpText_Create(Panel_pkmode, "Text_pkmode", 91, 15, "#FFFFFF", "-")
    GUI:setAnchorPoint(Text_pkmode, 0.5, 0.5)
    GUI:setTouchEnabled(Text_pkmode, true)
    MainPropertyWin32.Text_pkmode = Text_pkmode
    GUI:addOnClickEvent(Text_pkmode, MainPropertyWin32.OnClickChangePkMode)
    GUI:addMouseOverTips(Text_pkmode, "点击切换", {x=0,y=0}, {x=0.7, y=0.5})

--  底部聊天右侧-----------------------------------------------------------------------
    local Panel_act = GUI:Layout_Create(Panel_bg, "Panel_act", screenW/2+chatW/2+5, 0, 250, 200)
    GUI:setAnchorPoint(Panel_act, 0, 0)
    GUI:setTouchEnabled(Panel_act, true)
    GUI:setLocalZOrder(Panel_act, 3)

    -- local Image_act_bg = GUI:Image_Create(Panel_act, "Image_act_bg", -1, -2, MainPropertyWin32._ResPath.."1900010501.png")
    -- GUI:setAnchorPoint(Image_act_bg, 0, 0)

    local Button_role = GUI:Button_Create(Panel_act, "Button_role", 43, 149, MainPropertyWin32._ResPath.."000034.png")
    GUI:Button_loadTexturePressed(Button_role, MainPropertyWin32._ResPath.."000034_1.png")
    GUI:setAnchorPoint(Button_role, 0.5, 0.5)

    local Button_bag = GUI:Button_Create(Panel_act, "Button_bag", 86, 171, MainPropertyWin32._ResPath.."000035.png")
    GUI:Button_loadTexturePressed(Button_bag, MainPropertyWin32._ResPath.."000035_1.png")
    GUI:setAnchorPoint(Button_bag, 0.5, 0.5)

    local Button_skill = GUI:Button_Create(Panel_act, "Button_skill", 137, 163, MainPropertyWin32._ResPath.."000036.png")
    GUI:Button_loadTexturePressed(Button_skill, MainPropertyWin32._ResPath.."000036_1.png")
    GUI:setAnchorPoint(Button_skill, 0.5, 0.5)

    local Button_voice = GUI:Button_Create(Panel_act, "Button_voice", 173, 130, MainPropertyWin32._ResPath.."000037.png")
    GUI:Button_loadTexturePressed(Button_voice, MainPropertyWin32._ResPath.."000037_1.png")
    GUI:setAnchorPoint(Button_voice, 0.5, 0.5)

    local Button_store = GUI:Button_Create(Panel_act, "Button_store", 125, 103, MainPropertyWin32._ResPath.."000038.png")
    GUI:Button_loadTexturePressed(Button_store, MainPropertyWin32._ResPath.."000038_1.png")
    GUI:setAnchorPoint(Button_store, 0.5, 0.5)

    -- local Image_time = GUI:Image_Create(Panel_act, "Image_time", 165, 142, MainPropertyWin32._ResPath.."00000045.png")
    -- GUI:setAnchorPoint(Image_time, 0.5, 0.5)
    -- GUI:setTouchEnabled(Image_time, true)

    -- 等级
    local LoadingBar_level_bg = GUI:Image_Create(Panel_act, "LoadingBar_level_bg", 65, 107, MainPropertyWin32._ResPath.."Image_1.png")
    GUI:setAnchorPoint(LoadingBar_level_bg, 0.5, 0.5)
    --local Text_level = GUI:Text_Create(Panel_act, "Text_level", 60, 107, 13, "FFFFFF", "-")
    local Text_level = GUI:BmpText_Create(Panel_act, "Text_level", 60, 107, "#FFFFFF", "-")
    GUI:setAnchorPoint(Text_level, 0.5, 0.5)
    local LoadingBar_level_ic = GUI:Image_Create(Panel_act, "LoadingBar_level_ic", 20, 107, MainPropertyWin32._ResPath.."Image_level.png")
    GUI:setAnchorPoint(LoadingBar_level_ic, 0.5, 0.5)

    -- 经验
    local LoadingBar_exp_bg = GUI:Image_Create(Panel_act, "LoadingBar_exp_bg", 71, 75, MainPropertyWin32._ResPath.."Image_2.png")
    GUI:setAnchorPoint(LoadingBar_exp_bg, 0.5, 0.5)
    local LoadingBar_exp = GUI:LoadingBar_Create(Panel_act, "LoadingBar_exp", 70, 75, MainPropertyWin32._ResPath.."bar_1.png", 0)
    GUI:setAnchorPoint(LoadingBar_exp, 0.5, 0.5)
    local LoadingBar_exp_ic = GUI:Image_Create(Panel_act, "LoadingBar_exp_ic", 20, 75, MainPropertyWin32._ResPath.."Image_exp.png")
    GUI:setAnchorPoint(LoadingBar_exp_ic, 0.5, 0.5)

    -- 负重
    local LoadingBar_weight_bg = GUI:Image_Create(Panel_act, "LoadingBar_weight_bg", 82, 43, MainPropertyWin32._ResPath.."Image_3.png")
    GUI:setAnchorPoint(LoadingBar_weight_bg, 0.5, 0.5)
    local LoadingBar_weight = GUI:LoadingBar_Create(Panel_act, "LoadingBar_weight", 82, 43, MainPropertyWin32._ResPath.."bar_1.png", 0)
    GUI:setAnchorPoint(LoadingBar_weight, 0.5, 0.5)
    local LoadingBar_weight_ic = GUI:Image_Create(Panel_act, "LoadingBar_weight_ic", 20, 43, MainPropertyWin32._ResPath.."Image_weight.png")
    GUI:setAnchorPoint(LoadingBar_weight_ic, 0.5, 0.5)

    -- 时间
    local Text_time_bg = GUI:Image_Create(Panel_act, "Text_time_bg", 95, 13, MainPropertyWin32._ResPath.."000018.png")
    GUI:setAnchorPoint(Text_time_bg, 0.5, 0.5)
    --local Text_time = GUI:Text_Create(Panel_act, "Text_time", 95, 13, 13, "#FFFFFF", "")
    local Text_time = GUI:BmpText_Create(Panel_act, "Text_time", 95, 13, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_time, 0.5, 0.5)
    

    local Panel_hero = GUI:Layout_Create(Panel_act, "Panel_hero", 35, 128, 92, 20)
    GUI:setTouchEnabled(Panel_hero, true)

    local Button_herostate = GUI:Button_Create(Panel_act, "Button_herostate", 80, 133, MainPropertyWin32._ResPath.."00649.png")
    GUI:Button_loadTexturePressed(Button_herostate, MainPropertyWin32._ResPath.."00650.png")
    GUI:setAnchorPoint(Button_herostate, 0.5, 0.5)

    local Button_heroinfo = GUI:Button_Create(Panel_act, "Button_heroinfo", 107.5, 135, MainPropertyWin32._ResPath.."00661.png")
    GUI:Button_loadTexturePressed(Button_heroinfo, MainPropertyWin32._ResPath.."00662.png")
    GUI:setAnchorPoint(Button_heroinfo, 0.5, 0.5)

    local Button_herobag = GUI:Button_Create(Panel_act, "Button_herobag", 135, 120, MainPropertyWin32._ResPath.."00655.png")
    GUI:Button_loadTexturePressed(Button_herobag, MainPropertyWin32._ResPath.."00656.png")
    GUI:setAnchorPoint(Button_herobag, 0.5, 0.5)

    -- 英雄怒气条
    local LoadingBar_hjbg = GUI:Image_Create(Panel_act, "LoadingBar_hjbg", -8, 10, MainPropertyWin32._ResPath.."01072.png")
    GUI:setAnchorPoint(LoadingBar_hjbg, 0, 0)
    GUI:setContentSize(LoadingBar_hjbg, 13, 117)
    GUI:Image_setScale9Slice(LoadingBar_hjbg, 6, 6, 40, 40)

    local LoadingBar_hj = GUI:LoadingBar_Create(LoadingBar_hjbg, "LoadingBar_hj", 5, 60.5, MainPropertyWin32._ResPath.."01070.png", 2)
    GUI:setAnchorPoint(LoadingBar_hj, 0.5, 0.5)
    GUI:setContentSize(LoadingBar_hj, 108, 4)
    GUI:setRotation(LoadingBar_hj, -90)
    MainPropertyWin32.LoadingBar_hj = LoadingBar_hj

    local LoadingBar_hj_ani_pic = GUI:Image_Create(LoadingBar_hjbg, "LoadingBar_hj_ani_pic", 0, 0, MainPropertyWin32._ResPath.."01071.png")
    GUI:setContentSize(LoadingBar_hj_ani_pic, 13, 117)
    GUI:Image_setScale9Slice(LoadingBar_hj_ani_pic, 6, 6, 40, 40)
    GUI:setVisible(LoadingBar_hj_ani_pic, false)
    MainPropertyWin32.LoadingBar_hj_ani_pic = LoadingBar_hj_ani_pic

    local isHeroOpen = SL:GetMetaValue("USEHERO")
    if isHeroOpen then
        GUI:setClickDelay(Button_herobag, 0.5)
        GUI:addOnClickEvent(Button_herobag, function () 
            if SL:GetMetaValue("CALLHERO") then
                SL:OpenHeroBagUI()
            end
        end)
        GUI:addMouseOverTips(Button_herobag, "英雄包裹", {x=0,y=0}, {x=0.5, y=0.5})

        GUI:setClickDelay(Button_heroinfo, 0.5)
        GUI:addOnClickEvent(Button_heroinfo, function ()
            GUI:setClickDelay(Button_heroinfo, 0.5)
            SL:CallOrOutHero() 
        end)
        GUI:addMouseOverTips(Button_heroinfo, "召唤英雄", {x=0,y=0}, {x=0.5, y=0.5})

        GUI:setClickDelay(Button_herostate, 0.5)
        GUI:addOnClickEvent(Button_herostate, function () 
            if SL:GetMetaValue("CALLHERO") then
                SL:OpenMyPlayerHeroUI({index = 1})
            end
        end)
        GUI:addMouseOverTips(Button_herostate, "英雄", {x=0,y=0}, {x=0.5, y=0.5})

        GUI:setVisible(LoadingBar_hjbg, true)
        GUI:setVisible(LoadingBar_hjbg, true)
        GUI:setVisible(Button_herobag, true)
        GUI:setVisible(Button_heroinfo, true)
        GUI:setVisible(Button_herostate, true)
        GUI:setPosition(Button_store, 130, 80)
    else
        GUI:setVisible(LoadingBar_hjbg, false)
        GUI:setVisible(Button_herobag, false)
        GUI:setVisible(Button_heroinfo, false)
        GUI:setVisible(Button_herostate, false)
    end

--  底部聊天上侧-----------------------------------------------------------------------
    local Panel_quick = GUI:Layout_Create(Panel_bg, "Panel_quick", screenW/2, 155, 440, 55)
    GUI:setAnchorPoint(Panel_quick, 0.5, 0)
    
    local Image_quick_bg = GUI:Image_Create(Panel_quick, "Image_quick_bg", 220, 0, MainPropertyWin32._ResPath.."00000040.png")
    GUI:setAnchorPoint(Image_quick_bg, 0.5, 0)

    local Panel_quick_use_1 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_1", 111, 22, 30, 30)
    GUI:setAnchorPoint(Panel_quick_use_1, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_use_1, true)

    local Panel_quick_use_2 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_2", 154, 22, 30, 30)
    GUI:setAnchorPoint(Panel_quick_use_2, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_use_2, true)

    local Panel_quick_use_3 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_3", 198, 22, 30, 30)
    GUI:setAnchorPoint(Panel_quick_use_3, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_use_3, true)

    local Panel_quick_use_4 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_4", 241, 22, 30, 30)
    GUI:setAnchorPoint(Panel_quick_use_4, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_use_4, true)
    
    local Panel_quick_use_5 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_5", 285, 22, 30, 30)
    GUI:setAnchorPoint(Panel_quick_use_5, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_use_5, true)

    local Panel_quick_use_6 = GUI:Layout_Create(Panel_quick, "Panel_quick_use_6", 329, 22, 30, 30)
    GUI:setAnchorPoint(Panel_quick_use_6, 0.5, 0.5)
    GUI:setTouchEnabled(Panel_quick_use_6, true)

--  气泡栏-----------------------------------------------------------------------
    local Panel_bubble_tips = GUI:Layout_Create(Panel_bg, "Panel_bubble_tips", 160, 220, 250, 50)
    GUI:setAnchorPoint(Panel_bubble_tips, 0, 0)

    local ListView_bubble_tips = GUI:ListView_Create(Panel_bubble_tips, "ListView_bubble_tips", 0, 0, 250, 50, 2)
    GUI:ListView_setClippingEnabled(ListView_bubble_tips, true)
    GUI:ListView_setGravity(ListView_bubble_tips, 3)
    GUI:setTouchEnabled(ListView_bubble_tips, false)

--  auto_tips
    local Panel_auto_tips = GUI:Layout_Create(Panel_bg, "Panel_auto_tips", screenW/2, 210, 300, 50)

--  Set Value
    MainPropertyWin32.Text_level = Text_level
    MainPropertyWin32.LoadingBar_exp = LoadingBar_exp
    MainPropertyWin32.LoadingBar_weight = LoadingBar_weight

    MainPropertyWin32.Text_hp = Text_hp
    MainPropertyWin32.Text_mp = Text_mp
    MainPropertyWin32.LoadingBar_hp  = LoadingBar_hp
    MainPropertyWin32.LoadingBar_mp  = LoadingBar_mp
    MainPropertyWin32.Image_fhp_bg   = Image_fhp_bg
    MainPropertyWin32.Image_fhp_line = Image_fhp_line
    MainPropertyWin32.LoadingBar_fhp = LoadingBar_fhp

    -- 时钟定时器
    local function callback()
        local date = os.date("*t",  SL:GetCurServerTime())
        GUI:Text_setString(Text_time, string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
    end
    local timeID = SL:Schedule(callback, 1)
    callback()

    MainPropertyWin32.UpdateChannel()

--  刷新事件
    MainPropertyWin32.UpdatePkMode()

--  注册监听事件-----------------------------------------------------------------------------
    MainPropertyWin32.RegisterEvent()
end

-- 注册事件
function MainPropertyWin32.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE,              "MainPropertyWin32", MainPropertyWin32.UpdateRoleLevel)
    SL:RegisterLUAEvent(LUA_EVENT_HPMPCHANGE,               "MainPropertyWin32", MainPropertyWin32.UpdateRoleHMp)
    SL:RegisterLUAEvent(LUA_EVENT_EXPCHANGE,                "MainPropertyWin32", MainPropertyWin32.UpdateRoleExp)
    SL:RegisterLUAEvent(LUA_EVENT_PKMODECHANGE,             "MainPropertyWin32", MainPropertyWin32.UpdatePkMode)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_ANGER_CAHNGE,        "MainPropertyWin32", MainPropertyWin32.UpdateHeroAnger)
end

function MainPropertyWin32.UpdateHeroAnger()
    local isHeroOpen = SL:GetMetaValue("USEHERO")
    if isHeroOpen then
        local curAnger = SL:GetMetaValue("H.ANGER")
        local maxAnger = SL:GetMetaValue("H.MAXANGER")
        GUI:LoadingBar_setPercent(MainPropertyWin32.LoadingBar_hj, math.floor(curAnger/maxAnger*100))

        -- 播放动画
        if curAnger == maxAnger then
            local pic = MainPropertyWin32.LoadingBar_hj_ani_pic
            SL:schedule(MainPropertyWin32.LoadingBar_hj_ani_pic, function ()
                GUI:setVisible(MainPropertyWin32.LoadingBar_hj_ani_pic, not GUI:getVisible(MainPropertyWin32.LoadingBar_hj_ani_pic))
            end, 0.2)
        else
            GUI:stopAllActions(MainPropertyWin32.LoadingBar_hj_ani_pic)
        end
    end
end

function MainPropertyWin32.UpdatePkMode()
    local Text_pkmode = MainPropertyWin32.Text_pkmode
    if Text_pkmode then
        local pkMode = SL:GetMetaValue("PKMODE")
        local str = MainPropertyWin32._pkModeStr[pkMode] or MainPropertyWin32._pkModeStr[0]
        GUI:Text_setString(Text_pkmode, str)
    end
end

-- 刷新等级
function MainPropertyWin32.UpdateRoleLevel()
    local roleLevel = SL:GetRoleData().level
    local reinLv = SL:GetRoleData().reinLv
    if MainPropertyWin32.Text_level then
        local str = string.format( "%s%s", roleLevel.. "级", reinLv > 0 and reinLv.. "转" or "")
        GUI:Text_setString(MainPropertyWin32.Text_level, str)
    end
end

-- 刷新 Exp、负重
function MainPropertyWin32.UpdateRoleExp()
    local curExp = SL:GetRoleData().curExp
    local maxExp = SL:GetRoleData().maxExp
    local expPer = curExp/maxExp * 100
    GUI:LoadingBar_setPercent(MainPropertyWin32.LoadingBar_exp, expPer)

    -- 负重
    local curweight = SL:GetMetaValue("M.BW")
    local maxweight = SL:GetMetaValue("M.MAXBW")
    local weightPer = curweight/maxweight * 100
    GUI:LoadingBar_setPercent(MainPropertyWin32.LoadingBar_weight, weightPer)
end

-- 刷新 Hp、Mp
function MainPropertyWin32.UpdateRoleHMp()
    --HPMP
    local curHP = SL:GetRoleData().curHP
    local maxHP = SL:GetRoleData().maxHP
    local curMP = SL:GetRoleData().curMP
    local maxMP = SL:GetRoleData().maxMP
    local hpPer = curHP/maxHP * 100
    local mpPer = curMP/maxMP * 100
    local hpStr = string.format("%s/%s",SL:HPUnit(curHP),SL:HPUnit(maxHP))
    local mpStr = string.format("%s/%s",SL:HPUnit(curMP),SL:HPUnit(maxMP))
    GUI:Text_setString(MainPropertyWin32.Text_hp, hpStr)
    GUI:Text_setString(MainPropertyWin32.Text_mp, mpStr)
    
    local pSize = MainPropertyWin32.pSize

    local roleJob = SL:GetRoleData().job
    if SL:GetRoleData().level < 28 and roleJob == 0 then     -- 战士等级小于28 显示全血
        GUI:setVisible(MainPropertyWin32.LoadingBar_hp, false)
        GUI:setVisible(MainPropertyWin32.LoadingBar_mp, false)
        GUI:setVisible(MainPropertyWin32.LoadingBar_fhp, true)
        GUI:LoadingBar_setPercent(MainPropertyWin32.LoadingBar_fhp, curHP/maxHP * 100)

        if MainPropertyWin32.Panel_hp_sfx and MainPropertyWin32.Panel_mp_sfx and pSize then
            GUI:setVisible(MainPropertyWin32.Panel_hp_sfx, false)
            GUI:setVisible(MainPropertyWin32.Panel_mp_sfx, false)
            GUI:setVisible(MainPropertyWin32.Panel_fhp_sfx, true)
            GUI:setVisible(MainPropertyWin32.Image_fhp_bg, true)
            GUI:setVisible(MainPropertyWin32.Image_fhp_line, true)
            GUI:setContentSize(MainPropertyWin32.Panel_fhp_sfx, {width = pSize[3].width, height = pSize[3].height* hpPer/100})
        else
            GUI:setVisible(MainPropertyWin32.Image_fhp_bg, false)
            GUI:setVisible(MainPropertyWin32.Image_fhp_line, false)
        end 
    else
        GUI:setVisible(MainPropertyWin32.LoadingBar_hp, true)
        GUI:setVisible(MainPropertyWin32.LoadingBar_mp, true)
        GUI:setVisible(MainPropertyWin32.Image_fhp_bg, true)
        GUI:setVisible(MainPropertyWin32.Image_fhp_line, true)
        GUI:setVisible(MainPropertyWin32.LoadingBar_fhp, false)
        GUI:LoadingBar_setPercent(MainPropertyWin32.LoadingBar_hp, curHP/maxHP * 100)
        GUI:LoadingBar_setPercent(MainPropertyWin32.LoadingBar_mp, curMP/maxMP * 100)

        if MainPropertyWin32.Panel_hp_sfx and MainPropertyWin32.Panel_mp_sfx and pSize then
            GUI:setVisible(MainPropertyWin32.Panel_hp_sfx, true)
            GUI:setVisible(MainPropertyWin32.Panel_mp_sfx, true)
            GUI:setVisible(MainPropertyWin32.Panel_fhp_sfx, false)
            GUI:setContentSize(MainPropertyWin32.Panel_hp_sfx, {width = pSize[1].width, height = pSize[1].height* hpPer/100})
            GUI:setContentSize(MainPropertyWin32.Panel_mp_sfx, {width = pSize[2].width, height = pSize[2].height* mpPer/100})
        end 
    end
end

-- 血条特效
function MainPropertyWin32.ShowMHpEffect(Panel_hp, show)
    if not show then
        return false
    end

    local Panel_hp_sfx = GUI:Layout_Create(Panel_hp, "Panel_hp_sfx", 57, 92, 60, 122, true)
    GUI:setAnchorPoint(Panel_hp_sfx, 0.5, 0.5)
    MainPropertyWin32.Panel_hp_sfx = Panel_hp_sfx

    local Panel_mp_sfx = GUI:Layout_Create(Panel_hp, "Panel_mp_sfx", 123, 92, 60, 122, true)
    GUI:setAnchorPoint(Panel_mp_sfx, 0.5, 0.5)
    MainPropertyWin32.Panel_mp_sfx = Panel_mp_sfx

    local Panel_fhp_sfx = GUI:Layout_Create(Panel_hp, "Panel_fhp_sfx", 91, 92, 122, 122, true)
    GUI:setAnchorPoint(Panel_fhp_sfx, 0.5, 0.5)
    MainPropertyWin32.Panel_fhp_sfx = Panel_fhp_sfx

    local ext = {
        count = 29,
        loop = -1,
        speed = 100
    }
    local pSize = {}
    local hpSfx = GUI:Frames_Create(Panel_hp_sfx, "hpSfx", 0, 0, "res/private/mhp_ui/hp_", ".png", 0, nil, ext)
    local hpSfxSize = GUI:getContentSize(hpSfx)
    GUI:setScale(hpSfx, 2)
    GUI:setContentSize(Panel_hp_sfx, hpSfxSize)
    pSize[1] = hpSfxSize

    local mpSfx = GUI:Frames_Create(Panel_mp_sfx, "mpSfx", 0, 0, "res/private/mhp_ui/mp_", ".png", 0, nil, ext)
    GUI:setScale(hpSfx, 2)
    local mpSfxSize = GUI:getContentSize(mpSfx)
    GUI:setContentSize(Panel_mp_sfx, mpSfxSize)
    pSize[2] = mpSfxSize

    local fhpSfx = GUI:Frames_Create(Panel_fhp_sfx, "fhpSfx", 0, 0, "res/private/mhp_ui/fhp_", ".png", 0, nil, ext)
    GUI:setScale(hpSfx, 2)
    local fhpSfxSize = GUI:getContentSize(fhpSfx)
    GUI:setContentSize(Panel_fhp_sfx, fhpSfxSize)
    pSize[3] = fhpSfxSize

    return pSize
end

function MainPropertyWin32.OnSetChatChanel(sender)
    for _,item in pairs(GUI:getChildren(MainPropertyWin32.ListView_channel)) do
        if item then
            GUI:setVisible(GUI:getChildByName(item, "select"), GUI:getTag(item) == GUI:getTag(sender))
        end
    end
    local isvisible = GUI:getVisible(MainPropertyWin32.PanelChannel)
    local rotate = isvisible and 0 or 180
    GUI:setRotation(MainPropertyWin32.Button_arrow, rotate)
    GUI:setVisible(MainPropertyWin32.PanelChannel, not isvisible)
end

function MainPropertyWin32.OnChatChanel(sender)
    if not (sender and MainPropertyWin32.PanelChannel) then
        return false
    end
    local channel = GUI:getTag(sender)
    MainPropertyWin32.UpdateChannel(channel)
    
    GUI:setVisible(MainPropertyWin32.PanelChannel, false)
    GUI:setRotation(MainPropertyWin32.Button_arrow, 0)
end

function MainPropertyWin32.OnClickChangePkMode()
    local pkModeTB = {0, 1, 4, 5, 6, 2}
    -- 区服模式只能在跨服时可切换
    if SL:GetMetaValue("KFSTATE") then
        table.insert(pkModeTB, 10)
    end
    
    local canMode = {}
    for _, mode in ipairs(pkModeTB) do
        if SL:IsShowCurPkMode(mode) then
            table.insert(canMode, mode)
        end
    end

    local function getPKModeIndex(pkm) 
        for k, v in pairs(canMode) do
            if pkm == v then
                return k
            end
        end
        return 1
    end

    local pkMode     = SL:GetMetaValue("PKMODE")
    local index      = getPKModeIndex(pkMode)
    local nextPKMode = canMode[(index >= #canMode and 1 or index+1)]
    SL:RequestChangePKMode(nextPKMode)
end

-- 聊天选择框
function MainPropertyWin32.UpdateChannel(channel, content)
    if channel then
        SL:SetChatChannel(channel)
    else
        channel = SL:GetChatChannel()
    end

    if not _channels[channel] then
        return false
    end

    local Button_channel = MainPropertyWin32.Button_channel
    if not Button_channel then
        return false
    end
    GUI:setTag(Button_channel, channel)

    local Button_arrow = MainPropertyWin32.Button_arrow
    if Button_arrow then
        GUI:setTag(Button_arrow, channel)
    end

    local Image_channel = GUI:getChildByName(Button_channel, "Image_channel")
    if Image_channel then
        GUI:Image_loadTexture(Image_channel, _channels[channel])
    end

    MainPropertyWin32._SetChatPCInputValue(channel, content)
end

-- 气泡cell
function MainPropertyWin32.CreateBubbleTipsCell(parent)
    if not parent then
        return
    end

    local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0, 0, 50, 50)
    GUI:setTouchEnabled(Panel_cell, true)

    -- 图标
    local iconBtn = GUI:Button_Create(Panel_cell, "iconBtn", 25, 25, "Default/Button_Normal.png")
    GUI:setAnchorPoint(iconBtn, 0.5, 0.5)

    -- 倒计时
    --local timeText = GUI:Text_Create(Panel_cell, "timeText", 25, 7, 16, "#FF0000", "10")
    local timeText = GUI:BmpText_Create(Panel_cell, "timeText", 25, 7, "#FF0000", "10")
    GUI:setAnchorPoint(timeText, 0.5, 0.5)
end