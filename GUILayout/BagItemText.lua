BagItemText = class("BagItemText")

local __GD_Style = SL:GetMetaValue("GAME_DATA", "goods_item_star_styleid") or ""
local IsWinPlayMode = SL:GetMetaValue("WINPLAYMODE")
local starOriPos = nil  -- 初始星级位置

function BagItemText:ctor(parent, data)
    self._ui = GUI:ui_delegate(parent)
    self._parent = parent

    self._data = nil
    self._itemData = nil

    GUI:setChildrenCascadeOpacityEnabled(self._parent, true)
    GUI:setOpacity(self._parent, 255)

    self:Cleanup()
    self:InitData(data)
end

function BagItemText:Cleanup()
    if not starOriPos then
        starOriPos = GUI:getPosition(self._ui["Text_star_lv"])
    end
    GUI:setPosition(self._ui["Text_star_lv"], starOriPos.x, starOriPos.y)
end

function BagItemText:InitData(data)
    data = tonumber(data) and {index = tonumber(data)} or data
    if not data then
        return false
    end

    -- 道具数据
    self._data = data
    local itemData = data.itemData or SL:GetMetaValue("ITEM_DATA", data.index)
    self._itemData = itemData

    local index = data.index or (itemData and itemData.Index or 0)
    self._index = index

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
    self._showStarlevel = true
    if type(data.starLv) == "boolean" then
        self._showStarlevel = data.starLv
    end
    if self._showStarlevel then
        self:SetStarLevel(itemData and itemData.Star)
    end

    -- 只显示特效
    local onlyShowSfx = data.onlyShowSFX
    if onlyShowSfx then
        self:SetOnlySFXShow()
    end
end 

-- 道具数量
function BagItemText:SetCount(count)
    local ui_count = self._ui["Text_count"]
    if not ui_count then 
        return false
    end 
    
    count = tonumber(count) or 0
    if count < 2 then
        GUI:setVisible(ui_count, false)
        return false
    else 
        GUI:setVisible(ui_count, true)
        GUI:Text_setString(ui_count, self:GetBagSimpleNumber(count))
    end
end

-- 装备星级
function BagItemText:SetStarLevel(star)
    local ui_starLv = self._ui["Text_star_lv"]
    if not ui_starLv then
        return false
    end

    if not (star and star > 0) then
        GUI:setVisible(ui_starLv, false)
        return false
    end

    GUI:setVisible(ui_starLv, true)
    GUI:Text_setString(ui_starLv, "+" .. star)

    local arrays = string.split(__GD_Style, "|")
    __GD_Style = IsWinPlayMode and arrays[2] or arrays[1]
    local styles = SL:Split(__GD_Style, "#")

    local colorId = tonumber(styles[1])
    local offX = tonumber(styles[2]) or 0
    local offY = tonumber(styles[3]) or 0

    if colorId then 
        GUI:Text_setTextColor(ui_starLv, SL:GetHexColorByStyleId(colorId))
        local pos = GUI:getPosition(ui_starLv)
        GUI:setPosition(ui_starLv, pos.x + offX, pos.y + offY)
    end 
end

function BagItemText:SetNeedNum(needNum, format)
    local ui_needNum = self._ui["Node_needNum"]
    if not ui_needNum then
        return false
    end

    GUI:removeAllChildren(ui_needNum)

    if needNum < 1 then
        GUI:setVisible(ui_needNum, false)
        return false
    end

    GUI:setVisible(ui_needNum, true)

    local function formatEx(num)
        if num > 99999 then
            return string.format("%s万", math.floor(num / 10000))
        end
        return num
    end

    local totalNum = tonumber(SL:GetMetaValue("MONEY", self._index)) or 0
    local totalStr = format and totalNum or formatEx(totalNum) -- 总数量
    local needStr = format and needNum or formatEx(needNum) -- 当前数量
    local str = string.format("<font color='%s'>%s</font>/%s", totalNum >= needNum and "#28ef01" or "#ff0500", totalStr, needStr)

    -- 字体大小
    local fontSize = 14
    local richText = GUI:RichText_Create(ui_needNum, "richText", 0, 0, str, 400, fontSize)
    GUI:setAnchorPoint(richText, 1, 0.5)
end

function BagItemText:SetOnlySFXShow()
    GUI:setVisible(self._ui["Text_count"], false)
    GUI:setVisible(self._ui["Node_needNum"], false)
    GUI:setVisible(self._ui["Text_star_lv"], false)
end

function BagItemText:UpdateItemText(itemData)
    if not itemData or next(itemData) == nil then
        return false
    end
    self._itemData = itemData

    if self._showCount then
        self:SetCount(itemData and itemData.OverLap or 1)
    end

    if self._showStarlevel then
        self:SetStarLevel(itemData.Star)
    end

    local needNum = self._data and self._data.needNum
    if needNum then
        self:SetNeedNum(needNum)
    end
end

-- 数字转换成万、亿单位 保留小数点后1位
function BagItemText:GetBagSimpleNumber(n, places)
    local places = places and "%." .. places .. "f" or "%.2f"
    if n >= 100000000 then
        return string.format(places .. "%s", n / 100000000, "亿")
    end
    if n >= 100000 then
        return string.format("%d%s", n / 10000, "万")
    end
    if n >= 10000 then
        return string.format(places .. "%s", n / 10000, "万")
    end
    return tostring(n)
end

return BagItemText