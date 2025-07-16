UIOperator = {}

-- 打开个人人物界面(data = {type = 类型 1基础 2内功, page = 子页ID})
function UIOperator:OpenMyPlayerUI(data)
    if SL:IsForbidOpenBagOrEquip() then
        return false
    end

    GUI:SetLayerOpenParam(data)

    if PlayerFrame and PlayerFrame.OnClose then
        PlayerFrame.OnClose()
    end

    if GUIDefineEx.IsMergeMode then
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MERGE_PLAYER_MAIN)
    else
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_FRAME)
    end
    
    SL:OnPlayerFrameLoadSuccessAddRed()
end

-- 关闭个人人物界面
function UIOperator:CloseMyPlayerUI()
    if GUIDefineEx.IsMergeMode then
        GUI:Win_CloseByID(UIConst.LAYERID.MergePlayerMainGUI)
    else
        GUI:Win_CloseByID(UIConst.LAYERID.PlayerMainGUI)
    end
end

-- 打开个人英雄界面(data = {type = 类型 1基础 2内功, page = 子页ID})
function UIOperator:OpenMyHeroUI(data)
    if not SL:GetValue("HERO_IS_ACTIVE") then
        return SL:ShowSystemTips("英雄还未激活")
    end

    if not SL:GetValue("HERO_IS_ALIVE") then
        return SL:ShowSystemTips("英雄还未召唤")
    end

    if SL:IsForbidOpenBagOrEquip() then
        return false
    end

    if GUIDefineEx.IsMergeMode then
        data.roleType = 2
        GUI:SetLayerOpenParam(data)
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MERGE_PLAYER_MAIN)
    else
        GUI:SetLayerOpenParam(data)
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_HERO_FRAME)
    end

    SL:OnHeroFrameLoadSuccessAddRed()
end

-- 关闭个人人物界面
function UIOperator:CloseMyHeroUI()
    if GUIDefineEx.IsMergeMode then
        GUI:Win_CloseByID(UIConst.LAYERID.MergePlayerMainGUI)
    else
        GUI:Win_CloseByID(UIConst.LAYERID.HeroMainGUI)
    end
end

-- 打开角色装备
function UIOperator:OpenRoleEquipUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.Equip, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_EQUIP)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_EQUIP,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_EQUIP,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LUAFile.LUA_FILE_PLAYER_LOOK_EQUIP,
        [GUIDefine.RoleUIType.HERO_OTHER]   = UIConst.LUAFile.LUA_FILE_HERO_LOOK_EQUIP,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_EQUIP,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_EQUIP
    })[type])
end
-- 关闭角色装备
function UIOperator:CloseRoleEquipUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerEquip,
        [GUIDefine.RoleUIType.HERO]         = HeroEquip,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerEquip,
        [GUIDefine.RoleUIType.HERO_OTHER]   = LookHeroEquip,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = PlayerEquip_Look_TradingBank,
        [GUIDefine.RoleUIType.TRADE_HERO]   = HeroEquip_Look_TradingBank
    })[type]

    if UI then
        UI.OnClose()
    end
end

-- 打开角色状态
function UIOperator:OpenRoleBaseAttUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.State, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_BASE_ATT)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_BASE_ATT,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_BASE_ATT,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_BASE_ATT,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_BASE_ATT
    })[type])
end
-- 关闭角色状态
function UIOperator:CloseRoleBaseAttUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerBaseAtt,
        [GUIDefine.RoleUIType.HERO]         = HeroBaseAtt,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = PlayerBaseAtt_Look_TradingBank,
        [GUIDefine.RoleUIType.TRADE_HERO]   = HeroBaseAtt_Look_TradingBank,
    })[type]

    if UI then
        UI.OnClose()
    end
end

-- 打开角色属性
function UIOperator:OpenRoleExtraAttUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.Attri, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_EXTRA_ATT)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_EXTRA_ATT,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_EXTRA_ATT,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_EXTRA_ATT,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_EXTRA_ATT
    })[type])
end
-- 关闭角色属性
function UIOperator:CloseRoleExtraAttUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerExtraAtt,
        [GUIDefine.RoleUIType.HERO]         = HeroExtraAtt,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = PlayerExtraAtt_Look_TradingBank,
        [GUIDefine.RoleUIType.TRADE_HERO]   = HeroExtraAtt_Look_TradingBank,
    })[type]
    
    if UI then
        UI.OnClose()
    end
end

-- 打开角色技能
function UIOperator:OpenRoleSkillUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.Skill, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_SKILL)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_SKILL,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_SKILL,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_SKILL,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_SKILL
    })[type])
end
-- 关闭角色技能
function UIOperator:CloseRoleSkillUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerSkill,
        [GUIDefine.RoleUIType.HERO]         = HeroSkill,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = PlayerSkill_Look_TradingBank,
        [GUIDefine.RoleUIType.TRADE_HERO]   = HeroSkill_Look_TradingBank,
    })[type]
    
    if UI then
        UI.OnClose()
    end
