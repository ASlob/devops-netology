#!/usr/bin/env python3
print("Введите путь репозитория в формате 'path/':")
path = input()

import os

os.chdir(path)
bash_command = ["git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path+prepare_result)
