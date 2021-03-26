#for tenda
import angr
import re
import sys
import os
import argparse
from analyzer.binary_4 import *
from kingcore.color import Color

if len(sys.argv) < 3:
    sys.argv.append('-h')
desc =  "======== Firmking Scanner =========="
epi = "==" * 26 + '\n'
parser = argparse.ArgumentParser(description=desc,epilog=epi)
parser.add_argument("template_file", help="Template .fu file")
parser.add_argument("result_save_folder", help="Path to save result")
parser.add_argument("target_binary", help="Target binary")
args = parser.parse_args()
template = args.template_file
folder = args.result_save_folder
target_binary = args.target_binary
if(folder[-1:] == '/'):
	result_save_folder = folder
else:
	result_save_folder = folder + '/'

p = angr.Project(target_binary, load_options={'auto_load_libs': False})
obj = p.loader.main_object

if('ARM' in str(p.arch)):
  form_name_lists, form_func_params = scanexecutable_arm(p, result_save_folder)
  tempf = open(template, 'r')
  fucontent = tempf.read()
  tempf.close()
  for i in range(len(form_name_lists)):
  	if(form_name_lists[i] == None):
  		continue
  	ftext = open(result_save_folder + form_name_lists[i] + '.fu', 'w')
  	final_content = fucontent.replace('formname', form_name_lists[i])
  	for j in range(len(form_func_params[i])):
  		final_content = final_content.replace('arg' + str(j), form_func_params[i][j])
  	ftext.write(final_content)
  	ftext.close()
   
if('MIPS' in str(p.arch)):
  cfg = p.analyses.CFGFast()
  form_name_lists, form_func_params = scanexecutable_mips(p, cfg, result_save_folder)
  tempf = open(template, 'r')
  fucontent = tempf.read()
  tempf.close()
  for i in range(len(form_name_lists)):
  	if(form_name_lists[i] == None):
  		continue
  	ftext = open(result_save_folder + form_name_lists[i] + '.fu', 'w')
  	final_content = fucontent.replace('formname', form_name_lists[i])
  	for j in range(len(form_func_params[i])):
  		final_content = final_content.replace('arg' + str(j), form_func_params[i][j])
  	ftext.write(final_content)
  	ftext.close()




