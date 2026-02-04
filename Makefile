.PHONY: apply
apply:
	sudo $$(which darwin-rebuild) switch --impure --flake .#seriousben-mbp

.PHONY: update
update: update-pi-extensions
	nix flake update

.PHONY: update-pi-extensions
update-pi-extensions:
	@echo "Updating Pi extensions..."
	@# mitsuhiko/agent-stuff
	@echo "// Source: https://github.com/mitsuhiko/agent-stuff/blob/main/pi-extensions/answer.ts" > home-manager/files/pi/extensions/answer.ts
	@curl -s "https://raw.githubusercontent.com/mitsuhiko/agent-stuff/main/pi-extensions/answer.ts" >> home-manager/files/pi/extensions/answer.ts
	@echo "// Source: https://github.com/mitsuhiko/agent-stuff/blob/main/pi-extensions/review.ts" > home-manager/files/pi/extensions/review.ts
	@curl -s "https://raw.githubusercontent.com/mitsuhiko/agent-stuff/main/pi-extensions/review.ts" >> home-manager/files/pi/extensions/review.ts
	@echo "// Source: https://github.com/mitsuhiko/agent-stuff/blob/main/pi-extensions/notify.ts" > home-manager/files/pi/extensions/notify.ts
	@curl -s "https://raw.githubusercontent.com/mitsuhiko/agent-stuff/main/pi-extensions/notify.ts" >> home-manager/files/pi/extensions/notify.ts
	@# tmustier/pi-extensions
	@echo "// Source: https://github.com/tmustier/pi-extensions/blob/main/tab-status/tab-status.ts" > home-manager/files/pi/extensions/tab-status.ts
	@curl -s "https://raw.githubusercontent.com/tmustier/pi-extensions/main/tab-status/tab-status.ts" >> home-manager/files/pi/extensions/tab-status.ts
	@echo "// Source: https://github.com/tmustier/pi-extensions/blob/main/raw-paste/index.ts" > home-manager/files/pi/extensions/raw-paste.ts
	@curl -s "https://raw.githubusercontent.com/tmustier/pi-extensions/main/raw-paste/index.ts" >> home-manager/files/pi/extensions/raw-paste.ts
	@# badlogic/pi-mono (official examples)
	@echo "// Source: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/handoff.ts" > home-manager/files/pi/extensions/handoff.ts
	@curl -s "https://raw.githubusercontent.com/badlogic/pi-mono/main/packages/coding-agent/examples/extensions/handoff.ts" >> home-manager/files/pi/extensions/handoff.ts
	@echo "// Source: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/permission-gate.ts" > home-manager/files/pi/extensions/permission-gate.ts
	@curl -s "https://raw.githubusercontent.com/badlogic/pi-mono/main/packages/coding-agent/examples/extensions/permission-gate.ts" >> home-manager/files/pi/extensions/permission-gate.ts
	@echo "// Source: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/protected-paths.ts" > home-manager/files/pi/extensions/protected-paths.ts
	@curl -s "https://raw.githubusercontent.com/badlogic/pi-mono/main/packages/coding-agent/examples/extensions/protected-paths.ts" >> home-manager/files/pi/extensions/protected-paths.ts
	@echo "Pi extensions updated."
