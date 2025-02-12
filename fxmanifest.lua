fx_version('cerulean')
games({ 'gta5' })
author 'discord: @ehhas'
description 'ehh-pccheck'
version '1.0.0'


shared_script{
    'config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
};

server_scripts({
    'server/server.lua',
    'config_server.lua'
});

client_scripts({
    'client/client.lua'
});

ui_page 'dist/index.html'

files {
    'dist/index.html',
    'dist/style.css',
    'dist/script.js',
}

lua54 'yes'