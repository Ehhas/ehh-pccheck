Config = {}

Config.AdminPermisions = {
    'group.admin',
}

Config.IsTimmed = true
Config.TimeToJoinForPcCheck = 900 -- this is 15 minutes (if Config.IsAutoBan = true and Config.IsAutoBanWithTime = true put a time period in which you can do a pc check in)
Config.IsAutoBan = true -- if this is true then if the player runs out of time or leaves when the pc check is not done yet he will get instantly banned by your sellected type in Config.BanType
Config.IsAutoBanWithTime = true -- If you don't want for the player to get banned when the time runs out check this to false
Config.BanType = 'fg' -- examples: 'fg' (fiveguard), 'electron' (electronAC), 'EA' (EasyAdmin), wx (wx anticheat)
Config.AnticheatName = "fiveguard" -- Write you anticheat file name if your using fiveguard

Config.DiscordInvite = 'https://discord.gg/XXXXXXXX'
