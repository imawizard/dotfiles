(import-macros {: use! : gset!} :macros)

(use!
 ;; See :help test.txt.
 {:cmd [:TestFile
        :TestSuite
        :TestClass
        :TestNearest
        :TestLast
        :TestVisit]}
 :vim-test/vim-test)

(gset!
 test#preserve_screen 0
 test#strategy        "toggleterm")
