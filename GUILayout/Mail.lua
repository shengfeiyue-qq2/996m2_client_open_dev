Mail = {}

function Mail.main()
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, SL:GetMetaValue("WINPLAYMODE") and "social/mail/mail_win32" or "social/mail/mail")

    Mail._ui = GUI:ui_delegate(parent)
    Mail._movingFinish = true
    Mail._cells = {}
    Mail._items = {}

    -- 全部提取
    GUI:addOnClickEvent(Mail._ui["btn_takeOut_all"], function()
        SL:RequestGetAllMailItems()
    end)

    -- 删除已读
    GUI:addOnClickEvent(Mail._ui["btn_delete_read"], function()
        if SL:GetMetaValue("MAIL_HAVE_DEL_ITEM") then
            SL:RequestDelReadMail()
        else
            local mailList = SL:GetMetaValue("MAIL_LIST")
            if mailList and next(mailList) then
                SL:ShowSystemTips("有邮件附件未提取，删除失败")
            else
                SL:ShowSystemTips("没有可删除邮件")
            end
        end
    end)

    -- 提取
    Mail._btn_takeOut = Mail._ui["btn_takeOut"]
    GUI:addOnClickEvent(Mail._btn_takeOut, function()
        SL:RequestGetMailItems(SL:GetMetaValue("MAIL_CURRENT_ID"))
    end)

    -- 删除
    Mail._btn_delete = Mail._ui["btn_delete"]
    GUI:addOnClickEvent(Mail._btn_delete, function()
        GUI:setClickDelay(Mail._btn_delete, 0.1)
        if Mail._movingFinish then
            SL:RequestDelMail(SL:GetMetaValue("MAIL_CURRENT_ID"))
        end
    end)

     -- 确定收货
     Mail._btn_sure = Mail._ui["btn_sure"]
     if Mail._btn_sure then
        GUI:addOnClickEvent(Mail._btn_sure, function()
            local mailId = SL:GetMetaValue("MAIL_CURRENT_ID")
            local mail = SL:GetMetaValue("MAIL_BY_ID", mailId)
            if not mail then 
                return
            end
            local itemData =  SL:JsonDecode(mail.sItem)
            local other =  SL:JsonDecode(itemData.other)
            if other then
                other.emailId = mailId
                SL:RequestSureTake(nil, other, function(code, data, msg)
                    if code == 200 then
                        SL:ShowSystemTips(msg)
                    end
                end)
            end
        end)
     end
      -- 拒绝收货
    Mail._btn_refuse = Mail._ui["btn_refuse"]
    if Mail._btn_refuse then
        GUI:addOnClickEvent(Mail._btn_refuse, function()
            local mailId = SL:GetMetaValue("MAIL_CURRENT_ID")
            local mail = SL:GetMetaValue("MAIL_BY_ID", mailId)
            if not mail then 
                return
            end
            local itemData =  SL:JsonDecode(mail.sItem)
            local other =  SL:JsonDecode(itemData.other)
            if other then
                other.emailId = mailId
                SL:RequestRefuseTake(nil, other, function(code, data, msg)
                    if code == 200 then
                        SL:ShowSystemTips(msg)
                    end
                end)
            end
        end)
    end
    

    Mail.ShowDefaultMainPanel()
    SL:SetMetaValue("MAIL_CURRENT_ID", 0)

    Mail.RegisterEvent()
    SL:RequestMailList()
end

-- 默认显示
function Mail.ShowDefaultMainPanel()
    GUI:setVisible(Mail._ui["panel_main"], true)

    GUI:Text_setString(Mail._ui["label_title"], "")
    GUI:Text_setString(Mail._ui["label_sender"], "")
    GUI:Text_setString(Mail._ui["label_time"], "")

    GUI:ListView_removeAllItems(Mail._ui["list_mailContent"])

    GUI:setVisible(Mail._ui["list_items"], false)
    GUI:setVisible(Mail._ui["rewardFlag_icon"], false)
    GUI:setVisible(Mail._btn_takeOut, false)
    GUI:setVisible(Mail._btn_delete, false)
    GUI:setVisible(Mail._ui["Text_item"], false)
end

-- 刷新左边的邮件列表
function Mail.RefreshMailList()
    local mailList = SL:GetMetaValue("MAIL_LIST")
    dump(mailList,"mailList")
    local index = 0
    local mailSortList = {}
    for _, v in pairs(mailList) do
        index = index + 1
        mailSortList[index] = v
    end

    table.sort(mailSortList, function(a, b)
        return a.index < b.index
    end)

    local list = Mail._ui["list"]
    GUI:ListView_removeAllItems(list)
    Mail._cells = {}

    for i = 1, #mailSortList do
        local mail = mailSortList[i]
        local mailId = mail.Id

        local itemSize = {w = 220, h = 74}
        local isWinMode = SL:GetMetaValue("WINPLAYMODE")
        if isWinMode then 
            itemSize.w = 187 
            itemSize.h = 62
        end 
        
        local function createCell(parent)
            local layout = Mail.CreateMailItem(parent, mailId)
            return layout
        end
        local quickCell = GUI:QuickCell_Create(list, "quickCell"..mailId, 0, 0, itemSize.w, itemSize.h, createCell)
        Mail._cells[mailId] = quickCell

        -- 第一次默认读取第一封邮件
        local curId = SL:GetMetaValue("MAIL_CURRENT_ID")
        if i == 1 and SL:GetMetaValue("MAIL_BY_ID", curId) == nil then
            SL:SetMetaValue("MAIL_CURRENT_ID", mailId)
        end
    end

    if #mailSortList > 0 then 
        Mail.RefreshMainPanel()
    else 
        Mail.ShowDefaultMainPanel()
    end
