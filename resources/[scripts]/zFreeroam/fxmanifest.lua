fx_version 'adamant'
games { 'gta5' }
dependency 'essentialmode'
this_is_a_map 'yes'

client_scripts {
  "lib/common.lua",
	"lib/observers/*.lua",
	"RageUI/RMenu.lua",
  "RageUI/menu/RageUI.lua",
  "RageUI/menu/Menu.lua",
  "RageUI/menu/MenuController.lua",
  "RageUI/components/*.lua",
  "RageUI/menu/elements/*.lua",
  "RageUI/menu/items/*.lua",
  "RageUI/menu/panels/*.lua",
  "RageUI/menu/windows/*.lua",
	'@zFramework/locale.lua',
	"client/*.lua",
	'config.lua',
	'locales/fr.lua',
	'cl_skin.lua',
	'death.lua',
	'cl_skinchanger.lua',
	"gtav/*.lua",
	"gta_online/*.lua",
	"dlc_high_life/*.lua",
	"dlc_heists/*.lua",
	"dlc_executive/*.lua",
	"dlc_finance/*.lua",
	"dlc_bikers/*.lua",
	"dlc_import/*.lua",
	"dlc_gunrunning/*.lua",
	"dlc_smuggler/*.lua",
	"dlc_doomsday/*.lua",
	"dlc_afterhours/*.lua",
}

server_scripts {
	'@zFramework/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/fr.lua',
	'config.lua',
	"server/*.lua",
	'sv_skin.lua',
}

files {
    'index.html',
    'ui.html',
    'style.css',
    'bg/*.png',
    'sound/zfreeroam.ogg'
}

loadscreen 'index.html'

ui_page 'ui.html'

client_scripts {
	'client.lua'
}