GoldBox = {}

function GoldBox.main( )
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local pSize = {w = 365, h = 375}

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)

    -- 容器
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW/2, 400, pSize.w, pSize.h)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)
    GUI:setTouchEnabled(PMainUI, true)
    GUI:Win_SetDrag(parent, PMainUI)
    
    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    local ImageBg = GUI:Image_Create(PMainUI, "ImageBg", pSize.w / 2, pSize.h / 2, "res/private/treasure_box/000510.png")
    GUI:setAnchorPoint(ImageBg, 0.5, 0.5)

    -- 关闭按钮
    local BtnClose = GUI:Button_Create(PMainUI, "BtnClose", 295, 268, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(BtnClose, "res/public/1900000511.png")
    GUI:setAnchorPoint(BtnClose, {x=0.5, y=0.5})

    -- 开启按钮
    local BtnOpen = GUI:Button_Create(PMainUI, "BtnOpen", pSize.w / 2, 65, "res/public/1900000611.png")
    GUI:setAnchorPoint(BtnOpen, 0.5, 0.5)
    GUI:Button_setTitleText(BtnOpen, "摇一摇")
    SL:SetColorStyle(BtnOpen, 1022)

    ------------------------------格子------------------------------------------------------

    -- 中间
    local PanelGrid = GUI:Layout_Create(PMainUI, "PanelGrid", pSize.w / 2, pSize.h / 2 + 7, 0, 0)
    GUI:setAnchorPoint(PanelGrid, 0.5, 0.5)
    local IconBg_0 = GUI:Image_Create(PanelGrid, "IconBg_0", 0, 0, "res/private/treasure_box/000513.png")
    GUI:setAnchorPoint(IconBg_0, 0.5, 0.5)
    local IconNode_0 = GUI:Node_Create(PanelGrid, "IconNode_0", 0, 0)
    GUI:setAnchorPoint(IconNode_0, 0.5, 0.5)
    local IconAnim_0 = GUI:Node_Create(PanelGrid, "IconAnim_0", 0, 0)
    GUI:setAnchorPoint(IconAnim_0, 0.5, 0.5)
    local Ptouch_0 = GUI:Layout_Create(PanelGrid, "Ptouch_0", 0, 0, 52, 48)
    GUI:setTouchEnabled(Ptouch_0, true)
    GUI:setAnchorPoint(Ptouch_0, 0.5, 0.5)

    -- 1~8：左上角顺时针
    local IconBg_1 = GUI:Image_Create(PanelGrid, "IconBg_1", -55, 50, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_1, 0.5, 0.5)
    local IconNode_1 = GUI:Node_Create(PanelGrid, "IconNode_1", -55, 50)
    GUI:setAnchorPoint(IconNode_1, 0.5, 0.5)
    local IconAnim_1 = GUI:Node_Create(PanelGrid, "IconAnim_1", -55, 50)
    GUI:setAnchorPoint(IconAnim_1, 0.5, 0.5)
    local Ptouch_1 = GUI:Layout_Create(PanelGrid, "Ptouch_1", -55, 50, 40, 37)
    GUI:setTouchEnabled(Ptouch_1, true)
    GUI:setAnchorPoint(Ptouch_1, 0.5, 0.5)

    local IconBg_2 = GUI:Image_Create(PanelGrid, "IconBg_2", 0, 50, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_2, 0.5, 0.5)
    local IconNode_2 = GUI:Node_Create(PanelGrid, "IconNode_2", 0, 50)
    GUI:setAnchorPoint(IconNode_2, 0.5, 0.5)
    local IconAnim_2 = GUI:Node_Create(PanelGrid, "IconAnim_2", 0, 50)
    GUI:setAnchorPoint(IconAnim_2, 0.5, 0.5)
    local Ptouch_2 = GUI:Layout_Create(PanelGrid, "Ptouch_2", 0, 50, 40, 37)
    GUI:setTouchEnabled(Ptouch_2, true)
    GUI:setAnchorPoint(Ptouch_2, 0.5, 0.5)

    local IconBg_3 = GUI:Image_Create(PanelGrid, "IconBg_3", 55, 50, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_3, 0.5, 0.5)
    local IconNode_3 = GUI:Node_Create(PanelGrid, "IconNode_3", 55, 50)
    GUI:setAnchorPoint(IconNode_3, 0.5, 0.5)
    local IconAnim_3 = GUI:Node_Create(PanelGrid, "IconAnim_3", 55, 50)
    GUI:setAnchorPoint(IconAnim_3, 0.5, 0.5)
    local Ptouch_3 = GUI:Layout_Create(PanelGrid, "Ptouch_3", 55, 50, 40, 37)
    GUI:setTouchEnabled(Ptouch_3, true)
    GUI:setAnchorPoint(Ptouch_3, 0.5, 0.5)

    local IconBg_4 = GUI:Image_Create(PanelGrid, "IconBg_4", 55, 0, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_4, 0.5, 0.5)
    local IconNode_4 = GUI:Node_Create(PanelGrid, "IconNode_4", 55, 0)
    GUI:setAnchorPoint(IconNode_4, 0.5, 0.5)
    local IconAnim_4 = GUI:Node_Create(PanelGrid, "IconAnim_4", 55, 0)
    GUI:setAnchorPoint(IconAnim_4, 0.5, 0.5)
    local Ptouch_4 = GUI:Layout_Create(PanelGrid, "Ptouch_4", 55, 0, 40, 37)
    GUI:setTouchEnabled(Ptouch_4, true)
    GUI:setAnchorPoint(Ptouch_4, 0.5, 0.5)

    local IconBg_5 = GUI:Image_Create(PanelGrid, "IconBg_5", 55, -50, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_5, 0.5, 0.5)
    local IconNode_5 = GUI:Node_Create(PanelGrid, "IconNode_5", 55, -50)
    GUI:setAnchorPoint(IconNode_5, 0.5, 0.5)
    local IconAnim_5 = GUI:Node_Create(PanelGrid, "IconAnim_5", 55, -50)
    GUI:setAnchorPoint(IconAnim_5, 0.5, 0.5)
    local Ptouch_5 = GUI:Layout_Create(PanelGrid, "Ptouch_5", 55, -50, 40, 37)
    GUI:setTouchEnabled(Ptouch_5, true)
    GUI:setAnchorPoint(Ptouch_5, 0.5, 0.5)

    local IconBg_6 = GUI:Image_Create(PanelGrid, "IconBg_6", 0, -50, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_6, 0.5, 0.5)
    local IconNode_6 = GUI:Node_Create(PanelGrid, "IconNode_6", 0, -50)
    GUI:setAnchorPoint(IconNode_6, 0.5, 0.5)
    local IconAnim_6 = GUI:Node_Create(PanelGrid, "IconAnim_6", 0, -50)
    GUI:setAnchorPoint(IconAnim_6, 0.5, 0.5)
    local Ptouch_6 = GUI:Layout_Create(PanelGrid, "Ptouch_6", 0, -50, 40, 37)
    GUI:setTouchEnabled(Ptouch_6, true)
    GUI:setAnchorPoint(Ptouch_6, 0.5, 0.5)

    local IconBg_7 = GUI:Image_Create(PanelGrid, "IconBg_7", -55, -50, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_7, 0.5, 0.5)
    local IconNode_7 = GUI:Node_Create(PanelGrid, "IconNode_7", -55, -50)
    GUI:setAnchorPoint(IconNode_7, 0.5, 0.5)
    local IconAnim_7 = GUI:Node_Create(PanelGrid, "IconAnim_7", -55, -50)
    GUI:setAnchorPoint(IconAnim_7, 0.5, 0.5)
    local Ptouch_7 = GUI:Layout_Create(PanelGrid, "Ptouch_7", -55, -50, 40, 37)
    GUI:setTouchEnabled(Ptouch_7, true)
    GUI:setAnchorPoint(Ptouch_7, 0.5, 0.5)

    local IconBg_8 = GUI:Image_Create(PanelGrid, "IconBg_8", -55, 0, "res/private/treasure_box/000514.png")
    GUI:setAnchorPoint(IconBg_8, 0.5, 0.5)
    local IconNode_8 = GUI:Node_Create(PanelGrid, "IconNode_8", -55, 0)
    GUI:setAnchorPoint(IconNode_8, 0.5, 0.5)
    local IconAnim_8 = GUI:Node_Create(PanelGrid, "IconAnim_8", -55, 0)
    GUI:setAnchorPoint(IconAnim_8, 0.5, 0.5)
    local Ptouch_8 = GUI:Layout_Create(PanelGrid, "Ptouch_8", -55, 0, 40, 37)
    GUI:setTouchEnabled(Ptouch_8, true)
    GUI:setAnchorPoint(Ptouch_8, 0.5, 0.5)
end