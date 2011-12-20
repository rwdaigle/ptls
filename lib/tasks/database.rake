namespace :db do
  task :reload => ['db:drop', 'db:create', 'db:migrate', 'db:test:prepare']
end