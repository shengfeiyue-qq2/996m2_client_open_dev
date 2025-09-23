LoginRolePanel = {}

LoginRolePanel._animLightID = {4121, 4127, 4123, 4129, 4125, 4131}      -- 人物常亮动画id  顺序：男战士、女战士、男法师、女法师、男道士、女道士
LoginRolePanel._animGToLID  = {4122, 4128, 4124, 4130, 4126, 4132}      -- 人物灰到亮动画id   
LoginRolePanel._animPos     = {x = 0, y = 170}                          -- 人物特效位置    (基于 Node_anim_1/2)
LoginRolePanel._animScale   = {1, 1}                                    -- 左右动画缩放

LoginRolePanel._createJobPath = {         -- 创角页职业图标路径
    normal = {
        [1] = "res/private/login/icon_cjzy_01.png",
        [2] = "res/private/login/icon_cjzy_02.png",
        [3] = "res/private/login/icon_cjzy_03.png",
    },
    select = {
        [1] = "res/private/login/icon_cjzy_01_1.png",
        [2] = "res/private/login/icon_cjzy_02_1.png",
        [3] = "res/private/login/icon_cjzy_03_1.png",
    },
}

LoginRolePanel._createSexPath = {         -- 创角页性别图标路径
    normal = {
        [1] = "res/private/login/icon_cjzy_06.png",
        [2] = "res/private/login/icon_cjzy_05.png",
    },
    select={
        [1] = "res/private/login/icon_cjzy_06_1.png",
        [2] = "res/private/login/icon_cjzy_05_1.png",
    },
}

LoginRolePanel._multiJobPathN = "res/private/login/icon_zdyzy_%02d.png"
LoginRolePanel._multiJobPathS = "res/private/login/icon_zdyzy_%02d_1.png"

LoginRolePanel._multiJobBeginID = 5     -- 自定义职业起始ID
LoginRolePanel._multiJobEndID   = 15    -- 自定义职业结束ID

LoginRolePanel._autoBtnType = {
    StartGame   = 1, -- 开始
    CreateRole  = 2, -- 创角提交
}

function LoginRolePanel.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.LoginRoleGUI) then
        return
    end

    LoginRolePanel._createUI = nil
    LoginRolePanel._restoreUI = nil
    LoginRolePanel._index = -1
    LoginRolePanel._isRandName = false
    LoginRolePanel._reloginCD = false
    LoginRolePanel._autoData = {} -- 自动按钮 1: 开始   2: 创角提交
    LoginRolePanel._needAutoIndex = nil
    LoginRolePanel._touchAutoPanel = nil

    SL:StopAllAudio()
    SL:PlayAudioBGMByType(GUIDefine.BGMType.SELECT)

    local parent = GUI:Win_Create(UIConst.LAYERID.LoginRoleGUI, 0, 0, 0, 0, false, false, true, true, nil, nil, nil, LoginRolePanel.SubmitEnterGame)
    LoginRolePanel._layer = parent
    GUI:LoadExport(parent, "login_role/login_role")

    LoginRolePanel._ui = GUI:ui_delegate(parent)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local touchPanel = LoginRolePanel._ui.Panel_touch
    GUI:setContentSize(touchPanel, screenW, screenH)

    local panelBg = LoginRolePanel._ui.Panel_bg
    GUI:setPosition(panelBg, screenW / 2, screenH / 2)
    GUI:Layout_setBackGroundImage(panelBg, "res/private/login/bg_cjzy_02.jpg")

    -- 
    LoginRolePanel._openJob = {GUIDefine.Job.FIGHTER, GUIDefine.Job.WIZZARD, GUIDefine.Job.TAOIST}
    LoginRolePanel._multiJobData = {}
    for i = LoginRolePanel._multiJobBeginID, LoginRolePanel._multiJobEndID do
        local jobData   = SL:GetValue("GAME_DATA", "MultipleJobSetMap")[i]
        local isOpen    = jobData and jobData.isOpen
        if isOpen then
            table.insert(LoginRolePanel._openJob, i)
            LoginRolePanel._multiJobData[i] = jobData
        end
    end

    LoginRolePanel.InitUI()
    LoginRolePanel.InitActButtonData()
    LoginRolePanel.OnUpdateRoles(true)
    LoginRolePanel.RegisterEvent()
end

function LoginRolePanel.InitUI()
    -- 服务器名
    GUI:Text_setString(LoginRolePanel._ui.Text_server_name, SL:GetValue("SERVER_NAME"))

    -- role
    local function selectRole(index)
        -- 创角/恢复中
        if LoginRolePanel._createUI or LoginRolePanel._restoreUI then
            return
        end

        local roles = SL:GetValue("LOGIN_ROLE_DATAS")
        if not roles[index] then
            return false
        end
        LoginRolePanel.OnSelectRole(index)
    end

    GUI:addOnClickEvent(LoginRolePanel._ui.Button_select_1, function()
        selectRole(1)
    end)
    
    GUI:addOnClickEvent(LoginRolePanel._ui.Panel_role_1, function()
        selectRole(1)
    end)
    
    GUI:addOnClickEvent(LoginRolePanel._ui.Button_select_2, function()
        selectRole(2)
    end)

    GUI:addOnClickEvent(LoginRolePanel._ui.Panel_role_2, function()
        selectRole(2)
    end)

    LoginRolePanel.InitAct()

