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
  (setq projectile-project-search-path '(
                                         ("~/lscg" . 2)
                                         ("~/underdog" . 2)
                                         ("~/projects" . 2)
                                         )))

(defun +my/open-wezterm-here ()
  (interactive)
  (let* ((project-root (when (fboundp 'projectile-project-root)
                         (ignore-errors (projectile-project-root))))
         (dir (expand-file-name (or project-root default-directory))))
    (if-let ((wezterm (executable-find "wezterm")))
        (start-process "wezterm" nil wezterm "start" "--cwd" dir)
      (start-process "open-wezterm" nil "open" "-na" "WezTerm" "--args" "start" "--cwd" dir))))

(map! :leader
      :prefix ("o" . "open")
      :desc "Open WezTerm here" "T" #'+my/open-wezterm-here)

(defvar +my/project-vterm--window-config nil)
(defvar +my/project-vterm--active-buffer nil)
(defvar +my/project-vterm--last-slot (make-hash-table :test #'equal))

(defvar-local +my/project-vterm-slot 1)
(defvar-local +my/project-vterm-project nil)

(defun +my/project-vterm--project-root ()
  (or (when (fboundp 'projectile-project-root)
        (ignore-errors (projectile-project-root)))
      default-directory))

(defun +my/project-vterm--project-name ()
  (file-name-nondirectory
   (directory-file-name
    (expand-file-name (+my/project-vterm--project-root)))))

(defun +my/project-vterm--buffer-name (&optional slot)
  (let ((slot (max 1 (or slot 1)))
        (name (format "vterm:%s" (+my/project-vterm--project-name))))
    (if (> slot 1)
        (format "%s:%d" name slot)
      name)))

(defun +my/project-vterm--buffer-slot (buffer project-name)
  (or (and (buffer-live-p buffer)
           (buffer-local-value '+my/project-vterm-slot buffer))
      (let ((name (and (buffer-live-p buffer) (buffer-name buffer))))
        (if (and name
                 (string-match
                  (format "\\`vterm:%s\\(?::\\([0-9]+\\)\\)?\\'"
                          (regexp-quote project-name))
                  name))
            (if-let ((slot (match-string 1 name)))
                (string-to-number slot)
              1)
          1))))

(defun +my/project-vterm--buffer-project (buffer)
  (when (buffer-live-p buffer)
    (or (buffer-local-value '+my/project-vterm-project buffer)
        (when-let ((name (buffer-name buffer)))
          (when (string-match "\\`vterm:\\([^:]+\\)" name)
            (match-string 1 name))))))

(defun +my/project-vterm--live-buffer-p (buffer)
  (when (buffer-live-p buffer)
    (let ((proc (get-buffer-process buffer)))
      (and proc (process-live-p proc)))))

(defun +my/project-vterm--ensure-buffer (project-name slot)
  (let* ((name (+my/project-vterm--buffer-name slot))
         (buffer (get-buffer name))
        (default-directory (+my/project-vterm--project-root)))
    (when (and buffer (not (+my/project-vterm--live-buffer-p buffer)))
      (kill-buffer buffer)
      (setq buffer nil))
    (setq buffer
          (or buffer
              (save-window-excursion
                (vterm name))))
    (when (buffer-live-p buffer)
      (with-current-buffer buffer
        (setq-local +my/project-vterm-slot slot)
        (setq-local +my/project-vterm-project project-name)))
    buffer))

(defun +my/project-vterm-toggle (&optional arg)
  (interactive "P")
  (let* ((project-name (+my/project-vterm--project-name))
         (project-prefix (format "vterm:%s" project-name))
         (slot
          (cond
           (arg (max 1 (prefix-numeric-value arg)))
           ((and (derived-mode-p 'vterm-mode)
                 (string-prefix-p project-prefix (buffer-name (current-buffer))))
            (+my/project-vterm--buffer-slot (current-buffer) project-name))
           ((and (buffer-live-p +my/project-vterm--active-buffer)
                 (get-buffer-window +my/project-vterm--active-buffer (selected-frame))
                 (equal (+my/project-vterm--buffer-project +my/project-vterm--active-buffer)
                        project-name))
            (+my/project-vterm--buffer-slot +my/project-vterm--active-buffer project-name))
           (t
            (or (gethash project-name +my/project-vterm--last-slot) 1))))
         (buffer
          (+my/project-vterm--ensure-buffer project-name slot))
         (buffer-window (get-buffer-window buffer (selected-frame))))
    (puthash project-name slot +my/project-vterm--last-slot)
    (if (and (eq buffer +my/project-vterm--active-buffer)
             +my/project-vterm--window-config
             buffer-window)
        (progn
          (set-window-configuration +my/project-vterm--window-config)
          (setq +my/project-vterm--window-config nil
                +my/project-vterm--active-buffer nil))
      (unless (and +my/project-vterm--window-config
                   (buffer-live-p +my/project-vterm--active-buffer)
                   (get-buffer-window +my/project-vterm--active-buffer (selected-frame)))
        (setq +my/project-vterm--window-config (current-window-configuration)))
      (setq +my/project-vterm--active-buffer buffer)
      (switch-to-buffer buffer)
      (delete-other-windows))))

(global-set-key (kbd "C-\\") #'+my/project-vterm-toggle)

(after! evil
  (define-key evil-normal-state-map (kbd "C-\\") #'+my/project-vterm-toggle)
  (define-key evil-insert-state-map (kbd "C-\\") #'+my/project-vterm-toggle)
  (define-key evil-visual-state-map (kbd "C-\\") #'+my/project-vterm-toggle))

(after! vterm
  (add-to-list 'vterm-keymap-exceptions "C-\\")
  (define-key vterm-mode-map (kbd "C-\\") #'+my/project-vterm-toggle))
