ActorHud = {}
local sformat      = string.format
local sLen         = string.len
ActorHud._isWin32 = SL:GetValue("IS_PC_OPER_MODE")

function ActorHud.main()
    ActorHud.InitConfig()
    --骑马偏移
    ActorHud._horseOffset = {} 
end

-- 全局配置
function ActorHud.InitConfig()
    local fontSizeMob = SL:GetValue("GAME_DATA","sceneFontSize") or SL:GetValue("GAME_DATA","SCENE_FONT_SIZE")
    local fontSizeWin = SL:GetValue("GAME_DATA","sceneFontSize_pc") or SL:GetValue("GAME_DATA","SCENE_FONT_SIZE_PC")
    local fontSize = ActorHud._isWin32 and fontSizeWin or fontSizeMob
    --BATCH_LABEL
    ActorHud._fontPath = GUI.PATH_FONT2 --字体文件
    ActorHud._batchLabelFontSize = fontSize --字体大小
    ActorHud._batchLabelOutlineSize = 1 --字体描边大小
    
    --使用bmp字体
    ActorHud._useBmpFont = false
    if ActorHud._isWin32 then
        ActorHud._useBmpFont = SL:GetValue("GAME_DATA", "HudNotUseBmpFont") ~= 1
    else
        ActorHud._useBmpFont = SL:GetValue("GAME_DATA", "MobileHudUseBmpFont") == 1
    end
    if ActorHud._useBmpFont then 
        ActorHud._fontPath = GUI.PATH_BMP_FONT
    end

    --顶戴 根据称号往上移
    ActorHud._isAutoTopHatSetPosY = tonumber(SL:GetValue("GAME_DATA", "auto_set_topHat_posY")) == 1
    --顶戴图片用的路径格格式
    ActorHud._topHatImagePathFormat = "res/Topwear/%s.png"
    
end
--[[
    整体结构：
        图片称号
        封号
        血量文本
        血条
        ------------ 分割
        前缀文本
        行会信息
        角色名
]]
-----------------------------------------------
-- 血量相关
-------------------------------------------------------
ActorHud._hudSpriteFrameNameFormat = "actor_hud_%04d.png"
ActorHud.HUD = {
    HP_BG_SPRITE_ID             = 9990,         -- 血条背景资源ID
	HP_SPRITE_ID                = 9991,         -- 血条资源ID
	HP_MAIN_SPRITE_ID           = 9994,         -- 血条资源ID  主玩家高亮
	MP_SPRITE_ID                = 9992,         -- 蓝条资源ID
	NG_SPRITE_ID                = 9993,         -- 内功资源ID
	HUD_SPRITE_DEFAULT_ID       = 9999,         -- hud sprite 默认图片ID
}

ActorHud.HUD_OFFSET = {
    HP                  = GUI:p(-16, 50),
	HP_BG               = GUI:p(-16, 50),
	MP                  = GUI:p(-16, 50),
	MP_BG               = GUI:p(-16, 50),
	NG                  = GUI:p(-16, 47),
	NG_BG               = GUI:p(-16, 47),
    HORSE               = GUI:p(0, 15),         -- 骑马的HUD偏移
	HORSE_LABEL         = GUI:p(0, 15),         -- 骑马的HUD Label偏移
}

-- HUD {id = 资源ID, offset = HUD偏移坐标}
local shareHudParam = {}
-- HP HUD 血条
function ActorHud.GetHUDHPSpriteParam(actorID, isHudBg)
    if isHudBg then
        shareHudParam.id = ActorHud.HUD.HP_BG_SPRITE_ID
        shareHudParam.offset = ActorHud.HUD_OFFSET.HP_BG
        return shareHudParam
    end

    if SL:GetValue("GAME_DATA", "hight_main_player_hp") == 1 and SL:GetValue("ACTOR_IS_MAINPLAYER", actorID) then
        shareHudParam.id = ActorHud.HUD.HP_MAIN_SPRITE_ID
    else
        shareHudParam.id = ActorHud.HUD.HP_SPRITE_ID
    end

    shareHudParam.offset = ActorHud.HUD_OFFSET.HP
    return shareHudParam
end

