local __GD_Scale = SL:GetGameData("itemSacle")
local __GD_Style = SL:GetGameData("goods_item_star_styleid") or ""
local __GD_PowerDir = SL:GetGameData("itemPowerTagDir") or 0
local __GD_ItemLock = SL:GetGameData("ItemLock") or 1
local __GD_ShowRedMask = SL:GetGameData("show_equip_mask") or 0

local ItemFrom  = SL:GetItemForm()
local ItemType  = SL:GetItemType()
local ItemScale = SL:GetMetaValue("ITEM_SCALE")
local IsPc = SL:IsWinMode()

-- 物品框
-----------------------------------------------------------------------------------
local Item = class("Item")

function Item:ctor(parent, data)
    -- 设置item
    local path = (type(data) == "table" and data.isSmallSize) and "item/item_win32" or "item/item"
    parent:InitWidgetConfig(path) 

    local ui = GUI:ui_delegate(parent)
    if not ui then
        return false
    end

    self._data = nil

    self._ui = ui
    self._parent = parent

    self:InitUI()

    self:Cleanup()
    self:InitData(data)
end

function Item:InitUI()
    local Panel_bg = self._ui["Panel_bg"]
    local size = GUI:getContentSize(Panel_bg)

    GUI:setContentSize(self._parent, size)
    GUI:setAnchorPoint(self._parent, 0.5, 0.5)

    GUI:setPosition(self._ui["Node"], size.width * 0.5, size.height * 0.5)

    local n_size = GUI:getContentSize(self._ui["Node"])
    GUI:setPosition(Panel_bg, n_size.width / 2 * 0.5, n_size.height / 2 * 0.5)

    GUI:setIgnoreContentAdaptWithSize(self._ui["Button_icon"], true)
    GUI:Button_setZoomScale(self._ui["Button_icon"], -0.1)
end

function Item:Cleanup()
    local ui = self._ui
    if not ui then
        return false
    end

    self._greyStatus = nil

    GUI:setTouchEnabled(ui["Panel_bg"], false)
    GUI:setSwallowTouches(ui["Panel_bg"], true)

    GUI:setVisible(ui["Image_power"], false)
    GUI:setVisible(ui["Image_choosTag"], false)
    GUI:setVisible(ui["Image_bg"], false)

    GUI:removeAllChildren(ui["Node_needNum"])

    GUI:Button_setBrightStyle(ui["Button_icon"], 0)
    GUI:setScale(ui["Button_icon"], 1)
    GUI:setTouchEnabled(ui["Button_icon"], false)
    GUI:setSwallowTouches(ui["Button_icon"], true)
    GUI:Button_loadTextureNormal(ui["Button_icon"], "res/item/un_define.pvr.ccz")
    GUI:removeAllChildren(ui["Button_icon"])
    GUI:setVisible(ui["Button_icon"], true)

    local size = GUI:getContentSize(ui["Panel_bg"])
    GUI:setPosition(ui["Button_icon"], size.width * 0.5, size.height * 0.5)

    GUI:stopAllActions(ui["Panel_extra"])
    GUI:removeAllChildren(ui["Panel_extra"])

    GUI:removeAllChildren(ui["Node_sfx_under"])
    GUI:removeAllChildren(ui["Node_sfx"])
    GUI:removeAllChildren(ui["Node_sfx_power"])
    GUI:removeAllChildren(ui["Node_left_top"])
    GUI:removeAllChildren(ui["Node_lock"])

    GUI:setVisible(ui["Panel_extra"], true)
    GUI:setVisible(ui["Text_count"], true)
    GUI:setVisible(ui["Node_sfx"], true)
    GUI:setVisible(ui["Node_sfx_under"], true)
    GUI:setVisible(ui["Node_needNum"], true)
    GUI:setVisible(ui["Text_star_lv"], true)
    GUI:setVisible(ui["Node_sfx_power"], true)
    GUI:setVisible(ui["Node_left_top"], true)

    if IsPc then
        GUI:setPositionX(ui["Text_count"], size.width + 2)
        ui["Text_count"]:setFontSize(13)
    else
        GUI:setPositionX(ui["Text_count"], size.width - 3)
        ui["Text_count"]:setFontSize(15)
    end

    GUI:setOpacity(self._parent, 255)
    GUI:setScale(self._parent, 1)

    GUI:setOpacity(ui["Button_icon"], 255)
    self:SetIconGrey(false)

    self:SetCount(0)
    GUI:Text_setTextColor(ui["Text_count"], "#FFFFFF")

    self:SetStarLevel()
