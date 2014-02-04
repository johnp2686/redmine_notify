module RedmineNotify
  module JournalPatch

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


  
def notify?
    @notify != false
  end

  def notify=(arg)
    @notify = arg
  end


def recipients_ext
       notified = []
      notified = journalized.notified_users
   if private_notes?
       notified = notified.select {|user| user.allowed_to?(:view_private_notes, journalized.project)}
   end

    notified.each do |re|

 if !(re.pref[:issue_changed].present?) 
      re.pref[:issue_changed]=false
      re.pref[:status_changed]=true
      re.pref[:priority_changed]=true
      re.pref[:note_changed]=true
      re.pref.save
  end

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
 
         notified = journalized.notified_watchers
    if private_notes?
         notified = notified.select {|user| user.allowed_to?(:view_private_notes, journalized.project)}
    end

          new_notified=[]
     notified.each do |re|

     if !(re.pref[:issue_changed].present?) 
           re.pref[:issue_changed]=false
           re.pref[:status_changed]=true
           re.pref[:priority_changed]=true
           re.pref[:note_changed]=true
           re.pref.save
      end

   if (re.pref[:issue_changed] ||
      (new_status.present? && re.pref[:status_changed]) || 
       (new_value_for('priority_id').present? && re.pref[:priority_changed]) ||
       (notes.present? && re.pref[:note_changed]))     
   
           new_notified.push(re)

      end
  end
      new_notified.map(&:mail)
 
   end
  end
end
end
