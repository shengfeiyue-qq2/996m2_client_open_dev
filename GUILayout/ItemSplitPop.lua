ItemSplitPop = {}

function ItemSplitPop.main(itemData)
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local width  = 406
    local height = 266

    -- 全屏
    if not SL:IsWinMode() then
        local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)
        GUI:setTouchEnabled(Layout, true)
        GUI:addOnClickEvent(Layout, function () SL:CloseItemSplitPop() end)
    end

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, width, height)
    GUI:setAnchorPoint(PMainUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local Image_bg = GUI:Image_Create(PMainUI, "Image_bg", 0, 0, "res/public/bg_npc_08.jpg")

    -- 道具名
    local Text_name = GUI:Text_Create(PMainUI, "Text_name", width/2, height-40, 18, "#ffffff", "")
    GUI:setAnchorPoint(Text_name, {x=0.5, y=0.5})

    -- 道具底框
    local icon = GUI:ItemShow_Create(PMainUI, "icon", width/2, 175, {index = itemData.Index, itemData = itemData, bgVisible = true})
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    local Text_1 = GUI:Text_Create(PMainUI, "Text_1", 85, 105, 18, "#FFFFFF", "拆分数量: ")
    GUI:setAnchorPoint(Text_1, 0.5, 0.5)
    
    local Imagebg_1 = GUI:Image_Create(PMainUI, "Imagebg_1", 235, 105, "res/public/1900000668.png")
    GUI:setAnchorPoint(Imagebg_1, {x=0.5, y=0.5})
    GUI:setContentSize(Imagebg_1, {width = 100, height = 31})
    GUI:Image_setScale9Slice(Imagebg_1, 20, 20, 4, 4)
    
    local TextField = GUI:TextInput_Create(PMainUI, "TextField", 235, 105, 90, 20, 20)
    GUI:Text_setTextHorizontalAlignment(TextField, 1)
    GUI:setAnchorPoint(TextField, {x=0.5, y=0.5})
    GUI:TextInput_setInputMode(TextField, 2)

    -- btn sub
    local BtnSub = GUI:Button_Create(PMainUI, "BtnSub", 160, 105, "res/public/1900000620.png")
    GUI:Button_loadTexturePressed(BtnSub, "res/public/1900000620_1.png")
    GUI:setAnchorPoint(BtnSub, {x=0.5, y=0.5})

    -- btn add
    local BtnAdd = GUI:Button_Create(PMainUI, "BtnAdd", 310, 105, "res/public/1900000621.png")
    GUI:Button_loadTexturePressed(BtnAdd, "res/public/1900000621_1.png")
    GUI:setAnchorPoint(BtnAdd, {x=0.5, y=0.5})
    
    -- btn ok
    local BtnOk = GUI:Button_Create(PMainUI, "BtnOk", width/2, 50, "res/public/1900000662.png")
    GUI:Button_loadTexturePressed(BtnOk, "res/public/1900000663.png")
    GUI:setAnchorPoint(BtnOk, 0.5, 0.5)
    GUI:Button_setTitleFontSize(BtnOk, 18)
    GUI:Button_setTitleColor(BtnOk, "#FFFFFF")
    GUI:Button_setTitleText(BtnOk, "拆分")
    GUI:addOnClickEvent(BtnOk, function () GUI:Win_Close(parent) end)
end