end

function LoginRolePanel.InitAct()
    -- 开始
    GUI:addOnClickEvent(LoginRolePanel._ui.Button_start, function()
        GUI:delayTouchEnabled(LoginRolePanel._ui.Button_start, 0.5)
        LoginRolePanel.SubmitEnterGame()
    end)

    -- 返回
    GUI:addOnClickEvent(LoginRolePanel._ui.Button_leave, function()
        if SL:GetValue("IS_VISITOR_MODE") then
            return
        end
        local shiwan = SL:GetValue("BOX_TEST_PLAY")
        if shiwan then
            return
        end
        SL:ExitToLoginUI(true)
    end)

    -- 创建
    GUI:addOnClickEvent(LoginRolePanel._ui.Button_create, function()
        local shiwan = SL:GetValue("BOX_TEST_PLAY")
        if shiwan then
            return
        end
        LoginRolePanel.OnCreateRole()
    end)

    -- 删除
    GUI:addOnClickEvent(LoginRolePanel._ui.Button_delete, function()
        local shiwan = SL:GetValue("BOX_TEST_PLAY")
        if shiwan then
            return
        end
        LoginRolePanel.OnDeleteRole()
    end)

    -- 恢复
    GUI:addOnClickEvent(LoginRolePanel._ui.Button_restore, function()
        local shiwan = SL:GetValue("BOX_TEST_PLAY")
        if shiwan then
            return
        end
        LoginRolePanel.OnRestoreRole()
    end)

end

function LoginRolePanel.InitActButtonData()
    -- 开始按钮
    local desc = GUI:Button_getTitleText(LoginRolePanel._ui.Button_start)
    LoginRolePanel._autoData = {
        [1] = {
            btn = LoginRolePanel._ui.Button_start,
            btnDesc = desc,
            delayTimeDesc = desc .. "(%s)" 
        }
    }
end

function LoginRolePanel.OnUpdateRoles(isInit)
    LoginRolePanel._index = -1

    LoginRolePanel.InitTradeShow()

    -- 默认上次，没有就选择第一个
    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    local selectRole = SL:GetValue("LOGIN_SELECT_ROLE_DATA")

    local checkAutoIdx = LoginRolePanel._autoBtnType.StartGame
    if selectRole then
        LoginRolePanel.OnSelectRole(selectRole.index, true)
    elseif #roles > 0 then
        LoginRolePanel.OnSelectRole(1, true)
    else
        LoginRolePanel.OnSelectRole(0, true)
        if isInit then
            LoginRolePanel.ShowCreateRole()
            checkAutoIdx = LoginRolePanel._autoBtnType.CreateRole
        end
    end

    LoginRolePanel.UpdateRolesShow()

    if isInit and checkAutoIdx then
        LoginRolePanel.CheckAutoButton(checkAutoIdx)
    end

end

function LoginRolePanel.CheckAutoButton(checkAutoIdx)
    if not checkAutoIdx then
        return
    end

    if not SL:GetValue("LOGIN_IS_AUTO_BOOT") then
        return
    end

    -- 倒计时自动开始
    local btnData = LoginRolePanel._autoData[checkAutoIdx]
    if not btnData or not btnData.btn then
        return
    end

    LoginRolePanel._needAutoIndex = checkAutoIdx

    local btn = btnData.btn
    local delayTime = btnData.delay or 20
    local function callBack()
        if delayTime < 0 then
            LoginRolePanel.StopAutoButton()
            return
        end
        GUI:Button_setTitleText(btn, string.format(btnData.delayTimeDesc, delayTime))
        delayTime = delayTime - 1
        if delayTime == 0 then
            if LoginRolePanel._needAutoIndex == 1 then -- 开始
                LoginRolePanel.SubmitEnterGame()
            elseif LoginRolePanel._needAutoIndex == 2 then -- 创角
                LoginRolePanel.SubmitCreateNewRole()
            end
        end
    end
    GUI:stopAllActions(btn)
    SL:schedule(btn, callBack, 1)
    callBack()

    LoginRolePanel.InitStopAutoButtonPanel()

end

function LoginRolePanel.StopAutoButton()
    if not LoginRolePanel._needAutoIndex then
        return
    end

    local autoBtnIndex = LoginRolePanel._needAutoIndex
    LoginRolePanel._needAutoIndex = nil
   
    if not SL:GetValue("LOGIN_IS_AUTO_BOOT") then
        return
    end

    local btnData = LoginRolePanel._autoData[autoBtnIndex]
    if not btnData or not btnData.btn then
        return
    end

    local btn = btnData.btn
    GUI:stopAllActions(btn)
    GUI:Button_setTitleText(btn, btnData.btnDesc or "")

end

