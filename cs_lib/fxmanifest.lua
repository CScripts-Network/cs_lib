fx_version 'cerulean'
games {'gta5'}
lua54 "yes"

author 'CScripts Network'
description 'CScripts Network Library'
version '0.0.6'

client_scripts {
	'config.lua',
	'client/**.lua'
}

server_scripts {
	'config.lua',
	'server/**.lua'
}

exports {
	'GetLib'
}

server_exports {
	'GetLib'
}
