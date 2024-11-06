{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      format = "$all";
      # palette = "catppuccin_mocha";
      command_timeout = 1500;
      aws.disabled = true;
      azure.disabled = true;
      gcloud.disabled = true;
      docker_context.disabled = true;
      openstack.disabled = true;
    };
  };
}