end

-- 打开角色称号
function UIOperator:OpenRoleTitleUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.Title, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_TITLE)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_TITLE,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_TITLE,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LUAFile.LUA_FILE_PLAYER_LOOK_TITLE,
        [GUIDefine.RoleUIType.HERO_OTHER]   = UIConst.LUAFile.LUA_FILE_HERO_LOOK_TITLE,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_TITLE,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_TITLE
    })[type])
end
-- 关闭角色称号
function UIOperator:CloseRoleTitleUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerTitle,
        [GUIDefine.RoleUIType.HERO]         = HeroTitle,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerTitle,
        [GUIDefine.RoleUIType.HERO_OTHER]   = LookHeroTitle,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = PlayerTitle_Look_TradingBank,
        [GUIDefine.RoleUIType.TRADE_HERO]   = HeroTitle_Look_TradingBank,
    })[type]
    
    if UI then
        UI.OnClose()
    end
end

-- 打开角色神装
function UIOperator:OpenRoleSuperEquipUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.SuperEquip, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_SUPER_EQUIP)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_SUPER_EQUIP,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_SUPER_EQUIP,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LUAFile.LUA_FILE_PLAYER_LOOK_SUPER_EQUIP,
        [GUIDefine.RoleUIType.HERO_OTHER]   = UIConst.LUAFile.LUA_FILE_HERO_LOOK_SUPER_EQUIP,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_SUPER_EQUIP,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_SUPER_EQUIP
    })[type])
end
-- 关闭角色神装
function UIOperator:CloseRoleSuperEquipUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerSuperEquip,
        [GUIDefine.RoleUIType.HERO]         = HeroSuperEquip,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerSuperEquip,
        [GUIDefine.RoleUIType.HERO_OTHER]   = LookHeroSuperEquip,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = PlayerSuperEquip_Look_TradingBank,
        [GUIDefine.RoleUIType.TRADE_HERO]   = HeroSuperEquip_Look_TradingBank,
    })[type]
    
    if UI then
        UI.OnClose()
    end
end

-- 打开角色BUFF
function UIOperator:OpenRoleBuffUI(type, data)
    GUI:SetLayerOpenParam(data)

    if type == GUIDefine.RoleUIType.PLAYER and tonumber(SL:GetValue("GAME_DATA", "UIOpenMethod")) == 1 then
        return SL:CheckOpenLayer(SLDefine.HyperLinkID.Buff, data, function ()
            GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAYER_BUFF)
        end)
    end

    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_BUFF,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LUAFile.LUA_FILE_PLAYER_LOOK_BUFF,
    })[type])
end
-- 关闭角色BUFF
function UIOperator:CloseRoleBuffUI(type)
    local UI = ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerBuff,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = LookPlayerBuff
    })[type]

    if UI then
        UI.OnClose()
    end
end

------------------------------------------------------------------------
-- 打开内功状态 
function UIOperator:OpenInternalStateUI(type, data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_INTERNAL_STATE,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_INTERNAL_STATE,
    })[type])
end
-- 关闭内功状态 
function UIOperator:CloseInternalStateUI(type)
    ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerInternalState,
        [GUIDefine.RoleUIType.HERO]         = HeroInternalState
    })[type].OnClose()
end

-- 打开内功技能 
function UIOperator:OpenInternalSkillUI(type, data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_INTERNAL_SKILL,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_INTERNAL_SKILL,
    })[type])
end
-- 关闭内功技能 
function UIOperator:CloseInternalSkillUI(type)
    ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerInternalSkill,
        [GUIDefine.RoleUIType.HERO]         = HeroInternalSkill
    })[type].OnClose()
end

-- 打开内功经络 
function UIOperator:OpenInternalMerdianUI(type, data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_INTERNAL_MERIDIAN,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_INTERNAL_MERIDIAN,
    })[type])
end
-- 关闭内功经络 
function UIOperator:CloseInternalMerdianUI(type)
    ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerInternalMeridian,
        [GUIDefine.RoleUIType.HERO]         = HeroInternalMeridian
    })[type].OnClose()
end

-- 打开内功连击
function UIOperator:OpenInternalComboUI(type, data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_INTERNAL_COMBO,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_INTERNAL_COMBO,
    })[type])
end
-- 关闭内功连击
function UIOperator:CloseInternalComboUI(type)
    ({
        [GUIDefine.RoleUIType.PLAYER]       = PlayerInternalCombo,
        [GUIDefine.RoleUIType.HERO]         = HeroInternalCombo
    })[type].OnClose()
end

