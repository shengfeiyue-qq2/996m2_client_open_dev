-- 英雄状态面板 挂在左下角
HeroState = {}

-- 斗转星移技能ID
local DZXY_SkillID  = 118

-- 醉酒相关是否显示
local ON_OFF_zuijiu = false

local IS_PC_OPER_MODE = SL:GetValue("IS_PC_OPER_MODE")

function HeroState.main()
    local parent = GUI:Attach_Top()
    GUI:LoadExport(parent, "hero/hero_state_node")
    HeroState._root = GUI:getChildByName(parent, "Hero_State")
    HeroState._heroBtn = GUI:getChildByName(parent, "btnCallHerop")

    local Panel_ng = GUI:getChildByName(HeroState._root, "Panel_ng")
    local Panel_1  = GUI:getChildByName(HeroState._root, "Panel_1")

    local NGShow = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1
    HeroState._NGShow = NGShow

    GUI:setVisible(Panel_1, not NGShow)
    GUI:setVisible(Panel_ng, NGShow)

    HeroState._panel = NGShow and Panel_ng or Panel_1
    HeroState._ui = GUI:ui_delegate(HeroState._panel)

    if not HeroState._ui then
        return false
    end

    -- 适配
    GUI:setPositionY(HeroState._panel, SL:GetValue("SCREEN_HEIGHT") - 26)

    HeroState._originalPos = GUI:getPosition(HeroState._panel)

    HeroState.InitUI()

    HeroState.RegisterEvent()
end

-- 内功显示切换
function HeroState.OnShowNGPanel()
    HeroState._NGShow = tonumber(SL:GetValue("GAME_DATA", "OpenNGUI")) == 1 and SL:GetValue("H.IS_LEARNED_INTERNAL")
    if HeroState._ui.LoadingBar_ng then
        GUI:setVisible(HeroState._ui.LoadingBar_ng, HeroState._NGShow)
    end
    if HeroState._ui.Image_zj_bg then
        GUI:setVisible(HeroState._ui.Image_zj_bg, HeroState._NGShow and ON_OFF_zuijiu)
    end
    HeroState.OnRefreshDZShow()
    HeroState.OnRefreshNGValue()
end

