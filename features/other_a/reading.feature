@users
Feature: Reading count

  Scenario: only see own reading history
    Given the following activated user exists
    | login          | password   |
    | first_reader        | password   |
  When I am logged in as "second_reader"
    And I go to first_reader's reading page
    Then I should see "Sorry, you don't have permission"
    And I should not see "History" within "div#dashboard"
  When I go to second_reader's reading page
    Then I should see "History" within "div#dashboard"
    
  Scenario: Read a work several times, counts show on reading history
      increment the count whenever you reread a story
      also updates the date
    Given I am logged in as "writer"
      And I post the work "some work"
      And I am logged out
    When I am logged in as "fandomer"
      And fandomer first read "some work" on "2010-05-25"
    When I go to fandomer's reading page
    Then I should see "some work"
      And I should see "Viewed once"
      And I should see "Last viewed: 25 May 2010"
    When I am on writer's works page
      And I follow "some work"
    When the reading rake task is run
      And I go to fandomer's reading page
    Then I should see "Viewed 2 times"
      And I should see "Last viewed: less than 1 minute ago"

  Scenario: disable reading history
    then re-enable and check counts update again

    Given I am logged in as "writer"
      And I post the work "some work"
      And I am logged out
    When I am logged in as "fandomer"
      And fandomer first read "some work" on "2010-05-25"
    When I go to fandomer's reading page
    Then I should see "some work"
      And I should see "Viewed once"
      And I should see "Last viewed: 25 May 2010"    
    When I follow "Preferences"
      And I uncheck "Turn on Viewing History"
      And I press "Update"
    Then I should not see "My History"
    When I am on writer's works page
      And I follow "some work"
    When I am on writer's works page
      And I follow "some work"
    When the reading rake task is run
      And I go to fandomer's reading page
    Then I should see "You have reading history disabled"
      And I should not see "some work"
    When I check "Turn on Viewing History"
      And I press "Update"
    Then I should see "Your preferences were successfully updated."
    When I go to fandomer's reading page
    Then I should see "Viewed once"
      And I should see "Last viewed: 25 May 2010"
    When I am on writer's works page
      And I follow "some work"
    When the reading rake task is run
      And I go to fandomer's reading page
    Then I should see "Viewed 2 times"
      And I should see "Last viewed: less than 1 minute ago"

  Scenario: Clear entire reading history

    Given I have loaded the fixtures
      And the work indexes are updated
    When I am logged in as "fandomer"
      And I am on testuser's works page
      And I follow "First work"
      And I am on testuser's works page
      And I follow "second work"
      And I am on testuser2's works page
      And I follow "fifth"
      And I should see "fifth by testuser2"
      And I follow "Proceed"
      And the reading rake task is run
    When I go to fandomer's reading page
    Then I should see "History" within "div#dashboard"
      And I should see "First work"
      And I should see "second work"
      And I should see "fifth"
      But I should not see "fourth"
    When I follow "Clear History"
      Then I should see "Your history is now cleared"
      And I should see "History" within "div#dashboard"
      But I should not see "First work"
      And I should not see "second work"
      And I should not see "fifth"

  Scenario: Mark a story to read later

  Given I am logged in as "writer"
  When I post the work "Testy"
  Then I should see "Work was successfully posted"
  When I am logged out
    And I am logged in as "reader"
    And I view the work "Testy"
  Then I should see "Mark for Later"
  When I follow "Mark for Later"
  Then I should see "This work was added to your Marked for Later list."
    And I go to reader's reading page
  Then I should see "Testy"
    And I should see "(Marked for Later.)"
  When I view the work "Testy"
  Then I should see "Mark as Read"
  When I follow "Mark as Read"
  Then I should see "This work was removed from your Marked for Later list."
    And I go to reader's reading page
  Then I should see "Testy"
    And I should not see "(Marked for Later.)"

  Scenario: You can't mark a story to read later if you're not logged in or the author

  Given I am logged in as "writer"
  When I post the work "Testy"
  Then I should see "Work was successfully posted"
  When I view the work "Testy"
  Then I should not see "Mark for Later"
    And I should not see "Mark as Read"
  When I am logged out
    And I view the work "Testy"
  Then I should not see "Mark for Later"
    And I should not see "Mark as Read"

  Scenario: Multi-chapter works are added to history, can be deleted from history, are updated every time the user accesses a chapter, and can be marked for later

  Given I am logged in as "writer"
    And I post the work "multichapter work"
    And a chapter is added to "multichapter work"
  Then I should see "multichapter work"
  When I am logged out
    And I am logged in as "fandomer"
    And I view the work "multichapter work"
  When the reading rake task is run
    And I go to fandomer's reading page
  Then I should see "multichapter work"
    And I should see "Viewed once"
  When I press "Delete from History"
  Then I should see "Work successfully deleted from your history."
  When I view the work "multichapter work"
    And the reading rake task is run
  When I go to fandomer's reading page
  Then I should see "multichapter work"
    And I should see "Viewed once"
  When I view the work "multichapter work"
    And I follow "Next Chapter"
    And the reading rake task is run
  When I go to fandomer's reading page
  Then I should see "multichapter work"
  When "intermittent failure" is fixed
    # I should see "Viewed 3 times"
  When I view the work "multichapter work"
    And I follow "Next Chapter"
  When I follow "Mark for Later"
  Then I should see "This work was added to your Marked for Later list."
    And I go to fandomer's reading page
  Then I should see "multichapter work"
  When "intermittent failure" is fixed
    # I should see "Viewed 5 times"
    And I should see "(Marked for Later.)"

  Scenario: A user can see some of their works marked for later on the homepage

  Given the work "Maybe Tomorrow"
    And I am logged in as "testy"
  When I mark the work "Maybe Tomorrow" for later
    And I go to the homepage
  Then I should see "Is it later already?"
    And I should see "Some works you've marked for later."
    And I should see "Maybe Tomorrow"

  Scenario: A user cannot see works marked for later on the homepage if they have their reading history disabled

  Given the work "Maybe Tomorrow"
    And I am logged in as "testy"
  When I mark the work "Maybe Tomorrow" for later
    And I set my preferences to turn off viewing history
  When I go to the homepage
  Then I should not see "Is it later already?"
    And I should not see "Some works you've marked for later."
    And I should not see "Maybe Tomorrow"

  Scenario: A user can delete a work marked for later from their history on the homepage

  Given the work "Not Ever"
    And I am logged in as "testy"
  When I mark the work "Not Ever" for later
    And I go to the homepage
  Then I should see "Not Ever"
    And I should see a "Delete from History" button
  When I press "Delete from History"
  Then I should see "Work successfully deleted from your history."
    And I should be on the homepage
    And I should not see "Is it later already?"
    And I should not see "Some works you've marked for later."
    And I should not see "Not Ever"

  Scenario: When a user marks a work for later and the creator deletes that work, the marked for later blurb on their homepage should be replaced with a "Deleted work" placeholder

  Given I am logged in as "golucky" with password "password"
    And I post the work "Gone Gone Gone"
    And I am logged out
  When I am logged in as "reader" with password "password"
    And I mark the work "Gone Gone Gone" for later
    And the reading rake task is run
    And I am logged out
  When I am logged in as "golucky" with password "password"
    And I delete the work "Gone Gone Gone"
    And I am logged out
  When I am logged in as "reader" with password "password"
    And I go to the homepage
  Then I should see "Deleted work"
    And I should not see "Gone Gone Gone"
  When I go to reader's reading page
  Then I should see "Deleted work"
    And I should not see "Gone Gone Gone"
  When I follow "Marked for Later"
  Then I should see "Deleted work"
    And I should not see "Gone Gone Gone"

  Scenario: When a user marks a work for later and the creator updates that work, the marked for later blurb on their homepage should update

  Given I am logged in as "editor" with password "password"
    And I post the work "Some Work V1"
    And I am logged out
  When I am logged in as "reader" with password "password"
    And I mark the work "Some Work V1" for later
    And the reading rake task is run
    And I am logged out
  When I am logged in as "editor" with password "password"
    And I edit the work "Some Work V1"
    And I fill in "Work Title" with "Some Work V2"
    And I press "Post Without Preview"
    And I am logged out
  When I am logged in as "reader" with password "password"
    And I go to the homepage
  Then I should see "Some Work V2"
    And I should not see "Some Work V1"
