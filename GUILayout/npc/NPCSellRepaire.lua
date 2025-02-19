NPCSellRepaire = NPCSellRepaire or {}

function NPCSellRepaire.main()
    local data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    
    local parent = GUI:GetWindow(nil, UIConst.LAYERID.NPCSellOrRepaire)
    if not parent then
        parent = GUI:Win_Create(UIConst.LAYERID.NPCSellOrRepaire, 0, 0, 0, 0, false, false, true, true)
        GUI:LoadExport(parent, "npc/npc_sell_or_repaire_layer")

        NPCSellRepaire._ui = GUI:ui_delegate(parent)
        local screenH = SL:GetValue("SCREEN_HEIGHT")
        GUI:setPositionY(NPCSellRepaire._ui.Panel_1, screenH - 174)
    end
    NPCSellRepaire.InitGUI(data)
end

function NPCSellRepaire.InitGUI(data)
    NPCSellRepaire.layerType = data and data.type or 1

    NPCSellRepaire._root = NPCSellRepaire._ui.Panel_1
    NPCSellRepaire._itemNode = NPCSellRepaire._ui.Node_item
    NPCSellRepaire._textPrice = NPCSellRepaire._ui.Text_price

    NPCSellRepaire.goToType = {
        [GUIDefine.NpcEventType.SELL] = GUIDefine.ItemGoTo.SELL,
        [GUIDefine.NpcEventType.REPAIRE] = GUIDefine.ItemGoTo.REPAIRE,
        [GUIDefine.NpcEventType.DOSOMETHING] = GUIDefine.ItemGoTo.NPC_DO_SOMETHING,
        [GUIDefine.NpcEventType.NEWTYPE] = GUIDefine.ItemGoTo.NEWTYPE,
    }

    NPCSellRepaire.fromType = {
        [GUIDefine.NpcEventType.SELL] = GUIDefine.ItemGoTo.SELL,
        [GUIDefine.NpcEventType.REPAIRE] = GUIDefine.ItemGoTo.REPAIRE,
        [GUIDefine.NpcEventType.DOSOMETHING] = GUIDefine.ItemGoTo.NPC_DO_SOMETHING,
        [GUIDefine.NpcEventType.NEWTYPE] = GUIDefine.ItemGoTo.NEWTYPE,
    }

    NPCSellRepaire.InitUI(data)

    NPCSellRepaire.RegisterEvent()

    return true
end

