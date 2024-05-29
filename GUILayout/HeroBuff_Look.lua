HeroBuff_Look = {}

HeroBuff_Look._path = "res/buff_icon/"

function HeroBuff_Look.main()
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "hero_look/hero_buff_node_win32" or "hero_look/hero_buff_node")
    HeroBuff_Look._ui = GUI:ui_delegate(parent)
    HeroBuff_Look._parent = parent
    if not HeroBuff_Look._ui then
        return false
    end

    HeroBuff_Look._lookActorID = SL:GetMetaValue("LOOK_USER_ID")

    HeroBuff_Look._showBuffData = {}     -- 记录正在显示buff
    HeroBuff_Look._showBuffCount = 0
    HeroBuff_Look._qCells = {}

    HeroBuff_Look._buffList = HeroBuff_Look._ui.ListView_buff
    HeroBuff_Look._cellWid = GUI:getContentSize(HeroBuff_Look._buffList).width
    HeroBuff_Look._cellHei = isWinMode and 50 or 70

    HeroBuff_Look._timePrefix = "时间："
    HeroBuff_Look._olPrefix = "叠加："

    -- 加载内容
    HeroBuff_Look.OnFillContent()

    SL:RegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "HeroBuff_Look", HeroBuff_Look.OnUpdateBuff)
end

function HeroBuff_Look.CreateBuffCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "hero/buff_cell_win32" or "hero/buff_cell")
    local layout = GUI:getChildByName(parent, "Panel_cell")
    
    HeroBuff_Look.UpdateBuffCell(layout, data)

    return layout
end

function HeroBuff_Look.UpdateBuffCell(layout, data)
    local ui = GUI:ui_delegate(layout)
    -- icon
    local path = string.format("%s%s.png", HeroBuff_Look._path, data.icon)
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
            GUI:Text_setString(timeText, HeroBuff_Look._timePrefix .. str)
            
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
        GUI:Text_setString(olText, HeroBuff_Look._olPrefix .. data.ol)
    end
end

function HeroBuff_Look.OnFillContent()
    if not HeroBuff_Look._lookActorID then
        return
    end
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA", HeroBuff_Look._lookActorID)
    table.sort(items, function(a, b)
        if a.sort and b.sort then
            return a.sort < b.sort
        elseif not b.sort and a.sort then
            return true
        else
            return false
        end
    end)

    HeroBuff_Look._showBuffData = {}
    HeroBuff_Look._showBuffCount = 0
    HeroBuff_Look._qCells = {}
    for i = 1, #items do
        local v = items[i]
        if v.icon and string.len(v.icon) > 0 and v.other_look == 1 then
            HeroBuff_Look._showBuffCount = HeroBuff_Look._showBuffCount + 1
            HeroBuff_Look._showBuffData[v.id] = v
            local function createCell(parent)
                local cell = HeroBuff_Look.CreateBuffCell(parent, HeroBuff_Look._showBuffData[v.id])
                return cell 
            end
            local cell = GUI:QuickCell_Create(HeroBuff_Look._buffList, "item_" .. i, 0, 0, HeroBuff_Look._cellWid, HeroBuff_Look._cellHei, createCell)
            HeroBuff_Look._qCells[v.id] = cell
        end
    end
end

-- 是否需要重新排序
function HeroBuff_Look.IsAutoSortBuff()
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA", HeroBuff_Look._lookActorID)
    local showBuffNum = 0
    local isSortBuff = false
    for i, v in ipairs(items) do
        if v.other_look == 1 then
            if not HeroBuff_Look._showBuffData[v.id] then
                isSortBuff = true
                break
            end
            HeroBuff_Look._showBuffData[v.id] = v
            showBuffNum = showBuffNum + 1
        end
    end
    isSortBuff = isSortBuff or showBuffNum ~= HeroBuff_Look._showBuffCount
    return isSortBuff 
end

function HeroBuff_Look.OnUpdateBuff(data)
    if not HeroBuff_Look._lookActorID or HeroBuff_Look._lookActorID ~= data.actorID then
        return
    end

    if not HeroBuff_Look._buffList or tolua.isnull(HeroBuff_Look._buffList) then
        return
    end

    if not HeroBuff_Look.IsAutoSortBuff(data) then
        local cell = HeroBuff_Look._qCells[data.buffID]
        if cell then
            GUI:QuickCell_Exit(HeroBuff_Look._qCells[data.buffID])
            GUI:QuickCell_Refresh(HeroBuff_Look._qCells[data.buffID])
        end
        return
    end
    
    GUI:ListView_removeAllItems(HeroBuff_Look._buffList)
    HeroBuff_Look.OnFillContent()
end

function HeroBuff_Look.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "HeroBuff_Look")
end

return HeroBuff_Look