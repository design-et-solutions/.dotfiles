{ lib, ... }:
{
  security.pam.services.login = {
    startSession = true;
    allowNullPassword = lib.mkForce false;
    forwardXAuth = false;
  };
}
