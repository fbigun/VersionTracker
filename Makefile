.PHONY: all

all:
	@for dir in $(shell ls -l | grep "^d" | awk '{print $$9}');do \
		if [ -f $${dir}/Makefile ];then \
			cd $${dir}; $(MAKE); cd ..; \
		else \
			echo 'Directory has no buildable targets, Makefile does not exist';\
		fi \
	done
