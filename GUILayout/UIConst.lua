
UIConst = {}

UIConst.LUAFile = 
{
    LUA_FILE_HUD                                = "GUILayout/hud/ActorHud",                                                 -- hud

    LUA_FILE_MAIN_LEFTTOP                       = "GUILayout/main/MainLeftTop",                                             -- 主界面 左上
    LUA_FILE_MAIN_RIGHTTOP                      = "GUILayout/main/MainRightTop",                                            -- 主界面 右上
    LUA_FILE_MAIN_LEFTBOTTOM                    = "GUILayout/main/MainLeftBottom",                                          -- 主界面 左下
    LUA_FILE_MAIN_RIGHTBOTTOM                   = "GUILayout/main/MainRightBottom",                                         -- 主界面 右下
    LUA_FILE_MAIN_MINIMAP                       = "GUILayout/main/MainMiniMap",                                             -- 主界面 小地图
    LUA_FILE_MAIN_ASSIST                        = "GUILayout/main/MainAssist",                                              -- 主界面 导航栏
    LUA_FILE_MAIN_PROPERTY                      = "GUILayout/main/MainProperty",                                            -- 主界面 属性栏
    LUA_FILE_MAIN_SKILL                         = "GUILayout/main/MainSkill",                                               -- 主界面 技能/按钮
    LUA_FILE_MAIN_TARGET                        = "GUILayout/main/MainTarget",                                              -- 主界面 目标栏
    LUA_FILE_MAIN_TARGET_BELONG                 = "main/MainTargetBelong",                                                  -- 主界面 归属
    LUA_FILE_MAIN_TARGET_BIGHP                  = "GUILayout/main/MainTargetBigHp",                                         -- 主界面 大血条
    LUA_FILE_MAIN_TOP                           = "GUILayout/main/MainTop",                                                 -- 主界面 最上方
    LUA_FILE_MAIN_DIG                           = "GUILayout/main/MainDig",                                                 -- 主界面 尸体挖掘
    LUA_FILE_MAIN_SUMMONS                       = "GUILayout/main/MainSummons",                                             -- 主界面 召唤物
    LUA_FILE_MAIN_COLLECT                       = "GUILayout/main/MainCollect",                                             -- 主界面 采集怪

    LUA_FILE_MAIN_PROPERTY_WIN32                = "GUILayout/main/MainProperty_win32",                                      -- PC 主界面 属性栏
    LUA_FILE_MAIN_ASSIST_WIN32                  = "GUILayout/main/MainAssist_win32",                                        -- PC 导航栏
    LUA_FILE_MAIN_MINIMAP_WIN32                 = "GUILayout/main/MainMiniMap_win32",                                       -- PC 主界面小地图

    LUA_FILE_MAIN_NEAR                          = "main/MainNear",                                                          -- 附近列表展示
    LUA_FILE_MAIN_BUFFLIST                      = "GUILayout/main/MainBuffList",                                            -- 主界面BUFF列表（配置显示)

    LUA_FILE_MAIN_JOYSTICK                      = "GUILayout/main/MainJoyStick",                                            -- 摇杆
    
    LUA_FILE_SETTINGFRAME                       = "GUILayout/set/SettingFrame",                                             -- 设置 外框
    LUA_FILE_SETTING_BASIC                      = "GUILayout/set/SettingBasic",                                             -- 设置 基础
    LUA_FILE_SETTING_WINRANGE                   = "GUILayout/set/SettingWinRange",                                          -- 设置 视距
    LUA_FILE_SETTING_LAUNCH                     = "GUILayout/set/SettingLaunch",                                            -- 设置 战斗
    LUA_FILE_SETTING_PROTECT                    = "GUILayout/set/SettingProtect",                                           -- 设置 保护
    LUA_FILE_SETTING_PROTECTSET                 = "set/SettingProtectSetting",                                              -- 设置 保护相关设置
    LUA_FILE_SETTING_AUTO                       = "GUILayout/set/SettingAuto",                                              -- 设置 自动
    LUA_FILE_SETTING_SKILL_RANK                 = "set/SettingSkillRank",                                                   -- 设置 技能优先级
    LUA_FILE_SETTING_SKILL_PANEL                = "set/SettingSkillPanel",                                                  -- 设置 技能
    LUA_FILE_SETTING_PICK_SETTING               = "set/SettingPickSetting",                                                 -- 设置 拾取
    LUA_FILE_SETTING_PICK_SETTING_WIN32         = "set/SettingPickSetting_win32",                                           -- 设置 拾取
    LUA_FILE_SETTING_ADD_MONSTER_NAME           = "set/SettingAddMonsterName",                                              -- 设置 增加怪物name
    LUA_FILE_SETTING_ADD_MONSTER_TYPE           = "set/SettingAddMonsterType",                                              -- 设置 增加怪物type
    LUA_FILE_SETTING_BOSSTIPS                   = "set/SettingBossTips",                                                    -- 设置 增加boss提醒
    LUA_FILE_SETTING_PLAYER_NAME_COLOR          = "set/SettingPlayerNameColor",
    LUA_FILE_SETTING_HELP                       = "GUILayout/set/SettingHelp",                                              -- 设置 帮助
    LUA_FILE_SETTINGFRAME_WIN32                 = "GUILayout/set/SettingFrame_win32",                                       -- 设置 外框
    LUA_FILE_SETTING_BASIC_WIN32                = "GUILayout/set/SettingBasic_win32",                                       -- 设置 基础
    LUA_FILE_SETTING_LAUNCH_WIN32               = "GUILayout/set/SettingLaunch_win32",                                      -- 设置 战斗
    LUA_FILE_SETTING_PROTECT_WIN32              = "GUILayout/set/SettingProtect_win32",                                     -- 设置 保护
    LUA_FILE_SETTING_AUTO_WIN32                 = "GUILayout/set/SettingAuto_win32",                                        -- 设置 自动
    LUA_FILE_SETTING_HELP_WIN32                 = "GUILayout/set/SettingHelp_win32",                                        -- 设置 帮助

    LUA_FILE_PLAYER_FRAME                       = "player/PlayerFrame",                                                     -- 人物面板外框
    LUA_FILE_PLAYER_EQUIP                       = "player/PlayerEquip",                                                     -- 装备
    LUA_FILE_PLAYER_BASE_ATT                    = "player/PlayerBaseAtt",                                                   -- 基础属性
    LUA_FILE_PLAYER_EXTRA_ATT                   = "player/PlayerExtraAtt",                                                  -- 额外属性
    LUA_FILE_PLAYER_SKILL                       = "player/PlayerSkill",                                                     -- 技能
    LUA_FILE_PLAYER_SUPER_EQUIP                 = "player/PlayerSuperEquip",                                                -- 神装
    LUA_FILE_PLAYER_TITLE                       = "player/PlayerTitle",                                                     -- 称号
    LUA_FILE_PLAYER_BUFF                        = "player/PlayerBuff",                                                      -- BUFF
    
    LUA_FILE_SKILL_SETTING                      = "GUILayout/skill_setting/SkillSetting",                                   -- 技能设置
    LUA_FILE_SKILL_SETTING_WIN32                = "GUILayout/skill_setting/SkillSetting_win32",                             -- win32 技能设置

    LUA_FILE_PLAYER_BESTRING                    = "player/PlayerBestRing",                                                  -- 生肖
    LUA_FILE_PLAYER_LOOK_BESTRING               = "player_look/LookPlayerBestRing",                                         -- 查看他人生肖

    LUA_FILE_HERO_BESTRING                      = "hero/HeroBestRing",                                                      -- 生肖
    LUA_FILE_HERO_LOOK_BESTRING                 = "hero_look/LookHeroBestRing",                                             -- 查看英雄生肖

    LUA_FILE_PLAYER_INTERNAL_STATE              = "player_internal/PlayerInternalState",                                    -- 内功状态
    LUA_FILE_PLAYER_INTERNAL_SKILL              = "player_internal/PlayerInternalSkill",                                    -- 内功技能
    LUA_FILE_PLAYER_INTERNAL_MERIDIAN           = "player_internal/PlayerInternalMeridian",                                 -- 内功经络
    LUA_FILE_PLAYER_INTERNAL_COMBO              = "player_internal/PlayerInternalCombo",                                    -- 内功连击

    LUA_FILE_PLAYER_LOOK_FRAME                  = "player_look/LookPlayerFrame",                                            -- 查看他人人物面板外框
    LUA_FILE_PLAYER_LOOK_EQUIP                  = "player_look/LookPlayerEquip",                                            -- 查看他人装备
    LUA_FILE_PLAYER_LOOK_SUPER_EQUIP            = "player_look/LookPlayerSuperEquip",                                       -- 查看他人神装
    LUA_FILE_PLAYER_LOOK_TITLE                  = "player_look/LookPlayerTitle",                                            -- 查看他人称号 
    LUA_FILE_PLAYER_LOOK_BUFF                   = "player_look/LookPlayerBuff",                                             -- 查看他人Buff

    LUA_FILE_HERO_FRAME                         = "hero/HeroFrame",                                                         -- 英雄主界面
    LUA_FILE_HERO_EQUIP                         = "hero/HeroEquip",                                                         -- 装备
    LUA_FILE_HERO_BASE_ATT                      = "hero/HeroBaseAtt",                                                       -- 基础属性
    LUA_FILE_HERO_EXTRA_ATT                     = "hero/HeroExtraAtt",                                                      -- 额外属性
    LUA_FILE_HERO_SKILL                         = "hero/HeroSkill",                                                         -- 技能
    LUA_FILE_HERO_SUPER_EQUIP                   = "hero/HeroSuperEquip",                                                    -- 神装
    LUA_FILE_HERO_TITLE                         = "hero/HeroTitle",                                                         -- 称号

    LUA_FILE_HERO_LOOK_FRAME                    = "hero_look/LookHeroFrame",                                                -- 查看英雄人物面板外框
    LUA_FILE_HERO_LOOK_EQUIP                    = "hero_look/LookHeroEquip",                                                -- 查看英雄装备
    LUA_FILE_HERO_LOOK_SUPER_EQUIP              = "hero_look/LookHeroSuperEquip",                                           -- 查看英雄神装
    LUA_FILE_HERO_LOOK_TITLE                    = "hero_look/LookHeroTitle",                                                -- 查看英雄称号 

    LUA_FILE_HERO_INTERNAL_STATE                = "hero_internal/HeroInternalState",                                        -- 内功状态
    LUA_FILE_HERO_INTERNAL_SKILL                = "hero_internal/HeroInternalSkill",                                        -- 内功技能
    LUA_FILE_HERO_INTERNAL_MERIDIAN             = "hero_internal/HeroInternalMeridian",                                     -- 内功经络
    LUA_FILE_HERO_INTERNAL_COMBO                = "hero_internal/HeroInternalCombo",                                        -- 内功连击

    LUA_FILE_MERGE_PLAYER_MAIN                  = "merge_layer/MergePlayerFrame",                                           -- 个人-人物和英雄

    LUA_FILE_TITLE_TIPS                         = "GUILayout/TitleTips",                                                    -- 称号提示

    LUA_FILE_HERO_STATE                         = "hero_state/HeroState",                                                   -- 英雄状态
    LUA_FILE_HERO_STATE_SELECT                  = "hero_state/HeroStateSelect",                                             -- 英雄状态设置

    LUA_FILE_TRADE_PLAYER_FRAME                 = "player_tradingbank_look/PlayerHeroFrame_Look_TradingBank",     -- 交易行人物主界面
    LUA_FILE_TRADE_PLAYER_EQUIP                 = "player_tradingbank_look/PlayerEquip_Look_TradingBank",         -- 装备
    LUA_FILE_TRADE_PLAYER_BASE_ATT              = "player_tradingbank_look/PlayerBaseAtt_Look_TradingBank",       -- 基础属性
    LUA_FILE_TRADE_PLAYER_EXTRA_ATT             = "player_tradingbank_look/PlayerExtraAtt_Look_TradingBank",      -- 额外属性
    LUA_FILE_TRADE_PLAYER_SKILL                 = "player_tradingbank_look/PlayerSkill_Look_TradingBank",         -- 技能
    LUA_FILE_TRADE_PLAYER_SUPER_EQUIP           = "player_tradingbank_look/PlayerSuperEquip_Look_TradingBank",    -- 神装
    LUA_FILE_TRADE_PLAYER_TITLE                 = "player_tradingbank_look/PlayerTitle_Look_TradingBank",         -- 称号
    LUA_FILE_TRADE_PLAYER_BESTRING              = "player_tradingbank_look/PlayerBestRing_Look_TradingBank",      -- 生肖
    
    LUA_FILE_TRADE_HERO_EQUIP                   = "hero_tradingbank_look/HeroEquip_Look_TradingBank",             -- 装备
    LUA_FILE_TRADE_HERO_BASE_ATT                = "hero_tradingbank_look/HeroBaseAtt_Look_TradingBank",           -- 基础属性
    LUA_FILE_TRADE_HERO_EXTRA_ATT               = "hero_tradingbank_look/HeroExtraAtt_Look_TradingBank",          -- 额外属性
    LUA_FILE_TRADE_HERO_SKILL                   = "hero_tradingbank_look/HeroSkill_Look_TradingBank",             -- 技能
    LUA_FILE_TRADE_HERO_SUPER_EQUIP             = "hero_tradingbank_look/HeroSuperEquip_Look_TradingBank",        -- 神装
    LUA_FILE_TRADE_HERO_TITLE                   = "hero_tradingbank_look/HeroTitle_Look_TradingBank",             -- 称号
    LUA_FILE_TRADE_HERO_BESTRING                = "hero_tradingbank_look/HeroBestRing_Look_TradingBank",          -- 生肖


    LUA_FILE_NPC_TALK                           = "GUILayout/NPCTalk",                                                      -- NPC
    LUA_FILE_GAME_WORLD_CONFIRM                 = "GameWorldConfirm",                                                       -- 游戏世界确认公告

    LUA_FILE_GUILD_FRAME                        = "guild/GuildFrame",                                                       -- 行会 外框
    LUA_FILE_GUILD_MAIN                         = "guild/GuildMain",                                                        -- 行会主界面
    LUA_FILE_GUILD_LIST                         = "guild/GuildList",                                                        -- 行会列表
    LUA_FILE_GUILD_CHAT                         = "guild/GuildChat",                                                        -- 行会聊天
    LUA_FILE_GUILD_CREATE                       = "guild/GuildCreate",                                                      -- 行会创建
    LUA_FILE_GUILD_MEMBER                       = "guild/GuildMember",                                                      -- 行会成员
    LUA_FILE_GUILD_EDITTITLE                    = "guild/GuildEditTitle",                                                   -- 行会编辑
    LUA_FILE_GUILD_APPLY_LIST                   = "guild/GuildApplyList",                                                   -- 行会申请列表
    LUA_FILE_GUILD_ALLY_APPLY                   = "guild/GuildAllyApply",                                                   -- 行会结盟申请列表
    LUA_FILE_GUILD_WAR_ALLY                     = "guild/GuildWarAlly",                                                     -- 宣战、结盟结盟

    LUA_FILE_FUNC_DOCK                          = "func/FuncDock",                                                          -- 功能菜单
    
    LUA_FILE_SOCIAL_FRAME                       = "social/SocialFrame",                                                  -- 社交 外框
    LUA_FILE_MAIL                               = "social/mail/Mail",                                                    -- 邮件
    LUA_FILE_NEAR_PLAYER                        = "social/near_player/NearPlayer",                                       -- 附近
    LUA_FILE_TEAM                               = "social/team/Team",                                                    -- 组队
    LUA_FILE_FRIEND                             = "social/friend/Friend",                                                -- 好友
    LUA_FILE_RELATION                           = "social/relation/Relation",                                            -- 关系

    LUA_FILE_TEAM_APPLY                         = "social/team/TeamApply",                                               -- 组队申请
    LUA_FILE_TEAM_INVITE                        = "social/team/TeamInvite",                                              -- 组队邀请
    LUA_FILE_TEAM_BEINVITED_POP                 = "social/team/TeamBeInvitedPop",                                        -- 被邀请组队弹窗
    LUA_FILE_FRIEND_APPLY                       = "social/friend/FriendApply",                                           -- 好友申请
    LUA_FILE_FRIEND_ADD                         = "social/friend/FriendAdd",                                             -- 添加好友
    LUA_FILE_FRIEND_ADD_BLACKLIST               = "social/friend/FriendAddBlacklist",                                    -- 添加黑名单
    LUA_FILE_RELATION_INVITE                    = "social/relation/RelationInvite",                                      -- 

    LUA_FILE_LAYER_BAG                          = "player_bag/Bag",                                                         -- 个人背包
    LUA_FILE_HERO_BAG                           = "hero_bag/HeroBag",                                                       -- 英雄背包
    LUA_FILE_MERGE_BAG                          = "merge_layer/MergeBag",                                                   -- 个人、英雄背包合并
    LUA_FILE_NPC_STORAGE                        = "storage/Storage",                                                        -- 仓库

    LUA_FILE_NPC_STORE                          = "npc/NPCStore",                                                           -- npc商店
    LUA_FILE_MAKE_DRUG                          = "npc/NPCMakeDrug",                                                        -- 炼药
    LUA_FILE_SELL_REPAIRE                       = "npc/NPCSellRepaire",                                                     -- 出售或修理

    LUA_FILE_AUCTION_MAIN                       = "auction/AuctionMain",                                                    -- 拍卖行主界面
    LUA_FILE_AUCTION_WORLD                      = "auction/AuctionWorld",                                                   -- 世界拍卖、行会拍卖
    LUA_FILE_AUCTION_BIDDING                    = "auction/AuctionBidding",                                                 -- 我的竞拍
    LUA_FILE_AUCTION_PUT_LIST                   = "auction/AuctionPutList",                                                 -- 我的上架
    LUA_FILE_AUCTION_PUTIN                      = "auction/AuctionPutin",                                                   -- 上架道具
    LUA_FILE_AUCTION_TIMEOUT                    = "auction/AuctionTimeout",                                                 -- 超时
    LUA_FILE_AUCTION_PUTOUT                     = "auction/AuctionPutout",                                                  -- 下架道具
    LUA_FILE_AUCTION_BID                        = "auction/AuctionBid",                                                     -- 竞拍
    LUA_FILE_AUCTION_BUY                        = "auction/AuctionBuy",                                                     -- 购买

    LUA_FILE_STALL                              = "stall/Stall",                                                            -- 摆摊
    LUA_FILE_STALL_SET                          = "stall/StallSet",                   
    LUA_FILE_STALL_PUT                          = "stall/StallPut",        
    
    LUA_FILE_TRADE                              = "trade/Trade",                                                            -- 交易

    LUA_FILE_RANK                               = "rank/Rank",                                                              -- 排行榜                

    LUA_FILE_STORE_FRAME                        = "store/StoreFrame",                                                       -- 商城外框
    LUA_FILE_STORE_PAGE                         = "store/StorePage",                                                        -- 商城内容
    LUA_FILE_STORE_RECHARGE                     = "store/StoreRecharge",                                                    -- 商城充值
    LUA_FILE_STORE_DETAIL                       = "store/StoreDetail",                                                      -- 商城快捷购买
    LUA_FILE_RECHARGE_QRCODE                    = "store/RechargeQRCode",                                                   -- 充值二维码

    LUA_FILE_AUTO_USE_POP                       = "AutoUsePop",                                                             -- 自动使用

    LUA_FILE_COMMON_BUBBLE_INFO                 = "common/CommonBubbleInfo",                                                -- 被多人邀请组队、交易
    LUA_FILE_COMMON_TIPS_POP                    = "common/CommonTipsPop",                                                   -- 通用弹窗
    LUA_FILE_COMMON_DESC_TIPS                   = "common/CommonDescTips",                                                  -- 通用描述Tips
    LUA_FILE_COMMON_SELECT_LIST                 = "common/CommonSelectList",                                                -- 选择下拉栏
    LUA_FILE_COMMON_REDDOT                      = "common/RedDot",                                                          -- 红点

    LUA_FILE_ITEM_SPLIT_POP                     = "item/ItemSplitPop",                                                      -- 道具拆分弹窗

    LUA_FILE_TREASURE_BOX                       = "treasure_box/TreasureBox",                                               -- 宝箱道具
    LUA_FILE_GOLD_BOX                           = "treasure_box/GoldBox",                                                   -- 宝箱

    LUA_FILE_ITEM_TIPS                          = "item/ItemTips",                                                          -- 道具tips
    LUA_FILE_ITEM_TIPS_TXT                      = "item/ItemTips_txt",                                                      -- 道具tips  读配置

    LUA_FILE_ITEM_ICON_TIPS                     = "item/ItemIconTips",                                                      -- 道具Icon tips

    LUA_FILE_CHAT                               = "chat/Chat",                                                              -- 聊天
    LUA_FILE_CHAT_EXTEND                        = "chat/ChatExtend",                                                        -- 聊天拓展框
    LUA_FILE_PRIVATE_CHAT_WIN32                 = "chat/PrivateChat_win32",                                                 -- 私聊记录页
    
    LUA_FILE_NOTICE                             = "GUILayout/Notice",                                                       -- 系统类通知
    
    LUA_FILE_COMPOUND_ITEM                      = "compound/CompoundItem",                                                  -- 合成

    LUA_FILE_ITEM                               = "GUILayout/item/Item",                                                    -- 物品框
    LUA_FILE_COSTITEM                           = "GUILayout/item/CostItem",                                                -- 消耗物品组件

    LUA_FILE_REIN_ATTR                          = "reinattr/ReinAttr",                                                      -- 转生加点

    LUA_FILE_SET_WINSIZE_POP                    = "set/SetWinSizePop",                                                      -- 设置分辨率 

    
    LUA_FILE_MINIMAP                            = "main/MiniMap",                                                           -- 小地图
    LUA_FILE_MINIMAP_OTHER                      = "main/MiniMap_Other",                                                     -- 其他小地图 (非当前地图)

    LUA_FILE_UIMODEL                            = "GUILayout/UIModel",                                                      -- 内观模型
    LUA_FILE_BESTRONG_UP                        = "GUILayout/BeStrongUp",                                                   -- 变强按钮

    LUA_FILE_LOGIN_SERVER                       = "login/LoginServer",                                                      -- 登录服务器 开门动画
    LUA_FILE_LOGIN_ACCOUNT                      = "login/LoginAccount",                                                     -- 登录账号 
    LUA_FILE_LOGINROLE          		        = "login/LoginRolePanel",

    LUA_FILE_PROGRESS_BAR                       = "ProgressBar",                                                            -- 进度条 采集 
    LUA_FILE_PLAY_DICE                          = "PlayDice",                                                               -- 摇骰子

    LUA_FILE_UI_ROTATEVIEW                      = "GUILayout/UIRotateView",                                                 -- 控件 旋转容器

    LUA_FILE_PURCHASE_MAIN                      = "purchase/PurchaseMain",                                                  -- 求购- 主界面
    LUA_FILE_PURCHASE_WORLD                     = "purchase/PurchaseWorld",                                                 -- 世界求购
    LUA_FILE_PURCHASE_MY                        = "purchase/PurchaseMy",                                                    -- 我的求购
    LUA_FILE_PURCHASE_SELL                      = "purchase/PurchaseSell",                                                  -- 求购 - 出售界面
    LUA_FILE_PURCHASE_PUTIN                     = "purchase/PurchasePutIn",                                                 -- 求购 - 上架

    LUA_FILE_PC_SKILL_TO_MAINUI                 = "GUILayout/PCSkillToMainUITouch",                                         -- PC技能图标移到主界面上
    LUA_FILE_SIGHT_BEAD                         = "sight_bead/SightBead",                                                   -- 准星页面
    LUA_FILE_MOVE_EVENT                         = "moved_event/MoveEvent",                                                  -- 触摸事件
    LUA_FILE_RTOUCH_EVENT                       = "moved_event/RtouchEvent",

    LUA_FILE_GUIDE                              = "guide/Guide",                                                            -- 引导

    LUA_FILE_LOADING_BAR                        = "loading_bar/LoadingBar",

    LUA_FILE_ROLE_EFFECT                        = "GUILayout/RoleEffect",

    LUA_FILE_EXCHANGE_MAIN                      = "exchange/ExchangeMain",                                                  -- 交易所- 主界面
    LUA_FILE_EXCHANGE_BUY                       = "exchange/ExchangeBuy",                                                   -- 购买
    LUA_FILE_EXCHANGE_PUTLIST                   = "exchange/ExchangePutList",                                               -- 我的上架
    LUA_FILE_EXCHANGE_RECORD                    = "exchange/ExchangeRecord",                                                -- 我的记录
    LUA_FILE_EXCHANGE_PUTIN                     = "exchange/ExchangePutin",                                                 -- 上架道具
    LUA_FILE_EXCHANGE_PUTOUT                    = "exchange/ExchangePutout",                                                -- 下架道具
    LUA_FILE_EXCHANGE_BUYPANEL                  = "exchange/ExchangeBuyPanel",                                              -- 购买面板
}

