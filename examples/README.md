## Examples

The main README shows a few details about the resources in this cookbook, but mainly includes code to demonstrate the properties you can set on a resource.
As such, many of those code "examples" are incomplete or contain much more than you'd want to use.
This directory contains example recipes to show real, working code and detailed comments about how the resources work, why you'd want to use certain properties, and how to tie some of the resources together.

## Getting started

This section will help you get started using the iLO cookbook, and in doing so, explain some key concepts pertaining to Chef.

#### A quick intro of Chef

Chef is a configuration management tool that uses a declarative syntax. It is different than scripting in a few ways, but mainly:

 - You define what the environment should look like, not how to do it. This removes a lot of complexity, and simplifies your configuration code.
 - Chef code lives primarily in recipes. 1 or more recipes are packages into a cookbook that has a single concern. Cookbooks are versioned and checked into source control, unlike many scripts.
 - Chef integrates with a whole host of tools that make testing easy and meaningful. ChefSpec, InSpec, and Test Kitchen are some of these tools. Just like your applications, you can test and release your configuration code using automated pipelines.

Some common reasons you'd want (or need) to use a configuration management tool like Chef are to have success at scale, increase consistency, and gain visibility into your environment.

#### Developing with Chef and iLO

If you're new to Chef, I'd encourage you to go through some of the tutorials and self-paced trainings at [learn.chef.io](https://learn.chef.io) before going any further.

About the only thing you'll need to get started developing is some basic terminal knowledge and the [ChefDK](https://downloads.chef.io/chef-dk/) installed. This will give you Ruby, as well as tools such as Berkshelf, Test Kitchen, ChefSpec, Foodcritic, and Rubocop. For this guide, we'll use a Bash terminal; if you're on Windows, you may have to modify some of the system commands accordingly.

1. To get started, we'll create a new directory named "chef-repo"; this is where we'll put our new cookbooks. Also in this directory, lives the `.chef/knife.rb` configuration file used to connect to a Chef server.

  ```bash
  $ mkdir chef-repo
  $ cd chef-repo
  ```

2. We'll create a directory within our chef-repo named cookbooks, where our cookbooks will live:

  ```bash
  $ mkdir cookbooks
  $ cd cookbooks
  ```

3. Now we can use the chef command to generate a new cookbook named 'my-ilo':
  ```bash
  $ chef generate cookbook my_ilo
  $ cd my_ilo
  ```

  a. If you examine what was created (`$ ls -lah`), you'll notice a few files, notably `metadata.rb` and `recipes/default.rb`

4. At this point, read the main README of this repo. Much of what comes next is already described there, and we will not repeat everything here.

5. The first thing we need to do is specify a dependency on the ilo cookbook. We do this by adding the following to our metadata.rb file:

  ```ruby
  depends 'ilo'
  ```

  a. :pushpin: **Tip:** Check out the [Chef docs](https://docs.chef.io/config_rb_metadata.html) to see what all else you can put in this metadata.rb file.

6. Now we can edit our first recipe and add some configuration. Open up `recipes/default.rb` and add:

  ```ruby
  # Replace these credentials with those of your iLO(s)
  my_ilos = [
    { host: 'ilo1.example.com', user: 'Admin', password: 'secret123', ssl_enabled: false },
    { host: 'ilo2.example.com', user: 'Admin', password: 'secret456', ssl_enabled: false }
  ]

  ilo_user 'bob' do
    ilos my_ilos
    password 'password123'
    login_priv true
  end
  ```

  a. There's a few things I want to note here. The first thing is that the `my_ilos` object is just a Ruby array containing 2 Ruby hashes. These hashes contain the necessary data for connecting to the 2 iLOs we want to manage. We put this information in clear text here, but you'll definitely want to make some changes in production code, so you're not checking passwords into a repo in clear text. You can build this array by reading in a file, fetching an encrypted databag, etc. Also, instead of setting ssl_enabled to false, you should import the server's certs onto your machine.

  b. The second thing I want to note is the ilo_users resource. Here we're just defining a user named bob, associating him with both of the ilos in our `my_ilos` array, and setting his password to `password123`. When run, this will create this user and set his password. You can run the recipe over and over, and it will continue to check if bob exists and set his password to what you've defined.

7. Now let's run our recipe and see what happens:

  ```bash
  $ chef-client -z -o my_ilo::default
  ```

  a. You'll see an error saying it can't find the correct cookbook. This is because we haven't told Chef where to find our cookbooks, and we haven't downloaded our cookbook dependencies (ilo and compat_resource). Fix this by creating a knife.rb file at `chef-repo/.chef/knife.rb` and adding:

    ```ruby
    # See http://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

    current_dir = File.dirname(__FILE__)
    cookbook_path            ["#{current_dir}/../cookbooks"]

    # If you're behind a proxy, you'll need to set the http_proxy environment variable or set the http_proxy option here
    ```

  b. And download the ilo and compat_resource cookbooks by running:

    ```bash
    $ cd ..
    # (Now we're in chef-repo/cookbooks)

    $ knife cookbook site download ilo

    # Now we need to untar the download:
    $ tar -xvf ilo-*.tar.gz
    # Now the ilo cookbook lives at chef-repo/cookbooks/ilo

    # You can remove the tar file if you'd like; we no longer need it
    $ rm ilo-*.tar.gz

    # Do the same for the compat_resource cookbook:
    $ knife cookbook site download compat_resource
    $ tar -xvf compat_resource-*.tar.gz
    $ rm compat_resource-*.tar.gz
    ```

8. Now re-run `$ chef-client -z -o my_ilo::default`. This time it should succeed, and if you log into your iLOs, you'll see the user 'bob'.

That's it! You can re-run the recipe as many times as you'd like, adding or changing properties, and it will ensure what you set in the recipe is reflected on the iLO.
You can update the password, add permissions, or create additional resources.

Now that you've gotten your feet wet, please take another look at the main README to see the complete list of resources available to you, as well as the recipes in this directory for examples of how to use them.
