-- 英雄状态面板 挂在左下角
HeroState = {}
HeroState._ui = nil

function HeroState.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "hero/hero_state_node")

    HeroState._ui = GUI:ui_delegate(parent)
    if not HeroState._ui then
        return
    end

    HeroState.isWinPlayMode = SL:GetMetaValue("WINPLAYMODE")

    -- 适配
    GUI:setPositionY(HeroState._ui["Panel_1"], SL:GetMetaValue("SCREEN_HEIGHT") - 26)

    HeroState._originalPos = GUI:getPosition(HeroState._ui["Panel_1"])

    HeroState.InitUI()

    SL:RegisterLUAEvent(LUA_EVENT_ASSIST_HIDESTATUS_CHANGE, "HeroState", HeroState.onAssistHideStatusChange)
end

function HeroState.InitUI(data)
    GUI:setVisible(HeroState._ui.Text_state, false)
    --背包
    GUI:addOnClickEvent(HeroState._ui.Button_bag,function()
        if SL:GetMetaValue("HERO_IS_ALIVE") then
            SL:OpenHeroBagUI()
        end
    end)
    --状态
    GUI:addOnClickEvent(HeroState._ui.Button_state,function()
        SL:OpenMyPlayerHeroUI({ extent = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP })
    end)
    --召唤收回
    GUI:addOnClickEvent(HeroState._ui.Button_hero,function()
        GUI:setClickDelay(HeroState._ui.Button_hero, 0.5)
        SL:RequestCallOrOutHero()
    end)
    if HeroState.isWinPlayMode then
        GUI:setVisible(HeroState._ui.Button_bag, false)
        GUI:setVisible(HeroState._ui.Button_state, false)
        GUI:setVisible(HeroState._ui.Button_hero, false)
    end
    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_bag, true)
    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_state, true)
    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_hero, true)

    --------点击显示英雄信息
    GUI:addOnClickEvent(HeroState._ui.Panel_info, function()
        local str = ""
        local maxHp =   SL:GetMetaValue("H.MAXHP") 
        local curHp = SL:GetMetaValue("H.HP") 
        local maxMp = SL:GetMetaValue("H.MAXMP")
        local curMp = SL:GetMetaValue("H.MP")
        local curExp = SL:GetMetaValue("H.EXP")
        local maxExp = SL:GetMetaValue("H.MAXEXP")

        str = string.format("体力值:%s魔法值:%s经验值:%s", 
        (SL:HPUnit(curHp) .. "/" .. SL:HPUnit(maxHp) .. "\\"),
        (curMp .. "/" .. maxMp .. "\\"),
        (curExp .. "/" .. maxExp .. "\\"))
        local pos = GUI:getWorldPosition(HeroState._ui.Panel_info)
        pos.x = pos.x + 5
        SL:OpenCommonDescTipsPop({ str = str, worldPos = pos, width = 440, anchorPoint = GUI:p(0, 1)} )
    end)

    -----------
    GUI:setVisible(HeroState._ui.Panel_1, false)
    if not HeroState.isWinPlayMode then
        local heroBtnShow = false
        if  SL:GetMetaValue("USEHERO") and SL:GetMetaValue("HERO_IS_ACTIVE") then
            heroBtnShow = true
        end
        GUI:setVisible(HeroState._ui.Button_hero, heroBtnShow)
        
        local OptSet = SL:GetMetaValue("GAME_DATA","Heroqiehuanmoshi") or 0 -- 操作模式
        local node = HeroState._ui.Image_state
        local originPos = GUI:getWorldPosition(node)
        local longTime = 0.5 --长按时间
        if OptSet == 0 then --滑动模式
            local longCallBack = function() --长按
                --打开英雄状态选择界面 mode--1选择状态 2单击切换  3不能点击,滑动
                SL:OpenHeroStateSelectUI( { pos = originPos, mode = 3 })
            end
            local shortCallBack = function() --短按
                SL:OpenHeroStateSelectUI( { pos = originPos, mode = 2 })
            end
            
            local long = false --长按状态
            GUI:addOnTouchEvent(node, function(sender, type)
                if type == SLDefine.TouchEventType.began then
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
                elseif type == SLDefine.TouchEventType.moved then
                    if long then
                        local movePos = GUI:getTouchMovePosition(sender)
                        local sys =  SL:GetMetaValue("HERO_STATES_SYS_VALUES")--英雄状态系统 能设置的值3个或四个
                        local isthree = #sys ~= 4
                        local index = 0 --指向的选项
                        if isthree then --三个方向的
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
                        else--4个方向的
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
                            HeroStateSelect.refSelect( { index = index })
                        end
                    end
                elseif type == SLDefine.TouchEventType.ended then
                    if node._clicking then  --未触发长按触发短按
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
                elseif type == 3 then --长按松开
                    long = false
                    HeroStateSelect.refSelect( { index = -1 })
                end
            end)
        else--双击模式
            local clickCallBack = function()--单击
                repeat
                    local states = SL:GetMetaValue("HERO_ACTIVES_STATES")  --英雄激活的状态
                    local curstate = 0
                    --守护状态
                    if SL:GetMetaValue("HERO_GUARDSTATE") then
                        curstate = 3
                    else
                        local state = SL:GetMetaValue("HERO_STATE")--英雄状态
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
                            SL:OpenHeroStateSelectUI( { pos = originPos, mode = 1 })
                            break
                        end
                    end
                    local tag = states[idx]
                    local state = SL:GetMetaValue("HERO_GUARD_ISCLICK")--是否点击了  守护按钮
                    if tag < 3 then
                        if state then--要先取消守护点击状态
                            SL:SetMetaValue("HERO_GUARD_ISCLICK", false)
                        end
                        --切换英雄状态
                        SL:RequestChangeHeroMode(tag)
                    elseif tag == 3 then -- 守护
                        SL:SetMetaValue("HERO_GUARD_ISCLICK", not state)
                    end
                until true
            end
            local doubleClickCallBack = function()--长按
                SL:OpenHeroStateSelectUI( { pos = originPos, mode = 1 })
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
                        end, SLDefine.CLICK_DOUBLE_TIME)
                    end
                end
            end)
        end
    else
        local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
        GUI:setPosition(HeroState._ui.Panel_1, 250, screenH - 10)
    end
    ---------------点头像------------------------------------
    GUI:setTouchEnabled(HeroState._ui.Image_head, true)
    GUI:addOnClickEvent(HeroState._ui.Image_head,function()
        SL:OpenMyPlayerHeroUI({ extent = SLDefine.PlayerPage.MAIN_PLAYER_LAYER_EQUIP })
    end)

