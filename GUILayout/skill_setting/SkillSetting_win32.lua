SkillSetting = {}
SkillSetting._ui = nil
SkillSetting._path = GUIDefine.PATH_RES_PRIVATE .. "player_skill-win32/"

function SkillSetting.main()
    local data   = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.SkillSettingGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "skill_setting/skill_setting_win32")

    SkillSetting._ui = GUI:ui_delegate(parent)
    if not SkillSetting._ui then
        return false
    end

    SkillSetting._parent = parent
    
    SkillSetting._cells = {}
    SkillSetting._key   = 0
    SkillSetting._data  = data
    SkillSetting._key   = data.Key

    local screenW = SL:GetValue("SCREEN_WIDTH")
    GUI:setPosition(SkillSetting._ui["Panel_1"], screenW / 2, SL:GetValue("PC_POS_Y"))

    SkillSetting.InitUI()
    SkillSetting.UpdateCells()
end

function SkillSetting.InitUI()
    GUI:addOnClickEvent(SkillSetting._ui["Button_ok"],function()
        SL:SetValue("SKILL_KEY", SkillSetting._data.MagicID, SkillSetting._key)
        GUI:Win_Close(SkillSetting._parent)
    end)

    GUI:addOnClickEvent(SkillSetting._ui["Button_clear"],function()
        SkillSetting._key = 0
        SkillSetting.UpdateCells()
    end)

    for keyCode = 1, 8 do
        local cell = SkillSetting.CreateCell(keyCode)
        GUI:ListView_pushBackCustomItem(SkillSetting._ui["ListView_1"], cell)
        SkillSetting._cells[keyCode] = cell
    end

    for keyCode = 9, 16 do
        local cell = SkillSetting.CreateCell(keyCode)
        GUI:ListView_pushBackCustomItem(SkillSetting._ui["ListView_2"], cell)
        SkillSetting._cells[keyCode] = cell
    end

    local iconPath  = SL:GetValue("SKILL_RECT_ICON_PATH",SkillSetting._data.MagicID)
    local imageICON = GUI:Image_Create(SkillSetting._ui["Node_1"],"_imageICON_", 0, 0, iconPath)
    GUI:setIgnoreContentAdaptWithSize(imageICON,false)
    GUI:setAnchorPoint(imageICON, 0.5, 0.5)
    GUI:setContentSize(imageICON, 40, 40)
    GUI:Text_setString(SkillSetting._ui["Text_skillName"], SL:GetValue("SKILL_NAME", SkillSetting._data.MagicID))
end

function SkillSetting.UpdateCells()
    local texturePic = SkillSetting._key == 0 and "btn_jnan_2_1.png" or "btn_jnan_2.png"
    GUI:Button_loadTextureNormal(SkillSetting._ui["Button_clear"], SkillSetting._path .. texturePic)

    for k, cell in pairs(SkillSetting._cells) do
        GUI:Button_loadTextureNormal(cell["Button_key"],SkillSetting._path .. (k == SkillSetting._key and "btn_jnan_1_1.png" or "btn_jnan_1.png"))
    end
end

-- 左侧技能列表
function SkillSetting.CreateCell(keyCode)
    local ui = GUI:LoadExportEx2("skill_setting/skill_setting_cell_win32", "Cell_setting")
    GUI:ui_IterChilds(ui, ui)

    GUI:setIgnoreContentAdaptWithSize(ui["Image_key"],true)
    GUI:Image_loadTexture(ui["Image_key"], SkillSetting._path .. string.format("word_lizi_%s.png", keyCode > 8 and keyCode-8 or keyCode+8))

    GUI:addOnClickEvent(ui["Button_key"] ,function()
        SkillSetting._key = keyCode
        SkillSetting.UpdateCells()
    end)

    return ui
end

SkillSetting.main()