ThrowDamageNum = {}

-- 类型1：图片数值飘字
function ThrowDamageNum.GetShowDamageNumStr(prefix, originNum, damageID)
    prefix = prefix or ""
    return string.format("%s%s", prefix, tostring(originNum))
end

-- 类型3: 图片文本(无数值)
function ThrowDamageNum.GetShowDamageTextStr(prefix, damageID)
    prefix = string.gsub(prefix or "", "/", "") or ""
    return prefix
end

local function unitFunc(num)
    local pointBit = 2
    if pointBit == 0 then
        return math.floor(num)
    end
    local iNum, fNum = math.modf(num)
    local fDecimal = math.pow(10, tostring(pointBit))
    local newFNum = math.floor(tostring(fNum * fDecimal))
    local newINum = iNum + (newFNum / fDecimal)
    return newINum
end

-- 类型4: 图片数值飘字(显示小数单位)
function ThrowDamageNum.GetShowDamagePointStr(prefix, afterfix, originNum, damageID)
    prefix = prefix or ""
    afterfix = afterfix or ""
    originNum = tostring(originNum)
    local charLen = string.len(originNum)
    local charStr = ""
    local sampNum = ""
    local poinNum = ""
    local unit    = 1
    if charLen >= 17 then
        unit = 10000000000000000
        charStr = string.sub(afterfix, 8, 9)
        sampNum = string.sub(originNum, 1, charLen - 16)
        poinNum = string.sub(originNum, charLen - 15, charLen)
    elseif charLen >= 13 then
        unit = 1000000000000
        charStr = string.sub(afterfix, 6, 7)
        sampNum = string.sub(originNum, 1, charLen - 12)
        poinNum = string.sub(originNum, charLen - 11, charLen)
    elseif charLen >= 9 then
        unit = 100000000
        charStr = string.sub(afterfix, 4, 5)
        sampNum = string.sub(originNum, 1, charLen - 8)
        poinNum = string.sub(originNum, charLen - 7, charLen)
    elseif charLen >= 5 then
        unit = 10000
        charStr = string.sub(afterfix, 2, 3)
        sampNum = string.sub(originNum, 1, charLen - 4)
        poinNum = string.sub(originNum, charLen - 3, charLen)
    else
        sampNum = originNum
    end

    poinNum = tonumber(poinNum)
    if poinNum and poinNum > 0 then
        poinNum = unitFunc(poinNum / unit)
        if tonumber(sampNum) then
            poinNum = poinNum + tonumber(sampNum)
        end
        sampNum = ""
        poinNum = string.gsub(tostring(poinNum), "%.", string.sub(afterfix, 1, 1))
    else
        poinNum = ""
    end

    return string.format("%s%s%s%s", prefix, sampNum, poinNum, charStr)
end
