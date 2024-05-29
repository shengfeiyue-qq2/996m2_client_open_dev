PlayerBuff_Look = {}

PlayerBuff_Look._path = "res/buff_icon/"

function PlayerBuff_Look.main()
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "player_look/player_buff_node_win32" or "player_look/player_buff_node")
    PlayerBuff_Look._ui = GUI:ui_delegate(parent)
    PlayerBuff_Look._parent = parent
    if not PlayerBuff_Look._ui then
        return false
    end

    PlayerBuff_Look._lookActorID = SL:GetMetaValue("LOOK_USER_ID")

    PlayerBuff_Look._showBuffData = {}     -- 记录正在显示buff
    PlayerBuff_Look._showBuffCount = 0
    PlayerBuff_Look._qCells = {}

    PlayerBuff_Look._buffList = PlayerBuff_Look._ui.ListView_buff
    PlayerBuff_Look._cellWid = GUI:getContentSize(PlayerBuff_Look._buffList).width
    PlayerBuff_Look._cellHei = isWinMode and 50 or 70

    PlayerBuff_Look._timePrefix = "时间："
    PlayerBuff_Look._olPrefix = "叠加："

    -- 加载内容
    PlayerBuff_Look.OnFillContent()

    SL:RegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "PlayerBuff_Look", PlayerBuff_Look.OnUpdateBuff)
end

function PlayerBuff_Look.CreateBuffCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "player/buff_cell_win32" or "player/buff_cell")
    local layout = GUI:getChildByName(parent, "Panel_cell")
    
    PlayerBuff_Look.UpdateBuffCell(layout, data)

    return layout
end

function PlayerBuff_Look.UpdateBuffCell(layout, data)
    local ui = GUI:ui_delegate(layout)
    -- icon
    local path = string.format("%s%s.png", PlayerBuff_Look._path, data.icon)
    GUI:Button_loadTextureNormal(ui.Button_icon, path)

    -- name 
    GUI:Text_setString(ui.Text_name, data.name or "") 

    -- tips
    local tips = data.tips
    if tips and string.len(tips) > 0 then 
        GUI:setTouchEnabled(ui.Button_icon, true)
        GUI:addOnClickEvent(ui.Button_icon, function(sender)
            local pos = GUI:getTouchEndPosition(sender)
            local str = (data.name or "") .. GUIFunction:GetBuffAddAttrShow(data.id)
            str = str .. "\\" .. tips
            str = string.gsub(str, "%^", "\\")
            local openData = {
                str         = str,
                worldPos    = pos,
                width       = 400,
                anchorPoint = GUI:p(0, 0)
            }
            SL:OpenCommonDescTipsPop(openData)
        end)
    end

    -- time
    local timeText = ui.Text_time
    local olText = ui.Text_ol
    GUI:setVisible(timeText, false)
    GUI:setVisible(olText, false)

    if data.param and data.param > 0 and data.id > 10000 then
        -- 时间
        GUI:setVisible(timeText, true)
        local function callback()
            local remaining = math.max(data.endTime - SL:GetMetaValue("SERVER_TIME"), 0)
            local t = SL:SecondToHMS(remaining)
            local str = string.format("%ss", remaining)
            if t.h > 0 or t.d > 0 then
                str = string.format("%sh", t.d * 24 + t.h)
            elseif t.m > 0 then
                str = string.format("%sm", t.m)
            else
                str = string.format("%ss", t.s)
            end
            GUI:Text_setString(timeText, PlayerBuff_Look._timePrefix .. str)
            
            if remaining <= 0 then
                GUI:stopAllActions(timeText)
                GUI:setVisible(timeText, false)
            end
        end
        GUI:stopAllActions(timeText)
        GUI:schedule(timeText, callback, 1)
        callback()
    end

    -- 叠加
    if data.ol and data.ol > 1 then
        GUI:setVisible(olText, true)
        GUI:Text_setString(olText, PlayerBuff_Look._olPrefix .. data.ol)
    end
end

function PlayerBuff_Look.OnFillContent()
    if not PlayerBuff_Look._lookActorID then
        return
    end
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA", PlayerBuff_Look._lookActorID)
    table.sort(items, function(a, b)
        if a.sort and b.sort then
            return a.sort < b.sort
        elseif not b.sort and a.sort then
            return true
        else
            return false
        end
    end)

    PlayerBuff_Look._showBuffData = {}
    PlayerBuff_Look._showBuffCount = 0
    PlayerBuff_Look._qCells = {}
    for i = 1, #items do
        local v = items[i]
        if v.icon and string.len(v.icon) > 0 and v.other_look == 1 then
            PlayerBuff_Look._showBuffCount = PlayerBuff_Look._showBuffCount + 1
            PlayerBuff_Look._showBuffData[v.id] = v
            local function createCell(parent)
                local cell = PlayerBuff_Look.CreateBuffCell(parent, PlayerBuff_Look._showBuffData[v.id])
                return cell 
            end
            local cell = GUI:QuickCell_Create(PlayerBuff_Look._buffList, "item_" .. i, 0, 0, PlayerBuff_Look._cellWid, PlayerBuff_Look._cellHei, createCell)
            PlayerBuff_Look._qCells[v.id] = cell
        end
    end
end

-- 是否需要重新排序
function PlayerBuff_Look.IsAutoSortBuff()
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA", PlayerBuff_Look._lookActorID)
    local showBuffNum = 0
    local isSortBuff = false
    for i, v in ipairs(items) do
        if v.other_look == 1 then
            if not PlayerBuff_Look._showBuffData[v.id] then
                isSortBuff = true
                break
            end
            PlayerBuff_Look._showBuffData[v.id] = v
            showBuffNum = showBuffNum + 1
        end
    end
    isSortBuff = isSortBuff or showBuffNum ~= PlayerBuff_Look._showBuffCount
    return isSortBuff 
end

function PlayerBuff_Look.OnUpdateBuff(data)
    if not PlayerBuff_Look._lookActorID or PlayerBuff_Look._lookActorID ~= data.actorID then
        return
    end

    if not PlayerBuff_Look._buffList or tolua.isnull(PlayerBuff_Look._buffList) then
        return
    end

    if not PlayerBuff_Look.IsAutoSortBuff(data) then
        local cell = PlayerBuff_Look._qCells[data.buffID]
        if cell then
            GUI:QuickCell_Exit(PlayerBuff_Look._qCells[data.buffID])
            GUI:QuickCell_Refresh(PlayerBuff_Look._qCells[data.buffID])
        end
        return
    end
    
    GUI:ListView_removeAllItems(PlayerBuff_Look._buffList)
    PlayerBuff_Look.OnFillContent()
end

function PlayerBuff_Look.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "PlayerBuff_Look")
end

return PlayerBuff_Look