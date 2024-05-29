HeroBuff = {}

HeroBuff._path = "res/buff_icon/"

function HeroBuff.main()
    local parent = GUI:Attach_Parent()
    local isWinMode = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWinMode and "hero/hero_buff_node_win32" or "hero/hero_buff_node")
    HeroBuff._ui = GUI:ui_delegate(parent)
    HeroBuff._parent = parent
    if not HeroBuff._ui then
        return false
    end

    HeroBuff._showBuffData = {}     -- 记录正在显示buff
    HeroBuff._showBuffCount = 0
    HeroBuff._qCells = {}

    HeroBuff._buffList = HeroBuff._ui.ListView_buff
    HeroBuff._cellWid = GUI:getContentSize(HeroBuff._buffList).width
    HeroBuff._cellHei = isWinMode and 50 or 70

    HeroBuff._timePrefix = "时间："
    HeroBuff._olPrefix = "叠加："

    -- 加载内容
    HeroBuff.OnFillContent()

    SL:RegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "HeroBuff", HeroBuff.OnUpdateBuff)
end

function HeroBuff.CreateBuffCell(parent, data)
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "hero/buff_cell_win32" or "hero/buff_cell")
    local layout = GUI:getChildByName(parent, "Panel_cell")
    
    HeroBuff.UpdateBuffCell(layout, data)

    return layout
end

function HeroBuff.UpdateBuffCell(layout, data)
    local ui = GUI:ui_delegate(layout)
    -- icon
    local path = string.format("%s%s.png", HeroBuff._path, data.icon)
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
            GUI:Text_setString(timeText, HeroBuff._timePrefix .. str)
            
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
        GUI:Text_setString(olText, HeroBuff._olPrefix .. data.ol)
    end
end

function HeroBuff.OnFillContent()
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA", SL:GetMetaValue("HERO_ID"))
    table.sort(items, function(a, b)
        if a.sort and b.sort then
            return a.sort < b.sort
        elseif not b.sort and a.sort then
            return true
        else
            return false
        end
    end)

    HeroBuff._showBuffData = {}
    HeroBuff._showBuffCount = 0
    HeroBuff._qCells = {}
    for i = 1, #items do
        local v = items[i]
        if v.icon and string.len(v.icon) > 0 then
            HeroBuff._showBuffCount = HeroBuff._showBuffCount + 1
            HeroBuff._showBuffData[v.id] = v
            local function createCell(parent)
                local cell = HeroBuff.CreateBuffCell(parent, HeroBuff._showBuffData[v.id])
                return cell 
            end
            local cell = GUI:QuickCell_Create(HeroBuff._buffList, "item_" .. i, 0, 0, HeroBuff._cellWid, HeroBuff._cellHei, createCell)
            HeroBuff._qCells[v.id] = cell
        end
    end
end

-- 是否需要重新排序
function HeroBuff.IsAutoSortBuff()
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA", SL:GetMetaValue("HERO_ID"))
    local showBuffNum = 0
    local isSortBuff = false
    for i, v in ipairs(items) do
        if not HeroBuff._showBuffData[v.id] then
            isSortBuff = true
            break
        end
        HeroBuff._showBuffData[v.id] = v
        showBuffNum = showBuffNum + 1
    end
    isSortBuff = isSortBuff or showBuffNum ~= HeroBuff._showBuffCount
    return isSortBuff 
end

function HeroBuff.OnUpdateBuff(data)
    if SL:GetMetaValue("USER_ID") ~= data.actorID then
        return
    end

    if not HeroBuff._buffList or tolua.isnull(HeroBuff._buffList) then
        return
    end

    if not HeroBuff.IsAutoSortBuff(data) then
        local cell = HeroBuff._qCells[data.buffID]
        if cell then
            GUI:QuickCell_Exit(HeroBuff._qCells[data.buffID])
            GUI:QuickCell_Refresh(HeroBuff._qCells[data.buffID])
        end
        return
    end
    
    GUI:ListView_removeAllItems(HeroBuff._buffList)
    HeroBuff.OnFillContent()
end

function HeroBuff.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "HeroBuff")
end

return HeroBuff