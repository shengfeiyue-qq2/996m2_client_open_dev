ItemTips = {}

local screenW = SL:GetMetaValue("SCREEN_WIDTH")
local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

local ItemFrom = SL:GetMetaValue("ITEMFROMUI_ENUM")
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

local EquipMapByStdMode = SL:GetMetaValue("EQUIPMAP_BY_STDMODE")
local showLasting = SL:GetMetaValue("EX_SHOWLAST_MAP")

----------------- Params
local _PathRes       = "res/private/item_tips/"
local _PathResWin    = "res/private/item_tips_win32/"
local _TotalWidth    = 800
local _TextSize      = 18
local _DefaultFSize  = SL:GetMetaValue("WINPLAYMODE") and 12 or 16     -- 官方默认字号
local _TipsMaxH      = screenH - 100
local _PanelNum      = 0
local _DefaultSpace  = 10
local _lookPlayer    = false    
local _isSelf        = false

local _IsHero        = false

local rightSpace     = 15
local vspace         = SL:GetMetaValue("GAME_DATA", "DEFAULT_VSPACE")    -- 富文本行距
local fontPath       = SL:GetMetaValue("CHATANDTIPS_USE_FONT") or GUI.PATH_FONT2

-- 配置大小
local _setFontSize = nil
local _setVspace = SL:GetMetaValue("GAME_DATA", "DEFAULT_VSPACE")    -- 行距

-- 描述相关
local topDesY = {}
local rich_att_num = 0
local desc_img_num = 0

local function ResetDescParam() 
    topDesY = {}
    rich_att_num = 0
    desc_img_num = 0
end

local function IsEquip(itemData)
    return SL:GetMetaValue("ITEMTYPE", itemData) == SL:GetMetaValue("ITEMTYPE_ENUM").Equip
end

-- 按钮显示开关配置（cfg_game_data 表 BackpackGuide 字段）
-- switchType (1: 佩戴    2: 拆分   3: 不显示按钮)
local function IsOpenSwitch(switchType, StdMode)
    if not switchType then
        return false
    end

    if not ItemTips._Switch then
        ItemTips._Switch = {}
        local BackpackGuide = SL:GetMetaValue("GAME_DATA", "BackpackGuide")
        if BackpackGuide then
            local guide = string.split(BackpackGuide, "#") --拆分/佩戴开关
            for i, v in ipairs(guide) do
                if i == 3 then
                    ItemTips._Switch[3] = ItemTips._Switch[3] or {}

                    local stdModes = string.split(v or "", "|")
                    for _, stdMode in ipairs(stdModes) do
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

function ItemTips.main(data)
    local parent = GUI:Attach_Parent()
    ItemTips._data = data
    ItemTips._panelListSubItems = {}
    ItemTips.itemCount = 0
    ItemTips._PList = nil
    ItemTips._diff = false
    ItemTips._equipAttList = {} -- 身上的装备属性
    ItemTips._showTitleList = {}

    -- 是否是英雄装备
    _IsHero     = data.from and FormHero[data.from] or false
    _lookPlayer = data.lookPlayer
    _isSelf     = data.from ~= nil and FromEquip[data.from]
    topDesY     = {}
    rich_att_num = 0
    desc_img_num = 0

    local itemData = data.itemData or (data.typeId and SL:GetMetaValue("ITEM_DATA", data.typeId))

    if SL:GetMetaValue("WINPLAYMODE") then
        _TextSize = 13
    end

    local setData = SL:GetMetaValue("GAME_DATA", "setTipsFontSizeVspace")
    if setData and string.len(setData) > 0 then
        if tonumber(setData) and tonumber(setData) == 0 then
        else
            local setList = string.split(setData, "|")
            if setList[1] or setList[2] then
                local data = SL:GetMetaValue("WINPLAYMODE") and setList[2] or setList[1]
                if data and string.len(data) > 0 then
                    local valueList = string.split(data, "#")
                    if valueList[1] and tonumber(valueList[1]) then
                        _TextSize = tonumber(valueList[1])
                        _setFontSize = _TextSize
                    end
                    if valueList[2] and tonumber(valueList[2]) then
                        vspace = tonumber(valueList[2])
                        _setVspace = vspace
                    end
                end
            end
        end
    end

    -- 属性标题配置
    local showData = SL:GetMetaValue("GAME_DATA", "setTipsAttrTitle")
    if showData and string.len(showData) > 0 then
        local showList = string.split(showData, "|")
        for i, data in ipairs(showList) do
            if data and string.len(data) > 0 then
                ItemTips._showTitleList[i] = {}
                local param = string.split(data, "#")
                if param[1] and string.len(param[1]) > 0 then
                    ItemTips._showTitleList[i].name = param[1]
                end
                ItemTips._showTitleList[i].color = param[2] and tonumber(param[2])
            end
        end
    end

    if not data.pos then
        data.pos = {x = screenW / 2, y = screenH / 2}
        data.anchorPoint = {x = 0.5, y = 0.5}
    end

    if data.node then
        local PMainUI = GUI:Layout_Create(data.node, "PMainUI", 0, 0, screenW, screenH)
        ItemTips._PMainUI = PMainUI
    else
        local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, screenW, screenH)
        ItemTips._PMainUI = PMainUI
        GUI:setTouchEnabled(PMainUI, true)
        GUI:setSwallowTouches(PMainUI, false)
        GUI:addOnClickEvent(PMainUI, function() 
            SL:CloseItemTips() 
        end)
    end

    -- 道具类型
    if IsEquip(itemData) then
        ItemTips.GetEquipTips(data)
        ItemTips.SetTradeCapturePanel(ItemTips._PList)
    else
        ItemTips.GetItemTips(data, itemData)
        local chs = GUI:getChildren(ItemTips._PMainUI)
        ItemTips.SetTradeCapturePanel(chs[1])
    end

    -- 注册监听Tips鼠标滚动
    SL:RegisterLUAEvent(LUA_EVENT_ITEMTIPS_MOUSE_SCROLL, "ItemTips", ItemTips.OnMouseScroll)
end

function ItemTips.GetEquipTips(data)
    local from = ItemTips._data.from

    -- 装备1
    local itemData = data.itemData or (data.typeId and SL:GetMetaValue("ITEM_DATA", data.typeId))
    -- 装备2
    local itemData2 = data.itemData2
    -- 装备3
    local itemData3 = data.itemData3

    local v = SL:GetMetaValue("GAME_DATA", "tipsButtonOut")
    local isTipsOutSideBtn = tonumber(v) and tonumber(v) == 1
    local panelIndex = 0
    local setValue = SL:GetMetaValue("SETTING_VALUE", 36)
    local checkSet = (setValue and setValue[1]) == 1
    if checkSet and (from == ItemFrom.BAG or from == ItemFrom.AUTO_TRADE or from == ItemFrom.HERO_BAG) then
        local diffEquips = GUIFunction:GetDiffEquip(itemData, from == ItemFrom.HERO_BAG)
        local diffFrom = from == ItemFrom.HERO_BAG and ItemFrom.HERO_EQUIP or ItemFrom.PALYER_EQUIP
        if diffEquips and #diffEquips > 0 then
            ItemTips._diff = true
            panelIndex = panelIndex + 1
            local dData = SL:CopyData(data)
            dData.diff = true
            dData.diffFrom = diffFrom

            -- 对比身上的装备
            if diffEquips[1] then
                ItemTips.CreateEquipPanel(dData, diffEquips[1], false, panelIndex)
            end
            if diffEquips[2] then
                ItemTips.CreateEquipPanel(dData, diffEquips[2], false, panelIndex)
            end
        end
    end

    ItemTips.CreateEquipPanel(data, itemData, nil, isTipsOutSideBtn and (panelIndex + 1) or 0)

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
end

local function removeLastLine()
    if not ItemTips.contentPanel then
        return
    end
    local panelSize = GUI:getContentSize(ItemTips.contentPanel)
    local lastItem = GUI:getChildByTag(ItemTips.contentPanel, ItemTips.itemCount)
    if lastItem and string.find(GUI:getName(lastItem), "PLINE") then
        local lastItemSz = GUI:getContentSize(lastItem)
        GUI:removeFromParent(lastItem)
        GUI:setContentSize(
            ItemTips.contentPanel,
            panelSize.width,
            panelSize.height - lastItemSz.height - (_setVspace or 0)
        )
        ItemTips.itemCount = ItemTips.itemCount - 1
    end
end

function ItemTips.PushItem(parent, childItem)
    local rootPanel = parent
    if not rootPanel then
        return
    end

    local itemCount = ItemTips.itemCount or 0
    itemCount = itemCount + 1

    local oldChildren = GUI:getChildByTag(rootPanel, itemCount)
    if string.find(GUI:getName(childItem), "PLINE") then
        if oldChildren then
            GUI:removeFromParent(childItem)
            return
        end
    end

    ItemTips.itemCount = itemCount
    local childrenSz                    = GUI:getContentSize(childItem)
    local anchorPoint                   = GUI:getAnchorPoint(childItem)
    local childrenPosX, childrenPosY    = GUI:getPositionX(childItem), GUI:getPositionY(childItem)
    local offX, offY                    = anchorPoint.x * childrenSz.width + childrenPosX, (anchorPoint.y - 1) * childrenSz.height + childrenPosY
    GUI:setTag(childItem, itemCount)

    local rootPanelSz                   = GUI:getContentSize(rootPanel) 
    local posx, posy                    = 0 + offX, -rootPanelSz.height + offY - (_setVspace or 0)
    local newMaxW                       = math.max(childrenPosX + (1 - anchorPoint.x) * childrenSz.width, rootPanelSz.width)      --panel最后的宽度
    local newMaxH                       = math.max(math.abs(posy), rootPanelSz.height + childrenSz.height + (_setVspace or 0))    --panel最后的高度
    if posy > 0 then --在顶部
        local rootPosY = GUI:getPositionY(rootPanel)
        local newRootPosY = posy + anchorPoint.y * childrenSz.height
        if newRootPosY > rootPosY then
            GUI:setPositionY(rootPanel, math.floor(newRootPosY))
        end
        newMaxH = newRootPosY + rootPanelSz.height
    elseif posy < 0 and posy - anchorPoint.y * childrenSz.height >= -rootPanelSz.height then --位置在底部之上
        newMaxH = rootPanelSz.height
    end

    GUI:setContentSize(rootPanel, newMaxW, newMaxH)
    GUI:setPosition(childItem, math.floor(posx), math.floor(posy))
    GUI:setLocalZOrder(childItem, itemCount)
end

