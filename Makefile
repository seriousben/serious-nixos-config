.PHONY: apply
apply:
	sudo $$(which darwin-rebuild) switch --flake .#seriousben-mbp

.PHONY: update
update:
	nix flake update

.PHONY: changelog
changelog:
	darwin-rebuild changelog --flake .