-- MP HUD 蓝条
function ActorHud.GetHUDMPSpriteParam(actorID, isHudBg)
    if isHudBg then
        shareHudParam.id = ActorHud.HUD.HP_BG_SPRITE_ID
        shareHudParam.offset = ActorHud.HUD_OFFSET.MP_BG
        return shareHudParam
    end

    shareHudParam.id = ActorHud.HUD.MP_SPRITE_ID
    shareHudParam.offset = ActorHud.HUD_OFFSET.HP
    return shareHudParam
end

-- NG HUD 内功条
function ActorHud.GetHUDNGSpriteParam(actorID, isHudBg)
    if isHudBg then
        shareHudParam.id = ActorHud.HUD.HP_BG_SPRITE_ID
        shareHudParam.offset = ActorHud.HUD_OFFSET.NG_BG
        return shareHudParam
    end

    shareHudParam.id = ActorHud.HUD.NG_SPRITE_ID
    shareHudParam.offset = ActorHud.HUD_OFFSET.NG
    return shareHudParam
end

-- HP HUD 血条进度值(0 - 1)
function ActorHud.GetHUDHPBarPer(actorID)
    if not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return 0
    end

    local hpPer = SL:GetValue("ACTOR_HP", actorID) / SL:GetValue("ACTOR_MAXHP", actorID)
    if SL:GetValue("GAME_DATA", "showFewHp") == 1 and not SL:GetValue("ACTOR_HUD_FULL_HP_SHOW", actorID) then
        if not SL:GetValue("ACTOR_IS_MAINPLAYER", actorID) and not SL:GetValue("ACTOR_IS_MAINHERO", actorID) then
            hpPer = 1
        end
    end

    return hpPer
end

-- MP HUD 蓝条进度值(0 - 1)
function ActorHud.GetHUDMPBarPer(actorID)
    if not SL:GetValue("ACTOR_IS_VALID", actorID) then
        return 0
    end

    local mpPer = SL:GetValue("ACTOR_MP", actorID) / SL:GetValue("ACTOR_MAXMP", actorID)
    return mpPer
end

-- NG HUD 内力条进度值(0 - 1)
function ActorHud.GetHUDNGBarPer(actorID)
    if not SL:GetValue("ACTOR_IS_VALID", actorID) or not SL:GetValue("ACTOR_IS_PLAYER", actorID) then
        return 0
    end

    local force     = SL:GetValue("ACTOR_IFORCE", actorID)
    local maxForce  = SL:GetValue("ACTOR_MAX_IFORCE", actorID)
    local forcePer  = maxForce == 0 and 0 or (force / maxForce)
    return forcePer
end

--------------------------------------
function ActorHud.GetJobMask(job)
    local jobStr = {
        [0] = "Z",
        [1] = "F",
        [2] = "D"
    }
    -- 多职业未配置默认X
    if job >= 5 and job <= 15 then
        local jobData   = SL:GetValue("GAME_DATA", "MultipleJobSetMap")[job]
        local isOpen    = jobData and jobData.isOpen
        local str       = isOpen and jobData.hudStr or "X"
        return str
    end
    return jobStr[job] or "Z"
end
-- 刷新时触发
-- 血量 hud 信息
function ActorHud.GetHUDHPLabelInfo(actorID)
    local Hp = SL:GetValue("ACTOR_HP", actorID)
    local MaxHp = SL:GetValue("ACTOR_MAXHP", actorID) 
    local MP = 0
    local maxMP = 0
    if SL:GetValue("ACTOR_HUD_MPBAR_SHOW", actorID)  then
        MP = SL:GetValue("ACTOR_MP", actorID)
        maxMP = SL:GetValue("ACTOR_MAXMP", actorID) 
    end

    -- 显示百分比
    if SL:GetValue("MAP_SHOW_HPPER") then
        Hp    = math.ceil(((Hp+MP) / (MaxHp+maxMP)) * 100 )
        MP    = 0
        MaxHp = 100
    end
    local hpStr = ""
    repeat
        local showJobLevel = SL:GetValue("SETTING_ENABLED", SLDefine.SETTINGID.SETTING_IDX_PLAYER_JOB_LEVEL)
        local formatStr = "%s/%s"
        if SL:GetValue("MAP_FORBID_LEVEL_AND_JOB") or showJobLevel ~= 1 then
            hpStr = sformat(formatStr, SL:HPUnit(Hp + MP), SL:HPUnit(MaxHp))
            break
        end

        local isShowMonsterLv = SL:GetValue("GAME_DATA", "Monsterlevel") == 1
        local levelJob = nil
        local level = SL:GetValue("ACTOR_LEVEL", actorID)
        if SL:GetValue("ACTOR_IS_PLAYER", actorID) then
            levelJob = ActorHud.GetJobMask(SL:GetValue("ACTOR_JOB_ID", actorID)) .. level or ""
        elseif SL:GetValue("ACTOR_IS_MONSTER", actorID) then
            if isShowMonsterLv then
                levelJob = "J" .. level or ""
            end
        end

        hpStr = sformat(formatStr, SL:HPUnit(Hp + MP), SL:HPUnit(MaxHp))
        if levelJob then
            hpStr = sformat(formatStr, hpStr, levelJob)
        end
    until true
    
    local visible = SL:GetValue("ACTOR_HUD_HP_MP_SHOW", actorID)
    local offset = ActorHud._useBmpFont and GUI:p(2, 60) or GUI:p(2, 55)
    local result = {str = hpStr, visible = visible, offsetX = offset.x, offsetY = offset.y}
    return result
