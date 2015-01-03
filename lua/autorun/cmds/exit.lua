
-- Exit function
-- I admit it looked better inside the file, but this is to keep it modular
-- HumbleTH

function Term.exit()
	frame:Remove()
	Term.Text = ""
	Term.Path = ""
end

Term.addCommand( "exit", Term.exit, nil, "Clears the terminal and closes it." )