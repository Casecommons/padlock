# Padlock

    "...even Nedry knew better than to mess with the raptor fences."

Padlock is a component switch system.

Define which components should be used in certain environments.

Padlock is a fork of Paddock, but uses the term component instead of feature to reduce domain collisions.

## Setup

Put this somewhere like: `config/initializers/padlock.rb`

    include Padlock

    Padlock(Rails.env) do
      enable  :phone_system,  :in => [:development, :test]
      enable  :door_locks,    :in => :development
      enable  :raptor_fences
      disable :cryo_security
      disable :tyranosaur_fences, :in => :production
    end

You name it, we got it.

## Usage

    # Check if component is enabled
    if component(:perimeter_fence)
      # do work
    end

    # Guard a block
    component(:perimeter_fence) do
      # do work
    end

This is a unix system. I know this.

## Testing

This might need some work.

You can define which components are enabled in a test:

    before(:each) do
      Padlock.enable :component_i_am_testing
    end

You think that kind of automation is easy? Or cheap?

## Authors

We're not computer nerds. We prefer to be called "hackers."

* Pat Nakajima
* Brandon Keene

I prefer not to be too closely associated with the aforementioned "hackers."

* Todd Persen

(c) Copyright 2010 Pivotal Labs, see LICENSE
