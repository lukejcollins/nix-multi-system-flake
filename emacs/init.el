;; -*- lexical-binding: t -*-;;
;;; init.el --- Summary
;; This is my Emacs initialization file which configures Emacs to my liking.

;;; Commentary:
;; This file sets up essential packages, keybindings, and custom functions
;; to enhance productivity and usability of Emacs.

;;; Code:

(require 'use-package)


;;; Appearance Configuration ;;;
;;----------------------------;;

;; Load theme
(load-theme 'modus-vivendi)

;; Startup appearance
(setq fancy-splash-image "/Users/luke.collins/Pictures/gnu_color.png")

;;Remove tool bar
(tool-bar-mode -1)


;; Enable line numbers
(global-display-line-numbers-mode 1)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))


;;; General Configuration ;;;
;;----------------------------;;

;; Clipboard Configuration
(setq select-enable-clipboard t
            select-enable-primary t)

;; Disable backup files
(setq make-backup-files nil)

;; Disable tooltip mode
(tooltip-mode -1)

;; Disable auto save
(setq auto-save-default nil)

;; Path configuration
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


;;; App Configuration ;;;
;;----------------------------;;

;; Dashboard configuration
(use-package dashboard
  :ensure t
  :config
  ;; Set the initial buffer choice to Dashboard
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

  ;; Set up the Dashboard
  (dashboard-setup-startup-hook)

  ;; Dashboard appearance settings
  (setq dashboard-banner-logo-title "Welcome home")
  (setq dashboard-startup-banner "~/Pictures/gnu_color.png") ; Set the banner image
  (setq dashboard-center-content t) ; Center the content
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-file-icons t)

  ;; Dashboard items to display
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))

  ;; Modify heading icons for certain dashboard items
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))

  ;; Set the footer message
  (setq dashboard-footer-messages '("Zoom in and obsess. Zoom out and observe. We get to choose.")))

(use-package nerd-icons
  :ensure t
  :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  (nerd-icons-font-family "Symbols Nerd Font Mono"))

;; Projectile configuration
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

;; Direnv configuration
(use-package direnv
  :ensure t
  :config
  (direnv-mode))

;; Helm configuration
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  :bind (("M-x" . helm-M-x)))

;; Treemacs configuration
(use-package treemacs
  :ensure t
  :bind (("C-x t" . treemacs))
  :custom (treemacs-theme "all-the-icons")
  :config
  (use-package treemacs-all-the-icons
    :ensure t))

(defun my-treemacs-add-project-with-name ()
  "Add a project to the Treemacs workspace with a custom name."
  (interactive)
  (let* ((path (read-directory-name "Project root: "))
         (name (read-string "Project name: " (file-name-nondirectory (directory-file-name path))))
         (project (list :name name :path path)))
    (if (treemacs-workspace->is-empty?)
        (treemacs-do-create-workspace)
      (treemacs-do-add-project-to-workspace path name))))

(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map (kbd "A a") #'my-treemacs-add-project-with-name))

;; Ivy configuration
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t))

;; Counsel configuration
(use-package counsel
  :ensure t
  :bind (("M-y" . counsel-yank-pop)
         ("C-x C-f" . counsel-find-file)))

;; Enable grip-mode
(use-package grip-mode
  :ensure t)

;; Vterm configuration
(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 5000))

;; Copilot configuration
(let ((copilot-dir "~/.emacsCopilot")
      (copilot-file "~/.emacsCopilot/copilot.el"))

  ;; Check if the copilot.el file exists
  (when (file-exists-p copilot-file)
    
    ;; Add the directory to the load-path
    (add-to-list 'load-path copilot-dir)
    
    ;; Try to load the copilot module and catch any errors
    (condition-case err
        (progn
          (require 'copilot)
          (add-hook 'prog-mode-hook 'copilot-mode)
          (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion))
      
      ;; If there's an error, print a message (you can also log or take other actions)
      (error (message "Failed to load copilot: %s" err)))))


;;; Language Configuration ;;;
;;----------------------------;;

;; Linting with Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(python-pycompile))
  (add-hook 'python-mode-hook (lambda () (flycheck-select-checker 'python-flake8)))
  (add-hook 'sh-mode-hook (lambda () (flycheck-select-checker 'sh-shellcheck)))
  (add-hook 'dockerfile-mode-hook (lambda () (flycheck-select-checker 'dockerfile-hadolint)))
  (add-hook 'nix-mode-hook (lambda () (flycheck-select-checker 'nix-statix)))
  (add-hook 'terraform-mode-hook (lambda () (flycheck-select-checker 'terraform-tflint))))

(use-package flycheck-inline
  :ensure t
  :after flycheck
  :hook (flycheck-mode . flycheck-inline-mode))

;; Modes for various file types
(use-package terraform-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package nix-mode :ensure t)
(use-package markdown-mode :ensure t)

;; Python configuration
(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 79))

;; Formatting keybinding
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (cond ((eq major-mode 'python-mode) (blacken-buffer))
                                     ((eq major-mode 'sh-mode) (shell-command-on-region (point-min) (point-max) "shfmt" (current-buffer) t))
                                     ((eq major-mode 'nix-mode) (shell-command-on-region (point-min) (point-max) "nixpkgs-fmt" (current-buffer) t))
                                     ((eq major-mode 'terraform-mode) (shell-command-on-region (point-min) (point-max) "terraform fmt" nil t))
                                     (t (message "No formatter specified for %s" major-mode)))))

;; LSP configuration
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (rust-mode . lsp-deferred))

;; Rust Mode
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

;; Rust LSP
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company :hook (after-init . global-company-mode))
(use-package flycheck :init (global-flycheck-mode))

(provide 'init)
;;; init.el ends here
