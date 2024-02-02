MainDig = {}

function MainDig.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/main_dig")

    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    MainDig.Button_dig = ui["Button_dig"]

end