- Install
  - Get kubespray
    ```bash
    git clone https://github.com/kubernetes-sigs/kubespray.git
    pip install -r requirements.txt
    ```
  - Set ssh key
    ```
    ssh-keygen
    ssh-copy-id {{user}}@{{ip}}
    ```
  - Set inventory.ini
    ```bash
    cp -r kubespray/inventory/sample kubespray/inventory/mycluster
    vim kubespray/inventory/mycluster/inventory.ini
    ```
    ```ini
    [all]
    node-1 ansible_user=user ansible_host=192.168.0.12 ip=192.168.0.12 etcd_member_name=node-1 ansible_become_pass='pwpw'
    node-2 ansible_user=user ansible_host=192.168.0.14 ip=192.168.0.14 ansible_become_pass='pwpw'

    [kube_control_plane]
    node-1

    [etcd]
    node-1

    [kube_node]
    node-1
    node-2

    [calico_rr]

    [k8s_cluster:children]
    kube_control_plane
    kube_node
    calico_rr
    ```
  - Deploy
    ```bash
    #Test Ping
    ansible all -i inventory/mycluster/inventory.ini -m ping

    #Deploy
    ansible-playbook -i inventory/mycluster/inventory.ini -become --become-user=root cluster.yml
    ```

  - Set kubectl use
    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```