end

--英雄死亡触发
function HeroState.Hero_Die(b)
    if b then
        GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_1, 0)
        GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_2, 0)
        GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_3, 0)
        GUI:Image_setGrey(HeroState._ui.Image_head, true)
    else
        GUI:Image_setGrey(HeroState._ui.Image_head, false)
    end
end
--英雄属性改变 触发
function HeroState.refProperty()
    if not SL:GetMetaValue("HERO_IS_ALIVE")  then
        return
    end
    local name = SL:GetMetaValue("H.USERNAME") 
    local nameColor = SL:GetMetaValue("HERO_NAME_COLOR") 
    local HPPercent = SL:GetMetaValue("H.HPPercent")
    local MPPercent = SL:GetMetaValue("H.MPPercent")
    local EXPPercent = SL:GetMetaValue("H.EXPPercent")
    local level = SL:GetMetaValue("H.LEVEL")
    local sex = SL:GetMetaValue("H.SEX") 
    local job = SL:GetMetaValue("H.JOB")   
    local HeroLuck = SL:GetMetaValue("H.LUCK") --忠诚度
    if HPPercent == 0 then -- 死了跳过 
        return
    end
    local path = "0121" .. (job + 3 * (1 - sex)) .. ".png"
    local namestrs = string.split(name, "\\")
    GUI:Text_setString(HeroState._ui.Text_name, namestrs[1])
    SL:SetColorStyle(HeroState._ui.Text_name, nameColor)
    GUI:Text_setString(HeroState._ui.Text_level,level)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_1, HPPercent)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_2, MPPercent)
    GUI:LoadingBar_setPercent(HeroState._ui.LoadingBar_3, EXPPercent)
    GUI:Image_loadTexture( HeroState._ui.Image_head, SLDefine.PATH_RES_PRIVATE .. "player_hero/" .. path)

    GUI:Text_setString(HeroState._ui.Text_z, string.format("%0.2f%%", HeroLuck / 10))
