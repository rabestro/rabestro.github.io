.[] |
select(.stargazers_count >= 5) |
"_projects/\(.name).md" as $filename |
[
  "---",
  "layout: project",
  "title: \(.name)",
  "description: \(.description)",
  "repository: \(.html_url)",
  "site: \(.homepage // "")",
  "tags: \(.language // "")",
  "---"
] |
join("\n") |
. + "\n" |
{filename: $filename, content: .} |
"\(.filename)\n\(.content)"
