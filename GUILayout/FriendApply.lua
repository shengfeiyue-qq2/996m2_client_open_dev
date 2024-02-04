FriendApply = {}

function FriendApply.main()
    local parent = GUI:Attach_Parent()
    if not parent then
        return
    end

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local mainPanel = GUI:Layout_Create(parent, "mainPanel", screenW/2, screenH/2, 546, 325)
    GUI:setAnchorPoint(mainPanel, 0.5, 0.5)

    local bg = GUI:Image_Create(mainPanel, "bg", 273, 162, "res/public/bg_npc_10.jpg")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:Image_setScale9Slice(bg, 15, 15, 15, 15)
    GUI:setContentSize(bg, 546, 325)

    local listBg = GUI:Image_Create(mainPanel, "listBg", 270, 162, "res/public/1900000668.png")
    GUI:setAnchorPoint(listBg, 0.5, 0.5)
    GUI:Image_setScale9Slice(listBg, 24, 24, 10, 10)
    GUI:setContentSize(listBg, 492, 226)

    -- 标题
    local titleImg = GUI:Image_Create(mainPanel, "titleImg", 273, 294, "res/private/friend/word_haoyou_06.png")
    GUI:setAnchorPoint(titleImg, 0.5, 0.5)

    local closeBtn = GUI:Button_Create(mainPanel, "closeBtn", 557, 304, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(closeBtn, "res/public/1900000511.png")
    GUI:setAnchorPoint(closeBtn, 0.5, 0.5)

    -- 列表
    local applyListView = GUI:ListView_Create(mainPanel, "applyListView", 26, 49, 490, 225, 1)
    GUI:ListView_setGravity(applyListView, 2)
    GUI:ListView_setClippingEnabled(applyListView, true)

    local closeTitleText = GUI:Text_Create(mainPanel, "closeTitleText", 445, 32, 16, "#28ef01", "关闭后信息将被清空")
    GUI:setAnchorPoint(closeTitleText, 0.5, 0.5)

    -- cell
    local customizeCell = GUI:Layout_Create(mainPanel, "customizeCell", 0, 0, 490, 58)
    
    -- 显示文字模板
    FriendApply.BaseStrFormat = "%s   请求添加您为好友!"
    local applyText = GUI:Text_Create(customizeCell, "applyText", 16, 29, 16, "#FFFFFF", "玩家名字   请求添加您为好友！")
    GUI:setAnchorPoint(applyText, 0, 0.5)

    local confirmBtn = GUI:Button_Create(customizeCell, "confirmBtn", 440, 28, "res/public/1900000679_1.png")
    GUI:setAnchorPoint(confirmBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(confirmBtn, "res/public/1900000679.png")
    GUI:Button_setTitleText(confirmBtn, "确定")
    SL:SetColorStyle(confirmBtn, 1022)

    local cancelBtn = GUI:Button_Create(customizeCell, "cancelBtn", 346, 28, "res/public/1900000679_1.png")
    GUI:setAnchorPoint(cancelBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(cancelBtn, "res/public/1900000679.png")
    GUI:Button_setTitleText(cancelBtn, "取消")
    SL:SetColorStyle(cancelBtn, 1022)

    local line = GUI:Image_Create(customizeCell, "line", 230, 1, "res/public/1900000667.png")
    GUI:setAnchorPoint(line, 0.5, 0.5)
    GUI:setContentSize(line, 523, 2)

end