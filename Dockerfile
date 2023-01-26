FROM centos

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y python3
RUN yum install -y python3-pip

WORKDIR /projects/python/pyshop

RUN pip3 install virtualenv
RUN python3 -m venv venv
RUN source venv/bin/activate
COPY ./requirements.txt ./
RUN pip3 install -r requirements.txt
COPY ./ ./

RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
