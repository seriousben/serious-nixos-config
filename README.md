# serious-nixos-config

## Usage

### Update dependencies
```
nix flake update
niv update
```

### Apply changes
```
darwin-rebuild switch --flake
```

### Manual changes

- `touch ~/.hushlogin`: disable last login message on shell start

## Roadmap

- Use flakes instead of niv for everything

## References
- https://github.com/nmattia/niv
- https://nix-community.github.io/home-manager/options.xhtml
- https://daiderd.com/nix-darwin/manual/index.html
- https://direnv.net/man/direnv-stdlib.1.html

## Inspiration
- https://github.com/mitchellh/nixos-config
- https://github.com/cullenmcdermott/nix-config
- https://github.com/MatthiasBenaets/nix-config
- https://github.com/tscolari/nixfiles
