
(* Gère les erreurs basiques de ligne de commande, 
   affiche le menu d'aide (-h / --help) si demandé, puis enchaîne logiquement le parsing du JSON et le démarrage de la machine *)
let main () =
	let nb_argv = Array.length Sys.argv in
	if nb_argv >= 2 && (Sys.argv.(1) = "--help" || Sys.argv.(1) = "-h") then
		print_endline "usage: ft_turing [-h] jsonfile input\n\n\
positional arguments:\n  \
jsonfile				json description of the machine\n  \
input						input of the machine\n\n\
optional arguments:\n  \
-h, --help					show this help message and exit"
	else if nb_argv = 3 && Filename.check_suffix Sys.argv.(1) ".json" then
		try
			let machine = Parse.parse_json Sys.argv.(1) in
			Machine.start machine Sys.argv.(2)
		with
		| Failure msg -> print_endline ("Error: " ^ msg)
		| Sys_error msg -> print_endline ("Error: " ^ msg)
		| _ -> print_endline "Error: An unexpected error occurred"
	else
		print_endline "usage: ft_turing [-h] jsonfile input"

let () = main()
	