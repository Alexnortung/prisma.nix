{ pkgs, ... }: {
  mkPrismaShell =
    { shellHookPre ? ""
    , shellHookPost ? ""
    , buildInputs ? [ ]
    , prisma-engines ? pkgs.prisma-engines
    , ...
    } @ attrs:
    pkgs.mkShell (attrs // {
      buildInputs = with pkgs;
        [
          nodePackages.prisma
        ]
        ++ buildInputs;
      shellHook =
        let
          engines = prisma-engines;
        in
        shellHookPre
          + ''
          export PRISMA_MIGRATION_ENGINE_BINARY="${engines}/bin/migration-engine"
          export PRISMA_QUERY_ENGINE_BINARY="${engines}/bin/query-engine"
          export PRISMA_QUERY_ENGINE_LIBRARY="${engines}/lib/libquery_engine.node"
          export PRISMA_INTROSPECTION_ENGINE_BINARY="${engines}/bin/introspection-engine"
          export PRISMA_FMT_BINARY="${engines}/bin/prisma-fmt"
        ''
          + shellHookPost;
    });
}
