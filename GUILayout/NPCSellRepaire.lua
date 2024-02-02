NPCSellRepaire = {}

function NPCSellRepaire.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "npc/npc_sell_or_repaire_layer")
    
    local ui = GUI:ui_delegate(parent)
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(ui.Panel_1, screenH - 174)
end