BeStrongUp = {}

BeStrongUp._btnPosNormal = SL:GetValue("IS_PC_OPER_MODE") and {x = -300, y = 400} or {x = -300, y = 300}
BeStrongUp._btnPosPetAlive = SL:GetValue("IS_PC_OPER_MODE") and {x = -370, y = 400} or {x = -370, y = 300}
BeStrongUp._defaultBtnSize = {width = 120, height = 40}

BeStrongUpInfo = BeStrongUpInfo or {}
function BeStrongUp.main()
    if not BeStrongUpInfo._layer then
        local parent = GUI:Attach_RightBottom()
        BeStrongUpInfo._parent = parent 
        BeStrongUp.InitUI()
        BeStrongUp.RegisterEvent()
    end
end

function BeStrongUp.InitUI()
    GUI:LoadExport(BeStrongUpInfo._parent, "be_strong/be_strong_up") 
    BeStrongUpInfo._ui = GUI:ui_delegate(BeStrongUpInfo._parent)
    BeStrongUpInfo._layer = BeStrongUpInfo._ui.Node

    GUI:addOnClickEvent(BeStrongUpInfo._ui["Button_up"], function()
        local panelBg = BeStrongUpInfo._ui["Panel_bg"]
        local isShow = GUI:getVisible(panelBg)
        GUI:setVisible(panelBg, not isShow)

        BeStrongUp.RefreshBeStrongList()
    end)

    GUI:setVisible(BeStrongUpInfo._ui["Panel_bg"], false)

    BeStrongUp.ShowBtnAction()
    BeStrongUp.RefreshBtnPos()
end

-- 提升按钮位置
function BeStrongUp.ShowBtnAction()
    local btn_up = BeStrongUpInfo._ui["Button_up"]
    local action = GUI:ActionRepeatForever(GUI:ActionSequence(GUI:ActionFadeTo(0.4, 125), GUI:ActionFadeTo(0.4, 255), GUI:DelayTime(0.6)))
    GUI:runAction(btn_up, action)
end 

-- 提升按钮位置刷新
function BeStrongUp.RefreshBtnPos()
    local isAlived = SL:GetValue("PET_ALIVE")
    local posBtn = isAlived and BeStrongUp._btnPosPetAlive or BeStrongUp._btnPosNormal
    GUI:setPosition(BeStrongUpInfo._ui["Button_up"], posBtn.x, posBtn.y)
    GUI:setPosition(BeStrongUpInfo._ui["Panel_bg"], posBtn.x - 65, posBtn.y + 30)
end

function BeStrongUp.CreateCellBtn(i, data)
    local widget = GUI:Widget_Create(-1, "widget_" .. i, 0, 0, 0, 0)
    GUI:LoadExport(widget, "be_strong/be_strong_up_cell")
    local btn = GUI:getChildByName(widget, "Button_cell")
    GUI:Button_setTitleText(btn, data.name)

    GUI:removeFromParent(btn)
    return btn
end

-- 显示变强列表
function BeStrongUp.RefreshBeStrongList()
    local data = SL:GetValue("BESTRONG_DATA")
    local nums = table.nums(data)
    if nums == 0 then 
        return
    end 

    local panel = BeStrongUpInfo._ui["Panel_bg"]
    local listview = BeStrongUpInfo._ui["ListView"]

    GUI:ListView_removeAllItems(listview)

    local btnSize = nil
    for i, v in pairs(data) do
        local btn = BeStrongUp.CreateCellBtn(i, v)
        GUI:ListView_pushBackCustomItem(listview, btn)
        GUI:addOnClickEvent(btn, function()
            GUI:setVisible(panel, false)
            if v.link then
                SL:SubmitAct({Act = v.link, subid = v.id})
            elseif v.func then
                v.func()
            end
        end)

        if not btnSize then
            btnSize = GUI:getContentSize(btn)
        end
    end

    local count = GUI:ListView_getItemCount(listview)
    local btnSize = btnSize or BeStrongUp._defaultBtnSize
    local bgSize = GUI:getContentSize(panel)
    local listSize = GUI:getContentSize(listview)
    local margin = GUI:ListView_getItemsMargin(listview)
    --最多显示4条 超过的滑动显示
    local height = (btnSize.height + margin) * math.min(count, 4.5) - margin
    GUI:setContentSize(listview, listSize.width, height)
    GUI:setContentSize(panel, bgSize.width, height + 10)
end

function BeStrongUp.RefreshList()
    local showList = GUI:getVisible(BeStrongUpInfo._ui["Panel_bg"])
    if showList then
        BeStrongUp.RefreshBeStrongList()
    end
end

function BeStrongUp.OnClose()
    if  BeStrongUpInfo and BeStrongUpInfo._layer then
        GUI:removeFromParent(BeStrongUpInfo._layer)
        BeStrongUpInfo._layer = nil
        BeStrongUp.UnRegisterEvent()
        BeStrongUpInfo = nil
    end
end
-----------------------------------注册事件--------------------------------------
function BeStrongUp.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "BeStrongUp", BeStrongUp.RefreshBtnPos)
    SL:RegisterLUAEvent(LUA_EVENT_BESTRONG_LIST_REFRESH, "BeStrongUp", BeStrongUp.RefreshList)
    SL:RegisterLUAEvent(LUA_EVENT_BESTRONG_CLOSE, "BeStrongUp", BeStrongUp.OnClose)
    
end

function BeStrongUp.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "BeStrongUp")
    SL:UnRegisterLUAEvent(LUA_EVENT_BESTRONG_LIST_REFRESH, "BeStrongUp")
    SL:UnRegisterLUAEvent(LUA_EVENT_BESTRONG_CLOSE, "BeStrongUp")
end

BeStrongUp.main()