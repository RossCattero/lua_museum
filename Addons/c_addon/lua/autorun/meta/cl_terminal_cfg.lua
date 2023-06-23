hook.Add( "OnPlayerChat", "TerminalChat", function( ply, text, team, dead ) 
	print(TERMINAL:exec(text, {argument1, argument2}))
end )