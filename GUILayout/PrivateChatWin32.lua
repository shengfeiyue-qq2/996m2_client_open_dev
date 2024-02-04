PrivateChatWin32 = {}

function PrivateChatWin32.main()
    local parent = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, 400, 261)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:Layout_setBackGroundImage(PMainUI, "res/private/main-win32/chat/private_bg.png")
    GUI:setTouchEnabled(PMainUI, true)

    GUI:Win_SetDrag(parent, PMainUI)
    GUI:setMouseEnabled(PMainUI, true)

    local Button_close = GUI:Button_Create(PMainUI, "Button_close", 377, 238, "res/private/main-win32/btn_close.png")
    GUI:setAnchorPoint(Button_close, 0.5, 0.5)
    GUI:addOnClickEvent(Button_close, function ()
        GUI:Win_Close(parent)
    end)

    -- 聊天记录列表
    local ListView_cells = GUI:ListView_Create(PMainUI, "ListView_cells", 16, 44, 345, 175, 1)

    -- 滚动条
    -- 背景
    local Image_scroll_bg = GUI:Image_Create(PMainUI, "Image_scroll_bg", 370, 129, "res/private/main-win32/chat/line1.png")
    GUI:setContentSize(Image_scroll_bg, 16, 175)
    GUI:setAnchorPoint(Image_scroll_bg, 0.5, 0.5)
    -- 上
    local Button_scroll_top = GUI:Button_Create(Image_scroll_bg, "Button_scroll_top", 9, 174, "res/private/main-win32/chat/t1.png")
    GUI:Button_loadTexturePressed(Button_scroll_top, "res/private/main-win32/chat/t1_1.png")
    GUI:setAnchorPoint(Button_scroll_top, 0.5, 1)
    -- 下
    local Button_scroll_btm = GUI:Button_Create(Image_scroll_bg, "Button_scroll_btm", 9, 1, "res/private/main-win32/chat/b1.png")
    GUI:Button_loadTexturePressed(Button_scroll_btm, "res/private/main-win32/chat/b1_1.png")
    GUI:setAnchorPoint(Button_scroll_btm, 0.5, 0)
    --bar
    local Slider_bar = GUI:Slider_Create(Image_scroll_bg, "Slider_bar", 7.5, 87.5, "res/public/0.png", "res/public/0.png", "res/private/main-win32/chat/p1.png")
    GUI:setContentSize(Slider_bar, 133, 16)
    GUI:setAnchorPoint(Slider_bar, 0.5, 0.5)
    GUI:setRotation(Slider_bar, 90)
    GUI:Slider_setPercent(Slider_bar, 100)

    local CheckBox_auto = GUI:CheckBox_Create(PMainUI, "CheckBox_auto", 28, 30, "res/private/main-win32/1900000654.png", "res/private/main-win32/1900000655.png")
    GUI:setAnchorPoint(CheckBox_auto, 0.5, 0.5)

    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 37, 28.5, 12, "ffffff", "自动回复")
    GUI:setAnchorPoint(Text_1, 0, 0.5)

    -- 输入框
    local Image_input = GUI:Image_Create(PMainUI, "Image_input", 378, 30, "res/private/main-win32/chat/bg_input.png")
    GUI:setContentSize(Image_input, 288, 22)
    GUI:Image_setScale9Slice(Image_input, 50, 50, 6, 6)
    GUI:setAnchorPoint(Image_input, 1, 0.5)

    local TextField_input = GUI:TextInput_Create(Image_input, "TextField_input", 144, 9, 282, 16, 12)
    GUI:Text_setTextHorizontalAlignment(TextField_input, 0)
    GUI:TextInput_setPlaceHolder(TextField_input, "输入自动回复内容")
    GUI:TextInput_setInputMode(TextField_input, 6)
    GUI:TextInput_setMaxLength(TextField_input, SL._DEBUG and 9999 or 60)
    GUI:setAnchorPoint(TextField_input, 0.5, 0.5)
end