{
  config,
  lib,
  pkgs,
  ...
}: {
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
    # TODO: qt4 kvantum removed, still in hm module 2023-09-15
    style.package = lib.mkForce (with pkgs; [libsForQt5.qtstyleplugin-kvantum qt6Packages.qtstyleplugin-kvantum]);
  };
  xdg.configFile = let
    inherit (config.base16.defaultScheme) templateData;
  in {
    #"Kvantum/kvantum.kvconfig".text = ''theme=foxgirl''; # TODO: finish the below? using KvArcDark for now
    "Kvantum/foxgirl/foxgirl.kvconfig".text = with templateData; ''
      [%General]
      author=celestefox
      comment=base16 glue and custom tweaks, nya!

      [GeneralColors]
      window.color=#${base00-hex}
      base.color=#${base01-hex}
      alt.base.color=#383838
      button.color=#494949
      light.color=#626262
      mid.light.color=#555555
      dark.color=#171717
      mid.color=#3C3C3C
      highlight.color=#737373
      inactive.highlight.color=#4A4A4A
      tooltip.base.color=black
      text.color=#${base05-hex}
      window.text.color=#${base05-hex}
      button.text.color=#${base05-hex}
      disabled.text.color=#A0A0A0
      tooltip.text.color=#${base05-hex}
      highlight.text.color=#${base05-hex}
      link.color=#2EB8E6
      link.visited.color=#FF6666

      [PanelButtonCommand]
      frame=true
      frame.element=button
      frame.top=3
      frame.bottom=3
      frame.left=3
      frame.right=3
      interior=true
      interior.element=button
      indicator.size=9
      text.normal.color=white
      text.focus.color=#80C0FF
      text.press.color=white
      text.toggle.color=white
      text.shadow=false
      text.margin=1
      text.iconspacing=4
      indicator.element=arrow
      text.margin.top=3
      text.margin.bottom=3
      text.margin.left=4
      text.margin.right=4
      text.shadow.xshift=1
      text.shadow.yshift=1
      text.shadow.color=#000000
      text.shadow.alpha=255
      text.shadow.depth=1

      [PanelButtonTool]
      inherits=PanelButtonCommand

      [Dock]
      inherits=PanelButtonCommand
      frame=false
      interior=false

      [DockTitle]
      inherits=PanelButtonCommand
      frame=false
      interior=true
      interior.element=dock
      text.focus.color=white
      text.bold=true
      text.margin.top=2
      text.margin.bottom=2
      text.margin.left=3
      text.margin.right=3

      [IndicatorSpinBox]
      inherits=PanelButtonCommand
      indicator.element=arrow
      frame.element=spin
      interior.element=spin
      frame.top=3
      frame.bottom=3
      frame.left=3
      frame.right=3
      indicator.size=9

      [RadioButton]
      inherits=PanelButtonCommand
      interior.element=radio
      text.margin.top=2
      text.margin.bottom=2
      text.margin.left=3
      text.margin.right=3

      [CheckBox]
      inherits=PanelButtonCommand
      interior.element=checkbox
      text.margin.top=2
      text.margin.bottom=2
      text.margin.left=3
      text.margin.right=3

      [Focus]
      inherits=PanelButtonCommand
      interior=false
      frame=true
      frame.element=focus
      frame.top=1
      frame.bottom=1
      frame.left=1
      frame.right=1
      frame.patternsize=20

      [GenericFrame]
      inherits=PanelButtonCommand
      frame=true
      interior=false
      frame.element=common
      interior.element=common

      [LineEdit]
      inherits=PanelButtonCommand
      frame.element=lineedit
      interior.element=lineedit

      [DropDownButton]
      inherits=PanelButtonCommand
      indicator.element=arrow-down

      [IndicatorArrow]
      indicator.element=arrow
      indicator.size=9

      [ToolboxTab]
      inherits=PanelButtonCommand

      [Tab]
      inherits=PanelButtonCommand
      interior.element=tab
      text.margin.left=8
      text.margin.right=8
      frame.element=tab
      indicator.element=tab
      frame.top=2
      frame.bottom=2
      frame.left=2
      frame.right=2

      [TabFrame]
      inherits=PanelButtonCommand
      frame.element=tabframe
      interior.element=common

      [TreeExpander]
      inherits=PanelButtonCommand
      frame=false
      interior=false
      indicator.size=9

      [HeaderSection]
      inherits=PanelButtonCommand

      [SizeGrip]
      indicator.element=sizegrip

      [Toolbar]
      inherits=PanelButtonCommand
      indicator.element=toolbar
      indicator.size=5
      frame.element=toolbar
      interior.element=toolbar

      [Slider]
      inherits=PanelButtonCommand
      frame.element=slider
      interior.element=slider
      frame.top=2
      frame.bottom=2
      frame.left=2
      frame.right=2

      [SliderCursor]
      inherits=PanelButtonCommand
      frame=false
      interior.element=slidercursor

      [Progressbar]
      inherits=PanelButtonCommand
      frame.element=progress
      interior.element=progress
      frame.top=2
      frame.bottom=2
      frame.left=2
      frame.right=2
      text.focus.color=white
      text.bold=true

      [ProgressbarContents]
      inherits=PanelButtonCommand
      frame=false
      interior.element=progress-pattern

      [ItemView]
      inherits=PanelButtonCommand
      text.margin=0
      frame.element=itemview
      interior.element=itemview
      frame.top=2
      frame.bottom=2
      frame.left=2
      frame.right=2

      [Splitter]
      inherits=PanelButtonCommand
      interior.element=splitter
      frame.element=splitter
      frame.top=0
      frame.bottom=0
      frame.left=1
      frame.right=1
      indicator.element=splitter-grip
      indicator.size=16

      [Scrollbar]
      inherits=PanelButtonCommand
      indicator.size=8

      [ScrollbarSlider]
      inherits=PanelButtonCommand
      frame.element=scrollbarslider
      interior.element=scrollbarslider
      frame.top=2
      frame.bottom=2
      frame.left=2
      frame.right=2
      indicator.element=grip
      indicator.size=13

      [ScrollbarGroove]
      inherits=PanelButtonCommand
      interior.element=slider
      frame.element=slider
      frame.top=0
      frame.bottom=0
      frame.left=4
      frame.right=4

      [MenuItem]
      inherits=PanelButtonCommand
      frame=false
      interior.element=menuitem
      indicator.element=menuitem
      min_height=22
      text.focus.color=#4DA6FF
      text.margin.top=2
      text.margin.bottom=2
      text.margin.left=3
      text.margin.right=3

      [MenuBarItem]
      inherits=PanelButtonCommand
      interior.element=menubaritem
      frame.element=menubaritem
      frame.top=2
      frame.bottom=2
      frame.left=2
      frame.right=2
      text.margin.top=2
      text.margin.bottom=2

      [MenuBar]
      inherits=PanelButtonCommand
      frame.top=0
      frame.bottom=0
      frame.left=2
      frame.right=2
      frame.element=menuitem
      interior.element=menuitem

      [TitleBar]
      inherits=PanelButtonCommand
      frame=false
      interior.element=titlebar
      indicator.size=12
      indicator.element=mdi
      text.normal.color=black
      text.focus.color=white
      text.margin.top=2
      text.margin.bottom=2
      text.margin.left=3
      text.margin.right=3

      [ComboBox]
      inherits=PanelButtonCommand

      [Menu]
      inherits=PanelButtonCommand
      frame.top=3
      frame.bottom=3
      frame.left=3
      frame.right=3
      frame.element=menu
      interior.element=menu

      [GroupBox]
      inherits=GenericFrame
      frame=true
      frame.element=group
      interior=true
      interior.element=group
      text.shadow=false
      text.margin=0
      frame.top=3
      frame.bottom=3
      frame.left=3
      frame.right=3

      [TabBarFrame]
      inherits=GenericFrame
      frame=false
      interior=false
      text.shadow=false

      [ToolTip]
      inherits=GenericFrame
      frame.top=3
      frame.bottom=3
      frame.left=3
      frame.right=3
      interior=true
      text.shadow=false
      text.margin=0
      interior.element=tooltip
      frame.element=tooltip

      [Window]
      interior=false
    '';
  };
}
