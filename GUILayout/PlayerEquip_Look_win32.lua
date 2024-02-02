-- 查看他人面板 装备
PlayerEquip_Look = {}

PlayerEquip_Look._ui = nil

-- 13 斗笠位置比较特殊 属于和头盔位置同部位
PlayerEquip_Look.samePosDiff = {} -- 相同部位分开

PlayerEquip_Look._hideNodePos = {}
PlayerEquip_Look.RoleType = {
    Other = 11 -- 查看他人
}
function PlayerEquip_Look.main(data)
    PlayerEquip_Look.posSetting = {
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16
    }
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "player_look/player_equip_node_win32")

    PlayerEquip_Look._ui = GUI:ui_delegate(parent)
    if not PlayerEquip_Look._ui then
        return false
    end
    PlayerEquip_Look._parent = parent

    -- 初始化装备槽
    PlayerEquip_Look.InitEquipCells()
    -- 角色性别
    PlayerEquip_Look.playerSex = SL:GetMetaValue("L.M.SEX")
    -- 发型
    PlayerEquip_Look.playerHairID = SL:GetMetaValue("L.M.HAIR")
    -- 职业
    PlayerEquip_Look.playerJob = SL:GetMetaValue("L.M.JOB")
    

    -- 首饰盒
    local ringBoxShow = SL:GetMetaValue("SERVER_OPTION", SW_KEY_SNDAITEMBOX) == 1 -- 首饰盒功能是否开启
    GUI:setVisible(PlayerEquip_Look._ui.Best_ringBox, ringBoxShow)
    GUI:addOnClickEvent(PlayerEquip_Look._ui.Best_ringBox,function()
        --首饰盒是否开启
        local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look.RoleType.Other)
        if activeState then
            SL:OpenBestRingBoxUI(PlayerEquip_Look.RoleType.Other, { param = {} })
        else
            --提示
            local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
            local worldPos = GUI:getTouchEndPosition(PlayerEquip_Look._ui.Best_ringBox)
            GUI:ShowWorldTips(string.format("%s未开启", bestRingsName), worldPos, GUI:p(0, 1))
        end
    end)
    --刷新首饰盒状态
    PlayerEquip_Look.RefreshPlayerBestRingsOpenState()
    PlayerEquip_Look.RefreshBestRingBox()
    ----------------------
    --刷新行会信息
    PlayerEquip_Look.RefreshGuildInfo()
    ----------------------
    PlayerEquip_Look.RegisterEvent()
end

function PlayerEquip_Look.InitHideNodePos()
    PlayerEquip_Look._hideNodePos = {}
    local posList = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 55}
    for _, i in ipairs(posList) do
        if PlayerEquip_Look._ui[string.format("Node_%s", i)] then
            local visible = GUI:getVisible(PlayerEquip_Look._ui[string.format("Node_%s", i)])
            if not visible then
                PlayerEquip_Look._hideNodePos[i] = true
            end
        end
    end
end

function PlayerEquip_Look.InitEquipCells()
    local uid = SL:GetMetaValue("LOOK_USER_ID")

    --请求通知脚本查看uid的珍宝
    SL:RequestLookZhenBao(uid)
    -- 额外的装备位置
    local equipPosSet = SL:GetMetaValue("SERVER_OPTION", SW_KEY_EQUIP_EXTRA_POS) or 0
    local showExtra = equipPosSet == 1
    if showExtra then
        table.insert(PlayerEquip_Look.posSetting, 14)
        table.insert(PlayerEquip_Look.posSetting, 15)
    else
        GUI:setVisible(PlayerEquip_Look._ui.Panel_pos14, false)
        GUI:setVisible(PlayerEquip_Look._ui.Panel_pos15, false)
        GUI:setVisible(PlayerEquip_Look._ui.Node_14, false)
        GUI:setVisible(PlayerEquip_Look._ui.Node_15, false)

        local pos10x = (GUI:getPositionX(PlayerEquip_Look._ui.Panel_pos9) + GUI:getPositionX(PlayerEquip_Look._ui.Panel_pos10)) / 2 + 8
        local pos12x = (GUI:getPositionX(PlayerEquip_Look._ui.Panel_pos11) + GUI:getPositionX(PlayerEquip_Look._ui.Panel_pos12)) / 2 - 8
        local pos15x = GUI:getPositionX(PlayerEquip_Look._ui.Panel_pos15)
        local pos14x = GUI:getPositionX(PlayerEquip_Look._ui.Panel_pos14)
        GUI:setPositionX(PlayerEquip_Look._ui.Panel_pos10, pos10x)
        GUI:setPositionX(PlayerEquip_Look._ui.Panel_pos11, pos12x)
        GUI:setPositionX(PlayerEquip_Look._ui.Panel_pos12, pos15x)
        GUI:setPositionX(PlayerEquip_Look._ui.Panel_pos9, pos14x)

        GUI:setPositionX(PlayerEquip_Look._ui.Node_10, pos10x)
        GUI:setPositionX(PlayerEquip_Look._ui.Node_11, pos12x)
        GUI:setPositionX(PlayerEquip_Look._ui.Node_12, pos15x)
        GUI:setPositionX(PlayerEquip_Look._ui.Node_9, pos14x)
    end
