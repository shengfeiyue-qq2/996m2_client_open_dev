Friend = {}

-- 配置分页按钮 选中/正常 颜色ID
Friend.Btn_SelectColorID = 1025
Friend.Btn_NormalColorID = 1026

-- 设置离线/在线的字体颜色 0离线
Friend.SET_ONLINE_COLOR = {
    [0] = SL:ConvertColorFromHexString("#BFBFBF"),
    [1] = SL:ConvertColorFromHexString("#FFFFFF"),
}

function Friend.main()
    local parent = GUI:Attach_Parent()
    local innnerWid = 732
    local innnerHei = 445

    local mainPanel = GUI:Layout_Create(parent, "mainPanel", 0, 0, innnerWid, innnerHei)

    -- 好友
    local myFriendBtn = GUI:Button_Create(mainPanel, "myFriendBtn", 63, 420, "res/public/1900000663.png")
    GUI:setAnchorPoint(myFriendBtn, 0.5, 0.5)
    GUI:Button_loadTextureDisabled(myFriendBtn, "res/public/1900000662.png")
    GUI:Button_setTitleText(myFriendBtn, "我的好友")

    -- 黑名单
    local blacklistBtn = GUI:Button_Create(mainPanel, "blacklistBtn", 63, 380, "res/public/1900000663.png")
    GUI:setAnchorPoint(blacklistBtn, 0.5, 0.5)
    GUI:Button_loadTextureDisabled(blacklistBtn, "res/public/1900000662.png")
    GUI:Button_setTitleText(blacklistBtn, "黑名单")

    Friend.BaseFriendFormat = "好友: %s/%s"
    local friendNumText = GUI:Text_Create(mainPanel, "friendNumText", 145, 21, 16, "#ffffff", "好友: 0/100")
    GUI:setAnchorPoint(friendNumText, 0, 0.5)

    -- 标题
    local titlePanel = GUI:Layout_Create(mainPanel, "titlePanel", 0 , 0, innnerWid, innnerHei)

    local lineBg = GUI:Image_Create(titlePanel, "lineBg", 429, 425, "res/private/friend/bg_hengtiao_02.png") 
    GUI:setAnchorPoint(lineBg, 0.5, 0.5)

    local line1 = GUI:Image_Create(titlePanel, "line1", 125, 222, "res/private/friend/bg_hengtiao_01.png")
    GUI:setAnchorPoint(line1, 0.5, 0.5)
    GUI:setRotationSkewX(line1, 90)
    GUI:setRotationSkewY(line1, 90)
    GUI:setContentSize(line1, 445, 2)

    local nameText = GUI:Text_Create(titlePanel, "nameText", 198, 426, 16, "#ffffff", "名字")
    GUI:setAnchorPoint(nameText, 0.5, 0.5)

    local levelText = GUI:Text_Create(titlePanel, "levelText", 318, 426, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelText, 0.5, 0.5)

    local jobText = GUI:Text_Create(titlePanel, "jobText", 405, 426, 16, "#ffffff", "职业")
    GUI:setAnchorPoint(jobText, 0.5, 0.5)

    local guildText = GUI:Text_Create(titlePanel, "guildText", 518, 426, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guildText, 0.5, 0.5)

    local statusText = GUI:Text_Create(titlePanel, "statusText", 663, 426, 16, "#ffffff", "状态")
    GUI:setAnchorPoint(statusText, 0.5, 0.5)

    -- 我的好友分页
    local myFriendPanel = GUI:Layout_Create(mainPanel, "myFriendPanel", 0, 0, innnerWid, innnerHei)

    local noneFriendImg = GUI:Image_Create(myFriendPanel, "noneFriendImg", 426, 217, "res/private/friend/word_haoyou_01.png")
    GUI:setAnchorPoint(noneFriendImg, 0.5, 0.5)

    local addFriendBtn = GUI:Button_Create(myFriendPanel, "addFriendBtn", 673, 24, "res/public/1900000660.png")
    GUI:setAnchorPoint(addFriendBtn, 0.5, 0.5)
    SL:SetColorStyle(addFriendBtn, 1022)
    GUI:Button_setTitleText(addFriendBtn, "添加好友")

    local myFriendList = GUI:ListView_Create(myFriendPanel, "myFriendList", 125, 55, 606, 350, 1)
    GUI:ListView_setClippingEnabled(myFriendList, true)

    -- 黑名单分页
    local blackListPanel = GUI:Layout_Create(mainPanel, "blackListPanel", 0, 0, innnerWid, innnerHei)

    local noneBlackListImg = GUI:Image_Create(blackListPanel, "noneBlackListImg", 426, 214, "res/private/friend/word_haoyou_02.png")
    GUI:setAnchorPoint(noneBlackListImg, 0.5, 0.5)

    local blackListView = GUI:ListView_Create(blackListPanel, "blackListView", 124, 0, 606, 405, 1)
    GUI:ListView_setClippingEnabled(blackListView, true)

    -- 单条数据
    local customizeCell = GUI:Layout_Create(mainPanel, "customizeCell", 124, 365, 606, 40)
    GUI:setTouchEnabled(customizeCell, true)

    local nameLabel = GUI:Text_Create(customizeCell, "nameLabel", 75, 20, 16, "#ffffff", "角色名字")
    GUI:setAnchorPoint(nameLabel, 0.5, 0.5)

    local levelLabel = GUI:Text_Create(customizeCell, "levelLabel", 195, 20, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelLabel, 0.5, 0.5)

    local jobLabel = GUI:Text_Create(customizeCell, "jobLabel", 281, 20, 16, "#ffffff", "战士")
    GUI:setAnchorPoint(jobLabel, 0.5, 0.5)

    local guildLabel = GUI:Text_Create(customizeCell, "guildLabel", 395, 20, 16, "#ffffff", "行会名字")
    GUI:setAnchorPoint(guildLabel, 0.5, 0.5)

    local onlineLabel = GUI:Text_Create(customizeCell, "onlineLabel", 539, 20, 16, "#ffffff", "在线")
    GUI:setAnchorPoint(onlineLabel, 0.5, 0.5)

    local line = GUI:Image_Create(customizeCell, "line", 0, 0, "res/private/friend/1900014009.png")
end