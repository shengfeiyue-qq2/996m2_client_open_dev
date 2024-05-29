TreasureBox = {}

function TreasureBox.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "treasure_box/treasure_box")

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    TreasureBox._ui = GUI:ui_delegate(parent)
    GUI:setPosition(TreasureBox._ui.PMainUI, screenW / 2, screenH / 2)

    TreasureBox._boxNormalId = 4530
    TreasureBox._boxAnimOpenId = 4511
    TreasureBox._openAnimId = 4512
    TreasureBox.InitUI(data)
end

function TreasureBox.InitUI(data)
    local animIdData = string.split(SL:GetMetaValue("GAME_DATA", "boxtexiao") or "", "|")
    local animIdList = {}
    for k, v in ipairs(animIdData) do
        if v ~= "" then 
            local data = string.split(v, "#")
            if #data >= 4 then 
                animIdList[tonumber(data[1])] = {[1] = tonumber(data[2]), [2] = tonumber(data[3]), [3] = tonumber(data[4])}
            end
        end
    end

    if animIdList[data.Shape] then 
        TreasureBox._boxNormalId = animIdList[data.Shape][1]
        TreasureBox._boxAnimOpenId = animIdList[data.Shape][2]
        TreasureBox._openAnimId = animIdList[data.Shape][3]
    end

    TreasureBox.CreateBoxAnim(TreasureBox._ui.Node_box_normal, TreasureBox._boxNormalId)
end

function TreasureBox.CreateBoxAnim(root, id)
    local anim = GUI:Effect_Create(root, "anim", 0, 0, 0, id)
    GUI:Effect_play(anim, 0, 0, false)
end

function TreasureBox.OpenBoxAnim(data)
    SL:PlayOpenBoxAudio()
    local function openBox1()
        TreasureBox.CreateBoxAnim(TreasureBox._ui.Node_box_open, TreasureBox._boxAnimOpenId)
    end
    local function openBox2()
        GUI:setVisible(TreasureBox._ui.Node_box_normal, false)
        TreasureBox.CreateBoxAnim(TreasureBox._ui.Node_open, TreasureBox._openAnimId)
    end
    local function close()
        SL:CloseTreasureBoxShow()
        SL:OpenGoldBoxUI(data)
    end
    GUI:runAction(TreasureBox._ui.PMainUI, GUI:ActionSequence(GUI:CallFunc(openBox1), GUI:DelayTime(0.8), GUI:CallFunc(openBox2), GUI:DelayTime(1.3), GUI:CallFunc(close)))
end