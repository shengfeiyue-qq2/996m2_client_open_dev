MainTarget = {}

MainTarget.jobIconPath = {
    "res/private/main/Target/1900012533.png",
    "res/private/main/Target/1900012534.png",
    "res/private/main/Target/1900012535.png"
}
MainTarget.monsterIconPath = "res/private/main/Target/1900012536.png"

MainTarget._targetID = nil

-- 血条颜色
local HpColor = 
{
    "res/private/main_monster_ui/hp/1.png", 
    "res/private/main_monster_ui/hp/2.png", 
    "res/private/main_monster_ui/hp/3.png", 
    "res/private/main_monster_ui/hp/4.png", 
    "res/private/main_monster_ui/hp/5.png",
    "res/private/main_monster_ui/hp/6.png", 
    "res/private/main_monster_ui/hp/7.png", 
    "res/private/main_monster_ui/hp/8.png", 
    "res/private/main_monster_ui/hp/9.png", 
    "res/private/main_monster_ui/hp/10.png"
}

-- 上次血量
local PreHp = nil

local mceil = math.ceil
local mfloor = math.floor
local sformat = string.format

function MainTarget.main( ... )
    local parent = GUI:Attach_Parent()
    if not parent then
        return
    end
    MainTarget.createCommonLayout(parent)
    MainTarget.createMonsterLayout(parent)
    MainTarget.UpdateLockBtn()

    SL:RegisterLUAEvent(LUA_EVENT_TARGET_HP_CHANGE, "MainTarget", MainTarget.OnRefreshHp)
    SL:RegisterLUAEvent(LUA_EVENT_TARGET_CAHNGE, "MainTarget", MainTarget.OnTargetChange)
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "MainTarget", MainTarget.UpdateLockBtn)
    SL:RegisterLUAEvent(LUA_EVENT_ACTOR_OWNER_CHANGE, "MainTarget", MainTarget.OnActorOwnerChange)
end

function MainTarget.createCommonLayout(parent)
    local CommonPanel = GUI:Layout_Create(parent, "CommonPanel", 3, -225, 170, 37, false)
    GUI:setAnchorPoint(CommonPanel, 0, 1)
    GUI:setTouchEnabled(CommonPanel, true)
    GUI:setVisible(CommonPanel, false)
    GUI:addOnClickEvent(CommonPanel, MainTarget.OnClickTarget)
    MainTarget.CommonPanel = CommonPanel

    local icon = GUI:Image_Create(CommonPanel, "icon", 18, 18, "res/private/main/Target/1900012534.png")
    GUI:setAnchorPoint(icon, 0.5, 0.5)
    MainTarget.icon = icon

    local nameBg = GUI:Image_Create(CommonPanel, "nameBg", 105, 35, "res/private/main/Target/1900012531.png")
    GUI:setAnchorPoint(nameBg, 0.5, 1)

    local nameText = GUI:ScrollText_Create(CommonPanel, "nameText", 39, 17, 132, 16, "FFFFFF", "")
    GUI:ScrollText_enableOutline(nameText, "#111111", 1)
    GUI:ScrollText_setHorizontalAlignment(nameText, 2)

    local hpBg = GUI:Image_Create(CommonPanel, "hpBg", 105, 8, "res/private/main/Target/1900012530.png")
    GUI:setAnchorPoint(hpBg, 0.5, 0.5)

    local hpLoadingBar = GUI:LoadingBar_Create(CommonPanel, "hpLoadingBar", 105, 8, "res/private/main/Target/1900012532.png", 0)
    GUI:LoadingBar_setPercent(hpLoadingBar, 50)
    GUI:setAnchorPoint(hpLoadingBar, 0.5, 0.5)
    MainTarget.hpLoadingBar = hpLoadingBar

    local hpText = GUI:Text_Create(CommonPanel, "hpText", 105, 9, 16, "#FFFFFF", "100%")
    GUI:setAnchorPoint(hpText, 0.5, 0.5)

    local lockBtn = GUI:Button_Create(CommonPanel, "lockBtn", 205, 18.5, "res/private/player_hero/btn_heji_05_1.png")
    GUI:setAnchorPoint(lockBtn, 0.5, 0.5)
    GUI:setTouchEnabled(lockBtn, true)
    GUI:addOnClickEvent(lockBtn, MainTarget.OnLockEvent)
    MainTarget.lockBtn = lockBtn

    local cleanBtn = GUI:Button_Create(CommonPanel, "cleanBtn", 250, 18.5, "res/private/main/Target/btn_gban_01.png")
    GUI:setAnchorPoint(cleanBtn, 0.5, 0.5)
    GUI:setTouchEnabled(cleanBtn, true)
    GUI:addOnClickEvent(cleanBtn, function () SL:ClearTarget() end)
    MainTarget.cleanBtn = cleanBtn