-- 分割线
function ItemTips.CreateIntervalPanel(parent, height, line)
    local childList = GUI:getChildren(parent)
    local pLine = GUI:Layout_Create(parent, string.format("PLINE_%s", #childList + 1), 0, 0, 1, height)
    if line then
        local line = GUI:Image_Create(pLine, "line", 0, height / 2, _PathRes .. "line_tips_01.png")
        GUI:setAnchorPoint(line, 0, 0.5)
    end
    return pLine
end

-- 获取备注图片/特效 param: table  {res= 图片资源/特效id   x= 位置x  y = 位置y}
function ItemTips.GetNodeImage(parent, param, index)
    if not parent then
        return
    end
    if not param or not next(param) then
        return nil
    end
    local name = string.format("Desc_Img_%s", index or 0)
    local img = nil
    local imgSz = {
        width = 0,
        height = 0
    }
    if param.isSFX and param.res then
        img = GUI:Effect_Create(parent, name, 0, 0, 0, param.res)
        imgSz = GUI:getBoundingBox(img)
        if param.width > 0 and param.height > 0 then
            imgSz.width = param.width
            imgSz.height = param.height
        end
        GUI:setContentSize(img, imgSz.width, imgSz.height)
    else
        if param.res and SL:IsFileExist(param.res) then
            img = GUI:Image_Create(parent, name, 0, 0, param.res)
        end
    end

    if img then
        local newPosx, newPosy = param.x or 0, param.y or 0
        local imgPos = GUI:getPosition(img)
        GUI:setPosition(img, imgPos.x + newPosx, imgPos.y + newPosy)
        if param.scale and param.scale > 0 then
            GUI:setScale(img, param.scale)
        end
    end
    return img
end

-- 道具类型
ItemTips._item_type_name = nil
function ItemTips.GetTypeStr(itemData, isItem)
    if isItem and itemData and itemData.StdMode then
        if not ItemTips._item_type_name then
            ItemTips._item_type_name = {}
            local arrays = string.split(SL:GetMetaValue("GAME_DATA", "itemTypeName") or "", "|")
            for i, v in ipairs(arrays) do
                if v and v ~= "" then
                    local array = string.split(v, "#")
                    if tonumber(array[1]) and array[2] then
                        ItemTips._item_type_name[tonumber(array[1])] = array[2]
                    end
                end
            end
        end
        local name = ItemTips._item_type_name[itemData.StdMode] or "道具"
        return string.format("类型：%s", name)
    end
    return nil
end

function ItemTips.GetTouBaoGold(data)
    local insureGoldList = data.InsureGoldList
    if insureGoldList and string.len(insureGoldList) > 0 then
        local goldList = {}
        local list = string.split(insureGoldList, "|")
        for _, v in ipairs(list) do
            local value = string.split(v, "#")
            goldList[_] = {goldType = tonumber(value[1]), goldNum = tonumber(value[2]), notshow = tonumber(value[3]) == 1}

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
    return
end

-- 投保
function ItemTips.GetTouBaoDesc(data)
    local toubaoStr = nil
    local value = ItemTips.GetTouBaoGold(data)
    local gold = value and value.goldNum or 0

    if gold > 0 and value and value.goldType then
        local moneyName = SL:GetMetaValue("ITEM_NAME", value.goldType) or ""
        if data.touBaoTimes then
            if value.notshow then
                toubaoStr = string.format("<font color='%s' size='%s'>已投保%s次</font>", "#28ef01", _setFontSize or _DefaultFSize, data.touBaoTimes)
            else
                toubaoStr =
                    string.format(
                    "<font color='%s' size='%s'>已投保%s次，单次保额%s%s</font>",
                    "#28ef01",
                    _setFontSize or _DefaultFSize,
                    data.touBaoTimes,
                    gold,
                    moneyName
                )
            end
        else
            if value.notshow then
                toubaoStr = string.format("<font color='%s' size='%s'>可投保</font>", "#ff0500", _setFontSize or _DefaultFSize)
            else
                toubaoStr = string.format("<font color='%s' size='%s'>可投保，单次保额%s%s</font>", "#ff0500", _setFontSize or _DefaultFSize, gold, moneyName)
            end
        end
    end

    return toubaoStr
end

--
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
    elseif EquipMapByStdMode[itemData.StdMode] or showLasting[itemData.StdMode] then
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

--刀魂
function ItemTips.GetSwordOfSoul(parent, soulData, swordSoulIndex)
    if not parent then
        return
    end
    local switch = soulData[1] --进度条是否开启
    if switch ~= 1 then
        return nil
    end
    local nameStr       = soulData[2] or "" --名称
    local color         = soulData[3] --颜色
    local imgIndex      = soulData[4] --图片张数
    local jinduSwitch   = soulData[5] --进度开关
    local jinduValue    = soulData[6] --进度值
    local jinduMaxValue = soulData[7] --进度最大值
    local level         = soulData[8] --等级

    local newColor = nil
    if color then
        newColor = SL:GetColorByStyleId(color)
    end

    nameStr = jinduValue and string.gsub(nameStr, "%%p", jinduValue) or nameStr
    nameStr = jinduMaxValue and string.gsub(nameStr, "%%m", jinduMaxValue) or nameStr
    nameStr = level and string.gsub(nameStr, "%%l", level) or nameStr

    local percent = 0
    local isShowJinDuStr = false
    if jinduValue and jinduMaxValue and jinduMaxValue > 0 then
        percent = jinduValue / jinduMaxValue * 100
        isShowJinDuStr = true
    end
    local percentStr = string.format("%d%%", percent)
    nameStr = isShowJinDuStr and string.gsub(nameStr, "%%r", percentStr .. "%") or nameStr

    local tipsPanel = GUI:Layout_Create(parent, "s_Panel_" .. swordSoulIndex, 0, 0, 0, 0)
    local swordSoulName = GUI:Text_Create(tipsPanel, "swordSoulName", 0, 0, _setFontSize or 10, newColor or SL:ConvertColorFromHexString("#FFFFFF"), nameStr) 
    GUI:Text_enableOutline(swordSoulName, "#000000", 1)
    GUI:setAnchorPoint(swordSoulName, 0, 0)
    GUI:Text_setFontName(swordSoulName, fontPath)

    local swordSoulNameSz = GUI:getContentSize(swordSoulName)
    local nameW = swordSoulNameSz.width

    local tipW = nameW
    local tipH = swordSoulNameSz.height

    jinduValue = jinduValue or 0
    jinduMaxValue = jinduMaxValue or 100

    if (jinduSwitch == 1 or jinduSwitch == 2) and jinduMaxValue > 0 then
        local offX = 10
        local basePath = (SL:GetMetaValue("WINPLAYMODE") and _PathResWin or _PathRes) .. "sword_soul/"
        local barImgPath = string.format(basePath .. "jdtbg_%d.png", imgIndex)

        local bgImg = GUI:Image_Create(tipsPanel, "bg_img", nameW + offX, 0, barImgPath)
        GUI:setAnchorPoint(bgImg, 0, 0)

        local bgImgSz = GUI:getContentSize(bgImg)
        local index = 1
        local progressImgPath = string.format(basePath .. "jdt%d_%d.png", index, imgIndex)
        local slider = GUI:Slider_Create(tipsPanel, "slider", nameW + offX + 5, 1, "", progressImgPath, "")
        GUI:setAnchorPoint(slider, 0, 0)
        GUI:setContentSize(slider, bgImgSz.width - 10, bgImgSz.height - 2)

        SL:schedule(
            slider,
            function()
                index = index + 1
                if index > 3 then
                    index = 1
                end
                progressImgPath = string.format(basePath .. "jdt%d_%d.png", index, imgIndex)
                GUI:Slider_loadProgressBarTexture(slider, progressImgPath)
            end,
            0.3
        )

        percent = jinduValue / jinduMaxValue * 100
        if percent > 100 then
            percent = 100
        end
        GUI:Slider_setPercent(slider, jinduValue / jinduMaxValue * 100)
        local sliderSz = GUI:getContentSize(slider)

        local progressStr = ""
        if jinduSwitch == 1 then
            progressStr = string.format("%d%%", percent)
        elseif jinduSwitch == 2 then
            progressStr = string.format("%d/%d", jinduValue, jinduMaxValue)
        end

        local progress = GUI:Text_Create(tipsPanel, "progress_txt", nameW + offX + bgImgSz.width / 2, bgImgSz.height / 2, 10, newColor or "#FFFFFF", progressStr)
        GUI:Text_enableOutline(progress, "#000000", 1)
        GUI:setAnchorPoint(progress, 0.5, 0.5)
        GUI:Text_setFontName(progress, fontPath)

        tipW = tipW + bgImgSz.width + offX
        tipH = math.max(tipH, bgImgSz.height)
    end
    GUI:setContentSize(tipsPanel, tipW, tipH)
    return tipsPanel
end

--

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

local function checkNeedCombineExAdd()
    local needCombineEx = SL:GetMetaValue("GAME_DATA", "TipsCombineExAddShow") == 1
    return needCombineEx
end

function ItemTips.GetAttStr(itemData, diff)
    local pos = SL:GetMetaValue("EQUIP_POS_BY_STDMODE", itemData.StdMode)
    if not pos then
        return nil
    end
    local str = {} -- 添加属性提升标记

    -- 基础属性
    local attList           = GUIFunction:ParseItemBaseAtt(itemData.attribute)
    local attrAlignment     = SL:GetMetaValue("WINPLAYMODE") and tonumber(SL:GetMetaValue("GAME_DATA", "pc_tips_attr_alignment")) or 0
    local attrCoefficient   = SL:GetMetaValue("WINPLAYMODE") and -1 or 1
    attrAlignment           = math.ceil(attrAlignment / 3)
    --20以后的属性是元素属性
    local yuansuValues = {}
    local jipinValues = {}
    if itemData.Values and next(itemData.Values) ~= nil then
        for _, v in pairs(itemData.Values) do
            if v.Id < 20 then
                table.insert(jipinValues, v)
            else
                table.insert(yuansuValues, v)
            end
        end
    end

    --附加的元素属性
    local yuansuAtt = GUIFunction:GetExAttList(yuansuValues)
    if yuansuAtt and next(yuansuAtt) then
        attList = GUIFunction:CombineAttList(attList, yuansuAtt)
    end

    -- 极品属性
    local exAtt = GUIFunction:GetExAttList(jipinValues)
    local exAttShow = GUIFunction:GetAttDataShow(exAtt, true, true)
    -- 合并极品属性
    if exAtt and next(exAtt) then
        attList = GUIFunction:CombineAttList(attList, exAtt)
    end

    -- 附加属性 
    local exAddAttr = nil
    local exAddAttrShow = nil
    if checkNeedCombineExAdd() then
        local abilexStr = itemData.ExAbil and itemData.ExAbil.abilex
        exAddAttr = ItemTips.ParseExAddAttr(abilexStr, true)
        exAddAttrShow = GUIFunction:GetAttDataShow(exAddAttr, nil, true)
        if exAddAttr and next(exAddAttr) then
            attList = GUIFunction:CombineAttList(attList, exAddAttr)
        end
    end

    --属性提升
    local maxWidth = 0 --属性提升标识的位置
    local attUpList = {}
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
    --把基础属性和元素属性分开
    local basicAttrShow = {}
    local yuansuAttrShow = {}
    for id, v in pairs(stringAtt) do
        v.id = id
        local originId = getAttOriginId(id)
        local attConfig = SL:GetMetaValue("ATTR_CONFIG", originId)
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
            str,
            {
                str = titleStr
            }
        )
    end

    for _, v in pairs(basicAttrShow) do
        local name = string.gsub(v.name, " ", "")
        name = string.gsub(name, "　", "")
        local value  = getAddShow(v.id, v.value) .. v.value
        local nameLen, chineseLen = SL:GetUTF8ByteLen(name)  
        local newLen = math.max(attrAlignment - nameLen - chineseLen * attrCoefficient + SL:GetUTF8ByteLen(value), 0)
        local lenStr = string.format("%%%ds", newLen)
        value        = string.format(lenStr, value)

        local oneStr = name .. value
        local color = v.color
        if exAttShow and exAttShow[v.id] then
            oneStr = oneStr .. string.format("(%s)", exAttShow[v.id].value)
            color = 1039
        end
        if exAddAttrShow and exAddAttrShow[v.id] then
            oneStr = oneStr .. string.format("(%s)", exAddAttrShow[v.id].value)
            color = 250
        end

        if color and color > 0 then
            oneStr = string.format("<font color='%s'>%s</font>", color == 1039 and "#28EF01" or SL:GetHexColorByStyleId(color), oneStr)
        end

        table.insert(
            str,
            {
                id = v.id,
                str = oneStr
            }
        )
    end

    --强度
    if itemData.StdMode ~= 16 and itemData.Source and itemData.Source > 0 then
        local oneStr = string.format("强度：+%s", itemData.Source)
        oneStr = string.format("<font color='%s'>%s</font>", "#28EF01", oneStr)
        table.insert(
            str,
            {
                str = oneStr
            }
        )
    end

    --负重
    if (itemData.StdMode == 52 or itemData.StdMode == 62 or itemData.StdMode == 54 or itemData.StdMode == 64 
        or itemData.StdMode == 84 or itemData.StdMode == 85 or itemData.StdMode == 86 or itemData.StdMode == 87) 
        and itemData.AniCount and itemData.AniCount > 0 then
        local oneStr = string.format("负重：+%s", itemData.AniCount)
        oneStr = string.format("<font color='%s'>%s</font>", "#28EF01", oneStr)
        table.insert(
            str,
            {
                str = oneStr
            }
        )
    end

    local str2 = {}
    if yuansuAttrShow and next(yuansuAttrShow) then
        local titleName = ItemTips._showTitleList[2] and ItemTips._showTitleList[2].name or "[元素属性]："
        local titleColor = ItemTips._showTitleList[2] and ItemTips._showTitleList[2].color or 154
        local yuansuTitle = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName)
        table.insert(
            str2,
            {
                str = yuansuTitle
            }
        )
        for _, v in pairs(yuansuAttrShow) do
            local name = string.gsub(v.name, " ", "")
            name = string.gsub(name, "　", "")
            local value = getAddShow(v.id, v.value) .. v.value
            local nameLen, chineseLen = SL:GetUTF8ByteLen(name)
            local newLen = math.max(attrAlignment - nameLen - chineseLen * attrCoefficient + SL:GetUTF8ByteLen(value), 0)
            local lenStr = string.format("%%%ds", newLen)
            value        = string.format(lenStr, value)

            local oneStr = name .. value
            local color = v.color
            if exAttShow and exAttShow[v.id] then
                oneStr = oneStr .. string.format("(%s)", exAttShow[v.id].value)
            end

            if color and color > 0 then
                oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)
            end

            table.insert(
                str2,
                {
                    id = v.id,
                    str = oneStr
                }
            )
        end
    end

    return str, str2, attUpList
end

function ItemTips.ParseExAddAttr(attr, needAttrList)
    if not attr or string.len(attr) == "" then
        return
    end

    local attrAlignment     = SL:GetMetaValue("WINPLAYMODE") and tonumber(SL:GetMetaValue("GAME_DATA", "pc_tips_attr_alignment")) or 0
    local attrCoefficient   = SL:GetMetaValue("WINPLAYMODE") and -1 or 1
    attrAlignment           = math.ceil(attrAlignment / 3)

    local attList = {}
    local exList = {}
    local strList = string.split(attr, ",")
    for i, v in pairs(strList) do
        local data = string.split(v, "=")
        if tonumber(data[1]) and data[2] and tonumber(data[2]) then
            table.insert(attList, {id = tonumber(data[1]), value = tonumber(data[2])})
        end
    end

    if needAttrList then
        return attList
    end

    local stringAtt = GUIFunction:GetAttDataShow(attList, nil, true)
    local attrShow = {}
    for id, v in pairs(stringAtt) do
        v.id = id
        local originId = getAttOriginId(id)
        local attConfig = SL:GetMetaValue("ATTR_CONFIG", originId)
        v.sort = attConfig and attConfig.sort or originId + 1000
        v.excolor = attConfig.excolor
        table.insert(attrShow, v)
    end
    
    table.sort(attrShow, function(a, b)
        return a.sort < b.sort
    end)

    local strList = {}
    if attrShow and next(attrShow) then
        local titleName = ItemTips._showTitleList[3] and ItemTips._showTitleList[3].name or "[附加属性]："
        local titleColor = ItemTips._showTitleList[3] and ItemTips._showTitleList[3].color or 154
        local titleStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName)
        table.insert(strList, {
            str = titleStr
        })
    end

    for _,v in pairs(attrShow) do
        local name = string.gsub(v.name, " ", "")
        name = string.gsub(name, "　", "")
        local value  = getAddShow(v.id, v.value) .. v.value
        local nameLen, chineseLen = SL:GetUTF8ByteLen(name)  
        local newLen = math.max(attrAlignment - nameLen - chineseLen * attrCoefficient + SL:GetUTF8ByteLen(value), 0)
        local lenStr = string.format("%%%ds", newLen)
        value        = string.format(lenStr, value)
        local color  = tonumber(v.excolor) or 250
        local oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), name .. value)

        table.insert(strList, {
            id = v.id,
            str = oneStr
        })
    end

    return strList
end

function ItemTips.GetNeedStr(itemData, isItem)
    local strList = nil
    if _IsHero then
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

