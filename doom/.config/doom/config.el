;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


(after! exec-path-from-shell
  (exec-path-from-shell-initialize))

(after! lsp-mode
  (setq lsp-auto-guess-root t))

(setq-default indent-tabs-mode nil   ; expandtab
              tab-width 2            ; tabstop
              standard-indent 2      ; shiftwidth
              evil-shift-width 2)    ; shiftwidth for evil's < and > operators

(setq scroll-margin 8)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

(setq doom-font (font-spec
                 :family "Pragmasevka Nerd Font"
                 :size 20))

(setq-default line-spacing 0.3)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-rouge)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :n "gr" #'+lookup/references)
(map! :leader "s g" #'consult-ripgrep)

(map! :leader
      (:prefix ("g m" . "smerge")
       :desc "Keep mine (upper)"   "m" #'smerge-keep-upper
       :desc "Keep theirs (lower)" "t" #'smerge-keep-lower
       :desc "Keep both"           "b" #'smerge-keep-all
       :desc "Next conflict"       "n" #'smerge-next
       :desc "Previous conflict"   "p" #'smerge-prev))

;; Recenter after buffer scroll
(after! evil
  (dolist (fn '((evil-scroll-down . "C-d")
                (evil-scroll-up . "C-u")
                (evil-scroll-page-down . "C-f")
                (evil-scroll-page-up . "C-b")))
    (advice-add (car fn) :after
                (lambda (&rest _)
                  (recenter)))))

;; Copilot
(use-package! copilot
  :defer t
  :config
  (setq copilot-idle-delay nil)
  (setq copilot-enable-predicates nil))

(after! copilot
  (setq copilot-idle-delay nil)
  (setq copilot-enable-predicates nil)
  (setq copilot-indent-offset-warning-disable t)

  (map! :i "C-c c" #'copilot-complete)

  (define-key copilot-completion-map (kbd "<tab>") #'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "C-n") #'copilot-next-completion)
  (define-key copilot-completion-map (kbd "C-p") #'copilot-previous-completion)
  (define-key copilot-completion-map (kbd "C-k") #'copilot-clear-overlay))

(add-hook! '(prog-mode-hook
             conf-mode-hook
             text-mode-hook)
           #'copilot-mode)

(after! projectile
  (setq projectile-track-known-projects nil)
  (setq projectile-project-search-path '(
                                         ("~/lscg" . 2)
                                         ("~/underdog" . 2)
                                         ("~/projects" . 2)
                                         ))
  (projectile-add-known-project "~/.config/doom/"))

(load! "+terminal")

(use-package! flash
  :commands (flash-jump flash-treesitter)
  :init
  (after! evil
    (require 'flash-evil)
    (flash-evil-setup t))
  :config
  (map! :n "s-j" #'flash-jump)
  (require 'flash-isearch)
  (flash-isearch-mode 1))
