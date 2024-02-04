MainSummons = {}

function MainSummons.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "main/main_summons")

    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    -- 修改PK模式
    GUI:addOnClickEvent(ui["Image_icon"], function()
        local currMode = SL:GetMetaValue("PET_PKMODE")
        local nextMode = currMode == 4 and 2 or 4
        SL:RequestChangePetPKMode(nextMode)
    end)

    -- 监听宝宝模式改变
    local function updatePKMode()
        local modePath = { "word_zhaohuanwu_02.png", "word_zhaohuanwu_01.png", "word_zhaohuanwu_03.png", "word_zhaohuanwu_04.png" }
        local mode     = SL:GetMetaValue("PET_PKMODE")
        local path     = "res/private/main/summons/" .. modePath[mode]
        GUI:Image_loadTexture(ui["Image_mode"], path)
    end
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_MODE_CHANGE, "MainSummons", updatePKMode)
    updatePKMode()

    -- 监听宝宝存活状态改变
    local function updateAlive()
        local status  = SL:GetMetaValue("PET_ALIVE")
        local visible = (status == true)
        GUI:setVisible(ui["Node"], visible)
        GUI:setTouchEnabled(ui["Image_icon"], visible)
    end
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "MainSummons", updateAlive)
    updateAlive()
end