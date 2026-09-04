{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    browser = lib.getExe pkgs.chromium;
    openforti = "${pkgs.openfortivpn}/bin/openfortivpn";

    forticlient = pkgs.writeTextFile {
      name = "forticlient";
      executable = true;
      destination = "/bin/forticlient";
      text = ''
        #!/usr/bin/env bash
        
        if pgrep -f "openfortivpn.*jcforticlient.juniata.edu" > /dev/null; then
            pkill -f "openfortivpn.*jcforticlient.juniata.edu"
            echo "Stopped existing forticlient/openfortivpn instance."
            exit 0
        fi

        sudo DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" \
          ${openforti} jcforticlient.juniata.edu:36443 --saml-login 2>&1 | while IFS= read -r line; do
            echo "openfortivpn: $line"

            if [[ "$line" == *https* ]]; then
                TARGET_URL=$(echo "$line" | sed -n "s/.*'\(https:\/\/[^']*\)'.*/\1/p")
                
                if [ -n "$TARGET_URL" ]; then
                    echo "Launching browser for authentication..."
                    ${browser} "$TARGET_URL" &
                fi
            fi
        done
      '';
    };
  in {
    packages.forticlient = forticlient;
  };
}
