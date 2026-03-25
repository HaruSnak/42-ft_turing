open Types

(* Parcourt l'objet JSON des transitions pour en extraire et valider chaque action. On s'assure notamment que les caractères lus/écrits
	font partie de l'alphabet et empêche les doublons pour un même caractère afin de garantir le déterminisme de la machine *)
let parse_transitions list_transitions states alphabet: (string, transition list) Hashtbl.t =
	(* Transforme le string "LEFT" ou "RIGHT" en type action d'OCaml *)
	let parse_action = function
		| "LEFT" -> Left
		| "RIGHT" -> Right
		| _ -> failwith "Invalid action (must be 'LEFT' or 'RIGHT')"
	in

	let my_transitions = Hashtbl.create 17 in
	let open Yojson.Safe.Util in
	(try list_transitions |> to_assoc with _ -> failwith "The 'transitions' field must be an object") |> List.iter (fun(state, transitions) ->
		if not (List.mem state states) then
			failwith (Printf.sprintf "Transition state '%s' not found in declared states" state);
		let trans_list =
			(try transitions |> to_list with _ -> failwith (Printf.sprintf "Transitions for state '%s' must be a list" state)) |> List.map (fun t ->
					let read_str = try t |> member "read" |> to_string with _ -> failwith (Printf.sprintf "Missing or invalid 'read' field in transition of state '%s'" state) in
					if String.length read_str <> 1 then
						failwith "Read symbol must be exactly one character";
					let read = read_str.[0] in
					if not (List.mem read_str alphabet) then
						failwith (Printf.sprintf "Read symbol '%c' not found in alphabet" read);
					let to_state = try t |> member "to_state" |> to_string with _ -> failwith (Printf.sprintf "Missing or invalid 'to_state' field in transition of state '%s'" state) in
					if not (List.mem to_state states) then
						failwith (Printf.sprintf "To_state '%s' not found in declared states" to_state);
					let write_str = try t |> member "write" |> to_string with _ -> failwith (Printf.sprintf "Missing or invalid 'write' field in transition of state '%s'" state) in
					if String.length write_str <> 1 then
						failwith "Write symbol must be exactly one character";
					let write = write_str.[0] in
					if not (List.mem write_str alphabet) then
						failwith (Printf.sprintf "Write symbol '%c' not found in alphabet" write);
					let action = try t |> member "action" |> to_string |> parse_action with Failure m -> failwith m | _ -> failwith (Printf.sprintf "Missing or invalid 'action' field in transition of state '%s'" state) in
					{ read; to_state; write; action }
			)
		in
		(* Bloque les doublons de config pour le même caractère afin de garantir le déterminisme *)
		let rec check_duplicates seen = function
			| [] -> ()
			| h:: t ->
				if List.mem h.read seen then
					failwith (Printf.sprintf "Duplicate transition for read character '%c' in state '%s' (machine must be deterministic)" h.read state)
				else
					check_duplicates (h.read:: seen) t
		in
		check_duplicates [] trans_list;
		Hashtbl.add my_transitions state trans_list
	);
	my_transitions

(* Ouvre et lit le fichier JSON fourni. La fonction extrait chaque clé (alphabet, états finaux, caractère vide, etc.) et valide 
   la cohérence de ces informations pour garantir que la machine est fonctionnelle avant de la lancer *)
let parse_json filename: Types.turing_machine = 
	try
		let json = Yojson.Safe.from_file filename in
		let open Yojson.Safe.Util in

		(* Récupère la valeur d'un champ texte tout en gérant les erreurs de type s'il manque *)
		let get_string field =
			try json |> member field |> to_string 
			with _ -> failwith (Printf.sprintf "Missing or invalid '%s' field (expected string)" field)
		in
		(* Pareil, mais renvoie carrément une liste de strings *)
		let get_string_list field =
			try json |> member field |> to_list |> List.map to_string
			with _ -> failwith (Printf.sprintf "Missing or invalid '%s' field (expected list of strings)" field)
		in

		let name = get_string "name" in
		let alphabet = get_string_list "alphabet" in
		if not (List.for_all (fun s -> String.length s = 1) alphabet) then
			failwith "Alphabet characters must be strictly length 1";
		let blank = get_string "blank" in
		if not (List.mem blank alphabet) then
			failwith "Blank symbol not found in alphabet";
		let states = get_string_list "states" in
		let initial = get_string "initial" in
		if not (List.mem initial states) then
			failwith "Initial state not found in states";
		let finals = get_string_list "finals" in
		if not (List.for_all (fun f -> List.mem f states) finals) then
			failwith "Final state not found in states";
		let list_transitions = try json |> member "transitions" with _ -> failwith "Missing 'transitions' field" in
		let transitions = parse_transitions list_transitions states alphabet in
		{ name; alphabet; blank; states; initial; finals; transitions }
	with
	| Sys_error msg -> failwith ("File Error: " ^ msg)
	| Failure msg -> failwith msg
	| Yojson.Json_error msg -> failwith ("JSON Format Error: " ^ msg)
	| e -> failwith ("Unexpected parsing error: " ^ Printexc.to_string e)