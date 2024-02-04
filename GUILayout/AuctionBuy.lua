AuctionBuy = {}

function AuctionBuy.main()
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
    local Image_title = GUI:Image_Create(PMainUI, "Image_title", 205, 235, "res/private/auction/word_paimaihang_03.png")
    GUI:setAnchorPoint(Image_title, {x=0.5, y=0.5})


    -- 道具名
    local Text_name = GUI:Text_Create(PMainUI, "Text_name", 107, 110, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_name, {x=0.5, y=0.5})

    -- 道具底框
    local ItemBg = GUI:Image_Create(PMainUI, "ItemBg", 107, 158, "res/public/1900000664.png")
    GUI:setAnchorPoint(ItemBg, {x=0.5, y=0.5})

    
    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 245, 165, 16, "#ffffff", "购买数量:")
    GUI:setAnchorPoint(Text_1, {x=1, y=0.5}) 

    local Text_2 = GUI:Text_Create(PMainUI, "Text_2", 245, 125, 16, "#ffffff", "购买价格:")
    GUI:setAnchorPoint(Text_2, {x=1, y=0.5}) 


    local Imagebg_1 = GUI:Image_Create(PMainUI, "Imagebg_1", 305, 165, "res/public/1900000668.png")
    GUI:setAnchorPoint(Imagebg_1, {x=0.5, y=0.5})
    GUI:setContentSize(Imagebg_1, {width = 96, height = 24})
    GUI:Image_setScale9Slice(Imagebg_1, 20, 20, 4, 4)

    local Imagebg_2 = GUI:Image_Create(PMainUI, "Imagebg_2", 305, 125, "res/public/1900000668.png")
    GUI:setAnchorPoint(Imagebg_2, {x=0.5, y=0.5})
    GUI:setContentSize(Imagebg_2, {width = 96, height = 24})
    GUI:Image_setScale9Slice(Imagebg_2, 20, 20, 4, 4)

    local Text_count = GUI:Text_Create(PMainUI, "Text_count", 305, 165, 16, "#ffffff", "100")
    GUI:setAnchorPoint(Text_count, {x=0.5, y=0.5}) 

    local Text_price = GUI:Text_Create(PMainUI, "Text_price", 350, 125, 16, "#ffffff", "100")
    GUI:setAnchorPoint(Text_price, {x=1, y=0.5}) 

    local Node_money = GUI:Node_Create(PMainUI, "Node_money", 275, 125)
    GUI:setAnchorPoint(Node_money, {x=0.5, y=0.5})

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
    GUI:Button_setTitleText(Button_submit, "确认购买")
end