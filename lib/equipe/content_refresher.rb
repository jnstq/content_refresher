module Equipe
  module ContentRefresher

    def self.included(controller)
      controller.extend(ClassMethods)
      controller.send(:include, InstanceMethods)
      controller.after_filter :add_javascript_for_refresher
    end

    module ClassMethods
      def refresh(action_name, options = {})
        options.reverse_merge! :every => 30, :error_tag_id => 'lost_connection_to_server'
        options[:every] *= 1000
        write_inheritable_array(:content_refresher, [{action_name.to_sym => options}])
      end
    end

    module InstanceMethods
      
      def changed
        refresh_object = model_class.find(params[:id], :select => 'id, updated_at')
        respond_to do |format|
          format.js { render :json => {:id => refresh_object.id, :updated_at => refresh_object.updated_at}}
        end
      end
      
      def options_for_refresher(name = action_name)
        key = name.to_sym
        options = self.class.read_inheritable_attribute(:content_refresher)
        options = options.find{|opt| opt.has_key?(key) } if options
        options = options[key]  if options
        options = default_options_for_refresher(key).merge(options) if options
        options.inject({}) do |r, (k, v)|
          if v.respond_to?(:call)
            r[k] = instance_eval(&v)
          else
            r[k] = v
          end
          r
        end if options
      end

      def default_options_for_refresher(action_name)        
        {
          :id => model_object_variable.id,
          :updated_at => model_object_variable.updated_at,
          :pull_path => url_for(:action => 'changed', :id => model_object_variable.id, :format => 'js'),
          :refresh_path => url_for(:action => action_name, :id => model_object_variable.id, :format => 'js'),
          :check => true,
        }
      end
      
      def model_object_variable_name
        "@#{controller_name.singularize}"
      end
      
      def model_object_variable
        instance_variable_get(model_object_variable_name)
      end
      
      def model_class
        "#{controller_name.singularize.classify}".constantize
      end
      
      protected
      
      def add_javascript_for_refresher
        options = options_for_refresher
        if options
          response.body.sub!("</body>", %{
            <script type="text/javascript">
            //<![CDATA[
              var checkContentRefresherOptions = #{options.to_json};
              #{options[:check] ? 'checkContentLoop' : 'reloadContentLoop'}();
            //]]>
            </script>
          </body>})
        end
      end
    end
  end
end
