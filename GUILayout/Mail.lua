Mail = {}

function Mail.main( ... )
    local parent = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    local bgPanel = GUI:Layout_Create(parent, "bgPanel", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(bgPanel, true)

    local bgImg = GUI:Image_Create(bgPanel, "bgImg", attachW/2, 222.5, "res/private/mail/1900020061.png")
    GUI:setAnchorPoint(bgImg, 0.5, 0.5)

    -- 邮件列表
    local mailList = GUI:ListView_Create(bgPanel, "mailList", 12, 54, 220, 380, 1)
    GUI:ListView_setGravity(mailList, 0)
    GUI:ListView_setClippingEnabled(mailList, true)

    local takeOutAllBtn = GUI:Button_Create(bgPanel, "takeOutAllBtn", 67, 28, "res/public/1900000612.png")
    GUI:setAnchorPoint(takeOutAllBtn, 0.5, 0.5)
    GUI:Button_setTitleColor(takeOutAllBtn, "#f8e6c6")
    GUI:Button_setTitleFontSize(takeOutAllBtn, 16)
    GUI:Button_setTitleText(takeOutAllBtn, "全部提取")
    GUI:Button_titleEnableOutline(takeOutAllBtn, "#111111", 1)

    local deleteReadBtn = GUI:Button_Create(bgPanel, "deleteReadBtn", 176, 28, "res/public/1900000612.png")
    GUI:setAnchorPoint(deleteReadBtn, 0.5, 0.5)
    GUI:Button_setTitleColor(deleteReadBtn, "#f8e6c6")
    GUI:Button_setTitleFontSize(deleteReadBtn, 16)
    GUI:Button_setTitleText(deleteReadBtn, "删除已读")
    GUI:Button_titleEnableOutline(deleteReadBtn, "#111111", 1)

    -- 邮件详情
    local mainPanel = GUI:Layout_Create(bgPanel, "mainPanel", 240, 0, 490, 450, true)

    local titlePanel = GUI:Layout_Create(mainPanel, "titlePanel", 15, 400, 460, 30)
    GUI:Layout_setBackGroundImage(titlePanel, "res/private/mail/1900020064.png")
    GUI:Layout_setBackGroundImageScale9Slice(titlePanel, 11, 11, 11, 11)

    local titleName = GUI:Text_Create(titlePanel, "titleName", 10, 15, 16, "#ffffff", "主题:")
    GUI:setAnchorPoint(titleName, 0, 0.5)
    local titleShow = GUI:Text_Create(titlePanel, "titleShow", 60, 15, 16, "#ffffff", "xxxxx")
    GUI:setAnchorPoint(titleShow, 0, 0.5)

    local senderPanel = GUI:Layout_Create(mainPanel, "senderPanel", 15, 364, 460, 30)
    GUI:Layout_setBackGroundImage(senderPanel, "res/private/mail/1900020064.png")
    GUI:Layout_setBackGroundImageScale9Slice(senderPanel, 11, 11, 11, 11)
    
    local senderName = GUI:Text_Create(senderPanel, "senderName", 10, 15, 16, "#ffffff", "发送者:")
    GUI:setAnchorPoint(senderName, 0, 0.5)
    local senderShow = GUI:Text_Create(senderPanel, "senderShow", 80, 15, 16, "#ffffff", "xxxxx")
    GUI:setAnchorPoint(senderShow, 0, 0.5)

    local timePanel = GUI:Layout_Create(mainPanel, "timePanel", 15, 327, 460, 30)
    GUI:Layout_setBackGroundImage(timePanel, "res/private/mail/1900020064.png")
    GUI:Layout_setBackGroundImageScale9Slice(timePanel, 11, 11, 11, 11)
    
    local timeName = GUI:Text_Create(timePanel, "timeName", 10, 15, 16, "#ffffff", "时间:")
    GUI:setAnchorPoint(timeName, 0, 0.5)
    local timeShow = GUI:Text_Create(timePanel, "timeShow", 60, 15, 16, "#ffffff", "xxxxx")
    GUI:setAnchorPoint(timeShow, 0, 0.5)

    local contentPanel = GUI:Layout_Create(mainPanel, "contentPanel", 17, 138, attachH, 185)
    GUI:Layout_setBackGroundImage(contentPanel, "res/private/mail/1900020064.png")
    GUI:Layout_setBackGroundImageScale9Slice(contentPanel, 11, 11, 11, 11)

    -- 邮件内容
    local mailConList = GUI:ListView_Create(mainPanel, "mailConList", 22, 140, 450, 180, 1)
    GUI:Layout_setClippingEnabled(mailConList, true)

    -- 附件
    local itemText = GUI:Text_Create(mainPanel, "itemText", 39, 93, 20, "#d8c8ae", "附\n件")
    GUI:setAnchorPoint(itemText, 0.5, 0.5)
    GUI:Text_enableOutline(itemText, "#111111", 2)

    local itemsList = GUI:ListView_Create(mainPanel, "itemsList", 54, 59, 420, 70, 2)
    GUI:ListView_setClippingEnabled(itemsList, true)
    GUI:ListView_setGravity(itemsList, 5)
    GUI:ListView_setItemsMargin(itemsList, 5)

    local rewardFlagIcon = GUI:Image_Create(mainPanel, "rewardFlagIcon", 264, 92, "res/public/word_bqzy_01.png")
    GUI:setAnchorPoint(rewardFlagIcon, 0.5, 0.5)

    local takeOutBtn = GUI:Button_Create(mainPanel, "takeOutBtn", 420, 31, "res/public/1900000611.png")
    GUI:setAnchorPoint(takeOutBtn, 0.5, 0.5)
    GUI:Button_setTitleColor(takeOutBtn, "#f8e6c6")
    GUI:Button_setTitleFontSize(takeOutBtn, 16)
    GUI:Button_setTitleText(takeOutBtn, "提取")
    GUI:Button_titleEnableOutline(takeOutBtn, "#111111", 2)

    local deleteBtn = GUI:Button_Create(mainPanel, "deleteBtn", 420, 31, "res/public/1900000611.png")
    GUI:setAnchorPoint(deleteBtn, 0.5, 0.5)
    GUI:Button_setTitleColor(deleteBtn, "#f8e6c6")
    GUI:Button_setTitleFontSize(deleteBtn, 16)
    GUI:Button_setTitleText(deleteBtn, "删除")
    GUI:Button_titleEnableOutline(deleteBtn, "#111111", 2)

end

function Mail.CreateMailCell( parent )
    if not parent then
        return
    end

    local mailItem = GUI:Layout_Create(parent, "mailItem",0, 0, 220, 74)
    GUI:setTouchEnabled(mailItem , true)

    local mailBg = GUI:Button_Create(mailItem, "mailBg", 0, 0, "res/private/mail/1900020062.png")
    GUI:setTouchEnabled(mailBg, false)
    GUI:Button_loadTextureDisabled(mailBg, "res/private/mail/1900020063.png")

    -- 发送者
    local senderLabel = GUI:Text_Create(mailItem, "senderLabel", 15, 53, 16, "#ffffff", "传奇团队")
    GUI:setAnchorPoint(senderLabel, 0, 0.5)
    GUI:Text_enableOutline(senderLabel, "#111111", 1)

    -- 已读/未读状态
    local stateLabel = GUI:Text_Create(mailItem, "stateLabel", 125, 53, 16, "#ffffff", "已读")
    GUI:setAnchorPoint(stateLabel, 0.5, 0.5)
    GUI:Text_enableOutline(stateLabel, "#111111", 1)

    Mail.stateShow = {
        [1] = {str = "未读", color = "#ff0500"},
        [2] = {str = "已读", color = "#ffffff"}
    }

    -- 邮件标题
    local titleLabel = GUI:Text_Create(mailItem, "titleLabel", 15, 24, 16, "#ffffff", "系统奖励")
    GUI:setAnchorPoint(titleLabel, 0, 0.5)
    GUI:Text_enableOutline(titleLabel, "#111111", 1)

    -- 删除
    local deleteBtn = GUI:Button_Create(mailItem, "deleteBtn", 190, 37, "res/private/mail/1900020065.png")
    GUI:setAnchorPoint(deleteBtn, 0.5, 0.5)
    GUI:setScaleX(deleteBtn, 0.8)
    GUI:setScaleY(deleteBtn, 0.8)

    -- 附件标识
    local sItemImg = GUI:Image_Create(mailItem, "sItemImg", 251, 34, "Default/ImageFile.png")
    GUI:setAnchorPoint(sItemImg, 0.5, 0.5)
    GUI:setScaleX(sItemImg, 0.8)
    GUI:setScaleY(sItemImg, 0.8)

end