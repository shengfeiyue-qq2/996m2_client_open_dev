HeroBag = {}

function HeroBag.main()
    local parent = GUI:Attach_Parent()
    local isWin32 = SL:GetMetaValue("WINPLAYMODE")
    GUI:LoadExport(parent, isWin32 and "bag_hero/herobag_panel_win32" or "bag_hero/herobag_panel")

    HeroBag._ui = GUI:ui_delegate(parent)

    -- 初始化数据
    HeroBag._Col     = 5                        -- 列数
    HeroBag._IWidth  = isWin32 and 43 or 63     -- item 宽
    HeroBag._IHeight = isWin32 and 43 or 63     -- item 高
    HeroBag._LevelBgImgWithMaxBagNum = {        -- 不同等级的背景图片
        [10] = isWin32 and "res/private/bag_ui_hero_win32/bg1.png" or "res/private/bag_ui_hero/bg1.png",
        [20] = isWin32 and "res/private/bag_ui_hero_win32/bg2.png" or "res/private/bag_ui_hero/bg2.png",
        [30] = isWin32 and "res/private/bag_ui_hero_win32/bg3.png" or "res/private/bag_ui_hero/bg3.png",
        [35] = isWin32 and "res/private/bag_ui_hero_win32/bg4.png" or "res/private/bag_ui_hero/bg4.png",
        [40] = isWin32 and "res/private/bag_ui_hero_win32/bg5.png" or "res/private/bag_ui_hero/bg5.png",
    }

    -- 界面拖动
    GUI:Win_SetDrag(parent, HeroBag._ui["Panel_1"])

    GUI:addOnClickEvent(HeroBag._ui["Button_close"], function()
        SL:CloseHeroBagUI()
    end)

    -- 存入人物背包
    HeroBag._changeMode = false
    local Button_store_human_bag = HeroBag._ui["Button_store_human_bag"]
    GUI:addOnClickEvent(Button_store_human_bag, function()
        local changeMode = not HeroBag._changeMode
        HeroBag._changeMode = changeMode
        GUI:Button_setGrey(Button_store_human_bag, changeMode)
    end)
end