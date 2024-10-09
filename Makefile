.PHONY: apply
apply:
	darwin-rebuild switch --flake .

.PHONY: update
update:
	nix flake update
	niv update

.PHONY: changelog
changelog:
	darwin-rebuild changelog --flake .
