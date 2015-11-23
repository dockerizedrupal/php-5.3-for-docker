class run::drush {
  require run::user

  include run::drush::drush5
  include run::drush::drush6
  include run::drush::drush7
}