UIConst.LAYERID = 
{
    MoveEventGUI                = "MoveEventGUI",                   -- 准星事件
    SightBeadGUI                = "SightBeadGUI",                   -- 准星
    RightTouchEventGUI          = "RightTouchEventGUI",
    MiniMapGUI                  = "MiniMapGUI",                     -- 小地图
    MiniMapOtherGUI             = "MiniMapOtherGUI",                -- 其他小地图 (非当前地图)
    GoldBoxGUI                  = "GoldBoxGUI",                     -- 宝箱打开页面
    TreasureBoxGUI              = "TreasureBoxGUI",                 -- 宝箱
    LoginRoleGUI                = "LoginRoleGUI",                   -- 登录 选角
    LoginServerGUI              = "LoginServerGUI",                 -- 登录账号 开门动画
    LoginAccountGUI             = "LoginAccountGUI",                -- 登录账号

    SettingFrameGUI             = "SettingFrameGUI",                -- 设置 外框
    SettingBossTipsGUI          = "SettingBossTipsGUI",             -- 设置 boss提醒
    SettingPickSetGUI           = "SettingPickSetGUI",              -- 拾取设置
    SettingProtectSetGUI        = "SettingProtectSetGUI",           -- 保护设置
    SettingAddMonsterNamesGUI   = "SettingAddMonsterNamesGUI",      -- 设置增加怪物名称
    SettingAddMonsterTypeGUI    = "SettingAddMonsterTypeGUI",       -- 设置增加怪物类型
    SettingSkillRankGUI         = "SettingSkillRankGUI",            -- 设置技能排序
    SettingSkillPanelGUI        = "SettingSkillPanelGUI",           -- 设置技能组件
    SettingPlayerNameColorGUI   = "SettingPlayerNameColorGUI",      -- 设置人物名字颜色
    
    NPCTalkGUI                  = "NPCTalkGUI",                     -- NPC 对话
    GameWorldConfirmGUI         = "GameWorldConfirmGUI",            -- 游戏世界确认公告

    GuildFrameGUI               = "GuildFrameGUI",                  -- 行会外框
    GuildCreateGUI              = "GuildCreateGUI",                 -- 行会创建
    GuildEditTitleGUI           = "GuildEditTitleGUI",              -- 行会编辑
    GuildApplyListGUI           = "GuildApplyListGUI",              -- 行会申请列表
    GuildAllyApplyGUI           = "GuildAllyApplyGUI",              -- 行会结盟申请列表
    GuildWarAllyGUI             = "GuildWarAllyGUI",                -- 宣战/结盟申请

    PlayerMainGUI               = "PlayerMainGUI",                  -- 人物主界面
    PlayerBestRingGUI           = "PlayerBestRingGUI",              -- 生肖
    SkillSettingGUI             = "SkillSettingGUI",                -- 人物技能设置

    HeroMainGUI                 = "HeroMainGUI",                    -- 英雄主界面
    HeroBestRingGUI             = "HeroBestRingGUI",                -- 生肖
    HeroStateGUI                = "HeroStateGUI",                   -- 英雄状态设置
    HeroStateSelectGUI          = "HeroStateSelectGUI",             -- 英雄状态设置

    LookPlayerMainGUI           = "LookPlayerMainGUI",              -- 查看他人主界面
    LookPlayerBestRingGUI       = "LookPlayerBestRingGUI",          -- 查看他人生肖

    LookHeroMainGUI             = "LookHeroMainGUI",                -- 查看他人英雄主界面
    LookHeroBestRingGUI         = "LookHeroBestRingGUI",            -- 查看他人英雄生肖

    MergePlayerMainGUI          = "MergePlayerMainGUI",             -- 个人-人物和英雄
    LookMergePlayerMainGUI      = "LookMergePlayerMainGUI",         -- 其他玩家-人物和英雄

    TradingBankFrame            = "TradingBankFrame",               -- 交易行主界面
    TradingBankBestRingGUI      = "TradingBankBestRingGUI",         -- 交易行查看他人生肖
    TradingBankHeroBestRingGUI  = "TradingBankHeroBestRingGUI",     -- 交易行查看他人英雄生肖

    SocialGUI                   = "SocialGUI",                      -- 社交 外框

    BagLayerGUI                 = "BagLayerGUI",                    -- 个人背包
    HeroBagLayerGUI             = "HeroBagLayerGUI",                -- 英雄背包
    MergeBagLayerGUI            = "MergeBagLayerGUI",               -- 个人、英雄背包合并
    NPCStorageGUI               = "NPCStorageGUI",                  -- 仓库
    
    NPCStoreGUI                 = "NPCStoreGUI",                    -- npc商店
    NPCMakeDrugGUI              = "NPCMakeDrugGUI",                 -- 炼药
    NPCSellOrRepaire            = "NPCSellOrRepaireGUI",            -- 出售或修理

    AuctionMainGUI              = "AuctionMainGUI",                 -- 拍卖行主界面
    AuctionPutinGUI             = "AuctionPutinGUI",                -- 上架道具
    AuctionTimeoutGUI           = "AuctionTimeoutGUI",              -- 超时
    AuctionPutoutGUI            = "AuctionPutoutGUI",               -- 下架道具
    AuctionBidGUI               = "AuctionBidGUI",                  -- 竞拍
    AuctionBuyGUI               = "AuctionBuyGUI",                  -- 购买

    StallLayerGUI               = "StallLayerGUI",                  -- 摆摊
    StallSetGUI                 = "StallSetGUI", 
    StallPutGUI                 = "StallPutGUI",

    TradeGUI                    = "TradeGUI",                       -- 交易

    RankGUI                     = "RankGUI",                        -- 排行榜

    StoreFrameGUI               = "StoreFrameGUI",                  -- 商城外框
    StoreBuyGUI                 = "StoreBuyGUI",                    -- 商城购买
    StoreDetailGUI              = "StoreDetailGUI",                 -- 快捷购买

    TeamApplyGUI                = "TeamApplyGUI",                   -- 组队申请
    TeamInviteGUI               = "TeamInviteGUI",                  -- 组队邀请
    TeamBeInvitedPopGUI         = "TeamBeInvitedPopGUI",            -- 被邀请组队弹窗
    
    FriendApplyGUI              = "FriendApplyGUI",                 -- 好友申请
    FriendAddGUI                = "FriendAddGUI",                   -- 添加好友
    FriendAddBlacklistGUI       = "FriendAddBlacklistGUI",          -- 添加黑名单

    MainNearGUI                 = "MainNearGUI",                    -- 附近列表展示

    CompoundItemGUI             = "CompoundItemGUI",                -- 合成

    ReinAttrGUI                 = "ReinAttrGUI",                    -- 转生加属性点

    RechargeQRCodeGUI           = "RechargeQRCodeGUI",              -- 充值二维码

    SetWinSizeGUI               = "SetWinSizeGUI",                  -- 设置分辨率
    
    ConfigSettingGUI            = "ConfigSettingGUI",               -- 配置表设置

    CommonTipsSplitGUI          = "CommonTipsSplitGUI",             -- 道具拆分弹窗
    CommonTipsGUI               = "CommonTipsGUI",                  -- 通用弹窗GUI
    ItemTipsGUI                 = "ItemTipsGUI",                    -- 道具Tips
    ItemIconTipsGUI             = "ItemIconTipsGUI",                -- 道具Icon Tips
    CommonBubbleInfoGUI         = "CommonBubbleInfoGUI",            -- 通用气泡弹窗
    CommonDescTipsGUI           = "CommonDescTipsGUI",              -- 通用描述弹窗
    CommonSelectListGUI         = "CommonSelectListGUI",            -- 选择下拉栏

    PurchaseMainGUI             = "PurchaseMainGUI",                -- 求购
    PurchaseSellGUI             = "PurchaseSellGUI",                -- 求购-出售
    PurchasePutInGUI            = "PurchasePutInGUI",               -- 求购-上架

    PCSkillToMainUIGUI          = "PCSkillToMainUIGUI",             -- PC技能图标移到主界面上

    TitleTipsGUI                = "TitleTipsGUI",                   -- 称号Tips

    ChatGUI                     = "ChatGUI",                        -- 聊天页
    ChatExtendGUI               = "ChatExtendGUI",                  -- 聊天拓展页
    PCPrivateChatGUI            = "PCPrivateChatGUI",               -- PC私聊记录 
    PlayDiceGUI                 = "PlayDiceGUI",                    -- 摇色子
    ProgressBarGUI              = "ProgressBarGUI",                 -- 进度条

    FuncDockGUI                 = "FuncDockGUI",                    -- 功能弹框

    AutoUsePopGUI               = "AutoUsePopGUI",                  -- 自动使用弹窗

    LoadingBarGUI               = "LoadingBarGUI",                  -- 加载条

    GuideGUI                    = "GuideGUI",                       -- 引导

    RelationInviteGUI           = "RelationInviteGUI",              -- 关系邀请页

    ExchangeMainGUI             = "ExchangeMainGUI",                -- 交易所
    ExchangePutinGUI            = "ExchangePutinGUI",               -- 上架道具
    ExchangePutoutGUI           = "ExchangePutoutGUI",              -- 下架道具
    ExchangeBuyPanelGUI         = "ExchangeBuyPanelGUI",            -- 购买
}

