module RedmineNotify
  module JournalObserverPatch
    def self.included(base)
      base.class_eval do
        alias_method_chain :after_create, :journal
      end
    end


    def after_create_with_journal(journal)
      after_create_without_journal(journal) if journal.notify?
    end
  end
end