-- 宝石属性显示
function ItemTips.GetGemShow(parent, itemData)
    if not itemData or not itemData.ExtendInfo or not itemData.ExtendInfo.Sockets or not parent then
        return
    end

    local function getIconResPath(looks)
        local fileName = string.format("%06d", looks % 10000)
        local pathIndex = math.floor(tonumber(looks) / 10000)
        local filePath = "item_ground_" .. pathIndex .. "/" .. fileName
        local path = string.format("%s%s.png", "res/item_ground/", filePath)
        return path
    end

    local maxWidth = 0

    local titleName = ItemTips._showTitleList[5] and ItemTips._showTitleList[5].name or "[镶嵌宝石]："
    local titleColor = ItemTips._showTitleList[5] and ItemTips._showTitleList[5].color or 154
    local title = GUI:RichText_Create(parent, "rich_gem", 0, 0, titleName, _TotalWidth - 20, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(titleColor), vspace, nil, fontPath) 
    ItemTips.PushItem(parent, title)
    maxWidth = GUI:getContentSize(title).width

    local richPosX = 0
    for i, id in pairs(itemData.ExtendInfo.Sockets) do
        if id > 0 then
            local goodLayout = GUI:Layout_Create(parent, "layout_gem_" .. i, 0, 0, 20, 20)
            GUI:setTouchEnabled(goodLayout, false)
            local size = GUI:getContentSize(goodLayout)

            local gemBg = GUI:Image_Create(goodLayout, "bg_gem_" .. i, 0, 0, _PathRes .. "000000.png")
            GUI:setAnchorPoint(gemBg, 0.5, 0.5)
            local gemBgSize = GUI:getContentSize(gemBg)

            richPosX = 0
            richPosX = richPosX + gemBgSize.width + 6
            local maxH = gemBgSize.height
            if id == 1 then
                local rich = GUI:RichText_Create(goodLayout, "rich_" .. i, 0, 0, "未镶嵌宝石", _TotalWidth - 20, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(60), vspace, nil, fontPath) 
                GUI:setAnchorPoint(rich, 0, 0.5)
                maxWidth = math.max(maxWidth, size.width + GUI:getContentSize(rich).width)

                if GUI:getContentSize(rich).height > size.height then
                    size = {
                        width = size.width,
                        height = GUI:getContentSize(rich).height
                    }
                    GUI:setContentSize(goodLayout, size)
                end
                GUI:setPosition(rich, math.floor(size.width), math.floor(size.height / 2))
                richPosX = richPosX + GUI:getContentSize(rich).width
            elseif id > 1 then
                local gemData = SL:GetMetaValue("ITEM_DATA", id)
                if gemData then
                    if gemData.Shape and gemData.Shape <= 4 then
                        local icon = GUI:Image_Create(gemBg, "icon_" .. i, gemBgSize.width / 2, gemBgSize.height / 2, _PathRes .. string.format("00000%s.png", gemData.Shape + 1))
                        GUI:setAnchorPoint(icon, 0.5, 0.5)
                        maxWidth = math.max(maxWidth, gemBgSize.width)
                    elseif gemData.Shape == 255 and gemData.Looks then
                        GUI:setVisible(gemBg, false)
                        local icon = GUI:Image_Create(goodLayout, "icon_" .. i, richPosX - gemBgSize.width - 6, 0, getIconResPath(gemData.Looks))
                        GUI:setAnchorPoint(icon, 0, 0.5)
                        local iconSz = GUI:getContentSize(icon)
                        GUI:setPositionY(icon, iconSz.height / 2)
                        maxWidth = math.max(maxWidth, iconSz.width + gemBgSize.width)
                        richPosX = richPosX + iconSz.width
                        richPosX = richPosX - gemBgSize.width - 6
                        maxH = math.max(maxH, iconSz.height)
                    end

                    local attList = GUIFunction:ParseItemBaseAtt(gemData.attribute)
                    local attShow = GUIFunction:GetAttShowOrder(attList, nil, true)
                    local attStr = ""
                    for _, v in pairs(attShow) do
                        local name = string.gsub(v.name, " ", "")
                        name = string.gsub(name, "　", "")

                        local value = v.value
                        if gemData.Reserved == 1 and not string.find(value, "%%") then
                            if tonumber(value) then
                                value = tonumber(value) .. "%"
                            elseif string.find(value, "-") then
                                local sliceStr = string.split(value, "-")
                                if tonumber(sliceStr[1]) and tonumber(sliceStr[2]) then
                                    value = tonumber(sliceStr[1]) .. "%" .. "-" .. tonumber(sliceStr[2]) .. "%"
                                end
                            end
                        end

                        local oneStr = name .. getAddShow(v.id, value) .. value
                        local color = v.color

                        if color and color > 0 then
                            oneStr = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(color), oneStr)
                        end

                        attStr = attStr .. oneStr .. "&nbsp;&nbsp;"
                    end

                    local rich_name = GUI:RichText_Create(goodLayout, "rich_name", 0, 0, attStr, _TotalWidth - 20 - size.width, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath)
                    GUI:setAnchorPoint(rich_name, 0, 0.5)
                    local richSize = GUI:getContentSize(rich_name)
                    maxWidth = math.max(maxWidth, richSize.width + size.width)

                    if richSize.height > size.height then
                        maxH = math.max(maxH, richSize.height)
                    end
                    maxH = math.max(maxH, 20)
                    size = {width = size.width, height = maxH}
                    GUI:setContentSize(goodLayout, size)
                    GUI:setPosition(rich_name, math.floor(richPosX), math.floor(size.height / 2))
                end
            end

            GUI:setPosition(gemBg, size.width / 2, size.height / 2)
            ItemTips.PushItem(parent, goodLayout)
        end
    end

    return maxWidth
end

-- 回收/出售
function ItemTips.GetRecycleStr(itemData)
    if itemData.huishou or itemData.honour then
        local str = ""
        if itemData.huishou and itemData.huishou ~= "" then
            local sliceStr = string.split(itemData.huishou, "#")
            local id = tonumber(sliceStr[1])
            local count = tonumber(sliceStr[2])
            local config = SL:GetMetaValue("ITEM_DATA", id)
            str = string.format("装备回收：%s*%s", config and config.Name or "", count) .. "<br>"
        end

        if itemData.honour and itemData.honour ~= "" then
            local sliceStr = string.split(itemData.honour, "#")
            local id = tonumber(sliceStr[1])
            local count = tonumber(sliceStr[2])
            local config = SL:GetMetaValue("ITEM_DATA", id)
            str = str .. string.format("行会出售：%s*%s", config and config.Name or "", count)
        end

        return str
    end
    return nil
end

function ItemTips.GetCustomTitleShow(index, parent, content, color)
    if not content or string.len(content) < 1 then
        return nil
    end
    if not parent then
        return
    end
    local layout = GUI:Layout_Create(parent, "custom_title_" .. index, 0, 0, 0, 0)

    local function parseStr(content)
        if not content or string.len(content) < 1 then
            return nil
        end

        local firstStr = ""
        local nextStr = ""

        local find_info_img = {string.find(content, "<IMG:(.-)>")}
        local begin_pos_img = find_info_img[1]
        local end_pos_img   = find_info_img[2]

        local find_info_sfx = {string.find(content, "<TEXIAO:(.-)>")}
        local begin_pos_sfx = find_info_sfx[1]
        local end_pos_sfx   = find_info_sfx[2]

        local begin_pos_line, end_pos_line = string.find(content, "\\")
        if begin_pos_line and end_pos_line then
            if begin_pos_line == 1 then
                firstStr = string.sub(content, 0, end_pos_line)
                nextStr = string.sub(content, end_pos_line + 1, string.len(content))
            else
                firstStr = string.sub(content, 0, begin_pos_line - 1)
                nextStr = string.sub(content, begin_pos_line, string.len(content))
            end
        elseif (begin_pos_img and end_pos_img) or (begin_pos_sfx and end_pos_sfx) then
            local begin_pos = begin_pos_img ~= nil and (begin_pos_sfx ~= nil and math.min(begin_pos_img, begin_pos_sfx) or begin_pos_img) or begin_pos_sfx
            local end_pos = end_pos_img ~= nil and (end_pos_sfx ~= nil and math.min(end_pos_img, end_pos_sfx) or end_pos_img) or end_pos_sfx
            if begin_pos == 1 then
                firstStr = string.sub(content, 0, end_pos)
                nextStr = string.sub(content, end_pos + 1, string.len(content))
            else
                firstStr = string.sub(content, 0, begin_pos - 1)
                nextStr = string.sub(content, begin_pos, string.len(content))
            end
        else
            firstStr = content
            nextStr = ""
        end

        return firstStr, nextStr
    end

    local lineLayout = GUI:TipLineWidget_Create(layout, "line_layout_" .. index, 0, 0)

    local cell_num = 0

    local function createCell(str)
        local cell = nil
        local offset = {x = 0, y = 0}
        local isSetAnchorPoint = true
        cell_num = cell_num + 1
        if string.find(str, "<IMG:") then
            local find_info_img = {string.find(content, "<IMG:(.-)>")}
            local sliceStr = string.split(find_info_img[3] or "", ":")
            local res = sliceStr[1]
            if tonumber(res) then
                res = string.format("res/custom/tiptitle/%s.png", res)
            end
            if res then
                cell = GUI:Image_Create(lineLayout, "image_" .. cell_num, 0, 0, string.gsub(res, "\\", "/"))
                offset.x = tonumber(sliceStr[2]) or 0
                offset.y = tonumber(sliceStr[3]) or 0
            end
        elseif string.find(str, "<TEXIAO:") then
            local find_info_sfx = {string.find(content, "<TEXIAO:(.-)>")}
            local sliceStr = string.split(find_info_sfx[3] or "", ":")
            local sfxId = tonumber(sliceStr[1])
            if sfxId then
                isSetAnchorPoint = false
                cell = GUI:Effect_Create(lineLayout, "effect_" .. cell_num, 0, 0, 0, sfxId)
                GUI:setContentSize(cell, tonumber(sliceStr[2]) or 50, tonumber(sliceStr[3]) or 50)
                offset.x = tonumber(sliceStr[4]) or 0
                offset.y = tonumber(sliceStr[5]) or 0
            end
        else
            if str == "\\" then
                lineLayout = GUI:TipLineWidget_Create(layout, "line_layout_cell_" .. cell_num, 0, 0)
            elseif string.len(str) > 0 then
                local lineWidth = GUI:TipLineWidget_getSize(lineLayout).width
                local hexColor = color and SL:GetHexColorByStyleId(color) or "#28EF01"
                cell = GUI:RichTextFCOLOR_Create(lineLayout, "rich_" .. cell_num, 0, 0, str, _TotalWidth - 20 - lineWidth, _setFontSize or _DefaultFSize, hexColor, vspace, nil, fontPath)
            end
        end

        if cell then
            if isSetAnchorPoint then
                GUI:setAnchorPoint(cell, 0.5, 0.5)
            end
            GUI:TipLineWidget_pushCell(lineLayout, cell, offset)
        end
    end

    while content and string.len(content) > 0 do
        local firstStr, nextStr = parseStr(content)
        createCell(firstStr)
        content = nextStr
    end

    local layoutSize = {width = 0, height = 0}
    for _, v in pairs(GUI:getChildren(layout)) do
        GUI:TipLineWidget_updateSize(v)
        local size = GUI:TipLineWidget_getSize(v)
        layoutSize.width = math.max(layoutSize.width, size.width)
        layoutSize.height = layoutSize.height + size.height
    end

    GUI:setContentSize(layout, layoutSize)

    local curH = layoutSize.height
    for _, v in pairs(layout:getChildren()) do
        local size = GUI:TipLineWidget_getSize(v)
        curH = curH - size.height
        GUI:setPosition(v, 0, math.floor(curH))
    end

    return layout
end

