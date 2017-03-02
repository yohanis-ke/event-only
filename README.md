
Views and Forms - Assignment
========

Rails Form Helpers
-----

Refactor the below HTML form so that it uses Rails form helpers. Place your work in the `views/example/form.html.erb` file. You can see your form by visiting <http://localhost:3000/example/form>. Assume
that `@job_application` is an empty `JobApplication` object.

For help, see [the docs on form helpers](http://guides.rubyonrails.org/form_helpers.html).

```html
<form class="new_job_application" id="new_job_application" action="/job_applications" accept-charset="UTF-8" method="post">
  <p>
    <label for="job_application_full_name">Full name</label>
    <input type="text" name="job_application[full_name]" id="job_application_full_name" />
  </p>

  <p>
    <label for="job_application_phone">Phone</label>
    <input type="tel" name="job_application[phone]" id="job_application_phone" />
  </p>

  <p>
    <label for="job_application_hobby">Hobby</label>
    <input type="text" name="job_application[hobby]" id="job_application_hobby" />
  </p>

  <p>
    <label for="job_application_years_experience">Years experience</label>
    <input type="number" name="job_application[years_experience]" id="job_application_years_experience" />
  </p>

  <p>
    <label for="job_application_available_date">Available date</label>
    <input type="date" name="job_application[available_date]" id="job_application_available_date" />
  </p>

  <p>
    <input type="submit" name="commit" value="Create Job application" />
  </p>
</form>
```

Building Views and Forms
-----
Let's use this knowledge to build out the views and forms for an application.
Clone this repository, enter the newly-created directory `event-only`, and run:

* `bundle install`
* `rake db:migrate`
* `rake db:seed`

EventOnly is an app for creating and tracking events in different locations across Canada. There are two models:

* Location
* Event

Each of these models has a set of CRUD (Create, Read, Update, Delete) database operations. Your task will be to build the views and forms to make EventOnly a functional application!

### Views - Location

The database already has some locations and events in it since you ran `rake db:seed`. Let's create an index page to view them. Do this by modifying the `views/locations/index.html.erb` file.

```html
<h1>EventOnly</h1>

<% @locations.each do |current_location| %>
  <div class="location">
    <h3>City: <%= current_location.city %></h3>
    <%= current_location.description %><br />
    <%= link_to image_tag(current_location.image, class: "location"), location %>
  </div>
<% end %>
```

Here we're iterating over our locations and displaying some information about each one, including an image.

Now navigate to <http://localhost:3000/locations> to view the locations! Note that clicking an image will take you to an empty page. That's our next step.

Let's create a page that shows off a specific location. Edit the `views/locations/show.html.erb` file as follows:

```html
<h1><%= @location.name %></h1>

<div class="location">
  <h3>City: <%= @location.city %></h3>
  <%= @location.description %><br />
  <%= link_to image_tag(@location.image, class: "location"), @location %>
</div>
```

Clicking an image on the index page should now take you to the show page for a specific location.

You might have noticed that we wrote code that was almost identical in both files (everything inside of the `<div>` tag). This should always be a sign that you should find a way to re-factor your code such that the duplicated code is kept in one place.

The code we duplicated had one job in both places: to display a location. Therefore, let's create a new view: `views/locations/_single_location.html.erb`.

```html
<div class="location">
  <h3>City: <%= location.city %></h3>
  <%= location.description %><br />
  <%= link_to image_tag(location.image, class: "location"), location %>
</div>
```

The entire purpose of this view is to render a piece of a webpage, and to do so potentially many times. For this reason it is called a [partial](http://guides.rubyonrails.org/layouts_and_rendering.html#using-partials) view. We indicate this by having an underscore at the start of the file name (`_single_location.html.erb`).

Also notice that, in our partial, `location` is a local variable, not an instance variable. This is because the partial's job is to render whatever we give it, and we won't always have an instance variable called `@location`.

>You'd be less likely to see a partial named `_single_location.html.erb` in the real world. It would more likely be called `_location.html.erb`. We're doing this for clarity, so stick with it for now.

To see why, look again at our code for `index.html.erb` and notice that, because we are iterating over `@locations`, we are using a local variable called `current_location`. We will now `render` this partial, and pass it whatever location object we have access to - `current_location` in `index.html.erb`, and `@location` in `show.html.erb`.

Let's edit `views/locations/index.html.erb` now:

```html
<h1>EventOnly</h1>

<p>
  <%= link_to 'New Location', new_location_path %>
</p>

<% @locations.each do |current_location| %>
  <%= render 'single_location', location: current_location %>
<% end %>
```

And edit `views/locations/show.html.erb`:

```html
<h1><%= @location.name %></h1>

<%= render 'single_location', location: @location %>
```

Both files are now much shorter because we're using our `_single_location` partial to do the actual work of deciding how a location object should look on our web page. Now we can use this code to render a location anywhere!

Let's take a closer look at the syntax for rendering a partial. `render` is a method that takes arguments. The first argument is the name of the partial we want to render, leaving out the leading underscore. That is:

`<%= render 'single_location' %>` or `<%= render('single_location') %>`

But this code is not sufficient to give the partial the location object that it needs. Check your code in `_single_location.html.erb`: it relies on a variable called `location`, and it doesn't appear to be set anywhere!

We therefore have to pass it a location object, whatever its name happens to be. We are using the name `location` in the partial, so we had better give it the same name when passing it. This is the left-hand side (the key) of the hash we are passing. The right-hand side (the value) is the location object itself. That is, in the `show.html.erb` file:

    <%= render 'single_location', location: @location %>

and in the `index.html.erb` file:

    `<%= render 'single_location', location: current_location %>

Visit both pages again in the browser to make sure that they are still working as before.


### Forms - Location

We can now view all of the Locations that exist in the database, but what about creating new ones? We first need to get to the new page. Add the following code somewhere in the `index.html.erb` file as follows:

```html
<p>
  <%= link_to 'New Location', new_location_path %>
</p>
```

A link should now appear on <http://localhost:3000/locations>, but it should lead to an empty page. We need a form so that we can create new Locations. The back-end has already been written. If we create the form correctly, it should work right away. Note that the server has created an empty `Location` object for us called `@location`. Edit the view called `views/locations/new.html.erb` as follows:

```html
<h1>New Location</h1>

<%= link_to 'Show all locations', locations_path %>

<%= form_for @location do |f| %>
  <p>
    <%= f.label :name %>
    <%= f.text_field :name %>
  </p>

  <p>
    <%= f.label :city %>
    <%= f.text_field :city %>
  </p>

  <p>
    <%= f.label :description %>
    <%= f.text_area :description %>
  </p>

  <p>
    <%= f.label :image %>
    <%= f.text_field :image %>
  </p>

  <p>
    <%= f.submit %>
  </p>

<% end %>
```

The fields `name`, `city`, `description`, and `image` already exist in our database schema (`db/schema.rb`). Reload your `new` page and we should see a working form! Try it out. Make sure you enter a real image URL so we can see it on our other pages.

We now need to create a page to edit existing `Location` objects. We're going to need another form. What fields will the form need? It's actually going to need exactly the same fields that we needed to create a new Location. Because of that, our forms are going to be the same! This should raise an immediate flag in your head - Don't Repeat Yourself (DRY). Because our two forms are going to be identical, let's save the work by putting the form in one place – a partial.

Make a new partial view at `views/locations/_location_form.html.erb`, and move the entire form over to that file, removing the `@` before `location`, ie:

    <%= form_for location do |f| %>

    ...

Now we can shorten our `new.html.erb` view so it looks like this:

```html
<h1>New Location</h1>

<%= link_to 'Show all locations', locations_path %>

<%= render 'location_form', location: @location %>
```

Reload your `new` page and make sure the form still works.

Now we can make the `edit` page quite easily! Let's first add a link to it on the `show` page:

`<%= link_to 'Edit', edit_location_path %>`

Now edit the `edit.html.erb` view:

```html
<h1>Edit <%= link_to @location.name, location_path(@location) %></h1>

<%= render 'form', location: @location %>
```

Try editing the `Location` you made earlier.

We can now Create, Read, and Update `Locations`. We're just missing the D in CRUD: Delete! Add the following delete link to the `show` page as well. It will confirm with the user before sending a `DELETE` request to the server. The view should look something like this:

```html
<h1><%= @location.name %></h1>
<%= link_to 'Edit', edit_location_path(@location) %>
| <%= link_to 'Delete', location_path(@location), method: :delete, data: {confirm: "Are you sure you want to delete the location '#{@location.name}'? This cannot be undone!"} %>

<%= render 'single_location', location: @location %>
```

Reload the show page and try deleting the `Location` you just made. If it works, you've just successfully built the CRUD operations for the `Location` model using partial views.

If you haven't yet committed your work, make sure you do so now!

### Views and Forms - Event

In this application, each `Location` can have many `Events`. The `Event` model already exists; now you have to build the CRUD operations for it, just like we did before. *Read this whole section before getting started* - there is information at the bottom that is quite useful.

To help you get started, let's add a link somewhere in the location `show` page to make a new event, as well as to go to the events page for that `Location`:

```html
<h3><%= link_to 'New Event', new_location_event_path(@location) %></h3>

<h2><%= link_to 'Events', location_events_path(@location) %></h2>
```

In this app, `Event` is a nested resource under `Location`. That means we access events as follows. The below example should, if we create the views correctly, show us all of the `Events` that belong to the `Location` with id 1.

<http://localhost:3000/locations/1/events>

Similar to above, the below example is the URL to create an `Event` that belongs to the 3rd `Location`:

<http://localhost:3000/locations/3/events/new>

Or show a specific event:

<http://localhost:3000/locations/1/events/5>

Or edit a specific event:

<http://localhost:3000/locations/1/events/2/edit>

#### Your tasks:
1. Display all the events that belong to a location.
  * `views/events/index.html.erb`
  * you will have access to the `@events` and `@location` instance variables
1. Create a view to display a specific event.
  * `views/events/show.html.erb`
  * you will have access to the `@event` and `@location` instance variables
1. Create a new event.
  * `views/events/new.html.erb`
  * you will have access to the `@event` and `@location` instance variables
1. Edit an event.
  * `views/events/edit.html.erb`
  * you will have access to the `@event` and `@location` instance variables
1. Delete an event.
  * `views/events/show.html.erb`

Remember that you should be using partial views whenever you have duplicated code!

Because `Event` is nested under `Location`, the form for Events must reflect this nesting as follows:

```html
<!-- we have access to @location throughout our Event views, and we passed in the event object -->
<%= form_for [@location, event] do |f| %>
  <!-- Form fields go here -->
  <!-- Look in the schema.rb file to see the fields in the events table -->
<% end %>
```

This also applies to anywhere we want to link to a nested resource - in this case, an Event. Assuming we have access to variables `location` and `event`:

```html
<%= link_to "Event link text", [location, event] %>
```

## Stretch Assignment

1. Modify the `views/home/index.html.erb` view to display every Location and every Event.
1. Display all the events for a specific location on that location's `show` page.
