HeroTitle_Look_TradingBank = {}
HeroTitle_Look_TradingBank._ui = nil


HeroTitle_Look_TradingBank._path = GUIDefine.PATH_RES_PRIVATE ..  "title_layer_ui/"

function HeroTitle_Look_TradingBank.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    GUI:LoadExport(parent, "hero_look_tradingbank/hero_title_node")

    HeroTitle_Look_TradingBank._ui = GUI:ui_delegate(parent)
    if not HeroTitle_Look_TradingBank._ui then
        return false
    end

    HeroTitle_Look_TradingBank.InitUI()
end

function HeroTitle_Look_TradingBank.InitUI()
    -- 已激活的称号
    local activeID = TradingBankLookPlayerData.GetHeroActiveTitle()

    HeroTitle_Look_TradingBank.RefCurTitle(activeID)

    HeroTitle_Look_TradingBank.RefTitleList(activeID)
end

-- 刷新当前穿戴
function HeroTitle_Look_TradingBank.RefCurTitle(activeID)
    local btnCurTitle = HeroTitle_Look_TradingBank._ui["Button_curTitle"]
    local lblCurTitle = HeroTitle_Look_TradingBank._ui["Text_curTitle"]

    GUI:setTouchEnabled(btnCurTitle, activeID ~= nil)

    if activeID then
        local res = TitleData.GetTitleActivateImage(activeID)
        GUI:Button_loadTextureNormal(btnCurTitle, res)
        GUI:Text_setString(lblCurTitle, SL:GetValue("ITEM_NAME", activeID))
        GUI:Text_setTextColor(lblCurTitle, SL:GetHexColorByStyleId(SL:GetValue("ITEM_NAME_COLORID", activeID)))
        GUI:Text_setFontSize(lblCurTitle,  18)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(btnCurTitle, contentSize.width, contentSize.height)
        end
    else
        local res = HeroTitle_Look_TradingBank._path .. "title_3.png"
        GUI:Button_loadTextureNormal(btnCurTitle, res)
        local contentSize = GUI:getImageContentSize(res)
        if contentSize.width > 0 then
            GUI:setContentSize(btnCurTitle, contentSize.width, contentSize.height)
        end
        GUI:Text_setString(lblCurTitle, "")
    end
    GUI:setIgnoreContentAdaptWithSize(btnCurTitle, false)
end

-- 刷新称号列表
function HeroTitle_Look_TradingBank.RefTitleList(activeID)
    -- 称号数据
    local titles = TradingBankLookPlayerData.GetHeroTitle()

    -- 称号列表
    local titleList = SL:HashToSortArray(titles, function(a, b)
        return a.index < b.index
    end)

    titleList = titleList or {}

    local list = HeroTitle_Look_TradingBank._ui["ListView_cells"]
    GUI:removeAllChildren(list)


    local cellPath = "hero_look_tradingbank/title_cell.lua"
    local cellSize = {width = 348, height = 55}

    local count = math.max(5, #titleList)
    for i = 1, count do
        local widget = GUI:Widget_Create(list, "title_cell_" .. i, 0, 0, cellSize.width, cellSize.height)
        GUI:LoadExport(widget, cellPath)
        local ui = GUI:ui_delegate(widget)

        local buttonIcon = ui.Button_icon
        GUI:setTouchEnabled(buttonIcon, false)
        if titleList[i] then
            GUI:setTouchEnabled(buttonIcon, true)
            local titleId = titleList[i].id
            local time = titleList[i].time
            local name = SL:GetValue("ITEM_NAME", titleId)
            local res  = TitleData.GetTitleListImage(titleId)
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, name)

            local contentSize = GUI:getImageContentSize(res)
            if contentSize.width > 0 then
                GUI:setContentSize(buttonIcon, contentSize)
            end

            if titleId == activeID then
                GUI:Button_setGrey(buttonIcon, true)
            else
                GUI:Button_setGrey(buttonIcon, false)
            end

            local function showTips()
                local data = {}
                data.id = titleId
                data.pos = GUI:getWorldPosition(buttonIcon)
                data.type = 1
                data.time = time
                data.job = TradingBankLookPlayerData.GetHeroJob()
                UIOperator:OpenTitleTipsUI(data)
            end
            local function delayCallback()
                if buttonIcon._doubleState then
                    showTips()
                    buttonIcon._doubleState = false
                end
            end

            buttonIcon._doubleState = false
            GUI:addOnClickEvent(buttonIcon, function()
                if not buttonIcon._doubleState then
                    buttonIcon._doubleState = true
                    SL:scheduleOnce(buttonIcon, delayCallback, GUIDefine.CLICK_DOUBLE_TIME)
                else
                    buttonIcon._doubleState = false
                end
            end)
        else
            local res = HeroTitle_Look_TradingBank._path .. "title_4.png"
            GUI:Button_loadTextureNormal(buttonIcon, res)
            GUI:Text_setString(ui.Text_name, "")

            GUI:setContentSize(buttonIcon, GUI:getImageContentSize(res))
        end

        GUI:setIgnoreContentAdaptWithSize(buttonIcon, false)
    end
end

function HeroTitle_Look_TradingBank.OnClose()
end

HeroTitle_Look_TradingBank.main()