-- 打开首饰盒
function UIOperator:OpenBestRingBoxUI(type, data)
    local layerID = ({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LAYERID.PlayerBestRingGUI,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LAYERID.HeroBestRingGUI,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LAYERID.LookPlayerBestRingGUI,
        [GUIDefine.RoleUIType.HERO_OTHER]   = UIConst.LAYERID.LookHeroBestRingGUI,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LAYERID.TradingBankBestRingGUI,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LAYERID.TradingBankHeroBestRingGUI
    })[type]

    if not layerID then
        return false
    end

    if GUI:GetWindow(nil, layerID) then
        return UIOperator:CloseBestRingBoxUI(type)
    end
    
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LUAFile.LUA_FILE_PLAYER_BESTRING,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LUAFile.LUA_FILE_HERO_BESTRING,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LUAFile.LUA_FILE_PLAYER_LOOK_BESTRING,
        [GUIDefine.RoleUIType.HERO_OTHER]   = UIConst.LUAFile.LUA_FILE_HERO_LOOK_BESTRING,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_BESTRING,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LUAFile.LUA_FILE_TRADE_HERO_BESTRING
    })[type])
end
-- 关闭首饰盒
function UIOperator:CloseBestRingBoxUI(type)
    GUI:Win_CloseByID(({
        [GUIDefine.RoleUIType.PLAYER]       = UIConst.LAYERID.PlayerBestRingGUI,
        [GUIDefine.RoleUIType.HERO]         = UIConst.LAYERID.HeroBestRingGUI,
        [GUIDefine.RoleUIType.PLAYER_OTHER] = UIConst.LAYERID.LookPlayerBestRingGUI,
        [GUIDefine.RoleUIType.HERO_OTHER]   = UIConst.LAYERID.LookHeroBestRingGUI,
        [GUIDefine.RoleUIType.TRADE_PLAYER] = UIConst.LAYERID.TradingBankBestRingGUI,
        [GUIDefine.RoleUIType.TRADE_HERO]   = UIConst.LAYERID.TradingBankHeroBestRingGUI
    })[type])
end

-- 打开背包
function UIOperator:OpenBagUI(data)
    if  SL:IsForbidOpenBagOrEquip() then 
        return
    end
    data = data or {}
    data.bagType = GUIDefine.BagType.BAG
    GUI:SetLayerOpenParam(data)
    if GUIFunction:IsPlayerHeroMergeMode() then 
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MERGE_BAG)
    else
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_LAYER_BAG)
    end
end

--关闭背包
function UIOperator:CloseBagUI()
    if GUIFunction:IsPlayerHeroMergeMode() then 
        GUI:Win_CloseByID(UIConst.LAYERID.MergeBagLayerGUI)
    else
        GUI:Win_CloseByID(UIConst.LAYERID.BagLayerGUI)
    end
end

--打开英雄背包
function UIOperator:OpenHeroBagUI(data)
    if  SL:IsForbidOpenBagOrEquip() then 
        return
    end
    data = data or {}
    data.bagType = GUIDefine.BagType.HEROBAG
    GUI:SetLayerOpenParam(data)
    if GUIFunction:IsPlayerHeroMergeMode() then 
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MERGE_BAG)
    else
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_HERO_BAG)
    end
end

--关闭英雄背包
function UIOperator:CloseHeroBagUI()
    if GUIFunction:IsPlayerHeroMergeMode() then 
        GUI:Win_CloseByID(UIConst.LAYERID.MergeBagLayerGUI)
    else
        GUI:Win_CloseByID(UIConst.LAYERID.HeroBagLayerGUI)
    end
end

--打开交易行玩家面板
function UIOperator:OpenTradePlyerUI(data)
    if  SL:IsForbidOpenBagOrEquip() then 
        return
    end
    
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_TRADE_PLAYER_FRAME)
end

--关闭交易行玩家面板
function UIOperator:CloseTradePlyerUI()
    SL:onLUAEvent(LUA_EVENT_TRADE_BANK_PLAYER_FRAME_CLOSE)
end
-------------------------行会----------------------------
-- 打开行会
function UIOperator:OpenGuildMainUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUILD_FRAME)
end

-- 关闭行会
function UIOperator:CloseGuildMainUI()
    GUI:Win_CloseByID(UIConst.LAYERID.GuildFrameGUI)
end

-- 打开行会创建
function UIOperator:OpenGuildCreateUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUILD_CREATE)
end

-- 关闭行会创建
function UIOperator:CloseGuildCreateUI()
    GUI:Win_CloseByID(UIConst.LAYERID.GuildCreateGUI)
end

-- 打开行会申请列表
function UIOperator:OpenGuildApplyListUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUILD_APPLY_LIST)
end

-- 关闭行会申请列表
function UIOperator:CloseGuildApplyListUI()
    GUI:Win_CloseByID(UIConst.LAYERID.GuildApplyListGUI)
end

-- 打开行会宣战/结盟框
function UIOperator:OpenGuildWarAllyUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUILD_WAR_ALLY)
end

