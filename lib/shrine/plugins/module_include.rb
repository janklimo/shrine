# frozen_string_literal: true

class Shrine
  module Plugins
    # The `module_include` plugin allows you to extend Shrine's core classes for
    # the given uploader with modules/methods.
    #
    #     plugin :module_include
    #
    # To add a module to a core class, call the appropriate method:
    #
    #     attachment_module CustomAttachmentMethods
    #     attacher_module CustomAttacherMethods
    #     file_module CustomFileMethods
    #
    # Alternatively you can pass in a block (which internally creates a module):
    #
    #     attachment_module do
    #       def included(model)
    #         super
    #
    #         name = attachment_name
    #
    #         define_method :"#{name}_size" do |version|
    #           attachment = send(name)
    #           if attachment.is_a?(Hash)
    #             attachment[version].size
    #           elsif attachment
    #             attachment.size
    #           end
    #         end
    #       end
    #     end
    #
    # The above defines an additional `#<attachment>_size` method on the
    # attachment module, which is what is included in your model.
    module ModuleInclude
      module ClassMethods
        def attachment_module(mod = nil, &block)
          module_include(self::Attachment, mod, &block)
        end

        def attacher_module(mod = nil, &block)
          module_include(self::Attacher, mod, &block)
        end

        def file_module(mod = nil, &block)
          module_include(self::UploadedFile, mod, &block)
        end

        private

        def module_include(klass, mod, &block)
          mod ||= Module.new(&block)
          klass.include(mod)
        end
      end
    end

    register_plugin(:module_include, ModuleInclude)
  end
end
