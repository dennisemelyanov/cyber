## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![TODO: Update the path with the name of your diagram](Images/Diagram2_final.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the elk.yml file may be used to install only certain pieces of it, such as Filebeat.

```
---
  - name: Config ELK server
    hosts: elk
    become: true
    tasks:
    - name: Insrease Memory
      sysctl:
       name: vm.max_map_count
       value: '262144'
       sysctl_set: yes
       state: present
       reload: yes
    - name: docker.io
      apt:
        update_cache: yes
        name: docker.io
        state: present
    - name: Install pip3
      apt:
        name: python3-pip
        state: present
    - name: Install Docker module
      pip:
        name: docker
        state: present
    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        published_ports:
                    - 5601:5601
                    - 9200:9200
                    - 5044:5044
    - name: Enable docker on start up
      systemd:
        name: docker
        enabled: yes

```
This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- What aspect of security do load balancers protect? What is the advantage of a jump box? 
Load balancers are the front end and do not expose the actual servers, plus they distribute the traffic between the back end servers to make sure the service is available.
Jump box is the only machine that can access the rest of the network nodes ( asymmetric ssh key access used ). Plus there is an access control to a jump box too: Specific IP sources are allowed and ssh keys.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the log files and system resources.
- What does Filebeat watch for?
-- Filebeat watches/monitors changes in the log files
- What does Metricbeat record?
-- Metricbeat monitors CPU, memory, network, disk, plus apps like apache, docker , etc. In other words data from operating system and services

The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Management/IT access  | 10.0.0.12  | Linux            |
| Web-1    | Web Server| 10.0.0.10 | Linux           |
| Web-2    | Web Server| 10.0.0.11 | Linux           |
| Web-3    | Web Server| 10.0.0.13 | Linux           |
| Elk-Sever| Data Proccessing| 10.1.0.4 | Linux        |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box and Elk-Server machines can accept connections from the Internet. Access to these machines is only allowed from the following IP addresses:
- Whitelisted IP addresses: 76.102.188.228,174.194.192.151,70.35.42.0/24

Machines within the network can only be accessed by Jump-Box.
- Which machine is allowed to access your ELK VM? -- Jump-Box(Provisioner), IP:10.0.0.12

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes              | 76.102.188.228,174.194.192.151,70.35.42.0/24    |
| Elk-Server| Yes             | 76.102.188.228,174.194.192.151,70.35.42.0/24    |

 
### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it minimizes the risk of misconfigurations, which
potentially could lead to vulnerabilities.
 
- What is the main advantage of automating configuration with Ansible? -- Any server can be replaced/configured/built with minimum down time.

The playbook implements the following tasks:

- Increase memory allocation for VM
- Install Docker and Python3
- Download and Lauch ELK container
- Setup ports
- Enable Docker on start up

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![TODO: Update the path with the name of your screenshot of docker ps output](Images/docker_ps_output.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- 10.0.0.10, 10.0.0.11, 10.0.0.13

We have installed the following Beats on these machines:
- Filebeat (Log files) and Metricbeat (Metrics)

These Beats allow us to collect the following information from each machine:
- Filebeat:  Allows to watch log files being 'tailed' in Kibana, simplifies the collection, parsing and visualization of most log formats.
             It allows to filter by service, app, host, datacenter, or other criteria to track down any unusual behavior across aggregated logs.

- Metricbeat: Provides GUI for CPU, memory, file system, network IO, disk IO, statistics/metrics for processing running on the systems like Apache,
              MySQL, NGINX, etc. 
 
### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the elk.yml file to /etc/ansible/
- Update the hosts file to include the IP address and python3 language as follows: 10.1.0.4 ansible_python_interpreter=/usr/bin/python3
- Run the playbook, and navigate to http://10.1.0.4:5601 or http://40.75.5.137:5601 ( if allowed from the outside ) to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it? -- elk.yml is the playbook file and it should be in /etc/ansible/ diectory
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
-- Hosts file should be updated with a target host(s) IP address or a group name in square brackets [group name] with IP addresses of the target machines.
- _Which URL do you navigate to in order to check that the ELK server is running? -- Local IP: 10.1.0.4:5601 or External IP: 40.75.5.137:5601 ( if allowed )

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._