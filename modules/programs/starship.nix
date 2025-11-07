{...}: {
  catppuccin.starship = {
    enable = true;
    flavor = "mocha";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;
    settings = {
      format = "$all";
      command_timeout = 1500;
      aws.disabled = true;
      azure.disabled = true;
      gcloud.disabled = true;
      docker_context.disabled = true;
      openstack.disabled = true;
    };
  };
}
