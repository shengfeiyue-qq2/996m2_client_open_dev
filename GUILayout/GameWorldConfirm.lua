GameWorldConfirm = {}

function GameWorldConfirm.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.GameWorldConfirmGUI) then
        return
    end
    GameWorldConfirm._parent = GUI:Win_Create(UIConst.LAYERID.GameWorldConfirmGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.NORMAL, GameWorldConfirm.HandlePressedEnter)
    GUI:LoadExport(GameWorldConfirm._parent, "game_world_confirm")
    GameWorldConfirm._ui = GUI:ui_delegate(GameWorldConfirm._parent)
    if not GameWorldConfirm._ui then
        return false
    end

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    -- 屏蔽触摸
    local touchLayout = GameWorldConfirm._ui["TouchLayout"]
    GUI:setContentSize(touchLayout, screenW, screenH)
    -- 背景图
    local confirmBG = GameWorldConfirm._ui["ConfirmBG"]
    GUI:setPosition(confirmBG, screenW / 2, screenH / 2)

    GameWorldConfirm.InitGUI()

    GameWorldConfirm.RegisterEvent()
end


---GameWorldConfirmLayer
function GameWorldConfirm.InitGUI()
    -- 确认
    GUI:addOnClickEvent(GameWorldConfirm._ui.ConfirmButton, function ()
        GameWorldConfirm.EnterGameWorld()
    end)

    local remaining = 3
    local function callback()
        GUI:Text_setString(GameWorldConfirm._ui.RemainingText, string.format("(%s)", remaining))

        remaining = remaining - 1
        if remaining < 0 then
            GameWorldConfirm.EnterGameWorld()
        end
    end
    GUI:schedule(GameWorldConfirm._ui.RemainingText, callback, 1)
    callback()
    GameWorldConfirm.OnUpdate()
end

function GameWorldConfirm.OnUpdate()
    -- content
    local contentLayout = GameWorldConfirm._ui.ContentLayout
    GUI:removeAllChildren(contentLayout)
    
    local content = SL:GetValue("LOGIN_CONFIRM_CONTENT")
    if not content or content == "" then
        return nil
    end
    local contentSize = GUI:getContentSize(contentLayout)
    local richContent = GUI:RichText_Create(contentLayout, "richtext", contentSize.width/2, contentSize.height, content, contentSize.width, 16)
    GUI:setAnchorPoint(richContent, 0.5, 1)
end

function GameWorldConfirm.OnCloseWin(id)
    if id ~= UIConst.LAYERID.GameWorldConfirmGUI then
        return
    end
    GameWorldConfirm.RemoveEvent()
    GameWorldConfirm._parent = nil
end

function GameWorldConfirm.HandlePressedEnter()
    GameWorldConfirm.EnterGameWorld()
end

function GameWorldConfirm.EnterGameWorld()
    UIOperator:CloseGameWorld()
end

function GameWorldConfirm.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GameWorldConfirm", GameWorldConfirm.OnCloseWin)
    SL:RegisterLUAEvent(LUA_EVENT_GAME_WORLD_CONFIRM_UPDATE,   "GameWorldConfirm", GameWorldConfirm.OnUpdate)
end

function GameWorldConfirm.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GameWorldConfirm")
    SL:UnRegisterLUAEvent(LUA_EVENT_GAME_WORLD_CONFIRM_UPDATE,  "GameWorldConfirm")
end

GameWorldConfirm.main()