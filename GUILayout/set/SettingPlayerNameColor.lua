SettingPlayerNameColor = {}

SettingPlayerNameColor._setColorList = {249, 251, 250, 254, 242, 253, 0}

function SettingPlayerNameColor.main()
    local data = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.SettingPlayerNameColorGUI, 0, 0, 0, 0, false, false, true, true)

    GUI:LoadExport(parent, "set/setting_player_name_color")
    SettingPlayerNameColor._ui = GUI:ui_delegate(parent)

    SettingPlayerNameColor._selItem = {}
    SettingPlayerNameColor._setData = SL:CopyData(SL:GetValue("SETTING_PLAYER_NAME_COLOR_VALUE") or {}) -- 获取设置玩家颜色数据
    SettingPlayerNameColor._parent = parent
    SettingPlayerNameColor._qCells = {}
    SettingPlayerNameColor.InitUI(data)
    SettingPlayerNameColor.RegisterEvent()
end

function SettingPlayerNameColor.InitUI(data)
    -- 适配
    local isWinPlayMode = SL:GetValue("IS_PC_OPER_MODE")
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local posY = isWinPlayMode and SL:GetValue("PC_POS_Y") or screenH / 2
    GUI:setPosition(SettingPlayerNameColor._ui.Panel_1, screenW / 2, posY)
    GUI:setContentSize(SettingPlayerNameColor._ui.Panel_cancel, screenW, screenH)
    if not SettingPlayerNameColor._ui then
        return false
    end

    local ui = SettingPlayerNameColor._ui
    SettingPlayerNameColor._listView = ui.ListView_1

    GUI:addOnClickEvent(ui.Button_close, function()
        UIOperator:ClosePlayerNameColorSettingUI()
    end)

    GUI:addOnClickEvent(ui.Panel_cancel, function()
        UIOperator:ClosePlayerNameColorSettingUI()
    end)

    GUI:addOnClickEvent(ui.Button_sure, function()
        SettingPlayerNameColor.SaveSet()
        UIOperator:ClosePlayerNameColorSettingUI()
    end)

    local actors, nPlayer = SL:GetValue("FIND_IN_VIEW_PLAYER_LIST")
    for i = 1, nPlayer do
        SettingPlayerNameColor.AddPlayer({actorID = actors[i]})
    end

    GUI:ListView_jumpToTop(SettingPlayerNameColor._listView)
end

function SettingPlayerNameColor.SaveSet()
    SL:SetValue("SETTING_PLAYER_NAME_COLOR_VALUE", SettingPlayerNameColor._setData)
end

function SettingPlayerNameColor.AddPlayer(data)
    local actorID = data.actorID

    if SL:GetValue("ACTOR_IS_DIE", actorID) then
        return false
    end

    local function createCell(parent)
        return SettingPlayerNameColor.CreatePlayerCell(parent, actorID)
    end 
    local cellWid = SL:GetValue("IS_PC_OPER_MODE") and 440 or 440
    local cellHei = SL:GetValue("IS_PC_OPER_MODE") and 50 or 50
    SettingPlayerNameColor._qCells[actorID] = GUI:QuickCell_Create(SettingPlayerNameColor._listView, "cell" .. actorID, 0, 0, cellWid, cellHei, createCell)
end

function SettingPlayerNameColor.CreatePlayerCell(parent, actorID)
    GUI:LoadExport(parent, "set/setting_player_name_color_cell")

    local cell = GUI:getChildByName(parent, "Panel_cell")
    local ui = GUI:ui_delegate(cell)

    local name = SL:GetValue("ACTOR_NAME", actorID)
    GUI:Text_setString(ui.Text_name, name)

    local setColorID = SettingPlayerNameColor._setData[actorID]
    if setColorID then
        GUI:Text_setTextColor(ui.Text_name, SL:GetHexColorByStyleId(setColorID))
    end

    for i, color in ipairs(SettingPlayerNameColor._setColorList) do
        if ui["Panel_color_" .. i] then
            GUI:Layout_setBackGroundColor(ui["Panel_color_" .. i], SL:GetHexColorByStyleId(color))
            local selectImg = GUI:getChildByID(ui["Panel_color_" .. i], "Image_select")
            if setColorID == color then
                GUI:setVisible(selectImg, setColorID == color)
                SettingPlayerNameColor._selItem[actorID] = i
            end
            GUI:addOnClickEvent(ui["Panel_color_" .. i], function()
                if SettingPlayerNameColor._selItem[actorID] == i then
                    SettingPlayerNameColor._selItem[actorID] = nil
                    GUI:setVisible(selectImg, false)
                else
                    local selectItemIdx = SettingPlayerNameColor._selItem[actorID]
                    if selectItemIdx then
                        local lastSelectImg = GUI:getChildByID(ui["Panel_color_" .. selectItemIdx], "Image_select")
                        GUI:setVisible(lastSelectImg, false)
                    end
                    SettingPlayerNameColor._selItem[actorID] = i
                    GUI:setVisible(selectImg, true)
                end
                local selColorID = SettingPlayerNameColor._selItem[actorID] and SettingPlayerNameColor._setColorList[SettingPlayerNameColor._selItem[actorID]]
                SettingPlayerNameColor._setData[actorID] = selColorID
                GUI:Text_setTextColor(ui.Text_name, selColorID and SL:GetHexColorByStyleId(selColorID) or "#FFFFFF")
            end)
        end
    end
    
    return cell
end

function SettingPlayerNameColor.OnClose(id)
    if id == UIConst.LAYERID.SettingPlayerNameColorGUI then 
        SettingPlayerNameColor.UnRegisterEvent()
    end
end

function SettingPlayerNameColor.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "SettingPlayerNameColor", SettingPlayerNameColor.OnClose) -- 关闭界面
end

function SettingPlayerNameColor.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "SettingPlayerNameColor")
end

SettingPlayerNameColor.main()