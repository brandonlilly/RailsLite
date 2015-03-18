$router.draw do
  # get /users/, UsersController, :index
  get /^/users$/, UsersController, :index
  get /^/users/(?<id>\\d+)$/, UsersController, :show
end
