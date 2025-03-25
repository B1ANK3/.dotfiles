# https://discourse.nixos.org/t/how-do-i-apply-an-custom-theme-to-sddm/29281/14
# https://github.com/Keyitdev/sddm-astronaut-theme/tree/master
{
  stdenv,
  fetchFromGitHub,
}: {
  sddm-astronaut-theme = stdenv.mkDerivation rec {
    pname = "sddm-astronaut-theme";
    version = "5e39e08";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-theme-dialog
    '';
    src = fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "5e39e0841d4942757079779b4f0087f921288af6";
      sha256 = "sha256-bqMnJs59vWkksJCm+NOJWgsuT4ABSyIZwnABC3JLcSc=";
    };
  };
}
