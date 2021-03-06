# DocPad Configuration File
# http://docpad.org/docs/config

cheerio = require('cheerio')
url = require('url')

# Define the DocPad Configuration
docpadConfig = {

  environments:
    development:
      templateData:
        site:
          url: 'http://localhost:9778'

	templateData:
		# Specify some site properties
		site:
			# The production url of our website
			url: "http://erajasekar.github.io"

			# The default title of our website
			title: "Rajasekar Elango's blog"

			# The website author's name
			author: "Rajasekar Elango"

			# The website author's email
			email: "e.rajasekar@gmail.com"

			services :
				#buttons: ['FacebookLike']
				facebookLikeButton:
					applicationId: '879531558743071'

				twitterTweetButton: 'erajasekar'
				googlePlusOneButton: true


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} by #{@site.author}"
				# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		getPageUrlWithHostname: ->
			"#{@site.url}#{@document.url}"

		getIdForDocument: (document) ->
			hostname = url.parse(@site.url).hostname
			date = document.date.toISOString().split('T')[0]
			path = document.url
			"tag:#{hostname},#{date},#{path}"

		getOldUrl: (newUrl) ->
			newUrl.substr(0,newUrl.length-1) + '.html'

		fixLinks: (content, baseUrlOverride) ->
			baseUrl = @site.url
			if baseUrlOverride
				baseUrl = baseUrlOverride
			regex = /^(http|https|ftp|mailto):/

			$ = cheerio.load(content)
			$('img').each ->
				$img = $(@)
				src = $img.attr('src')
				$img.attr('src', baseUrl + src) unless regex.test(src)
			$('a').each ->
				$a = $(@)
				href = $a.attr('href')
				$a.attr('href', baseUrl + href) unless regex.test(href)
			$.html()

		moment: require('moment')

		getJavascriptEncodedTitle: (title) ->
			title.replace("'", "\\'")

		# Discus.com settings
		disqusShortName: 'erajasekarblog'

		# Google+ settings
		googlePlusId: '102844251118280588957'

	collections:
		posts: ->
			@getCollection("html").findAllLive({layout: 'post', draft: $exists: false},[{date:-1}])
		menuPages: ->
			@getCollection("html").findAllLive({menu: $exists: true},[{menuOrder:1}])

	plugins:
    paged:
      cleanurl:true
      startingPageNumber:2
    tagging:
      collectionName: 'posts'
      indexPageLowercase: true
    cleanurls:
      trailingSlashes: true
    ghpages:
      deployRemote: 'target'
      deployBranch: 'master'
}

# Export the DocPad Configuration
module.exports = docpadConfig
