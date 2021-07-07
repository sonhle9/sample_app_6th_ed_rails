if @user && @user.authenticate(params[:session][:password])
  if @user.activated?
    json.user do
      json.id @user.id
      json.name @user.name
      json.admin @user.admin
      json.email @user.email
    end
    json.token
  else
    json.flash ["warning", message]
  end
else
  json.flash ["danger", "Invalid email/password combination"]
end
