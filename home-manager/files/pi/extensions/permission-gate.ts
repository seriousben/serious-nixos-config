// Adapted from: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/permission-gate.ts
/**
 * Permission Gate Extension
 *
 * Prompts for confirmation before running:
 * - sudo commands
 * - chmod/chown 777
 * - Any write/edit outside ~/src/
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { resolve } from "node:path";
import { homedir } from "node:os";

const SAFE_ROOT = resolve(homedir(), "src");

const dangerousPatterns = [/\bsudo\b/i, /\b(chmod|chown)\b.*777/i];

function isDangerousBash(command: string): boolean {
	return dangerousPatterns.some((p) => p.test(command));
}

function isOutsideSafeRoot(path: string, cwd: string): boolean {
	const resolved = resolve(cwd, path);
	return !resolved.startsWith(SAFE_ROOT + "/") && resolved !== SAFE_ROOT;
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		// Block dangerous bash commands
		if (event.toolName === "bash") {
			const command = event.input.command as string;
			if (isDangerousBash(command)) {
				if (!ctx.hasUI) {
					return { block: true, reason: "Dangerous command blocked (no UI for confirmation)" };
				}
				const choice = await ctx.ui.select(`⚠️ Dangerous command:\n\n  ${command}\n\nAllow?`, ["Yes", "No"]);
				if (choice !== "Yes") {
					return { block: true, reason: "Blocked by user" };
				}
			}
		}

		// Block write/edit outside ~/src/
		if (event.toolName === "write" || event.toolName === "edit") {
			const path = event.input.path as string;
			if (isOutsideSafeRoot(path, ctx.cwd)) {
				if (!ctx.hasUI) {
					return { block: true, reason: `Write outside ~/src/ blocked: ${path}` };
				}
				const choice = await ctx.ui.select(`⚠️ Write outside ~/src/:\n\n  ${path}\n\nAllow?`, ["Yes", "No"]);
				if (choice !== "Yes") {
					return { block: true, reason: "Blocked by user" };
				}
			}
		}

		return undefined;
	});
}
