This is the source of [sapienshabitat.com](http://sapienshabitat.com).

## Information architecture and URL design

Rowan has decided _against_ using any type of namespaces in the URL structure.
_What kind_ of content you're looking at should become obvious from looking at
it. Even though the site is technically a blog, publication dates are not
exposed in the URLs.

As an example, here follows the URL of what will be the first article on this
site:

    http://sapienshabitat.com/wallflower-refuge/

Yes, there will be a ending slash, because that makes working with the source
files easier.

There won't be separate taxonomy pages, like `/tag/permaculture` or
`/scope/garden`. Instead, taxonomies will be revealed on the home page:

    http://sapienshabitat.com/

This will basically be a sitemap with various visual areas with the different
taxonomic categories.

Additionally, all/some taxonomically related pages will be revealed in the
navigation area of each page.

## Source format and transformation

Page content is written in Markdown. Each page has its own subdirectory in
`/pages/`. The Markdown files have a YAML header. The YAML metadata includes a
`taxonomy` part with is combined with the project-wide `taxonomy.yaml` file.