end

function Item:InitData(data)
    data = tonumber(data) and {index = tonumber(data)} or data
    if not data then
        return false
    end
    self._data = data

    -- 道具缩放
    local scaleArray = SL:Split(__GD_Scale, "|")
    if IsPc then
        ItemScale = tonumber(scaleArray[2]) or ItemScale
    else
        ItemScale = tonumber(scaleArray[1]) or ItemScale
    end
    self._Scale = ItemScale

    local itemData = data.itemData or SL:GetItemDataByIndex(data.index)

    self._looks = itemData and itemData.Looks or -1

    self._itemData = itemData

    -- 是否显示特效、false时不显示特效
    self._isShowEff = data.isShowEff

    -- 是否显示Model特效
    self._showModelEffect = data.showModelEffect

    -- 物品来源
    if data.from then
        self._from = data.from
    end
    
    -- 单个item缩放
    if data.scale then
        self._Scale = data.scale
    end

    -- 数量字体大小
    if data.countFontSize then
        GUI:Text_setFontSize(self._ui["Text_count"], data.countFontSize)
    end

    local index = data.index or (itemData and itemData.Index or 0)
    self._index = index
    self:SetItemIndex(index)

    -- 是否显示数量
    local showCount = not data.disShowCount
    self._showCount = showCount
    if showCount then
        if data.count then
            self:SetCount(data.count)
        elseif data.itemData then
            self:SetCount(data.itemData.OverLap or 1)
        end
    end

    -- 需要数量
    local needNum = data.needNum
    if needNum then
        self:SetNeedNum(needNum)
    end

    -- 是否显示星级(默认显示)
    local showStarlevel = data.starLv or true
    self._showStarlevel = showStarlevel
    if showStarlevel then
        self:SetStarLevel(itemData and itemData.Star)
    end

    -- 显示锁
    local showLock = not data.noLockTips
    self._showLock = showLock
    if showLock then
        self:SetItemLock()
    end

    -- 数量颜色
    local color = tonumber(data.color or -1)
    if color > -1 then
        self._ui["Text_count"]:setTextColor(SL:GetColorByStyleId(color))
    end

    -- 战力对比
    local checkPower = data.checkPower
    if checkPower then
        self:SetItemPowerFlag()
    end

    -- 设置背景框是否可见
    self:SetItemBgVisible(data.bgVisible)

    -- 满了提示
    local isFullTips = not data.noLockTips
    if isFullTips then
        self:SetFullTips()
    end

    local onlyShowSfx = data.onlyShowSFX
    if onlyShowSfx then
        self:SetOnlySFXShow()
    end

    -- 是否显示红色遮罩（不满足穿戴显示红色遮罩）
    local showRedMask = not data.notShowEquipRedMask
    self._showRedMask = showRedMask
    if showRedMask then --不满足穿戴显示红色遮罩
        self:SetEquipRedMask()
    end

    self:SetItemEffect()
end

function Item:UpdateGoodsItem(itemData)
    if not (itemData or next(itemData)) then
        return false
    end
    self._itemData = itemData

    -- count
    if self._showCount then
        self:SetCount(itemData and itemData.OverLap or 1)
    end

    local needNum = self._data and self._data.needNum
    if needNum then
        self:SetNeedNum(needNum)
    end

    if self._showStarlevel then
        self:SetStarLevel(itemData.Star)
    end

    if self._showLock then
        self:SetItemLock()
    end

    if self._showRedMask then
        self:SetEquipRedMask()
    end

    self:SetFullTips()
end

