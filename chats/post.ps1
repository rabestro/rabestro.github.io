#!/usr/bin/env pwsh

<#
    Copyright (c) 2023 Jegors Čemisovs
    License: MIT
    Repository: https://github.com/rabestro/gpt4-session-to-markdown

    Converts GPT-4 chat session JSON data to markdown format and
    adds YAML front matter to the top of the file to prepare it
    for publishing on the Jekyll site.

    Usage:
        ./post <file.json>
#>

# Set these variables as needed for your environment
$POSTS_DIR = "../_posts"
$TIMEZONE = "+0300"
$CATEGORIES = "AI"
$TAGS = "ai,  gpt-4"

function Get-FileName
{
  param($chatLog)
  $chatLog.history[0].name.ToLower() -replace '[^a-z0-9]+', '-'
}

function Get-Conversation
{
  param($JsonFile)
  $jsonContent = Get-Content -Raw -Path $JsonFile | ConvertFrom-Json
  $messages = $jsonContent.history[0].messages
  $conversation = $messages | ForEach-Object {
    if ($_.role -eq "user")
    {
      "👤 {0}" -f $_.content
    }
    else
    {
      "🤖 {0}" -f $_.content
    }
  }
  $conversation -join "`n"
}

function Test-HasMermaid
{
  param($JsonFile)
  $jsonContent = Get-Content -Raw -Path $JsonFile | ConvertFrom-Json
  $jsonContent.history.messages.content -match "```mermaid"
}

function Main
{
  param($FileJson)
  $chatLog = Get-Content -Raw -Path $FileJson | ConvertFrom-Json
  $FileName = Get-FileName $chatLog
  $CurrentDate = Get-Date -Format "yyyy-MM-dd"
  $CurrentTime = Get-Date -Format "HH:mm:ss"
  $FilePost = "${POSTS_DIR}/$CurrentDate-$FileName.md"

  $jsonContent = Get-Content -Raw -Path $FileJson | ConvertFrom-Json
  $Title = $jsonContent.history[0].name
  $Prompt = $jsonContent.history[0].prompt

  Write-Host "Title: $Title"
  Write-Host "File: $FileName"

  $YamlFrontMatter = @"
---
title: "$Title"
date: $CurrentDate $CurrentTime $TIMEZONE
categories: [$CATEGORIES]
tags: [$TAGS]
mermaid: $( Test-HasMermaid $FileJson )
---

## The system prompt used

{% raw %}
$Prompt

## The AI Conversation Log

$( Get-Conversation $FileJson )
{% endraw %}
"@

  Set-Content -Path $FilePost -Value $YamlFrontMatter
}

Main $args[0]