--自定义属性
function ItemTips.GetCustomShow(parent, data, isPetItem)
    if not data or next(data) == nil then
        return nil
    end
    if not parent then
        return
    end

    local str = ""
    local list = GUI:ListView_Create(parent, "Custom_list", 0, 0, 0, 0, 1)
    GUI:setTouchEnabled(list, false)
    GUI:ListView_setItemsMargin(list, _setVspace or 0)
    local listSize = {width = 0, height = 0}
    for p, d in pairs(data.abil or {}) do
        local isShowAttr = true
        if (not d.t or d.t == "") and not isPetItem then
            isShowAttr = false
        end

        if isShowAttr then
            local title = ItemTips.GetCustomTitleShow(p, list, d.t, d.c)
            if title then
                local titleSize = GUI:getContentSize(title)
                listSize.height = listSize.height + titleSize.height + (_setVspace or 0)
                listSize.width = math.max(listSize.width, titleSize.width)
            end
        end

        local group = d.i or 0
        local attList = {}
        for _, v in pairs(isShowAttr and d.v or {}) do
            local color     = v[1] or 0
            local attId     = v[2] or 0
            local value     = v[3] or 0
            local percent   = v[4] or 0
            local customId  = v[5]
            local pos       = v[6]
            if value and value > 0 then
                local custMap = SL:GetMetaValue("CUST_ABIL_MAP")
                local attNumType = nil
                local custName = nil
                if custMap[attId] and next(custMap[attId]) then
                    local typeMap = {[0] = 1, [1] = 3, [2] = 2}
                    local type = custMap[attId].type or 0
                    if custMap[attId].showCustomName then
                        local config = SL:GetMetaValue("ATTR_CONFIG", attId) or {}
                        custName = config.name
                    end
                    attId = custMap[attId].id
                    attNumType = typeMap[type]
                end
                local attConfig = SL:GetMetaValue("ATTR_CONFIG", attId)
                local noTipsShow = attConfig and (attConfig.noshowtips == 1)
                if not noTipsShow then
                    attList[pos] = attList[pos] or {}
                    table.insert(
                        attList[pos],
                        {color = color, attId = attId, value = value, percent = percent, pos = pos, customId = customId, type = attNumType, custName = custName}
                    )
                end
            end
        end
        attList =
            SL:HashToSortArray(
            attList,
            function(a, b)
                return a[1].pos < b[1].pos
            end
        )

        for k, v in pairs(isShowAttr and attList or {}) do
            local customId = v[1] and v[1].customId or 1
            local customDesc = SL:GetMetaValue("CUSTOM_DESC", customId)
            local customIcon = SL:GetMetaValue("CUSTOM_ICON", customId)
            local color = 0
            local attr = ""
            for i, a in pairs(v) do
                local attConfig = SL:GetMetaValue("ATTR_CONFIG", a.attId)
                if not attConfig then
                    attConfig = {}
                end
                local value = a.value
                if (attConfig and attConfig.type == 2) or a.type == 2 then --万分比除100
                    value = string.format("%.1f", value / 100) * 10 / 10
                end
                if a.type then
                    customDesc = nil
                    customIcon = nil
                end
                if customDesc then
                    local desc = value .. (a.percent > 0 and "%%" or "")
                    customDesc = string.gsub(customDesc, "%%s", desc, 1)
                    if a.color > 0 then
                        color = a.color
                    end
                else
                    local name = attConfig.name
                    if attConfig.AbilEx and string.len(attConfig.AbilEx) > 0 then
                        local sliceStr = string.split(attConfig.AbilEx, "|")
                        if sliceStr[p] then
                            name = sliceStr[p]
                        end
                    end
                    if a.custName then
                        name = a.custName
                    end

                    if isPetItem then
                        attr = attr .. string.format("<%s： %s%s/FCOLOR=%s>", name, value, a.percent > 0 and "%" or "", a.color)
                    else
                        attr = attr .. string.format("<%s：+%s%s/FCOLOR=%s>", name, value, a.percent > 0 and "%" or "", a.color)
                    end
                end
            end

            local node = GUI:Layout_Create(list, string.format("node_%s_%s", p, k), 0, 0, 0, 0)
            GUI:setAnchorPoint(node, 0, 0.5)
            local sizeW, sizeH = 0, 0
            local img = nil
            local tx = nil
            local rich_custom = nil
            if customIcon and next(customIcon) then
                if customIcon[1] then --图片
                    local path = string.gsub(customIcon[1].res, "\\", "/")
                    img = GUI:Image_Create(node, "icon_" .. k, customIcon[1].x, customIcon[1].y, path)
                    GUI:setAnchorPoint(img, 0, 0.5)
                    local imgSize = GUI:getContentSize(img)
                    sizeH = imgSize.height
                    sizeW = sizeW + imgSize.width
                elseif customIcon[2] then --特效
                    tx = GUI:Effect_Create(node, "effect_" .. k, 0, 0, 0, tonumber(customIcon[2].res))
                    local txSize = GUI:getBoundingBox(tx)
                    local anchorPoint = GUI:getAnchorPoint(tx)
                    GUI:setPosition(tx, txSize.width * anchorPoint.x + customIcon[2].x, customIcon[2].y)
                    sizeH = math.max(sizeH, txSize.height)
                    sizeW = sizeW + txSize.width
                end
            end

            if customDesc then
                if color > 0 then
                    if string.find(customDesc, "FCOLOR") then
                        customDesc = string.gsub(customDesc, "FCOLOR=%d+>", string.format("FCOLOR=%s>", color))
                    elseif string.find(customDesc, "<.+>") then
                        customDesc = string.gsub(customDesc, ">", string.format("/FCOLOR=%s>", color))
                    else
                        customDesc = string.format("<%s/FCOLOR=%s>", customDesc, color)
                    end
                end
                attr = customDesc
            else
                attr = attr
            end

            if attr and attr ~= "" then
                rich_custom = GUI:RichTextFCOLOR_Create(node, "rich_" .. k, math.floor(sizeW), 0, attr or "", _TotalWidth - 20, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
                GUI:setAnchorPoint(rich_custom, 0, 0.5)
                local richSz = GUI:getContentSize(rich_custom)
                GUI:setPositionY(rich_custom, math.floor(richSz.height))
                sizeH = math.max(sizeH, richSz.height)
                sizeW = sizeW + richSz.width
            end

            if sizeW > 0 and sizeH > 0 then
                GUI:setContentSize(node, sizeW, sizeH)
                if img then
                    GUI:setPositionY(img, math.floor(sizeH / 2))
                end
                if tx then
                    GUI:setPositionY(tx, math.floor(sizeH / 2))
                end
                if rich_custom then
                    GUI:setPositionY(rich_custom, math.floor(sizeH / 2))
                end

                listSize.height = listSize.height + sizeH + (_setVspace or 0)
                listSize.width = math.max(listSize.width, sizeW)
            end
        end
    end

    if listSize.width > 0 and listSize.height > 0 then
        GUI:setContentSize(list, listSize)
    else
        GUI:removeFromParent(list)
        list = nil
    end

    return list
end

--道具时限 身上的是时间戳 其他地方是剩余时间
function ItemTips.GetTimeStr(type, addValues, onEquip, data)
    local time = nil
    if addValues then
        for _, v in pairs(addValues) do
            if v.Id == 0 then
                time = v.Value
                break
            end
        end
    end
    if not time then
        return nil
    end

    local itemData = data and data.itemData
    local MakeIndex = itemData and itemData.MakeIndex
    if MakeIndex and itemData then
        local from = data and data.from
        if itemData.Need == 101 then --只穿戴身上时计时
            if
                (not from or from == ItemFrom.PALYER_EQUIP or from == ItemFrom.HERO_EQUIP) and
                    SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, from == ItemFrom.HERO_EQUIP)
            then
                time = time - SL:GetMetaValue("SERVER_TIME")
            else
                time = time - (itemData.getServerTime or 0)
            end
        elseif itemData.Need == 102 then --穿戴/背包/仓库都计时
            local checkNext = true
            if checkNext then
                if
                    (not from or from == ItemFrom.PALYER_EQUIP or from == ItemFrom.HERO_EQUIP) and
                        SL:GetMetaValue("EQUIP_DATA_BY_MAKEINDEX", MakeIndex, from == ItemFrom.HERO_EQUIP)
                then
                    time = time - SL:GetMetaValue("SERVER_TIME")
                    checkNext = false
                end
            end

            if checkNext then
                if
                    (not from or from == ItemFrom.BAG or from == ItemFrom.HERO_BAG) and
                        SL:GetMetaValue("ITEM_DATA_BY_MAKEINDEX", MakeIndex, from == ItemFrom.HERO_BAG)
                then
                    time = time - SL:GetMetaValue("SERVER_TIME")
                    checkNext = false
                end
            end

            if checkNext then
                --仓库
                if (not from or from == ItemFrom.STORAGE) and SL:GetMetaValue("STORAGE_DATA_BY_MAKEINDEX", MakeIndex) then
                    time = time - SL:GetMetaValue("SERVER_TIME")
                    checkNext = false
                end
            end

            if checkNext then --最后还是还检测  说明是不变的倒计时
                time = time - (itemData.getServerTime or 0)
            end
        elseif itemData.Need == 103 or itemData.Need == 104 then
            if from ~= ItemFrom.STORAGE then --仓库不刷新
                time = time - SL:GetMetaValue("SERVER_TIME")
            else
                time = time - (itemData.getServerTime or 0)
            end
        end
    else
        if onEquip then
            time = time - SL:GetMetaValue("SERVER_TIME")
        end
    end

    local str = string.format("%s：%s", type == 1 and "限时装备" or "限时道具", SL:TimeFormatToStr(time))

    return str
end

--来源
function ItemTips.GetSrcStr(src)
    if not src or not next(src) then
        return nil
    end
    local titleName = ItemTips._showTitleList[4] and ItemTips._showTitleList[4].name or "[物品来源]："
    local titleColor = ItemTips._showTitleList[4] and ItemTips._showTitleList[4].color or 154
    local str = string.format("<font color='%s'>%s</font>", SL:GetHexColorByStyleId(titleColor), titleName) .. "<br>"

    local map = src[1]
    local srcName = src[2]
    local userName = src[3]
    local time = src[4]

    if map and string.len(map) > 0 then
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "地图", map)
    end
    if srcName and string.len(srcName) > 0 then
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "出处", srcName)
    end
    if userName and string.len(userName) > 0 then
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "角色", userName)
    end
    if time and string.len(time) > 0 then
        local date = os.date("*t", time)
        local timeStr = string.format("%d-%02d-%02d %02d:%02d:%02d", date.year, date.month, date.day, date.hour, date.min, date.sec)
        str = str .. string.format("<font color='%s'>%s：%s</font><br>", SL:GetHexColorByStyleId(251), "时间", timeStr)
    end

    return str
end

--职业等级限制
function ItemTips.GetLimitStr(itemData, from)
    local str = nil
    if itemData.StdMode == 4 then
        local bagUse = true
        local job = SL:GetMetaValue("JOB")
        local needJob = itemData.Shape or 0
        -- 内功等级 （1 怒之 2 静之）
        local needNGLV = itemData.Source == 1 or itemData.Source == 2
        local conditionStr = "需要职业：%s"
        local jobName = "通用"
        local level = _IsHero and SL:GetMetaValue("H.LEVEL") or SL:GetMetaValue("LEVEL")
        if needNGLV then
            level = _IsHero and SL:GetMetaValue("H.INTERNAL_LEVEL") or SL:GetMetaValue("INTERNAL_LEVEL")
        end
        local newMeetJob = nil
        local jobNameList = {
            [1] = "战士",
            [2] = "法师",
            [3] = "道士"
        }
        if (needJob >= 0 and needJob <= 2) then --人物
            conditionStr = "人物职业：%s"
            jobName = jobNameList[1 + needJob]
        elseif needJob >= 3 and needJob <= 5 then --英雄
            job = SL:GetMetaValue("H.JOB")
            needJob = needJob - 3
            conditionStr = "英雄职业：%s"
            jobName = jobNameList[1 + needJob]
            level = needNGLV and SL:GetMetaValue("H.INTERNAL_LEVEL") or SL:GetMetaValue("H.LEVEL")
            bagUse = false
        elseif needJob == 6 then --合击技能
            --0=战士,1=法师,2=道士,99=全职业
            local needJobCondition = {
                [60] = {0, 0},
                [61] = {0, 2},
                [62] = {0, 1},
                [63] = {2, 2},
                [64] = {2, 1},
                [65] = {1, 1}
            }
            newMeetJob = false
            local heroJob = SL:GetMetaValue("H.JOB")
            local newCondition = needJobCondition[itemData.AniCount]
            if newCondition then
                if newCondition[1] == job and newCondition[2] == heroJob then
                    newMeetJob = true
                end
                local jobColor = newCondition[1] == job and "#FFFFFF" or "#FF0500"
                local heroJobColor = newCondition[2] == heroJob and "#FFFFFF" or "#FF0500"
                local str = "<font color='%s' size='%s'>%s</font>+<font color='%s' size='%s'>%s</font>"
                local fontSize = _setFontSize or _DefaultFSize
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
            level = math.min(SL:GetMetaValue("H.LEVEL"), SL:GetMetaValue("LEVEL"))
        elseif needJob >= 9 and needJob <= 20 then -- 多职业
            conditionStr = "人物职业：%s"
            needJob = needJob - 4
            jobName = SL:GetMetaValue("JOB_NAME", needJob) or ""
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

--聚灵珠消耗
function ItemTips.GetJulingCostStr(itemData)
    local str = nil
    if itemData.StdMode == 49 and itemData.AniCount and itemData.AniCount > 0 then
        local moneyId = itemData.AniCount
        local need = itemData.Need
        str = string.format("释放需要花费%s%s", need, SL:GetMetaValue("ITEM_NAME", moneyId))
    end

    return str
end

-- 星级
function ItemTips.GetStarPanel(parent, star)
    if not parent then
        return
    end

    local startNorm = 10 --一行星星数
    local resSpace = 0
    local offY = 0
    local starWid = 25 --星星宽
    local starHei = 25 --星星高
    local startRes = {
        [1] = {img = _PathRes .. "bg_tipszyxx_05.png"},
        [2] = {img = _PathRes .. "bg_tipszyxx_04.png"}
    }

    local starCfg = SL:GetMetaValue("GAME_DATA", "tips_star_custom")
    local modelStrArray = string.split(starCfg or "", "|")
    local modelStr = SL:GetMetaValue("WINPLAYMODE") and (modelStrArray[2] or "") or modelStrArray[1]
    if modelStr and string.len(modelStr) > 0 then
        local cfgArray = string.split(modelStr or "", "#")
        local resType = tonumber(cfgArray[1])
        if resType == 1 or resType == 2 then
            local resPath = string.split(cfgArray[2] or "", "&")
            local resKey = resType == 1 and "img" or "tx"
            for i, v in ipairs(resPath) do
                if v and string.len(v) > 0 then
                    local resP = v
                    if resType == 1 then
                        resP = string.format("%s%s.png", _PathRes, resP)
                    elseif resType == 2 then
                        resP = tonumber(resP) or 0
                    end
                    startRes[i] = {
                        [resKey] = resP
                    }
                end
            end
        end

        if tonumber(cfgArray[3]) then
            resSpace = tonumber(cfgArray[3])
        end
        if tonumber(cfgArray[4]) then
            offY = tonumber(cfgArray[4])
        end
        if tonumber(cfgArray[5]) then
            starWid = tonumber(cfgArray[5])
        end
        if tonumber(cfgArray[6]) then
            starHei = tonumber(cfgArray[6])
        end
    end

    local startNorms = {1, 10, 100, 1000}
    local startCounts = {}

    local starCount = 0 --取星星总数
    for i = #startNorms, 1, -1 do
        local v = startNorms[i]
        if star >= v then
            local count = math.floor(star / v)
            star = star - count * v
            startCounts[#startCounts + 1] = {
                count = count,
                res = startRes[i] or (i > 1 and startRes[2] or startRes[1])
            }
            starCount = starCount + count
        end
    end

    local colCount = math.min(starCount, startNorm)
    local rowCount = math.ceil(starCount / startNorm)
    local panelSize = {
        width = colCount * starWid + (colCount - 1) * resSpace,
        height = rowCount * starHei + (rowCount - 1) * resSpace
    }
    local panel = GUI:Layout_Create(parent, "star_panel", 0, 0, panelSize.width, panelSize.height)

    local posI = 0
    local row = 1
    for _i, _v in ipairs(startCounts) do
        if _v and _v.res and _v.count > 0 then
            for i = 1, _v.count do
                local resNode = nil
                if _v.res.img then --图片
                    resNode = GUI:Image_Create(panel, string.format("star_img_%s_%s", _i, i), 0, 0, string.gsub(_v.res.img, "\\", "/"))
                    GUI:setAnchorPoint(resNode, 0.5, 0)
                elseif _v.res.tx then --特效
                    resNode = GUI:Effect_Create(panel, string.format("star_sfx_%s_%s", _i, i), 0, 0, 0, _v.res.tx)
                end

                if posI == startNorm then
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

--
function ItemTips.GetHP_MP_Str(itemData)
    if itemData.StdMode == 0 and (itemData.Shape == 0 or itemData.Shape == 1) and string.len(itemData.effectParam) > 0 then
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

