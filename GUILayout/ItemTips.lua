ItemTips = {}

local screenW = SL:GetScreenWidth()
local screenH = SL:GetScreenHeight()

local ItemFrom = SL:GetItemForm()
local FormHero = {
    [ItemFrom.HERO_EQUIP] = true,
    [ItemFrom.HERO_BAG] = true,
    [ItemFrom.HERO_BEST_RINGS] = true
}

local FromEquip = {
    [ItemFrom.PALYER_EQUIP] = true,
    [ItemFrom.BEST_RINGS] = true,
    [ItemFrom.HERO_EQUIP] = true,
    [ItemFrom.HERO_BEST_RINGS] = true
}

-- 自定义装备比较用
local CustomEquipPosByStdMode = {
    [10001] = 71
}

-- 玩家和英雄的装备位置信息共用一份
local GetEquipPosByStdModeList = function (stdMode)
    return GUIShare.EquipPosByStdMode[stdMode]
end

local function IsEquip(itemData)
    return SL:GetItemTypeByData(itemData) == SL:GetItemType().Equip
end

-- 按钮显示开关配置（cfg_game_data 表 BackpackGuide 字段）   
-- switchType (1: 佩戴    2: 拆分   3: 不显示按钮) 
local function IsOpenSwitch(switchType, StdMode)
    if not switchType then return false end

    if not ItemTips._Switch then
        ItemTips._Switch = {}
        local BackpackGuide = SL:GetGameDataCfg().BackpackGuide
        if BackpackGuide then
            local guide = SL:Split(BackpackGuide, "#") --拆分/佩戴开关
            for i,v in ipairs(guide) do
                if i == 3 then
                    ItemTips._Switch[3] = ItemTips._Switch[3] or {}
                    
                    local stdModes = string.split(v or "","|")
                    for _,stdMode in ipairs(stdModes) do
                        if stdMode and string.len(stdMode) > 0 then
                            ItemTips._Switch[3][tonumber(stdMode)] = tonumber(stdMode)
                        end
                    end
                else
                    if v and string.len(v) > 0 then
                        ItemTips._Switch[i] = v and tonumber(v) or 0
                    end
                end
            end
        end
    end

    if switchType ~= 3 then
        return ItemTips._Switch[switchType] == 1
    end

    if not StdMode then
        return false
    end

    if not ItemTips._Switch[3] then
        return true
    end

    return ItemTips._Switch[3][StdMode] == nil
end

local _PathRes       = "res/private/item_tips/"
local _TotalWidth    = 800
local _TextSize      = 16
local _TipsMaxH      = screenH - 150
local _PanelNum      = 0
local _DefaultSpace  = 10
local _lookPlayer    = false    -- 默认是自己
local _IsHeroEquip   = false
local fontPath       = SL:IsWinMode() and "" or "fonts/font2.ttf"

function ItemTips.main(data)
    local parent  = GUI:Attach_Parent()
    local itemData = data.itemData or SL:GetItemDataByIndex(data.Index)
    ItemTips._data = data

    local PMainUI = GUI:Layout_Create(parent, "PMainUI",0, 0, screenW, screenH)
    ItemTips._PMainUI = PMainUI
    GUI:setTouchEnabled(PMainUI, true)
    GUI:setSwallowTouches(PMainUI, false)
    GUI:addOnClickEvent(PMainUI, function () SL:CloseItemTips() end)

    _lookPlayer = data.lookPlayer

    -- 道具类型
    if IsEquip(itemData) then
        ItemTips.GetEquipTips(data)
    else
        ItemTips.GetItemTips(data, itemData)
    end
end

function ItemTips.GetEquipTips(data)
    local from = ItemTips._data.from
    -- 是否是英雄装备
    _IsHeroEquip = from and FormHero[from] or false
    
    -- 装备1
    local itemData  = data.itemData or SL:GetItemDataByIndex(data.Index)
    -- 装备2
    local itemData2 = data.itemData2
    -- 装备3
    local itemData3 = data.itemData3

    local checkSet = SL:CheckSet(36) == 1
    if checkSet and (from == ItemFrom.BAG or from == ItemFrom.AUTO_TRADE) then
        local cpEquips = ItemTips.GetCompareEquip(itemData)
        if cpEquips and #cpEquips > 0 then
            local dData = SL:CopyData(data)
            dData.diff = true
            
            -- 对比身上的装备
            if cpEquips[1] then
                ItemTips.CreateEquipPanel(dData, cpEquips[1], false, true)
            end
            if cpEquips[2] then
                ItemTips.CreateEquipPanel(dData, cpEquips[2], false, true)
            end
        end
    end
    
    if itemData2 then
        if IsEquip(itemData2) then
            ItemTips.CreateEquipPanel(data, itemData2)
        end
    end
    if itemData3 then
        if IsEquip(itemData3) then
            ItemTips.CreateEquipPanel(data, itemData3)
        end
    end

    ItemTips.CreateEquipPanel(data, itemData)
end

