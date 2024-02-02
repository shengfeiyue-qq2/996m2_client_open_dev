ProgressBar = {}

function ProgressBar.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "progress_bar") 
    
    ProgressBar._ui = GUI:ui_delegate(parent)

    ProgressBar._parent = parent
    ProgressBar._data = data
    ProgressBar.startProgress()
end

function ProgressBar.startProgress()
    GUI:Text_setFontSize(ProgressBar._ui.Text_desc, SL:GetMetaValue("GAME_DATA","DEFAULT_FONT_SIZE") or 16)
    GUI:stopAllActions(ProgressBar._ui.Text_desc)
    GUI:stopAllActions(ProgressBar._ui.LoadingBar_1)

    local elasped = 0
    local percent = 0
    local function callback()
        percent = math.min(100, math.ceil(elasped / ProgressBar._data.time * 100))
        GUI:LoadingBar_setPercent(ProgressBar._ui.LoadingBar_1, percent)
        GUI:Text_setString(ProgressBar._ui.Text_desc, string.format(ProgressBar._data.msg, percent))
        elasped = elasped + 0.1

        -- 时间到
        if percent >= 100  then
            SL:CloseProgressBarUI()
        end
    end
    SL:schedule(ProgressBar._ui.LoadingBar_1, callback, 0.1)
    callback()
end

