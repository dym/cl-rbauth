; -*- coding: utf-8; mode: common-lisp; -*-

(in-package :cl-user)

(defpackage :rbauth
  (:use :common-lisp
        :split-sequence
        :iter
        :md5
        :local-time)
  (:export :login
           :logout
           :generate-session
           :authenticated-p
           :get-username
           :get-token
           :get-first-name
           :get-last-name))