end

function Mail.CreateMailItem(parent, mailId)
    local res = SL:GetMetaValue("WINPLAYMODE") and "social/mail/mail_item_win32" or "social/mail/mail_item"
    GUI:LoadExport(parent, res)
    local item = GUI:getChildByName(parent, "item")
    Mail.RefreshMailItem(item, mailId)
    return item
end

-- 刷新左边邮件列表中的item
function Mail.RefreshMailItem(item, mailId)
    local mail = SL:GetMetaValue("MAIL_BY_ID", mailId)
    if not mail then 
        return
    end 

    local itemUI = GUI:ui_delegate(item)
    if mail.Id == SL:GetMetaValue("MAIL_CURRENT_ID") then
        GUI:setVisible(itemUI["kuang01"], true)
        GUI:setVisible(itemUI["kuang02"], false)
    else
        GUI:setVisible(itemUI["kuang01"], false)
        GUI:setVisible(itemUI["kuang02"], true)
    end
    GUI:setTouchEnabled(item, not GUI:getVisible(itemUI["kuang01"]))

    GUI:setVisible(itemUI["btn_delete"], false)
    GUI:setVisible(itemUI["img_reward"], false)

    local state = mail.btReadFlag
    if state == 0 then  -- 未读
        GUI:Text_setString(itemUI["label_state"], "未读")
        GUI:Text_setTextColor(itemUI["label_state"], "#ff0500")

    elseif state == 1 then  -- 已读
        GUI:Text_setString(itemUI["label_state"], "已读")
        GUI:Text_setTextColor(itemUI["label_state"], "#28ef01")
        if #mail.sItem > 0 then
            if mail.btRecvFlag == 1 then
                GUI:setVisible(itemUI["btn_delete"], true)
            end
        else
            GUI:setVisible(itemUI["btn_delete"], true)
        end
    end

    if #mail.sItem > 0 and mail.btRecvFlag == 0 then
        GUI:setVisible(itemUI["img_reward"], true)
    end

    GUI:Text_setString(itemUI["item_sender"], mail.sSendName)
    GUI:Text_setString(itemUI["item_title"], mail.sLable)

    GUI:addOnClickEvent(itemUI["btn_delete"], function()
        if Mail._movingFinish then
            SL:RequestDelMail(mailId)
        end
    end)

    GUI:addOnClickEvent(item, function()
        SL:SetMetaValue("MAIL_CURRENT_ID", mailId)
        Mail.RefreshMainPanel()
        for i, cell in pairs(Mail._cells) do 
            GUI:QuickCell_Exit(cell)
            GUI:QuickCell_Refresh(cell)
        end 
    end)
end

