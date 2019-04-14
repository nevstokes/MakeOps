ifndef ANSI
ANSI := $(shell test $$(command -v tput >/dev/null 2>&1 && tput colors || echo 0) -ge 8 && echo 1)
endif

ifeq ($(ANSI),1)
STYLE_reset = \033[0m

STYLE__COLOR_red = 31
STYLE__COLOR_green = 32
STYLE__COLOR_yellow = 33
STYLE__COLOR_blue = 34
STYLE__COLOR_cyan = 36

STYLE__normal = 0
STYLE__bold = 1
STYLE__faint = 2
STYLE__italic = 3
STYLE__underline = 4

# Declare STYLE_* variants
__ := $(foreach color,red green yellow blue cyan, \
		$(eval STYLE_$(color)=\033[$(STYLE__normal);$(STYLE__COLOR_$(color))m) \
	;) \
	$(foreach style,normal bold faint italic underline, \
		$(eval STYLE_$(style)=\033[$(STYLE__$(style))m) \
	;) \
;)

STYLE_success = $(STYLE_green)
STYLE_info = $(STYLE_yellow)
STYLE_error = $(STYLE_red)
endif

define style #(text,style)
@printf "$(2)%s$(STYLE_reset)\n" $(1)
endef
