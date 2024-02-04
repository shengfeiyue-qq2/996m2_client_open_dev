
BeStrongUp = {}

function BeStrongUp.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "be_strong/be_strong_up")

    BeStrongUp._ui = GUI:ui_delegate(parent)

    local Button_up = BeStrongUp._ui["Button_up"]
    if not Button_up then
        return false
    end
    BeStrongUp._Button_up = Button_up

    GUI:addOnClickEvent(Button_up, function () SL:OpenBeStrongList(GUI:getWorldPosition(Button_up)) end)

    BeStrongUp.ShowBtnAction()
    BeStrongUp.UpdatePos()
    BeStrongUp.RegisterEvent()
end

function BeStrongUp.ShowBtnAction()
    local btn_up = BeStrongUp._Button_up
    local action = GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionFadeTo(0.4, 125), GUI:ActionFadeTo(0.4, 255), GUI:DelayTime(0.6)))
    GUI:runAction(btn_up, action)
end 

function BeStrongUp.UpdatePos()
    if GUI:Win_IsNull(BeStrongUp._Button_up) then
        return false
    end

    local isPcMode = SL:GetMetaValue("WINPLAYMODE")
    local petAlive = SL:GetMetaValue("PET_ALIVE")
    local x = 0
    local y = 0
    if petAlive then
        if isPcMode then
            x = -290
            y = 450
        else
            x = -290
            y = 350
        end
    else
        if isPcMode then
            x = -225
            y = 450
        else
            x = -225
            y = 350
        end
    end
    GUI:setPosition(BeStrongUp._Button_up, x, y)
end

-----------------------------------注册事件--------------------------------------
function BeStrongUp.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "BeStrongUp", BeStrongUp.UpdatePos)
end

function BeStrongUp.CloseCallback()
    SL:UnRegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "BeStrongUp")
end