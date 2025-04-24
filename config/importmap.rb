# Pin npm packages by running ./bin/importmap

pin "application"
pin "rails-ujs", to: "rails-ujs.js"

pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.0/lib/assets/compiled/rails-ujs.js"
