MainCollect = {}

local mItemPath = {"res/private/main/Target/1900012536.png", "res/private/main/Target/1900012531.png"}

local mPrvPathRes = "res/private/"

function MainCollect.main(parent)
    if not parent then
        return
    end
    GUI:LoadExport(parent, "main/collect/collect")

    MainCollect._ui = GUI:ui_delegate(parent)

    local MainCollectSelectParent = MainCollect._ui["Panel_1"]
    -- 底图
    local Layout_bg = GUI:Layout_Create(MainCollectSelectParent, "Layout_BG", 68, 50, 200, 120)
    GUI:Layout_setBackGroundImageScale9Slice(Layout_bg, 44, 44, 57, 57)
    GUI:Layout_setBackGroundImage(Layout_bg, mPrvPathRes .. "item_tips/bg_tipszy_05.png")
    GUI:setAnchorPoint(Layout_bg, 0, 0)
    GUI:setTouchEnabled(Layout_bg, false)

    -- ListView容器
    local ListView_select = GUI:ListView_Create(MainCollectSelectParent, "List_Collect_Select", 68, 50, 200, 120, 1)
    GUI:setAnchorPoint(ListView_select, 0, 0)
    GUI:ListView_setItemsMargin(ListView_select, 3)

    -- ListView容器的item
    local Layout_item = GUI:Layout_Create(MainCollectSelectParent, "Layout_Item", 0, 0, 200, 40)
    GUI:setAnchorPoint(Layout_item, 0, 0)
    GUI:setTouchEnabled(Layout_item, true)
    GUI:setVisible(Layout_item, false)

    -- 头像图片
    local Image_icon = GUI:Image_Create(Layout_item, "Image_Icon", 10, 20, mItemPath[1])
    GUI:setAnchorPoint(Image_icon, 0, 0.5)
    GUI:setTouchEnabled(Image_icon, false)

    -- 名字背景图片
    local Image_name_bg = GUI:Image_Create(Layout_item, "Image_Name_Bg", 50, 20, mItemPath[2])
    GUI:setAnchorPoint(Image_name_bg, 0, 0.5)
    GUI:setTouchEnabled(Image_name_bg, false)

    -- 名字
    local Text_name = GUI:Text_Create(Layout_item, "Text_Name", 116, 20, 15, "#FFFFFF", "")
    GUI:setAnchorPoint(Text_name, 0.5, 0.5)
end
