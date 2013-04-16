class UserMailer < ActionMailer::Base
  puts 'kurwa'
  include MailFriday
  default from: "from@example.com"

  def welcome(username, sth, opts = {})
    @username = username
    to = "~#{username} <#{username}@we.com>"
    subject = %(Welcome to #{sth})
    mail :to => to, :subject => subject
  end
end