end

-- 仅刷新显示状态时触发 boolean
-- 血量文本
function ActorHud.GetHUDHPLabelVisible(actorID, visible)
    return visible
end
-------------------------------------------------------
--前缀文本 行会信息 角色名 相关
-------------------------------------------------------
local heightMob = (SL:GetValue("GAME_DATA","sceneFontSize") or SL:GetValue("GAME_DATA","SCENE_FONT_SIZE")) + 2
local heightWin = (SL:GetValue("GAME_DATA","sceneFontSize_pc") or SL:GetValue("GAME_DATA","SCENE_FONT_SIZE_PC")) + 2
local height = ActorHud._isWin32 and heightWin or heightMob

local LABEL_HUD_HEIGHT = 
{
    [SLDefine.HudIndex.HUD_LABEL_NAME]       = height,
    [SLDefine.HudIndex.HUD_LABEL_GUILD]      = height,
    [SLDefine.HudIndex.HUD_LABEL_HP]         = 18,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME1]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME2]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME3]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME4]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME5]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME6]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME7]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME8]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME9]  = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME10] = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME11] = height,
    [SLDefine.HudIndex.HUD_LABEL_PRE_NAME12] = height,
}
-- 刷新时触发
-- 获取前缀文本 行会信息 角色名 hud  偏移内容显示等信息
function ActorHud.GetActorHUDLabelInfo(actorID, color, guildInfo)
    local result = {title = {}, guild = {}, name = {}}
    -- 行会战、安全区内
    local isPlayer = SL:GetValue("ACTOR_IS_PLAYER", actorID) 
    local isMonster = SL:GetValue("ACTOR_IS_MONSTER", actorID) 
    local isNpc = SL:GetValue("ACTOR_IS_NPC", actorID)
    if isPlayer or isMonster then
        if SL:GetValue("ACTOR_IS_WAR_ZONE", actorID)  and SL:GetValue("ACTOR_IN_SAFE_ZONE", actorID) then
            color = 255
        end
    end
    -- 解开称号字符 分为称号列表和玩家名字
    -- 展示顺序 1.(12个)前缀文本 2.行会信息 3.角色名
    local spName = SL:GetValue("ACTOR_ORIGIN_NAME_STRING", actorID) 
    if isNpc then
        spName = string.gsub(spName, "#", "")
    end
    local nameStr = string.split(spName, "\\")
    local showName = nameStr[1]
    table.remove(nameStr, 1)
    table.removebyvalue(nameStr, "", true)
    if isNpc then
        if SL:GetValue("ACTOR_ONLY_SHOW_BUBBLE_NAME", actorID) then
            showName = ""
        end
    end

    -- check visible
    local labelNameVisible = SL:GetValue("ACTOR_HUD_NAME_SHOW", actorID) or SL:GetValue("ACTOR_HUD_PC_MOUSE_SHOW", actorID)
    local labelGuildVisible =  SL:GetValue("ACTOR_HUD_GUILD_SHOW", actorID) or SL:GetValue("ACTOR_HUD_PC_MOUSE_SHOW", actorID)
    local labelTitleVisible = SL:GetValue("ACTOR_HUD_TITLE_LABEL_SHOW", actorID) or SL:GetValue("ACTOR_HUD_PC_MOUSE_SHOW", actorID)
    local offsetX = 2
    local offsetY = ActorHud._useBmpFont and 5 or 0
    if SL:GetValue("ACTOR_IS_HERO", actorID) then
        labelGuildVisible = false
    end

    -- 副驾不显示
    if SL:GetValue("ACTOR_IS_HORSE_COPILOT", actorID) then
        labelNameVisible = false
        labelGuildVisible = false
        labelTitleVisible = false
    end
    
    --前缀文本（称号文本）
    for i = 1, 12 do
        local titleStr = nameStr[i]
        local _, __, titleName, titleColor = string.find(titleStr or "", "<(.+)/(%d+)>")
        if titleName then
            color = tonumber(titleColor) or color
            titleStr = titleName
        end
        result.title[i] = {titleColor = tonumber(titleColor), color = color, str = titleStr, visible = labelTitleVisible, offsetX = offsetX, offsetY = offsetY}
        --文本往下移
        if labelTitleVisible and titleStr and sLen(titleStr) > 0 then
            local hudIndex = SLDefine.HudIndex.HUD_LABEL_PRE_NAME1 - 1 + i
            offsetY = offsetY - LABEL_HUD_HEIGHT[hudIndex]
        end
    end
    --行会
    local guildName = guildInfo.guildName
    local rankName = guildInfo.rankName
    local castleName = guildInfo.castleName
    local ret = guildName
    offsetX = 0
    if guildName and isPlayer then
        if guildName and string.len( guildName ) > 0 then
            if rankName and rankName ~= "" then -- 行会职位 自定义职位名称
                local showJobName = string.format("[%s]", rankName)
                ret = ret .. " " .. showJobName
            end
            if castleName and castleName ~= "" then  -- 沙城行会
                ret = "(沙巴克)" .. ret
            end
        end
    end
    result.guild = {color = color, str = ret, visible = labelGuildVisible, offsetX = offsetX, offsetY = offsetY}
    --文本往下移
    if labelGuildVisible and guildName and sLen(guildName)>0 then
        offsetY = offsetY - LABEL_HUD_HEIGHT[SLDefine.HudIndex.HUD_LABEL_GUILD]
    end
    --//////掉落物color是0xFFFFFF格式  其他的是colorID
    --名字
    offsetX = 2
    -- 前缀 {<前缀/253>}名字
    local i, j, namePrefix, name = string.find(showName, "%{(.+)%}(.+)")
    if namePrefix then
        local _, __, titleName, titleColor = string.find(namePrefix, "<(.+)/(%d+)>")
        if titleName then
            color = tonumber(titleColor) or color
            namePrefix = titleName
        end
        result.prefix = {titleColor = tonumber(titleColor), color = color, str = namePrefix, visible = labelNameVisible, offsetX = offsetX, offsetY = offsetY}
    end
    showName = name or showName
    if isPlayer then 
        local horseStateName = ActorHud.GetHorseStateName(actorID)
        showName = horseStateName or showName
    end
    result.name = {color = color, str = showName, visible = labelNameVisible, offsetX = offsetX, offsetY = offsetY}

    return result
