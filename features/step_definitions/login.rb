def logged_in?
  step "the client lists the directory"
  @error.nil?
end

def login(user, password)
  capture_error do
    @client.login user, password
  end
end

Given /^a successful connection( with TLS)?$/ do |with_tls|
  step 'the server is started'
  step "the client connects#{with_tls}"
end

Given /^a successful login( with TLS)?$/ do |with_tls|
  step "a successful connection#{with_tls}"
  step 'the client logs in'
end

Given /^a failed login$/ do
  step 'the server is started'
  step 'the client connects'
  step 'the client logs in with a bad password'
end

When /^the client logs in$/ do
  login @server.user, @server.password
end

When /^the client logs in with a bad password$/ do
  login @server.user, 'the-wrong-password'
end

When /^the client logs in with a bad user$/ do
  login 'the-wrong-user', @server.password
end

Then /^the client should( not)? be logged in$/ do |neg|
  matcher_method = if neg
                     :be_false
                   else
                     :be_true
                   end
  logged_in?.should send(matcher_method)
end

When /^the client sends a password( with no parameter)?$/ do |no_param|
  capture_error do
    args = if no_param
             []
           else
             [@server.password]
           end
    @client.raw 'PASS', *args
  end
end

When /^the client sends a user( with no parameter)?$/ do |no_param|
  capture_error do
    args = if no_param
             []
           else
             [@server.user]
           end
    @client.raw 'USER', *args
  end
end