-- 触摸层 用于停止自动按钮
function LoginRolePanel.InitStopAutoButtonPanel()
    if LoginRolePanel._touchAutoPanel then
        return
    end

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")
    local touchAutoPanel = GUI:Layout_Create(LoginRolePanel._layer, "touchAutoPanel", 0, 0, screenW, screenH)
    GUI:setTouchEnabled(touchAutoPanel, true)
    GUI:setSwallowTouches(touchAutoPanel, false)
    GUI:setLocalZOrder(touchAutoPanel, 999)
    GUI:addOnClickEvent(touchAutoPanel, function()
        if LoginRolePanel._needAutoIndex then
            LoginRolePanel.StopAutoButton()
        end
    end)

    LoginRolePanel._touchAutoPanel = touchAutoPanel
end

function LoginRolePanel.InitTradeShow()
    SL:OpenLoginTradeLockUI()
end

-- 更新角色信息 
function LoginRolePanel.UpdateRolesShow()
    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    -- level 等级 name 昵称 job 职业 012
    for i = 1, 2 do
        GUI:Text_setString(LoginRolePanel._ui["Text_level_"..i], "")
        GUI:Text_setString(LoginRolePanel._ui["Text_name_"..i], "")
        GUI:Text_setString(LoginRolePanel._ui["Text_job_"..i], "")

        if roles[i] then
            GUI:Text_setString(LoginRolePanel._ui["Text_level_"..i], roles[i].level .. "级")
            GUI:Text_setString(LoginRolePanel._ui["Text_name_"..i], roles[i].name)
            GUI:Text_setString(LoginRolePanel._ui["Text_job_"..i], GUIFunction:GetJobNameByID(roles[i].job))
        end
    end 
end

function LoginRolePanel.OnSelectRole(index, isInit)
    if LoginRolePanel._index == index and not isInit then
        return
    end

    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    if roles[index] and (roles[index].LockChar == 1 or roles[index].LockChar == 3) then
        if not isInit then
            SL:ShowSystemTips("角色已被冻结")
            return 
        else
            index = -1
        end
    end

    LoginRolePanel._index = index
    SL:SetValue("LOGIN_SELECT_ROLE_BY_INDEX", index)

    if not isInit then
        SL:PlaySelectRoleAudio()
    end

    local animID = LoginRolePanel._animLightID
    local animGID = LoginRolePanel._animGToLID
    local position = LoginRolePanel._animPos
    local _animScale = LoginRolePanel._animScale
    if animID and animGID and position then
        for i = 1, 2 do
            local scale = _animScale[i]
            GUI:removeAllChildren(LoginRolePanel._ui["Node_anim_" .. i])
            if roles[i] then
                local job = roles[i].job
                local sex = roles[i].sex
                local animIdx = job * 2 + sex + 1
                local needOpen = job >= 5 and job <= 15
                local set_animGToLID = nil
                local setAnimLID = nil
                if needOpen then
                    local jobData = LoginRolePanel._multiJobData[job]
                    set_animGToLID = jobData and (sex == 1 and jobData.animGToLFemaleID or jobData.animGToLMaleID)
                    setAnimLID = jobData and (sex == 1 and jobData.createLightFemaleID or jobData.createLightMaleID)
                end
                local _animLightID = needOpen and setAnimLID or animID[animIdx]
                local _animGToLID = needOpen and set_animGToLID or animGID[animIdx]
                if LoginRolePanel._index == i then
                    if isInit then
                        if _animLightID then
                            local anim = GUI:Effect_Create(LoginRolePanel._ui["Node_anim_" .. i], "role_effect" .. i, position.x, position.y, 0, _animLightID)
                            GUI:setScale(anim, scale)
                        end
                    else
                        if _animGToLID then
                            local animG = GUI:Effect_Create(LoginRolePanel._ui["Node_anim_" .. i], "role_effect_G" .. i, position.x, position.y, 0, _animGToLID)
                            GUI:setScale(animG, scale)
                            GUI:Effect_addOnCompleteEvent(animG, function()
                                GUI:removeFromParent(animG)
                                if _animLightID then
                                    local anim = GUI:Effect_Create(LoginRolePanel._ui["Node_anim_" .. i], "role_effect" .. i, position.x, position.y, 0, _animLightID)
                                    GUI:setScale(anim, scale)
                                end
                            end)
                        end

                        local sfx = GUI:Effect_Create(LoginRolePanel._ui["Node_anim_" .. i], "role_sfx" .. i, position.x, position.y, 0, 4114)
                        GUI:Effect_addOnCompleteEvent(sfx, function()
                            GUI:removeFromParent(sfx)
                        end)
                    end
                else
                    if isInit then
                        if _animGToLID then
                            local animG = GUI:Effect_Create(LoginRolePanel._ui["Node_anim_" .. i], "role_effect_G" .. i, position.x, position.y, 0, _animGToLID)
                            GUI:setScale(animG, scale)
                            GUI:Effect_play(animG, 0, 0, false, 1, false)
                            GUI:Effect_stop(animG, 1)
                        end
                    else
                        if _animGToLID then
                            local animG = GUI:Effect_Create(LoginRolePanel._ui["Node_anim_" .. i], "role_effect_G" .. i, position.x, position.y, 0, _animGToLID)
                            GUI:setScale(animG, scale)
                            GUI:Effect_play(animG, 0, 0, false, 1, false)
                            GUI:Effect_addOnCompleteEvent(animG, function()
                                GUI:Effect_stop(animG, 1)
                            end)
                        end
                    end
                end
            end
        end
    end

