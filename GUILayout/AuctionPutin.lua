AuctionPutin = {}

function AuctionPutin.main()
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
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 355, 455, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function () GUI:Win_Close(parent) end)

    -- 标题
    local Text_title = GUI:Text_Create(PMainUI, "Text_title", 177.5, 470, 16, "#ffffff", "上架道具")
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

    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 108, 315, 16, "#ffffff", "上架数量：")
    GUI:setAnchorPoint(Text_1, {x=1, y=0.5}) 
    -- btn sub
    local BtnSub = GUI:Button_Create(PMainUI, "BtnSub", 137, 315, "res/public/1900000620.png")
    GUI:Button_loadTexturePressed(BtnSub, "res/public/1900000620_1.png")
    GUI:setAnchorPoint(BtnSub, {x=0.5, y=0.5})

    -- btn add
    local BtnAdd = GUI:Button_Create(PMainUI, "BtnAdd", 285, 315, "res/public/1900000621.png")
    GUI:Button_loadTexturePressed(BtnAdd, "res/public/1900000621_1.png")
    GUI:setAnchorPoint(BtnAdd, {x=0.5, y=0.5})

    -- 输入框
    local input_bg = GUI:Image_Create(PMainUI, "Input_bg", 211, 315, "res/public/1900000668.png")
    GUI:setAnchorPoint(input_bg, {x=0.5, y=0.5})
    GUI:setContentSize(input_bg, {width = 102, height = 31})
    GUI:Image_setScale9Slice(input_bg, 20, 20, 4, 4)

    local TextField_count = GUI:TextInput_Create(PMainUI, "TextField_count", 211, 315, 95, 24, 16)
    GUI:Text_setTextHorizontalAlignment(TextField_count, 1)
    GUI:setAnchorPoint(TextField_count, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField_count, 2)


    local Text_2 = GUI:Text_Create(PMainUI, "Text_2", 108, 275, 16, "#ffffff", "出售货币：")
    GUI:setAnchorPoint(Text_2, {x=1, y=0.5}) 
    local Node_currency = GUI:Node_Create(PMainUI, "Node_currency", 207, 275)
    GUI:setAnchorPoint(Node_currency, {x=0.5, y=0.5})

    local cell = AuctionPutin.createCell_1(PMainUI)
    GUI:setVisible(cell, false)


    local Text_3 = GUI:Text_Create(PMainUI, "Text_3", 108, 240, 16, "#ffffff", "行会折扣：")
    GUI:setAnchorPoint(Text_3, {x=1, y=0.5}) 
    local Node_rebate = GUI:Node_Create(PMainUI, "Node_rebate", 207, 240)
    GUI:setAnchorPoint(Node_rebate, {x=0.5, y=0.5})


    local Text_4 = GUI:Text_Create(PMainUI, "Text_4", 108, 190, 16, "#ffffff", "竞拍价：")
    GUI:setAnchorPoint(Text_4, {x=1, y=0.5}) 

    local Panel_bid_able = GUI:Layout_Create(PMainUI, "Panel_bid_able", 40, 190, 250, 34)
    GUI:Layout_setBackGroundColorType(Panel_bid_able, 1)
    GUI:Layout_setBackGroundColor(Panel_bid_able, "#000000")
    GUI:Layout_setBackGroundColorOpacity(Panel_bid_able, 80)
    GUI:setAnchorPoint(Panel_bid_able, {x=0, y=0.5})
    GUI:setTouchEnabled(Panel_bid_able, true)

    local Image_2 = GUI:Image_Create(PMainUI, "Image_2", 207, 190, "res/public/1900000668.png")
    GUI:setAnchorPoint(Image_2, {x=0.5, y=0.5})
    GUI:setContentSize(Image_2, {width = 160, height = 31})
    GUI:Image_setScale9Slice(Image_2, 20, 20, 4, 4)

    local TextField_bid_price = GUI:TextInput_Create(PMainUI, "TextField_bid_price", 225, 190, 110, 22, 16)
    GUI:Text_setTextHorizontalAlignment(TextField_bid_price, 1)
    GUI:setAnchorPoint(TextField_bid_price, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField_bid_price, 2)

    local Image_bid_input = GUI:Image_Create(PMainUI, "Image_bid_input", 275, 190, "res/public/btn_szjm_04.png")
    GUI:setAnchorPoint(Image_bid_input, {x=0.5, y=0.5})

    local CheckBox_bid = GUI:CheckBox_Create(PMainUI, "CheckBox_bid", 305, 190, "res/public/1900000550.png", "res/public/1900000551.png")
    GUI:setAnchorPoint(CheckBox_bid, 0.5, 0.5)

    local Node_money_bid = GUI:Node_Create(PMainUI, "Node_money_bid", 150, 190)
    GUI:setAnchorPoint(Node_money_bid, {x=0.5, y=0.5})

    local Text_5 = GUI:Text_Create(PMainUI, "Text_5", 108, 145, 16, "#ffffff", "一口价：")
    GUI:setAnchorPoint(Text_5, {x=1, y=0.5})

    local Panel_buy_able = GUI:Layout_Create(PMainUI, "Panel_buy_able", 40, 145, 250, 34)
    GUI:Layout_setBackGroundColorType(Panel_buy_able, 1)
    GUI:Layout_setBackGroundColor(Panel_buy_able, "#000000")
    GUI:Layout_setBackGroundColorOpacity(Panel_buy_able, 80)
    GUI:setAnchorPoint(Panel_buy_able, {x=0, y=0.5})
    GUI:setTouchEnabled(Panel_buy_able, true)

    local Image_3 = GUI:Image_Create(PMainUI, "Image_3", 207, 145, "res/public/1900000668.png")
    GUI:setAnchorPoint(Image_3, {x=0.5, y=0.5})
    GUI:setContentSize(Image_3, {width = 160, height = 31})
    GUI:Image_setScale9Slice(Image_3, 20, 20, 4, 4)

    local TextField_buy_price = GUI:TextInput_Create(PMainUI, "TextField_buy_price", 225, 145, 110, 22, 16)
    GUI:Text_setTextHorizontalAlignment(TextField_buy_price, 1)
    GUI:setAnchorPoint(TextField_buy_price, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField_buy_price, 2)

    local Image_buy_input = GUI:Image_Create(PMainUI, "Image_buy_input", 275, 145, "res/public/btn_szjm_04.png")
    GUI:setAnchorPoint(Image_buy_input, {x=0.5, y=0.5})

    local CheckBox_buy = GUI:CheckBox_Create(PMainUI, "CheckBox_buy", 305, 145, "res/public/1900000550.png", "res/public/1900000551.png")
    GUI:setAnchorPoint(CheckBox_buy, 0.5, 0.5)

    local Node_money_buy = GUI:Node_Create(PMainUI, "Node_money_buy", 150, 145)
    GUI:setAnchorPoint(Node_money_buy, 0.5, 0.5)

    --------------------------------------------------------------------------------------------
    local Image_currency = GUI:Image_Create(PMainUI, "Image_currency", 207, 257.5, "res/public/1900000677.png")
    GUI:setContentSize(Image_currency, {width = 150, height = 238})
    GUI:setAnchorPoint(Image_currency, {x=0.5, y=1})
    GUI:Image_setScale9Slice(Image_currency, 10, 10, 14, 14)
    GUI:setVisible(Image_currency, false)

    local ListView_currency = GUI:ListView_Create(PMainUI, "ListView_currency", 207, 255, 150, 235, 1)
    GUI:setAnchorPoint(ListView_currency, {x=0.5, y=1})
    GUI:setVisible(ListView_currency, false)

    --------------------------------------------------------------------------------------------
    local Image_rebate = GUI:Image_Create(PMainUI, "Image_rebate", 207, 222.5, "res/public/1900000677.png")
    GUI:setContentSize(Image_rebate, {width = 150, height = 238})
    GUI:setAnchorPoint(Image_rebate, {x=0.5, y=1})
    GUI:Image_setScale9Slice(Image_rebate, 10, 10, 14, 14)
    GUI:setVisible(Image_rebate, false)

    local ListView_rebate = GUI:ListView_Create(PMainUI, "ListView_rebate", 207, 220, 150, 235, 1)
    GUI:setAnchorPoint(ListView_rebate, {x=0.5, y=1})
    GUI:setVisible(ListView_rebate, false)

    --------------------------------------------------------------------------------------------
    local Button_cancel = GUI:Button_Create(PMainUI, "Button_cancel", 90, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_cancel, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_cancel, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_cancel, 18)
    GUI:Button_setTitleColor(Button_cancel, "#FFFFFF")
    GUI:Button_setTitleText(Button_cancel, "取消上架")
    GUI:addOnClickEvent(Button_cancel, function () GUI:Win_Close(parent) end)

    local Button_submit = GUI:Button_Create(PMainUI, "Button_submit", 265, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_submit, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button_submit, 18)
    GUI:Button_setTitleColor(Button_submit, "#FFFFFF")
    GUI:Button_setTitleText(Button_submit, "世界上架")
end

function AuctionPutin.createCell_1(parent)
    local cell = GUI:Layout_Create(parent, "Cell_1", 0, 0, 150, 30)
    GUI:setAnchorPoint(cell, {x=1, y=0.5})
    GUI:setTouchEnabled(cell, true)

    local Image_1_1 = GUI:Image_Create(cell, "Image_1_1", 0, 1, "res/public/1900000668.png")
    GUI:setContentSize(Image_1_1, {width = 150, height = 28})

    local Image_line = GUI:Image_Create(cell, "Image_line", 0, 1, "res/public/1900000667_1.png")
    GUI:setContentSize(Image_line, {width = 150, height = 1})

    local Panel_item = GUI:Layout_Create(cell, "Panel_item", 20, 15, 0, 0)
    GUI:setAnchorPoint(Panel_item, {x=0.5, y=0.5})

    local Text_name = GUI:Text_Create(cell, "Text_name", 75, 15, 16, "#ffffff", "")
    GUI:setAnchorPoint(Text_name, {x=0.5, y=0.5})

    return cell
end