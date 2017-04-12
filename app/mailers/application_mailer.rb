class ApplicationMailer < ActionMailer::Base
  default from: I18n.t("noreply")
  layout I18n.t("mailer")
end
