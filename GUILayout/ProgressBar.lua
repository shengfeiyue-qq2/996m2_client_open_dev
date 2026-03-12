ProgressBar = {}

function ProgressBar.main()
    local data = GUI:GetLayerOpenParam()
    local parent = GUI:Win_Create(UIConst.LAYERID.ProgressBarGUI, 0, 0, 0, 0, false, false, true, true)
    GUI:LoadExport(parent, "progress_bar")

    ProgressBar._ui = GUI:ui_delegate(parent)

    ProgressBar._parent = parent
    ProgressBar._data = data
    ProgressBar.StartProgress()

    ProgressBar.RegisterEvent()
    
end

function ProgressBar.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "ProgressBar", ProgressBar.OnActionBegin)
end

function ProgressBar.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "ProgressBar")
end

function ProgressBar.StartProgress()
    GUI:Text_setFontSize(ProgressBar._ui.Text_desc, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE") or 16)
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
        if percent >= 100 then
            ProgressBar.UnRegisterEvent()
            UIOperator:CloseProgressBarUI()
        end
    end
    SL:schedule(ProgressBar._ui.LoadingBar_1, callback, 0.1)
    callback()
end

function ProgressBar.OnActionBegin(data)
    local act = data and data.act
    if GUIDefine.Action.IDLE == act then
        return false
    end

    if ProgressBar._data and ProgressBar._data.dis > 0 then
        if ProgressBar._data.NoDisJump == 1 and GUIDefine.Action.STUCK == act then --受击时不中断(后仰动作)
            return
        end
        if ProgressBar._data.dis == 2 and GUIDefine.Action.SKILL == act then --施法时监听部分技能是否中断
            return
        end
        ProgressBar.UnRegisterEvent()
        UIOperator:CloseProgressBarUI()
    end
end

ProgressBar.main()
