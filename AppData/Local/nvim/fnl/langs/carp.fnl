(let [parsers (require :nvim-treesitter.parsers)
      ft_to_parser parsers.filetype_to_parsername]
  (set ft_to_parser.carp "fennel"))
