PlayDice = {}
PlayDice._diceEffectID  = 4094
PlayDice._diceSize      = {width = 40, height = 60}
PlayDice._path          = "res/private/play_dice/"

function PlayDice.main(data)
    local parent = GUI:Attach_Parent()
    GUI:LoadExport(parent, "npc/play_dice") 
    
    PlayDice._ui        = GUI:ui_delegate(parent)
    PlayDice._parent    = parent
    PlayDice._data      = data
    local act           = PlayDice._data.callback
    local items         = PlayDice._data.arr
    local count         = PlayDice._data.count
    local diceSize      = PlayDice._diceSize
    local fixCount      = count < 3 and 3 or 6
    local imgHei        = GUI:getContentSize(PlayDice._ui.Image_1).height
    GUI:setContentSize(PlayDice._ui.Image_1, diceSize.width * fixCount + 40, imgHei)
    GUI:setContentSize(PlayDice._ui.Panel_dice, diceSize.width * count, diceSize.height)

    for key, value in ipairs(items) do
        if key > count then
            break
        end
        if value > 0 then
            local layout = GUI:Layout_Create(PlayDice._ui.Panel_dice, "layout_" .. key, (key - 1) * diceSize.width, 0, diceSize.width, diceSize.height)
            local sfx = GUI:Effect_Create(layout, "sfx", diceSize.width / 2, diceSize.height / 2, 0, PlayDice._diceEffectID)

            SL:scheduleOnce(layout, function()
                GUI:removeAllChildren(layout)
                local diceImg = GUI:Image_Create(layout, "dice_show", diceSize.width / 2, diceSize.height / 2, string.format(PlayDice._path .. "%04d.png", value - 1))
                GUI:setAnchorPoint(diceImg, 0.5, 0.5)
            end, 1.5 + math.random(0, 5) / 10)
        end
    end

    -- 
    SL:scheduleOnce(PlayDice._parent, function()
        SL:ClosePlayDice()
    end, 4)

end

