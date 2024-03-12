TreasureBox = {}

function TreasureBox.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, screenH/2, 250, 180)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)

    local Node_box_normal = GUI:Node_Create(PMainUI, "Node_box_normal", 125, 135)
    GUI:setAnchorPoint(Node_box_normal, 0.5, 0.5)

    local Node_box_open = GUI:Node_Create(PMainUI, "Node_box_open", 125, 265)
    GUI:setAnchorPoint(Node_box_open, 0.5, 0.5)

    local Node_open = GUI:Node_Create(PMainUI, "Node_open", 125, 265)
    GUI:setAnchorPoint(Node_open, 0.5, 0.5)

    local Panel_key = GUI:Layout_Create(PMainUI, "Panel_key", 130, 30, 60, 60)
    GUI:setTouchEnabled(Panel_key, true)

    local Text_tips = GUI:Text_Create(PMainUI, "Text_tips", 155, 55, 16, "#ffffff", "拖动钥匙\n到此开锁")
    GUI:setAnchorPoint(Text_tips, 0.5, 0.5)
    SL:SetColorStyle(Text_tips, 1006)

    local Panel_2 = GUI:Layout_Create(PMainUI, "Panel_2", 55, 6, 160, 130)
    GUI:setTouchEnabled(Panel_2, true)
    GUI:Win_SetDrag(parent, Panel_2)
    
    if SL:IsWinMode() then
        GUI:setMouseEnabled(Panel_2, true)
    end
end