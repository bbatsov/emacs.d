;;; init.el --- Bozhidar's Emacs configuration
;;
;; Copyright (c) 2016-2025 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.dev>
;; URL: https://github.com/bbatsov/emacs.d
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is my personal Emacs configuration.  Nothing more, nothing less.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)
;; update the package metadata if the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "Bozhidar Batsov"
      user-mail-address "bozhidar@batsov.dev")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; don't pop up the *Warnings* buffer during async native compilation
(setq native-comp-async-report-warnings-errors 'silent)

;; increase the amount of data Emacs reads from subprocesses in a
;; single chunk (default is 4KB).  This improves throughput for LSP
;; servers and other processes that produce large output.
(setq read-process-output-max (* 1024 1024)) ; 1MB

;; defer fontification while there is input pending -- this keeps
;; typing responsive in large/complex buffers where font-lock is slow
(setq redisplay-skip-fontification-on-input t)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; quit Emacs directly even if there are running processes
(setq confirm-kill-processes nil)

(defconst bozhidar-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p bozhidar-savefile-dir)
  (make-directory bozhidar-savefile-dir))

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

;; repeat-mode - press the last key to repeat commands without the prefix
(repeat-mode 1)

;; wrapped lines respect the indentation of the original line
(global-visual-wrap-prefix-mode 1)

;; live visual feedback when writing regexps in the minibuffer
(minibuffer-regexp-mode 1)

;; highlight the current error in compilation/grep buffers
(setq next-error-message-highlight t)

;; let's pick a nice font
(cond
 ((find-font (font-spec :name "Cascadia Code"))
  (set-frame-font "Cascadia Code-14"))
 ((find-font (font-spec :name "Menlo"))
  (set-frame-font "Menlo-14"))
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-14"))
 ((find-font (font-spec :name "Inconsolata"))
  (set-frame-font "Inconsolata-14")))

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; built-in and fastest option these days
(global-display-line-numbers-mode 1)

;; enable y/n answers
(setq use-short-answers t)

;; automatically select help windows so you can dismiss them with 'q'
(setq help-window-select t)

;; maximize the initial frame automatically
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; delete the selection with a keypress
(delete-selection-mode t)

;; preserve the system clipboard contents before killing text in Emacs,
;; so you don't lose what you copied from another app
(setq save-interprogram-paste-before-kill t)

