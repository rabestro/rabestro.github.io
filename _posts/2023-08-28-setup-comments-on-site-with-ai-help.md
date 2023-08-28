---
title: "Setup comments on site with AI help"
date: 2023-08-28 15:51:28 +0300
categories: [AI]
tags: [ai, devops, github, jekyll]
---

## The system prompt used

Act as an experienced DevOps knowledgeable on GitHub and Jekyll.

Your task is to help me set up and configure my site.

Please note the following information:
- my name is Jegors
- my GitHub username is `rabestro`
- my site address is `https://rabestro.github.io`
- I use GitHub pages and Chirpy Jekyll Theme for my personal blog.
  _omitted for brevity_

The content of my `_config.yml`{: .filepath} is: _omitted for brevity_

When responding, please provide links to official documentation or sources of information.

## The AI Conversation Log

👤 Hi!

🤖 Hello Jegors! How can I help you with your GitHub Pages and Jekyll setup? If you have any questions or need assistance, feel free to ask.


👤 I would like to add comments to my site

🤖 Great! Since you're using the Chirpy Jekyll Theme, which supports `giscus` out of the box, I recommend using it for adding comments to your site. Giscus is a commenting system that uses GitHub Discussions as a backend.

To enable giscus comments, follow these steps:

1. Go to your GitHub repository and click on the "Settings" tab.
2. Scroll down to the "Features" section and enable "Discussions" by checking the box next to it.

Now, update your `_config.yml` file to enable giscus comments:

1. Locate the `comments` section in your `_config.yml` file.
2. Set the `active` option to `giscus`:

```yaml
comments:
  active: giscus
```

3. Fill in the `giscus` options:

```yaml
  giscus:
    repo: rabestro/rabestro.github.io
    repo_id: # Your repository ID (see instructions below)
    category: General
    category_id: # Your category ID (see instructions below)
    mapping: pathname
    input_position: bottom
    lang: en
    reactions_enabled: 1
```

To get your repository ID and category ID, follow these steps:

