#= require_self
#= require angular-rails-templates
#= require_tree .

angular.module 'jquest', [
  'ngAnimate',
  'ngCookies',
  'ngTouch',
  'ngSanitize',
  'ngAria',
  'restangular',
  'ui.router',
  'ui.bootstrap',
  'pascalprecht.translate',
  'jquest.template'
]
