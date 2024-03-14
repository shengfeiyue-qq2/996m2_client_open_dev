LoginRolePanel = {}

LoginRolePanel.animLightID  = {4121, 4127, 4123, 4129, 4125, 4131}      -- 人物常亮动画id  顺序：男战士、女战士、男法师、女法师、男道士、女道士
LoginRolePanel.animGToLID   = {4122, 4128, 4124, 4130, 4126, 4132}      -- 人物灰到亮动画id   
LoginRolePanel.animPos      = {x=0, y=170}                              -- 人物特效位置    (基于 Node_anim_1/2)
LoginRolePanel.animScale    = {1, 1}                                    -- 左右动画缩放

LoginRolePanel.createJobPath= {         -- 创角页职业图标路径
    normal={
        [1] = "res/private/login/icon_cjzy_01.png",
        [2] = "res/private/login/icon_cjzy_02.png",
        [3] = "res/private/login/icon_cjzy_03.png",
    },
    select={
        [1] = "res/private/login/icon_cjzy_01_1.png",
        [2] = "res/private/login/icon_cjzy_02_1.png",
        [3] = "res/private/login/icon_cjzy_03_1.png",
    },
}

LoginRolePanel.createSexPath= {         -- 创角页性别图标路径
    normal={
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

function LoginRolePanel.main()
    LoginRolePanel._CreateUI = nil
    LoginRolePanel._RestoreUI = nil
    LoginRolePanel._index = -1

    local parent = GUI:Attach_Parent()
    LoginRolePanel._parent = parent
    GUI:LoadExport(parent, "login_role/login_role")

    local ui = GUI:ui_delegate(parent)
    LoginRolePanel.ui = ui

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    local Panel_touch = ui["Panel_touch"]
    GUI:setContentSize(Panel_touch, screenW, screenH)

    local Panel_bg = ui["Panel_bg"]
    GUI:setPosition(Panel_bg, screenW/2, screenH/2)
    GUI:Layout_setBackGroundImage(Panel_bg, "res/private/login/bg_cjzy_02.jpg")

    -- 服务器名
    local Text_server = ui["Text_server_name"]
    GUI:Text_setString(Text_server, SL:GetMetaValue("SERVER_NAME"))

    -- role
    local function selectRole(index) 
        -- 创角/恢复中
        if LoginRolePanel._CreateUI or LoginRolePanel._RestoreUI then
            return
        end

        local roles = SL:GetMetaValue("LOGIN_DATA")
        if not roles[index] then
            return false
        end
        LoginRolePanel.OnSelectRole(index)
    end

    GUI:addOnClickEvent(ui.Button_select_1, function()
        selectRole(1)
    end)
    
    GUI:addOnClickEvent(ui.Panel_role_1, function()
        selectRole(1)
    end)
    
    GUI:addOnClickEvent(ui.Button_select_2, function()
        selectRole(2)
    end)

    GUI:addOnClickEvent(ui.Panel_role_2, function()
        selectRole(2)
    end)

    -- 
    LoginRolePanel._openJob = {0, 1, 2}
    LoginRolePanel._multiJobData = {}
    for i = 5, 15 do
        local jobData   = SL:GetMetaValue("GAME_DATA", "MultipleJobSetMap")[i]
        local isOpen    = jobData and jobData.isOpen
        if isOpen then
            table.insert(LoginRolePanel._openJob, i)
            LoginRolePanel._multiJobData[i] = jobData
        end
    end
end

-- 更新角色信息 
function LoginRolePanel.UpdateRoles()
    local roles = SL:GetMetaValue("LOGIN_DATA")
    -- level 等级 name 昵称 job 职业 012
    local jobName = {"战士", "法师", "道士"}
    local function getJobName(job)
        if job >= 5 and job <= 15 then
            local jobData   = LoginRolePanel._multiJobData[job]
            local str       = jobData and jobData.name or string.format("未命名%s", job)
            return str
        end
        return jobName[job + 1]
    end
    --
    for i = 1, 2 do
        GUI:Text_setString(LoginRolePanel.ui["Text_level_"..i], "")
        GUI:Text_setString(LoginRolePanel.ui["Text_name_"..i], "")
        GUI:Text_setString(LoginRolePanel.ui["Text_job_"..i], "")

        if roles[i] then
            GUI:Text_setString(LoginRolePanel.ui["Text_level_"..i], roles[i].level .. "级")
            GUI:Text_setString(LoginRolePanel.ui["Text_name_"..i], roles[i].name)
            GUI:Text_setString(LoginRolePanel.ui["Text_job_"..i], getJobName(roles[i].job))
        end
    end 
end

function LoginRolePanel.SelectRole(index, isInit)
    LoginRolePanel._index = index

    if not isInit then
        SL:PlaySelectRoleAudio()
    end

    local animID = LoginRolePanel.animLightID
    local animGID = LoginRolePanel.animGToLID
    local position = LoginRolePanel.animPos
    local animScale = LoginRolePanel.animScale or {1, 1}

    local roles = SL:GetMetaValue("LOGIN_DATA")
    if animID and animGID and position then
        for i = 1, 2 do
            local scale = animScale[i]
            GUI:removeAllChildren(LoginRolePanel.ui["Node_anim_" .. i])
            if roles[i] then
                local job = roles[i].job
                local sex = roles[i].sex
                local animIdx = job * 2 + sex + 1
                local needOpen = job >= 5 and job <= 15
                local setAnimGToLID = nil
                local setAnimLID = nil
                if needOpen then
                    local jobData = LoginRolePanel._multiJobData[job]
                    setAnimGToLID = jobData and (sex == 1 and jobData.animGToLFemaleID or jobData.animGToLMaleID)
                    setAnimLID = jobData and (sex == 1 and jobData.createLightFemaleID or jobData.createLightMaleID)
                end
                local animLightID = needOpen and setAnimLID or animID[animIdx]
                local animGToLID = needOpen and setAnimGToLID or animGID[animIdx]
                if LoginRolePanel._index == i then
                    if isInit then
                        if animLightID then
                            local anim = GUI:Effect_Create(LoginRolePanel.ui["Node_anim_" .. i], "role_effect" .. i, position.x, position.y, 0, animLightID)
                            GUI:setScale(anim, scale)
                        end
                    else
                        if animGToLID then
                            local animG = GUI:Effect_Create(LoginRolePanel.ui["Node_anim_" .. i], "role_effect_G" .. i, position.x, position.y, 0, animGToLID)
                            GUI:setScale(animG, scale)
                            GUI:Effect_addOnCompleteEvent(animG, function()
                                GUI:removeFromParent(animG)
                                if animLightID then
                                    local anim = GUI:Effect_Create(LoginRolePanel.ui["Node_anim_" .. i], "role_effect" .. i, position.x, position.y, 0, animLightID)
                                    GUI:setScale(anim, scale)
                                end
                            end)
                        end

                        local sfx = GUI:Effect_Create(LoginRolePanel.ui["Node_anim_" .. i], "role_sfx" .. i, position.x, position.y, 0, 4114)
                        GUI:Effect_addOnCompleteEvent(sfx, function()
                            GUI:removeFromParent(sfx)
                        end)
                    end
                else
                    if isInit then
                        if animGToLID then
                            local animG = GUI:Effect_Create(LoginRolePanel.ui["Node_anim_" .. i], "role_effect_G" .. i, position.x, position.y, 0, animGToLID)
                            GUI:setScale(animG, scale)
                            GUI:Effect_play(animG, 0, 0, false, 1, false)
                            GUI:Effect_stop(animG, 1)
                        end
                    else
                        if animGToLID then
                            local animG = GUI:Effect_Create(LoginRolePanel.ui["Node_anim_" .. i], "role_effect_G" .. i, position.x, position.y, 0, animGToLID)
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

function LoginRolePanel.ShowDelete()
    if LoginRolePanel._index < 1 or LoginRolePanel._index > 2 then
        return false
    end
    local roles = SL:GetMetaValue("LOGIN_DATA")
    if not roles[LoginRolePanel._index] then
        return false
    end

    local function callback(bType)
        if bType == 1 then
            if LoginRolePanel._index < 1 or LoginRolePanel._index > 2 then
                return false
            end
            LoginRolePanel.OnDeleteRole(LoginRolePanel._index)
        end
    end
    local data = {}
    data.str = string.format("[%s]删除的角色是不能被恢复的，<br>一段时间内您将不能使用相同的角色名称，<br>你真的确定要删除吗？", roles[LoginRolePanel._index].name)
    data.btnDesc = {"确定", "取消"}
    data.callback = callback
    SL:OpenCommonTipsPop(data)
end

function LoginRolePanel.ShowCreateRole(isAuto)
    if LoginRolePanel._CreateUI then
        return
    end
    
    LoginRolePanel.createRole(LoginRolePanel._parent)

    -- 官方实现
    LoginRolePanel.OnCreateRole()

end

function LoginRolePanel.createRole(parent)
    GUI:LoadExport(parent, "login_role/login_role_create")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    local Panel_role = GUI:getChildByName(parent, "Panel_role")
    GUI:setPosition(Panel_role, screenW/2, screenH/2)

    LoginRolePanel._CreateUI = GUI:ui_delegate(Panel_role)

    local defaultJob = 0
    local defaultSex = 0

    local isRandomJob = SL:GetMetaValue("GAME_DATA", "isRandomJob") and tonumber(SL:GetMetaValue("GAME_DATA", "isRandomJob")) ~= 0
    local isRandomSex = SL:GetMetaValue("GAME_DATA", "isRandomSex") and tonumber(SL:GetMetaValue("GAME_DATA", "isRandomSex")) ~= 0
    local isSingleJob = SL:GetMetaValue("GAME_DATA", "isSingleJob") and tonumber(SL:GetMetaValue("GAME_DATA", "isSingleJob")) ~= 0
    local isSingleSex = SL:GetMetaValue("GAME_DATA", "isSingleSex") and tonumber(SL:GetMetaValue("GAME_DATA", "isSingleSex")) ~= 0

    -- 随机职业
    if not isSingleJob and isRandomJob then
        local num = #LoginRolePanel._openJob
        local index = Random(1, num)
        defaultJob = LoginRolePanel._openJob[index]
    end
    -- 随机性别
    if not isSingleSex and isRandomSex then
        defaultSex = Random(0, 1)
    end

    -- 默认职业
    local setJob = tonumber(SL:GetMetaValue("GAME_DATA", "defaultJob"))
    if setJob then
        defaultJob = setJob
        if isSingleJob then
            isSingleJob = defaultJob
        end
    end

    local isSingleSex
    if SL:GetMetaValue("GAME_DATA", "isSingleSex") then
        if SL:GetMetaValue("GAME_DATA","isSingleSex") == "boy" or SL:GetMetaValue("GAME_DATA","isSingleSex") == 1 then
            isSingleSex = 0
        elseif SL:GetMetaValue("GAME_DATA","isSingleSex") == "girl" or SL:GetMetaValue("GAME_DATA","isSingleSex") == 2 then
            isSingleSex = 1
        end
    end

    -- 显示刷新/功能添加
    GUI:setVisible(LoginRolePanel.ui.Node_anim_1, false)
    GUI:setVisible(LoginRolePanel.ui.Node_anim_2, false)

    local createJob = -1
    local createSex = -1

    local contentSize = GUI:getContentSize(Panel_role)
    GUI:setPositionX(ui.Panel_anim, contentSize.width / 2)
    GUI:setPositionX(ui.Panel_info, contentSize.width / 2)
    local roles = SL:GetMetaValue("LOGIN_DATA")
    if #roles > 0 then
        GUI:setAnchorPoint(ui.Panel_anim, 0, 1)
        GUI:setPositionX(ui.Panel_anim, contentSize.width / 2)
        GUI:setAnchorPoint(ui.Panel_info, 1, 1)
        GUI:setPositionX(ui.Panel_info, contentSize.width / 2)
    end

    local function updateAnim()
        -- 创建角色展示动画
        local pos = LoginRolePanel.animPos
        local animID = LoginRolePanel.animLightID
        GUI:removeAllChildren(ui.Node_anim)
        local animIdx = createJob*2 + createSex + 1
        local setAnimID = nil
        if createJob >= 5 and createJob <= 15 then -- 单独配置
            local jobData   = LoginRolePanel._multiJobData[createJob]
            setAnimID       = jobData and (createSex == 1 and jobData.createLightFemaleID or jobData.createLightMaleID)
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
        local normalPath = LoginRolePanel.createJobPath.normal
        local selectPath = LoginRolePanel.createJobPath.select

        local path = createJob == 0 and selectPath[1] or normalPath[1]
        GUI:Button_loadTextureNormal(ui.Button_job_1, path)
        local path = createJob == 1 and selectPath[2] or normalPath[2]
        GUI:Button_loadTextureNormal(ui.Button_job_2, path)
        local path = createJob == 2 and selectPath[3] or normalPath[3]
        GUI:Button_loadTextureNormal(ui.Button_job_3, path)

        for i = 5, 15 do
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
        local normalPath = LoginRolePanel.createSexPath.normal
        local selectPath = LoginRolePanel.createSexPath.select
    
        local path = createSex == 0 and selectPath[1] or normalPath[1]
        GUI:Button_loadTextureNormal(ui.Button_sex_1, path)
        local path = createSex == 1 and selectPath[2] or normalPath[2]
        GUI:Button_loadTextureNormal(ui.Button_sex_2, path)
    end

    -- 职业/性别
    GUI:Button_setZoomScale(ui.Button_job_1, 0)
    GUI:addOnClickEvent(ui.Button_job_1, function()
        if createJob == 0 then
            return false
        end
        selectJob(0)
        updateAnim()
    end)

    GUI:Button_setZoomScale(ui.Button_job_2, 0)
    GUI:addOnClickEvent(ui.Button_job_2, function()
        if createJob == 1 then
            return false
        end
        selectJob(1)
        updateAnim()
    end)
    

    GUI:Button_setZoomScale(ui.Button_job_3, 0)
    GUI:addOnClickEvent(ui.Button_job_3, function()
        if createJob == 2 then
            return false
        end
        selectJob(2)
        updateAnim()
    end)

    for i = 5, 15 do
        if ui["Button_job_" .. i] then
            local jobData   = LoginRolePanel._multiJobData[i]
            local isOpen    = jobData and jobData.isOpen
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
        if createSex == 0 then
            return false
        end
        selectSex(0)
        updateAnim()
    end)
    
    GUI:Button_setZoomScale(ui.Button_sex_2, 0)
    GUI:addOnClickEvent(ui.Button_sex_2, function()
        if createSex == 1 then
            return false
        end
        selectSex(1)
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
        if isSingleSex == 0 then
            GUI:setPositionX(ui.Button_sex_1, contentSize.width * 0.45)
            GUI:setVisible(ui.Button_sex_2, false)
        elseif isSingleSex == 1 then
            GUI:setPositionX(ui.Button_sex_2, contentSize.width * 0.45)
            GUI:setVisible(ui.Button_sex_1, false)
            selectSex(1)
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
    if LoginRolePanel._CreateUI then
        GUI:removeFromParent(LoginRolePanel._CreateUI.nativeUI)
        LoginRolePanel._CreateUI = nil
    end

    GUI:setVisible(LoginRolePanel.ui.Node_anim_1, true)
    GUI:setVisible(LoginRolePanel.ui.Node_anim_2, true)

    -- 官方实现
    LoginRolePanel.OnCloseCreateRole()
end

-- 角色恢复展示
function LoginRolePanel.createRestore()
    local parent = LoginRolePanel._parent
    GUI:LoadExport(parent, "login_role/login_role_restore")
    local ui = GUI:ui_delegate(parent)

    local screenW = SL:GetMetaValue("SCREEN_WIDTH")
    local screenH = SL:GetMetaValue("SCREEN_HEIGHT")

    local Layout_restore = GUI:getChildByName(parent, "Layout_restore")
    GUI:setPosition(Layout_restore, screenW/2, screenH/2)

    LoginRolePanel._RestoreUI = GUI:ui_delegate(Layout_restore)

    GUI:removeAllChildren(LoginRolePanel._RestoreUI.ListView_1)

    local restoreRoles = SL:GetMetaValue("RESTORE_ROLES") or {}
    for i, v in ipairs(restoreRoles) do
        local widget = GUI:Widget_Create(LoginRolePanel._RestoreUI.ListView_1, "widget" .. i, 0, 0, 300, 30)
        GUI:LoadExport(widget, "login_role/login_role_restore_cell")
        local cell = GUI:getChildByName(widget, "restore_cell")
        local roleName = GUI:getChildByName(cell, "Text_name")
        local roleLevel = GUI:getChildByName(cell, "Text_level")
        local btnRestore = GUI:getChildByName(cell, "btn_restore")

        GUI:Text_setString(roleName, v.uname)
        GUI:Text_setString(roleLevel, v.ulevel)
        GUI:addOnClickEvent(btnRestore, function()
            LoginRolePanel.OnRestoreRole(i)
        end)
    end

    GUI:addOnClickEvent(LoginRolePanel._RestoreUI.Button_close, function()
        LoginRolePanel.HideRestoreList()
    end)
end

function LoginRolePanel.HideRestoreList()
    if LoginRolePanel._RestoreUI then
        GUI:removeFromParent(LoginRolePanel._RestoreUI.nativeUI)
        LoginRolePanel._RestoreUI = nil
    end
end