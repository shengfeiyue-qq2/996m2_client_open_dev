--[[
提前加载一些远端资源
]]

GUIPreload = {}

GUIPreload._needPreloadFiles = {
    {path = "res/public/0.png"},                            -- 空图片
    {path = "res/private/login/open_door/00.png"},          -- 开门动画底图
    {path = "res/private/login/bg_cjzy_02.jpg"},            -- 选角界面背景图
    {path = "res/private/hud/actor_hud", type = "Atlas"},   -- actor_hud资源
}

function GUIPreload.main()
    GUIPreload._loadCompleted = false
    GUIPreload._loadProgress = 0

    local preloadCount = 0
    local loadCount = 0
    local needPreloadCount = #GUIPreload._needPreloadFiles

    local function loadCB(loadResult)

        loadCount = loadCount + 1
        if loadResult == true then
            preloadCount = preloadCount + 1
            GUIPreload._loadProgress = (preloadCount / needPreloadCount) * 100
            SL:OnLUAEvent(LUA_EVENT_GUI_PRELOAD_PROGRESS, GUIPreload._loadProgress)

            if preloadCount == needPreloadCount then
                if GUIPreload._loadCompleted then
                    return
                end

                GUIPreload._loadCompleted = true
                SL:OnLUAEvent(LUA_EVENT_GUI_PRELOAD_COMPLETED, true)
                return
            end
        end
        if loadCount == needPreloadCount and GUIPreload._loadCompleted == false then
            UIOperator:OpenCommonTipsUI({
                str = "必要资源下载失败，请重试",
                btnDesc = {"重试"},
                callback = function()
                    GUI:Win_CloseByID(UIConst.LAYERID.PreloadProgressGUI)
                    if SL:GetValue("PLATFORM_WINDOWS") and not SL._DEBUG then
                        SL:ShutdownGame()
                    else
                       SL:ExitToLoginUI() 
                    end
                end
            })
        end
    end

    for i = 1, #GUIPreload._needPreloadFiles do
        local file = GUIPreload._needPreloadFiles[i]
        if file.type == "Atlas" then
            SL:LoadRemoteRes_Atlas(file.path, loadCB)
        else
            SL:LoadRemoteRes(file.path, loadCB)
        end
    end

    if EquipData and EquipData.LoadEquipOffset then
        EquipData.LoadEquipOffset()
    end

    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PRELOAD_PROGRESS or "login/PreloadProgress")
end

