curl --location --request GET 'https://api.hetzner.cloud/v1/images' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer #HetznerTokenGoesHere#' > current_images.json
