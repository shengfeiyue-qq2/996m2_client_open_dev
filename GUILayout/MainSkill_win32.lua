MainSkill_win32 = {}

function MainSkill_win32.main()

	MainSkill_win32._skill_cells = {}

	MainSkill_win32.RegisterEvent()
end

-- 删除主界面技能按钮
function MainSkill_win32.RemoveSkillToUI(data)
	if not data then
		return
	end

	if not tonumber(data.skill) then
		return
	end

	local skillID    = data.skill
	local skillCell  = MainSkill_win32._skill_cells[skillID]
	if skillCell and not GUI:Win_IsNull(skillCell.skillPanel) then
		GUI:removeFromParent(skillCell.skillPanel)
		MainSkill_win32._skill_cells[skillID] = nil
	end

	SL:onLUAEvent(LUA_EVENT_SKILL_REMOVE_TO_UI_WIN32, data)
end

-- 主界面添加技能按钮
function MainSkill_win32.AddSkillToUI(data)
	if not data then
		return
	end

	if not tonumber(data.skill) then
		return
	end

	local skillPos = data.pos or {x=0, y=0}
	local skillID  = data.skill
	
	local iconPath = SL:GetMetaValue("SKILL_RECT_ICON_PATH", skillID)
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
	MainSkill_win32._skill_cells[skillID] = {
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
				SL:onLUAEvent(LUA_EVENT_SKILL_POSITION_UPDATE_WIN32, {skill = skillID, pos = GUI:getPosition(sender)})
				return
			end
			times = times + 1
			if not scheduleID then
				scheduleID = SL:scheduleOnce(sender, function()
					if times >= 2 then -- 双击
						MainSkill_win32.RemoveSkillToUI(data)
					else 
						local config 	= SL:GetMetaValue("SKILL_CONFIG", skillID)
						local desc   	= (config and config.desc or "") .. "\\<双击从屏幕上删除/FCOLOR=250>"
						local worldPos 	= GUI:getTouchEndPosition(sender)
						SL:SHOW_DESCTIP(desc, nil, worldPos, cc.p(0, 1))
					end

					times = 0
					GUI:stopAllActions(sender)
					scheduleID = nil
				end, doubleDelay)
			end
		elseif eventType == 3 then
			if isMoved then
				SL:onLUAEvent(LUA_EVENT_SKILL_POSITION_UPDATE_WIN32, {skill = skillID, pos = GUI:getPosition(sender)})
			end
			times = 0
			if scheduleID then
				GUI:stopAllActions(sender)
				scheduleID = nil
			end
		end
	end)
end

-- 更新倒计时
function MainSkill_win32.UpdateSkillCDTimeChange(data)
	local skillID = data.id
	local skillCell = MainSkill_win32._skill_cells[skillID]
	if skillCell and skillCell.progressCD then
		GUI:setVisible(skillCell.progressCD, data.percent ~= 0)
		GUI:ProgressTimer_setPercentage(skillCell.progressCD, data.percent)
	end
end

-----------------------------------监听  begin
-- 监听添加skill到UI
function MainSkill_win32.HandleAddSkillToUI(data)
	MainSkill_win32.AddSkillToUI(data)
end

-- 倒计时监听
function MainSkill_win32.HandleSkillCDTimeChange(data)
	MainSkill_win32.UpdateSkillCDTimeChange(data)
end

function MainSkill_win32.HandleSkillDelete(data)
    if not data or not data.MagicID then
        return
    end
    MainSkill_win32.RemoveSkillToUI({skill = data.MagicID})
end

-----------------------------------监听  end
-- 注册事件
function MainSkill_win32.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_ADD_TO_UI_WIN32, "MainSkill_win32", MainSkill_win32.HandleAddSkillToUI)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_CD_TIME_CHANGE, "MainSkill_win32", MainSkill_win32.HandleSkillCDTimeChange)
    SL:RegisterLUAEvent(LUA_EVENT_SKILL_DEL, "MainSkill_win32", MainSkill_win32.HandleSkillDelete)
end

return MainSkill_win32