{ ... }:
{
  group = "guest";
  isNormalUser = true;
  home = "/home/guest";
  extraGroups = [
    "audio"
    "video"
    "systemd-journal"
    "pulse"
  ];
  # hashedPassword = "$6$y2j3S1Viel/.P/j4$2OJ.Aoq/JDidLKsxtNJ4Z5XDlwT626d5iUljOTtq3m8HVYHeBhxQje/zN0XBOjonKsJHU.LSx0MCXPM2fAdnq.";
  password = "guest";
}
