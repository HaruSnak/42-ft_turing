<img src="readme/ft_turing.png" alt="ft_turing" width="900"/>

<div align="center">

# ft_turing
### The origin of programming - Functional implementation of a Turing machine

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

</div>

---

## 🇬🇧 English

<details>
<summary><b>📖 Click to expand/collapse English version</b></summary>

### 📖 About
**ft_turing** is a 42 School project entirely focused on the functional programming paradigm and the theoretical foundations of computer science. The objective is to construct a program capable of simulating a single-tape, single-headed Turing machine from a machine description provided in JSON.

The program reads a `jsonfile` detailing states, alphabet, initial state, final states, and transition rules, alongside an initial `input` to put on an infinite tape. It then steps through the machine's instructions until it halts (or loops forever), showcasing the evolution of the tape visually. 

This project must be built respecting the functional paradigm (no imperative loops, heavy use of iterators like map, fold, iter, and immutability). Written in OCaml, it highlights how simple rules can theoretically compute any computable algorithm.

### 🧠 Skills Learned
By completing the ft_turing project, students master:
- **Functional Programming**: Abstracting problems using only immutable states and pure functions (OCaml).
- **Automata Theory**: Deep understanding of Alan Turing's theoretical model of computing, states, and transition rules.
- **Parsing & Validation**: Safely deserializing JSON data to strong, statically-typed OCaml structures while catching edge cases.
- **Algorithm Complexity**: Analyzing and tracking time and space complexity dynamically through execution state analysis (Bonus).

## ⚙️ How It Works (Execution & Infinite Tape)
When initialized, the Turing machine engine loads the starting `input` onto an internally represented **infinite tape**. Initially, the read/write head points to the very first character of the input.
1. **Reading**: The machine reads the character directly beneath its head.
2. **Infinite Expansion**: If the head moves past the rightmost or leftmost character of the current tape, the tape automatically expands dynamically by inserting the `blank` character predefined in the JSON.
3. **Transition Matching**: Based on the `current_state` and the `read_character`, the internal engine looks up the exact transition rule in the dictionary.
4. **Applying Rule**: The machine overwrites the old character with the new `write` character, updates its internal `current_state` to the new `to_state`, and moves its head either `LEFT` or `RIGHT`.
5. **Halting & Errors**: This loop iterates recursively until the new `to_state` matches one of the values in the `finals` array. If no transition exists for a specific (State, Character) combination, the machine enters a blocked error state safely.

## 📄 JSON Architecture Definition
The machine heavily relies on a well-structured JSON schema containing the following fields:
- `name`: A string defining the machine's name.
- `alphabet`: An array of length-1 strings representing all valid characters allowed on the tape (e.g., `["0", "1", "."]`).
- `blank`: A specific character from the alphabet used to denote empty/uninitialized cells (e.g., `"."`).
- `states`: An exhaustive array of all possible state names the machine can enter.
- `initial`: The starting state of the machine (must exist in `states`).
- `finals`: An array of states that represent successful halting points for computation.
- `transitions`: A dictionary of rules grouped by state name. Each rule contains:
  - `read`: The target character triggering the rule.
  - `to_state`: The state the machine will transition into.
  - `write`: The character written on the tape before moving.
  - `action`: The movement of the head (`"LEFT"` or `"RIGHT"`).

### **Features**
**JSON Machine Loading:** *Parses Turing machine logic strictly defining alphabet, states, transitions.*<br>
**Live Tape Visualization:** *Displays the tape contents and clearly highlights the reader head using brackets `< >` at each tick.*<br>
**Robust Error Handling:** *Catches ill-formatted JSON, invalid input characters, and halt/block states gracefully without crashing.*<br>
**Complexity Tracking (Bonus):** *Computes algorithmic time complexity `O(n)` during computation by counting the exact number of transitions required until halt.*<br>

### 🤖 Machines Included (Algorithms details)
According to the subject matter, the project embeds specific Turing machines handling diverse logic operations:

1. **`unary_sub.json`** (Unary Subtraction):
   - **Algorithm:** The head reads the first unary block (e.g., `111`), passes the minus sign `-`, passes the second unary block (e.g., `11`), and finds the equals sign `=`. It turns back left, erases one `1`, skips the `-`, erases one `1` from the first block, and repeats this ping-pong.
   - **Output:** Halts leaving `1` (which equals 111 - 11 = 1).
   