end

function LoginRolePanel.OnCreateRole()
    if SL:GetValue("IS_VISITOR_MODE") then
        return
    end

    local shiwan = SL:GetValue("BOX_TEST_PLAY")
    if shiwan then
        return
    end

    -- 创角/恢复中
    if LoginRolePanel._createUI or LoginRolePanel._restoreUI then
        return
    end

    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    if #roles >= 2 then
        UIOperator:OpenCommonTipsUI({
            btnType = 1,
            str = "你可以为每个单独的账号创建两个角色",
        })
        return
    end

    LoginRolePanel.ShowCreateRole()
end

function LoginRolePanel.ShowCreateRole()
    if LoginRolePanel._createUI then
        return
    end
    
    LoginRolePanel.LoadCreateRoleUI(LoginRolePanel._layer)

    -- 默认请求随机名字
    if LoginRolePanel._createJob and LoginRolePanel._createSex then
        UIOperator:OpenLoadingBarUI(3)
        SL:RequestLoginRandRoleName(LoginRolePanel._createJob, LoginRolePanel._createSex)
    end

    local ui = LoginRolePanel._createUI
    if not ui then
        return
    end

    -- 随机名字
    GUI:addOnClickEvent(ui.Button_rand, function()
        GUI:delayTouchEnabled(ui.Button_rand)
        SL:RequestLoginRandRoleName(LoginRolePanel._createJob, LoginRolePanel._createSex)
    end)

    GUI:TextInput_addOnEvent(ui.TextInput_name, function(_, eventType)
        if eventType == 2 then
            if SL:GetValue("M2_FORBID_NAME", true) then
                GUI:TextInput_setString(ui.TextInput_name, "")
                return
            end
            LoginRolePanel._isRandName = false

            local input = GUI:TextInput_getString(ui.TextInput_name)
            input = string.gsub(input, "\r\n", "")
            input = string.gsub(input, "\n", "")
            input = string.gsub(input, " ", "")
            input = string.gsub(input, "　", "")
            GUI:TextInput_setString(ui.TextInput_name, input)
        end
    end)

    -- 提交
    GUI:addOnClickEvent(ui.Button_submit, function()
        GUI:delayTouchEnabled(ui.Button_submit, 0.5)
        LoginRolePanel.SubmitCreateNewRole()
    end)

    if LoginRolePanel._autoData and not LoginRolePanel._autoData[2] then
        -- 提交
        local submitStr = GUI:Button_getTitleText(LoginRolePanel._createUI.Button_submit)
        LoginRolePanel._autoData[2] = {
            btn = LoginRolePanel._createUI.Button_submit, 
            btnDesc = submitStr,
            delayTimeDesc = submitStr .. "(%s)"
        }
    end

end

-- 创角提交
function LoginRolePanel.SubmitCreateNewRole()
    if LoginRolePanel._createUI then
        local input = GUI:TextInput_getString(LoginRolePanel._createUI.TextInput_name)
        if string.len(input) == 0 then
            SL:ShowSystemTips("角色名不可为空")
            return
        end

        -- 屏蔽数字
        if string.match(input, "%d+") then
            SL:ShowSystemTips("禁止建立包含数字的人物名")
            return
        end

        UIOperator:OpenLoadingBarUI()

        SL:RequestCheckSensitiveWord(input, 1, function(status)
            UIOperator:CloseLoadingBarUI()

            -- 随机名字不检测敏感字
            if not status and not LoginRolePanel._isRandName then
                SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                return
            end

            SL:RequestLoginCreateRole(input, LoginRolePanel._createJob, LoginRolePanel._createSex)
        end)

    end
end

-- 进入游戏
function LoginRolePanel.SubmitEnterGame()
    if LoginRolePanel._reloginCD then
        return
    end

    if LoginRolePanel._restoreUI then
        return
    end

    -- 创角中
    if LoginRolePanel._createUI then
        LoginRolePanel.SubmitCreateNewRole()
        return
    end

    -- 没有选择角色
    local selectRoleData = SL:GetValue("LOGIN_SELECT_ROLE_DATA")
    if not selectRoleData then
        return
    end

    SL:SetValue("LOGIN_SELECT_ROLE_TRADE_PARAM")
    UIOperator:OpenLoadingBarUI()
    SL:RequestLoginEnterGame()

    SL:StopAudioBGM()
end

