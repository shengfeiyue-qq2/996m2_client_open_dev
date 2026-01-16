Mail = {}

MailInfo = MailInfo or {}

function Mail.main()
    local parent = GUI:GetLayerOpenParam()
    GUI:SetLayerOpenParam(nil)
    MailInfo._parent = parent
    Mail.InitData()
    Mail.InitUI() 
    Mail.RegisterEvent()
    Mail.ShowDefaultMainPanel()
    Mail.HideBubbleTips()
    SL:RequestMailList()
end

function Mail.InitData()
    MailInfo._isWinMode = SL:GetValue("IS_PC_OPER_MODE")
    Mail._currMailID = 0
    MailInfo._cells = {}
    MailInfo._items = {}
end

function Mail.InitUI()
    GUI:LoadExport(MailInfo._parent, MailInfo._isWinMode and "social/mail/mail_win32" or "social/mail/mail")

    MailInfo._ui = GUI:ui_delegate(MailInfo._parent)
    MailInfo._layer = MailInfo._ui.mailLayer
    -- 全部提取
    GUI:addOnClickEvent(MailInfo._ui.btn_takeOut_all, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestGetAllMailItems()
    end)

    -- 删除已读
    GUI:addOnClickEvent(MailInfo._ui.btn_delete_read, function(sender)
        if Mail.CheckAbleDeleteAllReadMail() then
            GUI:delayTouchEnabled(sender)
            SL:RequestDelReadMail()
        else
            local mailList = SL:GetValue("MAIL_LIST")
            if mailList and next(mailList) then
                SL:ShowSystemTips("有邮件附件未提取，删除失败")
            else
                SL:ShowSystemTips("没有可删除邮件")
            end
        end
    end)

    -- 提取
    GUI:addOnClickEvent(MailInfo._ui.btn_takeOut, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestGetMailItems(Mail._currMailID)
    end)

    -- 删除
    GUI:addOnClickEvent(MailInfo._ui.btn_delete, function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestDelMail(Mail._currMailID)
    end)

    -- 确定收货
    if MailInfo._ui.btn_sure then
        GUI:addOnClickEvent(MailInfo._ui.btn_sure, function()
            local mailId = Mail._currMailID
            local mail = SL:GetValue("MAIL_BY_ID", mailId)
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
    if MailInfo._ui.btn_refuse then
        GUI:addOnClickEvent(MailInfo._ui.btn_refuse, function()
            local mailId = Mail._currMailID
            local mail = SL:GetValue("MAIL_BY_ID", mailId)
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

   

    SL:AttachTXTSUI({
        root  = MailInfo._ui.bg,
        index = SLDefine.SUIComponentTable.Mail
    })
end

-- 默认显示
function Mail.ShowDefaultMainPanel()
    GUI:setVisible(MailInfo._ui.panel_main, true)

    GUI:Text_setString(MailInfo._ui.label_title, "")
    GUI:Text_setString(MailInfo._ui.label_sender, "")
    GUI:Text_setString(MailInfo._ui.label_time, "")

    GUI:ListView_removeAllItems(MailInfo._ui.list_mailContent)

    GUI:setVisible(MailInfo._ui.list_items, false)
    GUI:setVisible(MailInfo._ui.rewardFlag_icon, false)
    GUI:setVisible(MailInfo._ui.btn_takeOut, false)
    GUI:setVisible(MailInfo._ui.btn_delete, false)
    GUI:setVisible(MailInfo._ui.Text_item, false)
end

-- 刷新左边的邮件列表
function Mail.RefreshMailList()
    local mailList = SL:GetValue("MAIL_LIST")

    local index = 0
    local mailSortList = {}
    for _, v in pairs(mailList) do
        index = index + 1
        mailSortList[index] = v
    end

    table.sort(mailSortList, function(a, b)
        return a.index < b.index
    end)

    local list = MailInfo._ui.list
    GUI:ListView_removeAllItems(list)
    MailInfo._cells = {}

    for i = 1, #mailSortList do
        local mail = mailSortList[i]
        local mailId = mail.Id

        local itemSize = {w = 220, h = 74}
        if MailInfo._isWinMode then 
            itemSize.w = 187 
            itemSize.h = 62
        end 
        
        local function createCell(parent)
            local layout = Mail.CreateMailItem(parent, mailId)
            return layout
        end
        local quickCell = GUI:QuickCell_Create(list, "quickCell"..mailId, 0, 0, itemSize.w, itemSize.h, createCell)
        MailInfo._cells[mailId] = quickCell

        -- 第一次默认读取第一封邮件
        local curId = Mail._currMailID
        if i == 1 and SL:GetValue("MAIL_BY_ID", curId) == nil then
            Mail._currMailID = mailId
        end
    end

    if #mailSortList > 0 then 
        Mail.RefreshMainPanel()
    else 
        Mail.ShowDefaultMainPanel()
    end
end

function Mail.CheckAbleDeleteReadMailByID(mailID)
    local mail = SL:GetValue("MAIL_BY_ID", mailID)
    if not mail then
        return false
    end
    return mail.btReadFlag == 1 and (#mail.sItem == 0 or (#mail.sItem > 0 and mail.btRecvFlag == 1))
end

function Mail.CheckAbleDeleteAllReadMail()
    local mails = SL:GetValue("MAIL_LIST")
    for k, v in pairs(mails) do
        if Mail.CheckAbleDeleteReadMailByID(k) then
            return true
        end
    end
    return false
end

function Mail.CreateMailItem(parent, mailId)
    local res = MailInfo._isWinMode and "social/mail/mail_item_win32" or "social/mail/mail_item"
    GUI:LoadExport(parent, res)
    local item = GUI:getChildByName(parent, "item")
    Mail.RefreshMailItem(item, mailId)
    return item
end

-- 刷新左边邮件列表中的item
function Mail.RefreshMailItem(item, mailId)
    local mail = SL:GetValue("MAIL_BY_ID", mailId)
    if not mail then 
        return
    end 

    local itemUI = GUI:ui_delegate(item)
    if mail.Id == Mail._currMailID then
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

    GUI:addOnClickEvent(itemUI["btn_delete"], function(sender)
        GUI:delayTouchEnabled(sender)
        SL:RequestDelMail(mailId)
    end)

    GUI:addOnClickEvent(item, function()
        Mail._currMailID = mailId
        Mail.RefreshMainPanel()
        for i, cell in pairs(MailInfo._cells) do 
            GUI:QuickCell_Exit(cell)
            GUI:QuickCell_Refresh(cell)
        end 
    end)
end

function Mail.RefreshMainPanel()
    Mail.ShowDefaultMainPanel()
    local mailList = SL:GetValue("MAIL_LIST")
    if mailList == nil or next(mailList) == nil then
        return
    end

    local mailId = Mail._currMailID
    if mailId <= 0 then
        return
    end

    local mail = SL:GetValue("MAIL_BY_ID", mailId)
    if mail == nil then
        return
    end

    if mail.btReadFlag == 0 then
        SL:RequestReadMail(mailId)
    end

    GUI:Text_setString(MailInfo._ui.label_title, mail.sLable)
    GUI:setPositionX(MailInfo._ui.label_title, 10 + GUI:getPositionX(MailInfo._ui.mail_title) + GUI:getContentSize(MailInfo._ui.mail_title).width)

    GUI:Text_setString(MailInfo._ui.label_sender, mail.sSendName)
    GUI:setPositionX(MailInfo._ui.label_sender, 10 + GUI:getPositionX(MailInfo._ui.mail_sender) + GUI:getContentSize(MailInfo._ui.mail_sender).width)

    GUI:Text_setString(MailInfo._ui.label_time, mail.dCreateTime)
    GUI:setPositionX(MailInfo._ui.label_time, 10 + GUI:getPositionX(MailInfo._ui.time) + GUI:getContentSize(MailInfo._ui.time).width)

    GUI:ListView_removeAllItems(MailInfo._ui.list_mailContent)

    local panelText = GUI:Layout_Create(MailInfo._ui.list_mailContent, "panelText", 0, 0, 0, 0, false)
    GUI:setAnchorPoint(panelText, 0, 1)

    local richMaxW = GUI:getContentSize(MailInfo._ui.list_mailContent).width - 5
    local richText = nil
    local fontSize = MailInfo._isWinMode and 12 or 16
    if SL:GetValue("GAME_DATA", "MailFormatType") == 1 then
        richText = GUI:RichText_Create(panelText, "richText" .. mailId, 0, 0, mail.sMemo, richMaxW, fontSize, "#f8e6c6")
    else
        richText = GUI:RichTextFCOLOR_Create(panelText, "richText" .. mailId, 0, 0, mail.sMemo, richMaxW, fontSize, SL:ConvertColorFromHexString("#f8e6c6"))
    end

    local richSize = GUI:getContentSize(richText)
    GUI:setContentSize(panelText, richSize.width, richSize.height)

    -- 有附件
    if #mail.sItem > 0 then
        GUI:setVisible(MailInfo._ui.list_items, true)
        GUI:removeAllChildren(MailInfo._ui.list_items)
        GUI:setVisible(MailInfo._ui.Text_item, true)

        if mail.btRecvFlag == 0 then
            -- 附件未领取 不能删除
            if mail.btType == 9997 then
                if MailInfo._ui.btn_sure then
                    GUI:setVisible(MailInfo._ui.btn_sure, true)
                end
                if MailInfo._ui.btn_refuse then
                    GUI:setVisible(MailInfo._ui.btn_refuse, true)
                end
            else
                GUI:setVisible(MailInfo._ui.btn_takeOut, true)
                if MailInfo._ui.btn_sure then
                    GUI:setVisible(MailInfo._ui.btn_sure, false)
                end
                if MailInfo._ui.btn_refuse then
                    GUI:setVisible(MailInfo._ui.btn_refuse, false)
                end
            end

        elseif mail.btRecvFlag == 1 then
            GUI:setVisible(MailInfo._ui.rewardFlag_icon, true)
            GUI:setVisible(MailInfo._ui.btn_delete, true)
        end

        local countFontSize = nil
        if MailInfo._isWinMode then
            countFontSize = 10
        end

        if mail.btType == 9997 then --确定收货 or 拒绝收货邮件
            local itemData =  SL:JsonDecode(mail.sItem)
            local items = SL:TransItemDataIntoChatShow(itemData)
            local itemdata = { index = items.Index, count = items.OverLap, look = true, countFontSize = countFontSize, bgVisible = true,itemData = items }
            local item = GUI:ItemShow_Create(MailInfo._ui.list_items, "item1", 0, 0, itemdata)
            if mail.btRecvFlag == 1 then
                GUI:ItemShow_setIconGrey(item, true)
            end
        elseif mail.btType == 9999 then --交易行的附件
            local itemData = SL:JsonDecode(mail.sItem)
            local items = SL:TransItemDataIntoChatShow(itemData)
            local itemdata = { index = items.Index, count = items.OverLap, look = true, countFontSize = countFontSize, bgVisible = true,itemData = items }
            local item = GUI:ItemShow_Create(MailInfo._ui.list_items, "item1", 0, 0, itemdata)
            if mail.btRecvFlag == 1 then
                GUI:ItemShow_setIconGrey(item, true)
            end
        else
            for i = 1, #mail.sItem do
                local items = mail.sItem[i]
                local count = items.Count
                local itemdata = { index = items.Index, count = items.Count, look = true, countFontSize = countFontSize, bgVisible = true }
                local item = GUI:ItemShow_Create(MailInfo._ui.list_items, "item" .. i, 0, 0, itemdata)
                if mail.btRecvFlag == 1 then
                    GUI:ItemShow_setIconGrey(item, true)
                end
            end
        end

    -- 没附件
    else
        GUI:setVisible(MailInfo._ui.btn_delete, true)
    end
end

function Mail.DelOneMail(mailId)
    local index = 0
    local mailSortList = {}
    local mailList = SL:GetValue("MAIL_LIST")
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
        Mail._currMailID = curId
    end 

    Mail.RefreshMainPanel()
    if curId then 
        GUI:QuickCell_Exit(MailInfo._cells[curId])
        GUI:QuickCell_Refresh(MailInfo._cells[curId])
    end 

    -- 删除的动画
    local item = MailInfo._cells[mailId]
    if item then
        local list = MailInfo._ui.list
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
        MailInfo._cells[mailId] = nil
    end
end

function Mail.OnUpdateOne(mailID)
    -- 刷新内容
    if mailID == Mail._currMailID then
        Mail.RefreshMainPanel()
    end

    -- 刷新当前选择条目信息
    if MailInfo._cells[mailID] then
        GUI:QuickCell_Exit(MailInfo._cells[mailID])
        GUI:QuickCell_Refresh(MailInfo._cells[mailID])
    end
end

function Mail.OnUpdateAll()
    Mail.RefreshMailList()
end

function Mail.OnDeleteAllRead()
    SL:ShowSystemTips("删除邮件成功")
    SL:RequestMailList()
end

function Mail.HideBubbleTips()
    -- 隐藏新邮件气泡
    SL:DelBubbleTips(GUIDefine.BubbleType.MAIL)
end

function Mail.OnClose()
    if MailInfo and MailInfo._layer then 
        Mail.UnRegisterEvent()
        SL:UnAttachTXTSUI({
            index = SLDefine.SUIComponentTable.Mail
        })
        MailInfo = nil
    end
end
-----------------------------------注册事件--------------------------------------
function Mail.RegisterEvent()
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_LIST_REFRESH, "Mail", Mail.RefreshMailList)
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_DELETE_ALL_READ, "Mail", Mail.OnDeleteAllRead)
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_UPDATE_ALL, "Mail", Mail.OnUpdateAll)
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_UPDATE, "Mail", Mail.OnUpdateOne)
    SL:RegisterLUAEvent(LUA_EVENT_MAIL_DELETE, "Mail", Mail.DelOneMail)
    SL:RegisterLUAEvent(LUA_EVENT_SOCIAL_MAIL_LAYER_CLOSE, "Mail", Mail.OnClose)
end

function Mail.UnRegisterEvent()
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_LIST_REFRESH, "Mail")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_DELETE_ALL_READ, "Mail")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_UPDATE_ALL, "Mail")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_UPDATE, "Mail")
    SL:UnRegisterLUAEvent(LUA_EVENT_MAIL_DELETE, "Mail")
    SL:UnRegisterLUAEvent(LUA_EVENT_SOCIAL_MAIL_LAYER_CLOSE, "Mail")
end

Mail.main()