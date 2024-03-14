MainNear = {}

MainNear.PLAYER_COUNT  = 15    -- 最多显示15个玩家
MainNear.MONSTER_COUNT = 15    -- 最多显示15个怪物
MainNear.HERO_COUNT    = 15    -- 最多显示15个英雄

MainNear.jobIconPath = {
    "res/private/main/assist/1900012533.png",
    "res/private/main/assist/1900012534.png",
    "res/private/main/assist/1900012535.png"
}
MainNear.heroJobIconPath = {
    "res/private/main/assist/1900012537.png",
    "res/private/main/assist/1900012538.png",
    "res/private/main/assist/1900012539.png"
}
MainNear.titleList = {
    "怪物",
    "人物",
    "英雄"
}
MainNear.monsterIconPath = "res/private/main/assist/1900012536.png"        -- 怪物图标
MainNear.typeBtnCutLine = "res/private/main/assist/near_panel/line.png"    -- 标题按钮分割线

function MainNear.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/main_near_panel")
    MainNear._ui = GUI:ui_delegate(parent)

    local Panel_1 = MainNear._ui["Panel_1"]
    local pSize = GUI:getContentSize(Panel_1)
    -- 显示适配
    GUI:setPosition(Panel_1, SL:GetMetaValue("SCREEN_WIDTH") / 2, SL:GetMetaValue("PC_POS_Y") + pSize.height / 2)

    -- 设置拖拽
    GUI:Win_SetDrag(parent, Panel_1)
end

function MainNear.CreateEnemyCell(parent, data)
    GUI:LoadExport(parent, "main/assist/main_assist_enemy_cell")

    local layout = GUI:getChildByName(parent, "enemy_cell")
    if not layout then
        return
    end
    if not data or not data.actorID then
        return
    end
    GUI:removeFromParent(layout)

    local actorID      = data.actorID
    local ui           = GUI:ui_delegate(layout)
    local textName     = ui.Text_name
    local imageName    = ui.Image_name
    local imageIcon    = ui.Image_icon
    local imageTarget  = ui.Image_target
    local loadingBarHp = ui.LoadingBar_hp

    if textName then
        GUI:removeAllChildren(textName)
        local actorName = SL:GetMetaValue("ACTOR_NAME", actorID)
        if actorName and SL:GetUTF8ByteLen(actorName) > 7 then
            GUI:Text_setString(textName, "")
            local scrollLabel = GUI:ScrollText_Create(textName, "scrollText", 0, 0, 115, SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"), "#FFFFFF", actorName)
            GUI:setAnchorPoint(scrollLabel, 0.5, 0.5)
        else
            GUI:Text_setString(textName, actorName)
        end
    end

    local curHP = SL:GetMetaValue("ACTOR_HP", actorID)
    local maxHP = SL:GetMetaValue("ACTOR_MAXHP", actorID)
    local percent = math.floor((curHP / maxHP * 100))
    if loadingBarHp then
        GUI:LoadingBar_setPercent(loadingBarHp, percent)
    end

    if imageIcon then
        if SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) then
            local job = SL:GetMetaValue("ACTOR_JOB_ID", actorID)
            if SL:GetMetaValue("ACTOR_IS_HERO", actorID) then
                if MainNear.heroJobIconPath then
                    GUI:Image_loadTexture(imageIcon, MainNear.heroJobIconPath[job + 1])
                end
            else
                if MainNear.jobIconPathh then
                    GUI:Image_loadTexture(imageIcon, MainNear.jobIconPath[job + 1])
                end
            end
        else
            GUI:Image_loadTexture(imageIcon, MainNear.monsterIconPath)
        end
    end

    if imageTarget then
        GUI:setVisible(imageTarget, SL:GetMetaValue("SELECT_TARGET_ID") == actorID)
    end

    local function openFuncDock(touchPos)
        local DOCKTYPE_NENUM = SL:GetMetaValue("DOCKTYPE_NENUM")
        local data = {
            type        = SL:GetMetaValue("ACTOR_IS_HUMAN", actorID) and DOCKTYPE_NENUM.Func_Monster_Head or DOCKTYPE_NENUM.Func_Player_Head,
            targetId    = SL:GetMetaValue("ACTOR_ID", actorID),
            targetName  = SL:GetMetaValue("ACTOR_NAME", actorID),
            isHero      = SL:GetMetaValue("ACTOR_IS_HERO", actorID), 
            pos         = {x = touchPos.x + 15, y = touchPos.y}
        }
        SL:OpenFuncDockTips(data)
    end

    GUI:addOnClickEvent(layout, function(sender)
        SL:SetMetaValue("SELECT_TARGET_ID", actorID)

        if SL:GetMetaValue("ACTOR_IS_MONSTER", actorID) then
            local mapID = SL:GetMetaValue("MAP_ID")
            local posX = SL:GetMetaValue("ACTOR_MAP_X", actorID)
            local posY = SL:GetMetaValue("ACTOR_MAP_Y", actorID)
            SL:SetMetaValue("BATTLE_MOVE_BEGIN", mapID, posX, posY, nil, GUIDefine.AUTO_MOVE_TYPE.TARGET)
        end

        if SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) and not SL:GetMetaValue("WINPLAYMODE") then
            local touchPos = GUI:getTouchEndPosition(sender)
            openFuncDock(touchPos)
        end
    end)

    local function downRightBtnFunc(touchPos)
        if SL:GetMetaValue("ACTOR_IS_PLAYER", actorID) then
            openFuncDock(touchPos)
        end
    end
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseButtonEvent(layout, {
            onRightDownFunc = downRightBtnFunc,
            needTouchPos = true
        })
    end

    GUI:setVisible(layout, true)

    return {
        data         = data,
        layout       = layout,
        textName     = textName,
        imageTarget  = imageTarget,
        loadingBarHp = loadingBarHp,
    }
end