end

-- 骑马状态名字
function ActorHud.GetHorseStateName(actorID)
    local copilotid = SL:GetValue("ACTOR_HORSE_COPILOT_ID", actorID)  -- 副驾id
    local masterid  = SL:GetValue("ACTOR_HORSE_MASTER_ID", actorID)   --主驾id
    local copilotName = SL:GetValue("ACTOR_NAME", copilotid)
    local masterName = SL:GetValue("ACTOR_NAME", masterid)
    local name = nil
    if copilotName and masterName then
        name = string.format("%s  %s", masterName, copilotName)
    end

    return name
end
-- 刷新颜色时触发
-- 获取称号文本 行会信息 角色名 颜色
local result = {}
result.title = {}
function ActorHud.GetActorHUDLabelColorInfo(actorID, color, titleColors)
    --前缀文本
    for i = 1, 12 do
        result.title[i] = titleColors and titleColors[i] or color
    end
    result.guild = color
    result.name = color
    return result
end

-- 仅刷新显示状态时触发 boolean
-- 名字文本
function ActorHud.GetActorHUDLabelNameVisible(actorID, visible)
    return visible
end

-- 行会文本
function ActorHud.GetActorHUDLabelGuildVisible(actorID, visible)
    return visible
end

-- 前缀/称号文本
local title = {}
function ActorHud.GetActorHUDLabelTitleVisible(actorID, visible)
    -- 前缀文本
    for i = 1, 12 do
        title[i] = visible
    end
    return title
