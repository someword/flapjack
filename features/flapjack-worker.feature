Feature: flapjack-worker
  To be alerted to problems
  A user
  Needs checks executed
  On a regular schedule
  And the results of those checks
  Need to be reported

  @boilerplate
  Scenario: Start a worker
    Given beanstalkd is running
    When I background run "flapjack-worker"
    Then I should see "flapjack-worker" running
    Then I should see "Waiting for check" in the "flapjack-worker" output

  @boilerplate
  Scenario: Start a worker without beanstalk running
    Given beanstalkd is not running
    When I background run "flapjack-worker"
    Then I should see "flapjack-worker" running
    Then I should not see "Shutting down" in the "flapjack-worker" output

  @boilerplate
  Scenario: Beanstalk disappears while worker running
    Given beanstalkd is running
    When I background run "flapjack-worker"
    And beanstalkd is killed
    Then I should see "flapjack-worker" running
    Then I should not see "Shutting down" in the "flapjack-worker" output
    Then I should see "went away" in the "flapjack-worker" output

  @check @execution
  Scenario: Sends results
    Given beanstalkd is running
    When I background run "flapjack-worker"
    Then I should see "flapjack-worker" running
    When I insert a check onto the beanstalk
    Then I should see a job on the "checks" beanstalk queue
    And I should see "Executing check" in the "flapjack-worker" output
    And I should see a job on the "results" beanstalk queue

