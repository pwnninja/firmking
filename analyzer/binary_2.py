#for belkin/cisco/linksys:get_cgi
import angr
import re
from kingcore.color import Color
#p = angr.Project('../tests/rv110w_1217', load_options={'auto_load_libs': False})
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
    if(func.name == 'main'):
      continue
    gp = getgp(func)
    if(gp == 0):
      continue
    targets = findaddrfromins(func, 'lw', '$t9, ')
    print("scan:")
    print(hex(d_address))
    print("\n")
    for target in targets:
      ins = getinsfromaddr(func, target)                      
      if(ins.find('gp') < 0):
        continue
      left = ins.find('lw $t9, ')
      right = ins.find('(')
      offset = int(ins[left + 8 : right], 16)
      if('LE' in str(p.arch)):
        callsite = getintfromaddr(p, gp + offset)
      if('BE' in str(p.arch)):
        callsite = getintfromaddr_big(p, gp + offset)
      if(callsite == None):
        continue
      try:
        name = func_lists[callsite].name
      except:
        continue
      if(name == 'get_cgi'):
        print("get_cgi found!")
        onestring = func.name
        forminfo=[]
        if(onestring != None):
          forminfo.append(onestring)
          forminfo.append(d_address)
          forminfos.append(forminfo)
          break
  return forminfos
		
def getformfunctionstrings_mips(p, func):
	ans = []
	gp = getgp(func)
	targets = findaddrfromins(func, 'lw', '$a0, ')
	for target in targets:
		seta0 = getinsfromaddr(func, target)
		if('$gp' not in seta0):
			continue
		left = seta0.find('lw $a0, ')
		right = seta0.find('(')
		offset = int(seta0[left + 8 : right], 16)
		if('LE' in str(p.arch)):
			a0 = getintfromaddr(p, gp + offset)
		if('BE' in str(p.arch)):
			a0 = getintfromaddr_big(p, gp + offset)
		for i in range(1,7):
		  try:
		    tmpins = getinsfromaddr(func, target + i * 4)
		  except:
		    continue
		  if(tmpins == None):
		    continue
		  if('addiu $a0, $a0, ' in tmpins):        
		    adda0 = target + i * 4
		    ins = getinsfromaddr(func, adda0)
		    tmp = ins.find('addiu $a0, $a0, ')
		    tmp = int(ins[tmp + 16 : ], 16)
		    postparam_addr = (a0 + tmp) % 0x100000000
		    try:
		      onestring = getstringfromaddr(p, postparam_addr)
		    except:
		      continue
		    if((onestring != None) and ('.' not in onestring) and ('\n' not in onestring) and ('/' not in onestring) ):
		      ans.append(onestring)
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
		func = func_lists[func_address]
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


