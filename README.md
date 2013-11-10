# webwords cookbook

There are a lot of [new examples](http://typesafe.com/activator/templates) up on the Typesafe website, a few with the word "Reactive" in them to drive home the [credo](http://www.reactivemanifesto.org/) behind the framework. One of my favourite examples, however, seem to have been demoted but still remains one of my favourites: [webwords](https://github.com/typesafehub/webwords).

[The old Heroku link](http://webwords.herokuapp.com/) to the live running instance of webwords does not seem to be up anymore, so I whipped up a quick cookbook with which to spin up your own local instance.

# Dependencies

You need the following dependencies:

* [Vagrant](vagrantup.com)
* [Berkshelf](http://berkshelf.com/)
* [Rubygems](http://rubygems.org/)
* [bundler](http://bundler.io/)
* vagrant-berkshelf plugin

# Running

Run the following steps:

    git clone https://github.com/opyate/webwords-vm.git
    cd webwords-vm

    # If you're an RVM user,
    #+ now's a good time to switch to your usual vagrant gemset.
    # If you don't have gems or bundler, install it now
    bundle install
    gem install berkshelf
    # Hook up Vagrant and Berkshelf
    vagrant plugin install vagrant-berkshelf
    vagrant up

...then hit the app at [http://localhost:5000/words?url=opyate.com](http://localhost:5000/words?url=opyate.com) to test it against [my site](http://opyate.com).

# Resources

The [blog post](http://vialstudios.com/guide-authoring-cookbooks.html) I never wrote.