end

--刷新等级
function HeroState.refLevel()
    if not SL:GetMetaValue("HERO_IS_ACTIVE")  then
        return
    end
    local level = SL:GetMetaValue("H.LEVEL")
    GUI:Text_setString(HeroState._ui.Text_level,level)
end
--英雄召唤 触发
function HeroState.HeroLogin()
    GUI:setVisible( HeroState._ui.Panel_1, true)
    HeroState.Hero_Die(false)
    HeroState.refProperty()

    local normal = SLDefine.PATH_RES_PRIVATE .. "player_hero/btn_loginout1.png"
    local select = SLDefine.PATH_RES_PRIVATE .. "player_hero/btn_loginout2.png"
    GUI:Button_loadTextureNormal(HeroState._ui.Button_hero,normal)
    GUI:Button_loadTexturePressed(HeroState._ui.Button_hero,select)
    
    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_hero, true)
end
--英雄收回 触发
function HeroState.HeroLogOut()
    GUI:setVisible( HeroState._ui.Panel_1, false)

    local normal = SLDefine.PATH_RES_PRIVATE .. "player_hero/btn_login1.png"
    local select = SLDefine.PATH_RES_PRIVATE .. "player_hero/btn_login2.png"
    GUI:Button_loadTextureNormal(HeroState._ui.Button_hero,normal)
    GUI:Button_loadTexturePressed(HeroState._ui.Button_hero,select)

    GUI:setIgnoreContentAdaptWithSize(HeroState._ui.Button_hero, true)
end
--召唤按钮显示与否
function HeroState.HeroBtnShowOrHide(isshow)
    if SL:GetMetaValue("USEHERO") then
        GUI:setVisible(HeroState._ui.Button_hero, isshow)
    end
end
--状态 改变触发
function HeroState.refState()
    GUI:setVisible(HeroState._ui.Text_state, true)
    local stateStr = ""
    if SL:GetMetaValue("HERO_GUARDSTATE") then
        stateStr = "守护"
    else
        local state = SL:GetMetaValue("HERO_STATE") 
        state = tonumber(state)
        local showStrs = { "战斗", "跟随", "休息"}
        stateStr = showStrs[state+1]
    end
    GUI:Text_setString(HeroState._ui.Text_state, stateStr)
end

function HeroState.onAssistHideStatusChange(data)
    local isOpen = (tonumber(SL:GetMetaValue("GAME_DATA", "HeroStateHideWithAssist")) or 0) == 1
    if not isOpen then
        GUI:Timeline_EaseSineIn_MoveTo(HeroState._ui.Panel_1, HeroState._originalPos, 0.2)
        return
    end

    GUI:stopAllActions(HeroState._ui.Panel_1)
    if data.bHide then
        GUI:Timeline_EaseSineIn_MoveTo(HeroState._ui.Panel_1, {x = HeroState._originalPos.x - data.assistSize.width, y = HeroState._originalPos.y}, 0.2)
    else
        GUI:Timeline_EaseSineIn_MoveTo(HeroState._ui.Panel_1, HeroState._originalPos, 0.2)
    end
end