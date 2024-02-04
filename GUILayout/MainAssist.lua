MainAssist = {}

MainAssist.jobIconPath = {"res/private/main/assist/1900012533.png", "res/private/main/assist/1900012534.png", "res/private/main/assist/1900012535.png"}
MainAssist.monsterIconPath = "res/private/main/assist/1900012536.png"

function MainAssist.main()
    GUI:LoadExport(GUI:Attach_Parent(), "main/assist/assist")
end

function MainAssist.createMissionCell(parent)
    if parent then
        GUI:LoadExport(parent, "main/assist/cell_mission")
    end
end

function MainAssist.createTeamMemberCell(parent)
    if parent then
        GUI:LoadExport(parent, "main/assist/cell_member")
    end
end

function MainAssist.createEnemyCell(parent)
    if parent then
        GUI:LoadExport(parent, "main/assist/cell_enemy")
    end
end