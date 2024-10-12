MainTop = {}

function MainTop.main()
    local parent = GUI:Attach_Bottom()
    GUI:LoadExport(parent, "main/main_top")

    MainTop._root = GUI:getChildByName(parent, "Main_Top")
    MainTop._ui = GUI:ui_delegate(MainTop._root)
    if not MainTop._ui then
        return false
    end

    SL:RegisterLUAEvent(LUA_EVENT_WINDOW_CHANGE, "MainTop", MainTop.OnWindowChange)

    -- 自适应布局
    MainTop.InitAdapt()
end

function MainTop.InitAdapt()
    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    local topH = GUI:getContentSize().height

    GUI:setPosition(MainTop._root, 0, screenH)
    GUI:setContentSize(MainTop._root, screenW, topH)

    -- 背景图
    local Image_1 = MainTop._ui["Image_1"]
    GUI:setPosition(Image_1, 0, topH)
    GUI:setContentSize(Image_1, screenW, topH)
end

function MainTop.OnWindowChange()
    MainTop.InitAdapt()
end

MainTop.main()