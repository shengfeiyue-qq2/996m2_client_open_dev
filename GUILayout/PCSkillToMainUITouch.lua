PCSkillToMainUI = {}

function PCSkillToMainUI.main()
    local parent = GUI:Win_Create(UIConst.LAYERID.PCSkillToMainUIGUI, 0, 0, 0, 0, false, false, true, true, true, nil, GUIDefine.UIZ.MAIN)
    GUI:LoadExport(parent, "pc_skill_to_main_ui")
    
    PCSkillToMainUI._ui = GUI:ui_delegate(parent)
    if not PCSkillToMainUI._ui then
        return false
    end

    PCSkillToMainUI._Panel_1 = PCSkillToMainUI._ui["Panel_1"]

    PCSkillToMainUI._skillData = {}

    PCSkillToMainUI._skillCells = {}

    GUI:setSwallowTouches(PCSkillToMainUI._Panel_1, false)

    GUI:setContentSize(PCSkillToMainUI._Panel_1, SL:GetValue("SCREEN_WIDTH"), SL:GetValue("SCREEN_HEIGHT"))

    PCSkillToMainUI.InitMouseEvent()

    PCSkillToMainUI.RegisterEvent()

    PCSkillToMainUI.InitLocalShow()
end

function PCSkillToMainUI.InitMouseEvent()
    local function addItemToMainUI(touch)
        local state = SL:GetValue("ITEM_MOVE_STATE") 
        if not state then
            return -1
        end
        local data = {
            target = GUIDefine.ItemGoTo.TOPUI,
            pos    = touch
        }
        SL:ItemMoveCheck(data)
        return -1
    end

    GUI:addMouseButtonEvent(PCSkillToMainUI._Panel_1, {
        onRightDownFunc = function ()
            return -1
        end,
        onSpecialRFunc = addItemToMainUI
    })
end

function PCSkillToMainUI.InitLocalShow()
    local data = PCSkillToMainUI.ReadData()
    for _, v in pairs(data or {}) do
        if v and v.skillID and v.pos then
            PCSkillToMainUI.OnAddSkillToUI({skillID = v.skillID, pos = v.pos})
        end
    end
end

function PCSkillToMainUI.GetIndexBySkillID(skillID)
    for k, v in pairs(PCSkillToMainUI._skillData) do
        if v.skillID == skillID then
            return k
        end
    end
    return nil
end

-- 删除主界面技能按钮
function PCSkillToMainUI.DelSkillToUI(skillID)
    skillID = tonumber(skillID)
	if not skillID then
		return
	end

    local skillPanel = PCSkillToMainUI._skillCells[skillID] and PCSkillToMainUI._skillCells[skillID].skillPanel
	if GUI:Win_IsNotNull(skillPanel) then
		GUI:removeFromParent(skillPanel)
		PCSkillToMainUI._skillCells[skillID] = nil
	end

    PCSkillToMainUI.OnDelSkillToUI(skillID)
end

