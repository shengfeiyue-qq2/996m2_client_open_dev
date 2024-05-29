NPCSellRepaire = {}

function NPCSellRepaire.main()
    local parent = GUI:Attach_Parent()
    local loadFilePath = SL:GetMetaValue("WINPLAYMODE") and "npc/npc_sell_or_repaire_layer_win32" or "npc/npc_sell_or_repaire_layer"
    GUI:LoadExport(parent, loadFilePath)
    
    local ui = GUI:ui_delegate(parent)
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(ui.Panel_1, screenH - 174)
end