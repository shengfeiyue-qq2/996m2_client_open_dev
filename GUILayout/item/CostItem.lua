-- 消耗物品组件
-----------------------------------------------------------------------------------
local CostItem = class("CostItem")

local MoneyType = {
    YuanBao     = 2,
    BindYuanBao = 4,
}

local sformat = string.format

function CostItem:ctor(parent, data)

    local path = "item/cost_item.lua"
    parent:InitWidgetConfig(path) 

    local ui = GUI:ui_delegate(parent._widget)
    if not ui then
        return false
    end

    self._data = nil

    self._ui = ui
    self._parent = parent

    self._layoutBG  = self._ui.Panel_bg
    self._nodeTitle = self._layoutBG:getChildByName("Node_title")
    self._nodeIcon  = self._layoutBG:getChildByName("Node_icon")
    self._nodeCount = self._layoutBG:getChildByName("Node_count")

    GUI:setTouchEnabled(self._layoutBG, false)

    self:Update(data)
end

function CostItem:Update(data)
    self._data = data or {}

    -- default auto size
    self._data.autoSize = ((self._data.autoSize == nil) and true or self._data.autoSize)

    self:OnUpdateShow()
end

function CostItem:OnUpdateShow()
    local id = tonumber(self._data.itemId) or 1
    local count = tonumber(self._data.itemCount) or 1

    if id == 0 and count == 0 then
        return
    end
    
    local goodsData = {}
    goodsData.index = id
    goodsData.count = self._data.showItemCount
    goodsData.noMouseTips = self._data.noMouseTips
    goodsData.mouseCheckTimes = self._data.mouseCheckTimes
    GUI:removeAllChildren(self._nodeIcon)
    local goodsItem = GUI:ItemShow_Create(self._nodeIcon, "item", 0, 0, goodsData)
    GUI:setAnchorPoint(goodsItem, 0.5, 0.5)
    local scale = self._data.itemScale or 0.5
    GUI:setScale(goodsItem, scale)

    --bOneID :cost Equivalent replacement
    local bOneID = true
    if self._data and self._data.bOneID == false then
        bOneID = self._data.bOneID
    end

    local itemCount = SL:GetValue("ITEM_COUNT", id, bOneID)

    if self._data and self._data.speicalYuanBao then
        if id == MoneyType.BindYuanBao then
            itemCount = itemCount + SL:GetValue("ITEM_COUNT", MoneyType.YuanBao, false)
        end
    end

    if self._data and self._data.moreID then 
        for i, v in ipairs(self._data.moreID) do
            itemCount = SL:GetValue("ITEM_COUNT", v, bOneID)
        end
    end
    local contentStr = ""
    local colorIdEnough = "#28ef01"
    local colorIdLess = "#ff0500"
    if self._data and (self._data.cutLineData) then
        colorIdEnough = "#28ef01"
        colorIdLess = "#ff0500"
    end

    if not (self._data and self._data.unTouched) then
        -- click item tips
        GUI:setTouchEnabled(self._layoutBG, true)
        GUI:addOnClickEvent(self._layoutBG, function()
            UIOperator:OpenItemTips({typeId = id, pos = GUI:getTouchEndPosition(self._layoutBG)})
        end)
    else
        GUI:setTouchEnabled(self._layoutBG, false)
    end

    local needSimpleNum = self._data.simplenum == 1

    if self._data and self._data.limit then
        local countStr = count
        local itemCountStr = itemCount
        if self._data.lessNum then
            local pointBit = self._data.pointBit or 0 -- 保留小数点后的位数
            local placeholderFunc = function(countNum)
                local nDecimal = math.pow(10, pointBit)
                local nTemp = math.floor(countNum * nDecimal)
                local nRet = nTemp / nDecimal
                return nRet
            end
            if self._data.lessNum == 2 then
                if count >= 10000000 then
                    countStr = placeholderFunc(count / 10000) .. "万"
                    if self._data.showItemLess then
                        itemCountStr = placeholderFunc(itemCount / 10000)
                        if itemCount >= 10000000 then
                            itemCountStr = itemCountStr .. "万"
                        end
                    end
                end
            else
                if count >= 100000000 then
                    countStr = placeholderFunc(count / 100000000) .. "亿"
                    if self._data.showItemLess then
                        itemCountStr = placeholderFunc(itemCount / 100000000)
                        if itemCount >= 100000000 then
                            itemCountStr = itemCountStr .. "亿"
                        end
                    end
                elseif count >= 10000 then
                    countStr = placeholderFunc(count / 10000) .. "万"
                    if self._data.showItemLess then
                        itemCountStr = placeholderFunc(itemCount / 10000)
                        if itemCount >= 10000 then
                            itemCountStr = itemCountStr .. "万"
                        end
                    end
                end
            end
        end

        if self._data.showItemLess then
            contentStr =
                sformat(
                "<font color='%s'>%s</font>/%s",
                itemCount >= count and colorIdEnough or colorIdLess,
                itemCountStr,
                countStr
            )
        else
            contentStr =
                sformat(
                "<font color='%s'>%s</font>",
                itemCount >= count and colorIdEnough or colorIdLess,
                countStr
            )
        end
    else
        contentStr = 
            sformat(
            "<font color='%s'>%s</font>/%s",
            itemCount >= count and colorIdEnough or colorIdLess,
            needSimpleNum and SL:GetSimpleNumber(itemCount) or itemCount,
            needSimpleNum and SL:GetSimpleNumber(count) or count
        )
    end

    GUI:removeAllChildren(self._nodeCount)
    local fontSize = self._data.fontSize or SL:GetMetaValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16
    local richTextColor = "#ffffff"
    local richText = GUI:RichText_Create(self._nodeCount, "countRichText", 0, 0, contentStr, 400, fontSize, richTextColor)
    GUI:setAnchorPoint(richText, 0, 0.5)

    -- title
    GUI:removeAllChildren(self._nodeTitle)
    local title = nil
    local hasTitle = not self._data or not self._data.noTitle
    if hasTitle then
        if self._data and self._data.titlePath then
            title = GUI:Image_Create(self._nodeTitle, "titleImg", 0, 0, self._data.titlePath)
        elseif self._data and self._data.titleText then
            title = GUI:Text_Create(self._nodeTitle, "titleText", 0, 0, fontSize, self._data.titleColor or "#ffffff", self._data.titleText)
            GUI:Text_enableOutline(title, "#111111", 1)
        else
            title = GUI:Text_Create(self._nodeTitle, "titleText", 0, 0, fontSize, "#ffffff", "消耗:")
            GUI:Text_enableOutline(title, "#111111", 1)
        end
        GUI:setAnchorPoint(title, 0, 0.5)
    end
    
    -- calc contentSize、position again
    if self._data and self._data.autoSize then

        local dis = 1
        -- width
        local wid = 0
        local titleWid = title and GUI:getContentSize(title).width or 0
        local itemWid = GUI:getContentSize(goodsItem).width
        local countWid = GUI:getContentSize(richText).width
        wid = wid + titleWid + dis
        wid = wid + itemWid * scale + dis
        wid = wid + countWid
        local content = GUI:getContentSize(self._layoutBG)
        content.width = wid
        GUI:setContentSize(self._layoutBG, content.width, content.height)

        local x = 0
        GUI:setPositionX(self._nodeTitle, x)
        x = x + titleWid + (itemWid / 2) * scale + dis
        GUI:setPositionX(self._nodeIcon, x)
        x = x + (itemWid / 2) * scale + 3 + dis
        GUI:setPositionX(self._nodeCount, x)

        self._parent:setContentSize(content)

        GUI:setPosition(self._layoutBG, content.width / 2, content.height / 2)
    end

    if self._data and self._data.cutLineData then
        local lineData = self._data.cutLineData
        local cutLineSize = lineData.size or 3
        local cutLineBeginPos = lineData.beginPos or {x = -3, y = 0}
        local cutLineEndPos = lineData.endPos or {x = GUI:getContentSize(richText).width + 3, y = 0}
        local cutLineColor = lineData.color or "#FF0000"
        local cutLinePos = lineData.pos or {x = 0, y = 0}
        local cutLineOpacity = lineData.opacity or 127
        GUI:DrawLine_Create(self._nodeCount, "cutLine", cutLinePos.x, cutLinePos.y, cutLineSize, cutLineBeginPos.x, cutLineBeginPos.y, cutLineEndPos.x, cutLineEndPos.y, cutLineColor, cutLineOpacity)
    end
end

return CostItem