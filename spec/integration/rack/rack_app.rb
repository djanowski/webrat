require "rubygems"
require "sinatra/base"

class RackApp < Sinatra::Default
  get "/" do
    "Hello World"
  end

  get "/redirect_absolute_url" do
    redirect URI.join(request.url, "foo").to_s
  end

  get "/foo" do
    "spam"
  end

  get "/go" do
    return <<-EOS
    <form action="/go" method="post">
      <input type="text" name="Name" />
      <input type="text" name="Email" />
      <input type="submit" value="Submit" />
    </form>
    EOS
  end

  post "/go" do
    return <<-EOS
    Hello, #{params[:Name]}
    Your email is: #{params[:Email]}
    EOS
  end
end
