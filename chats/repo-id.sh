OWNER='rabestro'
REPO='blog-discussions'

#read -r -d '' GRAPHQL_QUERY << EOM
#{
#  "query": "query {
#    repository(owner:$OWNER, name:$REPO) {
#      id
#    }
#  }"
#}
#EOM
GRAPHQL_QUERY=' { "query": "query { repository(owner:\"'$OWNER'\", name:\"'$REPO'\"){ id }}" }'
#echo "$GRAPHQL_QUERY"

curl --silent --show-error \
  --header "Authorization: bearer $GITHUB_TOKEN" \
  --request POST \
  --data "$GRAPHQL_QUERY" \
  https://api.github.com/graphql \
   | jq '.data.repository.id'

LABEL_NAME=General
GRAPHQL_QUERY='{ "query": "query { repository(owner:\"'$OWNER'\", name:\"'$REPO'\"){ label(name:\"'$LABEL_NAME'\") { id }}}" }'

curl --silent --show-error \
  --header "Authorization: bearer $GITHUB_TOKEN" \
  --request POST \
  --data "$GRAPHQL_QUERY" \
  https://api.github.com/graphql
