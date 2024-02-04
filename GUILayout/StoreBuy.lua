StoreBuy = {}

function StoreBuy.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local pWidth  = 256
    local pHeight = 359

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 770, 360, pWidth, pHeight)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:Win_SetDrag(parent, PMainUI)
    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local pBg = GUI:Image_Create(PMainUI, "pBg", pWidth/2, pHeight/2, "res/public/1900000601.png")
    GUI:setAnchorPoint(pBg, 0.5, 0.5)

    -- 标题
    local Text_title = GUI:Text_Create(PMainUI, "Text_title", pWidth/2, 335, 18, "#ffffff", "道具购买")
    GUI:setAnchorPoint(Text_title, {x=0.5, y=0.5})

    local line = GUI:Image_Create(PMainUI, "line", pWidth/2, 320, "res/public/1900000667.png")
    GUI:setAnchorPoint(line, 0.5, 0.5)

    -- 道具底框
    local ItemBg = GUI:Image_Create(PMainUI, "ItemBg", 60, 270, "res/public/1900000664.png")
    GUI:setAnchorPoint(ItemBg, {x=0.5, y=0.5})

    -- 道具
    local NodeItem = GUI:Node_Create(PMainUI, "NodeItem", 60, 270)
    GUI:setAnchorPoint(NodeItem, {x=0.5, y=0.5})

    -- 单价
    local NodeSingle = GUI:Node_Create(PMainUI, "NodeSingle", 30, 208)
    GUI:setAnchorPoint(NodeSingle, {x=0, y=0.5})

    -- 总价
    local NodeTotal = GUI:Node_Create(PMainUI, "NodeTotal", 30, 112)
    GUI:setAnchorPoint(NodeTotal, {x=0, y=0.5})

    -- 道具名
    local Text_name = GUI:Text_Create(PMainUI, "Text_name", 105, 270, 18, "#ffffff", "")
    GUI:setAnchorPoint(Text_name, {x=0, y=0.5})

    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 30, 160, 16, "#ffffff", "数量:")
    GUI:setAnchorPoint(Text_1, {x=0, y=0.5}) 

    -- btn sub
    local BtnSub = GUI:Button_Create(PMainUI, "BtnSub", 95, 160, "res/public/1900000620.png")
    GUI:Button_loadTexturePressed(BtnSub, "res/public/1900000620_1.png")
    GUI:setAnchorPoint(BtnSub, {x=0.5, y=0.5})

    -- btn add
    local BtnAdd = GUI:Button_Create(PMainUI, "BtnAdd", 220, 160, "res/public/1900000621.png")
    GUI:Button_loadTexturePressed(BtnAdd, "res/public/1900000621_1.png")
    GUI:setAnchorPoint(BtnAdd, {x=0.5, y=0.5})

    local editBg = GUI:Image_Create(PMainUI, "editBg", 158, 160, "res/public/1900000676.png")
    GUI:setAnchorPoint(editBg, {x=0.5, y=0.5})

    local TextField = GUI:TextInput_Create(PMainUI, "TextField", 158, 160, 67, 24, 20)
    GUI:Text_setTextHorizontalAlignment(TextField, 1)
    GUI:setAnchorPoint(TextField, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField, 2)

    -- 购买
    local BtnBuy = GUI:Button_Create(PMainUI, "BtnBuy", pWidth/2, 50, "res/public/1900000660.png")
    GUI:Button_loadTexturePressed(BtnBuy, "res/public/1900000661.png")
    GUI:setAnchorPoint(BtnBuy, {x=0.5, y=0.5})
    GUI:Button_setTitleFontSize(BtnBuy, 18)
    GUI:Button_setTitleColor(BtnBuy, "#FFFFFF")
    GUI:Button_setTitleText(BtnBuy, "购买")

    -- 关闭按钮
    local Button_close = GUI:Button_Create(PMainUI, "Button_close", pWidth, pHeight, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
    GUI:setAnchorPoint(Button_close, 0, 1)
    GUI:addOnClickEvent(Button_close, function () GUI:Win_Close(parent) end)
end