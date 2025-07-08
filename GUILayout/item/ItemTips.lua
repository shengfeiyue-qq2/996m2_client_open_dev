ItemTips = {}

local screenW = SL:GetValue("SCREEN_WIDTH")
local screenH = SL:GetValue("SCREEN_HEIGHT")

local ItemFrom = GUIDefine.ItemFrom
local FromHero = {
    [ItemFrom.HERO_EQUIP] = true,
    [ItemFrom.HERO_BAG] = true,
    [ItemFrom.HERO_BEST_RINGS] = true
}

local FromEquip = {
    [ItemFrom.PLAYER_EQUIP] = true,
    [ItemFrom.BEST_RINGS] = true,
    [ItemFrom.HERO_EQUIP] = true,
    [ItemFrom.HERO_BEST_RINGS] = true
}

----------------- Params
local _resPath      = "res/private/item_tips/"
local _resPathWin   = "res/private/item_tips_win32/"
local _nameSize     = SL:GetValue("IS_PC_OPER_MODE") and 13 or 18
local _tipsMaxH     = screenH - 100
local _panelNum     = 0
local _defaultSpace = 10

local _lookPlayer   = false    
local _isSelf       = false
local _isHero       = false

local rightSpace    = 15
local topSpace      = 10
local vspace        = SL:GetValue("GAME_DATA", "DEFAULT_VSPACE")    -- 富文本行距
local fontPath      = SL:GetValue("CHATANDTIPS_USE_FONT") or GUI.PATH_FONT2
local fontSize      = SL:GetValue("IS_PC_OPER_MODE") and 12 or 16   -- 官方默认字号

-- stdmode对应不同Tips
local function getTipType(itemData)
    local config = GUIDefineEx.TipsTypeConfig -- 配置
    for type, param in ipairs(config) do
        if param.stdmode == "total" then
            return type
        end
        local stdmodeList = param.stdmode or {}
        if table.indexof(stdmodeList, itemData.StdMode) then
            return type
        end
    end
    return nil
end

local function isEquip(itemData)
    return SL:GetValue("ITEMTYPE", itemData) == SL:GetValue("ITEMTYPE_ENUM").Equip
end

local function isSkillBook(itemData)
    return SL:GetValue("ITEMTYPE", itemData) == SL:GetValue("ITEMTYPE_ENUM").SkillBook
end

-- 按钮显示开关配置（cfg_game_data 表 BackpackGuide 字段）
-- switchType (1: 佩戴    2: 拆分   3: 不显示按钮)
local function isOpenBtnSwitch(switchType, StdMode)
    if not switchType or not GUIDefineEx.TipsBtnTypeSwitch then
        return false
    end

    if switchType ~= 3 then
        return GUIDefineEx.TipsBtnTypeSwitch[switchType] == 1
    end

    if not StdMode then
        return false
    end

    if not GUIDefineEx.TipsBtnTypeSwitch[3] then
        return true
    end

    return GUIDefineEx.TipsBtnTypeSwitch[3][StdMode] == nil
end

local function toEven(num)
    if not num then
        return nil
    end
    return num % 2 ~= 0 and (num + 1) or num
end

function ItemTips.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.ItemTipsGUI, 0, 0, 0, 0, nil, nil, nil, nil, nil, nil, GUIDefine.UIZ.MOUSE)
    local data   = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    ItemTips._data = data

    ItemTips._panelSortItems = {}
    ItemTips._PList = nil
    ItemTips._diff = false
    ItemTips._equipAttList = {} -- 身上的装备属性
    ItemTips._baseAttList = nil
    ItemTips._diyAttList = nil


    ItemTips._upAttrRichs = {}
    ItemTips._upAttrMaxWidth = 0
    ItemTips._baseAttrs = nil
    ItemTips._ysAttrs = nil
    ItemTips._upAttrs = nil

    ItemTips.fromTrading = nil

    ItemTips.typeCapture = data and data.typeCapture or nil

    -- 是否是英雄装备
    _isHero     = data.from and FromHero[data.from] or false
    _lookPlayer = data.lookPlayer
    _isSelf     = data.from ~= nil and FromEquip[data.from]

    local itemData = data.itemData or (data.typeId and SL:GetValue("ITEM_DATA", data.typeId))
    ItemTips._data.itemData = itemData
    ItemTips.fromTrading = data and data.fromTrading or nil
    -- 职业
    ItemTips._job = nil
    if not _lookPlayer then
        ItemTips._job = _isHero and SL:GetValue("H.JOB") or SL:GetValue("JOB")
    else
        if ItemTips.fromTrading then
            ItemTips._job = SL:GetValue("T.M.JOB")
        else
            ItemTips._job = SL:GetValue("L.M.JOB")
        end
    end
    -- 字号、行距
    local param = GUIDefineEx.TipsFontSizeVspace
    _nameSize = param.fontSize or _nameSize
    fontSize = param.fontSize or fontSize
    vspace = param.vspace or vspace
    ItemTips._cellSpace = vspace

    -- 属性标题配置
    ItemTips._showTitleList = GUIDefineEx.TipsAttrTitle

    -- 
    local attrAlignment         = SL:GetValue("IS_PC_OPER_MODE") and tonumber(SL:GetValue("GAME_DATA", "pc_tips_attr_alignment")) or 0
    local attrCoefficient       = SL:GetValue("IS_PC_OPER_MODE") and -1 or 1
    attrAlignment               = math.ceil(attrAlignment / 3)
    ItemTips._attrCoefficient   = attrCoefficient
    ItemTips._attrAlignment     = attrAlignment

    if not data.pos then
        data.pos = {x = screenW / 2, y = screenH / 2}
        data.anchorPoint = {x = 0.5, y = 0.5}
    end

    ItemTips._PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(ItemTips._PMainUI, true)
    GUI:setSwallowTouches(ItemTips._PMainUI, false)
    GUI:addOnClickEvent(ItemTips._PMainUI, function()
        UIOperator:CloseItemTips() 
    end)
    GUI:Win_SetCloseCB(parent, ItemTips.OnClose)

    -- 不同分类Tips
    local type = getTipType(itemData)
    local config = GUIDefineEx.TipsTypeConfig[type] or {}
    ItemTips._config = config
    ItemTips.InitTips()
    
    -- 注册监听Tips鼠标滚动
    SL:RegisterLUAEvent(LUA_EVENT_ITEMTIPS_MOUSE_SCROLL, "ItemTips", ItemTips.OnMouseScroll)
    SL:RegisterLUAEvent(LUA_EVENT_USERINPUT_EVENT_NOTICE, "ItemTips", function ()
        GUI:Win_Close(parent)
    end)
end

function ItemTips.InitTips()
    local captureNode = nil
    if isEquip(ItemTips._data.itemData) then
        ItemTips.GetEquipTips()
        captureNode = ItemTips._PList
    else
        ItemTips.GetItemTips()
        captureNode = GUI:getChildren(ItemTips._PMainUI)[1]
    end
    -- 交易行 截图节点 请勿删除 
    ItemTips._screenshotRootNode = captureNode
end

----------------------------
-- 道具类型
function ItemTips.GetTypeStr(itemData, isItem)
    if isItem and itemData and itemData.StdMode then
        
        local name = GUIDefineEx.TipsItemTypeName[itemData.StdMode] or "道具"
        return string.format("类型：%s", name)
    end
    return nil
end

function ItemTips.GetTouBaoGold(data)
    local insureGoldList = data.InsureGoldList
    if insureGoldList and string.len(insureGoldList) > 0 then
        local goldList = {}
        local list = string.split(insureGoldList, "|")
        for i, v in ipairs(list) do
            local value = string.split(v, "#")
            goldList[i] = {goldType = tonumber(value[1]), goldNum = tonumber(value[2]), notshow = tonumber(value[3]) == 1}

        end
        local maxIndex = #list
        if data.touBaoTimes and goldList[data.touBaoTimes] then
            return goldList[data.touBaoTimes]
        elseif data.touBaoTimes and data.touBaoTimes > maxIndex then
            return goldList[maxIndex]
        else
            return goldList[1]
        end
    end
    return nil
end

-- 投保
function ItemTips.GetTouBaoDesc(data)
    if SL:GetMetaValue("SERVER_OPTIONS", SW_KEY_ITEMTIPS_TOUBAO_SHOW) ~= 1 then
        return
    end

    local toubaoStr = nil
    local value = ItemTips.GetTouBaoGold(data)
    local gold = value and value.goldNum or 0

    if gold > 0 and value and value.goldType then
        local moneyName = SL:GetValue("ITEM_NAME", value.goldType) or ""
        if data.touBaoTimes then
            if value.notshow then
                toubaoStr = string.format("<font color='%s' size='%s'>已投保%s次</font>", "#28ef01", fontSize, data.touBaoTimes)
            else
                toubaoStr =
                    string.format(
                    "<font color='%s' size='%s'>已投保%s次，单次保额%s%s</font>",
                    "#28ef01",
                    fontSize,
                    data.touBaoTimes,
                    gold,
                    moneyName
                )
            end
        else
            if value.notshow then
                toubaoStr = string.format("<font color='%s' size='%s'>可投保</font>", "#ff0500", fontSize)
            else
                toubaoStr = string.format("<font color='%s' size='%s'>可投保，单次保额%s%s</font>", "#ff0500", fontSize, gold, moneyName)
            end
        end
    end

    return toubaoStr
end

-- Mode
function ItemTips.GetModeStr(itemData)
    local str = nil
    local shape = itemData.Shape
    local checkDura = nil
    if itemData.StdMode == 7 and (shape == 1 or shape == 2 or shape == 3) then
        --魔血石
        local typeStr = ""
        if shape == 1 then
            typeStr = "HP"
        elseif shape == 2 then
            typeStr = "MP"
        elseif shape == 3 then
            typeStr = "HPMP"
        end
        str = string.format("%s %d/%d万", typeStr, itemData.Dura / 1000, itemData.DuraMax / 1000)
        checkDura = itemData.Dura / 1000
    elseif itemData.StdMode == 25 then --护身符及毒药
        local num = string.format("%s/%s", math.round(itemData.Dura / 100), math.round(itemData.DuraMax / 100))
        str = string.format("数量:%s", num)
    elseif GUIDefine.EquipMapByStdMode[itemData.StdMode] or GUIDefine.EquipMapExByStdmode[itemData.StdMode] then
        str = string.format("持久：%s", GUIFunction:GetDuraStr(itemData.Dura, itemData.DuraMax))
        checkDura = itemData.Dura / 1000
    elseif itemData.StdMode == 40 then --肉
        str = string.format("品质：%s", GUIFunction:GetDuraStr(itemData.Dura, itemData.DuraMax))
    elseif itemData.StdMode == 43 then --矿石
        str = string.format("纯度：%s", math.round(itemData.Dura / 1000))
    end

    if checkDura and checkDura < 1 then
        str = string.format("<font color='%s'>%s</font>", "#ff0000", str) -- 设置颜色(红色)
    end
    return str
end

--获取属性原始id
local function getAttOriginId(id)
    return id >= 10000 and math.floor(id / 10000) or id
end

--显示 +
local function getAddShow(id, value)
    if tonumber(value) and tonumber(value) < 0 then
        return ""
    end
    if id == 1 or id == 2 or id == 13 or id == 14 or id == 15 or id == 16 or id == 17 or id == 18 or id == 19 or id == 20 or id == 38 or id == 39 then
        return "+"
    end
    return ""
end

local function checkNeedQualityExAdd()
    local needExAdd = SL:GetValue("GAME_DATA", "TipsQualityExAddNotShow") ~= 1
    return needExAdd
end

local function getAlignAttrStr(v)
    if not v and not next(v) then
        return ""
    end
    local name      = string.gsub(v.name, " ", "")
    name            = string.gsub(name, "　", "")
    local value     = getAddShow(v.id, v.value) .. v.value
    local nameLen, chineseLen = SL:GetUTF8ByteLen(name)  
    local newLen    = math.max(ItemTips._attrAlignment - nameLen - chineseLen * ItemTips._attrCoefficient + SL:GetUTF8ByteLen(value), 0)
    local lenStr    = string.format("%%%ds", newLen)
    value           = string.format(lenStr, value)

    return string.format("%s%s", name, value)
end

