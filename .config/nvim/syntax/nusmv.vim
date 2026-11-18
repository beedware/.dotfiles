if exists("b:current_syntax")
  finish
endif

syntax case match
syntax iskeyword @,48-57,_,36,35,45

syntax keyword nusmvKeyword MODULE DEFINE MDEFINE CONSTANTS VAR IVAR FROZENVAR
syntax keyword nusmvKeyword ASSIGN INIT TRANS INVAR FAIRNESS JUSTICE COMPASSION
syntax keyword nusmvKeyword SPEC CTLSPEC LTLSPEC INVARSPEC COMPUTE
syntax keyword nusmvKeyword ISA CONSTRAINT SIMPWFF CTLWFF LTLWFF PSLWFF COMPWFF
syntax keyword nusmvKeyword NAME IN MIRROR PRED PREDICATES process
syntax match nusmvConditional "\<\%(case\|esac\)\>"
syntax keyword nusmvType boolean integer real word array of
syntax match nusmvType "\<\%(signed\|unsigned\)\>"
syntax keyword nusmvBoolean TRUE FALSE
syntax keyword nusmvSpecial self
syntax keyword nusmvFunction init bool word1 toint count swconst uwconst
syntax match nusmvFunction "\<next\>"
syntax keyword nusmvFunction extend resize sizeof abs min max
syntax match nusmvFunction "\<\%(signed\|unsigned\)\>\ze\s*("
syntax keyword nusmvOperator mod union in xor xnor
syntax keyword nusmvTemporal EX AX EF AF EG AG E A F G U V Y Z H O S T
syntax match nusmvTemporal "\<X\>"
syntax keyword nusmvTemporal EBF ABF EBG ABG BU MIN MAX
syntax match nusmvOperator "[-+*/%=<>!&|?:]"
syntax match nusmvOperator "\V<->\|->\|:=\|::\|<=\|>=\|!=\|==\|<<\|>>\|.."
syntax match nusmvDelimiter "[()\[\]{},;]"
syntax match nusmvNumber "\<\d\+\>"
syntax match nusmvNumber "\<0[us]\=[bB]\d*_[01][01_]*\>"
syntax match nusmvNumber "\<0[us]\=[oO]\d*_[0-7][0-7_]*\>"
syntax match nusmvNumber "\<0[us]\=[dD]\d\+_[0-9][0-9_]*\>"
syntax match nusmvNumber "\<0[us]\=[hH]\d*_[0-9a-fA-F][0-9a-fA-F_]*\>"

syntax match nusmvModule "\%(\<MODULE\s\+\)\@<=[A-Za-z_][A-Za-z0-9_$#-]*"
syntax match nusmvModule "\%(\<process\s\+\)\@<=[A-Za-z_][A-Za-z0-9_$#-]*"
syntax match nusmvModule "\%(:\s*\)\@<=[A-Za-z_][A-Za-z0-9_$#-]*\ze\s*("
syntax match nusmvSpecification "\%(\<NAME\s\+\)\@<=[A-Za-z_][A-Za-z0-9_$#-]*"
syntax match nusmvVariable "^\s*\zs\%(TRUE\>\|FALSE\>\)\@![A-Za-z_][A-Za-z0-9_$#-]*\ze\s*:\%([=]\)\@!"
syntax match nusmvDefine "^\s*\zs[A-Za-z_][A-Za-z0-9_$#-]*\ze\s*:="
syntax match nusmvEnum "\<[A-Za-z_][A-Za-z0-9_$#-]*\>" contained
syntax region nusmvEnumSet matchgroup=nusmvDelimiter start="{" end="}" contains=nusmvEnum,nusmvBoolean,nusmvNumber,nusmvComment,nusmvDelimiter
syntax match nusmvDelimiter "\.\%([.]\)\@!\%([.]\)\@<!"

syntax cluster nusmvExpression contains=nusmvKeyword,nusmvConditional,nusmvType,nusmvBoolean,nusmvSpecial,nusmvFunction,nusmvOperator,nusmvTemporal,nusmvDelimiter,nusmvNumber,nusmvComment,nusmvModule,nusmvSpecification,nusmvVariable,nusmvDefine,nusmvEnumSet
syntax region nusmvPSL transparent matchgroup=nusmvKeyword start="\<PSLSPEC\>" end=";" contains=@nusmvExpression,nusmvPSLTemporal,nusmvPSLKeyword,nusmvPSLConstant,nusmvPSLFunction,nusmvPSLOperator,nusmvPSLCase
syntax keyword nusmvPSLTemporal W always never contained
syntax match nusmvPSLTemporal "\<\%(next_a\|next_e\|next_event\|next_event_a\|next_event_e\|until\|before\|within\|whilenot\)\>" contained
syntax match nusmvPSLTemporal "\<\%(until\|before\|within\|whilenot\)_\>" contained
syntax match nusmvPSLTemporal "\<\%(X\|next\|eventually\|next_a\|next_e\|next_event\|next_event_a\|next_event_e\|until\|before\|within\|whilenot\)!_\=\%([A-Za-z0-9_$#-]\)\@!" contained
syntax keyword nusmvPSLKeyword forall abort contained
syntax keyword nusmvPSLConstant inf contained
syntax keyword nusmvPSLFunction select contained
syntax match nusmvPSLOperator "\V|->\||=>\|&&" contained
syntax region nusmvPSLCase transparent matchgroup=nusmvConditional start="\<case\>" end="\<endcase\>" contained contains=@nusmvExpression,nusmvPSLTemporal,nusmvPSLKeyword,nusmvPSLConstant,nusmvPSLFunction,nusmvPSLOperator,nusmvPSLCase

syntax keyword nusmvTodo TODO FIXME XXX NOTE contained
syntax match nusmvComment "--.*$" contains=nusmvTodo,@Spell
syntax region nusmvComment start="/--" end="--/" contains=nusmvTodo,@Spell
syntax sync minlines=100

highlight default link nusmvKeyword Keyword
highlight default link nusmvModule Type
highlight default link nusmvSpecification Label
highlight default link nusmvVariable Identifier
highlight default link nusmvDefine Function
highlight default link nusmvEnum Constant
highlight default link nusmvConditional Conditional
highlight default link nusmvType Type
highlight default link nusmvBoolean Boolean
highlight default link nusmvFunction Function
highlight default link nusmvSpecial Special
highlight default link nusmvDelimiter Delimiter
highlight default link nusmvPSLTemporal Operator
highlight default link nusmvPSLKeyword Keyword
highlight default link nusmvPSLConstant Constant
highlight default link nusmvPSLFunction Function
highlight default link nusmvPSLOperator Operator
highlight default link nusmvOperator Operator
highlight default link nusmvTemporal Operator
highlight default link nusmvNumber Number
highlight default link nusmvComment Comment
highlight default link nusmvTodo Todo

let b:current_syntax = "nusmv"
