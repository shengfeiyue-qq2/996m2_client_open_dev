GUIDefineEx = {}

local STR_SPLIT = string.split
local STR_LEN   = string.len
local TONUMBER  = tonumber

-- 手游聊天主界面最大数量限制
GUIDefineEx.MobileMainMaxChatNum = SL:GetValue("GAME_DATA", "MobileMainMaxChatNum") or 7

-- 聊天内容间隔值
GUIDefineEx.ChatContentInterval = GUIDefineEx.ChatContentInterval or (
    function ()
        local strs = SL:GetValue("GAME_DATA", "ChatShowInterval") or ""
        if STR_LEN(strs) > 0 then
            local idx = SL:GetValue("IS_PC_OPER_MODE") and 2 or 1
            local str = STR_SPLIT(strs, "|")
            local param = str[idx] and STR_SPLIT(str[idx], "#") or {}
            return {listInterval = TONUMBER(param[1]), richVspace = TONUMBER(param[2])}
        else
            return {listInterval = nil, richVspace = 0}
        end
    end
)()

-- 获取聊天富文本默认字体
GUIDefineEx.ChatRichFontPath = GUIDefineEx.ChatRichFontPath or (
    function ()
        return SL:GetValue("CHATANDTIPS_USE_FONT") or SL:GetValue("GAME_DATA", "CHAT_FONT_PATH_MOBILE") or GUI.PATH_FONT2
    end
)()

-- 不飘字提示属性
GUIDefineEx.NoHintAtts = GUIDefineEx.NoHintAtts or (
    function ()
        local arrays = {}
        local value = SL:GetValue("GAME_DATA", "attr_not_hint") or ""
        value = value ~= "" and (value .. "#150") or (value .. "150")
        local attrArrs = STR_SPLIT(value, "#")
        for _, v in ipairs(attrArrs) do
            local attrID = TONUMBER(v)
            if attrID then
                arrays[attrID] = attrID
            end
        end
        return arrays
    end
)()

-- 经验配置
GUIDefineEx.EXPcoordinate = GUIDefineEx.EXPcoordinate or (
    function ()
        local arrays = {}
        local expArrs = STR_SPLIT(SL:GetValue("GAME_DATA", "EXPcoordinate") or "", "|")
        -- 下标： 1 移动端位置XY  2 PC端位置XY  3 颜色FColor#BColor  4 满足经验值出提示
        for i = 1, 4 do
            local XYstr = STR_SPLIT(expArrs[i] or "0#0","#")
            local X     = TONUMBER(XYstr[1]) or (i == 3 and 255 or 0)
            local Y     = TONUMBER(XYstr[2]) or 0
            if i == 4 then
                arrays[i] = X
            else
                arrays[i] = {X = X, Y = Y}
            end
        end
        return arrays
    end
)()

