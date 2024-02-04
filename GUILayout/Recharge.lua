Recharge = {}

function Recharge.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, attachW, attachH)
    GUI:setTouchEnabled(PMainUI, true)

    local Image_1 = GUI:Image_Create(PMainUI, "Image_1", attachW/2, 425, "res/public/1900000668.png")
    GUI:setContentSize(Image_1, {width = 725, height = 31})
    GUI:Image_setScale9Slice(Image_1, 20, 20, 5, 5)
    GUI:setAnchorPoint(Image_1, {x=0.5, y=0.5})

    local Image_2 = GUI:Image_Create(PMainUI, "Image_2", attachW/2, 405, "res/public/1900000668.png")
    GUI:setContentSize(Image_2, {width = 725, height = 195})
    GUI:Image_setScale9Slice(Image_2, 20, 20, 5, 5)
    GUI:setAnchorPoint(Image_2, {x=0.5, y=1})

    local Image_3 = GUI:Image_Create(PMainUI, "Image_3", attachW/2, 205, "res/public/1900000668.png")
    GUI:setContentSize(Image_3, {width = 725, height = 200})
    GUI:Image_setScale9Slice(Image_3, 20, 20, 5, 5)
    GUI:setAnchorPoint(Image_3, {x=0.5, y=1})

    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 10, 425, 16, "#FFFFFF", "本服名称:")
    GUI:setAnchorPoint(Text_1, {x=0, y=0.5})
    local Text_servername = GUI:Text_Create(PMainUI, "Text_servername", 95, 425, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_servername, {x=0, y=0.5})

    local Text_2 = GUI:Text_Create(PMainUI, "Text_2", 300, 425, 16, "#FFFFFF", "充值角色:")
    GUI:setAnchorPoint(Text_2, {x=0, y=0.5})
    local Text_rolename = GUI:Text_Create(PMainUI, "Text_rolename", 385, 425, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_rolename, {x=0, y=0.5})

    local Text_3 = GUI:Text_Create(PMainUI, "Text_3", 10, 370, 16, "#FFFFFF", "货币种类:")
    GUI:setAnchorPoint(Text_3, {x=0, y=0.5})

    local Text_4 = GUI:Text_Create(PMainUI, "Text_4", 10, 310, 16, "#FFFFFF", "充值金额:")
    GUI:setAnchorPoint(Text_4, {x=0, y=0.5})
    local Text_4_0 = GUI:Text_Create(PMainUI, "Text_4_0", 17, 293, 12, "#FFFF00", "输入金额")
    GUI:setAnchorPoint(Text_4_0, {x=0, y=0.5})
    local Image_input_bg = GUI:Image_Create(PMainUI, "Image_input_bg", 95, 310, "res/private/powerful_secret/input_bg.png")
    GUI:setContentSize(Image_input_bg, {width = 110, height = 27})
    GUI:setAnchorPoint(Image_input_bg, {x=0, y=0.5})
    local TextField_input = GUI:TextInput_Create(PMainUI, "TextField_input", 97, 310, 105, 24, 18)
    GUI:Text_setTextHorizontalAlignment(TextField_input, 0)
    GUI:setAnchorPoint(TextField_input, {x=0, y=0.5})
    GUI:TextInput_setInputMode(TextField_input, 2)
    GUI:TextInput_setMaxLength(TextField_input, 8)
    -- 货币单位
    local Text_exchange = GUI:Text_Create(PMainUI, "Text_exchange", 10, 260, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_exchange, {x=0, y=0.5})

    local Text_5 = GUI:Text_Create(PMainUI, "Text_5", 10, 260, 16, "#FFFFFF", "充值方式:")
    GUI:setAnchorPoint(Text_5, {x=0, y=0.5})

    -- 支付宝
    local Button_alipay = GUI:Button_Create(PMainUI, "Button_alipay", 140, 260, "res/private/powerful_secret/bg_czzya_05.png")
    GUI:setAnchorPoint(Button_alipay, {x=0.5, y=0.5})
    local Image_flag = GUI:Image_Create(Button_alipay, "Image_flag", 88, 33, "res/private/powerful_secret/bg_czzya_05_1.png")
    GUI:setAnchorPoint(Image_flag, {x=1, y=1})

    -- 花呗
    local Button_huabei = GUI:Button_Create(PMainUI, "Button_huabei", 250, 260, "res/private/powerful_secret/bg_czzya_06.png")
    GUI:setAnchorPoint(Button_huabei, {x=0.5, y=0.5})
    local Image_flag = GUI:Image_Create(Button_huabei, "Image_flag", 88, 33, "res/private/powerful_secret/bg_czzya_05_1.png")
    GUI:setAnchorPoint(Image_flag, {x=1, y=1})

    -- 微信
    local Button_weixin = GUI:Button_Create(PMainUI, "Button_weixin", 360, 260, "res/private/powerful_secret/bg_czzya_04.png")
    GUI:setAnchorPoint(Button_weixin, {x=0.5, y=0.5})
    local Image_flag = GUI:Image_Create(Button_weixin, "Image_flag", 88, 33, "res/private/powerful_secret/bg_czzya_04_1.png")
    GUI:setAnchorPoint(Image_flag, {x=1, y=1})
    GUI:setVisible(Button_weixin, false)

    local Text_more = GUI:Text_Create(PMainUI, "Text_more", 315, 260, 16, "#FFFFFF", "更多支付方式")
    GUI:setTouchEnabled(Text_more, true)
    GUI:setAnchorPoint(Text_more, {x=0, y=0.5})

    local Button_submit = GUI:Button_Create(PMainUI, "Button_submit", 640, 260, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(Button_submit, "res/public/1900000661.png")
    GUI:setAnchorPoint(Button_submit, {x=0.5, y=0.5})
    GUI:Button_setTitleColor(Button_submit, "#FFFFFF")
    GUI:Button_setTitleFontSize(Button_submit, 16)
    GUI:Button_setTitleText(Button_submit, "确认支付")

    local Node_desc = GUI:Node_Create(PMainUI, "Node_desc", 317, 210)

    ----------------------------------------------------------------------
    local ListView_cells = GUI:ListView_Create(PMainUI, "ListView_cells", 100, 370, 600, 50, 2)
    GUI:setAnchorPoint(ListView_cells, {x=0, y=0.5})
    GUI:ListView_setItemsMargin(ListView_cells, 70)

    local product_cell = Recharge.createCell(PMainUI)
    GUI:setVisible(product_cell, false)
end

function Recharge.createCell(parent)
    local cell = GUI:Layout_Create(parent, "product_cell", 0, 0, 115, 50, true)
    GUI:setTouchEnabled(cell, true)

    local Image_product = GUI:Image_Create(cell, "Image_product", 57.5, 25, "res/private/powerful_secret/bg_czzya_01.png")
    GUI:setAnchorPoint(Image_product, {x=0.5, y=0.5})

    local Image_select = GUI:Image_Create(cell, "Image_select", 57.5, 25, "res/private/powerful_secret/bg_czzya_01.png")
    GUI:setContentSize(Image_select, {width = 115, height = 50})
    GUI:Image_setScale9Slice(Image_select, 12, 12, 12, 12)
    GUI:setAnchorPoint(Image_select, {x=0.5, y=0.5})

    local Text_name = GUI:Text_Create(cell, "Text_name", 57.5, 35, 16, "#FFFF00", "")
    GUI:setAnchorPoint(Text_name, {x=0.5, y=0.5})

    local Text_ratio = GUI:Text_Create(cell, "Text_ratio", 57.5, 15, 12, "#FFFF00", "")
    GUI:setAnchorPoint(Text_ratio, {x=0.5, y=0.5})

    return cell
end