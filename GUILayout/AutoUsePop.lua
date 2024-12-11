AutoUsePop = {}

local WinID = UIConst.LAYERID.AutoUsePopGUI

function AutoUsePop.main()
    local parent = GUI:GetWindow(nil, WinID)
    if not parent then
        parent = GUI:Win_Create(WinID, 0, 0, 0, 0, false, false, true, true, nil, nil, GUIDefine.UIZ.FUNC)
        GUI:LoadExport(parent, "auto_use_pop")
    end

    AutoUsePop._parent = parent

    AutoUsePop._node = GUI:getChildByName(parent, "Node")
    AutoUsePop._item = GUI:getChildByName(parent, "Item")

    AutoUsePop.InitAdapt()

    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)

    local uiLists = GUI:Win_GetParam(parent) or {}

    uiLists[data.item.MakeIndex] = true

    GUI:Win_SetParam(parent, uiLists)

    AutoUsePop.AddItem(data)
end

-- 适配
function AutoUsePop.InitAdapt()
    local posY     = 140
    local baseOffX = 350
    local screenW  = SL:GetValue("SCREEN_WIDTH")
    local screenH  = SL:GetValue("SCREEN_HEIGHT")

    if SL:GetValue("IS_PC_OPER_MODE") then
        baseOffX = 220
        posY = screenH - 330 - GUI:getContentSize(AutoUsePop._node).height
    end

    local notch, rect = SL:GetValue("NOTCH_PHONE_INFO")
    if notch then
        baseOffX = baseOffX + rect.x
    end

    GUI:setPosition(AutoUsePop._node, screenW - baseOffX, posY)
    GUI:setVisible(AutoUsePop._node, true)
end

function AutoUsePop.OnClose(makeIndex, pos, isHero)
    local uiLists = GUI:Win_GetParam(AutoUsePop._parent) or {}
    if not uiLists[makeIndex] then
        return false
    end

    uiLists[makeIndex] = nil

    GUI:Win_SetParam(AutoUsePop._parent, uiLists)

    -- 移除Item
    AutoUsePop.RemoveItem(makeIndex)

    -- 移除tips数据
    AutoUseItemData.RemoveEquipTip(pos or AutoUseItemData.GetBagPosByMakeIndex(makeIndex), isHero and GUIDefine.TitleType.HERO or GUIDefine.TitleType.PLAYER)

    if not next(uiLists) then
        GUI:Win_CloseByID(UIConst.LAYERID.AutoUsePopGUI)
    end
end

function AutoUsePop.GetItem(name)
    local item = GUI:getChildByName(AutoUsePop._node, name)
    if item then
        return item
    end
    
    item = GUI:Clone(AutoUsePop._item)
    GUI:addChild(AutoUsePop._node, item)
    GUI:setName(item, name)

    return item
end

function AutoUsePop.RemoveItem(name)
    local child = GUI:getChildByName(AutoUsePop._node, name)
    if child then
        GUI:removeFromParent(child)
        child = nil
    end
end

