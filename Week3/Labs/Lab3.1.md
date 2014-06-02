Lab 3.1
---

In this lab, we'll dive into connecting Smarticle to a web service.  In particular, we'll be using the New York Times' Most Popular API to pull down articles that have been the most emailed, shared or viewed in the last week.

Objectives
---
- Use NSURLSession to download data from the NY Times API
- Learn the basics of parsing a JSON formatted response
- Become familiar with basic concurrency and proper usage of the main thread

Basic structure
---
The first step in connecting to the web service will be making a simple HTTP request.  Before we do that, we'll need a way of determining when and what to request.

Remember from last time, our list view controller is responsible for providing two things to the table view:

1. The number of cells in the table view.
2. An individual cell view for a given index on-demand.  

Previously, we accomplished this using an array populated with static results.  Instead, we now want to retrieve those results from the API.  ArticleProvider's job will be to do just that.  For starters, take a look at ArticleProvider.h, especially these two methods:

**ArticleProvider.h**
```Objective-C

- (Article *)articleAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfArticles;

```

Seems oddly familiar.  These methods give us the ability to satisfy our adoption of the UITableViewDataSource protocol in ListViewController.  Mostly all we have to do is swap ArticleProvider in for the array we were using previously.

Grab Smarticle3.1 from the Week3 folder and you'll see that this swap has already been made.  There are a few other interesting changes to this class as well, which we'll discuss in a bit.

Run the project, click the articles button and check the console:

	Smarticle[11898:60b] Load articles for offset 0 here!
	
