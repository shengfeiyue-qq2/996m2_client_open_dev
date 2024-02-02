BagItem = class("BagItem")

local __GD_Scale = SL:GetMetaValue("GAME_DATA", "itemSacle")
local __GD_ItemLock = SL:GetMetaValue("GAME_DATA", "ItemLock") or 1
local __GD_ShowRedMask = SL:GetMetaValue("GAME_DATA", "show_equip_mask") or 0

local ItemFrom  = SL:GetMetaValue("ITEMFROMUI_ENUM")
local ItemType  = SL:GetMetaValue("ITEMTYPE_ENUM")
local ItemScale = SL:GetMetaValue("ITEM_SCALE")
local IsWinPlayMode = SL:GetMetaValue("WINPLAYMODE")

function BagItem:ctor(parent, data)
    if not data then 
        return 
    end 
    self._ui = GUI:ui_delegate(parent)
    self._parent = parent
    self._greyStatus = nil

    self:InitBagItemUI()
    self:InitBagItemData(data)
end 

function BagItem:InitBagItemUI()
    local ui = self._ui

    -- parent
    local size = IsWinPlayMode and {width = 32, height = 32} or GUI:getContentSize(ui["Panel_bg"]) 
    GUI:setContentSize(self._parent, size)
    GUI:setAnchorPoint(self._parent, 0.5, 0.5)
    GUI:setChildrenCascadeOpacityEnabled(self._parent, true)
    GUI:setOpacity(self._parent, 255)
    GUI:setScale(self._parent, 1)

    -- node
    GUI:setPosition(ui["Node"], size.width * 0.5, size.height * 0.5)

    -- panel
    GUI:setTouchEnabled(ui["Panel_bg"], false)
    GUI:setSwallowTouches(ui["Panel_bg"], true)

    -- btn
    GUI:removeAllChildren(ui["Button_icon"])
    GUI:setVisible(ui["Button_icon"], true)
    GUI:setScale(ui["Button_icon"], 1)
    GUI:setOpacity(ui["Button_icon"], 255)
    GUI:setTouchEnabled(ui["Button_icon"], false)
    GUI:setSwallowTouches(ui["Button_icon"], true)
    GUI:setIgnoreContentAdaptWithSize(ui["Button_icon"], true)
    GUI:Button_setBrightStyle(ui["Button_icon"], 0)
    GUI:Button_setZoomScale(ui["Button_icon"], -0.1)

    -- chooseTag
    GUI:setVisible(ui["Image_choosTag"], false)

    self:SetIconGrey(false)
end 

function BagItem:InitBagItemData(data)
    -- 道具数据
    data = tonumber(data) and {index = tonumber(data)} or data
    if not data then
        return false
    end
    self._data = data

    -- 道具数据
    local itemData = data.itemData or SL:GetMetaValue("ITEM_DATA", data.index)
    self._itemData = itemData    

    -- 道具唯一id
    local index = data.index or (itemData and itemData.Index or 0)
    self._index = index

    -- 是否可查看tips
    self._looks = itemData and itemData.Looks or -1   

    -- 道具来源
    if data.from then
        self._from = data.from
    end    

    -- 道具缩放
    local scaleArray = SL:Split(__GD_Scale, "|")
    if IsWinPlayMode then
        ItemScale = tonumber(scaleArray[2]) or ItemScale
    else
        ItemScale = tonumber(scaleArray[1]) or ItemScale
    end
    self._Scale = ItemScale

    -- 显示锁
    local showLock = not data.noLockTips
    self._showLock = showLock
    if showLock then
        self:SetItemLock()
    end

    -- 是否显示红色遮罩（不满足穿戴显示红色遮罩）
    local showRedMask = not data.notShowEquipRedMask
    self._showRedMask = showRedMask
    if showRedMask then 
        self:SetEquipRedMask()
    end

    -- 检测 图片 和 特效
    self._isShowEff = data.isShowEff    -- 是否显示特效
    self._showModelEffect = data.showModelEffect    -- 是否显示Model特效
    local sEffect = self._itemData.sEffect
    local bEffect = self._itemData.bEffect
    local newEffect = tostring(self._itemData.newEffect or "")
    local showEffect = string.len(newEffect) > 0 and newEffect or (self._showModelEffect and sEffect or bEffect)
    local bShowItem = true
    local bShowEffect = false
    if showEffect and showEffect ~= "0" and showEffect ~= "" then
        local effectList, showLook = ParseModelEffect(showEffect)
        bShowItem = showLook
        if effectList and next(effectList) ~= nil then 
            bShowEffect = true
        end 
    end

    if bShowItem then 
        self:SetItemIndex(index)
    end 

    if bShowEffect then 
        self:SetItemEffect()
    end 

    GUI:setVisible(self._ui["Button_icon"], bShowItem)
    GUI:setVisible(self._ui["Node_sfx_under"], bShowEffect)
    GUI:setVisible(self._ui["Node_sfx"], bShowEffect)
end 

