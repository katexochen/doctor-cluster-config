let
  extraGroups = [ "wheel" "docker" "input" ];
in {
  # Please use a uid in the range between 4000-5000
  # You can set `users.users.<name>.allowedHosts` to restrict access to certain machines.
  users.users = {

    gergonemeth = {
      isNormalUser = true;
      home = "/home/gergonemeth";
      shell = "/run/current-system/sw/bin/bash";
      uid = 4008;
      inherit extraGroups;
      allowedHosts = [
        "ryan"
      ];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxgj1VQLrGGVRVwk4wEw3t13Yx0BuslofrZYqGYEngd gergonemeth"];
      expires = "2026-08-01";
    };

    btbferret1 = {
      isNormalUser = true;
      home = "/home/btbferret1";
      shell = "/run/current-system/sw/bin/bash";
      uid = 4009;
      inherit extraGroups;
      allowedHosts = [
        "jamie"
      ];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJg3dQSL7NXMBTWxOYvoecR65Qo/TCpC1e5Pd8VlB5T btbferret1"];
      expires = "2026-09-01";
    };

    btbferret2 = {
      isNormalUser = true;
      home = "/home/btbferret2";
      shell = "/run/current-system/sw/bin/bash";
      uid = 4010;
      inherit extraGroups;
      allowedHosts = [
        "jamie"
      ];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGfmK0t9PXFJ+NhSQ4r0biriq7f+694olUQrl4sVb7Qy btbferret2"];
      expires = "2026-09-01";
    };
};

  # DANGER ZONE!
  # Make sure all data is backed up before adding user names here. This will
  # delete all data of the associated user
  users.deletedUsers = [
    "risotto"
    "sppRev1"
    "sppRev2"
    "sppRev3"
    "atcRev1"
    "atcRev2"
    "atcRev3"
    "cgo25Rev"
    "cgoPixel8"
    "conextRev1"
    "conextRev2"
    "conextRev3"
    "fastRev1"
    "fastRev2"
    "fastRev4"
    "fastRev5"
    "nsdiRev1"
    "nsdiRev2"
    "nsdiRev3"
    "nsdiRev4"
    "vcxlgenRev1"
    "vcxlgenRev2"
    "vcxlgenRev3"
    "aranciniRev1"
    "aranciniRev2"
    "ushellRev1"
    "ushellRev2"
    "ushellRev3"
    "ushell_test"
    "proteus1"
    "proteus2"
    "proteus3"
    "proteus4"
    "proteus_test"
    "proteus5"
    "proteus6"
    "proteus7"
  ];
}