Perfect (besides that blank wall of cells you're staring at).

Following -objectAtIndex
---
What just happened?  Let's walk through the code from the view controller's perspective.  Open up ArticlesProvider.m and find the implementation for articleAtIndex:

**ArticleProvider.m**
```Objective-C

- (Article *)articleAtIndex:(NSUInteger)index
{
    if (index < self.articles.count)
    {
        return [self.articles objectAtIndex:index];
    }
    else
    {
        [self loadMoreArticles];
        return nil;
    }
}
```

Notice, `self.articles` holds all the articles that have been loaded thus far.  When asked for an article that has not been loaded, we call `[self loadMoreArticles]` and return `nil`.

Now, head on over to loadMoreArticles.

**ArticleProvider.m**
```Objective-C
- (void)loadMoreArticles
{
    if (!self.loading)
    {
        self.loading = YES;
        
        NSUInteger nextOffset = self.offset + ArticleProviderPageSize;
        
        if (self.articleCount == 0 || nextOffset < self.articleCount)
        {
            [self loadArticlesForOffset:nextOffset];
        }
    }
}
```

This method uses the current offset to figure out the next offset in order to load the next page's worth of articles.  Neat.  Finally, navigate to loadArticlesForOffset: where you'll find the meat of the class and where our log statement lives.  This is where we'll make our request.

Making a request
---

First, we need to create the appropriate NSURL.  You can refer to the NSURL documentation and the NY times [Most Popular API](http://developer.nytimes.com/docs/read/most_popular_api) for more details.

Replace the NSLog statement in loadArticlesForOffset: with the following:
```Objective-C

    NSString *requestString = [ArticleProviderNYTimesBaseURI stringByAppendingFormat:
                               @"%@/all-sections/7.json?api-key=%@&offset=%zd",
                               self.resourceType,
                               ArticleProviderNYTimesAPIKey,
                               offset];
    
    NSURL *url = [NSURL URLWithString:requestString];

```
- stringByAppendingFormat takes the base url and appends the resource type, api key and the offset parameter to create a fully formed Most Popular API URL.
- URLWithString converts the requestString into an NSURL, suitable for using in making requests

Now, use NSURLSession to make a request with your brand new URL:

```Objective-C
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                 	NSLog(@"response = %@", response);
                                 }] resume];
```
- `[NSURLSession sharedSession]` give us the default shared session with the default configuration.
- `dataTaskWithURL:completionHandler` creates and configures a new NSURLDataTask based on the session, destined for the given URL.
- Calling `resume` on the task tells it to immediately begin executing the request.
- The completionHandler block is called when the request completes.  For now, we're just logging resposne object.

Let's take a moment to see how we're doing.  Hit play, tap the Articles button and you should see:

```
Smarticle[12173:1303] response = <NSHTTPURLResponse: 0x109b161c0> { URL: http://api.nytimes.com/svc/mostpopular/v2/mostemailed/all-sections/7.json?api-key=00edfc4660e9ccd3d484598a6aafd603:11:68426625&offset=0 } { status code: 200, headers {
    "Accept-Ranges" = bytes;
    Age = 0;
    "Content-Length" = 43092;
    "Content-Type" = "application/json; charset=UTF-8";
    Date = "Mon, 02 Jun 2014 20:22:51 GMT";
    Server = "nginx/1.4.1";
    Via = "1.1 varnish";
    "X-Cache" = MISS;
    "X-Mashery-Responder" = "prod-j-worker-atl-02.mashery.com";
    "X-Powered-By" = "PHP/5.5.10";
    "X-Varnish" = 1097622373;
} }
```
If not, check the following:
- Make sure you're calling `-resume` on the task to start it.
- Check the URL you created and compare it with the NY time API docs.

Error checking
---
Assuming the request succeeds, the completionHandler's error parameter will be nil.  Otherwise, if the request times out or fails for any reason, the error parameter will contain an NSError object describing the error.  Since we want robust networking code, let's check for the error and call a method to notify the view controller of what happened.

```Objective-C
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
        {
            [self finishLoadingWithError:error];
            return;
        }
        
        NSLog(@"response = %@", response);
    }] resume];
```
- Take a look at `finishLoadingWithError:`.  It just calls the delegate, making sure that we're on the main thread.
- Test this out by turning off your wifi.  You should see an alert view pop up when you visit the list view controller.

More error checking
---
We're not quite out of the woods yet.  Even if the request succeeds, that only means that we've received a response.  Depending on the web server, different HTTP response status codes will be returned to indicate various error states.  Find the method `-acceptsResponse:error:` that for now just returns YES.  This method should return YES for all valid responses and NO otherwise, populating an NSError object with a description of the problem. In general, we'll want to refer to the API documentation when implementing this type of error checking.

Here's how we'll do it:
```Objective-C
- (BOOL)acceptsResponse:(NSHTTPURLResponse *)response
                  error:(NSError **)error
{
    NSUInteger statusCode = response.statusCode;
    
    if (statusCode == 200)
    {
        return YES;
    }
    else
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:statusCode],
                                   NSURLErrorFailingURLErrorKey: [response URL]};
        *error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:userInfo];
        return NO;
    }
}
```

And in our `-loadArticlesForOffset:` method, let's call it at the bottom of our completion handler:

```Objetive-C
...
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          if (error)
          {
              [self finishLoadingWithError:error];
              return;
          }
          
          NSError *responseError;
          if (![self acceptsResponse:(NSHTTPURLResponse *)response error:&responseError])
          {
              [self finishLoadingWithError:responseError];
              return;
          }
          
          NSLog("response = %@", response);
	}] resume];
          
```

Parsing
---

We're finally ready to parse some JSON.  We'll use the builtin parser class, NSJSONSerialization.  Add this to the bottom of your completion handler:

```Objective-C
          id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&responseError];
          if (!json)
          {
              [self finishLoadingWithError:responseError];
              return;
          }
```
- Notice we're checking for errors one last time.  This time around we'll see if somewhow the server returned malformed JSON.
- The object returned from `JSONObjectWithData` is either an NSArray or NSDictionary, depending on whether the root of the JSON document is an array or an object.

Finishing up
---

Last of all, we'll call a method `-finishLoadingWithJSON:offset:` to convert the JSON objects into plain old Article objects.  Replace the NSLog statement with this call, passing in the json objects and the offset parameter.

For reference, here's the completed `loadArticlesForOffset:` method:

```Objective-C
- (void)loadArticlesForOffset:(NSUInteger)offset
{
    NSString *requestString = [ArticleProviderNYTimesBaseURI stringByAppendingFormat:
                               @"%@/all-sections/7.json?api-key=%@&offset=%zd",
                               self.resourceType,
                               ArticleProviderNYTimesAPIKey,
                               offset];
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error)
          {
              [self finishLoadingWithError:error];
              return;
          }
          
          NSError *responseError;
          if (![self acceptsResponse:(NSHTTPURLResponse *)response error:&responseError])
          {
              [self finishLoadingWithError:responseError];
              return;
          }
          
          id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&responseError];
          if (!json)
          {
              [self finishLoadingWithError:responseError];
              return;
          }
          
          [self finishLoadingWithJSON:json
                               offset:offset];
          
      }] resume];
}

```

-finishLoadingWithJSON:offset:
---
Navigate to the implementation of `finishLoadingWithJSON:offset:`.  This is where we will extract objects from the JSON dictionary, update the current offset and finally notify the delegate that new articles are available.

Implement first TODO item with the following:

```Objective-C
        // TODO Set the article count from the JSON.
        NSNumber *numResults = json[@"num_results"];
        self.articleCount = [numResults unsignedIntegerValue];
```

And the second one with this:

```Objective-C
        // TODO Parse the articles from the JSON and add them to self.articles
        NSArray *resultsArray = json[@"results"];
        NSArray *articles = [Article articlesForJSON:resultsArray];
        [self.articles addObjectsFromArray:articles];
```
- The articlesForJSON: method returns an array of articles when given a properly structured JSON array.
- Articles are added to the end of the existing array.

Alright.  Run it now and see the articles loading in.