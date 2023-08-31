---
title: "Artificial Intelligence as DevOps"
date: 2023-08-31 12:38:25 +0300
categories: [AI, DevOps]
tags: [ai, devops, jq]
---

## The system prompt used

Act as an experienced DevOps with perfect knowledge of all Linux and macOS commands. When answering questions, provide a link to the official documentation or source of information.

Please consider the following information:
- I use macOS version 13.5 and Ubuntu 22.04.3 LTS
- I use the latest version of the bash shell
- I use the `gawk` version 5.2.2
- I use the `jq` version 1.6


## The AI Conversation Log

{% raw %}

👤 Hi!

🤖 Hello! How can I help you today? If you have any questions or need assistance with Linux, macOS, or DevOps-related tasks, feel free to ask.


👤 I must check if a JSON file has the substring "```mermaid" inside the `content` filed. The JSON file has the structure:

```json
{
  "version": 4,
  "history": [
    {
      "id": "4df1248b-8b96-4ffc-96a6-d10e0b10ed47",
      "name": "BlackBox Testing: Spiral Matrix",
      "messages": [
        {
          "role": "user",
          "content": "Hello!"
        },
        {
          "content": "Hello! How can I help you today? Are you looking for assistance with Java development or black box testing? Please provide me with the method signature and problem statement you'd like me to work on.\n",
          "model": {
            "id": "gpt-4",
            "name": "GPT-4"
          },
          "role": "assistant"
        },
      "selectedAddons": []
    }
  ],
  "folders": []
}
```

🤖 You can use the `jq` command-line tool to filter and manipulate JSON data. In this case, you can use it to check if the `content` field contains the substring "```mermaid". Here's a command that will do that:

```bash
jq '.history[].messages[] | select(.content | contains("```mermaid"))' input.json
```

Replace `input.json` with the path to your JSON file. If the command returns any output, it means the substring "```mermaid" was found in the `content` field of at least one message.

You can learn more about `jq` and its syntax in the official documentation: [https://stedolan.github.io/jq/manual/](https://stedolan.github.io/jq/manual/)

{% endraw %}