-- 关闭行会宣战/结盟框
function UIOperator:CloseGuildWarAllyUI()
    GUI:Win_CloseByID(UIConst.LAYERID.GuildWarAllyGUI)
end

-- 打开行会称谓设置
function UIOperator:OpenGuildEditTitleUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUILD_EDITTITLE)
end

-- 关闭行会称谓设置
function UIOperator:CloseGuildEditTitleUI()
    GUI:Win_CloseByID(UIConst.LAYERID.GuildEditTitleGUI)
end

-- 打开行会结盟申请界面
function UIOperator:OpenGuildAllyApplyUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUILD_ALLY_APPLY)
end
-- 关闭行会结盟申请界面
function UIOperator:CloseGuildAllyApplyUI()
    GUI:Win_CloseByID(UIConst.LAYERID.GuildAllyApplyGUI)
end
-------------------------------------------------------

-- 社交（1附近玩家、2组队、3好友、4邮件）------------
function UIOperator:OpenSocialUI(page)
    GUI:SetLayerOpenParam(page)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SOCIAL_FRAME)
end

function UIOperator:CloseSocialUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SocialGUI)
end

-- 打开入队申请列表
function UIOperator:OpenTeamApply()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_TEAM_APPLY)
end

function UIOperator:CloseTeamApply()
    GUI:Win_CloseByID(UIConst.LAYERID.TeamApplyGUI)
end

-- 打开邀请组队界面
function UIOperator:OpenTeamInvite()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_TEAM_INVITE)
end

function UIOperator:CloseTeamInvite()
    GUI:Win_CloseByID(UIConst.LAYERID.TeamInviteGUI)
end

-- 打开被邀请组队界面
function UIOperator:OpenTeamBeInvite(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_TEAM_BEINVITED_POP)
end

function UIOperator:CloseTeamBeInvite()
    GUI:Win_CloseByID(UIConst.LAYERID.TeamBeInvitedPopGUI)
end

-- 打开添加好友界面
function UIOperator:OpenAddFriendUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_FRIEND_ADD)
end

function UIOperator:CloseAddFriendUI()
    GUI:Win_CloseByID(UIConst.LAYERID.FriendAddGUI)
end

-- 打开添加黑名单界面
function UIOperator:OpenAddBlackListUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_FRIEND_ADD_BLACKLIST)
end

function UIOperator:CloseAddBlackListUI()
    GUI:Win_CloseByID(UIConst.LAYERID.FriendAddBlacklistGUI)
end

-- 打开好友添加申请界面
function UIOperator:OpenFriendApplyUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_FRIEND_APPLY)
end

function UIOperator:CloseFriendApplyUI()
    SL:RequestClearFriendApplyList()
    GUI:Win_CloseByID(UIConst.LAYERID.FriendApplyGUI)
end

-- 打开邀请建立关系界面
function UIOperator:OpenRelationInvite(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_RELATION_INVITE)
end

function UIOperator:CloseRelationInvite()
    GUI:Win_CloseByID(UIConst.LAYERID.RelationInviteGUI)
end

------------------------------
-- 打开 PC 分辨率修改界面
function UIOperator:OpenResolutionSetUI()
    if not SL:GetValue("IS_PC_OPER_MODE") then 
        return 
    end
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SET_WINSIZE_POP)
end

function UIOperator:CloseResolutionSetUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SetWinSizeGUI)
end
------------------------------

-- 打开技能设置
function UIOperator:OpenSkillSettingUI(...)
    if SL:GetValue("IS_PC_OPER_MODE") then 
        GUI:SetLayerOpenParam(...)
        SL:Require(UIConst.LUAFile.LUA_FILE_SKILL_SETTING_WIN32, true)
    else
        SL:Require(UIConst.LUAFile.LUA_FILE_SKILL_SETTING, true) 
    end
end

-- 关闭技能设置
function UIOperator:CloseSkillSettingUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SkillSettingGUI)
end

---------------------------登录账号、选角--------------------------
-- 打开账号界面
function UIOperator:OpenLoginAccountUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_LOGIN_ACCOUNT)
end

-- 关闭账号界面
function UIOperator:CloseLoginAccountUI()
    GUI:Win_CloseByID(UIConst.LAYERID.LoginAccountGUI)
end

-- 打开登录服务器开门界面
function UIOperator:OpenLoginServerUI()
    if not GUI:GetWindow(nil, UIConst.LAYERID.LoginServerGUI) then
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_LOGIN_SERVER)
    end
end

-- 关闭账号界面
function UIOperator:CloseLoginServerUI()
    GUI:Win_CloseByID(UIConst.LAYERID.LoginServerGUI)
end

-- 打开角色选角界面
function UIOperator:OpenLoginRoleUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_LOGINROLE)
end

