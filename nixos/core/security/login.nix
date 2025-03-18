{ ... }:
{
  security.pam.services.login = {
    startSession = true;
    allowNullPassword = false;
    forwardXAuth = false;
  };
}
