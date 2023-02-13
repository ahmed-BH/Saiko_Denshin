FROM ubuntu:18.04
RUN apt-get update \
  && apt-get install -y python python-pip \
  swi-prolog \
  && apt-get clean

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080

CMD [ "python", "./Saiko_Denshin.py" ]