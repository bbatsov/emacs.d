;;; early-init.el --- Bozhidar's Emacs early init file
;;
;; Copyright (c) 2016-2026 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.dev>
;; URL: https://github.com/bbatsov/emacs.d

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Settings that have to be applied before the initial frame is
;; created and before package.el is initialized.

;;; Code:

;; raise the GC threshold for the duration of startup, so we don't pay
;; for repeated garbage collections while packages are being loaded;
;; restore a modest threshold afterwards (a permanently huge threshold
;; trades frequent short pauses for rare long freezes)
(setq gc-cons-threshold most-positive-fixnum)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1000 1000) ; 50MB
                  gc-cons-percentage 0.2)))

;; the toolbar is just a waste of valuable screen estate; disabling it
;; via frame parameters here means the initial frame is never created
;; with one (calling tool-bar-mode later forces a frame resize)
(push '(tool-bar-lines . 0) default-frame-alist)

;; maximize the initial frame automatically
(push '(fullscreen . maximized) initial-frame-alist)

;; don't resize the frame in response to font/UI changes during
;; startup - it's expensive and pointless before the frame is visible
(setq frame-inhibit-implied-resize t)

;; native-compile packages when they are installed, instead of
;; stalling when they get loaded for the first time
(setq package-native-compile t)

;; GUI Emacs on macOS doesn't inherit the environment from the shell,
;; so without LANG it ends up in the "C" locale, which breaks things
;; like spell-checking dictionaries and subprocess sorting
(when (and (eq system-type 'darwin) (not (getenv "LANG")))
  (setenv "LANG" "en_US.UTF-8"))

;;; early-init.el ends here
