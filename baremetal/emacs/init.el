;; This is my Emacs initialization file, configuring Emacs to my liking.

;;; Commentary:
;; This file sets up essential packages, keybindings, and custom functions
;; to enhance productivity and usability of Emacs.

;;; Code:

;;; Bootstrap `straight.el` ;;;
;;----------------------------;;

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Ensure `use-package` integrates with `straight.el`
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; Appearance Configuration ;;;
;;-----------------------------;;

;; Load Catppuccin theme
(use-package catppuccin-theme
  :straight t
  :config
  (load-theme 'catppuccin :no-confirm)
  (setq catppuccin-flavor 'mocha)
  (catppuccin-reload))

;; Remove toolbar
(tool-bar-mode -1)

;; Enable menu bar
(menu-bar-mode t)

;; Enable line numbers globally, but disable in Treemacs
(global-display-line-numbers-mode 1)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))

;; Configure mode line
(set-face-attribute 'mode-line-active nil :inherit 'mode-line)

;; Enable Doom Modeline
(use-package doom-modeline
  :straight t
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

(let ((paths '("/Users/luke.collins/.nix-profile/bin"
               "/etc/profiles/per-user/luke.collins/bin"
               "/run/current-system/sw/bin"
               "/nix/var/nix/profiles/default/bin"
               "/usr/local/bin"
               "/usr/bin"
               "/usr/sbin"
               "/bin"
               "/sbin")))
  ;; Set the environment variable PATH
  (setenv "PATH" (string-join paths ":"))

  ;; Set exec-path in Emacs
  (setq exec-path (append paths exec-path)))

;;; Backtab Functionality for Unindent ;;;
;;--------------------------------------;;

(defun my-unindent-up-to-previous ()
  "Unindent the current line to match the nearest lesser indentation level of the lines above."
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
  :straight t
  :config
  ;; Set the initial buffer choice to Dashboard
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

  ;; Set up the Dashboard
  (dashboard-setup-startup-hook)

  ;; Dashboard appearance settings
  (setq dashboard-banner-logo-title "Allied Mastercomputer")
  (setq dashboard-startup-banner "~/Pictures/gnu_color.png") ;; Set banner image
  (setq dashboard-center-content t) ;; Center content
  (setq dashboard-display-icons-p t) ;; Enable icons
  (setq dashboard-icon-type 'nerd-icons) ;; Use Nerd Icons
  (setq dashboard-set-file-icons t) ;; Show file icons

  ;; Dashboard items to display
  (setq dashboard-items '((recents . 5)))

  ;; Modify heading icons for certain dashboard items
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))

  ;; Set the footer message
  (setq dashboard-footer-messages '("I have no mouth, and I must scream")))

;; Enable Nerd Icons
(use-package nerd-icons
  :straight t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")) ;; Recommended font

;;; CSV Mode Configuration ;;;
;;---------------------------;;

(use-package csv-mode
  :straight t
  :config
  (csv-mode))

;;; Projectile Configuration ;;;
;;-----------------------------;;

(use-package projectile
  :straight t
  :config
  (projectile-mode +1))

;;; Direnv Configuration ;;;
;;-------------------------;;

(use-package direnv
  :straight t
  :config
  (direnv-mode))

;;; Helm Configuration ;;;
;;----------------------;;

(use-package helm
  :straight t
  :config
  (helm-mode 1) ;; Enable Helm

  ;; Enable fuzzy matching for various Helm commands
  (setq helm-M-x-fuzzy-match t) ;; Fuzzy matching for M-x
  (setq helm-buffers-fuzzy-matching t) ;; Fuzzy matching for buffer-related tasks
  (setq helm-recentf-fuzzy-match t) ;; Fuzzy matching for recent files
  (setq helm-locate-fuzzy-match t) ;; Fuzzy matching for locate command
  (setq helm-semantic-fuzzy-match t) ;; Fuzzy matching for semantic sources
  (setq helm-imenu-fuzzy-match t) ;; Fuzzy matching for imenu
  (setq helm-completion-in-region-fuzzy-match t) ;; Fuzzy matching for in-region completion

  ;; Keybindings for Helm
  :bind (("M-x" . helm-M-x)))

;;; Company Mode Configuration ;;;
;;------------------------------;;

(use-package company
  :straight t
  :defer 0.1
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
  :straight t
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

;;; GPTel Configuration ;;;
;;------------------------;;

(use-package gptel
  :config
  (setq gptel-model 'qwen2.5-coder:14b) ;; Set GPT model
  (setq gptel-backend (gptel-make-ollama "Ollama"
                                         :host "192.168.0.243:11434"
                                         :stream t
                                         :models '("qwen2.5-coder:14b"))))

;;; Language Configuration ;;;
;;---------------------------;;

;;; Custom Function to Enable LSP Mode Only for Bash Scripts ;;;
;;------------------------------------------------------------;;

(defun enable-lsp-in-sh-mode ()
  "Enable lsp-mode in shell mode only for Bash scripts."
  (when (and (eq major-mode 'sh-mode)
             (not (string-suffix-p ".zsh" (buffer-file-name))))
    (lsp-deferred)))

;;; Language Modes for Various File Types ;;;
;;------------------------------------------;;

;; Terraform Mode
(use-package terraform-mode
  :straight t
  :mode ("\\.tf\\'" . terraform-mode))

;; Dockerfile Mode
(use-package dockerfile-mode
  :straight t
  :mode ("Dockerfile\\'" . dockerfile-mode)
        ("\\.dockerfile\\'" . dockerfile-mode))

;; Nix Mode
(use-package nix-mode
  :straight t
  :mode "\\.nix\\'")

;; Rust Mode
(use-package rust-mode
  :straight t
  :mode "\\.rs\\'")

;; Markdown Mode
(use-package markdown-mode
  :straight t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

;; YAML Mode
(use-package yaml-mode
  :straight t
  :mode ("\\.yml\\'" "\\.yaml\\'"))

;; Web Mode (for HTML)
(use-package web-mode
  :straight t
  :mode ("\\.html?\\'" . web-mode)
  :init
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-auto-close-style 2))

;; CSS Mode
(use-package css-mode
  :straight t
  :mode ("\\.css\\'" . css-mode)
  :init
  (setq css-indent-offset 2))

;;; Flycheck Configuration ;;;
;;---------------------------;;

(use-package flycheck
  :straight t
  :init (global-flycheck-mode))

;;; LSP Mode Configuration ;;;
;;---------------------------;;

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :hook ((rust-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (sh-mode . enable-lsp-in-sh-mode)
         (dockerfile-mode . lsp-deferred)
         (terraform-mode . lsp-deferred)
         (yaml-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (css-mode . lsp-deferred))
  :config
  ;; Rust Analyzer settings
  (setq lsp-rust-analyzer-cargo-watch-command "clippy")
  (setq lsp-rust-analyzer-server-display-inlay-hints t)

  ;; LSP Completion settings
  (setq lsp-completion-enable nil)

  ;; Python LSP settings
  (setq lsp-pylsp-plugins-flake8-enabled t
        lsp-pylsp-plugins-black-enabled t
        lsp-pylsp-plugins-isort-enabled t
        lsp-pylsp-plugins-mypy-enabled t
        lsp-pylsp-plugins-mypy-live-mode t
        lsp-pylsp-plugins-pylint-enabled t
        lsp-pylsp-plugins-flake8-max-line-length 88))

;;; LSP UI Configuration ;;;
;;-------------------------;;

(use-package lsp-ui
  :straight t
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))

(provide 'init)
;;; init.el ends here
