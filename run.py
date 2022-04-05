import os
import subprocess
import re
def c_print(*args, **kwargs):
    '''
    Uses ascii codes to enable colored print statements. Works on Mac, Linux and Windows terminals
    '''
    #Magic that makes colors work on windows terminals
    os.system('')
    
    #Define Colors for more readable output
    c_gray = '\033[90m'
    c_red = '\033[91m'
    c_green = '\033[92m'
    c_yellow = '\033[93m'
    c_blue = '\033[94m'
    c_light_magenta = '\033[95m'
    c_end = '\033[0m'
    
    color = c_end
    if 'color' in kwargs:
        c = kwargs['color'].lower()
        if c == 'gray' or c == 'grey':
            color = c_gray
        elif c ==  'red':
            color = c_red
        elif c == 'green':
            color = c_green
        elif c == 'yellow':
            color = c_yellow
        elif c == 'blue':
            color = c_blue
        elif c == 'light_magenta':
            color = c_light_magenta
        else:
            color = c_end
    _end = '\n'
    if 'end' in kwargs:
        _end = kwargs['end']
    print(f'{color}', end='')
    for val in args:
        print(val, end='')
    print(f'{c_end}', end=_end)
def get_rand_face():
    pass
def get_rand_color():
    pass
def validate_url(url):
    if len(url) >= 3:
        if 'https://' not in url:
            if url[:3] == 'app' or url[:3] == 'api':
                url = 'https://' + url
            
    
    url = url.replace('app', 'api')
    url = re.sub(r'prismacloud\.io\S*', 'prismacloud.io', url)
    return url
def terraform_setup(cname, api, uname, password):
    tf_path = 'main.tf'
    if not os.path.exists(tf_path):
        with open(tf_path, 'w') as outfile:
            outfile.write("terraform {\n    required_providers {\n        prismacloud = {\n            source = \"PaloAltoNetworks/prismacloud\"\n            version = \"1.2.3\"\n        }\n    }\n}\n\nprovider \"prismacloud\" {\n    url = \"" + api + "\"\n    username = \"" + uname + "\"\n    password = \"" + password + "\"\n    customer_name = \"" + cname + "\"\n    skip_ssl_cert_verification= true\n    logging= {\"action\": true, \"send\": true, \"receive\": true}\n}")
        print()
        c_print('Created main.tf', color='green')
        c_print('You may need to update your version field in main.tf', color='blue')
    print()
    c_print('Once main.tf has been set up, please run ', end='', color='blue')
    c_print('terraform init', color='light_magenta')
def greet():
    print()
    c_print('╲⎝⧹ ( ͡° ͜ʖ ͡°) ⎠╱', color='red')
    print()
    c_print(' $$$$$$\   $$$$$$\  $$$$$$$$\       $$\        $$$$$$\  $$$$$$$\   $$$$$$\  ', color='green')
    c_print('$$  __$$\ $$  __$$\ $$  _____|      $$ |      $$  __$$\ $$  __$$\ $$  __$$\ ', color='green')
    c_print('$$ /  \__|$$ /  \__|$$ |            $$ |      $$ /  $$ |$$ |  $$ |$$ /  \__|', color='green')
    c_print('$$ |      \$$$$$$\  $$$$$\          $$ |      $$$$$$$$ |$$$$$$$\ |\$$$$$$\  ', color='green')
    c_print('$$ |       \____$$\ $$  __|         $$ |      $$  __$$ |$$  __$$\  \____$$\ ', color='green')
    c_print('$$ |  $$\ $$\   $$ |$$ |            $$ |      $$ |  $$ |$$ |  $$ |$$\   $$ |', color='green')
    c_print('\$$$$$$  |\$$$$$$  |$$$$$$$$\       $$$$$$$$\ $$ |  $$ |$$$$$$$  |\$$$$$$  |', color='green')
    c_print(' \______/  \______/ \________|      \________|\__|  \__|\_______/  \______/', color='green')
    print()
    c_print('[̲̅$̲̅(̲̅ ͡° ͜ʖ ͡°̲̅)̲̅$̲̅]', color='blue')
    print()
    c_print('Hello! Welcome to the Palo Alto Networks Prisma Cloud Customer Success Lab.', color='green')
    print()
def tasks():
    options = ['0', '1', '2', '3', '4']
    options2 = ['exit', 'aws', 'pcs_toolbox', 'gcloud', 'azure', 'terraform']
    choice = ''
    while choice not in options and choice not in options2:
        print()
        c_print('Select a assisted setup option or \'exit\' to be taken straight to the shell.', color='blue')
        print()
        c_print('1: pcs_toolbox/terraform', color='light_magenta')
        c_print('2: aws', color='light_magenta')
        c_print('3: gcloud', color='light_magenta')
        c_print('4: azure', color='light_magenta')
        c_print('0: exit', color='light_magenta')
        choice = input()
        choice = choice.lower()
    if choice == '0' or choice == 'exit':
        quit()
    
    if choice == '1' or choice == 'terraform' or choice == 'pcs_toolbox':
        c_print('Enter Customer name:', color='blue')
        cname = input()
        print()
        c_print('Enter tenant URL or API URL. (ex: https://app.ca.prismacloud.io):', color='blue')
        url = input()
        print()
        new_url = validate_url(url)
        if new_url != url:
            c_print('Adjusted URL:',color='yellow')
            print(new_url)
            print()
        api = new_url
        c_print('Enter tenant access key:', color='blue')
        uname = input()
        print()
        c_print('Enter tenant secret key:', color='blue')
        password = input()
        print()
        c_print('Select tool to setup:: ', color='blue')
        c_print('1: Terraform', color='light_magenta')
        c_print('2: PCS Toolbox', color='light_magenta')
        uinput = input()
        uinput = uinput.lower()
        if uinput == '1':
            os.chdir('/opt/terraform')
            terraform_setup(cname, api, uname, password)
            os.system("/bin/bash")
        if uinput == '2':
            os.chdir('/opt/pcs-toolbox')
            os.system(f'python3 scripts/pcs_configure.py --username "{uname}" --password "{password}" --api "{api}"')
            os.system("/bin/bash")
        quit()
    if choice == '2' or choice == 'aws':
        p = subprocess.Popen('okta-awscli', shell=True)
        out = p.communicate()
        p.wait()
        print()
        c_print('Copy and paste the 3 export commands into the command line.', color='blue')
        c_print('You will then have access to AWS. Confirm with \'aws s3 ls\'.', color='blue')
        c_print('After setting the environment variables, you can create a EKS cluster with the following command:', color='green')
        c_print('aws servicecatalog provision-product --provisioned-product-name "{ClusterName}" --provisioning-parameters \'{"Key":"EKSName","Value":"{ClusterName}"}\' --region us-east-1 --cli-input-json file:///opt/aws/eks/eks.json ', color='light_magenta')
        c_print('')
    if choice == '3' or choice == 'gcloud':
        os.system('gcloud auth login')
        print()
        c_print('You can create a GKE cluster with the following command:', color='green')
        c_print('gcloud container clusters create example-cluster --zone us-central1-f --num-nodes 1', color='light_magenta')
        quit()
    if choice == '4' or choice == 'azure':
        os.system('az login')
        print()
        c_print('You can create a AKS cluster with the following commands:', color='green')
        c_print('az group create --name myResourceGroup --location eastus', color='light_magenta')
        c_print('az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 1 --enable-addons monitoring --generate-ssh-keys', color='light_magenta')
        quit()
if __name__ == '__main__':
    greet()
    tasks()
