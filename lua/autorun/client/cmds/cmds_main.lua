
Term.Commands = {} -- commands table

-- include files --
local files = file.Find( "autorun/cmds/*", "LUA" )
for k, v in pairs( files ) do
	if( v != "cmds_main.lua" ) then
		include( v ) 
		AddCSLuaFile( v )
		Msg( "Included " .. v .. "!\n" )
	end 
end

if CLIENT then
	for k, v in pairs( files ) do
		if( v != "cmds_main.lua" ) then
			include( v ) 
			Msg( "Included " .. v .. "!\n" )
		end 
	end
end

function Term.addCommand( name, func, min_params, help ) -- insert commands into the table along with help text and minimal parameters, if provided
	Term.Commands[ name ] = {
		func = func
	}

	if( help ) then
		Term.Commands[ name ].help = help
	end

	if( min_params ) then
		Term.Commands[ name ].min = min_params
	end

	Msg( "Added command " .. name .. "\n" )
end

function Term.handleCommands( params ) -- handle the commands
	local cmd = Term.Commands[ params[1] ] -- localize the command

	if( !cmd ) then Term.alert( "Invalid command " .. params[1] .. "!" ) return false end -- check if the command exists
	if( cmd.min && #params - 1 < cmd.min ) then Term.alert( "Too little parameters provided for command " .. params[1] .. "!" ) return false end -- if minimum parameters provided, check if that requirement is met. -1 to remove the command itself

	if( ( params[2] == "-h" or params[2] == "-help" ) and cmd.help ) then -- if the first parameter to the command is -h or -help, print the help
		textarea:SetValue( textarea:GetValue() .. "\n" .. cmd.help )
	else -- block the command from being called if -h or -help is found
		cmd.func( params ) -- call the command's function
	end
end