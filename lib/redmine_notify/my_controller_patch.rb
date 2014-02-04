module RedmineNotify
  module MyControllerPatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :account, :ext
      end
    end

    module ClassMethods
    end

    module InstanceMethods

      def account_with_ext
        if request.post?
          User.current.pref[:issue_changed] = (params[:issue_changed] == '1')
          User.current.pref[:status_changed] = (params[:status_changed] == '1')
          User.current.pref[:priority_changed] = (params[:priority_changed] == '1')
          User.current.pref[:note_changed] = (params[:note_changed] == '1')

        end
        account_without_ext
      end

    end

  end
end
