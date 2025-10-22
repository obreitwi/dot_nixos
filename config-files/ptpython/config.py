#!/usr/bin/env python
# encoding: utf-8

# Refer to upstream for all options:
# https://github.com/prompt-toolkit/ptpython/blob/master/examples/ptpython_config/config.py

__all__ = ["configure"]

def configure(repl):
    repl.vi_mode = True
    repl.color_depth = "DEPTH_24_BIT"
    repl.vi_start_in_navigation_mode = True
    repl.prompt_style = "ipython"