function NPCSellRepaire.InitUI(data)
    GUI:addOnClickEvent(NPCSellRepaire._ui.Button_close, function()
        UIOperator:CloseNpcSellRepaireUI()
    end)

    GUI:addOnClickEvent(NPCSellRepaire._ui.Button_ok, function(sender)
        if NPCSellRepaire.layerType == GUIDefine.NpcEventType.REPAIRE then
            local npcId = SL:GetValue("CURRENT_TALK_NPC_ID")
            if not SL:GetValue("NPC_REPAIRE_DATA") or not npcId then
                return
            end

            local step = SL:GetValue("NPC_REPAIRE_STEP")
            if step ~= GUIDefine.NpcRepaireStep.HAD_PRICE then
                return
            end

            local repairePrice = SL:GetValue("NPC_REPAIRE_PRICE")
            if not repairePrice or repairePrice <= 0 then
                local data = {}
                data.str = "您不能修理此物品。"
                data.btnType = 1
                UIOperator:OpenCommonTipsUI(data)
                SL:ResetRepairingState()
                return false
            end
            SL:RequestNpcStoreRepaire()
        elseif NPCSellRepaire.layerType == GUIDefine.NpcEventType.SELL then
            local npcId = SL:GetValue("CURRENT_TALK_NPC_ID")
            if not SL:GetValue("NPC_SELLING_DATA") or not npcId then
                return false
            end
            local step = SL:GetValue("NPC_SELLING_STEP")
            if step ~= GUIDefine.NpcSellStep.HAD_PRICE then
                return false
            end
            local sellPrice = SL:GetValue("NPC_SELLING_PRICE")
            if not sellPrice or sellPrice <= 0 then
                local data = {}
                data.str = "您不能出售此物品。"
                data.btnType = 1
                UIOperator:OpenCommonTipsUI(data)
                SL:ResetSellingState()
                return false
            end
            SL:RequestNpcStoreSell()
        elseif NPCSellRepaire.layerType == GUIDefine.NpcEventType.DOSOMETHING then
            local npcId = SL:GetValue("CURRENT_TALK_NPC_ID")
            if not SL:GetValue("NPC_DOSOMETHING_DATA") or not npcId then
                return
            end

            local step = SL:GetValue("NPC_DOSOMETHING_STEP")
            if step ~= GUIDefine.NpcDosomethingStep.ADD_ITEM then
                return
            end
            SL:RequestNpcDoSomething()
        elseif NPCSellRepaire.layerType == GUIDefine.NpcEventType.NEWTYPE then
            if not SL:GetValue("NPC_NEWTYPE_DATA") then
                return
            end

            local step = SL:GetValue("NPC_NEWTYPE_STEP")
            if step ~= GUIDefine.NpcNewTypeStep.ADD_ITEM then
                return
            end

            SL:RequestNpcNewTypeOk()
        end
        GUI:delayTouchEnabled(sender)
    end)

    local strWay = ""
    if NPCSellRepaire.layerType == GUIDefine.NpcEventType.SELL then
        strWay = "出售"
    elseif NPCSellRepaire.layerType == GUIDefine.NpcEventType.REPAIRE then
        strWay = "修理"
    elseif NPCSellRepaire.layerType == GUIDefine.NpcEventType.DOSOMETHING then
        local param = data.param
        strWay = param.Title or ""
    elseif NPCSellRepaire.layerType == GUIDefine.NpcEventType.NEWTYPE then
        local param = data.param
        strWay = param.Title or ""
    end
    GUI:Text_setString(NPCSellRepaire._ui.Text_way, strWay)

    local panelTouchEvent = NPCSellRepaire._ui.Panel_touchEvents
    GUI:setSwallowTouches(panelTouchEvent, false)

    local function addItemIntoBag(touchPos)
        local state = SL:GetValue("ITEM_MOVE_STATE")
        local gotoWay = NPCSellRepaire.goToType[NPCSellRepaire.layerType]
        if state and gotoWay then
            local data = {}
            data.target = gotoWay
            data.pos = touchPos
            SL:ItemMoveCheck(data)
        else
            return -1
        end
    end

    local function setNoSwallowMouse()
        return -1
    end

    GUI:addMouseButtonEvent(panelTouchEvent, {
        onRightDownFunc = setNoSwallowMouse,
        onSpecialRFunc = addItemIntoBag
    })
end

function NPCSellRepaire.UpdateLayerParam(data)
    if not data then
        return
    end

    if data.price then
        NPCSellRepaire.UpdateItemSellPrice(data.price, data.way)
    end

    if data.itemData then
        NPCSellRepaire.UpdateItems(data.itemData)
    end

    if data.reset then
        NPCSellRepaire.CleanStateAndData(data.way)
    end
end

function NPCSellRepaire.UpdateItemSellPrice(price, way)
    if price and way == NPCSellRepaire.layerType then
        if price <= 0 then
            GUI:Text_setString(NPCSellRepaire._textPrice, "???? 金币")
        else
            GUI:Text_setString(NPCSellRepaire._textPrice, string.format("%s 金币", price))
        end
    end
end

function NPCSellRepaire.UpdateItems(data)
    if not data and NPCSellRepaire._itemNode then
        return
    end

    GUI:setVisible(NPCSellRepaire._textPrice, true)

    GUI:removeAllChildren(NPCSellRepaire._itemNode)

    local info = {}
    info.itemData = data
    info.index = data.Index
    info.look = true
    info.movable = true
    info.from = NPCSellRepaire.fromType[NPCSellRepaire.layerType]
    local goodItem = GUI:ItemShow_Create(NPCSellRepaire._itemNode, "goodItem" .. data.Index, 0, 0, info)
    GUI:setAnchorPoint(goodItem, 0.5, 0.5)

    local function cancelCallBack()
        if NPCSellRepaire and NPCSellRepaire._textPrice then
            GUI:setVisible(NPCSellRepaire._textPrice, true)
        end
    end
    GUI:ItemShow_addMoveCancelCallBack(goodItem, cancelCallBack)