-- 关闭角色选角界面
function UIOperator:CloseLoginRoleUI()
    GUI:Win_CloseByID(UIConst.LAYERID.LoginRoleGUI)
end

------------------------------------------------------------
-- 打开称号提示界面
function UIOperator:OpenTitleTipsUI(data)
    GUI:SetLayerOpenParam(data)
    SL:Require(UIConst.LUAFile.LUA_FILE_TITLE_TIPS, true)
end

-- 关闭称号提示界面
function UIOperator:CloseTitleTipsUI()
    GUI:Win_CloseByID(UIConst.LAYERID.TitleTipsGUI)
end

-----------------------内挂---------
--打开 boss提醒 设置界面
function UIOperator:OpenBossTipsUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_BOSSTIPS)
end

--关闭 boss提醒 设置界面
function UIOperator:CloseBossTipsUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingBossTipsGUI)
end

--打开 增加怪物名字 设置界面
function UIOperator:OpenAddMonsterNameUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_ADD_MONSTER_NAME)
end

--关闭 增加怪物名字 设置界面
function UIOperator:CloseAddMonsterNameUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingAddMonsterNamesGUI)
end

--打开 增加怪物类型 设置界面
function UIOperator:OpenAddMonsterTypeUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_ADD_MONSTER_TYPE)
end

--关闭 增加怪物类型 设置界面
function UIOperator:CloseAddMonsterTypeUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingAddMonsterTypeGUI)
end

--打开 拾取 设置界面
function UIOperator:OpenPickSettingUI()
    if SL:GetValue("IS_PC_OPER_MODE") then 
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_PICK_SETTING_WIN32)
    else 
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_PICK_SETTING)
    end
end

--关闭 拾取 设置界面
function UIOperator:ClosePickSettingUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingPickSetGUI)
end

--打开 保护 设置界面
function UIOperator:OpenProtectSettingUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_PROTECTSET)
end

--关闭 保护 设置界面
function UIOperator:CloseProtectSettingUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingProtectSetGUI)
end

--打开 技能排行 设置界面
function UIOperator:OpenSkillRankPanelUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_SKILL_RANK)
end

--关闭 技能排行 设置界面
function UIOperator:CloseSkillRankPanelUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingSkillRankGUI)
end

--打开 技能 设置界面
function UIOperator:OpenSkillPanelUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_SKILL_PANEL)
end

--关闭 技能 设置界面
function UIOperator:CloseSkillPanelUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingSkillPanelGUI)
end

-- 打开 玩家名字颜色 设置界面
function UIOperator:OpenPlayerNameColorSettingUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SETTING_PLAYER_NAME_COLOR)
end

-- 关闭 玩家名字颜色 设置界面
function UIOperator:ClosePlayerNameColorSettingUI()
    GUI:Win_CloseByID(UIConst.LAYERID.SettingPlayerNameColorGUI)
end

-------------------------------------
-- 打开摆摊界面
function UIOperator:OpenStallLayerUI(data)
    if SL:GetValue("TRADING_BANK_IS_OPEN") then
        SL:ShowSystemTips("摆摊与交易行不能同时使用")
        return
    end
    if SL:GetValue("TRADE_IS_TRADING") then
        SL:RequestTradeCancel()
    end
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_STALL)
end

function UIOperator:CloseStallLayerUI()
    GUI:Win_CloseByID(UIConst.LAYERID.StallLayerGUI)
end

function UIOperator:OpenStallPutLayerUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_STALL_PUT)
end

function UIOperator:CloseStallPutLayerUI()
    GUI:Win_CloseByID(UIConst.LAYERID.StallPutGUI)
end

function UIOperator:OpenStallSetLayerUI(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_STALL_SET)
end

function UIOperator:CloseStallSetLayerUI()
    GUI:Win_CloseByID(UIConst.LAYERID.StallSetGUI)
end
--------------------------------------

--------------------------------------
-- 合成
-- 打开合成界面
function UIOperator:OpenCompoundItemUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_COMPOUND_ITEM)
end

-- 关闭合成界面
function UIOperator:CloseCompoundItemUI()
    GUI:Win_CloseByID(UIConst.LAYERID.CompoundItemGUI)
end

---------------------------------------
------------------------------
-- 拍卖行
-- 打开拍卖行界面
function UIOperator:OpenAuctionUI(data)
    if SL:GetValue("TRADING_BANK_IS_OPEN") then
        SL:ShowSystemTips("拍卖行与交易行不能同时使用")
        return
    end
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUCTION_MAIN)
end

function UIOperator:CloseAuctionUI()
    GUI:Win_CloseByID(UIConst.LAYERID.AuctionMainGUI)
end

-- 打开拍卖行物品上架界面
function UIOperator:OpenAuctionPutInUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUCTION_PUTIN)
end

