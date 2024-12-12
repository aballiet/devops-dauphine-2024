# TP 3

## Partie 0: (si TP précédent pas terminé) Reprendre les partie 3 et 4 du TP 2

- https://cloud.google.com/build/docs/deploy-containerized-application-cloud-run?hl=fr

- https://cloud.google.com/build/docs/automate-builds?hl=fr


## Partie 1 : Tutoriel Terraform

###  Gérer une Infrastructure as Code avec Terraform, Cloud Build et GitOps

https://cloud.google.com/docs/terraform/resource-management/managing-infrastructure-as-code?hl=fr

# Partie 2 : déployer une application Node.js sur Cloud Run en autonomie

Si vous en êtes arrivés ici, c'est que vous avez tous les outils nécessaires pour délivrer une application en production en utilisant une approche DevOps 😎

Il est temps de mettre bout à bout vos connaissances 😌

### Utiliser terraform et cloud build pour déployer une application

Reprendre le code de l'application Node utilisée dans le TP 1 :

- App.js :

```js
const http = require('http');
const hostname = '0.0.0.0';
const port = 80;
const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello World\n');
});
server.listen(port, hostname, () => {
    console.log('Server running at http://%s:%s/', hostname, port);
});
process.on('SIGINT', function() {
    console.log('Caught interrupt signal and will exit');
    process.exit();
});
```

- Dockerfile

```dockerfile
# Use an official Node runtime as the parent image
FROM node:lts
# Set the working directory in the container to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
ADD . /app
# Make the container's port 80 available to the outside world
EXPOSE 80
# Run app.js using node when the container launches
CMD ["node", "app.js"]
```

Votre code terraform doit :
-> Activer les APIs nécessaires sur votre projet
-> Créer le repo Artifact Registry

Votre pipeline Cloud Build doit :
-> Appliquer les changements de votre code terraform sur votre projet
-> Build et push l'image docker sur une repo Artifact Registry

Bonus : déployer l'image docker sur une instance [Cloud Run](https://cloud.google.com/run?hl=fr) définie en code terraform. Faites attention au mapping des ports 😉 : [Config Cloud Run](https://cloud.google.com/run/docs/container-contract?hl=fr) & [Cloud Run Terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service)

![terraform-config-cloud-run](./terraform_cloud_run.png)