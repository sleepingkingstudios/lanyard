# frozen_string_literal: true

# Event class for recording a contact or discussion.
class RoleEvents::ContactedEvent < RoleEvent
  # (see RoleEvent#default_summary)
  def default_summary
    'Contacted by recruiter or agent'
  end
end
