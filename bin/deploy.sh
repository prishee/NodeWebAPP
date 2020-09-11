# terminate on any error
set -e

npm run build


# ********* DEPLOY TO PRODUCTION *********

# git revision
GIT_REV=$(git rev-parse --short HEAD)

# build docker container for front end, and tag container name
docker build -f Dockerfile.ui . -t prishu007/cat-ui:${GIT_REV} -t prishu007/cat-ui:prod
docker push prishu007/cat-ui:${GIT_REV}

# deploy backend to kubernetes
# will look for a kube config, and if none exists prompt to set up via kubesail
npx deploy-to-kube --no-confirm

# deploy frontend and tell kubernetes to use newest UI image
kubectl apply -f deployment-ui-prod.yaml
kubectl set image deployment/cat-ui cat-ui=prishu007/cat-ui:${GIT_REV}
