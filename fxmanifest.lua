fx_version 'cerulean'
games {'gta5'}
lua54 "yes"

author 'CScripts Network'
description 'CScripts Network Lib (Bridge)'
version '0.1.3'

ui_page 'html/html.html'

--shared_scripts {
--	'@ox_lib/init.lua'
--}

client_scripts {
	'config.lua',
	'client/**.lua',
	'client/modules/**.lua'
}

server_scripts {
	'config.lua',
	'server/**.lua',
	--'server/modules/**.lua'
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
