StoreFrame = {}

function StoreFrame.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local pWidth  = 873
    local pHeight = 555

    -- 全屏
    if not SL:IsWinMode() then
        local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)
        GUI:setTouchEnabled(Layout, true)
        GUI:addOnClickEvent(Layout, function() SL:CloseStoreUI() end)
    end

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, pWidth, pHeight)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)

    -- 标题
    -- local TitleText = GUI:Text_Create(PMainUI, "TitleText", 32, 498, 18, "#ffffff", "")
    -- GUI:setVisible(TitleText, false)

    -- 背景图
    local pBg = GUI:Image_Create(PMainUI, "pBg", pWidth/2, pHeight/2, "res/public/1900000672.png")
    GUI:setAnchorPoint(pBg, 0.5, 0.5)
    GUI:Win_SetDrag(parent, pBg)
    if SL:IsWinMode() then
        GUI:setMouseEnabled(pBg, true)
    end

    local Image_title = GUI:Image_Create(PMainUI, "Image_title", pWidth/2, pHeight-50, "res/private/store_ui/word_scbtt.png")
    GUI:setAnchorPoint(Image_title, 0.5, 0.5)

    -- 关闭按钮
    local Button_close = GUI:Button_Create(PMainUI, "Button_close", 828, 435, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
    GUI:setAnchorPoint(Button_close, 0.5, 0.5)
    GUI:addOnClickEvent(Button_close, function () GUI:Win_Close(parent) end)

    local PageNames = {
        [1] = "灵\n符", [2] = "元\n宝", [3] = "技\n能", [4] = "货\n币", [5] = "充\n值"}
    local posY = 320
    local distance = 75

    for i=1,5 do
        local Page = GUI:Button_Create(PMainUI, "Page"..i, 845, posY, "res/public/1900000641.png")
        GUI:Button_loadTextureDisabled(Page, "res/public/1900000640.png")
        GUI:Button_loadTexturePressed(Page, "res/public/1900000640.png")
        GUI:addOnClickEvent(Page, function() StoreFrame.PageTo(i)
        end)
        local Text = GUI:Text_Create(Page, "Text", 15, 60, 16, "#ffffff", PageNames[i])
        GUI:setAnchorPoint(Text, 0.5, 0.5)

        posY = posY - distance
    end
    
    -- 内容挂接点
    local AttachLayout = GUI:Layout_Create(PMainUI, "AttachLayout", 70, 30, GUIShare.WinView.Width, GUIShare.WinView.Height)
end