2. **`unary_add.json`** (Unary Addition): 
   - **Algorithm:** Travels right reading the first unary block, replacing the addition sign `+` with a `1`. It continues to the end of the second unary block, moves left by one cell, and replaces the trailing `1` with a `blank`.
   - **Output:** The tape cleanly displays the merged contiguous `1`s.

3. **`palindrome.json`** (Palindrome Detector): 
   - **Algorithm:** Reads the outermost left character, remembers it (by jumping to a character-specific state) and replaces it with a blank. The head rushes to the far right, matching and wiping the character. It travels back to the leftmost remaining character and repeats.
   - **Output:** If it empties the string without mismatch, it writes `y` (yes) at the end. Otherwise `n` (no).

4. **`0n1n.json`** (Language $0^n1^n$): 
   - **Algorithm:** Starts from the left, replaces a `0` with a blank (or marker), rushes right passing other `0`s to find the first `1` and replaces it. It returns to the start and repeats.
   - **Output:** Writes `y` if all `0`s perfectly wipe out all `1`s (e.g., `000111`), or `n` if an imbalance or syntax error (e.g., `0101`) occurs.

5. **`02n.json`** (Language $0^{2n}$): 
   - **Algorithm:** Sweeps across the zeroes crossing off every alternating `0` (modulo 2 logic). Once it reaches the end, it returns to the start and sweeps again, halving the amount of zeroes. If during any sweep it only finds an odd number of zeroes (except exactly 1 zero left), it fails.
   - **Output:** Writes `y` if the zero count was exactly a power of 2, otherwise writes `n`.

