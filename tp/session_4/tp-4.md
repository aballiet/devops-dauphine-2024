# TP 4 Inition aux microservices : Docker compose & Kubernetes

## Partie 1 : Docker compose

### Serveur Web et Redis

1. Créer un dossier `composetest` qui contiendra le code pour cette partie du TP.
1. Créer le fichier suivant `app.py` :

    ```python
    import time

    import redis
    from flask import Flask

    app = Flask(__name__)
    cache = redis.Redis(host='redis', port=6379)

    def get_hit_count():
        retries = 5
        while True:
            try:
                return cache.incr('hits')
            except redis.exceptions.ConnectionError as exc:
                if retries == 0:
                    raise exc
                retries -= 1
                time.sleep(0.5)

    @app.route('/')
    def hello():
        count = get_hit_count()
        return 'Hello World! I have been seen {} times.\n'.format(count)
    ```

    > Dans cet exemple, redis est le nom d'hôte du conteneur redis sur le réseau de l'application. Nous utilisons le port par défaut pour Redis, 6379.

    *Remarquez la façon dont la fonction `get_hit_count` est écrite.*

   Cette boucle de nouvelle tentative nous permet de tenter notre requête d'incrément plusieurs fois si le service Redis n'est pas disponible.

   Ceci est utile au démarrage lorsque l'application est en ligne, mais rend également l'application plus résiliente si le service Redis doit être redémarré à tout moment pendant la durée de vie de l'application.

   > Dans un cluster, cela permet également de gérer les interruptions de connexion momentanées entre les nœuds.

1. Créez un autre fichier appelé requirements.txt :

    ```txt
    flask
    redis
    ```

    > On définit ainsi les dépendances python de notre application `app.py`

2. Création du Dockerfile :

    ```Dockerfile
    FROM python:3.7-alpine
    WORKDIR /code
    ENV FLASK_APP=app.py
    ENV FLASK_RUN_HOST=0.0.0.0
    RUN apk add --no-cache gcc musl-dev linux-headers
    COPY requirements.txt requirements.txt
    RUN pip install -r requirements.txt
    EXPOSE 5000
    COPY . .
    CMD ["flask", "run"]
    ```

    Cela indique à Docker de faire les actions suivantes :

    - Créez une image en commençant par l'image Python 3.7.
    - Définir le répertoire de travail sur /code.
    - Définir les variables d'environnement utilisées par la commande flask.
    - Installer gcc et d'autres dépendances
    - Copier `requirements.txt` dans le container
    - Installer les dépendances Python (à partir du fichier `requirements.txt`)
    - Ajouter des métadonnées à l'image pour décrire que le conteneur écoute sur le port 5000
    - Copier le répertoire actuel. dans le projet vers le répertoire de travail . dans l'image.
    - Définir la commande par défaut du conteneur sur flask run.


1. Défintion du service

    Créer un fichier `compose.yaml` avec le contenu :

    ```YAML
    services:
    web:
        build: .
        ports:
        - "8000:5000"
    redis:
        image: "redis:alpine"
    ```

    > Ce fichier Compose définit deux services : web et redis.

    - Le service Web utilise une image créée à partir du Dockerfile dans le répertoire actuel. Il lie ensuite le conteneur et la machine hôte au port exposé, 8000. Cet exemple de service utilise le port par défaut du serveur Web Flask, 5000.

    - Le service Redis utilise une image Redis publique extraite du registre Docker Hub.

1. Depuis le répertoire de votre projet, démarrez votre application en exécutant docker `compose up`.

    Compose télécharge l'image Redis, crée une image pour votre code et démarre les services que vous avez définis. Dans ce cas, le code est copié de manière statique dans l’image au moment de la construction.

1. Faites la commande plusieurs fois et observer l'incrément : `curl http://localhost:8000/`

## Partie 2 : Kubernetes

### Introduction

Faites vos premiers pas avec le tutoriel de Google pour GKE (Kubernetes) : https://cloud.google.com/kubernetes-engine/docs/quickstarts/deploy-app-container-image?hl=fr#python


## Déploiement d'une application microservices : serveur PHP et Redis

https://cloud.google.com/kubernetes-engine/docs/tutorials/guestbook?hl=fr

### Aller plus loin : utiliser helm pour déployer ses applications

Helm permet de déployer plus facilement les applications multi-services sur Kubernetes.

Helm dispose d'un terraform provider : https://registry.terraform.io/providers/hashicorp/helm/latest/docs

Il utilise alors l'API kubernetes pour créer les ressources dans le cluster.

https://getbetterdevops.io/terraform-with-helm/ (en anglais)