GameWorldConfirm = {}

function GameWorldConfirm.main()
    local parent = GUI:Attach_Parent()

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 屏蔽触摸
    local TouchLayout = GUI:Layout_Create(parent, "TouchLayout", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(TouchLayout, true)
    
    -- 背景图
    local ConfirmBG = GUI:Image_Create(parent, "ConfirmBG", screenW/2, screenH/2, "res/private/announce/000030.png")
    GUI:setAnchorPoint(ConfirmBG, {x=0.5, y=0.5})
    local BGSize = GUI:getContentSize(ConfirmBG)

    -- 放内容的容器
    local ContentLayout = GUI:Layout_Create(ConfirmBG, "ContentLayout", BGSize.width/2, BGSize.height-40, 300, BGSize.height-60)
    GUI:setAnchorPoint(ContentLayout, {x=0.5, y=1})
    
    -- 确认按钮
    local ConfirmButton = GUI:Button_Create(ConfirmBG, "ConfirmButton", BGSize.width/2, 60, "res/private/announce/00000361.png")
    GUI:Button_loadTexturePressed(ConfirmButton, "res/private/announce/00000362.png")
    GUI:setAnchorPoint(ConfirmButton, {x=0.5, y=0.5})
    GUI:setTouchEnabled(ConfirmButton, true)

    -- 倒计时
    local RemainingText = GUI:Text_Create(ConfirmBG, "RemainingText", BGSize.width/2 + 60, 60, 18, "#ffffff", "(3)")
    GUI:setAnchorPoint(RemainingText, {x=0, y=0.5})
end