-- 禁止关闭界面
UIConst.ForbidCloseLayers = {
    [UIConst.LAYERID.MoveEventGUI]          = true,
    [UIConst.LAYERID.SightBeadGUI]          = true,
    [UIConst.LAYERID.RightTouchEventGUI]    = true,
    [UIConst.LAYERID.PCSkillToMainUIGUI]    = true,
}

UIConst.LayerTable = {
    TradingBankBuy          = 60,             -- 交易行购买
    TradingBankSell         = 61,             -- 交易行寄售
    TradingBankGoods        = 62,             -- 交易行货架
    TradingBankMe           = 63,             -- 交易行我的
    TradingBankSenkBuy      = 64,             -- 交易行求购

    PlayerEquip             = 101,            -- 装备
    PlayerBaseAtt           = 102,            -- 状态
    PlayerExtraAtt          = 103,            -- 属性
    PlayerSkill             = 104,            -- 技能
    PlayerTitle             = 105,            -- 称号
    PlayerSuperEquip        = 106,            -- 时装

    PlayerBestRing          = 111,            -- 极品首饰盒
    PlayerBuff              = 112,            -- BUFF

    Bag                     = 201,            -- 背包

    SettingBasic            = 300,            -- 基础设置
    SettingWindowRange      = 301,            -- 视距
    SettingFight            = 302,            -- 战斗
    SettingProtect          = 303,            -- 保护
    SettingAuto             = 304,            -- 挂机
    SettingHelp             = 305,            -- 帮助

    Mail                    = 401,            -- 邮件 
    Friend                  = 402,            -- 好友
    Team                    = 403,            -- 组队
    NearPlayer              = 404,            -- 附近玩家
    Relation                = 405,            -- 关系

    Rank                    = 501,            -- 排行榜

    Trade                   = 601,            -- 交易
    Stall                   = 602,            -- 摆摊界面

    InternalState           = 701,            -- 内功状态
    InternalSkill           = 702,            -- 内功技能
    InternalMeridian        = 703,            -- 内功经络
    InternalCombo           = 704,            -- 内功连击

    StoreHot                = 901,            -- 商城热销页签
    StoreBeauty             = 902,            -- 商城装饰页签
    StoreEngine             = 903,            -- 商城功能页签
    StoreFestival           = 904,            -- 商城节日页签
    StoreRecharge           = 905,            -- 充值

    GuildMain               = 1201,           -- 行会主界面
    GuildMember             = 1202,           -- 行会成员列表
    GuildList               = 1203,           -- 行会列表
    GuildApply              = 1204,           -- 行会申请
    GuildCreate             = 1205,           -- 行会创建
    GuildChat               = 1206,           -- 行会聊天记录

    SkillSetting            = 1401,           -- 技能设置

    Auction                 = 1901,           -- 拍卖行

    Compound                = 2201,           -- 合成
    Box996                  = 2202,           -- 996传奇盒子
}