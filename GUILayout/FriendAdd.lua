FriendAdd = {}

function FriendAdd.main()
    local parent = GUI:Attach_Parent()
    if not parent then
        return
    end

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local mainPanel = GUI:Layout_Create(parent, "mainPanel", screenW/2, screenH/2, 331, 145)
    GUI:setAnchorPoint(mainPanel, 0.5, 0.5)

    -- 背景
    local bgImg = GUI:Image_Create(mainPanel, "bgImg", 0, 0, "res/public/1900000650.png")

    -- 标题
    local titleText = GUI:Text_Create(mainPanel, "titleText", 160, 120, 18, "#FFFFFF", "添加好友")
    GUI:setAnchorPoint(titleText, 0.5, 0.5)

    -- 搜索
    local searchText = GUI:Text_Create(mainPanel, "searchText", 62, 90, 16, "#FFFFFF", "好友搜索")
    GUI:setAnchorPoint(searchText, 0.5, 0.5)

    local searchBg = GUI:Image_Create(mainPanel, "searchBg", 196, 88, "res/public/1900000668.png")
    GUI:setAnchorPoint(searchBg, 0.5, 0.5)
    GUI:Image_setScale9Slice(searchBg, 51, 51, 10, 10)
    GUI:setContentSize(searchBg, 180, 31)

    -- 输入框
    local searchTextInput = GUI:TextInput_Create(searchBg, "searchTextInput", 90, 15, 170, 26, 18)
    GUI:setAnchorPoint(searchTextInput, 0.5, 0.5)
    GUI:TextInput_setPlaceHolder(searchTextInput, "输入好友ID或者昵称")
    GUI:TextInput_setMaxLength(searchTextInput, 10)
    GUI:TextInput_setFontColor(searchTextInput, "#FFFFFF")

    local cancelBtn = GUI:Button_Create(mainPanel, "cancelBtn", 80, 38, "res/public/1900000679_1.png")
    GUI:setAnchorPoint(cancelBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(cancelBtn, "res/public/1900000679.png")
    GUI:Button_setTitleText(cancelBtn, "取消")
    SL:SetColorStyle(cancelBtn, 1022)

    local confirmBtn = GUI:Button_Create(mainPanel, "confirmBtn", 251, 38, "res/public/1900000679_1.png")
    GUI:setAnchorPoint(confirmBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(confirmBtn, "res/public/1900000679.png")
    GUI:Button_setTitleText(confirmBtn, "加为好友")
    SL:SetColorStyle(confirmBtn, 1022)

    local closeBtn = GUI:Button_Create(mainPanel, "closeBtn", 345, 123, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(closeBtn, "res/public/1900000511.png")
    GUI:setAnchorPoint(closeBtn, 0.5, 0.5)

end