MainCollect = {}

function MainCollect.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/collect/collect")

    MainCollect._ui = GUI:ui_delegate(parent)

    -- 采集列表
    MainCollect._selectList = MainCollect._ui.List_Collect_Select
    -- 采集列表底图
    MainCollect._selectListBg = MainCollect._ui.Layout_BG

end

-- 采集UI显示 (内部调用)
function MainCollect.ShowCollectUI()
    local showSelect = tonumber(SL:GetMetaValue("GAME_DATA", "Hide_Select_Collection")) ~= 1
    GUI:setVisible(MainCollect._ui.Panel_1, true)
    GUI:setTouchEnabled(MainCollect._ui.Panel_1, true)
    GUI:Text_setString(MainCollect._ui.Text_1, "可采集")

    if not MainCollect._selectList then
        return
    end
    GUI:setVisible(MainCollect._selectList, showSelect)
    GUI:setVisible(MainCollect._selectListBg, showSelect)
    if showSelect then
        GUI:setTouchEnabled(MainCollect._selectList, true)
    end
end

-- 采集UI隐藏 (内部调用)
function MainCollect.HideCollectUI()
    GUI:setVisible(MainCollect._ui.Panel_1, false)
    GUI:setTouchEnabled(MainCollect._ui.Panel_1, false)
    
    if not MainCollect._selectList then
        return
    end
    GUI:ListView_removeAllItems(MainCollect._selectList)
    GUI:setTouchEnabled(MainCollect._selectList, false)
end