;; don't clutter the kill ring with duplicate entries
(setq kill-do-not-save-duplicates t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; revert buffers automatically when underlying files are changed externally
(setq auto-revert-avoid-polling t)
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)
(global-set-key (kbd "s-q") #'fill-paragraph)
(global-set-key (kbd "s-x") #'execute-extended-command)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; after C-u C-SPC, keep popping the mark ring with just C-SPC
;; instead of having to repeat the C-u prefix each time
(setq set-mark-command-repeat-pop t)

;; show the current match and the total number of matches (e.g. 3/17)
;; in the isearch prompt
(setq isearch-lazy-count t)

;; motion commands like M-<, M-> and C-v move between matches during
;; isearch instead of quitting the search
(setq isearch-allow-motion t)

;; enable some commands that are disabled by default
(put 'erase-buffer 'disabled nil)

;; make it possible to navigate to the C source of Emacs functions
(setq find-function-C-source-directory "~/projects/emacs")

;; don't let ffap ping random hostnames -- when point is on something
;; that looks like a hostname, ffap would attempt a network lookup to
;; verify it, causing annoying freezes
(setq ffap-machine-p-known 'reject)

;; auto-create missing folders
(defun er-auto-create-missing-dirs ()
  "Make missing parent directories automatically."
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(add-to-list 'find-file-not-found-functions #'er-auto-create-missing-dirs)

;; make keyboard-quit a bit smarter
(define-advice keyboard-quit
    (:around (quit) quit-current-context)
  "Quit the current context.

When there is an active minibuffer and we are not inside it close
it.  When we are inside the minibuffer use the regular
`minibuffer-keyboard-quit' which quits any active region before
exiting.  When there is no minibuffer `keyboard-quit' unless we
are defining or executing a macro."
  (if (active-minibuffer-window)
      (if (minibufferp)
          (minibuffer-keyboard-quit)
        (abort-recursive-edit))
    (unless (or defining-kbd-macro
                executing-kbd-macro)
      (funcall-interactively quit))))

(setq use-package-always-ensure t)
(setq use-package-verbose t)

;; The bundled transient can be too old for recent magit/cider/projectile (and
;; can mess up magit).  Let package.el upgrade built-in packages so the newer
;; ELPA transient is installed and used instead of the built-in one.
(setq package-install-upgrade-built-in t)
(use-package transient)

;; Emacs 30 pretends compat is built-in (with a fake version), which can
;; trick package.el into never installing the real thing - even though
;; vertico, consult, embark & friends now require compat 31.  Install it
;; explicitly to avoid void-function errors from their newer APIs.
(use-package compat)

;;; built-in packages
(use-package paren
  :config
  (show-paren-mode +1)
  ;; show matching paren context when it's offscreen
  (setq show-paren-context-when-offscreen 'overlay))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package calendar
  :config
  ;; weeks in Bulgaria start on Monday
  (setq calendar-week-start-day 1))

(use-package time
  :config
  ;; TZs to display with `world-clock'
  (setq world-clock-list
        '(("America/Los_Angeles" "Seattle")
          ("America/New_York" "New York")
          ("America/Sao_Paulo" "Sao Paulo")
          ("America/Argentina/Buenos_Aires" "Buenos Aires")
          ("Europe/London" "London")
          ("Europe/Paris" "Paris")
          ("Europe/Sofia" "Sofia")
          ("Asia/Istanbul" "Istanbul")
          ("Israel" "Tel Aviv")
          ("Asia/Calcutta" "Bangalore")
          ("Asia/Tokyo" "Tokyo"))))

(use-package dictionary
  :bind (("C-c l" . dictionary-lookup-definition))
  :config
  (setq dictionary-server "dict.org"))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package abbrev
  :ensure nil
  :config
  (setq save-abbrevs 'silently)
  (setq-default abbrev-mode t))

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" bozhidar-savefile-dir))
  ;; activate it for all buffers
  (save-place-mode +1))

(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries and kill ring
        '(search-ring regexp-search-ring kill-ring)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" bozhidar-savefile-dir))
  ;; strip text properties from kill-ring entries before saving to disk --
  ;; propertized strings cause errors and bloat the savehist file
  (add-hook 'savehist-save-hook
            (lambda ()
              (setq kill-ring
                    (mapcar #'substring-no-properties
                            (cl-remove-if-not #'stringp kill-ring)))))
  (savehist-mode +1))

;; (use-package desktop
;;   :config
;;   (desktop-save-mode +1))

(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" bozhidar-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(use-package dired
  :ensure nil
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; drag files from dired to other apps
  (setq dired-mouse-drag-files t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package ediff
  :ensure nil
  :config
  ;; keep the control panel in the same frame instead of a separate one
  (setq ediff-window-setup-function #'ediff-setup-windows-plain)
  ;; diff side by side, not stacked
  (setq ediff-split-window-function #'split-window-horizontally))

;; which-key - show available keybindings in a popup
(use-package which-key
  :ensure nil
  :config
  (which-key-mode +1))

(use-package whitespace
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; third-party packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; color themes

(use-package zenburn-theme
  :defer t)

(use-package catppuccin-theme
  :defer t)

(use-package tokyo-night
  :vc (:url "https://github.com/bbatsov/tokyo-night-emacs" :rev :newest)
  :config
  (load-theme 'tokyo-night-storm t))

(defun nuke-loaded-themes ()
  "Nuke all loaded themes."
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme))
  (message "Themes nuked"))

;;; general purpose utilities

;; diminish - hide minor modes from the mode line
(use-package diminish
  :config
  (diminish 'abbrev-mode)
  (diminish 'eldoc-mode))

;; avy - jump to visible text using a char-based decision tree
(use-package avy
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char)
         ("C-c ." . avy-goto-word-or-subword-1)
         ("C-c ," . avy-goto-char)
         ("M-g l" . avy-goto-line)
         ("M-g w" . avy-goto-word-or-subword-1))
  :config
  (setq avy-background t))

(use-package magit
  :bind (("C-x g" . magit-status)))

;; git-timemachine - step through git revisions of a file
(use-package git-timemachine
  :bind (("C-c g" . git-timemachine)
         ("s-g" . git-timemachine)))

(use-package projectile
  :init
  (setq projectile-project-search-path '("~/projects/" "~/work/" "~/playground"))
  :config
  ;; I typically use this keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  ;; On Linux, however, I usually go with another one
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

;; expand-region, tree-sitter edition
(use-package expreg
  :ensure t
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract))
  :config
  (defvar expreg-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map "=" #'expreg-expand)
      (define-key map "-" #'expreg-contract)
      map))
  (put 'expreg-expand 'repeat-map 'expreg-repeat-map)
  (put 'expreg-contract 'repeat-map 'expreg-repeat-map))

;; elisp-slime-nav - M-. / M-, navigation for Elisp definitions
(use-package elisp-slime-nav
  :config
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook #'elisp-slime-nav-mode))
  (diminish 'elisp-slime-nav-mode))

;; paredit - structural editing for s-expressions
(use-package paredit
  :config
  ;; paredit steals RET for auto-newline-and-indent, which is annoying
  (define-key paredit-mode-map (kbd "RET") nil)
  (add-hook 'paredit-mode-hook (lambda () (electric-pair-local-mode -1)))
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  ;; enable in the *scratch* buffer
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  (diminish 'paredit-mode "()"))

;; anzu - show total search matches and current position in mode line
(use-package anzu
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode))

;; easy-kill - enhanced M-w with easy selection of nearby things
(use-package easy-kill
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill))

;; exec-path-from-shell - sync PATH and env vars from the shell on macOS
(use-package exec-path-from-shell
  :config
  ;; only needed for GUI Emacs on macOS, where the shell env isn't inherited
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

;; move-text - move current line or region up/down
(use-package move-text
  :bind
  (([(meta shift up)] . move-text-up)
   ([(meta shift down)] . move-text-down)))

;; rainbow-delimiters - colorize nested parentheses by depth
(use-package rainbow-delimiters)

;; rainbow-mode - colorize color strings like #ff0000 and rgb(...)
(use-package rainbow-mode
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode)
  (diminish 'rainbow-mode))

(use-package evil
  :config
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>ff") 'projectile-find-file)
  (evil-define-key 'normal 'global (kbd "<leader>fd") 'projectile-find-dir)

  (evil-define-key 'normal 'global (kbd "<leader>pp") 'projectile-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader>pd") 'projectile-discover-projects-in-search-path)
  ;(evil-mode +1)
  :bind (("s-z" . evil-local-mode)))

;; hl-todo - highlight TODO, FIXME, etc. in comments
(use-package hl-todo
  :config
  (setq hl-todo-highlight-punctuation ":")
  (global-hl-todo-mode +1))

;; zop-to-char - visual zap-to-char with preview
(use-package zop-to-char
  :bind (("M-z" . zop-up-to-char)
         ("M-Z" . zop-to-char)))

;; jinx - enchant-based spell checking; much faster than flyspell as it
;; only checks the visible portion of the buffer (needs libenchant,
;; e.g. brew install enchant)
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)
         ("C-c s" . bozhidar-jinx-correct-then-abbrev))
  :custom
  ;; be explicit about the language, as GUI Emacs on macOS doesn't
  ;; inherit LANG from the shell and jinx would end up with the "C"
  ;; locale and no usable dictionaries
  (jinx-languages "en_US")
  :config
  ;; jinx-powered version of `crux-ispell-word-then-abbrev'
  (defun bozhidar-jinx-correct-then-abbrev (p)
    "Correct a misspelled word with jinx, then save the fix as an abbrev.
With prefix P, create a local (mode-specific) abbrev, otherwise a
global one."
    (interactive "P")
    (let (bef aft)
      (letrec ((capture (lambda (overlay word)
                          (setq bef (buffer-substring-no-properties
                                     (overlay-start overlay)
                                     (overlay-end overlay))
                                aft word))))
        ;; `jinx--correct-replace' is the single point through which
        ;; every correction goes, so we tap it to learn what got
        ;; replaced with what
        (advice-add 'jinx--correct-replace :before capture)
        (unwind-protect
            (jinx-correct)
          (advice-remove 'jinx--correct-replace capture)))
      (if (and bef aft (not (string-equal-ignore-case bef aft)))
          (let ((bef (downcase bef))
                (aft (downcase aft)))
            (define-abbrev
              (if p local-abbrev-table global-abbrev-table)
              bef aft)
            (message "\"%s\" now expands to \"%s\" %sally"
                     bef aft (if p "loc" "glob")))
        (user-error "No correction made")))))

(use-package flycheck
  :config
  ;; prefer markdownlint-cli2, which reads repo-level .markdownlint-cli2.yaml
  ;; configs that the older markdownlint-cli checker ignores
  (setq-default flycheck-disabled-checkers '(markdown-markdownlint-cli))
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; flycheck-eldev - flycheck support for Eldev-based Emacs Lisp projects
(use-package flycheck-eldev
  :config
  (setq flycheck-eldev-whitelist
        '("~/projects/cider"
          "~/projects/projectile"
          "~/projects/adoc-mode"
          "~/projects/clojure-mode"
          "~/projects/neocaml"
          "~/projects/inf-clojure"
          "~/projects/clojure-ts-mode")))

;; super-save - auto-save buffers when they lose focus or you switch away
(use-package super-save
  :config
  ;; add integration with ace-window
  (add-to-list 'super-save-triggers 'ace-window)
  (super-save-mode +1)
  (diminish 'super-save-mode))

;; crux - a collection of useful interactive commands
(use-package crux
  :bind (("C-c o" . crux-open-with)
         ("M-o" . crux-smart-open-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-find-file)
         ("C-M-z" . crux-indent-defun)
         ("C-c u" . crux-view-url)
         ("C-c e" . crux-eval-and-replace)
         ("C-c w" . crux-swap-windows)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-buffer-and-file)
         ("C-c t" . crux-visit-term-buffer)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c I" . crux-find-user-init-file)
         ("C-c S" . crux-find-shell-init-file)
         ("s-r" . crux-recentf-find-file)
         ("s-j" . crux-top-join-line)
         ("C-^" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap kill-whole-line] . crux-kill-whole-line)))

;; diff-hl - highlight uncommitted changes in the fringe
(use-package diff-hl
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode))

;; vundo - visualize and navigate the undo history as a tree
;; unlike undo-tree it doesn't replace Emacs's undo system, just
;; provides a visual way to move through it
(use-package vundo
  :bind (("C-x u" . vundo))
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols))

;; undo-fu-session - persist undo history across Emacs sessions
(use-package undo-fu-session
  :config
  (setq undo-fu-session-directory (expand-file-name "undo-fu-session" bozhidar-savefile-dir))
  (undo-fu-session-global-mode +1))

;; when splitting a window, resize all windows proportionally
;; instead of just shrinking the current one
(setq window-combination-resize t)

;; ace-window - quickly switch between windows using number labels
(use-package ace-window
  :config
  (global-set-key (kbd "s-w") 'ace-window)
  (global-set-key [remap other-window] 'ace-window))

;; FIXME: Figure out why the vterm module stopped compiling properly
;; (use-package vterm
;;   :ensure t
;;   :config
;;   (setq vterm-shell "/bin/bash")
;;   ;; macOS
;;   (global-set-key (kbd "s-v") 'vterm)
;;   ;; Linux
;;   (global-set-key (kbd "C-c v") 'vterm))

;; keycast - display current command and its keybinding in the mode line
(use-package keycast)

;; gif-screencast - record GIF screencasts directly from Emacs
(use-package gif-screencast
  :config
  ;; To shut up the shutter sound of `screencapture' (see `gif-screencast-command').
  (setq gif-screencast-args '("-x"))
  ;; Optional: Used to crop the capture to the Emacs frame.
  (setq gif-screencast-cropping-program "mogrify")
  ;; Optional: Required to crop captured images.
  (setq gif-screencast-capture-format "ppm"))

;; temporarily highlight changes from yanking, etc
(use-package volatile-highlights
  :config
  (volatile-highlights-mode +1)
  (diminish 'volatile-highlights-mode))

;;;;; Completion setup

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Either bind `marginalia-cycle' globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; A few more useful configurations for Vertico
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; hide commands in M-x which do not work in the current mode
  (setq read-extended-command-predicate
        #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :bind (
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("s-i" . consult-imenu)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)))

;; embark - context actions on minibuffer candidates and things at point
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  ;; use embark to browse the available keybindings for a prefix (C-h
  ;; after the prefix), instead of the bare completing-read
  (setq prefix-help-command #'embark-prefix-help-command))

;; embark-consult - integration between embark and consult
;; (e.g. embark-export from consult-ripgrep into a grep buffer)
(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; wgrep - edit grep/occur buffers and apply the changes to the files
;; (press C-c C-p in a grep buffer, edit, then C-c C-e to apply)
(use-package wgrep
  :config
  ;; save the affected buffers automatically after applying the edits
  (setq wgrep-auto-save-buffer t))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :init
  (global-corfu-mode)
  ;; show candidate documentation in a popup next to the completions
  (corfu-popupinfo-mode +1))

;; cape - extra completion-at-point backends to feed corfu
(use-package cape
  :init
  ;; complete words from the current buffers and file names everywhere,
  ;; in addition to whatever the major mode's capf offers
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Programming modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; copilot - GitHub Copilot integration
(use-package copilot
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ("C-TAB" . copilot-accept-completion-by-word)
              ("C-<tab>" . copilot-accept-completion-by-word)
              ("C-n" . copilot-next-completion)
              ("C-p" . copilot-previous-completion)))

(use-package elisp-mode
  :ensure nil ; not a real package
  :config
  (defun bozhidar-visit-ielm ()
    "Switch to default `ielm' buffer.
Start `ielm' if it's not already running."
    (interactive)
    (require 'crux)
    (crux-start-or-switch-to 'ielm "*ielm*"))

  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (define-key emacs-lisp-mode-map (kbd "C-c C-z") #'bozhidar-visit-ielm)
  (define-key emacs-lisp-mode-map (kbd "C-c C-c") #'eval-defun)
  (define-key emacs-lisp-mode-map (kbd "C-c C-b") #'eval-buffer))

(use-package ielm
  :config
  (add-hook 'ielm-mode-hook #'rainbow-delimiters-mode))

;; Eask is the successor of Cask
(use-package eask-mode)

(use-package eglot
  :config
  ;; shut down LSP server when last managed buffer is killed
  (setq eglot-autoshutdown t))

;; inf-ruby - run a Ruby REPL inside Emacs
(use-package inf-ruby
  :config
  (add-hook 'ruby-mode-hook #'inf-ruby-minor-mode))

(use-package ruby-mode
  :config
  ;; Ruby 2.0+ doesn't need the -*- coding: utf-8 -*- magic comment
  (setq ruby-insert-encoding-magic-comment nil)
  (add-hook 'ruby-mode-hook #'subword-mode))

(use-package clojure-mode
  :config
  ;; teach clojure-mode about some macros that I use on projects like
  ;; nREPL and Orchard
  (define-clojure-indent
    (returning 1)
    (testing-dynamic 1)
    (testing-print 1))

  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

;; inf-clojure - basic Clojure REPL interaction (no nREPL required)
(use-package inf-clojure
  :config
  (add-hook 'inf-clojure-mode-hook #'paredit-mode)
  (add-hook 'inf-clojure-mode-hook #'rainbow-delimiters-mode))

;; cider - full-featured Clojure IDE powered by nREPL
(use-package cider
  :config
  ;; log nREPL messages for debugging connection issues
  (setq nrepl-log-messages t)
  ;; auto-download Java sources for navigation/documentation
  (setq cider-download-java-sources t)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode))

(use-package port
  :vc (:url "https://github.com/clojure-emacs/port" :lisp-dir "lisp" :branch "main" :rev :newest))

(use-package neat
  :vc (:url "https://github.com/nrepl/neat" :branch "main" :rev :newest)
  :commands (neat neat-mode))

;; flycheck-joker - Clojure linting via the Joker interpreter
(use-package flycheck-joker)

(add-hook 'elixir-ts-mode-hook #'subword-mode)

(use-package erlang
  :config
  (when (eq system-type 'windows-nt)
    (setq erlang-root-dir "C:/Program Files/erl7.2")
    (add-to-list 'exec-path "C:/Program Files/erl7.2/bin")))

(use-package haskell-mode
  :config
  (add-hook 'haskell-mode-hook #'subword-mode)
  (add-hook 'haskell-mode-hook #'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook #'haskell-doc-mode))

(use-package fsharp-ts-mode
  :defer t
  :config
  (add-hook 'fsharp-ts-mode-hook #'eglot-ensure))

;;;; OCaml support

;; neocaml - tree-sitter based OCaml major mode
(use-package neocaml
  :vc (:url "https://github.com/bbatsov/neocaml" :rev :newest)
  :config
  ;; register neocaml-mode with eglot so it launches ocamllsp
  (add-to-list 'eglot-server-programs '((neocaml-mode :language-id "ocaml") . ("ocamllsp")))
  (add-hook 'neocaml-mode-hook #'neocaml-repl-minor-mode)
  (setq neocaml--debug nil))

;; (use-package tuareg
;;   :mode (("\\.ocamlinit\\'" . tuareg-mode)))

;; (use-package dune)

;; ;; Merlin configuration
;; (use-package merlin
;;   :config
;;   (add-hook 'tuareg-mode-hook #'merlin-mode)
;;   ;; (add-hook 'merlin-mode-hook #'company-mode)
;;   ;; we're using flycheck instead
;;   (setq merlin-error-after-save nil))

;; (use-package merlin-eldoc
;;   :hook ((tuareg-mode) . merlin-eldoc-setup))

;; ;; This uses Merlin internally
;; (use-package flycheck-ocaml
;;   :config
;;   (flycheck-ocaml-setup))

;; ;; utop configuration
;; (use-package utop
;;   :config
;;   (add-hook 'tuareg-mode-hook #'utop-minor-mode))

;;;; Markup languages support

;; web-mode - major mode for editing web templates (ERB, EJS, Handlebars, etc.)
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.hbs\\'" . web-mode))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :config
  ;; syntax-highlight code inside fenced blocks
  (setq markdown-fontify-code-blocks-natively t)
  ;; no space between ``` and the language name
  (setq markdown-spaces-after-code-fence 0)
  :preface
  (defun jekyll-insert-image-url ()
    (interactive)
    (let* ((files (directory-files "../assets/images"))
           (selected-file (completing-read "Select image: " files nil t)))
      (insert (format "![%s](/assets/images/%s)" selected-file selected-file))))

  (defun jekyll-insert-post-url ()
    (interactive)
    (let* ((project-root (projectile-project-root))
           (posts-dir (expand-file-name "_posts" project-root))
           (default-directory posts-dir))
      (let* ((files (remove "." (mapcar #'file-name-sans-extension (directory-files "."))))
             (selected-file (completing-read "Select article: " files nil t)))
        (insert (format "{%% post_url %s %%}" selected-file))))))

;; asciidoc-mode - tree-sitter based AsciiDoc major mode
(use-package asciidoc-mode)


;; WSL-specific setup
(when (and (eq system-type 'gnu/linux)
           (getenv "WSLENV"))

  ;; pgtk is only available in Emacs 29+
  ;; without it Emacs fonts don't scale properly on
  ;; HiDPI display
  (when (< emacs-major-version 29)
    (set-frame-font "Inconsolata 28" t t))

  ;; Teach Emacs how to open links in your default Windows browser
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
        (cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
            browse-url-generic-args     cmd-args
            browse-url-browser-function 'browse-url-generic
            search-web-default-browser 'browse-url-generic))))

;; Windows-specific setup
(when (eq system-type 'windows-nt)
  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super) ; Left Windows key

  (setq w32-pass-rwindow-to-system nil)
  (setq w32-rwindow-modifier 'super) ; Right Windows key

  (setq w32-pass-apps-to-system nil)
  (setq w32-apps-modifier 'hyper) ; Menu/App key

  (set-frame-font "Cascadia Code 14")
  (add-to-list 'exec-path "C:/Program Files/Git/bin")
  (add-to-list 'exec-path "C:/Program Files/Git/mingw64/bin")
  (setenv "PATH" (concat "C:/Program Files/Git/bin;" "C:/Program Files/Git/mingw64/bin;" (getenv "PATH")))
  ;; needed for arc-mode
  (add-to-list 'exec-path "C:/Program Files/7-Zip"))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