function Item:SetCount(count, format)
    local ui = self._ui
    if not ui then
        return false
    end

    if format then
        GUI:Text_setString(ui["Text_count"], count)
        return false
    end

    count = tonumber(count) or 0
    if count < 2 then
        GUI:Text_setString(ui["Text_count"], "")
        return false
    end

    GUI:Text_setString(ui["Text_count"], SL:GetSimpleNumber(count))
end

function Item:SetNeedNum(needNum, format)
    GUI:removeAllChildren(self._ui["Node_needNum"])
    if needNum < 1 then
        return false
    end

    local function formatEx(num)
        if num > 99999 then
            return string.format("%s万", math.floor(num / 10000))
        end
        return num
    end

    -- 总数量
    local totalNum = tonumber(SL:GetMetaValue("MONEY", self._index)) or 0

    local totalStr = format and totalNum or formatEx(totalNum)
    local needStr = format and needNum or formatEx(needNum)

    local str = string.format("<font color='%s'>%s</font>/%s", totalNum >= needNum and "#28ef01" or "#ff0500", totalStr, needStr)
    local richText = GUI:RichText_Create(self._ui["Node_needNum"], "richText", 0, 0, str, 400, 14)
    GUI:setAnchorPoint(richText, 1, 0.5)
end

-- 装备星级
function Item:SetStarLevel(star)
    local Text_star = self._ui["Text_star_lv"]
    if not Text_star then
        return false
    end

    if not (star and star > 0) then
        GUI:Text_setString(Text_star, "")
        return false
    end

    GUI:Text_setString(Text_star, star)

    local styles = SL:Split(__GD_Style, "#")
    local id = tonumber(styles[1])
    local offX = tonumber(styles[2]) or 0
    local offY = tonumber(styles[3]) or 0

    if id then
        SL:SetColorStyle(Text_star, id)
    end

    if not Text_star.loaded then
        Text_star.loaded = true
        local p = GUI:getPosition(Text_star)
        GUI:setPosition(Text_star, p.x + offX, p.y + offY)
    end
end

function Item:SetItemEffect()
    local ui = self._ui
    if not ui then
        return false
    end

    GUI:removeAllChildren(ui["Node_sfx_under"])
    GUI:removeAllChildren(ui["Node_sfx"])

    if not (self._itemData or self._isShowEff) then
        if self._btnIcon_delay then
            GUI:setVisible(ui["Button_icon"], true)
        end
        return false
    end

    local sEffect = self._itemData.sEffect
    local bEffect = self._itemData.bEffect
    local newEffect = tostring(self._itemData.newEffect or "")
    local showEffect = string.len(newEffect) > 0 and newEffect or (self._showModelEffect and sEffect or bEffect)

    if showEffect and showEffect ~= "0" and showEffect ~= "" then
        local effectList, showLook = ParseModelEffect(showEffect)
        for i, v in ipairs(effectList) do
            -- 添加个特效
            local effectID = v.effectId
            local x = v.offX or 0
            local y = v.offY or 0

            local anim = nil
            if v.zOrder == 0 then
                anim = GUI:Effect_Create(ui["Node_sfx"], i, x, y, 0, effectID)
            else
                anim = GUI:Effect_Create(ui["Node_sfx_under"], i, x, y, 0, effectID)
            end

            local scale = v.scale or 1
            if scale ~= 1 then
                anim:setScale(scale)
            end
        end

        if self._btnIcon_delay then
            ui["Button_icon"]:setVisible(showLook == true)
        end
    else
        if self._btnIcon_delay then
            ui["Button_icon"]:setVisible(true)
        end
    end
end

function Item:SetItemIndex(index)
    local function getIconResPath(looks)
        local fileIndex = looks % 10000
        local fileName = string.format("%06d", fileIndex)
        local pathIndex = math.floor(tonumber(looks) / 10000)
        local filePath = "item_" .. pathIndex .. "/" .. fileName

        return string.format("res/item/%s.png", filePath)
    end

    local newItemLooks = self._itemData and self._itemData.newLooks
    local path = ""
    if newItemLooks and newItemLooks > 0 then
        path = getIconResPath(newItemLooks)
    end

    local looks = self._looks
    if not SL:IsFileExist(path) and looks and looks >= 0 then
        path = getIconResPath(looks)
    end

    if SL:IsFileExist(path) then
        -- 延迟加载字段
        self._btnIcon_delay = true
    else
        path = "res/item/sun_define.pvr.ccz"
    end

    GUI:Button_loadTextureNormal(self._ui["Button_icon"], path)
    GUI:setScale(self._ui["Button_icon"], self._Scale)
    GUI:setVisible(self._ui["Button_icon"], false)