function ItemTips.GetAttStr(itemData, diff)
    local pos =  GUIFunction:GetEmptyPosByStdMode(itemData.StdMode)
    if not pos then
        return nil
    end
    local strList = {}

    -- 基础属性
    local attList           = GUIFunction:ParseItemBaseAtt(itemData.Attribute, ItemTips._job)

    -- 极品属性
    local qualityAttrs      = GUIFunction:GetItemQualityAttr(itemData)
    local exAttShow         = GUIFunction:GetAttDataShow(qualityAttrs, true, true)
    -- 合并极品属性
    if qualityAttrs and next(qualityAttrs) then
        attList             = GUIFunction:CombineAttList(attList, qualityAttrs)
    end
    ItemTips._baseAttList = attList

    -- 附加幸运
    local exLuckyValue = itemData.Lucky

    -- 属性提升
    local attUpList = {}  -- 属性提升标识的位置
    if diff then
        table.insert(ItemTips._equipAttList, GUIFunction:GetAttDataShow(attList, nil, true))
    elseif next(ItemTips._equipAttList) then
        local curAttList = GUIFunction:GetAttDataShow(attList, nil, true)
        for _, attrList in pairs(ItemTips._equipAttList) do
            for id, curAtt in pairs(curAttList or {}) do
                if not attrList[id] then
                    attUpList[id] = true
                else
                    local att = attrList[id]
                    local value1 = curAtt.value
                    local value2 = att.value
                    if string.find(value1, "-") then
                        value1 = string.split(value1, "-")[2]
                        value2 = string.split(value2, "-")[2]
                    end

                    if string.find(value1, "%%") then
                        value1 = string.split(value1, "%")[1]
                        value2 = string.split(value2, "%")[1]
                    end

                    value1 = tonumber(value1)
                    value2 = tonumber(value2)
                    if value1 and value2 and value1 > value2 then
                        attUpList[id] = true
                    end
                end
            end
        end
    end

    -- 属性显示队列
    local stringAtt = GUIFunction:GetAttDataShow(attList, nil, true)
    -- 把基础属性和元素属性分开
    local basicAttrShow = {}
    local yuansuAttrShow = {}
    for id, v in pairs(stringAtt) do
        v.id = id
        local originId = getAttOriginId(id)
        local attConfig = SL:GetValue("ATTR_CONFIG", originId)
        v.sort = attConfig and attConfig.sort or originId + 1000

        if attConfig and attConfig.ys == 1 then
            table.insert(yuansuAttrShow, v)
        else
            table.insert(basicAttrShow, v)
        end
    end

    table.sort(
        basicAttrShow,
        function(a, b)
            return a.sort < b.sort
        end
    )
    table.sort(
        yuansuAttrShow,
        function(a, b)
            return a.sort < b.sort
        end
    )

    if basicAttrShow and next(basicAttrShow) then
        local titleName = ItemTips._showTitleList[1] and ItemTips._showTitleList[1].name or "[基础属性]："
        local titleColor = ItemTips._showTitleList[1] and ItemTips._showTitleList[1].color or 154
        local titleStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName)
        table.insert(
            strList,
            {
                str = titleStr
            }
        )
    end

    local showExLucky = false
    for _, v in ipairs(basicAttrShow) do
        local oneStr = getAlignAttrStr(v)
        local color = v.color
        if exAttShow and exAttShow[v.id] and checkNeedQualityExAdd() then
            oneStr = oneStr .. string.format("（%s）", exAttShow[v.id].value)
            color = 1039
        end
        -- 幸运
        if v.id == GUIDefine.AttTypeTable.Lucky and exLuckyValue then
            if v.isCurse and exLuckyValue < 0 then -- 诅咒 附加诅咒
                oneStr = oneStr .. string.format("（+%s）", math.abs(exLuckyValue))
                color = 1039
                showExLucky = true
            elseif not v.isCurse and exLuckyValue > 0 then -- 幸运 附加幸运
                oneStr = oneStr .. string.format("（+%s）", math.abs(exLuckyValue))
                color = 1039
                showExLucky = true
            end
        end

        if color and color > 0 then
            oneStr = string.format("<font color='%s'>%s</font>", color == 1039 and "#28EF01" or SL:GetHexColorByStyleId(color), oneStr)
        end

        table.insert(
            strList,
            {
                id = v.id,
                str = oneStr
            }
        )
    end

    -- 强度
    if itemData.StdMode ~= 16 and itemData.Source and itemData.Source > 0 then
        local oneStr = string.format("强度：+%s", itemData.Source)
        oneStr = string.format("<font color='%s'>%s</font>", "#28EF01", oneStr)
        table.insert(
            strList,
            {
                str = oneStr
            }
        )
    end

    -- 负重
    if (itemData.StdMode == 52 or itemData.StdMode == 62 or itemData.StdMode == 54 or itemData.StdMode == 64 
        or itemData.StdMode == 84 or itemData.StdMode == 85 or itemData.StdMode == 86 or itemData.StdMode == 87) 
        and itemData.AniCount and itemData.AniCount > 0 then
        local oneStr = string.format("负重：+%s", itemData.AniCount)
        oneStr = string.format("<font color='%s'>%s</font>", "#28EF01", oneStr)
        table.insert(
            strList,
            {
                str = oneStr
            }
        )
    end

    -- 附加幸运/诅咒
    if not showExLucky and exLuckyValue and exLuckyValue ~= 0 then
        local config = SL:GetValue("ATTR_CONFIG", GUIDefine.AttTypeTable.Lucky)
        local showName = config and config.name or "幸运"
        local oneStr = string.format("%s：+%s", exLuckyValue > 0 and showName or "诅咒", math.abs(exLuckyValue))
        oneStr = string.format("<font color='%s'>%s</font>", "#28EF01", oneStr)
        table.insert(
            strList,
            {
                str = oneStr
            }
        )
    end

    local ysStrList = {}
    if yuansuAttrShow and next(yuansuAttrShow) then
        local titleName = ItemTips._showTitleList[2] and ItemTips._showTitleList[2].name or "[元素属性]："
        local titleColor = ItemTips._showTitleList[2] and ItemTips._showTitleList[2].color or 154
        local yuansuTitle = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName)
        table.insert(
            ysStrList,
            {
                str = yuansuTitle
            }
        )
        for _, v in ipairs(yuansuAttrShow) do
            local oneStr = getAlignAttrStr(v)
            local color = v.color
            if exAttShow and exAttShow[v.id] and checkNeedQualityExAdd() then
                oneStr = oneStr .. string.format("（%s）", exAttShow[v.id].value)
            end

            if color and color > 0 then
                oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)
            end

            table.insert(
                ysStrList,
                {
                    id = v.id,
                    str = oneStr
                }
            )
        end
    end

    return strList, ysStrList, attUpList
end

function ItemTips.GetDiyAttStr(itemData)
    local pos =  GUIFunction:GetEmptyPosByStdMode(itemData.StdMode)
    if not pos then
        return nil
    end

    -- 自定义属性
    local attList           = GUIFunction:GetItemDiyAttr(itemData)
    ItemTips._diyAttList    = attList

    local strAttShowList = {}
    if attList and next(attList) then
        for type, attrs in pairs(attList) do
            local showList = GUIFunction:GetSeqAttDataShow(attrs, false, true)
            local strList = {}
            if showList and next(showList) then
                local config = GUIDefineEx.TipsDiyAttrTypeTitle and GUIDefineEx.TipsDiyAttrTypeTitle[type]
                local titleName = config and config.name
                if titleName then
                    if GUIFunction.ParseTitleHasCustomVar then
                        titleName = GUIFunction:ParseTitleHasCustomVar(itemData.MakeIndex, titleName)
                    end
                    local titleColor = config.color or 154
                    local titleStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName)
                    table.insert(strList, {
                        str = titleStr,
                        isTitle = true
                    })
                end
            end

            for _, v in ipairs(showList) do
                local oneStr = getAlignAttrStr(v)
                local color  = tonumber(v.excolor) or 250
                oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)

                table.insert(strList, {
                    id = v.id,
                    str = oneStr
                })
            end

            strAttShowList[type] = next(strList) and strList
        end
    end

    return strAttShowList
end

function ItemTips.GetInlayAttStr(itemData)
    local pos =  GUIFunction:GetEmptyPosByStdMode(itemData.StdMode)
    if not pos then
        return nil
    end

    local strAttShowList = {}

    -- 镶嵌物品
    local cell = itemData.TNCell
    for i = 0, 19 do
        local itemId = cell[i]
        if itemId > 0 then
            local item = SL:GetValue("ITEM_DATA", itemId)
            local attList = GUIFunction:ParseItemBaseAtt(item and item.Attribute, ItemTips._job)
            local attShow = GUIFunction:GetAttDataShow(attList, false, true)
            local showList = {}
            for id, v in pairs(attShow) do
                v.id = id
                local originId = getAttOriginId(id)
                local attConfig = SL:GetValue("ATTR_CONFIG", originId)
                v.sort = attConfig and attConfig.sort or originId + 1000
                table.insert(showList, v)
            end

            table.sort(showList, function(a, b)
                return a.sort < b.sort
            end)
    
            local str = ""
            for k, v in ipairs(showList) do
                local oneStr = getAlignAttrStr(v)
                local color  = tonumber(v.color) or 255
                oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)
                str = str .. (k ~= 1 and "<br>" or "") .. oneStr
            end

            strAttShowList[i] = string.len(str) > 0 and str
        end
    end

    return strAttShowList
end

function ItemTips.GetPowerStr(itemData)
    if not ItemTips._baseAttList then
        -- 基础属性
        local attList = GUIFunction:ParseItemBaseAtt(itemData.Attribute, ItemTips._job)
        -- 极品属性
        local qualityAttrs = GUIFunction:GetItemQualityAttr(itemData)
        -- 合并极品属性
        if qualityAttrs and next(qualityAttrs) then
            attList = GUIFunction:CombineAttList(attList, qualityAttrs)
        end
        ItemTips._baseAttList = attList
    end

    local diyAttList = {}
    if not ItemTips._diyAttList then
        -- 自定义属性
        ItemTips._diyAttList = GUIFunction:GetItemDiyAttr(itemData)
        for type, attTab in pairs(ItemTips._diyAttList) do
            for i = 1, #attTab do
                if attTab[i] and next(attTab[i]) then
                    table.insert(diyAttList, attTab[i])
                end
            end
        end
    end

    local job = ItemTips._job or SL:GetValue("JOB")

    -- 合并
    local allAttList = GUIFunction:CombineAttList(ItemTips._baseAttList, diyAttList)
    local power = 0
    for i, data in ipairs(allAttList) do
        local id = data.id
        local value = data.value
        local config = id and SL:GetMetaValue("ATTR_POWER_CONFIG")[id]
        if config then
            local powerKey = string.format("power%s", job >= 0 and job <= 2 and job + 1 or job)
            local powerValue = config[powerKey] and (math.floor(value / config.value) * config[powerKey]) or 0
            power = power + powerValue
        end
    end

    return string.format("战斗力：%s", power)
end

function ItemTips.GetNeedStr(itemData, isItem)
    local strList = nil
    if _isHero then
        strList = SL:CheckItemUseNeed_Hero(itemData).conditionStr
    else
        strList = SL:CheckItemUseNeed(itemData).conditionStr
    end
    if strList and next(strList) then
        local str = ""
        for i, v in ipairs(strList) do
            local color = v.can and "#ffffff" or "#ff0000"
            local conditionStr = string.format("<font color = '%s'>%s</font>", color, v.str)
            str = str .. conditionStr .. (i ~= #strList and "<br>" or "")
        end
        return str
    end
    return isItem and "需求：无限制" or nil
end

-- 道具时限
function ItemTips.GetTimeStr(type, itemData, from, lookPlayer)
    local time = itemData.limitRemainTime
    local active = itemData.limitTimeActive
    if not time or time <= 0 then
        return nil
    end

    local makeIndex = itemData and itemData.MakeIndex
    if makeIndex then
        if itemData.Need == 102 then -- 穿戴、穿戴后脱到背包、仓库计时
            if (not from or from == ItemFrom.STORAGE) and SL:GetMetaValue("STORAGE_DATA_BY_MAKEINDEX", makeIndex) then  -- 仓库限时服务端不主动刷新
                if itemData.limitEndTime then
                    time = math.max(itemData.limitEndTime - SL:GetMetaValue("SERVER_TIME"), 0)
                end
            end
        end
        if lookPlayer and itemData.limitEndTime then
            time = math.max(itemData.limitEndTime - SL:GetMetaValue("SERVER_TIME"), 0)
        end
    end

    local str = string.format("%s：%s", type == 1 and "限时装备" or "限时道具", SL:TimeFormatToStr(time))

    return str
end

-- 来源
function ItemTips.GetSrcStr(itemData)
    local src = itemData.ItemSrc
    if not src or not next(src) then
        return nil
    end
    local titleName = ItemTips._showTitleList[4] and ItemTips._showTitleList[4].name or "[物品来源]："
    local titleColor = ItemTips._showTitleList[4] and ItemTips._showTitleList[4].color or 154
    local str = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName) .. "<br>"

    local map = src.Map
    local srcName = src.DropName
    local userName = src.ChrName
    local time = src.Time

    if not(map and string.len(map) > 0) and not(srcName and string.len(srcName) > 0) and not(userName and string.len(userName) > 0) and not(time and time > 0) then
        return nil
    end
    if map and string.len(map) > 0 then
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "地图", map)
    end
    if srcName and string.len(srcName) > 0 then
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "出处", srcName)
    end
    if userName and string.len(userName) > 0 then
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "角色", userName)
    end
    if time and time > 0 then
        local date = os.date("*t", time)
        local timeStr = string.format("%d-%02d-%02d %02d:%02d:%02d", date.year, date.month, date.day, date.hour, date.min, date.sec)
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "时间", timeStr)
    end

    str = string.gsub(str, "<br>$", "")
    return str
end

