[(postfix
  ".nn"
  [(d 1 (fn [_ parent]
          (sn 1 [(t [(.. "if " parent.snippet.env.POSTFIX_MATCH " != nil {") "\t"])
                 (i 1)
                 (t [""  "}"])])))])]
