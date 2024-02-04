TradePlayerHeroStore = {}

function TradePlayerHeroStore.main()
    local parent  = GUI:Attach_Parent()
    local attachW = 348
    local attachH = 478
    TradePlayerHeroStore.attachW = attachW

    local _ResPath = "res/private/TradingBankLayer/"

    local PMainUI = GUI:Layout_Create(parent, "PMainUI", 0, 0, attachW, attachH, true)
    GUI:setTouchEnabled(PMainUI, true)

    local BG = GUI:Image_Create(PMainUI, "BG", 0, 0,  _ResPath.."bg_juese_02.png")

    local ListView = GUI:ListView_Create(PMainUI, "ListView", 5, 5, attachW - 10, attachH - 10, 1)
    TradePlayerHeroStore.ListView = ListView

    local ItemBg = GUI:Image_Create(PMainUI, "ItemBg", 0, 0, _ResPath.."bg_jiaoyh_04.png")
    GUI:setVisible(ItemBg, false)
    local scale = (attachW - 10) / GUI:getContentSize(ItemBg).width
    GUI:setContentSize(ItemBg, {width = attachW - 10, height = GUI:getContentSize(ItemBg).height * scale})
end