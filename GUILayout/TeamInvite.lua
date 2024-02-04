TeamInvite = {}

TeamInvite.Btn_SelectColorID = 1025
TeamInvite.Btn_NormalColorID = 1026 

function TeamInvite.main()
    local parent = GUI:Attach_Parent()
    if not parent then
        return
    end

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local blackLayout = GUI:Layout_Create(parent, 0, 0, screenW, screenH)

    local bgPanel = GUI:Layout_Create(parent, "bgPanel", screenW/2, screenH/2, 680, 400)
    GUI:setAnchorPoint(bgPanel, 0.5, 0.5)

    if SL:IsWinMode() then
        GUI:setTouchEnabled(bgPanel, true)
        GUI:Win_SetDrag(parent, bgPanel)
        GUI:setMouseEnabled(bgPanel, true)
    end

    GUI:Layout_setBackGroundImage(bgPanel, "res/public/1900000675.jpg")

    local innerBg = GUI:Image_Create(bgPanel, "innerBg", 395, 190, "res/private/team/1900014007.png")
    GUI:setAnchorPoint(innerBg, 0.5, 0.5)

    local closeBtn = GUI:Button_Create(bgPanel, "closeBtn", 692, 378, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(closeBtn, "res/public/1900000511.png")
    GUI:setAnchorPoint(closeBtn, 0.5, 0.5)

    -- 分页按钮
    -- 附近
    local nearBtn = GUI:Button_Create(bgPanel, "nearBtn", 80, 335, "res/public/1900000663.png")
    GUI:Button_loadTexturePressed(nearBtn, "res/public/1900000662.png")
    GUI:setAnchorPoint(nearBtn, 0.5, 0.5)
    SL:SetColorStyle(nearBtn, TeamInvite.Btn_SelectColorID)
    GUI:Button_setTitleText(nearBtn, "附近")

    -- 好友
    local friendBtn = GUI:Button_Create(bgPanel, "friendBtn", 80, 295, "res/public/1900000663.png")
    GUI:Button_loadTexturePressed(friendBtn, "res/public/1900000662.png")
    GUI:setAnchorPoint(friendBtn, 0.5, 0.5)
    SL:SetColorStyle(friendBtn, TeamInvite.Btn_SelectColorID)
    GUI:Button_setTitleText(friendBtn, "好友")

    -- 行会
    local guildBtn = GUI:Button_Create(bgPanel, "guildBtn", 80, 255, "res/public/1900000663.png")
    GUI:Button_loadTexturePressed(guildBtn, "res/public/1900000662.png")
    GUI:setAnchorPoint(guildBtn, 0.5, 0.5)
    SL:SetColorStyle(guildBtn, TeamInvite.Btn_SelectColorID)
    GUI:Button_setTitleText(guildBtn, "行会")

    -- 输入名字
    local nameBtn = GUI:Button_Create(bgPanel, "nameBtn", 80, 215, "res/public/1900000663.png")
    GUI:Button_loadTexturePressed(nameBtn, "res/public/1900000662.png")
    GUI:setAnchorPoint(nameBtn, 0.5, 0.5)
    SL:SetColorStyle(nameBtn, TeamInvite.Btn_NormalColorID)
    GUI:Button_setTitleText(nameBtn, "输入名字")

    local titleImg = GUI:Image_Create(bgPanel, "titleImg", 340, 369, "res/private/team/1900014005.png")
    GUI:setAnchorPoint(titleImg, 0.5, 0.5)

    local nameText = GUI:Text_Create(bgPanel, "bgPanel", 210, 339, 16, "#ffffff", "名字")
    GUI:setAnchorPoint(nameText, 0.5, 0.5)

    local guildText = GUI:Text_Create(bgPanel, "guildText", 340, 339, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guildText, 0.5, 0.5)

    local levelText = GUI:Text_Create(bgPanel, "levelText", 480, 339, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelText, 0.5, 0.5)

    local operationText = GUI:Text_Create(bgPanel, "operationText", 600, 339, 16, "#ffffff", "操作")
    GUI:setAnchorPoint(operationText, 0.5, 0.5)

    -- 单条成员信息
    local memberCell = GUI:Layout_Create(bgPanel, "memberCell", 143, 285, 504, 40)
    
    local cellBg = GUI:Image_Create(memberCell, "cellBg", 252, 20, "res/private/team/1900014007_1.png")
    GUI:setAnchorPoint(cellBg, 0.5, 0.5)

    local nameLabel = GUI:Text_Create(memberCell, "nameLabel", 68, 20, 16, "#ffffff", "玩家名字七个字")
    GUI:setAnchorPoint(nameLabel, 0.5, 0.5)

    local guildLabel = GUI:Text_Create(memberCell, "guildLabel", 200, 20, 16, "#ffffff", "行会名字七个字")
    GUI:setAnchorPoint(guildLabel, 0.5, 0.5)

    local levelLabel = GUI:Text_Create(memberCell, "levelLabel", 340, 20, 16, "#ffffff", "")
    GUI:setAnchorPoint(levelLabel, 0.5, 0.5)

    local operationBtn = GUI:Button_Create(memberCell, "operationBtn", 458, 20, "res/public/1900000679.png")
    GUI:setAnchorPoint(operationBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(operationBtn, "res/public/1900000679_1.png")
    SL:SetColorStyle(operationBtn, 1020)
    GUI:Button_setTitleText(operationBtn, "邀请")

    local operationLabel = GUI:Text_Create(memberCell, "operationLabel", 458, 20, 16, "#f8e6c6", "已邀请")
    GUI:setAnchorPoint(operationLabel, 0.5, 0.5)

    -- 列表
    local memberListView = GUI:ListView_Create(bgPanel, "memberListView", 143, 33, 504, 290, 1)
    GUI:ListView_setClippingEnabled(memberListView, true)
end