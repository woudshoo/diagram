(diagram
 (node b "box")
 (node h "h-mode-mixin")
 (node c "cast")
 (file-node f ".csv" "A nice file")
 (-o b h)
 (<- b h)
 (<- b f)
 (-- b c)
 (<-> b c))