function AutoUsePop.AddItem(data)
    local ui = AutoUsePop.GetItem(data.item.MakeIndex)
    GUI:ui_IterChilds(ui, ui)

    local item          = data.item
    local MakeIndex     = data.item.MakeIndex
    local targetPos     = data.targetPos
    local isSkillBook   = data.isSkillBook
    local itemBelong    = SL:GetValue("ITEM_BELONG_BY_MAKEINDEX", MakeIndex)
    local isFromHeroBag = itemBelong == GUIDefine.ItemBelong.HEROBAG          -- 是否来源于英雄背包
    local isHero        = data.isHero

    local dt = {
        data            = data,
        item            = item,
        MakeIndex       = MakeIndex,
        targetPos       = targetPos,
        isSkillBook     = isSkillBook,
        isHero          = isHero,
        isFromHeroBag   = isFromHeroBag
    }

    GUI:addOnClickEvent(ui["BtnClose"], function ()
        AutoUsePop.OnClose(MakeIndex, targetPos, isHero)
    end)

    GUI:addOnClickEvent(ui["BtnUse"], function(sender)
        GUI:delayTouchEnabled(sender)
        AutoUsePop.OnExit(dt, true)
    end)

    -- 英雄
    if isHero then
        GUI:Text_setString(ui["TextTitle"], "快捷使用(英雄)")
    end

    -- 技能书
    if isSkillBook then
        GUI:Button_setTitleText(ui["BtnUse"], "使用")
    end

    -- 道具名字
    GUI:Text_setString(ui["TextName"], item.Name)

    if SL:GetValue("GAME_DATA", "AutoUseScrollWidth") then
        local scrollWidth = tonumber(SL:GetValue("GAME_DATA", "AutoUseScrollWidth")) or 140
        GUI:removeAllChildren(ui["TextName"])
        GUI:Text_setString(ui["TextName"], "")
        local label = GUI:ScrollText_Create(ui["TextName"], "scrollText", 0, 0, scrollWidth, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", item.Name)
        GUI:setAnchorPoint(label, 0.5, 0.5)
    end

    -- 道具图标
    GUI:removeAllChildren(ui["ItemNode"])
    local bgSize = GUI:getContentSize(ui["ItemBg"])
    GUI:ItemShow_Create(ui["ItemNode"], "itemShow", -bgSize.width/2, -bgSize.height/2, {look = true, index = item.Index, itemData = item})

    -- 剩余时间
    local remaining = tonumber(SL:GetValue("GAME_DATA", "autousetimes")) or 5
    -- 是否是自动穿戴, 内挂控制
    local isAutoEquip = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_AUTO_PUT_IN_EQUIP) == 1

    local setText = function (time)
        GUI:Text_setString(ui["TextTime"], string.format("(%s)", time))
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
        GUI:setVisible(ui["TextTime"], true)
        SL:schedule(ui, callback, 1)
    else
        GUI:setVisible(ui["TextTime"], false)
    end

    GUI:setVisible(ui, true)
end

function AutoUsePop.OnExit(data, usable)
    if not usable then
        return false
    end

    if data.isHero and not SL:GetValue("HERO_IS_ALIVE") then
        return AutoUsePop.OnClose(data.MakeIndex, data.targetPos, true)
    end

    if data.isSkillBook then
        AutoUsePop.DealSkillBook(data)
    elseif data.targetPos then
        AutoUsePop.DealEquip(data)
    else
        AutoUsePop.DealOther(data)
    end
end

-- 技能书
function AutoUsePop.DealSkillBook(data)
    if data.isHero and data.isFromHeroBag then
        SL:RequestUseHeroItem(data.item)
    else
        SL:RequestUseItem(data.item)
    end
    AutoUsePop.OnClose(data.MakeIndex, data.targetPos, data.isHero)
end

-- 其他
function AutoUsePop.DealOther(data)
    if data.isHero then
        SL:RequestUseHeroItem(data.item)
    else
        SL:RequestUseItem(data.item)
    end
    AutoUsePop.OnClose(data.MakeIndex, data.targetPos, data.isHero)
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
    local movingData = SL:GetValue("ITEM_MOVE_DATA")
    if movingData and MakeIndex == movingData.MakeIndex then
        SL:ItemMoveCancel()
    end
    
    local equipIntoPos = -1
    -- 是否有找到合适的位置 战力对比
    local comparison = SL:GetValue("EQUIP_COMPARISON", itemData.Index)

    -- 是否有找到合适的位置 战力对比
    local myPower, powerSortIndex = GUIFunction:GetEquipPower(itemData, {jobPower = true}, isHero)
    local param = {jobPower = true, power = myPower, comparison = comparison, powerSortIndex = powerSortIndex}
    local excludePos = GUIFunction:CheckEquipExcludePos(itemData)
    local minPowerPos, onEquipMinPower, hasEquip = GUIFunction:GetMinPowerPosByStdMode(itemData.StdMode, param, nil, isHero, excludePos)
    if minPowerPos >= 0 and (not hasEquip or onEquipMinPower < myPower) then
        equipIntoPos = minPowerPos
    end

    if equipIntoPos < 0 then
        return AutoUsePop.OnClose(MakeIndex, targetPos, isHero)
    end

    -- 超负重了
    if not GUIFunction:CheckEquipWeight(itemData, minPowerPos, isHero and GUIDefine.EquipDataType.HEROEQUIP or GUIDefine.EquipDataType.EQUIP) then
        return AutoUsePop.OnClose(MakeIndex, targetPos, isHero)
    end

    -- 穿装备
    if isHero then
        SL:RequestHeroTakeOnEquip(itemData, equipIntoPos, not isFromHeroBag)
    else
        SL:RequestPlayerTakeOnEquip(itemData, equipIntoPos, isFromHeroBag)
    end

    -- 关闭
    AutoUsePop.OnClose(MakeIndex, equipIntoPos, isHero)
end

AutoUsePop.main()
