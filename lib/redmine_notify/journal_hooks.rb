module RedmineNotify
  class JournalHooks < Redmine::Hook::Listener
    def controller_jour_edit_before_save(context)

#    private

 #   def update_journal_notify(params, journal)
  #    if journal && params && params[:suppress_mail] == '1'
   #     if User.current.allowed_to?(:suppress_mail_notifications,
    #                                journal.project)
     #     journal.notify = false
      #  else
      #    # what?
      #  end
     # end
    #end
  end
end
