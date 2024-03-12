MiniMapFrame = {}

function MiniMapFrame.main()
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
    local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", screenW/2, screenH/2, layoutW, layoutH)
    GUI:setAnchorPoint(FrameLayout, {x=0.5, y=0.5})
    GUI:setTouchEnabled(FrameLayout, true)
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, FrameLayout)
        GUI:setMouseEnabled(FrameLayout, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0, 0, "res/public/1900000610.png")

    -- 龙头
    local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", -14, 474, "res/public/1900000610_1.png")

    -- 标题
    local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 32, 498, 18, "#ffffff", "地图")

    -- 内容挂接点
    local AttachLayout = GUI:Layout_Create(FrameLayout, "AttachLayout", GUIShare.WinView.HookX, GUIShare.WinView.HookY, attachW, attachH)

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 780, 492, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function()
        GUI:Win_Close(parent)
    end)
end