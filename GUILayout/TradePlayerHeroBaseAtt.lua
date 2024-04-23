TradePlayerHeroBaseAtt = {}

function TradePlayerHeroBaseAtt.main()
    local parent  = GUI:Attach_Parent()
    local attachW = 348
    local attachH = 478
    TradePlayerHeroBaseAtt.attachW = attachW

    local _ResPath = "res/private/player_main_layer_ui/player_main_layer_ui_mobile/"
    TradePlayerHeroBaseAtt.ResPath = _ResPath

    local BaseAttrUI = GUI:Layout_Create(parent, "BaseAttrUI", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(BaseAttrUI, true)

    local BG = GUI:Image_Create(BaseAttrUI, "BG", 0, 0,  _ResPath.."bg_juese_02.png")

    local ListView = GUI:ListView_Create(BaseAttrUI, "ListView", 5, 5, attachW - 10, attachH - 10, 1)
    TradePlayerHeroBaseAtt.ListView = ListView

    TradePlayerHeroBaseAtt.RefreshAttr(true)
end

function TradePlayerHeroBaseAtt.RefreshAttr(isJump)
    local data = SL:GetHeroData()
    local List = TradePlayerHeroBaseAtt.ListView

    -- 职业
    local jobName = SL:GetMetaValue("T.H.JOB")
    local item_1 = GUI:getChildByName(List, "item_1")
    if not item_1 then
        item_1 = GUI:Layout_Create(List, "item_1", 0, 0, TradePlayerHeroBaseAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_1, "num_bg", 175, 15, TradePlayerHeroBaseAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_1, "TextName", 26, 15, 16, "#FFFFFF", "职　　业")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_1, "TextVal", 180, 15, 16, "#FFFFFF", jobName)
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_1, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, jobName)
        end
    end

    -- 等级
    local level = SL:GetMetaValue("T.H.LEVEL")
    local item_2 = GUI:getChildByName(List, "item_2")
    if not item_2 then
        item_2 = GUI:Layout_Create(List, "item_2", 0, 0, TradePlayerHeroBaseAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_2, "num_bg", 175, 15, TradePlayerHeroBaseAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_2, "TextName", 26, 15, 16, "#FFFFFF", "等　　级")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_2, "TextVal", 180, 15, 16, "#FFFFFF", level)
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_2, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, level)
        end
    end

    -- 当前经验
    local maxExp = SL:GetMetaValue("T.M.EXP")
    local item_3 = GUI:getChildByName(List, "item_3")
    if not item_3 then
        item_3 = GUI:Layout_Create(List, "item_3", 0, 0, TradePlayerHeroBaseAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_3, "num_bg", 175, 15, TradePlayerHeroBaseAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_3, "TextName", 26, 15, 16, "#FFFFFF", "当前经验")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_3, "TextVal", 180, 15, 16, "#FFFFFF", curExp)
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_3, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, curExp)
        end
    end

    -- 升级经验
    local maxExp = SL:GetMetaValue("T.M.MAXEXP")
    local item_4 = GUI:getChildByName(List, "item_4")
    if not item_4 then
        item_4 = GUI:Layout_Create(List, "item_4", 0, 0, TradePlayerHeroBaseAtt.attachW  - 10, 30, true)
        local num_bg = GUI:Image_Create(item_4, "num_bg", 175, 15, TradePlayerHeroBaseAtt.ResPath.."1900015004.png")
        GUI:setContentSize(num_bg, {width = 110, height = 26})
        GUI:Image_setScale9Slice(num_bg, 30, 30, 6, 6)
        GUI:setAnchorPoint(num_bg, 0, 0.5)
        local TextName = GUI:Text_Create(item_4, "TextName", 26, 15, 16, "#FFFFFF", "升级经验")
        GUI:setAnchorPoint(TextName, 0, 0.5)
        local TextVal = GUI:Text_Create(item_4, "TextVal", 180, 15, 16, "#FFFFFF", maxExp)
        GUI:setAnchorPoint(TextVal, 0, 0.5)
    else
        local TextVal = GUI:getChildByName(item_4, "TextVal")
        if TextVal then
            GUI:Text_setString(TextVal, maxExp)
        end
    end

    if isJump then
        GUI:ListView_jumpToItem(List, 1)
    end
end
