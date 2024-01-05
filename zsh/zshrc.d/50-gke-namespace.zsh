function ns {
  if [[ -n $1 ]]; then
    kubectl config set-context $(kubectl config current-context) --namespace=$1
  fi

  namespaces=$(kubectl get namespaces -o name | sed -e 's/namespace\///g')
  current_context=$(kubectl config current-context)
  current_namespace=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${current_context}\")].context.namespace}")

  sorted=($(echo $namespaces | sort))

  for c in $sorted; do
    if [ "$c" = "$current_namespace" ]; then
      printf "\033[31m[\033[0m\033[33m%s\033[0m\033[31m]\033[0m " $c
    else
      printf "%s " $c
    fi
  done

  echo
}