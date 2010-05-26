Feature: CLI download picasa album
  In order to quickly download all the images in someone's picasa album

  Scenario: Download all images by album URL into current folder
    Given I expect to fetch "http://picasaweb.google.se/someuser/somealbum" but use "album.html"
    And I expect to use curl to fetch files
    When I run executable internally with arguments "http://picasaweb.google.se/someuser/somealbum"
    Then folder "someuser/somealbum" is created
    And I expect to curl 237 files
  
  
  