function UIOperator:CloseAuctionPutInUI()
    GUI:Win_CloseByID(UIConst.LAYERID.AuctionPutinGUI)
end

-- 打开拍卖行超时界面
function UIOperator:OpenAuctionTimeOutUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUCTION_TIMEOUT)
end

function UIOperator:CloseAuctionTimeOutUI()
    GUI:Win_CloseByID(UIConst.LAYERID.AuctionTimeoutGUI)
end

-- 打开拍卖行竞拍界面
function UIOperator:OpenAuctionBidUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUCTION_BID)
end

function UIOperator:CloseAuctionBidUI()
    GUI:Win_CloseByID(UIConst.LAYERID.AuctionBidGUI)
end

-- 打开拍卖行物品下架界面
function UIOperator:OpenAuctionPutOutUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUCTION_PUTOUT)
end

function UIOperator:CloseAuctionPutOutUI()
    GUI:Win_CloseByID(UIConst.LAYERID.AuctionPutoutGUI)
end

-- 打开拍卖行物品购买界面
function UIOperator:OpenAuctionBuyUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUCTION_BUY)
end

function UIOperator:CloseAuctionBuyUI()
    GUI:Win_CloseByID(UIConst.LAYERID.AuctionBuyGUI)
end 
---------------------------------------
---------------------------------------
-- 商城
-- 打开商城界面
function UIOperator:OpenStoreFrameUI(data)
    local shiwan = SL:GetValue("BOX_TEST_PLAY")
    if shiwan then
        return
    end
    
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_STORE_FRAME)
end

function UIOperator:CloseStoreFrameUI()
    GUI:Win_CloseByID(UIConst.LAYERID.StoreFrameGUI)
end

-- 打开商品详情界面
function UIOperator:OpenStoreDetailUI(storeIndex, limitStr)
    if not storeIndex then
        return
    end
    local storeData = SL:GetValue("STORE_ITEM_DATA_BY_INDEX", storeIndex)
    if not storeData or next(storeData) == nil then
        return
    end
    local canBuy = SL:GetValue("STORE_ITEM_CAN_BUY", storeIndex)
    if not canBuy then
        if limitStr and string.len(limitStr) > 0 then
            SL:ShowSystemTips(limitStr)
        end
        return
    end
    local buyData = {
        data = storeData,
    }

    GUI:SetLayerOpenParam(buyData)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_STORE_DETAIL)
end

function UIOperator:CloseStoreDetailUI()
    GUI:Win_CloseByID(UIConst.LAYERID.StoreDetailGUI)
end

-- 打开npc商城界面
function UIOperator:OpenNpcStoreUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_NPC_STORE)
end

function UIOperator:CloseNpcStoreUI()
    GUI:Win_CloseByID(UIConst.LAYERID.NPCStoreGUI)
end

-- 打开充值二维码
function UIOperator:OpenRechargeQRCodeUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_RECHARGE_QRCODE)
end

function UIOperator:CloseRechargeQRCodeUI()
    GUI:Win_CloseByID(UIConst.LAYERID.RechargeQRCodeGUI)
end
---------------------------------------
---------------------------------------
-- NPC
-- 打开炼药界面
function UIOperator:OpenNpcMakeDrugUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MAKE_DRUG)
    local newBagPos = {
        x = 470,
        y = 20
    }
    UIOperator:OpenBagUI({pos = newBagPos})
end

function UIOperator:CloseNpcMakeDrugUI()
    GUI:Win_CloseByID(UIConst.LAYERID.NPCMakeDrugGUI)
end

-- 打开出售、修理界面
function UIOperator:OpenNpcSellRepaireUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SELL_REPAIRE)
    local newBagPos = {
        x = 470,
        y = 20
    }
    UIOperator:OpenBagUI({pos = newBagPos})
end

function UIOperator:CloseNpcSellRepaireUI()
    GUI:Win_CloseByID(UIConst.LAYERID.NPCSellOrRepaire)
end

-- 打开npc仓库界面
function UIOperator:OpenNpcStorageUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_NPC_STORAGE)
    local noShowBag = data and data.noShowBag
    if not noShowBag then
        local newBagPos = {
            x = 470,
            y = 0
        }
        UIOperator:OpenBagUI({pos = newBagPos})
    end
end

function UIOperator:CloseNpcStorageUI()
    SL:onLUAEvent(LUA_EVENT_NPC_STORAGE_CLOSE)
    GUI:Win_CloseByID(UIConst.LAYERID.NPCStorageGUI)
end
----------------------------------------
-- ItemTips
function UIOperator:OpenItemTips(data)
    GUI:SetLayerOpenParam(data)
    if SL:GetMetaValue("GAME_DATA", "enableTxtTipsConfig") == 1 then
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_ITEM_TIPS_TXT)
    else
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_ITEM_TIPS)
    end
end
function UIOperator:CloseItemTips()
    GUI:Win_CloseByID(UIConst.LAYERID.ItemTipsGUI)
