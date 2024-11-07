## Partie 2 : Exercice Docker en autonomie

En vous appuyant sur la documentation officielle, lancez un
conteneur [postgres](https://hub.docker.com/_/postgres).

Par défaut, une base PostgreSQL écoute sur le port 5432.

Connectez vous à la base à l'aide la commande :

```bash
PGPASSWORD=<VOTRE_MOT_DE_PASSE_SI_DEFINI> psql -U postgres <NOM_DE_LA_DB>
```

Créez une table avec l'instruction SQL
suivante :

    ```sql
    CREATE TABLE techo (id VARCHAR NOT NULL PRIMARY
    KEY, name varchar(50) NOT NULL UNIQUE);
    ``````

- Redémarrez votre conteneur. La table existe t-elle toujours ?
D’après vous, où est localisé le stockage de votre conteneur ?

- Supprimez votre conteneur et re-créez le. Quelle différence
observez vous ?

- Recommencez la même opération avec les contraintes suivantes :

   - la base de données doit être accessible sur l’hôte sur le port 2345
   - la base de données doit se nommer tp_devops ;
   - les identifiants de connexion doivent être admin / foo123 ;
   - le conteneur ne peut consommer plus d’un CPU ;

   - le stockage doit être persistant et les données de la base
   sauvegardée dans un dossier data à la racine du projet.

  - Observez les ressources utilisées par votre conteneur et expliquez
   ce que représente chaque métrique.