end

function Item:SetIconGrey(isGrey)
    self._greyStatus = isGrey

    for _, sfx in ipairs(self._ui["Node_sfx_under"]:getChildren()) do
        GUI:setGrey(sfx, isGrey)
    end

    for _, sfx in ipairs(self._ui["Node_sfx"]:getChildren()) do
        GUI:setGrey(sfx, isGrey)
    end

    GUI:setGrey(self._ui["Button_icon"], isGrey)
end

-- 对比
function Item:SetItemPowerFlag()
    local NodeSfxPower = self._ui["Node_sfx_power"]
    if not NodeSfxPower then
        return false
    end

    local sfx = GUI:getChildByName(NodeSfxPower, "SFX_ANIM_5004")
    if sfx then
        GUI:removeFromParent(sfx)
        sfx = nil
    end

    if not self._itemData then
        return false
    end

    -- 是否更强
    local isUp = SL:CheckEquipPowerThanSelf(self._itemData, self._from)
    if not isUp then
        GUI:setVisible(self._ui["Image_power"], false)
        return false
    end

    -- 创建更强特效
    local rightTop = __GD_PowerDir == 1 -- 右上
    local x = IsPc and 13 or 25
    local y = rightTop and (IsPc and -10 or -40) or (IsPc and -25 or 0)
    GUI:Effect_Create(NodeSfxPower, "SFX_ANIM_5004", x, y, 0, 5004)
end

function Item:SetItemBgVisible(visible)
    if visible then
        GUI:setVisible(self._ui["Image_bg"], true)
    else
        GUI:setVisible(self._ui["Image_bg"], false)
    end
end

-- 设置绑定加锁
function Item:SetItemLock()
    -- 0:背包; 1:所有的; 其它的就是不显示
    if __GD_ItemLock ~= 0 and __GD_ItemLock ~= 1 then
        return false
    end

    if __GD_ItemLock == 0 and self._from ~= ItemFrom.BAG then
        return false
    end

    local imgLock = GUI:getChildByName(self._ui["Node_lock"], "LOCK_IMAGE")

    local isBind = SL:GetMetaValue("ITEM_IS_BIND", self._itemData)
    if not isBind then
        if imgLock then
            GUI:setVisible(imgLock, false)
        end
        return false
    end

    if imgLock then
        GUI:setVisible(imgLock, true)
        return false
    end

    -- Create Lock Image
    imgLock = GUI:Image_Create(self._ui["Node_lock"], "LOCK_IMAGE", -30, -30, "res/public/lock.png")
    if IsPc then
        GUI:setScale(imgLock, 0.6)
        GUI:setPosition(imgLock, -18, -18)
    end
end

function Item:SetItemExtraLockStatus(status)
    local imgLock = GUI:getChildByName(self._ui["Node_lock"], "LOCK_IMAGE")
    if imgLock then
        imgLock:setVisible(status)
        return status
    end

    -- Create Lock Image
    imgLock = GUI:Image_Create(self._ui["Node_lock"], "LOCK_IMAGE", -30, -30, "res/public/lock.png")
    if IsPc then
        GUI:setScale(imgLock, 0.6)
        GUI:setPosition(imgLock, -18, -18)
    end
end