function HeroState.InitUI()
    HeroState.OnShowNGPanel()
    GUI:setVisible(HeroState._ui.Text_state, false)
    -- 背包
    GUI:addOnClickEvent(HeroState._ui.Button_bag,function()
        if SL:GetValue("HERO_IS_ALIVE") then
            UIOperator:OpenHeroBagUI()
        end
    end)
    -- 状态
    GUI:addOnClickEvent(HeroState._ui.Button_state,function()
        UIOperator:OpenMyHeroUI({page = UIConst.LayerTable.PlayerEquip})
    end)
    -- 召唤收回
    GUI:addOnClickEvent(HeroState._heroBtn, function()
        GUI:setClickDelay(HeroState._heroBtn, 0.5)
        SL:RequestCallOrOutHero()
    end)
    if IS_PC_OPER_MODE then
        GUI:setVisible(HeroState._ui.Button_bag, false)
        GUI:setVisible(HeroState._ui.Button_state, false)
        GUI:setVisible(HeroState._heroBtn, false)
    end
    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_bag, true)
    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_state, true)
    GUI:setIgnoreContentAdaptWithSize(HeroState._heroBtn, true)

    -- 点击显示英雄信息
    GUI:setTouchEnabled(HeroState._ui.Panel_info, true)
    GUI:addOnClickEvent(HeroState._ui.Panel_info, function()
        local str = ""
        local maxHp      = SL:GetValue("H.MAXHP") 
        local curHp      = SL:GetValue("H.HP") 
        local maxMp      = SL:GetValue("H.MAXMP")
        local curMp      = SL:GetValue("H.MP")
        local curExp     = SL:GetValue("H.EXP")
        local maxExp     = SL:GetValue("H.MAXEXP")
        local curForce   = SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_Value)
        local maxForce   = SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_Value)
        local curDZValue = SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue) or 0
        local maxDZValue = SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue) or 0
        local ngStr = ""
        if HeroState._NGShow then
            ngStr = string.format("内力值:%s/%s\\", curForce, maxForce)
            if SL:GetValue("H.SKILL_DATA", DZXY_SkillID) then
                ngStr = ngStr .. string.format("斗转星移值: %s/%s\\", curDZValue, maxDZValue)
            end

            if ON_OFF_zuijiu then
                ngStr = ngStr .. string.format("醉酒值: %s%%", 0)
            end
        end

        str = string.format("体力值:%s魔法值:%s经验值:%s%s", 
                                    (SL:HPUnit(curHp) .. "/" .. SL:HPUnit(maxHp) .. "\\"),
                                    (curMp .. "/" .. maxMp .. "\\"),
                                    (curExp .. "/" .. maxExp .. "\\"),
                                    ngStr
        )
        local pos = GUI:getWorldPosition(HeroState._ui.Panel_info)
        pos.x = pos.x + 5
        UIOperator:OpenCommonDescTipsUI({str = str, worldPos = pos, width = 440, anchorPoint = GUI:p(0, 1)})
    end)

    GUI:setVisible(HeroState._root, false)
    if not IS_PC_OPER_MODE then
        local heroBtnShow = false
        if  SL:GetValue("USEHERO") and SL:GetValue("HERO_IS_ACTIVE") then
            heroBtnShow = true
        end
        GUI:setVisible(HeroState._heroBtn, heroBtnShow)

        -- 操作模式
        local OptSet = SL:GetValue("GAME_DATA","Heroqiehuanmoshi") or 0
        local node = HeroState._ui.Image_state
        local originPos = GUI:getWorldPosition(node)

        -- 长按时间
        local longTime = 0.5
        if OptSet == 0 then
            -- 滑动模式
            local longCallBack = function() -- 长按
                -- 打开英雄状态选择界面 mode--1选择状态 2单击切换  3不能点击,滑动
                UIOperator:OpenHeroStateSelectUI({pos = originPos, mode = 3})
            end
            local shortCallBack = function() -- 短按
                UIOperator:OpenHeroStateSelectUI({pos = originPos, mode = 2})
            end

            -- 长按状态
            local long = false
            GUI:addOnTouchEvent(node, function(sender, type)
                if type == GUIDefine.TouchEventType.BEGAN then
                    if not node._clicking then
                        node._clicking = true
                        SL:scheduleOnce(node, function()
                            node._clicking = false
                            if longCallBack then
                                long = 0
                                longCallBack()
                            end
                        end, longTime)
                    end
                elseif type == GUIDefine.TouchEventType.MOVED then
                    if long then
                        local movePos = GUI:getTouchMovePosition(sender)
                        -- 英雄状态系统 能设置的值3个或四个
                        local sys =  SL:GetValue("HERO_STATES_SYS_VALUES")
                        local isthree = #sys ~= 4

                        --指向的选项
                        local index = 0
                        if isthree then -- 3个方向的
                            if originPos.x == movePos.x then
                                index = originPos.y <= movePos.y and 1 or 3
                            elseif originPos.x < movePos.x then
                                local anger = math.atan((movePos.y - originPos.y) / (movePos.x - originPos.x)) / math.pi * 180

                                if anger <= -30 then
                                    index = 3
                                else
                                    index = 2
                                end
                            else
                                local anger = math.atan((movePos.y - originPos.y) / (movePos.x - originPos.x)) / math.pi * 180
                                if anger >= 30 then
                                    index = 3
                                else
                                    index = 1
                                end
                            end
                        else -- 4个方向的
                            if originPos.x == movePos.x then
                                index = originPos.y <= movePos.y and 1 or 4
                            elseif originPos.x < movePos.x then
                                local anger = math.atan((movePos.y - originPos.y) / (movePos.x - originPos.x)) / math.pi * 180
                                if anger >= 0 then
                                    index = 2
                                else
                                    index = 3
                                end
                            else
                                local anger = math.atan((movePos.y - originPos.y) / (movePos.x - originPos.x)) / math.pi * 180
                                if anger >= 0 then
                                    index = 4
                                else
                                    index = 1
                                end
                            end
                        end

                        if long ~= index then
                            long = index
                            -- 同步英雄状态选择
                            HeroStateSelect.refSelect({ index = index })
                        end
                    end
                elseif type == GUIDefine.TouchEventType.ENDED then
                    if node._clicking then  -- 未触发长按触发短按
                        GUI:stopAllActions(node)
                        node._clicking = false
                        if shortCallBack then
                            shortCallBack()
                        end
                    end
                    if long then
                        long = false
                        HeroStateSelect.refSelect({ index = -1 })
                    end
                elseif type == 3 then -- 长按松开
                    long = false
                    HeroStateSelect.refSelect({ index = -1 })
                end
            end)
        else -- 双击模式
            local clickCallBack = function()    -- 单击
                repeat
                    local states = SL:GetValue("HERO_ACTIVES_STATES")   -- 英雄激活的状态
                    local curstate = 0
                    -- 守护状态
                    if SL:GetValue("HERO_GUARDSTATE") then
                        curstate = 3
                    else
                        local state = SL:GetValue("HERO_STATE")     -- 英雄状态
                        state = tonumber(state)
                        curstate = state
                    end
                    local idx = table.indexof(states, curstate)
                    if idx then
                        idx = idx + 1
                        if idx > #states then
                            idx = 1
                        end
                    else
                        if #states > 0 then
                            idx = 1
                        else
                            UIOperator:OpenHeroStateSelectUI({pos = originPos, mode = 1})
                            break
                        end
                    end
                    local tag = states[idx]
                    local state = SL:GetValue("HERO_GUARD_ISCLICK") -- 是否点击了  守护按钮
                    if tag < 3 then
                        -- 要先取消守护点击状态
                        if state then
                            SL:SetValue("HERO_GUARD_ISCLICK", false)
                        end

                        -- 切换英雄状态
                        SL:RequestChangeHeroMode(tag)
                    elseif tag == 3 then 
                        -- 守护
                        SL:SetValue("HERO_GUARD_ISCLICK", not state)
                    end
                until true
            end

            -- 长按
            local doubleClickCallBack = function()
                UIOperator:OpenHeroStateSelectUI({pos = originPos, mode = 1})
            end

            GUI:addOnTouchEvent(node,function(sender, type)
                if type == 0 then
                    if node._clicking then
                        if doubleClickCallBack then
                            doubleClickCallBack()
                        end
                        GUI:stopAllActions(node)
                        node._clicking = false
                    else
                        node._clicking = true
                        performWithDelay(node, function()
                            node._clicking = false
                            if clickCallBack then
                                clickCallBack()
                            end
                        end, GUIDefine.CLICK_DOUBLE_TIME)
                    end
                end
            end)
        end
    else
        local screenH = SL:GetValue("SCREEN_HEIGHT")
        GUI:setPosition(HeroState._panel, 250, screenH - 10)
    end
    ---------------点头像------------------------------------
    GUI:setTouchEnabled(HeroState._ui.Image_head, true)
    GUI:addOnClickEvent(HeroState._ui.Image_head,function()
        UIOperator:OpenMyHeroUI({page = UIConst.LayerTable.PlayerEquip})
    end)

    local function addItemIntoBag()
        local state = SL:GetValue("ITEM_MOVE_STATE") 
        if not state then
            return -1
        end
        SL:ItemMoveCheck({target = GUIDefine.ItemGoTo.HERO_BAG})
    end

    GUI:addMouseButtonEvent(HeroState._ui["Image_head"], {
        onRightDownFunc = function ()
            return -1
        end,
        onSpecialRFunc = addItemIntoBag
    })