------------  装备tips  ------------------------------------------------
function ItemTips.CreateEquipPanel(data, itemData, isWear, isCompare)
    local pos = data.pos or {x = screenW / 2, y = screenH / 2}
    local anr = data.anchorPoint or {x = 0, y = 1}

    local TList = GUI:getChildByName(ItemTips._PMainUI, "TList")
    if not TList then
        TList = GUI:ListView_Create(ItemTips._PMainUI, "TList", pos.x, pos.y, 0, 0, 2)
        GUI:ListView_setClippingEnabled(TList, false)
        GUI:setTouchEnabled(TList, false)
        GUI:ListView_setGravity(TList, 3)
        GUI:setAnchorPoint(TList, anr)
        GUI:ListView_setItemsMargin(TList, 0)
    end

    _PanelNum = _PanelNum + 1
    local ListBg = GUI:Layout_Create(TList, "ListBg".._PanelNum, 0, 0, 135, 173)
    GUI:Layout_setBackGroundImageScale9Slice(ListBg, 44, 57, 47, 59)
    GUI:Layout_setBackGroundImage(ListBg, _PathRes.."bg_tipszy_05.png")
    GUI:setAnchorPoint(ListBg, anr)
    GUI:setTouchEnabled(ListBg, false)

    local richWidth = _TotalWidth - 20
    local ww = 0
    local hh = 0

    local ListView = GUI:ListView_Create(ListBg, "ListView", 15, 10, 0, 0, 1)
    GUI:ListView_setItemsMargin(ListView, 0)
    GUI:setTouchEnabled(ListView, false)

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255

    -- 道具名字
    local title = itemData.Name or ""
    local r_name = GUI:RichText_Create(ListView, "r_name", 0, 0, title, richWidth, _TextSize, SL:GetColorByID(color), nil, nil, fontPath)
    ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)

    local size = GUI:getContentSize(r_name)
    ww = math.max(ww, size.width)
    hh = hh + size.height + _DefaultSpace

    -- 星级
    --[[
        local PanelStar = ItemTips.GetStarPanel(ListView, itemData.Star)
        if PanelStar then
            size = GUI:getContentSize(PanelStar)
            ww = math.max(ww, size.width)
            hh = hh + size.height
        end
    --]]

    -- 绑定玩家 别人不能穿
    local isBindUser = itemData.BindInfo and string.len(itemData.BindInfo) > 0
    if isBindUser then
        local r_bindUser = GUI:RichText_Create(ListView, "r_bindUser", 0, 0, string.format("已绑定[%s]", itemData.BindInfo), richWidth, _TextSize, color, nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(r_bindUser).height + _DefaultSpace
    end

    -- 绑定 不能掉
    local isBind = itemData.Bind and string.len(itemData.Bind) > 0
    if isBind then
        local r_bind = GUI:RichText_Create(ListView, "r_bind", 0, 0, "已绑定", richWidth, _TextSize, color, nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(r_bind).height + _DefaultSpace
    end
    
    -- 道具图标
    local IconBg = GUI:Image_Create(ListView, "IconBg", 0, 0, _PathRes.."1900025001.png")
    local IconBgSz = GUI:getContentSize(IconBg)
    local Icon = GUI:ItemShow_Create(IconBg, "Icon", IconBgSz.width / 2, IconBgSz.height / 2, {
        index = itemData.Index
    })
    GUI:setAnchorPoint(Icon, 0.5, 0.5)
    ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
    hh = hh + IconBgSz.height + _DefaultSpace

    -- 类型
    local typeStr = ItemTips.GetTypeStr(itemData)
    if typeStr and string.len(typeStr) > 0 then
        local wx = IconBgSz.width + 10
        local wy = IconBgSz.height * 0.7
        local r_type = GUI:RichText_Create(Icon, "r_type", wx, wy, typeStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        GUI:setAnchorPoint(r_type, 0, 0.5)

        ww = math.max(ww, GUI:getContentSize(r_type).width + wx + 10)
    end

    -- 需求
    local needStr = ItemTips.GetNeedStr(itemData)
    local needww  = 0
    if needStr then
        local wx = IconBgSz.width + 10
        local wy = IconBgSz.height * 0.3
        local r_need = GUI:RichText_Create(Icon, "r_need", wx, wy, needStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        GUI:setAnchorPoint(r_need, 0, 0.5)

        ww = math.max(ww, GUI:getContentSize(r_need).width + wx + 10)
        needww = GUI:getContentSize(r_need).width
    end

    -- 职业
    local jobStr = ItemTips.GetJobStr(itemData)
    if jobStr then
        local wx = IconBgSz.width + needww + 40
        local wy = IconBgSz.height * 0.7
        local r_job = GUI:RichText_Create(Icon, "r_job", wx, wy, jobStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        GUI:setAnchorPoint(r_job, 0, 0.5)

        ww = math.max(ww, GUI:getContentSize(r_job).width + wx)
    end

    -- 重量
    -- local isWeight = itemData.Weight and itemData.Weight > 0
    -- if isWeight then
    --     local str = string.format("重量：%s", itemData.Weight)
    --     local wx = IconBgSz.width + 10
    --     local wy = IconBgSz.height * 0.7
    --     local r_weight = GUI:RichText_Create(Icon, "r_weight", wx, wy, str, richWidth, nil, "#FFFFFF")
    --     GUI:setAnchorPoint(r_weight, 0, 0.5)

    --     ww = math.max(ww, GUI:getContentSize(r_weight).width + wx + 10)
    -- end

    -- 其他的属性
    -- local aStr = ItemTips.GetOtherAttrStr(itemData)
    -- if aStr then
    --     local wx = IconBgSz.width + 10
    --     local wy = IconBgSz.height * 0.3
    --     local r_mode = GUI:RichText_Create(Icon, "r_mode", wx, wy, aStr, richWidth, nil, "#FFFFFF")
    --     GUI:setAnchorPoint(r_mode, 0, 0.5)

    --     ww = math.max(ww, GUI:getContentSize(r_mode).width + wx + 10)
    -- end

    -------------------------------------------------------------------------------------------------------
    -- 基础属性
    local baseAttList = GUIShare.ParseAttList(GUIShare.ParseBaseAtt(itemData.attribute))
    
    -- 极品加成属性
    local attExtra = GUIShare.ParseAttList(GUIShare.GetCustomAttByType(itemData, GUIShare._CusTomAttType.ADD))
    if GUIShare.IsAddToBaseAtt then
        baseAttList = GUIShare.CombineToBaseAtt(baseAttList, attExtra)
    end

    GUIShare.AttSort(baseAttList)
    GUIShare.AttSort(attExtra)
    
    local baseAttStr = ""
    if next(baseAttList) then
        baseAttStr = string.format("<font color='%s'>%s</font>", SL:GetColorByID(154), "[基础属性]：") .. "<br>"
    end
    
    local function _GetAttExtraValue(attID)
        for i,v in ipairs(attExtra) do
            if v.attID == attID then
                local vvalue = v.value
                local v1 = string.find(vvalue, "%/") and SL:Split(vvalue, "/") or SL:Split(vvalue, "-")
                local v1_val1 = tonumber(v1[1]) or 0
                local v1_val2 = tonumber(v1[2]) or 0

                if v1_val1 > 0 and v1_val2 > 0 then        
                    return "[".. v1_val1 .. "-" .. v1_val2 .. "]"
                end
                if v1_val1 > 0 then
                    return v1_val1
                end
                if v1_val2 > 0 then
                    return v1_val2
                end
            end
        end
    end

    for _,v in ipairs(baseAttList) do
        local color = SL:GetColorByID(v.color)
        local names = v.name .. v.value
        local str = string.format("<font color='%s'>%s</font>", SL:GetColorByID(color), names)
        
        local extraStr = _GetAttExtraValue(v.attID)
        if GUIShare.IsAddToBaseAtt and extraStr then
            str = str .. string.format("<font color='%s'>(+%s)</font>", SL:GetColorByID(1037), extraStr)
        end
        baseAttStr = baseAttStr .. str .. "<br>"
    end

    --负重
    if itemData.AniCount and itemData.AniCount > 0 and 
        (itemData.StdMode == 52 
            or itemData.StdMode == 62 
                or itemData.StdMode == 54 
                    or itemData.StdMode == 64 
                        or itemData.StdMode == 84 
                            or itemData.StdMode == 85 
                                or itemData.StdMode == 86 
                                    or itemData.StdMode == 87) then

        baseAttStr = baseAttStr .. string.format("<font color='%s'>%s</font>", SL:GetColorByID(1039), string.format("负重：+%s", itemData.AniCount))
    end
    
    if string.len(baseAttStr) > 0 then
        local r_att1 = GUI:RichText_Create(ListView, "r_att1", 0, 0, baseAttStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)

        size = GUI:getContentSize(r_att1)
        ww = math.max(ww, size.width)
        hh = hh + size.height + _DefaultSpace
    end

    if not GUIShare.IsAddToBaseAtt and attExtra and next(attExtra) then
        local extraAttStr = ""
        if next(attExtra) then
            extraAttStr = string.format("<font color='%s'>%s</font>", SL:GetColorByID(154), "[额外属性]：") .. "<br>"
        end
        
        for _,v in ipairs(attExtra) do
            local color = SL:GetColorByID(v.color)
            local names = v.name .. v.value
            local str = string.format("<font color='%s'>%s</font>", SL:GetColorByID(color), names)
            extraAttStr = extraAttStr .. str .. "<br>"
        end

        local r_extra = GUI:RichText_Create(ListView, "r_extra", 0, 0, extraAttStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)

        size = GUI:getContentSize(r_extra)
        ww = math.max(ww, size.width)
        hh = hh + size.height + _DefaultSpace
    end

    -------------------------------------------------------------------------------------------------------
    local ListSuitBg = nil
    local ListSuit   = nil
    local listSuitSize = {
        width = 0, height = 0
    }

    -- 套装属性
    local suitArr = SL:Split(itemData.Suit or "", "#")
    for k,suitID in ipairs(suitArr) do
        suitID = tonumber(suitID) or 0
        if suitID > 0 then
            
            if GUIShare.IsShowSuitCombine and not ListSuitBg then
                ListSuitBg = GUI:Layout_Create(TList, "ListSuitBg".._PanelNum, 0, 0, 135, 173)
                GUI:Layout_setBackGroundImageScale9Slice(ListSuitBg, 44, 57, 47, 59)
                GUI:Layout_setBackGroundImage(ListSuitBg, _PathRes.."bg_tipszy_05.png")
                GUI:setTouchEnabled(ListSuitBg, false)

                ListSuit = GUI:ListView_Create(ListSuitBg, "ListSuit", 15 , 10, 0, 0, 1)
            end

            local suitStr = ItemTips.GetSuitStr(suitID, itemData)
            if ListSuit then
                local r_suit = GUI:RichText_Create(ListSuit, "r_suit"..k, 0, 0, suitStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)

                size = GUI:getContentSize(r_suit)
                listSuitSize.width = math.max(size.width, listSuitSize.width)
                listSuitSize.height = listSuitSize.height + size.height
            else
                local r_suit = GUI:RichText_Create(ListView, "r_suit"..k, 0, 0, suitStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
                ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)

                size = GUI:getContentSize(r_suit)
                ww = math.max(ww, size.width)
                hh = hh + size.height + _DefaultSpace
            end
        end
    end


    if ListSuit then
        GUI:setContentSize(ListSuit, listSuitSize)
        GUI:setContentSize(ListSuitBg, {width = listSuitSize.width + 30, height = listSuitSize.height + 20})
    end

    -- 装备穿戴状态
    if data.diff then
        -- local r_equip = GUI:RichText_Create(ListView, "r_equip", 0, 0, "[当前身上装备]", richWidth, _TextSize)
        local nameSize = GUI:getContentSize(r_name)
        local wx = nameSize.width + 50
        local wy = nameSize.height / 2
        local wMask = GUI:Image_Create(r_name, "wMask", wx, wy, "res/public/word_bqzy_08.png")
        GUI:setAnchorPoint(wMask, 0, 0.5)

        local wMaskWidth = GUI:getContentSize(wMask).width
        if wMaskWidth + wx < ww then
            GUI:setPositionX(wMask, ww - wMaskWidth)
        else
            ww = wMaskWidth + wx
        end
    end

    -- 倒计时
    local endTime = ItemTips.GetEndTime(1, itemData)
    if endTime then
        local time = math.max(endTime - SL:GetCurServerTime(), 0)
        if time < 1 then
            return SL:CloseItemTips()
        end

        local function getTimeStr(time)
            return string.format("限时装备：%s", SL:TimeFormatToStr(time))
        end

        local Text_time = GUI:Text_Create(ListView, "Text_time", 0, 0, _TextSize, "#28EF01", getTimeStr(time))
        GUI:setAnchorPoint(Text_time, 0, 0.5)

        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(Text_time).height + _DefaultSpace
        ww = math.max(ww, GUI:getContentSize(Text_time).width)

        -- 小于一天才显示倒计时
        local day = math.floor(time / 86400)
        if day < 1 then
            local function showTime()
                local time = math.max(endTime - SL:GetCurServerTime(), 0)
                if time > 0 then
                    GUI:Text_setString(Text_time, string.format("限时装备：%s", SL:TimeFormatToStr(time)))
                else
                    SL:CloseItemTips()
                end
            end

            SL:schedule(Text_time, showTime, 1)
        end
    end

    -- 描述
    local desc = itemData.Desc
    if desc and string.len(desc) > 0 then
        local r_desc = GUI:RichText_Create(ListView, "r_desc", 0, 0, desc, ww + 10, _TextSize, "#FFFFFF", nil, nil, fontPath)

        size = GUI:getContentSize(r_desc)
        ww = math.max(ww, size.width)
        hh = hh + size.height
    end

    local ListBgWidth = ww + 30

    local btnhh = 0
    local isBtn = false
    if isWear ~= false and data and data.from == ItemFrom.BAG and not SL:IsWinMode() then
        if IsOpenSwitch(1) then
            local btn = ItemTips.addButton(ListBg, itemData, 1)
            local btnSize = GUI:getContentSize(btn)
            btnhh = btnSize.height + 20
            GUI:setPositionX(btn, ListBgWidth - 10)
            GUI:setPositionY(btn, 10)
            isBtn = true
        end
    end

    -- 可视高度
    local visiblehh = math.min(hh, _TipsMaxH)
    GUI:setContentSize(ListView, {width = ww, height = visiblehh})
    if isBtn then
        GUI:setContentSize(ListBg, {width = ListBgWidth, height = visiblehh + 10 + btnhh})
        GUI:setPositionY(ListView, btnhh)
    else
        GUI:setContentSize(ListBg, {width = ListBgWidth, height = visiblehh + 20})
        GUI:setPositionY(ListView, 10)
    end
    
    local isScroll = hh > _TipsMaxH
    if isScroll then
        ItemTips.SetTipsScrollArrow(ListBg, ListView, hh, _TipsMaxH)
    end

    -- 调整分割线的尺寸
    for i,v in pairs(GUI:getChildren(ListView)) do
        if v then
            GUI:setTouchEnabled(v, false)
            if string.find(GUI:getName(v), "PLINE") then
                local line = GUI:getChildByName(v, "line")
                if line then
                    GUI:setContentSize(line, {width = ww, height = GUI:getContentSize(line).height})
                end
            end
        end
    end

    -- 重新调整位置
    ItemTips.ResetItemTipsPostion(TList, pos, anr)
end

-- 滚轮滚动     data: {x,y} 滚轮的方向
function ItemTips.OnMouseScroll(data)
    if data and data.y then
        if ItemTips._topScrollEvent and data.y == -1 then
            ItemTips._topScrollEvent()
        elseif ItemTips._bottomScrollEvent and data.y == 1 then
            ItemTips._bottomScrollEvent()
        end
    end
end

--设置箭头
function ItemTips.SetTipsScrollArrow(tipsPanel, listView, innH, listH)
    local pSize  = GUI:getContentSize(tipsPanel)
    local picArr = "res/public/btn_szjm_01_1.png"

    local action = GUI:ActionSequence(GUI:ActionFadeTo(0.2, 125), GUI:ActionFadeTo(0.2, 255), GUI:DelayTime(0.3))

    -- 底部箭头
    local btmArrowImg = GUI:Image_Create(tipsPanel, "btmArror", pSize.width/2, 0, picArr)
    GUI:setAnchorPoint(btmArrowImg, 0.5, 0.5)
    GUI:setRotation(btmArrowImg, 180)
    GUI:setTouchEnabled(btmArrowImg, true)
    GUI:runAction(btmArrowImg, GUI:ActionRepeatForever(action))

    -- 顶部箭头
    local topArrowImg = GUI:Image_Create(tipsPanel, "topArror", pSize.width/2, pSize.height, picArr)
    GUI:setAnchorPoint(topArrowImg, 0.5, 0.5)
    GUI:setTouchEnabled(topArrowImg, true)
    GUI:runAction(topArrowImg, GUI:ActionRepeatForever(action))

    local function refreshArrow()
        if GUI:Win_IsNull(listView) then
            return false
        end
        local innerPos = GUI:ListView_getInnerContainerPosition(listView)
        btmArrowImg:setVisible(innerPos.y < innH and innerPos.y < 0)
        topArrowImg:setVisible(innerPos.y > listH - innH or innerPos.y >= 0)
    end

    refreshArrow()

    local bottomEvent = function()
        if GUI:Win_IsNull(listView) then
            return false
        end
        local innerPos      = GUI:ListView_getInnerContainerPosition(listView)
        local vHeight       = innH - listH
        local percent       = (vHeight + innerPos.y + 50) / vHeight * 100
        percent             = math.min(math.max(0, percent), 100)
        GUI:ListView_scrollToPercentVertical(listView, percent, 0.03, false)
        refreshArrow()
    end

    local topEvent = function()
        if GUI:Win_IsNull(listView) then
            return false
        end
        local innerPos      = GUI:ListView_getInnerContainerPosition(listView)
        local vHeight       = innH - listH
        local percent       = (vHeight + innerPos.y - 50) / vHeight * 100
        percent             = math.min(math.max(0, percent), 100)
        GUI:ListView_scrollToPercentVertical(listView, percent, 0.03, false)
        refreshArrow()
    end

    GUI:addOnClickEvent(btmArrowImg, function()
        bottomEvent()
    end)

    GUI:addOnClickEvent(topArrowImg, function()
        topEvent()
    end)

    if SL:IsWinMode() then
        GUI:setTouchEnabled(btmArrowImg, false)
        GUI:setTouchEnabled(topArrowImg, false)

        ItemTips._topScrollEvent    = topEvent
        ItemTips._bottomScrollEvent = bottomEvent
    end
    SL:schedule(btmArrowImg, refreshArrow, 0.1)
end

function ItemTips.ResetItemTipsPostion(widget, pos, ancPoint)
    local margin = GUI:ListView_getItemsMargin(widget) or 0
    local width, height = 0, 0
    for _,v in pairs(GUI:getChildren(widget)) do
        local size = v:getContentSize()
        if v then
            local size = GUI:getContentSize(v)
            width, height = width + size.width + margin, math.max(height, size.height)
        end
    end
    GUI:setContentSize(widget, {width = width, height = height})
    
    pos.x, pos.y = widget:getPosition()
    local pos, anchorPoint = ItemTips.GetTipsAnchorPoint(widget, pos, ancPoint)

    GUI:setPosition(widget, pos.x, pos.y)
    GUI:setAnchorPoint(widget, anchorPoint)
end

function ItemTips.GetTipsAnchorPoint(widget, pos, ancPoint)
    local size = GUI:getContentSize(widget)
    local outScreenX = false
    local outScreenY = false
    if pos.y + size.height*ancPoint.y > screenH then
        ancPoint.y = 1
        outScreenY = true
    end
    if pos.y - size.height*ancPoint.y < 0 then
        if outScreenY then
            ancPoint.y = 0.5
            pos.y = screenH / 2
        else
            ancPoint.y = 0
        end
    end
    
    if pos.x + size.width*(1-ancPoint.x) > screenW then
        ancPoint.x = 1
        outScreenX = true
    end
    if pos.x - size.width*ancPoint.x < 0 then
        if outScreenX then
            ancPoint.x = 0.5
            pos.x = screenW / 2
        else
            ancPoint.x = screenW - pos.x < size.width and pos.x/(size.width+5) or 0
        end
    end
    return pos, ancPoint
end

function ItemTips.GetOtherAttrStr(item)
    local str = nil
    local shape = item.Shape
    if item.StdMode == 7 and (shape == 1 or shape == 2 or shape == 3) then
        --魔血石
        local typeStr = ""
        if shape == 1 then
            typeStr = "HP"
        elseif shape == 2 then
            typeStr = "MP"
        elseif shape == 3 then
            typeStr = "HPMP"
        end
        str = string.format("%s %d/%d万", typeStr, item.Dura/1000, item.DuraMax/1000)
    elseif item.StdMode == 25 then --护身符及毒药
        str = string.format("数量:%s/%s", math.round(item.Dura/100), math.round(item.DuraMax/100))
    elseif item.StdMode == 40 then --肉
        str = string.format("品质：%s/%s", math.round(item.Dura/1000), math.round(item.DuraMax/1000))
    elseif item.StdMode == 43 then --矿石
        str = string.format("纯度：%s", math.round(item.Dura/1000))
    elseif GUIShare.EquipPosByStdMode[item.StdMode] then
        str = string.format("持久：%s/%s", math.round(item.Dura/1000), math.round(item.DuraMax/1000))
    end
    return str
end

function ItemTips.GetNeedStr(itemData)
    local tb = _IsHeroEquip and SL:CheckItemUseNeed_Hero(itemData) or SL:CheckItemUseNeed(itemData)
    local canUse, conditionStr = tb.canUse, tb.conditionStr

    local function getColor(can)
        return can and "#FFFFFF" or "#FF0000"
    end

    if (conditionStr and next(conditionStr)) then
        local str = ""
        for i,v in ipairs(conditionStr) do
            local color  = v.can and "#FFFFFF" or "#FF0000"
            local conStr = string.format("<font color='%s'>%s</font>", getColor(v.can), v.str)
            str = str .. conStr .. "<br>"
        end
        return str
    end

    return string.format("<font color='%s'>%s</font>", getColor(true), "需求：无限制")
end

-- 道具职业
function ItemTips.GetJobStr(itemData)
    if itemData and itemData.Job then
        local str = {
            [100] = "战士",
            [101] = "法师",
            [102] = "道士",
            [103] = "通用"
        }
        if str[itemData.Job] then
            return string.format("职业：%s", str[itemData.Job])
        end
    end 
    return false
end

--道具类型
function ItemTips.GetTypeStr(itemData)
    local posList = GetEquipPosByStdModeList(itemData.StdMode)
    local pos = (posList and posList[1]) and posList[1]
    if not pos then
        return false
    end
    return string.format("类型：%s", GUIShare.EquipPosTips[pos] or "自定义")
end

-- 星级
function ItemTips.GetStarPanel(parent, star)
    if not star or star < 1 then
        return false
    end

    local startNorm = 11
    local pinkStar  = math.floor( star / startNorm )
    local blueStar  = star % startNorm
    local starCount = pinkStar + blueStar

    local ww = math.min(starCount, startNorm)   * 25
    local hh = math.ceil(starCount / startNorm) * 25

    local PanelStar = GUI:Layout_Create(parent, "PanelStar", 0, 0, ww, hh)

    for i=1, starCount do
        local resPath = string.format(_PathRes.."bg_tipszyxx_0%d.png", i <= pinkStar and 4 or 5)
        local x = startNorm + ((i - 1) % startNorm) * 25
        local y = (math.ceil(starCount / startNorm) - math.ceil(i / startNorm)) * 25

        local image = GUI:Image_Create(PanelStar, "image"..i, x, y, resPath)
        GUI:setAnchorPoint(image, 0.5, 0)
    end

    return PanelStar
end

-- 分割线
function ItemTips.CreateIntervalPanel(parent, height, line)
    local num = GUI:getChildren(parent)
    local pLine = GUI:Layout_Create(parent, "PLINE"..tostring(#num+1), 0, 0, 1, height)
    if line then
        local line = GUI:Image_Create(pLine, "line", 0, height/2, _PathRes.."line_tips_01.png")
        GUI:setAnchorPoint(line, 0, 0.5)
    end
    return pLine
end

-- 获得需要比较的装备
function ItemTips.GetCompareEquip(itemData)
    local StdMode = itemData.StdMode

    -- 获取自定义装备信息
    local customEquipPos = CustomEquipPosByStdMode[StdMode]
    if customEquipPos then
        local customEquip = _IsHeroEquip and SL:GetHeroEquipDataByPos(customEquipPos) or SL:GetEquipDataByPos(customEquipPos)
        return {customEquip}
    end

    local posList = GetEquipPosByStdModeList(StdMode)
    if not posList then
        -- 没有需要比较的装备
        return {}
    end

    local equipList = {}
    for k,pos in pairs(posList) do
        local equip = _IsHeroEquip and SL:GetHeroEquipDataByPos(pos) or SL:GetEquipDataByPos(pos)
        if equip and next(equip) then
            table.insert(equipList, equip)
        end
    end
    return equipList
end

function ItemTips.GetColorXmlStr(colorID)
    local cfg = SL:GetColorCfg(colorID)
    local xmlStr = cfg and string.format("color = '%s' size = '%s'", (cfg.colour or "#FFFFFF"), (cfg.size or _TextSize)) or ""
    return xmlStr
end

-- 获取套装属性(对应 cfg_equip 中 Suit 字段)
function ItemTips.GetSuitStr(suitID, itemData)
    local suitCfgData = SL:GetSuitDataById(suitID)
    if not suitCfgData then
        return false
    end

    -- 该位置是否有装备
    local function CheckIsWearEquipPos(pos)
        local isWear = false
        local eName  = ""
        local eData  = nil

        if _lookPlayer then
            eData = SL:GetLookPlayerItemDataByPos(pos)
        elseif _IsHeroEquip then
            eData = SL:GetHeroEquipDataByPos(pos)
        else
            eData = SL:GetEquipDataByPos(pos)
        end

        if eData and eData.Suit and string.len(eData.Suit) > 0 then 
            local suitArr = string.split(eData.Suit, "#")
            for i,v in ipairs(suitArr) do
                if v and string.len(v) > 0 then
                    local posSuitConfig = SL:GetSuitDataById(tonumber(v))
                    if posSuitConfig and posSuitConfig.suittype == suitCfgData.suittype and posSuitConfig.suitid == suitCfgData.suitid then
                        isWear = true
                        eName = eData.Name
                        break
                    end
                end
            end
        end

        return isWear, eName
    end

    local function ParseColor(txtStr, colorIdx)
        local colorStr = ""
        local showStrt = ""
        local txtArray = SL:Split(txtStr or "", "|")
        if #txtArray > 1 then
            colorStr = txtArray[1] or ""
            for i=2,#txtArray do
                showStrt = showStrt .. (txtArray[i] or "")
            end
        else
            showStrt = txtStr
        end
        colorIdx = colorIdx or 1
        local colorArry = SL:Split(colorStr or "", "/")
        if #colorArry <= 1 then
            table.insert(colorArry, 1, 249)
        end
        local colorID = tonumber(colorArry[colorIdx])
        colorID = colorID or tonumber(colorArry[1])
        
        return colorID, showStrt
    end

    -- 套装件数
    local suitCount = suitCfgData.num or 0
    -- 穿戴数量
    local wearCount = 0

    local wearEuips = {}
    local equipPos  = string.split(suitCfgData.equipid or "", "#")
    for i,pos in ipairs(equipPos) do
        pos = tonumber(pos)
        if pos then
            local isWear, equipName = CheckIsWearEquipPos(pos)
            if isWear then
                wearCount = wearCount + 1
            end
            if not suitCfgData.num then
                suitCount = suitCount + 1
            end
            if equipName then
                wearEuips[equipName] = isWear
            end
        end
    end
    local suitStr = ""
    -- 套装标题
    local titleStr = suitCfgData.name or ""
    if titleStr and string.len(titleStr) > 0 then
        local mCount = wearCount > suitCount and suitCount or wearCount
        local colorID, str = ParseColor(titleStr, wearCount >= suitCount and 2 or 1)
        suitStr = string.format("<font %s>%s (%s/%s)</font><br>", ItemTips.GetColorXmlStr(colorID), str, mCount, suitCount)
    end

    -- 套装名字
    local showArr  = SL:Split(suitCfgData.equipshow or "","|")
    local nameStrs = SL:Split(#showArr > 1 and showArr[2] or showArr[1] "", "#")
    for _,nameStr in ipairs(nameStrs) do
        if nameStr and string.len(nameStr) > 0 then
            local isWear = wearEuips[nameStr]
            local colorID, str = ParseColor(showArr[1].."|"..nameStr, isWear and 2 or 1)
            suitStr = suitStr .. string.format("<font %s>%s</font><br>", ItemTips.GetColorXmlStr(colorID), str)
        end
    end

    -- 套装属性描述
    local descStr = suitCfgData.desc or ""
    if descStr and string.len(descStr) > 0 then
        local colorID = ParseColor(descStr, wearCount >= suitCount and 2 or 1)

        local descs = SL:Split(SL:Split(descStr,"|")[2], "<br>")
        for _,dsc in ipairs(descs) do
            if dsc and string.len(dsc) > 0 then
                suitStr = suitStr .. string.format("<font %s>%s</font><br>", ItemTips.GetColorXmlStr(colorID), dsc)
            end
        end
    end

    return suitStr
end

-- 道具时限-剩余时间
function ItemTips.GetEndTime(key, itemData)
    local addValues = itemData.AddValues
    if not addValues then
        return false
    end

    if type(addValues) ~= "table" then
        return false
    end

    local endTime = nil
    if addValues then
        for _, v in pairs(addValues) do
            if v.Id == 0 then
                endTime = v.Value
                break
            end
        end
    end

    return endTime
end

------------  道具tips  ------------------------------------------------
function ItemTips.GetItemTips(data, itemData)
    ItemTips.CreateItemPanel(data, itemData)
end

function ItemTips.CreateItemPanel(data, itemData)
    local pos = data.pos or {x = screenW / 2, y = screenH / 2}
    local anr = data.anchorPoint or {x = 0, y = 1}

    local TList = GUI:getChildByName(ItemTips._PMainUI, "TList")
    if not TList then
        TList = GUI:ListView_Create(ItemTips._PMainUI, "TList", pos.x, pos.y, 0, 0, 2)
        GUI:ListView_setClippingEnabled(TList, false)
        GUI:setTouchEnabled(TList, false)
        GUI:ListView_setGravity(TList, 3)
        GUI:setAnchorPoint(TList, anr)
        GUI:ListView_setItemsMargin(TList, 0)
    end

    _PanelNum = _PanelNum + 1
    local ListBg = GUI:Layout_Create(TList, "ListBg".._PanelNum, 0, 0, 135, 173)
    GUI:Layout_setBackGroundImageScale9Slice(ListBg, 44, 57, 47, 59)
    GUI:Layout_setBackGroundImage(ListBg, _PathRes.."bg_tipszy_05.png")
    GUI:setAnchorPoint(ListBg, anr)
    GUI:setTouchEnabled(ListBg, false)

    local richWidth = _TotalWidth - 20
    local ww = 0
    local hh = 0

    local ListView = GUI:ListView_Create(ListBg, "ListView", 15, 10, 0, 0, 1)
    GUI:ListView_setItemsMargin(ListView, 0)
    GUI:setTouchEnabled(ListView, false)

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255

    -- 道具名字
    local name = itemData.Name or ""
    local r_name = GUI:RichText_Create(ListView, "r_name", 0, 0, name, richWidth, _TextSize, SL:GetColorByID(color), nil, nil, fontPath)
    ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)

    local size = GUI:getContentSize(r_name)
    ww = math.max(ww, size.width)
    hh = hh + size.height + _DefaultSpace

    -- 道具图标
    local IconBg = GUI:Image_Create(ListView, "IconBg", 0, 0, _PathRes.."1900025001.png")
    local IconBgSz = GUI:getContentSize(IconBg)
    local Icon = GUI:ItemShow_Create(IconBg, "Icon", IconBgSz.width / 2, IconBgSz.height / 2, {
        index = itemData.Index, disShowCount = true
    })
    GUI:setAnchorPoint(Icon, 0.5, 0.5)
    ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
    hh = hh + IconBgSz.height + _DefaultSpace

    -- 类型
    local typeStr = ItemTips.GetTypeStr(itemData)
    if typeStr and string.len(typeStr) > 0 then
        local wx = IconBgSz.width + 10
        local wy = IconBgSz.height * 0.7
        local r_type = GUI:RichText_Create(Icon, "r_type", wx, wy, typeStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        GUI:setAnchorPoint(r_type, 0, 0.5)

        ww = math.max(ww, GUI:getContentSize(r_type).width + wx + 10)
    end

    -- 需求
    local needStr = ItemTips.GetNeedStr(itemData)
    local needww  = 0
    if needStr then
        local wx = IconBgSz.width + 10
        local wy = IconBgSz.height * 0.3
        local r_need = GUI:RichText_Create(Icon, "r_need", wx, wy, needStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        GUI:setAnchorPoint(r_need, 0, 0.5)

        ww = math.max(ww, GUI:getContentSize(r_need).width + wx + 10)
        needww = GUI:getContentSize(r_need).width
    end

    -- 绑定玩家 别人不能穿
    local isBindUser = itemData.BindInfo and string.len(itemData.BindInfo) > 0
    if isBindUser then
        local r_bindUser = GUI:RichText_Create(ListView, "r_bindUser", 0, 0, string.format("已绑定[%s]", itemData.BindInfo), richWidth, _TextSize, color, nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(r_bindUser).height + _DefaultSpace
    end

    -- 绑定 不能掉
    local isBind = itemData.Bind and string.len(itemData.Bind) > 0
    if isBind then
        local r_bind = GUI:RichText_Create(ListView, "r_bind", 0, 0, "已绑定", richWidth, _TextSize, color, nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(r_bind).height + _DefaultSpace
    end

    -- Hp、Mp
    local hmpStr = ItemTips.GetHP_MP_Str(itemData)
    if hmpStr and string.len(hmpStr) > 0 then
        local r_hmp = GUI:RichText_Create(ListView, "r_hmp", 0, 0, hmpStr, richWidth, _TextSize, color, nil, nil, fontPath)
        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(r_hmp).height + _DefaultSpace
    end

    -- 其他的属性
    local aStr = ItemTips.GetOtherAttrStr(itemData)
    if aStr then
        local r_mode = GUI:RichText_Create(ListView, "r_mode", 0, 0, aStr, richWidth, _TextSize, "#FFFFFF", nil, nil, fontPath)
        GUI:setAnchorPoint(r_mode, 0, 0.5)

        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(r_mode).height + _DefaultSpace
    end

    -- 倒计时
    local timeStr = ItemTips.GetEndTime(2, itemData)
    if timeStr then
        local time = math.max(endTime - SL:GetCurServerTime(), 0)
        if time < 1 then
            return SL:CloseItemTips()
        end

        local function getTimeStr(time)
            return string.format("限时道具：%s", SL:TimeFormatToStr(time))
        end

        local Text_time = GUI:Text_Create(ListView, "Text_time", 0, 0, _TextSize, "#28EF01", getTimeStr(time))
        GUI:setAnchorPoint(Text_time, 0, 0.5)

        ItemTips.CreateIntervalPanel(ListView, _DefaultSpace, true)
        hh = hh + GUI:getContentSize(Text_time).height + _DefaultSpace
        ww = math.max(ww, GUI:getContentSize(Text_time).width)

        -- 小于一天才显示倒计时
        local day = math.floor(time / 86400)
        if day < 1 then
            local function showTime()
                local time = math.max(endTime - SL:GetCurServerTime(), 0)
                if time > 0 then
                    GUI:Text_setString(Text_time, string.format("限时道具：%s", SL:TimeFormatToStr(time)))
                else
                    SL:CloseItemTips()
                end
            end

            SL:schedule(Text_time, showTime, 1)
        end
    end

    -- 道具描述
    local desc = itemData.Desc
    if desc and string.len(desc) > 0 then
        local r_desc = GUI:RichText_Create(ListView, "r_desc", 0, 0, desc, ww + 10, _TextSize, "#FFFFFF", nil, nil, fontPath)

        size = GUI:getContentSize(r_desc)
        ww = math.max(ww, size.width)
        hh = hh + size.height
    end


    local ListBgWidth = ww + 30

    local btnhh = 0
    local isBtn = false
    if data and data.from == ItemFrom.BAG and not SL:IsWinMode() then
        -- 使用
        if IsOpenSwitch(3, itemData.StdMode) then
            local btn = ItemTips.addButton(ListBg, itemData, 3)
            local btnSize = GUI:getContentSize(btn)
            btnhh = btnSize.height + 20
            GUI:setPositionX(btn, ListBgWidth - 10)
            GUI:setPositionY(btn, 10)

            isBtn = true
        end
        -- 拆分
        if IsOpenSwitch(2) and itemData.OverLap and itemData.OverLap > 1 then
            local btn = ItemTips.addButton(ListBg, itemData, 2)
            local btnSize = GUI:getContentSize(btn)

            if isBtn then
                GUI:setPositionX(btn, ListBgWidth - 10 - btnSize.width - 20)
            else
                btnhh = btnSize.height + 20
                GUI:setPositionX(btn, ListBgWidth - 10)
            end
            GUI:setPositionY(btn, 10)
        end
    end

    -- 可视高度
    local visiblehh = math.min(hh, _TipsMaxH)
    GUI:setContentSize(ListView, {width = ww, height = visiblehh})
    if isBtn then
        GUI:setContentSize(ListBg, {width = ListBgWidth, height = visiblehh + 10 + btnhh})
        GUI:setPositionY(ListView, btnhh)
    else
        GUI:setContentSize(ListBg, {width = ListBgWidth, height = visiblehh + 20})
        GUI:setPositionY(ListView, 10)
    end

    local isScroll = hh > _TipsMaxH
    if isScroll then
        ItemTips.SetTipsScrollArrow(ListBg, ListView, hh, _TipsMaxH)
    end

    -- 调整分割线的尺寸
    for i,v in pairs(GUI:getChildren(ListView)) do
        if v then
            if string.find(GUI:getName(v), "PLINE") then
                local line = GUI:getChildByName(v, "line")
                if line then
                    GUI:setContentSize(line, {width = ww, height = GUI:getContentSize(line).height})
                end
            end
        end
    end

    -- 重新调整位置
    ItemTips.ResetItemTipsPostion(TList, pos, anr)
end

function ItemTips.GetHP_MP_Str(itemData)
    if itemData.StdMode == 0 and (itemData.Shape == 0 or itemData.Shape == 1) and string.len(itemData.effectParam) > 0 then
        local str = ""
        local sliceStr = string.split(itemData.effectParam, "#")
        for i=1, #sliceStr do
            local count = tonumber(sliceStr[i])
            if count and count > 0 then
                if i == 1 then
                    str = str .. string.format("HP +%s<br>", count)
                elseif i == 2 then
                    str = str .. string.format("MP +%s<br>", count)
                end
            end
        end
        return str
    end
    return false
end

------------    按钮    ------------------------------------------------

local _GetBtnCfg = function (btnType)
    local cfg = {
        [1] = {
            normalPic= "res/public/1900000679.png",
            pressPic = "res/public/1900000679_1.png",
            btnName  = "佩戴", 
            color    = "#FFFFFF", 
            fontSize = 16,
            func = function (data)
                SL:UseItem(data)
                SL:CloseItemTips()
            end
        },
        [2] = {
            normalPic= "res/public/1900000679.png",
            pressPic = "res/public/1900000679_1.png",
            btnName  = "拆分",
            color    = "#FFFFFF", 
            fontSize = 16,
            func = function (data)
                if not SL:IsBagFull(true) then
                    SL:OpenItemSplitPop({itemData = SL:GetItemDataByMakeIndex(data.MakeIndex)})
                end
                SL:CloseItemTips()
            end
        },
        [3] = {
            normalPic= "res/public/1900000679.png",
            pressPic = "res/public/1900000679_1.png",
            btnName  = "使用", 
            color    = "#FFFFFF", 
            fontSize = 16,
            func = function (data)
                SL:UseItem(data)
                SL:CloseItemTips()
            end
        },
        [-1] = {
            normalPic= "res/public/1900000679.png",
            pressPic = "res/public/1900000679_1.png",
            btnName  = "TYPE_ERROR", 
            color    = "#FFFFFF", 
            fontSize = 16,
            func = function (data)
                print("Not ClickEvent....")
            end
        }
    }         
    return cfg[btnType] or cfg[-1]
end

--split_type: 1： 佩戴    2：拆分    3：使用道具
function ItemTips.addButton(parent, itemData, btnType)
    local btnCfg = _GetBtnCfg(btnType)

    local button = GUI:Button_Create(parent, "BTN"..btnType, 0, 0, btnCfg.normalPic)
    GUI:Button_loadTexturePressed(button, btnCfg.pressPic)
    GUI:Button_setTitleColor(button, btnCfg.color)
    GUI:Button_setTitleFontSize(button, btnCfg.fontSize)
    GUI:Button_setTitleText(button, btnCfg.btnName)
    GUI:setAnchorPoint(button, 1, 0)
    GUI:addOnClickEvent(button, function () btnCfg.func(itemData) end)

    return button
end