{
  pkgs,
  ...
}:

{
  env.GREET = "devenv";

  packages = with pkgs; [ 
    terraform
    terraform-docs
    #   pkgsStatic.stdenv.cc
  ];

  languages.rust = {
    enable = true;
    channel = "nightly";
    components = ["cargo" "rust-analyzer" "rust-src" "rustfmt" "rustc"];
    targets = [
      "x86_64-unknown-linux-musl"
    ];
  };
}