end

function PlayerEquip_Look.RefreshGuildInfo()
    local textGuildInfo = PlayerEquip_Look._ui.Text_guildinfo
    local guildData = SL:GetMetaValue("L.M.GUILD_INFO") --行会数据
    local myGuildName = guildData.guildName
    local myJobName = guildData.rankName
    if not myGuildName then
        return
    end
    myJobName = myJobName or ""

    local guildInfo = myGuildName .. " " .. myJobName
    GUI:Text_setString(textGuildInfo, guildInfo)

    local color = SL:GetMetaValue("LOOK_USER_NAME_COLOR")
    if color and color > 0 then
        SL:SetColorStyle(textGuildInfo, color)
    end
end

function PlayerEquip_Look.RefreshPlayerBestRingsOpenState(data)
    local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look.RoleType.Other)
    if activeState then
        GUI:Image_setGrey(PlayerEquip_Look._ui.Image_box, false)
    else
        GUI:Image_setGrey(PlayerEquip_Look._ui.Image_box, true)
    end
    
    local function mouseMoveCallBack(touchPos)
        if not GUI:getVisible(PlayerEquip_Look._ui.Best_ringBox) then 
            return
        end
        local bestRingsName = SL:GetMetaValue("SERVER_OPTION", "SndaItemBoxName") or "首饰盒"
        if SL:CheckNodeCanCallBack(PlayerEquip_Look._ui.Best_ringBox, touchPos) and bestRingsName ~= "" then
            local activeState = SL:GetMetaValue("BEST_RING_OPENSTATE", PlayerEquip_Look.RoleType.Other)
            local playerName = SL:GetMetaValue("LOOK_USER_NAME")
            local tipsStr = ""
            if activeState then
                tipsStr = string.format("点击打开%s",bestRingsName)
            else
                tipsStr = string.format("%s的%s未开启",playerName,bestRingsName)
            end
            local tips = GUI:GetWordTips(tipsStr) 
            
            GUI:setAnchorPoint(tips,0.5, 1)
            GUI:setPosition(tips,GUI:getContentSize(PlayerEquip_Look._ui.Best_ringBox).width/2, 10)
            GUI:setName(tips,"TIPS")
            GUI:addChild(PlayerEquip_Look._ui.Best_ringBox,tips)
        end
    end

    local function leaveItem()
        local nodeTips = GUI:getChildByName(PlayerEquip_Look._ui.Best_ringBox,"TIPS")
        if nodeTips then
            GUI:removeFromParent(nodeTips)
            nodeTips = nil
        end
    end

    GUI:addMouseMoveEvent(PlayerEquip_Look._ui.Best_ringBox,
        {
            onEnterFunc = mouseMoveCallBack,
            onLeaveFunc = leaveItem
        }
    )
    if data and data.isOpen then
        if activeState then
            SL:OpenBestRingBoxUI(PlayerEquip_Look.RoleType.Other, { param = {} })
        end
    end
end

function PlayerEquip_Look.RefreshBestRingBox()
    SL:scheduleOnce(PlayerEquip_Look._ui.Best_ringBox,function()
        if self and PlayerEquip_Look._ui.Best_ringBox then
            local texture = "btn_jewelry_1_1.png"
            if SL:GetMetaValue("BEST_RING_WIN_ISOPEN", PlayerEquip_Look.RoleType.Other) then -- 首饰盒界面是否打开
                texture = "btn_jewelry_1_0.png"
            end
            GUI:Image_loadTexture(PlayerEquip_Look._ui.Image_box, SLDefine.PATH_RES_PRIVATE .. "player_best_rings_ui/player_best_rings_ui_win32/" .. texture)
            -- 重置尺寸
            GUI:setIgnoreContentAdaptWithSize(PlayerEquip_Look._ui.Image_box, true)
        end
        PlayerEquip_Look.RefreshPlayerBestRingsOpenState()
    end,0.1)
end

--[[    
    创建装备回调
    item 装备
    返回 item
]]
function PlayerEquip_Look.CreateEquipItemCallBack(item)
    return item
end
--[[    
    创建人物模型回调
]]
function PlayerEquip_Look.CreateModelCallBack(model)
    return model
end
--[[    
    界面关闭回调
]]
function PlayerEquip_Look.CloseCallback()
    PlayerEquip_Look.UnRegisterEvent()
end

function PlayerEquip_Look.RegisterEvent()
end

function PlayerEquip_Look.UnRegisterEvent()
end