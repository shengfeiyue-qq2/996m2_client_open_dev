TeamBeInvitedPop = {}

function TeamBeInvitedPop.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local pWidth  = 331
    local pHeight = 145

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, pWidth, pHeight)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end

    -- 背景图
    local pBg = GUI:Image_Create(PMainUI, "pBg", pWidth/2, pHeight/2, "res/public/1900000650.png")
    GUI:setAnchorPoint(pBg, 0.5, 0.5)

    local ImageTitle = GUI:Image_Create(PMainUI, "ImageTitle", pWidth/2, 115, "res/private/team/1900014002.png")
    GUI:setAnchorPoint(ImageTitle, 0.5, 0.5)

    -- 标题
    local TextInfo = GUI:Text_Create(PMainUI, "TextInfo", pWidth/2, 85, 16, "#ffffff", "Text")
    GUI:setAnchorPoint(TextInfo, {x=0.5, y=0.5})

    local BtnAgree = GUI:Button_Create(PMainUI, "BtnAgree", 90, 30, "res/public/1900000653.png")
    GUI:Button_loadTexturePressed(BtnAgree, "res/public/1900000661.png")
    GUI:setAnchorPoint(BtnAgree, {x=0.5, y=0.5})
    GUI:Button_setTitleFontSize(BtnAgree, 16)
    GUI:Button_setTitleColor(BtnAgree, "#FFFFFF")
    GUI:Button_setTitleText(BtnAgree, "同意")

    local BtnDisAgree = GUI:Button_Create(PMainUI, "BtnDisAgree", 240, 30, "res/public/1900000653.png")
    GUI:Button_loadTexturePressed(BtnDisAgree, "res/public/1900000661.png")
    GUI:setAnchorPoint(BtnDisAgree, {x=0.5, y=0.5})
    GUI:Button_setTitleFontSize(BtnDisAgree, 16)
    GUI:Button_setTitleColor(BtnDisAgree, "#FFFFFF")
    GUI:Button_setTitleText(BtnDisAgree, "拒绝")

    -- 关闭按钮
    local BtnClose = GUI:Button_Create(PMainUI, "BtnClose", pWidth, pHeight, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(BtnClose, "res/public/1900000511.png")
    GUI:setAnchorPoint(BtnClose, 0, 1)
end