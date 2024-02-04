Team = {}

Team.Btn_SelectColorID = 1025
Team.Btn_NormalColorID = 1026

function Team.main( ... )
    local parent = GUI:Attach_Parent()
    local innnerWid = 732
    local innnerHei = 445

    local mainPanel = GUI:Layout_Create(parent, "mainPanel", 0, 0, innnerWid, innnerHei)

    local myTeamBtn = GUI:Button_Create(mainPanel, "myTeamBtn", 65, 420, "res/public/1900000663.png")
    GUI:setAnchorPoint(myTeamBtn, 0.5, 0.5)
    GUI:Button_loadTextureDisabled(myTeamBtn, "res/public/1900000662.png")
    GUI:Button_setTitleText(myTeamBtn, "我的队伍")
    SL:SetColorStyle(myTeamBtn, Team.Btn_SelectColorID)

    local nearTeamBtn = GUI:Button_Create(mainPanel, "nearTeamBtn", 65, 378, "res/public/1900000663.png")
    GUI:setAnchorPoint(nearTeamBtn, 0.5, 0.5)
    GUI:Button_loadTextureDisabled(nearTeamBtn, "res/public/1900000662.png")
    GUI:Button_setTitleText(nearTeamBtn, "附近队伍")
    SL:SetColorStyle(nearTeamBtn, Team.Btn_SelectColorID)

    -- 我的队伍 分页
    local myTeamPanel = GUI:Layout_Create(mainPanel, "myTeamPanel", 0, 0, innnerWid, innnerHei)
    
    local lineBg = GUI:Image_Create(myTeamPanel, "lineBg", 0, 52, "res/private/team/1900014008.png")
    
    local noneTip = GUI:Image_Create(myTeamPanel, "noneTip", 430, 244, "res/private/team/1900014011.png")
    GUI:setAnchorPoint(noneTip, 0.5, 0.5)
    
    local createTeamBtn = GUI:Button_Create(myTeamPanel, "createTeamBtn", 673, 24, "res/public/1900000660.png")
    GUI:setAnchorPoint(createTeamBtn, 0.5, 0.5)
    GUI:Button_setTitleText(createTeamBtn, "创建队伍")
    SL:SetColorStyle(createTeamBtn, 1022)

    local applyListBtn = GUI:Button_Create(myTeamPanel, "applyListBtn", 340, 26, "res/public/1900000660.png")
    GUI:setAnchorPoint(applyListBtn, 0.5, 0.5)
    GUI:Button_setTitleText(applyListBtn, "申请列表")
    SL:SetColorStyle(applyListBtn, 1022)

    local callBtn = GUI:Button_Create(myTeamPanel, "callBtn", 450, 26, "res/public/1900000660.png")
    GUI:setAnchorPoint(callBtn, 0.5, 0.5)
    GUI:Button_setTitleText(callBtn, "召集队友")
    SL:SetColorStyle(callBtn, 1022)

    local inviteBtn = GUI:Button_Create(myTeamPanel, "inviteBtn", 560, 26, "res/public/1900000660.png")
    GUI:setAnchorPoint(inviteBtn, 0.5, 0.5)
    GUI:Button_setTitleText(inviteBtn, "邀请成员")
    SL:SetColorStyle(inviteBtn, 1022)

    local exitBtn = GUI:Button_Create(myTeamPanel, "exitBtn", 673, 26, "res/public/1900000660.png")
    GUI:setAnchorPoint(exitBtn, 0.5, 0.5)
    GUI:Button_setTitleText(exitBtn, "离开队伍")
    SL:SetColorStyle(exitBtn, 1022)

    local nameText = GUI:Text_Create(myTeamPanel, "nameText", 218, 432, 16, "#ffffff", "名字")
    GUI:setAnchorPoint(nameText, 0.5, 0.5)
    GUI:Text_enableOutline(nameText, "#111111", 1)

    local jobText = GUI:Text_Create(myTeamPanel, "jobText", 345, 432, 16, "#ffffff", "职业")
    GUI:setAnchorPoint(jobText, 0.5, 0.5)
    GUI:Text_enableOutline(jobText, "#111111", 1)

    local levelText = GUI:Text_Create(myTeamPanel, "levelText", 423, 432, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelText, 0.5, 0.5)
    GUI:Text_enableOutline(levelText, "#111111", 1)

    local guildText = GUI:Text_Create(myTeamPanel, "guildText", 530, 432, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guildText, 0.5, 0.5)
    GUI:Text_enableOutline(guildText, "#111111", 1)

    local mapText = GUI:Text_Create(myTeamPanel, "mapText", 665, 432, 16, "#ffffff", "所在地图")
    GUI:setAnchorPoint(mapText, 0.5, 0.5)
    GUI:Text_enableOutline(mapText, "#111111", 1)

    local expText = GUI:Text_Create(myTeamPanel, "expText", 150, 27, 16, "#ffffff", "经验加成")
    GUI:setAnchorPoint(expText, 0, 0.5)
    GUI:Text_enableOutline(expText, "#111111", 1)

    -- 允许组队
    local setID = 4001
    local permitCheckBox = GUI:CheckBox_Create(myTeamPanel, "permitCheckBox", 26, 27, "res/public/1900000654.png", "res/public/1900000655.png")
    GUI:setAnchorPoint(permitCheckBox, 0.5, 0.5)
    GUI:CheckBox_setSelected(permitCheckBox, SL:CheckSet(setID) == 1)
    
    GUI:CheckBox_addOnEvent(permitCheckBox, function (sender, eventType)
        local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
        SL:SetSettingValue(setID, {isSelected})
    end)
    
    local TouchSize = GUI:Layout_Create(permitCheckBox, "TouchSize", -8.5, 9.5, 100, 28.5)
    GUI:setAnchorPoint(TouchSize, 0, 0.5)

    local permitText = GUI:Text_Create(permitCheckBox, "permitText", 25, 9.5, 16, "#28ef01", "允许组队")
    GUI:setAnchorPoint(permitText, 0, 0.5)
    GUI:Text_enableOutline(permitText, "#111111", 1)

    -- 我的队伍成员 列表
    local memberListView = GUI:ListView_Create(myTeamPanel, "memberListView", 131, 58, 600, 360, 1)
    GUI:ListView_setGravity(memberListView, 2)
    GUI:ListView_setClippingEnabled(memberListView, true)

    -- 单条成员
    local memberCell = GUI:Layout_Create(myTeamPanel, "memberCell", 131, 380, 600, 40)
    
    local leaderImg = GUI:Image_Create(memberCell, "leaderImg", 0, 20, "res/public/1900000678.png")
    GUI:setAnchorPoint(leaderImg, 0, 0.5)
    GUI:Image_setScale9Slice(leaderImg, 26, 26, 5, 5)

    local icon = GUI:Image_Create(memberCell, "icon", 20, 20, "res/private/team/1900014001.png")
    GUI:setAnchorPoint(icon, 0.5, 0.5)

    local cellBg = GUI:Image_Create(memberCell, "cellBg", 300, 20, "res/private/team/1900014010.png")
    GUI:setAnchorPoint(cellBg, 0.5, 0.5)

    local nameLabel = GUI:Text_Create(memberCell, "nameLabel", 94, 20, 16, "#ffffff", "玩家名字七个字")
    GUI:setAnchorPoint(nameLabel, 0.5, 0.5)

    local jobLabel = GUI:Text_Create(memberCell, "jobLabel", 215, 20, 16, "#ffffff", "战士")
    GUI:setAnchorPoint(jobLabel, 0.5, 0.5)

    local levelLabel = GUI:Text_Create(memberCell, "levelLabel", 293, 20, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelLabel, 0.5, 0.5)

    local guildLabel = GUI:Text_Create(memberCell, "guildLabel", 400, 20, 16, "#ffffff", "行会名字七个字")
    GUI:setAnchorPoint(guildLabel, 0.5, 0.5)

    local mapLabel = GUI:Text_Create(memberCell, "mapLabel", 535, 20, 16, "#ffffff", "地图名字七个字")
    GUI:setAnchorPoint(mapLabel, 0.5, 0.5)

    -- 附近队伍 分页
    local nearTeamPanel = GUI:Layout_Create(mainPanel, "nearTeamPanel", 0, 0, innnerWid, innnerHei)

    local lineBg = GUI:Image_Create(nearTeamPanel, "lineBg", 0, 52, "res/private/team/19000140013.png")

    local teamText = GUI:Text_Create(nearTeamPanel, "teamText", 215, 432, 16, "#ffffff", "队伍")
    GUI:setAnchorPoint(teamText, 0.5, 0.5)

    local guild1Text = GUI:Text_Create(nearTeamPanel, "guild1Text", 383, 432, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guild1Text, 0.5, 0.5)

    local numberText = GUI:Text_Create(nearTeamPanel, "numberText", 540, 432, 16, "#ffffff", "人数")
    GUI:setAnchorPoint(numberText, 0.5, 0.5)

    local operationText = GUI:Text_Create(nearTeamPanel, "operationText", 660, 432, 16, "#ffffff", "操作")
    GUI:setAnchorPoint(operationText, 0.5, 0.5)

    -- 单条附近队伍
    local nearMemberCell = GUI:Layout_Create(nearTeamPanel, "nearMemberCell", 131, 370, 600, 42)

    local cellBg = GUI:Image_Create(nearMemberCell, "cellBg", 300, 21, "res/private/team/19000140013_1.png")
    GUI:setAnchorPoint(cellBg, 0.5, 0.5)

    local nameLabel = GUI:Text_Create(nearMemberCell, "nameLabel", 83, 21, 16, "#ffffff",  "玩家名字七个字")
    GUI:setAnchorPoint(nameLabel, 0.5, 0.5)

    local guildLabel = GUI:Text_Create(nearMemberCell, "guildLabel", 250, 21, 16, "#ffffff", "行会名称")
    GUI:setAnchorPoint(guildLabel, 0.5, 0.5)

    local numberLabel = GUI:Text_Create(nearMemberCell, "numberLabel", 410, 21, 16, "#ffffff", "人数")
    GUI:setAnchorPoint(numberLabel, 0.5, 0.5)

    local operationLabel = GUI:Text_Create(nearMemberCell, "operationLabel", 530, 21, 16, "#f8e6c6", "已申请")
    GUI:setAnchorPoint(operationLabel, 0.5, 0.5)

    local operationButton  = GUI:Button_Create(nearMemberCell, "operationButton", 530, 21, "res/public/1900000679.png")
    GUI:setAnchorPoint(operationButton, 0.5, 0.5)
    GUI:Button_loadTexturePressed(operationButton, "res/public/1900000679_1.png")
    SL:SetColorStyle(operationButton, 1022)
    GUI:Button_setTitleText(operationButton, "申请")

    -- 附近队伍列表
    local nearListView = GUI:ListView_Create(nearTeamPanel, "nearListView", 131, 58, 600, 360, 1)
    GUI:ListView_setClippingEnabled(nearListView, true)
    GUI:ListView_setGravity(nearListView, 0)
end