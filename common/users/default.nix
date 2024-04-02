{pkgs, ...}: let
  sshKeys = {
    ereslibre = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDJz9rVLqUHt9ZFjep4RsN3B5xr9s6MtHSz4PbJHACj3bA3pP7UZwePzzDMofOZLhOIKzMJ+s9H0E28ruEN8xhAv9qPYN6DI15vvPoaMu4VbzyFOGAz4UXoMQpSkr3p9E8C3psJIMpgxOAGelp7PqODlCQS/6DVMqz3DqtkOJYPssAtivH1AfitA2NVPvI9bgswAhF0jArKJmnFPSy6DAc0G2q5DyVEZVfD943kOprd7GkVWdD9FpaHqjmLGd77RfHmmqrj9Tg5+ajYa+VrASJfTBkDJ/lZcFLH9DdfcUFcQzu2pzi/cX94e+FnTtog8TOGwCrWGDAZVPP5YEHmGU3QX0NQBl4vNprWe0oJaSjSzvIT2ZrixUhOWKTjW44To/+7UwIlCc4KWL/LJ+kbwWCpiOhhWqRs380cqUmuMRaq59uTIWCRImBTkqjTqBIxaj7060GV2ZWGzbYKhUsxPchx8KJVWyGxYoox+T/zQjF1KtwvnPVghIt4hiIifYCclxoeY1yAIU5T8LvZXaqBlSYPi715mJg7533IM6NhHMg09ANgkKt6fQmQUNtaYBpHfaIaKI68oSCJOFTiP3e1RYmKaz36GQPWqEBNKT5zaIYsSOMCyLhoecH6pF9Nqvust5iIpYgNSDlRh1qnOd1AUCimyJQiswsiEQTuCClbZHg152x33/6y8CZrpHRSzDh8cBApanvtQ5pmzD4IP9mZ3eGvWaSrVx6EtpYWkr4LSoPkh2dRWHdVu+a27TLVkl7V+2dE5WAIZzRsfpAfQB3JIVD5WmTVlbU1zgIIBSXr7SfGJo0bMQ59JptE9+ffoyGWk8fnbFww2re3QTphXau9Hy+88pUqvXkiYUxsSpHzXlpRAWbfR9wqCS3adKRaz+3vZYvJGP6d66ay9NRkTGeIKxEeYjdBSNues59UGsWiJVOaR9bxfvL5+F+WyIjv9a9yOJln9NXcADp32zUlAMY97+Kw0NRQeBnpX2fF6HjNLj+onlOt50EVNYGE3fS5CW8L9nSuIY4jAycQ8xF2GYG8lGgDfaCrGTVm0cFab6ytvLRFBaKFWqcIh2rYOgKV0p7qzoadQYH5hIH/V5LGt3yRgPdwqGHNd6662n5FKlio/omE1CUpAdedA1l+geMnaIdQpDG5ghjSb8jJnoUsPYVjTLQmg7g2HAnC2ofURbKAxEVfDDIuXmLp+plyb7DGGIhj6wprnoy7mDd/YJBzf9zmRjOz1mKhrgdbSHiDvfpbs0BW5HtodYHY7R6oEU8OtXYOR2bJfoqhspz5M/vmYBbzo5P7cbpBc5b6PW/xFnt2Sabuwrem0YTWh++eDmeDgSOK5F9k4NGQZriJYg5JqICqslht ereslibre@kde.org"
    ];
  };
in {
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.ereslibre = {
      isNormalUser = true;
      initialHashedPassword = "$6$M8PJiTY.2YaoUNLr$61IUEobA75b.vMbPLPxVkU4d6Rs5CuYB2KlQHX4B2Gr09Zx70Q99w3c1DyJoyt0AvXbNYS6Q7cNKdA35c3ZMU/";
      extraGroups = ["dialout" "wheel"];
      uid = 1000;
      openssh.authorizedKeys.keys = sshKeys.ereslibre;
    };
    users.root = {openssh.authorizedKeys.keys = sshKeys.ereslibre;};
  };
}
