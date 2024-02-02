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

function MainNear.CreateEnemyCell(parent)
    GUI:LoadExport(parent, "main/assist/main_assist_enemy_cell")
end