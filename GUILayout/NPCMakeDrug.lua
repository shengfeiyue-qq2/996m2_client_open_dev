NPCMakeDrug = {}

NPCMakeDrug.perPageItemsCount = 10  -- 每页最多10条物品

function NPCMakeDrug.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "npc/npc_make_drug_layer")

    local ui = GUI:ui_delegate(parent)
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")
    GUI:setPositionY(ui.Panel_1, screenH - 177)
end

-- 列表 cell
function NPCMakeDrug.CreateItemCell(parent)
    GUI:LoadExport(parent, "npc/npc_make_drug_cell")
end