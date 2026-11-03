if exists("b:current_syntax")
  finish
endif

syntax case match

syntax keyword nusmvKeyword MODULE DEFINE MDEFINE CONSTANTS VAR IVAR FROZENVAR
syntax keyword nusmvKeyword ASSIGN INIT TRANS INVAR FAIRNESS JUSTICE COMPASSION
syntax keyword nusmvKeyword SPEC CTLSPEC LTLSPEC PSLSPEC INVARSPEC COMPUTE
syntax keyword nusmvKeyword ISA CONSTRAINT SIMPWFF CTLWFF LTLWFF PSLWFF
syntax keyword nusmvConditional case esac
syntax keyword nusmvType boolean integer real word array of signed unsigned
syntax keyword nusmvBoolean TRUE FALSE
syntax keyword nusmvFunction init next self bool word1 toint count swconst uwconst
syntax keyword nusmvFunction signed unsigned extend resize sizeof floor min max
syntax keyword nusmvOperator mod union in xor xnor
syntax keyword nusmvTemporal EX AX EF AF EG AG E A X F G U V Y Z H O S T
syntax keyword nusmvTemporal EBF ABF EBG ABG EBU ABU MIN MAX
syntax match nusmvOperator "[-+*/=<>!&|?:]"
syntax match nusmvNumber "\<\d\+\>"
syntax match nusmvNumber "\<\d\+\.\d\+\>"
syntax match nusmvNumber "\<0[us]\=[bodh]_[0-9]\+_[0-9a-fA-F_]\+\>"
syntax region nusmvString start=+"+ skip=+\\.+ end=+"+
syntax keyword nusmvTodo TODO FIXME XXX NOTE contained
syntax match nusmvComment "--.*$" contains=nusmvTodo,@Spell

highlight default link nusmvKeyword Keyword
highlight default link nusmvConditional Conditional
highlight default link nusmvType Type
highlight default link nusmvBoolean Boolean
highlight default link nusmvFunction Function
highlight default link nusmvOperator Operator
highlight default link nusmvTemporal Operator
highlight default link nusmvNumber Number
highlight default link nusmvString String
highlight default link nusmvComment Comment
highlight default link nusmvTodo Todo

let b:current_syntax = "nusmv"
