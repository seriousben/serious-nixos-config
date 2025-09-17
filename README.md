# serious-nixos-config

## Usage

### Update dependencies
```
nix flake update
```

### Apply changes
```
darwin-rebuild switch --flake
```

### Manual changes

- `touch ~/.hushlogin`: disable last login message on shell start

## Roadmap

- ✅ Use flakes instead of niv for everything
- Split large darwin/default.nix system defaults into logical modules
- Optimize fish shell path management with nix-darwin built-ins

## References
- https://nix-community.github.io/home-manager/options.xhtml
- https://daiderd.com/nix-darwin/manual/index.html
- https://direnv.net/man/direnv-stdlib.1.html

## Inspiration
- https://github.com/mitchellh/nixos-config
- https://github.com/cullenmcdermott/nix-config
- https://github.com/MatthiasBenaets/nix-config
- https://github.com/tscolari/nixfiles
