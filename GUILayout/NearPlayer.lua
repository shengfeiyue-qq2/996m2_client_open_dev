NearPlayer = {}

function NearPlayer.main( ... )
    local parent = GUI:Attach_Parent()
    local attachW = GUIShare.WinView.Width
    local attachH = GUIShare.WinView.Height

    local mainPanel = GUI:Layout_Create(parent, "mainPanel", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(mainPanel, true)

    -- 允许添加 
    local setID = 4003
    local CheckBox_add = GUI:CheckBox_Create(mainPanel, "CheckBox_add", 25, 425, "res/public/1900000654.png", "res/public/1900000655.png")
    GUI:setAnchorPoint(CheckBox_add, 0.5, 0.5)
    GUI:CheckBox_setSelected(CheckBox_add, SL:CheckSet(setID) == 1)

    GUI:Win_SetParam(CheckBox_add, setID)
    GUI:CheckBox_addOnEvent(CheckBox_add, NearPlayer.onCheckBoxEvent)

    local TouchSize = GUI:Layout_Create(CheckBox_add, "TouchSize", -8.5, 9.5, 100, 28.5)
    GUI:setAnchorPoint(TouchSize, 0, 0.5)
    
    local permitText = GUI:Text_Create(CheckBox_add, "permitText", 20, 9.5, 16, "#28ef01", "允许添加")
    GUI:setAnchorPoint(permitText, 0, 0.5)
    GUI:Text_enableOutline(permitText, "#111111", 1)

    -- 允许组队
    local setID = 4001
    local CheckBox_team = GUI:CheckBox_Create(mainPanel, "CheckBox_team", 25, 395, "res/public/1900000654.png", "res/public/1900000655.png")
    GUI:setAnchorPoint(CheckBox_team, 0.5, 0.5)
    GUI:CheckBox_setSelected(CheckBox_team, SL:CheckSet(setID) == 1)

    GUI:Win_SetParam(CheckBox_team, setID)
    GUI:CheckBox_addOnEvent(CheckBox_team, NearPlayer.onCheckBoxEvent)

    local TouchSize = GUI:Layout_Create(CheckBox_team, "TouchSize", -8.5, 9.5, 100, 28.5)
    GUI:setAnchorPoint(TouchSize, 0, 0.5)
    
    local permitText = GUI:Text_Create(CheckBox_team, "permitText", 20, 9.5, 16, "#28ef01", "允许组队")
    GUI:setAnchorPoint(permitText, 0, 0.5)
    GUI:Text_enableOutline(permitText, "#111111", 1)

    -- 允许交易
    local setID = 4004
    local CheckBox_deal = GUI:CheckBox_Create(mainPanel, "CheckBox_deal", 25, 365, "res/public/1900000654.png", "res/public/1900000655.png")
    GUI:setAnchorPoint(CheckBox_deal, 0.5, 0.5)
    GUI:CheckBox_setSelected(CheckBox_deal, SL:CheckSet(setID) == 1)

    GUI:Win_SetParam(CheckBox_deal, setID)
    GUI:CheckBox_addOnEvent(CheckBox_deal, NearPlayer.onCheckBoxEvent)

    local TouchSize = GUI:Layout_Create(CheckBox_deal, "TouchSize", -8.5, 9.5, 100, 28.5)
    GUI:setAnchorPoint(TouchSize, 0, 0.5)
    
    local permitText = GUI:Text_Create(CheckBox_deal, "permitText", 20, 9.5, 16, "#28ef01", "允许交易")
    GUI:setAnchorPoint(permitText, 0, 0.5)
    GUI:Text_enableOutline(permitText, "#111111", 1)

    -- 允许挑战
    local setID = 4005
    local CheckBox_challenge = GUI:CheckBox_Create(mainPanel, "CheckBox_challenge", 25, 335, "res/public/1900000654.png", "res/public/1900000655.png")
    GUI:setAnchorPoint(CheckBox_challenge, 0.5, 0.5)
    GUI:CheckBox_setSelected(CheckBox_challenge, SL:CheckSet(setID) == 1)

    GUI:Win_SetParam(CheckBox_challenge, setID)
    GUI:CheckBox_addOnEvent(CheckBox_challenge, NearPlayer.onCheckBoxEvent)


    local TouchSize = GUI:Layout_Create(CheckBox_challenge, "TouchSize", -8.5, 9.5, 100, 28.5)
    GUI:setAnchorPoint(TouchSize, 0, 0.5)
    
    local permitText = GUI:Text_Create(CheckBox_challenge, "permitText", 20, 9.5, 16, "#28ef01", "允许挑战")
    GUI:setAnchorPoint(permitText, 0, 0.5)
    GUI:Text_enableOutline(permitText, "#111111", 1)

    -- 允许显示
    local setID = 4006
    local CheckBox_show = GUI:CheckBox_Create(mainPanel, "CheckBox_show", 25, 305, "res/public/1900000654.png", "res/public/1900000655.png")
    GUI:setAnchorPoint(CheckBox_show, 0.5, 0.5)
    GUI:CheckBox_setSelected(CheckBox_show, SL:CheckSet(setID) == 1)

    GUI:Win_SetParam(CheckBox_show, setID)
    GUI:CheckBox_addOnEvent(CheckBox_show, NearPlayer.onCheckBoxEvent)

    local TouchSize = GUI:Layout_Create(CheckBox_show, "TouchSize", -8.5, 9.5, 100, 28.5)
    GUI:setAnchorPoint(TouchSize, 0, 0.5)
    
    local permitText = GUI:Text_Create(CheckBox_show, "permitText", 20, 9.5, 16, "#28ef01", "允许显示")
    GUI:setAnchorPoint(permitText, 0, 0.5)
    GUI:Text_enableOutline(permitText, "#111111", 1)

    --- 列表展示
    local nearPanel = GUI:Layout_Create(mainPanel, "nearPanel", 0, 0, attachW, attachH)
    
    local lineImg = GUI:Image_Create(nearPanel, "lineImg", 0, 52, "res/private/team/1900014008.png")

    local nameText = GUI:Text_Create(nearPanel, "nameText", 215, 432, 16, "#ffffff", "队伍")
    GUI:setAnchorPoint(nameText, 0.5, 0.5)
    GUI:Text_enableOutline(nameText, "#111111", 1)

    local jobText = GUI:Text_Create(nearPanel, "jobText", 346, 432, 16, "#ffffff", "职业")
    GUI:setAnchorPoint(jobText, 0.5, 0.5)
    GUI:Text_enableOutline(jobText, "#111111", 1)

    local levelText = GUI:Text_Create(nearPanel, "levelText", 427, 432, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelText, 0.5, 0.5)
    GUI:Text_enableOutline(levelText, "#111111", 1)

    local guildText = GUI:Text_Create(nearPanel, "guildText", 528, 432, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guildText, 0.5, 0.5)
    GUI:Text_enableOutline(guildText, "#111111", 1)

    local operationText = GUI:Text_Create(nearPanel, "operationText", 660, 432, 16, "#ffffff", "操作")
    GUI:setAnchorPoint(operationText, 0.5, 0.5)
    GUI:Text_enableOutline(operationText, "#111111", 1)

    local nearListView = GUI:ListView_Create(nearPanel, "nearListView", 131, 58, 600, 360, 1)
    GUI:ListView_setGravity(nearListView, 0)

    -- 玩家信息模板
    local nearMemberCell = GUI:Layout_Create(nearPanel, "nearMemberCell", 131, 370, 600, 42)
    GUI:setTouchEnabled(nearMemberCell, true)

    local cellBg = GUI:Image_Create(nearMemberCell, "cellBg", 300, 21, "res/private/team/1900014010.png")
    GUI:setAnchorPoint(cellBg, 0.5, 0.5)
    
    local nameShow = GUI:Text_Create(nearMemberCell, "nameShow", 85, 21, 16, "#ffffff", "玩家名字七个字")
    GUI:setAnchorPoint(nameShow, 0.5, 0.5)
    GUI:Text_enableOutline(nameShow, "#111111", 1)

    local jobShow = GUI:Text_Create(nearMemberCell, "jobShow", 216, 21, 16, "#ffffff", "职业")
    GUI:setAnchorPoint(jobShow, 0.5, 0.5)
    GUI:Text_enableOutline(jobShow, "#111111", 1)

    local levelShow = GUI:Text_Create(nearMemberCell, "levelShow", 296, 21, 16, "#ffffff", "等级")
    GUI:setAnchorPoint(levelShow, 0.5, 0.5)
    GUI:Text_enableOutline(levelShow, "#111111", 1)

    local guildShow = GUI:Text_Create(nearMemberCell, "guildShow", 398, 21, 16, "#ffffff", "行会")
    GUI:setAnchorPoint(guildShow, 0.5, 0.5)
    GUI:Text_enableOutline(guildShow, "#111111", 1)

    local operationBtn = GUI:Button_Create(nearMemberCell, "operationBtn", 533, 21, "res/public/1900000679.png")
    GUI:Button_loadTexturePressed(operationBtn, "res/public/1900000679_1.png")
    GUI:setAnchorPoint(operationBtn, 0.5, 0.5)
    GUI:Button_setTitleFontSize(operationBtn, 16)
    GUI:Button_setTitleColor(operationBtn, "#f8e6c6")
    GUI:Button_titleEnableOutline(operationBtn, "#111111", 2)
    GUI:Button_setTitleText(operationBtn, "查看")
end

-- CheckBox 点击事件
function NearPlayer.onCheckBoxEvent(sender, eventType)
    local id = GUI:Win_GetParam(sender)
    print("id........", id)
    local isSelected = GUI:CheckBox_isSelected(sender) and 1 or 0
    SL:SetSettingValue(id, {isSelected})
end