;;; +terminal.el --- Project vterm toggle and WezTerm integration -*- lexical-binding: t; -*-

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

(defun +my/project-vterm--buffer-name (project-name &optional slot)
  (let ((slot (max 1 (or slot 1)))
        (name (format "vterm:%s" project-name)))
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
  (let* ((name (+my/project-vterm--buffer-name project-name slot))
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
  (let* ((project-name
          (or (and (derived-mode-p 'vterm-mode)
                   (bound-and-true-p +my/project-vterm-project))
              (+my/project-vterm--project-name)))
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
