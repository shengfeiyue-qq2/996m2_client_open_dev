TradePlayerBestRing = {}

function TradePlayerBestRing.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local ww = 353
    local hh = 325

    local _ResPath = "res/private/player_best_rings_ui/player_best_rings_ui_mobile/"

    -- 容器
    local BestRingUI = GUI:Layout_Create(parent, "BestRingUI", screenW/2, screenH/2, ww, hh)
    GUI:setAnchorPoint(BestRingUI, {x=0.5, y=0.5})
    GUI:setTouchEnabled(BestRingUI, true)
    GUI:Win_SetDrag(parent, BestRingUI)
    
    if SL:IsWinMode() then
        GUI:setMouseEnabled(BestRingUI, true)
    end

    -- 背景图
    local FrameBG = GUI:Image_Create(BestRingUI, "FrameBG", 0, 0, _ResPath.."bg_jewelry_1.png")
    GUI:setContentSize(FrameBG, {width = ww, height = hh})

    -- 线
    local line = GUI:Image_Create(BestRingUI, "line", ww/2, hh - 45, "res/public/word_sxbt_05.png")
    GUI:setAnchorPoint(line, {x=0.5, y=0.5})

    -- 标题
    local ImageTitle = GUI:Image_Create(BestRingUI, "ImageTitle", ww/2, hh - 45, _ResPath.."word_jewelry_1.png")
    GUI:setAnchorPoint(ImageTitle, {x=0.5, y=0.5})

    -- 关闭按钮
    local CloseButton = GUI:Button_Create(BestRingUI, "CloseButton", ww, hh, "res/public/1900000510.png")
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setAnchorPoint(CloseButton, {x=0, y=1})
    GUI:setTouchEnabled(CloseButton, true)

    local PanelItems = GUI:Layout_Create(BestRingUI, "PanelItems", 30.5, 25, 292, 219, true)
    local PanelTouch = GUI:Layout_Create(BestRingUI, "PanelTouch", 30.5, 25, 292, 219, true)

    local matrixs = {
        {
            {index = 0, x = 35, y = 185}, {index = 1, x = 108, y = 185}, {index = 2, x = 182, y = 185},{index = 3, x = 255, y = 185}
        },
        {
            {index = 4, x = 35, y = 110}, {index = 5, x = 108, y = 110}, {index = 6, x = 182, y = 110},{index = 7, x = 255, y = 110}
        },
        {
            {index = 8, x = 35, y = 35}, {index = 9, x = 108, y = 35}, {index = 10, x = 182, y = 35},{index = 11, x = 255, y = 35}
        }
    }
    for r,tab in ipairs(matrixs) do
        for c,v in ipairs(tab) do
            local idx = v.index
            local x = v.x
            local y = v.y
            local icBg = GUI:Image_Create(PanelItems, "icBg"..idx, x, y, "res/public/1900000651.png")
            local icon = GUI:Image_Create(PanelItems, "icon"..idx, x, y, string.format("%s%s%s.png", _ResPath, "word_shengxiao_", (idx + 1)))
            local Node = GUI:Node_Create(PanelItems, "Node"..idx, x, y)
            GUI:setAnchorPoint(icBg, 0.5, 0.5)
            GUI:setAnchorPoint(icon, 0.5, 0.5)
            GUI:setAnchorPoint(Node, 0.5, 0.5)
            GUI:setVisible(icon, false)
        end
    end
end