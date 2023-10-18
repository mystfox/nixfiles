{
  pkgs,
  config,
  lib,
  ...
}: let
  # TODO: actually get this working, maybe? for one, menus were mostly broken, incl right clicks even in firefox
  # i can also see I need to fix headerbar_border_color there
  # for now this stays as a wip/testament to hopes
  # (i also poked at other approaches than this poor-man's "templating", but they didn't want to work or were harder)
  templateData = config.base16.defaultScheme.templateData;
  gtkCss = with templateData; ''
    @define-color accent_color #${base0A-hex};
    @define-color accent_bg_color #${base0A-hex};
    @define-color accent_fg_color #${base00-hex};
    @define-color destructive_color #${base08-hex};
    @define-color destructive_bg_color #${base08-hex};
    @define-color destructive_fg_color #${base00-hex};
    @define-color success_color #${base0B-hex};
    @define-color success_bg_color #${base0B-hex};
    @define-color success_fg_color #${base00-hex};
    @define-color warning_color #${base0E-hex};
    @define-color warning_bg_color #${base0E-hex};
    @define-color warning_fg_color #${base00-hex};
    @define-color error_color #${base08-hex};
    @define-color error_bg_color #${base08-hex};
    @define-color error_fg_color #${base00-hex};
    @define-color window_bg_color #${base00-hex};
    @define-color window_fg_color #${base05-hex};
    @define-color view_bg_color #${base00-hex};
    @define-color view_fg_color #${base05-hex};
    @define-color headerbar_bg_color #${base01-hex};
    @define-color headerbar_fg_color #${base05-hex};
    @define-color headerbar_border_color rgba({{base01-dec-r}}, {{base01-dec-g}}, {{base01-dec-b}}, 0.7);
    @define-color headerbar_backdrop_color @window_bg_color;
    @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
    @define-color card_bg_color #${base01-hex};
    @define-color card_fg_color #${base05-hex};
    @define-color card_shade_color rgba(0, 0, 0, 0.07);
    @define-color dialog_bg_color #${base01-hex};
    @define-color dialog_fg_color #${base05-hex};
    @define-color popover_bg_color #${base01-hex};
    @define-color popover_fg_color #${base05-hex};
    @define-color shade_color rgba(0, 0, 0, 0.07);
    @define-color scrollbar_outline_color #${base02-hex};
    @define-color blue_1 #${base0D-hex};
    @define-color blue_2 #${base0D-hex};
    @define-color blue_3 #${base0D-hex};
    @define-color blue_4 #${base0D-hex};
    @define-color blue_5 #${base0D-hex};
    @define-color green_1 #${base0B-hex};
    @define-color green_2 #${base0B-hex};
    @define-color green_3 #${base0B-hex};
    @define-color green_4 #${base0B-hex};
    @define-color green_5 #${base0B-hex};
    @define-color yellow_1 #${base0A-hex};
    @define-color yellow_2 #${base0A-hex};
    @define-color yellow_3 #${base0A-hex};
    @define-color yellow_4 #${base0A-hex};
    @define-color yellow_5 #${base0A-hex};
    @define-color orange_1 #${base09-hex};
    @define-color orange_2 #${base09-hex};
    @define-color orange_3 #${base09-hex};
    @define-color orange_4 #${base09-hex};
    @define-color orange_5 #${base09-hex};
    @define-color red_1 #${base08-hex};
    @define-color red_2 #${base08-hex};
    @define-color red_3 #${base08-hex};
    @define-color red_4 #${base08-hex};
    @define-color red_5 #${base08-hex};
    @define-color purple_1 #${base0E-hex};
    @define-color purple_2 #${base0E-hex};
    @define-color purple_3 #${base0E-hex};
    @define-color purple_4 #${base0E-hex};
    @define-color purple_5 #${base0E-hex};
    @define-color brown_1 #${base0F-hex};
    @define-color brown_2 #${base0F-hex};
    @define-color brown_3 #${base0F-hex};
    @define-color brown_4 #${base0F-hex};
    @define-color brown_5 #${base0F-hex};
    @define-color light_1 #${base01-hex};
    @define-color light_2 #${base01-hex};
    @define-color light_3 #${base01-hex};
    @define-color light_4 #${base01-hex};
    @define-color light_5 #${base01-hex};
    @define-color dark_1 #${base01-hex};
    @define-color dark_2 #${base01-hex};
    @define-color dark_3 #${base01-hex};
    @define-color dark_4 #${base01-hex};
    @define-color dark_5 #${base01-hex};
  '';
in {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-moon";
    };
    #gtk3.extraCss = gtkCss;
    #gtk4.extraCss = gtkCss;
  };
}