-- 技能书 职业等级限制
function ItemTips.GetSkillBookLimitStr(itemData, from)
    local str = nil
    if isSkillBook(itemData) then
        local bagUse = true
        local job = SL:GetValue("JOB")
        local needJob = itemData.Shape or 0
        -- 内功等级 （1 怒之 2 静之）
        local needNGLV = itemData.Source == 1 or itemData.Source == 2
        local conditionStr = "需要职业：%s"
        local jobName = "通用"
        local level = _isHero and SL:GetValue("H.LEVEL") or SL:GetValue("LEVEL")
        if needNGLV then
            level = _isHero and SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_LEVEL) or SL:GetValue("CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_LEVEL)
        end
        local newMeetJob = nil
        local jobNameList = {
            [1] = "战士",
            [2] = "法师",
            [3] = "道士"
        }
        if needJob >= 0 and needJob <= 2 then -- 人物
            conditionStr = "人物职业：%s"
            jobName = jobNameList[1 + needJob]
        elseif needJob >= 3 and needJob <= 5 then -- 英雄
            job = SL:GetValue("H.JOB")
            needJob = needJob - 3
            conditionStr = "英雄职业：%s"
            jobName = jobNameList[1 + needJob]
            level = needNGLV and SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_LEVEL) or SL:GetValue("H.LEVEL")
            bagUse = false
        elseif needJob == 6 then -- 合击技能
            -- 0=战士, 1=法师, 2=道士, 99=全职业
            local needJobCondition = {
                [60] = {0, 0},
                [61] = {0, 2},
                [62] = {0, 1},
                [63] = {2, 2},
                [64] = {2, 1},
                [65] = {1, 1}
            }
            newMeetJob = false
            local heroJob = SL:GetValue("H.JOB")
            local newCondition = needJobCondition[itemData.AniCount]
            if newCondition then
                if newCondition[1] == job and newCondition[2] == heroJob then
                    newMeetJob = true
                end
                local jobColor = newCondition[1] == job and "#FFFFFF" or "#FF0500"
                local heroJobColor = newCondition[2] == heroJob and "#FFFFFF" or "#FF0500"
                local str = "<font color='%s' size='%s'>%s</font>+<font color='%s' size='%s'>%s</font>"
                local fontSize = fontSize
                jobName =
                    string.format(
                    str,
                    jobColor,
                    fontSize,
                    jobNameList[1 + newCondition[1]],
                    heroJobColor,
                    fontSize,
                    jobNameList[1 + newCondition[2]]
                )
            end
            level = math.min(SL:GetValue("H.LEVEL"), SL:GetValue("LEVEL"))
        elseif needJob >= 9 and needJob <= 20 then -- 多职业
            conditionStr = "人物职业：%s"
            needJob = needJob - 4
            jobName = SL:GetValue("JOB_NAME", needJob) or ""
        end
        jobName = string.format(conditionStr, jobName)
        local meetJob = needJob == 99 or needJob == job
        if newMeetJob ~= nil then
            meetJob = newMeetJob
        end
        if from == ItemFrom.HERO_BAG then
            bagUse = true
        end

        local jobStr =
            string.format(
            "<font color='%s'>%s</font>",
            bagUse and meetJob and "#FFFFFF" or "#FF0500",
            jobName
        )
        local needLevel = itemData.DuraMax
        local meetLevel = level >= needLevel
        local levelStr =
            string.format(
            "<font color='%s'>%s%s</font>",
            meetLevel and "#FFFFFF" or "#FF0500",
            needNGLV and "需要内功等级：" or "需要等级：",
            needLevel
        )

        str = jobStr .. "<br>" .. levelStr
    end

    return str
end

-- 聚灵珠消耗
function ItemTips.GetJulingCostStr(itemData)
    local str = nil
    if itemData.StdMode == 49 and itemData.AniCount and itemData.AniCount > 0 then
        local moneyId = itemData.AniCount
        local need = itemData.Need
        str = string.format("释放需要花费%s%s", need, SL:GetValue("ITEM_NAME", moneyId))
    end

    return str
end

-- 药品
function ItemTips.GetHpMpStr(itemData)
    if itemData.StdMode == 0 and (itemData.Shape == 0 or itemData.Shape == 1) and string.len(itemData.effectParam or "") > 0 then
        local str = ""
        local sliceStr = string.split(itemData.effectParam, "#")
        for i = 1, #sliceStr do
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

