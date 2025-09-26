;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar fst/default-font-size 110)
(defvar fst/default-variable-font-size 110)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			   ("org" . "https://orgmode.org/elpa/")
			   ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(setq comp-deferred-compilation nil)

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar
(global-visual-line-mode 1)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		  term-mode-hook
		  shell-mode-hook
		  eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "CaskaydiaCove Nerd Font Mono" :height fst/default-font-size)


;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "CaskaydiaCove Nerd Font Mono" :height fst/default-font-size)

(set-fontset-font t 'unicode "Noto Color Emoji" nil 'prepend)

(use-package hl-todo
:hook (prog-mode . hl-todo-mode)
:config
(setq hl-todo-highlight-punctuation ":"
	hl-todo-keyword-faces
	`(("TODO"       warning bold)
	  ("FIXME"      error bold)
	  ("HACK"       font-lock-constant-face bold)
	  ("REVIEW"     font-lock-keyword-face bold)
	  ("NOTE"       success bold)
	  ("DEPRECATED" font-lock-doc-face bold))))

;; (use-package mini-frame
;;   :ensure t
;;   )


;; (require 'mini-frame)

;; (with-eval-after-load 'mini-frame

;;   ;; Miniframe at the bottom for a nicer display
;;   (setq mini-frame-show-parameters
;;	  `((left . 0.5)
;;	    (top . 1.0)
;;	    (width . 1.0)
;;	    (height . 10)
;;	    (left-fringe . 12)
;;	    (right-fringe .12)
;;	    (child-frame-border-width . 0)
;;	    (internal-border-width . 0)
;;	    ))

;;   (with-eval-after-load 'ivy
;;     (setq ivy-height 9)
;;     ;; See https://github.com/abo-abo/swiper/issues/2383
;;     (setcdr (assoc t ivy-format-functions-alist) #'ivy-format-function-line)
;;     (setq mini-frame-ignore-commands
;;	    '("edebug-eval-expression" debugger-eval-expression))

;;     ;; (setq mini-frame-resize 'grow-only) ;; -> buggy as of 01/05/2021
;;     (setq mini-frame-resize 'not-set)
;;     ;; (setq mini-frame-resize nil)
;;     (add-hook 'minibuffer-setup-hook
;;		(lambda ()
;;		  (overlay-put (make-overlay (point-min) (+ (point-min) 1))
;;			       'before-string
;;			       (propertize "\n" 'face `(:extend t
;;								:height .5)))))))

;;   (mini-frame-mode 1)

(use-package ivy-posframe
  :ensure t
  )

(require 'ivy-posframe)
;; display at `ivy-posframe-style'
(setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-bottom-left)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
(ivy-posframe-mode 1)

;;(add-to-list 'custom-theme-load-path "~/.config/emacs/everforest-theme/")
;;(load-theme 'everforest-hard-dark t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer fst/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (fst/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree
:ensure t
:after evil
:config
(evil-set-undo-system 'undo-tree)
(global-undo-tree-mode 1))

(setq undo-tree-history-directory-alist
      `(("." . "~/.config/emacs/undo-tree/"))) ;; store undo files here
(setq undo-tree-auto-save-history t))        ;; enable saving undo history

(setq auto-save-file-name-transforms
    `((".*" "~/.config/emacs/auto-saves/" t))) ;; redirect autosaves
(setq auto-save-list-file-prefix "~/.config/emacs/auto-saves/.saves-")

(setq backup-directory-alist `(("." . "~/.config/emacs/backups")))
(setq make-backup-files t)             ;; enable backups
(setq backup-by-copying t)             ;; avoid symlink issues
(setq version-control t)               ;; use numbered backups
(setq delete-old-versions t)           ;; clean up old backups
(setq kept-new-versions 6)
(setq kept-old-versions 2)

(use-package doom-themes
:init (load-theme 'doom-dracula t))

;;(use-package gruvbox-theme)

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config (setq doom-modeline-bar-width 4))
(setq evil-normal-state-tag   (propertize "[Normal]" 'face '((:background "green" :foreground "black")))
    evil-emacs-state-tag    (propertize "[Emacs]" 'face '((:background "orange" :foreground "black")))
    evil-insert-state-tag   (propertize "[Insert]" 'face '((:background "red") :foreground "white"))
    evil-motion-state-tag   (propertize "[Motion]" 'face '((:background "blue") :foreground "white"))
    evil-visual-state-tag   (propertize "[Visual]" 'face '((:background "grey80" :foreground "black")))
    evil-operator-state-tag (propertize "[Operator]" 'face '((:background "purple"))))
(setq doom-modeline-modal-icon nil)

;; (use-package mood-line
;; :config
;; ;; Enable mood-line
;; (mood-line-mode)
;; ;; Use pretty Fira Code-compatible glyphs
;; (setq mood-line-glyph-alist mood-line-glyphs-unicode)
;; (setq mood-line-format mood-line-format-default-extended))

;;(use-package nano-modeline
;;  :ensure t
;;  :config
;;  (setopt nano-modeline-position 'nano-modeline-footer)

;;  (add-hook 'prog-mode-hook            #'nano-modeline-prog-mode)
;;  (add-hook 'text-mode-hook            #'nano-modeline-text-mode)
;;  (add-hook 'org-mode-hook             #'nano-modeline-org-mode)
;;  (add-hook 'pdf-view-mode-hook        #'nano-modeline-pdf-mode)
;;  (add-hook 'mu4e-headers-mode-hook    #'nano-modeline-mu4e-headers-mode)
;;  (add-hook 'mu4e-view-mode-hook       #'nano-modeline-mu4e-message-mode)
;;  (add-hook 'elfeed-show-mode-hook     #'nano-modeline-elfeed-entry-mode)
;;  (add-hook 'elfeed-search-mode-hook   #'nano-modeline-elfeed-search-mode)
;;  (add-hook 'term-mode-hook            #'nano-modeline-term-mode)
;;  (add-hook 'xwidget-webkit-mode-hook  #'nano-modeline-xwidget-mode)
;;  (add-hook 'messages-buffer-mode-hook #'nano-modeline-message-mode)
;;  (add-hook 'org-capture-mode-hook     #'nano-modeline-org-capture-mode)
;;  (add-hook 'org-agenda-mode-hook      #'nano-modeline-org-agenda-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package diminish)

(use-package swiper
  :after ivy
  :ensure t)

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	   ("C-x C-f" . counsel-find-file)
	   ("C-x b" . counsel-switch-buffer)
	   ("C-x C-r" . counsel-recentf)))

(use-package ivy
  :ensure t
  :demand t
  :diminish
  :bind (("C-s" . swiper)
	   :map ivy-minibuffer-map
	   ("TAB" . ivy-alt-done)
	   ("C-l" . ivy-alt-done)
	   ("C-j" . ivy-next-line)
	   ("C-k" . ivy-previous-line)
	   :map ivy-switch-buffer-map
	   ("C-k" . ivy-previous-line)
	   ("C-l" . ivy-done)
	   ("C-d" . ivy-switch-buffer-kill)
	   :map ivy-reverse-i-search-map
	   ("C-k" . ivy-previous-line)
	   ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode t))

(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode 1)
  :config
  (setq ivy-rich-path-style 'abbrev))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes)

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.config/emacs/Emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package toc-org
  :ensure t)

(if (require 'toc-org nil t)
  (progn
    (add-hook 'org-mode-hook 'toc-org-mode))
(warn "toc-org not found"))

(use-package vterm
    :ensure t)

(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(tree-sitter-require 'rust)
(tree-sitter-require 'cpp)
(tree-sitter-require 'c)
(tree-sitter-require 'python)

;; (use-package tramp
;; :config
;; ;; Use the remote machine's PATH
;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;; ;; Reduce verbosity for better performance
;; (setq tramp-verbose 1))

;; (defun fst/lsp-mode-setup ()
  ;;   (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  ;;   (lsp-headerline-breadcrumb-mode))

  ;; (use-package lsp-mode
  ;;   :commands (lsp lsp-deferred)
  ;;   :hook (lsp-mode . fst/lsp-mode-setup)
  ;;   :init
  ;;   (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  ;;   :config
  ;;   (lsp-enable-which-key-integration t)
  ;;   (lsp-register-client
  ;;    (make-lsp-client
  ;;     :new-connection (lsp-tramp-connection "clangd-12")
  ;;     :major-modes '(c++-mode)
  ;;     :remote? t
  ;;     :server-id 'clangd-id))
  ;;  )

  (defun fst/lsp-mode-setup ()
  "Custom setup for lsp-mode."
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . fst/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)
  ;; Register clangd for C++ (local only)
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "clangd")  ;; removed tramp
    :major-modes '(c++-mode)
    :server-id 'clangd-id)))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  :config
   (setq lsp-ui-sideline-show-hover t
  lsp-ui-sideline-show-code-actions t
  lsp-ui-doc-enable t))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection)
   :map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))  ;; instant suggestions

;; Optional: company-box for icons and nicer UI
(use-package company-box
  :hook (company-mode . company-box-mode))

(with-eval-after-load 'company
(setq company-backends '(company-capf)))

(setq gc-cons-threshold (* 100 1024 1024)
    read-process-output-max (* 1024 1024))

(use-package yasnippet
:ensure t
:config
(yas-global-mode 1))  ;; Enable yasnippet globally

;;   (progn
  ;;     (customize-set-variable 'eglot-extend-to-xref t)
  ;;     (customize-set-variable 'eglot-ignored-server-capabilities
  ;; 	  (quote (:documentFormattingProvider :documentRangeFormattingProvider)))

  ;;     (with-eval-after-load 'eglot
  ;; 	  (setq completion-category-defaults nil)
  ;; 	  (add-to-list 'eglot-server-programs
  ;; 	      '(c-mode c++-mode
  ;; 		   . ("clangd"
  ;; 			 "--malloc-trim"
  ;; 			 "--log=error"
  ;; 			 "--background-index"
  ;; 			 "--clang-tidy"
  ;; 			 "--cross-file-rename"
  ;; 			 "--completion-style=detailed"
  ;; 			 "--pch-storage=memory"
  ;; 			 "--header-insertion=never"
  ;; 			 "--header-insertion-decorators=0"))))

  ;; (defun fst/hook-cpp-mode ()
  ;;   (eglot-ensure)
  ;;   (company-mode t)) 

  ;; (add-hook 'c-mode-hook #'fst/hook-cpp-mode)
  ;; (add-hook 'c++-mode-hook #'fst/hook-cpp-mode))

(defun fst/lsp-mode-setup ()
  "Custom setup for lsp-mode."
  ;; Show path + file + symbols in headerline
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode)
  ;; Optional: enable company integration automatically
  (company-mode 1))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c-mode c++-mode) . fst/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; prefix for lsp commands
  :config
  ;; Enable which-key integration
  (lsp-enable-which-key-integration t)
  ;; Register clangd for local C/C++ usage
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "clangd")  ;; local clangd
    :major-modes '(c-mode c++-mode)
    :server-id 'clangd-id)))

(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)

;; WakaTime Configuration
(use-package wakatime-mode
  :ensure t  ; Automatically install if not present
  :config
  (setq wakatime-api-key (with-temp-buffer
			     (insert-file-contents (expand-file-name "~/.wakatime-api-key"))
			     (buffer-string)))
  (global-wakatime-mode 1))  ; Enable WakaTime mode
