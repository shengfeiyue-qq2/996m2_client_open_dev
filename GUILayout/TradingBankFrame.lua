TradingBankFrame = {}

-- 侧边页签按钮坐标（从上到下）
TradingBankFrame.btnPos = {
    [1] = {x = 780, y = 380},
    [2] = {x = 780, y = 305},
    [3] = {x = 780, y = 230},
    [4] = {x = 780, y = 155}
}

function TradingBankFrame.main()
    local parent = GUI:Attach_Parent()

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
        GUI:addOnClickEvent(CloseLayout, function()
            GUI:Win_Close(parent)
        end)
    end

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, layoutW, layoutH)
    GUI:setAnchorPoint(PMainUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(PMainUI, "FrameBG", 0, 0, "res/public/1900000610.png")

    -- 龙头
    local DressIMG = GUI:Image_Create(PMainUI, "DressIMG", -14, 474, "res/public/1900000610_1.png")

    -- 标题
    local TitleText = GUI:Text_Create(PMainUI, "TitleText", 32, 498, 18, "#ffffff", "")

    -- 内容
    local AttachLayout = GUI:Layout_Create(PMainUI, "AttachLayout", GUIShare.WinView.HookX, GUIShare.WinView.HookY, attachW, attachH) 

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(PMainUI, "CloseButton", 780, 492, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function()
        GUI:Win_Close(parent)
    end)
end