end

-- 内功值改变触发
function HeroState.OnRefreshNGValue()
    if not HeroState._NGShow then
        return false
    end

    -- 内功条
    local force    = SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_Value)
    local maxForce = SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_Value)
    local per = maxForce == 0 and 0 or (force / maxForce * 100)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_ng, per)

    -- 斗转星移值 
    if not HeroState._dzPanelHei then
        HeroState._dzPanelHei = GUI:getContentSize(HeroState._ui.Panel_bar_dz).height
    end
    local wid = GUI:getContentSize(HeroState._ui.Panel_bar_dz).width
    local curDZValue = SL:GetValue("H.CUR_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue)
    local maxDZValue = SL:GetValue("H.MAX_ABIL_BY_ID", GUIDefine.AttTypeTable.Internal_DZValue)
    local per = 0
    if curDZValue and maxDZValue and maxDZValue > 0 then
        per = curDZValue / maxDZValue
    end
    GUI:setContentSize(HeroState._ui.Panel_bar_dz, {width = wid, height = HeroState._dzPanelHei * per})
    
    -- 醉酒值
    if not HeroState._zjPanelHei then
        HeroState._zjPanelHei = GUI:getContentSize(HeroState._ui.Panel_bar_zj).height
    end
    local wid = GUI:getContentSize(HeroState._ui.Panel_bar_zj).width
    local per = 0
    GUI:setContentSize(HeroState._ui.Panel_bar_zj, {width = wid, height = HeroState._zjPanelHei * per})
end

-- 英雄普通技能学习/删除
function HeroState.OnRefreshDZShow()
    if HeroState._ui.Image_dz_bg then
        if SL:GetValue("H.SKILL_DATA", DZXY_SkillID) then
            GUI:setVisible(HeroState._ui.Image_dz_bg, HeroState._NGShow and true)
        else
            GUI:setVisible(HeroState._ui.Image_dz_bg, false)
        end
    end
end

-- 英雄死亡触发
function HeroState.Hero_Die(isDie)
    if isDie then
        GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_1, 0)
        GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_2, 0)
        GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_3, 0)
        if HeroState._NGShow then
            GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_ng, 0)
        end
        GUI:Image_setGrey(HeroState._ui.Image_head, true)
    else
        GUI:Image_setGrey(HeroState._ui.Image_head, false)
    end