end

-- ItemIconTips
function UIOperator:OpenItemIconTips(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_ITEM_ICON_TIPS)
end
function UIOperator:CloseItemIconTips()
    GUI:Win_CloseByID(UIConst.LAYERID.ItemIconTipsGUI)
end

-------------------------------------------
-- 小地图
--打开小地图
function UIOperator:OpenMiniMap()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MINIMAP)
end
--关闭小地图
function UIOperator:CloseMiniMap()
    GUI:Win_CloseByID(UIConst.LAYERID.MiniMapGUI)
end

-- 打开其他小地图
function UIOperator:OpenOtherMiniMap(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MINIMAP_OTHER)
end

function UIOperator:CloseOtherMiniMap()
    GUI:Win_CloseByID(UIConst.LAYERID.MiniMapOtherGUI)
end

-- 打开世界公告
function UIOperator:OpenGameWorld()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GAME_WORLD_CONFIRM)
end
-- 关闭世界公告
function UIOperator:CloseGameWorld()
    GUI:Win_CloseByID(UIConst.LAYERID.GameWorldConfirmGUI)
    SL:CloseGameWorldEvent()
end

----------------------------------------
-- 打开宝箱 data: 宝箱物品数据
function UIOperator:OpenGoldBox(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GOLD_BOX)
end
-- 关闭宝箱
function UIOperator:CLoseGoldBox()
    GUI:Win_CloseByID(UIConst.LAYERID.GoldBoxGUI)
end
----------------------------------------
-- 打开道具拆分弹窗层
function UIOperator:OpenTipsSplit(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_ITEM_SPLIT_POP)
end
--关闭道具拆分弹窗层
function UIOperator:CloseTipsSplit()
    GUI:Win_CloseByID(UIConst.LAYERID.CommonTipsSplitGUI)
end
----------------------------------------
--开宝箱
function UIOperator:OpenTreasure(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_TREASURE_BOX)
end
--关闭宝箱
function UIOperator:CloseTreasure()
    GUI:Win_CloseByID(UIConst.LAYERID.TreasureBoxGUI)
end
----------------------------------------
--打开转生点
function UIOperator:OpenReinAttrUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_REIN_ATTR)
end
--关闭转生点
function UIOperator:CloseReinAttrUI()
    GUI:Win_CloseByID(UIConst.LAYERID.ReinAttrGUI)
end

----------------------------------------------------
-- 聊天
-- 打开聊天页(手机)
function UIOperator:OpenChatUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_CHAT)
end

-- 关闭聊天
function UIOperator:CloseChatUI()
    SL:onLUAEvent(LUA_EVENT_CHAT_PANEL_CLOSE)
end

-- 打开聊天拓展页
function UIOperator:OpenChatExtendUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_CHAT_EXTEND)
end

-- 关闭聊天拓展页
function UIOperator:CloseChatExtendUI()
    GUI:Win_CloseByID(UIConst.LAYERID.ChatExtendGUI)
end

-- 打开PC私聊记录页
function UIOperator:OpenPCPrivateUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PRIVATE_CHAT_WIN32)
end

-- 关闭PC私聊记录页
function UIOperator:ClosePCPrivateUI()
    GUI:Win_CloseByID(UIConst.LAYERID.PCPrivateChatGUI)
end
--------------------------------------
-- 通用消息提示
-- 气泡消息
function UIOperator:OpenCommonBubbleInfoUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_COMMON_BUBBLE_INFO)
end

function UIOperator:CloseCommonBubbleInfoUI()
    GUI:Win_CloseByID(UIConst.LAYERID.CommonBubbleInfoGUI)
end

-- 通用描述弹窗
function UIOperator:OpenCommonDescTipsUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_COMMON_DESC_TIPS)
end

function UIOperator:CloseCommonDescTipsUI()
    GUI:Win_CloseByID(UIConst.LAYERID.CommonDescTipsGUI)
end

-- 通用选择弹窗
function UIOperator:OpenCommonSelectListUI(list, position, cellwidth, cellheight, func, extraData)
    local data = {}
    data.values = list
    data.position = position
    data.cellwidth = cellwidth
    data.cellheight = cellheight
    data.func = func
    if extraData then
        for k, v in pairs(extraData) do
            data[k] = v
        end
    end
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_COMMON_SELECT_LIST)
end

function UIOperator:CloseCommonSelectListUI()
    GUI:Win_CloseByID(UIConst.LAYERID.CommonSelectListGUI)
end

-- 通用提示弹窗
function UIOperator:OpenCommonTipsUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_COMMON_TIPS_POP)
end

function UIOperator:CloseCommonTipsUI()
    GUI:Win_CloseByID(UIConst.LAYERID.CommonTipsGUI)
end