-- 物品属性描述
function ItemTips.GetItemAttDescStr(itemData)
    local itemStrList = GUIFunction:GetItemAttDesc(itemData, ItemTips._job) or {}
    if next(itemStrList) then
        local attrStr = ""
        for i, line in ipairs(itemStrList) do
            if next(line) then
                if i ~= 1 then
                    attrStr = attrStr .. "<br>"
                end
                for k, txt in ipairs(line) do
                    attrStr = attrStr .. txt .. (k ~= #line and "<br>" or "")
                end
            end
        end
        return attrStr
    end
    return false
end

local function getJobDesc(desc)
    if not desc or desc == "" then
        return
    end
    local str = ""
    local descs = string.split(desc or "", "&")
    for i, v in ipairs(descs) do
        local strs = string.split(v, "#")
        if strs[2] then
            local jobNum = tonumber(strs[1])
            if jobNum == 3 or (ItemTips._job and jobNum == ItemTips._job) then
                str = str .. (strs[2] or "")
            end
        else
            str = str .. (strs[1] or "")
        end
    end
    return str
end

-- 新套装
function ItemTips.GetSuitStr(suit)
    local suitConfigs = SL:GetValue("SUITEX_CONFIG", tonumber(suit))
    if not suitConfigs or not next(suitConfigs) then
        return
    end

    -- 解析新的颜色规则  未获得颜色#获得颜色   无则使用第一个未获得颜色
    local function getNewColor(txtStr, colorIdx)
        txtStr = string.gsub(txtStr or "", "<br>", "\n")
        local colorStr = ""
        local showStr = ""
        local txtArray = string.split(txtStr or "", "|")
        if #txtArray > 1 then
            colorStr = txtArray[1] or ""
            for i = 2, #txtArray do
                showStr = showStr .. (txtArray[i] or "")
            end
        else
            showStr = txtStr
        end
        colorIdx = colorIdx or 1
        local colorArry = string.split(colorStr or "", "/")
        if #colorArry <= 1 then
            table.insert(colorArry, 1, 249)
        end
        return tonumber(colorArry[colorIdx]) or tonumber(colorArry[1]), showStr
    end

    -- 检测部位是否存在相应的装备
    local function checkEquipMeet(suitConfig, pos)
        local meet = false
        local equip = nil
        local equipName = nil
        if not _lookPlayer then
            if _isHero then
                equip = SL:GetValue("H.EQUIP_DATA", pos)
            else
                equip = SL:GetValue("EQUIP_DATA", pos)
            end
        else
            equip = SL:GetValue("L.M.EQUIP_DATA", pos)
        end
        local equipsuit = nil
        if equip and equip.suitid and string.len(equip.suitid) > 0 then
            equipsuit = equip.suitid
        end
        if equipsuit then
            local equipSuitArray = string.split(equipsuit, "#")
            for i, v in ipairs(equipSuitArray) do
                if v and string.len(v) > 0 then
                    local posSuitConfig = SL:GetValue("SUITEX_CONFIG", tonumber(v))
                    if
                        posSuitConfig and posSuitConfig[1] and posSuitConfig[1].suittype == suitConfig.suittype and
                            posSuitConfig[1].level >= suitConfig.level
                     then
                        meet = true
                        equipName = equip.originName or equip.Name
                        break
                    end
                end
            end
        end
        return meet, equipName
    end

    -- 获取职业匹配的属性描述
    local posCheckSwitch = tonumber(SL:GetValue("GAME_DATA", "suitCheckPos")) == 1 --做个开关， 是由装备位还是装备名作为检测key（默认是装备名）
    local suitStr = ""
    for cfgIdx, suitConfig in ipairs(suitConfigs) do
        if suitConfig and next(suitConfig) then
            local suitCount = suitConfig.num
            if suitConfig.desc and suitConfig.desc ~= "" then  -- 套装无描述不显示
                local meetCount = 0
                local equipshowArray = string.split(suitConfig.equopshow or "", "|")
                local equipShowColorStr = ""
                local equipShowStr = equipshowArray[1] or ""
                if #equipshowArray > 1 then
                    equipShowColorStr = equipshowArray[1] or ""
                    if equipShowColorStr and equipShowColorStr ~= "" then
                        equipShowColorStr = equipShowColorStr .. "|"
                    end
                    equipShowStr = equipshowArray[2] or ""
                end
                local equipShow = string.split(equipShowStr or "", "#")
                local equipPos = string.split(suitConfig.equipid or "", "#")
                local showEquipIdx = 1
                local checkIndex = 1
                local meetEquipShow = {}
                local tempMeetEquipShowCount = {}
                local isDistinct = suitConfig.distinct == 1 --(部位5 6、 7 8检测去除一个检测)
                local cullingCheckPos = {} --去除检测的部位做个标记

                for i, pos in ipairs(equipPos) do
                    pos = tonumber(pos)
                    if pos and not cullingCheckPos[pos] then
                        local nextCheckPos = nil
                        if isDistinct then
                            if pos == 5 then
                                nextCheckPos = 6
                            elseif pos == 6 then
                                nextCheckPos = 5
                            elseif pos == 7 then
                                nextCheckPos = 8
                            elseif pos == 8 then
                                nextCheckPos = 7
                            end
                        end

                        if nextCheckPos then
                            cullingCheckPos[nextCheckPos] = true
                        end

                        local meet, equipName = checkEquipMeet(suitConfig, pos)

                        if not meet and nextCheckPos then
                            meet, equipName = checkEquipMeet(suitConfig, nextCheckPos)
                        end

                        if meet then
                            meetCount = meetCount + 1
                        end
                        if not suitConfig.num then
                            suitCount = suitCount + 1
                        end

                        if equipName then
                            local meetKey = posCheckSwitch and i or equipName --是用下标做key,或者道具名
                            meetEquipShow[meetKey] = meet
                            if meet then
                                tempMeetEquipShowCount[meetKey] = (tempMeetEquipShowCount[meetKey] or 0) + 1
                            end
                        end
                    end
                end

                for i, showStr in ipairs(equipShow) do
                    if showStr and showStr ~= "" then
                        local meetKey = posCheckSwitch and i or showStr --是用下标做key,或者道具名
                        local meet = meetEquipShow[meetKey]

                        if tempMeetEquipShowCount[meetKey] then
                            if meet and tempMeetEquipShowCount[meetKey] <= 0 then
                                meet = false
                            end
                            tempMeetEquipShowCount[meetKey] = tempMeetEquipShowCount[meetKey] - 1
                        end

                        showStr = equipShowColorStr .. showStr
                        local color, showShowStr = getNewColor(showStr, meet and 2 or 1)
                        local size = fontSize
                        local colorHex = SL:GetHexColorByStyleId(color)
                        local showStrFormat = string.format("<font color='%s' size='%s'>%s</font><br>", colorHex, size, showShowStr)
                        suitStr = suitStr .. showStrFormat
                    end
                end

                local titleStr = suitConfig.name or ""
                if titleStr and string.len(titleStr) > 0 then
                    local color, showTitle = getNewColor(titleStr, meetCount >= suitCount and 2 or 1)
                    local size = fontSize
                    local colorHex = SL:GetHexColorByStyleId(color)
                    local mCount = meetCount > suitCount and suitCount or meetCount
                    local showTitleFormat =
                        string.format(
                        "<font color='%s' size='%s'>%s (%s/%s)</font><br>",
                        colorHex,
                        size,
                        showTitle,
                        mCount,
                        suitCount
                    )
                    suitStr = showTitleFormat .. suitStr
                end

                local descStr = getJobDesc(suitConfig.desc)
                if descStr and string.len(descStr) > 0 then
                    local color, showDescStr = getNewColor(descStr, meetCount >= suitCount and 2 or 1)
                    local size = fontSize
                    local colorHex = SL:GetHexColorByStyleId(color)
                    local showDescStrFormat = string.format("<font color='%s' size='%s'>%s</font><br>", colorHex, size, showDescStr)
                    suitStr = suitStr .. showDescStrFormat
                end
            end
        end
    end

    return string.len(suitStr) > 0 and suitStr
end

-- 星级
function ItemTips.GetStarPanel(star)

    local starColNum = 10 -- 单行星星数
    local starPattern = GUIDefineEx.TipsStarPattern
    local resSpace = starPattern.resSpace or 0
    local offY = starPattern.offY or 0
    local starWid = starPattern.starWid or 25 -- 星星宽
    local starHei = starPattern.starHei or 25 -- 星星高
    local starRes = {
        [1] = {img = _resPath .. "bg_tipszyxx_05.png"},
        [2] = {img = _resPath .. "bg_tipszyxx_04.png"}
    }

    if starPattern.starRes and next(starPattern.starRes) then
        for i, v in ipairs(starPattern.starRes) do
            if v and next(v) then
                if v.img then
                    local tempRes = SL:CopyData(v)
                    tempRes.img = string.gsub(string.format("%s%s", _resPath, v.img), "\\", "/")
                    starRes[i] = tempRes
                else
                    starRes[i] = v
                end
            end
        end
    end


    local starNorms = {1, 10, 100, 1000}
    local starList = {}

    local starCount = 0 -- 取星星总数
    for i = #starNorms, 1, -1 do
        local v = starNorms[i]
        if star >= v then
            local count = math.floor(star / v)
            star = star - count * v
            starList[#starList + 1] = {
                count = count,
                res = starRes[i] or (i > 1 and starRes[2] or starRes[1])
            }
            starCount = starCount + count
        end
    end

    local colCount = math.min(starCount, starColNum)
    local rowCount = math.ceil(starCount / starColNum)
    local panelSize = {
        width = colCount * starWid + (colCount - 1) * resSpace,
        height = rowCount * starHei + (rowCount - 1) * resSpace
    }
    local panel = GUI:Layout_Create(-1, "star_panel", 0, 0, panelSize.width, panelSize.height)

    local posI = 0
    local row = 1
    for k, v in ipairs(starList) do
        if v and v.res and v.count > 0 then
            for i = 1, v.count do
                local resNode = nil
                if v.res.img then -- 图片
                    resNode = GUI:Image_Create(panel, string.format("star_img_%s_%s", k, i), 0, 0, v.res.img)
                    GUI:setAnchorPoint(resNode, 0.5, 0)
                elseif v.res.sfx then -- 特效
                    resNode = GUI:Effect_Create(panel, string.format("star_sfx_%s_%s", k, i), 0, 0, 0, v.res.sfx)
                end

                if posI == starColNum then
                    posI = 0
                    row = row + 1
                end

                if resNode then
                    posI = posI + 1
                    local x = posI * starWid * 0.5 + (posI - 1) * starWid * 0.5 + (posI - 1) * resSpace
                    local y = panelSize.height - (row * starHei + (row - 1) * resSpace) + offY
                    GUI:setPosition(resNode, x, y)
                end
            end
        end
    end

    return panel
end

---------------------
function ItemTips.AddTipLayout(parent, name)
    local node = GUI:Widget_Create(parent, "widget_" .. name, 0, 0)
    GUI:LoadExport(node, "item/item_tips")
    local ui = GUI:ui_delegate(node)
    local tipsPanel = ui.tipsLayout
    GUI:removeFromParent(tipsPanel)
    GUI:setName(tipsPanel, name)
    GUI:addChild(parent, tipsPanel)
    GUI:removeFromParent(node)
    return tipsPanel
end

-- 获取新tips模块
function ItemTips.GetNewTipsPanel(tag)
    _panelNum = _panelNum + 1
    local childs = ItemTips._panelSortItems
    local lastWidget = childs[#childs]
    local x = GUI:getPositionX(lastWidget)
    local y = GUI:getPositionY(lastWidget)
    local wid = GUI:getContentSize(lastWidget).width

    local tipsPanel = ItemTips.AddTipLayout(ItemTips._PList, "tipsLayout_" .. tag)
    GUI:setPosition(tipsPanel, wid + x, 0)
    GUI:setTouchEnabled(tipsPanel, false)
    GUI:setAnchorPoint(tipsPanel, 0, 1)
    table.insert(ItemTips._panelSortItems, tipsPanel)

    local listView = GUI:ListView_Create(tipsPanel, "listView_" .. tag, 0, 0, 0, 0, 1)
    GUI:ListView_setItemsMargin(listView, ItemTips._cellSpace)
    GUI:setTouchEnabled(listView, false)

    return tipsPanel, listView
end

-- 衣服、武器内观预览
function ItemTips.GetModelPanel(itemData)
    local isShow = tonumber(SL:GetValue("GAME_DATA", "itemShowModel"))
    if not isShow or isShow ~= 1 then
        return
    end

    if ItemTips._diff or _isSelf or not itemData or not itemData.StdMode then
        return nil
    end
    local StdMode = itemData.StdMode
    local pos = GUIFunction:GetEmptyPosByStdMode(StdMode)
    if not pos then
        return nil
    end

    local preViewPos = {
        [0] = 0,
        [1] = 1,
        [17] = 17,
        [18] = 18
    }

    if not preViewPos[pos] then
        return nil
    end

    local sex = SL:GetValue("SEX")
    local job = SL:GetValue("JOB")
    local feature = {}

    local data = SL:GetValue("FEATURE")
    local hairID = data and data.hairID
    local normalDress = sex == 0 and 60 or 80

    if pos == 0 or pos == 17 then -- 衣服
        sex = 0 and StdMode == 10 and 0 or 1
        feature.clothID = itemData.Looks
        feature.clothEffectID = itemData.sEffect
    elseif pos == 1 or pos == 18 then -- 武器
        feature.weaponID = itemData.Looks
        feature.weaponEffectID = itemData.sEffect
        feature.clothID = normalDress
    end

    if not next(feature) then
        return nil
    end

    feature.hairID = hairID
    feature.showNodeModel = true
    _panelNum = _panelNum + 1

    local size = {width = 200, height = 260}
    local tipsPanel = ItemTips.GetNewTipsPanel("model")
    GUI:setContentSize(tipsPanel, size.width, size.height)

    local model = GUI:UIModel_Create(tipsPanel, "model", size.width / 2, size.height / 2, sex, feature, nil, true, job)
end

-- 获取新套装tips
function ItemTips.GetNewSuitPanel(suit, itemData)
    if not suit or suit == "" then
        return nil
    end

    local suitWidth = screenW / 2

    local suitStr = ItemTips.GetSuitStr(suit)

    if string.len(suitStr or "") == 0 then
        return
    end

    local tipsPanel, listView = ItemTips.GetNewTipsPanel("new_suit" .. (itemData.MakeIndex or "_") .. suit)

    local rich_suit = GUI:RichText_Create(listView, "rich_suit", 0, 0, suitStr, suitWidth - 20, fontSize, "#28EF01", vspace, nil, fontPath)
    GUI:setAnchorPoint(rich_suit, 0, 0)

    local size = GUI:getContentSize(rich_suit)
    local richWidth = size.width

    GUI:ListView_doLayout(listView)
    local innH = GUI:ListView_getInnerContainerSize(listView).height
    local listH = math.min(innH, _tipsMaxH)
    GUI:setContentSize(listView, richWidth, listH)
    GUI:setPosition(listView, 10, 10)
    GUI:setContentSize(tipsPanel, richWidth + 20, listH + 20)

    if innH > listH then
        GUI:setTouchEnabled(listView, true)
        ItemTips.SetTipsScrollArrow(tipsPanel, listView, innH, listH)
    end
end

-----------------------
-- 设置箭头
function ItemTips.SetTipsScrollArrow(tipsPanel, listView, innH, listH)
    local maxWidth = GUI:getContentSize(tipsPanel).width

    GUI:ListView_doLayout(listView)
    local listY = GUI:getPositionY(listView)
    -- 底部箭头
    local bottomArrowImg = GUI:Image_Create(tipsPanel, "bottom_arrow", maxWidth / 2, listY + 15, "res/public/btn_szjm_01_1.png")
    GUI:setTouchEnabled(bottomArrowImg, true)
    GUI:setAnchorPoint(bottomArrowImg, 0.5, 0.5)
    GUI:setRotation(bottomArrowImg, -90)
    local action =
        GUI:ActionRepeatForever(
        GUI:ActionSequence(GUI:ActionFadeTo(0.2, 125), GUI:ActionFadeTo(0.2, 255), GUI:DelayTime(0.3))
    )
    GUI:runAction(bottomArrowImg, action)

    -- 顶部箭头
    local topArrowImg = GUI:Image_Create(tipsPanel, "top_arrow", maxWidth / 2, listY + listH - 15, "res/public/btn_szjm_01_1.png")
    GUI:setTouchEnabled(topArrowImg, true)
    GUI:setAnchorPoint(topArrowImg, 0.5, 0.5)
    GUI:setRotation(topArrowImg, 90)
    GUI:runAction(topArrowImg, action)

    local function refreshArrow()
        local innerPos = GUI:ListView_getInnerContainerPosition(listView)
        if ItemTips.typeCapture == 1 then
            GUI:setVisible(bottomArrowImg, false)
        else
            GUI:setVisible(bottomArrowImg, innerPos.y < innH and innerPos.y < 0)
            GUI:setVisible(topArrowImg, innerPos.y > (listH - innH) or innerPos.y >= 0)
        end
    end

    refreshArrow()

    local bottomEvent = function()
        if innH > listH and not GUI:Widget_IsNull(listView) then
            local innerPos      = GUI:ListView_getInnerContainerPosition(listView)
            local vHeight       = innH - listH
            local percent       = (vHeight + innerPos.y + 50) / vHeight * 100
            percent             = math.min(math.max(0, percent), 100)
            GUI:ListView_scrollToPercentVertical(listView, percent, 0.03, false)
            refreshArrow()
        end
    end

    local topEvent = function()
        if innH > listH and not GUI:Widget_IsNull(listView) then
            local innerPos      = GUI:ListView_getInnerContainerPosition(listView)
            local vHeight       = innH - listH
            local percent       = (vHeight + innerPos.y - 50) / vHeight * 100
            percent             = math.min(math.max(0, percent), 100)
            GUI:ListView_scrollToPercentVertical(listView, percent, 0.03, false)
            refreshArrow()
        end
    end

    GUI:addOnClickEvent(bottomArrowImg, function()
        bottomEvent()
    end)

    GUI:addOnClickEvent(topArrowImg, function()
        topEvent()
    end)

    if SL:GetValue("IS_PC_OPER_MODE") then
        ItemTips._topScrollEvent      = topEvent
        ItemTips._bottomScrollEvent   = bottomEvent
    end
    SL:schedule(bottomArrowImg, refreshArrow, 0.1)
end

function ItemTips.GetTipsAnchorPoint(widget, pos, ancPoint)
    ancPoint = ancPoint or GUI:getAnchorPoint(widget)
    local size = GUI:getContentSize(widget)
    local visibleSize = {width = screenW, height = screenH}
    local outScreenX = false
    local outScreenY = false
    if pos.y + size.height * ancPoint.y > visibleSize.height then
        ancPoint.y = 1
        outScreenY = true
    end
    if pos.y - size.height * ancPoint.y < 0 then
        if outScreenY then
            ancPoint.y = 0.5
            pos.y = toEven(visibleSize.height / 2)
        else
            ancPoint.y = 0
        end
    end

    if pos.x + size.width * (1 - ancPoint.x) > visibleSize.width then
        ancPoint.x = 1
        outScreenX = true
    end
    if pos.x - size.width * ancPoint.x < 0 then
        if outScreenX then
            ancPoint.x = 0.5
            pos.x = toEven(visibleSize.width / 2)
        else
            ancPoint.x = 0
        end
    end
    return ancPoint, pos
end

function ItemTips.ResetEquipPosition()
    if not ItemTips._PList then
        return
    end

    local space = 0
    local width = 0
    local maxHeight = 0
    for _, v in ipairs(GUI:getChildren(ItemTips._PList)) do
        local size = GUI:getContentSize(v)
        width = width + size.width + space
        maxHeight = math.max(maxHeight, size.height)
    end

    GUI:setContentSize(ItemTips._PList, width, maxHeight)
    width = 0
    for _, v in pairs(ItemTips._panelSortItems) do
        GUI:setPositionX(v, width)
        local size = GUI:getContentSize(v)
        width = width + size.width + space
        GUI:setPositionY(v, maxHeight)
    end
    local pos = {
        x = GUI:getPositionX(ItemTips._PList),
        y = GUI:getPositionY(ItemTips._PList)
    }
    local anchorPoint, pos = ItemTips.GetTipsAnchorPoint(ItemTips._PList, pos, ItemTips._data.anchorPoint or {x=0, y=1})
    GUI:setAnchorPoint(ItemTips._PList, anchorPoint.x, anchorPoint.y)
    GUI:setPosition(ItemTips._PList, toEven(pos.x), toEven(pos.y))
end

function ItemTips.AddFrameEffect(parent, effectList)
    if effectList and next(effectList) then
        for i, param in ipairs(effectList) do
            local effectId = param.effectId
            local type = param.type
            local mode = param.mode
            
            local sfx = GUI:Effect_Create(parent, "frame_effect_" .. i, 0, 0, 0, effectId)
            if sfx then
                if mode == 2 then
                    GUI:setLocalZOrder(sfx, -1)
                end

                if param.scaleX and param.scaleX > 0 then
                    GUI:setScaleX(sfx, param.scaleX)
                end
                if param.scaleY and param.scaleY > 0 then
                    GUI:setScaleY(sfx, param.scaleY)
                end

                local tipsPanelHei = GUI:getContentSize(parent).height
                local offsetX, offsetY = param.x or 0, param.y or 0
                local oriPos = GUI:getPosition(sfx)
                GUI:setPosition(sfx, oriPos.x + offsetX, oriPos.y + offsetY + (type == 0 and tipsPanelHei or 0))
            end
        end
    end
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

-- 关闭界面
function ItemTips.OnClose()
    SL:UnRegisterLUAEvent(LUA_EVENT_ITEMTIPS_MOUSE_SCROLL, "ItemTips")
    SL:UnRegisterLUAEvent(LUA_EVENT_USERINPUT_EVENT_NOTICE, "ItemTips")
end

---------------------------------------------------
local function firstToUpper(str)
    return str:sub(1, 1):upper() .. str:sub(2)
end

local function removeLastLine()
    if not ItemTips._curCellView then
        return
    end

    local items = GUI:ListView_getItems(ItemTips._curCellView)
    local lastItem = items[#items]
    local lastWidget = GUI:getChildren(lastItem)[1]
    if (lastItem and string.find(GUI:getName(lastItem), "PLINE")) or (lastWidget and string.find(GUI:getName(lastWidget), "PLINE")) then
        local lastHei = GUI:getContentSize(lastItem).height
        GUI:ListView_removeChild(ItemTips._curCellView, lastItem)
        ItemTips._cell_num = ItemTips._cell_num - 1
        ItemTips._allCellHei = ItemTips._allCellHei - lastHei
        return lastHei
    end
end

-- 分割线
function ItemTips.CreateSplitLine(width, height)
    width = toEven(width or (ItemTips._maxWidth - 2 * rightSpace))
    height = toEven(height or 10)

    local pLine = GUI:Layout_Create(-1, "PLINE", 0, 0, width, height)
    local line = GUI:Image_Create(pLine, "line", width / 2, height / 2, _resPath .. "line_tips_01.png")
    GUI:setAnchorPoint(line, 0.5, 0.5)
    return pLine
end

function ItemTips.CreateWearWidget(param)
    if not param or not next(param) then
        return
    end
    
    if not param.tip_isWear then
        return
    end

    -- 装备穿戴状态
    if param.tip_isWear then
        local widget = GUI:RichText_Create(-1, "r_diff", 0, 0, "[当前身上装备]", ItemTips._richWid, _nameSize, SL:GetHexColorByStyleId(250), vspace, nil, fontPath)
        return widget
    end
end

function ItemTips.CreateNameWidget(param)
    if not param or not next(param) then
        return
    end
    
    if not param.tip_nameStr then
        return
    end

    -- 装备名称
    local color = param.tip_nameColor or 255
    local r_name = GUI:RichText_Create(-1, "r_name", 0, 0, param.tip_nameStr, ItemTips._richWid, _nameSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
    return r_name
end

function ItemTips.CreateIconWidget(param)
    local color = param and param.tip_nameColor or 255

    local itemData = param and param.tip_itemData
    if not itemData then
        return
    end

    local isItem = param and param.tip_isItem
    local noShowIcon = isItem and (tonumber(SL:GetValue("GAME_DATA", "itemTypeName")) == 0)
    if noShowIcon then
        return
    end

    local width = ItemTips._richWid
    -- icon
    local res = _resPath .. (SL:GetValue("IS_PC_OPER_MODE") and "1900025000.png" or "1900025001.png")
    local iconBg = GUI:Image_Create(-1, "icon_bg", 0, 0, res)
    local size = GUI:getContentSize(iconBg)
    local item = GUI:ItemShow_Create(iconBg, "item_", size.width / 2, size.height / 2, {itemData = itemData, index = itemData.Index, disShowCount = true, notShowEquipRedMask = true, noMouseTips = true})
    GUI:setAnchorPoint(item, 0.5, 0.5)

    local iconMoveY = SL:GetValue("IS_PC_OPER_MODE") and -2 or 0
    -- 绑定
    if itemData.Bind and string.len(itemData.Bind) > 0 and SL:GetValue("ITEM_IS_BIND", itemData) then
        local rich_bind = GUI:RichText_Create(iconBg, "rich_bind", size.width + 10, size.height + iconMoveY, "已绑定", width, fontSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_bind, 0, 1)
        -- 特殊需要单独设置
        GUI:RefPosByParent(rich_bind)
    end

    if isItem then
        -- 类型
        local typeStr = param and param.tip_itemTypeStr
        if typeStr and string.len(typeStr) > 0 then
            local rich_type = GUI:RichText_Create(iconBg, "rich_type", size.width + 10, size.height / 2 + iconMoveY, typeStr, width, fontSize, "#ffffff", vspace, nil, fontPath)
            GUI:setAnchorPoint(rich_type, 0, 0.5)
            GUI:RefPosByParent(rich_type)
        end

        -- 条件限制
        local needStr = param and param.tip_needStr
        if needStr and not isSkillBook(itemData) then
            local rich_need = GUI:RichText_Create(iconBg, "rich_need", size.width + 10, iconMoveY, needStr, width,  fontSize, "#ffffff", vspace, nil, fontPath)
            GUI:RefPosByParent(rich_need)
        end

    else
        -- 重量
        if itemData.Weight and itemData.Weight > 0 then
            local str = string.format("重量：%s", itemData.Weight)
            local rich_weight = GUI:RichText_Create(iconBg, "rich_weight", size.width + 10, size.height / 2 + iconMoveY, str, width, fontSize, "#FFFFFF", vspace, nil, fontPath)
            GUI:setAnchorPoint(rich_weight, 0, 0.5)
            GUI:RefPosByParent(rich_weight)
        end

        -- Mode
        local modeStr = param and param.tip_modeStr
        if modeStr then
            local rich_mode = GUI:RichText_Create(iconBg, "rich_mode", size.width + 10, iconMoveY, modeStr, width, fontSize, "#FFFFFF", vspace, nil, fontPath)
            GUI:RefPosByParent(rich_mode)
        end

    end

    return iconBg
end

function ItemTips.CreateTouBaoWidget(param)
    local isItem = param and param.tip_isItem
    if isItem then
        return
    end

    -- 投保
    local tbStr = param and param.tips_toubaoStr
    if tbStr then
        local rich_tb = GUI:RichText_Create(-1, "rich_need", 0, 0, tbStr, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath) 
        return rich_tb
    end
end

function ItemTips.CreateStarWidget(param)
    local star = param and param.tip_star

    -- 星级
    if star and star > 0 then
        local starPanel = ItemTips.GetStarPanel(star)
        return starPanel
    end
end

function ItemTips.CreateSwordOfSoulWidget(param, index)
    local itemData = param and param.tip_itemData
    if not itemData or not itemData.MakeIndex then
        return nil
    end
    local data = GUIDefineEx.TipsSwordOfSoulTitle
    local soulData = data and data[index]
    if not soulData or not next(soulData) then
        return
    end
    local switch        = soulData.switch or 0      -- 进度条是否关闭
    local nameStr       = soulData.name or ""       -- 名称
    local value         = soulData.value            -- 进度值
    local showWay       = soulData.showWay or 0     -- 显示方式 0: 数值 1: 万分比
    local color         = soulData.color or 255     -- 颜色
    local maxValue      = soulData.maxValue or 100  -- 最大值
    local loop          = soulData.loop or 0        -- 图片是否循环播放
    
    local itemMakeIndex = itemData.MakeIndex
    if GUIFunction.ParseTitleHasCustomVar then
        nameStr = GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, nameStr)
        value = tonumber(GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, value or ""))
        color = tonumber(GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, color)) or 255
        switch = tonumber(GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, switch)) or 0
        maxValue = tonumber(GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, maxValue)) or 100
        loop = tonumber(GUIFunction:ParseTitleHasCustomVar(itemMakeIndex, loop)) or 0
    end
    if switch == 1 then -- 1: 关闭
        return nil
    end
    if not value then
        return nil
    end
    local hexColor = SL:GetHexColorByStyleId(color or 255)
    local swordSoulPanel = GUI:Layout_Create(-1, "swordSoulPanel_" .. index, 0, 0, 0, 0)
    local swordSoulName = GUI:Text_Create(swordSoulPanel, "swordSoulName", 0, 0, fontSize, hexColor, nameStr) 
    GUI:Text_enableOutline(swordSoulName, "#000000", 1)

    local swordSoulNameSz = GUI:getContentSize(swordSoulName)
    local nameW = swordSoulNameSz.width

    local tipW = nameW
    local tipH = swordSoulNameSz.height

    local offX = 10
    local basePath = (SL:GetMetaValue("WINPLAYMODE") and _resPathWin or _resPath) .. "sword_soul/"
    local barImgPath = string.format(basePath .. "jdtbg_1.png")

    local bgImg = GUI:Image_Create(swordSoulPanel, "bg_img", nameW + offX, 0, barImgPath)
    local bgImgSz = GUI:getContentSize(bgImg)
    local imgIndex = 1
    local progressImgPath = string.format(basePath .. "jdt%d_1.png", imgIndex)
    local slider = GUI:Slider_Create(swordSoulPanel, "slider", nameW + offX + 5, 1, "", progressImgPath, "")
    GUI:setAnchorPoint(slider, 0, 0)
    GUI:setContentSize(slider, bgImgSz.width - 10, bgImgSz.height - 2)

    if loop == 1 then
        SL:schedule(slider, function()
            imgIndex = imgIndex + 1
            if imgIndex > 3 then
                imgIndex = 1
            end
            progressImgPath = string.format(basePath .. "jdt%d_1.png", imgIndex)
            GUI:Slider_loadProgressBarTexture(slider, progressImgPath)
        end, 0.3)
    end

    -- 万分比时最大值默认10000
    if showWay == 1 then
        maxValue = 10000
    end
    local percent = value / maxValue * 100
    if percent > 100 then
        percent = 100
    end
    GUI:Slider_setPercent(slider, percent)
    local sliderSz = GUI:getContentSize(slider)

    local progressStr = ""
    if showWay == 1 then
        progressStr = string.format("%.2f%%", percent)
    elseif showWay == 0 then
        progressStr = string.format("%d/%d", value, maxValue)
    end

    local progress = GUI:Text_Create(swordSoulPanel, "progress_txt", nameW + offX + bgImgSz.width / 2, bgImgSz.height / 2, 10, hexColor, progressStr)
    GUI:Text_enableOutline(progress, "#000000", 1)
    GUI:setAnchorPoint(progress, 0.5, 0.5)

    tipW = tipW + bgImgSz.width + offX
    tipH = math.max(tipH, bgImgSz.height)
    GUI:setContentSize(swordSoulPanel, tipW, tipH)
    return swordSoulPanel