function LoginRolePanel.LoadCreateRoleUI(parent)
    GUI:LoadExport(parent, "login_role/login_role_create")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    local rolePanel = GUI:getChildByName(parent, "Panel_role")
    GUI:setPosition(rolePanel, screenW / 2, screenH / 2)

    LoginRolePanel._createUI = GUI:ui_delegate(rolePanel)

    local defaultJob = 0
    local defaultSex = 0

    local isRandomJob = SL:GetValue("GAME_DATA", "isRandomJob") and tonumber(SL:GetValue("GAME_DATA", "isRandomJob")) ~= 0
    local isRandomSex = SL:GetValue("GAME_DATA", "isRandomSex") and tonumber(SL:GetValue("GAME_DATA", "isRandomSex")) ~= 0
    local isSingleJob = SL:GetValue("GAME_DATA", "isSingleJob") and tonumber(SL:GetValue("GAME_DATA", "isSingleJob")) ~= 0
    local isSingleSex = SL:GetValue("GAME_DATA", "isSingleSex") and tonumber(SL:GetValue("GAME_DATA", "isSingleSex")) ~= 0

    -- 随机职业
    if not isSingleJob and isRandomJob then
        local num = #LoginRolePanel._openJob
        local index = math.random(1, num)
        defaultJob = LoginRolePanel._openJob[index]
    end
    -- 随机性别
    if not isSingleSex and isRandomSex then
        defaultSex = math.random(0, 1)
    end

    -- 默认职业
    local setJob = tonumber(SL:GetValue("GAME_DATA", "defaultJob"))
    if setJob then
        defaultJob = setJob
        if isSingleJob then
            isSingleJob = defaultJob
        end
    end

    local isSingleSex
    if SL:GetValue("GAME_DATA", "isSingleSex") then
        if SL:GetValue("GAME_DATA","isSingleSex") == "boy" or SL:GetValue("GAME_DATA","isSingleSex") == 1 then
            isSingleSex = GUIDefine.Sex.MALE
        elseif SL:GetValue("GAME_DATA","isSingleSex") == "girl" or SL:GetValue("GAME_DATA","isSingleSex") == 2 then
            isSingleSex = GUIDefine.Sex.FEMALE
        end
    end

    -- 显示刷新/功能添加
    GUI:setVisible(LoginRolePanel._ui.Node_anim_1, false)
    GUI:setVisible(LoginRolePanel._ui.Node_anim_2, false)

    local createJob = -1
    local createSex = -1

    local contentSize = GUI:getContentSize(rolePanel)
    GUI:setPositionX(ui.Panel_anim, contentSize.width / 2)
    GUI:setPositionX(ui.Panel_info, contentSize.width / 2)
    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    if #roles > 0 then
        GUI:setAnchorPoint(ui.Panel_anim, 0, 1)
        GUI:setPositionX(ui.Panel_anim, contentSize.width / 2)
        GUI:setAnchorPoint(ui.Panel_info, 1, 1)
        GUI:setPositionX(ui.Panel_info, contentSize.width / 2)
    end

    local function updateAnim()
        -- 创建角色展示动画
        local pos = LoginRolePanel._animPos
        local animID = LoginRolePanel._animLightID
        GUI:removeAllChildren(ui.Node_anim)
        local animIdx = createJob * 2 + createSex + 1
        local setAnimID = nil
        if createJob >= LoginRolePanel._multiJobBeginID and createJob <= LoginRolePanel._multiJobEndID then -- 单独配置
            local jobData   = LoginRolePanel._multiJobData[createJob]
            setAnimID       = jobData and (createSex == GUIDefine.Sex.FEMALE and jobData.createLightFemaleID or jobData.createLightMaleID)
            if not setAnimID then
                return
            end
        end
        local anim = GUI:Effect_Create(ui.Node_anim, "createAnim", pos.x, pos.y, 0, setAnimID or animID[animIdx])
        GUI:stopAllActions(ui.Node_anim)
        GUI:setOpacity(ui.Node_anim, 0)
        GUI:runAction(ui.Node_anim, GUI:ActionFadeIn(0.3))
    end

    local function selectJob(job)
        createJob = job
        -- 设置创角选择职业
        LoginRolePanel._createJob = job
        local normalPath = LoginRolePanel._createJobPath.normal
        local selectPath = LoginRolePanel._createJobPath.select

        local path = createJob == GUIDefine.Job.FIGHTER and selectPath[1] or normalPath[1]
        GUI:Button_loadTextureNormal(ui.Button_job_1, path)
        local path = createJob == GUIDefine.Job.WIZZARD and selectPath[2] or normalPath[2]
        GUI:Button_loadTextureNormal(ui.Button_job_2, path)
        local path = createJob == GUIDefine.Job.TAOIST and selectPath[3] or normalPath[3]
        GUI:Button_loadTextureNormal(ui.Button_job_3, path)

        for i = LoginRolePanel._multiJobBeginID, LoginRolePanel._multiJobEndID do
            if ui["Button_job_" .. i] then
                local path = createJob == i and string.format(LoginRolePanel._multiJobPathS, i) or string.format(LoginRolePanel._multiJobPathN, i)
                GUI:Button_loadTextureNormal(ui["Button_job_" .. i], path)
            end
        end
    end
    
    local function selectSex(sex)
        createSex = sex
        -- 设置创角选择性别
        LoginRolePanel._createSex = sex
        local normalPath = LoginRolePanel._createSexPath.normal
        local selectPath = LoginRolePanel._createSexPath.select
    
        local path = createSex == 0 and selectPath[1] or normalPath[1]
        GUI:Button_loadTextureNormal(ui.Button_sex_1, path)
        local path = createSex == 1 and selectPath[2] or normalPath[2]
        GUI:Button_loadTextureNormal(ui.Button_sex_2, path)
    end

    -- 职业/性别
    GUI:Button_setZoomScale(ui.Button_job_1, 0)
    GUI:addOnClickEvent(ui.Button_job_1, function()
        if GUIFunction:IsFighter(createJob) then
            return false
        end
        selectJob(GUIDefine.Job.FIGHTER)
        updateAnim()
    end)

    GUI:Button_setZoomScale(ui.Button_job_2, 0)
    GUI:addOnClickEvent(ui.Button_job_2, function()
        if createJob == GUIDefine.Job.WIZZARD then
            return false
        end
        selectJob(GUIDefine.Job.WIZZARD)
        updateAnim()
    end)
    

    GUI:Button_setZoomScale(ui.Button_job_3, 0)
    GUI:addOnClickEvent(ui.Button_job_3, function()
        if createJob == GUIDefine.Job.TAOIST then
            return false
        end
        selectJob(GUIDefine.Job.TAOIST)
        updateAnim()
    end)

    for i = LoginRolePanel._multiJobBeginID, LoginRolePanel._multiJobEndID do
        if ui["Button_job_" .. i] then
            local jobData = LoginRolePanel._multiJobData[i]
            local isOpen = jobData and jobData.isOpen
            if isOpen then
                GUI:Button_setZoomScale(ui["Button_job_" .. i], 0)
                GUI:addOnClickEvent(ui["Button_job_" .. i], function()
                    if createJob == i then
                        return false
                    end
                    selectJob(i)
                    updateAnim()
                end)
            end
            GUI:setVisible(ui["Button_job_" .. i], isOpen == true)
        end
    end

    GUI:Button_setZoomScale(ui.Button_sex_1, 0)
    GUI:addOnClickEvent(ui.Button_sex_1, function()
        if createSex == GUIDefine.Sex.MALE then
            return false
        end
        selectSex(GUIDefine.Sex.MALE)
        updateAnim()
    end)
    
    GUI:Button_setZoomScale(ui.Button_sex_2, 0)
    GUI:addOnClickEvent(ui.Button_sex_2, function()
        if createSex == GUIDefine.Sex.FEMALE then
            return false
        end
        selectSex(GUIDefine.Sex.FEMALE)
        updateAnim()
    end)

    if defaultJob and defaultSex then
        selectJob(defaultJob)
        selectSex(defaultSex)
        updateAnim()
    end

    -- 单职业处理 
    if isSingleJob then
        local contentSize = GUI:getContentSize(ui.Panel_info)
        GUI:setPositionX(ui.Button_job_1, contentSize.width * 0.45)
        GUI:setVisible(ui.Button_job_2, false)
        GUI:setVisible(ui.Button_job_3, false)
        if ui.Button_job_r then
            GUI:setVisible(ui.Button_job_r, false)
        end
    end

    if isSingleSex then
        local contentSize = GUI:getContentSize(ui.Panel_info)
        if isSingleSex == GUIDefine.Sex.MALE then
            GUI:setPositionX(ui.Button_sex_1, contentSize.width * 0.45)
            GUI:setVisible(ui.Button_sex_2, false)
        elseif isSingleSex == GUIDefine.Sex.FEMALE then
            GUI:setPositionX(ui.Button_sex_2, contentSize.width * 0.45)
            GUI:setVisible(ui.Button_sex_1, false)
            selectSex(GUIDefine.Sex.FEMALE)
            updateAnim()
        end
    end

    -- 关闭
    GUI:addOnClickEvent(ui.Button_close, function()
        LoginRolePanel.CloseCreateRole()
    end)
