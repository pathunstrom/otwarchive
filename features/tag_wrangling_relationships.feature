@tags @users

Feature: Tag Wrangling - Relationships

Scenario: relationship wrangling - syns, mergers, characters, autocompletes

  Given the following activated tag wrangler exists
    | login  | password    |
    | Enigel | wrangulate! |
    And basic tags
    And a fandom exists with name: "Torchwood", canonical: true
    And a character exists with name: "Hoban Washburne", canonical: true
    And a character exists with name: "Zoe Washburne", canonical: true
    And a character exists with name: "Jack Harkness", canonical: true
    And a character exists with name: "Ianto Jones", canonical: true
    And I am logged in as "Enigel" with password "wrangulate!"
    And I follow "Tag Wrangling"
    
  # create a new canonical relationship from tag wrangling interface
    And I follow "New Tag"
    And I fill in "Name" with "Jack Harkness/Ianto Jones"
    And I choose "Relationship"
    And I check "tag_canonical"
    And I press "Save changes"
  Then I should see "Tag was successfully created"
    And the "tag_canonical" checkbox should be checked
    And the "tag_canonical" checkbox should not be disabled
  
  # create a new non-canonical relationship from tag wrangling interface
  When I follow "New Tag"
    And I fill in "Name" with "Wash/Zoe"
    And I choose "Relationship"
    And I press "Save changes"
  Then I should see "Tag was successfully created"
    And the "tag_canonical" checkbox should not be checked
    And the "tag_canonical" checkbox should not be disabled
  
  # assigning characters AND a new merger to a non-canonical relationship
  When I fill in "Characters" with "Hoban Washburne, Zoe Washburne"
    And I fill in "Synonym of" with "Hoban Washburne/Zoe Washburne"
    And I press "Save changes"
  Then I should see "Tag was updated"
  When I follow "Hoban Washburne/Zoe Washburne"
  Then I should see "Hoban Washburne" within "ul.tags"
    And I should see "Zoe Washburne" within "ul.tags"
    And I should see "Make tag non-canonical and unhook all associations"
    And I should see "Wash/Zoe"
    And the "tag_canonical" checkbox should be checked
    And the "tag_canonical" checkbox should be disabled
    
  # creating a new canonical relationship by renaming
  When I fill in "Synonym of" with "Hoban 'Wash' Washburne/Zoe Washburne"
    And I press "Save changes"
  Then I should see "Tag was updated"
    And I should not see "Synonyms"
  When I follow "Hoban 'Wash' Washburne/Zoe Washburne"
  Then I should see "Make tag non-canonical and unhook all associations"
    And I should see "Wash/Zoe"
    And I should see "Hoban Washburne/Zoe Washburne"
    And I should see "Hoban Washburne" within "ul.tags"
    And I should see "Zoe Washburne" within "ul.tags"
    And the "tag_canonical" checkbox should be checked
    And the "tag_canonical" checkbox should be disabled
  
  # creating non-canonical relationships from work posting
  When I go to the new work page
    And I select "Not Rated" from "Rating"
    And I check "No Archive Warnings Apply"
    And I fill in "Fandoms" with "Torchwood"
    And I fill in "Work Title" with "Silliness"
    And I fill in "Relationships" with "Janto, Jack/Ianto"
    And I fill in "content" with "And then everyone was kidnapped by an alien bus."
    And I press "Preview"
    And I press "Post"
  Then I should see "Work was successfully posted."
  
  # editing non-canonical relationship in order to syn it to existing canonical merger AND add characters
  When I follow "Jack/Ianto"
    And I follow "Edit"
    And I fill in "Synonym of" with "Jack H"
  Then I should find "Jack Harkness/Ianto Jones" within ".auto_complete"
  When I fill in "Synonym of" with "Jack Harkness/Ianto Jones"
    And I fill in "Characters" with "Jack H"
    And I should find "Jack Harkness" within ".auto_complete"
    And I fill in "Characters" with "Jack Harkness, Ianto Jones"
    And I fill in "Fandoms" with "Tor"
    And I should find "Torchwood" within ".auto_complete"
    And I fill in "Fandoms" with "Torchwood"
    And I press "Save changes"
  Then I should see "Tag was updated"
  
  # adding a non-canonical synonym to a canonical, fandom should be copied
  When I follow "Jack Harkness/Ianto Jones"
  Then I should see "Jack Harkness" within "ul.tags"
    And I should see "Ianto Jones" within "ul.tags"
    And I should see "Torchwood"
    And I should see "Jack/Ianto"
    And the "tag_canonical" checkbox should be disabled
  When I fill in "Synonyms" with "Jant"
  Then I should find "Janto" within ".auto_complete"
  When I fill in "Synonyms" with "Janto"
    And I press "Save changes"
  Then I should see "Tag was updated"
    And I should see "Janto"
  When I follow "Janto"
  Then I should see "Torchwood"
    But I should not see "Jack Harkness" within "ul.tags"
    And I should not see "Ianto Jones" within "ul.tags"
  
  # metatags and subtags, transference thereof to a new canonical
  When I follow "Jack Harkness/Ianto Jones"
    And I fill in "MetaTags" with "Jack Harkness/Male Character"
    And I press "Save changes"
  Then I should see "Tag was updated"
    But I should not see "Jack Harkness/Male Character"
  When I follow "New Tag"
    And I fill in "Name" with "Jack Harkness/Male Character"
    And I check "tag_canonical"
    And I choose "Relationship"
    And I press "Save changes"
    And I fill in "SubTags" with "Jack Harkness"
  Then I should find "Jack Harkness/Ianto Jones" within ".auto_complete"
  When I fill in "SubTags" with "Jack Harkness/Ianto Jones"
    And I press "Save changes"
  Then I should see "Tag was updated"
  When I follow "Jack Harkness/Ianto Jones"
  Then I should see "Jack Harkness/Male Character"
  When I follow "New Tag"
    And I fill in "Name" with "Jack Harkness/Robot Ianto Jones"
    And I choose "Relationship"
    And I check "tag_canonical"
    And I press "Save changes"
    And I fill in "MetaTags" with "Jack Harkness/Ianto Jones"
    And I press "Save changes"
  Then I should see "Tag was updated"
  When I follow "Jack Harkness/Ianto Jones"
  Then I should see "Jack Harkness/Robot Ianto Jones"
    And I should see "Jack Harkness/Male Character"
  When I fill in "Synonym of" with "Captain Jack Harkness/Ianto Jones"
    And I press "Save changes"
  Then I should see "Tag was updated"
    And I should not see "Jack Harkness/Robot Ianto Jones"
    And I should not see "Jack Harkness/Male Character"
    And I should not see "Janto"
    And I should not see "Jack/Ianto"
  When I follow "Captain Jack Harkness/Ianto Jones"
  Then I should see "Jack Harkness/Robot Ianto Jones"
    And I should see "Jack Harkness/Male Character"
    And I should see "Janto"
    And I should see "Jack/Ianto"
    And I should see "Jack Harkness/Ianto Jones" within "ul.tags"
    
  # trying to syn a non-canonical to another non-canonical
  When I follow "New Tag"
    And I fill in "Name" with "James Norrington/Jack Sparrow"
    And I choose "Relationship"
    And I press "Save changes"
    And I follow "New Tag"
    And I fill in "Name" with "Sparrington"
    And I choose "Relationship"
    And I press "Save changes"
    And I fill in "Synonym of" with "James Norrington/Jack Sparrow"
    And I press "Save changes"
  Then I should see "James Norrington/Jack Sparrow is not a canonical tag. Please make it canonical before adding synonyms to it."

  # trying to syn a non-canonical to a canonical of a different category
  When I fill in "Synonym of" with "Torchwood"
    And I press "Save changes"
  Then I should see "Torchwood is a fandom. Synonyms must belong to the same category."