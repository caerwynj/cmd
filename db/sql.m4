ifelse(VER, sybase, `define(_P, $1 $2)')
ifelse(VER, oracle, `define(_P, $1($2))')

_P(arb_drop_fkeys, EMF)
_P(a_proc, `EMF,1,"2",3')
