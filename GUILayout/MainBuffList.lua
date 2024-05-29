MainBuffList = {}

MainBuffList._path = "res/buff_icon/"

MainBuffList._anchorP = {GUI:p(1, 0), GUI:p(0.5, 0), GUI:p(0, 0), GUI:p(0, 0.5), GUI:p(0, 1), GUI:p(0.5, 1), GUI:p(1, 1), GUI:p(1, 0.5)}

function MainBuffList.main()
    MainBuffList._showBuffData = {} --记录正在显示buff
    local showBuffList = SL:GetMetaValue("GAME_DATA", "ShowBuffList")
    if showBuffList and string.len(showBuffList) > 0 then
        local set = string.split(showBuffList, "|")
        local params = string.split(SL:GetMetaValue("WINPLAYMODE") and set[2] or set[1], "#")
        -- 挂接点#坐标X#坐标Y#宽#高#显示个数#滑动方向#tips方向#倒计时X#倒计时Y#层数X#层数Y#倒计时字体色号#叠加层字体色号#图标大小(0默认)#折叠按钮方向|PC端
        if params[1] and tonumber(params[1]) then
            local data = {}
            data.x  = params[2] and tonumber(params[2]) or 0
            data.y  = params[3] and tonumber(params[3]) or 0
            data.panelWid   = params[4] and tonumber(params[4]) 
            data.panelHei   = params[5] and tonumber(params[5]) 
            data.showNum    = params[6] and tonumber(params[6]) 
            data.direction  = params[7] and tonumber(params[7]) 

            MainBuffList._tipDir    = params[8] and tonumber(params[8]) or 2
            MainBuffList._endOffset = params[9] and params[10] and GUI:p(tonumber(params[9]) or 0, tonumber(params[10] or 0))
            MainBuffList._olOffset  = params[11] and params[12] and GUI:p(tonumber(params[11]) or 0, tonumber(params[12] or 0))
            MainBuffList._endColorID= params[13] and tonumber(params[13])
            MainBuffList._olColorID = params[14] and tonumber(params[14])
            if params[15] and string.find(params[15], "*") then
                local data = string.split(params[15], "*")
                if data[1] and data[2] and tonumber(data[1]) and tonumber(data[2]) then
                    MainBuffList._iconSize = {width = tonumber(data[1]), height = tonumber(data[2])}
                end
            end
            MainBuffList._foldBtnDir = params[16] and tonumber(params[16])
            
            MainBuffList._suiID = tonumber(params[1])
            MainBuffList.CreateBuffPanel(data)
        end
   end
end