--聚灵珠类型-祝福罐类型满了提示
function Item:SetFullTips()
    local imgFullTip = GUI:getChildByName(self._ui["Node_left_top"], "FULL_TIP")

    if not self._itemData then
        if imgFullTip then
            GUI:setVisible(imgFullTip, false)
        end
        return false
    end
    local itemData = self._itemData

    local stdMode = itemData.StdMode
    if not (stdMode == 96 or stdMode == 49) then
        return false
    end

    -- 是否满了
    local isFull = itemData.Dura >= itemData.DuraMax
    if not isFull then
        return false
    end

    if imgFullTip then
        GUI:setVisible(imgFullTip, true)
        return false
    end

    local imgFullTip = GUI:getChildByName(self._ui["Node_left_top"], "FULL_TIP")

    if imgFullTip then
        imgFullTip:setVisible(true)
        return false
    end

    local promptData = SL:GetMetaValue("ITEM_PROMPT_DATA")
    local pic = promptData.resPath or "res/public/btn_npcfh_04.png" -- 显示资源
    local x = promptData.posX   -- 默认右上角
    local y = promptData.posY
    if IsPc then
        x = x or 12
        y = y or 12
    else
        x = x or 22
        y = y or 22
    end
    local scale = promptData.resScale or 1
    if scale == 0 then
        scale = 1
    end

    imgFullTip = GUI:Image_Create(self._ui["Node_left_top"], "FULL_TIP", x, y, pic)
    GUI:setAnchorPoint(imgFullTip, 0.5, 0.5)
    GUI:setScale(imgFullTip, scale)
end

function Item:SetOnlySFXShow()
    GUI:setVisible(self._ui["Panel_extra"], false)
    GUI:setVisible(self._ui["Button_icon"], false)
    GUI:setVisible(self._ui["Text_count"], false)
    GUI:setVisible(self._ui["Node_sfx"], true)
    GUI:setVisible(self._ui["Image_power"], false)
    GUI:setVisible(self._ui["Node_sfx_under"], true)
    GUI:setVisible(self._ui["Image_bg"], false)
    GUI:setVisible(self._ui["Node_needNum"], false)
    GUI:setVisible(self._ui["Image_choosTag"], false)
    GUI:setVisible(self._ui["Text_star_lv"], false)
    GUI:setVisible(self._ui["Node_sfx_power"], false)
    GUI:setVisible(self._ui["Node_left_top"], false)
end

-- 不能穿戴时红色遮罩
function Item:SetEquipRedMask()
    if tonumber(__GD_ShowRedMask) ~= 1 then
        return false
    end

    if not self._from then
        return false
    end
    local from = self._from

    local notCheckFrom = {
        [ItemFrom.HERO_BEST_RINGS] = true,
        [ItemFrom.PALYER_EQUIP] = true,
        [ItemFrom.HERO_EQUIP] = true,
        [ItemFrom.BEST_RINGS] = true
    }
    if not from or notCheckFrom[from] then
        return false
    end

    local isRemove = true
    local imgRedMask = GUI:getChildByName(self._ui["Node_lock"], "RED_MASK")
    if imgRedMask then
        imgRedMask:setVisible(false)
    end

    local itemData = self._itemData
    if not itemData then
        return false
    end

    if SL:GetItemTypeByData(itemData) ~= ItemType.Equip then
        return false
    end

    local IsCanUse = true
    if from == ItemFrom.HERO_BAG then
        IsCanUse = SL:CheckItemUseNeed_Hero(itemData)
    elseif from == ItemFrom.BAG then
        IsCanUse = SL:CheckItemUseNeed(itemData)
    else
        local IsCanUse = SL:CheckItemUseNeed(itemData)
        if not IsCanUse and SL:GetMetaValue("CALLHERO") then
            IsCanUse = SL:CheckItemUseNeed_Hero(itemData)
        end
    end

    if IsCanUse then
        return false
    end

    if imgRedMask then
        GUI:setVisible(imgRedMask, true)
        return false
    end

    imgRedMask = GUI:Image_Create(self._ui["Node_lock"], "RED_MASK", 0, 0, "res/public/icon_zhezhao_02025.png")
    GUI:setAnchorPoint(imgRedMask, 0.5, 0.5)
    if IsPc then
        GUI:setScale(imgRedMask, 0.6)
    end
end

-- 道具框是否吞噬触摸
function Item:SetItemTouchSwallow(isSwallowTouch)
    GUI:setSwallowTouches(self._ui["Panel_bg"], isSwallowTouch)
end

-- 道具框缩放
function Item:SetScale(scale)
    GUI:setScale(self._ui["Button_icon"], scale)
end

return Item