end

function MainTarget.createMonsterLayout(parent)
    -- Create MonsterLayout
	local MonsterLayout = GUI:Layout_Create(parent, "MonsterLayout", 270, -135, 394, 104, false)
    MainTarget.MonsterLayout = MonsterLayout
    GUI:setVisible(MonsterLayout, false)

	-- Create hpBg
	local hpBg = GUI:Image_Create(MonsterLayout, "hpBg", 0, 1, "res/private/main_monster_ui/bg.png")
	GUI:setTouchEnabled(hpBg, false)

	-- Create LoadingBar
	local hpBgMonster = GUI:LoadingBar_Create(MonsterLayout, "hpBgMonster", 89, 47, "res/private/main_monster_ui/hp/0.png", 0)
	GUI:LoadingBar_setPercent(hpBgMonster, 100)
    MainTarget.hpBgMonster = hpBgMonster

    -- Create hpLoadingBarMonster
	local hpLoadingBarMonster = GUI:LoadingBar_Create(MonsterLayout, "hpLoadingBarMonster", 89, 47, "res/private/main_monster_ui/hp/0.png", 0)
	GUI:LoadingBar_setPercent(hpLoadingBarMonster, 100)
    MainTarget.hpLoadingBarMonster = hpLoadingBarMonster

    -- Create Text_level
	local Text_level = GUI:Text_Create(MonsterLayout, "Text_level", 47, 11, 16, "#ffffff", [[0]])
	GUI:setAnchorPoint(Text_level, 0.5, 0.5)
    MainTarget.Text_level = Text_level

    local nameText = GUI:ScrollText_Create(MonsterLayout, "nameText", 92, 70, 171, 16, "FFFFFF", "")
    GUI:ScrollText_enableOutline(nameText, "#111111", 1)
    GUI:ScrollText_setHorizontalAlignment(nameText, 2)

	-- Create Image_head
	local Image_head = GUI:Image_Create(MonsterLayout, "Image_head", 12, 28, "res/private/main_monster_ui/monster/00001.png")
	GUI:setTouchEnabled(Image_head, false)
    MainTarget.Image_head = Image_head

    local hpText = GUI:Text_Create(MonsterLayout, "hpText", 221, 57, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(hpText, 0.5, 0.5)
    MainTarget.hpText = hpText

    local hpNum = GUI:Text_Create(MonsterLayout, "hpNum", 360, 27, 16, "#FF0000", "")
    GUI:setAnchorPoint(hpNum, 0.5, 0.5)
    MainTarget.hpNum = hpNum

    local Text_owner = GUI:Text_Create(MonsterLayout, "Text_owner", 95, 33, 16, "#ffffff", "")
	GUI:setAnchorPoint(Text_owner, 0, 0.5)
    MainTarget.Text_owner = Text_owner

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(MonsterLayout, "ButtonClose", 335, 69, "res/private/main_monster_ui/close1.png")
	GUI:Button_loadTexturePressed(ButtonClose, "res/private/main_monster_ui/close2.png")
	GUI:setTouchEnabled(ButtonClose, true)
    GUI:addOnClickEvent(ButtonClose, function () SL:ClearTarget() end)
end
function MainTarget.OnClickTarget()
    local actor = SL:GetActorByID(MainTarget._targetID)
    if not actor then
        return false
    end

    -- 自己的英雄不让查看
    if SL:IsMyHero(MainTarget._targetID) then
        return false
    end

    if not SL:IsPlayer(actor) then
        return false
    end

    SL:OpenFuncDockTips({
        type = SL:IsHumanoid(actor) and SL:EnumDockType().Func_Monster_Head or SL:EnumDockType().Func_Player_Head,
        isHero = SL:IsHero(actor),
        targetId = SL:GetActorID(actor),
        targetName = SL:GetActorName(actor),
        pos = {x = GUI:getTouchEndPosition(MainTarget.CommonPanel).x + 15, y = GUI:getTouchEndPosition(MainTarget.CommonPanel).y}
    })
end

function MainTarget.OnTargetChange(targetID)
    local actor = SL:GetActorByID(targetID)
    if SL:IsPlayer(actor) or SL:IsMonster(actor) then
        MainTarget.SelectTarget(targetID)
    else
        MainTarget.SelectTarget(nil)
    end
end

function MainTarget.SelectTarget(targetID)
    MainTarget._targetID = targetID
    MainTarget._monsterCfg = nil

    if not targetID then
        GUI:setVisible(MainTarget.CommonPanel, false)
        GUI:setVisible(MainTarget.MonsterLayout, false)
        return false
    end

    local actor = SL:GetActorByID(targetID)
    if not actor then
        MainTarget.CommonPanel:setVisible(false)
        GUI:setVisible(MainTarget.MonsterLayout, false)
        return false
    end

    if SL:IsPlayer(actor) then
        local job = SL:GetActorJobID(actor)
        local jobPath = MainTarget.jobIconPath
        if MainTarget.jobIconPath[job+1] then
            GUI:Image_loadTexture(MainTarget.icon, MainTarget.jobIconPath[job+1])
        end
    elseif SL:IsMonster(actor) then
        local cfg = SL:GetFMonsterDataByIndex(SL:GetMonsterIDByActor(actor))
        if cfg and cfg.open and cfg.open == 1 then
            MainTarget._monsterCfg = cfg
            -- head
            local headPic = string.format("res/private/main_monster_ui/monster/%s.png", cfg.head)
            if SL:IsFileExist(headPic) then
                GUI:Image_loadTexture(MainTarget.Image_head, headPic)
            end

            -- level
            local level = string.format("Lv.%s", SL:GetActorLevel(actor))
            GUI:Text_setString(MainTarget.Text_level, level)
        else
            if MainTarget.monsterIconPath then
                GUI:Image_loadTexture(MainTarget.icon, MainTarget.monsterIconPath)
            end
        end
    end

    MainTarget.OnRefreshHpUI(actor, true)
    MainTarget.SetTargetName()
end

function MainTarget.SetTargetName()
    local actor = SL:GetActorByID(MainTarget._targetID)
    if not actor then
        return false
    end

    -- 所属
    local ownerName = SL:GetActorOwnerName(actor)

    if MainTarget.IsOpenMoreHp() then
        -- 名字
        local name = SL:GetActorName(actor)
        GUI:ScrollText_setString(GUI:getChildByName(MainTarget.MonsterLayout, "nameText"), name)
        if string.len(ownerName) > 0 then
            GUI:ScrollText_setString(MainTarget.Text_owner, sformat("归属者 %s", ownerName))
        end
    else
        -- 名字
        local name = SL:GetActorName(actor)
        if string.len(ownerName) > 0 then
            name = sformat("%s(%s)", name, ownerName)
        end

        if SL:GetGameDataCfg().Monsterlevel == 2 and SL:CheckSet(34) == 1 and not SL:IsForbidLvJob() then
            name = name .. "/J" .. SL:GetActorLevel(actor)
        end
        GUI:ScrollText_setString(GUI:getChildByName(MainTarget.CommonPanel, "nameText"), name)
    end
end

-- 是否开启多血条
function MainTarget.IsOpenMoreHp()
    local cfg = MainTarget._monsterCfg
    if cfg and cfg.open and cfg.open == 1 then
        return true
    end
    return false
end

function MainTarget.OnRefreshHp(targetID)
    local actor = SL:GetActorByID(targetID)
    if not actor then
        return false
    end
    if targetID ~= MainTarget._targetID then
        return false
    end
    MainTarget.OnRefreshHpUI(actor)
end

function MainTarget.OnRefreshHpUI(target, targetchange)
    local isMoreHp = false
    if SL:IsMonster(target) and MainTarget.IsOpenMoreHp() then
        GUI:setVisible(MainTarget.MonsterLayout, true)
        GUI:setVisible(MainTarget.CommonPanel, false)

        MainTarget.SetMonsterHp(target, targetchange)
    else
        GUI:setVisible(MainTarget.MonsterLayout, false)
        GUI:setVisible(MainTarget.CommonPanel, true)

        local curHP   = SL:GetActorHp(target)
        local maxHP   = SL:GetActorMaxHp(target)
        local percent = mceil(curHP/maxHP * 100)

        if SL:IsFullHp(target) then
            percent = 100
        end
        GUI:LoadingBar_setPercent(GUI:getChildByName(MainTarget.CommonPanel, "hpLoadingBar"), percent)
        GUI:Text_setString(GUI:getChildByName(MainTarget.CommonPanel, "hpText"), percent .. "%")

        MainTarget.UpdateLockBtn()
    end
end

function MainTarget.SetMonsterHp(target, targetchange)
    local cfg = MainTarget._monsterCfg
    if not cfg then
        return false
    end
    -- 单条血量
    local hp_unit = cfg.hp_unit
    local hp_type = cfg.hp_type

    local curHP = SL:GetActorHp(target)
    local maxHP = SL:GetActorMaxHp(target)

    local function callback()
        if hp_type == 2 then
            MainTarget.hpText:setString(curHP .. "/" .. maxHP)
        else
            MainTarget.hpText:setString(mceil(curHP/maxHP * 100).."%")
        end
        MainTarget.hpNum:setString("X"..mceil(curHP / hp_unit))
    end

    -- 动画间隔
    local interval = 0.01

    if targetchange then
        PreHp = nil
    end

    if not PreHp or PreHp == 0 then
        PreHp = curHP
        local per = (curHP % hp_unit) / hp_unit * 100
        if per == 0 then
            per = 100
        end
        GUI:LoadingBar_setPercent(MainTarget.hpLoadingBarMonster, per)
        interval = 0
    end

    -- 血量变化值
    local changeHp = curHP - PreHp
    PreHp = curHP

    -- 进度条单次减少范围
    local step = changeHp > 0 and 10 or (changeHp < 0 and -10 or 0)

    -- 总血条数
    local totalnum = mceil(maxHP / hp_unit)
    -- 当前血条的数量
    local curnum   = mceil(curHP / hp_unit)
    local clrnum   = #HpColor
    local colors   = {}

    -- 实际需要的最大颜色范围
    local max_num = math.min(clrnum, totalnum)
    for i=1,max_num do
        colors[i] = HpColor[i]
    end

    local mod = curnum % max_num
    mod = mod > 0 and mod or max_num
    local n = #colors
    local tmp = {}
    for i=mod,1,-1 do
        tmp[#tmp+1] = colors[i]
    end
    for i=#colors,mod+1,-1 do
        tmp[#tmp+1] = colors[i]
    end
    colors = tmp

    if step == 0 then
        GUI:LoadingBar_loadTexture(MainTarget.hpLoadingBarMonster, colors[1])
        if MainTarget.hpBgMonster then
            if curnum == 1 then
                MainTarget.hpBgMonster:setOpacity(0)
            else
                GUI:LoadingBar_loadTexture(MainTarget.hpBgMonster, colors[2])
                MainTarget.hpBgMonster:setOpacity(255)
                GUI:LoadingBar_setPercent(MainTarget.hpBgMonster, 100)
            end
        end
        callback()
        return false
    end

    -- 进度条滚动的条数
    local count = mfloor(math.abs(changeHp) / hp_unit)

    -- 目标进度百分比（0~100）
    local to = (curHP % hp_unit) / hp_unit * 100

    -- 血条透明度
    local opacity = 255

    GUI:Timeline_Progress(MainTarget.hpLoadingBarMonster, MainTarget.hpBgMonster, {
        count       = count,
        num         = curnum,
        opacity     = opacity, 
        to          = to,
        step        = step,
        interval    = interval,
        colors      = colors,
        callback    = callback
    })
end

-- 召唤物锁定 -------------------------------------------------------------------
function MainTarget.OnLockEvent(sender)
    if GUI:Win_IsNull(sender) then
        return false
    end
    local lcokState = GUI:Win_GetParam(MainTarget.lockBtn)
    if lcokState == -1 then
        SL:RequestLockPetID(MainTarget._targetID)
        GUI:setClickDelay(sender, 0.3)
    elseif lcokState == 1 then
        SL:RequestUnLockPetID(MainTarget._targetID)
        GUI:setClickDelay(sender, 0.3)
    end
    MainTarget.UpdateLockBtn()
end

function MainTarget.UpdateLockBtn()
    -- 召唤物是否复活
    local isAlive = SL:GetMetaValue("PET_ALIVE")
    MainTarget.AdaptBtnPosition(isAlive)

    if not isAlive then
        return false
    end

    local lockID = SL:GetMetaValue("PET_LOCK_ID")

    local isLock = lockID == MainTarget._targetID
    if isLock then
        GUI:Win_SetParam(MainTarget.lockBtn, 1)
        GUI:Button_loadTextureNormal(MainTarget.lockBtn, "res/private/player_hero/btn_heji_05.png")
    else
        GUI:Win_SetParam(MainTarget.lockBtn, -1)
        GUI:Button_loadTextureNormal(MainTarget.lockBtn, "res/private/player_hero/btn_heji_05_1.png")
    end
end

-- 自适应召唤物锁定按钮
function MainTarget.AdaptBtnPosition(active)
    MainTarget.cleanBtn:setPositionX(active and 250 or 190)
    MainTarget.lockBtn:setVisible(active)
end

function MainTarget.OnActorOwnerChange(data)
    if not (data.actorID and MainTarget._targetID == data.actorID) then
        return false
    end

    MainTarget.SetTargetName()
end