-- 角色面板 装备
PlayerEquip = {}

PlayerEquip._ui = nil

-- 13 斗笠位置比较特殊 属于和头盔位置同部位
PlayerEquip.samePosDiff = {} -- 相同部位分开

PlayerEquip._hideNodePos = {}
PlayerEquip.RoleType = {
    Self = 1 -- 自己
}
function PlayerEquip.main(data)
    PlayerEquip.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player/player_equip_node_win32")

    PlayerEquip._ui = GUI:ui_delegate(parent)
    if not PlayerEquip._ui then
        return false
    end
    PlayerEquip._parent = parent

    -- 初始化装备槽
    PlayerEquip.InitEquipCells()
    -- 角色性别
    PlayerEquip.playerSex = SL:GetMetaValue("SEX")
    -- 发型
    PlayerEquip.playerHairID = SL:GetMetaValue("HAIR")
    -- 职业
    PlayerEquip.playerJob = SL:GetMetaValue("JOB")

    -- 首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 -- 首饰盒功能是否开启
    GUI:setVisible(PlayerEquip._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(PlayerEquip._ui.Best_ringBox,function()
        -- 请求玩家首饰盒状态
        SL:RequestOpenPlayerBestRings()

        GUI:delayTouchEnabled(PlayerEquip._ui.Best_ringBox, 0.3)
    end)
    --刷新首饰盒状态
    PlayerEquip.RefreshPlayerBestRingsOpenState()
    PlayerEquip.RefreshBestRingBox()
    ----------------------
    --刷新行会信息
    PlayerEquip.RefreshGuildInfo()
    ----------------------
    PlayerEquip.RegisterEvent()
end

function PlayerEquip.InitHideNodePos()
    PlayerEquip._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if PlayerEquip._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(PlayerEquip._ui[string.format("Node_%s", i)])
            if not visible then
                PlayerEquip._hideNodePos[i] = true
            end
        end
    end
end

function PlayerEquip.InitEquipCells()
    local uid = SL:GetMetaValue("USER_ID")
    -- 请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    -- 额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerEquip.posSetting, 14)
        table.insert(PlayerEquip.posSetting, 15)
    else
        GUI:setVisible(PlayerEquip._ui.Panel_pos14, false)
        GUI:setVisible(PlayerEquip._ui.Panel_pos15, false)
        GUI:setVisible(PlayerEquip._ui.Node_14, false)
        GUI:setVisible(PlayerEquip._ui.Node_15, false)

        local pos10x = (GUI:getPositionX(PlayerEquip._ui.Panel_pos9) + GUI:getPositionX(PlayerEquip._ui.Panel_pos10)) / 2 + 8
        local pos12x = (GUI:getPositionX(PlayerEquip._ui.Panel_pos11) + GUI:getPositionX(PlayerEquip._ui.Panel_pos12)) / 2 - 8
        local pos15x = GUI:getPositionX(PlayerEquip._ui.Panel_pos15)
        local pos14x = GUI:getPositionX(PlayerEquip._ui.Panel_pos14)
        GUI:setPositionX(PlayerEquip._ui.Panel_pos10, pos10x)
        GUI:setPositionX(PlayerEquip._ui.Panel_pos11, pos12x)
        GUI:setPositionX(PlayerEquip._ui.Panel_pos12, pos15x)
        GUI:setPositionX(PlayerEquip._ui.Panel_pos9, pos14x)

        GUI:setPositionX(PlayerEquip._ui.Node_10, pos10x)
        GUI:setPositionX(PlayerEquip._ui.Node_11, pos12x)
        GUI:setPositionX(PlayerEquip._ui.Node_12, pos15x)
        GUI:setPositionX(PlayerEquip._ui.Node_9, pos14x)
    end
end

function PlayerEquip.RefreshGuildInfo()
    local textGuildInfo = PlayerEquip._ui.Text_guildinfo
    local guildData = SL:GetMetaValue("GUILD_INFO") -- 行会数据
    local myGuildName = guildData.guildName
    local myJobName = SL:GetMetaValue("GUILD_OFFICIAL", guildData.rank)
    if not myGuildName then
        return
    end
    myJobName = myJobName or ""

    local guildInfo = myGuildName .. " " .. myJobName
    GUI:Text_setString(textGuildInfo, guildInfo)

    local color = SL:GetMetaValue("USER_NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

function PlayerEquip.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip.RoleType.Self)
    if activeState then
        GUI:Image_setGrey(PlayerEquip._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip._ui.Image_box, true)
    end
    
    local function mouseMoveCallBack(touchPos)
        if not GUI:getVisible(PlayerEquip._ui.Best_ringBox) then 
            return
        end
        local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
        if SL:CheckNodeCanCallBack(PlayerEquip._ui.Best_ringBox, touchPos) and bestRingsName ~= "" then
            local tips = nil
            local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip.RoleType.Self)
            if activeState then
                tips = string.format("点击打开%s", bestRingsName)
            else
                tips = string.format("%s未开启", bestRingsName)
            end
            local worldPos = GUI:getWorldPosition(PlayerEquip._ui.Best_ringBox)
            worldPos.x = GUI:getContentSize(PlayerEquip._ui.Best_ringBox).width/2 + worldPos.x
            GUI:ShowWorldTips(tips, worldPos, GUI:p(0.5, 1))
        end
    end

    local function leaveItem()
        GUI:HideWorldTips()
    end

    GUI:addMouseMoveEvent(PlayerEquip._ui.Best_ringBox,
        {
            onEnterFunc = mouseMoveCallBack,
            onLeaveFunc = leaveItem
        }
    )
    if data and data.isOpen then
        if activeState then
            SL:OpenBestRingBoxUI(PlayerEquip.RoleType.Self, { param = {} })
        end
    end
end

function PlayerEquip.RefreshBestRingBox()
    SL:scheduleOnce(PlayerEquip._ui.Best_ringBox,function()
        if self and PlayerEquip._ui.Best_ringBox then
            local texture = "btn_jewelry_1_1.png"
            if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", PlayerEquip.RoleType.Self) then -- 首饰盒界面是否打开
                texture = "btn_jewelry_1_0.png"
            end
            GUI:Image_loadTexture(PlayerEquip._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_win32/" .. texture)
            -- 重置尺寸
            GUI:setIgnoreContentAdaptWithSize(PlayerEquip._ui.Image_box, true)
        end
        PlayerEquip.RefreshPlayerBestRingsOpenState()
    end,0.1)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerEquip.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function PlayerEquip.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function PlayerEquip.CloseCallback()
    PlayerEquip.UnRegisterEvent()
end

function PlayerEquip.RegisterEvent()
    --刷新行会信息
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_GUILD_INFO_CHANGE, "PlayerEquip", PlayerEquip.RefreshGuildInfo)
end

function PlayerEquip.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_GUILD_INFO_CHANGE, "PlayerEquip")
end