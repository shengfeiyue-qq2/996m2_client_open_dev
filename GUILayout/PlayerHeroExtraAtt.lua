PlayerHeroExtraAtt = {}

function PlayerHeroExtraAtt.main()
    local parent  = GUI:Attach_Parent()
    local attachW = 348
    local attachH = 478
    PlayerHeroExtraAtt.attachW = attachW

    local _ResPath = "res/private/player_main_layer_ui/player_main_layer_ui_mobile/"
    PlayerHeroExtraAtt.ResPath = _ResPath

    local ExtraAttrUI = GUI:Layout_Create(parent, "ExtraAttrUI", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(ExtraAttrUI, true)

    local BG = GUI:Image_Create(ExtraAttrUI, "BG", 0, 0,  _ResPath.."bg_juese_02.png")

    -- ListView
    local ListView = GUI:ListView_Create(ExtraAttrUI, "ListView", 5, 5, attachW - 10, attachH - 10, 1)
    PlayerHeroExtraAtt.ListView = ListView
    PlayerHeroExtraAtt.RefreshAttr(true)
    
    SL:RegisterLUAEvent(LUA_EVENT_REFBASEATTR, "HeroExtraAttr", PlayerHeroExtraAtt.RefreshAttr)
end

function PlayerHeroExtraAtt.RefreshAttr(isJump)
    local data = SL:GetHeroData()
    local List = PlayerHeroExtraAtt.ListView
    if not List then
        return false
    end

    -- 生命值
    local curHP = data.curHP
    local maxHP = data.maxHP
    local item_1 = GUI:getChildByName(List, "item_1")
    if not item_1 then
        item_1 = GUI:Layout_Create(List, "item_1", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_1, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_1, "TextName", 26, 15, 16, "#FFFFFF", "生 命 值")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_1, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s/%s", curHP, maxHP))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_1, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s/%s", curHP, maxHP))
        end
    end

    -- 魔法值
    local curMP = data.curMP
    local maxMP = data.maxMP
    local item_2 = GUI:getChildByName(List, "item_2")
    if not item_2 then
        item_2 = GUI:Layout_Create(List, "item_2", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_2, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_2, "TextName", 26, 15, 16, "#FFFFFF", "魔 法 值")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_2, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s/%s", curMP, maxMP))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_2, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s/%s", curMP, maxMP))
        end
    end

    -- 准确
    local hit = SL:GetMetaValue("H.HIT")
    local item_3 = GUI:getChildByName(List, "item_3")
    if not item_3 then
        item_3 = GUI:Layout_Create(List, "item_3", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_3, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_3, "TextName", 26, 15, 16, "#FFFFFF", "准    确")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_3, "TextVal", 180, 15, 16, "#FFFFFF", hit)
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_3, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, hit)
        end
    end

    -- 闪避
    local spd = SL:GetMetaValue("H.M_SPEED")
    local item_4 = GUI:getChildByName(List, "item_4")
    if not item_4 then
        item_4 = GUI:Layout_Create(List, "item_4", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_4, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_4, "TextName", 26, 15, 16, "#FFFFFF", "闪    避")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_4, "TextVal", 180, 15, 16, "#FFFFFF", spd)
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_4, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, spd)
        end
    end

    -- 攻击
    local minDC = SL:GetMetaValue("H.MIN_ATK")
    local maxDC = SL:GetMetaValue("H.MAX_ATK")
    local item_5 = GUI:getChildByName(List, "item_5")
    if not item_5 then
        item_5 = GUI:Layout_Create(List, "item_5", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_5, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_5, "TextName", 26, 15, 16, "#FFFFFF", "攻    击")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_5, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minDC, maxDC))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_5, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minDC, maxDC))
        end
    end

    -- 魔法
    local minMC = SL:GetMetaValue("H.MIN_MAG")
    local maxMC = SL:GetMetaValue("H.MAX_MAG")
    local item_6 = GUI:getChildByName(List, "item_6")
    if not item_6 then
        item_6 = GUI:Layout_Create(List, "item_6", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_6, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_6, "TextName", 26, 15, 16, "#FFFFFF", "魔    法")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_6, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minMC, maxMC))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_6, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minMC, maxMC))
        end
    end

    -- 道术
    local minSC = SL:GetMetaValue("H.MIN_DAO")
    local maxSC = SL:GetMetaValue("H.MAX_DAO")
    local item_7 = GUI:getChildByName(List, "item_7")
    if not item_7 then
        item_7 = GUI:Layout_Create(List, "item_7", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_7, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_7, "TextName", 26, 15, 16, "#FFFFFF", "道    术")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_7, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minSC, maxSC))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_7, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minSC, maxSC))
        end
    end

    -- 防御
    local minAC = SL:GetMetaValue("H.MIN_DEF")
    local maxAC = SL:GetMetaValue("H.MAX_DEF")
    local item_8 = GUI:getChildByName(List, "item_8")
    if not item_8 then
        item_8 = GUI:Layout_Create(List, "item_8", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_8, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_8, "TextName", 26, 15, 16, "#FFFFFF", "防    御")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_8, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minAC, maxAC))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_8, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minAC, maxAC))
        end
    end

    -- 魔防
    local minMAC = SL:GetMetaValue("H.MIN_MDF")
    local maxMAC = SL:GetMetaValue("H.MAX_MDF")
    local item_9 = GUI:getChildByName(List, "item_9")
    if not item_9 then
        item_9 = GUI:Layout_Create(List, "item_9", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_9, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_9, "TextName", 26, 15, 16, "#FFFFFF", "魔    防")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_9, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minMAC, maxMAC))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_9, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minMAC, maxMAC))
        end
    end

    -- 背包负重
    local minBW = SL:GetMetaValue("H.BW")
    local maxBW = SL:GetMetaValue("H.MAXBW")
    local item_10 = GUI:getChildByName(List, "item_10")
    if not item_10 then
        item_10 = GUI:Layout_Create(List, "item_10", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_10, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_10, "TextName", 26, 15, 16, "#FFFFFF", "背包负重")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_10, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minBW, maxBW))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_10, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minBW, maxBW))
        end
    end

    -- 装备负重
    local minWW = SL:GetMetaValue("H.WW")
    local maxWW = SL:GetMetaValue("H.MAXWW")
    local item_11 = GUI:getChildByName(List, "item_11")
    if not item_11 then
        item_11 = GUI:Layout_Create(List, "item_11", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_11, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_11, "TextName", 26, 15, 16, "#FFFFFF", "装备负重")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_11, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minWW, maxWW))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_11, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minWW, maxWW))
        end
    end

    -- 手持负重
    local minHW = SL:GetMetaValue("H.HW")
    local maxHW = SL:GetMetaValue("H.MAXHW")
    local item_12 = GUI:getChildByName(List, "item_12")
    if not item_12 then
        item_12 = GUI:Layout_Create(List, "item_12", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_12, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_12, "TextName", 26, 15, 16, "#FFFFFF", "手持负重")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_12, "TextVal", 180, 15, 16, "#FFFFFF", string.format("%s-%s", minHW, maxHW))
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_12, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, string.format("%s-%s", minHW, maxHW))
        end
    end

    -- 掉落概率
    local dp = SL:GetMetaValue("H.DROP")
    local item_13 = GUI:getChildByName(List, "item_13")
    if not item_13 then
        item_13 = GUI:Layout_Create(List, "item_13", 0, 0, PlayerHeroExtraAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_13, "num_bg", 175, 15, PlayerHeroExtraAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_13, "TextName", 26, 15, 16, "#FFFFFF", "掉落概率")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_13, "TextVal", 180, 15, 16, "#FFFFFF", math.floor(dp/100).."%")
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_13, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, math.floor(dp/100).."%")
        end
    end

    if isJump then
        GUI:ListView_jumpToItem(List, 1)
    end
end