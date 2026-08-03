PreloadProgress = {}

-- 进度条资源
PreloadProgress._bgPath       = "localres/preload/load_bg.png"
PreloadProgress._progressPath = "localres/preload/load_progress.png"

function PreloadProgress.main()
    PreloadProgress._winID = UIConst.LAYERID.PreloadProgressGUI or "PreloadProgressGUI"
    if GUI:GetWindow(nil, PreloadProgress._winID) then
        return
    end

    -- 已加载完成则不显示
    if GUIPreload and GUIPreload._loadCompleted then
        return
    end

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    local parent = GUI:Win_Create(PreloadProgress._winID, 0, 0, 0, 0, false, false, false, false, nil, nil, GUIDefine.UIZ.MASK)
    PreloadProgress._layer = parent

    local panel = GUI:Layout_Create(parent, "Panel_preload_root", 0, 0, screenW, screenH)

    local slider = GUI:Slider_Create(panel, "Slider_preload", 0, screenH, PreloadProgress._bgPath, PreloadProgress._progressPath, "")
    GUI:setAnchorPoint(slider, 0, 1)
    local sliderSize = GUI:getContentSize(slider)
    GUI:Image_setScale9Slice(slider, 2, 2, 1, 1)
    GUI:setContentSize(slider, screenW, sliderSize.height)
    GUI:setTouchEnabled(slider, false)

    PreloadProgress._slider = slider

    -- 初始进度
    local curProgress = (GUIPreload and GUIPreload._loadProgress) or 0
    PreloadProgress.SetProgress(curProgress)


    PreloadProgress.RegisterEvent()
end

function PreloadProgress.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_GUI_PRELOAD_PROGRESS,  "PreloadProgress", PreloadProgress.OnProgressChange,  PreloadProgress._layer)
    SL:RegisterLUAEvent(LUA_EVENT_GUI_PRELOAD_COMPLETED, "PreloadProgress", PreloadProgress.OnCompleted, PreloadProgress._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN,              "PreloadProgress", PreloadProgress.OnCloseWin)
end

function PreloadProgress.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_GUI_PRELOAD_PROGRESS,  "PreloadProgress")
    SL:UnRegisterLUAEvent(LUA_EVENT_GUI_PRELOAD_COMPLETED, "PreloadProgress")
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN,              "PreloadProgress")
end

function PreloadProgress.SetProgress(progress)
    if not PreloadProgress._slider then
        return
    end
    progress = tonumber(progress) or 0
    progress = math.max(progress, 0)
    progress = math.min(progress, 100)
    GUI:Slider_setPercent(PreloadProgress._slider, progress)
end

function PreloadProgress.OnProgressChange(progress)
    PreloadProgress.SetProgress(progress)
end

function PreloadProgress.OnCompleted(isCompleted)
    if not isCompleted then
        return
    end

    PreloadProgress.Close()
end

function PreloadProgress.OnCloseWin(id)
    if id == PreloadProgress._winID then
        PreloadProgress.UnRegisterEvent()
        PreloadProgress._layer = nil
        PreloadProgress._slider = nil
    end
end

function PreloadProgress.Close()
    GUI:Win_CloseByID(PreloadProgress._winID)
end

PreloadProgress.main()
