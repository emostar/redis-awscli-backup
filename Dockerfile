FROM amazonlinux:2

# Install Redis, AWS CLI, and other necessary tools
RUN amazon-linux-extras install epel -y && \
    yum update -y && \
    yum install -y redis aws-cli tar gzip && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY backup-script.sh /usr/local/bin/backup-script.sh
RUN chmod +x /usr/local/bin/backup-script.sh

ENTRYPOINT ["/usr/local/bin/backup-script.sh"]
