SplitLayer = {}
function SplitLayer.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.CommonTipsSplitGUI) then
        return
    end
    SplitLayer._parent = GUI:Win_Create(UIConst.LAYERID.CommonTipsSplitGUI, 0, 0, 0, 0, false, false, true, true, false, false, GUIDefine.UIZ.TOBOX)

    --设置参数
    SplitLayer._data = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    SplitLayer.InitGUI()
    SplitLayer.RegisterEvent()
end

function SplitLayer.InitGUI()
    if not SplitLayer._data then
        return
    end
    SL:RequireFile(UIConst.LUAFile.LUA_FILE_ITEM_SPLIT_POP)
    ItemSplitPop.main(SplitLayer._data)
end

function SplitLayer.OnCloseWin(id)
    if id ~= UIConst.LAYERID.CommonTipsSplitGUI then
        return
    end
    SplitLayer.RemoveEvent()
    SplitLayer._parent = nil
end

function SplitLayer.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN,     "SplitLayer", SplitLayer.OnCloseWin)
end

function SplitLayer.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN,     "SplitLayer")
end

SplitLayer.main()