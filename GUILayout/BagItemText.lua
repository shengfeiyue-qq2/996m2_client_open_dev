BagItemText = class("BagItemText")

local __GD_Style = SL:GetMetaValue("GAME_DATA", "goods_item_star_styleid") or ""
local IsWinPlayMode = SL:GetMetaValue("WINPLAYMODE")

function BagItemText:ctor(parent, data)
    self._ui = GUI:ui_delegate(parent)
    self._parent = parent

    self._data = nil
    self._itemData = nil

    GUI:setOpacity(self._parent, 255)
    GUI:setCascadeOpacityEnabled(self._parent, true)

    self:InitData(data)
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
            self:SetCount(data.count, data.countFontSize)
        elseif data.itemData then
            self:SetCount(data.itemData.OverLap or 1, data.countFontSize)
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
function BagItemText:SetCount(count, fontSize)
    local ui_count = self._ui["Node_count"]
    if not ui_count then 
        return false
    end 
    
    count = tonumber(count) or 0
    if count < 2 then
        GUI:setVisible(ui_count, false)
        return false
    else 
        GUI:setVisible(ui_count, true)
        GUI:removeAllChildren(ui_count)

        local bm_count = GUI:Text_Create(ui_count, "bm_count", 0, 0, IsWinPlayMode and 13 or 15, "#ffffff", self:GetBagSimpleNumber(count))
        GUI:Text_enableOutline(bm_count, "#000000", 2)
        GUI:setAnchorPoint(bm_count, 1, 0)

        local posX = IsWinPlayMode and 18 or 28
        local posY = IsWinPlayMode and -18 or -30
        GUI:setPosition(bm_count, posX, posY)

        -- 数量字体大小
        -- if fontSize then 
        --     GUI:Text_setFontSize(bm_count, fontSize)
        -- end 
    end
end

-- 装备星级
function BagItemText:SetStarLevel(star)
    local ui_starLv = self._ui["Node_star_lv"]
    if not ui_starLv then
        return false
    end

    if not (star and star > 0) then
        GUI:setVisible(ui_starLv, false)
        return false
    end

    GUI:setVisible(ui_starLv, true)
    GUI:removeAllChildren(ui_starLv)

    local arrays = string.split(__GD_Style, "|")
    __GD_Style = IsWinPlayMode and arrays[2] or arrays[1]

    local styles = SL:Split(__GD_Style, "#")
    local id = tonumber(styles[1])
    local color = SL:GetHexColorByStyleId(id)
    if color == "#ffffff" then 
        color = "#EFAD21"
    end 
    local offX = tonumber(styles[2]) or 0
    local offY = tonumber(styles[3]) or 0

    local posX = IsWinPlayMode and -20 or -28
    local posY = IsWinPlayMode and 20 or 30

    local bm_starLv = GUI:Text_Create(ui_starLv, "bm_starLv", posX + offX, posY + offY, IsWinPlayMode and 13 or 15, color, "+" .. star)
    GUI:Text_enableOutline(bm_starLv, "#000000", 1)
    GUI:setAnchorPoint(bm_starLv, 0, 1)
end

function BagItemText:SetNeedNum(needNum, format)
    local ui_needNum = self._ui["Node_needNum"]
    if not ui_needNum then
        return false
    end

    if needNum < 1 then
        GUI:setVisible(ui_needNum, false)
        return false
    end

    GUI:removeAllChildren(ui_needNum)
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

    -- 坐标
    local posX = IsWinPlayMode and 18 or 30
    local posY = IsWinPlayMode and -12 or -22

    -- 字体大小
    local fontSize = IsWinPlayMode and 13 or 15

    local richText = GUI:RichText_Create(ui_needNum, "richText", posX, posY, str, 400, fontSize)
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
function BagItemText:GetBagSimpleNumber(n)
    if n >= 100000000 then
        return string.format("%.1f%s", n / 100000000, "亿")
    end
    if n >= 100000 then
        return string.format("%d%s", n / 10000, "万")
    end
    if n >= 10000 then
        return string.format("%.1f%s", n / 10000, "万")
    end
    return tostring(n)
end

return BagItemText