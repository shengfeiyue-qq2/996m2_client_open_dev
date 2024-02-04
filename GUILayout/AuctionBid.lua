AuctionBid = {}

function AuctionBid.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏关闭
    if not SL:IsWinMode() then
        local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)
        GUI:Layout_setBackGroundColorType(CloseLayout, 1)
        GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
        GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
        GUI:setTouchEnabled(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function () GUI:Win_Close(parent) end)
    end

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568, 320, 410, 270)
    GUI:setAnchorPoint(PMainUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(PMainUI, true)

    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0, 0, "res/public/1900000600.png")
    GUI:Image_setScale9Slice(Image_bg, 30, 30, 30, 30)
    GUI:setContentSize(Image_bg, {width = 410, height = 270})

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 410, 228, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function () GUI:Win_Close(parent) end)

    -- 标题
    local Image_title = GUI:Image_Create(PMainUI, "Image_title", 205, 235, "res/private/auction/word_paimaihang_02.png")
    GUI:setAnchorPoint(Image_title, {x=0.5, y=0.5})

    -- 线
    local line = GUI:Image_Create(PMainUI, "line", 265, 130, "res/public/1900000667.png")
    GUI:setContentSize(line, {width = 230, height = 2})
    GUI:setAnchorPoint(line, {x=0.5, y=0.5})

    -- 道具名
    local Text_name = GUI:Text_Create(PMainUI, "Text_name", 107, 110, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_name, {x=0.5, y=0.5})

    -- 道具底框
    local ItemBg = GUI:Image_Create(PMainUI, "ItemBg", 107, 158, "res/public/1900000664.png")
    GUI:setAnchorPoint(ItemBg, {x=0.5, y=0.5})

    
    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 245, 185, 16, "#ffffff", "当前竞价:")
    GUI:setAnchorPoint(Text_1, {x=1, y=0.5}) 

    local Text_2 = GUI:Text_Create(PMainUI, "Text_2", 245, 155, 16, "#ffffff", "加价金额:")
    GUI:setAnchorPoint(Text_2, {x=1, y=0.5}) 

    local Text_3 = GUI:Text_Create(PMainUI, "Text_3", 245, 110, 16, "#ffffff", "出价金额:")
    GUI:setAnchorPoint(Text_3, {x=1, y=0.5}) 

    local Imagebg_1 = GUI:Image_Create(PMainUI, "Imagebg_1", 305, 185, "res/public/1900000668.png")
    GUI:setAnchorPoint(Imagebg_1, {x=0.5, y=0.5})
    GUI:setContentSize(Imagebg_1, {width = 96, height = 24})
    GUI:Image_setScale9Slice(Imagebg_1, 20, 20, 4, 4)

    local Imagebg_2 = GUI:Image_Create(PMainUI, "Imagebg_2", 305, 155, "res/public/1900000668.png")
    GUI:setAnchorPoint(Imagebg_2, {x=0.5, y=0.5})
    GUI:setContentSize(Imagebg_2, {width = 96, height = 24})
    GUI:Image_setScale9Slice(Imagebg_2, 20, 20, 4, 4)

    local Imagebg_3 = GUI:Image_Create(PMainUI, "Imagebg_3", 305, 110, "res/public/1900000668.png")
    GUI:setAnchorPoint(Imagebg_3, {x=0.5, y=0.5})
    GUI:setContentSize(Imagebg_3, {width = 96, height = 24})
    GUI:Image_setScale9Slice(Imagebg_3, 20, 20, 4, 4)

    local Text_price = GUI:Text_Create(PMainUI, "Text_price", 350, 185, 16, "#ffffff", "100")
    GUI:setAnchorPoint(Text_price, {x=1, y=0.5}) 
    
    local TextField_add_price = GUI:TextInput_Create(PMainUI, "TextField_add_price", 345, 155, 55, 20, 16)
    GUI:Text_setTextHorizontalAlignment(TextField_add_price, 2)
    GUI:setAnchorPoint(TextField_add_price, {x=01, y=0.5})
    GUI:TextInput_setInputMode(TextField_add_price, 2)

    local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 370, 155, "res/public/btn_szjm_04.png")
    GUI:setAnchorPoint(Image_1, {x=0.5, y=0.5})

    local Text_bid_price = GUI:Text_Create(PMainUI, "Text_bid_price", 350, 110, 16, "#ffffff", "100")
    GUI:setAnchorPoint(Text_bid_price, {x=1, y=0.5})


    local Node_money1 = GUI:Node_Create(PMainUI, "Node_money1", 275, 185)
    GUI:setAnchorPoint(Node_money1, {x=0.5, y=0.5})

    local Node_money2 = GUI:Node_Create(PMainUI, "Node_money2", 275, 155)
    GUI:setAnchorPoint(Node_money2, {x=0.5, y=0.5})

    local Node_money3 = GUI:Node_Create(PMainUI, "Node_money3", 275, 110)
    GUI:setAnchorPoint(Node_money3, {x=0.5, y=0.5})

    --------------------------------------------------------------------------------------------
    local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 115, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_cancel, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_cancel, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_cancel, 18)
    GUI:Button_setTitleColor(Button_cancel, "#FFFFFF")
    GUI:Button_setTitleText(Button_cancel, "取消")
    GUI:addOnClickEvent(Button_cancel, function () GUI:Win_Close(parent) end)

    local Button_submit = GUI:Button_Create(PMainUI, "Button_submit", 295, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_submit, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_submit, 18)
    GUI:Button_setTitleColor(Button_submit, "#FFFFFF")
    GUI:Button_setTitleText(Button_submit, "确认出价")
end