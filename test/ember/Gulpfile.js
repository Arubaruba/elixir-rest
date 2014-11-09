var gulp = require('gulp'),
  concat = require('gulp-concat'),
  declare = require('gulp-declare'),
  handlebars = require('gulp-handlebars'),
  livereload = require('gulp-livereload'),
  order = require('gulp-order'),
  sass = require('gulp-sass'),
  uglify = require('gulp-uglify'),
  watch = require('gulp-watch'),
  wrap = require('gulp-wrap'),

  eventStream = require('event-stream'),
  emberHandlebars = require('ember-handlebars'),
  packageName = require('./package.json')['name'];

var buildPaths = {
  development: '.tmp',
  production: 'dist'
};

var sources = {
  localScripts: [
    'app/app.js',
    'app/**/*.js'
  ],
  dependencies: [
    'bower_components/jquery/dist/jquery.min.js',
    'bower_components/handlebars/handlebars.runtime.min.js',
    'bower_components/ember/ember.min.js',
    'bower_components/ember-data/ember-data.min.js'
  ],
  templates: 'app/views/**/*.hbs',
  sass: 'app/styles/**/*.s*ss'
};

var pipes = {
  localScripts: function () {
    return gulp.src(sources.localScripts)
      .pipe(uglify())
      .pipe(concat('local-scripts.js'));
  },
  dependencies: function () {
    return gulp.src(sources.dependencies)
      .pipe(concat('dependencies.js'));
  },
  templates: function () {
    return gulp.src(sources.templates)
      .pipe(handlebars({
        handlebars: emberHandlebars
      }))
      .pipe(wrap('Ember.Handlebars.template(<%= contents %>)'))
      .pipe(declare({
        namespace: 'Ember.TEMPLATES',
        noRedeclare: true
      }))
      .pipe(uglify())
      .pipe(concat('templates.js'));
  },
  sass: function () {
    return gulp.src(sources.sass)
      .pipe(sass())
      .pipe(concat('stylesheets.css'));
  }
};

gulp.task('development', function () {
  eventStream.merge(
    pipes.dependencies(),
    pipes.localScripts(),
    pipes.templates(),
    pipes.sass()
  ).pipe(gulp.dest(buildPaths.development));

  livereload.listen();

  watch(sources.localScripts, function () {
    pipes.localScripts()
      .pipe(gulp.dest(buildPaths.development));
  }).pipe(livereload());

  watch(sources.templates, function () {
    pipes.templates()
      .pipe(gulp.dest(buildPaths.development));
  }).pipe(livereload());

  watch(sources.sass, function () {
    pipes.sass()
      .pipe(gulp.dest(buildPaths.development));
  }).pipe(livereload());
});

gulp.task('production', function () {
  eventStream.merge(
    pipes.dependencies(),
    pipes.templates(),
    pipes.localScripts()
  )
    .pipe(order(['*dependencies*', '*templates*', '*local-scripts*']))
    .pipe(concat(packageName + '.min.js'))
    .pipe(gulp.dest(buildPaths.production));

  pipes.sass().concat(packageName + '.css').pipe(gulp.dest(buildPaths.production));
});