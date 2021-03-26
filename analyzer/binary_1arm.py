#for tenda
import angr
import re
from kingcore.color import Color
#p = angr.Project('../tests/httpd_ac15', load_options={'auto_load_libs': False})
#obj = p.loader.main_object
def getintfromaddr(p, addr):
	memory = p.loader.memory
	ans = 0
	for i in range(4):
		current = memory[addr + i]	        
		ans += current << (i * 8)
	return ans
def getstringfromaddr(p, addr):
	memory = p.loader.memory
	ans = ""
	i = 0
	current = memory[addr]
	while(current):
		current = memory[addr + i]	        
		ans += chr(current)        
		i += 1
	if(ans[-1:] == '\x00'):
		ans = ans[:-1]
	if(ans):
		return ans
def getsectionaddr(obj, section_name):	
	s = str(obj.sections)
	x = s.find('vaddr ', s.find('<' + section_name))
	y = s.find(',', x)
	addr = s[x + 6 : y]
	addr = int(addr, 16)
	return addr
def getdisasm(func):
	address_table = []
	mnemonic_table = []
	op_str_table = []
	for block in func.blocks:
		for i in range(len(block.capstone.insns)):
			address_table.append(block.capstone.insns[i].address)
			mnemonic_table.append(block.capstone.insns[i].mnemonic)
			op_str_table.append(block.capstone.insns[i].op_str)
	return address_table, mnemonic_table, op_str_table
def getinsfromaddr(func, addr):
	for block in func.blocks:
		for i in range(len(block.capstone.insns)):
			if(block.capstone.insns[i].address == addr):
				return block.capstone.insns[i].mnemonic + ' ' + block.capstone.insns[i].op_str
def getaddrfromins(func, mnemonic, op_str):
	addrs = []
	for block in func.blocks:
		for i in range(len(block.capstone.insns)):
			if((block.capstone.insns[i].mnemonic == mnemonic) and (block.capstone.insns[i].op_str == op_str)):
				addrs.append(block.capstone.insns[i].address)
	return addrs
def getformfunctionstrings_arm(p, func):
	obj = p.loader.main_object
	got_addr = getsectionaddr(obj, '.got')
	ans = []
	targets = getaddrfromins(func, 'add', 'r3, r4, r3')
	for target in targets:
		ins = getinsfromaddr(func, target-4)
		x = ins.find('#')
		y = ins.find(']')
		imm = int(ins[x + 1 : y], 16)
		tmpoffset = getintfromaddr(p, target + 4 + imm)
		postparam_addr = (tmpoffset + got_addr) % 0x100000000
		onestring = getstringfromaddr(p, postparam_addr)
		if(onestring):
			if((onestring.isalpha()) and (onestring != 'true') and (onestring != 'false') and (onestring != 'none')):
				ans.append(onestring)
	return ans
def scanexecutable_arm(p, result_save_folder=None):
	if(result_save_folder != None):
		form_functions_info = open(result_save_folder + 'FHF_info.txt', 'w')
	obj = p.loader.main_object
	got_addr = getsectionaddr(obj, '.got')
	cfg = p.analyses.CFGFast(data_references=True, cross_references=True)
	func_lists = cfg.kb.functions
	form_name_lists = []
	form_func_params= []
	func_count = 0
	form_func_count = 0
	param_count = 0
	for func_address in func_lists:   
		func_count += 1
		func = func_lists[func_address]
		funcname = func.name
		if(re.search('telnet', funcname, flags=re.IGNORECASE)):
			print("\n\n\n{}".format(Color.GREEN))
			print("Telnet interface found!!!")
			if(result_save_folder != None):
				form_functions_info.write("\n\nTelnet interface found!!!\n")
		if(funcname[:4] == 'form'):
			form_func_count += 1
			xref = list(p.kb.xrefs.get_xrefs_by_dst(func_address))
			if(xref == []):
				continue
			xref_address = xref[0].ins_addr
			print(hex(xref_address))
			xref_code = getintfromaddr(p, xref_address - 16)
			imm = xref_code % 0x1000
			if((xref_code >> 16) % 0x100 == 0x9f):
				tmpoffset = getintfromaddr(p, xref_address - 8 + imm)
				formname_addr = (tmpoffset + got_addr) % 0x100000000
			elif((xref_code >> 16) % 0x100 == 0x1f):
				tmpoffset = getintfromaddr(p, xref_address - 8 - imm)
				formname_addr = (tmpoffset + got_addr) % 0x100000000
			else:
				continue
			formname = getstringfromaddr(p, formname_addr)		
			form_name_lists.append(formname)	
			print("\n{}".format(Color.GREEN))
			print(funcname)
			print(formname)
			print("\n{}".format(Color.RED))
			stringinform = getformfunctionstrings_arm(p, func_lists[func_address])
			form_func_params.append(stringinform)
			param_count += 1
			print(stringinform)
			if(result_save_folder != None):
				form_functions_info.write("\n\nfunction name:" + funcname + '\n')
				form_functions_info.write("form name:" + formname + '\n\n')
			for eachcall in func.get_call_sites():
				call_target_func = func_lists[func.get_call_target(eachcall)]
				if(call_target_func.name == "strcpy"):
					print("strcpy called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("strcpy called in " + funcname + '\n')
				if(call_target_func.name == "sprintf"):
					print("sprintf called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("sprintf called in " + funcname + '\n')
				if(call_target_func.name == "gets"):
					print("gets called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("gets called in " + funcname + '\n')
				if(call_target_func.name == "strcat"):
					print("strcat called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("strcat called in " + funcname + '\n')
				if(call_target_func.name == "memcpy"):
					print("memcpy called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("memcpy called in " + funcname + '\n')
				if(call_target_func.name == "system"):
					print("system called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("system called in " + funcname + '\n')
				if(call_target_func.name == "eval"):
					print("eval called in %s" % (funcname))
					if(result_save_folder != None):
						form_functions_info.write("eval called in " + funcname + '\n')
				if(re.search('system', call_target_func.name, flags=re.IGNORECASE)):
					print("%s called in %s" % (call_target_func.name, funcname))
					if(result_save_folder != None):
						form_functions_info.write(call_target_func.name + " called in " + funcname + '\n')
				if(re.search('exec', call_target_func.name, flags=re.IGNORECASE)):
					print("%s called in %s" % (call_target_func.name, funcname))
					if(result_save_folder != None):
						form_functions_info.write(call_target_func.name + " called in " + funcname + '\n')
	print("\n\n{}".format(Color.END))
	print("%d functions Identified." % (func_count))
	print("%d form functions Identified." % (form_func_count))
	print("%d form parameters Identified." % (param_count))
	if(result_save_folder != None):
		form_functions_info.write(str(func_count) + "functions Identified.\n")
		form_functions_info.write(str(form_func_count) + "form functions Identified.\n")
		form_functions_info.close()
	return form_name_lists, form_func_params


