require 'redmine'

Redmine::Plugin.register :redmine_notify do
name 'Redmine Notice plugin'
  author 'John Paul '
  description 'This plugin allows you to disable the notification of the issue changes'
  version '2.2.x'

  
end

prepare_block = Proc.new do
  Journal.send(:include, RedmineNotify::JournalPatch)
  JournalObserver.send(:include, RedmineNotify::JournalObserverPatch)

MyController.send(:include, RedmineNotify::MyControllerPatch)
  UsersController.send(:include, RedmineNotify::UsersControllerPatch)
  #Issue.send(:include, RedmineNotify::IssuePatch)
  #Journal.send(:include, RedmineNotify::JournalPatch)
end



if Rails.env.development?
 ActionDispatch::Reloader.to_prepare { prepare_block.call }
else
  prepare_block.call
end

require 'redmine_notify/my_controller_patch'
require 'redmine_notify/users_controller_patch'
require 'redmine_notify/journal_patch'
require 'redmine_notify/journal_observer_patch'
require 'redmine_notify/view_hooks'






