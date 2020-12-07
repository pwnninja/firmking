def prompt(question, answers=["y", "n"], defaultIndex=None):
    answer = ""
    while answer not in answers:
        print("%s (%s)" % (question, "/".join(answers)))
        if defaultIndex != None:
            answer = raw_input("Default %s: " % (answers[defaultIndex]))
        else:
            answer = raw_input("No default: ")
        print("")

        if defaultIndex != None and answer == "":
            answer = answers[defaultIndex]
            break

    if len(answers) == 2 and answers[0] == "y" and answers[1] == "n":
        if answer == "y":
            return True
        else:
            return False
    else:
        return answer

def promptInt(question, defaultResponse=None, allowNo=False):
    answer = None

    while answer == None:
        print("%s" % (question))
        try:
            if defaultResponse:
                answer = raw_input("Default {0}: ".format(defaultResponse)).strip()
            else:
                answer = raw_input("No default: ")
            print("")
            
            if allowNo and (answer == "n" or answer == ""):
                return None
            else:
                answer = int(answer)

        except ValueError:
            answer = None

        if answer == None and defaultResponse:
            answer = defaultResponse
    
    return answer

def promptString(question, defaultResponse="n", validateFunc=None):
    retStr = ""
    while not retStr or not len(retStr): 
        if defaultResponse:
            inputStr = raw_input("%s\nDefault %s: " % (question, defaultResponse))
        else:
            inputStr = raw_input("%s\nNo default: " % (question))
            
        print("")
        if defaultResponse and (inputStr == defaultResponse or not len(inputStr)):
            return defaultResponse    

        if validateFunc:
            if validateFunc(inputStr):
                retStr = inputStr 

    return retStr 

def validateNumberRange(inputStr, flattenList=False):
    retList = []
    tmpList = filter(None,inputStr.split(','))

    for num in tmpList:
        try:
            retList.append(int(num))
        except ValueError:
            if '-' in num:
                intRange = num.split('-')  
                if len(intRange) > 2:
                    print("Invalid range given")
                    return None
                try:
                    if not flattenList:
                        retList.append(xrange(int(intRange[0]),int(intRange[1])+1)) 
                    else:
                        retList.extend(range(int(intRange[0]),int(intRange[1])+1)) 
                except TypeError:
                    print("Invalid range given")
                    return None
            else:
                print("Invalid number given")
                return None
    if flattenList:
        retList = sorted(list(set(retList)))
    return retList 

