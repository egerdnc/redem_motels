fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

server_script {"@mysql-async/lib/MySQL.lua"}
client_script {"@redm-rpc/lib.lua"}
server_script {"@redm-rpc/lib.lua"}
client_script {'client/cl_*.lua'}
server_script {'server/sv_*.lua'}