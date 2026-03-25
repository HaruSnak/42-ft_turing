open Types

type tape = {
	left: char list;
	head: char;
	right: char list;
	blank: char;
}

(* Convertit explicitement une chaîne de caractères en liste de caractères *)
let string_to_char_list (s: string): char list =
	let rec aux idx acc =
		if idx < 0 then acc else aux (idx - 1) (s.[idx]:: acc)
	in
	aux (String.length s - 1) []

(* Initialise la bande de la machine de Turing avec l'input fourni ainsi qu'avec le caractère vide (blank) *)
let init_tape (input: string) (blank_str: string): tape =
	let blank_char = blank_str.[0] in
	let char_list = string_to_char_list input in
	match char_list with
	| [] -> { left = []; head = blank_char; right = []; blank = blank_char }
	| first_char:: rest_of_chars -> { left = []; head = first_char; right = rest_of_chars; blank = blank_char }

(* Vérifie que l'input est valide et que chacun de ses caractères appartient bien à l'alphabet de la machine *)
let check_input (input: string) (machine: turing_machine): unit =
	let char_list = string_to_char_list input in
	List.iter (fun current_char ->
		let char_as_str = String.make 1 current_char in
		if not (List.mem char_as_str machine.alphabet) then
			failwith (Printf.sprintf "Input character '%c' not in alphabet" current_char);
		if char_as_str = machine.blank then
			failwith "Blank character is not allowed in the input"
	) char_list

(* Déplace la tête de lecture de la bande d'une case vers la droite, et en rajoute une vide si c'est la fin de la bande *)
let move_right (current_tape: tape): tape =
	let new_left = current_tape.head:: current_tape.left in
	match current_tape.right with
	| [] -> { current_tape with left = new_left; head = current_tape.blank; right = [] }
	| next_char:: rest_right -> { current_tape with left = new_left; head = next_char; right = rest_right }

(* Déplace la tête de lecture de la bande d'une case vers la gauche, et en rajoute une vide si on dépasse le bord repéré *)
let move_left (current_tape: tape): tape =
	let new_right = current_tape.head:: current_tape.right in
	match current_tape.left with
	| [] -> { current_tape with left = []; head = current_tape.blank; right = new_right }
	| prev_char:: rest_left -> { current_tape with left = rest_left; head = prev_char; right = new_right }

(* Remplace la valeur de la case actuellement visée par la tête de lecture par le nouveau caractère passé en argument *)
let write_char (current_tape: tape) (new_char: char): tape =
	{ current_tape with head = new_char }

(* Affiche l'état actuel complet de la bande formatée avec la position de la tête de lecture marquée entre "<" et ">" *)
let print_tape tape =
	let left_str = tape.left |> List.rev |> List.map (String.make 1) |> String.concat "" in
	let right_str = tape.right |> List.map (String.make 1) |> String.concat "" in
	Printf.printf "[%s<%c>%s] " left_str tape.head right_str

(* Affiche l'en-tête étoilé résumant la configuration de la machine: 
   son nom centré, son alphabet, ses états et la liste complète de ses transitions mathématiques avant de lancer l'exécution de celle-ci *)
let print_machine_info machine =
	Printf.printf "********************************************************************************\n";
	Printf.printf "*                                                                              *\n";
	Printf.printf "*                                                                              *\n";
	let pad = 76 - String.length machine.name in
	let pad_left = pad / 2 in
	let pad_right = pad - pad_left in
	Printf.printf "*%s%s%s*\n" (String.make pad_left ' ') machine.name (String.make pad_right ' ');
	Printf.printf "*                                                                              *\n";
	Printf.printf "*                                                                              *\n";
	Printf.printf "********************************************************************************\n";
	Printf.printf "Alphabet: [ %s ]\n" (String.concat ", " machine.alphabet);
	Printf.printf "States: [ %s ]\n" (String.concat ", " machine.states);
	Printf.printf "Initial: %s\n" machine.initial;
	Printf.printf "Finals: [ %s ]\n" (String.concat ", " machine.finals);
	Hashtbl.iter (fun state trans_list ->
		List.iter (fun (t: Types.transition) ->
		Printf.printf "(%s, %c) -> (%s, %c, %s)\n" state t.read t.to_state t.write (match t.action with Left -> "LEFT" | Right -> "RIGHT")
		) trans_list
	) machine.transitions;
	Printf.printf "********************************************************************************\n"

(* Fonction récursive qui lit le caractère sous la tête, cherche la transition correspondante dans la hash map, applique les écritures et déplacements 
   nécessaires (gauche/droite) puis s'appelle elle-même avec le nouvel état jusqu'à atteindre un état final ou bloquant *)
let rec run machine state tape =
	let transitions_for_state = Hashtbl.find_opt machine.transitions state in
	let current_char = tape.head in

	let transition_opt = match transitions_for_state with
		| None -> None
		| Some trans_list -> List.find_opt (fun t -> t.read = current_char) trans_list
	in

	match transition_opt with
	| None ->
		print_tape tape;
		if List.mem state machine.finals then (
			Printf.printf "\n";
			tape
		) else (
			Printf.printf "Machine blocked. No transition for character '%c' in state %s.\n" current_char state;
			tape
		)
	| Some t ->
		print_tape tape;
		Printf.printf "(%s, %c) -> (%s, %c, %s)\n" state tape.head t.to_state t.write (match t.action with Left -> "LEFT" | Right -> "RIGHT");
		let new_tape = write_char tape t.write in
		let new_tape = match t.action with
			| Left -> move_left new_tape
			| Right -> move_right new_tape
		in
		if List.mem t.to_state machine.finals then (
			new_tape
		) else (
			run machine t.to_state new_tape
		)

(* Fonction qui commence par vérifier que l'entrée utilisateur ne contient pas de caractères inconnus 
   ni de caractère vide, puis initialise la bande et lance la boucle de traitement. *)
let start machine input =
	print_machine_info machine;
	check_input input machine;
	let tape = init_tape input machine.blank in
	if List.mem machine.initial machine.finals then
		let _ = run machine machine.initial tape in ()
	else
		let _ = run machine machine.initial tape in ()
