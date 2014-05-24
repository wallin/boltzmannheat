# Boltzmann & heat exchange

## Develop

This project is created with a tool called [middleman](http://middlemanapp.com/)

### Requirements

* [Ruby](https://www.ruby-lang.org/en/downloads/)
* [NodeJS](http://nodejs.org/) and [bower](http://bower.io/)

### Running the development server

First, install the dependencies:
```bash
$ cd /path-to-project
$ bundle install
$ bower install
```

Run the server:
```bash
$ middleman
== The Middleman is loading
== The Middleman is standing watch at http://0.0.0.0:4567
```

Open up your browser and point it to [http://0.0.0.0:4567](http://0.0.0.0:4567)

### Building and deploying

To just build the project:

```bash
$ middleman build
```

To build and deploy the project to [Github pages](https://pages.github.com/):

```bash
$ middleman deploy
```