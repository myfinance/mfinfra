FROM public.ecr.aws/semaphore/pro/server:v2.16.51

USER root

RUN ansible-galaxy collection install sophos.sophos_firewall \
    -p /usr/share/ansible/collections

USER semaphore