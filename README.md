## Motivation

Trying to use prisma on NixOS does not seem to work when following the official tutorial. You will be met by an error saying that the precompiled binaries is not compiled for NixOS.

A Solution to this problem has already been made in [pimeys/nix-prisma-example](https://github.com/pimeys/nix-prisma-example), but this adds some boilerplate to your `flake.nix` file.

This flake aims to reduce the boilerplate code needed to make a nice flake setup using prisma.

## Getting started

### Imperative

This can be good to use if you are just following the prisma getting started guide.

If you do not want to add a `flake.nix` to your project, you can use the devShell by itself. Simply run the following command

```
nix develop github:Alexnortung/prisma.nix
```

### Flake project (recommeneded)

In your `flake.nix` add the following

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    prisma = {
      url = "github:Alexnortung/prisma.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { prisma, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = prisma.devShell.${system}; # To use the default dev shell with prisma
    });
}
```

## Customizing shell

### Extending `mkShell`

Your nix project might use a specific version of node/npm/yarn etc. This can easily be added to the shell like a normal `mkShell`. Simply use the `lib.mkPrismaShell` function which "extends" the mkShell function.

```nix
# flake.nix
{
  ...
    devShell = prisma.lib.mkPrismaShell {
      buildInputs = with pkgs; [
        yarn
        nodejs-16_x
      ];
    };
  ...
}
```

#### Caveats

You cannot use the `shellHook` directly, but you can add stuff before or after the shell hook from the prisma shell with `shellHookPre` and `shellHookPost`. Example:

```nix
# flake.nix
{
  ...
    devShell = prisma.lib.mkPrismaShell {
      shellHookPre = ''
        echo "setting up prisma shell"
      '';
      shellHookPost = ''
        echo "ready to use prisma shell"
      '';
    };
  ...
}
```

### Customizing packages

The prisma engines and prisma package can easily be overwritten with your own specific versions. You can do this by using the `prismaEnginesPackage` and `prismaPackage`.

```nix
# flake.nix
{
  ...
    devShell = prisma.lib.mkPrismaShell {
      # defaults
      prismaEnginesPackage = pkgs.prisma-engines;
      prismaPackage = pkgs.nodePackages.prisma;
    };
  ...
}
```

## Tips and tricks

### direnv

For direnv users you can add a `.envrc` file to your project with the following content

```
use flake
```

## Inspired by

- [pimeys/nix-prisma-example](https://github.com/pimeys/nix-prisma-example)