-- 获取新套装tips
function ItemTips.GetNewSuitPanel(suit, itemData)
    if not suit or suit == "" then
        return nil
    end

    local suitWidth = screenW / 2 --270

    -- 解析新的颜色规则  未获得颜色#获得颜色   无则使用第一个未获得颜色
    local function GetNewColor(txtStr, colorIdx)
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
            equip = _IsHero and SL:GetMetaValue("H.EQUIP_DATA", pos) or SL:GetMetaValue("EQUIP_DATA", pos)
        else
            equip = SL:GetMetaValue("L.M.EQUIP_DATA", pos)
        end
        local equipsuit = nil
        if equip and equip.suitid and string.len(equip.suitid) > 0 then
            equipsuit = equip.suitid
        end
        if equipsuit then
            local equipSuitArray = string.split(equipsuit, "#")
            for i, v in ipairs(equipSuitArray) do
                if v and string.len(v) > 0 then
                    local posSuitConfig = SL:GetMetaValue("SUITEX_CONFIG", tonumber(v))
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
    local job = nil
    if not _lookPlayer then
        job = _IsHero and SL:GetMetaValue("H.JOB") or SL:GetMetaValue("JOB")
    else
        job = SL:GetMetaValue("L.M.JOB")
    end
    local function GetJobDesc(desc)
        if not desc or desc == "" then
            return
        end
        local returnStr = ""
        local descs = string.split(desc or "", "&")
        for i, _str in ipairs(descs) do
            local strs = string.split(_str, "#")
            if strs[2] then
                local jobNum = tonumber(strs[1])
                if jobNum == 3 or (job and jobNum == job) then
                    returnStr = returnStr .. (strs[2] or "")
                end
            else
                returnStr = returnStr .. (strs[1] or "")
            end
        end
        return returnStr
    end

    local posCheckSwitch = tonumber(SL:GetMetaValue("GAME_DATA", "suitCheckPos")) == 1 --做个开关， 是由装备位还是装备名作为检测key（默认是装备名）
    local suitConfigs = SL:GetMetaValue("SUITEX_CONFIG", tonumber(suit))
    local suitStr = ""
    if suitConfigs and next(suitConfigs) then
        for cfgIdx, suitConfig in ipairs(suitConfigs) do
            if suitConfig and next(suitConfig) then
                local suitCount = suitConfig.num
                if suitConfig.desc and suitConfig.desc ~= "" then  -- 套装无描述不显示
                    local meetCount = 0
                    local equopshowArray = string.split(suitConfig.equopshow or "", "|")
                    local equipShowColorStr = ""
                    local equipShowStr = equopshowArray[1] or ""
                    if #equopshowArray > 1 then
                        equipShowColorStr = equopshowArray[1] or ""
                        if equipShowColorStr and equipShowColorStr ~= "" then
                            equipShowColorStr = equipShowColorStr .. "|"
                        end
                        equipShowStr = equopshowArray[2] or ""
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
                            local color, showShowStr = GetNewColor(showStr, meet and 2 or 1)
                            local size = _setFontSize or _DefaultFSize
                            local colorHex = SL:GetHexColorByStyleId(color)
                            local showStrFormat = string.format("<font color='%s' size='%s'>%s</font><br>", colorHex, size, showShowStr)
                            suitStr = suitStr .. showStrFormat
                        end
                    end

                    local titleStr = suitConfig.name or ""
                    if titleStr and string.len(titleStr) > 0 then
                        local color, showTitle = GetNewColor(titleStr, meetCount >= suitCount and 2 or 1)
                        local size = _setFontSize or _DefaultFSize
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

                    local descStr = GetJobDesc(suitConfig.desc)
                    if descStr and string.len(descStr) > 0 then
                        local color, showDescStr = GetNewColor(descStr, meetCount >= suitCount and 2 or 1)
                        local size = _setFontSize or _DefaultFSize
                        local colorHex = SL:GetHexColorByStyleId(color)
                        local showDescStrFormat = string.format("<font color='%s' size='%s'>%s</font><br>", colorHex, size, showDescStr)
                        suitStr = suitStr .. showDescStrFormat
                    end
                end
            end
        end
    else
        return
    end

    if string.len(suitStr or "") == 0 then
        return
    end

    local tipsPanel, listView = ItemTips.GetNewTipsPanel("new_suit" .. (itemData.MakeIndex or "_") .. suit)

    if SL:GetMetaValue("WINPLAYMODE") then
        local topSpace = ItemTips.CreateIntervalPanel(listView, 1)
    end
    local rich_suit = GUI:RichText_Create(listView, "rich_suit", 0, 0, suitStr or "", suitWidth - 20, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
    GUI:setAnchorPoint(rich_suit, 0, 0)

    local size = GUI:getContentSize(rich_suit)
    local richWidth = size.width

    GUI:ListView_doLayout(listView)
    local innH = GUI:ListView_getInnerContainerSize(listView).height
    local listH = math.min(innH, _TipsMaxH)
    GUI:setContentSize(listView, richWidth, listH)
    GUI:setPosition(listView, 10, 10)
    GUI:setContentSize(tipsPanel, richWidth + 20, listH + 20)

    if innH > listH then
        GUI:setTouchEnabled(listView, true)
        ItemTips.SetTipsScrollArrow(tipsPanel, listView, innH, listH)
    end

    if ssrGlobal_ItemTipsSuitPanelEx then
        local widget = ssrGlobal_ItemTipsSuitPanelEx(itemData, tipsPanel)
        if widget and not tolua.isnull(widget) then
            GUI:addChild(tipsPanel, widget)
        end
    end
end

-- 获取老套装tips
function ItemTips.GetSuitPanel(suitConfig, itemData, idx)
    if ItemTips._diff then
        return
    end

    local tipsPanel, listView = ItemTips.GetNewTipsPanel("suit" .. (itemData.MakeIndex or "_") .. (idx or 0))

    local panel = GUI:Layout_Create(listView, "panel_suit", 0, 0, 0, 0)
    local suitWidth = screenW / 2

    local richWidth = 0
    local index = 0
    local heights = {}
    local interval = _setVspace or 0

    -- 解析新的颜色规则  未获得颜色#获得颜色   没有使用第一个未获得颜色
    local function GetNewColor(colorStr, colorIdx)
        colorIdx = colorIdx or 1
        local colorArry = string.split(colorStr or "", "#")
        if #colorArry <= 1 then
            table.insert(colorArry, 1, 249)
        end
        return tonumber(colorArry[colorIdx]) or tonumber(colorArry[1])
    end

    -- 解析新的/FCOLOR颜色规则  未获得颜色#获得颜色   fColorIdx: 颜色的下标
    local function GetNewFColor(textStr, fColorIdx)
        textStr = textStr or ""
        fColorIdx = fColorIdx or 1
        local newTextStr = ""
        while true do
            local startIndex, endIndex = string.find(textStr, "%b<>")
            if startIndex and endIndex then
                if startIndex > 1 then
                    newTextStr = newTextStr .. string.sub(textStr, 1, startIndex - 1)
                end

                local newFColorStr = string.sub(textStr, startIndex, endIndex)
                local cStart, cEnd = string.find(newFColorStr, "/FCOLOR=")
                if cStart and cEnd then
                    local colorStr = string.sub(newFColorStr, cEnd + 1, -2)
                    local colorArry = string.split(colorStr or "", "#")
                    newFColorStr = string.sub(newFColorStr, 1, cEnd)
                    if #colorArry <= 1 then
                        table.insert(colorArry, 1, 215)
                    end
                    newFColorStr = newFColorStr .. (tonumber(colorArry[fColorIdx]) and colorArry[fColorIdx] or colorArry[1]) .. ">"
                end

                newTextStr = newTextStr .. newFColorStr

                textStr = string.sub(textStr, endIndex + 1, -1)
            else
                newTextStr = newTextStr .. textStr
                break
            end
        end
        return newTextStr
    end

    local sliceStr = string.split(suitConfig.equipNameStr, "|")
    local sliceName = string.split(sliceStr[1], "/")
    local nameColor = nil
    local name = ""
    local suitCount = tonumber(sliceStr[2]) or 1

    if #sliceName >= 2 then
        if sliceName[1] ~= nil and string.len(sliceName[1]) > 0 then
            nameColor = sliceName[1]
        end
        if sliceName[2] ~= nil and string.len(sliceName[2]) > 0 then
            name = sliceName[2]
        end
    else
        name = sliceName[1]
    end

    --套装部位
    local equipNameStr = ""
    local meetCount = 0
    local sameName = {}
    for i = 3, #sliceStr do
        local equipSlice = string.split(sliceStr[i], "/")
        local equipColor = 150
        local name = ""

        if #equipSlice >= 2 then
            if equipSlice[1] ~= nil and string.len(equipSlice[1]) > 0 then
                equipColor = equipSlice[1]
            end
            if equipSlice[2] ~= nil and string.len(equipSlice[2]) > 0 then
                name = equipSlice[2]
            end
        else
            name = equipSlice[1]
        end

        local meet = false
        local equip = nil
        local equipCount = 0
        sameName[name] = sameName[name] ~= nil and sameName[name] + 1 or 1
        if not _lookPlayer then
            equip = _IsHero and SL:GetMetaValue("H.EQUIP_DATA", name) or SL:GetMetaValue("EQUIP_DATA", name)
        else
            equip = SL:GetMetaValue("L.M.EQUIP_DATA", name)
        end
        if equip then
            equipCount = #equip
            if equipCount >= sameName[name] then
                meet = true
                meetCount = meetCount + 1
            end
        end

        local color = GetNewColor(equipColor, meet and 2 or 1)
        local size = _setFontSize or _DefaultFSize
        local colorHex = SL:GetHexColorByStyleId(color)
        equipNameStr = string.format("%s<font color='%s' size='%s'>%s</font>", equipNameStr, colorHex, size, name)
        equipNameStr = equipNameStr .. (i ~= #sliceStr and "<br>" or "")
    end

    if nameColor then
        nameColor = GetNewColor(nameColor, meetCount >= suitCount and 2 or 1)
    end

    nameColor = nameColor or 250
    local nSize = _setFontSize or _DefaultFSize
    local nColorHex = SL:GetHexColorByStyleId(nameColor)
    local suitNameStr =
        string.format(
        "<font color='%s' size='%s'>%s(%s/%s)</font><br>",
        nColorHex,
        nSize,
        name,
        math.min(meetCount, suitCount),
        suitCount
    )
    local descs = GUIFunction:GetParseItemDesc(suitNameStr .. equipNameStr)
    if descs and descs.desc and next(descs.desc) then --这里不支持top  bottom
        for i, v in pairs(descs.desc) do
            if v.text then
                index = index + 1
                local label_posName = GUI:RichText_Create(panel, "name_text_" .. index, 0, 0, v.text or "", suitWidth - 20, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(255), vspace, nil, fontPath)
                GUI:setAnchorPoint(label_posName, 0, 0)
                GUI:setTag(label_posName, index)
                local size = GUI:getContentSize(label_posName)
                heights[index] = size.height + interval
                richWidth = math.max(richWidth, size.width)
            elseif v.res then
                index = index + 1
                local img = ItemTips.GetNodeImage(panel, v, index)
                if img then
                    GUI:setTag(img, index)
                    local size = GUI:getContentSize(img)
                    heights[index] = size.height + interval
                    richWidth = math.max(richWidth, size.width)
                end
            end
        end
    end

    local attrDescs = GUIFunction:GetParseItemDesc(suitConfig.equipAttStr)
    if attrDescs and attrDescs.desc and next(attrDescs.desc) then --这里不支持top  bottom
        for i, v in pairs(attrDescs.desc) do
            if v.text then
                index = index + 1
                local label_posName = GUI:RichTextFCOLOR_Create(panel, "desc_text_" .. index, 0, 0, v.text or "", suitWidth - 20, _setFontSize or _DefaultFSize, SL:GetColorByStyleId(255), vspace, nil, fontPath)
                GUI:setAnchorPoint(label_posName, 0, 0) 
                GUI:setTag(label_posName, index)
                local size = GUI:getContentSize(label_posName)
                heights[index] = size.height + interval
                richWidth = math.max(richWidth, size.width)
            elseif v.res then
                index = index + 1
                local img = ItemTips.GetNodeImage(panel, v, index)
                if img then
                    GUI:setTag(img, index)
                    local size = GUI:getContentSize(img)
                    heights[index] = size.height + interval
                    richWidth = math.max(richWidth, size.width)
                end
            end
        end
    end

    local height = 0
    for _, v in pairs(heights) do
        height = height + v
    end

    local curH = height
    for i = 1, index do
        local label = GUI:getChildByTag(panel, i)
        if label then
            curH = curH - heights[i]
            GUI:setPositionY(label, math.floor(curH))
        end
    end

    GUI:setContentSize(panel, richWidth, height)
    GUI:ListView_doLayout(listView)

    local innH = GUI:ListView_getInnerContainerSize(listView).height
    local listH = math.min(innH, _TipsMaxH)
    GUI:setContentSize(listView, richWidth, listH)
    GUI:setPosition(listView, 10, 10)
    GUI:setContentSize(tipsPanel, richWidth + 20, listH + 20)

    if innH > listH then
        GUI:setTouchEnabled(listView, true)
        ItemTips.SetTipsScrollArrow(tipsPanel, listView, innH, listH)
    end

    if ssrGlobal_ItemTipsSuitPanelEx then
        local widget = ssrGlobal_ItemTipsSuitPanelEx(itemData, tipsPanel)
        if widget and not tolua.isnull(widget) then
            GUI:addChild(tipsPanel, widget)
        end
    end
end

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
    _PanelNum = _PanelNum + 1
    local childs = ItemTips._panelListSubItems
    local lastWidget = childs[#childs]
    local x = GUI:getPositionX(lastWidget)
    local y = GUI:getPositionY(lastWidget)
    local wid = GUI:getContentSize(lastWidget).width

    local tipsPanel = ItemTips.AddTipLayout(ItemTips._PList, "tips_" .. tag)
    GUI:setPosition(tipsPanel, wid + x, 0)
    GUI:setTouchEnabled(tipsPanel, false)
    GUI:setAnchorPoint(tipsPanel, 0, 1)
    table.insert(ItemTips._panelListSubItems, tipsPanel)

    local listView = GUI:ListView_Create(tipsPanel, "listView_" .. tag, 0, 0, 0, 0, 1)
    GUI:ListView_setClippingEnabled(listView, true)
    GUI:ListView_setItemsMargin(listView, _setVspace or 0)
    GUI:setTouchEnabled(listView, false)

    return tipsPanel, listView
end

--设置箭头
function ItemTips.SetTipsScrollArrow(tipsPanel, listView, innH, listH)
    local maxWidth = GUI:getContentSize(tipsPanel).width
    -- 底部箭头
    local bottomArrowImg = GUI:Image_Create(tipsPanel, "bottom_arrow", maxWidth / 2, 15, "res/public/btn_szjm_01_1.png")
    GUI:setTouchEnabled(bottomArrowImg, true)
    GUI:setAnchorPoint(bottomArrowImg, 0.5, 0.5)
    GUI:setRotation(bottomArrowImg, -90)
    local action =
        GUI:ActionRepeatForever(
        GUI:ActionSequence(GUI:ActionFadeTo(0.2, 125), GUI:ActionFadeTo(0.2, 255), GUI:DelayTime(0.3))
    )
    GUI:runAction(bottomArrowImg, action)

    -- 顶部箭头
    local topArrowImg = GUI:Image_Create(tipsPanel, "top_arrow", maxWidth / 2, listH - 15, "res/public/btn_szjm_01_1.png")
    GUI:setTouchEnabled(topArrowImg, true)
    GUI:setAnchorPoint(topArrowImg, 0.5, 0.5)
    GUI:setRotation(topArrowImg, 90)
    GUI:runAction(topArrowImg, action)

    local function refreshArrow()
        local innerPos = GUI:ListView_getInnerContainerPosition(listView)
        GUI:setVisible(bottomArrowImg, innerPos.y < innH and innerPos.y < 0)
        GUI:setVisible(topArrowImg, innerPos.y > (listH - innH) or innerPos.y >= 0)
    end

    refreshArrow()

    local bottomEvent = function()
        if innH > listH and not tolua.isnull(listView) then
            local innerPos      = GUI:ListView_getInnerContainerPosition(listView)
            local vHeight       = innH - listH
            local percent       = (vHeight + innerPos.y + 50) / vHeight * 100
            percent             = math.min(math.max(0, percent), 100)
            GUI:ListView_scrollToPercentVertical(listView, percent, 0.03, false)
            refreshArrow()
        end
    end

    local topEvent = function()
        if innH > listH and not tolua.isnull(listView) then
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

    if SL:GetMetaValue("WINPLAYMODE") then
        ItemTips._topScrollEvent      = topEvent
        ItemTips._bottomScrollEvent   = bottomEvent
    end
    SL:schedule(bottomArrowImg, refreshArrow, 0.1)
end

-- 衣服、武器内观预览
function ItemTips.GetModelPanel(itemData)
    local isShow = tonumber(SL:GetMetaValue("GAME_DATA", "itemShowModel"))
    if not isShow or isShow ~= 1 then
        return
    end

    if ItemTips._diff or _isSelf or not itemData or not itemData.StdMode then
        return nil
    end
    local StdMode = itemData.StdMode
    local pos = SL:GetMetaValue("EQUIP_POS_BY_STDMODE", StdMode)
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

    local sex = SL:GetMetaValue("SEX")
    local job = SL:GetMetaValue("JOB")
    local feature = {}

    local data = SL:GetMetaValue("FEATURE")
    local hairID = data and data.hairID
    local normalDress = sex == 0 and 60 or 80

    if pos == 0 or pos == 17 then --衣服
        --衣服
        sex = 0 and StdMode == 10 and 0 or 1
        feature.clothID = itemData.Looks
        feature.clothEffectID = itemData.sEffect
        feature.noHead = itemData.show == 1
    elseif pos == 1 or pos == 18 then --武器
        feature.weaponID = itemData.Looks
        feature.weaponEffectID = itemData.sEffect
        feature.clothID = normalDress
    end

    if not next(feature) then
        return nil
    end

    feature.hairID = hairID
    _PanelNum = _PanelNum + 1

    local size = {width = 200, height = 260}
    local tipsPanel = ItemTips.GetNewTipsPanel("model")
    GUI:setContentSize(tipsPanel, size.width, size.height)

    local model = GUI:UIModel_Create(tipsPanel, "model", size.width / 2, size.height / 2, sex, feature, nil, true, job)
end

function ItemTips.RefreshItemPosition(tips, listView, size)
    size = size or {}
    local listHeight = GUI:ListView_getInnerContainerSize(listView).height
    if listHeight > _TipsMaxH then
        listHeight = _TipsMaxH - 20
    end
    local listWidth = size.width or 0
    local maxWidth = size.width or 0
    local itemsW = {}
    local isAdjustWidth = false
    for i = 1, ItemTips.itemCount do
        local item = GUI:getChildByTag(ItemTips.contentPanel, i)
        if item then
            itemsW[i] = GUI:getContentSize(item)
            maxWidth = math.max(maxWidth, GUI:getContentSize(item).width)
            if not isAdjustWidth then
                if item._itemWid then
                    isAdjustWidth = maxWidth == item._itemWid
                else
                    isAdjustWidth = maxWidth == GUI:getContentSize(item).width
                end
            end
        end
    end

    local value = SL:GetMetaValue("GAME_DATA", "tipsButtonOut")
    local isTipsOutSideBtn = tonumber(value) and tonumber(value) == 1

    if not isTipsOutSideBtn then
        local index = 1
        local movePosX, movePosY = 0, 0
        if SL:GetMetaValue("WINPLAYMODE") then
            movePosX, movePosY = 17, 7
        end
        for i = 1, 3 do
            local btn = GUI:getChildByName(tips, "BTN_" .. i)
            if btn then
                local btnSz = GUI:getContentSize(btn)
                if isAdjustWidth then
                    isAdjustWidth = false
                    maxWidth = maxWidth + btnSz.width
                end
                local posX = maxWidth - btnSz.width / 2 - 18 - 5
                local posY = listHeight - (index - 1) * 50 - btnSz.height / 2 + movePosY
                local itemSzW = 0
                if index > 1 then
                    local itemSzW1 = itemsW[(index - 1) * 2] and itemsW[(index - 1) * 2].width or 0
                    local itemSzW2 = itemsW[(index - 1) * 2 + 1] and itemsW[(index - 1) * 2 + 1].width or 0
                    itemSzW = math.max(itemSzW1, itemSzW2)
                else
                    itemSzW = itemsW[index] and itemsW[index].width or 0
                end
                if itemSzW > posX then
                    local newListsWidth = itemSzW + btnSz.width + 10
                    if newListsWidth > listWidth then
                        listWidth = newListsWidth
                        posX = listWidth - btnSz.width / 2 - 18 - 5
                        if listWidth > maxWidth then
                            maxWidth = listWidth
                        end
                        for idx = index - 1, 1, -1 do
                            local btn1 = GUI:getChildByName(tips, "BTN_" .. idx)
                            GUI:setPositionX(btn1, posX + movePosX)
                        end
                    end
                end
                GUI:setPosition(btn, posX + movePosX + rightSpace, posY)
                index = index + 1
            end
        end
    end

    local tipExtraWidth = isTipsOutSideBtn and 0 or 20

    listWidth = math.max(listWidth, maxWidth)

    GUI:setContentSize(listView, listWidth, listHeight)
    GUI:setContentSize(tips, listWidth + tipExtraWidth + rightSpace, listHeight + 20)

    if isTipsOutSideBtn then
        local heightOffY = 0
        for i = 1, 3 do
            local btn = GUI:getChildByName(tips, "BTN_" .. i)
            if btn then
                local btnSz = GUI:getContentSize(btn)
                GUI:setPosition(btn, listWidth + rightSpace, heightOffY)
                heightOffY = heightOffY + btnSz.height
            end
        end
    end
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
            pos.y = visibleSize.height / 2
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
            pos.x = visibleSize.width / 2
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
    for _, v in pairs(GUI:getChildren(ItemTips._PList)) do
        local size = GUI:getContentSize(v)
        width = width + size.width + space
        maxHeight = math.max(maxHeight, size.height)
    end

    GUI:setContentSize(ItemTips._PList, width, maxHeight)
    width = 0
    for _, v in pairs(ItemTips._panelListSubItems) do
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
    GUI:setPosition(ItemTips._PList, pos.x, pos.y)
end

local function pushDescItem(desc, descTag)
    if not desc or not ItemTips.contentPanel then
        return
    end
    local movePosY = 0
    if desc and next(desc) then
        local contentSz = GUI:getContentSize(ItemTips.contentPanel)
        for i, v in ipairs(desc) do
            local isadd = true
            if descTag == 1 then
                if v.y and v.y ~= 0 then
                    isadd = false
                    v.y = contentSz.height - v.y
                    v.isTop = true
                    table.insert(topDesY, v)
                end
            end

            if isadd then
                if v.isTop then
                    v.y = contentSz.height - v.y
                    GUI:setContentSize(ItemTips.contentPanel, contentSz)
                end

                if v.newLine then
                    local lineH = v.height or 0
                    lineH = lineH > 0 and lineH or _DefaultSpace
                    local linePanel = ItemTips.CreateIntervalPanel(ItemTips.contentPanel, lineH, true)
                    GUI:setPosition(linePanel, v.x or 0, v.y or 0)
                    ItemTips.PushItem(ItemTips.contentPanel, linePanel)
                elseif v.text then
                    rich_att_num = rich_att_num + 1
                    local textSize = _setFontSize or _DefaultFSize
                    if v.fontsize and v.fontsize > 0 then
                        textSize = v.fontsize
                    end
                    local rich_att = GUI:RichTextFCOLOR_Create(ItemTips.contentPanel, string.format("rich_att_%s", rich_att_num), math.floor(v.x or 0), math.floor(v.y or 0), v.text, ItemTips._isItem and 420 or (_TotalWidth - 20), textSize, "#FFFFFF", vspace, nil, fontPath)
                    ItemTips.PushItem(ItemTips.contentPanel, rich_att)
                    if SL:GetMetaValue("WINPLAYMODE") then
                        movePosY = movePosY - 1
                    end
                elseif v.res then
                    desc_img_num = desc_img_num + 1
                    local img = ItemTips.GetNodeImage(ItemTips.contentPanel, v, desc_img_num)
                    if img then
                        ItemTips.PushItem(ItemTips.contentPanel, img)
                        if v.isSFX and SL:GetMetaValue("WINPLAYMODE") then --pc与移动的宽高差导致的位置进行调整
                            local imgSz = GUI:getContentSize(img)
                            local posX = GUI:getPositionX(img)
                            local posY = GUI:getPositionY(img)
                            GUI:setPosition(img, math.floor(posX), math.floor(posY - imgSz.height / 2 + movePosY))
                        end
                    end
                end
            end
        end
    end
end

function ItemTips.AddFrameEffect(parent, itemDescs)
    -- 特效根据配置宽高进行缩放
    local function animScale(anim)
        if anim and anim.isSFX then --isSFX判断是否是特效
            local scaleX, scaleY = 1, 1
            if anim.configW and anim.configW > 0 then
                scaleX = anim.configW
            end
            if anim.configH and anim.configH > 0 then
                scaleY = anim.configH
            end
            --外边框的宽、高缩放
            GUI:setScaleX(anim, scaleX)
            GUI:setScaleY(anim, scaleY)

            if anim.order and anim.order == 0 then
                GUI:setLocalZOrder(anim, -1)
            end
        end
    end

    local function addFrameDesc(desc, frameChilds)
        if desc and next(desc) then
            for i, v in ipairs(desc) do
                if v.newLine then
                    local lineH = v.height or 0
                    lineH = lineH > 0 and lineH or _DefaultSpace
                    local linePanel = ItemTips.CreateIntervalPanel(parent, lineH, true)
                    GUI:setPosition(linePanel, v.x or 0, v.y or 0)

                    if frameChilds then
                        table.insert(frameChilds, linePanel)
                    end
                elseif v.text then
                    rich_att_num = rich_att_num + 1
                    local textSize = _setFontSize or _DefaultFSize
                    if v.fontsize and v.fontsize > 0 then
                        textSize = v.fontsize
                    end
                    local rich_att = GUI:RichTextFCOLOR_Create(parent, string.format("rich_att_%s", rich_att_num), math.floor(v.x or 0), math.floor(v.y or 0), v.text, ItemTips._isItem and 420 or (_TotalWidth - 20), textSize, "#FFFFFF", vspace, nil, fontPath)
                    if frameChilds then
                        table.insert(frameChilds, rich_att)
                    end
                elseif v.res then
                    desc_img_num = desc_img_num + 1
                    local img = ItemTips.GetNodeImage(parent, v, desc_img_num)
                    if img and frameChilds then
                        img.isSFX   = v.isSFX
                        img.configW = v.width
                        img.configH = v.height
                        img.order   = v.frameOrder
                        table.insert(frameChilds, img)
                    end
                end
            end
        end
    end

    -- 框体特效
    local frameTopDesc = itemDescs.frame_top_desc
    if frameTopDesc and next(frameTopDesc) then
        local frameChilds = {}
        addFrameDesc(frameTopDesc, frameChilds)
        local tipsPanelSz = GUI:getContentSize(parent)
        for i, children in ipairs(frameChilds) do
            if children then
                local x = GUI:getPositionX(children)
                local y = GUI:getPositionY(children) + tipsPanelSz.height
                GUI:setPosition(children, x, y)
                animScale(children)
            end
        end
    end

    local frameBottomDesc = itemDescs.frame_bottom_desc
    if frameBottomDesc then
        local frameChilds = {}
        addFrameDesc(frameBottomDesc, frameChilds)
        for i, children in ipairs(frameChilds) do
            if children then
                animScale(children)
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
end

------------  装备tips  ------------------------------------------------
function ItemTips.CreateEquipPanel(data, itemData, isWear, panelInsertIndex)
    if not data or not itemData then
        return
    end

    if SL:GetMetaValue("WINPLAYMODE") then
        isWear = false
    end

    ResetDescParam()
    ItemTips.itemCount = 0

    if not ItemTips._PList then
        ItemTips._PList = GUI:Layout_Create(ItemTips._PMainUI, "PList", data.pos.x, data.pos.y, 0, 0)
        GUI:setTouchEnabled(ItemTips._PList, false)
        GUI:setAnchorPoint(ItemTips._PList, 0, 1)
    end

    _PanelNum = _PanelNum + 1
    local richWidth = _TotalWidth - 20
    local maxWidth = 0
    local hh = 0

    local ListBg = ItemTips.AddTipLayout(ItemTips._PList, "ListBg" .. _PanelNum)
    GUI:setPosition(ListBg, 0, 0)
    GUI:setAnchorPoint(ListBg, 0, 1)
    GUI:setTouchEnabled(ListBg, false)

    local index = tonumber(panelInsertIndex) and (tonumber(panelInsertIndex) + 1) or 1
    table.insert(ItemTips._panelListSubItems, index, ListBg)

    local scrollView = GUI:ScrollView_Create(ListBg, "scrollView", 0, 0, 0, 0, 1)
    GUI:ScrollView_setClippingEnabled(scrollView, true)
    GUI:setTouchEnabled(scrollView, false)

    if not SL:GetMetaValue("WINPLAYMODE") then
        GUI:setTouchEnabled(ListBg, true)
        GUI:setTouchEnabled(scrollView, true)
    end

    local contentPanel = GUI:Layout_Create(scrollView, "contentPanel", 0, 0, maxWidth, 1)
    GUI:setAnchorPoint(contentPanel, 0, 0)
    ItemTips.contentPanel = contentPanel

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255
    local name = itemData.Name or ""
    -- 沙巴克标识
    local sbk = nil
    if itemData.Values then
        for _, v in pairs(itemData.Values) do
            if v.Id == 15 then
                sbk = v.Value
                break
            end
        end
    end
    if sbk and sbk > 0 then
        name = "(*)" .. name
    end

    -- 装备穿戴状态
    if data.diff then
        local rich_equip = GUI:RichText_Create(contentPanel, "r_diff", 0, 0, "[当前身上装备]", richWidth, _TextSize, SL:GetHexColorByStyleId(250), vspace, nil, fontPath)
        ItemTips.PushItem(contentPanel, rich_equip)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 装备名称
    local nameStr = string.format("<font color='%s' size='%s'>%s</font>", SL:GetHexColorByStyleId(color), _TextSize, name) 
    local r_name = GUI:RichText_Create(contentPanel, "r_name", 0, 0, nameStr, richWidth, _TextSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
    ItemTips.PushItem(contentPanel, r_name)
    ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))

    local itemDescs = GUIFunction:GetParseItemDesc(itemData.Desc)
    -- 顶部描述
    local topDescs = itemDescs.top_desc
    if topDescs then
        removeLastLine()
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace / 2))
        pushDescItem(topDescs, 1)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 绑定
    if itemData.BindInfo and string.len(itemData.BindInfo) > 0 then
        local rich_bind = GUI:RichText_Create(contentPanel, "rich_bind", 0, 0, string.format("已绑定[%s]", itemData.BindInfo), richWidth, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
        ItemTips.PushItem(contentPanel, rich_bind)
    end

    maxWidth = math.max(maxWidth, GUI:getContentSize(r_name).width)

    -- icon
    local res = SL:GetMetaValue("WINPLAYMODE") and _PathRes .. "1900025000.png" or _PathRes .. "1900025001.png"
    local icon_bg = GUI:Image_Create(contentPanel, "icon_bg", 0, 0, res)
    local size = GUI:getContentSize(icon_bg)
    icon_bg._itemWid = size.width
    local item = GUI:ItemShow_Create(icon_bg, "item_", size.width / 2, size.height / 2, {itemData = itemData, index = itemData.Index, disShowCount = true, notShowEquipRedMask = true})
    GUI:setAnchorPoint(item, 0.5, 0.5)
    ItemTips.PushItem(contentPanel, icon_bg)
    ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))

    -- 投保
    if SL:GetMetaValue("SERVER_OPTIONS", SW_KEY_ITEMTIPS_TOUBAO_SHOW) == 1 then
        local touBaoStr = ItemTips.GetTouBaoDesc(itemData)
        if touBaoStr then
            local rich_tb = GUI:RichText_Create(contentPanel, "rich_tb", 0, 0, touBaoStr, richWidth, _setFontSize or _DefaultFSize , "#FF0500", vspace, nil, fontPath)
            ItemTips.PushItem(contentPanel, rich_tb)
            maxWidth = math.max(maxWidth, GUI:getContentSize(rich_tb).width)
        end
    end

    -- 星级
    if itemData.Star and itemData.Star > 0 then
        local starPanel = ItemTips.GetStarPanel(contentPanel, itemData.Star)
        ItemTips.PushItem(contentPanel, starPanel)
        if starPanel then
            maxWidth = math.max(maxWidth, GUI:getContentSize(starPanel).width)
        end
    end

    local iconMoveY = SL:GetMetaValue("WINPLAYMODE") and -6 or 0
    -- 绑定
    if itemData.Bind and string.len(itemData.Bind) > 0 and SL:GetMetaValue("ITEM_IS_BIND", itemData) then
        local rich_bind = GUI:RichText_Create(GUI:ItemShow_GetLayoutExtra(item), "rich_bind", size.width + 10, size.height + iconMoveY, "已绑定", richWidth, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_bind, 0, 1)
        -- 特殊需要单独设置
        GUI:RefPosByParent(rich_bind)
        local bindSize = GUI:getContentSize(rich_bind)
        maxWidth = math.max(maxWidth, bindSize.width + size.width + 20)
        icon_bg._itemWid = bindSize.width + size.width + 20
    end

    -- 重量
    if itemData.Weight and itemData.Weight > 0 then
        local str = string.format("重量：%s", itemData.Weight)
        local rich_weight = GUI:RichText_Create(GUI:ItemShow_GetLayoutExtra(item), "rich_weight", size.width + 10, size.height / 2 + iconMoveY, str, richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_weight, 0, 0.5)
        GUI:RefPosByParent(rich_weight)
        local weightSize = GUI:getContentSize(rich_weight)
        maxWidth = math.max(maxWidth, weightSize.width + size.width + 20)
        icon_bg._itemWid = math.max(icon_bg._itemWid, weightSize.width + size.width + 20)
    end

    -- Mode
    local modeStr = ItemTips.GetModeStr(itemData)
    if modeStr then
        local rich_mode = GUI:RichText_Create(GUI:ItemShow_GetLayoutExtra(item), "rich_mode", size.width + 10, iconMoveY, modeStr, richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_mode, 0, 0)
        GUI:RefPosByParent(rich_mode)
        local modeSize = GUI:getContentSize(rich_mode)
        maxWidth = math.max(maxWidth, modeSize.width + size.width + 20)
        icon_bg._itemWid = math.max(icon_bg._itemWid, modeSize.width + size.width + 20)
    end

    -- 刀魂
    local extend = itemData.ExtendInfo
    if extend then
        local swordSoulIndex = 0
        while true do
            local swordSoulData = extend["LH" .. swordSoulIndex]
            if not swordSoulData then
                break
            end
            local swordSoulTips = ItemTips.GetSwordOfSoul(contentPanel, swordSoulData, swordSoulIndex)
            if swordSoulTips then
                ItemTips.PushItem(contentPanel, swordSoulTips)
                maxWidth = math.max(maxWidth, GUI:getContentSize(swordSoulTips).width)
            end
            swordSoulIndex = swordSoulIndex + 1
        end
    end

    -- 基础属性
    local upAttrRichs = {}
    local upAttrMaxWidth = 0
    local attStr, attStr2, upAttrs = ItemTips.GetAttStr(itemData, data.diff)
    local showAttr = true
    -- 宠物装备
    if (itemData.StdMode == 22 and itemData.Shape == 130) or (itemData.StdMode == 26 and itemData.Shape == 131) or (itemData.StdMode == 15 and itemData.Shape == 132) then
        showAttr = itemData.TipsShowAttr == 1
        if not showAttr then
            local rich_att = GUI:RichText_Create(contentPanel, "rich_att_pet", 0, 0, "?????", richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath) 
            ItemTips.PushItem(contentPanel, rich_att)
            maxWidth = math.max(maxWidth, GUI:getContentSize(rich_att).width)
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
        end
    end

    if showAttr and attStr and #attStr > 0 then
        for i, v in ipairs(attStr) do
            local rich_att_base = nil
            if v.str then
                rich_att_base = GUI:RichText_Create(contentPanel, "rich_att_base_" .. i, 0, 0, v.str, richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath) 
                ItemTips.PushItem(contentPanel, rich_att_base)
                maxWidth = math.max(maxWidth, GUI:getContentSize(rich_att_base).width)
                upAttrMaxWidth = math.max(upAttrMaxWidth, GUI:getContentSize(rich_att_base).width)
            end

            if rich_att_base and v.id and upAttrs[v.id] then
                table.insert(upAttrRichs, rich_att_base)
            end
        end
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 条件限制
    local needStr = ItemTips.GetNeedStr(itemData)
    if needStr then
        local rich_need = GUI:RichText_Create(contentPanel, "rich_need", 0, 0, needStr, richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath) 
        ItemTips.PushItem(contentPanel, rich_need)
        maxWidth = math.max(maxWidth, GUI:getContentSize(rich_need).width)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 元素属性
    if attStr2 and #attStr2 > 0 then
        for i, v in ipairs(attStr2) do
            local rich_att_ys = nil
            if v.str then
                rich_att_ys = GUI:RichText_Create(contentPanel, "rich_att_ys_"..i, 0, 0, v.str, richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath) 
                ItemTips.PushItem(contentPanel, rich_att_ys)
                maxWidth = math.max(maxWidth, GUI:getContentSize(rich_att_ys).width)
                upAttrMaxWidth = math.max(upAttrMaxWidth, GUI:getContentSize(rich_att_ys).width)
            end

            if rich_att_ys and v.id and upAttrs[v.id] then
                table.insert(upAttrRichs, rich_att_ys)
            end
        end
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 附加属性
    local needCombineEx = checkNeedCombineExAdd()
    local abilexStr = itemData.ExAbil and itemData.ExAbil.abilex
    local exAttrStr = not needCombineEx and ItemTips.ParseExAddAttr(abilexStr) or nil
    if exAttrStr and next(exAttrStr) then
        for i, v in ipairs(exAttrStr) do
            local rich_att_ex = nil
            if v.str then
                rich_att_ex = GUI:RichText_Create(contentPanel, "rich_att_ex_" .. i, 0, 0, v.str, richWidth, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath) 
                ItemTips.PushItem(contentPanel, rich_att_ex)
                maxWidth = math.max(maxWidth, GUI:getContentSize(rich_att_ex).width)
                upAttrMaxWidth = math.max(upAttrMaxWidth, GUI:getContentSize(rich_att_ex).width)
            end

            if rich_att_ex and v.id and upAttrs[v.id] then
                table.insert(upAttrRichs, rich_att_ex)
            end
        end
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 添加属性提升标识
    if upAttrRichs and #upAttrRichs > 0 then
        for i, rich_att in ipairs(upAttrRichs) do
            local image = GUI:Image_Create(rich_att, "up_attr_tag_" .. i, upAttrMaxWidth + 10, 2, "res/public/btn_szjm_01_3.png")
            GUI:setAnchorPoint(image, 0, 0)
            GUI:setScale(image, 0.8)
        end
    end

    -- 特殊属性 无

    -- 宝石
    if itemData and itemData.ExtendInfo and itemData.ExtendInfo.Sockets then
        local width = ItemTips.GetGemShow(contentPanel, itemData)
        if width then
            maxWidth = math.max(maxWidth, width)
        end
    end

    -- 回收
    if itemData.huishou or itemData.honour then
        local recycleStr = ItemTips.GetRecycleStr(itemData)
        local rich_recycle = GUI:RichText_Create(contentPanel, "rich_recycle", 0, 0, recycleStr, richWidth, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
        ItemTips.PushItem(contentPanel, rich_recycle)
        maxWidth = math.max(maxWidth, GUI:getContentSize(rich_recycle).width)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 描述
    local desc = itemDescs.desc
    if desc then
        removeLastLine()
        pushDescItem(desc)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    if itemDescs and next(itemDescs) then
        pushDescItem(itemDescs)
    end

    -- 自定义属性
    if itemData.ExAbil and type(itemData.ExAbil) == "table" and next(itemData.ExAbil) then
        local rich_custom = ItemTips.GetCustomShow(contentPanel, itemData.ExAbil)
        if rich_custom then
            ItemTips.PushItem(contentPanel, rich_custom)
            maxWidth = math.max(maxWidth, GUI:getContentSize(rich_custom).width)
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
        end
    end

    --倒计时
    if itemData.AddValues then
        local timeStr = ItemTips.GetTimeStr(1, itemData.AddValues, data.diff or _lookPlayer or _isSelf, {from = data.from, itemData = itemData})
        if timeStr then
            local rich_time = GUI:RichText_Create(contentPanel, "rich_time", 0, 0, timeStr, richWidth, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
            ItemTips.PushItem(contentPanel, rich_time)
            maxWidth = math.max(maxWidth, GUI:getContentSize(rich_time).width)
        end
    end

    if ssrGlobal_ItemTipsEx then
        local widget = ssrGlobal_ItemTipsEx(itemData)
        if widget and not tolua.isnull(widget) then
            GUI:addChild(contentPanel, widget)
            ItemTips.PushItem(contentPanel, widget)
        end
    end

    -- 来源
    local extend = itemData.ExtendInfo
    if extend and extend.ItmSrc then
        local srcStr = ItemTips.GetSrcStr(extend.ItmSrc)
        if srcStr then
            removeLastLine()
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
            local rich_src = GUI:RichText_Create(contentPanel, "rich_src", 0, 0, srcStr, richWidth, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
            ItemTips.PushItem(contentPanel, rich_src)
            maxWidth = math.max(maxWidth, GUI:getContentSize(rich_src).width)
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
        end
    end

    -- 顶部描述desc(移动的)
    pushDescItem(topDesY)
    -- 底部描述
    local bottomDescs = itemDescs.bottom_desc
    if bottomDescs then
        pushDescItem(bottomDescs)
    end

    removeLastLine()

    local sz = GUI:getContentSize(contentPanel)
    local innerH = sz.height
    maxWidth = math.max(maxWidth, sz.width)

    local posY = GUI:getPositionY(contentPanel)
    GUI:setPositionY(contentPanel, innerH - posY)
    GUI:ScrollView_setInnerContainerSize(scrollView, maxWidth, innerH)
    local listH = math.min(innerH, _TipsMaxH)
    GUI:setContentSize(scrollView, maxWidth, listH)
    GUI:setPosition(scrollView, 15, 10)
    GUI:setContentSize(ListBg, maxWidth + 30, listH + 20)
    GUI:setTag(ListBg, _PanelNum)

    -- 套装属性
    local suitCalType = SL:GetMetaValue("GAME_DATA", "SuitCalType") or 0
    local suitSwitch = tonumber(suitCalType) == 1
    local IsHideSuitTips = (tonumber(SL:GetMetaValue("GAME_DATA", "hideSuitTips")) or 0) == 1
    if not IsHideSuitTips then
        if suitSwitch then -- 新套装
            local suitids = itemData.suitid
            if not ItemTips._diff and suitids and string.len(suitids) > 0 then
                local suitArry = string.split(suitids, "#")
                for k, v in pairs(suitArry) do
                    local id = v and tonumber(v)
                    if id then
                        ItemTips.GetNewSuitPanel(id, itemData)
                    end
                end
            end
        else -- 老套装
            local suitNameConfig = SL:GetMetaValue("SUIT_CONFIG", itemData.originName or itemData.Name)
            if suitNameConfig then
                table.sort(suitNameConfig, function(a, b)
                    return a.Idx < b.Idx
                end)
                for k, v in pairs(suitNameConfig) do
                    ItemTips.GetSuitPanel(v, itemData, k)
                end
            end
        end
    end

    -- 穿戴按钮
    local tipsSz = GUI:getContentSize(ListBg)
    if isWear ~= false and data and data.from == ItemFrom.BAG then
        if IsOpenSwitch(1) then
            local btn = ItemTips.AddButton(ListBg, itemData, 1)
            tipsSz = GUI:getContentSize(ListBg)
        end
    end

    -- 内观预览
    ItemTips.GetModelPanel(itemData)

    -- 调整位置
    ItemTips.RefreshItemPosition(ListBg, scrollView, tipsSz)

    -- 重置内部位置
    ItemTips.ResetEquipPosition()

    if innerH > listH then
        ItemTips.SetTipsScrollArrow(ListBg, scrollView, innerH, listH)
    end

    if ssrGlobal_ItemTipsBasePanelEx then
        local widget = ssrGlobal_ItemTipsBasePanelEx(itemData, ListBg)
        if widget and not tolua.isnull(widget) then
            GUI:addChild(ListBg, widget)
        end
        ItemTips.ResetEquipPosition()
    end

    --
    ItemTips.AddFrameEffect(ListBg, itemDescs)
end

------------  道具tips  ------------------------------------------------
function ItemTips.GetItemTips(data, itemData)
    ItemTips._isItem = true
    ItemTips.CreateItemPanel(data, itemData)
end

function ItemTips.CreateItemPanel(data, itemData)
    if not data or (not data.pos and not data.node) then
        return false
    end

    ResetDescParam()

    local width = 420
    local listMargin = SL:GetMetaValue("WINPLAYMODE") and 0 or -3
    local maxWidth = 0

    _PanelNum = _PanelNum + 1

    local ListBg = ItemTips.AddTipLayout(ItemTips._PMainUI, "ListBg" .. _PanelNum)
    GUI:setPosition(ListBg, 0, 0)
    GUI:setAnchorPoint(ListBg, 0, 0)
    GUI:setTouchEnabled(ListBg, false)

    local scrollView = GUI:ScrollView_Create(ListBg, "scrollView", 10, 10, 0, 0, 1)
    GUI:ScrollView_setClippingEnabled(scrollView, true)
    GUI:setTouchEnabled(scrollView, false)

    local contentPanel = GUI:Layout_Create(scrollView, "contentPanel", 0, 0, 47, 1)
    GUI:setAnchorPoint(contentPanel, 0, 0)
    ItemTips.contentPanel = contentPanel

    local color = (itemData.Color and itemData.Color > 0) and itemData.Color or 255
    local name = itemData.Name or ""
    -- 道具名字
    local nameStr = string.format("<font color='%s' size='%s'>%s</font>", SL:GetHexColorByStyleId(color), _TextSize, name)
    local r_name = GUI:RichText_Create(contentPanel, "r_name", 0, 0, nameStr, width, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(color), vspace, nil, fontPath)
    ItemTips.PushItem(contentPanel, r_name)

    local itemDescs = GUIFunction:GetParseItemDesc(itemData.Desc)
    -- 顶部描述
    local topDescs = itemDescs.top_desc
    if topDescs then
        if SL:GetMetaValue("WINPLAYMODE") then
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace))
        end
        pushDescItem(topDescs, 1)
    end
    ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))

    -- icon
    local isShowIcon = true
    if tonumber(SL:GetMetaValue("GAME_DATA", "itemTypeName")) == 0 then
        isShowIcon = false
    end
    local item = nil
    local size = {width = 0, height = 0}
    if isShowIcon then
        local res = SL:GetMetaValue("WINPLAYMODE") and (_PathRes .. "1900025000.png") or (_PathRes .. "1900025001.png")
        local icon_bg = GUI:Image_Create(contentPanel, "icon_bg", 0, 0, res)
        size = GUI:getContentSize(icon_bg)
        icon_bg._itemWid = size.width
        item = GUI:ItemShow_Create(icon_bg, "item_", size.width / 2, size.height / 2, {itemData = itemData, index = itemData.Index, disShowCount = true, notShowEquipRedMask = true})
        GUI:setAnchorPoint(item, 0.5, 0.5)
        ItemTips.PushItem(contentPanel, icon_bg)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    local iconMoveY = SL:GetMetaValue("WINPLAYMODE") and -6 or 0
    -- 类型
    local typeStr = ItemTips.GetTypeStr(itemData, true)
    if isShowIcon and typeStr and string.len(typeStr) > 0 then
        local rich_type = GUI:RichText_Create(GUI:ItemShow_GetLayoutExtra(item), "rich_type", size.width + 10, size.height / 2 + iconMoveY, typeStr, width, _setFontSize or _DefaultFSize, "#ffffff", vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_type, 0, 0.5)
        GUI:RefPosByParent(rich_type)
        maxWidth = math.max(maxWidth, GUI:getContentSize(rich_type).width + size.width + 20)
        local icon_bg = GUI:getChildByName(contentPanel, "icon_bg")
        icon_bg._itemWid = math.max(icon_bg._itemWid, GUI:getContentSize(rich_type).width + size.width + 20)
    end

    -- 条件限制
    local needStr = ItemTips.GetNeedStr(itemData, true)
    if isShowIcon and needStr and itemData.StdMode ~= 4 then
        local rich_need = GUI:RichText_Create(GUI:ItemShow_GetLayoutExtra(item), "rich_need", size.width + 10, iconMoveY, needStr, width,  _setFontSize or _DefaultFSize, "#ffffff", vspace, nil, fontPath) 
        GUI:setAnchorPoint(rich_need, 0, 0)
        GUI:RefPosByParent(rich_need)
        maxWidth = math.max(maxWidth, GUI:getContentSize(rich_need).width + size.width + 20)
        local icon_bg = GUI:getChildByName(contentPanel, "icon_bg")
        icon_bg._itemWid = math.max(icon_bg._itemWid, GUI:getContentSize(rich_need).width + size.width + 20)
    end

    -- 绑定
    local isAddLink = false
    if itemData.BindInfo and string.len(itemData.BindInfo) > 0 then
        local rich_bind = GUI:RichText_Create(contentPanel, "rich_bind", 0, 0, string.format("已绑定[%s]", itemData.BindInfo), width, _setFontSize or _DefaultFSize, SL:GetColorByStyleId(color), vspace, nil, fontPath)
        ItemTips.PushItem(contentPanel, rich_bind)
        isAddLink = true
    end

    if isShowIcon and itemData.Bind and string.len(itemData.Bind) > 0 and SL:GetMetaValue("ITEM_IS_BIND", itemData) then
        -- ！Pos
        local rich_bind = GUI:RichText_Create(GUI:ItemShow_GetLayoutExtra(item), "rich_bind", size.width + 10, size.height + iconMoveY, "已绑定", width, _setFontSize or _DefaultFSize, SL:GetColorByStyleId(color), vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_bind, 0, 1)
        GUI:RefPosByParent(rich_bind)
        local bindSize = GUI:getContentSize(rich_bind)
        maxWidth = math.max(maxWidth, bindSize.width + size.width + 20)
        local icon_bg = GUI:getChildByName(contentPanel, "icon_bg")
        icon_bg._itemWid = math.max(icon_bg._itemWid, bindSize.width + size.width + 20)
    end

    -- 药品
    local str = ItemTips.GetHP_MP_Str(itemData)
    if str and string.len(str) > 0 then
        local rich_hmp = GUI:RichText_Create(contentPanel, "rich_hmp", 0, 0, str, width, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath)
        ItemTips.PushItem(contentPanel, rich_hmp)
        isAddLink = true
        maxWidth = math.max(maxWidth, GUI:getContentSize(rich_hmp).width)
    end

    if isAddLink then
        isAddLink = false
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    -- 道具描述
    local itemStr = GUIFunction:GetItemAttDesc(itemData) or {}
    local attrStr = ""
    for i, line in ipairs(itemStr) do
        if next(line) then
            if i ~= 1 then
                attrStr = attrStr .. "<br>"
            end
            for k, txt in ipairs(line) do
                attrStr = attrStr .. txt .. (k ~= #line and "<br>" or "")
            end
        end
    end
    if attrStr and string.len(attrStr) > 0 then
        local rich_attr = GUI:RichText_Create(contentPanel, "rich_attr", 0, 0, attrStr, width, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath)
        GUI:setAnchorPoint(rich_attr, 0, 0)
        ItemTips.PushItem(contentPanel, rich_attr)
    else
        removeLastLine()
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace / 2, true))
    end

    -- 职业等级限制
    if itemData.StdMode == 4 then
        local richStr = ItemTips.GetLimitStr(itemData, data.from)
        if richStr then
            local rich_limit = GUI:RichText_Create(contentPanel, "rich_limit", 0, 0, richStr, width, _setFontSize or _DefaultFSize, "#FFFFFF", vspace, nil, fontPath)
            GUI:setAnchorPoint(rich_limit, 0, 0)
            ItemTips.PushItem(contentPanel, rich_limit)
        end
    end

    -- 道具说明
    local desc = itemDescs.desc
    if desc then
        pushDescItem(desc)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace / 2, true))
    end

    local desc = itemDescs
    if desc and next(desc) then
        pushDescItem(desc)
    end

    -- 聚灵珠
    if itemData.StdMode == 49 then
        local richStr = ItemTips.GetJulingCostStr(itemData)
        if richStr then
            local rich_jl = GUI:RichText_Create(contentPanel, "rich_rl", 0, 0, richStr, width, _setFontSize or _DefaultFSize, SL:GetHexColorByStyleId(69), vspace, nil, fontPath)
            GUI:setAnchorPoint(rich_jl, 0, 0)
            ItemTips.PushItem(contentPanel, rich_jl)
        end
    end

    -- 倒计时
    if itemData.AddValues then
        local timeStr = ItemTips.GetTimeStr(2, itemData.AddValues, _lookPlayer or _isSelf, {from = data.from, itemData = itemData})
        if timeStr then
            local rich_time = GUI:RichText_Create(contentPanel, "rich_time", 0, 0, timeStr, width, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
            GUI:setAnchorPoint(rich_time, 0, 0)
            ItemTips.PushItem(contentPanel, rich_time)
        end
    end

    -- 物品自定义属性 (针对201类宠物蛋)
    local showExAbil = true
    if SL:GetMetaValue("GAME_DATA", "hidePetsItemExAbil") and tonumber(SL:GetMetaValue("GAME_DATA", "hidePetsItemExAbil")) == 1 then
        showExAbil = false
    end
    if showExAbil and itemData.StdMode == 201 and itemData.ExAbil and type(itemData.ExAbil) == "table" and next(itemData.ExAbil) then
        local rich_custom = ItemTips.GetCustomShow(contentPanel, itemData.ExAbil, true)
        removeLastLine()
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
        ItemTips.PushItem(contentPanel, rich_custom)
        maxWidth = math.max(maxWidth, GUI:getContentSize(rich_custom).width)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    if ssrGlobal_ItemTipsEx then
        local widget = ssrGlobal_ItemTipsEx(itemData)
        if widget and not tolua.isnull(widget) then
            GUI:addChild(contentPanel, widget)
            ItemTips.PushItem(contentPanel, widget)
        end
    end

    -- 来源
    local exten = itemData.ExtendInfo
    if exten and exten.ItmSrc then
        local srcStr = ItemTips.GetSrcStr(exten.ItmSrc)
        if srcStr then
            removeLastLine()
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
            local rich_src = GUI:RichText_Create(contentPanel, "rich_src", 0, 0, srcStr, width, _setFontSize or _DefaultFSize, "#28EF01", vspace, nil, fontPath)
            ItemTips.PushItem(contentPanel, rich_src)
            maxWidth = math.max(maxWidth, GUI:getContentSize(rich_src).width)
            ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
        end
    end

    pushDescItem(topDesY)

    local bottomDescs = itemDescs.bottom_desc
    if bottomDescs then
        pushDescItem(bottomDescs)
        ItemTips.PushItem(contentPanel, ItemTips.CreateIntervalPanel(contentPanel, _DefaultSpace, true))
    end

    removeLastLine()

    -- 使用/拆分按钮
    if not SL:GetMetaValue("WINPLAYMODE") and data.from == ItemFrom.BAG then
        if IsOpenSwitch(3, itemData.StdMode) then
            if not (itemData.StdMode == 40 and itemData.Shape == 15) then -- 宝箱不显示使用
                ItemTips.AddButton(ListBg, itemData, 3)
            end
        end

        if IsOpenSwitch(2) and itemData.OverLap and itemData.OverLap > 1 then
            local itemConfig = SL:GetMetaValue("ITEM_DATA", itemData.Index)
            if itemConfig and itemConfig.OverLap and itemConfig.OverLap > 1 then
                ItemTips.AddButton(ListBg, itemData, 2) -- 拆分
            end
        end
    end

    local sz = GUI:getContentSize(contentPanel)
    local innerH = sz.height + 5
    local contentPanelPosY = GUI:getPositionY(contentPanel)
    GUI:setPositionY(contentPanel, innerH - contentPanelPosY)

    maxWidth = math.max(maxWidth, sz.width)
    GUI:ScrollView_setInnerContainerSize(scrollView, maxWidth, sz.height)
    local listH = math.min(innerH, _TipsMaxH)
    GUI:setContentSize(scrollView, maxWidth, listH)

    GUI:setContentSize(ListBg, maxWidth, listH)
    local tipsSz = GUI:getContentSize(ListBg)
    ItemTips.RefreshItemPosition(ListBg, scrollView, tipsSz)

    local anchorPoint, pos = ItemTips.GetTipsAnchorPoint(ListBg, data.pos, ItemTips._data.anchorPoint or {x = 0, y = 1})
    GUI:setAnchorPoint(ListBg, anchorPoint.x, anchorPoint.y)
    GUI:setPosition(ListBg, pos.x, pos.y)

    if innerH > listH then
        GUI:setTouchEnabled(scrollView, true)
        ItemTips.SetTipsScrollArrow(ListBg, scrollView, innerH, listH)
    end

    if ssrGlobal_ItemTipsBasePanelEx then
        local widget = ssrGlobal_ItemTipsBasePanelEx(itemData, ListBg)
        if widget and not tolua.isnull(widget) then
            GUI:addChild(ListBg, widget)
        end
    end

    --
    ItemTips.AddFrameEffect(ListBg, itemDescs)
end

------------    按钮    ------------------------------------------------

local _GetBtnCfg = function(btnType)
    local cfg = {
        [1] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "佩戴", 
            func        = function(data)
                SL:RequestUseItem(data)
                SL:CloseItemTips()
            end
        },
        [2] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "拆分",
            func        = function(data)
                SL:OpenItemSplitPop(data)
                SL:CloseItemTips()
            end
        },
        [3] = {
            normalPic   = "res/public/1900000679.png",
            pressPic    = "res/public/1900000679_1.png",
            btnName     = "使用",
            func        = function(data)
                SL:RequestUseItem(data)
                SL:CloseItemTips()
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

--btnType: 1： 佩戴    2：拆分    3：使用道具
function ItemTips.AddButton(parent, itemData, btnType)
    local btnCfg = _GetBtnCfg(btnType)

    local button = GUI:Button_Create(parent, "BTN_" .. btnType, 0, 0, btnCfg.normalPic)
    GUI:Button_loadTexturePressed(button, btnCfg.pressPic)
    GUI:Button_setTitleText(button, btnCfg.btnName)
    GUI:Button_setTitleFontSize(button, _setFontSize or _DefaultFSize)
    GUI:Button_setTitleColor(button, "#FFFFFF")
    GUI:Button_titleEnableOutline(button, "#111111", 1)
    GUI:setAnchorPoint(button, 0, 0)
    GUI:setScale(button, SL:GetMetaValue("WINPLAYMODE") and 0.8 or 1)
    GUI:addOnClickEvent(button, function() 
        btnCfg.func(itemData) 
    end)

    local size = GUI:getContentSize(parent)
    local minW = 200
    if size.width < minW then
        size.width = minW
        GUI:setContentSize(parent, size)
    end

    local minH = 80
    if btnType == 1 and size.height < minH then
        size.height = minH
        GUI:setContentSize(parent, size)
    end

    local btnSz = GUI:getContentSize(button)
    local posY = size.height - btnSz.height - 5
    GUI:setPosition(button, size.width - btnSz.width - 5, posY)

    if btnType == 1 then
        GUI:setPositionY(button, posY - 50)
    end

    return button
end