end

-- 关闭创角界面
function LoginRolePanel.CloseCreateRole()
    if LoginRolePanel._createUI then
        GUI:stopAllActions(LoginRolePanel._createUI.Button_submit)
        GUI:removeFromParent(LoginRolePanel._createUI.nativeUI)
        LoginRolePanel._createUI = nil
    end

    GUI:setVisible(LoginRolePanel._ui.Node_anim_1, true)
    GUI:setVisible(LoginRolePanel._ui.Node_anim_2, true)

    LoginRolePanel._needAutoIndex = nil
    LoginRolePanel._autoData[LoginRolePanel._autoBtnType.CreateRole] = nil

end

function LoginRolePanel.OnDeleteRole()
    if SL:GetValue("IS_VISITOR_MODE") then
        return
    end

    -- 创角/恢复中
    if LoginRolePanel._createUI or LoginRolePanel._restoreUI then
        return
    end

    if LoginRolePanel._index < 1 or LoginRolePanel._index > 2 then
        return
    end

    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    if not roles[LoginRolePanel._index] then
        return
    end

    local function callback(bType)
        if bType == 1 then
            if LoginRolePanel._index < 1 or LoginRolePanel._index > 2 then
                return
            end
            local roles = SL:GetValue("LOGIN_ROLE_DATAS")
            local roleInfo = roles[LoginRolePanel._index]
            if roleInfo then
                UIOperator:OpenLoadingBarUI()
                SL:RequestLoginDeleteRole(roleInfo.roleid)
            end
        end
    end
    local data = {}
    data.str = string.format("[%s]删除的角色是不能被恢复的，<br>一段时间内您将不能使用相同的角色名称，<br>你真的确定要删除吗？", roles[LoginRolePanel._index].name)
    data.btnDesc = {"确定", "取消"}
    data.callback = callback
    UIOperator:OpenCommonTipsUI(data)
