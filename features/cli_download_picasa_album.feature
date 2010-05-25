Feature: CLI download picasa album
  In order to quickly download all the images in someone's picasa album

  Scenario: Download all images by album URL into current folder
    When I run local executable "pablo" with arguments "http://picasaweb.google.se/someuser/somealbum"
    Then folder "someuser/somealbum" is created
    And folder "someuser/somealbum" contains 237 images
  
  
  
