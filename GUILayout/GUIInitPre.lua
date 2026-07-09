--[[
一些需要提前加载的配置可以放这里
]]

function GUIInitPre()
    SL:Print("Hello World, This is GUIInitPre!")
    -- 加载GUIInitPreEx
    if SL:IsFileExist("GUILayout/GUIInitPreEx.lua") then
        SL:Require("GUILayout/GUIInitPreEx", true)
    end
    -- 加载ShaderUtils.lua
    SL:Require("GUILayout/ShaderUtils", true)
end
GUIInitPre()

---------------------------进入游戏世界前监听----------------------------------
-- 登录账号
LoggedIn = false
-- 账号登录成功
SL:RegisterLUAEvent(LUA_EVENT_LOGIN_ACCOUNT_SUCCESS, "GUIInitPre", function(needTips)
    if LoggedIn == true then
        return
    end
    LoggedIn = true

    if needTips then
        SL:ShowSystemTips("登录成功")
    end

    SL:SaveLoginLocalData()

    -- 进入服务器界面
    UIOperator:OpenLoginServerUI()
    SL:ScheduleOnce(function()
        SL:RequestLoginConnectServer()
    end, 1 / 60)

    SL:DoTradingBankLoginOperations()
end)

-- 账密验证成功
SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CHECK_TOKEN_SUCCESS, "GUIInitPre", function()
    if not SL:GetValue("GAME_IN_LOGIN_STATE") then
        return 
    end
    
    SL:SaveLoginLocalData()

    -- 进入服务器界面
    UIOperator:OpenLoginServerUI()
    SL:ScheduleOnce(function()
        SL:RequestLoginConnectServer()
    end, 1 / 60)
end)

-- 账密验证失败
SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CHECK_TOKEN_FAIL, "GUIInitPre", function(data)
    if not data or not data.msg then
        return
    end
    SL:ShowSystemTips(data.msg)
end)

-- 登录服务器成功
SL:RegisterLUAEvent(LUA_EVENT_LOGIN_SERVER_SUCCESS, "GUIInitPre", function()
    UIOperator:CloseLoginAccountUI()
end)

--------------------------------------------------------------------------------