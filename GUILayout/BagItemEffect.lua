BagItemEffect = class("BagItemEffect")

local __GD_PowerDir = SL:GetMetaValue("GAME_DATA", "itemPowerTagDir") or 0
local IsWinPlayMode = SL:GetMetaValue("WINPLAYMODE")

function BagItemEffect:ctor(parent, data)
    self._ui = GUI:ui_delegate(parent)
    self._parent = parent

    GUI:setChildrenCascadeOpacityEnabled(self._parent, true)
    GUI:setOpacity(self._parent, 255)

    self:InitData(data)
end 

function BagItemEffect:InitData(data)
    data = tonumber(data) and {index = tonumber(data)} or data
    if not data then
        return false
    end

    -- 道具数据
    self._data = data
    local itemData = data.itemData or SL:GetMetaValue("ITEM_DATA", data.index)
    self._itemData = itemData

    -- 道具来源
    if data.from then
        self._from = data.from
    end

    -- 战力比较特效
    local checkPower = data.checkPower
    if checkPower then
        self:SetItemPowerFlag()
    end

    -- 只显示特效
    local onlyShowSfx = data.onlyShowSFX
    if onlyShowSfx then
        self:SetOnlySFXShow()
    end

    -- 满了提示
    local isFullTips = not data.noLockTips
    if isFullTips then
        self:SetFullTips()
    end
end 

function BagItemEffect:SetItemPowerFlag()
    if not self._itemData then
        return false
    end

    local node_power = self._ui["Node_sfx_power"]
    if not node_power then
        return false
    end

    local sfx = GUI:getChildByName(node_power, "SFX_ANIM_5004")
    if sfx then
        GUI:removeFromParent(sfx)
        sfx = nil
    end

    -- 是否更强
    local isUp = GUIFunction:CompareEquipOnBody(self._itemData, self._from)
    if isUp then 
        local rightTop = __GD_PowerDir == 1 -- 右上
        local x = IsWinPlayMode and -12 or 0
        local y = rightTop and (IsWinPlayMode and -8 or 0) or (IsWinPlayMode and -28 or 0)
        GUI:Effect_Create(node_power, "SFX_ANIM_5004", x, y, 0, 5004)
        GUI:setVisible(node_power, true)
    end     
end 

function BagItemEffect:SetOnlySFXShow()
    GUI:setVisible(self._ui["Node_sfx_power"], false)
    GUI:setVisible(self._ui["Node_left_top"], false)
end

--聚灵珠类型-祝福罐类型满了提示
function BagItemEffect:SetFullTips()
    local imgFullTip = GUI:getChildByName(self._ui["Node_left_top"], "FULL_TIP")
    if imgFullTip then
        GUI:setVisible(imgFullTip, false)
    end

    if not self._itemData then
        return false
    end

    local stdMode = self._itemData.StdMode
    if not (stdMode == 96 or stdMode == 49) then
        return false
    end

    -- 是否满了
    local isFull = self._itemData.Dura >= self._itemData.DuraMax
    if not isFull then
        return false
    end

    if imgFullTip then
        GUI:setVisible(imgFullTip, true)
        return false
    end

    local promptData = SL:GetMetaValue("ITEM_PROMPT_DATA")
    local pic = promptData.resPath or "res/public/btn_npcfh_04.png" -- 显示资源
    local x = promptData.posX   -- 默认右上角
    local y = promptData.posY
    if IsWinPlayMode then
        x = x - 8 or -8
        y = y - 8 or -8
    else
        x = x or 0
        y = y or 0
    end
    local scale = promptData.resScale or 1
    if scale == 0 then
        scale = 1
    end

    imgFullTip = GUI:Image_Create(self._ui["Node_left_top"], "FULL_TIP", x, y, pic)
    GUI:setAnchorPoint(imgFullTip, 0.5, 0.5)
    GUI:setScale(imgFullTip, scale)
    GUI:setVisible(imgFullTip, true)
end

function BagItemEffect:UpdateItemEffect(itemData)
    if not itemData or next(itemData) == nil then
        return false
    end
    self._itemData = itemData

    self:SetFullTips()
end

return BagItemEffect