end

function LoginRolePanel.OnRestoreRole()
    if SL:GetValue("IS_VISITOR_MODE") then
        return
    end

    -- 创角中
    if LoginRolePanel._createUI then
        return
    end

    local roles = SL:GetValue("LOGIN_ROLE_DATAS")
    if #roles >= 2 then
        SL:ShowSystemTips("当前已有两角色，无法恢复角色！")
        return
    end

    -- 请求恢复角色列表
    SL:RequestLoginRestoreRoleList()
end

-- 角色恢复展示
function LoginRolePanel.ShowRestoreUI()
    local parent = LoginRolePanel._layer
    GUI:LoadExport(parent, "login_role/login_role_restore")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetValue("SCREEN_WIDTH")
    local screenH = SL:GetValue("SCREEN_HEIGHT")

    local restoreLayout = GUI:getChildByName(parent, "Layout_restore")
    GUI:setPosition(restoreLayout, screenW / 2, screenH / 2)

    LoginRolePanel._restoreUI = GUI:ui_delegate(restoreLayout)
    GUI:removeAllChildren(LoginRolePanel._restoreUI.ListView_1)

    local restoreRoles = SL:GetValue("LOGIN_RESTORE_ROLES_DATA") or {}
    for i, v in ipairs(restoreRoles) do
        local widget = GUI:Widget_Create(LoginRolePanel._restoreUI.ListView_1, "widget" .. i, 0, 0, 300, 30)
        GUI:LoadExport(widget, "login_role/login_role_restore_cell")
        local cell = GUI:getChildByName(widget, "restore_cell")
        local roleName = GUI:getChildByName(cell, "Text_name")
        local roleLevel = GUI:getChildByName(cell, "Text_level")
        local btnRestore = GUI:getChildByName(cell, "btn_restore")

        GUI:Text_setString(roleName, v.uname)
        GUI:Text_setString(roleLevel, v.ulevel)
        GUI:addOnClickEvent(btnRestore, function()
            LoginRolePanel.SubmitRestoreRole(i)
        end)
    end

    GUI:addOnClickEvent(LoginRolePanel._restoreUI.Button_close, function()
        LoginRolePanel.HideRestoreList()
    end)
end

function LoginRolePanel.HideRestoreList()
    if LoginRolePanel._restoreUI then
        GUI:removeFromParent(LoginRolePanel._restoreUI.nativeUI)
        LoginRolePanel._restoreUI = nil
    end
end

function LoginRolePanel.SubmitRestoreRole(index)
    if not index then
        return
    end
    UIOperator:OpenCommonTipsUI({
        str = "是否确定恢复该角色？",
        btnDesc = {"确定", "取消"},
        callback = function(bType)
            if bType == 1 then
                local restoreRoles = SL:GetValue("LOGIN_RESTORE_ROLES_DATA") or {}
                local restoreRoleInfo = restoreRoles[index]
                if restoreRoleInfo then
                    SL:RequestLoginRestoreRole(restoreRoleInfo.uid, restoreRoleInfo.uname)
                end
            end
        end
    })
end

function LoginRolePanel.OnRandNameRefresh(name)
    UIOperator:CloseLoadingBarUI()
    if LoginRolePanel._createUI then
        LoginRolePanel._isRandName = true
        GUI:Text_setString(LoginRolePanel._createUI.TextInput_name, name)
    end
end

function LoginRolePanel.OnCreateRoleSuccess()
    UIOperator:CloseLoadingBarUI()

    -- 创角成功直接进入游戏
    UIOperator:OpenLoadingBarUI()
    SL:RequestLoginEnterGame()
end

function LoginRolePanel.OnCreateRoleFail(errorCode)
    UIOperator:CloseLoadingBarUI()

    if errorCode == 1 then
        SL:ShowSystemTips("创建失败：角色名重复！")
    elseif errorCode == 2 then
        SL:ShowSystemTips("创建失败：角色名非法！")
    elseif errorCode == 3 then
        SL:ShowSystemTips("最多可创建2位角色！")
    elseif errorCode == 5 then
        SL:ShowSystemTips("命名含有错误字符，请重新输入！")
    elseif errorCode == 6 then
        SL:ShowSystemTips("角色名不得低于两个字符")
    elseif errorCode == 7 then
        SL:ShowSystemTips("当前服务器已爆满，请更换其他服务器创建")
    elseif errorCode == 100 then
        SL:ShowSystemTips("不允许建立新人物")
    elseif errorCode == 101 then
        SL:ShowSystemTips("禁止建立包含数字的人物名")
    elseif errorCode == 102 then
        SL:ShowSystemTips("禁止建立全英文人物名称")
    elseif errorCode == 103 then
        SL:ShowSystemTips("禁止角色名包含特殊字符")
    elseif errorCode == 999 then
        SL:ShowSystemTips("创建失败：数据有误！")
    else
        SL:ShowSystemTips("创建失败: 错误码 "..tostring(errorCode))
    end 
