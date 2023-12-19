Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "user/create", to: "users#create_user"

  put "user/update", to: "users#update_user"

  delete "user/delete", to: "users#delete_user"

end
