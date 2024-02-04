
CommonBubbleInfo = {}

function CommonBubbleInfo.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 全屏
    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(PMainUI, true)

    -- bg
    local ListViewBg = GUI:Layout_Create(PMainUI, "ListViewBg", 408, 250, 320, 158)
    GUI:Layout_setBackGroundImage(ListViewBg, "res/private/item_tips/btn_tipszy_01.png")
    GUI:Layout_setBackGroundImageScale9Slice(ListViewBg, 35, 35, 4, 4)
    GUI:setTouchEnabled(ListViewBg, true)
    GUI:setAnchorPoint(ListViewBg, 0, 0)

    -- ListView
    local ListView = GUI:ListView_Create(ListViewBg, "ListView", 0, 158, 320, 158, 1)
    GUI:setAnchorPoint(ListView, 0, 1)

    -- ListView Cell
    local LCell = GUI:Layout_Create(PMainUI, "LCell", 0, 0, 320, 52, true)
    GUI:setTouchEnabled(LCell, true)
    GUI:setVisible(LCell, false)

    local Line = GUI:Image_Create(LCell, "Line", 160, 26, "res/public/1900000667.png")
    GUI:setAnchorPoint(Line, 0.5, 0.5)

    local TextInfo = GUI:Text_Create(LCell, "TextInfo", 10, 26, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(TextInfo, 0, 0.5)
    
    local BtnDisAgree = GUI:Button_Create(LCell, "BtnDisAgree", 260, 26, "res/public/btn_quxiao_01.png")
    GUI:Button_loadTexturePressed(BtnDisAgree, "res/public/btn_quxiao_02.png")
    GUI:setAnchorPoint(BtnDisAgree, 0.5, 0.5)

    local BtnAgree = GUI:Button_Create(LCell, "BtnAgree", 300, 26, "res/public/btn_queding_01.png")
    GUI:Button_loadTexturePressed(BtnAgree, "res/public/btn_queding_02.png")
    GUI:setAnchorPoint(BtnAgree, 0.5, 0.5)
end