end

function HeroState.OnAssistHideStatusChange(data)
    local isOpen = (tonumber(SL:GetValue("GAME_DATA", "HeroStateHideWithAssist")) or 0) == 1
    if not isOpen then
        GUI:Timeline_EaseSineIn_MoveTo(HeroState._panel, HeroState._originalPos, 0.2)
        return
    end

    GUI:stopAllActions(HeroState._panel)
    if data.bHide then
        GUI:Timeline_EaseSineIn_MoveTo(HeroState._panel, {x = HeroState._originalPos.x - data.assistSize.width, y = HeroState._originalPos.y}, 0.2)
    else
        GUI:Timeline_EaseSineIn_MoveTo(HeroState._panel, HeroState._originalPos, 0.2)
    end
end

-- 忠诚度改变
function HeroState.OnUpdateLoyal()
    -- 忠诚度
    local HeroLuck = SL:GetValue("H.LUCK")
    GUI:Text_setString(HeroState._ui.Text_z, string.format("%0.2f%%", HeroLuck / 10))
end

-- 英雄属性改变
function HeroState.OnUpdateProperty()
    -- 未召唤英雄
    if not SL:GetValue("HERO_IS_ALIVE")  then
        return false
    end

    -- 死亡
    if SL:GetValue("ACTOR_IS_DIE", SL:GetValue("HERO_ID")) then
        return false
    end 

    local name       = SL:GetValue("H.USERNAME") 
    local nameColor  = SL:GetValue("HERO_NAME_COLOR") 
    local HPPercent  = SL:GetValue("H.HPPercent")
    local MPPercent  = SL:GetValue("H.MPPercent")
    local EXPPercent = SL:GetValue("H.EXPPercent")
    local level      = SL:GetValue("H.LEVEL")
    local sex        = SL:GetValue("H.SEX") 
    local job        = SL:GetValue("H.JOB")   
    
    local namestrs = string.split(name, "\\")
    GUI:Text_setString(HeroState._ui.Text_name, namestrs[1])

    if nameColor then
        GUI:Text_setTextColor(HeroState._ui.Text_name, SL:GetHexColorByStyleId(nameColor))
    end

    GUI:Text_setString(HeroState._ui.Text_level,level)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_1, HPPercent)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_2, MPPercent)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_3, EXPPercent)
    GUI:Image_loadTexture(HeroState._ui.Image_head, string.format("%splayer_hero/0121%s.png", GUIDefine.PATH_RES_PRIVATE, (job + 3 * (1 - sex))))
end

-- 复活
function HeroState.OnRevive()
    if not SL:GetValue("HERO_IS_ALIVE") then
        return false
    end

    HeroState.Hero_Die(false)
end