-- 禁止快捷键
GUIDefineEx.DisableKeys = GUIDefineEx.DisableKeys or (
    function ()
        local arrays = {}
        local valueList = STR_SPLIT(SL:GetValue("GAME_DATA", "disableKeys") or "", "#")
        for _, v in ipairs(valueList) do
            local value = TONUMBER(v)
            if value then
                arrays[#arrays + 1] = value
            end
        end
        return arrays
    end
)()

-- 是否英雄人物二合一界面
GUIDefineEx.IsMergeMode = GUIDefineEx.IsMergeMode or (
    function()
        if not SL:GetValue("IS_PC_OPER_MODE") and TONUMBER(SL:GetValue("GAME_DATA", "syshero")) == 1 and TONUMBER(SL:GetValue("GAME_DATA", "playerInfoMode")) == 1 then
            return true
        end
        return false
    end
)()

-- PC字体大小设置 -- 未配置默认12
GUIDefineEx.PCFontSize = GUIDefineEx.PCFontSize or (
    function()
        if SL:GetValue("IS_PC_OPER_MODE") then
            local valueList = STR_SPLIT(SL:GetValue("GAME_DATA", "PCFontConfig") or "", "#")
            return valueList[2] and TONUMBER(valueList[2])
        else
            return nil
        end
    end
)()

-- TIPS字号和行间距
GUIDefineEx.TipsFontSizeVspace = GUIDefineEx.TipsFontSizeVspace or (
    function()
        local param = {}
        local setData = SL:GetValue("GAME_DATA", "setTipsFontSizeVspace")
        if setData and STR_LEN(setData) > 0 then
            if not (TONUMBER(setData) == 0) then
                local setList = STR_SPLIT(setData, "|")
                if setList[1] or setList[2] then
                    local data = SL:GetValue("IS_PC_OPER_MODE") and setList[2] or setList[1]
                    if data and STR_LEN(data) > 0 then
                        local valueList = STR_SPLIT(data, "#")
                        param.fontSize = valueList[1] and TONUMBER(valueList[1])
                        param.vspace = valueList[2] and TONUMBER(valueList[2])
                    end
                end
            end
        end
        return param
    end
)()

-- TIPS属性标题配置
GUIDefineEx.TipsAttrTitle = GUIDefineEx.TipsAttrTitle or (
    function()
        local arrays = {}
        local showData = SL:GetValue("GAME_DATA", "setTipsAttrTitle")
        if showData and STR_LEN(showData) > 0 then
            local showList = STR_SPLIT(showData, "|")
            for i, str in ipairs(showList) do
                if str and STR_LEN(str) > 0 then
                    arrays[i] = {}
                    local param = STR_SPLIT(str, "#")
                    arrays[i].name = STR_LEN(param[1] or "") > 0 and param[1]
                    arrays[i].color = param[2] and TONUMBER(param[2])
                end
            end
        end
        return arrays
    end
)()

-- TIPS道具类型名称 key: stdmode
GUIDefineEx.TipsItemTypeName = GUIDefineEx.TipsItemTypeName or (
    function()
        local arrays = {}
        local strArray = STR_SPLIT(SL:GetValue("GAME_DATA", "itemTypeName") or "", "|")
        for i, str in ipairs(strArray) do
            if str and STR_LEN(str) > 0 then
                local param = STR_SPLIT(str, "#")
                if TONUMBER(param[1]) and param[2] then
                    arrays[TONUMBER(param[1])] = param[2]
                end
            end
        end
        return arrays
    end
)()

-- TIPS强化星星样式配置
GUIDefineEx.TipsStarPattern = GUIDefineEx.TipsStarPattern or (
    function()
        local arrays = {}
        local modelStrArray = STR_SPLIT(SL:GetValue("GAME_DATA", "tips_star_custom") or "", "|")
        local modelStr = SL:GetValue("IS_PC_OPER_MODE") and (modelStrArray[2] or "") or modelStrArray[1]
        if modelStr and STR_LEN(modelStr) > 0 then
            local cfgArray = STR_SPLIT(modelStr or "", "#")
            local resType = TONUMBER(cfgArray[1])
            if resType == 1 or resType == 2 then
                local resPath = STR_SPLIT(cfgArray[2] or "", "&")
                local resKey = resType == 1 and "img" or "sfx"
                local starRes = {}
                for i, v in ipairs(resPath) do
                    if v and STR_LEN(v) > 0 then
                        local resP = v
                        if resType == 1 then
                            resP = string.format("%s.png", resP)
                        elseif resType == 2 then
                            resP = TONUMBER(resP) or 0
                        end
                        starRes[i] = {
                            [resKey] = resP
                        }
                    end
                end
                arrays.starRes = starRes
            end
            arrays.resSpace = TONUMBER(cfgArray[3])
            arrays.offY = TONUMBER(cfgArray[4])
            arrays.starWid = TONUMBER(cfgArray[5])
            arrays.starHei = TONUMBER(cfgArray[6])
        end
        return arrays
    end
)()

-- TIPS按钮显示开关配置
GUIDefineEx.TipsBtnTypeSwitch = GUIDefineEx.TipsBtnTypeSwitch or (
    function()
        local arrays = {}
        local value = SL:GetValue("GAME_DATA", "BackpackGuide")
        if value and STR_LEN(value) > 0 then
            local valueList = STR_SPLIT(value, "#")
            for i, v in ipairs(valueList) do
                if i == 3 then  -- 不显示按钮的stdmode
                    arrays[3] = arrays[3] or {}
                    local stdModes = STR_SPLIT(v or "", "|")
                    for _, stdMode in ipairs(stdModes) do
                        if stdMode and STR_LEN(stdMode) > 0 then
                            arrays[3][TONUMBER(stdMode)] = TONUMBER(stdMode)
                        end
                    end
                else
                    arrays[i] = TONUMBER(v or 1) or 1 
                end
            end 
        end
        return arrays
    end
)()

-- TIPS分类
GUIDefineEx.TipsTypeConfig = GUIDefineEx.TipsTypeConfig or (
    function()
        local file = "game_config/cfg_tips_config.lua"
        if SL:IsFileExist("scripts/" .. file) then
            local config = SL:Require(file)
            for i, data in ipairs(config) do
                local stdmodeList = {}
                if data.stdmode and STR_LEN(data.stdmode) > 0 then
                    for _, value in ipairs(STR_SPLIT(data.stdmode, "#")) do
                        if TONUMBER(value) then
                            table.insert(stdmodeList, TONUMBER(value))
                        end
                    end
                end
                if data.stdmode ~= "total" then
                    config[i].stdmode = stdmodeList
                end
            end
            return config
        end
        return {}
    end
)()

-- 物品描述配置
GUIDefineEx.ItemDescConfig = GUIDefineEx.ItemDescConfig or (
    function()
        local file = "game_config/cfg_itemdesc.lua"
        if SL:IsFileExist("scripts/" .. file) then
            local config = SL:RequireFile(file)
            return config
        end
        return {}
    end
)()

-- 自定义属性组标题
GUIDefineEx.TipsDiyAttrTypeTitle = GUIDefineEx.TipsDiyAttrTypeTitle or (
    function()
        local arrays = {}
        local showData = SL:GetValue("GAME_DATA", "TipsDiyAttrTypeTitle")
        if showData and STR_LEN(showData) > 0 then
            local showList = STR_SPLIT(showData, "|")
            for _, str in ipairs(showList) do
                if str and STR_LEN(str) > 0 then
                    local param = STR_SPLIT(str, "#")
                    local type = TONUMBER(param[1])
                    if type then
                        arrays[type] = {}
                        arrays[type].name = STR_LEN(param[2] or "") > 0 and param[2] or nil
                        arrays[type].color = param[3] and TONUMBER(param[3])
                    end
                end
            end
        end
        return arrays
    end
)()

-- 自定义镶嵌组标题
GUIDefineEx.TipsTNCellGroupTitle = GUIDefineEx.TipsTNCellGroupTitle or (
    function()
        local arrays = {}
        local value = SL:GetValue("GAME_DATA", "TipsTNCellGroupTitle")
        if value and STR_LEN(value) > 0 then
            local valueList = STR_SPLIT(value, "|")
            for _, v in ipairs(valueList) do
                if v and STR_LEN(v) > 0 then
                    local param = STR_SPLIT(v, "#")
                    local indexs = {}
                    local groupId = param[2] and TONUMBER(param[2])
                    for _, idx in ipairs(STR_SPLIT(param[1], ",")) do
                        if TONUMBER(idx) then
                            table.insert(indexs, TONUMBER(idx))
                        end
                    end
                    if groupId and next(indexs) then
                        arrays[groupId] = {}
                        arrays[groupId].name = STR_LEN(param[3] or "") > 0 and param[3] or nil
                        arrays[groupId].color = param[4] and TONUMBER(param[4])
                        arrays[groupId].indexs = indexs
                    end
                end
            end
        end
        return arrays
    end
)()

-- 自定义刀魂配置显示
GUIDefineEx.TipsSwordOfSoulTitle = GUIDefineEx.TipsSwordOfSoulTitle or (
    function()
        local arrays = {}
        local value = SL:GetValue("GAME_DATA", "TipsSwordOfSoulTitle")
        if value and STR_LEN(value) > 0 then
            local valueList = STR_SPLIT(value, "|")
            for _, v in ipairs(valueList) do
                if v and STR_LEN(v) > 0 then
                    local param = STR_SPLIT(v, "#")
                    local index = TONUMBER(param[1])
                    if index then
                        arrays[index] = {}
                        arrays[index].name = STR_LEN(param[2] or "") > 0 and param[2]   -- 刀魂名 支持变量
                        arrays[index].value = param[3]
                        arrays[index].showWay = TONUMBER(param[4]) or 0
                        arrays[index].color = param[5] and TONUMBER(param[5]) or param[5]
                        arrays[index].switch = TONUMBER(param[6]) or param[6]           -- 开关： 0显示 1关闭  支持变量
                        arrays[index].loop = TONUMBER(param[7]) or param[7]             -- 图片是否循环播放： 0否 1循环 支持变量
                        arrays[index].maxValue = TONUMBER(param[8]) or param[8]         -- 最大值 支持变量
                    end
                end
            end
        end
        return arrays
    end
)()

-- 配置不可挖怪物类型
GUIDefineEx.NoDigMonsterTypeMap = GUIDefineEx.NoDigMonsterTypeMap or (
    function()
        local arrays = {}
        local value = SL:GetValue("GAME_DATA", "noDigMonsters")
        if value and STR_LEN(value) > 0 then
            local valueList = STR_SPLIT(value, "#")
            for _, typeIndex in ipairs(valueList) do
                if TONUMBER(typeIndex) then
                    arrays[TONUMBER(typeIndex)] = true
                end
            end
        end
        return arrays
    end
)()

-- 屏幕掉落提示参数配置 (Notice)
GUIDefineEx.ShowDropNoticeParam = GUIDefineEx.ShowDropNoticeParam or (
    function()
        local arrays        = {}
        local paramList     = SL:GetValue("GAME_DATA","ShowDropNotice") and STR_SPLIT(SL:GetValue("GAME_DATA","ShowDropNotice"), "|")
        local setList       = paramList and STR_LEN(paramList[1]) > 0 and STR_SPLIT(paramList[1], "#") or {}
        arrays.x            = setList[1] and TONUMBER(setList[1]) or 0
        arrays.y            = setList[2] and TONUMBER(setList[2]) or 0 
        arrays.interval     = setList[3] and TONUMBER(setList[3]) or 0
        arrays.setFontSize  = setList[4] and TONUMBER(setList[4])
        arrays.maxCount     = setList[5] and TONUMBER(setList[5]) or 4
        arrays.delayTime    = setList[6] and TONUMBER(setList[6]) or 2
        arrays.opacity      = setList[7] and TONUMBER(setList[7]) or 0

        return arrays
    end
)()

