Config              = {}
Config.MarkerType   = 2
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 2.0, y = 4.0, z = 2.0}
Config.MarkerColor  = {r = 255, g = 140, b = 0}
Config.ShowBlips   = true

Config.RequiredCopsTest  = 0

Config.TimeToFarm    = 4.5 * 850
Config.TimeToProcess = 5.5 * 1500
Config.TimeToSell    = 0.5 * 350

-- Sprache

Config.Locale = 'de'

Config.Zones = {
	CatchKürbis =		{x = 3282.2,	y = 5185.1,	z = 18.5,	name = _U('kürbis_picking'),		sprite = 501,	color = 81},
	KürbisJuice =	{x = 2554.08,	y = 4668.02,	z = 34.02,	name = _U('turns_from_juice'),	sprite = 478,	color = 81},
	SellKürbisSaft =		{x = 311.29,	y = -203.33,	z = 54.22,	name = _U('sell_juice_kürbis_blip'),		sprite = 52,	color = 81}
}
