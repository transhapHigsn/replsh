from subprocess import Popen, call
import re

def func():
    keywords = {
        'import': re.compile(r'import'),
        'interface': re.compile(r'interface'),
        'class' : re.compile(r'class'),
        'function': re.compile(r'function'),
    }
    
    entries = {}
    #variables = {}

    with open("jTemplate.txt", "r") as template:
        lines  = template.readlines()

    try:
        while True:
            com = take()
            lines, idx = codeblock(com, lines)
            entries['latest'] = idx
        
            with open("./temporary/TempJava.java", "w+") as destFile:
                for line in lines:
                    destFile.write(line)
            
            if call(['javac','./temporary/TempJava.java']) == 0:
                if call(['java', 'temporary.TempJava']) == 0:
                    print()

                else:
                    del lines[entries['latest']]
                    print()

            else:
                del lines[entries['latest']]
                print()

    except KeyboardInterrupt:
        Popen(["bash", "./script.sh"])

    except Exception as e:
        print (e)

    print ("Extinguishing the light, exiting the shell.")                                                  

def take():
    commands = []
    code = input('pshelf>  ')
    commands.append(code)
    lst = list(code)

    while True:
        c1 = lst.count('{')
        c2 = lst.count('}')
   
        if lst[-1] == ';':
            if c1==c2:
                break
            else:
                more = input('...   ')
                commands.append(more)
                lst.extend(list(more))    
        
        elif lst[-1] == '}':

            if  c1==c2:
                break
            else:
                while c1 != c2:
                    more = input('...   ')
                    commands.append(more)
                    l = list(more)

                    temp_c1 = l.count('{')
                    temp_c2 = l.count('}')

                    c1 += temp_c1
                    c2 += temp_c2

            break        

        else:
            more = input('...   ')
            commands.append(more)
            lst.extend(list(more))

    st = ''
    for i in commands:
        l = list(i)

        for j in range(len(l)):
            if l[j]=='{' or l[j]==';' or l[j]=='}':
                l.insert(j+1,'\n')

        if l[-1] == ';' or  l[-1] == '}' or l[-1] == '{':
            st += ''.join(l) + '\n'
        else:
            st += ''.join(l)        

    #print (st)
    return st

def codeblock(commands, lines):
    
    keywords = {
        'import': re.compile(r'import'),
        'interface': re.compile(r'interface'),
        'class' : re.compile(r'class'),
        'function': re.compile(r'function'),
    }

    idx = 0

    if keywords['import'].search(commands):
        idx=lines.index('//imports\n') + 1

    elif keywords['interface'].search(commands):
        idx=lines.index('//interfaces\n') + 1

    elif keywords['class'].search(commands):
        idx=lines.index('//classes\n') + 1

    elif keywords['function'].search(commands):
        idx=lines.index('//functions\n') + 1   
        
    else:
        idx=lines.index('//code\n')   
    
    lines.insert(idx,commands + '\n')    

    return (lines,idx)

def delPrint(command):
    #try working on logging module 
    pass

if __name__=='__main__':
    print(take())           
