#!/bin/bash
gvim -v -c 'exec ".!echo -ne '"'"'done.\\n----'"'"' | figlet | grep -v '"'"'^ *$'"'"'" | vne | exec ".!echo -ne '"'"'TODO\\n----'"'"' | figlet | grep -v '"'"'^ *$'"'"'"'
