; -*- coding: utf-8; mode: common-lisp; -*-

(defpackage :rbauth-asd
  (:use :cl
        :asdf))

(in-package :rbauth-asd)

(defsystem rbauth
  :name "Redis Based Auth"
  :version "0.0.0"
  :author "Dmitriy Budashny <dmitriy.budashny@gmail.com>"
  :license "BSD"
  :components
  ((:module "src"
            :components
            ((:file "packages")
             (:file "rbauth" :depends-on ("packages")))))
  :depends-on (#:cl-redis #:split-sequence #:iterate #:md5
                          #:local-time))