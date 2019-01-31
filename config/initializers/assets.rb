# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( jquery.timeago.js )
Rails.application.config.assets.precompile += %w( jquery.jeditable.js )
Rails.application.config.assets.precompile += %w( notification.js )
Rails.application.config.assets.precompile += %w( drawer_script.js )
Rails.application.config.assets.precompile += %w( friends_script.js )
Rails.application.config.assets.precompile += %w( general_script.js )
Rails.application.config.assets.precompile += %w( like_script.js )
Rails.application.config.assets.precompile += %w( delete_script.js )
Rails.application.config.assets.precompile += %w( assign_script.js )
Rails.application.config.assets.precompile += %w( timestamp.js )
Rails.application.config.assets.precompile += %w( channels_script.js )
Rails.application.config.assets.precompile += %w( textarea.js )
Rails.application.config.assets.precompile += %w( posting_channels_script.js )
Rails.application.config.assets.precompile += %w( edit_modal.js )
Rails.application.config.assets.precompile += %w( write_modal.js )
Rails.application.config.assets.precompile += %w( delete_or_edit.js )
Rails.application.config.assets.precompile += %w( channel_dropdown.js )
Rails.application.config.assets.precompile += %w( channel_dropdown.js )
Rails.application.config.assets.precompile += %w( comments_nav.js )
Rails.application.config.assets.precompile += %w( repost_modal.js )
Rails.application.config.assets.precompile += %w( repost_edit_modal.js )
Rails.application.config.assets.precompile += %w( exit_modal.js )
Rails.application.config.assets.precompile += %w( flash_message.js )
Rails.application.config.assets.precompile += %w( show_reactions.js )