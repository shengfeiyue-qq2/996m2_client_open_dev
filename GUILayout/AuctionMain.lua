AuctionMain = {}

function AuctionMain.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local layoutW = GUIShare.WinView.LayWidth
    local layoutH = GUIShare.WinView.LayHeight
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    -- 全屏关闭
    if not SL:IsWinMode() then
        local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)
        GUI:Layout_setBackGroundColorType(CloseLayout, 1)
        GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
        GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
        GUI:setTouchEnabled(CloseLayout, true)
        GUI:addOnClickEvent(CloseLayout, function() GUI:Win_Close(parent) end)
    end

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, layoutW, layoutH)
    GUI:setAnchorPoint(PMainUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 780, 492, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function() GUI:Win_Close(parent) end)

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0, 0, "res/public/1900000610.png")

    -- 龙头
    local DressIMG = GUI:Image_Create(PMainUI, "DressIMG", -14, 474, "res/public/1900000610_1.png")

    -- 标题
    local TitleText = GUI:Text_Create(PMainUI, "TitleText", 32, 498, 18, "#ffffff", "拍卖行")

    -- 内容挂接点
    local AttachLayout = GUI:Layout_Create(PMainUI, "AttachLayout", GUIShare.WinView.HookX, GUIShare.WinView.HookY, attachW, attachH)

    local posX = 85
    local distance = 105

    if SL:GetMetaValue("GAME_DATA", "isHideAuctionGuild") then
        local Button1 = AuctionMain.createButton(PMainUI, 1, posX, 465)
        GUI:Button_setTitleText(Button1, "世界拍卖")
    
        posX = posX + distance
        local Button3 = AuctionMain.createButton(PMainUI, 3, posX, 465)
        GUI:Button_setTitleText(Button3, "我的竞拍")
    
        posX = posX + distance
        local Button4 = AuctionMain.createButton(PMainUI, 4, posX, 465)
        GUI:Button_setTitleText(Button4, "我的上架")
    else
        local Button1 = AuctionMain.createButton(PMainUI, 1, posX, 465)
        GUI:Button_setTitleText(Button1, "世界拍卖")
    
        posX = posX + distance
        local Button2 = AuctionMain.createButton(PMainUI, 2, posX, 465)
        GUI:Button_setTitleText(Button2, "行会拍卖")
    
        posX = posX + distance
        local Button3 = AuctionMain.createButton(PMainUI, 3, posX, 465)
        GUI:Button_setTitleText(Button3, "我的竞拍")
    
        posX = posX + distance
        local Button4 = AuctionMain.createButton(PMainUI, 4, posX, 465)
        GUI:Button_setTitleText(Button4, "我的上架")
    end


    -- 搜索框
    local PanelSearch = GUI:Layout_Create(PMainUI, "PanelSearch", 500, 447.5, 220, 35)
    local Image_1 = GUI:Image_Create(PanelSearch, "Image_1", 20, 17.5, "res/public/btn_szjm_02.png")
    GUI:setAnchorPoint(Image_1, 0.5, 0.5)

    local SearchInputBg = GUI:Image_Create(PanelSearch, "SearchInputBg", 38, 17.5, "res/public/1900015004.png")
    GUI:setContentSize(SearchInputBg, {width = 124, height = 24})
    GUI:Button_setScale9Slice(SearchInputBg, 10, 10, 10, 10)
    GUI:setAnchorPoint(SearchInputBg, 0, 0.5)

    local SearchInput = GUI:TextInput_Create(PanelSearch, "SearchInput", 42, 19, 120, 20, 14)
    GUI:Text_setTextHorizontalAlignment(SearchInput, 0) 
    GUI:TextInput_setInputMode(SearchInput, 0)
    GUI:setTouchEnabled(SearchInput, true)
    GUI:TextInput_setString(SearchInput, "请输入物品名")
    GUI:TextInput_setFontColor(SearchInput, "#FFFFFF")
    GUI:setAnchorPoint(SearchInput, 0, 0.5)

    local BtnOk = GUI:Button_Create(PanelSearch, "BtnOk", 200, 17.5, "res/public/btn_fanye_03.png")
    GUI:Button_loadTexturePressed(BtnOk, "res/public/btn_fanye_03_1.png")
    GUI:setAnchorPoint(BtnOk, 0.5, 0.5)
    GUI:Button_setTitleFontSize(BtnOk, 18)
    GUI:Button_setTitleColor(BtnOk, "#FFFFFF")
    GUI:Button_setTitleText(BtnOk, "确定")
end

function AuctionMain.createButton(parent, i, x, y)
    local Button = GUI:Button_Create(parent, "Button"..i, x, y, "res/public/1900000680_1.png")
    GUI:Button_loadTextureDisabled(Button, "res/public/1900000680.png")
    GUI:Button_loadTexturePressed(Button, "res/public/1900000680.png")
    GUI:addOnClickEvent(Button, function ()
        AuctionMain.OnSelectGroup(i)
    end)
    GUI:setAnchorPoint(Button, 0.5, 0.5)
    GUI:Button_setTitleFontSize(Button, 18)
    GUI:Button_setTitleColor(Button, "#FFFFFF")
    
    -- 红点
    local targetNode = GUI:Node_Create(Button, "Node_redtips", 95, 27)
    SL:CreateRedPoint(targetNode)
    GUI:setVisible(targetNode, false)
    
    return Button
end