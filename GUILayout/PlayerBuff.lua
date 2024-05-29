PlayerBuff = {}

PlayerBuff._path = "res/buff_icon/"

function PlayerBuff.main()
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "player/player_buff_node_win32" or "player/player_buff_node")
    PlayerBuff._ui = GUI:ui_delegate(parent)
    PlayerBuff._parent = parent
    if not PlayerBuff._ui then
        return false
    end

    PlayerBuff._showBuffData = {}     -- 记录正在显示buff
    PlayerBuff._showBuffCount = 0
    PlayerBuff._qCells = {}

    PlayerBuff._buffList = PlayerBuff._ui.ListView_buff
    PlayerBuff._cellWid = GUI:getContentSize(PlayerBuff._buffList).width
    PlayerBuff._cellHei = isWinMode and 50 or 70

    PlayerBuff._timePrefix = "时间："
    PlayerBuff._olPrefix = "叠加："

    -- 加载内容
    PlayerBuff.OnFillContent()

    SL:RegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "PlayerBuff", PlayerBuff.OnUpdateBuff)
end

function PlayerBuff.CreateBuffCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "player/buff_cell_win32" or "player/buff_cell")
    local layout = GUI:getChildByName(parent, "Panel_cell")
    
    PlayerBuff.UpdateBuffCell(layout, data)

    return layout
end

function PlayerBuff.UpdateBuffCell(layout, data)
    local ui = GUI:ui_delegate(layout)
    -- icon
    local path = string.format("%s%s.png", PlayerBuff._path, data.icon)
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
            GUI:Text_setString(timeText, PlayerBuff._timePrefix .. str)
            
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
        GUI:Text_setString(olText, PlayerBuff._olPrefix .. data.ol)
    end
end

function PlayerBuff.OnFillContent()
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA")
    table.sort(items, function(a, b)
        if a.sort and b.sort then
            return a.sort < b.sort
        elseif not b.sort and a.sort then
            return true
        else
            return false
        end
    end)

    PlayerBuff._showBuffData = {}
    PlayerBuff._showBuffCount = 0
    PlayerBuff._qCells = {}
    for i = 1, #items do
        local v = items[i]
        if v.icon and string.len(v.icon) > 0 then
            PlayerBuff._showBuffCount = PlayerBuff._showBuffCount + 1
            PlayerBuff._showBuffData[v.id] = v
            local function createCell(parent)
                local cell = PlayerBuff.CreateBuffCell(parent, PlayerBuff._showBuffData[v.id])
                return cell 
            end
            local cell = GUI:QuickCell_Create(PlayerBuff._buffList, "item_" .. i, 0, 0, PlayerBuff._cellWid, PlayerBuff._cellHei, createCell)
            PlayerBuff._qCells[v.id] = cell
        end
    end
end

-- 是否需要重新排序
function PlayerBuff.IsAutoSortBuff()
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA")
    local showBuffNum = 0
    local isSortBuff = false
    for i, v in ipairs(items) do
        if not PlayerBuff._showBuffData[v.id] then
            isSortBuff = true
            break
        end
        PlayerBuff._showBuffData[v.id] = v
        showBuffNum = showBuffNum + 1
    end
    isSortBuff = isSortBuff or showBuffNum ~= PlayerBuff._showBuffCount
    return isSortBuff 
end

function PlayerBuff.OnUpdateBuff(data)
    if SL:GetMetaValue("USER_ID") ~= data.actorID then
        return
    end

    if not PlayerBuff._buffList or tolua.isnull(PlayerBuff._buffList) then
        return
    end

    if not PlayerBuff.IsAutoSortBuff(data) then
        local cell = PlayerBuff._qCells[data.buffID]
        if cell then
            GUI:QuickCell_Exit(PlayerBuff._qCells[data.buffID])
            GUI:QuickCell_Refresh(PlayerBuff._qCells[data.buffID])
        end
        return
    end
    
    GUI:ListView_removeAllItems(PlayerBuff._buffList)
    PlayerBuff.OnFillContent()
end

function PlayerBuff.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "PlayerBuff")
end

return PlayerBuff