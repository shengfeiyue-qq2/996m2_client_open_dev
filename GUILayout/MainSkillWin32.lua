MainSkillWin32 = {}

MainSkillWin32.CellSize = {
    width = 55, height = 55
}

MainSkillWin32.skillSfx =  {     -- 技能特效 press:按下 select:选择/开启
    press  = 4001,
    select = 4005
}

MainSkillWin32.sfxScale = 0.5

function MainSkillWin32.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local Panel_skill = GUI:Layout_Create(parent, "Panel_skill", 0, 0, MainSkillWin32.CellSize.width, 460)
    GUI:setAnchorPoint(Panel_skill, 1, 1)
    GUI:setPositionY(Panel_skill, -190)

    local arr_bg = GUI:Image_Create(Panel_skill, "arr_bg", MainSkillWin32.CellSize.width/2, 460, "res/private/main-win32/skill/1900012573.png")
    GUI:setAnchorPoint(arr_bg, 0, 0.5)
    GUI:setContentSize(arr_bg, 20, 50)
    GUI:Image_setScale9Slice(arr_bg, 3, 3, 25, 25)
    GUI:setRotation(arr_bg, 90)

    local Button_arr = GUI:Button_Create(arr_bg, "Button_arr", 10, 25, "res/private/main-win32/skill/1900012567.png")
    GUI:setAnchorPoint(Button_arr, 0.5, 0.5)
    GUI:addOnClickEvent(Button_arr, MainSkillWin32.onButtonArr)

    local ListView_skill = GUI:ScrollView_Create(Panel_skill, "ListView_skill", 0, 440, MainSkillWin32.CellSize.height, 440, 1)
    GUI:setAnchorPoint(ListView_skill, 0, 1)
    MainSkillWin32.ListView_skill = ListView_skill

    local sformat = string.format
    for i=1,8 do
        local skillCell = MainSkillWin32.createSkillCell(ListView_skill, i)
        local Image_key = GUI:getChildByName(skillCell, "Image_key")
        GUI:Image_loadTexture(Image_key, sformat("res/private/main-win32/word/key_F%s.png", i))
    end
    GUI:UserUILayout(ListView_skill)
end

function MainSkillWin32.onButtonArr(sender)
    local rotate = GUI:getRotation(sender)
    if rotate == 0 then
        GUI:setVisible(MainSkillWin32.ListView_skill, false)
        GUI:setRotation(sender, 180)
    else
        GUI:setVisible(MainSkillWin32.ListView_skill, true)
        GUI:setRotation(sender, 0)
        GUI:UserUILayout(MainSkillWin32.ListView_skill, {interval = 0.01})
    end
end

function MainSkillWin32.createSkillCell(parent, ID)
    local width, height = MainSkillWin32.CellSize.width, MainSkillWin32.CellSize.height

    local Panel_cell = GUI:Layout_Create(parent, ID, 0, 0, width, height, false)

    local Image_bg = GUI:Image_Create(Panel_cell, "Image_bg", width / 2, height / 2, "res/private/main-win32/skill/bg_kjjsz_02.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)

    local Button_icon = GUI:Button_Create(Panel_cell, "Button_icon", width / 2 + 1, height / 2 - 1)
    GUI:setContentSize(Button_icon, 45, 45)
    GUI:setAnchorPoint(Button_icon, 0.5, 0.5)

    local ProgressTimer_cd = GUI:ProgressTimer_Create(Panel_cell, "ProgressTimer_cd", width / 2, height / 2 - 1, "res/public/1900000580.png")
    GUI:setAnchorPoint(ProgressTimer_cd, 0.5, 0.5)
    GUI:setOpacity(ProgressTimer_cd, 150)
    GUI:setScale(ProgressTimer_cd, 1.6)
    GUI:ProgressTimer_setReverseDirection(ProgressTimer_cd, true)

    local Image_key = GUI:Image_Create(Panel_cell, "Image_key", 47, 5, "res/private/main-win32/word/key_F1.png")
    GUI:setAnchorPoint(Image_key, 1, 0)

    local Text_cd = GUI:Text_Create(Panel_cell, "Text_cd", width / 2, height / 2, 14, "ff0000", "")
    GUI:setAnchorPoint(Text_cd, 0.5, 0.5)
    GUI:Text_setTextColor(Text_cd, "#ff0000")

    local Node_tx = GUI:Node_Create(Panel_cell, "Node_tx", width / 2, height / 2)
    GUI:setAnchorPoint(Node_tx, 0.5, 0.5)

    return Panel_cell
end