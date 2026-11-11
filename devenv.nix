{
  pkgs,
  ...
}:

{
  env.GREET = "devenv";

  packages = with pkgs; [ 
    terraform
    terraform-docs
  ];

  languages.rust = {
    enable = true;
  };
}
