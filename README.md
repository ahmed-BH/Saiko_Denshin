# Saiko_Denshin

Saiko_Denshin is an Akinator game where a machine tries to determine which person (a boxer in this case) the player is thinking of by asking a series of questions.

## Running with docker

```shell
docker run --rm -it -p 8080:8080 ahbenmed/saikodenshin
```

## Running manually

### Prerequisites

* Install [python-2.7.13.msi](https://www.python.org/ftp/python/2.7.14/python-2.7.14.amd64.msi)

* Install [SWI-Prolog.exe](http://www.swi-prolog.org/download/stable)

* Execute the command prompt as administrator and run:

		rename "C:\Program Files (x86)\swipl\bin\libswipl.dll" libpl.dll

* install needed python modules :

        pip install -r requirements.txt
        
### Runing

```
cd Saiko_Denshin/
```

Open a new command prompt

```
python Saiko_Denshin.py
```

Open Browser and test it on http://localhost:8080/


Scrots
------

![Guess](scrot/guess.jpg?raw=true "Guess")

## Built With

* [Bottle](http://bottlepy.org/docs/dev/) - The micro web-framework used
* [Pyswip](https://github.com/yuce/pyswip) - SWI-Prolog language interface
