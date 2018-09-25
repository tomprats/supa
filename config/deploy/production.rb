server "shared.tomify.me", user: "deploy", roles: [:app, :db, :web], primary: true
after "deploy:restart", "deploy:cleanup"
