(* Direction de déplacement de la tête de lecture sur la bande (vers la gauche ou vers la droite) *)
type action = Left | Right

(* Transition: le caractère lu, le nouvel état, le caractère à écrire et l'action de déplacement *)
type transition = {
	read: char;
	to_state: string;
	write: char;
	action: action;
}

(* Machine de Turing complète (états, alphabet, transitions, etc.) *)
type turing_machine = {
	name: string;
	alphabet: string list;
	blank: string;
	states: string list;
	initial: string;
	finals: string list;
	transitions: (string, transition list) Hashtbl.t;
}