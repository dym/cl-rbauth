; -*- coding: utf-8; mode: common-lisp; -*-

(in-package :rbauth)

(defparameter *key-prefix* "rbauth_")

(defun build-key (key)
  (format nil "~a~a" *key-prefix* key))

(defun parse-value (value)
  (split-sequence #\: value))

(defun create-value (username token session first-name last-name)
  (format nil "~a:~a:~a:~a:~a"
          username token session first-name last-name))

(defun get-value (account)
  (redis:with-connection ()
    (redis:red-get account)))

(defun delete-session (account)
  (let* ((value (get-value account))
         (parsed-value (parse-value value)))
    (redis:with-connection ()
      (redis:red-set account
                     (create-value (elt parsed-value 0)
                                   (elt parsed-value 1)
                                   nil
                                   (elt parsed-value 3)
                                   (elt parsed-value 4))))))


(defun return-all-accounts ()
  (redis:with-connection ()
    (redis:red-keys (format nil "~a*" *key-prefix*))))

(defun get-session (account)
  (redis:with-connection ()
    (elt (parse-value (redis:red-get account)) 2)))

(defun find-account (session)
  (iter (for account in (return-all-accounts))
        (if (equal session
                   (get-session account))
            (return account))))

;;;; External API
(defun generate-session (username)
  (format nil "~(~{~2,'0X~}~)"
          (map 'list #'identity
               (md5:md5sum-sequence (format nil "~a-~a"
                                            username
                                            (now))))))

(defun login (username token session &key first-name last-name)
  (redis:with-connection ()
    (redis:red-set (build-key username)
                   (create-value username token session first-name last-name))))

(defun logout (session)
  (let ((account (find-account session)))
    (if account (delete-session account))))

(defun authenticated-p (session)
  (if (find-account session)
      t))

(defun get-username (session)
  (let ((account (find-account session)))
    (if account
        (elt (parse-value (get-value account)) 0))))

(defun get-token (session)
  (let ((account (find-account session)))
    (if account
        (elt (parse-value (get-value account)) 1))))