function BagItem:SetItemIndex()
    local function getIconResPath(looks)
        local fileIndex = looks % 10000
        local fileName = string.format("%06d", fileIndex)
        local pathIndex = math.floor(tonumber(looks) / 10000)
        local filePath = "item_" .. pathIndex .. "/" .. fileName
        return string.format("res/item/%s.png", filePath)
    end

    local path = ""
    local looks = self._looks
    if (path == "" or not SL:IsFileExist(path)) and looks and looks >= 0 then
        path = getIconResPath(looks)
    end

    if path == "" or not SL:IsFileExist(path) then
        path = "res/public/0.png"
    end

    GUI:Button_loadTextureNormal(self._ui["Button_icon"], path)
    GUI:setScale(self._ui["Button_icon"], self._Scale)
end

function BagItem:SetItemEffect()
    if not self._itemData then
        return false
    end

    local node_sfx = self._ui["Node_sfx"]
    if not node_sfx then 
        return false
    end 

    local node_sfx_under = self._ui["Node_sfx_under"]
    if not node_sfx_under then 
        return false
    end 

    GUI:removeAllChildren(node_sfx)
    GUI:removeAllChildren(node_sfx_under)

    local showEffect = self._itemData.bEffect
    local effectList, showLook = ParseModelEffect(showEffect)
    for i, v in ipairs(effectList) do
        local effectID = v.effectId
        local x = v.offX or 0
        local y = v.offY or 0

        local anim = nil
        if v.zOrder == 0 then
            anim = GUI:Effect_Create(node_sfx, i, x, y, 0, effectID)
            GUI:setVisible(node_sfx, true)
        else
            anim = GUI:Effect_Create(node_sfx_under, i, x, y, 0, effectID)
            GUI:setVisible(node_sfx_under, true)
        end

        local scale = v.scale or 1
        if scale ~= 1 then
            GUI:setScale(anim, scale)
        end
    end 
end 

function BagItem:SetIconGrey(isGrey)
    self._greyStatus = isGrey
    GUI:setGrey(self._ui["Button_icon"], isGrey)

    for _, sfx in ipairs(GUI:getChildren(self._ui["Node_sfx_under"])) do
        GUI:setGrey(sfx, isGrey)
    end

    for _, sfx in ipairs(GUI:getChildren(self._ui["Node_sfx"])) do
        GUI:setGrey(sfx, isGrey)
    end 
end

function BagItem:SetItemLock()
    -- 0:背包; 1:所有的; 其它的就是不显示
    if __GD_ItemLock ~= 0 and __GD_ItemLock ~= 1 then
        return false
    end

    if __GD_ItemLock == 0 and self._from ~= ItemFrom.BAG then
        return false
    end

    local imgLock = self._ui["Image_bindLock"]

    local isBind = SL:GetMetaValue("ITEM_IS_BIND", self._itemData)
    if not isBind then
        if imgLock then 
            GUI:setVisible(imgLock, false)
        end 
        return false
    end

    if imgLock then 
        GUI:setVisible(imgLock, true)
        GUI:setScale(imgLock, 1)
        GUI:setPosition(imgLock, 12, 12)
        if IsWinPlayMode then
            GUI:setPosition(imgLock, 16, 20)
            GUI:setScale(imgLock, 0.6)
        end
    end 

end

function BagItem:SetChooseState(bVisible)
    local img_chooseTag = self._ui["Image_choosTag"]
    local size = {width = 60, height = 60}
    if IsWinPlayMode then 
        size = {width = 40, height = 40}
    end 

    GUI:setContentSize(img_chooseTag, size.width, size.height)
    GUI:setVisible(img_chooseTag, bVisible)
end

-- 不能穿戴时红色遮罩
function BagItem:SetEquipRedMask()
    GUI:setVisible(self._ui["Image_redMask"], false)

    if tonumber(__GD_ShowRedMask) ~= 1 then
        return false
    end

    local itemData = self._itemData
    if not itemData then
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
    if notCheckFrom[from] then
        return false
    end

    if SL:GetMetaValue("ITEMTYPE", itemData) ~= ItemType.Equip then
        return false
    end

    local IsCanUse = true
    if from == ItemFrom.HERO_BAG then
        IsCanUse = SL:CheckItemUseNeed_Hero(itemData).canUse
    elseif from == ItemFrom.BAG then
        IsCanUse = SL:CheckItemUseNeed(itemData).canUse
    else
        local IsCanUse = SL:CheckItemUseNeed(itemData).canUse
        if not IsCanUse and SL:GetMetaValue("HERO_IS_ALIVE") then
            IsCanUse = SL:CheckItemUseNeed_Hero(itemData).canUse
        end
    end

    if IsCanUse then
        return false
    end

    local ui_redMask = self._ui["Image_redMask"]
    GUI:setVisible(ui_redMask, true)
    if IsWinPlayMode then
        GUI:setScale(ui_redMask, 0.7)
    end
end

function BagItem:SetOnlySFXShow()
    GUI:setVisible(self._ui["Node_sfx"], true)
    GUI:setVisible(self._ui["Node_sfx_under"], true)
    GUI:setVisible(self._ui["Button_icon"], false)
    GUI:setVisible(self._ui["Image_choosTag"], false)
    GUI:setVisible(self._ui["Image_bindLock"], false)
    GUI:setVisible(self._ui["Image_redMask"], false)
end

function BagItem:UpdateItemData(itemData)
    if not itemData or next(itemData) == nil then
        return false
    end
    self._itemData = itemData

    if self._showLock then
        self:SetItemLock()
    end

    if self._showRedMask then
        self:SetEquipRedMask()
    end
end

return BagItem