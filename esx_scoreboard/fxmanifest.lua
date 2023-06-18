shared_script "@esx_menu_deafult/shared/shared.lua"


fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'github.com/tekkenkkk'
description 'FiveM Scoreboard made for RichRP (Private Rework)'

client_scripts {
    'client/functions.lua',
    'client/main.lua',
    'client/lib.lua'
}

server_scripts {
    'server/functions.lua',
    'server/main.lua'
}

files {
    'html/assets/*.*',
    'html/index.html'
}

server_exports {
    'CounterPlayers',
	'MisiaczekPlayers',
}

ui_page 'html/index.html'

