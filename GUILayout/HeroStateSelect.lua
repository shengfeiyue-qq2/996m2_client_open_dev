HeroStateSelect = {}

function HeroStateSelect.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local _PathRes = "res/private/player_hero/"

    -- 全屏
    local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(CloseLayout, true)

    local Image_bg = GUI:Image_Create(parent, "Image_bg", 0, 0, _PathRes .. "btn_heji_03.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    local Text0 = GUI:Text_Create(Image_bg, "Text0", 60, 60, 18, "#FFFFFF", "战斗")
    GUI:setAnchorPoint(Text0, 0.5, 0.5)

    local tbs = {
        {x = 31, y = 89, angle = -90},  -- 左上
        {x = 89, y = 89, angle = 0},    -- 右上
        {x = 89, y = 31, angle = 90},   -- 右下
        {x = 31, y = 31, angle = -180}  -- 左下
    }

    local path = _PathRes .. "btn_heji_04.png"
    for i=1,4 do
        local t = tbs[i]
        local x, y, angle = t.x, t.y, t.angle

        local TouchBg = GUI:Image_Create(Image_bg, "TouchBg"..i, x, y, path)
        GUI:setAnchorPoint(TouchBg, 0.5, 0.5)
        GUI:setRotation(TouchBg, angle)
        GUI:setRotationSkewX(TouchBg, angle)
        GUI:setRotationSkewY(TouchBg, angle)
        
        local Text = GUI:Text_Create(Image_bg, "Text"..i, x, y, 18, "#FFFFFF", "战斗")
        GUI:setAnchorPoint(Text, 0.5, 0.5)

        local Touch = GUI:Layout_Create(Image_bg, "Touch"..i, x, y, 55, 55, true)
        GUI:setAnchorPoint(Touch, 0.5, 0.5)
        GUI:setTouchEnabled(Touch, true)
    end
end