function MainBuffList.CreateBuffPanel(data)
    local panelWid    = data.panelWid or 180
    local panelHei    = data.panelHei or 40
    local showNum     = data.showNum or 4
    local direction   = data.direction or 2

    local parent = GUI:Win_FindParent(MainBuffList._suiID)
    local panel = GUI:Layout_Create(parent, "996OfficialBuffPanel", data.x, data.y, panelWid, panelHei)

    local clipPanel = GUI:Layout_Create(panel, "clipPanel", 0, 0, panelWid, panelHei, true)
    if direction == 0 then
        local buffList = GUI:ScrollView_Create(clipPanel, "996OfficalBuffList", 0, 0, panelWid, panelHei, 1)
        GUI:setSwallowTouches(buffList, false)
        MainBuffList._isAutoCol = showNum -- 单行个数

        MainBuffList._cellWid = math.ceil(panelWid / showNum)
        MainBuffList._cellHei = MainBuffList._cellWid
        MainBuffList._totalHei = panelHei

        MainBuffList._buffList = buffList
        MainBuffList.OnFillContent(MainBuffList._isAutoCol)

    else
        local buffList = GUI:ListView_Create(clipPanel, "996OfficalBuffList", 0, 0, panelWid, panelHei, direction)
        GUI:setSwallowTouches(buffList, false)

        if direction == 2 then -- 横
            MainBuffList._cellWid = math.ceil(panelWid / showNum)
            MainBuffList._cellHei = panelHei
        elseif direction == 1 then
            MainBuffList._cellWid = panelWid
            MainBuffList._cellHei = math.ceil(panelHei / showNum)
        end

        MainBuffList._buffList = buffList
        MainBuffList.OnFillContent()
    end

    -- 折叠按钮
    MainBuffList._hide = false
    -- 往左收缩 1
    -- 往右收缩 2
    -- 往上收缩 3
    -- 往下收缩 4
    local dirParam = {
        [1] = {anr = GUI:p(0, 0.5), pos = GUI:p(panelWid, panelHei * 0.5),  moveW = panelWid},
        [2] = {anr = GUI:p(1, 0.5), pos = GUI:p(0, panelHei * 0.5),         moveW = - panelWid},
        [3] = {anr = GUI:p(0.5, 1), pos = GUI:p(panelWid * 0.5, 0),         moveH = - panelHei},
        [4] = {anr = GUI:p(0.5, 0), pos = GUI:p(panelWid * 0.5, panelHei),  moveH = panelHei},
    }

    local foldPathF = "res/private/main/buff_fold%s.png"
    if MainBuffList._foldBtnDir and MainBuffList._foldBtnDir ~= 0 then
        local pos =  dirParam[MainBuffList._foldBtnDir].pos
        local anr =  dirParam[MainBuffList._foldBtnDir].anr
        local foldBtn = GUI:Button_Create(panel, "foldBtn", pos.x, pos.y, string.format(foldPathF, ""))
        GUI:setAnchorPoint(foldBtn, anr.x, anr.y)
        GUI:addOnClickEvent(foldBtn, function()
            MainBuffList._hide = not MainBuffList._hide
            if MainBuffList._foldBtnDir == 1 or MainBuffList._foldBtnDir == 2 then
                local moveW = dirParam[MainBuffList._foldBtnDir].moveW
                local movePos = GUI:p(- (MainBuffList._hide and moveW or 0), 0)
                GUI:Timeline_EaseSineIn_MoveTo(MainBuffList._buffList, movePos, 0.2, function()
                    GUI:setVisible(MainBuffList._buffList, not MainBuffList._hide)
                end)
                local btnMovePos = GUI:p(pos.x - (MainBuffList._hide and moveW or 0), pos.y)
                GUI:Timeline_MoveTo(foldBtn, btnMovePos, 0.2, function()
                    GUI:Button_loadTextureNormal(foldBtn, string.format(foldPathF, MainBuffList._hide and "_1" or ""))
                end)
            else
                local moveH = dirParam[MainBuffList._foldBtnDir].moveH
                local movePos = GUI:p(0, - (MainBuffList._hide and moveH or 0))
                GUI:Timeline_EaseSineIn_MoveTo(MainBuffList._buffList, movePos, 0.2, function()
                    GUI:setVisible(MainBuffList._buffList, not MainBuffList._hide)
                end)
                local btnMovePos = GUI:p(pos.x, pos.y - (MainBuffList._hide and moveH or 0))
                GUI:Timeline_MoveTo(foldBtn, btnMovePos, 0.2, function()
                    GUI:Button_loadTextureNormal(foldBtn, string.format(foldPathF, MainBuffList._hide and "_1" or ""))
                end)
            end

            GUI:delayTouchEnabled(foldBtn)
        end)
        MainBuffList._foldBtn = foldBtn
        GUI:setVisible(MainBuffList._foldBtn, #GUI:getChildren(MainBuffList._buffList) > 0)
    end

    SL:RegisterLUAEvent(LUA_EVENT_BUFFUPDATE, "MainBuffList", MainBuffList.OnUpdateBuff)
end

function MainBuffList.CreateBuffCell(data, parent)
    local cellWid = MainBuffList._cellWid or 45
    local cellHei = MainBuffList._cellHei or 40

    local layout = GUI:Layout_Create(parent or -1, "cell_panel", 0, 0, cellWid, cellHei)
    
    MainBuffList.UpdateBuffCell(layout, data)

    return layout
end

-- 刷新cell
function MainBuffList.UpdateBuffCell(layout, data)
    local cellWid = MainBuffList._cellWid or 45
    local cellHei = MainBuffList._cellHei or 40

    -- icon
    local path = string.format("%s%s.png", MainBuffList._path, data.icon)
    local icon = GUI:getChildByName(layout, "icon") or GUI:Image_Create(layout, "icon", cellWid / 2, cellHei / 2, path)
    GUI:setAnchorPoint(icon, 0.5, 0.5)
    if MainBuffList._iconSize then
        GUI:setContentSize(icon, MainBuffList._iconSize.width, MainBuffList._iconSize.height)
    end

    -- time
    local offsetX = MainBuffList._endOffset and MainBuffList._endOffset.x or 0
    local offsetY = MainBuffList._endOffset and MainBuffList._endOffset.y or 0
    local fontSize = SL:GetMetaValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
    local fontColor = MainBuffList._endColorID and SL:GetHexColorByStyleId(MainBuffList._endColorID) or "#FFFF00"
    local timeText = GUI:getChildByName(layout, "timeText") or GUI:Text_Create(layout, "timeText", cellWid / 2 + offsetX, cellHei * 0.2 + offsetY, fontSize, fontColor, "")
    GUI:setAnchorPoint(timeText, 0.5, 0.5)
    GUI:Text_enableOutline(timeText, "#000000", 1)

    -- 叠加
    local offsetX = MainBuffList._olOffset and MainBuffList._olOffset.x or 0
    local offsetY = MainBuffList._olOffset and MainBuffList._olOffset.y or 0
    local fontSize = SL:GetMetaValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
    local fontColor = MainBuffList._olColorID and SL:GetHexColorByStyleId(MainBuffList._olColorID) or "#FFFFFF"
    local iconS = GUI:getContentSize(icon)
    local olText = GUI:getChildByName(icon, "olText") or GUI:Text_Create(icon, "olText", iconS.width + offsetX, iconS.height + offsetY, fontSize, fontColor, "")
    GUI:setAnchorPoint(olText, 1, 1)
    GUI:Text_enableOutline(olText, "#000000", 1)

    -- tips
    local tips = data.tips
    if tips and string.len(tips) > 0 then 
        GUI:setTouchEnabled(layout, true)
        GUI:addOnClickEvent(layout, function(sender)
            local pos = GUI:getTouchEndPosition(sender)
            local str = (data.name or "") .. "\\" .. tips
            str = string.gsub(str, "%^", "\\")
            local openData = {
                str         = str,
                worldPos    = pos,
                width       = 400,
                anchorPoint = MainBuffList._tipDir and MainBuffList._anchorP[MainBuffList._tipDir + 1] or GUI:p(0, 0)
            }
            SL:OpenCommonDescTipsPop(openData)
        end)
    end

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
            GUI:Text_setString(timeText, str)
            
            if remaining <= 0 then
                GUI:stopAllActions(timeText)
                GUI:setVisible(timeText, false)
            end
        end
        GUI:stopAllActions(timeText)
        GUI:schedule(timeText, callback, 1)
        callback()
    end

    if data.ol and data.ol > 0 then
        GUI:setVisible(olText, true)
        GUI:Text_setString(olText, data.ol)
    end
end

function MainBuffList.OnFillContent(isAutoCol)
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

    MainBuffList._showBuffData = {}
    MainBuffList._showBuffCount = #items
    for i = 1, #items do
        local v = items[i]
        if v.icon and string.len(v.icon) > 0 then
            MainBuffList._showBuffData[v.id] = v
            local function createCell(parent)
                local cell = MainBuffList.CreateBuffCell(v, parent)
                return cell 
            end
            local cell = GUI:QuickCell_Create(MainBuffList._buffList, "item_" .. i, 0, 0, MainBuffList._cellWid, MainBuffList._cellHei, createCell)
            GUI:setTag(cell, v.id)
            if isAutoCol then
                local row = math.ceil(i / isAutoCol)
                local posX = MainBuffList._cellWid * ((i - 1) % isAutoCol)
                local posY = MainBuffList._totalHei - MainBuffList._cellHei * row
                GUI:setPosition(cell, posX, posY)
            end
        end
    end
end

-- 是否需要重新排序
function MainBuffList.IsAutoSortBuff(data)
    local items = SL:GetMetaValue("ACTOR_BUFF_DATA")
    local isSortBuff = #items ~= MainBuffList._showBuffCount
    for i, v in ipairs(items) do
        if not MainBuffList._showBuffData[v.id] then
            isSortBuff = true
            break
        end
        MainBuffList._showBuffData[v.id] = v
    end
    return isSortBuff
end

function MainBuffList.OnUpdateBuff(data)
    if SL:GetMetaValue("USER_ID") ~= data.actorID then
        return
    end

    if not MainBuffList._buffList or tolua.isnull(MainBuffList._buffList) then
        return
    end

    if not MainBuffList.IsAutoSortBuff(data) then
        local cell = GUI:getChildByTag(MainBuffList._buffList, data.buffID)
        local layout = cell and GUI:getChildByName(cell, "cell_panel") or nil
        if layout then
            MainBuffList.UpdateBuffCell(layout, MainBuffList._showBuffData[data.buffID])
        end
        return
    end

    if MainBuffList._isAutoCol then
        GUI:ScrollView_removeAllChildren(MainBuffList._buffList)
    else
        GUI:ListView_removeAllItems(MainBuffList._buffList)
    end
    MainBuffList.OnFillContent(MainBuffList._isAutoCol)
    if MainBuffList._foldBtn then
        GUI:setVisible(MainBuffList._foldBtn, #GUI:getChildren(MainBuffList._buffList) > 0)
    end
end