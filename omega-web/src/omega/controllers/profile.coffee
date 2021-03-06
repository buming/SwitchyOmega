angular.module('omega').controller 'ProfileCtrl', ($scope, $stateParams,
  $location, $rootScope, $modal, $state, profileColorPalette) ->
  name = $stateParams.name
  profileTemplates =
    'FixedProfile': 'profile_fixed.html'
    'PacProfile': 'profile_pac.html'
    'SwitchProfile': 'profile_switch.html'
    'RuleListProfile': 'profile_rule_list.html'
  $scope.spectrumOptions =
    localStorageKey: 'spectrum.profileColor'
    palette: profileColorPalette
    preferredFormat: 'hex'
    showButtons: false
    showInitial: true
    showInput: true
    showPalette: true
    showSelectionPalette: true

  $scope.deleteProfile = ->
    profileName = $scope.profile.name
    refs = OmegaPac.Profiles.referencedBySet(profileName, $rootScope.options)
    refs = Object.keys(refs)

    scope = $rootScope.$new('isolate')
    scope.profile = $scope.profile
    scope.profileIcons = $scope.profileIcons

    if refs.length > 0
      scope.refs = refs.map (p) -> OmegaPac.Profiles.byKey(p,
        $rootScope.options)
      $modal.open(
        templateUrl: 'partials/cannot_delete_profile.html'
        scope: scope
      )
    else
      $modal.open(
        templateUrl: 'partials/delete_profile.html'
        scope: scope
      ).result.then ->
        delete $rootScope.options[OmegaPac.Profiles.nameAsKey(profileName)]
        if $rootScope.options['-startupProfileName'] == profileName
          $rootScope.options['-startupProfileName'] = ""
        quickSwitch = $rootScope.options['-quickSwitchProfiles']
        for i in [0...quickSwitch.length]
          if profileName == quickSwitch[i]
            quickSwitch.splice i, 1
            break
        $state.go('ui')

  unwatch = $scope.$watch (-> $scope.options?['+' + name]), (profile) ->
    if not profile
      if $scope.options
        unwatch()
        $location.path '/'
      else
        unwatch2 = $scope.$watch 'options', ->
          if $scope.options
            unwatch2()
            if not $scope.options['+' + name]
              unwatch()
              $location.path '/'
      return
    if OmegaPac.Profiles.formatByType[profile.profileType]
      profile.format = OmegaPac.Profiles.formatByType[profile.profileType]
      profile.profileType = 'RuleListProfile'
    $scope.profile = profile
    type = $scope.profile.profileType
    templ = profileTemplates[type] ? 'profile_unsupported.html'
    $scope.profileTemplate = 'partials/' + templ
    $scope.scriptable = true

    onProfileChange = (profile, oldProfile) ->
      return profile if profile == oldProfile
      OmegaPac.Profiles.updateRevision(profile)
      return profile

    $scope.omegaWatchAndChange 'profile', onProfileChange, true
