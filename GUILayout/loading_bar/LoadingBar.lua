LoadingBar = {}

function LoadingBar.main()
    local data = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.LoadingBarGUI, 0, 0, 0, 0, false, false, false, false, nil, nil, GUIDefine.UIZ.MASK)
    GUI:LoadExport(parent, "loading/loadingbar.lua")
    LoadingBar._ui = GUI:ui_delegate(parent)
    LoadingBar._imageBar = LoadingBar._ui["Image_bar"]
    GUI:setPosition(LoadingBar._imageBar, { x = SL:GetValue("SCREEN_WIDTH") / 2, y = SL:GetValue("SCREEN_HEIGHT") / 2 })

    LoadingBar.InitBar(data)
end

function LoadingBar.InitBar(delayTime)
    GUI:stopAllActions(LoadingBar._imageBar)

    GUI:runAction(LoadingBar._imageBar, GUI:ActionSequence(GUI:ActionHide(), GUI:DelayTime(0.1), GUI:ActionShow()))
    GUI:runAction(LoadingBar._imageBar, GUI:ActionRepeatForever(GUI:ActionSequence(GUI:DelayTime(0.04), GUI:ActionRotateBy(0, 30))))

    if delayTime then
        local function callback()
            UIOperator:CloseLoadingBarUI()
        end
        GUI:runAction(LoadingBar._imageBar, GUI:ActionSequence(GUI:DelayTime(delayTime), GUI:CallFunc(callback)))
    end
end

LoadingBar.main()