1. Go to the [giscus configuration page](https://giscus.app).
2. Fill in the required fields and click "Preview widget".
3. Scroll down to the "Configuration" section and copy the `data-repo-id` and `data-category-id` values.

Paste these values into your `_config.yml` file in the `repo_id` and `category_id` fields, respectively.

After making these changes, commit and push your updated `_config.yml` file to your GitHub repository. Giscus comments should now be enabled on your site.

For more information on giscus, you can refer to the [official giscus documentation](https://giscus.app/docs/).

👤 When I fill in "repository:" on giscus configuration page I get this message: 

> Cannot use giscus on this repository. Make sure all of the above criteria have been met.
{: .prompt-danger}

🤖 I apologize for the confusion. It seems that there might be an issue with the repository settings or the Discussions feature. Please follow these steps to troubleshoot the issue:

1. Double-check that you have enabled "Discussions" in your repository settings. Go to your GitHub repository, click on the "Settings" tab, scroll down to the "Features" section, and ensure that the "Discussions" checkbox is checked.

2. Make sure you're using the correct repository name in the giscus configuration page. The repository name should be in the format `username/repository`, in your case, it should be `rabestro/rabestro.github.io`.

3. Ensure that you're logged in to your GitHub account when accessing the giscus configuration page. If you're not logged in, you might not have the necessary permissions to enable giscus for your repository.

4. Verify that your GitHub account has the necessary permissions for the repository. You should have admin access to the repository to enable giscus.

If you've checked all of the above and are still encountering the issue, it might be a temporary problem with the giscus service. In that case, I recommend waiting for a while and trying again later.

If the issue persists, you can consider using an alternative commenting system like [utterances](https://utteranc.es/) or [Disqus](https://disqus.com/), both of which are also supported by the Chirpy Jekyll Theme.

👤 I forget to install `giscus`. "Okay, giscus was installed on the @rabestro account." :)

🤖 Great! Now that you have installed giscus, you should be able to proceed with the configuration steps I mentioned earlier. Just to recap, follow these steps:

1. Go to the [giscus configuration page](https://giscus.app).
2. Fill in the required fields:
   - Repository: `rabestro/rabestro.github.io`
   - Category: `General` (or any other category you prefer)
   - Mapping: `pathname`
   - Input position: `bottom`
   - Language: `en`
   - Reactions enabled: `Yes`

3. Click "Preview widget".
4. Scroll down to the "Configuration" section and copy the `data-repo-id` and `data-category-id` values.

Now, update your `_config.yml` file with the giscus configuration:

1. Locate the `comments` section in your `_config.yml` file.
2. Set the `active` option to `giscus`:

```yaml
comments:
  active: giscus
```

3. Fill in the `giscus` options:

```yaml
  giscus:
    repo: rabestro/rabestro.github.io
    repo_id: # Your repository ID (copied from the giscus configuration page)
    category: General
    category_id: # Your category ID (copied from the giscus configuration page)
    mapping: pathname
    input_position: bottom
    lang: en
    reactions_enabled: 1
```

After making these changes, commit and push your updated `_config.yml` file to your GitHub repository. Giscus comments should now be enabled on your site.

If you have any further questions or need assistance, feel free to ask.

👤 Tell me more and compare "Discussions Mapping"

🤖 In giscus, "Discussions Mapping" determines how the comments on your website are linked to GitHub Discussions in your repository. There are several mapping options available, each with its own advantages and use cases. Here's a comparison of the different mapping options:

1. **URL**: This option maps the comments to a GitHub Discussion based on the full URL of the page. This is useful if you want to ensure that each page on your website has a unique discussion thread, even if the page title or pathname changes. However, if your website's domain changes, the comments will no longer be linked to the correct discussion threads.

2. **Pathname**: This option maps the comments to a GitHub Discussion based on the pathname of the page (excluding the domain). This is useful if you want to maintain the same discussion threads even if your website's domain changes. However, if the pathname of a page changes, the comments will no longer be linked to the correct discussion thread.

3. **Title**: This option maps the comments to a GitHub Discussion based on the title of the page. This is useful if you want to maintain the same discussion threads even if the URL or pathname of a page changes. However, if the title of a page changes, the comments will no longer be linked to the correct discussion thread.

4. **OG:title**: This option maps the comments to a GitHub Discussion based on the Open Graph title (`og:title`) of the page. This is useful if you want to maintain the same discussion threads even if the URL, pathname, or visible title of a page changes. However, if the Open Graph title of a page changes, the comments will no longer be linked to the correct discussion thread.

5. **Link**: This option maps the comments to a GitHub Discussion based on the canonical link (`link[rel=canonical]`) of the page. This is useful if you want to maintain the same discussion threads even if the URL, pathname, or title of a page changes. However, if the canonical link of a page changes, the comments will no longer be linked to the correct discussion thread.

6. **Issue number**: This option maps the comments to a specific GitHub Discussion by its issue number. This is useful if you want to manually link a page to a specific discussion thread. However, this requires manually updating the issue number for each page on your website.

In summary, the best mapping option for your website depends on your specific requirements and how you expect your website's content to change over time. If you want to maintain the same discussion threads even if your website's domain, pathname, or title changes, consider using the "OG:title" or "Link" mapping options. If you want a simpler approach and don't expect your website's content to change significantly, the "Pathname" or "Title" mapping options might be more suitable.

For more information on giscus mapping options, you can refer to the [official giscus documentation](https://giscus.app/docs/configuration#mapping).

👤 Please explain OG:title 

🤖 `OG:title` stands for Open Graph title, which is a part of the Open Graph protocol. The Open Graph protocol is a set of meta tags that allows you to control how your web pages are displayed when shared on social media platforms like Facebook, Twitter, and LinkedIn. These meta tags provide information about the page, such as the title, description, and image, to create a rich preview when the page is shared.

The `OG:title` meta tag specifically defines the title of your web page as it should appear when shared on social media platforms. It is usually placed in the `<head>` section of your HTML document and looks like this:

```html
<meta property="og:title" content="Your Page Title" />
```

When using the `OG:title` mapping option in giscus, the comments on your website will be linked to a GitHub Discussion based on the Open Graph title of the page. This means that even if the URL, pathname, or visible title of a page changes, the comments will still be linked to the correct discussion thread, as long as the Open Graph title remains the same.

To use the `OG:title` mapping option in giscus, update your `_config.yml` file with the following configuration:

```yaml
comments:
  active: giscus
  giscus:
    repo: rabestro/rabestro.github.io
    repo_id: # Your repository ID (copied from the giscus configuration page)
    category: General
    category_id: # Your category ID (copied from the giscus configuration page)
    mapping: og:title
    input_position: bottom
    lang: en
    reactions_enabled: 1
```

Make sure that your web pages have the `og:title` meta tag in their `<head>` section. If you're using Jekyll, you can add the `og:title` meta tag to your theme's layout files, such as `_layouts/default.html` or `_includes/head.html`.

For more information on the Open Graph protocol, you can refer to the [official Open Graph documentation](https://ogp.me/).

👤 ok, I prefer the ordinal title

🤖 If you prefer to use the visible page title for mapping comments to GitHub Discussions, you can set the `mapping` option to `title` in your `_config.yml` file. Here's the updated giscus configuration:

```yaml
comments:
  active: giscus
  giscus:
    repo: rabestro/rabestro.github.io
    repo_id: # Your repository ID (copied from the giscus configuration page)
    category: General
    category_id: # Your category ID (copied from the giscus configuration page)
    mapping: title
    input_position: bottom
    lang: en
    reactions_enabled: 1
```

With this configuration, giscus will map the comments on your website to GitHub Discussions based on the visible title of the page. Keep in mind that if the title of a page changes, the comments will no longer be linked to the correct discussion thread.

After updating your `_config.yml` file, commit and push the changes to your GitHub repository. Giscus comments should now be enabled on your site and mapped based on the page title.

If you have any further questions or need assistance, feel free to ask.

👤 What "Discussion Category" is better to use?

🤖 The choice of "Discussion Category" depends on your preferences and the content of your website. Categories help organize discussions in your GitHub repository and make it easier for users to find and participate in relevant conversations.

Here are some suggestions for choosing a "Discussion Category" for your website:

1. **General**: This is a good default choice if you don't have a specific category in mind. It can be used for a wide range of topics and discussions related to your website's content.

2. **Blog Comments**: If your website is primarily a blog, you can create a "Blog Comments" category to keep all the comments on your blog posts organized in one place.

3. **Tutorials**: If your website contains tutorials or guides, you can create a "Tutorials" category for discussions related to those specific topics.

4. **Q&A**: If you want to encourage users to ask questions and get answers from you or other community members, you can create a "Q&A" category.

5. **Feedback**: If you want to collect feedback on your website, articles, or projects, you can create a "Feedback" category.

To create a new category in your GitHub repository, follow these steps:

1. Go to your GitHub repository and click on the "Discussions" tab.
2. Click on the "New discussion" button.
3. Click on the "Select a category" dropdown menu and choose "Create a new category".
4. Enter the name and description for your new category and click "Create category".

Once you've created the desired category, use its name in the giscus configuration in your `_config.yml` file:

```yaml
comments:
  active: giscus
  giscus:
    repo: rabestro/rabestro.github.io
    repo_id: # Your repository ID (copied from the giscus configuration page)
    category: Your Category Name
    category_id: # Your category ID (copied from the giscus configuration page)
    mapping: title
    input_position: bottom
    lang: en
    reactions_enabled: 1
```

Remember to replace `Your Category Name` with the actual name of the category you created.

After updating your `_config.yml` file, commit and push the changes to your GitHub repository. Giscus comments should now be enabled on your site and organized under the chosen category.

If you have any further questions or need assistance, feel free to ask.

👤 Tell me more about "input_position"

🤖 The `input_position` option in giscus configuration determines the position of the comment input box relative to the existing comments on your website. There are two available options for `input_position`:

1. **top**: This option places the comment input box above the existing comments. This can be useful if you want to encourage users to leave a comment before reading the existing comments, or if you expect a high volume of comments and want to make it easy for users to find the input box.

2. **bottom**: This option places the comment input box below the existing comments. This is the default and most common choice, as it allows users to read through the existing comments before leaving their own comment.

To set the `input_position` option in your giscus configuration, update your `_config.yml` file as follows:

```yaml
comments:
  active: giscus
  giscus:
    repo: rabestro/rabestro.github.io
    repo_id: # Your repository ID (copied from the giscus configuration page)
    category: Your Category Name
    category_id: # Your category ID (copied from the giscus configuration page)
    mapping: title
    input_position: top # or 'bottom'
    lang: en
    reactions_enabled: 1
```

Replace `top` with `bottom` if you prefer the comment input box to be placed below the existing comments.

After updating your `_config.yml` file, commit and push the changes to your GitHub repository. The comment input box position should now be updated on your site.

If you have any further questions or need assistance, feel free to ask.
