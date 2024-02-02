PlayerSkillSetting = {}----win32 技能设置
PlayerSkillSetting._ui = nil
PlayerSkillSetting._path  = SLDefine.PATH_RES_PRIVATE .. "player_skill-win32/"
PlayerSkillSetting.index = 0
function PlayerSkillSetting.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/skill_setting_win32")
    PlayerSkillSetting._ui = GUI:ui_delegate(parent)
    PlayerSkillSetting._parent = parent
    if not PlayerSkillSetting._ui then
        return false
    end
    
    PlayerSkillSetting._cells = {}
    PlayerSkillSetting._key   = 0
    PlayerSkillSetting._data = data
    PlayerSkillSetting._key  = data.Key

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    GUI:setPosition(PlayerSkillSetting._ui.Panel_1, screenW / 2, SL:GetMetaValue("PC_POS_Y"))

    PlayerSkillSetting.InitUI()
    PlayerSkillSetting.UpdateCells()

    return true
end

function PlayerSkillSetting.InitUI()
    GUI:addOnClickEvent(PlayerSkillSetting._ui.Button_ok,function()
        SL:SetMetaValue("SKILL_KEY",PlayerSkillSetting._data.MagicID, PlayerSkillSetting._key)
        SL:CloseSkillSettingUI()--关闭设置
    end)
    GUI:addOnClickEvent(PlayerSkillSetting._ui.Button_0,function()
        PlayerSkillSetting._key = 0
        PlayerSkillSetting.UpdateCells()
    end)

    for i = 1, 8 do
        local cell = PlayerSkillSetting.CreateCell(PlayerSkillSetting._ui.ListView_1,{key = i})
        PlayerSkillSetting._cells[i] = cell
    end
    for i = 9, 16 do
        local cell = PlayerSkillSetting.CreateCell(PlayerSkillSetting._ui.ListView_2,{key = i})
        PlayerSkillSetting._cells[i] = cell
    end

    local iconPath      = SL:GetMetaValue("SKILL_RECT_ICON_PATH",PlayerSkillSetting._data.MagicID)
    local imageICON     = GUI:Image_Create(PlayerSkillSetting._ui.Node_1,"_imageICON_", 0, 0, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON,false)
    GUI:setAnchorPoint(imageICON, 0.5, 0.5)
    GUI:setContentSize(imageICON, 40, 40)
    GUI:Text_setString(PlayerSkillSetting._ui.Text_skillName, SL:GetMetaValue("SKILL_NAME", PlayerSkillSetting._data.MagicID))
end

function PlayerSkillSetting.UpdateCells()
    GUI:Button_loadTextureNormal(PlayerSkillSetting._ui.Button_0,PlayerSkillSetting._path .. "btn_jnan_2.png")
    if PlayerSkillSetting._key == 0 then
        GUI:Button_loadTextureNormal(PlayerSkillSetting._ui.Button_0,PlayerSkillSetting._path .. "btn_jnan_2_1.png")
    end

    for k, cell in pairs(PlayerSkillSetting._cells) do
        GUI:Button_loadTextureNormal(cell.Button_key,PlayerSkillSetting._path .. (k == PlayerSkillSetting._key and "btn_jnan_1_1.png" or "btn_jnan_1.png"))
    end
end

function PlayerSkillSetting.CreateCell(parent, data)
    PlayerSkillSetting.index = PlayerSkillSetting.index + 1
    local widget =  GUI:Widget_Create(parent, "Cell_"..PlayerSkillSetting.index , 0, 0, 35, 35)
    GUI:LoadExport(widget, "player/skill_setting_cell_win32")
    local ui = GUI:ui_delegate(widget)

    GUI:setIgnoreContentAdaptWithSize(ui.Image_key,true)
    GUI:Image_loadTexture(ui.Image_key,PlayerSkillSetting._path .. string.format("word_lizi_%s.png", data.key > 8 and data.key-8 or data.key+8))

    -- 
    GUI:addOnClickEvent(ui.Button_key ,function()
        PlayerSkillSetting._key = data.key
        PlayerSkillSetting.UpdateCells()
    end)

    return ui
end

return PlayerSkillSettingLayer