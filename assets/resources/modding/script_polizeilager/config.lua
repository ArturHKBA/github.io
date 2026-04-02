Config = {}

-- Orte

Config.LagerPos = {
	Polizeilager = {
		Pos = {}
	}
}

Config.DiscordWebook = "Dayrise channel log Link"

-- Positionen der Schutzweste: 
-- Speichert sich nicht im Inventar buggy af!!

Config.SchutzwestePos = {
	PolizeiSchutzweste = {
		Pos = {
			{x = 450.01,  y = -998.14, z = 29.3},
			{x = 2515.2,  y = -342.0, z = 105.9}
		}
	}
}

-- Aufsätze

Config.AufsaetzeZ = {
	PolizeiAufsaetze = {
		Pos = {
			{x = 486.79,  y = -996.11, z = 32.4},
			{}
		}
	}
}

-- Lager:

Config.KeyToOpenLager = 38
Config.LagerMarker = 27
Config.LagerMarkerColor = { r = 50, g = 50, b = 204, a = 100 }
Config.LagerMarkerScale = { x = 1.0, y = 1.0, z = 1.0 }
Config.LagerDraw3DText = "Drücke ~g~[E]~s~ um ~y~ auf zuzugreifen~s~"

-- Schutzweste:

Config.KeyToOpenSchutzweste = 38
Config.SchutzwesteMarker = 27
Config.SchutzwesteMarkerColor = { r = 50, g = 50, b = 204, a = 100 }
Config.SchutzwesteMarkerScale = { x = 1.0, y = 1.0, z = 1.0 }
Config.SchutzwesteDraw3DText = "Drücke [E] um eine Schutzweste auszuwählen"

-- Aufsätze:

Config.KeyToOpenAufsätze = 38
Config.AufsaetzeMarker = 27
Config.AufsaetzeMarkerColor = { r = 50, g = 50, b = 204, a = 100 }
Config.AufsaetzeMarkerScale = { x = 1.0, y = 1.0, z = 1.0 }
Config.AufsaetzeDraw3DText = "Drücke ~g~ [E] um deine ~s~ Waffe ~y~ zu bearbeiten ~s~"

-- Menu Elemente:

Config.Lager = "Lager"
-- Server crash!!
Config.Lager2 = "Auswählen"
Config.Schutzweste1 = "LSPD Police Schutzweste [25%]"
Config.Schutzweste2 = "K-9 LSPD Schutzweste [50%]"
Config.Schutzweste3 = "Sheriff LSPD Schutzweste [75%]"
Config.Schutzweste4 = "LSPD Schutzweste [100%]"
Config.EntfernenSchutzweste = "Ausziehen"

-- Menu Title:

Config.LagerTitle = "Lager"
Config.Lager2Title = "Auswählen"
Config.Schutzweste1Title = "Deposit"
Config.Schutzweste2Title = "Schutzwesten"
Config.WaffenauswahlTitle = "Wähle eine Waffe aus"
Config.AufsaetzeTitle = "Zubehör"

-- Nachrichten (Default):

Config.KontaktiereVorgesetzten = "Du hast diese Waffe bereits freigegeben, kontaktiere einen Vorgesetzten"
Config.KeinPolizistOnline = "Es ist kein Polizist online"
Config.WaffeMussInDerHandSein = "Du musst die Waffe in der Hand halten"
Config.TaschenlampeAusgeruestet = "Du hast eine Taschenlampe für ~r~%s ~s~ ausgerüstet"
Config.TaschenlampeEntfernt = "Du hast die Taschenlampe von ~r~%s ~s~ entfernt"
Config.VisierAusgeruestet = "Du hast ein Visier für ~r~%s ~s~ ausgerüstet"
Config.VisierEntfernt = "Du hast das Visier von ~r~%s ~s~ entfernt"
Config.SchalldaempferAusgeruestet = "Du hast einen Schalldämpfer für ~r~%s ~s~ angebracht"
Config.SchalldaempferEntfernt = "Du hast den Schalldämpfer von ~r~%s ~s~ entfernt"

-- Fortschritt:

Config.Fortschritt1 = "Waffen werden abgenommen"
Config.Fortschritt2 = "Weste wird ausgezogen!"
Config.Fortschritt3 = "Weste wird angezogen!"

-- ProgressBar Timer, in seconds:

Config.RestockTimer = 5
Config.RemoveSchutzwesteTimer = 5
Config.anziehenSchutzwesteTimer = 5

-- Ped Variationen:

Config.VestVariation1 = { componentId = 9, drawableId = 18, textureId = 0, paletteId = 12 }
Config.VestVariation2 = { componentId = 9, drawableId = 11, textureId = 1, paletteId = 0 }
Config.VestVariation3 = { componentId = 9, drawableId = 6, textureId = 2, paletteId = 1 }
Config.VestVariation4 = { componentId = 9, drawableId = 1, textureId = 0, paletteId = 1 }

-- Jobs:

Config.Datanbank = 'polizei', 'police', 'fib', 'null', 'admin', 'testuser', 'dev', 'marshal', 'sheriff'

-- Job Grad:

Config.Grad = 4
-- COnfig.Grad = 3

-- Default Munition:

Config.AmmountOfAmmo = 150 

-- Waffen:

Config.WeaponsInArmory = {
	{ weaponHash = 'WEAPON_FLASHLIGHT', label = 'Taschenlampe', type = 'other', attachment = false, flashlight = nil, scope = nil, suppressor = nil},
	{ weaponHash = 'WEAPON_NIGHTSTICK', label = 'Schlagstock', type = 'other', attachment = false, flashlight = nil, scope = nil, suppressor = nil  },
	{ weaponHash = 'WEAPON_STUNGUN', label = 'Tasers', type = 'other', attachment = false, flashlight = nil, scope = nil, suppressor = nil  },
	{ weaponHash = 'WEAPON_COMBATPISTOL', label = 'Glock 17', type = 'pistol', attachment = true, flashlight = 0x359B7AAE, scope = nil, suppressor = 0xC304849A},
	{ weaponHash = 'WEAPON_SMG', label = 'MP5 9MM', type = 'smg', attachment = true, flashlight = 0x7BC4CDDC, scope = 0x3CC6BA57, suppressor = nil  },
	{ weaponHash = 'WEAPON_CARBINERIFLE', label = 'M4 Sturmgewehr', type = 'rifle', attachment = true, flashlight = 0x7BC4CDDC, scope = 0xA0D89C42, suppressor = 0x837445AA  },
	{ weaponHash = 'WEAPON_PUMPSHOTGUN', label = 'Schrotflinte', type = 'shotgun', attachment = true, flashlight = 0x7BC4CDDC, scope = nil, suppressor = nil  },
}
