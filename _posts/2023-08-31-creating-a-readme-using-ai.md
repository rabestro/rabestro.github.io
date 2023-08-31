---
title: "Creating a README using AI"
date: 2023-08-31 19:06:47 +0300
categories: [AI, DevOps]
tags: [ai, devops, bash, jq]
mermaid: false
---
{% raw %}

## The AI Conversation Log

👤 Hi, who are you?

🤖 Hello! I am an AI trained to assist you with your DevOps tasks. I have extensive knowledge of GitHub, GitHub Pages, GitHub Actions, Jekyll, and the Chirpy Jekyll Theme. I'm here to help you set up and configure your site. If you have any questions or need assistance, feel free to ask!

👤 I created a shell script named `post` to convert the ChatGPT-4 session in JSON to the post for my site. I want to publish this script as an open source. Could you analyze the script and write a `README.md` file for the repository with a description, requirements, and a guide on how to use it? 

🤖 Sure, I'd be happy to help you create a `README.md` file for your repository. However, I'll need to see the content of your `post` shell script to understand its functionality and requirements. Please provide the script content or a link to the script in your repository.

👤 

```bash
#!/usr/bin/env bash
#
# Copyright (c) 2023 Jegors Čemisovs
# License: MIT
# Repository: https://github.com/rabestro/gpt4-session-to-markdown
#
# Converts GPT-4 chat session JSON data to markdown format and
# adds YAML front matter to the top of the file to prepare it
# for publishing on the Jekyll site.
#
# Usage:
#   ./post <file.json>
#

# set these variables as needed for your environment
readonly POSTS_DIR="../_posts"
readonly TIMEZONE="+0300"
readonly CATEGORIES="AI"
readonly TAGS="ai"

create_file_name() {
  jq --raw-output '.history[0].name | ascii_downcase | gsub("[^a-z0-9]+"; "-")' "$1"
}

conversation() {
  local -r file_json="$1"
  cat <<EOF

## The AI Conversation Log

$(jq --raw-output '.history[0].messages | map((
  if .role == "user" then "👤" else "🤖" end
  )+ " \(.content)\n") | join("\n")' "$file_json")

EOF
}

has_mermaid() {
  jq 'any(.history[].messages[]; .content | contains("```mermaid"))' "$1"
}

main() {
  local -r file_json="$1"
  local -r file_name=$(create_file_name "$file_json")
  local -r current_date=$(date '+%Y-%m-%d')
  local -r current_time=$(date '+%H:%M:%S')
  local -r file_post="${POSTS_DIR}/$current_date-$file_name.md"

  local -r title=$(jq --raw-output '.history[0].name' "$file_json")
  local -r prompt=$(jq --raw-output '.history[0].prompt' "$file_json")

  echo "Title: $title"
  echo "File: $file_name"

  cat << EOF > "$file_post"
---
title: "$title"
date: $current_date $current_time $TIMEZONE
categories: [$CATEGORIES]
tags: [$TAGS]
mermaid: $(has_mermaid "$file_json")
---
\{% raw %}

## The system prompt used

$prompt

$(conversation "$file_json")

\{% endraw %}
EOF
}

main "$1"
```


🤖 Thank you for providing the script. Based on the provided script, I have created a `README.md` file for your repository:

```markdown
# GPT-4 Session to Markdown

This script converts GPT-4 chat session JSON data to markdown format and adds YAML front matter to the top of the file to prepare it for publishing on a Jekyll site.

## Requirements

- [jq](https://stedolan.github.io/jq/) - A lightweight and flexible command-line JSON processor.

## Usage

1. Clone the repository:

    git clone https://github.com/rabestro/gpt4-session-to-markdown.git
    cd gpt4-session-to-markdown

2. Make the script executable:

    chmod +x post

3. Run the script with the JSON file as an argument:

    ./post <file.json>

   Replace `<file.json>` with the path to your GPT-4 chat session JSON file.

## Configuration

You can customize the script by modifying the following variables at the beginning of the `post` script:

- `POSTS_DIR`: The directory where the generated markdown files will be saved. Default is `../_posts`.
- `TIMEZONE`: The timezone to be used in the YAML front matter. Default is `+0300`.
- `CATEGORIES`: The categories to be used in the YAML front matter. Default is `AI`.
- `TAGS`: The tags to be used in the YAML front matter. Default is `ai`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```

You can create a new file named `README.md` in your repository and paste the content above. This will provide a description, requirements, and a guide on how to use your script.

👤 Thank you!

🤖 You're welcome! If you have any more questions or need further assistance, feel free to ask. Good luck with your project!

{% endraw %}
