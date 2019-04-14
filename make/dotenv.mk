# scm-safe templated env file extension
DIST ?= dist

# Pattern rule to generate environment files from scm-safe template files
%: %.$(DIST)
ifeq ($(INTERACTIVE),1)
	@while IFS="=" read -r key value <&3; do \
		read -e -i "$$value" -p "$$key: " input; \
		echo "$$key=$${input:-$$value}" >> $@; \
	done 3< <(comm -13 <(test -f $@ && cut -sd= -f1 $@ | sort) <(cut -sd= -f1 $< | sort) | xargs printf ^%s=\\n | grep -f - $< | envsubst)
else
	comm -13 <(test -f $@ && cut -sd= -f1 $@ | sort) <(cut -sd= -f1 $< | sort) | xargs printf ^%s=\\n | grep -f - $< | envsubst >> $@
endif
