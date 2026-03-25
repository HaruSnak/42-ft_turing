NAME = ft_turing

all: $(NAME)

.opam_deps:
	@echo "Checking and installing yojson dependency..."
	@opam install yojson -y
	@touch .opam_deps

$(NAME): .opam_deps
	opam exec -- dune build
	@cp _build/default/bin/main.exe ./$(NAME)
	@echo "$(NAME) compiled successfully."

clean:
	opam exec -- dune clean

fclean: clean
	@rm -f $(NAME) main.exe .opam_deps

re: fclean all

.PHONY: all clean fclean re