### 📋 Table of Contents
- [About](#about)
- [How It Works](#how-it-works-execution--infinite-tape)
- [Algorithms Details](#machines-included-algorithms-details)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Credits](#credits)

<a name="installation"></a>
### 🚀 Installation
```bash
# Clone the repository
git clone https://github.com/HaruSnak/42-ft_turing
cd 42-ft_turing

# Build the project (will detect and install dependencies via opam if needed)
make
```

<a name="usage"></a>
### 💻 Usage
```bash
usage: ./ft_turing [-h] jsonfile input

positional arguments:
  jsonfile      json description of the machine
  input         input of the machine

optional arguments:
  -h, --help    show this help message and exit

# Example
./ft_turing files/unary_sub.json "111-11="
```

<a name="project-structure"></a>
### 📂 Project Structure
```text
42-ft_turing/
├── Makefile                    # Standard Makefile to build bytecodes and native
├── ft_turing.opam              # OPAM dependencies package
├── bin/                        # Executable entry points for the terminal
├── lib/                        # Core logic (Types, JSON Parser, Machine Engine)
├── files/                      # JSON descriptions of the machines
│   ├── unary_add.json
│   ├── palindrome.json
│   ├── 0n1n.json
│   ├── 02n.json
│   └── unary_sub.json
├── test/                       # Unit test suite for validation
└── README.md                   # This file
```

<a name="credits"></a>
### 📖 Credits
- **Turing Machines**: [Wikipedia - Turing Machine](https://en.wikipedia.org/wiki/Turing_machine)
- **OCaml Documentation**: [OCaml.org](https://ocaml.org/)
- **Les Machines de Turing - ScienceEtonnante** : [Youtube](https://www.youtube.com/watch?v=o_swEgbBhMU)

### 📄 License
This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

</details>

---

## 🇫🇷 Français

<details>
<summary><b>📖 Cliquez pour développer/réduire la version française</b></summary>

### 📖 À propos
**ft_turing** est un projet de l'école 42 entièrement centré sur le paradigme de la programmation fonctionnelle et les fondations théoriques de l'informatique. L'objectif est de construire un programme capable de simuler une machine de Turing à une seule tête et un ruban infini à partir d'une description JSON.

Le programme lit un fichier `jsonfile` détaillant les états, l'alphabet, l'état initial, les états finaux et les règles de transition, ainsi qu'une chaîne `input` initiale à placer sur le ruban. Il exécute ensuite les instructions étape par étape jusqu'à un état d'arrêt, en affichant l'évolution du ruban de manière visuelle.

Ce projet doit être réalisé en respectant le paradigme fonctionnel (pas de boucles impératives, forte utilisation d'itérateurs comme map, fold, iter et d'états immuables). Écrit en OCaml, il démontre comment un ensemble de règles simples peut théoriquement exécuter n'importe quel algorithme calculable.

### 🧠 Compétences acquises
En complétant ft_turing, les étudiants maîtrisent :
- **Programmation Fonctionnelle** : Abstraction de problèmes en n'utilisant que des états immuables et des fonctions pures (OCaml).
- **Théorie des Automates** : Compréhension du modèle informatique d'Alan Turing, des états de calcul et des règles de transition.
- **Parsing et Validation** : Désérialisation sûre des données JSON vers des structures de données OCaml typées statiquement, avec gestion des cas d'erreur.
- **Complexité Algorithmique** : Suivi des complexités temporelles et spatiales durant l'exécution (Bonus).

## ⚙️ Fonctionnement (Exécution & Ruban Infini)
Lors de l'initialisation, le moteur de la machine de Turing charge la chaine `input` de départ sur un **ruban infini**. Initialement, la tête de lecture/écriture pointe sur le tout premier caractère de l'entrée.
1. **Lecture** : La machine lit le caractère situé directement sous sa tête.
2. **Expansion Infinie** : Si la tête dépasse le caractère le plus à droite ou le plus à gauche du ruban actuel, le ruban s'étend dynamiquement en insérant le caractère `blank` défini dans le JSON.
3. **Recherche de Transition** : En fonction du `current_state` (état actuel) et du `read_character` (caractère lu), le moteur recherche la règle de transition exacte dans le dictionnaire.
4. **Application de la Règle** : La machine remplace l'ancien caractère par le nouveau caractère `write`, met à jour son `current_state` interne par le nouveau `to_state`, et déplace sa tête vers la `LEFT` (gauche) ou la `RIGHT` (droite).
5. **Arrêt et Erreurs** : Cette boucle opère de façon récursive jusqu'à ce que le nouveau `to_state` figure dans le tableau `finals`. Si aucune transition n'existe pour une combinaison (État, Caractère) spécifique, la machine passe proprement en état d'erreur de blocage.

## 📄 Définition de l'Architecture JSON
La machine s'appuie massivement sur un schéma JSON bien structuré contenant les champs suivants :
- `name` : Une chaine définissant le nom de la machine.
- `alphabet` : Un tableau représentant tous les caractères autorisés sur le ruban (taille 1).
- `blank` : Un caractère spécifique de l'alphabet utilisé pour désigner les cellules vides (ex. `"."`).
- `states` : Un tableau exhaustif de tous les noms d'états possibles.
- `initial` : L'état de départ de la machine (doit exister dans `states`).
- `finals` : Un tableau d'états représentant les points d'arrêt de fin de calcul.
- `transitions` : Un dictionnaire de règles regroupées par nom d'état. Chaque règle contient :
  - `read` : Le caractère cible déclenchant la règle.
  - `to_state` : Le nouvel état de la machine.
  - `write` : Le caractère à écrire sur la bande avant de se déplacer.
  - `action` : Le mouvement de la tête (`"LEFT"` ou `"RIGHT"`).

### **Fonctionnalités**
**Chargement JSON :** *Analyse de la logique de la machine en définissant strictement alphabet, états, transitions.*<br>
**Visualisation du Ruban :** *Affiche le contenu du ruban en mettant la tête de lecture en évidence via des chevrons `< >` à chaque étape.*<br>
**Gestion d'Erreurs Robuste :** *Intercepte les erreurs JSON, entrées invalides ou machines bloquées avec élégance.*<br>
**Suivi de Complexité (Bonus) :** *Calcule la complexité algorithmique `O(n)` lors du fonctionnement en comptant le nombre exact de transitions exécutées jusqu'à l'arrêt.*<br>

### 🤖 Machines Intégrées (Détails des algorithmes)
Le sujet de ce projet exige la conception de machines de Turing capables de réaliser des opérations logiques précises :

1. **`unary_sub.json`** (Soustraction unaire) :
   - **Algorithme :** La tête lit le premier bloc unaire (ex. `111`), passe le signe `-`, passe le second bloc unaire (ex. `11`), et trouve le signe `=`. Elle retourne à gauche, efface un `1`, passe le `-`, efface un `1` du premier bloc, et répète cet aller-retour.
   - **Sortie :** S'arrête en laissant `1` (car 111 - 11 = 1).

2. **`unary_add.json`** (Addition unaire) :
   - **Algorithme :** Voyage vers la droite en lisant le premier bloc unaire, remplace le signe `+` par un `1`. Continue jusqu'à la fin du second bloc, recule d'une case et remplace le dernier `1` par un espace (blank).
   - **Sortie :** Le ruban affiche proprement les `1` fusionnés.

3. **`palindrome.json`** (Détecteur de palindrome) :
   - **Algorithme :** Lit le caractère le plus à gauche, le mémorise (en sautant vers un état spécifique au caractère) et le remplace par un blanc. La tête file vers l'extrême droite pour vérifier et effacer le caractère symétrique. Elle revient au prochain caractère de gauche et recommence.
   - **Sortie :** Si la chaîne est vidée sans erreur, inscrit `y` (oui) à la fin. Sinon `n` (non).

4. **`0n1n.json`** (Langage $0^n1^n$) :
   - **Algorithme :** Commence par la gauche, remplace un `0` par un blanc (ou marqueur), fonce vers la droite en ignorant les autres `0` pour trouver le premier `1` et le remplace. Revient au début et répète.
   - **Sortie :** Écrit `y` si tous les `0` annulent parfaitement tous les `1` (ex. `000111`), ou `n` si un déséquilibre survient.

5. **`02n.json`** (Langage $0^{2n}$) :
   - **Algorithme :** Balaie les zéros de gauche à droite en barrant un `0` sur deux (logique modulo 2). Arrivé à la fin, retourne au début et relance un balayage, divisant ainsi la quantité de zéros par deux à chaque passage. Si lors d'un passage il trouve un nombre impair de zéros (sauf s'il n'en reste qu'un), il échoue.
   - **Sortie :** Écrit `y` si le nombre de zéros était bien une puissance de 2, sinon écrit `n`.

### 📋 Table des matières
- [À propos](#-propos-1)
- [Fonctionnement](#-fonctionnement-excution--ruban-infini)
- [Détails des algorithmes](#machines-intgres-dtails-des-algorithmes)
- [Installation](#installation-1)
- [Utilisation](#utilisation-1)
- [Structure du projet](#structure-du-projet-1)
- [Crédits](#crdits-1)

<a name="installation-1"></a>
### 🚀 Installation
```bash
# Cloner le dépôt
git clone https://github.com/HaruSnak/42-ft_turing
cd 42-ft_turing

# Compiler le projet (détectera et installera les dépendances OPAM si nécessaire)
make
```

<a name="utilisation-1"></a>
### 💻 Utilisation
```bash
usage: ./ft_turing [-h] jsonfile input

positional arguments:
  jsonfile      json description of the machine
  input         input of the machine

optional arguments:
  -h, --help    show this help message and exit

# Exemple
./ft_turing files/unary_sub.json "111-11="
```

<a name="structure-du-projet-1"></a>
### 📂 Structure du projet
```text
42-ft_turing/
├── Makefile                    # Fichier Makefile pour compiler (bytecode & natif)
├── ft_turing.opam              # Paquet OPAM déclarant les dépendances
├── bin/                        # Points d'entrée exécutables CLI
├── lib/                        # Logique cœur (Types, Parsing JSON, Moteur Turing)
├── files/                      # Descriptions JSON des différentes machines
│   ├── unary_add.json
│   ├── palindrome.json
│   ├── 0n1n.json
│   ├── 02n.json
│   └── unary_sub.json
├── test/                       # Suite de tests unitaires pour le CI
└── README.md                   # Ce fichier
```

<a name="crdits-1"></a>
### 📖 Crédits
- **Machines de Turing** : [Wikipédia - Machine de Turing](https://fr.wikipedia.org/wiki/Machine_de_Turing)
- **Documentation OCaml** : [OCaml.org](https://ocaml.org/)
- **Les Machines de Turing - ScienceEtonnante** : [Youtube](https://www.youtube.com/watch?v=o_swEgbBhMU)

### 📄 Licence
Ce projet est sous licence **MIT** - voir le fichier [LICENSE](LICENSE) pour plus de détails.

</details>

---

[contributors-shield]: https://img.shields.io/github/contributors/HaruSnak/42-ft_turing.svg?style=for-the-badge
[contributors-url]: https://github.com/HaruSnak/42-ft_turing/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/HaruSnak/42-ft_turing.svg?style=for-the-badge
[forks-url]: https://github.com/HaruSnak/42-ft_turing/network/members
[stars-shield]: https://img.shields.io/github/stars/HaruSnak/42-ft_turing.svg?style=for-the-badge
[stars-url]: https://github.com/HaruSnak/42-ft_turing/stargazers
[issues-shield]: https://img.shields.io/github/issues/HaruSnak/42-ft_turing.svg?style=for-the-badge
[issues-url]: https://github.com/HaruSnak/42-ft_turing/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/shany-moreno-5a863b2aa
[license-shield]: https://img.shields.io/github/license/HaruSnak/42-ft_turing.svg?style=for-the-badge
[license-url]: https://github.com/HaruSnak/42-ft_turing/blob/master/LICENSE
