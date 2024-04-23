AuctionPutout = {}

function AuctionPutout.main()
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
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 568, 320, 355, 495)
    GUI:setAnchorPoint(PMainUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0, 0, "res/public/1900000601.png")
    GUI:Image_setScale9Slice(Image_bg, 30, 30, 30, 30)
    GUI:setContentSize(Image_bg, {width = 355, height = 495})

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 355, 452, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function () GUI:Win_Close(parent) end)

    -- 标题
    local Text_title = GUI:Text_Create(PMainUI, "Text_title", 177.5, 470, 16, "#ffffff", "下架道具")
    GUI:setAnchorPoint(Text_title, {x=0.5, y=0.5})

    -- 线
    local line = GUI:Image_Create(PMainUI, "line", 177.5, 452, "res/public/1900000667.png")
    GUI:setContentSize(line, {width = 300, height = 2})
    GUI:setAnchorPoint(line, {x=0.5, y=0.5})

    -- 道具名
    local Text_name = GUI:Text_Create(PMainUI, "Text_name", 177.5, 430, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_name, {x=0.5, y=0.5})

    -- 道具底框
    local ItemBg = GUI:Image_Create(PMainUI, "ItemBg", 177.5, 380, "res/public/1900000664.png")
    GUI:setAnchorPoint(ItemBg, {x=0.5, y=0.5})

    -- 竞拍状态（竞拍中、超时）
    local Text_status = GUI:Text_Create(PMainUI, "Text_status", 177.5, 315, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_status, {x=0.5, y=0.5}) 

    -- 倒计时
    local Text_remaining = GUI:Text_Create(PMainUI, "Text_remaining", 95, 265, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_remaining, {x=0.5, y=0.5}) 

    -- 上架数量
    local Text_count = GUI:Text_Create(PMainUI, "Text_count", 260, 265, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_count, {x=0.5, y=0.5}) 
   
    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 110, 210, 16, "#ffffff", "竞拍价：")
    GUI:setAnchorPoint(Text_1, {x=1, y=0.5}) 

    local Image_1 = GUI:Image_Create(PMainUI, "Image_1", 210, 210, "res/public/1900000668.png")
    GUI:setAnchorPoint(Image_1, {x=0.5, y=0.5})
    GUI:setContentSize(Image_1, {width = 188, height = 31})
    GUI:Image_setScale9Slice(Image_1, 20, 20, 4, 4)

    local Node_money_bid = GUI:Node_Create(PMainUI, "Node_money_bid", 135, 210)
    GUI:setAnchorPoint(Node_money_bid, {x=0.5, y=0.5})

    local Text_bid_price = GUI:Text_Create(PMainUI, "Text_bid_price", 220, 210, 16, "#ffffff", "999")
    GUI:setAnchorPoint(Text_bid_price, {x=0.5, y=0.5})


    local Text_2 = GUI:Text_Create(PMainUI, "Text_2", 110, 160, 16, "#ffffff", "一口价：")
    GUI:setAnchorPoint(Text_2, {x=1, y=0.5}) 

    local Image_2 = GUI:Image_Create(PMainUI, "Image_2", 210, 160, "res/public/1900000668.png")
    GUI:setAnchorPoint(Image_2, {x=0.5, y=0.5})
    GUI:setContentSize(Image_2, {width = 188, height = 31})
    GUI:Image_setScale9Slice(Image_2, 20, 20, 4, 4)

    local Node_money_buy = GUI:Node_Create(PMainUI, "Node_money_buy", 135, 160)
    GUI:setAnchorPoint(Node_money_buy, {x=0.5, y=0.5})

    local Text_buy_price = GUI:Text_Create(PMainUI, "Text_buy_price", 220, 160, 16, "#ffffff", "999")
    GUI:setAnchorPoint(Text_buy_price, {x=0.5, y=0.5})

    --------------------------------------------------------------------------------------------
    local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 90, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_cancel, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_cancel, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_cancel, 18)
    GUI:Button_setTitleColor(Button_cancel, "#FFFFFF")
    GUI:Button_setTitleText(Button_cancel, "取消")
    GUI:addOnClickEvent(Button_cancel, function () GUI:Win_Close(parent) end)

    local Button_submit = GUI:Button_Create(PMainUI, "Button_submit", 265, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_submit, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_submit, 18)
    GUI:Button_setTitleColor(Button_submit, "#FFFFFF")
    GUI:Button_setTitleText(Button_submit, "下架道具")
end