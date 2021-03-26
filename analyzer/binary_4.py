#for dlink-816
import angr
import re
from kingcore.color import Color
#p = angr.Project('../tests/dir816_111b02', load_options={'auto_load_libs': False})
#obj = p.loader.main_object

def getintfromaddr(p, addr):
	memory = p.loader.memory
	ans = 0
	for i in range(4):
		current = memory[addr + i]	        
		ans += current << (i * 8)
	return ans

def getintfromaddr_big(p, addr):
	memory = p.loader.memory
	ans = 0
	for i in range(4):
		current = memory[addr + i]	        
		ans += current << ((3-i) * 8)
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

def findaddrfromins(func, mnemonic, op_str):
	addrs = []
	for block in func.blocks:
		for i in range(len(block.capstone.insns)):
			if((block.capstone.insns[i].mnemonic == mnemonic) and (op_str in block.capstone.insns[i].op_str)):
				addrs.append(block.capstone.insns[i].address)
	return addrs

def getgp(func):
	gpins = getinsfromaddr(func, func.addr)
	try:
		t = gpins.find('lui $gp, ')
	except:
		return 0
	if(t < 0):
		return 0
	gpimm = int(gpins[t + 9 : ], 16) << 16
	gpins2 = getinsfromaddr(func, func.addr + 4)
	t2 = gpins2.find('addiu $gp, $gp, ')
	gpimm2 = int(gpins2[t2 + 16 : ], 16)
	gp = func.addr + gpimm + gpimm2
	return gp

def getformfunctions(p, cfg):
     forminfos= []
     func_lists = cfg.kb.functions
     for d_address in func_lists:
             func = func_lists[d_address]
             targets = findaddrfromins(func, 'addiu', '$a0, $a0, ')
             print("scan:")
             print(hex(d_address))
             print("\n")
             for target in targets:
                     nextins = getinsfromaddr(func, target + 8)
                     preins1 = getinsfromaddr(func, target - 8)
                     preins2 = getinsfromaddr(func, target - 12)
                     if(preins1 == None or preins2 == None or nextins == None):
                             continue
                     if('addiu $a1, $a1, ' in nextins and 'lw $a1, ' in preins1 and 'lw $a0, ' in preins2 and '($gp)' in preins1 and '($gp)' in preins2):
                             print("table found in:")
                             print(hex(d_address))
                             print("\n")
                             gp = getgp(func)
                             forminfo=[]
                             
                             t = nextins.find('addiu $a1, $a1, ')
                             ttt = int(nextins[t + 16 : ], 16)                             
                             
                             z = preins1.find('lw $a1, ')
                             if(preins1.find('gp') < 0):
                                     continue
                             z2 = preins1.find('(')
                             zzz = int(preins1[z + 8 : z2], 16)
                             if('LE' in str(p.arch)):
                                     zzz = getintfromaddr(p, gp + zzz)
                             if('BE' in str(p.arch)):
                                     zzz = getintfromaddr_big(p, gp + zzz)
                             formaddr = (ttt + zzz) % 0x100000000
                             
                             ins = getinsfromaddr(func, target)
                             y = ins.find('addiu $a0, $a0, ')
                             yyy = int(ins[y + 16 : ], 16)
                             
                             x = preins2.find('lw $v0, ')
                             if(preins2.find('gp') < 0):
                                     continue
                             x2 = preins2.find('(')
                             xxx = int(preins2[x + 8 : x2], 16)
                             if('LE' in str(p.arch)):
                                     xxx = getintfromaddr(p, gp + xxx)
                             if('BE' in str(p.arch)):
                                     xxx = getintfromaddr_big(p, gp + xxx)
                             formname_addr = (yyy + xxx) % 0x100000000
                             onestring = getstringfromaddr(p, formname_addr)
                             if((onestring != None) and (onestring != 'true') and (onestring != 'false') and (onestring != 'none') and ('/' not in onestring)):
                                             forminfo.append(onestring)
                                             forminfo.append(formaddr)
                                             forminfos.append(forminfo)
     return forminfos
		
def getformfunctionstrings_mips(p, func):
	ans = []
	gp = getgp(func)
	if(gp == 0):
	  return ans
	targets = findaddrfromins(func, 'addiu', '$a1, $a1, ')
	for target in targets:
		ins = getinsfromaddr(func, target)
		y = ins.find('addiu $a1, $a1, ')
		yyy = int(ins[y + 16 : ], 16)
		for i in range(5):
		  ins2 = getinsfromaddr(func, target - i * 4)
		  x = ins2.find('lw $a1, ')
		  if(ins2.find('gp') < 0):
		    continue
		  if(ins2.find('lw $a1, ') < 0):
		    continue      
		  x2 = ins2.find('(')
		  xxx = int(ins2[x + 8 : x2], 16)
		  if('LE' in str(p.arch)):
		    xxx = getintfromaddr(p, gp + xxx)
		  if('BE' in str(p.arch)):
		    xxx = getintfromaddr_big(p, gp + xxx)  
		  postparam_addr = (yyy + xxx) % 0x100000000
		  onestring = getstringfromaddr(p, postparam_addr)
		  if((onestring != None) and (onestring.isalpha()) and (onestring != 'true') and (onestring != 'false') and (onestring != 'none')):
		    ans.append(onestring)
		  break
	return ans

def scanexecutable_mips(p, cfg, result_save_folder=None):
	if(result_save_folder != None):
		form_functions_info = open(result_save_folder + 'FHF_info.txt', 'w')
	func_lists = cfg.kb.functions
	forminfos = getformfunctions(p, cfg)
	form_name_lists = []
	form_addr_lists = []
	form_func_params= []
	form_func_count = 0
	param_count = 0
	for i in range(len(forminfos)):
			form_name_lists.append(forminfos[i][0])
			form_addr_lists.append(forminfos[i][1])
			form_func_count += 1
	for func_address in form_addr_lists:
		try:
		  func = func_lists[func_address]
		except:
		  continue
		funcname = func.name
		if(re.search('telnet', funcname, flags=re.IGNORECASE)):
			print("\n\n\n{}".format(Color.GREEN))
			print("Telnet interface found!!!")
			if(result_save_folder != None):
				form_functions_info.write("\n\nTelnet interface found!!!\n")
		print("\n{}".format(Color.GREEN))
		print(funcname)
		print("\n{}".format(Color.RED))
		stringinform = getformfunctionstrings_mips(p, func_lists[func_address])
		form_func_params.append(stringinform)
		param_count += 1
		print(stringinform)
		if(result_save_folder != None and funcname != None ):
			form_functions_info.write("\n\nform name:" + funcname + '\n')
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
	print("%d form functions Identified." % (form_func_count))
	print("%d form parameters Identified." % (param_count))
	if(result_save_folder != None):
		form_functions_info.write(str(form_func_count) + "form functions Identified.\n")
		form_functions_info.close()
	return form_name_lists, form_func_params


