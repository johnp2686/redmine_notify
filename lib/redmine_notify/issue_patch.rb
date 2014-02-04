module RedmineNotify
  module IssuePatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method :recipients, :recipients_ext
        alias_method :watcher_recipients, :watcher_recipients_ext
      end
    end

    module ClassMethods
    end

    module InstanceMethods

      def recipients_ext

        notified = []
    # Author and assignee are always notified unless they have been
    # locked or don't want to be notified
    notified << author if author
    if assigned_to
      notified += (assigned_to.is_a?(Group) ? assigned_to.users : [assigned_to])
    end
    if assigned_to_was
      notified += (assigned_to_was.is_a?(Group) ? assigned_to_was.users : [assigned_to_was])
    end
    notified = notified.select {|u| u.active? && u.notify_about?(self)}

    notified += project.notified_users
    notified.uniq!
    # Remove users that can not view the issue
    notified.reject! {|user| !visible?(user)}
    notified

 notified.each do |re|

      if !(re.pref[:issue_changed] ||
         (new_status.present? && re.pref[:status_changed]) || 
            (new_value_for('priority_id').present? && re.pref[:priority_changed]) ||
             (notes.present? && re.pref[:note_changed]))    
           
            notified.delete(re)
       end
      end
    notified.map(&:mail)
      end

      def watcher_recipients_ext
        notified = watcher_users.active
        notified.reject! { |user| user.mail_notification == 'none' || allow_notify_closed?(user) === true }

        if respond_to?(:visible?)
          notified.reject! { |user| !visible?(user) }
        end
        notified.collect(&:mail).compact
      end

      private


      def allow_notify_closed?(user)
       (user.pref[:issue_changed] && @status.is_closed?) ? false : true
        (user.pref[:status_changed] && @status.is_closed?) ? false : true
        (user.pref[:prioruy_changed] && @status.is_closed?) ? false : true
        (user.pref[:issue_changed] && @status.is_closed?) ? false : true
    end
end
  end
end
