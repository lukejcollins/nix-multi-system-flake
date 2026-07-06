;;; emacs.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; This file sets up essential packages, keybindings, and custom functions
;; to enhance productivity and usability of Emacs.

;;; Code:

(require 'subr-x)
(require 'sh-script)

(declare-function treemacs-do-add-project-to-workspace "treemacs")
(declare-function treemacs-load-theme "treemacs")

;;; Appearance Configuration ;;;
;;-----------------------------;;

;; Load Catppuccin theme
(use-package catppuccin-theme
  :init
  (setq catppuccin-flavor 'mocha)
  :config
  (load-theme 'catppuccin :no-confirm))

;; Remove toolbar
(tool-bar-mode -1)

;; Enable menu bar
(menu-bar-mode t)

;; Enable line numbers globally, but disable in Treemacs
(global-display-line-numbers-mode 1)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))

;; Configure mode line
(when (facep 'mode-line-active)
  (set-face-attribute 'mode-line-active nil :inherit 'mode-line))

;; Enable Doom Modeline
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

;;; General Configuration ;;;
;;--------------------------;;

;; Enable clipboard integration
(setq select-enable-clipboard t
      select-enable-primary t)

;; Disable backup files
(setq make-backup-files nil)

;; Disable tooltips
(tooltip-mode -1)

;; Disable auto-save
(setq auto-save-default nil)

;; Enable auto-revert mode to refresh buffers automatically
(global-auto-revert-mode t)

;; Disable dialog boxes
(setq use-dialog-box nil)

;; Remap Meta + 3 to insert `#` (fixes pound sign issue on Mac keyboards)
(global-set-key (kbd "M-3") (lambda () (interactive) (insert "#")))

;; macOS-specific modifier key settings
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier nil)
(setq mac-command-modifier 'super)

;;; Keybindings ;;;
;;---------------;;

;; Copy (Cmd+C)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)

;; Paste (Cmd+V)
(global-set-key (kbd "s-v") 'clipboard-yank)

;; Cut (Cmd+X)
(global-set-key (kbd "s-x") 'kill-region)

;; Undo (Cmd+Z)
(global-set-key (kbd "s-z") 'undo)

;; Redo (Cmd+Y)
(global-set-key (kbd "s-y") 'undo-redo)

;; Force Quit (Cmd+Q)
(global-set-key (kbd "s-q") 'kill-emacs)

;; Select All (Cmd+A)
(global-set-key (kbd "s-a") 'mark-whole-buffer)

;; Allow pasting to replace selected text
(delete-selection-mode 1)

;;; Path Configuration ;;;
;;----------------------;;

(let ((paths (delq nil
                   (list (expand-file-name ".nix-profile/bin" (getenv "HOME"))
                         (format "/etc/profiles/per-user/%s/bin" (user-login-name))
                         "/run/current-system/sw/bin"
                         "/nix/var/nix/profiles/default/bin"
                         "/opt/homebrew/bin"
                         "/usr/local/bin"
                         "/usr/bin"
                         "/usr/sbin"
                         "/bin"
                         "/sbin"))))
  (setenv "PATH" (string-join paths ":"))
  (setq exec-path (append paths exec-path)))

;;; Backtab Functionality for Unindent ;;;
;;--------------------------------------;;

(defun my-unindent-up-to-previous ()
  "Unindent the current line to the nearest lesser level above."
  (interactive)
  (let ((current-indentation (current-indentation))
        (target-indentation 0)
        (searching t))
    (save-excursion
      ;; Loop to search upwards for a line with lesser indentation.
      (while (and searching (not (bobp))) ;; `bobp` checks if beginning of buffer is reached.
        (forward-line -1)
        (let ((previous-line-indentation (current-indentation)))
          (when (< previous-line-indentation current-indentation)
            (setq target-indentation previous-line-indentation)
            (setq searching nil)))))
    ;; Only unindent if a target indentation level was found.
    (when (and (not searching) (> current-indentation target-indentation))
      (indent-line-to target-indentation))))

;; Bind the function to Backtab (Shift + Tab)
(define-key global-map [backtab] 'my-unindent-up-to-previous)

;;; App Configuration ;;;
;;----------------------;;

;;; Dashboard Configuration ;;;
;;----------------------------;;

(use-package dashboard
  :demand t
  :functions (dashboard-open dashboard-setup-startup-hook)
  :init
  (setq inhibit-startup-screen t)
  (setq dashboard-banner-logo-title
        "\"Software must be Free because we all deserve freedom.\"\n\nRichard Stallman")
  (setq dashboard-startup-banner "~/Pictures/gnu_color.png") ;; Set banner image
  (setq dashboard-center-content t) ;; Center content
  (setq dashboard-display-icons-p t) ;; Enable icons
  (setq dashboard-icon-type 'nerd-icons) ;; Use Nerd Icons
  (setq dashboard-set-file-icons t) ;; Show file icons

  ;; Dashboard items to display
  (setq dashboard-items '((recents . 5)))

  ;; Set the footer message
  (setq dashboard-footer-messages '("I have no mouth, and I must scream"))

  ;; Set the initial buffer choice to Dashboard for interactive sessions.
  (unless noninteractive
    (setq initial-buffer-choice #'dashboard-open))
  :config
  ;; Set up the Dashboard
  (dashboard-setup-startup-hook))

;; Enable Nerd Icons
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")) ;; Recommended font

;;; CSV Mode Configuration ;;;
;;---------------------------;;

(use-package csv-mode
  :mode "\\.csv\\'")

;;; Projectile Configuration ;;;
;;-----------------------------;;

(use-package projectile
  :demand t
  :functions projectile-mode
  :config
  (projectile-mode +1))

;;; Direnv Configuration ;;;
;;-------------------------;;

(use-package direnv
  :demand t
  :functions direnv-mode
  :config
  (direnv-mode))

;;; Helm Configuration ;;;
;;----------------------;;

(use-package helm
  :demand t
  :functions helm-mode
  :custom
  (helm-M-x-fuzzy-match t)
  (helm-buffers-fuzzy-matching t)
  (helm-recentf-fuzzy-match t)
  (helm-locate-fuzzy-match t)
  (helm-semantic-fuzzy-match t)
  (helm-imenu-fuzzy-match t)
  (helm-completion-in-region-fuzzy-match t)
  :config
  (require 'helm-mode)
  (helm-mode 1)
  :bind (("M-x" . helm-M-x)))

;;; Company Mode Configuration ;;;
;;------------------------------;;

(use-package company
  :demand t
  :functions global-company-mode
  :config
  (global-company-mode t) ;; Enable Company globally

  ;; Adjust completion settings
  (setq-default
   company-idle-delay 0.05 ;; Show completions quickly
   company-require-match nil
   company-minimum-prefix-length 0

   ;; Get only preview
   company-frontends '(company-preview-frontend)
   ;; Uncomment below to also show a dropdown:
   ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   ))

;;; Treemacs Configuration ;;;
;;---------------------------;;

(use-package treemacs
  :bind (("C-x t" . treemacs)))

(use-package treemacs-nerd-icons
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

;; Function to add projects to Treemacs workspace with a custom name
(defun my-treemacs-add-project-with-name ()
  "Add a project to the Treemacs workspace with a custom name."
  (interactive)
  (let ((path (read-directory-name "Project root: "))
        (name (read-string "Project name: ")))
    ;; Ensure the path is valid
    (when (and (file-directory-p path)
               (file-exists-p path))
      ;; Add project to workspace
      (treemacs-do-add-project-to-workspace path name))))

;; Bind the function to `A a` in Treemacs mode
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map (kbd "A a") #'my-treemacs-add-project-with-name))

;;; Language Configuration ;;;
;;---------------------------;;

;;; Custom Function to Enable LSP Mode Only for Bash Scripts ;;;
;;------------------------------------------------------------;;

(defun enable-lsp-in-sh-mode ()
  "Enable lsp-mode in shell mode only for Bash scripts."
  (when (and (eq major-mode 'sh-mode)
             (not (eq sh-shell 'zsh)))
    (lsp-deferred)))

;;; Language Modes for Various File Types ;;;
;;------------------------------------------;;

;; Terraform Mode
(use-package terraform-mode
  :mode ("\\.tf\\'" . terraform-mode))

;; Dockerfile Mode
(use-package dockerfile-mode
  :mode (("Dockerfile\\'" . dockerfile-mode)
         ("\\.dockerfile\\'" . dockerfile-mode)))

;; Nix Mode
(use-package nix-mode
  :mode "\\.nix\\'")

;; Rust Mode
(use-package rust-mode
  :mode "\\.rs\\'")

;; Markdown Mode
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

;; YAML Mode
(use-package yaml-mode
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))

;; Web Mode (for HTML)
(use-package web-mode
  :mode ("\\.html?\\'" . web-mode)
  :init
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-auto-close-style 2))

;; CSS Mode
(use-package css-mode
  :mode ("\\.css\\'" . css-mode)
  :init
  (setq css-indent-offset 2))

;;; Flycheck Configuration ;;;
;;---------------------------;;

(use-package flycheck
  :demand t
  :functions global-flycheck-mode
  :config
  (global-flycheck-mode))

;;; LSP Mode Configuration ;;;
;;---------------------------;;

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-completion-enable nil)
  (lsp-pylsp-plugins-flake8-enabled t)
  (lsp-pylsp-plugins-black-enabled t)
  (lsp-pylsp-plugins-isort-enabled t)
  (lsp-pylsp-plugins-mypy-enabled t)
  (lsp-pylsp-plugins-mypy-live-mode t)
  (lsp-pylsp-plugins-pylint-enabled t)
  (lsp-pylsp-plugins-flake8-max-line-length 88)
  :hook ((rust-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (sh-mode . enable-lsp-in-sh-mode)
         (dockerfile-mode . lsp-deferred)
         (terraform-mode . lsp-deferred)
         (yaml-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (css-mode . lsp-deferred)))

;;; LSP UI Configuration ;;;
;;-------------------------;;

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(provide 'init)
;;; init.el ends here
