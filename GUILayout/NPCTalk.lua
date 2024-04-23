NPCTalk = {}

function NPCTalk.main()
    local parent = GUI:Attach_Parent()

    local screenW = SL:GetScreenWidth()
    local screenH = SL:GetScreenHeight()

    local NPCBG = GUI:Image_Create(parent, "NPCBG", 0, screenH, "res/public/bg_npc_01.png")
    GUI:setAnchorPoint(NPCBG, {x=0, y=1})
    GUI:setTouchEnabled(NPCBG, true)
    
    local CloseButton = GUI:Button_Create(parent, "CloseButton", 546, screenH, "res/public/1900000510.png")
    GUI:setAnchorPoint(CloseButton, {x=0, y=1})
    GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
    GUI:setTouchEnabled(CloseButton, true)
    GUI:addOnClickEvent(CloseButton, function()
        GUI:Win_Close(parent)
    end)

    local TalkLayout = GUI:Layout_Create(NPCBG, "TalkLayout", 20, 20, 500, 140)
end