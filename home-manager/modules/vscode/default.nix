{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.code;
in {
  options.link.code.enable = mkEnableOption "activate vscodium";
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        #vscodevim.vim
        arrterian.nix-env-selector
        b4dm4n.vscode-nixpkgs-fmt
        dracula-theme.theme-dracula
        eamodio.gitlens
        esbenp.prettier-vscode
        firefox-devtools.vscode-firefox-debug
        github.copilot
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
        ms-python.python
        ms-toolsai.jupyter
        ms-vscode-remote.remote-ssh
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        usernamehw.errorlens
        vadimcn.vscode-lldb
        yzhang.markdown-all-in-one
      ];
      userSettings = {
        "[nix]" = { "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt"; };
        "diffEditor.codeLens" = true;
        "diffEditor.diffAlgorithm" = "advanced";
        "diffEditor.ignoreTrimWhitespace" = "false";
        "editor.cursorBlinking" = "expand";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorSurroundingLinesStyle" = "all";
        "editor.defaultColorDecorators" = true;
        "editor.find.autoFindInSelection" = "multiline";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.linkedEditing" = true;
        "editor.mouseWheelZoom" = true;
        "editor.renderWhitespace" = "all";
        "editor.smoothScrolling" = true;
        "editor.stickyTabStops" = true;
        "editor.suggest.preview" = true;
        "editor.tabCompletion" = "on";
        "editor.tabSize" = "2";
        "editor.wordWrap" = "bounded";
        "explorer.incrementalNaming" = "smart";
        "files.autoGuessEncoding" = true;
        "files.autoSave" = "afterDelay";
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "git.autofetch" = true;
        "git.confirmSync" = "false";
        "git.enableSmartCommit" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "problems.showCurrentInStatus" = true;
        "scm.alwaysShowActions" = true;
        "scm.alwaysShowRepositories" = true;
        "search.experimental.notebookSearch" = true;
        "search.smartCase" = true;
        "window.zoomLevel" = "-2";
        "workbench.colorTheme" = "Dracula";
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.editor.limit.enabled" = true;
        "workbench.list.smoothScrolling" = true;
      };
      globalSnippets = {
        fixme = {
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
          prefix = [ "fixme" ];
        };
      };
      keybindings = [{
        key = "ctrl+c";
        command = "editor.action.clipboardCopyAction";
        when = "textInputFocus";
      }];
    };
  };

}