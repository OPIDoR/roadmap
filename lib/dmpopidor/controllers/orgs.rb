module Dmpopidor
  module Controllers
    module Orgs

      # CHANGE: ADDED BANNER TEXT and ACTIVE
      def admin_update
        attrs = org_params
        @org = Org.find(params[:id])
        authorize @org
        @org.logo = attrs[:logo] if attrs[:logo]
        tab = (attrs[:feedback_enabled].present? ? "feedback" : "profile")
        if params[:org_links].present?
          @org.links = JSON.parse(params[:org_links])
        end
    
        @org.banner_text = attrs[:banner_text] if attrs[:banner_text]

        # Only allow super admins to change the org types and shib info
        if current_user.can_super_admin?
          identifiers = []
          attrs[:managed] = attrs[:managed] == "1"

          # Handle Shibboleth identifier if that is enabled
          if Rails.application.config.shibboleth_use_filtered_discovery_service
            shib = IdentifierScheme.by_name("shibboleth").first

            if shib.present? && attrs.fetch(:identifiers_attributes, {}).any?
              entity_id = attrs[:identifiers_attributes].first[1][:value]
              identifier = Identifier.find_or_initialize_by(
                identifiable: @org, identifier_scheme: shib, value: entity_id
              )
              @org = process_identifier_change(org: @org, identifier: identifier)
            end
            attrs.delete(:identifiers_attributes)
          end

          attrs[:managed] = attrs[:managed] == "1"

          # See if the user selected a new Org via the Org Lookup and
          # convert it into an Org
          lookup = org_from_params(params_in: attrs)
          ids = identifiers_from_params(params_in: attrs)
          identifiers += ids.select { |id| id.value.present? }

          # Remove the extraneous Org Selector hidden fields
          attrs = remove_org_selection_params(params_in: attrs)
        end
    
        if @org.update(attrs)

          # Save any identifiers that were found
          if current_user.can_super_admin? && lookup.present?
            # Loop through the identifiers and then replace the existing
            # identifier and save the new one
            identifiers.each do |id|
              @org = process_identifier_change(org: @org, identifier: id)
            end
            @org.save
          end
          
          # if active is false, unpublish all published tempaltes, guidances
          if !@org.active 
            @org.published_templates.update_all(published: false)
            @org.guidance_groups.update_all(published: false)
            @org.update(feedback_enabled: false)
          end

          redirect_to "#{admin_edit_org_path(@org)}\##{tab}",
                      notice: success_message(@org, _("saved"))
        else
          failure = failure_message(@org, _("save")) if failure.blank?
          redirect_to "#{admin_edit_org_path(@org)}\##{tab}", alert: failure
        end
      end


      def org_params
        params.require(:org)
              .permit(:name, :abbreviation, :logo, :contact_email, :contact_name,
                      :remove_logo, :org_type, :managed, :feedback_enabled,
                      :feedback_email_msg, :org_id, :org_name, :org_crosswalk,
                      :banner_text, :active,
                      identifiers_attributes: [:identifier_scheme_id, :value],
                      tracker_attributes: [:code])
      end
    end
  end
end