-- FuncDock 通用功能弹框
function UIOperator:OpenFuncDockTips(data)
    if data.type == FuncDockData.FuncDockType.Func_Player_Head then
        FuncDockData.RequestLookPlayerInfo(data)
    else
        GUI:SetLayerOpenParam(data)
        GUI:Win_Open(UIConst.LUAFile.LUA_FILE_FUNC_DOCK)
    end
end

function UIOperator:CloseFuncDockTips()
    GUI:Win_CloseByID(UIConst.LAYERID.FuncDockGUI)
end

--------------------------------------
-- 求购
-- 主界面
function UIOperator:OpenPurchaseUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PURCHASE_MAIN)
end

function UIOperator:ClosePurchaseUI()
    GUI:Win_CloseByID(UIConst.LAYERID.PurchaseMainGUI)
end

-- 上架
function UIOperator:OpenPurchasePutInUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PURCHASE_PUTIN)
end

function UIOperator:ClosePurchasePutInUI()
    GUI:Win_CloseByID(UIConst.LAYERID.PurchasePutInGUI)
end

-- 出售
function UIOperator:OpenPurchaseSellUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PURCHASE_SELL)
end

function UIOperator:ClosePurchaseSellUI()
    GUI:Win_CloseByID(UIConst.LAYERID.PurchaseSellGUI)
end
-----------------------------------
-- 摇色子
function UIOperator:OpenPlayDiceUI(data)
    if GUI:GetWindow(nil, UIConst.LAYERID.PlayDiceGUI) then
        return
    end
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PLAY_DICE)
end

function UIOperator:ClosePlayDiceUI()
    GUI:Win_CloseByID(UIConst.LAYERID.PlayDiceGUI)
end
-----------------------------------
-- 进度条
function UIOperator:OpenProgressBarUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_PROGRESS_BAR)
end

function UIOperator:CloseProgressBarUI()
    GUI:Win_CloseByID(UIConst.LAYERID.ProgressBarGUI)
end
-----------------------------------

-------------------------------------
-- 打开排行榜
function UIOperator:OpenRankUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_RANK)
end

-- 关闭排行榜
function UIOperator:CloseRankUI()
    GUI:Win_CloseByID(UIConst.LAYERID.RankGUI)
end
-------------------------------------
-- 同意交易
function UIOperator:OpenTradeUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_TRADE)
end
-------------------------------------
-- 打开准星
function UIOperator:OpenSightBeadUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_SIGHT_BEAD)
end
-------------------------------------
function UIOperator:OpenMoveEventUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MOVE_EVENT)
end
-------------------------------------
function UIOperator:OpenRtouchEventUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_RTOUCH_EVENT)
end
-- 引导
function UIOperator:OpenGuideUI(data)
    SL:onLUAEvent(LUA_EVENT_GUIDE_EXIT)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_GUIDE)
end
-------------------------------------
-- 打开目标归属
function UIOperator:OpenTargetBelongUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MAIN_TARGET_BELONG)
end
-- 附近展示页
function UIOperator:OpenMainNearUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_MAIN_NEAR)
end
function UIOperator:CloseMainNearUI()
    GUI:Win_CloseByID(UIConst.LAYERID.MainNearGUI)
end
------------------------------------
-- 刷新红点
function UIOperator:RefreshRedDot(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_COMMON_REDDOT)
end
------------------------------------

-- 打开快捷使用框
function UIOperator:OpenAutoUsePopUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_AUTO_USE_POP)
end

-- 关闭快捷使用框
function UIOperator:CloseAutoUsePopUI(makeIndex, pos, isHero)
    if not AutoUsePop or not AutoUsePop.OnClose then
        return false
    end
    AutoUsePop.OnClose(makeIndex, pos, isHero)
end
---------------------------------------
-- 加载条
function UIOperator:OpenLoadingBarUI(data)
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_LOADING_BAR)
end

function UIOperator:CloseLoadingBarUI()
    GUI:Win_CloseByID(UIConst.LAYERID.LoadingBarGUI)
end

--------------------------------------
-- 打开英雄状态
function UIOperator:OpenHeroStateUI()
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_HERO_STATE)
end
-- 关闭英雄状态
function UIOperator:CloseHeroStateUI()
    GUI:Win_CloseByID(UIConst.LAYERID.HeroStateGUI)
end

-- 打开英雄状态选择界面
function UIOperator:OpenHeroStateSelectUI(data)
    -- 未召唤
    if not SL:GetValue("HERO_IS_ALIVE") then
        return false
    end
    GUI:SetLayerOpenParam(data)
    GUI:Win_Open(UIConst.LUAFile.LUA_FILE_HERO_STATE_SELECT)
end
-- 关闭英雄状态选择界面
function UIOperator:CloseHeroStateSelectUI()
    GUI:Win_CloseByID(UIConst.LAYERID.HeroStateSelectGUI)
end
