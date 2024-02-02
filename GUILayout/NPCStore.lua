NPCStore = {}

NPCStore.perPageItemsCount = 8  -- 每页最多8个商品

function NPCStore.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "npc/npc_store_layer_win32" or "npc/npc_store_layer")

    local ui = GUI:ui_delegate(parent)
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(ui.Panel_1, screenH - 177)
end