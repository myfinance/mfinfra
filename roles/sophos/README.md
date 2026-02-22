Step 1: Enable API on Sophos Firewall
Before Ansible can talk to the firewall, you must whitelist your Semaphore server's IP.

Log in to your Sophos XG Web Admin.

Navigate to Backup & Firmware > API.

Check API Configuration to enable it.

In Allowed IP Address, add the IP of your Semaphore/Ansible runner.

Click Apply.

Install Collection: ansible-galaxy collection install sophos.sophos_firewall

Python Library: pip install sophosfirewall-python