end

function NPCSellRepaire.CleanStateAndData(way)
    if NPCSellRepaire._itemNode and way and way == NPCSellRepaire.layerType then
        GUI:removeAllChildren(NPCSellRepaire._itemNode)
    end

    if NPCSellRepaire._textPrice then
        GUI:Text_setString(NPCSellRepaire._textPrice, "")
    end
end

function NPCSellRepaire.OnBeginMovingState()
    if NPCSellRepaire._textPrice then
        GUI:setVisible(NPCSellRepaire._textPrice, false)
    end
end

function NPCSellRepaire.GetLayerItemFrom()
    return NPCSellRepaire.fromType[NPCSellRepaire.layerType]
end

function NPCSellRepaire.OnCloseLayer()
    UIOperator:CloseNpcSellRepaireUI()
end

function NPCSellRepaire.OnClose(UID)
    if UID ~= UIConst.LAYERID.NPCSellOrRepaire then
        return false
    end

    NPCSellRepaire.UnRegisterEvent()
    NPCSellRepaire._ui = nil

    -- clean data
    SL:ResetSellingState()
    SL:ResetRepairingState()
    SL:CleanOnDoData()

    local itemFrom = NPCSellRepaire.GetLayerItemFrom()
    SL:onLUAEvent(LUA_EVENT_LAYER_MOVED_CANCEL, { from = itemFrom })
    SL:onLUAEvent(LUA_EVENT_BAG_ITEM_POS_CHANGE)
end

function NPCSellRepaire.OnItemBeginMoving(data)
    if data and next(data) then
        if data.from == GUIDefine.ItemGoTo.SELL
            or data.from == GUIDefine.ItemGoTo.REPAIRE
            or data.from == GUIDefine.ItemGoTo.DOSOMETHING then
            NPCSellRepaire:OnBeginMovingState()
        end
    end
end

function NPCSellRepaire.OnBagDataChange(data)
    if not data or not next(data) then
        return
    end

    if data.opera == GUIDefine.OperateType.DEL then
        local itemList = data.operID or {}
        local makeIndex = BagData.GetOnSellOrRepaire()
        if makeIndex then
            for k, v in pairs(itemList) do
                if makeIndex == v.MakeIndex then
                    SL:ResetSellingState()
                    SL:ResetRepairingState()
                    SL:CleanOnDoData()
                end
            end
        end
    end
end

function NPCSellRepaire.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NPCSellRepaire", NPCSellRepaire.OnClose) -- 关闭界面
    SL:RegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "NPCSellRepaire", NPCSellRepaire.OnCloseLayer)
    SL:RegisterLUAEvent(LUA_EVENT_NPC_SELL_REPAIRE_UPDATE, "NPCSellRepaire", NPCSellRepaire.UpdateLayerParam)
    SL:RegisterLUAEvent(LUA_EVENT_LAYER_MOVED_BEGIN, "NPCSellRepaire", NPCSellRepaire.OnItemBeginMoving)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "NPCSellRepaire", NPCSellRepaire.OnBagDataChange)
end

function NPCSellRepaire.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "NPCSellRepaire")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_TALK_CLOSE, "NPCSellRepaire")
    SL:UnRegisterLUAEvent(LUA_EVENT_NPC_SELL_REPAIRE_UPDATE, "NPCSellRepaire")
    SL:UnRegisterLUAEvent(LUA_EVENT_LAYER_MOVED_BEGIN, "NPCSellRepaire")
    SL:UnRegisterLUAEvent(LUA_EVENT_BAG_ITEM_CHANGE, "NPCSellRepaire")
end

NPCSellRepaire.main()
