module Dmpopidor
  module Controllers
    module StaticPages
      # Changed News feed
      def news_feed
        dcc_news_feed_url = "https://opidor.fr/category/dmp-news/feed/"
        @dcc_news_feed = Feedjira::Feed.fetch_and_parse dcc_news_feed_url
        respond_to do |format|
          format.rss { redirect_to dcc_news_feed_url }
          format.html
        end
      end
    
      # Added Tutorials Page
      def tutorials
  
      end

      def optout

      end
    end
  end
end