module RedmineNotify
  module UsersControllerPatch

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :create, :ext
        alias_method_chain :update, :ext
      end
    end

    module ClassMethods
    end

    module InstanceMethods

      def create_with_ext
        create_without_ext
        unless @user.id.nil?
          
          @user.pref[:issue_changed] = (params[:issue_changed] == '1')
          @user.pref[:status_changed] = (params[:status_changed] == '1')
          @user.pref[:priority_changed] = (params[:priority_changed] == '1')
          @user.pref[:note_changed] = (params[:note_changed] == '1')
          @user.pref.save
        end
      end

      def update_with_ext

         @user.pref[:issue_changed] = (params[:issue_changed] == '1')
          @user.pref[:status_changed] = (params[:status_changed] == '1')
          @user.pref[:priority_changed] = (params[:priority_changed] == '1')
          @user.pref[:note_changed] = (params[:note_changed] == '1')
          @user.pref.save
        update_without_ext
      end

    end

  end
end