end

function ItemTips.CreateBaseAttrWidget(param)
    local isItem = param and param.tip_isItem
    if isItem then
        return
    end

    local itemData = param and param.tip_itemData
    if not itemData then
        return
    end

    -- 基础属性
    local width = ItemTips._richWid

    local widget = nil
    if not ItemTips._baseAttrs then
        ItemTips._baseAttrs, ItemTips._ysAttrs, ItemTips._upAttrs = ItemTips.GetAttStr(itemData, param.tip_isWear)
    end
    local attStr = ItemTips._baseAttrs
    local upAttrs = ItemTips._upAttrs
    local showAttr = true
    -- 神秘装备(戒指/手镯/头盔)
    if (itemData.StdMode == 22 and itemData.Shape == 130) or (itemData.StdMode == 26 and itemData.Shape == 131) or (itemData.StdMode == 15 and itemData.Shape == 132) then
        showAttr = itemData.mysticShowAttr
        if not showAttr then
            widget = GUI:RichText_Create(-1, "rich_att_mystic", 0, 0, "?????", width, fontSize, "#FFFFFF", vspace, nil, fontPath)
            return widget
        end
    end

    local cells = {}
    local cellHei = 0

    if showAttr and attStr and #attStr > 0 then
        widget = GUI:Layout_Create(-1, "base_attr_panel", 0, 0, width, 0)
        for i, v in ipairs(attStr) do
            local rich_att_base = nil
            if v.str then
                rich_att_base = GUI:RichText_Create(widget, "rich_att_base_" .. i, 0, 0, v.str, width, fontSize, "#FFFFFF", vspace, nil, fontPath) 
                cellHei = cellHei + toEven(GUI:getContentSize(rich_att_base).height)
                ItemTips._upAttrMaxWidth = math.max(ItemTips._upAttrMaxWidth, GUI:getContentSize(rich_att_base).width)
                table.insert(cells, rich_att_base)
            end

            if rich_att_base and v.id and upAttrs[v.id] then
                table.insert(ItemTips._upAttrRichs, rich_att_base)
            end
        end

        cellHei = cellHei + (#cells - 1) * ItemTips._cellSpace
        GUI:setContentSize(widget, width, cellHei)
        local posY = cellHei
        for i = 1, #cells do
            local child = cells[i]
            local childAPoint = GUI:getAnchorPoint(child)
            local childSize = GUI:getContentSize(child)
            GUI:setPosition(child, childAPoint.x * childSize.width, posY - (1 - childAPoint.y) * childSize.height)
            posY = posY - childSize.height - ItemTips._cellSpace
        end
    end
    return widget
end

function ItemTips.CreateNeedWidget(param)
    local isItem = param and param.tip_isItem
    if isItem then
        return
    end

    -- 条件限制
    local needStr = param and param.tip_needStr
    if needStr then
        local rich_need = GUI:RichText_Create(-1, "rich_need", 0, 0, needStr, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath) 
        return rich_need
    end
end

function ItemTips.CreateYsAttrWidget(param)
    local isItem = param and param.tip_isItem
    if isItem then
        return
    end

    local itemData = param and param.tip_itemData
    if not itemData then
        return
    end

    -- 基础属性
    local width = ItemTips._richWid

    local widget = nil
    if not ItemTips._ysAttrs then
        ItemTips._baseAttrs, ItemTips._ysAttrs, ItemTips._upAttrs = ItemTips.GetAttStr(itemData, param.tip_isWear)
    end
    local attStr = ItemTips._ysAttrs
    local upAttrs = ItemTips._upAttrs

    local cells = {}
    local cellHei = 0

    if attStr and #attStr > 0 then
        widget = GUI:Layout_Create(-1, "ys_attr_panel", 0, 0, width, 0)
        for i, v in ipairs(attStr) do
            local rich_att_ys = nil
            if v.str then
                rich_att_ys = GUI:RichText_Create(widget, "rich_att_ys_" .. i, 0, 0, v.str, width, fontSize, "#FFFFFF", vspace, nil, fontPath) 
                cellHei = cellHei + toEven(GUI:getContentSize(rich_att_ys).height)
                ItemTips._upAttrMaxWidth = math.max(ItemTips._upAttrMaxWidth, GUI:getContentSize(rich_att_ys).width)
                table.insert(cells, rich_att_ys)
            end

            if rich_att_ys and v.id and upAttrs[v.id] then
                table.insert(ItemTips._upAttrRichs, rich_att_ys)
            end
        end

        cellHei = cellHei + (#cells - 1) * ItemTips._cellSpace
        GUI:setContentSize(widget, width, cellHei)
        local posY = cellHei
        for i = 1, #cells do
            local child = cells[i]
            local childAPoint = GUI:getAnchorPoint(child)
            local childSize = GUI:getContentSize(child)
            GUI:setPosition(child, childAPoint.x * childSize.width, posY - (1 - childAPoint.y) * childSize.height)
            posY = posY - childSize.height - ItemTips._cellSpace
        end
    end
    return widget
end

function ItemTips.AddUpAttrMarkImg()
    -- 添加属性提升标识
    if ItemTips._upAttrRichs and #ItemTips._upAttrRichs > 0 then
        for i, rich_att in ipairs(ItemTips._upAttrRichs) do
            local image = GUI:Image_Create(rich_att, "up_attr_tag_" .. i, ItemTips._upAttrMaxWidth + 10, 2, "res/public/btn_szjm_01_3.png")
            GUI:setScale(image, 0.8)
        end
    end
end

function ItemTips.CreateDiyAttrWidget(param)
    local isItem = param and param.tip_isItem
    if isItem then
        return
    end

    local itemData = param and param.tip_itemData
    if not itemData then
        return
    end

    local width = ItemTips._richWid
    local widget = nil
    local cells = {}
    local cellHei = 0
    
    -- 自定义属性
    local diyAttrStrList = ItemTips.GetDiyAttStr(itemData)
    if diyAttrStrList and next(diyAttrStrList) then
        widget = GUI:Layout_Create(-1, "diy_attr_panel", 0, 0, width, 0)
        local typeTab = table.keys(diyAttrStrList)
        table.sort(typeTab, function(a, b)
            return a < b
        end)
        for i, type in ipairs(typeTab) do
            local attStrs = diyAttrStrList[type] or {}
            if i ~= 1 and next(attStrs) then
                local line = ItemTips.CreateSplitLine()
                GUI:addChild(widget, line)
                cellHei = cellHei + GUI:getContentSize(line).height
                table.insert(cells, line)
            end
            local customDiyShow = itemData.MakeIndex and SL:GetValue("ITEM_CUSTOM_DIYSHOW_BY_TYPE", itemData.MakeIndex, type)
            if customDiyShow and string.len(customDiyShow) > 0 then -- 自定义属性组内容显示
                -- 属性组标题
                local attStr = attStrs[1]
                if attStr and attStr.isTitle then
                    if attStr.str then
                        local rich_att_diy = GUI:RichText_Create(widget, string.format("rich_att_diy_%s_1", i), 0, 0, attStr.str, width, fontSize, "#FFFFFF", vspace, nil, fontPath) 
                        cellHei = cellHei + toEven(GUI:getContentSize(rich_att_diy).height)
                        table.insert(cells, rich_att_diy)
                    end
                end

                local showList = SL:Split(customDiyShow, "|")
                local sizeW, sizeH = nil, nil
                if showList[1] and string.len(showList[1]) > 0 then
                    local data = SL:Split(showList[1], ":")
                    sizeW = tonumber(data[1])
                    sizeH = tonumber(data[2])
                end

                if sizeW and sizeH then
                    local layout = GUI:Layout_Create(widget, "custom_panel_" .. type, 0, 0, sizeW, sizeH)
                    for i = 2, #showList do
                        if showList[i] and string.len(showList[i]) > 0 then
                            local params = SL:Split(showList[i], ":")
                            if params[1] == "IMG" then
                                local path = params[2] and string.format("res/custom/tiptitle/%s.png", params[2])
                                if path then
                                    local img = GUI:Image_Create(layout, "img_" .. i, tonumber(params[3]) or 0, tonumber(params[4]) or 0, path)
                                    if tonumber(params[5]) and tonumber(params[5]) > 0 then
                                        GUI:setScale(img, tonumber(params[5]))
                                    end
                                end

                            elseif params[1] == "SFX" then
                                local sfxID = tonumber(params[2])
                                if sfxID then
                                    local sfx = GUI:Effect_Create(layout, "sfx_" .. i, tonumber(params[3]) or 0, tonumber(params[4]) or 0, 0, sfxID)
                                    if tonumber(params[5]) and tonumber(params[5]) > 0 then
                                        GUI:setScale(sfx, tonumber(params[5]))
                                    end
                                end
                            elseif params[1] == "DESC" then
                                local descId = tonumber(params[2])
                                local config = descId and GUIDefineEx.ItemDescConfig[descId]
                                if config and config.str then
                                    local richText = GUI:RichText_Create(layout, "desc_" .. i, tonumber(params[3]), tonumber(params[4]), config.str, sizeW, SL:GetValue("GAME_DATA","DEFAULT_FONT_SIZE"), "#FFFFFF")
                                    if tonumber(params[5]) and tonumber(params[5]) > 0 then
                                        GUI:setScale(richText, tonumber(params[5]))
                                    end
                                end
                            end
                        end
                    end
                    cellHei = cellHei + sizeH
                    table.insert(cells, layout)
                end
            else
                for k, v in ipairs(attStrs) do
                    local rich_att_diy = nil
                    if v.str then
                        rich_att_diy = GUI:RichText_Create(widget, string.format("rich_att_diy_%s_%s", i, k), 0, 0, v.str, width, fontSize, "#FFFFFF", vspace, nil, fontPath) 
                        cellHei = cellHei + toEven(GUI:getContentSize(rich_att_diy).height)
                        table.insert(cells, rich_att_diy)
                    end
                end
            end
        end

        cellHei = cellHei + (#cells - 1) * ItemTips._cellSpace
        GUI:setContentSize(widget, width, cellHei)
        local posY = cellHei
        for i = 1, #cells do
            local child = cells[i]
            local childAPoint = GUI:getAnchorPoint(child)
            local childSize = GUI:getContentSize(child)
            GUI:setPosition(child, childAPoint.x * childSize.width, posY - (1 - childAPoint.y) * childSize.height)
            posY = posY - childSize.height - ItemTips._cellSpace
        end
    end
    return widget
end

-- 单个镶嵌孔位显示
function ItemTips.CreateEmptyInlayCell(index)
    local width = ItemTips._richWid

    local cell = GUI:Layout_Create(-1, "inlay_cell", 0, 0, width, 0)
    local res = _resPath .. (SL:GetValue("IS_PC_OPER_MODE") and "inlay_bg_1.png" or "inlay_bg_0.png")
    local iconBg = GUI:Image_Create(cell, "icon_bg", 0, 0, res)
    local size = GUI:getContentSize(iconBg)
    local maxHei = size.height
    GUI:setContentSize(cell, width, maxHei)
    -- 图标位置
    GUI:setAnchorPoint(iconBg, 0, 1)
    GUI:setPositionY(iconBg, maxHei)

    return cell
end

-- 单条镶嵌物品显示
function ItemTips.CreateInlayCell(itemId, inlayStrList, index)
    if not itemId or itemId <= 0 then
        return
    end

    local itemData = SL:GetValue("ITEM_DATA", itemId)
    if not itemData then
        return
    end

    local width = ItemTips._richWid
    local cells = {}
    local cellHei = 0
    local maxHei = 0

    local cell = GUI:Layout_Create(-1, "inlay_cell", 0, 0, width, 0)
    
    local res = _resPath .. (SL:GetValue("IS_PC_OPER_MODE") and "inlay_bg_1.png" or "inlay_bg_0.png")
    local iconBg = GUI:Image_Create(cell, "icon_bg", 0, 0, res)
    local size = GUI:getContentSize(iconBg)
    local item = GUI:ItemShow_Create(iconBg, "item_", size.width / 2, size.height / 2, {itemData = itemData, index = itemData.Index, disShowCount = true, notShowEquipRedMask = true, noMouseTips = true})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    local itemScale = size.width / GUI:getContentSize(item).width
    GUI:setScale(item, itemScale)

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255
    local nameStr = string.format("<font color='%s' size='%s'>%s</font>", SL:GetHexColorByStyleId(color), fontSize, itemData.Name or "")
    local x = size.width + 10
    local rich_name = GUI:RichText_Create(cell, "r_name", x, maxHei, nameStr, ItemTips._richWid - x, fontSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
    GUI:setAnchorPoint(rich_name, 0, 1)
    cellHei = cellHei + GUI:getContentSize(rich_name).height
    table.insert(cells, rich_name)

    local attStr = inlayStrList and inlayStrList[index]
    if attStr then
        local rich_att_inlay = GUI:RichText_Create(cell, string.format("rich_att_inlay_%s", index), x, 0, attStr, width, fontSize, "#FFFFFF", vspace, nil, fontPath) 
        cellHei = cellHei + toEven(GUI:getContentSize(rich_att_inlay).height)
        table.insert(cells, rich_att_inlay)
    end

    cellHei = cellHei + (#cells - 1) * ItemTips._cellSpace
    local maxHei = math.max(cellHei, size.height)
    GUI:setContentSize(cell, width, maxHei)
    local posY = maxHei
    for i = 1, #cells do
        local child = cells[i]
        local childAPoint = GUI:getAnchorPoint(child)
        local childSize = GUI:getContentSize(child)
        GUI:setPositionY(child, posY - (1 - childAPoint.y) * childSize.height)
        posY = posY - childSize.height - ItemTips._cellSpace
    end

    -- 图标位置
    GUI:setAnchorPoint(iconBg, 0, 1)
    GUI:setPositionY(iconBg, maxHei)

    return cell
end

function ItemTips.CreateInlayAttrWidget(param)
    local isItem = param and param.tip_isItem
    if isItem then
        return
    end

    local itemData = param and param.tip_itemData
    if not itemData or not itemData.TNCell then
        return
    end

    local inlayStrList = ItemTips.GetInlayAttStr(itemData)
    local openTNCellNum = itemData.openTNCellNum
    if not next(inlayStrList) and openTNCellNum <= 0 then
        return
    end

    local width = ItemTips._richWid
    local cells = {}
    local cellHei = 0

    local widget = GUI:Layout_Create(-1, "diy_attr_panel", 0, 0, width, 0)

    local function checkGroupShow(groupIndexs)
        if not groupIndexs or not next(groupIndexs) then
            return false
        end
        for _, index in ipairs(groupIndexs) do
            local attStr = inlayStrList[index]
            if attStr or (itemData.TNCell[index] and itemData.TNCell[index] ~= 0) then -- 0: 未开启 -1: 已开启格子无物品 
               return true 
            end
        end

        return false
    end

    local function addToWidget(widget, cell)
        GUI:addChild(widget, cell)
        cellHei = cellHei + toEven(GUI:getContentSize(cell).height)
        table.insert(cells, cell)
    end
    
    local addIndexList = {}
    local groupList = GUIDefineEx.TipsTNCellGroupTitle
    if next(groupList) then
        local groupTab = table.keys(groupList)
        table.sort(groupTab, function(a, b)
            return a < b
        end)
        for i, groupId in ipairs(groupTab) do
            local params = groupList[i]
            local indexList = params.indexs or {}
            if checkGroupShow(indexList) then
                if i ~= 1 then
                    local line = ItemTips.CreateSplitLine()
                    addToWidget(widget, line)
                end
                local titleName = params.name
                if titleName then
                    if GUIFunction.ParseTitleHasCustomVar then
                        titleName = GUIFunction:ParseTitleHasCustomVar(itemData.MakeIndex, titleName)
                    end
                    local titleColor = params.color or 154
                    local titleStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName)
                    local rich_title = GUI:RichText_Create(widget, string.format("rich_att_inlay_title_%s", groupId), 0, 0, titleStr, width, fontSize, "#FFFFFF", vspace, nil, fontPath) 
                    cellHei = cellHei + toEven(GUI:getContentSize(rich_title).height)
                    table.insert(cells, rich_title)
                end

                for _, index in ipairs(indexList) do
                    addIndexList[index] = true
                    local cell = nil
                    if itemData.TNCell[index] == -1 then -- 开启空格
                        cell = ItemTips.CreateEmptyInlayCell(index)
                    else
                        cell = ItemTips.CreateInlayCell(itemData.TNCell[index], inlayStrList, index)
                    end
                    if cell then
                        addToWidget(widget, cell)
                    end
                end
            end
        end
    end

    local needLine = true
    for index = 0, 19 do
        if not addIndexList[index] then
            local cell = nil
            if itemData.TNCell[index] == -1 then -- 开启空格
                cell = ItemTips.CreateEmptyInlayCell(index)
            else
                cell = ItemTips.CreateInlayCell(itemData.TNCell[index], inlayStrList, index)
            end
            if cell then
                addToWidget(widget, cell)
            end
        end
    end

    cellHei = cellHei + (#cells - 1) * ItemTips._cellSpace
    GUI:setContentSize(widget, width, cellHei)
    local posY = cellHei
    for i = 1, #cells do
        local child = cells[i]
        local childAPoint = GUI:getAnchorPoint(child)
        local childSize = GUI:getContentSize(child)
        GUI:setPosition(child, childAPoint.x * childSize.width, posY - (1 - childAPoint.y) * childSize.height)
        posY = posY - childSize.height - ItemTips._cellSpace
    end

    return widget
end

-- 套装
function ItemTips.CreateNewSuitWidget(param)
    
    local richStr = param and param.tip_newSuitStr
    if richStr then
        local rich_suit = GUI:RichText_Create(-1, "rich_new_suit", 0, 0, richStr, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath)
        return rich_suit
    end
end

-- 装备战力
function ItemTips.CreatePowerWidget(param)

    local powerStr = param and param.tip_powerStr
    if powerStr then
        local rich_power = GUI:RichText_Create(-1, "rich_power", 0, 0, powerStr, ItemTips._richWid, fontSize, "#00FF00", vspace, nil, fontPath)
        return rich_power
    end
end

-- 限时装备
function ItemTips.CreateLimitTimeWidget(param)

    -- 倒计时
    local timeStr = param and param.tip_timeStr
    if timeStr then
        local rich_time = GUI:RichText_Create(-1, "rich_time", 0, 0, timeStr, ItemTips._richWid, fontSize, "#28EF01", vspace, nil, fontPath)
        return rich_time
    end
end

-- 来源
function ItemTips.CreateItemSrcWidget(param)

    local srcStr = param and param.tip_srcStr
    if srcStr then
        local rich_src = GUI:RichText_Create(-1, "rich_src", 0, 0, srcStr, ItemTips._richWid, fontSize, "#28EF01", vspace, nil, fontPath)
        return rich_src
    end
end

-- 药品加成
function ItemTips.CreateHpMpWidget(param)

    local str = param and param.tip_hpmpStr
    if str and string.len(str) > 0 then
        local rich_hmp = GUI:RichText_Create(-1, "rich_hmp", 0, 0, str, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath)
        return rich_hmp
    end
end

-- 道具属性描述
function ItemTips.CreateItemAttrWidget(param)

    local attrStr = param and param.tip_itemAttrStr
    if attrStr and string.len(attrStr) > 0 then
        local rich_attr = GUI:RichText_Create(-1, "rich_attr", 0, 0, attrStr, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath)
        return rich_attr
    end
end

-- 技能书限制
function ItemTips.CreateSkillLimitWidget(param)

    local richStr = param and param.tip_skillLimitStr
    if richStr and string.len(richStr) > 0 then
        local rich_limit = GUI:RichText_Create(-1, "rich_limit", 0, 0, richStr, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath)
        return rich_limit
    end
end

-- 聚灵珠消耗
function ItemTips.CreateJulingCostWidget(param)
    
    local richStr = param and param.tip_julingStr
    if richStr and string.len(richStr) > 0 then
        local rich_jl = GUI:RichText_Create(-1, "rich_rl", 0, 0, richStr, ItemTips._richWid, fontSize, SL:GetHexColorByStyleId(69), vspace, nil, fontPath)
        return rich_jl
    end
end

-- 描述
function ItemTips.CreateDescWidget(groupId, param)
    if not groupId then
        return
    end
    local richStr = nil
    if param and param[string.format("tip_desc%sStr", groupId)] then
        richStr = param[string.format("tip_desc%sStr", groupId)]
    else
        local descList = param and param.tip_descList
        richStr = GUIFunction:GetItemDescStrByGroup(descList, groupId)
    end
    if richStr and string.len(richStr) > 0 then
        local rich_desc = GUI:RichText_Create(-1, "rich_desc_" .. groupId, 0, 0, richStr, ItemTips._richWid, fontSize, "#FFFFFF", vspace, nil, fontPath)
        return rich_desc
    end
end

--------------------------------------------------------
function ItemTips.InitShellCell(widgetKey, widget)
    local cell = GUI:Widget_Create(-1, widgetKey, 0, 0, 0, 0)
    GUI:addChild(cell, widget)
    GUI:setAnchorPoint(widget, 0, 0)
    GUI:setPosition(widget, 0, 0)
    local cellSize = GUI:getContentSize(widget)
    GUI:setContentSize(cell, toEven(cellSize.width), toEven(cellSize.height))
    return cell
end

function ItemTips.PushItem(cellView, widget)
    if not widget then
        return
    end
    local cell = ItemTips.InitShellCell("cell_" .. ItemTips._cell_num, widget)
    ItemTips._allCellHei = ItemTips._allCellHei + GUI:getContentSize(cell).height
    ItemTips._cell_num = ItemTips._cell_num + 1
    GUI:ListView_pushBackCustomItem(cellView, cell)
end

function ItemTips.FillTipsContent(tipsLayout, cellView, tipsParam)
    local groupList = ItemTips._config.group
    local maxWidth = ItemTips._maxWidth
    local topHei = 0
    local topLayout = nil
    local bottomHei = 0
    local bottomLayout = nil
    ItemTips._allCellHei = 0
    ItemTips._cell_num = 0

    -- 装备穿戴
    local wearWidget = ItemTips.CreateWearWidget(tipsParam)
    ItemTips.PushItem(cellView, wearWidget)
    if wearWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 名字
    local nameWidget = ItemTips.CreateNameWidget(tipsParam)
    ItemTips.PushItem(cellView, nameWidget)

    -- 描述1
    local descWidget = ItemTips.CreateDescWidget(1, tipsParam)
    ItemTips.PushItem(cellView, descWidget)

    ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())

    -- 图标显示
    local iconWidget = ItemTips.CreateIconWidget(tipsParam)
    ItemTips.PushItem(cellView, iconWidget)
    if iconWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 投保
    local toubaoWidget = ItemTips.CreateTouBaoWidget(tipsParam)
    ItemTips.PushItem(cellView, toubaoWidget)

    -- hpMp
    local hpMpWidget = ItemTips.CreateHpMpWidget(tipsParam)
    ItemTips.PushItem(cellView, hpMpWidget)
    if hpMpWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    if tipsParam.tip_isItem then
        -- 道具属性
        local itemAttrWidget = ItemTips.CreateItemAttrWidget(tipsParam)
        ItemTips.PushItem(cellView, itemAttrWidget)

        -- 技能书限制
        local skillLimitWidget = ItemTips.CreateSkillLimitWidget(tipsParam)
        ItemTips.PushItem(cellView, skillLimitWidget)

        -- 聚灵珠消耗
        local julingCostWidget = ItemTips.CreateJulingCostWidget(tipsParam)
        ItemTips.PushItem(cellView, julingCostWidget)
    end

    -- 星星
    local starWidget = ItemTips.CreateStarWidget(tipsParam)
    ItemTips.PushItem(cellView, starWidget)

    -- 刀魂
    local sets = GUIDefineEx.TipsSwordOfSoulTitle or {}
    for i, data in ipairs(sets) do
        local soulWidget = ItemTips.CreateSwordOfSoulWidget(tipsParam, i)
        ItemTips.PushItem(cellView, soulWidget)
    end

    -- 基础属性
    local baseAttWidget = ItemTips.CreateBaseAttrWidget(tipsParam)
    ItemTips.PushItem(cellView, baseAttWidget)
    if baseAttWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 条件限制
    local needWidget = ItemTips.CreateNeedWidget(tipsParam)
    ItemTips.PushItem(cellView, needWidget)
    if needWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 元素属性
    local ysAttWidget = ItemTips.CreateYsAttrWidget(tipsParam)
    ItemTips.PushItem(cellView, ysAttWidget)
    if ysAttWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 描述3
    local desc3Widget = ItemTips.CreateDescWidget(3, tipsParam)
    if desc3Widget then
        removeLastLine()
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
        ItemTips.PushItem(cellView, desc3Widget)
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 自定义属性
    local diyAttWidget = ItemTips.CreateDiyAttrWidget(tipsParam)
    ItemTips.PushItem(cellView, diyAttWidget)
    if diyAttWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 镶嵌
    local inlayAttWidget = ItemTips.CreateInlayAttrWidget(tipsParam)
    ItemTips.PushItem(cellView, inlayAttWidget)
    if inlayAttWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 新套装 (关闭单独tips的显示方式)
    local newSuitWidget = ItemTips.CreateNewSuitWidget(tipsParam)
    ItemTips.PushItem(cellView, newSuitWidget)
    if newSuitWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 限时道具
    local limitTimeWidget = ItemTips.CreateLimitTimeWidget(tipsParam)
    ItemTips.PushItem(cellView, limitTimeWidget)
    if limitTimeWidget then
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
    end

    -- 描述2
    local desc2Widget = ItemTips.CreateDescWidget(2, tipsParam)
    if desc2Widget then
        removeLastLine()
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
        ItemTips.PushItem(cellView, desc2Widget)
    end

    if GUIGlobal_ItemTipsEx then
        local widget = GUIGlobal_ItemTipsEx(tipsParam and tipsParam.tip_itemData)
        if widget and not GUI:Widget_IsNull(widget) then
            ItemTips.PushItem(cellView, widget)
        end
    end

    -- 物品来源
    local itemSrcWidget = ItemTips.CreateItemSrcWidget(tipsParam)
    if itemSrcWidget then
        removeLastLine()
        ItemTips.PushItem(cellView, ItemTips.CreateSplitLine())
        ItemTips.PushItem(cellView, itemSrcWidget)
    end

    -- 属性提升标识
    if not tipsParam.tip_isItem then
        ItemTips.AddUpAttrMarkImg()
    end

    ItemTips._allCellHei = math.max(ItemTips._cell_num - 1, 0) * ItemTips._cellSpace + ItemTips._allCellHei
    GUI:ListView_setItemsMargin(cellView, ItemTips._cellSpace)

    local innerH = ItemTips._allCellHei
    local needTopSpace = topHei and topHei > 0
    local needBottomSpace = bottomHei and bottomHei > 0 
    local listH = math.min(innerH, _tipsMaxH - topHei - (needTopSpace and vspace or 0) - bottomHei - (needBottomSpace and vspace or 0))
    local listWid = ItemTips._maxWidth - 2 * rightSpace
    GUI:setContentSize(cellView, listWid, listH)
    GUI:setPosition(cellView, rightSpace, topSpace + bottomHei + (needBottomSpace and vspace or 0))
    local tipsHei = listH + topHei + (needTopSpace and vspace or 0) + bottomHei + (needBottomSpace and vspace or 0) + 2 * topSpace
    GUI:setContentSize(tipsLayout, ItemTips._maxWidth, tipsHei)
    GUI:setTag(tipsLayout, _panelNum)
    if topLayout then
        GUI:setPosition(topLayout, rightSpace, tipsHei - topSpace)
    end
    if bottomLayout then
        GUI:setPosition(bottomLayout, rightSpace, topSpace)
    end
    ItemTips.manyHeight = innerH + topSpace
    return innerH, listH
end

function ItemTips.InitTipsWidth()
    local maxWidth = nil
    if SL:GetValue("IS_PC_OPER_MODE") then
        maxWidth = ItemTips._config.pcWidth
    else
        maxWidth = ItemTips._config.mobileWidth
    end
    maxWidth = maxWidth or ItemTips._config.maxWidth or 400 -- 配置最大宽度
    ItemTips._maxWidth = toEven(maxWidth)
    ItemTips._richWid = toEven(ItemTips._maxWidth - 2 * rightSpace)
end

------------  装备tips  ------------------------------------------------
function ItemTips.GetEquipTips()
    local from = ItemTips._data.from

    local data = ItemTips._data
    -- 装备1
    local itemData = data.itemData or (data.typeId and SL:GetValue("ITEM_DATA", data.typeId))
    -- 装备2
    local itemData2 = data.itemData2
    -- 装备3
    local itemData3 = data.itemData3

    local isTipsOutSideBtn = tonumber(SL:GetValue("GAME_DATA", "tipsButtonOut")) == 1
    local panelIndex = 0
    -- 内挂开启装备对比
    local setValue = SL:GetValue("SETTING_VALUE", SLDefine.SETTINGID.SETTING_IDX_EQUIP_COMPARE)
    local openCompare = (setValue and setValue[1]) == 1
    if openCompare and (from == ItemFrom.BAG or from == ItemFrom.AUTO_TRADE or from == ItemFrom.HERO_BAG) then
        local diffEquips = GUIFunction:GetDiffEquip(itemData, from == ItemFrom.HERO_BAG)
        local diffFrom = from == ItemFrom.HERO_BAG and ItemFrom.HERO_EQUIP or ItemFrom.PLAYER_EQUIP
        if diffEquips and #diffEquips > 0 then
            ItemTips._diff = true
            local dData = SL:CopyData(data)
            dData.diff = true
            dData.diffFrom = diffFrom

            -- 对比身上的装备
            for i = 1, #diffEquips do
                if diffEquips[i] then
                    ItemTips.CreateEquipPanel(dData, diffEquips[i], false, panelIndex)
                    panelIndex = panelIndex + 1
                end
            end
        end
    end

    ItemTips.CreateEquipPanel(data, itemData, nil, isTipsOutSideBtn and panelIndex or 0)

    if itemData2 then
        if isEquip(itemData2) then
            ItemTips.CreateEquipPanel(data, itemData2)
        end
    end
    if itemData3 then
        if isEquip(itemData3) then
            ItemTips.CreateEquipPanel(data, itemData3)
        end
    end
end

function ItemTips.CreateEquipPanel(data, itemData, isWear, panelInsertIndex)
    if not data or not itemData then
        return
    end

    if SL:GetValue("IS_PC_OPER_MODE") then
        isWear = false
    end

    if not ItemTips._PList then
        ItemTips._PList = GUI:Layout_Create(ItemTips._PMainUI, "PList", data.pos.x, data.pos.y, 0, 0)
        GUI:setTouchEnabled(ItemTips._PList, false)
        GUI:setAnchorPoint(ItemTips._PList, 0, 1)
    end

    _panelNum = _panelNum + 1

    ItemTips._baseAttList, ItemTips._diyAttList = nil, nil
    ItemTips._baseAttrs, ItemTips._ysAttrs, ItemTips._upAttrs = nil, nil, nil

    ItemTips.InitTipsWidth()

    local tipsLayout = ItemTips.AddTipLayout(ItemTips._PList, "tipsLayout_" .. _panelNum)
    GUI:setPosition(tipsLayout, 0, 0)
    GUI:setAnchorPoint(tipsLayout, 0, 1)
    GUI:setTouchEnabled(tipsLayout, false)

    local index = tonumber(panelInsertIndex) and (tonumber(panelInsertIndex) + 1) or 1
    table.insert(ItemTips._panelSortItems, index, tipsLayout)

    local cellView = GUI:ListView_Create(tipsLayout, "cellView", 0, 0, 0, 0, 1)
    if ItemTips.typeCapture == 1 then--截图
        GUI:ScrollView_setClippingEnabled(cellView, false)
    end
    GUI:setTouchEnabled(cellView, false)

    if not SL:GetValue("IS_PC_OPER_MODE") then
        GUI:setTouchEnabled(tipsLayout, true)
        GUI:setTouchEnabled(cellView, true)
    end

    ItemTips._curCellView = cellView

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255
    local name = itemData.Name or ""
    local nameStr = string.format("<font color='%s' size='%s'>%s</font>", SL:GetHexColorByStyleId(color), _nameSize, name)
    local descList, effectList = GUIFunction:GetItemDescList(itemData)

    -- 套装显示开关
    local hideSuitTips = (tonumber(SL:GetValue("GAME_DATA", "hideSuitTips")) or 0) == 1
    local suitStr = ""
    local suitids = itemData.suitid
    if hideSuitTips and not ItemTips._diff and suitids and string.len(suitids) > 0 then
        local suitArry = string.split(suitids, "#")
        local pos = 0
        for k, v in ipairs(suitArry) do
            local id = v and tonumber(v)
            local tSuitStr = id and ItemTips.GetSuitStr(id)
            if tSuitStr then
                pos = pos + 1
                tSuitStr = string.gsub(tSuitStr, "<br>$", "")
                suitStr = suitStr .. (pos ~= 1 and "<br>" or "") .. tSuitStr
            end
        end
        if string.len(suitStr) > 0 then
            local titleName = ItemTips._showTitleList[3] and ItemTips._showTitleList[3].name or "[套装属性]："
            local titleColor = ItemTips._showTitleList[3] and ItemTips._showTitleList[3].color or 154
            suitStr = string.format("<font color='%s'>%s</font><br>%s", SL:GetHexColorByStyleId(titleColor), titleName, suitStr)
        end
    end

    local tipsParam = {
        tip_isItem      = false,
        tip_name        = name,                                 -- string
        tip_nameStr     = nameStr,                              -- string 富文本
        tip_nameColor   = color,                                -- int 
        tip_modeStr     = ItemTips.GetModeStr(itemData),        -- string 富文本
        tip_itemIsBind  = itemData.Bind and itemData.Bind > 0 and SL:GetValue("ITEM_IS_BIND", itemData), -- boolen
        tip_isWear      = data.diff,                            -- boolean
        tip_weight      = itemData.Weight,                      -- number
        tips_toubaoStr  = ItemTips.GetTouBaoDesc(itemData),     -- string 富文本
        tip_star        = itemData.Star,                        -- number
        tip_needStr     = ItemTips.GetNeedStr(itemData),        -- string 富文本
        tip_timeStr     = ItemTips.GetTimeStr(1, itemData, data.from, _lookPlayer), -- string
        tip_srcStr      = ItemTips.GetSrcStr(itemData),         -- string 富文本
        tip_itemData    = itemData,                             -- table
        tip_descList    = descList,                             -- table
        tip_newSuitStr  = string.len(suitStr) > 0 and suitStr,  -- string 富文本
        tip_powerStr    = ItemTips.GetPowerStr(itemData),       -- string 富文本
    }

    ------

    local innerH, listH = ItemTips.FillTipsContent(tipsLayout, cellView, tipsParam)

    -- 套装属性
    if not hideSuitTips then
        local suitids = itemData.suitid
        if not ItemTips._diff and suitids and string.len(suitids) > 0 then
            local suitArry = string.split(suitids, "#")
            for k, v in ipairs(suitArry) do
                local id = v and tonumber(v)
                if id then
                    ItemTips.GetNewSuitPanel(id, itemData)
                end
            end
        end
    end

    -- 穿戴按钮
    if isWear ~= false and data and data.from == ItemFrom.BAG then
        if isOpenBtnSwitch(1) then
            ItemTips.AddButton(tipsLayout, itemData, 1)
        end
    end

    -- 内观预览
    ItemTips.GetModelPanel(itemData)

    -- 重置内部位置
    ItemTips.ResetEquipPosition()

    -- 调整按钮位置
    ItemTips.RefreshBtnPosition(tipsLayout)

    if innerH > listH then
        ItemTips.SetTipsScrollArrow(tipsLayout, cellView, innerH, listH)
    end

    if GUIGlobal_ItemTipsBasePanelEx then
        local widget = GUIGlobal_ItemTipsBasePanelEx(itemData, tipsLayout)
        if widget and not GUI:Widget_IsNull(widget) then
            GUI:addChild(tipsLayout, widget)
        end
    end

    -- 备注特效
    ItemTips.AddFrameEffect(tipsLayout, effectList)
end

------------  道具tips  ------------------------------------------------
function ItemTips.GetItemTips()
    ItemTips._isItem = true
    ItemTips.CreateItemPanel(ItemTips._data, ItemTips._data.itemData)
end

function ItemTips.CreateItemPanel(data, itemData)
    if not data or (not data.pos and not data.node) then
        return false
    end

    _panelNum = _panelNum + 1

    ItemTips.InitTipsWidth()

    local tipsLayout = ItemTips.AddTipLayout(ItemTips._PMainUI, "tipsLayout_" .. _panelNum)
    GUI:setPosition(tipsLayout, 0, 0)
    GUI:setAnchorPoint(tipsLayout, 0, 0)
    GUI:setTouchEnabled(tipsLayout, false)

    local cellView = GUI:ListView_Create(tipsLayout, "cellView", 0, 0, 0, 0, 1)
    GUI:setTouchEnabled(cellView, false)

    ItemTips._curCellView = cellView

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255
    local name = itemData.Name or ""
    local nameStr = string.format("<font color='%s' size='%s'>%s</font>", SL:GetHexColorByStyleId(color), _nameSize, name)
    local descList, effectList = GUIFunction:GetItemDescList(itemData)

    local tipsParam = {
        tip_isItem      = true,                                     -- 是否物品            
        tip_name        = name,                                     -- string
        tip_nameStr     = nameStr,                                  -- string 富文本
        tip_nameColor   = color,                                    -- int
        tip_itemIsBind  = itemData.Bind and itemData.Bind > 0 and SL:GetValue("ITEM_IS_BIND", itemData), -- boolen
        tip_isWear      = false,                                    -- boolean
        tip_weight      = itemData.Weight,                          -- number
        tip_star        = itemData.Star,                            -- number
        tip_needStr     = ItemTips.GetNeedStr(itemData, true),      -- string 富文本
        tip_timeStr     = ItemTips.GetTimeStr(2, itemData, data.from, _lookPlayer), -- string
        tip_srcStr      = ItemTips.GetSrcStr(itemData),             -- string 富文本
        tip_itemTypeStr = ItemTips.GetTypeStr(itemData, true),      -- string
        tip_hpmpStr     = ItemTips.GetHpMpStr(itemData),            -- string
        tip_skillLimitStr = ItemTips.GetSkillBookLimitStr(itemData, data.from), -- string 富文本
        tip_julingStr   = ItemTips.GetJulingCostStr(itemData),      -- string 富文本
        tip_itemAttrStr = ItemTips.GetItemAttDescStr(itemData),     -- string 富文本
        tip_itemData    = itemData,                                 -- table
        tip_descList    = descList,                                 -- table
    }

    local innerH, listH = ItemTips.FillTipsContent(tipsLayout, cellView, tipsParam)

    -- 使用/拆分按钮
    if not SL:GetValue("IS_PC_OPER_MODE") and data.from == ItemFrom.BAG then
        if isOpenBtnSwitch(3, itemData.StdMode) then
            if not (itemData.StdMode == 40 and itemData.Shape == 15) then -- 宝箱不显示使用
                ItemTips.AddButton(tipsLayout, itemData, 3)
            end
        end

        if isOpenBtnSwitch(2) and itemData.OverLap and itemData.OverLap > 1 then
            local itemConfig = SL:GetValue("ITEM_DATA", itemData.Index)
            if itemConfig and itemConfig.OverLap and itemConfig.OverLap > 1 then
                ItemTips.AddButton(tipsLayout, itemData, 2) -- 拆分
            end
        end
    end

    local anchorPoint, pos = ItemTips.GetTipsAnchorPoint(tipsLayout, data.pos, data.anchorPoint or {x = 0, y = 1})
    GUI:setAnchorPoint(tipsLayout, anchorPoint.x, anchorPoint.y)
    GUI:setPosition(tipsLayout, pos.x, pos.y)

    -- 调整按钮位置
    ItemTips.RefreshBtnPosition(tipsLayout)

    if innerH > listH then
        GUI:setTouchEnabled(cellView, true)
        ItemTips.SetTipsScrollArrow(tipsLayout, cellView, innerH, listH)
    end

    if GUIGlobal_ItemTipsBasePanelEx then
        local widget = GUIGlobal_ItemTipsBasePanelEx(itemData, tipsLayout)
        if widget and not GUI:Widget_IsNull(widget) then
            GUI:addChild(tipsLayout, widget)
        end
    end
    
    -- 备注特效
    ItemTips.AddFrameEffect(tipsLayout, effectList)
end

------------    按钮    ------------------------------------------------
local getBtnCfg = function(btnType)
    local cfg = {
        [1] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "佩戴", 
            func        = function(data)
                SL:RequestUseItem(data)
                UIOperator:CloseItemTips()
            end
        },
        [2] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "拆分",
            func        = function(data)
                SL:OpenItemSplitPop(data)
                UIOperator:CloseItemTips()
            end
        },
        [3] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "使用",
            func        = function(data)
                SL:RequestUseItem(data)
                UIOperator:CloseItemTips()
            end
        },
        [-1] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "",
            func        = function(data)
                SL:Print("Not ClickEvent....")
            end
        }
    }
    return cfg[btnType] or cfg[-1]
