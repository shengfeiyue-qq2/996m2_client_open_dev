CodeDOMMainUI = {}

local showUIs = {
    [1] = function (parent) GUI:Timeline_Window1(parent) end,
    [2] = function (parent) GUI:Timeline_Window2(parent) end,
    [3] = function (parent) GUI:Timeline_Window3(parent) end,
    [4] = function (parent) GUI:Timeline_Window4(parent) end,
    [5] = function (parent) GUI:Timeline_Window5(parent) end,
    [6] = function (parent) GUI:Timeline_Window6(parent) end
}

function CodeDOMMainUI.main(data)
    dump(data, "----CodeDOMMainUI---")
    local parent = GUI:Win_Create(data.GUI_ID, 0, 0, 0, 0, data.hideMain, data.hideLast, data.needVoice, data.escClose, data.isRevmsg, data.npcID, data.orderParam)
    GUI:LoadExportEx(parent, data.exportID, data.page, data)
    local showFunc = showUIs[data.showType]
    if showFunc then
        showFunc(parent)
    end
end

function CodeDOMMainUI.update(data)
    GUI:UpdateExportEx(data.parent, data.exportID, data.page)
end


function CodeDOMMainUI.OpenGUIUI(data)
    dump(data, "----CodeDOMMainUI---")
    local parent = GUI:Win_Create(data.GUI_ID, 0, 0, 0, 0, data.hideMain, data.hideLast, data.needVoice, data.escClose, data.isRevmsg, data.npcID, data.orderParam)
    GUI:LoadExportVar(parent, data.exportID, data)
    local showFunc = showUIs[data.showType]
    if showFunc then
        showFunc(parent)
    end
end

function CodeDOMMainUI.UpdateGUIUI(data)
    GUI:UpdateExportVar(data.parent, data.exportID, data)
end