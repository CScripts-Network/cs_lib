fx_version 'cerulean'
games {'gta5'}
lua54 "yes"

author 'CScripts Network'
description 'CScripts Network Library'
version '0.0.9'

ui_page 'html/html.html'

client_scripts {
	'config.lua',
	'client/**.lua',
	'client/modules/**.lua'
}

server_scripts {
	'config.lua',
	'server/**.lua',
	'server/modules/**.lua'
}

exports {
	'GetLib'
}

server_exports {
	'GetLib'
}

files {
    'html/html.html',
    'html/css.css',
    'html/SignikaNegative-Regular.ttf',
}