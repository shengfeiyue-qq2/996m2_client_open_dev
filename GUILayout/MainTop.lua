MainTop = {}

MainTop.NetPath = {                             -- 网络标识图片路径
    "res/private/main/Other/1900012501.png",    -- WIFI
    "res/private/main/Other/1900012500.png",    -- 蜂窝网络
}

function MainTop.main()
    local parent = GUI:Attach_MainTop()
    GUI:LoadExport(parent, "main/main_top")

    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    local Panel_1 = ui["Panel_1"]
    GUI:setContentSize(Panel_1, screenW, 30)

    -- 背景图
    local Image_1 = ui["Image_1"]
    GUI:setPosition(Image_1, screenW / 2, 30)
    GUI:setContentSize(Image_1, screenW, 31)

    local Panel_3 = ui["Panel_3"]
    GUI:setPosition(Panel_3, screenW - 20, 30)

    -- 网络标识
    local Image_net = ui["Image_net"]
    local function updateNetType()
        local netType = SL:GetMetaValue("NET_TYPE")
        -- -1:未识别 0:wifi 1:蜂窝
        if netType == 0 then
            GUI:Image_loadTexture(Image_net, "res/private/main/Other/1900012501.png")
        else
            GUI:Image_loadTexture(Image_net, "res/private/main/Other/1900012500.png")
        end
    end
    SL:RegisterLUAEvent(LUA_EVENT_NETCHANGE, "MainTop", updateNetType)
    updateNetType()

    -- 电量显示
    local LoadingBar_battery = ui["LoadingBar_battery"]
    local function updateBattery()
        local percent = SL:GetMetaValue("BATTERY")
        GUI:LoadingBar_setPercent(LoadingBar_battery, percent)
    end
    SL:RegisterLUAEvent(LUA_EVENT_BATTERYCHANGE, "MainTop", updateBattery)
    updateBattery()
end