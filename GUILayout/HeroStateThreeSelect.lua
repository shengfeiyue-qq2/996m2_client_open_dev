HeroStateThreeSelect = {}

function HeroStateThreeSelect.main()
    local parent  = GUI:Attach_Parent()
    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()
    local _PathRes = "res/private/player_hero/"

    -- 全屏
    local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(CloseLayout, true)

    local Image_bg = GUI:Image_Create(parent, "Image_bg", 0, 0, _PathRes .. "btn_heji_03_3.png")
    GUI:setAnchorPoint(Image_bg, 0.5, 0.5)
    local Text0 = GUI:Text_Create(Image_bg, "Text0", 60, 60, 18, "#FFFFFF", "战斗")
    GUI:setAnchorPoint(Text0, 0.5, 0.5)

    local tbs_bgs = {
        {x = 32, y = 77, angle = -120},     -- 左上
        {x = 89, y = 75, angle = 0},        -- 右上
        {x = 58, y = 27.5, angle = 120},    -- 下
    }

    local tbs_touchs = {
        {x = 23, y = 78, angle = -144},     -- 左上
        {x = 89, y = 78, angle = -34},      -- 右上
        {x = 60, y = 20, angle = 90},       -- 下
    }

    local path = _PathRes .. "btn_heji_04_3.png"
    for i=1,3 do
        local tb1 = tbs_bgs[i]
        local tb2 = tbs_touchs[i]

        local TouchBg = GUI:Image_Create(Image_bg, "TouchBg"..i, tb1.x, tb1.y, path)
        GUI:setAnchorPoint(TouchBg, 0.5, 0.5)
        GUI:setRotation(TouchBg, tb1.angle)
        GUI:setRotationSkewX(TouchBg, tb1.angle)
        GUI:setRotationSkewY(TouchBg, tb1.angle)

        local Text = GUI:Text_Create(Image_bg, "Text"..i, tb2.x, tb2.y, 18, "#FFFFFF", "战斗")
        GUI:setAnchorPoint(Text, 0.5, 0.5)

        local Touch = GUI:Layout_Create(Image_bg, "Touch"..i, tb2.x, tb2.y, 37, 81, true)
        GUI:setAnchorPoint(Touch, 0.5, 0.5)
        GUI:setRotation(Touch, tb2.angle)
        GUI:setRotationSkewX(Touch, tb2.angle)
        GUI:setRotationSkewY(Touch, tb2.angle)
        GUI:setTouchEnabled(Touch, true)
    end
end