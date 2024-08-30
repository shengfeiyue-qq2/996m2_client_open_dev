MainSummons = {}

function MainSummons.main()
    local parent = GUI:Attach_Center()
    GUI:LoadExport(parent, "main/main_summons")

    MainSummons._ui = GUI:ui_delegate(parent)
    if not MainSummons._ui then
        return false
    end

    -- 修改PK模式
    GUI:addOnClickEvent(MainSummons._ui["Image_icon"], function(sender)
        GUI:delayTouchEnabled(sender)
        MainSummons.OnChangePKMode()
    end)

    -- 监听宝宝模式改变
    MainSummons.UpdatePKMode()

    -- 监听宝宝存活状态改变
    MainSummons.UpdateAlive()
    
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_MODE_CHANGE, "MainSummons", MainSummons.UpdatePKMode)
    SL:RegisterLUAEvent(LUA_EVENT_SUMMON_ALIVE_CHANGE, "MainSummons", MainSummons.UpdateAlive)
end

function MainSummons.OnChangePKMode()
    local PetPkType = GUIDefine.PetPkType
    local currMode = SL:GetValue("PET_PKMODE")
    local nextMode = currMode == PetPkType.REST and PetPkType.ATTACK or PetPkType.REST
    SL:RequestChangePetPKMode(nextMode)
end

function MainSummons.UpdatePKMode()
    local modePath = {"word_zhaohuanwu_02.png", "word_zhaohuanwu_01.png", "word_zhaohuanwu_03.png", "word_zhaohuanwu_04.png"}
    local mode     = SL:GetValue("PET_PKMODE")
    local path     = "res/private/main/summons/" .. modePath[mode]
    GUI:Image_loadTexture(MainSummons._ui["Image_mode"], path)
end

function MainSummons.UpdateAlive()
    local status  = SL:GetValue("PET_ALIVE")
    local visible = status == true
    GUI:setVisible(MainSummons._ui["Node"], visible)
    GUI:setTouchEnabled(MainSummons._ui["Image_icon"], visible)
end

MainSummons.main()