end

-- btnType: 1： 佩戴    2：拆分    3：使用道具
function ItemTips.AddButton(parent, itemData, btnType)
    local btnCfg = getBtnCfg(btnType)

    local button = GUI:Button_Create(parent, "BTN_" .. btnType, 0, 0, btnCfg.normalPic)
    GUI:Button_loadTexturePressed(button, btnCfg.pressPic)
    GUI:Button_setTitleText(button, btnCfg.btnName)
    GUI:Button_setTitleFontSize(button, fontSize)
    GUI:Button_setTitleColor(button, "#FFFFFF")
    GUI:Button_titleEnableOutline(button, "#111111", 1)
    GUI:setScale(button, SL:GetValue("IS_PC_OPER_MODE") and 0.8 or 1)
    GUI:addOnClickEvent(button, function() 
        btnCfg.func(itemData) 
    end)

    local size = GUI:getContentSize(parent)

    local minH = 80
    if btnType == 1 and size.height < minH then
        size.height = minH
        GUI:setContentSize(parent, size)
    end

    local btnSz = GUI:getContentSize(button)
    local posX = size.width - btnSz.width - 5
    local posY = size.height - btnSz.height - 5
    GUI:setPosition(button, posX, posY)

    return button
end

function ItemTips.RefreshBtnPosition(tipsLayout)
    if SL:GetValue("IS_PC_OPER_MODE") then
        return
    end

    local value = SL:GetValue("GAME_DATA", "tipsButtonOut")
    local isTipsOutSideBtn = tonumber(value) and tonumber(value) == 1

    local tipSize = GUI:getContentSize(tipsLayout)
    if isTipsOutSideBtn then
        local heightOffY = 0
        for i = 1, 3 do
            local btn = GUI:getChildByName(tipsLayout, "BTN_" .. i)
            if btn then
                GUI:setAnchorPoint(btn, 0, 1)
                local btnSz = GUI:getContentSize(btn)
                GUI:setPosition(btn, tipSize.width, tipSize.height - heightOffY)
                heightOffY = heightOffY + btnSz.height
            end
        end
    else
        local index = 1
        local movePosX, movePosY = 0, 0
        if SL:GetValue("IS_PC_OPER_MODE") then
            movePosX, movePosY = 10, 6
        end
        local lastHei = 0
        for i = 1, 3 do
            local btn = GUI:getChildByName(tipsLayout, "BTN_" .. i)
            if btn then
                local btnSz = GUI:getContentSize(btn)
                local anchorPoint = GUI:getAnchorPoint(btn)
                local posX = tipSize.width - btnSz.width * (1 - anchorPoint.x) - 5
                local posY = tipSize.height - lastHei - btnSz.height * (1 - anchorPoint.y) - 5
                lastHei = lastHei + btnSz.height + movePosY
                GUI:setPosition(btn, posX + movePosX, posY + movePosY)
                index = index + 1
            end
        end
    end

end

ItemTips.main()