function Mail.RefreshMainPanel()
    Mail.ShowDefaultMainPanel()
    local mailList = SL:GetMetaValue("MAIL_LIST")
    if mailList == nil or next(mailList) == nil then
        return
    end

    local mailId = SL:GetMetaValue("MAIL_CURRENT_ID")
    if mailId <= 0 then
        return
    end

    local mail = SL:GetMetaValue("MAIL_BY_ID", mailId)
    if mail == nil then
        return
    end

    if mail.btReadFlag == 0 then
        SL:RequestReadMail(mailId)
    end

    local title = Mail._ui["mail_title"]
    local label_title = Mail._ui["label_title"]
    GUI:Text_setString(label_title, mail.sLable)
    GUI:setPositionX(label_title, 10 + GUI:getPositionX(title) + GUI:getContentSize(title).width)

    local sender = Mail._ui["mail_sender"]
    local label_sender = Mail._ui["label_sender"]
    GUI:Text_setString(label_sender, mail.sSendName)
    GUI:setPositionX(label_sender, 10 + GUI:getPositionX(sender) + GUI:getContentSize(sender).width)

    local time = Mail._ui["time"]
    local label_time = Mail._ui["label_time"]
    GUI:Text_setString(label_time, mail.dCreateTime)
    GUI:setPositionX(label_time, 10 + GUI:getPositionX(time) + GUI:getContentSize(time).width)

    local contentList = Mail._ui["list_mailContent"]
    GUI:ListView_removeAllItems(contentList)

    local panelText = GUI:Layout_Create(contentList, "panelText", 0, 0, 0, 0, false)
    GUI:setAnchorPoint(panelText, 0, 1)

    local richMaxW = GUI:getContentSize(contentList).width - 5
    local richText = nil
    local fontSize = SL:GetMetaValue("WINPLAYMODE") and 12 or 16
    if SL:GetMetaValue("GAME_DATA", "MailFormatType") == 1 then
        richText = GUI:RichText_Create(panelText, "richText" .. mailId, 0, 0, mail.sMemo, richMaxW, fontSize, "#f8e6c6")
    else
        richText = GUI:RichTextFCOLOR_Create(panelText, "richText" .. mailId, 0, 0, mail.sMemo, richMaxW, fontSize, SL:ConvertColorFromHexString("#f8e6c6"))
    end

    local richSize = GUI:getContentSize(richText)
    GUI:setContentSize(panelText, richSize.width, richSize.height)

    -- 有附件
    if #mail.sItem > 0 then
        GUI:setVisible(Mail._ui["list_items"], true)
        GUI:removeAllChildren(Mail._ui["list_items"])
        GUI:setVisible(Mail._ui["Text_item"], true)

        if mail.btRecvFlag == 0 then
            -- 附件未领取 不能删除
            if mail.btType == 9997 then
                if Mail._btn_sure then
                    GUI:setVisible(Mail._btn_sure, true)
                end
                if Mail._btn_refuse then
                    GUI:setVisible(Mail._btn_refuse, true)
                end
            else
                GUI:setVisible(Mail._btn_takeOut, true)
                if Mail._btn_sure then
                    GUI:setVisible(Mail._btn_sure, false)
                end
                if Mail._btn_refuse then
                    GUI:setVisible(Mail._btn_refuse, false)
                end
            end
        elseif mail.btRecvFlag == 1 then
            GUI:setVisible(Mail._ui["rewardFlag_icon"], true)
            GUI:setVisible(Mail._btn_delete, true)
        end

        local countFontSize = nil
        if SL:GetMetaValue("WINPLAYMODE") then
            countFontSize = 10
        end

        if mail.btType == 9997 then --确定收货 or 拒绝收货邮件
            local itemData =  SL:JsonDecode(mail.sItem)
            local items = SL:TransItemDataIntoChatShow(itemData)
            local itemdata = { index = items.Index, count = items.OverLap, look = true, countFontSize = countFontSize, bgVisible = true }
            local item = GUI:ItemShow_Create(Mail._ui["list_items"], "item1", 0, 0, itemdata)
            if mail.btRecvFlag == 1 then
                GUI:ItemShow_setIconGrey(item, true)
            end
        elseif mail.btType == 9999 then --交易行的附件
            local itemData =  SL:JsonDecode(mail.sItem)
            local items = SL:TransItemDataIntoChatShow(itemData)
            local itemdata = { index = items.Index, count = items.OverLap, look = true, countFontSize = countFontSize, bgVisible = true }
            local item = GUI:ItemShow_Create(Mail._ui["list_items"], "item1", 0, 0, itemdata)
            if mail.btRecvFlag == 1 then
                GUI:ItemShow_setIconGrey(item, true)
            end
        else
            for i = 1, #mail.sItem do
                local items = mail.sItem[i]
                local count = items.Count
                local itemdata = { index = items.Index, count = items.Count, look = true, countFontSize = countFontSize, bgVisible = true }
                local item = GUI:ItemShow_Create(Mail._ui["list_items"], "item" .. i, 0, 0, itemdata)
                if mail.btRecvFlag == 1 then
                    GUI:ItemShow_setIconGrey(item, true)
                end
            end
        end

    -- 没附件
    else
        GUI:setVisible(Mail._btn_delete, true)
    end
end

function Mail.DelOneMail(mailId)
    local index = 0
    local mailSortList = {}
    local mailList = SL:GetMetaValue("MAIL_LIST")
    for _, v in pairs(mailList) do
        index = index + 1
        mailSortList[index] = v
    end
    table.sort(mailSortList, function(a, b)
        return a.index < b.index
    end)

    -- 跳转当前item
    local curMail = mailSortList[1]
    local curId = nil
    if curMail then 
        curId = curMail.Id
        SL:SetMetaValue("MAIL_CURRENT_ID", curId)
    end 

    Mail.RefreshMainPanel()
    if curId then 
        GUI:QuickCell_Exit(Mail._cells[curId])
        GUI:QuickCell_Refresh(Mail._cells[curId])
    end 

    -- 删除的动画
    local item = Mail._cells[mailId]
    if item then
        local list = Mail._ui["list"]
        GUI:stopAllActions(list)
        GUI:setTouchEnabled(list, false)

        local xx = GUI:getPositionX(item)
        local yy = GUI:getPositionY(item)

        local function removeItem()
            local index = GUI:ListView_getItemIndex(list, item)
            GUI:ListView_removeItemByIndex(list, index)
            GUI:setTouchEnabled(list, true)
        end

        local itemW = GUI:getContentSize(item).width
        GUI:Timeline_EaseSineOut_MoveTo(item, {x = xx - itemW, y = yy}, 0.3, removeItem)
        Mail._cells[mailId] = nil
    end
end

-----------------------------------注册事件--------------------------------------
function Mail.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_UPDATE, "Mail", Mail.RefreshMailList)
end

function Mail.RemoveEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_UPDATE, "Mail")
end