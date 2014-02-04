module RedmineNotify
  class ViewHooks < Redmine::Hook::ViewListener
    render_on :view_my_account,
      :partial => 'hooks/notfiy_mail'

    render_on :view_users_form,
      :partial => 'hooks/notfiy_mail'
  end
end
