;; -*- lexical-binding: t; -*-

;; defaults to ChatGPT, using ~/.authinfo
(use-package gptel)

(setq my-llama
      (gptel-make-ollama "Llama"
        :host "localhost:11434"
	      :stream t
        :models '(llama3)))

(setq my-gemma
      (gptel-make-ollama "Gemma"
        :host "localhost:11434"
	      :stream t
        :models '(gemma:7b)))

;; OPTIONAL configuration
;; (setq gptel-model 'mistral:latest
;;       gptel-backend my-llama)

(provide 'init-ai)