end

function LoginRolePanel.OnDeleteRoleSuccess()
    UIOperator:CloseLoadingBarUI()
    SL:ShowSystemTips("玩家角色已删除！")
    LoginRolePanel.OnUpdateRoles()
end

function LoginRolePanel.OnDeleteRoleFail()
    UIOperator:CloseLoadingBarUI()
    SL:ShowSystemTips("删除角色失败！")
end

function LoginRolePanel.OnRefreshRestoreList()
    local restoreRoles = SL:GetValue("LOGIN_RESTORE_ROLES_DATA")
    if #restoreRoles == 0 then
        SL:ShowSystemTips("你没有可以恢复的角色！")
        return
    end

    if LoginRolePanel._restoreUI then
        return
    end

    LoginRolePanel.ShowRestoreUI()
end

function LoginRolePanel.OnRoleEnterGameDelay()
    local exitCD = SL:GetValue("GAME_DATA", "buttonSmall") or 0
    if exitCD == 0 then
        return
    end

    LoginRolePanel._reloginCD = true

    -- 小退CD
    local interval = 1 / 60
    local exitTime = exitCD * 0.001
    local remaining = exitTime

    local btnSize = GUI:getContentSize(LoginRolePanel._ui.Button_start)
    local layoutSize = {width = 100, height = 40}       -- 遮罩大小
    local blackLayout = GUI:Layout_Create(LoginRolePanel._ui.Button_start, "blackLayout", 0, 0, layoutSize.width, layoutSize.height)
    GUI:setAnchorPoint(blackLayout, 0.5, 0)
    GUI:setPosition(blackLayout, btnSize.width / 2, 10)
    GUI:Layout_setBackGroundColorType(blackLayout, 1)
    GUI:Layout_setBackGroundColor(blackLayout, "#000000")
    GUI:Layout_setBackGroundColorOpacity(blackLayout, 150)

    local originHei = layoutSize.height
    local function callBack()
        remaining = math.max(remaining - interval, 0)
        local hei = remaining / exitTime * originHei
        GUI:setContentSize(blackLayout, layoutSize.width, hei)

        if remaining == 0 then
            LoginRolePanel._reloginCD = false
            GUI:stopAllActions(blackLayout)
            GUI:removeFromParent(blackLayout)
        end
    end
    SL:schedule(blackLayout, callBack, interval)
end

function LoginRolePanel.OnLoginRoleInfo()
    LoginRolePanel.CloseCreateRole()
    LoginRolePanel.OnUpdateRoles(true)
end

function LoginRolePanel.OnRestoreRoleSuccess()
    SL:ShowSystemTips("恢复成功")
    SL:RequestLoginRoleInfo()

    LoginRolePanel.HideRestoreList()
end

function LoginRolePanel.OnRestoreRoleFail(errorCode)
    if not errorCode then
        return
    end
    if errorCode == -1 then
        SL:ShowSystemTips("禁止恢复")
    elseif errorCode == 0 then
        SL:ShowSystemTips("恢复失败")
    end
end

function LoginRolePanel.OnCloseWin(id)
    if id == UIConst.LAYERID.LoginRoleGUI then
        SL:CloseLoginTradeLockUI()
    end
end
-------------------------------------------------------------------------
function LoginRolePanel.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_RAND_ROLE_NAME_REFRESH, "LoginRolePanel", LoginRolePanel.OnRandNameRefresh, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CREATE_ROLE_SUCCESS, "LoginRolePanel", LoginRolePanel.OnCreateRoleSuccess, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_CREATE_ROLE_FAIL, "LoginRolePanel", LoginRolePanel.OnCreateRoleFail, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_DELETE_ROLE_SUCCESS, "LoginRolePanel", LoginRolePanel.OnDeleteRoleSuccess, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_DELETE_ROLE_FAIL, "LoginRolePanel", LoginRolePanel.OnDeleteRoleFail, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_RESTORE_ROLE_DATA_REFRESH, "LoginRolePanel", LoginRolePanel.OnRefreshRestoreList, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_ROLE_ENTER_GAME_DELAY, "LoginRolePanel", LoginRolePanel.OnRoleEnterGameDelay, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_ROLE_INFO_DATA, "LoginRolePanel", LoginRolePanel.OnLoginRoleInfo, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_RESTORE_ROLE_SUCCESS, "LoginRolePanel", LoginRolePanel.OnRestoreRoleSuccess, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_LOGIN_RESTORE_ROLE_FAIL, "LoginRolePanel", LoginRolePanel.OnRestoreRoleFail, LoginRolePanel._layer)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "LoginRolePanel", LoginRolePanel.OnCloseWin)
end

-------------------------------------------------------------------------

LoginRolePanel.main()