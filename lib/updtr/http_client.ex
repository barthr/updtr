defmodule Updtr.HTTPClient do
  use Tesla

  plug Tesla.Middleware.FollowRedirects, max_redirects: 5
end
