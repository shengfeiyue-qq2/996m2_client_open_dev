AutoUsePop = {}

function AutoUsePop.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "auto/auto_use_pop")

    AutoUsePop._ui = GUI:ui_delegate(parent)
    if not AutoUsePop._ui then
        return false
    end

    local PMainUI = AutoUsePop._ui["PPopUI"]
    if SL:IsWinMode() then
        GUI:Win_SetDrag(parent, PMainUI)
        GUI:setMouseEnabled(PMainUI, true)
    end
end

function AutoUsePop.DelItem(tag)
    local child = GUI:getChildByTag(AutoUsePop._ui["Node"], tag)
    if child then
        GUI:removeFromParent(child)
        child = nil
    end
end

function AutoUsePop.GetPopView(tag)
    local popView = GUI:getChildByTag(AutoUsePop._ui["Node"], tag)
    if popView then
        return popView
    end
    
    popView = GUI:Clone(AutoUsePop._ui["PPopUI"])
    GUI:addChild(AutoUsePop._ui["Node"], popView)
    GUI:setTag(popView, tag)

    return popView
end

function AutoUsePop.AddItem(data)
    local popView = AutoUsePop.GetPopView(data.id)
    GUI:ui_IterChilds(popView, popView)

    local item          = data.item
    local MakeIndex     = data.item.MakeIndex
    local targetPos     = data.targetPos
    local skillBook     = data.skillBook
    local isHero        = data.isHero
    -- 是否来源于英雄背包
    local isFromHeroBag = SL:GetMetaValue("IS_IN_HEROBAG", MakeIndex)

    local dt = {
        data            = data,
        item            = item,
        MakeIndex       = MakeIndex,
        targetPos       = targetPos,
        skillBook       = skillBook,
        isHero          = isHero,
        isFromHeroBag   = isFromHeroBag
    }

    GUI:addOnClickEvent(popView["BtnClose"], function ()
        SL:CloseAutoUsePop({id = MakeIndex, pos = targetPos, isHero = isHero})
    end)

    GUI:addOnClickEvent(popView["BtnUse"], function ()
        AutoUsePop.OnExit(dt, true)
    end)

    if isHero then
        GUI:Text_setString(popView["TextTitle"], "快捷使用(英雄)")
    end

    if skillBook then
        GUI:Button_setTitleText(popView["BtnUse"], "使用")
    end

    -- 道具名字
    local showName = SL:GetItemShowNameByData(item)
    GUI:Text_setString(popView["TextName"], showName)

    if SL:GetMetaValue("GAME_DATA", "AutoUseScrollWidth") then
        local scrollWidth = tonumber(SL:GetMetaValue("GAME_DATA", "AutoUseScrollWidth")) or 140
        GUI:removeAllChildren(popView["TextName"])
        GUI:Text_setString(popView["TextName"], "")
        local label = GUI:ScrollText_Create(popView["TextName"], "scrollText", 0, 0, scrollWidth, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", showName)
        GUI:setAnchorPoint(label, 0.5, 0.5)
    end

    GUI:removeAllChildren(popView["ItemNode"])
    local bgSize = GUI:getContentSize(popView["ItemBg"])
    local itemShow = GUI:ItemShow_Create(popView["ItemNode"], "itemShow", -bgSize.width/2, -bgSize.height/2, {look = true, index = item.Index, itemData = item})

    -- 剩余时间
    local remaining = tonumber(SL:GetMetaValue("GAME_DATA", "autousetimes")) or 5
    -- 是否是自动穿戴, 内挂控制
    local isAutoEquip = SL:CheckSet(62) == 1

    local setText = function (time)
        GUI:Text_setString(popView["TextTime"], string.format("(%s)", time))
    end

    setText(remaining)

    local function callback()
        remaining = remaining - 1
        remaining = math.max(remaining, 0)
        setText(remaining)

        if remaining == 0 then
            AutoUsePop.OnExit(dt, isAutoEquip)
        end
    end

    if isAutoEquip then
        GUI:setVisible(popView["TextTime"], true)
        SL:schedule(popView, callback, 1)
    else
        GUI:setVisible(popView["TextTime"], false)
    end

    GUI:setVisible(popView, true)
end

function AutoUsePop.OnExit(data, usable)
    if not usable then
        return false
    end

    if data.isHero and not SL:GetMetaValue("CALLHERO") then
        return SL:CloseAutoUsePop({id = data.MakeIndex, pos = data.targetPos, isHero = true})
    end

    if data.skillBook then
        AutoUsePop.DealSkillBook(data)
    elseif data.targetPos then
        AutoUsePop.DealEquip(data)
    else
        AutoUsePop.DealOther(data)
    end
end

-- 技能书
function AutoUsePop.DealSkillBook(data)
    if data.isHero and data.isFromHero then
        SL:HeroUseItem(data.item)
    else
        SL:UseItem(data.item)
    end
    SL:CloseAutoUsePop({id = data.MakeIndex, pos = data.targetPos, isHero = data.isHero})
end

-- 其他
function AutoUsePop.DealOther(data)
    if data.isHero then
        SL:HeroUseItem(data.item, true)
    else
        SL:UseItem(data.item, true)
    end
    SL:CloseAutoUsePop({id = data.MakeIndex, pos = data.targetPos, isHero = data.isHero})
end

-- 装备
function AutoUsePop.DealEquip(data)
    local isHero    = data.isHero
    local itemData  = data.item
    local MakeIndex = data.MakeIndex
    local targetPos = data.targetPos
    local isFromHeroBag = data.isFromHeroBag

    local checkData = isHero and SL:CheckItemUseNeed_Hero(itemData) or SL:CheckItemUseNeed(itemData)
    if not checkData or not checkData.canUse then
        return false
    end

    -- 道具在移动中停止
    local movingData = SL:GetMetaValue("ITEM_MOVING_DATA")
    if movingData and MakeIndex == movingData.MakeIndex then
        SL:SetItemMoveCancel()
    end

    -- 比较身上装备
    local bCompare = GUIShare.CompareEquipOnBody(itemData)
    if not bCompare then 
        return false
    end

    -- 因为穿戴有延时，在结束时重新选择最优位置
    
    local equipIntoPos = -1
    -- 是否有找到合适的位置 战力对比
    local comparison = SL:GetMetaValue("EQUIP_COMPARISON", itemData.Index)

    -- 是否有找到合适的位置 战力对比
    local myPower, powerSortIndex = SL:GetMetaValue("EQUIP_POWER", itemData, {jobPower = true}, isHero)

    local minPowerPos, onEquipMinPower, hasEquip = GUIShare.GetMinPowerPosByStdMode(itemData.StdMode, {jobPower = true, contrastV = myPower, comparisonV = comparison, powerSortIndex = powerSortIndex}, isHero)
    if minPowerPos >= 0 and (not hasEquip or onEquipMinPower < myPower) then
        equipIntoPos = minPowerPos
    end

    if equipIntoPos < 0 then
        return SL:CloseAutoUsePop({id = MakeIndex, pos = targetPos, isHero = isHero})
    end

    -- 超负重了
    if not GUIShare.CheckEquipWeight(itemData, minPowerPos, isHero) then
        return SL:CloseAutoUsePop({id = MakeIndex, pos = targetPos, isHero = isHero})
    end

    -- 传装备
    SL:RequestTakeOn({itemData = itemData, pos = equipIntoPos}, isHero, isFromHeroBag)

    -- 关闭
    SL:CloseAutoUsePop({id = MakeIndex, pos = equipIntoPos, isHero = isHero})
end