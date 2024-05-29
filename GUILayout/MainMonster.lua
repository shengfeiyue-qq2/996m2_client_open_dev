-- 怪物大血条
MainMonster = {}

function MainMonster.main(data)
    data = data or {}
    local parent = data.parent
    GUI:LoadExport(parent, "main_monster/main_monster_node")

    GUI:setPositionX(parent, -197, 0)
    MainMonster._ui = GUI:ui_delegate(parent)
    local size = SL:GetMetaValue("WINPLAYMODE") and 12 or 16

    local scrollText = GUI:ScrollText_Create(MainMonster._ui.Text_belong_name, "scrollText", 45, 0, 94, size, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)
    MainMonster._belongScrollNameText = scrollText

    local scrollText1 = GUI:ScrollText_Create(MainMonster._ui.Text_monster_name, "scrollText1", 84, 0, 162, size, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText1, 2)
    GUI:ScrollText_enableOutline(scrollText1, "#111111", 1)
    GUI:setAnchorPoint(scrollText1, 0.5, 0.5)
    MainMonster._monsterScrollNameText = scrollText1
end

--- 刷新UI 头像
---@param imgPath string 头像图片地址
function MainMonster.UpdateUIIcon(imgPath)
    local iconImage = MainMonster._ui.Image_icon
    GUI:Image_loadTexture(iconImage, imgPath)
end

--- 刷新UI
---@param hpPercent number 血量百分比
function MainMonster.UpdateUIHp(hpPercent)
    hpPercent = hpPercent or 0
    local hpText = MainMonster._ui.Text_hp
    GUI:Text_setString(hpText, hpPercent .. "%")
end

--- 刷新UI  归属名
---@param data table 归属数据
function MainMonster.UpdateBelongName(name)
    GUI:ScrollText_setString(MainMonster._belongScrollNameText, name or "")
    local Text = GUI:getChildByName(MainMonster._belongScrollNameText, "Text")
    if Text and GUI:getContentSize(Text).width < 94 then
        GUI:setPositionX(MainMonster._belongScrollNameText, GUI:getContentSize(Text).width / 2 - 2)
    else
        GUI:setPositionX(MainMonster._belongScrollNameText, 45)
    end
end

--- 刷新UI 怪物名字
---@param name string 名字
function MainMonster.UpdateUIName(name)
    GUI:ScrollText_setString(MainMonster._monsterScrollNameText, name or "")
end

--- 刷新UI 怪物等级
---@param actor userdata actor对象
function MainMonster.UpdateUILevel(level)
    level = level or ""
    GUI:Text_setString(MainMonster._ui.Text_lv, "LV." .. level)
end

--- 刷新UI 当前血条数
---@param tube number 血条数
function MainMonster.UpdateUIHpTip(tube)
    tube = tube or 0
    local hpTipText = MainMonster._ui.Text_hp_tip
    GUI:Text_setString(hpTipText, "X " .. tube)
end
