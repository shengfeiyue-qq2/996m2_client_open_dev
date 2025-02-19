GuildCreate = {}

function GuildCreate.main()
    if GUI:GetWindow(nil, UIConst.LAYERID.GuildCreateGUI) then
        return
    end

    local parent = GUI:Win_Create(UIConst.LAYERID.GuildCreateGUI, 0, 0, 0, 0, false, false, true, true)
    GuildCreate._layer = parent

    local isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    if isWinMode then
        GUI:LoadExport(parent, "guild/guild_create_win32")
    else
        GUI:LoadExport(parent, "guild/guild_create")
    end

    GuildCreate._ui = GUI:ui_delegate(parent)
    GuildCreate._autoApprove = true             -- 创建行会是否自动同意加入
    GuildCreate._autoLevel = 1                  -- 默认自动同意等级
    GuildCreate._costItems = {}                 -- 创建所需物品/货币

    local mainPanel = GuildCreate._ui["PMainUI"]
    local closeLayout = GuildCreate._ui["CloseLayout"]
    local winSizeW = SL:GetValue("SCREEN_WIDTH")
    local winSizeH = SL:GetValue("SCREEN_HEIGHT")
    GUI:setContentSize(closeLayout, winSizeW, winSizeH)
    GUI:setPosition(mainPanel, winSizeW / 2, winSizeH / 2)

    if isWinMode then
        GUI:setVisible(closeLayout, false)
        GUI:setPosition(mainPanel, winSizeW / 2, SL:GetValue("PC_POS_Y"))
        -- 可拖拽
        GUI:Win_SetDrag(parent, mainPanel)
        GUI:Win_SetZPanel(parent, mainPanel)
    else
        -- 全屏关闭
        GUI:setVisible(closeLayout, true)
        GUI:addOnClickEvent(closeLayout, function()
            UIOperator:CloseGuildCreateUI()
        end)
    end

    -- 关闭按钮
    GUI:addOnClickEvent(GuildCreate._ui["CloseButton"], function()
        UIOperator:CloseGuildCreateUI()
    end)

    -- 自定义挂接组件
    SL:AttachTXTSUI({
        index = SLDefine.SUIComponentTable.GuildCreate,
        root = GuildCreate._ui.PMainUI
    })

    GuildCreate.InitData()
    GuildCreate.InitUI()
    GuildCreate.RegisterEvent()
end

function GuildCreate.InitData()
    local costStr = SL:GetValue("GAME_DATA", "GuildCreate")
    if costStr then
        local costs = string.split(costStr, "&")
        for i = 1, #costs do
            local cost = costs[i]
            if cost and cost ~= "" then
                local info = string.split(cost, "#")
                local id = SL:GetValue("ITEM_INDEX_BY_NAME", info[1])
                local num = tonumber(info[2])
                if id and num and num > 0 then
                    table.insert(GuildCreate._costItems, {id = id, num = num})
                end
            end
        end
    end
end

function GuildCreate.CheckCreateCostItemEnough(autoTips)
    local costs = GuildCreate._costItems
    if not costs or not next(costs) then
        if autoTips then
            SL:ShowSystemTips("创建消耗未配置")
        end
        return false
    end

    for i = 1, #costs do
        local cost = costs[i]
        if SL:GetValue("ITEM_COUNT", cost.id) < cost.num then
            if autoTips then
                SL:ShowSystemTips(string.format("创建行会所需 %s 不足", SL:GetValue("ITEM_NAME", cost.id)))
            end
            return false
        end
    end

    return true
end

function GuildCreate.InitUI()

    GUI:addOnClickEvent(GuildCreate._ui.BtnCreate, function(sender, event)
        if SL:GetValue("M2_FORBID_NAME", true) then
            return
        end
        if not GuildCreate.CheckCreateCostItemEnough(true) then
            return
        end
        local guildName = GUI:TextInput_getString(GuildCreate._ui.Input)
        if guildName == "" then
            SL:ShowSystemTips("未输入行会名")
        else
            -- 敏感字
            local function handle_Func(state)
                if not state then
                    SL:ShowSystemTips("请不要包含敏感字或者特殊字符！")
                    return
                end
                SL:RequestGuildCreate(guildName, GuildCreate._autoApprove, GuildCreate._autoLevel)
            end
            SL:RequestCheckSensitiveWord(guildName, 1, handle_Func)
        end
        GUI:delayTouchEnabled(sender)
    end)

    -- 自动同意入会等级
    GUI:TextInput_setString(GuildCreate._ui.Input_level, GuildCreate._autoLevel)
    GUI:TextInput_addOnEvent(GuildCreate._ui.Input_level, function(_, eventType)
        if eventType == 3 then
            GuildCreate._autoLevel = tonumber(GUI:TextInput_getString(GuildCreate._ui.Input_level))
        end
    end)

    -- 自动同意加入状态
    GUI:CheckBox_setSelected(GuildCreate._ui.CheckBox, GuildCreate._autoApprove)
    GUI:CheckBox_addOnEvent(GuildCreate._ui.CheckBox, function()
        GuildCreate._autoApprove = GUI:CheckBox_isSelected(GuildCreate._ui.CheckBox)
    end)
   
    GuildCreate.InitGuildCreate()
end

function GuildCreate.InitGuildCreate()
    GUI:removeAllChildren(GuildCreate._ui["Node_item"])

    for i, costItem in ipairs(GuildCreate._costItems) do
        -- icon
        local goodsData = {index = costItem.id, count = costItem.num, look = true, bgVisible = true}
        GUI:ItemShow_Create(GuildCreate._ui["Node_item"], "goods_" .. costItem.id, -25 + (i - 1) * 65, 0, goodsData)

        -- text
        local richStr = string.format("%s x%s", SL:GetValue("ITEM_NAME", costItem.id), costItem.num)
        local richColor = "#ff0000"
        local haveNum = tonumber(SL:GetValue("ITEM_COUNT", costItem.id))
        if haveNum and haveNum >= costItem.num then 
            richColor = "#28ef01"
        end 
        local ui_rich = GUI:RichText_Create(GuildCreate._ui["Node_item"], "rich_" .. costItem.id, -15, -30 - (i - 1) * 25, richStr, 200, SL:GetValue("GAME_DATA", "DEFAULT_FONT_SIZE"), richColor)
        GUI:setAnchorPoint(ui_rich, 0, 0)
    end
end 

---------------------------------------------------------------------------
function GuildCreate.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildCreate", GuildCreate.OnClose)
end

function GuildCreate.OnClose(id)
    if id == UIConst.LAYERID.GuildCreateGUI then
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.GuildCreate
        })
        GuildCreate.RemoveEvent()
    end
end

function GuildCreate.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "GuildCreate")
end
----------------------------------------------------------------------------

GuildCreate.main()