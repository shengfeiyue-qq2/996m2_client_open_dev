MainTop = {}

function MainTop.main()
    local parent = GUI:Attach_MainTop()

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 背景图
    local Image_top_bg = GUI:Image_Create(parent, "Image_top_bg", 0, 0, "res/private/main/1900012013.png")
    GUI:setAnchorPoint(Image_top_bg, {x=0, y=1})
    GUI:setContentSize(Image_top_bg, {width=screenW, height=30})
    MainTop.Image_top_bg = Image_top_bg

    -- 装饰箭头
    local Image_arrow = GUI:Image_Create(parent, "Image_top_arrow", 40, -25, "res/private/main/1900012014.png")
end

function MainTop.onAdapetSize(rect)
    local oldSize = GUI:getContentSize(MainTop.Image_top_bg)
    local width   = SL:GetScreenWidth()
    local height  = oldSize.height
    local xx = rect.width - width
    GUI:setPositionX(MainTop.Image_top_bg, xx)
    GUI:setContentSize(MainTop.Image_top_bg, width, height)
end