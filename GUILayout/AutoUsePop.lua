AutoUsePop = {}

function AutoUsePop.main()
    local parent = GUI:Attach_Parent()
    local width  = 171
    local height = 186

    local Node = GUI:Node_Create(parent, "Node", 785, 140)
    GUI:setAnchorPoint(Node, 0.5, 0.5)

    local PPopUI = GUI:Layout_Create(parent, "PPopUI", 0, 0, width, height)
    GUI:setVisible(PPopUI, false)
    GUI:setTouchEnabled(PPopUI, true)
    
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PPopUI)
        GUI:setMouseEnabled(PPopUI, true)
    end

    local pBg = GUI:Image_Create(PPopUI, "pBg", 0, 0, "res/public/bg_hhdb_02.jpg")

    local TextTitle = GUI:Text_Create(PPopUI, "TextTitle", 72.5, 164, 18, "#FFFFFF", "快捷使用")
    GUI:setAnchorPoint(TextTitle, 0.5, 0.5)

    local ItemBg = GUI:Image_Create(PPopUI, "ItemBg", 72.5, 112, "res/public/1900000651.png")
    GUI:setAnchorPoint(ItemBg, 0.5, 0.5)

    local ItemNode = GUI:Layout_Create(PPopUI, "ItemNode",72.5, 112, 0, 0)
    GUI:setAnchorPoint(ItemNode, 0.5, 0.5)

    local TextName = GUI:Text_Create(PPopUI, "TextName", 72.5, 68, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(TextName, 0.5, 0.5)

    local TextTime = GUI:Text_Create(PPopUI, "TextTime", 123, 35, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(TextTime, 0.5, 0.5)

    local BtnUse = GUI:Button_Create(PPopUI, "BtnUse", 72.5, 35, "res/public/1900000679.png")
    GUI:Button_loadTexturePressed(BtnUse, "res/public/1900000679_1.png")
    GUI:setAnchorPoint(BtnUse, 0.5, 0.5)
    GUI:Button_setTitleFontSize(BtnUse, 16)
    GUI:Button_setTitleText(BtnUse, "使用")
    GUI:Button_setTitleColor(BtnUse, "#f8e6c6")
    
    -- 关闭按钮
    local BtnClose = GUI:Button_Create(PPopUI, "BtnClose", 145, 145, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(BtnClose, "res/public/1900000511.png")
end