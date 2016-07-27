angular.module 'jquest'
  .config ($stateProvider) ->
    $stateProvider
      .state 'main',
        templateUrl: 'main/main.html'
        controller: 'MainCtrl'
        controllerAs: 'main'
        url: '/'
        resolve:
          seasons: (Seasons)->
            'ngInject'
            Seasons.ready()
          seasonRestangular: (seasonRestangular)->
            'ngInject'
            seasonRestangular.ready()
