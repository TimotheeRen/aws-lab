
{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    terraform
    terraform-docs
    zig
    gcc
    binutils
    lld
    clang
    gnumake
    coreutils
    findutils
    bash
    pkg-config
    openssl
    zlib
    musl
    cargo-lambda
  ];

  languages.rust = {
    enable = true;
    channel = "nightly";

    components = [
      "cargo"
      "rust-analyzer"
      "rust-src"
      "rustfmt"
      "rustc"
      "clippy"
    ];

    targets = [
      "x86_64-unknown-linux-musl"
      "x86_64-unknown-linux-gnu"
    ];
  };
}
