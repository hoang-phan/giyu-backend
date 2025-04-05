# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@7.3.0/app/javascript/turbo/index.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js", preload: true
pin "@hotwired/stimulus-loading", to: "https://ga.jspm.io/npm:@hotwired/stimulus-loading@0.2.0/dist/stimulus-loading.js", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js", preload: true
pin "jquery_ujs", to: "https://ga.jspm.io/npm:jquery_ujs@1.2.2/src/rails.js", preload: true
pin "select2", to: "https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.js", preload: true
pin "active_admin", to: "https://ga.jspm.io/npm:activeadmin@4.0.0-beta14/app/assets/javascripts/active_admin/base.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
