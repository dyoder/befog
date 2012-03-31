Befog is a load testing framework. A given load test consists of four components:

* Scenarios, which implement a specific type of test
* Pods, which run scenarios and report back results
* Overlords, which provide instructions to remote Pods
* Dashboards, which track and report the results  

## Configuring Your Account

Befog uses spire.io to coordinate load tests. If you don't already have an account key, you can simply run:

    befog register --email <email> --password <password>
    
This will create a new account for you and place the key in your .spirerc file. Other befog commands will use this key to send messages.

You should also add your Amazon Web Services key if you want to use the automated pod deployment process.

    befog configure --aws-key <key>

## Creating a Scenario

You write scenarios in CoffeeScript

    Scenario = require("befog/scenario")
    myScenario = new Scenario (context) ->
      // do some setup
      context.ready (context) ->
        context.start()
        // run your test
        context.finish()

You can return an error result with `context.halt`, passing the error message.

Add a package.json, put it up on github, and you've got a scenario.

## Pods

Scenarios run within pods. The first thing you need to do is to ... 

*DEPLOY THE PODS!*

This is very simple:

    befog pod add --group myPods --number 10
    
This will create 10 "pods" - virtual machines - that will run your scenario. You can refer to them using the group `myPods`.

You can add and remove pods and even deploy them by region. For the moment, let's focus on running a scenario.

If you don't want befog to provision your machines for you, you can simply push the befog pod code instead. (You'll need to add your `ssh` key to your befog configuration first.)

Now you can deploy your scenario to the pods. We specify the group as before with `--group` and a label as well, so we can refer to it later.

    befog pod deploy --scenario http://github.com/your/repo.git 
      --label test --group myPods

Finally, we're ready to run our test.

## Overlords

The dolpin overlord will actually orchestrate the load test.

    befog overlord -g myPods -s test -i 5 -m 20 -r 3 -d 'testing 1-2-3'
    
This will tell the `myPods` group to run the `test` scenario up to 20 concurrent connections, incrementing by 5 each time (so 5,10,15,20); we'll repeat the test 3 times; and label the results using `testing 1-2-3`.

We can also send custom parameters that will passed into your scenario in the context. For example, you could pass in a `host` parameter like this:

    befog overlord -g myPods -s test -i 5 -m 20 -r 3 
      -d 'testing 1-2-3' -p host=http://big.foo.org/

That would be accessible within the scenario as `context.parameters.host`.

## Dashboards

Now that you have a scenario running, you'll want to check the results. Anyone can quickly run a local Web server that will act as a dashboard.

    befog dashboard -p 3210
    
If you navigate your browser to:
  
    http://localhost:3210/last?group=myPods
    
you'll see a Web page that will display a nice set of charts for the most recent test run, including a bar graph of latency by concurrency level and geographic location, a similar chart for error rates and standard deviations, and a pie chart for any errors that were returned.

You can also navigate to:

    http://localhost:3210/?group=myPods

to get a list of available test results. You can limit the results using the `limit` parameter.