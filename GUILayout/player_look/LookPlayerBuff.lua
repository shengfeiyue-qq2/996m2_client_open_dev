LookPlayerBuff = {}

LookPlayerBuff._path = "res/buff_icon/"

local isPC = SL:GetValue("IS_PC_OPER_MODE")

function LookPlayerBuff.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, isPC and "player_look/player_buff_node_win32" or "player_look/player_buff_node")

    LookPlayerBuff._ui = GUI:ui_delegate(parent)
    if not LookPlayerBuff._ui then
        return false
    end

    LookPlayerBuff._lookActorID = LookPlayerData.GetPlayerUID()

    LookPlayerBuff._showBuffData = {}     -- 记录正在显示buff
    LookPlayerBuff._showBuffCount = 0
    LookPlayerBuff._qCells = {}

    LookPlayerBuff._buffList = LookPlayerBuff._ui.ListView_buff
    LookPlayerBuff._cellWid = GUI:getContentSize(LookPlayerBuff._buffList).width
    LookPlayerBuff._cellHei = isPC and 50 or 70

    LookPlayerBuff._timePrefix = "时间："
    LookPlayerBuff._olPrefix = "叠加："

    -- 加载内容
    LookPlayerBuff.OnFillContent()

    SL:AttachTXTSUI({root = parent, index = SLDefine.SUIComponentTable.PlayerBuffO})

    SL:RegisterLUAEvent(LUA_EVENT_BUFF_UPDATE, "LookPlayerBuff", LookPlayerBuff.OnUpdateBuff)
end

function LookPlayerBuff.CreateBuffCell(parent, data)
    GUI:LoadExport(parent, SL:GetValue("IS_PC_OPER_MODE") and "player/buff_cell_win32" or "player/buff_cell")
    local layout = GUI:getChildByName(parent, "Panel_cell")
    
    LookPlayerBuff.UpdateBuffCell(layout, data)

    return layout
end

function LookPlayerBuff.UpdateBuffCell(layout, data)
    local ui = GUI:ui_delegate(layout)
    -- icon
    local path = string.format("%s%s.png", LookPlayerBuff._path, data.icon)
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
            UIOperator:OpenCommonDescTipsUI(openData)
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
            local remaining = math.max(data.endTime - SL:GetValue("SERVER_TIME"), 0)
            local t = SL:SecondToHMS(remaining)
            local str = string.format("%ss", remaining)
            if t.h > 0 or t.d > 0 then
                str = string.format("%sh", t.d * 24 + t.h)
            elseif t.m > 0 then
                str = string.format("%sm", t.m)
            else
                str = string.format("%ss", t.s)
            end
            GUI:Text_setString(timeText, LookPlayerBuff._timePrefix .. str)
            
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
        GUI:Text_setString(olText, LookPlayerBuff._olPrefix .. data.ol)
    end
end

function LookPlayerBuff.OnFillContent()
    if not LookPlayerBuff._lookActorID then
        return
    end
    local items = SL:GetValue("ACTOR_BUFF_DATA", LookPlayerBuff._lookActorID)
    table.sort(items, function(a, b)
        if a.sort and b.sort then
            return a.sort < b.sort
        elseif not b.sort and a.sort then
            return true
        else
            return false
        end
    end)

    LookPlayerBuff._showBuffData = {}
    LookPlayerBuff._showBuffCount = 0
    for i = 1, #items do
        local v = items[i]
        if v.icon and string.len(v.icon) > 0 and v.other_look == 1 then
            LookPlayerBuff._showBuffCount = LookPlayerBuff._showBuffCount + 1
            LookPlayerBuff._showBuffData[v.id] = v
            local function createCell(parent)
                local cell = LookPlayerBuff.CreateBuffCell(parent, LookPlayerBuff._showBuffData[v.id])
                return cell 
            end
            local cell = GUI:QuickCell_Create(LookPlayerBuff._buffList, "item_" .. i, 0, 0, LookPlayerBuff._cellWid, LookPlayerBuff._cellHei, createCell)
            LookPlayerBuff._qCells[v.id] = cell
        end
    end
end

-- 是否需要重新排序
function LookPlayerBuff.IsAutoSortBuff()
    local items = SL:GetValue("ACTOR_BUFF_DATA", LookPlayerBuff._lookActorID)
    local showBuffNum = 0
    local isSortBuff = false
    for i, v in ipairs(items) do
        if v.other_look == 1 then
            if not LookPlayerBuff._showBuffData[v.id] then
                isSortBuff = true
                break
            end
            LookPlayerBuff._showBuffData[v.id] = v
            showBuffNum = showBuffNum + 1
        end
    end
    isSortBuff = isSortBuff or showBuffNum ~= LookPlayerBuff._showBuffCount
    return isSortBuff 
end

function LookPlayerBuff.OnUpdateBuff(data)
    if not LookPlayerBuff._lookActorID or LookPlayerBuff._lookActorID ~= data.actorID then
        return
    end

    if not LookPlayerBuff._buffList or tolua.isnull(LookPlayerBuff._buffList) then
        return
    end

    if not LookPlayerBuff.IsAutoSortBuff(data) then
        local cell = LookPlayerBuff._qCells[data.buffID]
        if cell then
            GUI:QuickCell_Exit(cell)
            GUI:QuickCell_Refresh(cell)
        end
        return
    end
    
    GUI:ListView_removeAllItems(LookPlayerBuff._buffList)
    LookPlayerBuff.OnFillContent()
end

function LookPlayerBuff.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_BUFF_UPDATE, "LookPlayerBuff")

    SL:UnAttachTXTSUI({
        index = SLDefine.SUIComponentTable.PlayerBuffO
    })
end

LookPlayerBuff.main()