-- 主界面添加技能按钮
function PCSkillToMainUI.AddSkillToUI(data)
    local skillID  = tonumber(data.skillID)
	local skillPos = data.pos or {x = 0, y = 0}

    skillPos.x = math.min(SL:GetMetaValue("SCREEN_WIDTH") - 20, skillPos.x)
	skillPos.y = math.min(SL:GetMetaValue("SCREEN_HEIGHT") - 20, skillPos.y)
	
	local iconPath = SL:GetValue("SKILL_RECT_ICON_PATH", skillID)
	local skillIcon= GUI:Image_Create(GUI:Attach_LeftBottom(), "MAIN_ICON" .. skillID, skillPos.x, skillPos.y, iconPath)

	if not skillIcon then
		return
	end

	GUI:setIgnoreContentAdaptWithSize(skillIcon, false)
	GUI:setAnchorPoint(skillIcon, 0.5, 0.5)
	GUI:setContentSize(skillIcon, 40, 40)
	GUI:setTouchEnabled(skillIcon, true)

	local iconSize  = GUI:getContentSize(skillIcon)
	local cdProgress= GUI:ProgressTimer_Create(skillIcon, "MAIN_PROGRESS", 0, 0, "res/private/main/Skill/bg_lsxljm_05.png", iconSize.width, iconSize.height)
	GUI:ProgressTimer_setReverseDirection(cdProgress, true)
	PCSkillToMainUI._skillCells[skillID] = {
		skillPanel 	= skillIcon,
		progressCD	= cdProgress
	}

	-- 注册icon触摸
	local doubleDelay   = 0.3  -- 双击时间
	local scheduleID    = nil
	local isMoved 		= false
	local times 		= 0
	GUI:addOnTouchEvent(skillIcon, function(sender, eventType)
		if eventType == 0 then
			isMoved = false
		elseif eventType == 1 then
			if not isMoved then
				local movedPos = GUI:getTouchMovePosition(sender)
				local beganPos = GUI:getTouchBeganPosition(sender)

				local diff 	   = SL:GetSubPoint(movedPos, beganPos)
				local distSq   = SL:GetPointLengthSQ(diff)
				if distSq > 100 then
					isMoved = true
				end
			end

			if isMoved then
				local movedPos = GUI:getTouchMovePosition(sender)
				GUI:setPosition(sender, movedPos.x, movedPos.y)
			end
		elseif eventType == 2 then
			if isMoved then
                PCSkillToMainUI.OnSkillUIPostionUpdate({skill = skillID, pos = GUI:getPosition(sender)})
				return
			end
			times = times + 1
			if not scheduleID then
				scheduleID = SL:scheduleOnce(sender, function()
					if times >= 2 then -- 双击
						PCSkillToMainUI.DelSkillToUI(skillID)
					else 
						local config 	= SL:GetValue("SKILL_CONFIG", skillID)
						local desc   	= (config and config.desc or "") .. "\\<双击从屏幕上删除/FCOLOR=250>"
						local worldPos 	= GUI:getTouchEndPosition(sender)
						SL:SHOW_DESCTIP(desc, nil, worldPos, GUI:p(0, 1))
					end

					times = 0
					GUI:stopAllActions(sender)
					scheduleID = nil
				end, doubleDelay)
			end
		elseif eventType == 3 then
			if isMoved then
                PCSkillToMainUI.OnSkillUIPostionUpdate({skill = skillID, pos = GUI:getPosition(sender)})
			end
			times = 0
			if scheduleID then
				GUI:stopAllActions(sender)
				scheduleID = nil
			end
		end
	end)
end

-- 清空缓存数据
function PCSkillToMainUI.OnDelSkillToUI(skillID)
    local key = PCSkillToMainUI.GetIndexBySkillID(skillID)
    if not key then
        return
    end
    
    table.remove(PCSkillToMainUI._skillData, key)
    PCSkillToMainUI.WriteData()
end

function PCSkillToMainUI.WriteData()
    SL:SetValue("CLOUD_DATA_BY_KEY", "main_skill_pc" , PCSkillToMainUI._skillData or {})
end

function PCSkillToMainUI.ReadData()
    return SL:GetValue("CLOUD_DATA_BY_KEY", "main_skill_pc")
end

-- 更新CD倒计时
function PCSkillToMainUI.OnSkillCDTimeChange(data)
    local skillID = data.id
	local progressCD = PCSkillToMainUI._skillCells[skillID] and PCSkillToMainUI._skillCells[skillID].progressCD
    if GUI:Win_IsNull(progressCD) then
        return
    end

    GUI:setVisible(progressCD, data.percent ~= 0)
    GUI:ProgressTimer_setPercentage(progressCD, data.percent)
end

-- 删除技能，更新技能栏
function PCSkillToMainUI.OnSkillDelete(data)
    PCSkillToMainUI.DelSkillToUI(data and data.MagicID)
end

-- 监听添加skill到UI
function PCSkillToMainUI.OnAddSkillToUI(data)
    local skillID = data and tonumber(data.skillID)
    if not skillID then
        return
    end

    PCSkillToMainUI.AddSkillToUI(data)

    if PCSkillToMainUI.GetIndexBySkillID(skillID) then
        return
    end

    PCSkillToMainUI._skillData = PCSkillToMainUI._skillData or {}
    PCSkillToMainUI._skillData[#PCSkillToMainUI._skillData + 1] = {skillID = skillID, pos = data.pos}

    PCSkillToMainUI.WriteData()
end

function PCSkillToMainUI.OnSkillUIPostionUpdate(data)
    if not data or not PCSkillToMainUI._skillData then
        return
    end

    local key = PCSkillToMainUI.GetIndexBySkillID(data.skillID)
    if not key then
        return
    end

    PCSkillToMainUI._skillData[key] = data
    PCSkillToMainUI.WriteData()
end

function PCSkillToMainUI.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "PCSkillToMainUI", PCSkillToMainUI.OnSkillDelete)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CD_CHANGE, "PCSkillToMainUI", PCSkillToMainUI.OnSkillCDTimeChange)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL_TO_UI_WIN32, "PCSkillToMainUI", PCSkillToMainUI.OnDelSkillToUI)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD_TO_UI_WIN32, "PCSkillToMainUI", PCSkillToMainUI.OnAddSkillToUI)
end

PCSkillToMainUI.main()
