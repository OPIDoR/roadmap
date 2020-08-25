module Dmpopidor
  module Controllers
    module TemplateOptions
      # CHANGES : Default template should appear in template lists
      def index
        org_hash = plan_params.fetch(:research_org_id, {})
        funder_hash = plan_params.fetch(:funder_id, {})
        authorize Template.new, :template_options?

        if org_hash.present?
          org = org_from_params(params_in: { org_id: org_hash.to_json })
        end
        if funder_hash.present?
          funder = org_from_params(params_in: { org_id: funder_hash.to_json })
        end

        @templates = []
    
        if (org.present? && !org.new_record?) ||
          (funder.present? && !funder.new_record?)
          if funder.present? && !funder.new_record?
            # Load the funder's template(s) minus the default template (that gets swapped
            # in below if NO other templates are available)
            @templates = Template.latest_customizable
                                 .where(org_id: funder.id)
            if org.present? && !org.new_record?
              # Swap out any organisational cusotmizations of a funder template
              @templates = @templates.map do |tmplt|
                customization = Template.published
                                        .latest_customized_version(tmplt.family_id,
                                                                    org.id).first
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
          if funder.blank? || funder.id == org&.id
            # Retrieve the Org's templates
            @templates << Template.published.where(org_id: org.id).to_a
          end

          @templates = @templates.flatten.uniq
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