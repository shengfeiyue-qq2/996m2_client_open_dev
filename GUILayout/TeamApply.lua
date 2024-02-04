TeamApply = {}

function TeamApply.main()
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

    local innerBg = GUI:Image_Create(bgPanel, "innerBg", 340, 195, "res/private/team/1900014004.png")
    GUI:setAnchorPoint(innerBg, 0.5, 0.5)

    local closeBtn = GUI:Button_Create(bgPanel, "closeBtn", 692, 378, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(closeBtn, "res/public/1900000511.png")
    GUI:setAnchorPoint(closeBtn, 0.5, 0.5)

    local titleImg = GUI:Image_Create(bgPanel, "titleImg", 340, 369, "res/private/team/1900014002.png")
    GUI:setAnchorPoint(titleImg, 0.5, 0.5)

    local nameText = GUI:Text_Create(bgPanel, "bgPanel", 108, 339, 16, "#ffffff", "名字")
    GUI:setAnchorPoint(nameText, 0.5, 0.5)

    local guildText = GUI:Text_Create(bgPanel, "guildText", 242, 339, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guildText, 0.5, 0.5)

    local levelText = GUI:Text_Create(bgPanel, "levelText", 378, 339, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelText, 0.5, 0.5)

    local operationText = GUI:Text_Create(bgPanel, "operationText", 543, 339, 16, "#ffffff", "操作")
    GUI:setAnchorPoint(operationText, 0.5, 0.5)

    -- 单条成员信息
    local memberCell = GUI:Layout_Create(bgPanel, "memberCell", 40, 285, 600, 40)
    
    local cellBg = GUI:Image_Create(memberCell, "cellBg", 300, 20, "res/private/team/1900014004_1.png")
    GUI:setAnchorPoint(cellBg, 0.5, 0.5)

    local nameLabel = GUI:Text_Create(memberCell, "nameLabel", 68, 20, 16, "#ffffff", "玩家名字七个字")
    GUI:setAnchorPoint(nameLabel, 0.5, 0.5)

    local guildLabel = GUI:Text_Create(memberCell, "guildLabel", 200, 20, 16, "#ffffff", "行会名字七个字")
    GUI:setAnchorPoint(guildLabel, 0.5, 0.5)

    local levelLabel = GUI:Text_Create(memberCell, "levelLabel", 340, 20, 16, "#ffffff", "")
    GUI:setAnchorPoint(levelLabel, 0.5, 0.5)

    local disagreeBtn = GUI:Button_Create(memberCell, "disagreeBtn", 458, 20, "res/public/1900000679.png")
    GUI:setAnchorPoint(disagreeBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(disagreeBtn, "res/public/1900000679_1.png")
    SL:SetColorStyle(disagreeBtn, 1020)
    GUI:Button_setTitleText(disagreeBtn, "拒绝")

    local agreeBtn = GUI:Button_Create(memberCell, "agreeBtn", 553, 20, "res/public/1900000679.png")
    GUI:setAnchorPoint(agreeBtn, 0.5, 0.5)
    GUI:Button_loadTexturePressed(agreeBtn, "res/public/1900000679_1.png")
    SL:SetColorStyle(agreeBtn, 1020)
    GUI:Button_setTitleText(agreeBtn, "同意")

    -- 申请成员列表
    local memberListView = GUI:ListView_Create(bgPanel, "memberListView", 40, 43, 600, 280, 1)
    GUI:ListView_setClippingEnabled(memberListView, true)
end