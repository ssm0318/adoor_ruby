config.verify_access_proc = proc { |controller| controller.current_user.has_role? :admin }