end
-------------------------------------------------------
--称号 封号 相关
-------------------------------------------------------
-- 刷新称号封号时触发
local SharedResult = {}
SharedResult.label = {}
SharedResult.sprite= {}
function ActorHud.GetActorHUDTitleInfo(actorID, titleID)
    local offsetY   = 78
    local titleH    = 0
    local imagePath = ""
    local color     = 255
    local itemName  = ""

    -- 
    if titleID and titleID > 0 then 
        imagePath = TitleData.GetSceneTitleImage(titleID)
        color = SL:GetValue("ITEM_NAME_COLORID", titleID)
        itemName = SL:GetValue("ITEM_NAME", titleID)
    end
    
    -- visible
    local visible = SL:GetValue("ACTOR_HUD_TITLE_SHOW", actorID)

    ---sprite
    -- reserved: 0 图标显示在左边; 1 图标显示在中间; 2不显示图标
    local reserved = SL:GetValue("ITEM_RESERVED_BY_INDEX", titleID)
    local remove   = reserved == 2
    local offsetX  = reserved == 1 and 0 or -40 
    local offsetY  = ActorHud._isWin32 and 78 or 83

    -----label 
    -- reserved: 不为0不显示
    local labelRemove = reserved > 0
    local labelOffsetX = 0
    local labelOffsetY = 78

    -- label
    SharedResult.label.str = itemName
    SharedResult.label.visible = visible
    SharedResult.label.color = color
    SharedResult.label.offsetX = labelOffsetX
    SharedResult.label.offsetY = labelOffsetY
    SharedResult.label.remove = labelRemove

    -- result
    SharedResult.sprite.imagePath = imagePath
    SharedResult.sprite.visible = visible
    SharedResult.sprite.offsetX = offsetX
    SharedResult.sprite.offsetY = offsetY
    SharedResult.sprite.remove = remove
    return SharedResult
end

-- 刷新称号封号时触发
local result = {}
for i = 0, 10, 1 do
    result[i] = {}
    result[i].enable = false
end
function ActorHud.GetActorHUDTophatInfo(actorID, icons, autoSort, hasTitle)
    local titleH = hasTitle and 20 or 0
    local offsetY = 78
    if ActorHud._isAutoTopHatSetPosY then
        offsetY = offsetY + titleH
    end
    local visible = SL:GetValue("ACTOR_HUD_TITLE_SHOW", actorID)
    for i = 0, 10 do--0-10槽位
        local params = icons[i]
        if params then
            local y = autoSort and offsetY or (offsetY - params.iY) -- 参数6大于1 自动排序并当height
            if autoSort then 
                offsetY = offsetY + params.height
            end
            result[i].X = params.X
            result[i].Y = y
            result[i].effType = params.effType
            result[i].effSrc = params.effSrc
            result[i].after = params.after
            result[i].Id  = params.Id
            result[i].visible = visible
            result[i].enable = true
        else
            result[i].enable = false
        end
    end

    return result
end
--------------------------------骑马时的偏移  BEGIN---------------------------------
function ActorHud.GetHorseOffset(actorID)
    if not actorID or not ActorHud._horseOffset[actorID] then
        return GUI:p(0,0)
    end
    return ActorHud._horseOffset[actorID].default or GUI:p(0,0)
end

function ActorHud.SetHorseOffset(actorID, offset) 
    if not actorID then
        return
    end
    if not ActorHud._horseOffset[actorID] then
        ActorHud._horseOffset[actorID] = {}
    end
    ActorHud._horseOffset[actorID].default = offset or GUI:p(0,0)
end

function ActorHud.GetHorseOffsetLabel(actorID)
    if not actorID or not ActorHud._horseOffset[actorID] then
        return GUI:p(0,0)
    end
    return ActorHud._horseOffset[actorID].labelDefault or GUI:p(0,0)
end

function ActorHud.SetHorseOffsetLabel(actorID, offset)
    if not ActorHud._horseOffset[actorID] then
        ActorHud._horseOffset[actorID] = {}
    end

    ActorHud._horseOffset[actorID].labelDefault = offset or GUI:p(0,0)
end

function ActorHud.RmvHorseOffsetByActorID(actorID)
    ActorHud._horseOffset[actorID] = nil
end

function ActorHud.CleanHorseOffset()
    ActorHud._horseOffset = {}
end
--------------------------------骑马时的偏移  END---------------------------------

ActorHud.main()