-- 死亡
function HeroState.OnDie()
    HeroState.Hero_Die(true)
end

-- 英雄召唤
function HeroState.OnHeroLogin()
    GUI:setVisible(HeroState._root, true)
    HeroState.Hero_Die(false)
    HeroState.OnUpdateProperty()

    GUI:Button_loadTextureNormal(HeroState._heroBtn, string.format("%splayer_hero/btn_loginout1.png", GUIDefine.PATH_RES_PRIVATE))
    GUI:Button_loadTexturePressed(HeroState._heroBtn,string.format("%splayer_hero/btn_loginout2.png", GUIDefine.PATH_RES_PRIVATE))
    GUI:setIgnoreContentAdaptWithSize(HeroState._heroBtn, true)
end

-- 英雄收回
function HeroState.OnHeroLogOut()
    GUI:setVisible(HeroState._root, false)
    GUI:Button_loadTextureNormal(HeroState._heroBtn, string.format("%splayer_hero/btn_login1.png", GUIDefine.PATH_RES_PRIVATE))
    GUI:Button_loadTexturePressed(HeroState._heroBtn,string.format("%splayer_hero/btn_login2.png", GUIDefine.PATH_RES_PRIVATE))
    GUI:setIgnoreContentAdaptWithSize(HeroState._heroBtn, true)
end

-- 状态改变
function HeroState.OnUpdateLockState()
    local stateStr = ""
    if SL:GetValue("HERO_GUARDSTATE") then
        stateStr = "守护"
    else
        local state = SL:GetValue("HERO_STATE") 
        local showStrs = {"战斗", "跟随", "休息"}
        stateStr = showStrs[state+1]
    end
    GUI:Text_setString(HeroState._ui.Text_state, stateStr)

    GUI:setVisible(HeroState._ui.Text_state, true)
end

-- 刷新等级
function HeroState.OnUpdateLevel()
    if not SL:GetValue("HERO_IS_ACTIVE")  then
        return false
    end

    GUI:Text_setString(HeroState._ui.Text_level, SL:GetValue("H.LEVEL"))
end

-- 按钮是否显示
function HeroState.OnHeroBtnShowOrHide()
    if IS_PC_OPER_MODE then
        return false
    end

    -- 是否开启英雄
    if not SL:GetValue("USEHERO")  then
        return false
    end
    
    GUI:setVisible(HeroState._heroBtn, SL:GetValue("HERO_IS_ACTIVE"))
end

function HeroState.OnWindowChange()
    GUI:setPositionY(HeroState._panel, SL:GetValue("SCREEN_HEIGHT") - 26)
end

function HeroState.RegisterEvent()    
    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_HIDESTATUS_CHANGE,     "HeroState", HeroState.OnAssistHideStatusChange)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_FORCE_CHANGE,   "HeroState", HeroState.OnRefreshNGValue)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_INTERNAL_DZVALUE_CHANGE, "HeroState", HeroState.OnRefreshNGValue)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOYAL_CHANGE,            "HeroState", HeroState.OnUpdateLoyal)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LEARNED_INTERNAL,        "HeroState", HeroState.OnShowNGPanel)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SKILL_ADD,               "HeroState", HeroState.OnRefreshDZShow)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_SKILL_DEL,               "HeroState", HeroState.OnRefreshDZShow)

    SL:RegisterLUAEvent(LUA_EVENT_HERO_PROPERTY_CHANGE,         "HeroState", HeroState.OnUpdateProperty)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_REVIVE,                  "HeroState", HeroState.OnRevive)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_DIE,                     "HeroState", HeroState.OnDie)
    
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGIN,                   "HeroState", HeroState.OnHeroLogin)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOGOUT,                  "HeroState", HeroState.OnHeroLogOut)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_LOCK_CHANGE,             "HeroState", HeroState.OnUpdateLockState)

    SL:RegisterLUAEvent(LUA_EVENT_HERO_LEVEL_CHANGE,             "HeroState", HeroState.OnUpdateLevel)
    SL:RegisterLUAEvent(LUA_EVENT_HERO_CALL_BUTTON_SHOW,        "HeroState", HeroState.OnHeroBtnShowOrHide)

    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE,                "HeroState", HeroState.OnWindowChange)
end

HeroState.main()