
CommonTipsPop = {}

function CommonTipsPop.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local psize   = {w = 452, h = 179}

    -- 全屏
    local Layout = GUI:Layout_Create(parent, "Layout", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(Layout, true)

    local PMainUI = GUI:Layout_Create(parent, "PMainUI", screenW / 2, screenH / 2, psize.w, psize.h)
    GUI:Layout_setBackGroundImage(PMainUI, "res/public/1900000600.png")
    GUI:setTouchEnabled(PMainUI, true)
    GUI:setAnchorPoint(PMainUI, 0.5, 0.5)

    if SL:IsWinMode() then
        GUI:setMouseEnabled(PMainUI, true)
    end

    local DescList = GUI:ScrollView_Create(PMainUI, "DescList", 20, psize.h - 20, psize.w - 40, psize.h - 80, 1)
    GUI:setAnchorPoint(DescList, 0, 1)

    local tfSize =  {width = psize.w - 72, height = 31}
    local TextFieldBg = GUI:Image_Create(PMainUI, "TextFieldBg", psize.w / 2, psize.h / 2, "res/public/1900000668.png")
    GUI:setContentSize(TextFieldBg, tfSize)
    GUI:Image_setScale9Slice(TextFieldBg, 20, 20, 4, 4)
    GUI:setAnchorPoint(TextFieldBg, 0.5, 0.5)
    GUI:setVisible(TextFieldBg, false)

    local TextField = GUI:TextInput_Create(TextFieldBg, "TextField", tfSize.width / 2, tfSize.height / 2, tfSize.width - 6, tfSize.height - 6, 18)
    GUI:TextInput_getString(TextField, "")
    GUI:TextInput_setFontColor(TextField, "#FFFFFF")
    GUI:TextInput_setInputMode(TextField, 6)
    GUI:setAnchorPoint(TextField, 0.5, 0.5)

    local BtnCancel = GUI:Button_Create(PMainUI, "BtnCancel", 287, 40, "res/public/000365.png")
    GUI:Button_loadTexturePressed(BtnCancel, "res/public/000366.png")
    GUI:setAnchorPoint(BtnCancel, 0.5, 0.5)
    local BtnOk = GUI:Button_Create(PMainUI, "BtnOk", 387, 40, "res/public/000361.png")
    GUI:Button_loadTexturePressed(BtnOk, "res/public/000362.png")
    GUI:setAnchorPoint(BtnOk, 0.5, 0.5)

    local Btn_1 = GUI:Button_Create(PMainUI, "Btn_1", 287, 40, "res/public/1900001022.png")
    GUI:Button_loadTexturePressed(Btn_1, "res/public/1900001023.png")
    GUI:setAnchorPoint(Btn_1, 0.5, 0.5)
    GUI:Button_setTitleColor(Btn_1, "#FFFFFF")
    GUI:Button_setTitleFontSize(Btn_1, 16)
    local Btn_2 = GUI:Button_Create(PMainUI, "Btn_2", 387, 40, "res/public/1900001022.png")
    GUI:Button_loadTexturePressed(Btn_2, "res/public/1900001023.png")
    GUI:setAnchorPoint(Btn_2, 0.5, 0.5)
    GUI:Button_setTitleColor(Btn_2, "#FFFFFF")
    GUI:Button_setTitleFontSize(Btn_2, 16)
end