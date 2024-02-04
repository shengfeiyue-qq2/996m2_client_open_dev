PlayerTitle = {}

function PlayerTitle.main()
    local parent  = GUI:Attach_Parent()
    local attachW = 348
    local attachH = 478

    local TitleUI = GUI:Layout_Create(parent, "TitleUI", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(TitleUI, true)

    -- 当前称号
    local IconBg = GUI:Image_Create(TitleUI, "IconBg", 45, 433, "res/private/title_layer_ui/title_5.png")
    GUI:setAnchorPoint(IconBg, 0.5, 0.5)
    GUI:setVisible(IconBg, false)
    -- 称号图标
    local BtnCurTitle = GUI:Button_Create(IconBg, "BtnCurTitle", 25.5, 26.5, "res/private/title_layer_ui/title_3.png")
    GUI:setAnchorPoint(BtnCurTitle, 0.5, 0.5)

    local NameBg = GUI:Image_Create(IconBg, "NameBg", 70, 29, "res/private/title_layer_ui/title_1.png")
    GUI:setAnchorPoint(NameBg, 0, 0.5)
    local CurTitleName = GUI:Text_Create(IconBg, "CurTitleName", 80, 29, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(CurTitleName, 0, 0.5)

    local titleBg = GUI:Image_Create(IconBg, "titleBg", 155, -32, "res/private/title_layer_ui/title_0.png")
    GUI:setAnchorPoint(titleBg, 0.5, 0.5)

    -- ListView
    local lSize = {
        width  = attachW - 10,
        height = attachH - 128
    }
    local ListView = GUI:ListView_Create(TitleUI, "ListView", 5, 5, lSize.width, lSize.height, 1)

-- [[ ListView item
    local item = GUI:Layout_Create(TitleUI, "item", 0, 0, lSize.width, 60, true)
    GUI:setVisible(item, false)
    -- 线
    local line = GUI:Image_Create(item, "line", 0, 0, "res/public/1900000667.png")
    GUI:setContentSize(line, {width = lSize.width, height = 2})
    -- 图标背景
    local icon_bg = GUI:Image_Create(item, "icon_bg", 40, 30, "res/private/title_layer_ui/title_6.png")
    GUI:setAnchorPoint(icon_bg, 0.5, 0.5)
    -- 称号图标
    local btnTitle = GUI:Button_Create(item, "btnTitle", 40, 30, "res/private/title_layer_ui/title_4.png")
    GUI:setAnchorPoint(btnTitle, 0.5, 0.5)
    -- 称号名字
    local titleName = GUI:Text_Create(item, "titleName", 90, 30, 16, "#FFFFFF", "")
    GUI:setAnchorPoint(titleName, 0, 0.5)
-- ]]
end