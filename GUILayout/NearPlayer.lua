NearPlayer = {}

function NearPlayer.main()
    local parent = GUI:Attach_Parent()

    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "social/near/near_player_win32")
    else
        GUI:LoadExport(parent, "social/near/near_player")
    end
end

function NearPlayer.CreateMemberCell(parent)
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:LoadExport(parent, "social/near/member_cell_win32")
    else
        GUI:LoadExport(parent, "social/near/member_cell")
    end
end