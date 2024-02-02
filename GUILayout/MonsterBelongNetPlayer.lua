MonsterBelongNetPlayer = {}

function MonsterBelongNetPlayer.main(data)
    data = data or {}
    local parent = data.parent
    GUI:LoadExport(parent, "main_monster/monster_belong_netplayer")

    MonsterBelongNetPlayer._ui = GUI:ui_delegate(parent)

    local scrollText = GUI:ScrollText_Create(MonsterBelongNetPlayer._ui.Text_name, "scrollText", 0, 0, 55, 13, "#FFFFFF", "")
    GUI:ScrollText_setHorizontalAlignment(scrollText, 2)
    GUI:ScrollText_enableOutline(scrollText, "#111111", 1)
    GUI:setAnchorPoint(scrollText, 0.5, 0.5)
    MonsterBelongNetPlayer._scrollNameText = scrollText
end

--- 更新头像UI
---@param iconPath string 图片资源地址
function MonsterBelongNetPlayer.UpdateUIIcon(iconPath)
    GUI:Image_loadTexture(MonsterBelongNetPlayer._ui.Image_icon, iconPath)
end

--- 更新名字UI
---@param name string 名字
function MonsterBelongNetPlayer.UpdateUIName(name)
    GUI:ScrollText_setString(MonsterBelongNetPlayer._scrollNameText, name or "")
end
