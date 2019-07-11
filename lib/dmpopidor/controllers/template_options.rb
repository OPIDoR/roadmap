module Dmpopidor
  module Controllers
    module TemplateOptions
      # CHANGES : Default template should appear in template lists
      def index
        org_id = (plan_params[:org_id] == "-1" ? "" : plan_params[:org_id])
        funder_id = (plan_params[:funder_id] == "-1" ? "" : plan_params[:funder_id])
        authorize Template.new, :template_options?
        @templates = []
    
        if org_id.present? || funder_id.present?
          unless funder_id.blank?
            # Load the funder's template(s) minus the default template (that gets swapped
            # in below if NO other templates are available)
            @templates = Template.latest_customizable
                                 .where(org_id: funder_id)
            unless org_id.blank?
              # Swap out any organisational cusotmizations of a funder template
              @templates = @templates.map do |tmplt|
                customization = Template.published
                                        .latest_customized_version(tmplt.family_id,
                                                                   org_id).first
                # Only provide the customized version if its still up to date with the
                # funder template!
                if customization.present? && !customization.upgrade_customization?
                  customization
                else
                  tmplt
                end
              end
            end
          end
    
          # If the no funder was specified OR the funder matches the org
          if funder_id.blank? || funder_id == org_id
            # Retrieve the Org's templates
            @templates << Template.published
                                  .organisationally_visible
                                  .where(org_id: org_id).to_a
          end

          @templates = @templates.flatten.uniq
        end
    
        # If no templates were available use the default template
        if @templates.empty?
          if Template.default.present?
            customization = Template.published
                              .latest_customized_version(Template.default.family_id,
                                                         org_id).first
    
            @templates << (customization.present? ? customization : Template.default)
          end
        end

        @templates.each do |template|
          if !template.customization_of.nil?
            template.title += " (#{d_('dmpopidor', 'Customized by ')} #{template.org.name})"
          end
        end

        @templates = @templates.sort_by(&:title)
        
      end
    end
  end
end